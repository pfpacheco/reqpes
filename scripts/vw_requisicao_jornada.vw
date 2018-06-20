CREATE OR REPLACE FORCE VIEW REQPES.VW_REQUISICAO_JORNADA AS
SELECT
      -------------------------------------------------
      -- VIEW QUE LISTA A JORNADA DE TRABALHO DA REQUISIÇÃO
      -- Author: Thiago Lima Coutinho
      -- Date  : 21/10/2011
      -------------------------------------------------
       REQUISICAO_SQ
      ,CODIGO_ESCALA
      ,ID_CALENDARIO
      ,IND_TIPO_HORARIO
      ,DIA
      ,TO_CHAR(HORARIO_ENTRADA, 'HH24:MI') AS HORARIO_ENTRADA
      ,TO_CHAR(HORARIO_ALMOCO , 'HH24:MI') AS HORARIO_ALMOCO
      ,TO_CHAR(HORARIO_RETORNO, 'HH24:MI') AS HORARIO_RETORNO
      ,TO_CHAR(HORARIO_SAIDA  , 'HH24:MI') AS HORARIO_SAIDA
      ,TO_CHAR(HORARIO_ENTRADA_EXTRA, 'HH24:MI') AS HORARIO_ENTRADA_EXTRA
      ,TO_CHAR(HORARIO_ALMOCO_EXTRA , 'HH24:MI') AS HORARIO_ALMOCO_EXTRA
      ,TO_CHAR(HORARIO_RETORNO_EXTRA, 'HH24:MI') AS HORARIO_RETORNO_EXTRA
      ,TO_CHAR(HORARIO_SAIDA_EXTRA  , 'HH24:MI') AS HORARIO_SAIDA_EXTRA

FROM   (
        -- Requisições sem escala TimeKeeper
        SELECT  REQUISICAO_SQ
               ,CODIGO_ESCALA
               ,ID_CALENDARIO
               ,IND_TIPO_HORARIO
               ,DIA
               ,HORARIO_ENTRADA
               ,HORARIO_ALMOCO
               ,HORARIO_RETORNO
               ,HORARIO_SAIDA
               ,HORARIO_ENTRADA_EXTRA
               ,HORARIO_ALMOCO_EXTRA
               ,HORARIO_RETORNO_EXTRA
               ,HORARIO_SAIDA_EXTRA
               ,ORDEM
        FROM   (SELECT 'SEG' AS DIA
                       ,T.HR_SEGUNDA_ENTRADA1 AS HORARIO_ENTRADA
                       ,T.HR_SEGUNDA_SAIDA1   AS HORARIO_ALMOCO
                       ,T.HR_SEGUNDA_ENTRADA2 AS HORARIO_RETORNO
                       ,T.HR_SEGUNDA_SAIDA2   AS HORARIO_SAIDA
                       ,T.HR_SEGUNDA_ENTRADA3 AS HORARIO_ENTRADA_EXTRA
                       ,T.HR_SEGUNDA_SAIDA3   AS HORARIO_ALMOCO_EXTRA
                       ,T.HR_SEGUNDA_ENTRADA4 AS HORARIO_RETORNO_EXTRA
                       ,T.HR_SEGUNDA_SAIDA4   AS HORARIO_SAIDA_EXTRA
                       ,1 ORDEM
                       ,T.REQUISICAO_SQ
                       ,NULL AS CODIGO_ESCALA
                       ,T.ID_CALENDARIO
                       ,T.IND_TIPO_HORARIO
                 FROM   REQUISICAO_JORNADA T
                 WHERE  T.COD_ESCALA IS NULL
                 UNION
                 SELECT 'TER' AS DIA
                       ,T.HR_TERCA_ENTRADA1 AS HORARIO_ENTRADA
                       ,T.HR_TERCA_SAIDA1   AS HORARIO_ALMOCO
                       ,T.HR_TERCA_ENTRADA2 AS HORARIO_RETORNO
                       ,T.HR_TERCA_SAIDA2   AS HORARIO_SAIDA
                       ,T.HR_TERCA_ENTRADA3 AS HORARIO_ENTRADA_EXTRA
                       ,T.HR_TERCA_SAIDA3   AS HORARIO_ALMOCO_EXTRA
                       ,T.HR_TERCA_ENTRADA4 AS HORARIO_RETORNO_EXTRA
                       ,T.HR_TERCA_SAIDA4   AS HORARIO_SAIDA_EXTRA
                       ,2 ORDEM
                       ,T.REQUISICAO_SQ
                       ,NULL AS CODIGO_ESCALA
                       ,T.ID_CALENDARIO
                       ,T.IND_TIPO_HORARIO
                 FROM   REQUISICAO_JORNADA T
                 WHERE  T.COD_ESCALA IS NULL
                 UNION
                 SELECT 'QUA' AS DIA
                       ,T.HR_QUARTA_ENTRADA1 AS HORARIO_ENTRADA
                       ,T.HR_QUARTA_SAIDA1   AS HORARIO_ALMOCO
                       ,T.HR_QUARTA_ENTRADA2 AS HORARIO_RETORNO
                       ,T.HR_QUARTA_SAIDA2   AS HORARIO_SAIDA
                       ,T.HR_QUARTA_ENTRADA3 AS HORARIO_ENTRADA_EXTRA
                       ,T.HR_QUARTA_SAIDA3   AS HORARIO_ALMOCO_EXTRA
                       ,T.HR_QUARTA_ENTRADA4 AS HORARIO_RETORNO_EXTRA
                       ,T.HR_QUARTA_SAIDA4   AS HORARIO_SAIDA_EXTRA
                       ,3 ORDEM
                       ,T.REQUISICAO_SQ
                       ,NULL AS CODIGO_ESCALA
                       ,T.ID_CALENDARIO
                       ,T.IND_TIPO_HORARIO
                 FROM   REQUISICAO_JORNADA T
                 WHERE  T.COD_ESCALA IS NULL
                 UNION
                 SELECT 'QUI' AS DIA
                       ,T.HR_QUINTA_ENTRADA1 AS HORARIO_ENTRADA
                       ,T.HR_QUINTA_SAIDA1   AS HORARIO_ALMOCO
                       ,T.HR_QUINTA_ENTRADA2 AS HORARIO_RETORNO
                       ,T.HR_QUINTA_SAIDA2   AS HORARIO_SAIDA
                       ,T.HR_QUINTA_ENTRADA3 AS HORARIO_ENTRADA_EXTRA
                       ,T.HR_QUINTA_SAIDA3   AS HORARIO_ALMOCO_EXTRA
                       ,T.HR_QUINTA_ENTRADA4 AS HORARIO_RETORNO_EXTRA
                       ,T.HR_QUINTA_SAIDA4   AS HORARIO_SAIDA_EXTRA
                       ,4 ORDEM
                       ,T.REQUISICAO_SQ
                       ,NULL AS CODIGO_ESCALA
                       ,T.ID_CALENDARIO
                       ,T.IND_TIPO_HORARIO
                 FROM   REQUISICAO_JORNADA T
                 WHERE  T.COD_ESCALA IS NULL
                 UNION
                 SELECT 'SEX' AS DIA
                       ,T.HR_SEXTA_ENTRADA1 AS HORARIO_ENTRADA
                       ,T.HR_SEXTA_SAIDA1   AS HORARIO_ALMOCO
                       ,T.HR_SEXTA_ENTRADA2 AS HORARIO_RETORNO
                       ,T.HR_SEXTA_SAIDA2   AS HORARIO_SAIDA
                       ,T.HR_SEXTA_ENTRADA3 AS HORARIO_ENTRADA_EXTRA
                       ,T.HR_SEXTA_SAIDA3   AS HORARIO_ALMOCO_EXTRA
                       ,T.HR_SEXTA_ENTRADA4 AS HORARIO_RETORNO_EXTRA
                       ,T.HR_SEXTA_SAIDA4   AS HORARIO_SAIDA_EXTRA
                       ,5 ORDEM
                       ,T.REQUISICAO_SQ
                       ,NULL AS CODIGO_ESCALA
                       ,T.ID_CALENDARIO
                       ,T.IND_TIPO_HORARIO
                 FROM   REQUISICAO_JORNADA T
                 WHERE  T.COD_ESCALA IS NULL
                 UNION
                 SELECT 'SAB' AS DIA
                       ,T.HR_SABADO_ENTRADA1 AS HORARIO_ENTRADA
                       ,T.HR_SABADO_SAIDA1   AS HORARIO_ALMOCO
                       ,T.HR_SABADO_ENTRADA2 AS HORARIO_RETORNO
                       ,T.HR_SABADO_SAIDA2   AS HORARIO_SAIDA
                       ,T.HR_SABADO_ENTRADA3 AS HORARIO_ENTRADA_EXTRA
                       ,T.HR_SABADO_SAIDA3   AS HORARIO_ALMOCO_EXTRA
                       ,T.HR_SABADO_ENTRADA4 AS HORARIO_RETORNO_EXTRA
                       ,T.HR_SABADO_SAIDA4   AS HORARIO_SAIDA_EXTRA
                       ,6 ORDEM
                       ,T.REQUISICAO_SQ
                       ,NULL AS CODIGO_ESCALA
                       ,T.ID_CALENDARIO
                       ,T.IND_TIPO_HORARIO
                 FROM   REQUISICAO_JORNADA T
                 WHERE  T.COD_ESCALA IS NULL
                 UNION
                 SELECT 'DOM' AS DIA
                       ,T.HR_DOMINGO_ENTRADA1 AS HORARIO_ENTRADA
                       ,T.HR_DOMINGO_SAIDA1   AS HORARIO_ALMOCO
                       ,T.HR_DOMINGO_ENTRADA2 AS HORARIO_RETORNO
                       ,T.HR_DOMINGO_SAIDA2   AS HORARIO_SAIDA
                       ,T.HR_DOMINGO_ENTRADA3 AS HORARIO_ENTRADA_EXTRA
                       ,T.HR_DOMINGO_SAIDA3   AS HORARIO_ALMOCO_EXTRA
                       ,T.HR_DOMINGO_ENTRADA4 AS HORARIO_RETORNO_EXTRA
                       ,T.HR_DOMINGO_SAIDA4   AS HORARIO_SAIDA_EXTRA
                       ,7 ORDEM
                       ,T.REQUISICAO_SQ
                       ,NULL AS CODIGO_ESCALA
                       ,T.ID_CALENDARIO
                       ,T.IND_TIPO_HORARIO
                 FROM   REQUISICAO_JORNADA T
                 WHERE  T.COD_ESCALA IS NULL)
        UNION
        -- Requisições com escala TimeKeeper
        SELECT REQUISICAO_SQ
              ,R.CODIGO_ESCALA
              ,T.ID_CALENDARIO
              ,T.IND_TIPO_HORARIO
              ,R.DIA
              ,R.HORARIO_ENTRADA
              ,R.HORARIO_ALMOCO
              ,R.HORARIO_RETORNO
              ,R.HORARIO_SAIDA
              ,NULL AS HORARIO_ENTRADA_EXTRA
              ,NULL AS HORARIO_ALMOCO_EXTRA
              ,NULL AS HORARIO_RETORNO_EXTRA
              ,NULL AS HORARIO_SAIDA_EXTRA
              ,R.SEQUENCIA_ESCALA AS ORDEM
        FROM   VW_ESCALA_HORARIO  R
              ,REQUISICAO_JORNADA T
        WHERE  R.CODIGO_ESCALA = T.COD_ESCALA)
ORDER  BY ORDEM
;
grant select on REQPES.VW_REQUISICAO_JORNADA to AN$RHEV;


