<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
  // Verificando se o ID j� est� sendo utilizado em outras RP's
  out.print(new RequisicaoControl().verificaSubstituido(Integer.parseInt(request.getParameter("P_CHAPA"))));
%>