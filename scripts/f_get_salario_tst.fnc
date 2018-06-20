CREATE OR REPLACE FUNCTION REQPES.F_GET_SALARIO_TST(P_COD_UO IN VARCHAR2
                                            ,P_CARGO  IN NUMBER
                                            ,P_COTA   IN NUMBER)
  RETURN NUMBER IS
  RETORNO NUMBER;
BEGIN
  SELECT TSNS.VALOR_STEP SALARIO
  INTO   RETORNO
  FROM   UNIORG_CARGO_TAB_NIVEL   UCTN
        ,TAB_SALARIAL_NIVEL_STEPS TSNS
        ,UNIDADES_ORGANIZACIONAIS UO
        ,UNIDADES_ORGANIZACIONAIS UO1
  WHERE  UO.CODIGO = P_COD_UO
  AND    UCTN.ID_CARGO = P_CARGO
  AND    (UCTN.COD_UNIORG = UO.CODIGO_PAI OR UCTN.COD_UNIORG = 'SENAC')
  AND    UO.NIVEL = 2
  AND    UO.DATA_ENCERRAMENTO IS NULL
  AND    UCTN.TAB_SALARIAL = TSNS.TAB_SALARIAL
  AND    UCTN.NIVEL = TSNS.NIVEL
  AND    UO.CODIGO_PAI = UO1.CODIGO
  AND    UO1.DATA_ENCERRAMENTO IS NULL
  AND    LPAD((TSNS.POSICAO_STEP - 1), 2, '0') = P_COTA
  ORDER  BY LPAD((TSNS.POSICAO_STEP - 1), 2, '0');

  RETURN RETORNO;
END F_GET_SALARIO_TST;
/
grant execute, debug on REQPES.F_GET_SALARIO_TST to AN$RHEV;

