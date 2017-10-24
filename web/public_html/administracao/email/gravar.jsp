<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.UsuarioAvisoEmailControl" %>
<%@ page import="br.senac.sp.reqpes.model.UsuarioAvisoEmail" %>

<jsp:useBean id="usuarioAvisoEmail" class="br.senac.sp.reqpes.model.UsuarioAvisoEmail" />
<jsp:setProperty name="usuarioAvisoEmail" property="*" />

<%   
  //-- Objetos de controle
  UsuarioAvisoEmailControl usuarioAvisoEmailControl = new UsuarioAvisoEmailControl();
  
  //-- Pegando o usu�rio da sess�o
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Parametros de p�gina
  String[] codTipoAviso = request.getParameterValues("codTipoAviso");
    
  //-- Grava as atribui��es  
  usuarioAvisoEmailControl.deletaUsuarioAvisoEmail(usuarioAvisoEmail, usuario);
  for(int i=0; i<codTipoAviso.length; i++){
    //-- setando valores
    usuarioAvisoEmail.setCodTipoAviso(Integer.parseInt(codTipoAviso[i]));
    usuarioAvisoEmailControl.gravaUsuarioAvisoEmail(usuarioAvisoEmail, usuario);
  }
%>

<script language="JavaScript">
  window.location = "index.jsp";  
</script>