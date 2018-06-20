CREATE OR REPLACE PROCEDURE REQPES.SP_NOTIFICA_UO_NEC AS

  V_CONTA           VARCHAR2(1000);
  V_COPIA_OCULTA    VARCHAR2(100)  := 'marcus.soliveira@sp.senac.br';
  V_ASSUNTO         VARCHAR2(1000) := 'Requisição de Pessoal - Unidades sem associação no workflow de aprovação';
  V_CORPO           VARCHAR2(4000);
  V_MENSAGEM        VARCHAR2(2000);
  V_ERROR_MESSAGE   VARCHAR2(4000);
  V_EMAIL_REMETENTE VARCHAR2(100);

BEGIN  
-------------------------------------------------------------------------------------
-- PROCEDURE RESPONSÁVEL POR NOTIFICAR AS UO'S SEM ASSOCIAÇÃO NO GRUPO NEC - WORKFLOW
-- Author: Thiago Lima Coutinho
-- Date  : 06/12/2011
-------------------------------------------------------------------------------------

  -----------------------------------------------------------
  -- CARREGANDO PARAMETROS DO SISTEMA
  -----------------------------------------------------------
    SELECT S.VLR_SISTEMA_PARAMETRO
    INTO   V_EMAIL_REMETENTE
    FROM   SYN_SISTEMA_PARAMETRO S
    WHERE  S.COD_SISTEMA     = 7
    AND    S.NOM_PARAMETRO   = 'EMAIL_REMETENTE';

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
  --------------------------------------------------------------------------
  -- MONTANDO O CORPO DO E-MAIL
  --------------------------------------------------------------------------   
    FOR UO IN ( SELECT UO.CODIGO
                      ,UO.SIGLA
                      ,UO.DESCRICAO
                FROM   UNIDADES_ORGANIZACIONAIS UO
                WHERE  UO.NIVEL = 2
                AND    UO.DATA_ENCERRAMENTO IS NULL
                AND    UO.CODIGO NOT IN ('SA', 'SU', 'SO', 'SD', '001C')
                AND    NOT EXISTS (SELECT 1
                        FROM   GRUPO_NEC_UNIDADES GU
                        WHERE  GU.COD_UNIDADE = UO.CODIGO)
                ORDER  BY CODIGO) LOOP
                
        V_MENSAGEM := V_MENSAGEM || '<tr class="borderintranet">';
        V_MENSAGEM := V_MENSAGEM ||   '<td height="16">&nbsp;' || UO.CODIGO    || '</td>';
        V_MENSAGEM := V_MENSAGEM ||   '<td height="16">&nbsp;' || UO.SIGLA     || '</td>';
        V_MENSAGEM := V_MENSAGEM ||   '<td height="16">&nbsp;' || UO.DESCRICAO || '</td>';
        V_MENSAGEM := V_MENSAGEM || '</tr>';
        
    END LOOP;
    
    ------------------------------------------------------------------------
    IF (V_MENSAGEM IS NOT NULL) THEN
      V_CORPO :=  '<head>';
      V_CORPO := V_CORPO ||   '<style type="text/css">';
      V_CORPO := V_CORPO ||     '.tdCabecalho{font-family:verdana; color:#FFFFFF; font-size:10px; background-color:#6699CC; font-weight:normal; }';
      V_CORPO := V_CORPO ||     '.tdintranet3{font-family:verdana; color:#000000; font-size:10px; background-color:#A8CEE6; }';
      V_CORPO := V_CORPO ||     '.tdintranet2{font-family:verdana; color:#000000; font-size:10px; background-color:#E7F3FF; }';
      V_CORPO := V_CORPO ||     '.tdintranet {font-family:verdana; color:#000000; font-size:10px; background-color:#6699CC; }';
      V_CORPO := V_CORPO ||     '.tdNormal   {font-family:verdana; color:#000000; font-size:10px; background-color:#FFFFFF; }';
      V_CORPO := V_CORPO ||     '.borderintranet {font-family:verdana; color:#000000; font-size:10px; background-color:#F9FCFF; }';
      V_CORPO := V_CORPO ||     'td.texto {color:#000000; font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px; background-color: #FFFFFF; }';
      V_CORPO := V_CORPO ||   '</style>';
      V_CORPO := V_CORPO || '</head>';
      V_CORPO := V_CORPO || '<body bgcolor="#ffffff" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0" marginwidth="0" marginheight="0" >';
      V_CORPO := V_CORPO ||   '<center><br>';
      V_CORPO := V_CORPO ||     '<table border="0" width="610" cellpadding="0" cellspacing="0">';
      V_CORPO := V_CORPO ||       '<tr>';
      V_CORPO := V_CORPO ||         '<td height="18" class="tdCabecalho">';
      V_CORPO := V_CORPO ||           '<STRONG>&nbsp;&nbsp;REQUISIÇÃO DE PESSOAL</STRONG>';
      V_CORPO := V_CORPO ||         '</td>';
      V_CORPO := V_CORPO ||       '</tr>';            
      V_CORPO := V_CORPO ||       '<tr>';
      V_CORPO := V_CORPO ||         '<td height="30" align="left" class="tdintranet2">';
      V_CORPO := V_CORPO ||           '<br>';
      V_CORPO := V_CORPO ||           '&nbsp;&nbsp;&nbsp;&nbsp;Unidades ativas no RHEvolution sem associação no workflow de aprovação no nível <b>GEP-NEC</b>.<br>';
      V_CORPO := V_CORPO ||           '&nbsp;&nbsp;&nbsp;&nbsp;Favor abrir um chamado via <i>Service Desk</i> informando as responsabilidades.<br><br>';
      V_CORPO := V_CORPO ||         '</td>';
      V_CORPO := V_CORPO ||     '</tr>';
      V_CORPO := V_CORPO ||     '<tr>';
      V_CORPO := V_CORPO ||         '<td align="center" class="tdintranet2">';
      V_CORPO := V_CORPO ||           '<table border="0" width="87%" style="background:#6699CC;" cellpadding="0" cellspacing="1">';
      V_CORPO := V_CORPO ||             '<tr>';
      V_CORPO := V_CORPO ||               '<td class="tdintranet3" width="10%" align="left" height="18"><strong>&nbsp;Código</strong></td>';
      V_CORPO := V_CORPO ||               '<td class="tdintranet3" width="15%" align="left" height="18"><strong>&nbsp;Sigla</strong></td>';
      V_CORPO := V_CORPO ||               '<td class="tdintranet3" width="75%" align="left" height="18"><strong>&nbsp;Unidade</strong></td>';
      V_CORPO := V_CORPO ||             '</tr>';
      V_CORPO := V_CORPO || V_MENSAGEM;
      V_CORPO := V_CORPO ||           '</table>';
      V_CORPO := V_CORPO ||         '</td>';
      V_CORPO := V_CORPO ||       '</tr>';            
      V_CORPO := V_CORPO ||       '<tr>';
      V_CORPO := V_CORPO ||         '<td height="30" align="left" class="tdintranet2"><br></td>';
      V_CORPO := V_CORPO ||       '</tr>';
      V_CORPO := V_CORPO ||       '<tr>';
      V_CORPO := V_CORPO ||         '<td height="3" class="tdIntranet"></td>';
      V_CORPO := V_CORPO ||       '</tr>';
      V_CORPO := V_CORPO ||       '<tr>';
      V_CORPO := V_CORPO ||         '<td align="center" class="tdNormal">';
      V_CORPO := V_CORPO ||           '<br>Esta é uma mensagem automática, por favor não responda este e-mail.';
      V_CORPO := V_CORPO ||         '</td>';
      V_CORPO := V_CORPO ||       '</tr>';
      V_CORPO := V_CORPO ||     '</table>';
      V_CORPO := V_CORPO ||   '</center><br>';
      V_CORPO := V_CORPO || '</body>';

      -- Notificando a GEP 
      RHEVSENAC.SENDMAILJPKG2.SENDMAILHTML(SMTPSERVERNAME => '10.2.0.36',
                                           SENDER         => V_EMAIL_REMETENTE,
                                           RECIPIENT      => V_CONTA,
                                           CCRECIPIENT    => NULL,
                                           BCCRECIPIENT   => V_COPIA_OCULTA,
                                           SUBJECT        => V_ASSUNTO,
                                           BODY           => V_CORPO,
                                           ERRORMESSAGE   => V_ERROR_MESSAGE);                                                
    ELSE
      -- Notificando a GES sobre a execução do processo qdo não houverem unidades pendentes
      RHEVSENAC.SENDMAILJPKG2.SENDMAILHTML(SMTPSERVERNAME => '10.2.0.36',
                                           SENDER         => V_EMAIL_REMETENTE,
                                           RECIPIENT      => V_COPIA_OCULTA,
                                           CCRECIPIENT    => NULL,
                                           BCCRECIPIENT   => NULL,
                                           SUBJECT        => V_ASSUNTO,
                                           BODY           => 'Nenhuma pendência encontrada',
                                           ERRORMESSAGE   => V_ERROR_MESSAGE);                                                
    END IF;

END SP_NOTIFICA_UO_NEC;
/
grant execute, debug on REQPES.SP_NOTIFICA_UO_NEC to AN$RHEV;


