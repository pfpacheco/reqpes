CREATE OR REPLACE PROCEDURE REQPES.SP_GET_UNIDADE_DESTINO(P_COD_UNIORG IN OUT VARCHAR2
                                                  ,P_UO_CERTA   IN OUT VARCHAR2
                                                  ,P_ID_GER     IN OUT NUMBER
                                                  ,P_TENTATIVA  IN OUT NUMBER
                                                  ,P_TEOR_COD   IN OUT VARCHAR2) IS

  V_COD_UNIORG VARCHAR2(4)  := P_COD_UNIORG;
  V_TEOR_COD   VARCHAR2(10) := P_TEOR_COD;
  V_NOVA_UO    VARCHAR2(4)  := '';

BEGIN
-------------------------------------------------------------------------------------
-- PROCEDURE QUE RETORNA A UNIDADE DE DESTINO ATRAVES DA UNIDADE INFORMADA
-- Author: Aroldo Barros / Thiago Lima Coutinho
-- Date  : 3/7/2009
-------------------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  -- CARREGANDO O ID DO GERENTE DA UNIDADE INFORMADA
  ---------------------------------------------------------------------------
  BEGIN
    SELECT RE.FUNC_ID
    INTO   P_ID_GER
    FROM   RESPONSAVEL_ESTRUTURA RE
    WHERE  RE.UNOR_COD = P_COD_UNIORG
    AND    RE.TEOR_COD = P_TEOR_COD
    AND    TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN;
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      P_ID_GER := 0;
  END;

  ---------------------------------------------------------------------------
  -- CASO A UNIDADE INFORMADA NÃO POSSUA GERENTE ASSOCIADO, BUSCA DA UO PAI
  ---------------------------------------------------------------------------
  IF (P_ID_GER = 0) THEN
    SELECT MAX(UNOR_COD_PAI)
    INTO   V_NOVA_UO
    FROM   ESTRUTURA_ORGANIZACIONAL EO
    WHERE  EO.TEOR_COD = P_TEOR_COD
    AND    EO.UNOR_COD = P_COD_UNIORG;

    -- Chamada recursiva para busca do gerente da unidade Pai
    IF (P_TENTATIVA < 5) THEN
      P_TENTATIVA := P_TENTATIVA + 1;
      SP_GET_UNIDADE_DESTINO(V_NOVA_UO, P_UO_CERTA, P_ID_GER, P_TENTATIVA, P_TEOR_COD);
    END IF;

  ELSE
    -- Caso seja encontrado o gerente da Unidade, seta valores no retorno
    P_COD_UNIORG := V_COD_UNIORG;
    P_UO_CERTA   := V_COD_UNIORG;
    P_TEOR_COD   := V_TEOR_COD;
  END IF;
  ---------------------------------------------------------------------------
END SP_GET_UNIDADE_DESTINO;
/
grant execute, debug on REQPES.SP_GET_UNIDADE_DESTINO to AN$RHEV;


