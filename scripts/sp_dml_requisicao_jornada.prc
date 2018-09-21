CREATE OR REPLACE PROCEDURE REQPES.SP_DML_REQUISICAO_JORNADA(P_IN_DML                 IN NUMBER
                                                     ,P_IN_REQUISICAO_SQ       IN NUMBER
                                                     ,P_IN_COD_ESCALA          IN VARCHAR2
                                                     ,P_IN_ID_CALENDARIO       IN NUMBER
                                                     ,P_IN_IND_TIPO_HORARIO    IN VARCHAR2
                                                     ,P_IN_CHAPA               IN NUMBER
                                                     --
                                                     ,P_IN_HR_SEGUNDA_ENTRADA1 IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_SAIDA1   IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_ENTRADA2 IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_SAIDA2   IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_ENTRADA3 IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_SAIDA3   IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_ENTRADA4 IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_SAIDA4   IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_TERCA_ENTRADA1   IN VARCHAR2
                                                     ,P_IN_HR_TERCA_SAIDA1     IN VARCHAR2
                                                     ,P_IN_HR_TERCA_ENTRADA2   IN VARCHAR2
                                                     ,P_IN_HR_TERCA_SAIDA2     IN VARCHAR2
                                                     ,P_IN_HR_TERCA_ENTRADA3   IN VARCHAR2
                                                     ,P_IN_HR_TERCA_SAIDA3     IN VARCHAR2
                                                     ,P_IN_HR_TERCA_ENTRADA4   IN VARCHAR2
                                                     ,P_IN_HR_TERCA_SAIDA4     IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_QUARTA_ENTRADA1  IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_SAIDA1    IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_ENTRADA2  IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_SAIDA2    IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_ENTRADA3  IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_SAIDA3    IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_ENTRADA4  IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_SAIDA4    IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_QUINTA_ENTRADA1  IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_SAIDA1    IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_ENTRADA2  IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_SAIDA2    IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_ENTRADA3  IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_SAIDA3    IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_ENTRADA4  IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_SAIDA4    IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_SEXTA_ENTRADA1   IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_SAIDA1     IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_ENTRADA2   IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_SAIDA2     IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_ENTRADA3   IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_SAIDA3     IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_ENTRADA4   IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_SAIDA4     IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_SABADO_ENTRADA1  IN VARCHAR2
                                                     ,P_IN_HR_SABADO_SAIDA1    IN VARCHAR2
                                                     ,P_IN_HR_SABADO_ENTRADA2  IN VARCHAR2
                                                     ,P_IN_HR_SABADO_SAIDA2    IN VARCHAR2
                                                     ,P_IN_HR_SABADO_ENTRADA3  IN VARCHAR2
                                                     ,P_IN_HR_SABADO_SAIDA3    IN VARCHAR2
                                                     ,P_IN_HR_SABADO_ENTRADA4  IN VARCHAR2
                                                     ,P_IN_HR_SABADO_SAIDA4    IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_DOMINGO_ENTRADA1 IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_SAIDA1   IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_ENTRADA2 IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_SAIDA2   IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_ENTRADA3 IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_SAIDA3   IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_ENTRADA4 IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_SAIDA4   IN VARCHAR2
                                                     ) IS

  REG_REQUISICAO_JORNADA REQUISICAO_JORNADA%ROWTYPE;

BEGIN
  -- Parametro:  P_IN_DML =>  0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_REQUISICAO_JORNADA.REQUISICAO_SQ    := P_IN_REQUISICAO_SQ;
  REG_REQUISICAO_JORNADA.COD_ESCALA       := P_IN_COD_ESCALA;
  REG_REQUISICAO_JORNADA.ID_CALENDARIO    := P_IN_ID_CALENDARIO;
  REG_REQUISICAO_JORNADA.IND_TIPO_HORARIO := P_IN_IND_TIPO_HORARIO;

  -- Horários utilizados exclusivamente por cargos de professores
  IF (P_IN_IND_TIPO_HORARIO = 'P') THEN
    -- SEGUNDA
    IF (P_IN_HR_SEGUNDA_ENTRADA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEGUNDA_ENTRADA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEGUNDA_ENTRADA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEGUNDA_ENTRADA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEGUNDA_ENTRADA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEGUNDA_ENTRADA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEGUNDA_ENTRADA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEGUNDA_ENTRADA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEGUNDA_ENTRADA4 ),'DD/MM/YYYY HH24:MI');
    END IF;

    IF (P_IN_HR_SEGUNDA_SAIDA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEGUNDA_SAIDA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEGUNDA_SAIDA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEGUNDA_SAIDA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEGUNDA_SAIDA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEGUNDA_SAIDA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEGUNDA_SAIDA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEGUNDA_SAIDA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEGUNDA_SAIDA4 ),'DD/MM/YYYY HH24:MI');
    END IF;

    -- TERCA
    IF (P_IN_HR_TERCA_ENTRADA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_TERCA_ENTRADA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_TERCA_ENTRADA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_TERCA_ENTRADA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_TERCA_ENTRADA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_TERCA_ENTRADA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_TERCA_ENTRADA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_TERCA_ENTRADA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_TERCA_ENTRADA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_TERCA_ENTRADA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_TERCA_ENTRADA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_TERCA_ENTRADA4 ),'DD/MM/YYYY HH24:MI');
    END IF;

    IF (P_IN_HR_TERCA_SAIDA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_TERCA_SAIDA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_TERCA_SAIDA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_TERCA_SAIDA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_TERCA_SAIDA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_TERCA_SAIDA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_TERCA_SAIDA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_TERCA_SAIDA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_TERCA_SAIDA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_TERCA_SAIDA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_TERCA_SAIDA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_TERCA_SAIDA4 ),'DD/MM/YYYY HH24:MI');
    END IF;
    
    -- QUARTA
    IF (P_IN_HR_QUARTA_ENTRADA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUARTA_ENTRADA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUARTA_ENTRADA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUARTA_ENTRADA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUARTA_ENTRADA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUARTA_ENTRADA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUARTA_ENTRADA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUARTA_ENTRADA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUARTA_ENTRADA4 ),'DD/MM/YYYY HH24:MI');
    END IF;

    IF (P_IN_HR_QUARTA_SAIDA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUARTA_SAIDA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUARTA_SAIDA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUARTA_SAIDA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUARTA_SAIDA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUARTA_SAIDA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUARTA_SAIDA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUARTA_SAIDA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUARTA_SAIDA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUARTA_SAIDA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUARTA_SAIDA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUARTA_SAIDA4 ),'DD/MM/YYYY HH24:MI');
    END IF;
    
    -- QUINTA
    IF (P_IN_HR_QUINTA_ENTRADA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUINTA_ENTRADA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUINTA_ENTRADA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUINTA_ENTRADA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUINTA_ENTRADA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUINTA_ENTRADA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUINTA_ENTRADA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUINTA_ENTRADA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUINTA_ENTRADA4 ),'DD/MM/YYYY HH24:MI');
    END IF;

    IF (P_IN_HR_QUINTA_SAIDA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUINTA_SAIDA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUINTA_SAIDA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUINTA_SAIDA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUINTA_SAIDA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUINTA_SAIDA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUINTA_SAIDA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUINTA_SAIDA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUINTA_SAIDA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_QUINTA_SAIDA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_QUINTA_SAIDA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_QUINTA_SAIDA4 ),'DD/MM/YYYY HH24:MI');
    END IF;

    -- SEXTA
    IF (P_IN_HR_SEXTA_ENTRADA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEXTA_ENTRADA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEXTA_ENTRADA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEXTA_ENTRADA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEXTA_ENTRADA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEXTA_ENTRADA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEXTA_ENTRADA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEXTA_ENTRADA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEXTA_ENTRADA4 ),'DD/MM/YYYY HH24:MI');
    END IF;

    IF (P_IN_HR_SEXTA_SAIDA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEXTA_SAIDA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEXTA_SAIDA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEXTA_SAIDA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEXTA_SAIDA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEXTA_SAIDA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEXTA_SAIDA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEXTA_SAIDA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEXTA_SAIDA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SEXTA_SAIDA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SEXTA_SAIDA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SEXTA_SAIDA4 ),'DD/MM/YYYY HH24:MI');
    END IF;
    
    -- SABADO
    IF (P_IN_HR_SABADO_ENTRADA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SABADO_ENTRADA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SABADO_ENTRADA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SABADO_ENTRADA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SABADO_ENTRADA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SABADO_ENTRADA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SABADO_ENTRADA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SABADO_ENTRADA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SABADO_ENTRADA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SABADO_ENTRADA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SABADO_ENTRADA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SABADO_ENTRADA4 ),'DD/MM/YYYY HH24:MI');
    END IF;

    IF (P_IN_HR_SABADO_SAIDA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SABADO_SAIDA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SABADO_SAIDA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SABADO_SAIDA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SABADO_SAIDA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SABADO_SAIDA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SABADO_SAIDA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SABADO_SAIDA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SABADO_SAIDA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_SABADO_SAIDA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_SABADO_SAIDA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_SABADO_SAIDA4 ),'DD/MM/YYYY HH24:MI');
    END IF;
    
    -- DOMINGO
    IF (P_IN_HR_DOMINGO_ENTRADA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_DOMINGO_ENTRADA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_DOMINGO_ENTRADA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_DOMINGO_ENTRADA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_DOMINGO_ENTRADA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_DOMINGO_ENTRADA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_DOMINGO_ENTRADA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_DOMINGO_ENTRADA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_DOMINGO_ENTRADA4 ),'DD/MM/YYYY HH24:MI');
    END IF;

    IF (P_IN_HR_DOMINGO_SAIDA1 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA1  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_DOMINGO_SAIDA1 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_DOMINGO_SAIDA2 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA2  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_DOMINGO_SAIDA2 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_DOMINGO_SAIDA3 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA3  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_DOMINGO_SAIDA3 ),'DD/MM/YYYY HH24:MI');
    END IF;
    IF (P_IN_HR_DOMINGO_SAIDA4 IS NOT NULL) THEN
       REG_REQUISICAO_JORNADA.HR_DOMINGO_SAIDA4  := TO_DATE('1/1/2000 '|| TRIM( P_IN_HR_DOMINGO_SAIDA4 ),'DD/MM/YYYY HH24:MI');
    END IF;
  END IF;

  REQUISICAO_PKG.SP_DML_REQUISICAO_JORNADA(P_IN_DML, REG_REQUISICAO_JORNADA, P_IN_CHAPA);
  -------------------------------------------------------------------------------
END SP_DML_REQUISICAO_JORNADA;
/
grant execute, debug on REQPES.SP_DML_REQUISICAO_JORNADA to AN$RHEV;


