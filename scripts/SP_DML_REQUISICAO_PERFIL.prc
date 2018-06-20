CREATE OR REPLACE PROCEDURE REQPES.SP_DML_REQUISICAO_PERFIL(P_IN_DML                      IN NUMBER
                                                    ,P_IN_REQUISICAO_SQ            IN NUMBER
                                                    ,P_IN_SQ_NIVEL                 IN NUMBER
                                                    ,P_IN_SEXO                     IN VARCHAR2
                                                    ,P_IN_DS_FORMACAO              IN VARCHAR2
                                                    ,P_IN_FAIXA_ETARIA_INI         IN NUMBER
                                                    ,P_IN_FAIXA_ETARIA_FIM         IN NUMBER
                                                    ,P_IN_OUTRAS_CARATERISTICA     IN VARCHAR2
                                                    ,P_IN_EXPERIENCIA              IN NUMBER
                                                    ,P_IN_COMPLEMENTO_ESCOLARIDADE IN VARCHAR2
                                                    ,P_IN_TP_EXPERIENCIA           IN VARCHAR2
                                                    ,P_IN_COMENTARIOS              IN VARCHAR2
                                                    ,P_IN_DSC_OPORTUNIDADE         IN VARCHAR2
                                                    ,P_IN_DSC_ATIVIDADES_CARGO     IN VARCHAR2
                                                    ,P_IN_COD_AREA                 IN NUMBER
                                                    ,P_IN_NIVEL_HIERARQUIA         IN NUMBER
                                                    ,P_IN_COD_FUNCAO               IN NUMBER
                                                    ,P_IN_DSC_EXPERIENCIA          IN VARCHAR2
                                                    ,P_IN_DSC_CONHECIMENTOS        IN VARCHAR2
                                                    ,P_IN_LIST_FUNCAO              IN VARCHAR2
                                                    ,P_IN_GRAVA_HISTORICO_CHAPA    IN NUMBER
                                                    ,P_IN_SO_PERFIL                IN NUMBER) IS

  REG_REQUISICAO_PERFIL REQUISICAO_PERFIL%ROWTYPE;

BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar

  -------------------------------------------------------------------------------
  -- Verificando o valor a ser setando na idade de inicio
  IF(P_IN_FAIXA_ETARIA_INI > 0)THEN
    REG_REQUISICAO_PERFIL.FAIXA_ETARIA_INI := P_IN_FAIXA_ETARIA_INI;
  ELSE
    REG_REQUISICAO_PERFIL.FAIXA_ETARIA_INI := NULL;
  END IF;
  -- Verificando o valor a ser setando na idade final
  IF(P_IN_FAIXA_ETARIA_FIM > 0)THEN
    REG_REQUISICAO_PERFIL.FAIXA_ETARIA_FIM := P_IN_FAIXA_ETARIA_FIM;
  ELSE
    REG_REQUISICAO_PERFIL.FAIXA_ETARIA_FIM := NULL;
  END IF;
  -------------------------------------------------------------------------------
  REG_REQUISICAO_PERFIL.COMENTARIOS              := P_IN_COMENTARIOS;
  REG_REQUISICAO_PERFIL.COMPLEMENTO_ESCOLARIDADE := P_IN_COMPLEMENTO_ESCOLARIDADE;
  REG_REQUISICAO_PERFIL.DS_FORMACAO              := P_IN_DS_FORMACAO;
  REG_REQUISICAO_PERFIL.EXPERIENCIA              := P_IN_EXPERIENCIA;
  REG_REQUISICAO_PERFIL.OUTRAS_CARATERISTICA     := P_IN_OUTRAS_CARATERISTICA;
  REG_REQUISICAO_PERFIL.REQUISICAO_SQ            := P_IN_REQUISICAO_SQ;
  REG_REQUISICAO_PERFIL.SEXO                     := P_IN_SEXO;
  REG_REQUISICAO_PERFIL.SQ_NIVEL                 := P_IN_SQ_NIVEL;
  REG_REQUISICAO_PERFIL.TP_EXPERIENCIA           := P_IN_TP_EXPERIENCIA;
  REG_REQUISICAO_PERFIL.DSC_OPORTUNIDADE         := P_IN_DSC_OPORTUNIDADE;
  REG_REQUISICAO_PERFIL.DSC_ATIVIDADES_CARGO     := P_IN_DSC_ATIVIDADES_CARGO;
  REG_REQUISICAO_PERFIL.COD_AREA                 := P_IN_COD_AREA;
  REG_REQUISICAO_PERFIL.COD_NIVEL_HIERARQUIA     := P_IN_NIVEL_HIERARQUIA;
  REG_REQUISICAO_PERFIL.COD_FUNCAO               := P_IN_COD_FUNCAO;
  REG_REQUISICAO_PERFIL.DSC_EXPERIENCIA          := P_IN_DSC_EXPERIENCIA;
  REG_REQUISICAO_PERFIL.DSC_CONHECIMENTOS        := P_IN_DSC_CONHECIMENTOS;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_REQUISICAO_PERFIL(P_IN_DML, REG_REQUISICAO_PERFIL, P_IN_LIST_FUNCAO, P_IN_GRAVA_HISTORICO_CHAPA, P_IN_SO_PERFIL);
  -------------------------------------------------------------------------------

END SP_DML_REQUISICAO_PERFIL;
/
grant execute, debug on REQPES.SP_DML_REQUISICAO_PERFIL to AN$RHEV;


