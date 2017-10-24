<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%  
  //-- Objetos de controle
  RequisicaoControl requisicaoControl = new RequisicaoControl();

  //-- Objetos de sess�o
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Parametros de p�gina
  int codClassificacaoFuncional = (request.getParameter("P_COD_CLASSIFICACAO")==null)?0:Integer.parseInt(request.getParameter("P_COD_CLASSIFICACAO"));
  
  //-- Resgatando objeto
  String[][] dadosClassificacao = requisicaoControl.getDscClassificacaoFuncional(codClassificacaoFuncional);
%>

<%if(dadosClassificacao.length > 0){%>
    <textarea readonly cols="73" rows="4" name="dscClassificacaoFuncional"><%=dadosClassificacao[0][2].trim()%></textarea>
<%}else{
    //-- Enviando e-mail de cr�tica
    RequisicaoMensagemControl.enviaMensagemCritica("getClassificacaoFuncional.jsp", "Descri��o da Classifica��o Funcional n�o encontrada! <br><b>ClassificacaoFuncional:</b> "+codClassificacaoFuncional, usuario);
    %>
    <font color="Red">Dados n�o encontrados!</font>
<%}%>