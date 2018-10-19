CREATE OR REPLACE PACKAGE REQUISICAO_PKG IS

  -- Author  : Thiago Lima Coutinho
  -- Created : 01/09/2008
  -- Purpose : Armazenar as regras de banco da aplicação de Requisição de Pessoal

  PROCEDURE SP_DML_REQUISICAO(P_IN_DML IN NUMBER, P_IN_REQUISICAO IN OUT REQUISICAO%ROWTYPE,P_IN_USUARIO IN VARCHAR2,P_UO_DESTINO IN VARCHAR2,P_NIVEL IN NUMBER,P_TIPO IN NUMBER);

  PROCEDURE SP_DML_REQUISICAO_PERFIL(P_IN_DML IN NUMBER,P_IN_REQUISICAO_PERFIL IN OUT REQUISICAO_PERFIL%ROWTYPE, P_IN_LIST_FUNCAO IN VARCHAR2, P_IN_GRAVA_HISTORICO_CHAPA IN NUMBER, P_IN_SO_PERFIL IN NUMBER);

  PROCEDURE SP_DML_REQUISICAO_JORNADA(P_IN_DML IN NUMBER,P_IN_REQUISICAO_JORNADA IN OUT REQUISICAO_JORNADA%ROWTYPE, P_IN_CHAPA IN NUMBER);

  PROCEDURE SP_DML_USUARIO_AVISO(P_IN_DML IN NUMBER,P_IN_USUARIO_AVISO IN OUT USUARIO_AVISO%ROWTYPE,P_IN_USUARIO IN VARCHAR2);

  PROCEDURE SP_DML_REQUISICAO_BAIXA(P_IN_DML IN NUMBER,P_IN_REQUISICAO_BAIXA IN OUT REQUISICAO_BAIXA%ROWTYPE,P_IN_USUARIO IN VARCHAR2);

  PROCEDURE SP_DML_REQUISICAO_ESTORNO(P_IN_DML IN NUMBER,P_IN_REQUISICAO_ESTORNO IN OUT HISTORICO_REQUISICAO%ROWTYPE,P_IN_USUARIO IN VARCHAR2,P_IN_IND_TIPO_ESTORNO IN VARCHAR2);

  PROCEDURE SP_DML_REQUISICAO_REVISAO(P_IN_DML IN NUMBER,P_IN_REQUISICAO_REVISAO IN OUT REQUISICAO_REVISAO%ROWTYPE,P_IN_USUARIO IN VARCHAR2, P_IN_PERFIL_HOM IN NUMBER, P_IN_CHAPA IN VARCHAR2);

  PROCEDURE SP_DML_REQUISICAO_HOMOLOGACAO(P_IN_TIPO IN VARCHAR2,P_IN_REQUISICAO IN HISTORICO_REQUISICAO%ROWTYPE,P_IN_USUARIO IN VARCHAR2,P_IN_DSC_MOTIVO IN VARCHAR2);

  PROCEDURE SP_DML_SUBSTITUICAO_GERENTE(P_IN_DML IN VARCHAR2,P_IN_SUBSTITUICAO IN RESPONSAVEL_ESTRUTURA%ROWTYPE,P_IN_TEOR_COD IN VARCHAR2);
  
  PROCEDURE SP_DML_TABELA_SALARIAL(P_IN_DML IN NUMBER,P_IN_TABELA_SALARIAL IN OUT TABELA_SALARIAL%ROWTYPE, P_IN_USUARIO IN VARCHAR2);
  
  PROCEDURE SP_DML_TAB_SALARIAL_ATRIBUICAO(P_IN_DML IN NUMBER, P_IN_TAB_SALARIAL_ATRIBUICAO IN OUT TABELA_SALARIAL_ATRIBUICAO%ROWTYPE);
  
  PROCEDURE SP_DML_INSTRUCAO(P_IN_DML IN NUMBER,P_IN_INSTRUCAO IN OUT INSTRUCAO%ROWTYPE, P_IN_USUARIO IN VARCHAR2);
  
  PROCEDURE SP_DML_INSTRUCAO_ATRIBUICAO(P_IN_DML IN NUMBER, P_IN_INSTRUCAO_ATRIBUICAO IN OUT INSTRUCAO_ATRIBUICAO%ROWTYPE);

  PROCEDURE SP_DML_GRUPO_NEC(P_IN_DML IN NUMBER, P_IN_GRUPO_NEC IN OUT GRUPO_NEC%ROWTYPE, P_IN_USUARIO IN VARCHAR2);
  
  PROCEDURE SP_DML_GRUPO_NEC_UNIDADES(P_IN_DML IN NUMBER, P_IN_GRUPO_NEC_UNIDADES IN OUT GRUPO_NEC_UNIDADES%ROWTYPE);
  
  PROCEDURE SP_DML_GRUPO_NEC_USUARIOS(P_IN_DML IN NUMBER, P_IN_GRUPO_NEC_USUARIOS IN OUT GRUPO_NEC_USUARIOS%ROWTYPE, P_IN_USUARIO IN VARCHAR2);

  PROCEDURE SP_DML_CARGO_ADM_COORD(P_IN_DML IN NUMBER, P_IN_UO_CARGO_ADM_COORD IN UO_CARGO_ADM_COORD%ROWTYPE, P_IN_USUARIO IN VARCHAR2);
  
  PROCEDURE SP_DML_TIPO_AVISO(P_IN_DML IN NUMBER, P_IN_TIPO_AVISO IN OUT TIPO_AVISO%ROWTYPE, P_IN_USUARIO IN VARCHAR2);

  PROCEDURE SP_REQUISICAO_PERFIL_FUNCAO(P_REQUISICAO_SQ IN REQUISICAO.REQUISICAO_SQ%TYPE, P_LIST_FUNCAO IN VARCHAR2);

END REQUISICAO_PKG;
/
CREATE OR REPLACE PACKAGE BODY REQUISICAO_PKG IS

  -- Author  : Thiago Lima Coutinho
  -- Created : 01/09/2008
  -- Purpose : Armazenar as regras de banco da aplicação de Requisição de Pessoal
  
  
--################################ FUNCAO PARA LIMPAR CARACTERES #######################
FUNCTION F_REMOVE_CARACTERES(P_TEXT VARCHAR2) RETURN VARCHAR2 IS
BEGIN 
  RETURN REPLACE(REPLACE(REPLACE(REPLACE(P_TEXT,Chr(34),''),Chr(10),''),Chr(13),''),Chr(32),'');
EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20025, 'PROBLEMA AO REMOVER CARACTERES' || SQLERRM);    
END F_REMOVE_CARACTERES;

--################################ INICIO DA PROCEDURE SP_DML_REQUISICAO #######################
PROCEDURE SP_DML_REQUISICAO(P_IN_DML IN NUMBER,P_IN_REQUISICAO IN OUT REQUISICAO%ROWTYPE,P_IN_USUARIO IN VARCHAR2,P_UO_DESTINO IN VARCHAR2,P_NIVEL  IN NUMBER,P_TIPO IN NUMBER) IS
 TIPO_TRANSACAO VARCHAR2(50);
 V_RPS_SUBST    VARCHAR2(250);
 
 V_REQUISICAO_SQ             REQUISICAO.REQUISICAO_SQ%TYPE;
 V_COD_UNIDADE               REQUISICAO.COD_UNIDADE%TYPE; 
 V_USUARIO_SQ                REQUISICAO.USUARIO_SQ%TYPE; 
 V_CARGO_SQ                  REQUISICAO.CARGO_SQ%TYPE; 
 V_COD_MA                    REQUISICAO.COD_MA%TYPE; 
 V_COD_SMA                   REQUISICAO.COD_SMA%TYPE;
 V_COTA                      REQUISICAO.COTA%TYPE; 
 V_TP_CONTRATACAO            REQUISICAO.TP_CONTRATACAO%TYPE; 
 V_NM_SUPERIOR               REQUISICAO.NM_SUPERIOR%TYPE; 
 V_FONE_UNIDADE              REQUISICAO.FONE_UNIDADE%TYPE; 
 V_JORNADA_TRABALHO          REQUISICAO.JORNADA_TRABALHO%TYPE; 
 V_LOCAL_TRABALHO            REQUISICAO.LOCAL_TRABALHO%TYPE; 
 V_MOTIVO_SOLICITACAO        REQUISICAO.MOTIVO_SOLICITACAO%TYPE; 
 V_OBS                       REQUISICAO.OBS%TYPE; 
 V_SUPERVISAO                REQUISICAO.SUPERVISAO%TYPE; 
 V_NR_FUNCIONARIO            REQUISICAO.NR_FUNCIONARIO%TYPE; 
 V_DS_TAREFA                 REQUISICAO.DS_TAREFA%TYPE; 
 V_VIAGEM                    REQUISICAO.VIAGEM%TYPE; 
 V_SALARIO                   REQUISICAO.SALARIO%TYPE; 
 V_OUTRO_LOCAL               REQUISICAO.OUTRO_LOCAL%TYPE; 
 V_NM_INDICADO               REQUISICAO.NM_INDICADO%TYPE; 
 V_INICIO_CONTRATACAO        REQUISICAO.INICIO_CONTRATACAO%TYPE; 
 V_FIM_CONTRATACAO           REQUISICAO.FIM_CONTRATACAO%TYPE;
 V_COD_RECRUTAMENTO          REQUISICAO.COD_RECRUTAMENTO%TYPE; 
 V_DT_REQUISICAO             REQUISICAO.DT_REQUISICAO%TYPE; 
 V_COD_AREA                  REQUISICAO.COD_AREA%TYPE; 
 V_RAZAO_SUBSTITUICAO        REQUISICAO.RAZAO_SUBSTITUICAO%TYPE; 
 V_TIPO_INDICACAO            REQUISICAO.TIPO_INDICACAO%TYPE; 
 V_NOME_INDICADO             REQUISICAO.NOME_INDICADO%TYPE; 
 V_DS_MOTIVO_SOLICITACAO     REQUISICAO.DS_MOTIVO_SOLICITACAO%TYPE; 
 V_CLASSIFICACAO_FUNCIONAL   REQUISICAO.CLASSIFICACAO_FUNCIONAL%TYPE; 
 V_ID_INDICADO               REQUISICAO.ID_INDICADO%TYPE; 
 V_SUBSTITUIDO_ID_HIST       REQUISICAO.SUBSTITUIDO_ID_HIST%TYPE; 
 V_TRANSFERENCIA_DATA        REQUISICAO.TRANSFERENCIA_DATA%TYPE; 
 V_IND_CARTA_CONVTE          REQUISICAO.IND_CARTA_CONVTE%TYPE; 
 V_IND_EX_CARTA_CONVTE       REQUISICAO.IND_EX_CARTA_CONVTE%TYPE; 
 V_IND_EX_FUNCIONARIO        REQUISICAO.IND_EX_FUNCIONARIO%TYPE; 
 V_ID_CODE_COMBINATION       REQUISICAO.ID_CODE_COMBINATION%TYPE; 
 V_IND_TIPO_REQUISICAO       REQUISICAO.IND_TIPO_REQUISICAO%TYPE; 
 V_COD_STATUS                REQUISICAO.COD_STATUS%TYPE; 
 V_DSC_RECRUTAMENTO          REQUISICAO.DSC_RECRUTAMENTO%TYPE; 
 V_IND_CARATER_EXCECAO       REQUISICAO.IND_CARATER_EXCECAO%TYPE; 
 V_VERSAO_SISTEMA            REQUISICAO.VERSAO_SISTEMA%TYPE; 
 V_COD_SEGMENTO1             REQUISICAO.COD_SEGMENTO1%TYPE; 
 V_COD_SEGMENTO2             REQUISICAO.COD_SEGMENTO2%TYPE; 
 V_COD_SEGMENTO3             REQUISICAO.COD_SEGMENTO3%TYPE; 
 V_COD_SEGMENTO4             REQUISICAO.COD_SEGMENTO4%TYPE; 
 V_COD_SEGMENTO5             REQUISICAO.COD_SEGMENTO5%TYPE; 
 V_COD_SEGMENTO6             REQUISICAO.COD_SEGMENTO6%TYPE; 
 V_COD_SEGMENTO7             REQUISICAO.COD_SEGMENTO7%TYPE; 
 V_SQ_USUARIO                USUARIO.USUARIO_SQ%TYPE;
 V_NIVEL_USUARIO             USUARIO.NIVEL%TYPE;
 V_USUARIO_COD_UNIDADE       USUARIO.COD_UNIDADE%TYPE;
 V_IDENTIFICACAO_USUARIO     USUARIO.IDENTIFICACAO%TYPE;
 V_UNIDADE_USUARIO           USUARIO.UNIDADE%TYPE;
 V_COD_UNIDADE_HISTORICO     HISTORICO_REQUISICAO.COD_UNIDADE%TYPE;
 V_NIVEL_HISTORICO           HISTORICO_REQUISICAO.NIVEL%TYPE;
 P_DATA_HORA                 DATE;
 V_ANTES                     NVARCHAR2(30000); 
 V_DEPOIS                    NVARCHAR2(30000); 
BEGIN
    BEGIN
      P_DATA_HORA:=CURRENT_TIMESTAMP;
      
      -------------------------------------------------
      -- SETANDO VALORES
      -------------------------------------------------
      IF (P_IN_REQUISICAO.ID_INDICADO = 0) THEN
        P_IN_REQUISICAO.ID_INDICADO := NULL;
      END IF;
      -------------------------------------------------
      IF (P_IN_REQUISICAO.SUBSTITUIDO_ID_HIST = 0) THEN
        P_IN_REQUISICAO.SUBSTITUIDO_ID_HIST := NULL;
      END IF;
      -------------------------------------------------
      IF (P_IN_REQUISICAO.MOTIVO_SOLICITACAO = 0) THEN
        P_IN_REQUISICAO.MOTIVO_SOLICITACAO := NULL;
      END IF;
      -------------------------------------------------
      IF (P_IN_REQUISICAO.RAZAO_SUBSTITUICAO = 0) THEN
        P_IN_REQUISICAO.RAZAO_SUBSTITUICAO := NULL;
      END IF;
      -------------------------------------------------
      IF (P_IN_REQUISICAO.TP_CONTRATACAO = 0) THEN
        P_IN_REQUISICAO.TP_CONTRATACAO := NULL;
      END IF;
      -------------------------------------------------
      IF (P_IN_REQUISICAO.COD_RECRUTAMENTO = 0) THEN
        P_IN_REQUISICAO.COD_RECRUTAMENTO := NULL;
      END IF;
      

      -- ############# VERIFICANDO O TIPO DE TRANSACÃO   ################# --
      -- ############# SE 0 FAZ INSERT   ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------
        SELECT SEQ_REQUISICAO.NEXTVAL
        INTO   P_IN_REQUISICAO.REQUISICAO_SQ
        FROM   DUAL;
        -----------------------------------------------------

        -- Verifica se existem RP utilizando o mesmo ID do substituido
        V_RPS_SUBST := F_VERIFICA_SUBSTUIDO_ID(P_IN_REQUISICAO.SUBSTITUIDO_ID_HIST);

        -----------------------------------------------------
        INSERT INTO REQUISICAO
          (REQUISICAO_SQ
          ,COD_UNIDADE
          ,USUARIO_SQ
          ,CARGO_SQ
          ,COTA
          ,COD_MA
          ,COD_SMA
          ,TP_CONTRATACAO
          ,NM_SUPERIOR
          ,FONE_UNIDADE
          ,JORNADA_TRABALHO
          ,LOCAL_TRABALHO
          ,MOTIVO_SOLICITACAO
          ,OBS
          ,SUPERVISAO
          ,NR_FUNCIONARIO
          ,DS_TAREFA
          ,VIAGEM
          ,SALARIO
          ,OUTRO_LOCAL
          ,NM_INDICADO
          ,INICIO_CONTRATACAO
          ,FIM_CONTRATACAO
          ,COD_RECRUTAMENTO
          ,DT_REQUISICAO
          ,COD_AREA
          ,RAZAO_SUBSTITUICAO
          ,TIPO_INDICACAO
          ,DS_MOTIVO_SOLICITACAO
          ,CLASSIFICACAO_FUNCIONAL
          ,ID_INDICADO
          ,SUBSTITUIDO_ID_HIST
          ,TRANSFERENCIA_DATA
          ,IND_CARTA_CONVTE
          ,IND_EX_CARTA_CONVTE
          ,IND_EX_FUNCIONARIO
          ,ID_CODE_COMBINATION
          ,IND_TIPO_REQUISICAO
          ,COD_STATUS
          ,DSC_RECRUTAMENTO
          ,IND_CARATER_EXCECAO
          ,VERSAO_SISTEMA
          ,COD_SEGMENTO1
          ,COD_SEGMENTO2
          ,COD_SEGMENTO3
          ,COD_SEGMENTO4
          ,COD_SEGMENTO5
          ,COD_SEGMENTO6
          ,COD_SEGMENTO7)
        VALUES
          (P_IN_REQUISICAO.REQUISICAO_SQ
          ,P_IN_REQUISICAO.COD_UNIDADE
          ,P_IN_REQUISICAO.USUARIO_SQ
          ,P_IN_REQUISICAO.CARGO_SQ
          ,P_IN_REQUISICAO.COTA
          ,P_IN_REQUISICAO.COD_MA
          ,P_IN_REQUISICAO.COD_SMA
          ,P_IN_REQUISICAO.TP_CONTRATACAO
          ,P_IN_REQUISICAO.NM_SUPERIOR
          ,P_IN_REQUISICAO.FONE_UNIDADE
          ,P_IN_REQUISICAO.JORNADA_TRABALHO
          ,P_IN_REQUISICAO.LOCAL_TRABALHO
          ,P_IN_REQUISICAO.MOTIVO_SOLICITACAO
          ,P_IN_REQUISICAO.OBS
          ,P_IN_REQUISICAO.SUPERVISAO
          ,NVL(P_IN_REQUISICAO.NR_FUNCIONARIO,0)
          ,P_IN_REQUISICAO.DS_TAREFA
          ,P_IN_REQUISICAO.VIAGEM
          ,P_IN_REQUISICAO.SALARIO
          ,P_IN_REQUISICAO.OUTRO_LOCAL
          ,P_IN_REQUISICAO.NM_INDICADO
          ,P_IN_REQUISICAO.INICIO_CONTRATACAO
          ,P_IN_REQUISICAO.FIM_CONTRATACAO
          ,P_IN_REQUISICAO.COD_RECRUTAMENTO
          ,SYSDATE
          ,P_IN_REQUISICAO.COD_AREA
          ,P_IN_REQUISICAO.RAZAO_SUBSTITUICAO
          ,P_IN_REQUISICAO.TIPO_INDICACAO
          ,P_IN_REQUISICAO.DS_MOTIVO_SOLICITACAO
          ,P_IN_REQUISICAO.CLASSIFICACAO_FUNCIONAL
          ,P_IN_REQUISICAO.ID_INDICADO
          ,P_IN_REQUISICAO.SUBSTITUIDO_ID_HIST
          ,P_IN_REQUISICAO.TRANSFERENCIA_DATA
          ,P_IN_REQUISICAO.IND_CARTA_CONVTE
          ,P_IN_REQUISICAO.IND_EX_CARTA_CONVTE
          ,P_IN_REQUISICAO.IND_EX_FUNCIONARIO
          ,P_IN_REQUISICAO.ID_CODE_COMBINATION
          ,P_IN_REQUISICAO.IND_TIPO_REQUISICAO
          ,P_IN_REQUISICAO.COD_STATUS
          ,P_IN_REQUISICAO.DSC_RECRUTAMENTO
          ,P_IN_REQUISICAO.IND_CARATER_EXCECAO
          ,P_IN_REQUISICAO.VERSAO_SISTEMA
          ,P_IN_REQUISICAO.COD_SEGMENTO1
          ,P_IN_REQUISICAO.COD_SEGMENTO2
          ,P_IN_REQUISICAO.COD_SEGMENTO3
          ,P_IN_REQUISICAO.COD_SEGMENTO4
          ,P_IN_REQUISICAO.COD_SEGMENTO5
          ,P_IN_REQUISICAO.COD_SEGMENTO6
          ,P_IN_REQUISICAO.COD_SEGMENTO7);
        
        -----------------------------------------------------
        -- Notificando os homologadores da GEP
        -- Acão: Gravar / Alterar
        -- RP_Para: 2 - SUBSTITUIÇÃO / 3 - TRANSFERENCIA
        -----------------------------------------------------
        IF (P_IN_DML IN (0,1) AND P_IN_REQUISICAO.MOTIVO_SOLICITACAO IN ('2','3')) THEN
           IF (V_RPS_SUBST <> '0') THEN
              SP_NOTIFICA_SUBSTITUICAO_ID(P_IN_REQUISICAO, V_RPS_SUBST);
           END IF;
        END IF;

        -----------------------------------------------------
        -- GRAVANDO NO HISTORICO
        -----------------------------------------------------
      
        INSERT INTO HISTORICO_REQUISICAO
          (REQUISICAO_SQ
          ,COD_UNIDADE
          ,DT_ENVIO
          ,DT_HOMOLOGACAO
          ,USUARIO_SQ
          ,STATUS
          ,UNIDADE_ATUAL_USUARIO
          ,NIVEL)
        VALUES
          (P_IN_REQUISICAO.REQUISICAO_SQ
          ,P_UO_DESTINO
          ,CURRENT_TIMESTAMP--SYSDATE
          ,null
          ,P_IN_REQUISICAO.USUARIO_SQ
          ,'criou'
          ,F_GET_UO_USUARIO_SQ(P_IN_REQUISICAO.USUARIO_SQ)
          ,P_NIVEL);
        -----------------------------------------------------

        -- ############# SE 1 FAZ UPDATE   ################# --
      ELSIF (P_IN_DML > 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'UPDATE';
        -----------------------------------------------------

        -- captura dados da requisição antes da alteração
        SELECT REQUISICAO_SQ
              ,COD_UNIDADE
              ,USUARIO_SQ
              ,CARGO_SQ
              ,COD_MA
              ,COD_SMA
              ,COTA
              ,TP_CONTRATACAO
              ,NM_SUPERIOR
              ,FONE_UNIDADE
              ,JORNADA_TRABALHO
              ,LOCAL_TRABALHO
              ,MOTIVO_SOLICITACAO
              ,OBS
              ,SUPERVISAO
              ,NR_FUNCIONARIO
              ,DS_TAREFA
              ,VIAGEM
              ,SALARIO
              ,OUTRO_LOCAL
              ,NM_INDICADO
              ,INICIO_CONTRATACAO
              ,FIM_CONTRATACAO
              ,COD_RECRUTAMENTO
              ,DT_REQUISICAO
              ,COD_AREA
              ,RAZAO_SUBSTITUICAO
              ,TIPO_INDICACAO
              ,NOME_INDICADO
              ,DS_MOTIVO_SOLICITACAO
              ,CLASSIFICACAO_FUNCIONAL
              ,ID_INDICADO
              ,SUBSTITUIDO_ID_HIST
              ,TRANSFERENCIA_DATA
              ,IND_CARTA_CONVTE
              ,IND_EX_CARTA_CONVTE
              ,IND_EX_FUNCIONARIO
              ,ID_CODE_COMBINATION
              ,IND_TIPO_REQUISICAO
              ,COD_STATUS
              ,DSC_RECRUTAMENTO
              ,IND_CARATER_EXCECAO
              ,VERSAO_SISTEMA
              ,COD_SEGMENTO1
              ,COD_SEGMENTO2
              ,COD_SEGMENTO3
              ,COD_SEGMENTO4
              ,COD_SEGMENTO5
              ,COD_SEGMENTO6
              ,COD_SEGMENTO7
          INTO V_REQUISICAO_SQ
              ,V_COD_UNIDADE
              ,V_USUARIO_SQ
              ,V_CARGO_SQ
              ,V_COD_MA
              ,V_COD_SMA
              ,V_COTA
              ,V_TP_CONTRATACAO
              ,V_NM_SUPERIOR
              ,V_FONE_UNIDADE
              ,V_JORNADA_TRABALHO
              ,V_LOCAL_TRABALHO
              ,V_MOTIVO_SOLICITACAO
              ,V_OBS
              ,V_SUPERVISAO
              ,V_NR_FUNCIONARIO
              ,V_DS_TAREFA
              ,V_VIAGEM
              ,V_SALARIO
              ,V_OUTRO_LOCAL
              ,V_NM_INDICADO
              ,V_INICIO_CONTRATACAO
              ,V_FIM_CONTRATACAO
              ,V_COD_RECRUTAMENTO
              ,V_DT_REQUISICAO
              ,V_COD_AREA
              ,V_RAZAO_SUBSTITUICAO
              ,V_TIPO_INDICACAO
              ,V_NOME_INDICADO
              ,V_DS_MOTIVO_SOLICITACAO
              ,V_CLASSIFICACAO_FUNCIONAL
              ,V_ID_INDICADO
              ,V_SUBSTITUIDO_ID_HIST
              ,V_TRANSFERENCIA_DATA
              ,V_IND_CARTA_CONVTE
              ,V_IND_EX_CARTA_CONVTE
              ,V_IND_EX_FUNCIONARIO
              ,V_ID_CODE_COMBINATION
              ,V_IND_TIPO_REQUISICAO
              ,V_COD_STATUS
              ,V_DSC_RECRUTAMENTO
              ,V_IND_CARATER_EXCECAO
              ,V_VERSAO_SISTEMA
              ,V_COD_SEGMENTO1
              ,V_COD_SEGMENTO2
              ,V_COD_SEGMENTO3
              ,V_COD_SEGMENTO4
              ,V_COD_SEGMENTO5
              ,V_COD_SEGMENTO6
              ,V_COD_SEGMENTO7
          FROM REQUISICAO
         WHERE REQUISICAO_SQ = P_IN_REQUISICAO.REQUISICAO_SQ;


        -- OBS: O status da requisição e atualizado no processo de REVISÃO
        UPDATE REQUISICAO
        SET    IND_TIPO_REQUISICAO     = P_IN_REQUISICAO.IND_TIPO_REQUISICAO
              ,CARGO_SQ                = P_IN_REQUISICAO.CARGO_SQ
              ,CLASSIFICACAO_FUNCIONAL = P_IN_REQUISICAO.CLASSIFICACAO_FUNCIONAL
              ,COD_AREA                = P_IN_REQUISICAO.COD_AREA
              ,COD_UNIDADE             = P_IN_REQUISICAO.COD_UNIDADE
              ,COTA                    = P_IN_REQUISICAO.COTA
              ,DS_MOTIVO_SOLICITACAO   = P_IN_REQUISICAO.DS_MOTIVO_SOLICITACAO
              ,DS_TAREFA               = P_IN_REQUISICAO.DS_TAREFA
              ,FIM_CONTRATACAO         = P_IN_REQUISICAO.FIM_CONTRATACAO
              ,FONE_UNIDADE            = P_IN_REQUISICAO.FONE_UNIDADE
              ,ID_CODE_COMBINATION     = P_IN_REQUISICAO.ID_CODE_COMBINATION
              ,ID_INDICADO             = P_IN_REQUISICAO.ID_INDICADO
              ,IND_CARTA_CONVTE        = P_IN_REQUISICAO.IND_CARTA_CONVTE
              ,IND_EX_CARTA_CONVTE     = P_IN_REQUISICAO.IND_EX_CARTA_CONVTE
              ,IND_EX_FUNCIONARIO      = P_IN_REQUISICAO.IND_EX_FUNCIONARIO
              ,INICIO_CONTRATACAO      = P_IN_REQUISICAO.INICIO_CONTRATACAO
              ,JORNADA_TRABALHO        = P_IN_REQUISICAO.JORNADA_TRABALHO
              ,LOCAL_TRABALHO          = P_IN_REQUISICAO.LOCAL_TRABALHO
              ,MOTIVO_SOLICITACAO      = P_IN_REQUISICAO.MOTIVO_SOLICITACAO
              ,NM_INDICADO             = P_IN_REQUISICAO.NM_INDICADO
              ,NM_SUPERIOR             = P_IN_REQUISICAO.NM_SUPERIOR
              ,NR_FUNCIONARIO          = NVL(P_IN_REQUISICAO.NR_FUNCIONARIO,0)
              ,OBS                     = P_IN_REQUISICAO.OBS
              ,OUTRO_LOCAL             = P_IN_REQUISICAO.OUTRO_LOCAL
              ,RAZAO_SUBSTITUICAO      = P_IN_REQUISICAO.RAZAO_SUBSTITUICAO
              ,COD_RECRUTAMENTO        = P_IN_REQUISICAO.COD_RECRUTAMENTO
              ,SALARIO                 = P_IN_REQUISICAO.SALARIO
              ,SUBSTITUIDO_ID_HIST     = P_IN_REQUISICAO.SUBSTITUIDO_ID_HIST
              ,SUPERVISAO              = P_IN_REQUISICAO.SUPERVISAO
              ,TIPO_INDICACAO          = P_IN_REQUISICAO.TIPO_INDICACAO
              ,TP_CONTRATACAO          = P_IN_REQUISICAO.TP_CONTRATACAO
              ,TRANSFERENCIA_DATA      = P_IN_REQUISICAO.TRANSFERENCIA_DATA
              ,VIAGEM                  = P_IN_REQUISICAO.VIAGEM
              ,DSC_RECRUTAMENTO        = P_IN_REQUISICAO.DSC_RECRUTAMENTO
              ,IND_CARATER_EXCECAO     = P_IN_REQUISICAO.IND_CARATER_EXCECAO
              ,VERSAO_SISTEMA          = P_IN_REQUISICAO.VERSAO_SISTEMA
              ,COD_SEGMENTO1           = P_IN_REQUISICAO.COD_SEGMENTO1
              ,COD_SEGMENTO2           = P_IN_REQUISICAO.COD_SEGMENTO2
              ,COD_SEGMENTO3           = P_IN_REQUISICAO.COD_SEGMENTO3
              ,COD_SEGMENTO4           = P_IN_REQUISICAO.COD_SEGMENTO4
              ,COD_SEGMENTO5           = P_IN_REQUISICAO.COD_SEGMENTO5
              ,COD_SEGMENTO6           = P_IN_REQUISICAO.COD_SEGMENTO6
              ,COD_SEGMENTO7           = P_IN_REQUISICAO.COD_SEGMENTO7
        WHERE  REQUISICAO_SQ           = P_IN_REQUISICAO.REQUISICAO_SQ;

        -----------------------------------------------------
        -- GRAVANDO NO HISTORICO
        -----------------------------------------------------

            SELECT USUARIO_SQ,NIVEL,COD_UNIDADE,UNIDADE,IDENTIFICACAO 
              INTO V_SQ_USUARIO,V_NIVEL_USUARIO,V_USUARIO_COD_UNIDADE,V_UNIDADE_USUARIO,V_IDENTIFICACAO_USUARIO 
              FROM USUARIO 
              WHERE USUARIO_SQ=P_IN_REQUISICAO.USUARIO_SQ;              

             SELECT COD_UNIDADE,NIVEL INTO V_COD_UNIDADE_HISTORICO,V_NIVEL_HISTORICO FROM (
             SELECT COD_UNIDADE,NIVEL FROM HISTORICO_REQUISICAO 
              WHERE REQUISICAO_SQ=P_IN_REQUISICAO.REQUISICAO_SQ AND STATUS<>'alterou' ORDER BY DT_ENVIO DESC) 
              WHERE ROWNUM=1;
       
              INSERT INTO HISTORICO_REQUISICAO(
                     REQUISICAO_SQ, COD_UNIDADE, DT_ENVIO, DT_HOMOLOGACAO, USUARIO_SQ, STATUS, UNIDADE_ATUAL_USUARIO, NIVEL)
              VALUES
                (V_REQUISICAO_SQ
                ,V_COD_UNIDADE_HISTORICO
                ,P_DATA_HORA
                ,NULL
                ,V_SQ_USUARIO
                ,'alterou'
                ,V_UNIDADE_USUARIO
                ,V_NIVEL_HISTORICO);                       
    
           --  ROTINA QUE ATUALIZA O HISTORICO DO PERFIL

           IF P_IN_REQUISICAO.CARGO_SQ != V_CARGO_SQ THEN
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT CD.DESCRICAO FROM CARGOS C, CARGO_DESCRICOES CD WHERE C.ID= ' || V_CARGO_SQ || ' AND C.ID = CD.ID AND C.IN_SITUACAO_CARGO = "A"');
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT CD.DESCRICAO FROM CARGOS C, CARGO_DESCRICOES CD 	WHERE  C.ID= ' || P_IN_REQUISICAO.CARGO_SQ || ' AND C.ID = CD.ID AND C.IN_SITUACAO_CARGO = "A"');
              INSERT INTO historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Título do cargo', V_ANTES,V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.MOTIVO_SOLICITACAO != V_MOTIVO_SOLICITACAO THEN            
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT DESCRICAO FROM SOLICITACAO_MOTIVO WHERE ID=' || V_MOTIVO_SOLICITACAO);
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT DESCRICAO FROM SOLICITACAO_MOTIVO WHERE ID=' || P_IN_REQUISICAO.MOTIVO_SOLICITACAO);
              INSERT INTO  historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'RP para', V_ANTES, V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.COD_RECRUTAMENTO != V_COD_RECRUTAMENTO THEN
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT DESCRICAO  FROM RECRUTAMENTO WHERE ID_RECRUTAMENTO =' || V_COD_RECRUTAMENTO);
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT DESCRICAO  FROM RECRUTAMENTO WHERE ID_RECRUTAMENTO =' || P_IN_REQUISICAO.COD_RECRUTAMENTO);
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Tipo de recrutamento', V_ANTES,V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.CLASSIFICACAO_FUNCIONAL != V_CLASSIFICACAO_FUNCIONAL THEN
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT CLFU_DES FROM CLASSIFICACAO_FUNCIONAL WHERE CLFU_COD=' || V_CLASSIFICACAO_FUNCIONAL);
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT CLFU_DES FROM CLASSIFICACAO_FUNCIONAL WHERE CLFU_COD=' || P_IN_REQUISICAO.CLASSIFICACAO_FUNCIONAL);
              INSERT INTO historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Classificação funcional', V_ANTES,V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.DSC_RECRUTAMENTO != V_DSC_RECRUTAMENTO THEN 
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT DESCRICAO FROM RECRUTAMENTO WHERE ID_RECRUTAMENTO=' || V_DSC_RECRUTAMENTO || ' AND ATIVO = "S"');
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT DESCRICAO FROM RECRUTAMENTO WHERE ID_RECRUTAMENTO=' || P_IN_REQUISICAO.DSC_RECRUTAMENTO || ' AND ATIVO = "S"');
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Tipo de recrutamento', V_DSC_RECRUTAMENTO,P_IN_REQUISICAO.DSC_RECRUTAMENTO);
           END IF;   

           IF P_IN_REQUISICAO.COD_SEGMENTO1 != V_COD_SEGMENTO1  THEN
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || V_COD_SEGMENTO1 || ' AND  T.TIPO_SEGMENTO=1 AND T.COD_SEGMENTO <> "-"');
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || P_IN_REQUISICAO.COD_SEGMENTO1 || ' AND T.TIPO_SEGMENTO=1 AND T.COD_SEGMENTO <> "-"');
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Empresa', V_ANTES,V_DEPOIS);
           END IF;   

          IF P_IN_REQUISICAO.COD_SEGMENTO2 != V_COD_SEGMENTO2 THEN
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || V_COD_SEGMENTO2 || ' AND T.TIPO_SEGMENTO=2 AND T.COD_SEGMENTO <> "-"');
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || P_IN_REQUISICAO.COD_SEGMENTO2 || ' AND T.TIPO_SEGMENTO=2 AND T.COD_SEGMENTO <> "-"');
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Uniorg Emitente', V_ANTES,V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.COD_SEGMENTO3 != V_COD_SEGMENTO3 THEN
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || V_COD_SEGMENTO3 || ' AND T.TIPO_SEGMENTO=3 AND T.COD_SEGMENTO <> "-"');
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || P_IN_REQUISICAO.COD_SEGMENTO3 || ' AND T.TIPO_SEGMENTO=3 AND T.COD_SEGMENTO <> "-"');
               insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Uniorg Destino', V_ANTES,V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.COD_SEGMENTO4 != V_COD_SEGMENTO4 THEN
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || V_COD_SEGMENTO4 || ' AND T.TIPO_SEGMENTO=4 AND T.COD_SEGMENTO <> "-"');
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || P_IN_REQUISICAO.COD_SEGMENTO4 || ' AND T.TIPO_SEGMENTO=4 AND T.COD_SEGMENTO <> "-"');
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Área / Sub-área', V_ANTES,V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.COD_SEGMENTO5 != V_COD_SEGMENTO5 THEN
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || V_COD_SEGMENTO5 || ' AND T.TIPO_SEGMENTO=5 AND T.COD_SEGMENTO <> "-"');
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || P_IN_REQUISICAO.COD_SEGMENTO5 || ' AND T.TIPO_SEGMENTO=5 AND T.COD_SEGMENTO <> "-"');
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Serviço / Produto', V_ANTES,V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.COD_SEGMENTO6 != V_COD_SEGMENTO6 THEN
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || V_COD_SEGMENTO6 || ' AND T.TIPO_SEGMENTO=6 AND T.COD_SEGMENTO <> "-"');
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || P_IN_REQUISICAO.COD_SEGMENTO6 || ' AND T.TIPO_SEGMENTO=6 AND T.COD_SEGMENTO <> "-"');
               insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                  (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Especificação', V_ANTES,V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.COD_SEGMENTO7 != V_COD_SEGMENTO7 THEN
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || V_COD_SEGMENTO7 || ' AND T.TIPO_SEGMENTO=7 AND T.COD_SEGMENTO <> "-"');
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT T.COD_SEGMENTO || " - " || T.DESCRICAO FROM reqpes.CODE_DESCRICOES_RH T WHERE T.COD_SEGMENTO=' || P_IN_REQUISICAO.COD_SEGMENTO7 || ' AND T.TIPO_SEGMENTO=7 AND T.COD_SEGMENTO <> "-"');
               insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                   (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Modalidade', V_ANTES,V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.COD_MA != V_COD_MA THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Cód. MA', V_COD_MA,P_IN_REQUISICAO.COD_MA);
           END IF;   

           IF P_IN_REQUISICAO.COD_SMA != V_COD_SMA THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Cód. SMA', V_COD_SMA,P_IN_REQUISICAO.COD_SMA);
           END IF;   

           IF P_IN_REQUISICAO.COTA != V_COTA THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Cota', V_COTA,P_IN_REQUISICAO.COTA);
           END IF;   

           IF P_IN_REQUISICAO.NM_SUPERIOR != V_NM_SUPERIOR THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Responsável', V_NM_SUPERIOR,P_IN_REQUISICAO.NM_SUPERIOR);
           END IF;   

           IF P_IN_REQUISICAO.FONE_UNIDADE != V_FONE_UNIDADE THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Telefone', DECODE(V_FONE_UNIDADE,NULL,'Nenhum',V_FONE_UNIDADE) ,P_IN_REQUISICAO.FONE_UNIDADE);
           END IF;   

           IF P_IN_REQUISICAO.JORNADA_TRABALHO != V_JORNADA_TRABALHO  THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Carga horária semanal', DECODE(V_JORNADA_TRABALHO,NULL,'Nenhum',V_JORNADA_TRABALHO) ,P_IN_REQUISICAO.JORNADA_TRABALHO);
           END IF;   

           IF P_IN_REQUISICAO.LOCAL_TRABALHO != V_LOCAL_TRABALHO  THEN
              IF P_IN_REQUISICAO.LOCAL_TRABALHO=1 THEN 
                 V_DEPOIS:='NA GERÊNCIA/UO SOLICITANTE';
                 V_ANTES:='OUTROS';                
              ELSE
                 V_DEPOIS :='OUTROS';                
                 V_ANTES:='NA GERÊNCIA/UO SOLICITANTE';
              END IF;
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Local de trabalho', V_ANTES,V_DEPOIS);
           END IF;   
           
           IF P_IN_REQUISICAO.OUTRO_LOCAL != NVL(V_OUTRO_LOCAL,'1')  THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Outro local', NVL(V_OUTRO_LOCAL,'Nenhum'), P_IN_REQUISICAO.OUTRO_LOCAL);
           END IF;

           /*IF P_IN_REQUISICAO.OBS != V_OBS  THEN          
            insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Observações', V_OBS,P_IN_REQUISICAO.OBS);
           END IF;*/

           IF P_IN_REQUISICAO.SUPERVISAO != V_SUPERVISAO THEN
            insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Supervisão de funcionários', DECODE(V_SUPERVISAO,'S','Sim','Não'), DECODE(P_IN_REQUISICAO.SUPERVISAO,'S','Sim','Não'));
           END IF;   

           IF P_IN_REQUISICAO.NR_FUNCIONARIO != V_NR_FUNCIONARIO THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Nº de funcionários', DECODE(V_NR_FUNCIONARIO,NULL,'Nenhum',V_NR_FUNCIONARIO),P_IN_REQUISICAO.NR_FUNCIONARIO);
           END IF;   

           IF P_IN_REQUISICAO.DS_TAREFA != V_DS_TAREFA THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Descrição da tarefa', DECODE(V_DS_TAREFA,NULL,'Nenhum',V_DS_TAREFA) ,P_IN_REQUISICAO.DS_TAREFA);
           END IF;   

           IF P_IN_REQUISICAO.VIAGEM != V_VIAGEM  THEN
             
           --insert into debug values('sim');
             
              IF P_IN_REQUISICAO.VIAGEM = 1 THEN 
                 V_DEPOIS := 'Frequentes';
                 V_ANTES := 'Raras';                
              ELSE
                 V_DEPOIS := 'Raras';                
                 V_ANTES := 'Frequentes';
              END IF;
              
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Viagem', V_ANTES,V_DEPOIS);
           END IF;   


           IF P_IN_REQUISICAO.SALARIO != V_SALARIO THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Salário', V_SALARIO,P_IN_REQUISICAO.SALARIO);
           END IF;     

           IF P_IN_REQUISICAO.NM_INDICADO != V_NM_INDICADO THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Nome indicado', DECODE(V_NM_INDICADO,NULL,'Nenhum',V_NM_INDICADO) ,P_IN_REQUISICAO.NM_INDICADO);
           END IF; 
           
           IF P_IN_REQUISICAO.TP_CONTRATACAO != V_TP_CONTRATACAO THEN
              select tp.descricao into v_depois from reqpes.tipo_contratacao tp where tp.cod_tipo_contratacao = p_in_requisicao.tp_contratacao;
              select tp.descricao into v_antes from reqpes.tipo_contratacao tp where tp.cod_tipo_contratacao = v_tp_contratacao;
              
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Tipo de Contratação', v_antes,v_depois);
           END IF;   

           IF (P_IN_REQUISICAO.INICIO_CONTRATACAO != NVL(V_INICIO_CONTRATACAO,to_date('01/01/1900','dd/mm/yyyy'))
              OR P_IN_REQUISICAO.FIM_CONTRATACAO != NVL(V_FIM_CONTRATACAO,to_date('01/01/1900','dd/mm/yyyy'))) THEN
              
              IF P_IN_REQUISICAO.TP_CONTRATACAO = 2 OR P_IN_REQUISICAO.TP_CONTRATACAO = 3 THEN
                insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Início da contratação', DECODE(V_INICIO_CONTRATACAO,NULL,'Nenhum',V_INICIO_CONTRATACAO), P_IN_REQUISICAO.INICIO_CONTRATACAO);           
                
                insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                  (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Fim da contratação', DECODE(V_FIM_CONTRATACAO,NULL,'Nenhum',V_FIM_CONTRATACAO) ,P_IN_REQUISICAO.FIM_CONTRATACAO);  
              ELSE    
                IF P_IN_REQUISICAO.INICIO_CONTRATACAO != NVL(V_INICIO_CONTRATACAO,to_date('01/01/1900','dd/mm/yyyy')) THEN
                   insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                   (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Início da contratação', DECODE(V_INICIO_CONTRATACAO,NULL,'Nenhum',V_INICIO_CONTRATACAO), P_IN_REQUISICAO.INICIO_CONTRATACAO);           
                ELSIF P_IN_REQUISICAO.FIM_CONTRATACAO != NVL(V_FIM_CONTRATACAO,to_date('01/01/1900','dd/mm/yyyy')) THEN
                   insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                   (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Fim da contratação', DECODE(V_FIM_CONTRATACAO,NULL,'Nenhum',V_FIM_CONTRATACAO) ,P_IN_REQUISICAO.FIM_CONTRATACAO);  
                END IF;
              END IF;
           
           END IF;   

           /*IF P_IN_REQUISICAO.FIM_CONTRATACAO != NVL(V_FIM_CONTRATACAO,to_date('01/01/1900','dd/mm/yyyy')) THEN
              
              IF P_IN_REQUISICAO.TP_CONTRATACAO = 2 OR P_IN_REQUISICAO.TP_CONTRATACAO = 3 THEN
                insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                  (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Início da contratação', DECODE(V_INICIO_CONTRATACAO,NULL,'Nenhum',V_INICIO_CONTRATACAO), P_IN_REQUISICAO.INICIO_CONTRATACAO);
              END IF; 

           END IF;*/

           IF P_IN_REQUISICAO.DT_REQUISICAO != V_DT_REQUISICAO THEN
            insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Data Requisição', V_DT_REQUISICAO,P_IN_REQUISICAO.DT_REQUISICAO);
           END IF;   

           IF P_IN_REQUISICAO.COD_AREA != V_COD_AREA  THEN
            insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Cód. Area', V_COD_AREA,P_IN_REQUISICAO.COD_AREA);
           END IF;   


           IF P_IN_REQUISICAO.RAZAO_SUBSTITUICAO != NVL(V_RAZAO_SUBSTITUICAO,0) THEN 
              V_ANTES:=SP_DML_REQUISICAO_TRATAMENTO('SELECT DESCRICAO FROM VW_RHEV_TRANSFERENCIA_MOTIVO WHERE TRANSFERENCIA_MOTIVO_ID=' || NVL(V_RAZAO_SUBSTITUICAO,0) || ' AND IND_MOTIVO = "T"');
              V_DEPOIS:=SP_DML_REQUISICAO_TRATAMENTO('SELECT DESCRICAO FROM VW_RHEV_TRANSFERENCIA_MOTIVO WHERE TRANSFERENCIA_MOTIVO_ID=' || P_IN_REQUISICAO.RAZAO_SUBSTITUICAO || '  AND IND_MOTIVO = "T"');
            insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Motivo da solicitação', DECODE(V_ANTES,'Vazio','Nenhum',V_ANTES),V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.TIPO_INDICACAO != V_TIPO_INDICACAO THEN
            insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Tipo Indicação', DECODE(V_TIPO_INDICACAO ,NULL,'Nenhum',V_TIPO_INDICACAO) ,P_IN_REQUISICAO.TIPO_INDICACAO);
           END IF;   

           IF P_IN_REQUISICAO.NOME_INDICADO != V_NOME_INDICADO THEN
            insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Nome Indicado', DECODE(V_NOME_INDICADO ,NULL,'Nenhum',V_NOME_INDICADO),P_IN_REQUISICAO.NOME_INDICADO);
           END IF;   

           IF P_IN_REQUISICAO.DS_MOTIVO_SOLICITACAO != V_DS_MOTIVO_SOLICITACAO THEN
            INSERT INTO historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                    (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Justificativa', DECODE(V_DS_MOTIVO_SOLICITACAO ,NULL,'Nenhum',V_DS_MOTIVO_SOLICITACAO),P_IN_REQUISICAO.DS_MOTIVO_SOLICITACAO);
           END IF; 
             
           IF P_IN_REQUISICAO.ID_INDICADO != V_ID_INDICADO THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
                  (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Indicado', DECODE(V_ID_INDICADO ,NULL,'Nenhum',V_DS_MOTIVO_SOLICITACAO),P_IN_REQUISICAO.ID_INDICADO);
           END IF;   
  
           IF P_IN_REQUISICAO.SUBSTITUIDO_ID_HIST != NVL(V_SUBSTITUIDO_ID_HIST,0) THEN
             
              IF NVL(V_SUBSTITUIDO_ID_HIST,0) > 0 THEN
                 SELECT F.NOME INTO V_ANTES FROM FUNCIONARIOS F WHERE F.ID = V_SUBSTITUIDO_ID_HIST;  
              ELSE
                 V_ANTES:= 'Nenhum';
              END IF;
           
              SELECT F.NOME INTO V_DEPOIS FROM FUNCIONARIOS F WHERE F.ID = P_IN_REQUISICAO.SUBSTITUIDO_ID_HIST;           
           
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Id Substituido', V_SUBSTITUIDO_ID_HIST || ' - ' || V_ANTES,P_IN_REQUISICAO.SUBSTITUIDO_ID_HIST || ' - ' || V_DEPOIS);
           END IF;   

           IF P_IN_REQUISICAO.TRANSFERENCIA_DATA != NVL(V_TRANSFERENCIA_DATA,TO_DATE('01/01/1900','DD/MM/YYYY')) THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Previsão de transferência', DECODE(V_TRANSFERENCIA_DATA,NULL,'Nenhum',V_TRANSFERENCIA_DATA) ,P_IN_REQUISICAO.TRANSFERENCIA_DATA);
           END IF; 
             
           IF P_IN_REQUISICAO.IND_CARTA_CONVTE != NVL(V_IND_CARTA_CONVTE,'X') THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Ind. Carta Convite', DECODE(V_IND_CARTA_CONVTE,NULL,'Nenhum',V_IND_CARTA_CONVTE),P_IN_REQUISICAO.IND_CARTA_CONVTE);
           END IF;   

           IF P_IN_REQUISICAO.IND_EX_CARTA_CONVTE != NVL(V_IND_EX_CARTA_CONVTE,'X') THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Carta Convite', DECODE(V_IND_EX_CARTA_CONVTE,NULL,'Nenhum',V_IND_EX_CARTA_CONVTE),P_IN_REQUISICAO.IND_EX_CARTA_CONVTE);
           END IF;   

           IF P_IN_REQUISICAO.IND_EX_FUNCIONARIO != NVL(V_IND_EX_FUNCIONARIO,'X') THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Ex Funcionário', DECODE(V_IND_EX_FUNCIONARIO,NULL,'Nenhum',V_IND_EX_FUNCIONARIO),P_IN_REQUISICAO.IND_EX_FUNCIONARIO);
           END IF;   

           IF P_IN_REQUISICAO.ID_CODE_COMBINATION != NVL(V_ID_CODE_COMBINATION,0) THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Code Combination', DECODE(V_ID_CODE_COMBINATION,NULL,'Nenhum',V_ID_CODE_COMBINATION),P_IN_REQUISICAO.ID_CODE_COMBINATION);
           END IF;  

           IF P_IN_REQUISICAO.IND_TIPO_REQUISICAO != NVL(V_IND_TIPO_REQUISICAO,'X') THEN              
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Tipo Requisição', decode(V_IND_TIPO_REQUISICAO,'A','Admissão','Transferência'), decode(P_IN_REQUISICAO.IND_TIPO_REQUISICAO,'A','Admissão','Transferência'));
           END IF;   

--           IF P_IN_REQUISICAO.COD_STATUS != V_COD_STATUS THEN
--              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
--              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Cód. Status', V_COD_STATUS,P_IN_REQUISICAO.COD_STATUS);
--           END IF;   

           IF P_IN_REQUISICAO.IND_CARATER_EXCECAO != NVL(V_IND_CARATER_EXCECAO,'X') THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Tipo de enquadramento', 
               DECODE(V_IND_CARATER_EXCECAO,'N','De acordo com a Instrução 04/2011','em caráter de exceção'),
               DECODE(P_IN_REQUISICAO.IND_CARATER_EXCECAO,'N','De acordo com a Instrução 04/2011','em caráter de exceção'));
           END IF;   

           IF P_IN_REQUISICAO.VERSAO_SISTEMA != NVL(V_VERSAO_SISTEMA,'X')  THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Versão do Sistema', DECODE(V_VERSAO_SISTEMA,NULL,'Nenhum',V_VERSAO_SISTEMA),P_IN_REQUISICAO.VERSAO_SISTEMA);
           END IF; 
           
           IF P_IN_REQUISICAO.NM_INDICADO != NVL(V_NOME_INDICADO,'X')  THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Nome do indicado', DECODE(V_NOME_INDICADO,NULL,'Nenhum',V_NOME_INDICADO),P_IN_REQUISICAO.NM_INDICADO);
           END IF;
           
           IF P_IN_REQUISICAO.ID_INDICADO != NVL(V_ID_INDICADO,0)  THEN
              insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
              (V_REQUISICAO_SQ, V_SQ_USUARIO, CURRENT_TIMESTAMP, 'Id do indicado', DECODE(V_ID_INDICADO,NULL,'Nenhum',V_ID_INDICADO),P_IN_REQUISICAO.ID_INDICADO);
           END IF;

        -- ############# SE -1 FAZ DELETE   ################# --
      ELSE
        -----------------------------------------------------
        TIPO_TRANSACAO := 'DELETE';
        -----------------------------------------------------
        -- Neste caso a exclusão e apenas logica
        UPDATE REQUISICAO
        SET    COD_STATUS    = 7 -- STATUS: EXCLUIDA
        WHERE  REQUISICAO_SQ = P_IN_REQUISICAO.REQUISICAO_SQ;

        ------------------------------------------------------
        -- REQUISIÇÕES EXCLUIDAS
        ------------------------------------------------------
        INSERT INTO REQUISICAO_EXCLUIDA
          (REQUISICAO_SQ
          ,FUNCIONARIO_ID
          ,MOTIVO)
        VALUES
          (P_IN_REQUISICAO.REQUISICAO_SQ
          ,P_IN_USUARIO
          ,P_IN_REQUISICAO.DS_MOTIVO_SOLICITACAO);

        ------------------------------------------------------
        -- GRAVANDO NO HISTORICO
        ------------------------------------------------------
        INSERT INTO HISTORICO_REQUISICAO
          (REQUISICAO_SQ
          ,COD_UNIDADE
          ,DT_ENVIO
          ,USUARIO_SQ
          ,STATUS
          ,UNIDADE_ATUAL_USUARIO)
        VALUES
          (P_IN_REQUISICAO.REQUISICAO_SQ
          ,P_UO_DESTINO
          ,CURRENT_TIMESTAMP--SYSDATE
          ,P_IN_REQUISICAO.USUARIO_SQ
          ,'excluiu'
          ,F_GET_UO_USUARIO_SQ(P_IN_REQUISICAO.USUARIO_SQ));
        -----------------------------------------------------
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' ||TIPO_TRANSACAO || ' NA TABELA REQUISICAO' ||SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA AO FAZER ' || TIPO_TRANSACAO ||' NA TABELA REQUISICAO' || SQLERRM);
    END;   
    
END SP_DML_REQUISICAO;
--################################ FIM DA PROCEDURE SP_DML_REQUISICAO #######################


--################################ INICIO DA PROCEDURE SP_DML_REQUISICAO_PERFIL #######################
PROCEDURE SP_DML_REQUISICAO_PERFIL(P_IN_DML IN NUMBER,P_IN_REQUISICAO_PERFIL IN OUT REQUISICAO_PERFIL%ROWTYPE, P_IN_LIST_FUNCAO IN VARCHAR2, P_IN_GRAVA_HISTORICO_CHAPA IN NUMBER, P_IN_SO_PERFIL NUMBER) IS
 
 TIPO_TRANSACAO          VARCHAR2(50);
 V_COMENTARIOS           VARCHAR2(4000);
 V_OUTRAS_CARATERISTICA  VARCHAR2(4000);
 V_DSC_CONHECIMENTOS     VARCHAR2(4000);
 V_DSC_EXPERIENCIA       VARCHAR2(4000);
 V_DS_FORMACAO           VARCHAR2(4000);
 V_DSC_ATIVIDADES_CARGO  VARCHAR2(4000);
 V_REQUISICAO_SQ         NUMBER;
 P_DATA_HORA             DATE;
 V_USUARIO_SQ            USUARIO.USUARIO_SQ%TYPE;  
 V_NIVEL_USUARIO         USUARIO.NIVEL%TYPE;
 V_COD_UNIDADE           USUARIO.COD_UNIDADE%TYPE;
 V_UNIDADE_USUARIO       USUARIO.UNIDADE%TYPE;
 V_COD_UNIDADE_HIST      HISTORICO_REQUISICAO.COD_UNIDADE%TYPE;
 V_DT_ENVIO_HIST         HISTORICO_REQUISICAO.DT_ENVIO%TYPE; 
 V_DT_HOMOLOGACAO_HIST   HISTORICO_REQUISICAO.DT_HOMOLOGACAO%TYPE; 
 V_USUARIO_SQ_HIST       HISTORICO_REQUISICAO.USUARIO_SQ%TYPE; 
 V_STATUS_HIST           HISTORICO_REQUISICAO.STATUS%TYPE;
 V_UNIDADE_ATUAL_USUARIO_HIST HISTORICO_REQUISICAO.UNIDADE_ATUAL_USUARIO%TYPE; 
 V_NIVEL_HIST            HISTORICO_REQUISICAO.NIVEL%TYPE;
 V_COD_AREA              REQUISICAO_PERFIL.COD_AREA%TYPE;
 V_COD_NIVEL_HIERARQUIA  REQUISICAO_PERFIL.COD_NIVEL_HIERARQUIA%TYPE;
 V_COD_FUNCAO            REQUISICAO_PERFIL.COD_FUNCAO%TYPE;
 V_ANTES                 VARCHAR2(3000);
 V_DEPOIS                VARCHAR2(3000);
 

BEGIN
    BEGIN
      P_DATA_HORA:=SYSDATE;
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO   ################# --
      -- ############# SE 0 FAZ INSERT   ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------
        INSERT INTO REQUISICAO_PERFIL
          (REQUISICAO_SQ
          ,SQ_NIVEL
          ,SEXO
          ,DS_FORMACAO
          ,FAIXA_ETARIA_INI
          ,FAIXA_ETARIA_FIM
          ,OUTRAS_CARATERISTICA
          ,EXPERIENCIA
          ,COMPLEMENTO_ESCOLARIDADE
          ,TP_EXPERIENCIA
          ,COMENTARIOS
          ,DSC_OPORTUNIDADE
          ,DSC_ATIVIDADES_CARGO
          ,COD_AREA
          ,COD_NIVEL_HIERARQUIA
          ,COD_FUNCAO
          ,DSC_EXPERIENCIA
          ,DSC_CONHECIMENTOS)
        VALUES
          (P_IN_REQUISICAO_PERFIL.REQUISICAO_SQ
          ,P_IN_REQUISICAO_PERFIL.SQ_NIVEL
          ,P_IN_REQUISICAO_PERFIL.SEXO
          ,P_IN_REQUISICAO_PERFIL.DS_FORMACAO
          ,P_IN_REQUISICAO_PERFIL.FAIXA_ETARIA_INI
          ,P_IN_REQUISICAO_PERFIL.FAIXA_ETARIA_FIM
          ,P_IN_REQUISICAO_PERFIL.OUTRAS_CARATERISTICA
          ,P_IN_REQUISICAO_PERFIL.EXPERIENCIA
          ,'1' -- este valor estava setado na versão do sistema anterior do sistema
          ,P_IN_REQUISICAO_PERFIL.TP_EXPERIENCIA
          ,P_IN_REQUISICAO_PERFIL.COMENTARIOS
          ,P_IN_REQUISICAO_PERFIL.DSC_OPORTUNIDADE
          ,P_IN_REQUISICAO_PERFIL.DSC_ATIVIDADES_CARGO
          ,P_IN_REQUISICAO_PERFIL.COD_AREA
          ,P_IN_REQUISICAO_PERFIL.COD_NIVEL_HIERARQUIA
          ,P_IN_REQUISICAO_PERFIL.COD_FUNCAO
          ,P_IN_REQUISICAO_PERFIL.DSC_EXPERIENCIA
          ,P_IN_REQUISICAO_PERFIL.DSC_CONHECIMENTOS);                
          
          -- Inclui as funções adicionais no perfil
          SP_REQUISICAO_PERFIL_FUNCAO(P_IN_REQUISICAO_PERFIL.REQUISICAO_SQ, P_IN_LIST_FUNCAO);
          
        -- ############# SE 1 FAZ UPDATE   ################# --
      ELSIF (P_IN_DML > 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'UPDATE';
        -----------------------------------------------------
        
        -- SE A CHAPA VIER PREENCHIDA SIGNIFICA QUE A ALTERAÇÃO FOI FEITA COM A REQUISIÇÃO
        -- EM HOMOLOGAÇÃO, PORTANTO SE TORNA NECESSÁRIO CADASTRAR O HISTÓRICO
        IF P_IN_GRAVA_HISTORICO_CHAPA > 0 THEN
           
           SELECT COMENTARIOS,
                  OUTRAS_CARATERISTICA,
                  DSC_CONHECIMENTOS,
                  DSC_EXPERIENCIA,
                  DS_FORMACAO,
                  DSC_ATIVIDADES_CARGO,
                  REQUISICAO_SQ,
                  RP.COD_AREA,
                  RP.COD_NIVEL_HIERARQUIA,
                  RP.COD_FUNCAO
             INTO V_COMENTARIOS,
                  V_OUTRAS_CARATERISTICA,
                  V_DSC_CONHECIMENTOS,
                  V_DSC_EXPERIENCIA,
                  V_DS_FORMACAO,
                  V_DSC_ATIVIDADES_CARGO,
                  V_REQUISICAO_SQ,
                  V_COD_AREA,
                  V_COD_NIVEL_HIERARQUIA,
                  V_COD_FUNCAO 
             FROM REQUISICAO_PERFIL RP
            WHERE RP.REQUISICAO_SQ = P_IN_REQUISICAO_PERFIL.REQUISICAO_SQ;
 
            SELECT USUARIO_SQ,NIVEL,COD_UNIDADE,UNIDADE 
              INTO V_USUARIO_SQ,V_NIVEL_USUARIO,V_COD_UNIDADE,V_UNIDADE_USUARIO 
              FROM USUARIO 
              WHERE IDENTIFICACAO=P_IN_GRAVA_HISTORICO_CHAPA;


             SELECT COD_UNIDADE, DT_ENVIO, DT_HOMOLOGACAO, USUARIO_SQ, STATUS, UNIDADE_ATUAL_USUARIO, NIVEL 
             INTO V_COD_UNIDADE_HIST, V_DT_ENVIO_HIST, V_DT_HOMOLOGACAO_HIST, V_USUARIO_SQ_HIST, V_STATUS_HIST, V_UNIDADE_ATUAL_USUARIO_HIST, V_NIVEL_HIST
             FROM (
             SELECT COD_UNIDADE, DT_ENVIO, DT_HOMOLOGACAO, USUARIO_SQ, STATUS, UNIDADE_ATUAL_USUARIO, NIVEL from HISTORICO_REQUISICAO 
              WHERE REQUISICAO_SQ=P_IN_REQUISICAO_PERFIL.REQUISICAO_SQ ORDER BY DT_ENVIO DESC) 
              WHERE ROWNUM=1;
              
              IF P_IN_SO_PERFIL = 1 THEN
                INSERT INTO HISTORICO_REQUISICAO(
                       REQUISICAO_SQ, COD_UNIDADE, DT_ENVIO, DT_HOMOLOGACAO, USUARIO_SQ, STATUS, UNIDADE_ATUAL_USUARIO, NIVEL)
                VALUES
                  (V_REQUISICAO_SQ
                  ,V_COD_UNIDADE_HIST
                  ,CURRENT_TIMESTAMP
                  ,NULL
                  ,V_USUARIO_SQ
                  ,'alterou'
                  ,V_UNIDADE_ATUAL_USUARIO_HIST
                  ,V_NIVEL_HIST);
              END IF;
       
           --  ROTINA QUE ATUALIZA O HISTORICO DO PERFIL          
           --
           IF F_REMOVE_CARACTERES(TRIM(P_IN_REQUISICAO_PERFIL.DSC_ATIVIDADES_CARGO)) != F_REMOVE_CARACTERES(TRIM(V_DSC_ATIVIDADES_CARGO)) THEN
              insert into historico_perfil_campos
                (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo)
              values
                (V_REQUISICAO_SQ, V_USUARIO_SQ, current_timestamp, 'Principais atividades do cargo', V_DSC_ATIVIDADES_CARGO,P_IN_REQUISICAO_PERFIL.DSC_ATIVIDADES_CARGO);
           END IF;
           
           IF F_REMOVE_CARACTERES(TRIM(P_IN_REQUISICAO_PERFIL.DS_FORMACAO)) != F_REMOVE_CARACTERES(TRIM(V_DS_FORMACAO)) THEN
              insert into historico_perfil_campos
                (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo)
              values
                (V_REQUISICAO_SQ, V_USUARIO_SQ, current_timestamp, 'Escolaridade mínima', V_DS_FORMACAO,P_IN_REQUISICAO_PERFIL.DS_FORMACAO);
           END IF;
           
           IF F_REMOVE_CARACTERES(TRIM(P_IN_REQUISICAO_PERFIL.DSC_EXPERIENCIA)) != F_REMOVE_CARACTERES(TRIM(V_DSC_EXPERIENCIA)) THEN
              insert into historico_perfil_campos
                (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo)
              values
                (V_REQUISICAO_SQ, V_USUARIO_SQ, current_timestamp, 'Experiência profissional', V_DSC_EXPERIENCIA,P_IN_REQUISICAO_PERFIL.DSC_EXPERIENCIA);
           END IF; 
           
           IF F_REMOVE_CARACTERES(TRIM(P_IN_REQUISICAO_PERFIL.DSC_CONHECIMENTOS)) != F_REMOVE_CARACTERES(TRIM(V_DSC_CONHECIMENTOS)) THEN
              insert into historico_perfil_campos
                (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo)
              values
                (V_REQUISICAO_SQ, V_USUARIO_SQ, current_timestamp, 'Conhecimentos específicos', V_DSC_CONHECIMENTOS,P_IN_REQUISICAO_PERFIL.DSC_CONHECIMENTOS);
           END IF;
           
           IF F_REMOVE_CARACTERES(TRIM(P_IN_REQUISICAO_PERFIL.OUTRAS_CARATERISTICA)) != F_REMOVE_CARACTERES(TRIM(V_OUTRAS_CARATERISTICA)) THEN
              insert into historico_perfil_campos
                (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo)
              values
                (V_REQUISICAO_SQ, V_USUARIO_SQ, current_timestamp, 'Competências', V_OUTRAS_CARATERISTICA,P_IN_REQUISICAO_PERFIL.OUTRAS_CARATERISTICA);
           END IF; 

           if F_REMOVE_CARACTERES(trim(p_in_requisicao_perfil.comentarios)) != F_REMOVE_CARACTERES(TRIM(v_comentarios)) then
              insert into historico_perfil_campos
                (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo)
              values
                (v_requisicao_sq, v_usuario_sq, current_timestamp, 'Observações', v_comentarios,p_in_requisicao_perfil.comentarios);
           end if; 
           
           if p_in_requisicao_perfil.cod_area != v_cod_area then
             
              select rt.nome 
                into v_antes 
                from recru.recru_tipo rt 
               where rt.id_tipo = v_cod_area
                 and rt.grupo = 'AREA_VAGA';
                 
              select rt.nome 
                into v_depois 
                from recru.recru_tipo rt 
               where rt.id_tipo = p_in_requisicao_perfil.cod_area
                 and rt.grupo = 'AREA_VAGA';
              
              insert into historico_perfil_campos
                (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo)
              values
                (v_requisicao_sq, v_usuario_sq, current_timestamp, 'Área', INITCAP(v_antes), INITCAP(v_depois));
           end if; 
           
           if p_in_requisicao_perfil.cod_nivel_hierarquia != v_cod_nivel_hierarquia then
              
              select rt.nome 
                into v_antes 
                from recru.recru_tipo rt 
               where rt.id_tipo = v_cod_nivel_hierarquia
                 and rt.grupo = 'NIVEL_HIERARQUIA';
                 
              select rt.nome 
                into v_depois 
                from recru.recru_tipo rt 
               where rt.id_tipo = p_in_requisicao_perfil.cod_nivel_hierarquia
                 and rt.grupo = 'NIVEL_HIERARQUIA';
              
              insert into historico_perfil_campos
                (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo)
              values
                (v_requisicao_sq, v_usuario_sq, current_timestamp, 'Nível Hierárquico', INITCAP(v_antes), INITCAP(v_depois));
           end if; 
           
           if p_in_requisicao_perfil.cod_funcao != v_cod_funcao then
              
              select rt.nome 
                into v_antes 
                from recru.recru_funcao rt 
               where rt.id_funcao = v_cod_funcao;
                 
              select rt.nome 
                into v_depois 
                from recru.recru_funcao rt 
               where rt.id_funcao = p_in_requisicao_perfil.cod_funcao;
              
              insert into historico_perfil_campos
                (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo)
              values
                (v_requisicao_sq, v_usuario_sq, current_timestamp, 'Função', INITCAP(v_antes),INITCAP(v_depois));
           end if; 
        
        END IF;
        
        UPDATE REQUISICAO_PERFIL
        SET    COMENTARIOS          = P_IN_REQUISICAO_PERFIL.COMENTARIOS
              ,DS_FORMACAO          = P_IN_REQUISICAO_PERFIL.DS_FORMACAO
              ,EXPERIENCIA          = P_IN_REQUISICAO_PERFIL.EXPERIENCIA
              ,FAIXA_ETARIA_FIM     = P_IN_REQUISICAO_PERFIL.FAIXA_ETARIA_FIM
              ,FAIXA_ETARIA_INI     = P_IN_REQUISICAO_PERFIL.FAIXA_ETARIA_INI
              ,OUTRAS_CARATERISTICA = P_IN_REQUISICAO_PERFIL.OUTRAS_CARATERISTICA
              ,SEXO                 = P_IN_REQUISICAO_PERFIL.SEXO
              ,SQ_NIVEL             = P_IN_REQUISICAO_PERFIL.SQ_NIVEL
              ,TP_EXPERIENCIA       = P_IN_REQUISICAO_PERFIL.TP_EXPERIENCIA
              ,DSC_OPORTUNIDADE     = P_IN_REQUISICAO_PERFIL.DSC_OPORTUNIDADE
              ,DSC_ATIVIDADES_CARGO = P_IN_REQUISICAO_PERFIL.DSC_ATIVIDADES_CARGO
              ,COD_AREA             = P_IN_REQUISICAO_PERFIL.COD_AREA
              ,COD_NIVEL_HIERARQUIA = P_IN_REQUISICAO_PERFIL.COD_NIVEL_HIERARQUIA
              ,COD_FUNCAO           = P_IN_REQUISICAO_PERFIL.COD_FUNCAO
              ,DSC_EXPERIENCIA      = P_IN_REQUISICAO_PERFIL.DSC_EXPERIENCIA
              ,DSC_CONHECIMENTOS    = P_IN_REQUISICAO_PERFIL.DSC_CONHECIMENTOS
        WHERE  REQUISICAO_SQ = P_IN_REQUISICAO_PERFIL.REQUISICAO_SQ;
        
        -- Atualiza as funções adicionais no perfil
        SP_REQUISICAO_PERFIL_FUNCAO(P_IN_REQUISICAO_PERFIL.REQUISICAO_SQ, P_IN_LIST_FUNCAO);
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA REQUISICAO_PERFIL' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA REQUISICAO_PERFIL' || SQLERRM);
    END;
END SP_DML_REQUISICAO_PERFIL;
--################################ FIM DA PROCEDURE SP_DML_REQUISICAO_PERFIL #######################


--################################ INICIO DA PROCEDURE SP_DML_REQUISICAO_JORNADA #######################
PROCEDURE SP_DML_REQUISICAO_JORNADA(P_IN_DML IN NUMBER,P_IN_REQUISICAO_JORNADA IN OUT REQUISICAO_JORNADA%ROWTYPE, P_IN_CHAPA IN NUMBER) IS
 TIPO_TRANSACAO VARCHAR2(50);
 V_COD_ESCALA REQUISICAO_JORNADA.COD_ESCALA%TYPE;
 V_ID_CALENDARIO REQUISICAO_JORNADA.ID_CALENDARIO%TYPE;
 V_COD_USUARIO_SQ USUARIO.USUARIO_SQ%TYPE;
BEGIN
    BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO    ################# --
      -- ############# SE 0 FAZ INSERT   ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------
        INSERT INTO REQUISICAO_JORNADA
          (REQUISICAO_SQ
          ,COD_ESCALA
          ,ID_CALENDARIO
          ,IND_TIPO_HORARIO
          --
          ,HR_SEGUNDA_ENTRADA1
          ,HR_SEGUNDA_ENTRADA2
          ,HR_SEGUNDA_ENTRADA3
          ,HR_SEGUNDA_ENTRADA4
          ,HR_SEGUNDA_SAIDA1
          ,HR_SEGUNDA_SAIDA2
          ,HR_SEGUNDA_SAIDA3
          ,HR_SEGUNDA_SAIDA4
          --
          ,HR_TERCA_ENTRADA1
          ,HR_TERCA_ENTRADA2
          ,HR_TERCA_ENTRADA3
          ,HR_TERCA_ENTRADA4
          ,HR_TERCA_SAIDA1
          ,HR_TERCA_SAIDA2
          ,HR_TERCA_SAIDA3
          ,HR_TERCA_SAIDA4
          --
          ,HR_QUARTA_ENTRADA1
          ,HR_QUARTA_ENTRADA2
          ,HR_QUARTA_ENTRADA3
          ,HR_QUARTA_ENTRADA4
          ,HR_QUARTA_SAIDA1
          ,HR_QUARTA_SAIDA2
          ,HR_QUARTA_SAIDA3
          ,HR_QUARTA_SAIDA4
          --
          ,HR_QUINTA_ENTRADA1
          ,HR_QUINTA_ENTRADA2
          ,HR_QUINTA_ENTRADA3
          ,HR_QUINTA_ENTRADA4
          ,HR_QUINTA_SAIDA1
          ,HR_QUINTA_SAIDA2
          ,HR_QUINTA_SAIDA3
          ,HR_QUINTA_SAIDA4
          --
          ,HR_SEXTA_ENTRADA1
          ,HR_SEXTA_ENTRADA2
          ,HR_SEXTA_ENTRADA3
          ,HR_SEXTA_ENTRADA4
          ,HR_SEXTA_SAIDA1
          ,HR_SEXTA_SAIDA2
          ,HR_SEXTA_SAIDA3
          ,HR_SEXTA_SAIDA4
          --
          ,HR_SABADO_ENTRADA1
          ,HR_SABADO_ENTRADA2
          ,HR_SABADO_ENTRADA3
          ,HR_SABADO_ENTRADA4
          ,HR_SABADO_SAIDA1
          ,HR_SABADO_SAIDA2
          ,HR_SABADO_SAIDA3
          ,HR_SABADO_SAIDA4
          --
          ,HR_DOMINGO_ENTRADA1
          ,HR_DOMINGO_ENTRADA2
          ,HR_DOMINGO_ENTRADA3
          ,HR_DOMINGO_ENTRADA4
          ,HR_DOMINGO_SAIDA1
          ,HR_DOMINGO_SAIDA2
          ,HR_DOMINGO_SAIDA3
          ,HR_DOMINGO_SAIDA4)
        VALUES
          (P_IN_REQUISICAO_JORNADA.REQUISICAO_SQ
          ,P_IN_REQUISICAO_JORNADA.COD_ESCALA
          ,P_IN_REQUISICAO_JORNADA.ID_CALENDARIO
          ,P_IN_REQUISICAO_JORNADA.IND_TIPO_HORARIO
          --
          ,P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA1
          ,P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA2
          ,P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA3
          ,P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA4
          ,P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA1
          ,P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA2
          ,P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA3
          ,P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA4
          --
          ,P_IN_REQUISICAO_JORNADA.HR_TERCA_ENTRADA1
          ,P_IN_REQUISICAO_JORNADA.HR_TERCA_ENTRADA2
          ,P_IN_REQUISICAO_JORNADA.HR_TERCA_ENTRADA3
          ,P_IN_REQUISICAO_JORNADA.HR_TERCA_ENTRADA4
          ,P_IN_REQUISICAO_JORNADA.HR_TERCA_SAIDA1
          ,P_IN_REQUISICAO_JORNADA.HR_TERCA_SAIDA2
          ,P_IN_REQUISICAO_JORNADA.HR_TERCA_SAIDA3
          ,P_IN_REQUISICAO_JORNADA.HR_TERCA_SAIDA4
          --
          ,P_IN_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA1
          ,P_IN_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA2
          ,P_IN_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA3
          ,P_IN_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA4
          ,P_IN_REQUISICAO_JORNADA.HR_QUARTA_SAIDA1
          ,P_IN_REQUISICAO_JORNADA.HR_QUARTA_SAIDA2
          ,P_IN_REQUISICAO_JORNADA.HR_QUARTA_SAIDA3
          ,P_IN_REQUISICAO_JORNADA.HR_QUARTA_SAIDA4
          --
          ,P_IN_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA1
          ,P_IN_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA2
          ,P_IN_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA3
          ,P_IN_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA4
          ,P_IN_REQUISICAO_JORNADA.HR_QUINTA_SAIDA1
          ,P_IN_REQUISICAO_JORNADA.HR_QUINTA_SAIDA2
          ,P_IN_REQUISICAO_JORNADA.HR_QUINTA_SAIDA3
          ,P_IN_REQUISICAO_JORNADA.HR_QUINTA_SAIDA4
          --
          ,P_IN_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA1
          ,P_IN_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA2
          ,P_IN_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA3
          ,P_IN_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA4
          ,P_IN_REQUISICAO_JORNADA.HR_SEXTA_SAIDA1
          ,P_IN_REQUISICAO_JORNADA.HR_SEXTA_SAIDA2
          ,P_IN_REQUISICAO_JORNADA.HR_SEXTA_SAIDA3
          ,P_IN_REQUISICAO_JORNADA.HR_SEXTA_SAIDA4
          --
          ,P_IN_REQUISICAO_JORNADA.HR_SABADO_ENTRADA1
          ,P_IN_REQUISICAO_JORNADA.HR_SABADO_ENTRADA2
          ,P_IN_REQUISICAO_JORNADA.HR_SABADO_ENTRADA3
          ,P_IN_REQUISICAO_JORNADA.HR_SABADO_ENTRADA4
          ,P_IN_REQUISICAO_JORNADA.HR_SABADO_SAIDA1
          ,P_IN_REQUISICAO_JORNADA.HR_SABADO_SAIDA2
          ,P_IN_REQUISICAO_JORNADA.HR_SABADO_SAIDA3
          ,P_IN_REQUISICAO_JORNADA.HR_SABADO_SAIDA4
          --
          ,P_IN_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA1
          ,P_IN_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA2
          ,P_IN_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA3
          ,P_IN_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA4
          ,P_IN_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA1
          ,P_IN_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA2
          ,P_IN_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA3
          ,P_IN_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA4);
        -----------------------------------------------------

        -- ############# SE 1 FAZ UPDATE   ################# --
      ELSIF (P_IN_DML > 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'UPDATE';
        -----------------------------------------------------
        
        SELECT DISTINCT (T.COD_ESCALA)
          INTO V_COD_ESCALA
          FROM REQUISICAO_JORNADA T
         WHERE T.REQUISICAO_SQ = P_IN_REQUISICAO_JORNADA.REQUISICAO_SQ;
         
        SELECT DISTINCT (T.ID_CALENDARIO)
          INTO V_ID_CALENDARIO
          FROM REQUISICAO_JORNADA T
         WHERE T.REQUISICAO_SQ = P_IN_REQUISICAO_JORNADA.REQUISICAO_SQ;
         
         SELECT DISTINCT (T.USUARIO_SQ)
           INTO V_COD_USUARIO_SQ
           FROM USUARIO T
          WHERE T.IDENTIFICACAO = P_IN_CHAPA;
        
        IF NVL(V_COD_ESCALA, -1)  != P_IN_REQUISICAO_JORNADA.COD_ESCALA THEN
          insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
          (P_IN_REQUISICAO_JORNADA.REQUISICAO_SQ, V_COD_USUARIO_SQ, current_timestamp, 'Código de escala', V_COD_ESCALA,P_IN_REQUISICAO_JORNADA.COD_ESCALA);
        END IF;  
        
        IF NVL(V_ID_CALENDARIO, -1) != P_IN_REQUISICAO_JORNADA.ID_CALENDARIO THEN
          insert into historico_perfil_campos (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo) values
          (P_IN_REQUISICAO_JORNADA.REQUISICAO_SQ, V_COD_USUARIO_SQ, current_timestamp, 'Id calendário', V_ID_CALENDARIO,P_IN_REQUISICAO_JORNADA.ID_CALENDARIO);
        END IF;                         
        
        UPDATE REQUISICAO_JORNADA
        SET    COD_ESCALA       = P_IN_REQUISICAO_JORNADA.COD_ESCALA
              ,IND_TIPO_HORARIO = P_IN_REQUISICAO_JORNADA.IND_TIPO_HORARIO
              ,ID_CALENDARIO    = P_IN_REQUISICAO_JORNADA.ID_CALENDARIO              
              --
              ,HR_SEGUNDA_ENTRADA1 = P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA1
              ,HR_SEGUNDA_ENTRADA2 = P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA2
              ,HR_SEGUNDA_ENTRADA3 = P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA3
              ,HR_SEGUNDA_ENTRADA4 = P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA4
              ,HR_SEGUNDA_SAIDA1   = P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA1
              ,HR_SEGUNDA_SAIDA2   = P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA2
              ,HR_SEGUNDA_SAIDA3   = P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA3
              ,HR_SEGUNDA_SAIDA4   = P_IN_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA4
              --
              ,HR_TERCA_ENTRADA1   = P_IN_REQUISICAO_JORNADA.HR_TERCA_ENTRADA1
              ,HR_TERCA_ENTRADA2   = P_IN_REQUISICAO_JORNADA.HR_TERCA_ENTRADA2
              ,HR_TERCA_ENTRADA3   = P_IN_REQUISICAO_JORNADA.HR_TERCA_ENTRADA3
              ,HR_TERCA_ENTRADA4   = P_IN_REQUISICAO_JORNADA.HR_TERCA_ENTRADA4
              ,HR_TERCA_SAIDA1     = P_IN_REQUISICAO_JORNADA.HR_TERCA_SAIDA1
              ,HR_TERCA_SAIDA2     = P_IN_REQUISICAO_JORNADA.HR_TERCA_SAIDA2
              ,HR_TERCA_SAIDA3     = P_IN_REQUISICAO_JORNADA.HR_TERCA_SAIDA3
              ,HR_TERCA_SAIDA4     = P_IN_REQUISICAO_JORNADA.HR_TERCA_SAIDA4
              --
              ,HR_QUARTA_ENTRADA1  = P_IN_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA1
              ,HR_QUARTA_ENTRADA2  = P_IN_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA2
              ,HR_QUARTA_ENTRADA3  = P_IN_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA3
              ,HR_QUARTA_ENTRADA4  = P_IN_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA4
              ,HR_QUARTA_SAIDA1    = P_IN_REQUISICAO_JORNADA.HR_QUARTA_SAIDA1
              ,HR_QUARTA_SAIDA2    = P_IN_REQUISICAO_JORNADA.HR_QUARTA_SAIDA2
              ,HR_QUARTA_SAIDA3    = P_IN_REQUISICAO_JORNADA.HR_QUARTA_SAIDA3
              ,HR_QUARTA_SAIDA4    = P_IN_REQUISICAO_JORNADA.HR_QUARTA_SAIDA4
              --
              ,HR_QUINTA_ENTRADA1  = P_IN_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA1
              ,HR_QUINTA_ENTRADA2  = P_IN_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA2
              ,HR_QUINTA_ENTRADA3  = P_IN_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA3
              ,HR_QUINTA_ENTRADA4  = P_IN_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA4
              ,HR_QUINTA_SAIDA1    = P_IN_REQUISICAO_JORNADA.HR_QUINTA_SAIDA1
              ,HR_QUINTA_SAIDA2    = P_IN_REQUISICAO_JORNADA.HR_QUINTA_SAIDA2
              ,HR_QUINTA_SAIDA3    = P_IN_REQUISICAO_JORNADA.HR_QUINTA_SAIDA3
              ,HR_QUINTA_SAIDA4    = P_IN_REQUISICAO_JORNADA.HR_QUINTA_SAIDA4
              --
              ,HR_SEXTA_ENTRADA1   = P_IN_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA1
              ,HR_SEXTA_ENTRADA2   = P_IN_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA2
              ,HR_SEXTA_ENTRADA3   = P_IN_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA3
              ,HR_SEXTA_ENTRADA4   = P_IN_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA4
              ,HR_SEXTA_SAIDA1     = P_IN_REQUISICAO_JORNADA.HR_SEXTA_SAIDA1
              ,HR_SEXTA_SAIDA2     = P_IN_REQUISICAO_JORNADA.HR_SEXTA_SAIDA2
              ,HR_SEXTA_SAIDA3     = P_IN_REQUISICAO_JORNADA.HR_SEXTA_SAIDA3
              ,HR_SEXTA_SAIDA4     = P_IN_REQUISICAO_JORNADA.HR_SEXTA_SAIDA4
              --
              ,HR_SABADO_ENTRADA1  = P_IN_REQUISICAO_JORNADA.HR_SABADO_ENTRADA1
              ,HR_SABADO_ENTRADA2  = P_IN_REQUISICAO_JORNADA.HR_SABADO_ENTRADA2
              ,HR_SABADO_ENTRADA3  = P_IN_REQUISICAO_JORNADA.HR_SABADO_ENTRADA3
              ,HR_SABADO_ENTRADA4  = P_IN_REQUISICAO_JORNADA.HR_SABADO_ENTRADA4
              ,HR_SABADO_SAIDA1    = P_IN_REQUISICAO_JORNADA.HR_SABADO_SAIDA1
              ,HR_SABADO_SAIDA2    = P_IN_REQUISICAO_JORNADA.HR_SABADO_SAIDA2
              ,HR_SABADO_SAIDA3    = P_IN_REQUISICAO_JORNADA.HR_SABADO_SAIDA3
              ,HR_SABADO_SAIDA4    = P_IN_REQUISICAO_JORNADA.HR_SABADO_SAIDA4
              --
              ,HR_DOMINGO_ENTRADA1 = P_IN_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA1
              ,HR_DOMINGO_ENTRADA2 = P_IN_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA2
              ,HR_DOMINGO_ENTRADA3 = P_IN_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA3
              ,HR_DOMINGO_ENTRADA4 = P_IN_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA4
              ,HR_DOMINGO_SAIDA1   = P_IN_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA1
              ,HR_DOMINGO_SAIDA2   = P_IN_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA2
              ,HR_DOMINGO_SAIDA3   = P_IN_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA3
              ,HR_DOMINGO_SAIDA4   = P_IN_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA4  
        WHERE  REQUISICAO_SQ    = P_IN_REQUISICAO_JORNADA.REQUISICAO_SQ;
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA REQUISICAO_JORNADA' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA REQUISICAO_JORNADA' || SQLERRM);
    END;
END SP_DML_REQUISICAO_JORNADA;
--################################ FIM DA PROCEDURE SP_DML_REQUISICAO_JORNADA #######################

--################################ INICIO DA PROCEDURE SP_DML_USUARIO_AVISO #######################
PROCEDURE SP_DML_USUARIO_AVISO(P_IN_DML IN NUMBER,P_IN_USUARIO_AVISO IN OUT USUARIO_AVISO%ROWTYPE,P_IN_USUARIO IN VARCHAR2) IS
 TIPO_TRANSACAO VARCHAR2(50);
BEGIN
    BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO   ################# --
      -- ############# SE 0 FAZ INSERT   ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------
        INSERT INTO USUARIO_AVISO
          (CHAPA
          ,COD_TIPO_AVISO
          ,USER_LOG)
        VALUES
          (P_IN_USUARIO_AVISO.CHAPA
          ,P_IN_USUARIO_AVISO.COD_TIPO_AVISO
          ,P_IN_USUARIO);
        -----------------------------------------------------

      -- ############# SE -1 FAZ DELETE   ################# --
      ELSE
        -----------------------------------------------------
        TIPO_TRANSACAO := 'DELETE';
        -----------------------------------------------------
        DELETE FROM USUARIO_AVISO WHERE CHAPA = P_IN_USUARIO_AVISO.CHAPA;

      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA USUARIO_AVISO' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA USUARIO_AVISO' || SQLERRM);
    END;
END SP_DML_USUARIO_AVISO;
--################################ FIM DA PROCEDURE SP_DML_USUARIO_AVISO #######################


--################################ INICIO DA PROCEDURE SP_DML_REQUISICAO_BAIXA #######################
PROCEDURE SP_DML_REQUISICAO_BAIXA(P_IN_DML IN NUMBER,P_IN_REQUISICAO_BAIXA IN OUT REQUISICAO_BAIXA%ROWTYPE,P_IN_USUARIO IN VARCHAR2) IS
 TIPO_TRANSACAO VARCHAR2(50);
 --V_QTD_BAIXA    NUMBER;
 V_TIPO_RP      VARCHAR2(1);

BEGIN
    BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO  ################# --
      -- ############# SE 0 FAZ INSERT ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------
        -- CARREGANDO O TIPO DA RP
        -----------------------------------------------------        
        SELECT R.IND_TIPO_REQUISICAO
        INTO   V_TIPO_RP
        FROM   REQUISICAO R
        WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_BAIXA.REQUISICAO_SQ;

        -----------------------------------------------------        
        -- VALIDANDO BAIXA DE ACORDO COM O TIPO DE RECRUTAMENTO
        -----------------------------------------------------
        /*IF (V_TIPO_RP = 'A') THEN
          -- Requisição de Admissão (Recrutamento Externo ou Misto)
          -- Verifica se o id do funcionario ja esta em uma baixa
          SELECT COUNT(*)
          INTO   V_QTD_BAIXA
          FROM   REQUISICAO_BAIXA RB
                ,REQUISICAO       R
          WHERE  RB.FUNCIONARIO_ID = P_IN_REQUISICAO_BAIXA.FUNCIONARIO_ID
          AND    R.REQUISICAO_SQ   = RB.REQUISICAO_SQ
          AND    R.TP_CONTRATACAO  = 1; -- TIPO DE CONTRATAÇÃO = PRAZO INDETERMINADO   
          
        ELSE 
          -- Requisição de Transferencia (Recrutamento Interno)
          -- Baixas sem restrições de quantidade
          V_QTD_BAIXA := 0;        
        END IF;

        -----------------------------------------------------
        IF (V_QTD_BAIXA = 0) THEN*/
          -----------------------------------------------------
          -- ALTERANDO O STATUS DA REQUISIÇÃO
          -----------------------------------------------------
          UPDATE REQUISICAO R
          SET    R.COD_STATUS    = 6 -- STATUS: BAIXADA
          WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_BAIXA.REQUISICAO_SQ;

          ---------------------------------------------------
          -- INSERINDO O ID DO FUNCIONARIO BAIXADO
          ---------------------------------------------------
          INSERT INTO REQUISICAO_BAIXA
            (REQUISICAO_SQ
            ,FUNCIONARIO_ID)
          VALUES
            (P_IN_REQUISICAO_BAIXA.REQUISICAO_SQ
            ,P_IN_REQUISICAO_BAIXA.FUNCIONARIO_ID);

          -----------------------------------------------------
          -- GRAVANDO NO HISTORICO
          ------------------------------------------------------
          INSERT INTO HISTORICO_REQUISICAO
            (REQUISICAO_SQ
            ,COD_UNIDADE
            ,DT_ENVIO
            ,USUARIO_SQ
            ,STATUS)
          VALUES
            (P_IN_REQUISICAO_BAIXA.REQUISICAO_SQ
            ,F_GET_UO_USUARIO_SQ(P_IN_USUARIO)
            ,CURRENT_TIMESTAMP--SYSDATE
            ,P_IN_USUARIO
            ,'deu baixa');
          -----------------------------------------------------
        /*ELSE
          -- caso o id ja esteja baixado retorna -1
          P_IN_REQUISICAO_BAIXA.FUNCIONARIO_ID := -1;
        END IF;*/
        -----------------------------------------------------
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA REQUISICAO_BAIXA' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA REQUISICAO_BAIXA' || SQLERRM);
    END;
END SP_DML_REQUISICAO_BAIXA;
--################################ FIM DA PROCEDURE SP_DML_REQUISICAO_BAIXA #######################


--################################ INICIO DA PROCEDURE SP_DML_REQUISICAO_ESTORNO #######################
PROCEDURE SP_DML_REQUISICAO_ESTORNO(P_IN_DML IN NUMBER,P_IN_REQUISICAO_ESTORNO IN OUT HISTORICO_REQUISICAO%ROWTYPE,P_IN_USUARIO IN VARCHAR2,P_IN_IND_TIPO_ESTORNO IN VARCHAR2) IS
 TIPO_TRANSACAO  VARCHAR2(50);
 V_COD_STATUS    NUMBER;
 V_UO_APR        VARCHAR2(4);

BEGIN
   BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO   ################# --
      -- ############# SE 0 FAZ INSERT   ################# --
      IF (P_IN_DML = 1) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'UPDATE (ESTORNO)';
        -----------------------------------------------------
        -- VERIFICANDO O TIPO DE ESTORNO
        -- (S)imples / (R)evisão        
        -----------------------------------------------------        
        IF (P_IN_IND_TIPO_ESTORNO = 'S') THEN
          -----------------------------------------------------
          -- ESTORNO SIMPLES (RP encaminhada para última ação no WorkFlow)
          -- RESGATANDO OS DADOS DO NÍVEL ANTERIOR DO HISTÓRICO
          -----------------------------------------------------
          BEGIN
            SELECT H.REQUISICAO_SQ
                  ,H.COD_UNIDADE
                  ,H.DT_ENVIO
                  ,H.USUARIO_SQ
                  ,H.STATUS
                  ,H.UNIDADE_ATUAL_USUARIO
                  ,H.NIVEL
                  ,RS.COD_STATUS
            INTO   P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ
                  ,P_IN_REQUISICAO_ESTORNO.COD_UNIDADE
                  ,P_IN_REQUISICAO_ESTORNO.DT_ENVIO
                  ,P_IN_REQUISICAO_ESTORNO.USUARIO_SQ
                  ,P_IN_REQUISICAO_ESTORNO.STATUS
                  ,P_IN_REQUISICAO_ESTORNO.UNIDADE_ATUAL_USUARIO
                  ,P_IN_REQUISICAO_ESTORNO.NIVEL
                  ,V_COD_STATUS
            FROM   HISTORICO_REQUISICAO H
                  ,REQUISICAO_STATUS    RS
            WHERE  H.REQUISICAO_SQ = P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ
            AND    H.DT_ENVIO =
                   (SELECT MAX(H1.DT_ENVIO) ATUAL
                     FROM   HISTORICO_REQUISICAO H1
                     WHERE  H1.REQUISICAO_SQ = H.REQUISICAO_SQ
                     AND    H1.DT_ENVIO <
                            (SELECT MAX(H2.DT_ENVIO) ATUAL
                              FROM   HISTORICO_REQUISICAO H2
                              WHERE  H2.REQUISICAO_SQ = H1.REQUISICAO_SQ))
  
            AND    DECODE(H.STATUS,'criou','ABERTA'
                                  ,'homologou','EM HOMOLOGAÇÃO'
                                  ,'revisou','EM HOMOLOGAÇÃO'
                                  ,'em revisão','EM REVISÃO'
                                  ,'aprovou','APROVADA'
                                  ,'reprovou','REPROVADA'
                                  ,'deu baixa','BAIXADA'
                                  ,'excluiu','CANCELADA'
                                  ,'solicitou revisão','EM REVISÃO'
                                  ,'expirada','EXPIRADA'
                                  ,NULL) = RS.DSC_STATUS;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ROLLBACK;
              -- Indica que a requisição não pode ser estornada
              P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ := -1;
          END;
          
        ELSE
          BEGIN        
            -----------------------------------------------------
            -- ESTORNO PARA REVISÃO (RP encaminhada para GEP - AP&B)
            -- RESGATANDO A UNIDADE APROVADORA
            -----------------------------------------------------
            SELECT S.VLR_SISTEMA_PARAMETRO
            INTO   V_UO_APR
            FROM   SYN_SISTEMA_PARAMETRO S
            WHERE  S.COD_SISTEMA   = 7
            AND    S.NOM_PARAMETRO = 'UNIDADE_APROVADORA';          
  
            -----------------------------------------------------
            -- RESGATANDO A UNIDADE DA RP
            -----------------------------------------------------
            SELECT R.COD_UNIDADE 
            INTO   P_IN_REQUISICAO_ESTORNO.COD_UNIDADE
            FROM   REQUISICAO R
            WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ;
            
            -----------------------------------------------------
            -- VERIFICA SE A RP PERTENCE A UNIDADE APROVADORA
            -----------------------------------------------------          
            IF (V_UO_APR = P_IN_REQUISICAO_ESTORNO.COD_UNIDADE) THEN
              -- Seta RP para nível de homologação GEP - AP&B 
              SELECT H.REQUISICAO_SQ
                    ,H.COD_UNIDADE
                    ,H.DT_ENVIO
                    ,H.USUARIO_SQ
                    ,H.STATUS
                    ,H.UNIDADE_ATUAL_USUARIO
                    ,2 -- RP direcionada para AP&B
                    ,2 -- STATUS: HOMOLOGAÇÃO
              INTO   P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ
                    ,P_IN_REQUISICAO_ESTORNO.COD_UNIDADE
                    ,P_IN_REQUISICAO_ESTORNO.DT_ENVIO
                    ,P_IN_REQUISICAO_ESTORNO.USUARIO_SQ
                    ,P_IN_REQUISICAO_ESTORNO.STATUS
                    ,P_IN_REQUISICAO_ESTORNO.UNIDADE_ATUAL_USUARIO
                    ,P_IN_REQUISICAO_ESTORNO.NIVEL
                    ,V_COD_STATUS                  
              FROM   HISTORICO_REQUISICAO H
              WHERE  H.REQUISICAO_SQ = P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ
              AND    H.DT_ENVIO =
                     (SELECT MIN(H1.DT_ENVIO) ATUAL
                       FROM   HISTORICO_REQUISICAO H1
                       WHERE  H1.REQUISICAO_SQ = H.REQUISICAO_SQ);           
            ELSE
              -- Seta RP para nível de revisão, configura para último status de homologador de unidade
              SELECT H.REQUISICAO_SQ
                    ,H.COD_UNIDADE
                    ,H.DT_ENVIO
                    ,H.USUARIO_SQ
                    ,H.STATUS
                    ,H.UNIDADE_ATUAL_USUARIO
                    ,H.NIVEL
                    ,2 -- STATUS: HOMOLOGAÇÃO
              INTO   P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ
                    ,P_IN_REQUISICAO_ESTORNO.COD_UNIDADE
                    ,P_IN_REQUISICAO_ESTORNO.DT_ENVIO
                    ,P_IN_REQUISICAO_ESTORNO.USUARIO_SQ
                    ,P_IN_REQUISICAO_ESTORNO.STATUS
                    ,P_IN_REQUISICAO_ESTORNO.UNIDADE_ATUAL_USUARIO
                    ,P_IN_REQUISICAO_ESTORNO.NIVEL
                    ,V_COD_STATUS
              FROM   HISTORICO_REQUISICAO H
                    ,REQUISICAO_STATUS    RS
              WHERE  H.REQUISICAO_SQ = P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ
              AND    H.DT_ENVIO =
                     (SELECT MAX(H1.DT_ENVIO) ATUAL
                       FROM   HISTORICO_REQUISICAO H1
                       WHERE  H1.REQUISICAO_SQ = H.REQUISICAO_SQ
                       AND    H1.NIVEL = 3
                       AND    H1.STATUS NOT IN ('estornou', 'estorno revisão')) -- WORKFLOW NÍVEL 2: APROVAÇÃO DO GERENTE => HOMOLOGADOR GEP - AP&B
    
              AND    DECODE(H.STATUS,'criou','ABERTA'
                                    ,'homologou','EM HOMOLOGAÇÃO'
                                    ,'revisou','EM HOMOLOGAÇÃO'
                                    ,'em revisão','EM REVISÃO'
                                    ,'aprovou','APROVADA'
                                    ,'reprovou','REPROVADA'
                                    ,'deu baixa','BAIXADA'
                                    ,'excluiu','CANCELADA'
                                    ,'solicitou revisão','EM REVISÃO'
                                    ,'expirada','EXPIRADA'
                                    ,NULL) = RS.DSC_STATUS;     
            END IF;
            
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ROLLBACK;
              -- Indica que a requisição não pode ser estornada para revisão
              P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ := -2;
          END;            
        END IF;
        
        -----------------------------------------------------
        -- COMPLEMENTAÇÔES NO ESTORNO
        -----------------------------------------------------
        IF (P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ > 0) THEN
          -----------------------------------------------------
          -- ALTERANDO O STATUS DA REQUISIÇÃO
          -----------------------------------------------------
          UPDATE REQUISICAO R
          SET    R.COD_STATUS    = V_COD_STATUS
          WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ;

          -----------------------------------------------------
          -- REMOVENDO DADOS DE TABELAS AUXILIARES
          -----------------------------------------------------
          DELETE FROM REQUISICAO_BAIXA RB
          WHERE  RB.REQUISICAO_SQ = P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ;
          -----------------------------------------------------
          DELETE FROM REQUISICAO_REPROVADA RP
          WHERE  RP.REQUISICAO_SQ = P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ;
          -----------------------------------------------------
          DELETE FROM REQUISICAO_EXCLUIDA RE
          WHERE  RE.REQUISICAO_SQ = P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ;
          
          -----------------------------------------------------
          -- GRAVANDO NO HISTÓRICO
          -----------------------------------------------------
          -- estorno
          INSERT INTO HISTORICO_REQUISICAO
            (REQUISICAO_SQ
            ,DT_ENVIO
            ,USUARIO_SQ
            ,STATUS
            ,UNIDADE_ATUAL_USUARIO
            ,COD_UNIDADE
            ,NIVEL)
          VALUES
            (P_IN_REQUISICAO_ESTORNO.REQUISICAO_SQ
            ,CURRENT_TIMESTAMP--SYSDATE
            ,P_IN_USUARIO
            ,DECODE(P_IN_IND_TIPO_ESTORNO, 'R'
                                         , 'estorno revisão'
                                         , 'estornou ')
            ,F_GET_UO_USUARIO_SQ(P_IN_USUARIO)
            ,P_IN_REQUISICAO_ESTORNO.COD_UNIDADE
            ,P_IN_REQUISICAO_ESTORNO.NIVEL);
        END IF;
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || 'OPÇÃO: '|| P_IN_IND_TIPO_ESTORNO || ' NA TABELA REQUISICAO' ||SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA AO FAZER ' || TIPO_TRANSACAO ||' NA TABELA REQUISICAO' || SQLERRM);
    END;
END SP_DML_REQUISICAO_ESTORNO;
--################################ FIM DA PROCEDURE SP_DML_REQUISICAO_ESTORNO #######################


--################################ INICIO DA PROCEDURE SP_DML_REQUISICAO_REVISAO #######################
PROCEDURE SP_DML_REQUISICAO_REVISAO(P_IN_DML IN NUMBER,P_IN_REQUISICAO_REVISAO IN OUT REQUISICAO_REVISAO%ROWTYPE,P_IN_USUARIO IN VARCHAR2, P_IN_PERFIL_HOM IN NUMBER, P_IN_CHAPA IN VARCHAR2) IS
 TIPO_TRANSACAO   VARCHAR2(50);
 V_NRO_REVISAO    NUMBER;
 V_STATUS_RP      NUMBER;
 V_UO_APR         VARCHAR2(5);
 V_UO_RP          VARCHAR2(5);
 V_NIVEL_WORKFLOW NUMBER;
 V_QTD_HOM_GEP    NUMBER;
 V_QTD_HOM_NEC    NUMBER; 

BEGIN
    BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO   ################# --
      -- ############# SE 0 FAZ INSERT   ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------
        -- RESGATANDO A QUANTIDADE DE REVISÕES DA REQUISIÇÃO
        -----------------------------------------------------
        SELECT COUNT(*) + 1
        INTO   V_NRO_REVISAO
        FROM   REQUISICAO_REVISAO R
        WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ;

        -----------------------------------------------------
        -- INSERINDO OS DADOS NA TABELA DE REVISÕES
        -----------------------------------------------------
        INSERT INTO REQUISICAO_REVISAO
          (REQUISICAO_SQ
          ,NRO_REVISAO
          ,STATUS
          ,MOTIVO)
        VALUES
          (P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ
          ,V_NRO_REVISAO
          ,'aberta'
          ,P_IN_REQUISICAO_REVISAO.MOTIVO);

        -----------------------------------------------------
        -- ALTERANDO O STATUS DA REQUISIÇÃO
        -----------------------------------------------------
        UPDATE REQUISICAO R
        SET    R.COD_STATUS = 3 -- STATUS: EM REVISÃO
        WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ;

        -----------------------------------------------------
        -- GRAVANDO NO HISTORICO
        -----------------------------------------------------
        INSERT INTO HISTORICO_REQUISICAO
          (REQUISICAO_SQ
          ,COD_UNIDADE
          ,DT_ENVIO
          ,USUARIO_SQ
          ,STATUS
          ,UNIDADE_ATUAL_USUARIO
          ,NIVEL)
        VALUES
          (P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ
          ,F_GET_UO_REQUISICAO(P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ)
          ,CURRENT_TIMESTAMP--SYSDATE
          ,P_IN_USUARIO
          ,'solicitou revisão'
          ,F_GET_UO_USUARIO_SQ(P_IN_USUARIO)
          ,0);
          
         insert into historico_perfil_campos
           (requisicao_sq, usuario_sq, dt_envio, campo, conteudo_anterior, conteudo_novo)
         values
           (P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ, P_IN_USUARIO, current_timestamp, 'Solicitou a revisão: ' || P_IN_REQUISICAO_REVISAO.MOTIVO, null, null);         

        -----------------------------------------------------

        -- ############# SE 1 FAZ UPDATE   ################# --
      ELSIF (P_IN_DML > 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'UPDATE';
        -----------------------------------------------------
        -- RESGATANDO O STATUS ATUAL E UNIDADE DA REQUISICAO
        -----------------------------------------------------
        SELECT R.COD_STATUS
              ,R.COD_UNIDADE
        INTO   V_STATUS_RP
              ,V_UO_RP
        FROM   REQUISICAO R
        WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ;

        -- VERIFICANDO SE A RP JA FOI REVISADA (3 - EM REVISÃO)
        IF (V_STATUS_RP = 3) THEN
          -----------------------------------------------------
          -- CARREGANDO PARAMETROS
          -----------------------------------------------------
          SELECT S.VLR_SISTEMA_PARAMETRO
          INTO   V_UO_APR
          FROM   SYN_SISTEMA_PARAMETRO S
          WHERE  S.COD_SISTEMA   = 7
          AND    S.NOM_PARAMETRO = 'UNIDADE_APROVADORA';

          -- Verifica se o usuario e Homologador GEP - AP&B
          SELECT COUNT(*)
          INTO   V_QTD_HOM_GEP
          FROM   SYN_SISTEMA_PARAMETRO S
          WHERE  S.COD_SISTEMA           = 7
          AND    S.NOM_PARAMETRO         = 'HOMOLOGADOR_GEP'
          AND    S.VLR_SISTEMA_PARAMETRO = P_IN_CHAPA;
          
          -- Verifica se o usuario e Homologador GEP - NEC
          SELECT COUNT(*)
          INTO   V_QTD_HOM_NEC
          FROM   GRUPO_NEC_USUARIOS G
          WHERE  G.CHAPA = P_IN_CHAPA;

          -----------------------------------------------------
          -- VERIFICA SE A RP E DA UNIDADE APROVADORA
          -----------------------------------------------------
          -- Caso a revisão esteja sendo feita por um usuario de CRIAÇÃO da GEP ou por um GERENTE de UO, sobe o nivel
          IF (V_UO_RP = V_UO_APR OR P_IN_PERFIL_HOM = 1) THEN
             V_NIVEL_WORKFLOW := 2; -- HOMOLOGADOR GEP - AP&B
             V_STATUS_RP := 2; -- EM HOMOLOGAÇÃO
          ELSE
             V_NIVEL_WORKFLOW := 1; -- HOMOLOGADOR UO
             V_STATUS_RP := 1; -- ABERTA
          END IF;

          -- Caso a revisão esteja sendo feita pelo HOMOLOGADOR GEP - AP&B, sobre de nivel
          IF (V_QTD_HOM_GEP > 0) THEN
             V_NIVEL_WORKFLOW := 3; -- HOMOLOGADOR GEP - NEC
             V_STATUS_RP := 2; -- EM HOMOLOGAÇÃO
          END IF;
          
          -- Caso a revisão esteja sendo feita pelo HOMOLOGADOR GEP - NEC, desce de nivel
          IF (V_QTD_HOM_NEC > 0) THEN
             V_NIVEL_WORKFLOW := 2; -- HOMOLOGADOR GEP - AP&B
             V_STATUS_RP := 2; -- EM HOMOLOGAÇÃO
          END IF;          

          -----------------------------------------------------
          -- ATUALIZANDO DADOS NA TABELA DE REVISÕES
          -----------------------------------------------------
          UPDATE REQUISICAO_REVISAO
          SET    STATUS = 'fechada'
          WHERE  REQUISICAO_SQ = P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ;

          -----------------------------------------------------
          -- ALTERANDO O STATUS DA REQUISIÇÃO
          -----------------------------------------------------
          UPDATE REQUISICAO R
          SET    R.COD_STATUS    = V_STATUS_RP
          WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ;

          -----------------------------------------------------
          -- GRAVANDO NO HISTORICO
          -----------------------------------------------------
          IF (P_IN_PERFIL_HOM = 1 OR V_QTD_HOM_GEP > 0 OR V_QTD_HOM_NEC > 0) THEN
            -- Gravando dados no historio de uma revisão de GERENTE DE UNIDADE ou HOMOLOGADOR GEP
            INSERT INTO HISTORICO_REQUISICAO
              (REQUISICAO_SQ
              ,COD_UNIDADE
              ,DT_ENVIO
              ,USUARIO_SQ
              ,STATUS
              ,UNIDADE_ATUAL_USUARIO
              ,NIVEL)
            VALUES
              (P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ
              ,F_GET_UO_REQUISICAO(P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ)
              ,CURRENT_TIMESTAMP + INTERVAL '1' SECOND
               --SYSDATE +  + INTERVAL '1' MINUTE
              ,P_IN_USUARIO
              ,'revisou'
              ,F_GET_UO_USUARIO_SQ(P_IN_USUARIO)
              ,1);
            --
            INSERT INTO HISTORICO_REQUISICAO
              (REQUISICAO_SQ
              ,COD_UNIDADE
              ,DT_ENVIO
              ,USUARIO_SQ
              ,STATUS
              ,UNIDADE_ATUAL_USUARIO
              ,NIVEL)
            VALUES
              (P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ
              ,F_GET_UO_REQUISICAO(P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ)
              ,CURRENT_TIMESTAMP + INTERVAL '2' SECOND  --SYSDATE + INTERVAL '2' MINUTE --Diferenca de 2 minuto
              ,P_IN_USUARIO
              ,'homologou'
              ,F_GET_UO_USUARIO_SQ(P_IN_USUARIO)
              ,V_NIVEL_WORKFLOW);

          ELSE
            -- Gravando dados no historio de uma revisão de CRIADOR
            INSERT INTO HISTORICO_REQUISICAO
              (REQUISICAO_SQ
              ,COD_UNIDADE
              ,DT_ENVIO
              ,USUARIO_SQ
              ,STATUS
              ,UNIDADE_ATUAL_USUARIO
              ,NIVEL)
            VALUES
              (P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ
              ,F_GET_UO_REQUISICAO(P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ)
              ,CURRENT_TIMESTAMP + INTERVAL '1' SECOND--SYSDATE + INTERVAL '1' MINUTE
              ,P_IN_USUARIO
              ,'revisou'
              ,F_GET_UO_USUARIO_SQ(P_IN_USUARIO)
              ,V_NIVEL_WORKFLOW);
          END IF;
          -----------------------------------------------------
        ELSE
            P_IN_REQUISICAO_REVISAO.REQUISICAO_SQ := -1;
        END IF;

        -- ############# SE -1 FAZ DELETE   ################# --
      ELSE
        -----------------------------------------------------
        TIPO_TRANSACAO := 'DELETE';
        -----------------------------------------------------
        NULL;

      END IF;
      
      
      insert into debug values('revisao');

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' ||TIPO_TRANSACAO ||' NA TABELA REQUISICAO_REVISAO' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA AO FAZER ' || TIPO_TRANSACAO ||' NA TABELA REQUISICAO_REVISAO' || SQLERRM);
    END;
END SP_DML_REQUISICAO_REVISAO;
--################################ FIM DA PROCEDURE SP_DML_REQUISICAO_REVISAO #######################


--################################ INICIO DA PROCEDURE SP_DML_REQUISICAO_HOMOLOGACAO #######################
PROCEDURE SP_DML_REQUISICAO_HOMOLOGACAO(P_IN_TIPO IN VARCHAR2, P_IN_REQUISICAO IN HISTORICO_REQUISICAO%ROWTYPE, P_IN_USUARIO IN VARCHAR2, P_IN_DSC_MOTIVO IN VARCHAR2) IS
 TIPO_TRANSACAO VARCHAR2(50);
 V_NIVEL        NUMBER := P_IN_REQUISICAO.NIVEL;
 V_QTD          NUMBER := 0;
 V_CHAPA        INTEGER;
 V_USUARIO_SQ   INTEGER;
 V_PERFIL       INTEGER;
 
BEGIN
    BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO    ################# --
      IF (P_IN_TIPO = 'A') THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'APROVAÇÃO PELO HOMOLOGADOR';
        -----------------------------------------------------
        -- ALTERANDO O STATUS DA REQUISIÇÃO
        -----------------------------------------------------
        UPDATE REQUISICAO R
        SET    R.COD_STATUS = 2 -- STATUS: EM HOMOLOGAÇÃO
        WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO.REQUISICAO_SQ;
        
        
        
/*        
        -----------------------------------------------------
        -- REGRA DE PULAR NIVEL
        -- Quando uma RP e criada pelo NEC for homologada pela AP&B, deve ser encaminhada para o APR-GEP (Laercio)
        -----------------------------------------------------        
        SELECT COUNT(*) QTD
        INTO   V_QTD
        FROM   HISTORICO_REQUISICAO H
              ,GRUPO_NEC_USUARIOS   G
              ,USUARIO              U
        WHERE  H.REQUISICAO_SQ = P_IN_REQUISICAO.REQUISICAO_SQ
        AND    G.CHAPA         = U.IDENTIFICACAO
        AND    U.USUARIO_SQ    = H.USUARIO_SQ
        AND    H.DT_ENVIO      = (SELECT MAX(H1.DT_ENVIO)
                                  FROM   HISTORICO_REQUISICAO H1
                                  WHERE  H1.REQUISICAO_SQ = H.REQUISICAO_SQ AND STATUS<>'alterou');
                                  
        IF (V_QTD > 0) THEN
           V_NIVEL := 4;        
        END IF;                                  
*/  
        --VERIFICA O CRIADOR DA REQUISICAO
        SELECT R.USUARIO_SQ
          INTO V_USUARIO_SQ
          FROM REQPES.REQUISICAO R
         WHERE R.REQUISICAO_SQ = P_IN_REQUISICAO.REQUISICAO_SQ; 
         
        --VERIFICA O SOLICITANTE 
        SELECT U.IDENTIFICACAO
          INTO V_CHAPA
          FROM REQPES.USUARIO U
         WHERE U.USUARIO_SQ = V_USUARIO_SQ;
               
        --VERIFICA O PERFIL DO SOLICITANTE
        SELECT PU.COD_SISTEMA_PERFIL
          INTO V_PERFIL
          FROM ADM_TI.MV_SISTEMA_PERFIL_USUARIO PU,
               ADM_TI.MV_SISTEMA_PERFIL SP
         WHERE PU.IDENTIFICACAO = V_CHAPA
           AND PU.COD_SISTEMA_PERFIL = SP.COD_SISTEMA_PERFIL
           AND SP.COD_SISTEMA = 7;
           
        --SER O CRIADOR FOR AP&B, E O APROVADOR FOR NEC, PULA O AP&B
        IF(V_PERFIL = 91 AND V_NIVEL = 3) THEN
           V_NIVEL := V_NIVEL + 1;
        END IF;

      -----------------------------------------------------
        -- GRAVANDO NO HISTORICO
        -----------------------------------------------------
        INSERT INTO HISTORICO_REQUISICAO
          (REQUISICAO_SQ
          ,COD_UNIDADE
          ,DT_ENVIO
          ,USUARIO_SQ
          ,STATUS
          ,UNIDADE_ATUAL_USUARIO
          ,NIVEL)
        VALUES
          (P_IN_REQUISICAO.REQUISICAO_SQ
          ,P_IN_REQUISICAO.COD_UNIDADE
          ,CURRENT_TIMESTAMP--SYSDATE
          ,P_IN_USUARIO
          ,'homologou'
          ,P_IN_REQUISICAO.UNIDADE_ATUAL_USUARIO
          ,V_NIVEL);
        -----------------------------------------------------

      ELSIF (P_IN_TIPO = 'R') THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'REPROVAÇÃO PELO HOMOLOGADOR';
        -----------------------------------------------------
        -- ALTERANDO O STATUS DA REQUISIÇÃO
        -----------------------------------------------------
        UPDATE REQUISICAO R
        SET    R.COD_STATUS = 5 -- STATUS: REPROVADA
        WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO.REQUISICAO_SQ;

        -----------------------------------------------------
        -- INSERINDO OS DADOS NA TABELA DE REQUISIÇÕES REPROVADAS
        -----------------------------------------------------
        INSERT INTO REQUISICAO_REPROVADA
          (REQUISICAO_SQ
          ,COD_UNIDADE
          ,DT_REPROVADA
          ,MOTIVO)
        VALUES
          (P_IN_REQUISICAO.REQUISICAO_SQ
          ,P_IN_REQUISICAO.COD_UNIDADE
          ,SYSDATE
          ,P_IN_DSC_MOTIVO);

        -----------------------------------------------------
        -- GRAVANDO NO HISTORICO
        -----------------------------------------------------
        INSERT INTO HISTORICO_REQUISICAO
          (REQUISICAO_SQ
          ,COD_UNIDADE
          ,DT_ENVIO
          ,USUARIO_SQ
          ,STATUS
          ,UNIDADE_ATUAL_USUARIO
          ,NIVEL)
        VALUES
          (P_IN_REQUISICAO.REQUISICAO_SQ
          ,P_IN_REQUISICAO.COD_UNIDADE
          ,CURRENT_TIMESTAMP-- SYSDATE
          ,P_IN_USUARIO
          ,'reprovou'
          ,P_IN_REQUISICAO.UNIDADE_ATUAL_USUARIO
          ,P_IN_REQUISICAO.NIVEL);
        -----------------------------------------------------

      ELSIF (P_IN_TIPO = 'AF') THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'APROVAÇÃO FINAL';
        -----------------------------------------------------
        -- ALTERANDO O STATUS DA REQUISIÇÃO
        -----------------------------------------------------
        UPDATE REQUISICAO R
        SET    R.COD_STATUS = 4 -- STATUS: APROVADA
        WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO.REQUISICAO_SQ;

        -----------------------------------------------------
        -- GRAVANDO NO HISTORICO
        -----------------------------------------------------
        INSERT INTO HISTORICO_REQUISICAO
          (REQUISICAO_SQ
          ,COD_UNIDADE
          ,DT_ENVIO
          ,USUARIO_SQ
          ,STATUS
          ,UNIDADE_ATUAL_USUARIO
          ,NIVEL)
        VALUES
          (P_IN_REQUISICAO.REQUISICAO_SQ
          ,P_IN_REQUISICAO.COD_UNIDADE
          ,CURRENT_TIMESTAMP--SYSDATE
          ,P_IN_USUARIO
          ,'aprovou'
          ,P_IN_REQUISICAO.UNIDADE_ATUAL_USUARIO
          ,P_IN_REQUISICAO.NIVEL);
        -----------------------------------------------------
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' ||TIPO_TRANSACAO ||' NO PROCESSO DE HOMOLOGAÇÃO' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA AO FAZER ' || TIPO_TRANSACAO ||' NO PROCESSO DE HOMOLOGAÇÃO' || SQLERRM);
    END;
END SP_DML_REQUISICAO_HOMOLOGACAO;
--################################ FIM DA PROCEDURE SP_DML_REQUISICAO_HOMOLOGACAO #######################


--################################ INICIO DA PROCEDURE SP_DML_SUBSTITUICAO_GERENTE #######################
PROCEDURE SP_DML_SUBSTITUICAO_GERENTE(P_IN_DML IN VARCHAR2,P_IN_SUBSTITUICAO IN RESPONSAVEL_ESTRUTURA%ROWTYPE, P_IN_TEOR_COD IN VARCHAR2) IS
 TIPO_TRANSACAO           VARCHAR2(50);
 V_CHAPA_GERENTE_ANTERIOR NUMBER;
 V_DAT_FIM_VIGEN          VARCHAR2(10) := TO_CHAR(P_IN_SUBSTITUICAO.REST_DAT_FIN_VIGEN,'DD/MM/YYYY');
BEGIN
    BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO  ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------
        -- FINALIZANDO A VIGENCIA DO GERENTE ATUAL
        -----------------------------------------------------
        -- resgatando o ID do gerente anterior
        SELECT FUNC_ID
        INTO   V_CHAPA_GERENTE_ANTERIOR
        FROM   RESPONSAVEL_ESTRUTURA RE
        WHERE  RE.TEOR_COD = P_IN_TEOR_COD
        AND    RE.UNOR_COD = P_IN_SUBSTITUICAO.UNOR_COD
        AND    TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN;
        ----------------------------------------------------
        -- finalizando a vigencia do grente anterior
        UPDATE RESPONSAVEL_ESTRUTURA RE
        SET    RE.REST_DAT_FIN_VIGEN = P_IN_SUBSTITUICAO.REST_DAT_INI_VIGEN - 1
              ,RE.REST_USU_REGIS     = 'REQUISICAO'
        WHERE  RE.TEOR_COD = P_IN_TEOR_COD
        AND    RE.UNOR_COD = P_IN_SUBSTITUICAO.UNOR_COD
        AND    RE.FUNC_ID  = V_CHAPA_GERENTE_ANTERIOR
        AND    TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN;

        -----------------------------------------------------
        -- GRAVANDO OS DADOS DO NOVO GERENTE
        -----------------------------------------------------
        INSERT INTO RESPONSAVEL_ESTRUTURA
          (TEOR_COD
          ,UNOR_COD
          ,PROC_ID
          ,TRES_COD
          ,FUNC_ID
          ,REST_DAT_REGIS
          ,REST_USU_REGIS
          ,REST_DAT_INI_VIGEN
          ,REST_DAT_FIN_VIGEN)
        VALUES
          (P_IN_TEOR_COD
          ,P_IN_SUBSTITUICAO.UNOR_COD
          ,203
          ,'GER'
          ,P_IN_SUBSTITUICAO.FUNC_ID
          ,TRUNC(SYSDATE)
          ,'REQUISICAO'
          ,P_IN_SUBSTITUICAO.REST_DAT_INI_VIGEN
          ,P_IN_SUBSTITUICAO.REST_DAT_FIN_VIGEN);

        -----------------------------------------------------
        -- GRAVANDO OS DADOS DO GERENTE ANTERIOR APOS DATA FINAL DE VIGENCIA DO GERENTE ATUAL
        -----------------------------------------------------
        INSERT INTO RESPONSAVEL_ESTRUTURA
          (TEOR_COD
          ,UNOR_COD
          ,PROC_ID
          ,TRES_COD
          ,FUNC_ID
          ,REST_DAT_REGIS
          ,REST_USU_REGIS
          ,REST_DAT_INI_VIGEN
          ,REST_DAT_FIN_VIGEN)
        VALUES
          (P_IN_TEOR_COD
          ,P_IN_SUBSTITUICAO.UNOR_COD
          ,203
          ,'GER'
          ,V_CHAPA_GERENTE_ANTERIOR
          ,TRUNC(SYSDATE)
          ,'REQUISICAO'
          ,TO_DATE(V_DAT_FIM_VIGEN,'DD/MM/YYYY') + 1
          ,TO_DATE('01/01/2100','DD/MM/YYYY'));
        -----------------------------------------------------

      ELSIF (P_IN_DML = 1) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'UPDATE';
        -----------------------------------------------------
        -- Consulta retorna o ultimo gerente em vigencia ou o gerente em vigencia
        -----------------------------------------------------
        UPDATE RESPONSAVEL_ESTRUTURA RE
        SET    RE.REST_DAT_INI_VIGEN = P_IN_SUBSTITUICAO.REST_DAT_INI_VIGEN
              ,RE.REST_DAT_FIN_VIGEN = P_IN_SUBSTITUICAO.REST_DAT_FIN_VIGEN
              ,RE.REST_USU_REGIS     = 'REQUISICAO'
              ,REST_DAT_REGIS        = TRUNC(SYSDATE)
        WHERE  RE.TEOR_COD = P_IN_TEOR_COD
        AND    RE.FUNC_ID  = P_IN_SUBSTITUICAO.FUNC_ID
        AND    RE.UNOR_COD = P_IN_SUBSTITUICAO.UNOR_COD
        AND    (TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN OR
                TRUNC(SYSDATE) > (SELECT MAX(R1.REST_DAT_FIN_VIGEN)
                                  FROM   RESPONSAVEL_ESTRUTURA R1
                                  WHERE  R1.TEOR_COD = RE.TEOR_COD
                                  AND    R1.UNOR_COD = RE.UNOR_COD));

        -----------------------------------------------------
        -- Atualizando a data de inicio de vigencia do proximo gerente
        -----------------------------------------------------
          SELECT R.FUNC_ID
          INTO   V_CHAPA_GERENTE_ANTERIOR
          FROM   RESPONSAVEL_ESTRUTURA R
          WHERE  R.TEOR_COD = P_IN_TEOR_COD
          AND    R.UNOR_COD = P_IN_SUBSTITUICAO.UNOR_COD
          AND    R.REST_DAT_FIN_VIGEN = (SELECT MAX(R1.REST_DAT_FIN_VIGEN)
                                         FROM   RESPONSAVEL_ESTRUTURA R1
                                         WHERE  R1.TEOR_COD = P_IN_TEOR_COD
                                         AND    R1.UNOR_COD = P_IN_SUBSTITUICAO.UNOR_COD);
          ------------------------------------------------------
          IF (V_CHAPA_GERENTE_ANTERIOR <> P_IN_SUBSTITUICAO.FUNC_ID) THEN
            ----------------------------------------------------
            UPDATE RESPONSAVEL_ESTRUTURA R
            SET    R.REST_DAT_INI_VIGEN = P_IN_SUBSTITUICAO.REST_DAT_FIN_VIGEN + 1
            WHERE  R.TEOR_COD = P_IN_TEOR_COD
            AND    R.UNOR_COD = P_IN_SUBSTITUICAO.UNOR_COD
            AND    R.REST_DAT_FIN_VIGEN = (SELECT MAX(R1.REST_DAT_FIN_VIGEN)
                                           FROM   RESPONSAVEL_ESTRUTURA R1
                                           WHERE  R1.TEOR_COD = P_IN_TEOR_COD
                                           AND    R1.UNOR_COD = P_IN_SUBSTITUICAO.UNOR_COD);
           ----------------------------------------------------
          END IF;
          -----------------------------------------------------
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' ||TIPO_TRANSACAO ||' NO PROCESSO DE SUBSTITUICAO_GERENTE' ||SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA AO FAZER ' || TIPO_TRANSACAO ||' NO PROCESSO DE SUBSTITUICAO_GERENTE' ||SQLERRM);
    END;
END SP_DML_SUBSTITUICAO_GERENTE;
--################################ FIM DA PROCEDURE SP_DML_SUBSTITUICAO_GERENTE #######################


--################################ INICIO DA PROCEDURE SP_DML_TABELA_SALARIAL #######################
PROCEDURE SP_DML_TABELA_SALARIAL(P_IN_DML IN NUMBER,P_IN_TABELA_SALARIAL IN OUT TABELA_SALARIAL%ROWTYPE, P_IN_USUARIO IN VARCHAR2) IS
 TIPO_TRANSACAO VARCHAR2(50);
BEGIN
    BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO    ################# --
      -- ############# SE 0 FAZ INSERT   ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------
        SELECT SEQ_TABELA_SALARIAL.NEXTVAL
        INTO   P_IN_TABELA_SALARIAL.COD_TAB_SALARIAL
        FROM   DUAL;
        -----------------------------------------------------
        
        INSERT INTO TABELA_SALARIAL
          (COD_TAB_SALARIAL
          ,DSC_TAB_SALARIAL
          ,IND_ATIVO
          ,IND_EXIBE_AREA_SUBAREA
          ,USER_CADASTRO)
        VALUES
          (P_IN_TABELA_SALARIAL.COD_TAB_SALARIAL
          ,P_IN_TABELA_SALARIAL.DSC_TAB_SALARIAL
          ,P_IN_TABELA_SALARIAL.IND_ATIVO
          ,P_IN_TABELA_SALARIAL.IND_EXIBE_AREA_SUBAREA
          ,P_IN_USUARIO);
        -----------------------------------------------------

        -- ############# SE 1 FAZ UPDATE   ################# --
      ELSIF (P_IN_DML > 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'UPDATE';
        -----------------------------------------------------
        UPDATE TABELA_SALARIAL
        SET    DSC_TAB_SALARIAL       = P_IN_TABELA_SALARIAL.DSC_TAB_SALARIAL
              ,IND_ATIVO              = P_IN_TABELA_SALARIAL.IND_ATIVO
              ,IND_EXIBE_AREA_SUBAREA = P_IN_TABELA_SALARIAL.IND_EXIBE_AREA_SUBAREA
              ,DAT_ALTERACAO          = SYSDATE
              ,USER_ALTERACAO         = P_IN_USUARIO
        WHERE  COD_TAB_SALARIAL       = P_IN_TABELA_SALARIAL.COD_TAB_SALARIAL;
        -----------------------------------------------------

        -- ############# SE -1 FAZ DELETE   ################# --
      ELSE
        -----------------------------------------------------
        TIPO_TRANSACAO := 'DELETE';
        -----------------------------------------------------
        DELETE FROM TABELA_SALARIAL_ATRIBUICAO WHERE COD_TAB_SALARIAL  = P_IN_TABELA_SALARIAL.COD_TAB_SALARIAL;
        DELETE FROM TABELA_SALARIAL WHERE COD_TAB_SALARIAL = P_IN_TABELA_SALARIAL.COD_TAB_SALARIAL;

      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA TABELA_SALARIAL' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA TABELA_SALARIAL' || SQLERRM);
    END;
END SP_DML_TABELA_SALARIAL;
--################################ FIM DA PROCEDURE SP_DML_TABELA_SALARIAL #######################


--################################ INICIO DA PROCEDURE SP_DML_TAB_SALARIAL_ATRIBUICAO #######################
PROCEDURE SP_DML_TAB_SALARIAL_ATRIBUICAO(P_IN_DML IN NUMBER, P_IN_TAB_SALARIAL_ATRIBUICAO IN OUT TABELA_SALARIAL_ATRIBUICAO%ROWTYPE) IS
 TIPO_TRANSACAO VARCHAR2(50) := 'DELETE / INSERT';
BEGIN
    BEGIN     
    
        IF (P_IN_DML = 0) THEN
          -----------------------------------------------------
          -- INSERINDO AS ATRIBUIÇÕES
          -----------------------------------------------------
          INSERT INTO TABELA_SALARIAL_ATRIBUICAO
            (COD_TAB_SALARIAL
            ,COD_TAB_SALARIAL_RHEV)
          VALUES
            (P_IN_TAB_SALARIAL_ATRIBUICAO.COD_TAB_SALARIAL
            ,P_IN_TAB_SALARIAL_ATRIBUICAO.COD_TAB_SALARIAL_RHEV);

        ELSE
          -----------------------------------------------------
          -- REMOVENDO AS ATRIBUIÇÕES
          -----------------------------------------------------
          DELETE FROM TABELA_SALARIAL_ATRIBUICAO WHERE COD_TAB_SALARIAL  = P_IN_TAB_SALARIAL_ATRIBUICAO.COD_TAB_SALARIAL;

       END IF;        

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA TABELA_SALARIAL_ATRIBUICAO' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA TABELA_SALARIAL_ATRIBUICAO' || SQLERRM);
    END;
END SP_DML_TAB_SALARIAL_ATRIBUICAO;
--################################ FIM DA PROCEDURE SP_DML_TAB_SALARIAL_ATRIBUICAO #######################



--################################ INICIO DA PROCEDURE SP_DML_INSTRUCAO #######################
PROCEDURE SP_DML_INSTRUCAO(P_IN_DML IN NUMBER,P_IN_INSTRUCAO IN OUT INSTRUCAO%ROWTYPE, P_IN_USUARIO IN VARCHAR2) IS
 TIPO_TRANSACAO VARCHAR2(50);
BEGIN
    BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO    ################# --
      -- ############# SE 0 FAZ INSERT   ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------        
        SELECT SEQ_INSTRUCAO.NEXTVAL
        INTO   P_IN_INSTRUCAO.COD_INSTRUCAO
        FROM   DUAL;
        -----------------------------------------------------
                
        INSERT INTO INSTRUCAO
          (COD_INSTRUCAO
          ,COD_TAB_SALARIAL
          ,COD_CARGO
          ,COTA
          ,COD_AREA_SUBAREA
          ,USER_CADASTRO)
        VALUES
          (P_IN_INSTRUCAO.COD_INSTRUCAO
          ,P_IN_INSTRUCAO.COD_TAB_SALARIAL
          ,P_IN_INSTRUCAO.COD_CARGO
          ,P_IN_INSTRUCAO.COTA
          ,P_IN_INSTRUCAO.COD_AREA_SUBAREA
          ,P_IN_USUARIO);
        -----------------------------------------------------

        -- ############# SE 1 FAZ UPDATE   ################# --
      ELSIF (P_IN_DML > 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'UPDATE';
        -----------------------------------------------------
        UPDATE INSTRUCAO
        SET    COD_TAB_SALARIAL = P_IN_INSTRUCAO.COD_TAB_SALARIAL
              ,COD_CARGO        = P_IN_INSTRUCAO.COD_CARGO
              ,COTA             = P_IN_INSTRUCAO.COTA
              ,COD_AREA_SUBAREA = P_IN_INSTRUCAO.COD_AREA_SUBAREA
              ,DAT_ALTERACAO    = SYSDATE
              ,USER_ALTERACAO   = P_IN_USUARIO
        WHERE  COD_INSTRUCAO    = P_IN_INSTRUCAO.COD_INSTRUCAO;
        -----------------------------------------------------

        -- ############# SE -1 FAZ DELETE   ################# --
      ELSE
        -----------------------------------------------------
        TIPO_TRANSACAO := 'DELETE';
        -----------------------------------------------------
        INSERT INTO AUDIT_TMP
        SELECT USERENV('SESSIONID')
              ,P_IN_USUARIO
              ,'INSTRUCAO_ATRIBUICAO: ' || SUBSTR(UNIDADES, (INSTR(UNIDADES, '#')+1), LENGTH(UNIDADES))
        FROM   (SELECT F_GET_LST_INSTRUCAO_ATRIBUICAO(P_IN_INSTRUCAO.COD_INSTRUCAO) AS UNIDADES
                FROM   DUAL);

        DELETE FROM INSTRUCAO_ATRIBUICAO WHERE COD_INSTRUCAO = P_IN_INSTRUCAO.COD_INSTRUCAO;
        DELETE FROM INSTRUCAO WHERE COD_INSTRUCAO = P_IN_INSTRUCAO.COD_INSTRUCAO;

      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA INSTRUCAO' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA INSTRUCAO' || SQLERRM);
    END;
END SP_DML_INSTRUCAO;
--################################ FIM DA PROCEDURE SP_DML_INSTRUCAO #######################


--################################ INICIO DA PROCEDURE SP_DML_INSTRUCAO_ATRIBUICAO #######################
PROCEDURE SP_DML_INSTRUCAO_ATRIBUICAO(P_IN_DML IN NUMBER, P_IN_INSTRUCAO_ATRIBUICAO IN OUT INSTRUCAO_ATRIBUICAO%ROWTYPE) IS
 TIPO_TRANSACAO VARCHAR2(50) := 'DELETE / INSERT';
BEGIN
    BEGIN     
    
        IF (P_IN_DML = 0) THEN
          -----------------------------------------------------
          -- INSERINDO AS ATRIBUIÇÕES
          -----------------------------------------------------
          INSERT INTO INSTRUCAO_ATRIBUICAO
            (COD_INSTRUCAO
            ,COD_UNIDADE)
          VALUES
            (P_IN_INSTRUCAO_ATRIBUICAO.COD_INSTRUCAO
            ,P_IN_INSTRUCAO_ATRIBUICAO.COD_UNIDADE);

        ELSE
          -----------------------------------------------------
          -- REMOVENDO AS ATRIBUIÇÕES
          -----------------------------------------------------
          DELETE FROM INSTRUCAO_ATRIBUICAO WHERE COD_INSTRUCAO = P_IN_INSTRUCAO_ATRIBUICAO.COD_INSTRUCAO;

       END IF;        

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA INSTRUCAO_ATRIBUICAO' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA INSTRUCAO_ATRIBUICAO' || SQLERRM);
    END;
END SP_DML_INSTRUCAO_ATRIBUICAO;
--################################ FIM DA PROCEDURE SP_DML_INSTRUCAO_ATRIBUICAO #######################


--################################ INICIO DA PROCEDURE SP_DML_GRUPO_NEC #######################
PROCEDURE SP_DML_GRUPO_NEC(P_IN_DML IN NUMBER, P_IN_GRUPO_NEC IN OUT GRUPO_NEC%ROWTYPE, P_IN_USUARIO IN VARCHAR2) IS
 TIPO_TRANSACAO VARCHAR2(50);
BEGIN
    BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO    ################# --
      -- ############# SE 0 FAZ INSERT   ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------        
        SELECT SEQ_GRUPO_NEC.NEXTVAL
        INTO   P_IN_GRUPO_NEC.COD_GRUPO
        FROM   DUAL;
        -----------------------------------------------------
                
        INSERT INTO GRUPO_NEC
          (COD_GRUPO
          ,DSC_GRUPO
          ,USER_CADASTRO)
        VALUES
          (P_IN_GRUPO_NEC.COD_GRUPO
          ,P_IN_GRUPO_NEC.DSC_GRUPO
          ,P_IN_USUARIO);
        -----------------------------------------------------

        -- ############# SE 1 FAZ UPDATE   ################# --
      ELSIF (P_IN_DML > 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'UPDATE';
        -----------------------------------------------------
        UPDATE GRUPO_NEC
        SET    DSC_GRUPO      = P_IN_GRUPO_NEC.DSC_GRUPO
              ,DAT_ALTERACAO  = SYSDATE
              ,USER_ALTERACAO = P_IN_USUARIO
        WHERE  COD_GRUPO      = P_IN_GRUPO_NEC.COD_GRUPO;
        -----------------------------------------------------

        -- ############# SE -1 FAZ DELETE   ################# --
      ELSE
        -----------------------------------------------------
        TIPO_TRANSACAO := 'DELETE';
        -----------------------------------------------------
        DELETE FROM GRUPO_NEC WHERE COD_GRUPO = P_IN_GRUPO_NEC.COD_GRUPO;

      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA GRUPO_NEC' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA GRUPO_NEC' || SQLERRM);
    END;
END SP_DML_GRUPO_NEC;
--################################ FIM DA PROCEDURE SP_DML_GRUPO_NEC #######################


--################################ INICIO DA PROCEDURE SP_DML_GRUPO_NEC_UNIDADES #######################
PROCEDURE SP_DML_GRUPO_NEC_UNIDADES(P_IN_DML IN NUMBER, P_IN_GRUPO_NEC_UNIDADES IN OUT GRUPO_NEC_UNIDADES%ROWTYPE) IS
 TIPO_TRANSACAO VARCHAR2(50) := 'DELETE / INSERT';
BEGIN
    BEGIN     
    
        IF (P_IN_DML = 0) THEN
          -----------------------------------------------------
          -- INSERINDO AS ATRIBUIÇÕES
          -----------------------------------------------------
          INSERT INTO GRUPO_NEC_UNIDADES
            (COD_GRUPO
            ,COD_UNIDADE)
          VALUES
            (P_IN_GRUPO_NEC_UNIDADES.COD_GRUPO
            ,P_IN_GRUPO_NEC_UNIDADES.COD_UNIDADE);

        ELSE
          -----------------------------------------------------
          -- REMOVENDO AS ATRIBUIÇÕES
          -----------------------------------------------------
          DELETE FROM GRUPO_NEC_UNIDADES WHERE COD_GRUPO = P_IN_GRUPO_NEC_UNIDADES.COD_GRUPO;

       END IF;        

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA GRUPO_NEC_UNIDADES' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA GRUPO_NEC_UNIDADES' || SQLERRM);
    END;
END SP_DML_GRUPO_NEC_UNIDADES;
--################################ FIM DA PROCEDURE SP_DML_GRUPO_NEC_UNIDADES #######################


--################################ INICIO DA PROCEDURE SP_DML_GRUPO_NEC_USUARIOS #######################
PROCEDURE SP_DML_GRUPO_NEC_USUARIOS(P_IN_DML IN NUMBER, P_IN_GRUPO_NEC_USUARIOS IN OUT GRUPO_NEC_USUARIOS%ROWTYPE, P_IN_USUARIO IN VARCHAR2) IS
 TIPO_TRANSACAO VARCHAR2(50) := 'DELETE / INSERT';
BEGIN
    BEGIN     
    
        IF (P_IN_DML = 0) THEN
          -----------------------------------------------------
          -- INSERINDO AS ATRIBUIÇÕES
          -----------------------------------------------------
          INSERT INTO GRUPO_NEC_USUARIOS
            (COD_GRUPO
            ,CHAPA
            ,USER_LOG)
          VALUES
            (P_IN_GRUPO_NEC_USUARIOS.COD_GRUPO
            ,P_IN_GRUPO_NEC_USUARIOS.CHAPA
            ,P_IN_USUARIO);
         
        ELSE
          -----------------------------------------------------
          -- REMOVENDO O ACESSO
          -----------------------------------------------------          
          DELETE FROM GRUPO_NEC_USUARIOS WHERE CHAPA = P_IN_GRUPO_NEC_USUARIOS.CHAPA;

       END IF;        

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA GRUPO_NEC_USUARIOS' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA GRUPO_NEC_USUARIOS' || SQLERRM);
    END;
END SP_DML_GRUPO_NEC_USUARIOS;
--################################ FIM DA PROCEDURE SP_DML_GRUPO_NEC_USUARIOS #######################


--################################ INICIO DA PROCEDURE SP_DML_CARGO_ADM_COORD #######################
PROCEDURE SP_DML_CARGO_ADM_COORD(P_IN_DML IN NUMBER, P_IN_UO_CARGO_ADM_COORD IN UO_CARGO_ADM_COORD%ROWTYPE, P_IN_USUARIO IN VARCHAR2) IS
 TIPO_TRANSACAO VARCHAR2(50);
BEGIN
    BEGIN     
    
        IF (P_IN_DML = 0) THEN
          -----------------------------------------------------
          -- INSERINDO OS DADOS
          -----------------------------------------------------
          TIPO_TRANSACAO := 'INSERT';
          INSERT INTO UO_CARGO_ADM_COORD
            (COD_UNIDADE
            ,USER_CADASTRO)
          VALUES
            (P_IN_UO_CARGO_ADM_COORD.COD_UNIDADE
            ,P_IN_USUARIO);
         
        ELSE
          -----------------------------------------------------
          -- REMOVENDO O REGISTRO
          -----------------------------------------------------          
          TIPO_TRANSACAO := 'DELETE';          
          DELETE FROM UO_CARGO_ADM_COORD WHERE COD_UNIDADE = P_IN_UO_CARGO_ADM_COORD.COD_UNIDADE;

       END IF;        

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA UO_CARGO_ADM_COORD' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA UO_CARGO_ADM_COORD' || SQLERRM);
    END;
END SP_DML_CARGO_ADM_COORD;
--################################ FIM DA PROCEDURE SP_DML_CARGO_ADM_COORD #######################


--################################ INICIO DA PROCEDURE SP_DML_TIPO_AVISO #######################
PROCEDURE SP_DML_TIPO_AVISO(P_IN_DML IN NUMBER, P_IN_TIPO_AVISO IN OUT TIPO_AVISO%ROWTYPE, P_IN_USUARIO IN VARCHAR2) IS
 TIPO_TRANSACAO VARCHAR2(50);
BEGIN
    BEGIN
      -- ############# VERIFICANDO O TIPO DE TRANSAÇÃO   ################# --
      -- ############# SE 0 FAZ INSERT   ################# --
      IF (P_IN_DML = 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'INSERT';
        -----------------------------------------------------        
        SELECT SEQ_TIPO_AVISO.NEXTVAL
        INTO   P_IN_TIPO_AVISO.COD_TIPO_AVISO
        FROM   DUAL;
        -----------------------------------------------------
        INSERT INTO TIPO_AVISO
          (COD_TIPO_AVISO
          ,TITULO
          ,CARGO_CHAVE
          ,CARGO_REGIME
          ,USER_CADASTRO)
        VALUES
          (P_IN_TIPO_AVISO.COD_TIPO_AVISO
          ,P_IN_TIPO_AVISO.TITULO
          ,P_IN_TIPO_AVISO.CARGO_CHAVE
          ,P_IN_TIPO_AVISO.CARGO_REGIME
          ,P_IN_USUARIO);
        -----------------------------------------------------

        -- ############# SE 1 FAZ UPDATE   ################# --
      ELSIF (P_IN_DML > 0) THEN
        -----------------------------------------------------
        TIPO_TRANSACAO := 'UPDATE';
        -----------------------------------------------------
        UPDATE TIPO_AVISO
        SET    TITULO         = P_IN_TIPO_AVISO.TITULO
              ,CARGO_CHAVE    = P_IN_TIPO_AVISO.CARGO_CHAVE
              ,CARGO_REGIME   = P_IN_TIPO_AVISO.CARGO_REGIME
              ,DAT_ALTERACAO  = SYSDATE
              ,USER_ALTERACAO = P_IN_USUARIO
        WHERE  COD_TIPO_AVISO = P_IN_TIPO_AVISO.COD_TIPO_AVISO;
        -----------------------------------------------------

        -- ############# SE -1 FAZ DELETE   ################# --
      ELSE
        -----------------------------------------------------
        TIPO_TRANSACAO := 'DELETE';
        -----------------------------------------------------
        DELETE FROM TIPO_AVISO WHERE COD_TIPO_AVISO = P_IN_TIPO_AVISO.COD_TIPO_AVISO;

      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA TIPO_AVISO' || SQLERRM);
      WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER ' || TIPO_TRANSACAO || ' NA TABELA TIPO_AVISO' || SQLERRM);
    END;
END SP_DML_TIPO_AVISO;
--################################ FIM DA PROCEDURE SP_DML_TIPO_AVISO #######################


--################################ INICIO DA PROCEDURE SP_REQUISICAO_PERFIL_FUNCAO #######################
PROCEDURE SP_REQUISICAO_PERFIL_FUNCAO(P_REQUISICAO_SQ IN REQUISICAO.REQUISICAO_SQ%TYPE, P_LIST_FUNCAO IN VARCHAR2) IS
  BEGIN
    -- Limpando os registros
    DELETE FROM REQUISICAO_PERFIL_FUNCAO R
    WHERE  R.REQUISICAO_SQ = P_REQUISICAO_SQ;
    
    -- Inserindo as funções adicionais no perfil
    IF (P_LIST_FUNCAO IS NOT NULL) THEN
      INSERT INTO REQUISICAO_PERFIL_FUNCAO
        (REQUISICAO_SQ
        ,COD_FUNCAO)
        SELECT P_REQUISICAO_SQ
              ,T.ID_FUNCAO
        FROM   RECRU_FUNCAO T
        WHERE  T.ID_FUNCAO IN (SELECT * FROM TABLE(F_SPLIT(P_LIST_FUNCAO)))
        AND    NOT EXISTS (SELECT 1 FROM REQUISICAO_PERFIL P
                           WHERE  P.REQUISICAO_SQ = P_REQUISICAO_SQ
                           AND    P.COD_FUNCAO = T.ID_FUNCAO);
    END IF;
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20024,'PROBLEMA: DADOS NÃO ENCONTRADOS NA INCLUSÃO DA TABELA REQUISICAO_PERFIL_FUNCAO' || SQLERRM);
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20024, 'PROBLEMA AO FAZER DML NA TABELA REQUISICAO_PERFIL_FUNCAO' || SQLERRM);
END SP_REQUISICAO_PERFIL_FUNCAO;

END REQUISICAO_PKG;
/
