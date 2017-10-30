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
          <br>Sess�o expirada!<br>
          <%= "S�o Paulo, " + data.getDia() + " de " + data.getDescricaoMes() + " de " + data.getAno() %>        
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
        <P>&nbsp;<b>Aten��o:</b>
          <%
            if(request.getParameter("manutencao") != null){
              out.print("Sistema em manuten��o!</p>");
            }else if(request.getParameter("semAcesso") != null){
                     out.print("Voc� n�o est� habilitado a acessar este sistema!</p>");
                  }else{
                     out.print("Seu tempo de conex�o expirou, favor realizar sua atentica��o novamente!</p>");
                  }
          %>
        </td>
      </tr>
    </table>
  </center>
</body>    
</html>
<jsp:include page="fimTemplateIntranet.jsp"/>