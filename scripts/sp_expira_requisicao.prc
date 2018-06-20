CREATE OR REPLACE PROCEDURE REQPES.SP_EXPIRA_REQUISICAO IS

  V_EXISTE CHAR := 'N';
  V_PRAZO  NUMBER;

BEGIN

-------------------------------------------------------------------------------------
-- PROCEDURE RESPONSAVEL POR EXPIRAR AS REQUISI합ES APOS 6 MESES DA DATA DE APROVA플O
-- Processo executado todos os dias as 05:00hs AM, atraves do job 885
-- Author: Thiago Lima Coutinho
-- Date  : 3/7/2009
-------------------------------------------------------------------------------------

  -------------------------------------------------------
  -- CARREGANDO O PRAZO DE VALIDADE DA RP
  -------------------------------------------------------
  SELECT S.VLR_SISTEMA_PARAMETRO
  INTO   V_PRAZO
  FROM   SYN_SISTEMA_PARAMETRO S
  WHERE  S.COD_SISTEMA   = 7
  AND    S.NOM_PARAMETRO = 'CONTRATACAO_VALIDADE';

  -------------------------------------------------------
  FOR EXPIRANDO IN ( -- CURSOR DE REQUISI합ES EM EXPIRA플O
                     SELECT UNIQUE R.REQUISICAO_SQ
                           ,R.COD_STATUS
                     FROM   REQUISICAO           R
                           ,HISTORICO_REQUISICAO HR
                     WHERE  HR.REQUISICAO_SQ = R.REQUISICAO_SQ
                     AND    R.COD_STATUS IN (1, 2, 3, 4) -- STATUS: ABERTA, EM HOMOLOGA플O, EM REVIS홒, APROVADA
                     AND    SYSDATE > (SELECT MAX(E.DT_ENVIO)
                                       FROM   HISTORICO_REQUISICAO E
                                       WHERE  E.REQUISICAO_SQ = HR.REQUISICAO_SQ) + V_PRAZO
                    ) LOOP
        -----------------------------------------------------
        V_EXISTE := 'S';
        -----------------------------------------------------
        -- ATUALIZANDO A REQUISI플O
        -----------------------------------------------------
         UPDATE REQUISICAO R
         SET    R.COD_STATUS    = 8 -- STATUS: EXPIRADA
         WHERE  R.REQUISICAO_SQ = EXPIRANDO.REQUISICAO_SQ;

        -----------------------------------------------------
        -- ATUALIZANDO O HISTORICO
        -----------------------------------------------------
         INSERT INTO HISTORICO_REQUISICAO
           (REQUISICAO_SQ
           ,DT_ENVIO
           ,STATUS)
         VALUES
           (EXPIRANDO.REQUISICAO_SQ
           ,SYSDATE
           ,'expirada');
  END LOOP;
  -------------------------------
  IF(V_EXISTE = 'S')THEN
    COMMIT;
  END IF;
  -------------------------------
  EXCEPTION
   WHEN OTHERS THEN
     ROLLBACK;
  -------------------------------
END SP_EXPIRA_REQUISICAO;
/
grant execute, debug on REQPES.SP_EXPIRA_REQUISICAO to AN$RHEV;


