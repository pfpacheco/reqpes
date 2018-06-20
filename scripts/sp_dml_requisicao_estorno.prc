CREATE OR REPLACE PROCEDURE REQPES.SP_DML_REQUISICAO_ESTORNO(P_IN_DML               IN NUMBER
                                                     ,P_IN_OUT_REQUISICAO_SQ IN OUT NUMBER
                                                     ,P_IN_USUARIO           IN VARCHAR2
                                                     ,P_IN_IND_TIPO_ESTORNO  IN VARCHAR2) IS

  REG_REQUISICAO HISTORICO_REQUISICAO%ROWTYPE;

BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_REQUISICAO.REQUISICAO_SQ := P_IN_OUT_REQUISICAO_SQ;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_REQUISICAO_ESTORNO(P_IN_DML,REG_REQUISICAO,P_IN_USUARIO,P_IN_IND_TIPO_ESTORNO);
  -------------------------------------------------------------------------------
  -- Retornando o codigo da requisição
  P_IN_OUT_REQUISICAO_SQ := REG_REQUISICAO.REQUISICAO_SQ;
  -------------------------------------------------------------------------------
END SP_DML_REQUISICAO_ESTORNO;
/
grant execute, debug on REQPES.SP_DML_REQUISICAO_ESTORNO to AN$RHEV;


