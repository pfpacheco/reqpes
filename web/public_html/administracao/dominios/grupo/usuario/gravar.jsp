<%  session.setAttribute("root","../../../../"); %>
<%@ page errorPage="../../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:useBean id="grupoNecUsuario" class="br.senac.sp.reqpes.model.GrupoNecUsuario" />
<jsp:setProperty name="grupoNecUsuario" property="*" />

<%   
  //-- Objetos control
  GrupoNecUsuarioControl grupoNecUsuarioControl = new GrupoNecUsuarioControl();
  
  //-- Pegando o usuário da sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Parametros de página
  String[] grupo = request.getParameterValues("codGrupo");
  int retorno = 0;
  
  //-- Grava as atribuições
  for(int i=0; i<grupo.length; i++){
    //-- setando valores
    grupoNecUsuario.setCodGrupo(Integer.parseInt(grupo[i]));
    retorno = grupoNecUsuarioControl.gravaGrupoNecUsuario(grupoNecUsuario, usuario);
  }
%>

<script language="JavaScript">
  window.location = "index.jsp";  
</script>