CREATE OR REPLACE PROCEDURE REQPES.SP_DML_INSTRUCAO(P_IN_DML                    IN NUMBER
                                            ,P_IN_COD_INSTRUCAO          IN OUT NUMBER
                                            ,P_IN_COD_TAB_SALARIAL       IN NUMBER
                                            ,P_IN_COD_CARGO              IN NUMBER
                                            ,P_IN_COTA                   IN NUMBER
                                            ,P_IN_COD_AREA_SUBAREA       IN VARCHAR2
                                            ,P_IN_USUARIO                IN VARCHAR2) IS
  REG_INSTRUCAO INSTRUCAO%ROWTYPE;
BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_INSTRUCAO.COD_INSTRUCAO     := P_IN_COD_INSTRUCAO;
  REG_INSTRUCAO.COD_TAB_SALARIAL  := P_IN_COD_TAB_SALARIAL;
  REG_INSTRUCAO.COD_CARGO         := P_IN_COD_CARGO;
  REG_INSTRUCAO.COTA              := P_IN_COTA;
  REG_INSTRUCAO.COD_AREA_SUBAREA  := P_IN_COD_AREA_SUBAREA;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_INSTRUCAO(P_IN_DML, REG_INSTRUCAO, P_IN_USUARIO);
  -------------------------------------------------------------------------------
  IF (P_IN_DML >= 0) THEN
    P_IN_COD_INSTRUCAO := REG_INSTRUCAO.COD_INSTRUCAO;
  END IF;

END SP_DML_INSTRUCAO;
/
grant execute, debug on REQPES.SP_DML_INSTRUCAO to AN$RHEV;


