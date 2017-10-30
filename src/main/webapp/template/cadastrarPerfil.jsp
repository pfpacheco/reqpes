<%@ include file="templateIntranet.jsp"   %>
<%@ page import="br.senac.sp.componente.model.*" %>
<%@ page import="br.senac.sp.componente.util.*" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%
      Usuario usuario = (Usuario) session.getAttribute("usuario");
 
      StringBuffer msg = new StringBuffer();
      String[] para = {Config.EMAIL_ERRO};
      Email email = new Email();
         email.setSTMPServer(Config.SMTP);
         email.setAssunto(Config.NOME_SISTEMA+" - Usuário sem acesso");
         email.setRemetente(Config.EMAIL_ERRO);
         msg.append("Nome .: " + usuario.getNome());
         msg.append("\nChapa.: " + usuario.getChapa());
         email.setCorpoEmail(msg.toString());
         email.setParaVarios(para);   
      try{
       email.enviarEmailRemetentesSimples();
      }catch(Exception e){
        System.out.println(e.getMessage());
      }
 
    
  Data data = new Data(); 
%>
<html>
  <head> 
    <meta http-equiv=expires content="Mon, 06 Jan 1990 00:00:01 GMT">
    <meta http-equiv="pragma" content="no-cache">
    <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
    <link href="../css/stylesheet.css" rel="STYLESHEET" type="text/css"/>
    <title><%=Config.NOME_SISTEMA%></title>
    <script language="javaScript">
      window.name="decontosCorporativos";
    </script>
  </head>
  <body>
    <center>
<table width="610" border="0" align="center" cellpadding="0" cellspacing="0" >
       <tr>
         <td class="tdCabecalho" background='../imagens/chapeu_topo.gif' height="10" width="610">
           &nbsp;
         </td>
      </tr>
      <tr>
        <td valign="middle" class="tdIntranet2" align="center"  height="65">
          <b><FONT face="Verdana" size="2"> &nbsp; </FONT></b>
          <BR/>
          <STRONG><FONT size="4"><%=Config.NOME_SISTEMA%></FONT></STRONG>
          <br>
          Perfil!
          <br>
          <%= "São Paulo," + data.getDia() + " de " + data.getDescricaoMes() + " de " + data.getAno() %>        
        </td>
      </tr>
        <tr>
          <td colspan="1"  height="3" class="tdCabecalho" background='../imagens/fio_azul_end.gif' >
           
          </td>
        </tr>        
    </table>
    <br>
    <table width="610">
      <tr>
        <td>
          <P>&nbsp;<b>Atenção:</b>&nbsp;Seu usuário não possui perfil de acesso cadastrado</p>
          <P>&nbsp;Entre em contato com o administrador do sistema!
          </p>
        </td>
      </tr>
      <tr>
        <td>
           <img src="../imagens/marcadagua.jpg" width="610" height="408">
        </td>
      </tr> 
    </table>
    </center>
 </body>    
  </html>
<jsp:include page="fimTemplateIntranet.jsp"/>