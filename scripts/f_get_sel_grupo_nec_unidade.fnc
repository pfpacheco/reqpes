CREATE OR REPLACE FUNCTION REQPES.F_GET_SEL_GRUPO_NEC_UNIDADE(P_IN_COD_GRUPO IN NUMBER, P_IN_COD_UNIDADE VARCHAR2) RETURN VARCHAR2 IS
  V_QTD NUMBER := 0;
  V_RETORNO VARCHAR2(1) := 'N';

BEGIN
  -----------------------------------------------
  -- VERIFICANDO EXISTENCIA DA ATRIBUICAO
  -----------------------------------------------
  SELECT COUNT(*)
  INTO   V_QTD
  FROM   GRUPO_NEC_UNIDADES G
  WHERE  G.COD_GRUPO   = P_IN_COD_GRUPO
  AND    G.COD_UNIDADE = P_IN_COD_UNIDADE;
  ---------------------------------------------
  IF (V_QTD > 0) THEN
     V_RETORNO := 'S';
  END IF;
  ---------------------------------------------
  RETURN(V_RETORNO);
  ---------------------------------------------
END F_GET_SEL_GRUPO_NEC_UNIDADE;
/
grant execute, debug on REQPES.F_GET_SEL_GRUPO_NEC_UNIDADE to AN$RHEV;


