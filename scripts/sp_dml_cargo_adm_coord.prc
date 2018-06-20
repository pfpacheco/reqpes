CREATE OR REPLACE PROCEDURE REQPES.SP_DML_CARGO_ADM_COORD(P_IN_DML         IN NUMBER
                                                  ,P_IN_COD_UNIDADE IN VARCHAR2
                                                  ,P_IN_USUARIO     IN NUMBER) IS

  REG_UO_CARGO_ADM_COORD UO_CARGO_ADM_COORD%ROWTYPE;
  
BEGIN 
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_UO_CARGO_ADM_COORD.COD_UNIDADE := P_IN_COD_UNIDADE;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_CARGO_ADM_COORD(P_IN_DML,REG_UO_CARGO_ADM_COORD,P_IN_USUARIO);
  -------------------------------------------------------------------------------  
END SP_DML_CARGO_ADM_COORD;
/
grant execute, debug on REQPES.SP_DML_CARGO_ADM_COORD to AN$RHEV;


