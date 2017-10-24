<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
  //-- Objetos de controle
  InstrucaoControl instrucaoControl = new InstrucaoControl();
  
  //-- Parametros de página
  int     codTabelaSalarial   = (request.getParameter("P_COD_TABELA_SALARIAL")==null)?0:Integer.parseInt(request.getParameter("P_COD_TABELA_SALARIAL"));
  String  codCargoSelecionado = (request.getParameter("P_COD_CARGO")==null)?"":request.getParameter("P_COD_CARGO");
  String  codInstrucao        = (request.getParameter("P_COD_INSTRUCAO")==null)?"0":request.getParameter("P_COD_INSTRUCAO");
 
  //-- Resgatando objeto
  String[][] dadosCargo = instrucaoControl.getComboCargo(codTabelaSalarial);
%>

<%if(dadosCargo.length > 0){%>
    <select name="codCargo" class="select" style="width: 450px;">
      <option value="-1">SELECIONE</option>
      <option value="0">TODOS</option>
      <%for(int i=0; i<dadosCargo.length; i++){%>
        <option value="<%=dadosCargo[i][0]%>"><%=dadosCargo[i][1]%></option>
      <%}%>
    </select>
<%}else{
    //-- Enviando e-mail de crítica
    RequisicaoMensagemControl.enviaMensagemCritica("getComboCargo.jsp", "Na Tabela Salarial selecionada não existem cargos associados! <br>Tabela Salarial: " + codTabelaSalarial, (Usuario) session.getAttribute("usuario"));
  %>
  <font color="Red">Na Tabela Salarial selecionada não existem cargos associados!</font>
  <input type="hidden" name="codCargo" id="codCargo" value="-1">
<%}%>