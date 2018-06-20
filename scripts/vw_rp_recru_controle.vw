CREATE OR REPLACE FORCE VIEW REQPES.VW_RP_RECRU_CONTROLE AS
SELECT
      ------------------------------------------------------------------------
      -- VIEW UTILIZADA PELO SISTEMA DE RECRUTAMENTO E SELEC?O
      -- Author: Thiago Lima Coutinho
      -- Date  : 03/05/2010
      ------------------------------------------------------------------------
       R.REQUISICAO_SQ
      ,R.COD_STATUS
      ,R.DT_REQUISICAO
      ,A.DT_ENVIO AS DAT_ULTIMA_APROVACAO
      ,R.CARGO_SQ AS ID_CARGO
      ,R.COD_UNIDADE
      ,P.COD_FUNCAO
      ,R.COD_RECRUTAMENTO
      ,RC.DESCRICAO AS DSC_RECRUTAMENTO

FROM   REQUISICAO R
      ,REQUISICAO_PERFIL P
      ,RECRUTAMENTO      RC
      ,(SELECT MAX(H1.DT_ENVIO) DT_ENVIO
              ,H1.REQUISICAO_SQ
        FROM   HISTORICO_REQUISICAO H1
        WHERE  H1.NIVEL = 5
        GROUP  BY H1.REQUISICAO_SQ) A

WHERE  R.REQUISICAO_SQ = A.REQUISICAO_SQ
AND    R.REQUISICAO_SQ = P.REQUISICAO_SQ
AND    R.COD_RECRUTAMENTO = RC.ID_RECRUTAMENTO
;
grant select on REQPES.VW_RP_RECRU_CONTROLE to AN$RHEV;
grant select on REQPES.VW_RP_RECRU_CONTROLE to RECRU;


