CREATE OR REPLACE FUNCTION REQPES.F_IS_CARGO_ADM_COORD(P_IN_COD_UNIDADE IN VARCHAR2) RETURN VARCHAR IS
  V_QTD     NUMBER;
  V_RETORNO VARCHAR2(1) := 'N';
BEGIN
  -----------------------------------------------
  -- VERIFICANDO EXISTENCIA DA UNIDADE
  -----------------------------------------------
  SELECT COUNT(*)
  INTO   V_QTD
  FROM   UO_CARGO_ADM_COORD T
  WHERE  T.COD_UNIDADE LIKE P_IN_COD_UNIDADE||'%';

  -----------------------------------------------
  IF (V_QTD > 0) THEN
    V_RETORNO := 'S';
  END IF;

  RETURN V_RETORNO;

END F_IS_CARGO_ADM_COORD;
/
grant execute, debug on REQPES.F_IS_CARGO_ADM_COORD to AN$RHEV;


