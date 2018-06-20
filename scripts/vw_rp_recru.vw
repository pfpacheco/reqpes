CREATE OR REPLACE FORCE VIEW REQPES.VW_RP_RECRU AS
SELECT
      ------------------------------------------------------------------------
      -- VIEW UTILIZADA PELO SISTEMA DE RECRUTAMENTO E SELE��O
      -- Author: Thiago Lima Coutinho
      -- Date  : 9/9/2009
      ------------------------------------------------------------------------
       T.REQUISICAO_SQ
       -- UNIDADE
      ,COD_UNIDADE
      ,SIGLA_UNIDADE
      ,DSC_UNIDADE_ING AS DSC_UNIDADE -- 20/10/2011 Thiago, solicita��o da GCR (Unidade com acentua��o)
      ,UE.BAIRRO AS DSC_BAIRRO_UNID
      ,UE.CIDADE AS DSC_CIDADE_UNID
      ,NOM_SUPERIOR
      ,FONE_UNIDADE
      -- RP
      ,COD_STATUS
      ,DSC_STATUS
      ,COD_USUARIO_SQ_CRIACAO
      ,COD_CARGO
      ,DSC_CARGO
      ,COTA
      ,SALARIO
      ,COD_TP_CONTRATACAO
      ,DSC_TIPO_CONTRATACAO
      ,JORNADA_TRABALHO
      ,COD_LOCAL_TRABALHO
      ,DSC_LOCAL_TRABALHO
      ,COD_RP_PARA
      ,DSC_RP_PARA
      ,IND_SUPERVISAO
      ,NR_FUNCIONARIO
      ,TAREFAS_DESEMPENHADAS
      ,COD_VIAGEM
      ,DSC_VIAGEM
      ,OUTRO_LOCAL
      ,NOM_INDICADO
      ,DAT_INICIO_CONTRATACAO
      ,DAT_FIM_CONTRATACAO
      ,COD_RECRUTAMENTO
      ,DSC_RECRUTAMENTO
      ,JUST_RECRUTAMENTO
      ,DAT_REQUISICAO
      ,COD_MOTIVO_SOLICITACAO
      ,DSC_MOTIVO_SOLICITACAO
      ,JUSTIFICATIVA
      ,COD_CLASSIF_FUNCIONAL
      ,DSC_CLASSIF_FUNCIONAL
      ,CHAPA_FUNC_SUBSTITUIDO
      ,NOM_FUNC_SUBSTITUIDO
      ,TRANSFERENCIA_DATA
      ,IND_CARTA_CONVTE
      ,IND_EX_CARTA_CONVTE
      ,IND_EX_FUNCIONARIO
      -- SEGMENTOS
      ,COD_MA
      ,COD_SMA
      ,ID_CODE_COMBINATION
      ,COD_SEGMENTO1
      ,COD_SEGMENTO2
      ,COD_SEGMENTO3
      ,COD_SEGMENTO4
      ,COD_SEGMENTO5
      ,COD_SEGMENTO6
      ,COD_SEGMENTO7
      -- HORARIO
      ,COD_ESCALA
      ,ID_CALENDARIO
      -- PERFIL
      ,SEXO
      ,FAIXA_ETARIA_INI
      ,FAIXA_ETARIA_FIM
      ,TEMPO_EXPERIENCIA
      ,DSC_TIPO_EXPERIENCIA
      ,DSC_AREA
      ,COD_FUNCAO
      ,DSC_FUNCAO
      ,DSC_NIVEL_HIERARQUIA
      ,DSC_OPORTUNIDADE
      ,DSC_ATIVIDADES_CARGO
      ,NVL(DSC_FORMACAO_DESEJADA,DSC_FORMACAO) AS DSC_ESCOL_FORM_DESEJADA
      ,DSC_OUTRAS_CARACTERISTICAS AS DSC_COMPET_CONHECIMENTOS
      ,PERFIL_COMENTARIO COMENTARIOS
      ,DSC_EXPERIENCIA
      ,DSC_CONHECIMENTOS
      -- BAIXA
      ,CHAPA_FUNC_BAIXADO
      ,NOM_FUNC_BAIXADO
      ,APR.DT_ENVIO AS DAT_ULTIMA_APROVACAO

FROM   VW_DADOS_COMPLETOS_REQUISICAO T
      ,UNIORG_ENDERECO               UE

/*
WHERE  T.COD_STATUS IN (4, 7, 8) -- APROVADA / CANCELADA / EXPIRADA

      -- VISUALIZA��O DE TODAS AS RP's QUE J� FORAM APROVADAS
      -- Autor: Thiago Lima Coutinho
      -- Data: 28/04/2010
      -- Solicitante: Bruno Bucci Xavier / Alexandre Kiyoshi Ishida
*/

      ,(SELECT H1.REQUISICAO_SQ, MAX(H1.DT_ENVIO) AS DT_ENVIO
        FROM   HISTORICO_REQUISICAO H1
        WHERE  H1.NIVEL = 5
        GROUP BY REQUISICAO_SQ) APR

WHERE  UO_CODIGO_NIVEL(T.COD_UNIDADE,1) = UE.COD_UNIORG(+)
AND    T.REQUISICAO_SQ = APR.REQUISICAO_SQ
;
grant select on REQPES.VW_RP_RECRU to AN$RHEV;

