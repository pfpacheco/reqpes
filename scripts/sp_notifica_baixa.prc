CREATE OR REPLACE PROCEDURE REQPES.SP_NOTIFICA_BAIXA(P_REQUISICAO_SQ    IN NUMBER
                                             ,P_REG_FUNCIONARIOS IN FUNCIONARIOS%ROWTYPE
                                             ,P_TIPO_MSG         IN NUMBER) AS

  V_COPIA           VARCHAR2(1000);
  V_CONTA           VARCHAR2(1000);
  V_COPIA_OCULTA    VARCHAR2(100) := 'otavio.remedio@sp.senac.br';
  V_ASSUNTO         VARCHAR2(1000);
  V_CORPO           VARCHAR2(4000);
  V_MENSAGEM        VARCHAR2(1000);
  V_ERROR_MESSAGE   VARCHAR2(4000);
  V_EMAIL_REMETENTE VARCHAR2(100);
  V_IND_ENVIA_EMAIL VARCHAR2(1);
  V_INSTANCIA_ATUAL VARCHAR2(10);
  V_INSTANCIA_PROD  VARCHAR(4):= 'RHEV';

BEGIN  
-------------------------------------------------------------------------------------
-- PROCEDURE RESPONSÁVEL POR NOTIFICAR AS BAIXAS DAS REQUISIÇÕES
-- Author: Thiago Lima Coutinho
-- Date  : 26/10/2011
-------------------------------------------------------------------------------------
    SELECT UPPER(SYS_CONTEXT('USERENV','DB_NAME'))
    INTO V_INSTANCIA_ATUAL
    FROM DUAL;  


  -----------------------------------------------------------
  -- VERIFICA SE O PROCESSO PODE SER EXECUTADO
  -----------------------------------------------------------
    SELECT S.VLR_SISTEMA_PARAMETRO
    INTO   V_IND_ENVIA_EMAIL
    FROM   SYN_SISTEMA_PARAMETRO S
    WHERE  S.COD_SISTEMA   = 7
    AND    S.NOM_PARAMETRO = 'IND_ENVIAR_EMAILS';


    IF (V_IND_ENVIA_EMAIL = 'S') THEN 
      -----------------------------------------------------------
      -- CARREGANDO PARAMETROS DO SISTEMA
      -----------------------------------------------------------
        SELECT S.VLR_SISTEMA_PARAMETRO
        INTO   V_EMAIL_REMETENTE
        FROM   SYN_SISTEMA_PARAMETRO S
        WHERE  S.COD_SISTEMA   = 7
        AND    S.NOM_PARAMETRO = 'EMAIL_REMETENTE';

      -----------------------------------------------------------
      -- CARREGANDO OS E-MAILS DOS COLABORADORES 
      -----------------------------------------------------------
        FOR EMAIL_GEP IN ( -- CURSOR DE E-MAILS DOS HOMOLOGADORES AP&B
                           SELECT FC.E_MAIL
                           FROM   SYN_SISTEMA_PARAMETRO   S
                                 ,FUNCIONARIO_COMPLEMENTO FC
                           WHERE  FC.ID_FUNCIONARIO = S.VLR_SISTEMA_PARAMETRO
                           AND    S.COD_SISTEMA = 7
                           AND    S.NOM_PARAMETRO = 'HOMOLOGADOR_GEP'
                           --
                           UNION
                           -- CURSOR CONTENDO OS USUÁRIOS QUE PARTICIPARAM DA HOMOLOGAÇÃO
                           SELECT UNIQUE FC.E_MAIL
                           FROM   HISTORICO_REQUISICAO    H
                                 ,USUARIO                 U
                                 ,FUNCIONARIO_COMPLEMENTO FC
                           WHERE  H.USUARIO_SQ = U.USUARIO_SQ
                           AND    FC.ID_FUNCIONARIO = U.IDENTIFICACAO
                           AND    H.STATUS <> 'aprovou'
                           AND    H.REQUISICAO_SQ = P_REQUISICAO_SQ
                         ) LOOP

             -----------------------------------------------------
             -- SETANDO A LISTAGEM DE E-MAILS DOS HOMOLOGADORES DA GEP
             -----------------------------------------------------
               V_COPIA := V_COPIA || EMAIL_GEP.E_MAIL || ',';
        END LOOP;

      --------------------------------------------------------------------------
      -- MONTANDO O CORPO DO E-MAIL
      --------------------------------------------------------------------------
        IF (P_TIPO_MSG = 1) THEN
          -- Funcionário interno
          V_ASSUNTO  := 'Aviso de baixa automática da Requisição nº '|| P_REQUISICAO_SQ;
          V_MENSAGEM := 'A Requisição de Pessoal Nº <b>'||P_REQUISICAO_SQ||'</b> foi baixada.<br><br><b>ID:</b> '||P_REG_FUNCIONARIOS.ID||'<br><b>Colaborador:</b> '|| P_REG_FUNCIONARIOS.NOME;
        ELSIF (P_TIPO_MSG = 2) THEN
             -- Funcionário externo (novo registro)
             V_ASSUNTO  := 'Aviso de baixa automática da Requisição nº '|| P_REQUISICAO_SQ;
             V_MENSAGEM := 'A Requisição de Pessoal Nº <b>'||P_REQUISICAO_SQ||'</b> foi baixada.<br><br><b>ID:</b> '||P_REG_FUNCIONARIOS.ID||'<br><b>Colaborador:</b> '|| P_REG_FUNCIONARIOS.NOME;
             V_MENSAGEM := V_MENSAGEM ||'<br><br>Favor dar continuidade no <b>processo de ativação no <i>RHEvolution</i></b>.';
           ELSIF (P_TIPO_MSG = 3) THEN
                -- Funcionário com duplo vínculo empregatício
                V_ASSUNTO  := 'Aviso de baixa manual da Requisição nº '|| P_REQUISICAO_SQ;
                V_MENSAGEM := 'O colaborador utilizado na Requisição de Pessoal Nº <b>'||P_REQUISICAO_SQ||'</b>, possui duplo vínculo empregatício.<br><br>Favor <b>realizar a baixa manualmente no sistema</b> utilizando o ID adequado.<br><br>';
                V_MENSAGEM := V_MENSAGEM ||'Dados do colaborador:<br><br>';
                V_MENSAGEM := V_MENSAGEM ||'<b>Nome:</b> '||P_REG_FUNCIONARIOS.NOME;
                FOR DV IN ( SELECT F.ID
                                  ,D.DESCRICAO AS CARGO
                            FROM   FUNCIONARIOS     F
                                  ,CARGO_DESCRICOES D
                            WHERE  F.ID_CARGO = D.ID
                            AND    F.CIC_NRO = P_REG_FUNCIONARIOS.CIC_NRO
                            AND    F.COMPLEMENTO_CIC_NRO = P_REG_FUNCIONARIOS.COMPLEMENTO_CIC_NRO
                            AND    F.TIPO_COLAB <> 'P'
                            AND    F.ATIVO = 'A') LOOP
                  V_MENSAGEM := V_MENSAGEM ||'<br><b>ID:</b> '||DV.ID||' - <b>Cargo:</b> '||DV.CARGO;
                END LOOP;
           END IF;
        ------------------------------------------------------------------------
        V_CORPO := '';
        V_CORPO := V_CORPO || '<head>';
        V_CORPO := V_CORPO ||   '<style>';
        V_CORPO := V_CORPO ||     '.tdCabecalho{font-family:verdana; color:#FFFFFF; font-size:10px; background-color:#6699CC; font-weight:normal;}';
        V_CORPO := V_CORPO ||     '.tdintranet2{font-family:verdana; color:#000000; font-size:10px; background-color:#E7F3FF;}';
        V_CORPO := V_CORPO ||     '.tdintranet{font-family:verdana; color:#000000; font-size:10px; background-color:#6699CC;}';
        V_CORPO := V_CORPO ||     '.tdNormal{font-family:verdana; color:#000000; font-size:10px; background-color:#FFFFFF;}';
        V_CORPO := V_CORPO ||     'td.texto {color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; background-color: #FFFFFF;}';
        V_CORPO := V_CORPO ||   '</style>';
        V_CORPO := V_CORPO || '</head>';
        V_CORPO := V_CORPO || '<body bgcolor="#ffffff" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0" marginwidth="0" marginheight="0">';
        V_CORPO := V_CORPO ||   '<center><br>';
        V_CORPO := V_CORPO ||   '<table border="0" width="610" cellpadding="0" cellspacing="0">';
        V_CORPO := V_CORPO ||     '<tr>';
        V_CORPO := V_CORPO ||       '<td colspan="2" height="18" class="tdCabecalho">';
        V_CORPO := V_CORPO ||         '<STRONG>&nbsp;&nbsp;REQUISIÇÃO DE PESSOAL</STRONG>';
        V_CORPO := V_CORPO ||       '</td>';
        V_CORPO := V_CORPO ||     '</tr>';
        V_CORPO := V_CORPO ||     '<tr>';
        V_CORPO := V_CORPO ||       '<td colspan="2" height="6" class="tdintranet2"></td>';
        V_CORPO := V_CORPO ||     '</tr>';
        V_CORPO := V_CORPO ||     '<tr>';
        V_CORPO := V_CORPO ||       '<td height="25" width="5%" align="left" class="tdintranet2"></td>';
        V_CORPO := V_CORPO ||       '<td height="25" width="95%" align="left" class="tdintranet2">';
        V_CORPO := V_CORPO ||            V_MENSAGEM;
        V_CORPO := V_CORPO ||       '</td>';
        V_CORPO := V_CORPO ||     '</tr>';
        V_CORPO := V_CORPO ||     '<tr>';
        V_CORPO := V_CORPO ||       '<td colspan="2" height="6" class="tdintranet2"></td>';
        V_CORPO := V_CORPO ||     '</tr>';
        V_CORPO := V_CORPO ||     '<tr>';
        V_CORPO := V_CORPO ||       '<td height="25" width="5%" align="left" class="tdintranet2"></td>';
        V_CORPO := V_CORPO ||       '<td height="25" width="95%" align="left" class="tdintranet2">';
        IF(V_INSTANCIA_ATUAL = V_INSTANCIA_PROD) THEN 
          V_CORPO := V_CORPO ||       '<br>Para maiores detalhes <a href="http://www3.intranet.sp.senac.br/login/leRP.cfm?sncReqPes='|| P_REQUISICAO_SQ ||'">clique aqui</a> para acessar o sistema e consultar os dados completos desta requisição.<br><br>';
        ELSE
          V_CORPO := V_CORPO ||       '<br>Para maiores detalhes <a href="http://www.intranet.sp.senac.br/intranet-frontend/sistemas-integrados/login?url=login/sistemaInfoGES.cfm&idsistema=7&sncReqPes='|| P_REQUISICAO_SQ ||'">clique aqui</a> para acessar o sistema e consultar os dados completos desta requisição.<br><br>';
        END IF;
        --V_CORPO := V_CORPO ||       '<br>Para maiores detalhes <a href="http://www.intranet.sp.senac.br/intranet-frontend/sistemas-integrados/login?url=login/leRP.cfm?sncReqPes='|| P_REQUISICAO_SQ ||'">clique aqui</a> para acessar o sistema e consultar os dados completos desta requisição.<br><br>';
        V_CORPO := V_CORPO ||       '</td>';
        V_CORPO := V_CORPO ||     '</tr>';
        V_CORPO := V_CORPO ||     '<tr>';
        V_CORPO := V_CORPO ||       '<td colspan="2" height="3" class="tdIntranet"></td>';
        V_CORPO := V_CORPO ||     '</tr>';
        V_CORPO := V_CORPO ||     '<tr>';
        V_CORPO := V_CORPO ||       '<td colspan="2" height="3" class="tdIntranet"></td>';
        V_CORPO := V_CORPO ||     '</tr>';
        V_CORPO := V_CORPO ||     '<tr>';
        V_CORPO := V_CORPO ||       '<td colspan="2" align="center" class="tdNormal">';
        V_CORPO := V_CORPO ||            '<br>Esta é uma mensagem automática, por favor não responda este e-mail.';
        V_CORPO := V_CORPO ||       '</td>';
        V_CORPO := V_CORPO ||     '</tr>';
        V_CORPO := V_CORPO ||   '</table>';
        V_CORPO := V_CORPO || '</center><br>';
        V_CORPO := V_CORPO || '</body> ';

      ------------------------------------------------------------------------------------------
      -- ENVIANDO OS E-MAILS
      ------------------------------------------------------------------------------------------
        
        BEGIN                                                  
          
          IF(V_INSTANCIA_ATUAL = V_INSTANCIA_PROD) THEN 
          
            RHEVSENAC.SENDMAILJPKG2.SENDMAILHTML(SMTPSERVERNAME => '10.2.0.36',
                                                 SENDER         => V_EMAIL_REMETENTE,
                                                 RECIPIENT      => V_CONTA,
                                                 CCRECIPIENT    => V_COPIA,
                                                 BCCRECIPIENT   => V_COPIA_OCULTA,
                                                 SUBJECT        => V_ASSUNTO,
                                                 BODY           => V_CORPO,
                                                 ERRORMESSAGE   => V_ERROR_MESSAGE); 
          ELSE
            
            RHEVSENAC.SENDMAILJPKG2.SENDMAILHTML(SMTPSERVERNAME => '10.2.0.36',
                                                 SENDER         => 'otavio.remedio@sp.senac.br',
                                                 RECIPIENT      => 'otavio.remedio@sp.senac.br',
                                                 CCRECIPIENT    => 'marcelo.cquevedo@sp.senac.br',
                                                 BCCRECIPIENT   => null,
                                                 SUBJECT        => V_ASSUNTO,
                                                 BODY           => V_CORPO,
                                                 ERRORMESSAGE   => V_ERROR_MESSAGE); 

          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, 'Problemas no envio de e-mail: ' ||V_ERROR_MESSAGE);
        END;
        
    END IF;  
END SP_NOTIFICA_BAIXA;
/
grant execute, debug on REQPES.SP_NOTIFICA_BAIXA to AN$RHEV;


