CREATE OR REPLACE FORCE VIEW REQPES.VW_INSTRUCAO_ATRIBUICAO AS
SELECT
      -------------------------------------------------
      -- VIEW QUE LISTA OS DADOS DO RELATÓRIO DAS INSTRUÇÕES
      -- Author: Thiago Lima Coutinho
      -- Date  : 12/11/2010
      -------------------------------------------------
       COD_INSTRUCAO
      ,COD_TAB_SALARIAL
      ,DSC_TAB_SALARIAL
      ,COD_CARGO
      ,DSC_CARGO
      ,COTA
      ,SUBSTR(UNIDADES, 0, (INSTR(UNIDADES, '#')-1)) AS SGL_UO
      ,SUBSTR(UNIDADES, (INSTR(UNIDADES, '#')+1), LENGTH(UNIDADES)) AS COD_UO

FROM (SELECT I.COD_INSTRUCAO
            ,I.COD_TAB_SALARIAL
            ,TB.DSC_TAB_SALARIAL
            ,I.COD_CARGO
            ,CD.DESCRICAO AS DSC_CARGO
            ,I.COTA
            ,F_GET_LST_INSTRUCAO_ATRIBUICAO(I.COD_INSTRUCAO) AS UNIDADES
      FROM   INSTRUCAO          I
            ,CARGO_DESCRICOES   CD
            ,TABELA_SALARIAL    TB
      WHERE  I.COD_CARGO        = CD.ID
      AND    I.COD_TAB_SALARIAL = TB.COD_TAB_SALARIAL
     )

ORDER  BY DSC_TAB_SALARIAL
         ,DSC_CARGO
         ,COTA
;
grant select on REQPES.VW_INSTRUCAO_ATRIBUICAO to AN$RHEV;


