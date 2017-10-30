<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.reqpes.util.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page import="br.senac.sp.reqpes.Interface.Config" %>

<jsp:useBean id="requisicaoEstorno" class="br.senac.sp.reqpes.model.RequisicaoEstorno" />
<jsp:setProperty name="requisicaoEstorno" property="*" />

<%
  //-- Resgatando objeto da sessão  
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Estornando a RP
  int retorno = new RequisicaoEstornoControl().estornaRequisicao(requisicaoEstorno, usuario);
  
  //------------------------ ENVIO DE E-MAILS --------------------------------
  if(retorno > 0){
    SistemaParametro indEnviarEmails = new SistemaParametroControl().getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"IND_ENVIAR_EMAILS");
    if(indEnviarEmails.getVlrSistemaParametro().equals("S")){    
      //-- resgatando os dados da requisição que acaba de ser estornada
      Requisicao requisicao = new RequisicaoControl().getRequisicao(requisicaoEstorno.getCodRequisicao());
      //-- resgatando a lista de e-mails dos envolvidos
      String[] listaEmails = new RequisicaoAprovacaoControl().getEmailsEnvolvidosWorkFlow(requisicao);      
      //-- enviando e-mail de notificação
      RequisicaoMensagemControl.enviaMensagemEstorno(usuario, requisicao, listaEmails);
    }
  }
%>

<script language="JavaScript">
  switch (<%=retorno%>){
    case -1: alert('Não foi possível realizar estorno na RP nº <%=requisicaoEstorno.getCodRequisicao()%>.\n\Esta requisição já foi estornada anteriormente!');
             break;
    case -2: alert('Não foi possível realizar estorno na RP nº <%=requisicaoEstorno.getCodRequisicao()%>.\n\Para o tipo de estorno "Revisão" a RP deve ter sido homologada anteriormente pela GEP!');
             break;             
  }
  window.location = "index.jsp";
</script>