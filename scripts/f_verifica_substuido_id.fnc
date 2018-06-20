CREATE OR REPLACE FUNCTION REQPES.F_VERIFICA_SUBSTUIDO_ID (P_IN_CHAPA NUMBER) RETURN VARCHAR2 IS

  V_QTD     NUMBER;
  V_RETORNO VARCHAR2(200);

BEGIN
  ------------------------------------------------------------------------------
  -- VERIFICA SE EXISTEM RP's COM O MESMO ID DO FUNCIONARIO SUBSTITUIDO
  ------------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO   V_QTD
    FROM   REQUISICAO R
    WHERE  R.MOTIVO_SOLICITACAO  IN (2,3)       -- RP's para Substituições
    AND    R.COD_STATUS          NOT IN (5,7,8) -- Reprovada, Cancelada e Expirada
    AND    R.SUBSTITUIDO_ID_HIST = P_IN_CHAPA;  -- Funcionario substituido

  ------------------------------------------------------------------------------
  -- MONTA O RETORNO DA FUNÇÃO
  ------------------------------------------------------------------------------
    IF (V_QTD > 0) THEN
      FOR CUR IN ( -- Cursor com RP's utilizando o mesmo ID
                   SELECT REQUISICAO_SQ
                   FROM   REQUISICAO R
                   WHERE  R.MOTIVO_SOLICITACAO  IN (2,3)
                   AND    R.COD_STATUS          NOT IN (5,7,8)
                   AND    R.SUBSTITUIDO_ID_HIST = P_IN_CHAPA
                 ) LOOP
         V_RETORNO := V_RETORNO || CUR.REQUISICAO_SQ ||', ';
      END LOOP;
      -- Retornando os numeros das RP's
      V_RETORNO := SUBSTR(V_RETORNO,0,LENGTH(V_RETORNO) -2);
    ELSE
      -- Retorna 0, caso não encontrado
      V_RETORNO := '0';
    END IF;
    ------------------
    RETURN V_RETORNO;
    ------------------
END F_VERIFICA_SUBSTUIDO_ID;
/
grant execute, debug on REQPES.F_VERIFICA_SUBSTUIDO_ID to AN$RHEV;


