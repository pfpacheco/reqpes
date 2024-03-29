CREATE OR REPLACE FUNCTION REQPES.F_GET_COTA_TST(P_COD_UO IN VARCHAR2
                                         ,P_CARGO  IN NUMBER) RETURN NUMBER IS
  RETORNO NUMBER;
BEGIN
  SELECT I.COTA
  INTO   RETORNO
  FROM   INSTRUCAO            I
        ,INSTRUCAO_ATRIBUICAO IA
        ,TABELA_SALARIAL      T
  WHERE  I.COD_INSTRUCAO = IA.COD_INSTRUCAO
  AND    I.COD_TAB_SALARIAL = T.COD_TAB_SALARIAL
  AND    T.IND_ATIVO = 'S'
  AND    IA.COD_UNIDADE = P_COD_UO
  AND    I.COD_CARGO = P_CARGO
  AND    I.COD_TAB_SALARIAL = 7;

  RETURN RETORNO;
END F_GET_COTA_TST;
/
grant execute, debug on REQPES.F_GET_COTA_TST to AN$RHEV;


