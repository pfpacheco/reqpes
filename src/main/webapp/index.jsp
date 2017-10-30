<%  session.setAttribute("root","./"); %>
<%@ page errorPage="./error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<jsp:include page="template/cabecalho.jsp"/>

<%
  //-- Parametro recebido quando o usuário acessa o sistema através do e-mail de notificação enviado
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