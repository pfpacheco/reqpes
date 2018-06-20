CREATE OR REPLACE PROCEDURE REQPES.SP_DML_SUBSTITUICAO_GERENTE(P_IN_DML                 IN NUMBER
                                                       ,P_IN_CHAPA               IN NUMBER
                                                       ,P_IN_COD_UNIDADE         IN VARCHAR2
                                                       ,P_IN_DAT_INICIO_VIGENCIA IN DATE
                                                       ,P_IN_DAT_FIM_VIGENCIA    IN DATE
                                                       ,P_IN_TEOR_COD            IN VARCHAR2) IS

  REG_SUBSTITUICAO_GERENTE RESPONSAVEL_ESTRUTURA%ROWTYPE;
BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_SUBSTITUICAO_GERENTE.UNOR_COD           := P_IN_COD_UNIDADE;
  REG_SUBSTITUICAO_GERENTE.FUNC_ID            := P_IN_CHAPA;
  REG_SUBSTITUICAO_GERENTE.REST_DAT_INI_VIGEN := P_IN_DAT_INICIO_VIGENCIA;
  REG_SUBSTITUICAO_GERENTE.REST_DAT_FIN_VIGEN := P_IN_DAT_FIM_VIGENCIA;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_SUBSTITUICAO_GERENTE(P_IN_DML,REG_SUBSTITUICAO_GERENTE,P_IN_TEOR_COD);
  -------------------------------------------------------------------------------
END SP_DML_SUBSTITUICAO_GERENTE;
/
grant execute, debug on REQPES.SP_DML_SUBSTITUICAO_GERENTE to AN$RHEV;


