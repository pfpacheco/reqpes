CREATE OR REPLACE PROCEDURE REQPES.SP_DML_GRUPO_NEC(P_IN_DML        IN NUMBER
                                            ,P_IN_COD_GRUPO  IN OUT NUMBER
                                            ,P_IN_DSC_GRUPO  IN VARCHAR2
                                            ,P_IN_USUARIO    IN VARCHAR2) IS
  REG_GRUPO_NEC GRUPO_NEC%ROWTYPE;
BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_GRUPO_NEC.COD_GRUPO := P_IN_COD_GRUPO;
  REG_GRUPO_NEC.DSC_GRUPO := P_IN_DSC_GRUPO;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_GRUPO_NEC(P_IN_DML, REG_GRUPO_NEC, P_IN_USUARIO);
  -------------------------------------------------------------------------------
  IF (P_IN_DML >= 0) THEN
    P_IN_COD_GRUPO := REG_GRUPO_NEC.COD_GRUPO;
  END IF;

END SP_DML_GRUPO_NEC;
/
grant execute, debug on REQPES.SP_DML_GRUPO_NEC to AN$RHEV;


