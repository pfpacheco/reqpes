CREATE OR REPLACE PROCEDURE REQPES.SP_DML_REQUISICAO(P_IN_DML                     IN NUMBER
                                             ,P_IN_OUT_REQUISICAO_SQ       IN OUT NUMBER
                                             ,P_IN_COD_UNIDADE             IN VARCHAR2
                                             ,P_IN_COD_MA                  IN VARCHAR2
                                             ,P_IN_COD_SMA                 IN VARCHAR2
                                             ,P_IN_USUARIO_SQ              IN NUMBER
                                             ,P_IN_CARGO_SQ                IN NUMBER
                                             ,P_IN_COTA                    IN NUMBER
                                             ,P_IN_TP_CONTRATACAO          IN VARCHAR2
                                             ,P_IN_NM_SUPERIOR             IN VARCHAR2
                                             ,P_IN_FONE_UNIDADE            IN VARCHAR2
                                             ,P_IN_JORNADA_TRABALHO        IN NUMBER
                                             ,P_IN_LOCAL_TRABALHO          IN VARCHAR2
                                             ,P_IN_MOTIVO_SOLICITACAO      IN VARCHAR2
                                             ,P_IN_OBS                     IN VARCHAR2
                                             ,P_IN_SUPERVISAO              IN VARCHAR2
                                             ,P_IN_NR_FUNCIONARIO          IN NUMBER
                                             ,P_IN_DS_TAREFA               IN VARCHAR2
                                             ,P_IN_VIAGEM                  IN VARCHAR2
                                             ,P_IN_SALARIO                 IN NUMBER
                                             ,P_IN_OUTRO_LOCAL             IN VARCHAR2
                                             ,P_IN_NM_INDICADO             IN VARCHAR2
                                             ,P_IN_INICIO_CONTRATACAO      IN DATE
                                             ,P_IN_FIM_CONTRATACAO         IN DATE
                                             ,P_IN_COD_RECRUTAMENTO        IN NUMBER
                                             ,P_IN_COD_AREA                IN NUMBER
                                             ,P_IN_RAZAO_SUBSTITUICAO      IN VARCHAR2
                                             ,P_IN_TIPO_INDICACAO          IN VARCHAR2
                                             ,P_IN_DS_MOTIVO_SOLICITACAO   IN VARCHAR2
                                             ,P_IN_CLASSIFICACAO_FUNCIONAL IN NUMBER
                                             ,P_IN_ID_INDICADO             IN NUMBER
                                             ,P_IN_SUBSTITUIDO_ID_HIST     IN NUMBER
                                             ,P_IN_TRANSFERENCIA_DATA      IN DATE
                                             ,P_IN_IND_CARTA_CONVTE        IN CHAR
                                             ,P_IN_IND_EX_CARTA_CONVTE     IN CHAR
                                             ,P_IN_IND_EX_FUNCIONARIO      IN CHAR
                                             ,P_IN_IND_TIPO_REQUISICAO     IN VARCHAR2
                                             ,P_IN_COD_STATUS              IN NUMBER
                                             ,P_IN_USUARIO                 IN VARCHAR2
                                             ,P_IN_SEGMENTO_1              IN VARCHAR2
                                             ,P_IN_SEGMENTO_2              IN VARCHAR2
                                             ,P_IN_SEGMENTO_3              IN VARCHAR2
                                             ,P_IN_SEGMENTO_4              IN VARCHAR2
                                             ,P_IN_SEGMENTO_5              IN VARCHAR2
                                             ,P_IN_SEGMENTO_6              IN VARCHAR2
                                             ,P_IN_SEGMENTO_7              IN VARCHAR2
                                             ,P_UO_DESTINO                 IN VARCHAR2
                                             ,P_NIVEL                      IN NUMBER
                                             ,P_IN_DSC_RECRUTAMENTO        IN VARCHAR2
                                             ,P_IN_IND_CARATER_EXCECAO     IN VARCHAR2
                                             ,P_IN_VERSAO_SISTEMA          IN VARCHAR2
                                             ,P_IN_ID_CODE_COMBINATION     IN NUMBER
                                             ,P_IN_TIPO                    IN NUMBER) IS
  REG_REQUISICAO REQUISICAO%ROWTYPE;

BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_REQUISICAO.REQUISICAO_SQ           := P_IN_OUT_REQUISICAO_SQ;
  REG_REQUISICAO.CARGO_SQ                := P_IN_CARGO_SQ;
  REG_REQUISICAO.CLASSIFICACAO_FUNCIONAL := P_IN_CLASSIFICACAO_FUNCIONAL;
  REG_REQUISICAO.COD_AREA                := NULL;                 -- campo descontinuado
  REG_REQUISICAO.COD_MA                  := NULL;                 -- campo descontinuado
  REG_REQUISICAO.COD_SMA                 := NULL;                 -- campo descontinuado
  REG_REQUISICAO.COD_STATUS              := P_IN_COD_STATUS;
  REG_REQUISICAO.COD_UNIDADE             := P_IN_COD_UNIDADE;
  REG_REQUISICAO.COTA                    := P_IN_COTA;
  REG_REQUISICAO.DS_MOTIVO_SOLICITACAO   := P_IN_DS_MOTIVO_SOLICITACAO;
  REG_REQUISICAO.DS_TAREFA               := P_IN_DS_TAREFA;
  REG_REQUISICAO.FIM_CONTRATACAO         := P_IN_FIM_CONTRATACAO;
  REG_REQUISICAO.FONE_UNIDADE            := P_IN_FONE_UNIDADE;
  REG_REQUISICAO.ID_INDICADO             := P_IN_ID_INDICADO;
  REG_REQUISICAO.IND_CARTA_CONVTE        := P_IN_IND_CARTA_CONVTE;
  REG_REQUISICAO.IND_EX_CARTA_CONVTE     := P_IN_IND_EX_CARTA_CONVTE;
  REG_REQUISICAO.IND_EX_FUNCIONARIO      := P_IN_IND_EX_FUNCIONARIO;
  REG_REQUISICAO.IND_TIPO_REQUISICAO     := P_IN_IND_TIPO_REQUISICAO;
  REG_REQUISICAO.INICIO_CONTRATACAO      := P_IN_INICIO_CONTRATACAO;
  REG_REQUISICAO.JORNADA_TRABALHO        := P_IN_JORNADA_TRABALHO;
  REG_REQUISICAO.LOCAL_TRABALHO          := P_IN_LOCAL_TRABALHO;
  REG_REQUISICAO.MOTIVO_SOLICITACAO      := P_IN_MOTIVO_SOLICITACAO;
  REG_REQUISICAO.NM_INDICADO             := P_IN_NM_INDICADO;
  REG_REQUISICAO.NM_SUPERIOR             := P_IN_NM_SUPERIOR;
  REG_REQUISICAO.NR_FUNCIONARIO          := P_IN_NR_FUNCIONARIO;
  REG_REQUISICAO.OBS                     := P_IN_OBS;
  REG_REQUISICAO.OUTRO_LOCAL             := P_IN_OUTRO_LOCAL;
  REG_REQUISICAO.RAZAO_SUBSTITUICAO      := P_IN_RAZAO_SUBSTITUICAO;
  REG_REQUISICAO.COD_RECRUTAMENTO        := P_IN_COD_RECRUTAMENTO;
  REG_REQUISICAO.SALARIO                 := P_IN_SALARIO;
  REG_REQUISICAO.SUBSTITUIDO_ID_HIST     := P_IN_SUBSTITUIDO_ID_HIST;
  REG_REQUISICAO.SUPERVISAO              := P_IN_SUPERVISAO;
  REG_REQUISICAO.TIPO_INDICACAO          := NULL;               -- campo descontinuado
  REG_REQUISICAO.TP_CONTRATACAO          := P_IN_TP_CONTRATACAO;
  REG_REQUISICAO.TRANSFERENCIA_DATA      := P_IN_TRANSFERENCIA_DATA; 
  REG_REQUISICAO.USUARIO_SQ              := P_IN_USUARIO_SQ;
  REG_REQUISICAO.VIAGEM                  := P_IN_VIAGEM;
  REG_REQUISICAO.DSC_RECRUTAMENTO        := P_IN_DSC_RECRUTAMENTO;
  REG_REQUISICAO.IND_CARATER_EXCECAO     := P_IN_IND_CARATER_EXCECAO;
  REG_REQUISICAO.VERSAO_SISTEMA          := P_IN_VERSAO_SISTEMA;
  REG_REQUISICAO.ID_CODE_COMBINATION     := P_IN_ID_CODE_COMBINATION;
  REG_REQUISICAO.COD_SEGMENTO1           := P_IN_SEGMENTO_1;
  REG_REQUISICAO.COD_SEGMENTO2           := P_IN_SEGMENTO_2;
  REG_REQUISICAO.COD_SEGMENTO3           := P_IN_SEGMENTO_3;
  REG_REQUISICAO.COD_SEGMENTO4           := P_IN_SEGMENTO_4;
  REG_REQUISICAO.COD_SEGMENTO5           := P_IN_SEGMENTO_5;
  REG_REQUISICAO.COD_SEGMENTO6           := P_IN_SEGMENTO_6;
  REG_REQUISICAO.COD_SEGMENTO7           := P_IN_SEGMENTO_7;
  -------------------------------------------------------------------------------
  -- Chamando a procedure que executa os comandos DML de acordo com o parâmetro passado
  REQUISICAO_PKG.SP_DML_REQUISICAO(P_IN_DML, REG_REQUISICAO, P_IN_USUARIO, P_UO_DESTINO, P_NIVEL,P_IN_TIPO);
  -------------------------------------------------------------------------------
  -- Retornando o código da requisição
  P_IN_OUT_REQUISICAO_SQ := REG_REQUISICAO.REQUISICAO_SQ;  
 
  -------------------------------------------------------------------------------  
END SP_DML_REQUISICAO;
/
grant execute, debug on REQPES.SP_DML_REQUISICAO to AN$RHEV;


