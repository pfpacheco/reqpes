<%@ page isErrorPage="true"%>
<%@ page import="br.senac.sp.reqpes.Interface.Config" %>

<html>
  <head>    
    <meta http-equiv="expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
    <meta http-equiv="pragma" content="no-cache"/>
    <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE"/>
    <link href="<%=request.getContextPath()%>/css/stylesheet.css" rel="STYLESHEET" type="text/css"/>
    <title><%=Config.NOME_SISTEMA%></title>
  </head>
  
  <script language="javaScript">
    <% if(session.getAttribute("usuario") == null && exception != null ){ %>
        if('<%=exception%>' == 'java.lang.NullPointerException'){
          window.location = "<%=request.getContextPath()%>/template/sessaoExpirada.jsp";
        }
    <% } %>
  </script>
  
  <body> 
    <br>
    <center>
      <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td class="tdCabecalho" background="<%=request.getContextPath()%>/imagens/chapeu_topo.gif" height="10" width="610">&nbsp;</td>
        </tr>
        <tr>
          <td valign="middle" class="tdIntranet2" align="center" height="65">
            <b><FONT face="Verdana" size="2">&nbsp; </FONT></b>
            <BR/>
            <STRONG><FONT size="4"><%=Config.NOME_SISTEMA%></FONT></STRONG> 
          </td>
        </tr>
        <tr align="center" valign="top" height="24">
          <td bgcolor="#ffffff" class="tdintranet2">
            <b><font color="#000000" size="3">Atenção</font></b>
          </td>
        </tr>
        <tr>
          <td height="3" class="tdCabecalho" background='<%=request.getContextPath()%>/imagens/fio_azul_end.gif'>
          </td>
        </tr>          
        <tr>
          <td>
            <br>            
            <b><%=exception%></b>
            <br>&nbsp;
          </td>
        </tr>
        <tr>
          <td height="3" class="tdCabecalho" background='<%=request.getContextPath()%>/imagens/fio_azul_end.gif'>
          </td>
        </tr>        
      </table>
    </center>
  </body>
</html>