<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page import="java.util.*"%>

<jsp:useBean id="requisicaoAprovacao" class="br.senac.sp.reqpes.model.RequisicaoAprovacao" />
<jsp:setProperty name="requisicaoAprovacao" property="*" />

<%      
    //-- Objetos de controle
    RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();
    SistemaParametroControl    sistemaParametroControl    = new SistemaParametroControl();  
    RequisicaoControl          requisicaoControl          = new RequisicaoControl();
    UsuarioAvisoEmailControl   usuarioAvisoEmailControl   = new UsuarioAvisoEmailControl();

    //-- Pegando o usuário da sessão
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    //-- Resgatando as unidades do WorkFlow
    SistemaParametro codUOAprovadora = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"UNIDADE_APROVADORA");
    String codUOHomologadora = requisicaoAprovacaoControl.getUnidadeRHEvolutionByCodUnidade(usuario.getUnidade().getCodUnidade());
    
    //-- Setando os parametros de aprovação
    requisicaoAprovacao.setCodUnidadeAprovadora(codUOAprovadora.getVlrSistemaParametro());
    requisicaoAprovacao.setCodUnidadeHomologador(codUOHomologadora);
      
    //-- Objetos
    int retorno = 0;
    int idPerfilAPR = Integer.parseInt((sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_APR_GEP").getVlrSistemaParametro()));
    int idPerfilGEP = Integer.parseInt((sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_GEP").getVlrSistemaParametro()));
    int idPerfilNEC = Integer.parseInt((sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_NEC").getVlrSistemaParametro()));
    String indEnviarEmails = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"IND_ENVIAR_EMAILS").getVlrSistemaParametro();
    String[] listaEmails = null;
    
    //-- Resgatando os dados completos da requisição
    Requisicao requisicaoDados = requisicaoControl.getRequisicao(requisicaoAprovacao.getCodRequisicao());

    //-- Verifica se a homologação está sendo feita pelo APROVADOR FINAL
    if(usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilAPR){
    
      // aprovação final da requisição pela unidade aprovadora (APROVADOR - GEP)
      retorno = requisicaoAprovacaoControl.aprovaRequisicao(requisicaoAprovacao, usuario);

      //------------------------ ENVIO DE E-MAILS --------------------------------
        if(indEnviarEmails.equals("S")){
          Set listEmail = new HashSet();
          //-- Resgatando dos envolvidos no workflow
            listaEmails = requisicaoAprovacaoControl.getEmailsEnvolvidosWorkFlow(requisicaoDados);          
            for(int i=0; i < listaEmails.length; i++){
              listEmail.add(listaEmails[i]);
            }          
  
          //-- Resgatando e-mails dos usuarios cadastrados da GEP
            listaEmails = usuarioAvisoEmailControl.getEmailsUsuariosAviso(requisicaoDados.getCodCargo());
            for(int i=0; i < listaEmails.length; i++){
              listEmail.add(listaEmails[i]);
            }            
            
          //-- Enviando a mensagem
            listaEmails = new String[listEmail.size()];
            listEmail.toArray(listaEmails);            
            RequisicaoMensagemControl.enviaMensagemAprovacao(usuario, requisicaoDados, listaEmails);            
        }
      
    }else{
     
      // homologação parcial da requisição, pelo gerente (HOMOLOGADOR-UO) ou homologador da unidade aprovadora (HOMOLOGADOR-GEP / HOMOLOGADOR-NEC)
      retorno = requisicaoAprovacaoControl.homologaRequisicao(requisicaoAprovacao, usuario);
          
      //------------------------ ENVIO DE E-MAILS --------------------------------      
        if(indEnviarEmails.equals("S")){
          if(usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilGEP || usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilNEC){

            //-- Realiza a notificação apenas quando a RP foi encaminhada para o aprovador final
            if(requisicaoAprovacaoControl.getNivelAprovacaoAtual(requisicaoDados.getCodRequisicao()) == 4){              
              RequisicaoMensagemControl.enviaMensagemHomologacaoGEP(usuario, requisicaoDados);
            }else{
              //-- Enviando e-mail para envolvidos no workflow
              listaEmails = requisicaoAprovacaoControl.getEmailsEnvolvidosWorkFlow(requisicaoDados);
              
              //-- Aprovaçao intermediária (AP&B e NEC)
              if(usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilGEP){
                //-- Aprovaçao pela AP&B => notifica o NEC
                RequisicaoMensagemControl.enviaMensagemHomologacaoAPeB(usuario, requisicaoDados, listaEmails);
              }else{
                //-- Aprovaçao pelo NEC => notifica a AP&B
                RequisicaoMensagemControl.enviaMensagemHomologacaoNEC(usuario, requisicaoDados, listaEmails);
              }
            }
            
          }else{
            //-- Se foi o gerente de unidade que aprovou, notifica os homologadores da GEP
            RequisicaoMensagemControl.enviaMensagemHomologacaoUO(usuario, requisicaoDados);
          }            
        }
    }
%>

<script language="javascript">
  if(<%=retorno%> > 0){
    alert('Aprovação realizada com sucesso!');
  }
  window.location = "<%=request.getContextPath()%>/requisicao/aprovar/index.jsp";
</script>