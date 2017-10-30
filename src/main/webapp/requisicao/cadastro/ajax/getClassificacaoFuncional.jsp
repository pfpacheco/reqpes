<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%  
  //-- Objetos de controle
  RequisicaoControl requisicaoControl = new RequisicaoControl();

  //-- Objetos de sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Parametros de página
  int codClassificacaoFuncional = (request.getParameter("P_COD_CLASSIFICACAO")==null)?0:Integer.parseInt(request.getParameter("P_COD_CLASSIFICACAO"));
  
  //-- Resgatando objeto
  String[][] dadosClassificacao = requisicaoControl.getDscClassificacaoFuncional(codClassificacaoFuncional);
%>

<%if(dadosClassificacao.length > 0){%>
    <textarea readonly cols="73" rows="4" name="dscClassificacaoFuncional"><%=dadosClassificacao[0][2].trim()%></textarea>
<%}else{
    //-- Enviando e-mail de crítica
    RequisicaoMensagemControl.enviaMensagemCritica("getClassificacaoFuncional.jsp", "Descrição da Classificação Funcional não encontrada! <br><b>ClassificacaoFuncional:</b> "+codClassificacaoFuncional, usuario);
    %>
    <font color="Red">Dados não encontrados!</font>
<%}%>