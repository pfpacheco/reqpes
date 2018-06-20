CREATE OR REPLACE PROCEDURE REQPES.SP_DML_TABELA_SALARIAL(P_IN_DML                    IN NUMBER
                                                  ,P_IN_COD_TAB_SALARIAL       IN OUT NUMBER
                                                  ,P_IN_DSC_TAB_SALARIAL       IN VARCHAR2
                                                  ,P_IN_IND_ATIVO              IN VARCHAR2
                                                  ,P_IN_IND_EXIBE_AREA_SUBAREA IN VARCHAR2
                                                  ,P_IN_USUARIO                IN VARCHAR2) IS
  REG_TABELA_SALARIAL TABELA_SALARIAL%ROWTYPE;
BEGIN
  -- Parametro:  P_IN_DML =>  -1 : excluir; 0 : inserir; 1 : alterar
  -------------------------------------------------------------------------------
  REG_TABELA_SALARIAL.COD_TAB_SALARIAL       := P_IN_COD_TAB_SALARIAL;
  REG_TABELA_SALARIAL.DSC_TAB_SALARIAL       := UPPER(P_IN_DSC_TAB_SALARIAL);
  REG_TABELA_SALARIAL.IND_ATIVO              := P_IN_IND_ATIVO;
  REG_TABELA_SALARIAL.IND_EXIBE_AREA_SUBAREA := P_IN_IND_EXIBE_AREA_SUBAREA;
  -------------------------------------------------------------------------------
  REQUISICAO_PKG.SP_DML_TABELA_SALARIAL(P_IN_DML, REG_TABELA_SALARIAL, P_IN_USUARIO);
  -------------------------------------------------------------------------------
  IF (P_IN_DML >= 0) THEN
     P_IN_COD_TAB_SALARIAL := REG_TABELA_SALARIAL.COD_TAB_SALARIAL;
  END IF;
  
END SP_DML_TABELA_SALARIAL;
/
grant execute, debug on REQPES.SP_DML_TABELA_SALARIAL to AN$RHEV;


