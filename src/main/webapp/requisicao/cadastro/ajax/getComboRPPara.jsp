<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
  //-- Objetos de controle
  RequisicaoControl requisicaoControl = new RequisicaoControl();
  
  //-- Parametros de página
  int tipoRecrutamento = (request.getParameter("P_TIPO_RECRU")==null)?0:Integer.parseInt(request.getParameter("P_TIPO_RECRU"));
  String codRPPara     = (request.getParameter("P_COD_RP_PARA")==null)?"":request.getParameter("P_COD_RP_PARA");
  
  //-- Resgatando objeto
  String[][] comboRPPara = requisicaoControl.getComboRPPara(tipoRecrutamento);
%>

<%if(comboRPPara.length > 0){%>
    <select name="codRPPara" class="select" style="width: 386px;" onchange="exibeFuncionarioSubstituido(this.value, 'RP_PARA'); carregaComboMotivoSolicitacao('divExibeMotivS2', '<%=tipoRecrutamento%>', '0', this.value);">
      <option value="0">SELECIONE</option>
      <%for(int i=0; i< comboRPPara.length; i++){%>
        <option value="<%=comboRPPara[i][0]%>" <%=(comboRPPara[i][0].equals(codRPPara))?" SELECTED":""%> ><%=comboRPPara[i][1]%></option>
      <%}%>                
    </select>
<%}else{%>
    <select name="codRPPara" class="select" style="width: 386px;" onchange="exibeFuncionarioSubstituido(this.value, 'RP_PARA');">
      <option value="0">SELECIONE</option>
    </select>
<%}%>