CREATE OR REPLACE FUNCTION REQPES.F_GET_ID_CODE_COMBINATION(P_IN_CENTRO_CUSTO IN VARCHAR2)
  RETURN VARCHAR2 IS

  --=======================================================================================--
  -- Data: 05/12/2011
  -- Autor: Thiago Lima Coutinho
  -- Descrição: Executa a API do ERP Oracle para a criação da Code Combination no GL utilizando
  --            a conta contábil 311210101 SALÁRIO (conta definida pela GEF - Valter)
  --=======================================================================================--

  V_CHART_OF_ACCOUNTS_ID NUMBER;
  V_COD_COMBINATION_ID   NUMBER;
  V_MESSAGE              VARCHAR2(4000);
  V_CC_CONTA_CONTABIL    VARCHAR2(50);
  
BEGIN
  -- Obtendo a Conta Contábil parametrizada no sistema
  -- Atualmente retorna a conta (311210101 - Salário)
  SELECT VLR_SISTEMA_PARAMETRO
  INTO   V_CC_CONTA_CONTABIL
  FROM   SYN_SISTEMA_PARAMETRO
  WHERE  COD_SISTEMA   = 7
  AND    NOM_PARAMETRO = 'CC_CONTA_CONTABIL';
  
  -- Obtendo o ID do Chart of Accounts (COA)
  V_CHART_OF_ACCOUNTS_ID := XXGL_UTIL.GET_COA_ID('LIVRO_SENAC_PLANO_NOVO');

  -- API: Obtendo o CODE_COMBINATION_ID
  V_COD_COMBINATION_ID := XXFND_FLEX_EXT.GET_CCID(V_CHART_OF_ACCOUNTS_ID -- ID do plano de contas
                                                              ,P_IN_CENTRO_CUSTO ||'.'|| V_CC_CONTA_CONTABIL ||'.0' -- Centro de custo
                                                              ,V_MESSAGE); -- Variável OUT que armazena mensagem qdo não é possível criar a combinação

  IF (V_COD_COMBINATION_ID > 0) THEN
    V_MESSAGE := 'OK';
  END IF;

  RETURN V_COD_COMBINATION_ID ||'|'|| UPPER(V_MESSAGE);

EXCEPTION
  WHEN OTHERS THEN
    RETURN '-1|ERRO EM F_GET_ID_CODE_COMBINATION (Oracle API): '||SQLERRM;

END F_GET_ID_CODE_COMBINATION;
/
grant execute, debug on REQPES.F_GET_ID_CODE_COMBINATION to AN$RHEV;


