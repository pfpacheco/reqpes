CREATE OR REPLACE FORCE VIEW REQPES.VW_REQUISICOES_PARA_BAIXA AS
SELECT
      -------------------------------------------------
      -- VIEW QUE LISTA TODAS AS RP's PARA BAIXA
      -- Author: Thiago Lima Coutinho
      -- Date  : 9/9/2009
      -------------------------------------------------
       R.REQUISICAO_SQ
      ,TO_CHAR(R.DT_REQUISICAO,'dd/mm/yyyy') AS DT_REQUISICAO
      ,R.CARGO_SQ
      ,CD.DESCRICAO AS CARGO
      ,R.COD_UNIDADE
      ,DECODE(R.IND_TIPO_REQUISICAO,'T','TRANSFERENCIA','A','ADMISSÃO') AS IND_TIPO_REQUISICAO
      ,UO.SIGLA     AS SGL_UNIDADE
      ,UO.DESCRICAO AS NOM_UNIDADE

FROM   REQUISICAO               R
      ,CARGO_DESCRICOES         CD
      ,UNIDADES_ORGANIZACIONAIS UO

WHERE  R.CARGO_SQ           = CD.ID
AND    R.COD_STATUS         = 4 -- Status de aprovada
AND    UO.CODIGO            = R.COD_UNIDADE
AND    UO.NIVEL             = 2
AND    UO.DATA_ENCERRAMENTO IS NULL
AND    NOT EXISTS (SELECT 1 FROM REQUISICAO_BAIXA RB WHERE R.REQUISICAO_SQ = RB.REQUISICAO_SQ)

ORDER  BY R.DT_REQUISICAO
         ,R.REQUISICAO_SQ
         ,R.COD_UNIDADE
         ,CD.DESCRICAO
;
grant select on REQPES.VW_REQUISICOES_PARA_BAIXA to AN$RHEV;


