<%@ page import="br.senac.sp.reqpes.Control.CentroCustoControl" %>
<% 
	try{		
		out.print(new CentroCustoControl().getIdCodeCombination(request.getParameter("centroCusto")));
	}catch (Exception e){
		out.print("ERRO");
	}
%>