CREATE OR REPLACE FORCE VIEW REQPES.VW_REQUISICOES_PARA_ESTORNO AS
SELECT
      -------------------------------------------------
      -- VIEW QUE LISTA TODAS AS RP's PARA ESTORNO
      -- Author: Thiago Lima Coutinho
      -- Date  : 9/9/2009

      -- Log de alteração
      -- 20/10/2009 - Retirar RP's que estão em homologação pela AP&B
      -------------------------------------------------
       R.REQUISICAO_SQ
      ,TO_CHAR(R.DT_REQUISICAO,'dd/mm/yyyy') AS DT_REQUISICAO
      ,R.CARGO_SQ
      ,CD.DESCRICAO AS CARGO
      ,R.COD_UNIDADE
      ,UO.DESCRICAO AS NOM_UNIDADE
      ,UO.SIGLA     AS SGL_UNIDADE
      ,RS.DSC_STATUS
      ,HR.NIVEL

FROM   REQUISICAO               R
      ,UNIDADES_ORGANIZACIONAIS UO
      ,CARGO_DESCRICOES         CD
      ,REQUISICAO_STATUS        RS
      ,HISTORICO_REQUISICAO     HR

WHERE  HR.DT_ENVIO      = (SELECT MAX(HR1.DT_ENVIO)
                           FROM   HISTORICO_REQUISICAO HR1
                           WHERE  HR1.REQUISICAO_SQ = R.REQUISICAO_SQ) -- ÚLTIMO NÍVEL
AND    (RS.COD_STATUS   NOT IN(1,2) /*ABERTAS e EM HOMOLOGAÇÃO*/ OR (RS.COD_STATUS = 2 AND HR.NIVEL <> 2)/*EM HOMOLOGAÇÃO, execeto AP&B*/)
AND    UO.CODIGO(+)     = R.COD_UNIDADE
AND    CD.ID(+)         = R.CARGO_SQ
AND    RS.COD_STATUS    = R.COD_STATUS
AND    HR.REQUISICAO_SQ = R.REQUISICAO_SQ

/*
AND    RS.COD_STATUS    <> 1 -- STATUS: ABERTA
AND    HR.DT_ENVIO      = (SELECT MAX(HR1.DT_ENVIO)
                           FROM   HISTORICO_REQUISICAO HR1
                           WHERE  HR1.REQUISICAO_SQ = R.REQUISICAO_SQ
                           AND    HR1.NIVEL <> 2) -- WORKFLOW: GEP AP&B
*/

ORDER BY R.DT_REQUISICAO
        ,UO.DESCRICAO
        ,CD.DESCRICAO
;
grant select on REQPES.VW_REQUISICOES_PARA_ESTORNO to AN$RHEV;


