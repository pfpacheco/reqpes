<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
  //-- Objetos de controle
  RequisicaoControl requisicaoControl = new RequisicaoControl();
  
  //-- Parametros de p�gina
  String inicioContratacao = (request.getParameter("P_INICIO_CONTRATACAO")==null)?"":request.getParameter("P_INICIO_CONTRATACAO");
  int    prazoContratacao  = (request.getParameter("P_PRAZO_CONTRATACAO")==null)?0:Integer.parseInt(request.getParameter("P_PRAZO_CONTRATACAO"));
  
  //-- Resgatando objeto
  String prazo = requisicaoControl.getDataFimContratacao(inicioContratacao, prazoContratacao);    
%>

<%if(prazo != null){%>
  <strong title="Fim contrata��o">&nbsp;&nbsp;&nbsp;Fim:</strong>
  <%--&nbsp;<input class="input" size="12" maxlength="10" readonly name="datFimContratacao" value="<%=prazo%>" /> (dd/mm/aaaa)--%>
  &nbsp;<input class="input" size="7" maxlength="7" readonly name="datFimContratacao" value="<%=prazo.substring(3,10)%>" />
<%}else{
    //-- Enviando e-mail de cr�tica
    RequisicaoMensagemControl.enviaMensagemCritica("getDataFimContratacao.jsp", "Erro ao gerar o prazo final de contrata��o!! <br><b>In�cio contrata��o:</b> "+ inicioContratacao +"<br><b>Prazo contrata��o:</b> "+ prazoContratacao, (Usuario) session.getAttribute("usuario"));
    %>
  <font color="Red">&nbsp;Erro ao gerar o prazo final de contrata��o!</font>
<%}%>