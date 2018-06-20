CREATE OR REPLACE FORCE VIEW REQPES.VW_DADOS_COMPLETOS_REQUISICAO AS
SELECT
      -------------------------------------------------
      -- VIEW QUE LISTA TODAS AS INFORMAÇÕES DAS RP's
      -- Author: Thiago Lima Coutinho
      -- Date  : 9/9/2009

      -- Modificações
      -- 14/07/2010: Retirado os horários de trabalho (Thiago)
      -- 17/01/2012: Alterada a estrutura do Centro de Custo (Thiago)
      -------------------------------------------------
       R.REQUISICAO_SQ
      ,R.COD_UNIDADE
      ,UO.DESCRICAO AS DSC_UNIDADE
      ,UO.DESCRICAO_ING AS DSC_UNIDADE_ING
      ,R.USUARIO_SQ AS COD_USUARIO_SQ_CRIACAO
      ,R.CARGO_SQ   AS COD_CARGO
      ,C.DESCRICAO  AS DSC_CARGO
      ,R.COD_MA
      ,R.COD_SMA
      ,R.COTA
      ,R.TP_CONTRATACAO     AS COD_TP_CONTRATACAO
      ,TC.DESCRICAO         AS DSC_TIPO_CONTRATACAO
      ,R.NM_SUPERIOR        AS NOM_SUPERIOR
      ,R.FONE_UNIDADE
      ,R.JORNADA_TRABALHO
      ,R.LOCAL_TRABALHO     AS COD_LOCAL_TRABALHO
      ,DECODE (R.LOCAL_TRABALHO, '1', 'NA GERENCIA/UO SOLICITANTE'
                               , '2', 'OUTROS'
                               , 'NÃO INFORMADO') AS DSC_LOCAL_TRABALHO

      ,R.MOTIVO_SOLICITACAO AS COD_RP_PARA
      ,SM.DESCRICAO         AS DSC_RP_PARA
      ,R.OBS                AS COMENTARIOS
      ,DECODE(R.SUPERVISAO, 'S', 'SIM'
                          , 'N', 'NÃO'
                          , 'NÃO INFORMADO') AS IND_SUPERVISAO
      ,R.NR_FUNCIONARIO
      ,R.DS_TAREFA        AS TAREFAS_DESEMPENHADAS
      ,R.VIAGEM           AS COD_VIAGEM
      ,DECODE(R.VIAGEM, '1', 'FREQUENTES'
                      , '2', 'RARAS'
                      , 'NÃO INFORMADO') AS DSC_VIAGEM

      ,TRIM(TO_CHAR(R.SALARIO,'999G999D99')) AS SALARIO
      ,R.OUTRO_LOCAL
      ,R.NM_INDICADO     AS NOM_INDICADO
      ,TO_CHAR(R.INICIO_CONTRATACAO, 'mm/yyyy') AS DAT_INICIO_CONTRATACAO
      ,TO_CHAR(R.FIM_CONTRATACAO, 'mm/yyyy')    AS DAT_FIM_CONTRATACAO

      ,R.COD_RECRUTAMENTO
      ,RC.DESCRICAO           AS DSC_RECRUTAMENTO
      ,TRUNC(R.DT_REQUISICAO) AS DAT_REQUISICAO
      ,R.RAZAO_SUBSTITUICAO   AS COD_MOTIVO_SOLICITACAO
      ,TM.DES_MOTIVO          AS DSC_MOTIVO_SOLICITACAO

      ,R.DS_MOTIVO_SOLICITACAO    AS JUSTIFICATIVA
      ,R.CLASSIFICACAO_FUNCIONAL  AS COD_CLASSIF_FUNCIONAL
      ,CF.CLFU_DES                AS DSC_CLASSIF_FUNCIONAL
      ,R.ID_INDICADO              AS CHAPA_FUNC_INDICADO
      ,FI.NOME                    AS NOM_FUNC_INDICADO
      ,R.SUBSTITUIDO_ID_HIST      AS CHAPA_FUNC_SUBSTITUIDO
      ,FS.NOME                    AS NOM_FUNC_SUBSTITUIDO
      ,TO_CHAR(R.TRANSFERENCIA_DATA, 'dd/mm/yyyy') AS TRANSFERENCIA_DATA

      ,DECODE(R.IND_CARTA_CONVTE, 'S', 'SIM'
                                , 'N', 'NÃO'
                                , 'NÃO INFORMADO') AS IND_CARTA_CONVTE
      ,DECODE(R.IND_EX_CARTA_CONVTE, 'S', 'SIM'
                                   , 'N', 'NÃO'
                                   , 'NÃO INFORMADO') AS IND_EX_CARTA_CONVTE
      ,DECODE(R.IND_EX_FUNCIONARIO, 'S', 'SIM'
                                  , 'N', 'NÃO'
                                  , 'NÃO INFORMADO') AS IND_EX_FUNCIONARIO
      ,R.ID_CODE_COMBINATION
      ,R.COD_SEGMENTO1
      ,R.COD_SEGMENTO2
      ,R.COD_SEGMENTO3
      ,R.COD_SEGMENTO4
      ,R.COD_SEGMENTO5
      ,R.COD_SEGMENTO6
      ,R.COD_SEGMENTO7
      ,NVL(RC.DESCRICAO,'NÃO INFORMADO') AS TIPO_REQUISICAO
      ,R.COD_STATUS
      ,RS.DSC_STATUS
      ,TRIM(UO.SIGLA) AS SIGLA_UNIDADE

      -- JORNADA
      ,RJ.COD_ESCALA
      ,RJ.ID_CALENDARIO

      -- PERFIL
      ,DECODE(RP.SEXO, 'I', 'INDIFERENTE'
                     , 'M', 'MASCULINO'
                     , 'F', 'FEMININO') AS SEXO
      ,E.DESCRICAO                      AS DSC_FORMACAO
      ,RP.DS_FORMACAO                   AS DSC_FORMACAO_DESEJADA
      ,RP.FAIXA_ETARIA_INI
      ,RP.FAIXA_ETARIA_FIM
      ,RP.OUTRAS_CARATERISTICA          AS DSC_OUTRAS_CARACTERISTICAS
      ,RP.EXPERIENCIA                   AS TEMPO_EXPERIENCIA
      ,DECODE(RP.TP_EXPERIENCIA, NULL,'NÃO INFORMADO'
                               , RP.TP_EXPERIENCIA) AS DSC_TIPO_EXPERIENCIA
      ,RP.COMENTARIOS     AS PERFIL_COMENTARIO
      ,UOI.DESCRICAO      AS UNIDADE_FUNC_INDICADO
      ,RB.FUNCIONARIO_ID  AS CHAPA_FUNC_BAIXADO
      ,FB.NOME            AS NOM_FUNC_BAIXADO

      -- NOVOS CAMPOS (RECRUTAMENTO E SELECÃO)
      ,R.DSC_RECRUTAMENTO             AS JUST_RECRUTAMENTO
      ,AREA.NOME                      AS DSC_AREA
      ,RP.COD_FUNCAO
      -- 05/10/2011 Thiago
      --,RF.NOME                        AS DSC_FUNCAO
      ,F_GET_PERFIL_DSC_FUNCAO(R.REQUISICAO_SQ) AS DSC_FUNCAO
      ,NIVEL_HIERARQUIA.NOME   AS DSC_NIVEL_HIERARQUIA
      ,RP.DSC_OPORTUNIDADE
      ,RP.DSC_ATIVIDADES_CARGO
      ,DECODE(R.IND_CARATER_EXCECAO,'S','SIM', 'NÃO') AS IND_CARATER_EXCECAO
      ,RP.DSC_EXPERIENCIA
      ,DECODE(R.IND_TIPO_REQUISICAO, 'A', 'ADMISSÃO', 'T', 'TRANSFERENCIA') AS IND_TIPO_REQUISICAO
      ,R.VERSAO_SISTEMA
      ,RP.DSC_CONHECIMENTOS
FROM   REQUISICAO                R
      ,CARGO_DESCRICOES          C
      ,TIPO_CONTRATACAO          TC
      ,SOLICITACAO_MOTIVO        SM
      ,RECRUTAMENTO              RC
      ,MOTIVOS_CONTRATACAO       TM
      ,CLASSIFICACAO_FUNCIONAL   CF
      ,FUNCIONARIOS              FI
      ,FUNCIONARIOS              FS
      ,FUNCIONARIOS              FB
      ,REQUISICAO_STATUS         RS
      ,UNIDADES_ORGANIZACIONAIS  UO
      ,UNIDADES_ORGANIZACIONAIS  UOI
      ,REQUISICAO_JORNADA        RJ
      ,REQUISICAO_PERFIL         RP
      ,ESCOLARIDADES             E
      ,REQUISICAO_BAIXA          RB
      --,RECRU_FUNCAO              RF
      ,(SELECT ID_TIPO
              ,NOME
        FROM  RECRU.RECRU_TIPO
        WHERE GRUPO = 'AREA_VAGA') AREA

      ,(SELECT ID_TIPO
              ,NOME
        FROM  RECRU.RECRU_TIPO
        WHERE GRUPO = 'NIVEL_HIERARQUIA') NIVEL_HIERARQUIA

WHERE c.ID                      (+) = r.CARGO_SQ
AND   TC.COD_TIPO_CONTRATACAO   (+) = R.TP_CONTRATACAO
AND   SM.ID                     (+) = R.MOTIVO_SOLICITACAO
AND   RC.ID_RECRUTAMENTO        (+) = R.COD_RECRUTAMENTO
AND   TM.COD_MOTIVO             (+) = R.RAZAO_SUBSTITUICAO
AND   CF.CLFU_COD               (+) = R.CLASSIFICACAO_FUNCIONAL
AND   FI.ID                     (+) = R.ID_INDICADO
AND   FS.ID                     (+) = R.SUBSTITUIDO_ID_HIST
AND   FB.ID                     (+) = RB.FUNCIONARIO_ID
AND   RS.COD_STATUS             (+) = R.COD_STATUS
AND   RJ.REQUISICAO_SQ          (+) = R.REQUISICAO_SQ
AND   RP.REQUISICAO_SQ          (+) = R.REQUISICAO_SQ
AND   RB.REQUISICAO_SQ          (+) = R.REQUISICAO_SQ
AND   E.CODIGO                  (+) = RP.SQ_NIVEL
AND   UO.CODIGO                 (+) = R.COD_UNIDADE
AND   UOI.CODIGO                (+) = FI.COD_UNIORG
AND   AREA.ID_TIPO              (+) = RP.COD_AREA
AND   NIVEL_HIERARQUIA.ID_TIPO  (+) = RP.COD_NIVEL_HIERARQUIA
--AND   RF.ID_FUNCAO              (+) = RP.COD_FUNCAO
;
grant select on REQPES.VW_DADOS_COMPLETOS_REQUISICAO to AN$RHEV;


