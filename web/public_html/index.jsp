<%  session.setAttribute("root","./"); %>
<%@ page errorPage="./error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<jsp:include page="template/cabecalho.jsp"/>

<%
  //-- Parametro recebido quando o usu�rio acessa o sistema atrav�s do e-mail de notifica��o enviado
  int sncReqPes = (request.getParameter("sncReqPes")==null)?0:Integer.parseInt(request.getParameter("sncReqPes"));
%>

<form action="relatorio/index.jsp" name="frmHistorico" method="POST">
  <input type="HIDDEN" name="codRequisicao" value="<%=sncReqPes%>">
  <input type="HIDDEN" name="isEmail" value="true">
</form>

<script language="javaScript">
  if('<%=sncReqPes%>' != '0'){
    document.frmHistorico.submit();
  }else{
    window.location = "requisicao/aprovar/index.jsp";
  }
</script>
 
<br>    
<jsp:include page="./template/fimTemplateIntranet.jsp"/>