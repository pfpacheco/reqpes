<%  session.setAttribute("root","../../../../"); %>
<%@ page errorPage="../../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:useBean id="grupoNecUsuario" class="br.senac.sp.reqpes.model.GrupoNecUsuario" />
<jsp:setProperty name="grupoNecUsuario" property="*" />

<%   
  //-- Remove o acesso
  new GrupoNecUsuarioControl().deletaGrupoNecUsuario(grupoNecUsuario, (Usuario) session.getAttribute("usuario"));
%>

<script language="JavaScript">
  window.location = "index.jsp";  
</script>