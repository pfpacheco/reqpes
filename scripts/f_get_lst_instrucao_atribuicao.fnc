CREATE OR REPLACE FUNCTION REQPES.F_GET_LST_INSTRUCAO_ATRIBUICAO(P_IN_COD_INSTRUCAO IN INSTRUCAO.COD_INSTRUCAO%TYPE)
  RETURN VARCHAR2 IS

  -- Fun��o utilizada na listagem das unidades associadas com a instru��o
  V_LIST_UO VARCHAR2(4000);
  V_LIST_COD VARCHAR2(4000);

BEGIN
  FOR UO IN (SELECT UO.SIGLA
                   ,UO.CODIGO
             FROM   INSTRUCAO_ATRIBUICAO     IA
                   ,UNIDADES_ORGANIZACIONAIS UO
             WHERE  IA.COD_INSTRUCAO = P_IN_COD_INSTRUCAO
             AND    IA.COD_UNIDADE   = UO.CODIGO
             ORDER  BY UO.SIGLA) LOOP
    V_LIST_UO  := V_LIST_UO  || UO.SIGLA  || ' / ';
    V_LIST_COD := V_LIST_COD || UO.CODIGO || ' / ';
  END LOOP;

  RETURN SUBSTR(V_LIST_UO, 0, LENGTH(V_LIST_UO) - 3) || '#' || SUBSTR(V_LIST_COD, 0, LENGTH(V_LIST_COD) - 3);
END;
/
grant execute, debug on REQPES.F_GET_LST_INSTRUCAO_ATRIBUICAO to AN$RHEV;


