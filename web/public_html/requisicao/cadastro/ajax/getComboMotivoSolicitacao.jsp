<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
  //-- Objetos de controle
  RequisicaoControl requisicaoControl = new RequisicaoControl();
  
  //-- Parametros de página
  int    tipoRecrutamento     = (request.getParameter("P_TIPO_RECRU")==null)?0:Integer.parseInt(request.getParameter("P_TIPO_RECRU"));
  int    codRPPara            = (request.getParameter("P_RPPARA")==null)?0:Integer.parseInt(request.getParameter("P_RPPARA"));
  String codMotivoSolicitacao = (request.getParameter("P_COD_MOTIVO_SOLICITACAO")==null)?"":request.getParameter("P_COD_MOTIVO_SOLICITACAO");
  
  //-- Resgatando objeto
  String[][] comboMotivoSolicitacao = requisicaoControl.getComboMotivoSolicitacao(codRPPara);
%>

<%if(comboMotivoSolicitacao.length > 0){%>
    <select name="codMotivoSolicitacao" class="select" style="width: 386px;" <%=(tipoRecrutamento==1)?"onchange=\"exibeFuncionarioSubstituido(this.value, 'MOTIVO_SOLICITACAO');\"":""%>>
      <option value="0">SELECIONE</option>
      <%for(int i=0; i< comboMotivoSolicitacao.length; i++){%>
        <option value="<%=comboMotivoSolicitacao[i][0]%>" <%=(comboMotivoSolicitacao[i][0].equals(codMotivoSolicitacao))?" SELECTED":""%> ><%=comboMotivoSolicitacao[i][1]%></option>
      <%}%>               
    </select>
<%}else{%>
    <select name="codMotivoSolicitacao" class="select" style="width: 386px;">
      <option value="0">SELECIONE</option>
    </select>              
<%}%>