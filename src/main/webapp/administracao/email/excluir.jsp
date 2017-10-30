<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.UsuarioAvisoEmailControl" %>
<%@ page import="br.senac.sp.reqpes.model.UsuarioAvisoEmail" %>

<jsp:useBean id="usuarioAvisoEmail" class="br.senac.sp.reqpes.model.UsuarioAvisoEmail" />
<jsp:setProperty name="usuarioAvisoEmail" property="*" />
<%
  //-- Excluindo o usuário 
  new UsuarioAvisoEmailControl().deletaUsuarioAvisoEmail(usuarioAvisoEmail, ((Usuario) session.getAttribute("usuario")) );
%>

<script language="JavaScript">
    window.location = "index.jsp";
</script>