CREATE OR REPLACE PROCEDURE REQPES.SP_NOTIFICA_EXPIRACAO AS

  V_UO_CERTA   VARCHAR2(15);
  V_ID_GERENTE NUMBER;
  V_TENTATIVA  NUMBER := 1;
  V_TEOR       VARCHAR2(2);
  -----------------------------------
  V_COPIA         VARCHAR2(1000);
  V_CONTA         VARCHAR2(1000);
  V_COPIA_OCULTA  VARCHAR2(100) := 'GrupoGES-SistemasTecnologia@sp.senac.br';
  V_ASSUNTO       VARCHAR2(1000);
  V_CORPO         CLOB;
  V_DAT_APROVACAO VARCHAR2(15);
  V_DAT_EXPIRACAO VARCHAR2(15);
  V_DSC_STATUS    VARCHAR2(100);
  V_MENSAGEM      VARCHAR2(1000);
  V_ERROR_MESSAGE VARCHAR2(4000);
  -----------------------------------
  V_PRAZO           NUMBER;
  V_AVISO           NUMBER;
  V_EMAIL_REMETENTE VARCHAR2(100);

BEGIN
-------------------------------------------------------------------------------------
-- PROCEDURE RESPONSAVEL POR NOTIFICAR AS REQUISIÇÕES QUE IRÃO EXPIRAR APOS APROVAÇÃO
-- Processo executado todos os dias as 05:00hs AM, atraves do job 885
-- Author: Thiago Lima Coutinho
-- Date  : 3/7/2009
-------------------------------------------------------------------------------------

 -----------------------------------------------------------
 -- CARREGANDO PARAMETROS DO SISTEMA
 -----------------------------------------------------------
  SELECT S.VLR_SISTEMA_PARAMETRO
  INTO   V_PRAZO
  FROM   SYN_SISTEMA_PARAMETRO S
  WHERE  S.COD_SISTEMA     = 7
  AND    S.NOM_PARAMETRO   = 'CONTRATACAO_VALIDADE';
  ----------------------------------------------------------
  SELECT S.VLR_SISTEMA_PARAMETRO
  INTO   V_AVISO
  FROM   SYN_SISTEMA_PARAMETRO S
  WHERE  S.COD_SISTEMA     = 7
  AND    S.NOM_PARAMETRO   = 'EXPIRACAO_AVISO';
  ----------------------------------------------------------
  SELECT S.VLR_SISTEMA_PARAMETRO
  INTO   V_EMAIL_REMETENTE
  FROM   SYN_SISTEMA_PARAMETRO S
  WHERE  S.COD_SISTEMA     = 7
  AND    S.NOM_PARAMETRO   = 'EMAIL_REMETENTE';
  ----------------------------------------------------------
  SELECT S.VLR_SISTEMA_PARAMETRO
  INTO   V_TEOR
  FROM   SYN_SISTEMA_PARAMETRO S
  WHERE  S.COD_SISTEMA     = 7
  AND    S.NOM_PARAMETRO   = 'TEOR_COD_WORKFLOW';

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
         V_COPIA := V_COPIA || EMAIL_GEP.E_MAIL || ',';

  END LOOP;

 -----------------------------------------------------------
 -- REALIZANDO O PROCESSO DE ENVIO DE E-MAILS PARA OS GERENTES E HOMOLOGADORES
 -----------------------------------------------------------
  FOR EX IN ( -- CURSOR DE REQUISIÇÕES EM EXPIRAÇÃO
              SELECT UNIQUE R.REQUISICAO_SQ
                    ,R.COD_UNIDADE
                    ,TO_CHAR(R.DT_REQUISICAO, 'dd/mm/yyyy') AS DAT_CRIACAO
                    ,R.COD_STATUS
                    ,RS.DSC_STATUS
              FROM   REQUISICAO           R
                    ,HISTORICO_REQUISICAO HR
                    ,REQUISICAO_STATUS    RS
              WHERE  HR.REQUISICAO_SQ     = R.REQUISICAO_SQ
              AND    RS.COD_STATUS        = R.COD_STATUS
              AND    R.COD_STATUS         IN (1, 2, 3, 4) -- STATUS: ABERTA, HOMOLOGAÇÃO, REVISÃO, APROVADA
              AND    SYSDATE              > (SELECT MAX(E.DT_ENVIO)
                                             FROM   HISTORICO_REQUISICAO E
                                             WHERE  E.REQUISICAO_SQ = HR.REQUISICAO_SQ) + V_PRAZO - V_AVISO
            ) LOOP

       -----------------------------------------------------
       -- CARREGANDO OS ID'S DOS GERENTES RESPONSAVEIS PELAS UNIDADES
       -----------------------------------------------------
         SP_GET_UNIDADE_DESTINO(EX.COD_UNIDADE, V_UO_CERTA, V_ID_GERENTE, V_TENTATIVA,V_TEOR);

       -----------------------------------------------------
       -- CARREGANDO O E-MAIL DO GERENTE RESPONSAVEL PELA RP
       -----------------------------------------------------
         SELECT FC.E_MAIL
         INTO   V_CONTA
         FROM   FUNCIONARIO_COMPLEMENTO FC
         WHERE  FC.ID_FUNCIONARIO = V_ID_GERENTE;

       -----------------------------------------------------
       -- CARREGANDO DATAS: ULTIMO NIVEL NO WORKFLOW E EXPIRAÇÃO
       -----------------------------------------------------
         SELECT TO_CHAR(HR.DT_ENVIO, 'dd/mm/yyyy')          AS DAT_APROVACAO
               ,TO_CHAR(HR.DT_ENVIO + V_PRAZO,'dd/mm/yyyy') AS DAT_EXPIRACAO
         INTO   V_DAT_APROVACAO
               ,V_DAT_EXPIRACAO
         FROM   HISTORICO_REQUISICAO HR
         WHERE  HR.REQUISICAO_SQ = EX.REQUISICAO_SQ
         AND    HR.DT_ENVIO = (SELECT MAX(E.DT_ENVIO)
                               FROM   HISTORICO_REQUISICAO E
                               WHERE  E.REQUISICAO_SQ = HR.REQUISICAO_SQ);

       ------------------------------------------------------
       -- MONTANDO O STATUS ATUAL DA REQUISIÇÃO
       ------------------------------------------------------
         IF (EX.COD_STATUS = 1) THEN
            V_DSC_STATUS := 'criada';
         ELSIF (EX.COD_STATUS = 2) THEN
               V_DSC_STATUS := 'homologada';
            ELSIF (EX.COD_STATUS = 3) THEN
                  V_DSC_STATUS := 'com revisão solicitada';
               ELSE
                  V_DSC_STATUS := LOWER(EX.DSC_STATUS);
         END IF;

       -----------------------------------------------------
       -- MONTANDO O CORPO DO E-MAIL
       -----------------------------------------------------
         V_ASSUNTO  := 'Aviso de expiração da Requisição nº '||EX.REQUISICAO_SQ;
         ------------------------------------------------------------------------
         V_MENSAGEM := 'A Requisição de Pessoal nº <b>'||EX.REQUISICAO_SQ||'</b>, '||V_DSC_STATUS||' no dia '||V_DAT_APROVACAO||' expirara caso não seja utilizada (baixada) até '||V_DAT_EXPIRACAO||'.';

         IF (EX.COD_STATUS <> 4) THEN
            V_MENSAGEM := V_MENSAGEM || '<br><br>Para utilização da RP, é necessário que ela seja aprovada.';
         END IF;
         ------------------------------------------------------------------------
         V_CORPO := '';
         V_CORPO := V_CORPO || '<head>';
         V_CORPO := V_CORPO || '    <title>Solicitacão</title>';
         V_CORPO := V_CORPO || '    <meta http-equiv=expires content=\"Mon, 06 Jan 1990 00:00:01 GMT\">';
         V_CORPO := V_CORPO || '    <meta http-equiv=\"pragma\" content=\"no-cache\">';
         V_CORPO := V_CORPO || '    <META HTTP-EQUIV=\"CACHE-CONTROL\" CONTENT=\"NO-CACHE\">';
         V_CORPO := V_CORPO || '  <style>';
         V_CORPO := V_CORPO || '     .tdCabecalho{font-family:verdana; color:#FFFFFF; font-size:10px; background-color:#6699CC; font-weight:normal; }';
         V_CORPO := V_CORPO || '     .tdintranet2{font-family:verdana; color:#000000; font-size:10px; background-color:#E7F3FF; }';
         V_CORPO := V_CORPO || '     .tdintranet {font-family:verdana; color:#000000; font-size:10px; background-color:#6699CC; }';
         V_CORPO := V_CORPO || '     .tdNormal   {font-family:verdana; color:#000000; font-size:10px; background-color:#FFFFFF; }';
         V_CORPO := V_CORPO || '      td.texto {';
         V_CORPO := V_CORPO || '        color: #000000;';
         V_CORPO := V_CORPO || '        font-family: Verdana, Arial, Helvetica, sans-serif;';
         V_CORPO := V_CORPO || '        font-size: 10px;';
         V_CORPO := V_CORPO || '        background-color: #FFFFFF;';
         V_CORPO := V_CORPO || '      }';
         V_CORPO := V_CORPO || '  </style>';
         V_CORPO := V_CORPO || '  </head>';
         V_CORPO := V_CORPO || '  <body bgcolor="#ffffff" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0" marginwidth="0" marginheight="0" >';
         V_CORPO := V_CORPO || '  <center><br>';
         V_CORPO := V_CORPO || '     <table border="0" width="610" cellpadding="0" cellspacing="0">';
         V_CORPO := V_CORPO || '           <tr>';
         V_CORPO := V_CORPO || '             <td colspan="2" height="18" class="tdCabecalho">';
         V_CORPO := V_CORPO || '              <STRONG>&nbsp;&nbsp;REQUISIÇÃO DE PESSOAL</STRONG>';
         V_CORPO := V_CORPO || '             </td>';
         V_CORPO := V_CORPO || '           </tr>';
         V_CORPO := V_CORPO || '           <tr>';
         V_CORPO := V_CORPO || '              <td colspan="2"  height="6" class="tdintranet2"></td>';
         V_CORPO := V_CORPO || '           </tr>';
         V_CORPO := V_CORPO || '           <tr>';
         V_CORPO := V_CORPO || '              <td height="25" width="5%" align="left" class="tdintranet2"></td>';
         V_CORPO := V_CORPO || '              <td height="25" width="95%" align="left" class="tdintranet2">';
         V_CORPO := V_CORPO ||                V_MENSAGEM;
         V_CORPO := V_CORPO || '              </td>';
         V_CORPO := V_CORPO || '           </tr>';
         V_CORPO := V_CORPO || '           <tr>';
         V_CORPO := V_CORPO || '               <td colspan="2"  height="6" class="tdintranet2"></td>';
         V_CORPO := V_CORPO || '           </tr>';
         V_CORPO := V_CORPO || '           <tr>';
         V_CORPO := V_CORPO || '              <td height="25" width="5%" align="left" class="tdintranet2"></td>';
         V_CORPO := V_CORPO || '              <td height="25" width="95%" align="left" class="tdintranet2">';
         V_CORPO := V_CORPO || '        Para mais detalhes <a href="http://www.intranet.sp.senac.br/intranet-frontend/sistemas-integrados/detalhes/7">clique aqui</a> para acessar o sistema e consultar os dados completos desta requisição, digitando o número da RP no campo correspondente e clicando em `Pesquisar¿.<br><br>';
         V_CORPO := V_CORPO || '              </td>';
         V_CORPO := V_CORPO || '           </tr>';
         V_CORPO := V_CORPO || '           <tr>';
         V_CORPO := V_CORPO || '              <td colspan="2"  height="3" class="tdIntranet"></td>';
         V_CORPO := V_CORPO || '           </tr>';
         V_CORPO := V_CORPO || '           <tr>';
         V_CORPO := V_CORPO || '              <td colspan="2"  height="3" class="tdIntranet"></td>';
         V_CORPO := V_CORPO || '           </tr>   ';
         V_CORPO := V_CORPO || '           <tr>';
         V_CORPO := V_CORPO || '              <td colspan="2" align="center" class="tdNormal">';
         V_CORPO := V_CORPO || '                  <br>Esta é uma mensagem automática, por favor não responda este e-mail. ';
         V_CORPO := V_CORPO || '              </td>';
         V_CORPO := V_CORPO || '           </tr>';
         V_CORPO := V_CORPO || '     </table>';
         V_CORPO := V_CORPO || ' </center><br>';
         V_CORPO := V_CORPO || '</body> ';

       ------------------------------------------------------------------------------------------
       -- ENVIANDO OS E-MAILS
       ------------------------------------------------------------------------------------------
        BEGIN
          RHEVSENAC.SENDMAILJPKG2.SENDMAILHTML(SMTPSERVERNAME => '10.2.0.217',
                                               SENDER         => V_EMAIL_REMETENTE,
                                               RECIPIENT      => V_CONTA,
                                               CCRECIPIENT    => V_COPIA,
                                               BCCRECIPIENT   => V_COPIA_OCULTA,
                                               SUBJECT        => V_ASSUNTO,
                                               BODY           => V_CORPO,
                                               ERRORMESSAGE   => V_ERROR_MESSAGE);
        EXCEPTION
          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, 'Problemas no envio de email. Mensagem de erro SMTP: ' ||V_ERROR_MESSAGE);
        END;

  END LOOP;
 -----------------------------------------------------------
END SP_NOTIFICA_EXPIRACAO;
/
grant execute, debug on REQPES.SP_NOTIFICA_EXPIRACAO to AN$RHEV;


