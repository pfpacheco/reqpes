CREATE OR REPLACE PROCEDURE REQPES.SP_ALTERA_GRUPO_NEC AS

  V_DATA_ATUAL DATE := SYSDATE;

BEGIN
  ----------------------------------------
  -- Gravando backup
  ----------------------------------------
    INSERT INTO GRUPO_NEC_BKP20110401
      SELECT *
      FROM   GRUPO_NEC;

    INSERT INTO GRUPO_NEC_UNIDADES_BKP20110401
      SELECT *
      FROM   GRUPO_NEC_UNIDADES;

  ----------------------------------------
  -- Alterando os grupos
  ----------------------------------------
    UPDATE GRUPO_NEC T
    SET    T.DSC_GRUPO      = 'Grupo 1'
          ,T.DAT_ALTERACAO  = V_DATA_ATUAL
          ,T.USER_ALTERACAO = 318477
    WHERE  T.COD_GRUPO = 5;

    UPDATE GRUPO_NEC T
    SET    T.DSC_GRUPO      = 'Grupo 2'
          ,T.DAT_ALTERACAO  = V_DATA_ATUAL
          ,T.USER_ALTERACAO = 318477
    WHERE  T.COD_GRUPO = 3;

    UPDATE GRUPO_NEC T
    SET    T.DSC_GRUPO      = 'Grupo 3'
          ,T.DAT_ALTERACAO  = V_DATA_ATUAL
          ,T.USER_ALTERACAO = 318477
    WHERE  T.COD_GRUPO = 2;

    UPDATE GRUPO_NEC T
    SET    T.DSC_GRUPO      = 'Grupo 4'
          ,T.DAT_ALTERACAO  = V_DATA_ATUAL
          ,T.USER_ALTERACAO = 318477
    WHERE  T.COD_GRUPO = 1;

    UPDATE GRUPO_NEC T
    SET    T.DSC_GRUPO      = 'Grupo 5'
          ,T.DAT_ALTERACAO  = V_DATA_ATUAL
          ,T.USER_ALTERACAO = 318477
    WHERE  T.COD_GRUPO = 4;

  ----------------------------------------
  -- Alterando as unidades associadas
  ----------------------------------------
    DELETE FROM GRUPO_NEC_UNIDADES;

    -- Dupla 1
    INSERT INTO GRUPO_NEC_UNIDADES
      (SELECT 5
             ,UO.CODIGO
       FROM   UNIDADES_ORGANIZACIONAIS UO
       WHERE  UO.SIGLA IN ('MAI',
                           'TIR',
                           'JUL',
                           'ACL',
                           'GMS',
                           'GES',
                           'GD2',
                           'EDS',
                           'OSA',
                           'GUA',
                           'TAU',
                           'SJC',
                           'SJR',
                           'ACA',
                           'VOT',
                           'CAR',
                           'AME',
                           'GO2')
       AND    UO.NIVEL = 2
       AND    UO.DATA_ENCERRAMENTO IS NULL);

    -- Dupla 2
    INSERT INTO GRUPO_NEC_UNIDADES
      (SELECT 3
             ,UO.CODIGO
       FROM   UNIDADES_ORGANIZACIONAIS UO
       WHERE  UO.SIGLA IN ('FAU',
                           'ANA',
                           'PEN',
                           'SAM',
                           'GEF',
                           'GEP',
                           'GD1',
                           'FRA',
                           'BOT',
                           'SOR',
                           'IPE',
                           'ITU',
                           'ARA',
                           'RIP',
                           'CAT',
                           'JAB',
                           'ITA',
                           'DIREG',
                           'GO3')
       AND    UO.NIVEL = 2
       AND    UO.DATA_ENCERRAMENTO IS NULL);

    -- Dupla 3
    INSERT INTO GRUPO_NEC_UNIDADES
      (SELECT 2
             ,UO.CODIGO
       FROM   UNIDADES_ORGANIZACIONAIS UO
       WHERE  UO.SIGLA IN ('ITQ',
                           'VPR',
                           'TAT',
                           'TIT',
                           'AJ',
                           'GPG',
                           'GD3',
                           'SENG',
                           'CAS',
                           'SJB',
                           'RIC',
                           'MOG',
                           'LIM',
                           'PPR',
                           'BAR',
                           'JAU',
                           'UNI')
       AND    UO.NIVEL = 2
       AND    UO.DATA_ENCERRAMENTO IS NULL);

    -- Dupla 4
    INSERT INTO GRUPO_NEC_UNIDADES
      (SELECT 1
             ,UO.CODIGO
       FROM   UNIDADES_ORGANIZACIONAIS UO
       WHERE  UO.SIGLA IN ('CEC',
                           'JBQ',
                           'CON',
                           'SCI',
                           'GAC',
                           'GD4',
                           'GCR',
                           'GRU',
                           'SAD',
                           'SAN',
                           'CAM',
                           'JUN',
                           'PIR',
                           'MAR',
                           'BAU',
                           'BEB',
                           'GO1')
       AND    UO.NIVEL = 2
       AND    UO.DATA_ENCERRAMENTO IS NULL);

    -- Dupla 5
    INSERT INTO GRUPO_NEC_UNIDADES
      (SELECT 4
             ,UO.CODIGO
       FROM   UNIDADES_ORGANIZACIONAIS UO
       WHERE  UO.SIGLA IN ('CAP', 'CAJ', 'GHP', 'GHJ', 'CVH', 'CGH')
       AND    UO.NIVEL = 2
       AND    UO.DATA_ENCERRAMENTO IS NULL);

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
END;
/
grant execute, debug on REQPES.SP_ALTERA_GRUPO_NEC to AN$RHEV;


