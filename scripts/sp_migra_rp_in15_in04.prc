CREATE OR REPLACE PROCEDURE REQPES.SP_MIGRA_RP_IN15_IN04 AS

  V_NRO_REVISAO NUMBER;
  V_SYSDATE     VARCHAR2(100) := TO_CHAR(SYSDATE, 'DD/MM/RRRR HH24:MI:SS');

BEGIN

  FOR C_RP IN (SELECT *
               FROM   (SELECT R.REQUISICAO_SQ
                             ,R.DT_REQUISICAO DT_CRIACAO
                             ,T.DSC_STATUS
                             ,R.COD_UNIDADE
                             ,CD.ID ID_CARGO
                             ,CD.DESCRICAO CARGO
                             ,R.COTA
                             ,R.SALARIO
                             ,CAR.ID ID_CARGO_NEW
                             ,CAR.DESCRICAO CARGO_NEW
                             ,F_GET_COTA_TST(R.COD_UNIDADE, CAR.ID) COTA_NEW
                             ,F_GET_SALARIO_TST(R.COD_UNIDADE,
                                                CAR.ID,
                                                (F_GET_COTA_TST(R.COD_UNIDADE,
                                                                CAR.ID))) SALARIO_NEW
                       FROM   REQUISICAO R
                             ,REQUISICAO_STATUS T
                             ,CARGO_DESCRICOES CD
                             ,CARGOS C
                             ,(SELECT *
                               FROM   HISTORICO_REQUISICAO HR
                               WHERE  HR.DT_ENVIO =
                                      (SELECT MAX(HR1.DT_ENVIO)
                                       FROM   HISTORICO_REQUISICAO HR1
                                       WHERE  HR1.REQUISICAO_SQ =
                                              HR.REQUISICAO_SQ)) HR
                             ,(SELECT C.ID
                                     ,D.DESCRICAO
                                     ,C.HORAS_SEMANAIS
                               FROM   CARGO_DESCRICOES D
                                     ,CARGOS           C
                               WHERE  C.ID = D.ID
                               AND    C.IN_SITUACAO_CARGO = 'A'
                               AND    C.ID IN
                                      (SELECT UNIQUE UCTN.ID_CARGO
                                        FROM   UNIORG_CARGO_TAB_NIVEL UCTN
                                        WHERE  UCTN.TAB_SALARIAL = 5)) CAR
                       
                       WHERE  HR.REQUISICAO_SQ = R.REQUISICAO_SQ
                       AND    T.COD_STATUS = R.COD_STATUS
                       AND    CD.ID = R.CARGO_SQ
                       AND    C.ID = R.CARGO_SQ
                       AND    C.HORAS_SEMANAIS = CAR.HORAS_SEMANAIS
                       AND    R.COD_STATUS IN (1, 2, 3, 4) -- STATUS: ABERTA, HOMOLOGAÇÃO, REVISÃO, APROVADA
                       AND    CD.ID IN
                              (SELECT UNIQUE UCTN.ID_CARGO
                                FROM   UNIORG_CARGO_TAB_NIVEL UCTN
                                WHERE  UCTN.TAB_SALARIAL = 5)
                       AND    R.IND_CARATER_EXCECAO = 'N'
                       AND    R.COD_UNIDADE <> '107C')
               WHERE  SALARIO_NEW >= SALARIO) LOOP
    
    -- Atualizando cota, cargo e salário
    UPDATE REQUISICAO R
    SET    R.CARGO_SQ = C_RP.ID_CARGO_NEW
          ,R.COTA     = C_RP.COTA_NEW
          ,R.SALARIO  = C_RP.SALARIO_NEW
    WHERE  R.REQUISICAO_SQ = C_RP.REQUISICAO_SQ;

    -- Gravando registro na tabela de revisão (manter histórico)  
    SELECT COUNT(*) + 1
    INTO   V_NRO_REVISAO
    FROM   REQUISICAO_REVISAO R
    WHERE  R.REQUISICAO_SQ = C_RP.REQUISICAO_SQ;
  
    INSERT INTO REQUISICAO_REVISAO
      (REQUISICAO_SQ
      ,NRO_REVISAO
      ,STATUS
      ,MOTIVO)
    VALUES
      (C_RP.REQUISICAO_SQ
      ,V_NRO_REVISAO
      ,'fechada'
      ,'Data: ' || V_SYSDATE ||
       ' <br>Usuários: Mauro, Lydia, Rosana e Laercio' ||
       ' <br>Motivo: Migração dos campos cargo, cota e salário, atendendo a nova resolução IN04/2011' ||
       ' <br>Alterações: id_cargo_old='|| C_RP.ID_CARGO ||' id_cargo_new='|| C_RP.ID_CARGO_NEW ||' / cota_old='||C_RP.COTA ||' cota_new='|| C_RP.COTA_NEW ||' / salario_old='||C_RP.SALARIO ||' salario_new='|| C_RP.SALARIO_NEW);  
  
  END LOOP;  
  --
  COMMIT;
  --
END SP_MIGRA_RP_IN15_IN04;
/
grant execute, debug on REQPES.SP_MIGRA_RP_IN15_IN04 to AN$RHEV;


