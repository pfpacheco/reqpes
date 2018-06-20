CREATE OR REPLACE PROCEDURE REQPES.SP_DML_REQUISICAO_BAIXA(P_IN_DML                IN NUMBER
                                                   ,P_IN_REQUISICAO_SQ      IN NUMBER
                                                   ,P_IN_OUT_FUNCIONARIO_ID IN OUT NUMBER
                                                   ,P_IN_USUARIO            IN VARCHAR2) IS

  REG_REQUISICAO_BAIXA REQUISICAO_BAIXA%ROWTYPE;

BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_REQUISICAO_BAIXA.FUNCIONARIO_ID := P_IN_OUT_FUNCIONARIO_ID;
  REG_REQUISICAO_BAIXA.REQUISICAO_SQ  := P_IN_REQUISICAO_SQ;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_REQUISICAO_BAIXA(P_IN_DML,REG_REQUISICAO_BAIXA,P_IN_USUARIO);
  -------------------------------------------------------------------------------
  -- Retornando o codigo da requisição
  P_IN_OUT_FUNCIONARIO_ID := REG_REQUISICAO_BAIXA.FUNCIONARIO_ID;
  -------------------------------------------------------------------------------
END SP_DML_REQUISICAO_BAIXA;
/
grant execute, debug on REQPES.SP_DML_REQUISICAO_BAIXA to AN$RHEV;


