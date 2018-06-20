CREATE OR REPLACE FUNCTION REQPES.UO_CODIGO_NIVEL(PCODIGO IN VARCHAR2, PNIVEL IN NUMBER) RETURN VARCHAR2 IS
  RESULTE VARCHAR2(10);
  VNIVEL  NUMBER := 99;
  VCODIGO VARCHAR2(10) := PCODIGO;
  /* Retorna o cod_uniorg de uma Unidade Organizacional do Senac para o nivel <nivel> */
BEGIN
  ----------------------------------------
  WHILE VNIVEL <> PNIVEL LOOP
    -- Tuning 15/12/2006 - Aroldo Barros
    SELECT UO.CODIGO_PAI
          ,UO.NIVEL - 1
    INTO   RESULTE
          ,VNIVEL
    FROM   UNIDADES_ORGANIZACIONAIS UO
    WHERE  UO.CODIGO = VCODIGO;
    ----------------------------------------
    VCODIGO := RESULTE;
  END LOOP;
  ----------------------------------------
  RETURN(RESULTE);
  ----------------------------------------
END UO_CODIGO_NIVEL;
/
grant execute, debug on REQPES.UO_CODIGO_NIVEL to AN$RHEV;


