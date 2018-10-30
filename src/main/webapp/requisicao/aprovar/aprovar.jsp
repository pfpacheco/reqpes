<%@page import="br.senac.sp.componente.model.SistemaPerfil"%>
<%@page import="br.senac.sp.componente.control.SistemaPerfilControl"%>
<%@page import="br.senac.sp.componente.model.SistemaPerfilUsuario"%>
<%@page import="br.senac.sp.componente.control.UsuarioControl"%>
<%
	session.setAttribute("root", "../../");
%>
<%@ page errorPage="../../error/error.jsp"%>
<%@ page import="br.senac.sp.reqpes.model.*"%>
<%@ page import="br.senac.sp.componente.model.Unidade"%>
<%@ page import="br.senac.sp.reqpes.Control.*"%>
<%@ page import="br.senac.sp.reqpes.Interface.*"%>
<%@ page import="br.senac.sp.componente.model.Usuario"%>
<%@ page import="br.senac.sp.componente.model.SistemaParametro"%>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl"%>
<%@ page import="java.util.*"%>
<%@ page import="br.senac.sp.reqpes.DAO.*"%>
<%@ page import="br.senac.sp.reqpes.Control.*"%>

<jsp:useBean id="requisicaoAprovacao"
	class="br.senac.sp.reqpes.model.RequisicaoAprovacao" />
<jsp:setProperty name="requisicaoAprovacao" property="*" />
<%
	//-- Objetos de controle
	RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();
	SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
	RequisicaoControl requisicaoControl = new RequisicaoControl();
	UsuarioAvisoEmailControl usuarioAvisoEmailControl = new UsuarioAvisoEmailControl();

	//-- Pegando o usu�rio da sess�o
	Usuario usuario = (Usuario) session.getAttribute("usuario");

	//-- Resgatando as unidades do WorkFlow
	SistemaParametro codUOAprovadora = sistemaParametroControl
			.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "UNIDADE_APROVADORA");
	String codUOHomologadora = requisicaoAprovacaoControl
			.getUnidadeRHEvolutionByCodUnidade(usuario.getUnidade().getCodUnidade());

	//-- Setando os parametros de aprova��o
	requisicaoAprovacao.setCodUnidadeAprovadora(codUOAprovadora.getVlrSistemaParametro());
	requisicaoAprovacao.setCodUnidadeHomologador(codUOHomologadora);

	//-- Objetos
	int retorno = 0;
	int idPerfilAPR = Integer.parseInt(
			(sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "ID_PERFIL_APR_GEP")
					.getVlrSistemaParametro()));
	int idPerfilGEP = Integer.parseInt(
			(sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "ID_PERFIL_HOM_GEP")
					.getVlrSistemaParametro()));
	int idPerfilNEC = Integer.parseInt(
			(sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "ID_PERFIL_HOM_NEC")
					.getVlrSistemaParametro()));
	String indEnviarEmails = sistemaParametroControl
			.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "IND_ENVIAR_EMAILS").getVlrSistemaParametro();
	String[] listaEmails = null;
	ResponsavelEstrutura responsavelEstrutura = null;
	ResponsavelEstruturaControl responsavelEstruturaControl = new ResponsavelEstruturaControl();
	SistemaParametro idPerfilHOM = null;

	//-- Resgatando os dados completos da requisi��o
	Requisicao requisicaoDados = requisicaoControl.getRequisicao(requisicaoAprovacao.getCodRequisicao());

	//-- resgata o criador da requisicao
	int numUsuaarioSq = requisicaoControl.getDadosUsuarioCriador(requisicaoDados.getCodRequisicao());
	Usuario criador = new UsuarioControl().getUsuario(numUsuaarioSq);
	SistemaPerfil sp = new SistemaPerfilControl().getSistemaPerfilByUsuarioSistema(criador.getChapa(),
			Config.ID_SISTEMA);
	criador.setSistemaPerfil(sp);

	if (criador != null) {
		//------------ REGRA DE PERFIL EXCLUSIVA DO SISTEMA REQUISICAO -------------                 
		//-- Carregando objeto da Respons�vel Estrutura atrav�s do usu�rio passado
		responsavelEstrutura = responsavelEstruturaControl.getResponsavelEstrutura(criador);

		//-- Setando o perfil do usu�rio de acordo com o WorkFlow da RESPONSAVEL_ESTRUTURA
		SistemaPerfil sistemaPerfilWorkFlow = new SistemaPerfil();
		sistemaPerfilWorkFlow.setCodSistemaPerfil(responsavelEstrutura.getCodPerfilUsuario());
		criador.setSistemaPerfil(sistemaPerfilWorkFlow);

		//-- Carregando o par�metro de perfil de HOMOLOGADOR UO (GERENTE)
		idPerfilHOM = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,
				"ID_PERFIL_HOM_UO");

		//-- Setando as unidades de acesso caso o usu�rio seja GERENTE
		if (Integer.parseInt(idPerfilHOM.getVlrSistemaParametro()) == responsavelEstrutura
				.getCodPerfilUsuario()) {
			Unidade[] unidades = responsavelEstrutura.getUnidades();
			criador.setUnidades(unidades);
		}
		//---------------------------------------------------------------------------         
	}

	int idPerfilCriador = criador.getSistemaPerfil().getCodSistemaPerfil();
	int idPerfilUsuario = usuario.getSistemaPerfil().getCodSistemaPerfil();

	if (idPerfilUsuario == idPerfilNEC && idPerfilCriador == idPerfilGEP) {
		requisicaoAprovacao.setNivelWorkFlow(4);
	}

	//-- Verifica se a homologa��o est� sendo feita pelo APROVADOR FINAL
	if (usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilAPR) {

		// aprova��o final da requisi��o pela unidade aprovadora (APROVADOR - GEP)
		retorno = requisicaoAprovacaoControl.aprovaRequisicao(requisicaoAprovacao, usuario);

		//------------------------ ENVIO DE E-MAILS --------------------------------
		if (indEnviarEmails.equals("S")) {
			Set listEmail = new HashSet();
			//-- Resgatando dos envolvidos no workflow
			listaEmails = requisicaoAprovacaoControl.getEmailsEnvolvidosWorkFlow(requisicaoDados);
			for (int i = 0; i < listaEmails.length; i++) {
				listEmail.add(listaEmails[i]);
			}

			//-- Resgatando e-mails dos usuarios cadastrados da AP&B
			//  listaEmails = usuarioAvisoEmailControl.getEmailsUsuariosAviso(requisicaoDados.getCodCargo());
			listaEmails = new RequisicaoAprovacaoControl().getEmailsHomologadoresGEP();

			for (int i = 0; i < listaEmails.length; i++) {
				listEmail.add(listaEmails[i]);
			}

			////-- Resgatando e-mails dos usuarios cadastrados do NEC
			listaEmails = requisicaoAprovacaoControl.getEmailsEnvolvidosWorkFlowNEC(requisicaoDados);

			for (int i = 0; i < listaEmails.length; i++) {
				listEmail.add(listaEmails[i]);
			}

			//-- Enviando a mensagem
			listaEmails = new String[listEmail.size()];
			listEmail.toArray(listaEmails);
			RequisicaoMensagemControl.enviaMensagemAprovacao(usuario, requisicaoDados, listaEmails);
		}

	} else {

		// homologa��o parcial da requisi��o, pelo gerente (HOMOLOGADOR-UO) ou homologador da unidade aprovadora (HOMOLOGADOR-GEP / HOMOLOGADOR-NEC)
		retorno = requisicaoAprovacaoControl.homologaRequisicao(requisicaoAprovacao, usuario);

		//------------------------ ENVIO DE E-MAILS --------------------------------      
		if (indEnviarEmails.equals("S")) {
			if (usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilGEP
					|| usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilNEC) {

				//-- Realiza a notifica��o apenas quando a RP foi encaminhada para o aprovador final
				if (requisicaoAprovacaoControl
						.getNivelAprovacaoAtual(requisicaoDados.getCodRequisicao()) == 4) {
					RequisicaoMensagemControl.enviaMensagemHomologacaoGEP(usuario, requisicaoDados);
				} else {

					//-- Aprova�ao intermedi�ria (AP&B e NEC)
					if (usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilGEP) {
						//-- Aprova�ao pela AP&B => notifica o NEC
						listaEmails = requisicaoAprovacaoControl
								.getEmailsEnvolvidosWorkFlowNEC(requisicaoDados);
						RequisicaoMensagemControl.enviaMensagemHomologacaoAPeB(usuario, requisicaoDados,
								listaEmails);
					} else {
						//-- Aprova�ao pelo NEC => notifica a AP&B
						listaEmails = requisicaoAprovacaoControl
								.getEmailsEnvolvidosWorkFlowAPB(requisicaoDados); // ap&b
						RequisicaoMensagemControl.enviaMensagemHomologacaoNEC(usuario, requisicaoDados,
								listaEmails);
					}
				}

			} else {
				//-- Se foi o gerente de unidade que aprovou, notifica os homologadores da GEP
				RequisicaoMensagemControl.enviaMensagemHomologacaoUO(usuario, requisicaoDados);
			}
		}
	}
%>

<script language="javascript">
  if(<%=retorno%> > 0){
    alert('Aprova��o realizada com sucesso!');
  }
  window.location = "<%=request.getContextPath()%>/requisicao/aprovar/index.jsp";
</script>