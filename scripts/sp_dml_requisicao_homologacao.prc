CREATE OR REPLACE PROCEDURE REQPES.SP_DML_REQUISICAO_HOMOLOGACAO(P_IN_TIPO               IN VARCHAR2
                                                         ,P_IN_REQUISICAO_SQ      IN NUMBER
                                                         ,P_IN_COD_UO_APROVADORA  IN VARCHAR2
                                                         ,P_IN_COD_UO_HOMOLOGADOR IN VARCHAR2
                                                         ,P_IN_NIVEL              IN NUMBER
                                                         ,P_IN_DSC_MOTIVO         IN VARCHAR2
                                                         ,P_IN_USUARIO            IN VARCHAR2) IS

  REG_REQUISICAO HISTORICO_REQUISICAO%ROWTYPE;

BEGIN
  -- Parametro:  P_IN_TIPO =>  A: Aprovação; R: Reprovação
  -------------------------------------------------------------------------------
  REG_REQUISICAO.REQUISICAO_SQ         := P_IN_REQUISICAO_SQ;
  REG_REQUISICAO.COD_UNIDADE           := P_IN_COD_UO_APROVADORA;
  REG_REQUISICAO.UNIDADE_ATUAL_USUARIO := P_IN_COD_UO_HOMOLOGADOR;
  REG_REQUISICAO.NIVEL                 := P_IN_NIVEL;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_REQUISICAO_HOMOLOGACAO(P_IN_TIPO,REG_REQUISICAO,P_IN_USUARIO, P_IN_DSC_MOTIVO);
  -------------------------------------------------------------------------------
END SP_DML_REQUISICAO_HOMOLOGACAO;
/
grant execute, debug on REQPES.SP_DML_REQUISICAO_HOMOLOGACAO to AN$RHEV;


