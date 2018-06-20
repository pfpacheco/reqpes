CREATE OR REPLACE FUNCTION REQPES.F_GET_SEL_GRUPO_NEC_USUARIO(P_IN_COD_GRUPO IN NUMBER, P_IN_CHAPA NUMBER) RETURN VARCHAR2 IS
  V_QTD NUMBER := 0;
  V_RETORNO VARCHAR2(1) := 'N';

BEGIN
  -----------------------------------------------
  -- VERIFICANDO EXISTENCIA DA ATRIBUICAO
  -----------------------------------------------
  SELECT COUNT(*)
  INTO   V_QTD
  FROM   GRUPO_NEC_USUARIOS G
  WHERE  G.COD_GRUPO  = P_IN_COD_GRUPO
  AND    G.CHAPA      = P_IN_CHAPA;
  ---------------------------------------------
  IF (V_QTD > 0) THEN
     V_RETORNO := 'S';
  END IF;
  ---------------------------------------------
  RETURN(V_RETORNO);
  ---------------------------------------------
END F_GET_SEL_GRUPO_NEC_USUARIO;
/
grant execute, debug on REQPES.F_GET_SEL_GRUPO_NEC_USUARIO to AN$RHEV;


