<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:useBean id="grupoNec" class="br.senac.sp.reqpes.model.GrupoNec" />
<jsp:setProperty name="grupoNec" property="*" />

<%
  //-- Excluindo dados
  new GrupoNecControl().deletaGrupoNec(grupoNec, (Usuario) session.getAttribute("usuario"));
%>

<script language="JavaScript">
  window.location = "index.jsp";  
</script>