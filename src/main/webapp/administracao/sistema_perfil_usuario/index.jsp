<% session.setAttribute("root","../../"); %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<jsp:include page="../../template/cabecalho.jsp"/>

<%
   //-- Objetos
   Usuario usuario = (Usuario)session.getAttribute("usuario");
%>

<iframe src="${sessionScope.admti_path}/include/administracao/sistema_perfil_usuario/index.jsp?codSistema=<%=Config.ID_SISTEMA%>&include=yes&chapa=<%=usuario.getChapa()%>&indTerceiro=S&codPerfil=<%=usuario.getSistemaPerfil().getCodSistemaPerfil()%>" height="800" width="100%" frameborder="0" marginwidth="5"></iframe>

<br>   
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>
