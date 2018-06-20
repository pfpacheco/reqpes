CREATE OR REPLACE FORCE VIEW REQPES.VW_HISTORICO_REQUISICAO AS
SELECT /*+Rule*/
      -----------------------------------------------------
      -- VIEW QUE LISTA OS HISTORICOS NO WORKFLOW DAS RP's
      -- Author: Thiago Lima Coutinho
      -- Date  : 9/9/2009
      -----------------------------------------------------
       TO_CHAR(HR.DT_ENVIO,'dd/mm/yyyy hh24:mi:ss') AS DT_HISTORICO
      ,HR.REQUISICAO_SQ
      ,NVL(RC.DESCRICAO,'NÃO INFORMADO') AS RP_TIPO
      ,TO_CHAR(R.DT_REQUISICAO, 'dd/mm/yyyy') AS DT_CRIACAO
      ,R.COD_UNIDADE AS UO_REQUISICAO
      ,F.NOME
      ,HR.USUARIO_SQ
      ,U.IDENTIFICACAO
      ,HR.UNIDADE_ATUAL_USUARIO AS UO_USUARIO
      ,DECODE(HR.STATUS, 'aprovou',  '-'
                       , 'expirada', '-'
                       , 'reprovou', '-'
                       , 'deu baixa','-'
                       , 'excluiu',  '-'
                       , HR.COD_UNIDADE) AS UO_PARA_UNIDADE
      ,DECODE(HR.STATUS, 'expirada', 'expirou', HR.STATUS) AS STATUS
      ,R.CARGO_SQ
      ,CD.DESCRICAO
      ,DT_REQUISICAO AS DT_REQUISICAO_SQL
      ,HR.DT_ENVIO   AS DT_HISTORICO_SQL
      ,HR.NIVEL      AS NIVEL_WORKFLOW

FROM   HISTORICO_REQUISICAO HR
      ,REQUISICAO           R
      ,CARGO_DESCRICOES     CD
      ,USUARIO              U
      ,FUNCIONARIOS         F
      ,RECRUTAMENTO         RC

WHERE  R.REQUISICAO_SQ        = HR.REQUISICAO_SQ
AND    CD.ID              (+) = R.CARGO_SQ
AND    U.USUARIO_SQ       (+) = HR.USUARIO_SQ
AND    F.ID               (+) = U.IDENTIFICACAO
AND    RC.ID_RECRUTAMENTO (+) = R.COD_RECRUTAMENTO
ORDER  BY HR.REQUISICAO_SQ, DT_ENVIO
;
grant select on REQPES.VW_HISTORICO_REQUISICAO to AN$RHEV;


