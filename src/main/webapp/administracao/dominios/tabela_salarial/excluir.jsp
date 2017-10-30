<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:useBean id="tabelaSalarial" class="br.senac.sp.reqpes.model.TabelaSalarial" />
<jsp:setProperty name="tabelaSalarial" property="*" />

<%
  //-- Excluindo dados
  new TabelaSalarialControl().deletaTabelaSalarial(tabelaSalarial, (Usuario) session.getAttribute("usuario"));
%>

<script language="JavaScript">
  window.location = "index.jsp";  
</script>