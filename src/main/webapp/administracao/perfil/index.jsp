<% session.setAttribute("root","../../"); %>
<jsp:include page="../../template/cabecalho.jsp"/>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>

<%   
   //-- Objetos
   Usuario usuario = (Usuario)session.getAttribute("usuario");
%>

<iframe src="${sessionScope.admti_path}/include/administracao/perfil/index.jsp?codSistema=<%=Config.ID_SISTEMA%>&include=yes&chapa=<%=usuario.getChapa()%>" height="1020" width="100%" frameborder="0" marginwidth="5"></iframe>

<br>   
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>