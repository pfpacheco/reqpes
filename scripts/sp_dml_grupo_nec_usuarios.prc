CREATE OR REPLACE PROCEDURE REQPES.SP_DML_GRUPO_NEC_USUARIOS(P_IN_DML        IN NUMBER
                                                     ,P_IN_COD_GRUPO  IN OUT NUMBER
                                                     ,P_IN_CHAPA      IN VARCHAR2
                                                     ,P_IN_USUARIO    IN VARCHAR2) IS
  REG_GRUPO_NEC_USUARIOS GRUPO_NEC_USUARIOS%ROWTYPE;
BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_GRUPO_NEC_USUARIOS.COD_GRUPO := P_IN_COD_GRUPO;
  REG_GRUPO_NEC_USUARIOS.CHAPA     := P_IN_CHAPA;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_GRUPO_NEC_USUARIOS(P_IN_DML, REG_GRUPO_NEC_USUARIOS, P_IN_USUARIO);
  -------------------------------------------------------------------------------
  IF (P_IN_DML >= 0) THEN
    P_IN_COD_GRUPO := REG_GRUPO_NEC_USUARIOS.COD_GRUPO;
  END IF;

END SP_DML_GRUPO_NEC_USUARIOS;
/
grant execute, debug on REQPES.SP_DML_GRUPO_NEC_USUARIOS to AN$RHEV;


