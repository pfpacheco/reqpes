<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Interface.Config" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>

<jsp:useBean id="requisicaoRevisao" class="br.senac.sp.reqpes.model.RequisicaoRevisao" />
<jsp:setProperty name="requisicaoRevisao" property="*" />

<%      
  //-- Objetos de controle
  RequisicaoRevisaoControl requisicaoRevisaoControl = new RequisicaoRevisaoControl();
  SistemaParametroControl  sistemaParametroControl  = new SistemaParametroControl();
  RequisicaoControl        requisicaoControl        = new RequisicaoControl();
  
  //-- Objetos
  SistemaParametro indEnviarEmails = null;  
  Requisicao requisicaoDados = null;
  
  //-- pegando o usu�rio da sess�o
  Usuario usuario = (Usuario) session.getAttribute("usuario");
      
  //-- Solicitando revis�o
  int retorno = requisicaoRevisaoControl.gravaRequisicaoRevisao(requisicaoRevisao, usuario);
    
  //------------------------ ENVIO DE E-MAILS --------------------------------
  if(retorno > 0){
    indEnviarEmails = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"IND_ENVIAR_EMAILS");
    if(indEnviarEmails != null && indEnviarEmails.getVlrSistemaParametro().equals("S")){
      //-- resgatando os dados completos da requisi��o
      requisicaoDados = requisicaoControl.getRequisicao(requisicaoRevisao.getCodRequisicao());
      //-- enviando e-mail de notifica��o
      RequisicaoMensagemControl.enviaMensagemSolicitarRevisao(usuario, requisicaoDados, request.getParameter("dscMotivo"));
    }
  }    
%>

<script language="javascript">  
  if(<%=retorno%> > 0){
    alert('Solicita��o de Revis�o encaminhada para unidade solicitante!');
  }  
  window.location = "<%=request.getContextPath()%>/requisicao/aprovar/index.jsp";
</script>