<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:useBean id="instrucao" class="br.senac.sp.reqpes.model.Instrucao" />
<jsp:setProperty name="instrucao" property="*" />

<%
  //-- Excluindo dados
   new InstrucaoControl().deletaInstrucao(instrucao, (Usuario) session.getAttribute("usuario"));  
%>

<script language="JavaScript">
  window.location = "index.jsp";  
</script>