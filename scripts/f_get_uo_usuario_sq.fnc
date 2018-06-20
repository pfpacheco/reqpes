CREATE OR REPLACE FUNCTION REQPES.F_GET_UO_USUARIO_SQ(P_IN_USUARIO_SQ IN VARCHAR2) RETURN VARCHAR2 IS
  V_COD_UNIDADE VARCHAR2(10);
BEGIN
  ---------------------------------------------
  -- RESGATANDO O CODIGO DA UNIDADE DO USUARIO
  ---------------------------------------------
  SELECT U.UNIDADE
  INTO   V_COD_UNIDADE
  FROM   USUARIO U
  WHERE  U.USUARIO_SQ = P_IN_USUARIO_SQ;
  ---------------------------------------------
  RETURN(V_COD_UNIDADE);
  ---------------------------------------------
END F_GET_UO_USUARIO_SQ;
/
grant execute, debug on REQPES.F_GET_UO_USUARIO_SQ to AN$RHEV;


