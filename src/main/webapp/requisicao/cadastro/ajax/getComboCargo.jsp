<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>

<% 
  //-- Parametros de página
  String codUnidade          = (request.getParameter("P_COD_UNIDADE")==null)?"":request.getParameter("P_COD_UNIDADE");
  String codCargoSelecionado = (request.getParameter("P_COD_CARGO")==null)?"":request.getParameter("P_COD_CARGO");
 
  //-- Resgatando objeto
  String[][] dadosCargo = new RequisicaoControl().getComboCargo(codUnidade);
%>

<%if(dadosCargo.length > 0){%>
    <select name="codCargo" id="codCargo" onchange="getJornadaTrabalho(this.value);" class="select" style="width: 386px;">
      <option value="0">SELECIONE</option>
      <%for(int i=0; i<dadosCargo.length; i++){%>
        <option value="<%=dadosCargo[i][0]%>" <%=(dadosCargo[i][0].equals(codCargoSelecionado))?" SELECTED":""%>><%=dadosCargo[i][2]%></option>
      <%}%>
    </select>
<%}else{
    //-- Enviando e-mail de crítica
    RequisicaoMensagemControl.enviaMensagemCritica("getComboCargo.jsp", "Na unidade selecionada não existem cargos associados! <br><b>Unidade:</b> " + codUnidade, (Usuario) session.getAttribute("usuario"));
  %>
  <font color="Red">Na unidade selecionada não existem cargos associados!</font>
  <input type="hidden" name="codCargo" id="codCargo" value="0">
<%}%>