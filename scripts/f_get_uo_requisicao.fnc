CREATE OR REPLACE FUNCTION REQPES.F_GET_UO_REQUISICAO(P_IN_REQUISICAO_SQ IN NUMBER) RETURN VARCHAR2 IS
  V_COD_UNIDADE VARCHAR2(10);
BEGIN
  -----------------------------------------------
  -- RESGATANDO O CODIGO DA UNIDADE DA REQUISIÇÃO
  -----------------------------------------------
  SELECT R.COD_UNIDADE
  INTO   V_COD_UNIDADE
  FROM   REQUISICAO R
  WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_SQ;
  ---------------------------------------------
  RETURN(V_COD_UNIDADE);
  ---------------------------------------------
END F_GET_UO_REQUISICAO;
/
grant execute, debug on REQPES.F_GET_UO_REQUISICAO to AN$RHEV;


