<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.TipoAvisoControl" %>
<%@ page import="br.senac.sp.reqpes.model.TipoAviso" %>

<jsp:useBean id="tipoAviso" class="br.senac.sp.reqpes.model.TipoAviso" />
<jsp:setProperty name="tipoAviso" property="*" />

<%  
  new TipoAvisoControl().deletaTipoAviso(tipoAviso, (Usuario) session.getAttribute("usuario"));
%>

<script language="JavaScript">
  window.location = "index.jsp";
</script>