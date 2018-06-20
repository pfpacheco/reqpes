CREATE OR REPLACE PROCEDURE REQPES.SP_NOTIFICA_SUBSTITUICAO_ID(P_IN_REQUISICAO IN REQUISICAO%ROWTYPE, P_IN_RPS_SUBST IN VARCHAR2) AS

  V_CONTA         VARCHAR2(1000);
  V_COPIA_OCULTA  VARCHAR2(100);
  V_ASSUNTO       VARCHAR2(1000);
  V_CORPO         CLOB;
  V_MENSAGEM      VARCHAR2(1000);
  V_ERROR_MESSAGE VARCHAR2(4000);
  -----------------------------------
  V_IND_ENVIA_EMAIL VARCHAR2(1);
  V_EMAIL_REMETENTE VARCHAR2(100);

BEGIN
--------------------------------------------------------------------------------------------------------
-- PROCEDURE RESPONSAVEL POR NOTIFICAR AS REQUISIÇÕES QUE CONTEM O MESMO ID DO FUNCIONARIO SUBSTITUIDO
-- Solicitante: Marli Dias (GEP - AP&B)
-- Author     : Thiago Lima Coutinho
-- Date       : 25/03/2009
--------------------------------------------------------------------------------------------------------

 -----------------------------------------------------------
 -- CARREGANDO PARAMETROS DO SISTEMA
 -----------------------------------------------------------
  SELECT S.VLR_SISTEMA_PARAMETRO
  INTO   V_EMAIL_REMETENTE
  FROM   SYN_SISTEMA_PARAMETRO S
  WHERE  S.COD_SISTEMA   = 7
  AND    S.NOM_PARAMETRO = 'EMAIL_REMETENTE';
  ----------------------------------------------------------
  SELECT S.VLR_SISTEMA_PARAMETRO
  INTO   V_IND_ENVIA_EMAIL
  FROM   SYN_SISTEMA_PARAMETRO S
  WHERE  S.COD_SISTEMA   = 7
  AND    S.NOM_PARAMETRO = 'IND_ENVIAR_EMAILS';

  IF (V_IND_ENVIA_EMAIL = 'S') THEN
     -----------------------------------------------------------
     -- CARREGANDO OS E-MAILS DOS HOMOLOGADORES DA GEP
     -----------------------------------------------------------
      FOR EMAIL_GEP IN ( -- CURSOR DE E-MAILS DOS HOMOLOGADORES
                         SELECT FC.E_MAIL
                         FROM   SYN_SISTEMA_PARAMETRO S
                               ,FUNCIONARIO_COMPLEMENTO FC
                         WHERE  FC.ID_FUNCIONARIO = S.VLR_SISTEMA_PARAMETRO
                         AND    S.COD_SISTEMA     = 7
                         AND    S.NOM_PARAMETRO   = 'HOMOLOGADOR_GEP'
                       ) LOOP

           -----------------------------------------------------
           -- SETANDO A LISTAGEM DE E-MAILS DOS HOMOLOGADORES DA GEP
           -----------------------------------------------------
             V_CONTA := V_CONTA || EMAIL_GEP.E_MAIL || ',';
      END LOOP;

     -----------------------------------------------------
     -- MONTANDO O CORPO DO E-MAIL
     -----------------------------------------------------
       V_ASSUNTO  := 'Funcionário Substituído: Requisição nº '||P_IN_REQUISICAO.REQUISICAO_SQ;
       ------------------------------------------------------------------------
       V_MENSAGEM := 'Na RP <b>'||P_IN_REQUISICAO.REQUISICAO_SQ||'</b>, o funcionário que está sendo substituído já foi utilizado na(s) seguinte(s) RP(s): <br><b>'||P_IN_RPS_SUBST||'</b>.<br><br>';
       V_MENSAGEM := V_MENSAGEM || '<b>Justificativa: </b>'||P_IN_REQUISICAO.DS_MOTIVO_SOLICITACAO;
       ------------------------------------------------------------------------
       V_CORPO := '';
       V_CORPO := V_CORPO || '<head> ';
       V_CORPO := V_CORPO || '    <title>Solicitação</title> ';
       V_CORPO := V_CORPO || '    <meta http-equiv=expires content=\"Mon, 06 Jan 1990 00:00:01 GMT\"> ';
       V_CORPO := V_CORPO || '    <meta http-equiv=\"pragma\" content=\"no-cache\"> ';
       V_CORPO := V_CORPO || '    <META HTTP-EQUIV=\"CACHE-CONTROL\" CONTENT=\"NO-CACHE\"> ';
       V_CORPO := V_CORPO || '	<style> ';
       V_CORPO := V_CORPO || '	   .tdCabecalho{font-family:verdana; color:#FFFFFF; font-size:10px; background-color:#6699CC; font-weight:normal; }';
       V_CORPO := V_CORPO || '     .tdintranet2{font-family:verdana; color:#000000; font-size:10px; background-color:#E7F3FF; }';
       V_CORPO := V_CORPO || '     .tdintranet {font-family:verdana; color:#000000; font-size:10px; background-color:#6699CC; }';
       V_CORPO := V_CORPO || '     .tdNormal   {font-family:verdana; color:#000000; font-size:10px; background-color:#FFFFFF; }';
       V_CORPO := V_CORPO || '		  td.texto { ';
       V_CORPO := V_CORPO || '			  color: #000000; ';
       V_CORPO := V_CORPO || '			  font-family: Verdana, Arial, Helvetica, sans-serif; ';
       V_CORPO := V_CORPO || '			  font-size: 10px; ';
       V_CORPO := V_CORPO || '			  background-color: #FFFFFF; ';
       V_CORPO := V_CORPO || '		  } ';
       V_CORPO := V_CORPO || '	</style> ';
       V_CORPO := V_CORPO || '  </head> ';
       V_CORPO := V_CORPO || '  <body bgcolor="#ffffff" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0" marginwidth="0" marginheight="0" > ';
       V_CORPO := V_CORPO || '  <center><br>  ';
       V_CORPO := V_CORPO || '     <table border="0" width="610" cellpadding="0" cellspacing="0">  ';
       V_CORPO := V_CORPO || '           <tr>  ';
       V_CORPO := V_CORPO || '             <td colspan="2" height="18" class="tdCabecalho">  ';
       V_CORPO := V_CORPO || '              <STRONG>&nbsp;&nbsp;REQUISIÇÃO DE PESSOAL</STRONG>  ';
       V_CORPO := V_CORPO || '             </td>  ';
       V_CORPO := V_CORPO || '           </tr>  ';
       V_CORPO := V_CORPO || '               <tr>  ';
       V_CORPO := V_CORPO || '                 <td colspan="2"  height="6" class="tdintranet2"></td>  ';
       V_CORPO := V_CORPO || '               </tr>     ';
       V_CORPO := V_CORPO || '           <tr>  ';
       V_CORPO := V_CORPO || '              <td height="25" width="5%" align="left" class="tdintranet2">  ';
       V_CORPO := V_CORPO || '              &nbsp; ';
       V_CORPO := V_CORPO || '             </td>  ';
       V_CORPO := V_CORPO || '              <td height="25" width="95%" align="left" class="tdintranet2">  ';
       V_CORPO := V_CORPO ||                V_MENSAGEM;
       V_CORPO := V_CORPO || '              </td>  ';
       V_CORPO := V_CORPO || '           </tr>     ';
       V_CORPO := V_CORPO || '               <tr>  ';
       V_CORPO := V_CORPO || '                 <td colspan="2"  height="6" class="tdintranet2"></td>  ';
       V_CORPO := V_CORPO || '               </tr>     ';
       V_CORPO := V_CORPO || '           <tr>  ';
       V_CORPO := V_CORPO || '              <td height="25" width="5%" align="left" class="tdintranet2">  ';
       V_CORPO := V_CORPO || '              &nbsp; ';
       V_CORPO := V_CORPO || '             </td>  ';
       V_CORPO := V_CORPO || '              <td height="25" width="95%" align="left" class="tdintranet2">  ';
       V_CORPO := V_CORPO || '        Para mais detalhes <a href="http://www.intranet.sp.senac.br/jsp/private/sistemaIntraNovo.jsp?url=login/leRP.cfm?sncReqPes='||P_IN_REQUISICAO.REQUISICAO_SQ||'">clique aqui</a> para acessar o sistema e consultar os dados completos desta requisição.<br><br>';
       V_CORPO := V_CORPO || '              </td>  ';
       V_CORPO := V_CORPO || '           </tr>     ';
       V_CORPO := V_CORPO || '           <tr>  ';
       V_CORPO := V_CORPO || '              <td colspan="2"  height="3" class="tdIntranet"></td>  ';
       V_CORPO := V_CORPO || '           </tr>     ';
       V_CORPO := V_CORPO || '               <tr>  ';
       V_CORPO := V_CORPO || '                 <td colspan="2" align="center" class="tdNormal" ';
       V_CORPO := V_CORPO || '                    <br><br>Esta é uma mensagem automática, por favor não responda este e-mail. ';
       V_CORPO := V_CORPO || '                 </td> ';
       V_CORPO := V_CORPO || '               </tr>     ';
       V_CORPO := V_CORPO || '         </table>      ';
       V_CORPO := V_CORPO || ' </center><br>  ';
       V_CORPO := V_CORPO || '</body> ';

     ------------------------------------------------------------------------------------------
     -- ENVIANDO OS E-MAILS
     ------------------------------------------------------------------------------------------
      V_COPIA_OCULTA := 'marcus.soliveira@sp.senac.br, aroldo.barros@sp.senac.br';

      BEGIN                                                 
        RHEVSENAC.SENDMAILJPKG2.SENDMAILHTML(SMTPSERVERNAME => '10.2.0.36',
                                             SENDER         => V_EMAIL_REMETENTE,
                                             RECIPIENT      => V_CONTA,
                                             CCRECIPIENT    => NULL,
                                             BCCRECIPIENT   => V_COPIA_OCULTA,
                                             SUBJECT        => V_ASSUNTO,
                                             BODY           => V_CORPO,
                                             ERRORMESSAGE   => V_ERROR_MESSAGE);                                                     

      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20003, 'Problemas no envio de email. Mensagem de erro SMTP: ' ||V_ERROR_MESSAGE);
      END;
     -----------------------------------------------------------
  END IF;
END SP_NOTIFICA_SUBSTITUICAO_ID;
/
grant execute, debug on REQPES.SP_NOTIFICA_SUBSTITUICAO_ID to AN$RHEV;


