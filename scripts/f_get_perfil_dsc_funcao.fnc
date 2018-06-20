CREATE OR REPLACE FUNCTION REQPES.F_GET_PERFIL_DSC_FUNCAO(P_REQUISICAO_SQ IN REQUISICAO.REQUISICAO_SQ%TYPE)
  RETURN VARCHAR2 IS
  /** Retorna uma lista com as descrições dos perfis associados a uma determinada RP **/

  V_RETORNO VARCHAR2(4000) := '';
BEGIN
  FOR F IN (SELECT RF.NOME AS NOME
            FROM   (SELECT R.COD_FUNCAO
                    FROM   REQUISICAO_PERFIL_FUNCAO R
                    WHERE  R.REQUISICAO_SQ = P_REQUISICAO_SQ
                    -----
                    UNION
                    -----
                    SELECT P.COD_FUNCAO
                    FROM   REQUISICAO_PERFIL P
                    WHERE  P.REQUISICAO_SQ = P_REQUISICAO_SQ) RP
                  ,RECRU.RECRU_FUNCAO RF
            WHERE  RP.COD_FUNCAO = RF.ID_FUNCAO
            ORDER  BY RF.NOME) LOOP

    V_RETORNO := V_RETORNO || ', ' || F.NOME;

  END LOOP;

  RETURN TRIM(SUBSTR(V_RETORNO, 2, LENGTH(V_RETORNO)));

END F_GET_PERFIL_DSC_FUNCAO;
/
grant execute, debug on REQPES.F_GET_PERFIL_DSC_FUNCAO to AN$RHEV;


