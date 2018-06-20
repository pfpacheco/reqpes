CREATE OR REPLACE FORCE VIEW REQPES.VW_RHEV_TRANSFERENCIA_MOTIVO AS
SELECT
      ------------------------------------------------
      -- VIEW QUE LISTA OS MOTIVOS DE TRANSFERENCIA
      -- Author: Thiago Lima Coutinho
      -- Date  : 9/9/2009
      ------------------------------------------------
       M.COD_MOTIVO AS TRANSFERENCIA_MOTIVO_ID
      ,M.DES_MOTIVO AS DESCRICAO
      ,'T' AS IND_MOTIVO
FROM   MOTIVOS_CONTRATACAO M
WHERE  M.COD_MOTIVO BETWEEN 1 AND 9 -- MOTIVOS DE TRANSFERENCIA
-----
UNION
-----
SELECT M.COD_MOTIVO AS TRANSFERENCIA_MOTIVO_ID
      ,M.DES_MOTIVO AS DESCRICAO
      ,'S' AS IND_MOTIVO
FROM   MOTIVOS_CONTRATACAO M
WHERE  M.COD_MOTIVO IN (2,3,4,5,6,7,9,10) -- MOTIVOS DE SUBSTITUIC?O
;
grant select on REQPES.VW_RHEV_TRANSFERENCIA_MOTIVO to AN$RHEV;


