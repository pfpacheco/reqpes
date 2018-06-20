CREATE OR REPLACE PROCEDURE REQPES.SP_MIGRA_CODE_COMBINATION AS

  V_CHART_OF_ACCOUNTS_ID NUMBER;
  V_COD_COMBINATION_ID   NUMBER;
  V_MESSAGE              VARCHAR2(4000);

BEGIN
  
  --=================================================================================================--
  -- Migrando os Id's com a combinação criada
  --=================================================================================================--
  FOR C IN (SELECT OLD.REQUISICAO_SQ
                  ,ID_CODE_COMBINATION_NEW
                  ,ID_CODE_COMBINATION_OLD
                  ,NEW.COD_SEGMENTO1       COD_SEGMENTO1_NEW
                  ,OLD.COD_SEGMENTO1       COD_SEGMENTO1_OLD
                  ,NEW.COD_SEGMENTO2       COD_SEGMENTO2_NEW
                  ,OLD.COD_SEGMENTO2       COD_SEGMENTO2_OLD
                  ,NEW.COD_SEGMENTO3       COD_SEGMENTO3_NEW
                  ,OLD.COD_SEGMENTO3       COD_SEGMENTO3_OLD
                  ,NEW.COD_SEGMENTO4       COD_SEGMENTO4_NEW
                  ,OLD.COD_SEGMENTO4       COD_SEGMENTO4_OLD
                  ,NEW.COD_SEGMENTO5       COD_SEGMENTO5_NEW
                  ,OLD.COD_SEGMENTO5       COD_SEGMENTO5_OLD
                  ,NEW.COD_SEGMENTO6       COD_SEGMENTO6_NEW
                  ,OLD.COD_SEGMENTO6       COD_SEGMENTO6_OLD
                  ,NEW.COD_SEGMENTO7       COD_SEGMENTO7_NEW
                  ,OLD.COD_SEGMENTO7       COD_SEGMENTO7_OLD
            FROM   (SELECT MAX(C.ID_CODE_COMBINATION) ID_CODE_COMBINATION_NEW
                          ,C.COD_SEGMENTO1
                          ,C.COD_SEGMENTO2
                          ,C.COD_SEGMENTO3
                          ,C.COD_SEGMENTO4
                          ,C.COD_SEGMENTO5
                          ,C.COD_SEGMENTO6
                          ,C.COD_SEGMENTO7
                    FROM   CODE_COMBINATION_ALL C
                    WHERE  C.COD_SEGMENTO2 = '012'
                    GROUP  BY C.COD_SEGMENTO1
                             ,C.COD_SEGMENTO2
                             ,C.COD_SEGMENTO3
                             ,C.COD_SEGMENTO4
                             ,C.COD_SEGMENTO5
                             ,C.COD_SEGMENTO6
                             ,C.COD_SEGMENTO7) NEW
                  ,(SELECT R.ID_CODE_COMBINATION ID_CODE_COMBINATION_OLD
                          ,C.COD_SEGMENTO1
                          ,C.COD_SEGMENTO2
                          ,C.COD_SEGMENTO3
                          ,C.COD_SEGMENTO4
                          ,C.COD_SEGMENTO5
                          ,C.COD_SEGMENTO6
                          ,C.COD_SEGMENTO7
                          ,R.REQUISICAO_SQ
                    FROM   REQUISICAO           R
                          ,CODE_COMBINATION_ALL C
                    WHERE  R.COD_STATUS IN (1, 2, 3, 4)
                    AND    R.ID_CODE_COMBINATION = C.ID_CODE_COMBINATION
                    AND    C.COD_SEGMENTO2 = '010') OLD
            WHERE  NEW.COD_SEGMENTO1 = OLD.COD_SEGMENTO1
            AND    NEW.COD_SEGMENTO3 = OLD.COD_SEGMENTO3
            AND    NEW.COD_SEGMENTO4 = OLD.COD_SEGMENTO4
            AND    NEW.COD_SEGMENTO5 = OLD.COD_SEGMENTO5
            AND    NEW.COD_SEGMENTO6 = OLD.COD_SEGMENTO6
            AND    NEW.COD_SEGMENTO7 = OLD.COD_SEGMENTO7) LOOP
  
    UPDATE REQUISICAO R
    SET    R.ID_CODE_COMBINATION = C.ID_CODE_COMBINATION_NEW
    WHERE  R.REQUISICAO_SQ = C.REQUISICAO_SQ;
  
  END LOOP;

  --=================================================================================================--
  -- Migrando os Id's sem combinação criada, desta forma chamando a API para a criação da combinação
  --=================================================================================================--
  -- Obtendo o ID do Chart of Accounts (COA)
  V_CHART_OF_ACCOUNTS_ID := XXGL_UTIL.GET_COA_ID('LIVRO_SENAC_PLANO_NOVO');

  FOR D IN (SELECT R.REQUISICAO_SQ
                  ,C.COD_SEGMENTO1 || '.012.' ||
                   C.COD_SEGMENTO3 || '.' || C.COD_SEGMENTO4 || '.' ||
                   C.COD_SEGMENTO5 || '.' || C.COD_SEGMENTO6 || '.' ||
                   C.COD_SEGMENTO7 || '.312210102.0' CENTRO_CUSTO
            FROM   REQUISICAO           R
                  ,CODE_COMBINATION_ALL C
            WHERE  R.COD_STATUS IN (1, 2, 3, 4)
            AND    R.ID_CODE_COMBINATION = C.ID_CODE_COMBINATION
            AND    C.COD_SEGMENTO2 = '010') LOOP
  
    -- API: Obtendo o CODE_COMBINATION_ID
    V_COD_COMBINATION_ID := XXFND_FLEX_EXT.GET_CCID(V_CHART_OF_ACCOUNTS_ID,
                                                                 D.CENTRO_CUSTO,
                                                                 V_MESSAGE);
  
    IF (V_COD_COMBINATION_ID > 0) THEN
      UPDATE REQUISICAO R
      SET    R.ID_CODE_COMBINATION = V_COD_COMBINATION_ID
      WHERE  R.REQUISICAO_SQ = D.REQUISICAO_SQ;
    ELSE
      DBMS_OUTPUT.PUT_LINE(' RP: '  || D.REQUISICAO_SQ || 
                           ' CC: '  || D.CENTRO_CUSTO || 
                           ' MSG: ' || V_MESSAGE);
    END IF;
  
  END LOOP;

END;
/
grant execute, debug on REQPES.SP_MIGRA_CODE_COMBINATION to AN$RHEV;


