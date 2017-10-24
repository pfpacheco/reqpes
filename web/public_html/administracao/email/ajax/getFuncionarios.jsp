<%@ page import="br.senac.sp.reqpes.Control.UsuarioAvisoEmailControl" %>
<%@ page errorPage="../../../error/error.jsp" %>

<% 
  //-- Parametros de página
  String codUnidade = (request.getParameter("P_COD_UNIDADE")==null)?"":request.getParameter("P_COD_UNIDADE");
  
  //-- Resgatando objeto
  String[][] funcionarios = new UsuarioAvisoEmailControl().getComboUsuarios(codUnidade);
%>

<%if(funcionarios.length > 0){%>
    <select name="chapa" id="chapa" class="select" style="width: 400px;">
      <option value="0">SELECIONE</option>
      <%for(int i=0; i<funcionarios.length; i++){%>
        <option value="<%=funcionarios[i][0]%>"><%=funcionarios[i][1]%></option>
      <%}%>
    </select>
<%}else{%>
  <font color="Red">Na unidade selecionada não existem colaboradores associados!</font>
  <input type="hidden" name="chapa" id="chapa" value="0">
<%}%>