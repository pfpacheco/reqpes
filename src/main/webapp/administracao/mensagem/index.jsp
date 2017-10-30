<% session.setAttribute("root","../../"); %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<jsp:include page="../../template/cabecalho.jsp"/>

<%
   //-- Objetos
   Usuario usuario = (Usuario)session.getAttribute("usuario");
%>

<iframe src="${sessionScope.admti_path}/include/administracao/mensagem/index.jsp?codSistema=<%=Config.ID_SISTEMA%>&include=yes&chapa=<%=usuario.getChapa()%>" height="800" width="100%" frameborder="0" marginwidth="5"></iframe>

<br>   
<jsp:include page="../../template/fimTemplateIntranet.jsp"/> 