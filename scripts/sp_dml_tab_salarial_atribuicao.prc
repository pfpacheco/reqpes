CREATE OR REPLACE PROCEDURE REQPES.SP_DML_TAB_SALARIAL_ATRIBUICAO(P_IN_DML                 IN NUMBER
                                                          ,P_IN_COD_TABELA_SALARIAL IN OUT NUMBER
                                                          ,P_IN_COD_TABELA          IN NUMBER) IS

  REG_TAB_SALARIAL_ATRIBUICAO TABELA_SALARIAL_ATRIBUICAO%ROWTYPE;

BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_TAB_SALARIAL_ATRIBUICAO.COD_TAB_SALARIAL      := P_IN_COD_TABELA_SALARIAL;
  REG_TAB_SALARIAL_ATRIBUICAO.COD_TAB_SALARIAL_RHEV := P_IN_COD_TABELA;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_TAB_SALARIAL_ATRIBUICAO(P_IN_DML, REG_TAB_SALARIAL_ATRIBUICAO);
  -------------------------------------------------------------------------------
  P_IN_COD_TABELA_SALARIAL := REG_TAB_SALARIAL_ATRIBUICAO.COD_TAB_SALARIAL;

END SP_DML_TAB_SALARIAL_ATRIBUICAO;
/
grant execute, debug on REQPES.SP_DML_TAB_SALARIAL_ATRIBUICAO to AN$RHEV;


