CREATE OR REPLACE PROCEDURE REQPES.SP_DML_GRUPO_NEC_UNIDADES(P_IN_DML         IN NUMBER
                                                     ,P_IN_COD_GRUPO   IN NUMBER
                                                     ,P_IN_COD_UNIDADE IN VARCHAR2) IS

  REG_GRUPO_NEC_UNIDADES GRUPO_NEC_UNIDADES%ROWTYPE;
BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_GRUPO_NEC_UNIDADES.COD_GRUPO   := P_IN_COD_GRUPO;
  REG_GRUPO_NEC_UNIDADES.COD_UNIDADE := P_IN_COD_UNIDADE;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_GRUPO_NEC_UNIDADES(P_IN_DML, REG_GRUPO_NEC_UNIDADES);
  -------------------------------------------------------------------------------
END SP_DML_GRUPO_NEC_UNIDADES;
/
grant execute, debug on REQPES.SP_DML_GRUPO_NEC_UNIDADES to AN$RHEV;


