<%@ include file="templateIntranet.jsp"   %>
<%@ page import="br.senac.sp.componente.util.Data" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>

<%
  Data data = new Data();
%>
 
<html>
<head> 
  <meta http-equiv=expires content="Mon, 06 Jan 1990 00:00:01 GMT">
  <meta http-equiv="pragma" content="no-cache">
  <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
  <link href="<%= request.getContextPath()%>/css/stylesheet.css" rel="STYLESHEET" type="text/css"/>
  <title><%=Config.NOME_SISTEMA%></title>
</head>
<body>
<br>
  <center>
    <table width="610" border="0" align="center" cellpadding="0" cellspacing="0" >
       <tr>
         <td class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/chapeu_topo.gif' height="10" width="610">
           &nbsp;
         </td>
      </tr>
      <tr>
        <td valign="middle" class="tdIntranet2" align="center"  height="65">
          <b><FONT face="Verdana" size="2">&nbsp;</FONT></b><BR>
          <STRONG><FONT size="4"><%=Config.NOME_SISTEMA%></FONT></STRONG>
          <br>Sessão expirada!<br>
          <%= "São Paulo, " + data.getDia() + " de " + data.getDescricaoMes() + " de " + data.getAno() %>        
        </td>
      </tr>
        <tr>
          <td colspan="1"  height="3" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' >           
          </td>
        </tr>        
    </table>
    <br>
    <table width="610">
      <tr>
        <td>
        <P>&nbsp;<b>Atenção:</b>
          <%
            if(request.getParameter("manutencao") != null){
              out.print("Sistema em manutenção!</p>");
            }else if(request.getParameter("semAcesso") != null){
                     out.print("Você não está habilitado a acessar este sistema!</p>");
                  }else{
                     out.print("Seu tempo de conexão expirou, favor realizar sua atenticação novamente!</p>");
                  }
          %>
        </td>
      </tr>
    </table>
  </center>
</body>    
</html>
<jsp:include page="fimTemplateIntranet.jsp"/>