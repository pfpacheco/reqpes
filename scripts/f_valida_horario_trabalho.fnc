CREATE OR REPLACE FUNCTION REQPES.F_VALIDA_HORARIO_TRABALHO(P_HORA_ENTRADA VARCHAR2, P_HORA_SAIDA VARCHAR2) RETURN NUMBER IS

  V_HORA_ENTRADA DATE;
  V_HORA_SAIDA   DATE;
  V_RETORNO      NUMBER;
  V_DATA_ATUAL   DATE := TRUNC(SYSDATE);

BEGIN
  -----------------------------------------------------------------------------------
  -- VERIFICA SE A HORA E VALIDA
  -----------------------------------------------------------------------------------
  IF ((P_HORA_ENTRADA IS NOT NULL AND P_HORA_ENTRADA <> '0') AND (P_HORA_SAIDA IS NOT NULL AND P_HORA_SAIDA <> '0')) THEN
    -- Cria datas com as horas informadas
    V_HORA_ENTRADA := TO_DATE(V_DATA_ATUAL ||' '||P_HORA_ENTRADA,'dd/mm/yyyy HH24:MI');
    V_HORA_SAIDA   := TO_DATE(V_DATA_ATUAL ||' '||P_HORA_SAIDA  ,'dd/mm/yyyy HH24:MI');

    -- Caso a data de saida seja menor que a data de entrada, soma 1 dia para realização do calculo
    IF (V_HORA_SAIDA < V_HORA_ENTRADA) THEN
       V_HORA_SAIDA := TO_DATE(V_DATA_ATUAL+1 ||' '||P_HORA_SAIDA  ,'dd/mm/yyyy HH24:MI');
    END IF;

    -- Converte os milisegundos em horas
    V_RETORNO := (V_HORA_ENTRADA - V_HORA_SAIDA)*1440/60*-1;
  ELSE
    V_RETORNO := 0;
  END IF;
  --------------------------------------------------
  RETURN V_RETORNO;
  --------------------------------------------------
END F_VALIDA_HORARIO_TRABALHO;
/
grant execute, debug on REQPES.F_VALIDA_HORARIO_TRABALHO to AN$RHEV;


