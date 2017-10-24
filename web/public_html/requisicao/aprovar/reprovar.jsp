<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>

<jsp:useBean id="requisicaoAprovacao" class="br.senac.sp.reqpes.model.RequisicaoAprovacao" />
<jsp:setProperty name="requisicaoAprovacao" property="*" />

<%      
  //-- Objetos de controle
  RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();
  SistemaParametroControl    sistemaParametroControl    = new SistemaParametroControl();      
  RequisicaoControl          requisicaoControl          = new RequisicaoControl();

  //-- pegando o usuário da sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Resgatando as unidades do WorkFlow
  String codUOHomologadora = requisicaoAprovacaoControl.getUnidadeRHEvolutionByCodUnidade(usuario.getUnidade().getCodUnidade());
  
  //-- Setando os parametros de aprovação
  requisicaoAprovacao.setCodUnidadeAprovadora(codUOHomologadora);
  requisicaoAprovacao.setCodUnidadeHomologador(codUOHomologadora);
      
  //-- Reprovando a RP
  int retorno = requisicaoAprovacaoControl.reprovaRequisicao(requisicaoAprovacao, usuario);
  
  //------------------------ ENVIO DE E-MAILS --------------------------------
  if(retorno > 0){
    SistemaParametro indEnviarEmails = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"IND_ENVIAR_EMAILS");
    if(indEnviarEmails.getVlrSistemaParametro().equals("S")){    
      //-- resgatando os dados da requisição que acaba de ser reprovada
      Requisicao requisicaoDados = requisicaoControl.getRequisicao(requisicaoAprovacao.getCodRequisicao());
      //-- resgatando a lista de e-mails dos envolvidos
      String[] listaEmails = requisicaoAprovacaoControl.getEmailsEnvolvidosWorkFlow(requisicaoDados);      
      //-- enviando e-mail de notificação
      RequisicaoMensagemControl.enviaMensagemReprovacao(usuario, requisicaoDados, listaEmails, request.getParameter("dscMotivo"));
    }
  }  
%>

<script language="javascript">
  if(<%=retorno%> > 0){
    alert('Requisição reprovada com sucesso!');
  }  
  window.location = "<%=request.getContextPath()%>/requisicao/aprovar/index.jsp";
</script>