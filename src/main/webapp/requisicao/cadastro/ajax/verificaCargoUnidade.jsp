<%@ page import="br.senac.sp.reqpes.Control.RequisicaoControl" %>
<%    
    //-- Parametros de p�gina
    String codUnidade = request.getParameter("P_COD_UNIDADE");    
    //-- Verifica se a unidade informada est� na lista de exce��es de cargos administrativos exercidos por coordenadores    
    String[] retorno = new RequisicaoControl().getLista("SELECT reqpes.F_IS_CARGO_ADM_COORD('"+ codUnidade +"') FROM DUAL");
    out.print(retorno[0]);
%>