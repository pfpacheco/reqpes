CREATE OR REPLACE PROCEDURE REQPES.SP_DML_REQUISICAO_REVISAO(P_IN_DML           IN NUMBER
                                                     ,P_IN_REQUISICAO_SQ IN OUT NUMBER
                                                     ,P_IN_MOTIVO        IN VARCHAR2
                                                     ,P_IN_USUARIO_SQ    IN NUMBER
                                                     ,P_IN_PERFIL_HOM    IN NUMBER
                                                     ,P_IN_CHAPA         IN VARCHAR2) IS
  REG_REQUISICAO_REVISAO REQUISICAO_REVISAO%ROWTYPE;

BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_REQUISICAO_REVISAO.MOTIVO        := P_IN_MOTIVO;
  REG_REQUISICAO_REVISAO.REQUISICAO_SQ := P_IN_REQUISICAO_SQ;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_REQUISICAO_REVISAO(P_IN_DML, REG_REQUISICAO_REVISAO, P_IN_USUARIO_SQ, P_IN_PERFIL_HOM, P_IN_CHAPA);
  -------------------------------------------------------------------------------
  P_IN_REQUISICAO_SQ := REG_REQUISICAO_REVISAO.REQUISICAO_SQ;
  -------------------------------------------------------------------------------
END SP_DML_REQUISICAO_REVISAO;
/
grant execute, debug on REQPES.SP_DML_REQUISICAO_REVISAO to AN$RHEV;


