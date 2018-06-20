CREATE OR REPLACE FUNCTION REQPES.F_GET_SEL_TABELA_SALARIAL(P_IN_COD_TABELA IN NUMBER, P_IN_COD_TABELA_RHEV NUMBER) RETURN VARCHAR2 IS
  V_QTD NUMBER := 0;
  V_RETORNO VARCHAR2(1) := 'N';

BEGIN
  -----------------------------------------------
  -- VERIFICANDO EXISTENCIA DA ATRIBUICAO
  -----------------------------------------------
  SELECT COUNT(*)
  INTO   V_QTD
  FROM   TABELA_SALARIAL_ATRIBUICAO G
  WHERE  G.COD_TAB_SALARIAL      = P_IN_COD_TABELA
  AND    G.COD_TAB_SALARIAL_RHEV = P_IN_COD_TABELA_RHEV;
  ---------------------------------------------
  IF (V_QTD > 0) THEN
     V_RETORNO := 'S';
  END IF;
  ---------------------------------------------
  RETURN(V_RETORNO);
  ---------------------------------------------
END F_GET_SEL_TABELA_SALARIAL;
/
grant execute, debug on REQPES.F_GET_SEL_TABELA_SALARIAL to AN$RHEV;


