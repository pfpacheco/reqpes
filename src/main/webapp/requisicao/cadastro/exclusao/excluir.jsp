<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page import="br.senac.sp.reqpes.Interface.Config" %>

<jsp:useBean id="requisicao" class="br.senac.sp.reqpes.model.Requisicao" />
<jsp:setProperty name="requisicao" property="*" />

<%      
  //-- Objetos de controle
  RequisicaoControl requisicaoControl = new RequisicaoControl();
  SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
  RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();
      
  //-- Parametro de página
  Boolean indWorkFlow = (request.getParameter("indWorkFlow") == null)?Boolean.FALSE:Boolean.valueOf(request.getParameter("indWorkFlow").trim());
  
  //-- Pegando o usuário da sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");

  //-- Exluindo os dados da requisição (EXCLUSÃO LÓGICA), cancelamento da RP   
  int codRequisicao = requisicaoControl.deletaRequisicao(requisicao, (Usuario)session.getAttribute("usuario"));

  //------------------------ ENVIO DE E-MAILS --------------------------------
  if(codRequisicao > 0){
    SistemaParametro indEnviarEmails = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"IND_ENVIAR_EMAILS");
    System.out.println(indEnviarEmails.getVlrSistemaParametro().equals("S"));
    if(indEnviarEmails.getVlrSistemaParametro().equals("S")){    
      //-- resgatando os dados da requisição que acaba de ser cancelada
      Requisicao requisicaoDados = requisicaoControl.getRequisicao(requisicao.getCodRequisicao());
      //-- resgatando a lista de e-mails dos envolvidos
      String[] listaEmails = requisicaoAprovacaoControl.getEmailsEnvolvidosWorkFlow(requisicaoDados);
      //-- enviando e-mail de notificação
      RequisicaoMensagemControl.enviaMensagemCancelamento(usuario, requisicaoDados, listaEmails, request.getParameter("dscMotivoSolicitacao"));
    }
  }    
    
%>

<script language="javascript">
  <%
    if(codRequisicao > 0){
      out.println("alert('Cancelamento da RP nº "+ codRequisicao +" realizada com sucesso!');");
    }  
  
    if(indWorkFlow.booleanValue()){
      out.println("window.location = '"+request.getContextPath()+"/requisicao/aprovar/index.jsp';");
    }else{
      out.println("window.location = 'index.jsp';");
    }  
  %>
</script>