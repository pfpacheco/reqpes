CREATE OR REPLACE PROCEDURE REQPES.SP_REMOVE_REQUISICAO(P_IN_REQUISICAO_SQ IN NUMBER, P_IN_ERROR IN VARCHAR2) AS
-------------------------------------------------------------------------------------
-- PROCEDURE RESPONSAVEL POR REMOVER AS RP's INCONSISTENTES
-- Author: Thiago Lima Coutinho
-- Date  : 14/12/2009
-------------------------------------------------------------------------------------

  V_ERRORMESSAGE VARCHAR2(4000);                                   

BEGIN

  DELETE FROM HISTORICO_REQUISICAO H
  WHERE  H.REQUISICAO_SQ = P_IN_REQUISICAO_SQ;
  
  DELETE FROM REQUISICAO_JORNADA J
  WHERE  J.REQUISICAO_SQ = P_IN_REQUISICAO_SQ;
  
  DELETE FROM REQUISICAO_PERFIL P
  WHERE  P.REQUISICAO_SQ = P_IN_REQUISICAO_SQ;
  
  DELETE FROM REQUISICAO R
  WHERE R.REQUISICAO_SQ = P_IN_REQUISICAO_SQ;
  
  -----------------------------------------------------
  RHEVSENAC.SENDMAILJPKG2.SENDMAILHTML(SMTPSERVERNAME => '10.2.0.36',
                                       SENDER         => 'ges_suporte@sp.senac.br',
                                       RECIPIENT      => 'marcus.soliveira@sp.senac.br',
                                       CCRECIPIENT    => NULL,
                                       BCCRECIPIENT   => NULL,
                                       SUBJECT        => 'ERRO: Requisição de Pessoal (PROD)',
                                       BODY           => 'SP_REMOVE_REQUISICAO executada com a RP nº: ' || P_IN_REQUISICAO_SQ || ' devido o seguinte erro: <br><br>' || P_IN_ERROR,
                                       ERRORMESSAGE   => V_ERRORMESSAGE);
  -----------------------------------------------------
  COMMIT;
  -----------------------------------------------------

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RHEVSENAC.SENDMAILJPKG2.SENDMAILHTML(SMTPSERVERNAME => '10.2.0.36',
                                           SENDER         => 'ges_suporte@sp.senac.br',
                                           RECIPIENT      => 'marcus.soliveira@sp.senac.br',
                                           CCRECIPIENT    => NULL,
                                           BCCRECIPIENT   => NULL,
                                           SUBJECT        => 'ERRO: Requisição de Pessoal (PROD)',
                                           BODY           => 'PROBLEMA AO EXECUTAR O PROCEDIMENTO SP_REMOVE_REQUISICAO com a RP nº: ' || P_IN_REQUISICAO_SQ || ' devido o seguinte erro: <br><br>' || P_IN_ERROR,
                                           ERRORMESSAGE   => V_ERRORMESSAGE);  
      -----------------------------------------------------
      RAISE_APPLICATION_ERROR(-20024,'PROBLEMA AO EXECUTAR O PROCEDIMENTO SP_REMOVE_REQUISICAO. ERRO: ' || SQLERRM);
        
END SP_REMOVE_REQUISICAO;
/
grant execute, debug on REQPES.SP_REMOVE_REQUISICAO to AN$RHEV;


