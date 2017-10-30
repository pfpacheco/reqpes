<%@ page import="br.senac.sp.componente.util.Data" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<% Data data = new Data(); %>

  <head>
    <meta http-equiv=expires content="Mon, 06 Jan 1990 00:00:01 GMT">
    <meta http-equiv="pragma" content="no-cache">
    <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
    <link href="<%=request.getContextPath()%>/css/stylesheet.css" rel="STYLESHEET" type="text/css"/>
    <title><%=Config.NOME_SISTEMA%></title>
  </head>

    <table width="610" border="0" align="center" cellpadding="0" cellspacing="0" >
      <tr>
        <td valign="middle"  align="left" width="15%">
          <img src="<%=request.getContextPath()%>/imagens/logo.jpg">
        </td>
        <td valign="middle"  align="center" width="70%">
          <font size="2"><b>SERVIÇO NACIONAL DE APRENDIZAGEM COMERCIAL</b></font>
          <br><br>
          <font size="2"><b><%=(request.getParameter("titulo")!=null?request.getParameter("titulo"):"")%></b></font>
          <br><br>
          <%= "São Paulo, " + data.getDia() + " de " + data.getDescricaoMes() + " de " + data.getAno() %>        
        </td>
        <td valign="middle"  align="left" width="15%">
          &nbsp;
        </td>
      </tr>
    </table>
    <br>