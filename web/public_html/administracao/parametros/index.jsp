<% session.setAttribute("root","../../"); %>
<jsp:include page="../../template/cabecalho.jsp"/>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>

<%
   //-- Objetos
   Usuario usuario = (Usuario)session.getAttribute("usuario");
%>

<%--
  PRODUÇÃO
  <iframe src="http://www4.intranet.sp.senac.br/infoGES/include/administracao/parametros/index.jsp?codSistema=<%=Config.ID_SISTEMA%>&include=yes&chapa=<%=usuario.getChapa()%>" height="800" width="100%" frameborder="0" marginwidth="5"></iframe>

  DESENVOLVIMENTO
  <iframe src="http://ges-jav02:8080/admTI/include/administracao/parametros/index.jsp?codSistema=<%=Config.ID_SISTEMA%>&include=yes&chapa=<%=usuario.getChapa()%>" height="800" width="100%" frameborder="0" marginwidth="5"></iframe>
--%>

<iframe src="http://www4.intranet.sp.senac.br/infoGES/include/administracao/parametros/index.jsp?codSistema=<%=Config.ID_SISTEMA%>&include=yes&chapa=<%=usuario.getChapa()%>" height="800" width="100%" frameborder="0" marginwidth="5"></iframe>

<br>   
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>