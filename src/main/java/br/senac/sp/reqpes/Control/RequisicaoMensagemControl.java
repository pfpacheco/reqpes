package br.senac.sp.reqpes.Control;

//-- Classes do java
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

//-- Classes do componente
import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.componente.control.SistemaParametroControl;
import br.senac.sp.componente.model.SistemaParametro;
//-- Classes da aplica��o
import br.senac.sp.componente.model.Usuario;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.Config;
import br.senac.sp.reqpes.model.Requisicao;
import br.senac.sp.reqpes.util.Email;
import br.senac.sp.reqpes.util.TemplateCorpoEmail;

public class RequisicaoMensagemControl {

	static Logger LOG = Logger.getLogger("ReqPes");

	public RequisicaoMensagemControl() {
	}

	/**
	 * Envia mensagem de cria��o de RP para o criador
	 *
	 * @param usuario,
	 *            requisicao, mensagem, emailPara, assunto
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemCriacao(Usuario usuario, Requisicao requisicao, String mensagem, String emailPara,
			String assunto) throws RequisicaoPessoalException, AdmTIException {
		String[] email = { emailPara };
		enviaMensagem(usuario, requisicao, mensagem, email, assunto);
	}

	/**
	 * Envia mensagem de cria��o de RP para o gerente da Unidade
	 *
	 * @param usuario,
	 *            requisicao, emailPara
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemCriacao(Usuario usuario, Requisicao requisicao, String emailPara)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Nova solicita��o de RP: " + requisicao.getCodRequisicao();
		String mensagem = "Nova requisi��o encaminhada para an�lise.";
		String[] email = { emailPara };
		enviaMensagem(usuario, requisicao, mensagem, email, assunto);
	}

	/**
	 * Envia mensagem de cria��o de RP para uma lista de usu�rios
	 *
	 * @param usuario,
	 *            requisicao, emailPara[]
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemCriacao(Usuario usuario, Requisicao requisicao, String[] emailPara)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Nova solicita��o de RP: " + requisicao.getCodRequisicao();
		String mensagem = "Nova requisi��o encaminhada para an�lise.";
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem para os homologadores da GEP (AP&B) e o criador da RP
	 *
	 * @param usuario,
	 *            requisicao
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemHomologacaoUO(Usuario usuario, Requisicao requisicao)
			throws RequisicaoPessoalException, AdmTIException {
		// -- Objetos
		List listEmail = new ArrayList();
		String[] homologGep = null;

		String assunto = "Retorno da Requisi��o n� " + requisicao.getCodRequisicao()
				+ " para o Solicitante (Homologada)";
		String mensagem = "<br>A Requisi��o de Pessoal N� <b>" + requisicao.getCodRequisicao()
				+ "</b> foi homologada pelo respons�vel da unidade e encaminhada para an�lise pela Ger�ncia de Pessoal.<br><br>";

		// Adicionando o email do criador na lista de envio (CRIADOR DA RP)
		if (requisicao.getEmailCriadorRP() != null) {
			listEmail.add(requisicao.getEmailCriadorRP());
		}

		// Adicionando os emails dos homologadores da unidade aprovadora na
		// lista de envio (HOMOLOGADORES - GEP)
		homologGep = new RequisicaoAprovacaoControl().getEmailsHomologadoresGEP();
		for (int i = 0; i < homologGep.length; i++) {
			listEmail.add(homologGep[i]);
		}

		// Criando array com os valores armzenados no ArrayList
		String[] emailPara = new String[listEmail.size()];
		listEmail.toArray(emailPara);

		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem para os homologadores da GEP (NEC) e participantes no
	 * Workflow de aprova��o
	 *
	 * @param usuario,
	 *            requisicao, emailPara[]
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemHomologacaoAPeB(Usuario usuario, Requisicao requisicao, String[] emailPara)
			throws RequisicaoPessoalException {

		try {
			// -- Objetos de controle
			RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();

			// -- Objetos
			List listEmail = new ArrayList();
			String[][] listaEmails = null;
			String email = null;

			String assunto = "Retorno da Requisi��o n� " + requisicao.getCodRequisicao()
					+ " para o Solicitante (Homologa��o)";
			String mensagem = "<br>A Requisi��o de Pessoal N� <b>" + requisicao.getCodRequisicao()
					+ "</b> foi homologada pela Ger�ncia de Pessoal (AP&B) e encaminhada para an�lise de aprova��o.<br><br>";

			// Adicionando lista de e-mail recebida como par�metro
			for (int i = 0; i < emailPara.length; i++) {
				listEmail.add(emailPara[i]);
			}

			// Adicionando o email do homologador da unidade da RP (GERENTE DE
			// UNIDADE)
			email = requisicaoAprovacaoControl.getEmailResponsavelUO(requisicao.getCodUnidade());
			if (email != null) {
				listEmail.add(email);
			}

			// Adicionando os emails dos homologadores GEP - NEC
			listaEmails = new GrupoNecUsuarioControl().getUsuariosByUnidade(requisicao.getCodUnidade());
			for (int i = 0; listaEmails != null && i < listaEmails.length; i++) {
				listEmail.add(listaEmails[i][1]);
			}

			// Criando array com os valores armzenados no ArrayList
			String[] destinatarios = new String[listEmail.size()];
			listEmail.toArray(destinatarios);

			enviaMensagem(usuario, requisicao, mensagem, destinatarios, assunto);

		} catch (Exception e) {
			e.printStackTrace();
			throw new RequisicaoPessoalException("enviaMensagemHomologacaoAPeB - Ocorreu o seguinte erro: \n",
					e.getMessage());
		}
	}

	/**
	 * Envia mensagem para os homologadores da GEP (AP&B) e participantes no
	 * Workflow de aprova��o
	 *
	 * @param usuario,
	 *            requisicao, emailPara[]
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemAlteracao(Usuario usuario, Requisicao requisicao, String[] emailPara)
			throws RequisicaoPessoalException {

		try {
			// -- Objetos de controle
			RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();

			// -- Objetos
			List listEmail = new ArrayList();
			String[] listaEmails = null;
			String email = null;

			// String assunto = "Retorno da Requisi��o n� " +
			// requisicao.getCodRequisicao()
			// + " para o Solicitante (Homologa��o)";
			// String mensagem = "<br>A Requisi��o de Pessoal N� <b>" +
			// requisicao.getCodRequisicao()
			// + "</b> foi homologada pela Ger�ncia de Pessoal (NEC) e
			// encaminhada para an�lise de aprova��o.<br><br>";

			String assunto = "Altera��o da Requisi��o n� <b>" + "333111" + "</b>";

			String mensagem = "";
			mensagem = mensagem + "<br><br>";
			mensagem = mensagem + "<br><br><b>Numero da RP:</b> xxx " + "333111";
			mensagem = mensagem + "<br><br><b>Unidade solicitante:</b> xxx";
			mensagem = mensagem + "<br><br><b>Cargo :</b> xxx";
			mensagem = mensagem + "<br><br><b>data da solicita��o:</b> xxx";
			mensagem = mensagem + "<br><br><b>Centro de custo:</b> xxx";
			mensagem = mensagem + "<br><br><b>Detalhes da altera��o:</b> xxx";
			mensagem = mensagem + "<br><br><b>Respons�vel pela altera��o:</b> xxx";

			// Adicionando lista de e-mail recebida como par�metro
			for (int i = 0; i < emailPara.length; i++) {
				listEmail.add(emailPara[i]);
			}

			// Adicionando o email do homologador da unidade da RP (GERENTE DE
			// UNIDADE)
			email = requisicaoAprovacaoControl.getEmailResponsavelUO(requisicao.getCodUnidade());
			if (email != null) {
				listEmail.add(email);
			}

			// Adicionando os emails dos homologadores GEP - AP&B
			listaEmails = requisicaoAprovacaoControl.getEmailsHomologadoresGEP();
			for (int i = 0; listaEmails != null && i < listaEmails.length; i++) {
				listEmail.add(listaEmails[i]);
			}

			// Criando array com os valores armzenados no ArrayList
			String[] destinatarios = new String[listEmail.size()];
			listEmail.toArray(destinatarios);

			enviaMensagem(usuario, requisicao, mensagem, destinatarios, assunto);

		} catch (Exception e) {
			e.printStackTrace();
			throw new RequisicaoPessoalException("enviaMensagemHomologacaoNEC - Ocorreu o seguinte erro: \n",
					e.getMessage());
		}
	}

	/**
	 * Envia mensagem para os homologadores da GEP (AP&B) e participantes no
	 * Workflow de aprova��o
	 *
	 * @param usuario,
	 *            requisicao, emailPara[]
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemHomologacaoNEC(Usuario usuario, Requisicao requisicao, String[] emailPara)
			throws RequisicaoPessoalException {

		try {
			// -- Objetos de controle
			RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();

			// -- Objetos
			List listEmail = new ArrayList();
			String[] listaEmails = null;
			String email = null;

			String assunto = "Retorno da Requisi��o n� " + requisicao.getCodRequisicao()
					+ " para o Solicitante (Homologa��o)";
			String mensagem = "<br>A Requisi��o de Pessoal N� <b>" + requisicao.getCodRequisicao()
					+ "</b> foi homologada pela Ger�ncia de Pessoal (NEC) e encaminhada para an�lise de aprova��o.<br><br>";

			// Adicionando lista de e-mail recebida como par�metro
			for (int i = 0; i < emailPara.length; i++) {
				listEmail.add(emailPara[i]);
			}

			// Adicionando o email do homologador da unidade da RP (GERENTE DE
			// UNIDADE)
			email = requisicaoAprovacaoControl.getEmailResponsavelUO(requisicao.getCodUnidade());
			if (email != null) {
				listEmail.add(email);
			}

			// Adicionando os emails dos homologadores GEP - AP&B
			listaEmails = requisicaoAprovacaoControl.getEmailsHomologadoresGEP();
			for (int i = 0; listaEmails != null && i < listaEmails.length; i++) {
				listEmail.add(listaEmails[i]);
			}

			// Criando array com os valores armzenados no ArrayList
			String[] destinatarios = new String[listEmail.size()];
			listEmail.toArray(destinatarios);

			enviaMensagem(usuario, requisicao, mensagem, destinatarios, assunto);

		} catch (Exception e) {
			e.printStackTrace();
			throw new RequisicaoPessoalException("enviaMensagemHomologacaoNEC - Ocorreu o seguinte erro: \n",
					e.getMessage());
		}
	}

	/**
	 * Envia mensagem notificando o gerente da unidade respons�vel e o gerente
	 * da unidade aprovadora (GEP)
	 *
	 * @param usuario,
	 *            requisicao
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemHomologacaoGEP(Usuario usuario, Requisicao requisicao)
			throws RequisicaoPessoalException, AdmTIException {

		// -- Objetos de controle
		RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();
		SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();

		// -- Objetos
		List listEmail = new ArrayList();
		String email = null;

		String assunto = "Retorno da Requisi��o n� " + requisicao.getCodRequisicao()
				+ " para o Solicitante (Homologada)";
		String mensagem = "<br>A Requisi��o de Pessoal N� <b>" + requisicao.getCodRequisicao()
				+ "</b> foi homologada pela Ger�ncia de Pessoal e encaminhada para an�lise de aprova��o.<br><br>";

		// Adicionando o email do homologador da unidade da RP (GERENTE DE
		// UNIDADE)
		email = requisicaoAprovacaoControl.getEmailResponsavelUO(requisicao.getCodUnidade());
		if (email != null) {
			listEmail.add(email);
		}

		// Adicionando o email do aprovador final (GERENTE - GEP)
		SistemaParametro codUnidadeAprovadora = sistemaParametroControl
				.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "UNIDADE_APROVADORA");
		email = requisicaoAprovacaoControl.getEmailResponsavelUO(codUnidadeAprovadora.getVlrSistemaParametro());
		if (email != null) {
			listEmail.add(email);
		}

		// Criando array com os valores armzenados no ArrayList
		String[] emailPara = new String[listEmail.size()];
		listEmail.toArray(emailPara);

		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem notificando a aprova��o final da RP
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemAprovacao(Usuario usuario, Requisicao requisicao, String[] emailPara)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Retorno da Requisi��o n� " + requisicao.getCodRequisicao() + " para o Solicitante (Aprovada)";
		String mensagem = "A Requisi��o de Pessoal N� <b>" + requisicao.getCodRequisicao()
				+ "</b> foi analisada e aprovada pela Ger�ncia de Pessoal.";
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem notificando a reprova��o da RP
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemReprovacao(Usuario usuario, Requisicao requisicao, String[] emailPara,
			String dscMotivo) throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Retorno da Requisi��o n� " + requisicao.getCodRequisicao()
				+ " para o Solicitante (Reprovada)";
		String mensagem = "<br>A Requisi��o de Pessoal N� <b>" + requisicao.getCodRequisicao()
				+ "</b> foi analisada e reprovada, pelo(s) seguinte(s) motivos:<br><br>" + dscMotivo + "<br><br>";
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem notificando os usu�rios do Workflow que a RP foi estornada
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemEstorno(Usuario usuario, Requisicao requisicao, String[] emailPara)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Retorno da Requisi��o n� " + requisicao.getCodRequisicao() + " para o Solicitante (Estorno)";
		String mensagem = "A Requisi��o de Pessoal N� <b>" + requisicao.getCodRequisicao() + "</b> foi estornada.";
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem notificando os usu�rios com perfil de cria��o da unidade
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemSolicitarRevisao(Usuario usuario, Requisicao requisicao, String dscMotivo)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Retorno da Requisi��o n� " + requisicao.getCodRequisicao() + " para o Solicitante (Revisar)";
		String mensagem = "<br>Solicita��o de revis�o da Requisi��o de Pessoal N� <b>" + requisicao.getCodRequisicao()
				+ "</b> pelo(s) seguinte(s) motivos:<br><br>" + dscMotivo + "<br><br>";
		String[] emailPara = { requisicao.getEmailCriadorRP(),
				new RequisicaoAprovacaoControl().getEmailResponsavelUO(requisicao.getCodUnidade()) };
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem notificando o Gerente da Unidade que a RP foi revisada
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemRevisaoEfetuada(Usuario usuario, Requisicao requisicao, String emailGerente)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Retorno da Requisi��o n� " + requisicao.getCodRequisicao() + " para o Solicitante (Revisada)";
		String mensagem = "<br>A Requisi��o de Pessoal N� <b>" + requisicao.getCodRequisicao()
				+ "</b> foi revisada e encaminhada para an�lise.<br><br>";
		String[] emailPara = { emailGerente };
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem notificando o cancelamento da RP
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemCancelamento(Usuario usuario, Requisicao requisicao, String[] emailPara,
			String dscMotivo) throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Cancelamento da Requisi��o n� " + requisicao.getCodRequisicao();
		String mensagem = "<br>A Requisi��o de Pessoal N� <b>" + requisicao.getCodRequisicao()
				+ "</b> foi cancelada pelo(s) seguinte(s) motivos:<br><br>" + dscMotivo + "<br><br>";
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia e-mail com remetente rpessoal@sp.senac.br
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagem(Requisicao requisicao, String mensagem, String[] emailPara, String assunto)
			throws RequisicaoPessoalException, AdmTIException {

		SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
		Email email = new Email();

		SistemaParametro smtp = null;
		SistemaParametro emailRemetente = null;
		String[] para = emailPara;

		try {
			smtp = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "SMTP");
			emailRemetente = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,
					"EMAIL_REMETENTE");
		} catch (Exception e) {
			throw new AdmTIException("Requisi��o de Pessoal: Erro ao enviar e-mail:", e.getMessage());
		}

		email.setSTMPServer(smtp.getVlrSistemaParametro());
		email.setTipoTexto("text/html");
		email.setAssunto(assunto);
		email.setRemetente(emailRemetente.getVlrSistemaParametro());
		email.setCorpoEmail(TemplateCorpoEmail.getCorpoEmail(requisicao, mensagem).toString());
		email.setParaVarios(para);

		try {
			email.enviarEmailRemetentesSimples();
		} catch (Exception e) {
			LOG.error(e.getMessage());
			System.out.println(e.getMessage());
		}
	}

	/**
	 * Envia e-mail com o usu�rio que realizou a a��o como remetente
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagem(Usuario usuario, Requisicao requisicao, String mensagem, String[] emailPara,
			String assunto) throws RequisicaoPessoalException, AdmTIException {

		SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
		Email email = new Email();

		SistemaParametro smtp = null;

		// voltar essas linhas
		// String[] para = emailPara;
		String emailRemetente = usuario.getEmail();

		String[] para = { "sanches_i7system@hotmail.com" };
		// String emailRemetente = "sanches_i7system@hotmail.com";

		try {
			smtp = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "SMTP");
		} catch (Exception e) {
			throw new AdmTIException("Requisi��o de Pessoal: Erro ao enviar e-mail:", e.getMessage());
		}

		email.setSTMPServer(smtp.getVlrSistemaParametro());
		email.setTipoTexto("text/html");
		email.setAssunto(assunto);
		email.setRemetente(emailRemetente);
		email.setCorpoEmail(TemplateCorpoEmail.getCorpoEmail(requisicao, mensagem).toString());
		email.setParaVarios(para);

		try {
			email.enviarEmailRemetentesSimples();
		} catch (Exception e) {
			LOG.error(e.getMessage());
			System.out.println(e.getMessage());
		}
	}

	public static void enviaMensagemCritica(String pagina, String mensagem, Usuario usuario) throws AdmTIException {

		SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
		StringBuffer corpo = new StringBuffer();
		Email email = new Email();

		SistemaParametro smtp = null;
		SistemaParametro emailRemetente = null;
		String[] para = { "marcus.soliveira@sp.senac.br" };

		try {
			smtp = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "SMTP");
			emailRemetente = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,
					"EMAIL_REMETENTE");
		} catch (Exception e) {
			throw new AdmTIException("Requisi��o de Pessoal: Erro ao enviar e-mail:", e.getMessage());
		}

		corpo.append("<b>P�gina :</b> " + pagina + "<BR><BR>");
		corpo.append("<b>Cr�tica:</b> " + mensagem + "<BR><BR>");

		if (usuario != null) {
			corpo.append("<b>Usu�rio:</b> " + usuario.getNome() + "<BR>");
			corpo.append("<b>Chapa  :</b> " + usuario.getChapa() + "<BR>");
			corpo.append("<b>Perfil :</b> " + usuario.getSistemaPerfil().getNomSistemaPerfil() + "<BR>");
			corpo.append("<b>Unidade:</b> " + usuario.getUnidade().getSigla());
		}

		email.setSTMPServer(smtp.getVlrSistemaParametro());
		email.setTipoTexto("text/html");
		email.setAssunto("Cr�tica: Requisi��o de Pessoal");
		email.setRemetente(emailRemetente.getVlrSistemaParametro());
		email.setCorpoEmail(corpo.toString());
		email.setParaVarios(para);

		try {
			email.enviarEmailRemetentesSimples();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
}