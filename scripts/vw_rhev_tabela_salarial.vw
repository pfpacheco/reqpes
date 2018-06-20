CREATE OR REPLACE FORCE VIEW REQPES.VW_RHEV_TABELA_SALARIAL AS
SELECT
      ------------------------------------------------------------------------
      -- VIEW RESPONSAVEL POR GERAÇÃO DE DPARA (RHEV => RP) NA TABELA SALARIAL
      -- Author: Thiago Lima Coutinho
      -- Date  : 9/9/2009
      -- Alterado em 17/01/2017 por Cadu - Incluido o codigo 11 - Tabela Tutor IES EAD
      ------------------------------------------------------------------------
       T.CODIGO AS COD_TABELA
      ,DECODE(T.CODIGO, 1, '01 - GERAL'
                      , 2, '02 - HOTELARIA'
                      , 3, '88 - DOCENTES SEGUNDO GRAU'
                      , 4, '04 - PROFESSORES HORISTAS'
                      , 5, '05 - MONITORES DE EDUCAÇÃO PROFISSIONAL E COMUNITÁRIA'
                      , 7, '07 - ORIENTADORES DE ESTUDO E PESQUISA'
                      , 8, '08 - JORNALISTAS'
                      , 9, '09 - PROFESSORES MENSALISTAS'
                      , 10,'10 - ESTAGIÁRIOS'
                      , 11,'11 - TUTOR IES EAD') AS DSC_TABELA

FROM   TIPO_TAB_SALARIAIS T

WHERE  T.CODIGO BETWEEN 1 AND 11
AND    T.CODIGO NOT IN (6,10)
ORDER BY 2
;
grant select on REQPES.VW_RHEV_TABELA_SALARIAL to AN$RHEV;


