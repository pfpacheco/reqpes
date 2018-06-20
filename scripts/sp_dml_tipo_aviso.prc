CREATE OR REPLACE PROCEDURE REQPES.SP_DML_TIPO_AVISO(P_IN_DML            IN NUMBER
                                             ,P_IN_COD_TIPO_AVISO IN OUT NUMBER
                                             ,P_IN_TITULO         IN VARCHAR2
                                             ,P_IN_CARGO_CHAVE    IN VARCHAR2
                                             ,P_IN_CARGO_REGIME   IN VARCHAR2
                                             ,P_IN_USUARIO        IN NUMBER) IS
  REG_TIPO_AVISO TIPO_AVISO%ROWTYPE;
BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  IF (P_IN_CARGO_REGIME = 'N') THEN
     REG_TIPO_AVISO.CARGO_REGIME := NULL;
  ELSE
     REG_TIPO_AVISO.CARGO_REGIME := P_IN_CARGO_REGIME;
  END IF;

  REG_TIPO_AVISO.COD_TIPO_AVISO := P_IN_COD_TIPO_AVISO;
  REG_TIPO_AVISO.TITULO         := P_IN_TITULO;
  REG_TIPO_AVISO.CARGO_CHAVE    := P_IN_CARGO_CHAVE;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_TIPO_AVISO(P_IN_DML, REG_TIPO_AVISO, P_IN_USUARIO);
  -------------------------------------------------------------------------------
  IF (P_IN_DML >= 0) THEN
    P_IN_COD_TIPO_AVISO := REG_TIPO_AVISO.COD_TIPO_AVISO;
  END IF;

END SP_DML_TIPO_AVISO;
/
grant execute, debug on REQPES.SP_DML_TIPO_AVISO to AN$RHEV;


