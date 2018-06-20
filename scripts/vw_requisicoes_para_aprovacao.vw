CREATE OR REPLACE FORCE VIEW REQPES.VW_REQUISICOES_PARA_APROVACAO AS
SELECT
      -------------------------------------------------
      -- VIEW QUE LISTA TODAS AS RP's PARA APROVAÇÃO
      -- Author: Thiago Lima Coutinho
      -- Date  : 9/9/2009
      -------------------------------------------------
       R.REQUISICAO_SQ
      ,TO_CHAR(R.DT_REQUISICAO,'dd/mm/yyyy') AS DT_REQUISICAO
      ,R.CARGO_SQ
      ,CD.DESCRICAO CARGO
      ,R.COD_UNIDADE
      ,R.COD_STATUS
      ,RS.DSC_STATUS
      ,R.IND_TIPO_REQUISICAO
      ,UO.COD_UNIDADE AS COD_UNIDADE_NUM
      ,HR.NIVEL       AS NIVEL_WORKFLOW
      ,HR.COD_UNIDADE AS COD_UNIDADE_DESTINO
      ,DT_REQUISICAO  AS DT_REQUISICAO_SQL
      ,HR.DT_ENVIO
      ,TRIM(UO.SIGLA)       AS SGL_UNIDADE
      ,TRIM(UPPER(UO.NOME)) AS NOM_UNIDADE
      ,R.USUARIO_SQ

FROM   REQUISICAO           R
      ,CARGO_DESCRICOES     CD
      ,REQUISICAO_STATUS    RS
      ,UNIDADE              UO
      ,HISTORICO_REQUISICAO HR

WHERE  R.CARGO_SQ                 = CD.ID (+)
AND    LPAD(UO.COD_UNIDADE,3,'0') = SUBSTR(R.COD_UNIDADE, 1, 3)
AND    R.REQUISICAO_SQ            = HR.REQUISICAO_SQ
AND    R.COD_STATUS               = RS.COD_STATUS
AND    R.COD_STATUS               IN (1,2,3) -- ABERTA, EM HOMOLOGAÇÃO, EM REVISÃO
-- Visualizando ultimo nivel no Workflow
AND    HR.DT_ENVIO                = (SELECT MAX(HR1.DT_ENVIO)
                                     FROM   HISTORICO_REQUISICAO HR1
                                     WHERE  HR1.REQUISICAO_SQ  = HR.REQUISICAO_SQ AND STATUS<>'alterou')
;
grant select on REQPES.VW_REQUISICOES_PARA_APROVACAO to AN$RHEV;


