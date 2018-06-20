CREATE OR REPLACE PROCEDURE REQPES.SP_DML_USUARIO_AVISO(P_IN_DML            IN NUMBER
                                                ,P_IN_OUT_CHAPA      IN OUT NUMBER
                                                ,P_IN_COD_TIPO_AVISO IN NUMBER
                                                ,P_IN_USUARIO        IN NUMBER) IS
  REG_USUARIO_AVISO USUARIO_AVISO%ROWTYPE;
BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_USUARIO_AVISO.CHAPA := P_IN_OUT_CHAPA;
  REG_USUARIO_AVISO.COD_TIPO_AVISO := P_IN_COD_TIPO_AVISO;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_USUARIO_AVISO(P_IN_DML, REG_USUARIO_AVISO, P_IN_USUARIO);
  -------------------------------------------------------------------------------
  IF (P_IN_DML = 0) THEN
    P_IN_OUT_CHAPA := REG_USUARIO_AVISO.CHAPA;
  END IF;
  -------------------------------------------------------------------------------
END SP_DML_USUARIO_AVISO;
/
grant execute, debug on REQPES.SP_DML_USUARIO_AVISO to AN$RHEV;


