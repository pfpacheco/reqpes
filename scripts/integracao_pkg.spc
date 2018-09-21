CREATE OR REPLACE PACKAGE REQPES.INTEGRACAO_PKG IS
  --=======================================================================================--
  -- Data: 17/01/2012
  -- Autor: Thiago Lima Coutinho
  -- Descrição: Processo responsável por incluir os dados iniciais do candidato selecionado
  --            no Banco de Talentos no sistema RHEvolution
  --=======================================================================================--

  PROCEDURE SP_INTEGRACAO(P_IN_OUT_REG_FUNCIONARIOS IN OUT FUNCIONARIOS%ROWTYPE
                         ,P_IN_REQUISICAO_SQ        IN REQUISICAO.REQUISICAO_SQ%TYPE
                         ,P_IN_USUARIO_LOG          IN FUNCIONARIOS.ID%TYPE
                         ,P_OUT_SUCESSO             OUT NUMBER
                         ,P_OUT_MSG                 OUT VARCHAR2);

  PROCEDURE SP_IN_FUNCIONARIOS(P_IN_OUT_REG_FUNCIONARIOS  IN OUT FUNCIONARIOS%ROWTYPE
                              ,P_IN_REQUISICAO_SQ         IN REQUISICAO.REQUISICAO_SQ%TYPE
                              ,P_IN_USUARIO_LOG           IN FUNCIONARIOS.ID%TYPE
                              ,P_IN_USUARIO_SQ            IN USUARIO.USUARIO_SQ%TYPE
                              ,P_OUT_SUCESSO              OUT NUMBER
                              ,P_OUT_MSG                  OUT VARCHAR2);

  FUNCTION F_RETORNA_DV_ID(W_ID VARCHAR2) RETURN VARCHAR2;

  PROCEDURE SP_VALIDA_DADOS_EXTERNO(P_IN_OUT_REG_FUNCIONARIOS  IN OUT FUNCIONARIOS%ROWTYPE
                                   ,P_OUT_ERRO                 OUT VARCHAR2);

  PROCEDURE SP_VALIDA_DADOS_INTERNO(P_IN_OUT_REG_FUNCIONARIOS  IN OUT FUNCIONARIOS%ROWTYPE
                                   ,P_IN_REQUISICAO_SQ         IN REQUISICAO.REQUISICAO_SQ%TYPE
                                   ,P_OUT_SUCESSO              OUT NUMBER
                                   ,P_OUT_MSG                  OUT VARCHAR2);

  PROCEDURE SP_IN_LOG_EXPORTACAO(P_IN_REQUISICAO_SQ IN LOG_EXPORTACAO.REQUISICAO_SQ%TYPE
                                ,P_IN_DSC_LOG       IN LOG_EXPORTACAO.DSC_LOG%TYPE
                                ,P_IN_USER_LOG      IN LOG_EXPORTACAO.USER_LOG%TYPE);
                                
                                
  PROCEDURE SP_NOTIFICA_INTEGRACAO_RHEV(P_IN_FUNCIONARIO IN FUNCIONARIOS%ROWTYPE);
                                  
END INTEGRACAO_PKG;
/
grant execute, debug on REQPES.INTEGRACAO_PKG to AN$RHEV;


