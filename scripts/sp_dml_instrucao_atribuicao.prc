CREATE OR REPLACE PROCEDURE REQPES.SP_DML_INSTRUCAO_ATRIBUICAO(P_IN_DML           IN NUMBER
                                                       ,P_IN_COD_INSTRUCAO IN OUT NUMBER
                                                       ,P_IN_COD_UNIDADE   IN VARCHAR2) IS
  REG_INSTRUCAO_ATRIBUICAO INSTRUCAO_ATRIBUICAO%ROWTYPE;
BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_INSTRUCAO_ATRIBUICAO.COD_INSTRUCAO  := P_IN_COD_INSTRUCAO;
  REG_INSTRUCAO_ATRIBUICAO.COD_UNIDADE    := P_IN_COD_UNIDADE;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_INSTRUCAO_ATRIBUICAO(P_IN_DML, REG_INSTRUCAO_ATRIBUICAO);
  -------------------------------------------------------------------------------
  P_IN_COD_INSTRUCAO := REG_INSTRUCAO_ATRIBUICAO.COD_INSTRUCAO;

END SP_DML_INSTRUCAO_ATRIBUICAO;
/
grant execute, debug on REQPES.SP_DML_INSTRUCAO_ATRIBUICAO to AN$RHEV;


