CREATE OR REPLACE FUNCTION REQPES.F_GET_SEL_INSTRUCAO_ATRIBUICAO(P_IN_COD_INSTRUCAO IN NUMBER, P_IN_COD_UNIDADE VARCHAR2) RETURN VARCHAR2 IS
  V_QTD NUMBER := 0;
  V_RETORNO VARCHAR2(1) := 'N';

BEGIN
  -----------------------------------------------
  -- VERIFICANDO EXISTENCIA DA ATRIBUICAO
  -----------------------------------------------
  SELECT COUNT(*)
  INTO   V_QTD
  FROM   INSTRUCAO_ATRIBUICAO I
  WHERE  I.COD_INSTRUCAO = P_IN_COD_INSTRUCAO
  AND    I.COD_UNIDADE   = P_IN_COD_UNIDADE;
  ---------------------------------------------
  IF (V_QTD > 0) THEN
     V_RETORNO := 'S';
  END IF;
  ---------------------------------------------
  RETURN(V_RETORNO);
  ---------------------------------------------
END F_GET_SEL_INSTRUCAO_ATRIBUICAO;
/
grant execute, debug on REQPES.F_GET_SEL_INSTRUCAO_ATRIBUICAO to AN$RHEV;


