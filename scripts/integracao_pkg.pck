CREATE OR REPLACE PACKAGE INTEGRACAO_PKG IS
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
CREATE OR REPLACE PACKAGE BODY INTEGRACAO_PKG IS

  /***************************************************************************************/
  /* INICIO DA PROCEDURE IN_FUNCIONARIOS                                                 */
  /***************************************************************************************/
  PROCEDURE SP_INTEGRACAO(P_IN_OUT_REG_FUNCIONARIOS IN OUT FUNCIONARIOS%ROWTYPE
                         ,P_IN_REQUISICAO_SQ        IN REQUISICAO.REQUISICAO_SQ%TYPE
                         ,P_IN_USUARIO_LOG          IN FUNCIONARIOS.ID%TYPE
                         ,P_OUT_SUCESSO             OUT NUMBER
                         ,P_OUT_MSG                 OUT VARCHAR2) IS

    V_TIPO_RECRUTAMENTO  REQUISICAO.COD_RECRUTAMENTO%TYPE;
    V_USUARIO_SQ         USUARIO.USUARIO_SQ%TYPE;
    
  BEGIN
    
    -- Resgatando o usuario_sq para utilizar na baixa
    SELECT U.USUARIO_SQ
    INTO   V_USUARIO_SQ
    FROM   USUARIO U
    WHERE  U.IDENTIFICACAO = P_IN_USUARIO_LOG;

    IF (P_IN_OUT_REG_FUNCIONARIOS.CIC_NRO IS NULL OR P_IN_OUT_REG_FUNCIONARIOS.COMPLEMENTO_CIC_NRO IS NULL) THEN
      P_OUT_SUCESSO := -1;
      P_OUT_MSG := 'ERRO NO CPF: PREENCHIMENTO OBRIGATÓRIO';
    ELSE
      SELECT R.COD_RECRUTAMENTO
      INTO   V_TIPO_RECRUTAMENTO -- (1) INTERNO / (2) EXTERNO / (3) MISTO
      FROM   REQUISICAO R
      WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_SQ;

      --======================================================================--
      -- INTERNO
      --======================================================================--
        IF (V_TIPO_RECRUTAMENTO = 1) THEN
          SP_VALIDA_DADOS_INTERNO(P_IN_OUT_REG_FUNCIONARIOS, P_IN_REQUISICAO_SQ, P_OUT_SUCESSO, P_OUT_MSG);

          IF (P_OUT_SUCESSO > 0 AND P_OUT_MSG IS NULL) THEN
            -- Realiza a baixa da Requisição de Pessoal
            /*SP_DML_REQUISICAO_BAIXA(0
                                   ,P_IN_REQUISICAO_SQ
                                   ,P_OUT_SUCESSO
                                   ,V_USUARIO_SQ);
                                   
            -- Notifica a baixa realizada
            SP_NOTIFICA_BAIXA(P_IN_REQUISICAO_SQ
                             ,P_IN_OUT_REG_FUNCIONARIOS
                             ,1);*/
            
            -- Grava o sucesos no log de exportação                 
            SP_IN_LOG_EXPORTACAO(P_IN_REQUISICAO_SQ
                                ,'BAIXA REALIZADA COM SUCESSO: ' || P_IN_OUT_REG_FUNCIONARIOS.ID || ' - ' || P_IN_OUT_REG_FUNCIONARIOS.NOME
                                ,P_IN_USUARIO_LOG);
          END IF;

      --======================================================================--
      -- EXTERNO
      --======================================================================--
        ELSIF (V_TIPO_RECRUTAMENTO = 2) THEN
          IF (P_IN_OUT_REG_FUNCIONARIOS.ID IS NULL) THEN
            -- Insere o candidato no RHEvolution e realiza a baixa da Requisição de Pessoal
            SP_IN_FUNCIONARIOS(P_IN_OUT_REG_FUNCIONARIOS
                              ,P_IN_REQUISICAO_SQ
                              ,P_IN_USUARIO_LOG
                              ,V_USUARIO_SQ
                              ,P_OUT_SUCESSO
                              ,P_OUT_MSG);

            -- Notifica a baixa realizada
            /*IF (P_OUT_SUCESSO > 0) THEN
              SP_NOTIFICA_BAIXA(P_IN_REQUISICAO_SQ
                               ,P_IN_OUT_REG_FUNCIONARIOS
                               ,2);
            END IF;*/
          ELSE
            P_OUT_SUCESSO := -1;
            P_OUT_MSG := 'ERRO NO TIPO DE RECRUTAMENTO/FUNCIONÁRIO: A RP EXIGE UM COLABORADOR EXTERNO';
          END IF;

      --======================================================================--
      -- MISTO
      --======================================================================--
        ELSE
          IF (P_IN_OUT_REG_FUNCIONARIOS.ID IS NULL) THEN
            -- Candidato EXTERNO
            -- Insere o candidato no RHEvolution e realiza a baixa da Requisição de Pessoal
            SP_IN_FUNCIONARIOS(P_IN_OUT_REG_FUNCIONARIOS
                              ,P_IN_REQUISICAO_SQ
                              ,P_IN_USUARIO_LOG
                              ,V_USUARIO_SQ
                              ,P_OUT_SUCESSO
                              ,P_OUT_MSG);

            -- Notifica a baixa realizada
            /*IF (P_OUT_SUCESSO > 0) THEN
              SP_NOTIFICA_BAIXA(P_IN_REQUISICAO_SQ
                               ,P_IN_OUT_REG_FUNCIONARIOS
                               ,2);
            END IF;*/
          ELSE
            -- Candidato INTERNO
            SP_VALIDA_DADOS_INTERNO(P_IN_OUT_REG_FUNCIONARIOS, P_IN_REQUISICAO_SQ, P_OUT_SUCESSO, P_OUT_MSG);

            IF (P_OUT_SUCESSO > 0 AND P_OUT_MSG IS NULL) THEN
              -- Realiza a baixa da Requisição de Pessoal
             /* SP_DML_REQUISICAO_BAIXA(0
                                     ,P_IN_REQUISICAO_SQ
                                     ,P_OUT_SUCESSO
                                     ,V_USUARIO_SQ);
                                     
              -- Notifica a baixa realizada
              SP_NOTIFICA_BAIXA(P_IN_REQUISICAO_SQ
                               ,P_IN_OUT_REG_FUNCIONARIOS
                               ,1);*/
                               
             -- Grava o sucesos no log de exportação                 
             SP_IN_LOG_EXPORTACAO(P_IN_REQUISICAO_SQ
                                 ,'BAIXA REALIZADA COM SUCESSO: ' || P_IN_OUT_REG_FUNCIONARIOS.ID || ' - ' || P_IN_OUT_REG_FUNCIONARIOS.NOME
                                 ,P_IN_USUARIO_LOG);                                
            END IF;
          END IF;
        END IF;
      END IF;
      
      SP_NOTIFICA_INTEGRACAO_RHEV(P_IN_FUNCIONARIO => P_IN_OUT_REG_FUNCIONARIOS);

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- Registrando log e retorno do erro
      P_OUT_SUCESSO := -1;
      P_OUT_MSG := 'PROBLEMA NA EXECUÇÃO DO PROCESSO SP_INTEGRACAO: ' || SQLERRM;
      SP_IN_LOG_EXPORTACAO(P_IN_REQUISICAO_SQ
                          ,'PROBLEMA NA EXECUÇÃO DO PROCESSO SP_INTEGRACAO: ' || SQLERRM
                          ,P_IN_USUARIO_LOG);

  END SP_INTEGRACAO;


  /***************************************************************************************/
  /* INICIO DA PROCEDURE IN_FUNCIONARIOS                                                 */
  /***************************************************************************************/
  PROCEDURE SP_IN_FUNCIONARIOS(P_IN_OUT_REG_FUNCIONARIOS  IN OUT FUNCIONARIOS%ROWTYPE
                              ,P_IN_REQUISICAO_SQ         IN REQUISICAO.REQUISICAO_SQ%TYPE
                              ,P_IN_USUARIO_LOG           IN FUNCIONARIOS.ID%TYPE
                              ,P_IN_USUARIO_SQ            IN USUARIO.USUARIO_SQ%TYPE
                              ,P_OUT_SUCESSO              OUT NUMBER
                              ,P_OUT_MSG                  OUT VARCHAR2) IS

    V_REG_REQUISICAO  REQUISICAO%ROWTYPE;
    V_TIPO_COLAB      FUNCIONARIOS.TIPO_COLAB%TYPE;    
    V_QTD_REGISTRO    NUMBER;

  BEGIN
    --===========================================================--
    -- VERIFICA SE O CANDIDATO POSSUI REGISTRO NO RHEVOLUTION
    --===========================================================--
      SELECT COUNT(*)
      INTO   V_QTD_REGISTRO
      FROM   FUNCIONARIOS F
      WHERE  F.CIC_NRO = P_IN_OUT_REG_FUNCIONARIOS.CIC_NRO
      AND    F.COMPLEMENTO_CIC_NRO = P_IN_OUT_REG_FUNCIONARIOS.COMPLEMENTO_CIC_NRO
      AND    F.TIPO_COLAB IN ('A', 'M')
      AND    F.ATIVO = 'A';

      IF (V_QTD_REGISTRO > 0) THEN
         P_OUT_SUCESSO := -1;
         P_OUT_MSG := 'ERRO NA VALIDAÇÃO DOS DADOS: CANDIDATO EXTERNO JÁ POSSUI CADASTRO NO RHEVOLUTION';
      ELSE
        --===========================================================--
        -- RESGATANDO DADOS COMPLEMENTARES
        --===========================================================--
          SELECT *
          INTO   V_REG_REQUISICAO
          FROM   REQUISICAO R
          WHERE  R.REQUISICAO_SQ = P_IN_REQUISICAO_SQ;
          ---
          SELECT UO.CODIGO_PAI
          INTO   P_IN_OUT_REG_FUNCIONARIOS.UNIORG_CGC
          FROM   UNIDADES_ORGANIZACIONAIS UO
          WHERE  NIVEL = 2
          AND    UO.DATA_ENCERRAMENTO IS NULL
          AND    UO.CODIGO = V_REG_REQUISICAO.COD_UNIDADE;
          ---
          SELECT E.ESTADO
                ,E.CIDADE
          INTO   P_IN_OUT_REG_FUNCIONARIOS.BASE_ORIGEM
                ,P_IN_OUT_REG_FUNCIONARIOS.BASE_ORIGEM_MUNICIPIO
          FROM   UNIORG_ENDERECO E
          WHERE  E.COD_UNIORG = P_IN_OUT_REG_FUNCIONARIOS.UNIORG_CGC;
          ---
          P_IN_OUT_REG_FUNCIONARIOS.ID_CARGO := V_REG_REQUISICAO.CARGO_SQ;
          P_IN_OUT_REG_FUNCIONARIOS.MOTIVO_CONTRATACAO := V_REG_REQUISICAO.RAZAO_SUBSTITUICAO;
          P_IN_OUT_REG_FUNCIONARIOS.COD_UNIORG := V_REG_REQUISICAO.COD_SEGMENTO3 || V_REG_REQUISICAO.COD_SEGMENTO4;
          
        --===========================================================--
        -- PESQUISANDO O TIPO DE COLABORADOR DE ACORDO COM O CARGO
        --  ( P ) Prestador
        --  ( A ) CLT
        --  ( M ) Aprendiz (8285)
        --  ( E ) Estagiário (8189, 8190, 8304, 8364, 8192, 8193)
        --===========================================================--        
          IF (P_IN_OUT_REG_FUNCIONARIOS.ID_CARGO = 8285) THEN
            V_TIPO_COLAB := 'M'; -- Aprendiz
          ELSIF (P_IN_OUT_REG_FUNCIONARIOS.ID_CARGO IN (8189, 8190, 8304, 8364, 8192, 8193)) THEN
              V_TIPO_COLAB := 'E'; -- Estagiário
            ELSE
              V_TIPO_COLAB := 'A'; -- CLT
          END IF;

          P_IN_OUT_REG_FUNCIONARIOS.TIPO_COLAB           := V_TIPO_COLAB;
          P_IN_OUT_REG_FUNCIONARIOS.CTR_PONTO            := 'N';
          P_IN_OUT_REG_FUNCIONARIOS.RECEBE_CREDITO_BANCO := 'S';
          P_IN_OUT_REG_FUNCIONARIOS.ATIVO                := 'C'; -- Em cadastramento

        --===========================================================--
        -- REALIZA TESTE NA INSERÇÃO DOS DADOS NO RHEVOLUTION
        --===========================================================--
          SP_VALIDA_DADOS_EXTERNO(P_IN_OUT_REG_FUNCIONARIOS, P_OUT_MSG);

        --===========================================================--
        -- INSERE OS DADOS
        --===========================================================--
          IF (P_OUT_MSG IS NULL) THEN

            SELECT S_FUNCIONARIOS_01.NEXTVAL
            INTO   P_IN_OUT_REG_FUNCIONARIOS.ID
            FROM   DUAL;

            -- Cria o dígito identificador
            P_IN_OUT_REG_FUNCIONARIOS.ID := P_IN_OUT_REG_FUNCIONARIOS.ID || F_RETORNA_DV_ID(LPAD(P_IN_OUT_REG_FUNCIONARIOS.ID, 6, '0'));

            INSERT INTO RHEV.FUNCIONARIOS
              (ID
              ,NOME
              ,ENDERECO
              ,NRO_END
              ,COMPLEMENTO_END
              ,BAIRRO
              ,CIDADE
              ,ESTADO
              ,CEP
              ,CODIGO_DDD
              ,TELEFONE
              ,RAMAL
              ,ESTADO_CIVIL
              ,SEXO
              ,DATA_NASCIMENTO
              ,PAIS_NASCIMENTO
              ,NACIONALIDADE
              ,CIDADE_NASCIMENTO
              ,ESTADO_NASCIMENTO
              ,NOME_PAI
              ,NOME_MAE
              ,NACIONALIDADE_PAI
              ,NACIONALIDADE_MAE
              ,NATURALIZADO
              ,DATA_CHEGADA_PAIS
              ,NRO_CARTEIRA_MODELO_19
              ,TIPO_VISTO_ESTRANGEIRO
              ,CART_PROFISSIONAL_NRO
              ,CART_PROFISSIONAL_SERIE
              ,CART_PROFISSIONAL_LETRA
              ,CART_PROFISSIONAL_EST_EMISSOR
              ,CART_PROFISSIONAL_DATA_EXPED
              ,CART_PROFISSIONAL_DATA_VALID
              ,PIS_NRO
              ,PIS_PASEP_DATA_EXPED
              ,TIPO_PROG_INTEGRACAO
              ,SEGUNDO_EMPREGO
              ,CERT_RESERVISTA_NRO
              ,COMPLEMENTO_CERT_RESERVISTA
              ,RG_NRO
              ,RG_COMPLEMENTO
              ,RG_ORGAO_EMISSOR
              ,RG_ESTADO_EMISSOR
              ,RG_DATA_EXPEDICAO
              ,CIC_NRO
              ,COMPLEMENTO_CIC_NRO
              ,TITULO_ELEITOR_NRO
              ,TITULO_ELEITOR_ZONA
              ,TITULO_ELEITOR_SECAO
              ,CART_HABILITACAO_NRO
              ,CART_HABILITACAO_CATEGORIA
              ,GRAU_ESCOLARIDADE
              ,ORGAO_CLASSE
              ,REGIAO_CLASSE
              ,NRO_REG_CLASSE
              -- 15/12/2011 Retirado devido erro no RHEvolution
              --,ID_CARGO
              --,ID_DESCRICAO
              ,COD_UNIORG
              ,UNIORG_CGC
              ,TIPO_COLAB
              ,RECEBE_CREDITO_BANCO
              ,ATIVO
              ,CTR_PONTO
              ,BASE_ORIGEM
              ,BASE_ORIGEM_MUNICIPIO
              ,MOTIVO_CONTRATACAO
              ,APOSENTADO)
            VALUES
              (P_IN_OUT_REG_FUNCIONARIOS.ID
              ,P_IN_OUT_REG_FUNCIONARIOS.NOME
              ,P_IN_OUT_REG_FUNCIONARIOS.ENDERECO
              ,P_IN_OUT_REG_FUNCIONARIOS.NRO_END
              ,P_IN_OUT_REG_FUNCIONARIOS.COMPLEMENTO_END
              ,P_IN_OUT_REG_FUNCIONARIOS.BAIRRO
              ,P_IN_OUT_REG_FUNCIONARIOS.CIDADE
              ,P_IN_OUT_REG_FUNCIONARIOS.ESTADO
              ,P_IN_OUT_REG_FUNCIONARIOS.CEP
              ,P_IN_OUT_REG_FUNCIONARIOS.CODIGO_DDD
              ,P_IN_OUT_REG_FUNCIONARIOS.TELEFONE
              ,P_IN_OUT_REG_FUNCIONARIOS.RAMAL
              ,P_IN_OUT_REG_FUNCIONARIOS.ESTADO_CIVIL
              ,P_IN_OUT_REG_FUNCIONARIOS.SEXO
              ,P_IN_OUT_REG_FUNCIONARIOS.DATA_NASCIMENTO
              ,P_IN_OUT_REG_FUNCIONARIOS.PAIS_NASCIMENTO
              ,P_IN_OUT_REG_FUNCIONARIOS.NACIONALIDADE
              ,P_IN_OUT_REG_FUNCIONARIOS.CIDADE_NASCIMENTO
              ,P_IN_OUT_REG_FUNCIONARIOS.ESTADO_NASCIMENTO
              ,P_IN_OUT_REG_FUNCIONARIOS.NOME_PAI
              ,P_IN_OUT_REG_FUNCIONARIOS.NOME_MAE
              ,P_IN_OUT_REG_FUNCIONARIOS.NACIONALIDADE_PAI
              ,P_IN_OUT_REG_FUNCIONARIOS.NACIONALIDADE_MAE
              ,P_IN_OUT_REG_FUNCIONARIOS.NATURALIZADO
              ,P_IN_OUT_REG_FUNCIONARIOS.DATA_CHEGADA_PAIS
              ,P_IN_OUT_REG_FUNCIONARIOS.NRO_CARTEIRA_MODELO_19
              ,P_IN_OUT_REG_FUNCIONARIOS.TIPO_VISTO_ESTRANGEIRO
              ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_NRO
              ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_SERIE
              ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_LETRA
              ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_EST_EMISSOR
              ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_DATA_EXPED
              ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_DATA_VALID
              ,P_IN_OUT_REG_FUNCIONARIOS.PIS_NRO
              ,P_IN_OUT_REG_FUNCIONARIOS.PIS_PASEP_DATA_EXPED
              ,P_IN_OUT_REG_FUNCIONARIOS.TIPO_PROG_INTEGRACAO
              ,P_IN_OUT_REG_FUNCIONARIOS.SEGUNDO_EMPREGO
              ,P_IN_OUT_REG_FUNCIONARIOS.CERT_RESERVISTA_NRO
              ,P_IN_OUT_REG_FUNCIONARIOS.COMPLEMENTO_CERT_RESERVISTA
              ,P_IN_OUT_REG_FUNCIONARIOS.RG_NRO
              ,P_IN_OUT_REG_FUNCIONARIOS.RG_COMPLEMENTO
              ,P_IN_OUT_REG_FUNCIONARIOS.RG_ORGAO_EMISSOR
              ,P_IN_OUT_REG_FUNCIONARIOS.RG_ESTADO_EMISSOR
              ,P_IN_OUT_REG_FUNCIONARIOS.RG_DATA_EXPEDICAO
              ,P_IN_OUT_REG_FUNCIONARIOS.CIC_NRO
              ,P_IN_OUT_REG_FUNCIONARIOS.COMPLEMENTO_CIC_NRO
              ,P_IN_OUT_REG_FUNCIONARIOS.TITULO_ELEITOR_NRO
              ,P_IN_OUT_REG_FUNCIONARIOS.TITULO_ELEITOR_ZONA
              ,P_IN_OUT_REG_FUNCIONARIOS.TITULO_ELEITOR_SECAO
              ,P_IN_OUT_REG_FUNCIONARIOS.CART_HABILITACAO_NRO
              ,P_IN_OUT_REG_FUNCIONARIOS.CART_HABILITACAO_CATEGORIA
              ,P_IN_OUT_REG_FUNCIONARIOS.GRAU_ESCOLARIDADE
              ,P_IN_OUT_REG_FUNCIONARIOS.ORGAO_CLASSE
              ,P_IN_OUT_REG_FUNCIONARIOS.REGIAO_CLASSE
              ,P_IN_OUT_REG_FUNCIONARIOS.NRO_REG_CLASSE
              -- 15/12/2011 Retirado devido erro no RHEvolution
              --,P_IN_OUT_REG_FUNCIONARIOS.ID_CARGO
              --,P_IN_OUT_REG_FUNCIONARIOS.ID_CARGO
              ,P_IN_OUT_REG_FUNCIONARIOS.COD_UNIORG
              ,P_IN_OUT_REG_FUNCIONARIOS.UNIORG_CGC
              ,P_IN_OUT_REG_FUNCIONARIOS.TIPO_COLAB
              ,P_IN_OUT_REG_FUNCIONARIOS.RECEBE_CREDITO_BANCO
              ,P_IN_OUT_REG_FUNCIONARIOS.ATIVO
              ,P_IN_OUT_REG_FUNCIONARIOS.CTR_PONTO
              ,P_IN_OUT_REG_FUNCIONARIOS.BASE_ORIGEM
              ,P_IN_OUT_REG_FUNCIONARIOS.BASE_ORIGEM_MUNICIPIO
              ,P_IN_OUT_REG_FUNCIONARIOS.MOTIVO_CONTRATACAO
              ,P_IN_OUT_REG_FUNCIONARIOS.APOSENTADO);

            -- Registrando log e retorno (ID_FUNCIONARIO)
            P_OUT_SUCESSO := P_IN_OUT_REG_FUNCIONARIOS.ID;
            SP_IN_LOG_EXPORTACAO(P_IN_REQUISICAO_SQ
                                ,'BAIXA / REGISTRO INSERIDO COM SUCESSO: ' || P_IN_OUT_REG_FUNCIONARIOS.ID || ' - ' || P_IN_OUT_REG_FUNCIONARIOS.NOME
                                ,P_IN_USUARIO_LOG);

            -- Realiza a baixa da RP
            /*SP_DML_REQUISICAO_BAIXA(0
                                   ,P_IN_REQUISICAO_SQ
                                   ,P_IN_OUT_REG_FUNCIONARIOS.ID
                                   ,P_IN_USUARIO_SQ);*/
          ELSE
            -- Registrando log e retorno do erro
            P_OUT_SUCESSO := -1;
            SP_IN_LOG_EXPORTACAO(P_IN_REQUISICAO_SQ
                                ,'ERRO NA VALIDAÇÃO DOS DADOS: ' || P_OUT_MSG
                                ,P_IN_USUARIO_LOG);
          END IF;
      END IF;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- Registrando log e retorno do erro
      P_OUT_SUCESSO := -1;
      --DBMS_OUTPUT.put_line(SQLERRM);
      P_OUT_MSG := 'PROBLEMA NA EXECUÇÃO DO PROCESSO SP_IN_FUNCIONARIOS: ' || SQLERRM;
      SP_IN_LOG_EXPORTACAO(P_IN_REQUISICAO_SQ
                          ,'PROBLEMA NA EXECUÇÃO DO PROCESSO SP_IN_FUNCIONARIOS: ' || SQLERRM
                          ,P_IN_USUARIO_LOG);

  END SP_IN_FUNCIONARIOS;


  /***************************************************************************************/
  /* INICIO DA FUNÇÃO RETORNA_DV_ID                                                      */
  /***************************************************************************************/
  FUNCTION F_RETORNA_DV_ID(W_ID VARCHAR2) RETURN VARCHAR2 IS

    DV    VARCHAR2(1);
    WS_ID VARCHAR2(9);
    ID1   INTEGER;
    ID2   INTEGER;
    ID3   INTEGER;
    ID4   INTEGER;
    ID5   INTEGER;
    ID6   INTEGER;
    RID1  INTEGER;
    RID2  INTEGER;
    RID3  INTEGER;
    RID4  INTEGER;
    RID5  INTEGER;
    RID6  INTEGER;
    RTOT  INTEGER;

  BEGIN

    WS_ID := W_ID;
    ID1   := NVL(TO_NUMBER(SUBSTR(WS_ID, 1, 1)), 0);
    ID2   := NVL(TO_NUMBER(SUBSTR(WS_ID, 2, 1)), 0);
    ID3   := NVL(TO_NUMBER(SUBSTR(WS_ID, 3, 1)), 0);
    ID4   := NVL(TO_NUMBER(SUBSTR(WS_ID, 4, 1)), 0);
    ID5   := NVL(TO_NUMBER(SUBSTR(WS_ID, 5, 1)), 0);
    ID6   := NVL(TO_NUMBER(SUBSTR(WS_ID, 6, 1)), 0);
    --
    RID6 := ID6 * 2;
    RID5 := ID5 * 3;
    RID4 := ID4 * 4;
    RID3 := ID3 * 5;
    RID2 := ID2 * 6;
    RID1 := ID1 * 7;
    --
    RTOT := (RID6 + RID5 + RID4 + RID3 + RID2 + RID1);
    --
    IF MOD(RTOT, 11) = 0 OR MOD(RTOT, 11) = 1 THEN
      DV := 0;
    ELSE
      DV := 11 - MOD(RTOT, 11);
    END IF;
    --
    RETURN DV;
    --
  END F_RETORNA_DV_ID;


  /***************************************************************************************/
  /* INICIO DA PROCEDURE SP_VALIDA_DADOS_EXTERNO                                         */
  /***************************************************************************************/
  PROCEDURE SP_VALIDA_DADOS_EXTERNO(P_IN_OUT_REG_FUNCIONARIOS  IN OUT FUNCIONARIOS%ROWTYPE
                                   ,P_OUT_ERRO                 OUT VARCHAR2) IS

  BEGIN

    BEGIN
      INSERT INTO RHEV.FUNCIONARIOS
        (ID
        ,NOME
        ,ENDERECO
        ,NRO_END
        ,COMPLEMENTO_END
        ,BAIRRO
        ,CIDADE
        ,ESTADO
        ,CEP
        ,CODIGO_DDD
        ,TELEFONE
        ,RAMAL
        ,ESTADO_CIVIL
        ,SEXO
        ,DATA_NASCIMENTO
        ,PAIS_NASCIMENTO
        ,NACIONALIDADE
        ,CIDADE_NASCIMENTO
        ,ESTADO_NASCIMENTO
        ,NOME_PAI
        ,NOME_MAE
        ,NACIONALIDADE_PAI
        ,NACIONALIDADE_MAE
        ,NATURALIZADO
        ,DATA_CHEGADA_PAIS
        ,NRO_CARTEIRA_MODELO_19
        ,TIPO_VISTO_ESTRANGEIRO
        ,CART_PROFISSIONAL_NRO
        ,CART_PROFISSIONAL_SERIE
        ,CART_PROFISSIONAL_LETRA
        ,CART_PROFISSIONAL_EST_EMISSOR
        ,CART_PROFISSIONAL_DATA_EXPED
        ,CART_PROFISSIONAL_DATA_VALID
        ,PIS_NRO
        ,PIS_PASEP_DATA_EXPED
        ,TIPO_PROG_INTEGRACAO
        ,CERT_RESERVISTA_NRO
        ,COMPLEMENTO_CERT_RESERVISTA
        ,RG_NRO
        ,RG_COMPLEMENTO
        ,RG_ORGAO_EMISSOR
        ,RG_ESTADO_EMISSOR
        ,RG_DATA_EXPEDICAO
        ,CIC_NRO
        ,COMPLEMENTO_CIC_NRO
        ,TITULO_ELEITOR_NRO
        ,TITULO_ELEITOR_ZONA
        ,TITULO_ELEITOR_SECAO
        ,CART_HABILITACAO_NRO
        ,CART_HABILITACAO_CATEGORIA
        ,GRAU_ESCOLARIDADE
        ,ORGAO_CLASSE
        ,REGIAO_CLASSE
        ,NRO_REG_CLASSE
        --,ID_CARGO
        --,ID_DESCRICAO
        ,COD_UNIORG
        ,UNIORG_CGC
        ,TIPO_COLAB
        ,RECEBE_CREDITO_BANCO
        ,ATIVO
        ,CTR_PONTO
        ,BASE_ORIGEM
        ,BASE_ORIGEM_MUNICIPIO
        ,MOTIVO_CONTRATACAO)
      VALUES
        (9999999
        ,P_IN_OUT_REG_FUNCIONARIOS.NOME
        ,P_IN_OUT_REG_FUNCIONARIOS.ENDERECO
        ,P_IN_OUT_REG_FUNCIONARIOS.NRO_END
        ,P_IN_OUT_REG_FUNCIONARIOS.COMPLEMENTO_END
        ,P_IN_OUT_REG_FUNCIONARIOS.BAIRRO
        ,P_IN_OUT_REG_FUNCIONARIOS.CIDADE
        ,P_IN_OUT_REG_FUNCIONARIOS.ESTADO
        ,P_IN_OUT_REG_FUNCIONARIOS.CEP
        ,P_IN_OUT_REG_FUNCIONARIOS.CODIGO_DDD
        ,P_IN_OUT_REG_FUNCIONARIOS.TELEFONE
        ,P_IN_OUT_REG_FUNCIONARIOS.RAMAL
        ,P_IN_OUT_REG_FUNCIONARIOS.ESTADO_CIVIL
        ,P_IN_OUT_REG_FUNCIONARIOS.SEXO
        ,P_IN_OUT_REG_FUNCIONARIOS.DATA_NASCIMENTO
        ,P_IN_OUT_REG_FUNCIONARIOS.PAIS_NASCIMENTO
        ,P_IN_OUT_REG_FUNCIONARIOS.NACIONALIDADE
        ,P_IN_OUT_REG_FUNCIONARIOS.CIDADE_NASCIMENTO
        ,P_IN_OUT_REG_FUNCIONARIOS.ESTADO_NASCIMENTO
        ,P_IN_OUT_REG_FUNCIONARIOS.NOME_PAI
        ,P_IN_OUT_REG_FUNCIONARIOS.NOME_MAE
        ,P_IN_OUT_REG_FUNCIONARIOS.NACIONALIDADE_PAI
        ,P_IN_OUT_REG_FUNCIONARIOS.NACIONALIDADE_MAE
        ,P_IN_OUT_REG_FUNCIONARIOS.NATURALIZADO
        ,P_IN_OUT_REG_FUNCIONARIOS.DATA_CHEGADA_PAIS
        ,P_IN_OUT_REG_FUNCIONARIOS.NRO_CARTEIRA_MODELO_19
        ,P_IN_OUT_REG_FUNCIONARIOS.TIPO_VISTO_ESTRANGEIRO
        ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_NRO
        ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_SERIE
        ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_LETRA
        ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_EST_EMISSOR
        ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_DATA_EXPED
        ,P_IN_OUT_REG_FUNCIONARIOS.CART_PROFISSIONAL_DATA_VALID
        ,P_IN_OUT_REG_FUNCIONARIOS.PIS_NRO
        ,P_IN_OUT_REG_FUNCIONARIOS.PIS_PASEP_DATA_EXPED
        ,P_IN_OUT_REG_FUNCIONARIOS.TIPO_PROG_INTEGRACAO
        ,P_IN_OUT_REG_FUNCIONARIOS.CERT_RESERVISTA_NRO
        ,P_IN_OUT_REG_FUNCIONARIOS.COMPLEMENTO_CERT_RESERVISTA
        ,P_IN_OUT_REG_FUNCIONARIOS.RG_NRO
        ,P_IN_OUT_REG_FUNCIONARIOS.RG_COMPLEMENTO
        ,P_IN_OUT_REG_FUNCIONARIOS.RG_ORGAO_EMISSOR
        ,P_IN_OUT_REG_FUNCIONARIOS.RG_ESTADO_EMISSOR
        ,P_IN_OUT_REG_FUNCIONARIOS.RG_DATA_EXPEDICAO
        ,P_IN_OUT_REG_FUNCIONARIOS.CIC_NRO
        ,P_IN_OUT_REG_FUNCIONARIOS.COMPLEMENTO_CIC_NRO
        ,P_IN_OUT_REG_FUNCIONARIOS.TITULO_ELEITOR_NRO
        ,P_IN_OUT_REG_FUNCIONARIOS.TITULO_ELEITOR_ZONA
        ,P_IN_OUT_REG_FUNCIONARIOS.TITULO_ELEITOR_SECAO
        ,P_IN_OUT_REG_FUNCIONARIOS.CART_HABILITACAO_NRO
        ,P_IN_OUT_REG_FUNCIONARIOS.CART_HABILITACAO_CATEGORIA
        ,P_IN_OUT_REG_FUNCIONARIOS.GRAU_ESCOLARIDADE
        ,P_IN_OUT_REG_FUNCIONARIOS.ORGAO_CLASSE
        ,P_IN_OUT_REG_FUNCIONARIOS.REGIAO_CLASSE
        ,P_IN_OUT_REG_FUNCIONARIOS.NRO_REG_CLASSE
        --,P_IN_OUT_REG_FUNCIONARIOS.ID_CARGO
        --,P_IN_OUT_REG_FUNCIONARIOS.ID_CARGO
        ,P_IN_OUT_REG_FUNCIONARIOS.COD_UNIORG
        ,P_IN_OUT_REG_FUNCIONARIOS.UNIORG_CGC
        ,P_IN_OUT_REG_FUNCIONARIOS.TIPO_COLAB
        ,P_IN_OUT_REG_FUNCIONARIOS.RECEBE_CREDITO_BANCO
        ,P_IN_OUT_REG_FUNCIONARIOS.ATIVO
        ,P_IN_OUT_REG_FUNCIONARIOS.CTR_PONTO
        ,P_IN_OUT_REG_FUNCIONARIOS.BASE_ORIGEM
        ,P_IN_OUT_REG_FUNCIONARIOS.BASE_ORIGEM_MUNICIPIO
        ,P_IN_OUT_REG_FUNCIONARIOS.MOTIVO_CONTRATACAO);

    EXCEPTION
      WHEN OTHERS THEN
        P_OUT_ERRO := SQLERRM;
    END;
    ---------
    ROLLBACK;
    ---------
  END SP_VALIDA_DADOS_EXTERNO;


  /***************************************************************************************/
  /* INICIO DA PROCEDURE SP_VALIDA_DADOS_INTERNO                                         */
  /***************************************************************************************/
  PROCEDURE SP_VALIDA_DADOS_INTERNO(P_IN_OUT_REG_FUNCIONARIOS  IN OUT FUNCIONARIOS%ROWTYPE
                                   ,P_IN_REQUISICAO_SQ         IN REQUISICAO.REQUISICAO_SQ%TYPE
                                   ,P_OUT_SUCESSO              OUT NUMBER
                                   ,P_OUT_MSG                  OUT VARCHAR2) IS

    V_ID_VALIDO NUMBER;

  BEGIN

    -- Validando o tipo de recrutamento através do id do funcionário informado
    IF (P_IN_OUT_REG_FUNCIONARIOS.ID IS NULL) THEN
      P_OUT_SUCESSO := -1;
      P_OUT_MSG := 'ERRO NO TIPO DE RECRUTAMENTO/FUNCIONÁRIO: A RP EXIGE UM COLABORADOR INTERNO';
    ELSE
      -- Validando o id do funcionário
      SELECT COUNT(*)
      INTO   V_ID_VALIDO
      FROM   FUNCIONARIOS F
      WHERE  F.ID = P_IN_OUT_REG_FUNCIONARIOS.ID
      AND    F.TIPO_COLAB <> 'P';

      IF (V_ID_VALIDO = 0) THEN
        P_OUT_SUCESSO := -1;
        P_OUT_MSG := 'ERRO NO PARÂMETRO P_IN_ID_FUNCIONARIO: FUNCIONÁRIO NÃO ENCONTRADO';
      ELSE
        -- Verifica se o funcionário possui duplo vínculo
        SELECT COUNT(*)
        INTO   V_ID_VALIDO
        FROM   FUNCIONARIOS F
        WHERE  F.CIC_NRO = P_IN_OUT_REG_FUNCIONARIOS.CIC_NRO
        AND    F.COMPLEMENTO_CIC_NRO = P_IN_OUT_REG_FUNCIONARIOS.COMPLEMENTO_CIC_NRO
        AND    F.TIPO_COLAB <> 'P'
        AND    F.ATIVO = 'A';

        IF (V_ID_VALIDO > 1) THEN
           P_OUT_SUCESSO := -2;
           P_OUT_MSG := 'ERRO NA BAIXA DA RP: FUNCIONÁRIO POSSUI DUPLO VÍNCULO, A BAIXA DEVE SER REALIZADA MANUALMENTE';
             
          -- Notifica que a baixa deve ser realizada manualmente
          /*SP_NOTIFICA_BAIXA(P_IN_REQUISICAO_SQ
                           ,P_IN_OUT_REG_FUNCIONARIOS
                           ,3);*/
                             
        ELSE
           P_OUT_SUCESSO := P_IN_OUT_REG_FUNCIONARIOS.ID;
           P_OUT_MSG := NULL;
        END IF;
      END IF;
    END IF;
    
  EXCEPTION
    WHEN OTHERS THEN
      P_OUT_SUCESSO := -1;
      P_OUT_MSG := SQLERRM;

  END SP_VALIDA_DADOS_INTERNO;


  /***************************************************************************************/
  /* INICIO DA PROCEDURE SP_IN_LOG_EXPORTACAO                                            */
  /***************************************************************************************/
  PROCEDURE SP_IN_LOG_EXPORTACAO(P_IN_REQUISICAO_SQ IN LOG_EXPORTACAO.REQUISICAO_SQ%TYPE
                                ,P_IN_DSC_LOG       IN LOG_EXPORTACAO.DSC_LOG%TYPE
                                ,P_IN_USER_LOG      IN LOG_EXPORTACAO.USER_LOG%TYPE) IS
  BEGIN

    INSERT INTO LOG_EXPORTACAO
      (REQUISICAO_SQ
      ,DSC_LOG
      ,USER_LOG)
    VALUES
      (P_IN_REQUISICAO_SQ
      ,P_IN_DSC_LOG
      ,P_IN_USER_LOG);

  END SP_IN_LOG_EXPORTACAO;
  
  /***************************************************************************************/
  /* NOTIFICA VIA EMAIL A INTEGRAÇÃO DO FUNCIONÁRIO                                      */
  /***************************************************************************************/
  
  PROCEDURE SP_NOTIFICA_INTEGRACAO_RHEV(P_IN_FUNCIONARIO IN FUNCIONARIOS%ROWTYPE) IS
    
  V_TESTE        VARCHAR2(10);
  V_EMAIL_TESTES VARCHAR2(500);
  V_DESTINATARIO VARCHAR2(500):= 'gepcontratacoes@sp.senac.br';
  V_BANCO_PROD   ADM_TI.BANCO_PROD;
  V_CORPO        CLOB;
  
  BEGIN 
    
    V_BANCO_PROD := ADM_TI.BANCO_PROD();
    IF (V_BANCO_PROD.V_PROD != 1) THEN
       V_TESTE := ' TESTE';
       V_DESTINATARIO := V_BANCO_PROD.EMAIL_TESTE(7);
    END IF;          
  
    --------------------------------------------------------------------
    -- MONTANDO O CORPO DO E-MAIL
    --------------------------------------------------------------------
    V_CORPO := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
    V_CORPO := V_CORPO || '<html xmlns="http://www.w3.org/1999/xhtml">';
    V_CORPO := V_CORPO || '<head>';
    V_CORPO := V_CORPO || '<title>DADOS DO CANDIDATO</title>';
    V_CORPO := V_CORPO || '<meta http-equiv=expires content="Mon, 06 Jan 1990 00:00:01 GMT">';
    V_CORPO := V_CORPO || '<meta http-equiv="pragma" content="no-cache">';
    V_CORPO := V_CORPO || '<meta http-equiv="cache-control" content="no-cache">';
    V_CORPO := V_CORPO || '<style type="text/css">';
    V_CORPO := V_CORPO || '  td { font-size: 10px; font-family: Verdana; }';
    V_CORPO := V_CORPO || '</style>';
    V_CORPO := V_CORPO || '</head>';
    V_CORPO := V_CORPO || '<body>';
    V_CORPO := V_CORPO || '<table border="0" width="500" cellpadding="0" cellspacing="0" style="background-color: #E7F3FF;" align="center">';
    V_CORPO := V_CORPO || '  <tr>';
    V_CORPO := V_CORPO || '    <td style="background-color: #6699CC; text-transform: uppercase; padding: 3px; font-weight: bold; color: #fff; text-align: left;">';
    V_CORPO := V_CORPO || '      DADOS DO CANDIDATO';
    V_CORPO := V_CORPO || '    </td>';
    V_CORPO := V_CORPO || '  </tr>';
    V_CORPO := V_CORPO || '  <tr>';
    V_CORPO := V_CORPO || '    <td style="padding: 20px;">  ';
    V_CORPO := V_CORPO || '      <p>';
    V_CORPO := V_CORPO || '        <table border="0" cellpadding="2" cellspacing="0" width="100%">';
    V_CORPO := V_CORPO || '          <tr>';
    V_CORPO := V_CORPO || '            <td width="30%"><b>Id:</b></td>';
    V_CORPO := V_CORPO || '            <td>'|| P_IN_FUNCIONARIO.ID ||'</td>';
    V_CORPO := V_CORPO || '          </tr>';
    V_CORPO := V_CORPO || '          <tr>';
    V_CORPO := V_CORPO || '            <td width="30%"><b>Nome:</b></td>';
    V_CORPO := V_CORPO || '            <td>'|| P_IN_FUNCIONARIO.NOME ||'</td>';
    V_CORPO := V_CORPO || '          </tr>';
    V_CORPO := V_CORPO || '          <tr>';
    V_CORPO := V_CORPO || '            <td width="30%"><b>Data de Nascimento:</b></td>';
    V_CORPO := V_CORPO || '            <td>'|| TO_CHAR(P_IN_FUNCIONARIO.DATA_NASCIMENTO,'dd/mm/yyyy') ||'</td>';
    V_CORPO := V_CORPO || '          </tr>';
    V_CORPO := V_CORPO || '          <tr>';
    V_CORPO := V_CORPO || '            <td width="30%"><b>CPF:</b></td>';
    V_CORPO := V_CORPO || '            <td>'|| regexp_replace(LPAD(LPAD(TO_CHAR(P_IN_FUNCIONARIO.CIC_NRO),9,'0') || LPAD(TO_CHAR(P_IN_FUNCIONARIO.COMPLEMENTO_CIC_NRO),2,'0'), 11),'([0-9]{3})([0-9]{3})([0-9]{3})','\1.\2.\3-') || '</td>';
    V_CORPO := V_CORPO || '          </tr>';
    V_CORPO := V_CORPO || '          <tr>';
    V_CORPO := V_CORPO || '            <td width="30%"><b>NIS:</b></td>';
    V_CORPO := V_CORPO || '            <td>'|| P_IN_FUNCIONARIO.PIS_NRO ||'</td>';
    V_CORPO := V_CORPO || '          </tr>';
    V_CORPO := V_CORPO || '        </table>';
    V_CORPO := V_CORPO || '      </p>';
    V_CORPO := V_CORPO || '    </td>';
    V_CORPO := V_CORPO || '  </tr>';
    V_CORPO := V_CORPO || '  <tr>';
    V_CORPO := V_CORPO || '    <td style="background-color: #E7F3FF;" height="3"></td>';
    V_CORPO := V_CORPO || '  </tr>';
    V_CORPO := V_CORPO || '  <tr>';
    V_CORPO := V_CORPO || '    <td style="padding: 20px; text-align: center; background-color: #fff; border-top: solid 5px #6699CC;">';
    V_CORPO := V_CORPO || '      Esta é uma mensagem automática, por favor não responda este e-mail.';
    V_CORPO := V_CORPO || '    </td>';
    V_CORPO := V_CORPO || '  </tr>';
    V_CORPO := V_CORPO || '</table>';
    V_CORPO := V_CORPO || '</body>';
    V_CORPO := V_CORPO || '</html>';
    
    --------------------------------------------------------------------
    -- ENVIANDO O E-MAIL
    --------------------------------------------------------------------
    ADM_TI.SP_SEND_MAIL(P_SUBJECT => 'Integração Banco de Talentos -> Rhevolution - Candidato cadastrado' || V_TESTE,
                        P_MESSAGE => V_CORPO,
                        P_FROM    => 'naoresponda@sp.senac.br',
                        P_TO      => V_DESTINATARIO,
                        P_HEAD    => 'N');
                        
  EXCEPTION
    WHEN OTHERS THEN
      ADM_TI.SP_SEND_MAIL(P_SUBJECT => 'Erro ao tentar notificar a Integração Banco de Talentos -> Rhevolution' || V_TESTE,
                        P_MESSAGE => 'Ocorreu o erro ' || SQLERRM || ' ao tentar notificar a integração.',
                        P_FROM    => 'naoresponda@sp.senac.br',
                        P_TO      => 'ges_suporte@sp.senac.br',
                        P_HEAD    => 'N');
    
  END SP_NOTIFICA_INTEGRACAO_RHEV;

END INTEGRACAO_PKG;
/
