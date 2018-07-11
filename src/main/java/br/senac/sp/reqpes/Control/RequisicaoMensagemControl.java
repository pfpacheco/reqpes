package br.senac.sp.reqpes.Control;

//-- Classes do java
import java.util.ArrayList;
import java.util.List;
import java.util.PropertyResourceBundle;

import org.apache.log4j.Logger;

//-- Classes do componente
import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.componente.control.SistemaParametroControl;
import br.senac.sp.componente.model.SistemaParametro;
//-- Classes da aplicação
import br.senac.sp.componente.model.Usuario;
import br.senac.sp.reqpes.DAO.RequisicaoPerfilDAO;
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
	 * Envia mensagem de criação de RP para o criador
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
	 * Envia mensagem de criação de RP para o gerente da Unidade
	 *
	 * @param usuario,
	 *            requisicao, emailPara
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemCriacao(Usuario usuario, Requisicao requisicao, String emailPara)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Nova solicitação de RP: " + requisicao.getCodRequisicao();
		String mensagem = "Nova requisição encaminhada para análise.";
		String[] email = { emailPara };
		enviaMensagem(usuario, requisicao, mensagem, email, assunto);
	}

	/**
	 * Envia mensagem de criação de RP para uma lista de usuários
	 *
	 * @param usuario,
	 *            requisicao, emailPara[]
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemCriacao(Usuario usuario, Requisicao requisicao, String[] emailPara)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Nova solicitação de RP: " + requisicao.getCodRequisicao();
		String mensagem = "Nova requisição encaminhada para análise.";
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

		String assunto = "Retorno da Requisição n° " + requisicao.getCodRequisicao()
				+ " para o Solicitante (Homologada)";
		String mensagem = "<br>A Requisição de Pessoal N° <b>" + requisicao.getCodRequisicao()
				+ "</b> foi homologada pelo responsável da unidade e encaminhada para análise pela Gerência de Pessoal.<br><br>";

		// Adicionando o email do criador na lista de envio (CRIADOR DA RP)
		if (requisicao.getEmailCriadorRP() != null) {
			listEmail.add(requisicao.getEmailCriadorRP());
		}

		// Adicionando os emails dos homologadores da unidade aprovadora na
		// lista de envio (HOMOLOGADORES - GEP)

		// homologGep = new
		// RequisicaoAprovacaoControl().getEmailsHomologadoresGEP();

		homologGep = new RequisicaoAprovacaoControl().getEmailsHomologadoresNEC(requisicao);

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
	 * Workflow de aprovação
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

			String assunto = "Retorno da Requisição n° " + requisicao.getCodRequisicao()
					+ " para o Solicitante (Homologação)";
			String mensagem = "<br>A Requisição de Pessoal N° <b>" + requisicao.getCodRequisicao()
					+ "</b> foi homologada pela Gerência de Pessoal (AP&B) e encaminhada para análise de aprovação.<br><br>";

			// Adicionando lista de e-mail recebida como parâmetro
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
	
	private static String geraCorpoEmailAlteracao(int codRequisicao, int...gravaHistoricoChapa) throws RequisicaoPessoalException{
		RequisicaoControl requisicaoControl = new RequisicaoControl();
		Requisicao requisicao = requisicaoControl.getRequisicao(codRequisicao);
		RequisicaoPerfilDAO requisicaoPerfilDAO = new RequisicaoPerfilDAO();
		String[][] dadosRequisicao = requisicaoPerfilDAO.getRequisicaoDetalhes(requisicao, gravaHistoricoChapa[0]);
		String[][] dadosAlterados = requisicaoPerfilDAO.getRequisicaoAlteracao(requisicao);

		StringBuffer corpo = new StringBuffer();

		corpo.append("<head>");
		corpo.append("    <title>Solicitação</title>");
		corpo.append("    <meta http-equiv=expires content=\"Mon, 06 Jan 1990 00:00:01 GMT\">");
		corpo.append("    <meta http-equiv=\"pragma\" content=\"no-cache\">");
		corpo.append("    <META HTTP-EQUIV=\"CACHE-CONTROL\" CONTENT=\"NO-CACHE\">");
		corpo.append("	<style>");
		corpo.append(
				"	   .tdCabecalho{font-family:verdana; color:#FFFFFF; font-size:10px; background-color:#6699CC; font-weight:normal; }");
		corpo.append(
				"     .tdintranet2{font-family:verdana; color:#000000; font-size:10px; background-color:#E7F3FF; }");
		corpo.append(
				"     .tdintranet {font-family:verdana; color:#000000; font-size:10px; background-color:#6699CC; }");
		corpo.append(
				"     .tdNormal   {font-family:verdana; color:#000000; font-size:10px; background-color:#FFFFFF; }");
		corpo.append("		td.texto {");
		corpo.append("			color: #000000;");
		corpo.append("			font-family: Verdana, Arial, Helvetica, sans-serif;");
		corpo.append("			font-size: 10px;");
		corpo.append("			background-color: #FFFFFF;");
		corpo.append("		}");
		corpo.append("	</style>");
		corpo.append("  </head>");
		corpo.append(
				"  <body bgcolor='#ffffff' bottommargin='0' topmargin='0' leftmargin='0' rightmargin='0' marginwidth='0' marginheight='0' >");
		corpo.append("  <center><br> ");
		corpo.append("     <table border='0' width='610' cellpadding='0' cellspacing='0'> ");
		corpo.append("           <tr> ");
		corpo.append("             <td colspan='2' height='18' class='tdCabecalho'> ");
		corpo.append("              <STRONG>&nbsp;&nbsp;REQUISIÇÃO DE PESSOAL</STRONG> ");
		corpo.append("             </td> ");
		corpo.append("           </tr> ");
		corpo.append("           <tr> ");
		corpo.append("              <td height='25' width='5%' align='left' class='tdintranet2'> ");
		corpo.append("              &nbsp;");
		corpo.append("             </td> ");
		corpo.append("              <td height='25' width='95%' align='left' class='tdintranet2'> ");

		corpo.append("A Requisição de Pessoal N° " + dadosRequisicao[0][0]
				+ " foi analisada e alterada pela Gerência de Pessoal.");
		corpo.append("              </td> ");
		corpo.append("           </tr>    ");
		corpo.append("           <tr> ");
		corpo.append("              <td height='25' width='5%' align='left' class='tdintranet2'> ");
		corpo.append("              &nbsp;");
		corpo.append("             </td> ");
		corpo.append("              <td height='25' width='95%' align='left' class='tdintranet2'> ");
		// -- LINK DE PRODUÇÃO
		// corpo.append( "Para mais detalhes <a
		// href='http://www.intranet.sp.senac.br/jsp/private/sistemaIntra.jsp?url=login/leRP.cfm?sncReqPes="+requisicao.getCodRequisicao()+"'>clique
		// aqui</a> para visualizar os dados completos desta
		// requisição.<br><br>");
		corpo.append(
				"Para mais detalhes <a href='http://www.intranet.sp.senac.br/intranet-frontend/sistemas-integrados/detalhes/7'>clique aqui</a> para visualizar os dados completos desta requisição.<br><br>");
		// -- LINK DE HOMOLOGAÇÃO
		// corpo.append( "Para mais detalhes <a
		// href='http://www.intranet.sp.senac.br/jsp/private/sistemaIntra.jsp?url=login/leRPHOM.cfm?sncReqPes="+requisicao.getCodRequisicao()+"'>clique
		// aqui</a> para visualizar os dados completos desta
		// requisição.<br><br>");
		corpo.append("              </td> ");
		corpo.append("           </tr>    ");
		corpo.append("           <tr> ");
		corpo.append("              <td colspan='2'  height='3' class='tdIntranet'></td> ");
		corpo.append("           </tr>    ");
		corpo.append("     </table><br>");

		corpo.append("     <table border='0' width='610' cellpadding='0' cellspacing='0'> ");
		corpo.append("           <tr> ");
		corpo.append("             <td colspan='3'  height='18' class='tdCabecalho'> ");
		corpo.append("              <STRONG>&nbsp;&nbsp;DADOS DA REQUISIÇÃO</STRONG> ");
		corpo.append("             </td> ");
		corpo.append("           </tr> ");
		corpo.append("               <tr> ");
		corpo.append("                   <td colspan='2'  height='8' class='tdintranet2'></td> ");
		corpo.append("               </tr>      ");
		corpo.append("               <tr> ");
		corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
		corpo.append("                   <STRONG>Número da RP:&nbsp;</STRONG> ");
		corpo.append("                 </td> ");
		corpo.append("                 <td class='tdintranet2' width='77%'> ");
		corpo.append("                   " + dadosRequisicao[0][0]);
		corpo.append("                 </td> ");
		corpo.append("               </tr>    ");
		corpo.append("               <tr> ");
		corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
		corpo.append("                   <STRONG>Unidade solicitante:&nbsp;</STRONG> ");
		corpo.append("                 </td> ");
		corpo.append("                 <td class='tdintranet2' width='77%'> ");
		corpo.append("                   " + dadosRequisicao[0][1]);
		corpo.append("                 </td> ");
		corpo.append("               </tr>    ");
		corpo.append("               <tr> ");
		corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
		corpo.append("                   <STRONG>Cargo:&nbsp;</STRONG> ");
		corpo.append("                 </td> ");
		corpo.append("                 <td class='tdintranet2' width='77%'> ");
		corpo.append("                   " + dadosRequisicao[0][2]);
		corpo.append("                 </td> ");
		corpo.append("               </tr>    ");
		corpo.append("               <tr> ");
		corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
		corpo.append("                   <STRONG>Data da solicitação:&nbsp;</STRONG> ");
		corpo.append("                 </td> ");
		corpo.append("                 <td class='tdintranet2' width='77%'> ");
		corpo.append("                   " + dadosRequisicao[0][3]);
		corpo.append("                 </td> ");
		corpo.append("               </tr>    ");

		corpo.append("               <tr> ");
		corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
		corpo.append("                   <STRONG>Centro de Custo:&nbsp;</STRONG> ");
		corpo.append("                 </td> ");
		corpo.append("                 <td class='tdintranet2' width='77%'> ");
		corpo.append("                   " + dadosRequisicao[0][4]);
		corpo.append("                 </td> ");
		corpo.append("               </tr>    ");

		corpo.append("               <tr> ");
		corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
		corpo.append("                   <STRONG>Responsável pela alteração:&nbsp;</STRONG> ");
		corpo.append("                 </td> ");
		corpo.append("                 <td class='tdintranet2' width='77%'> ");
		corpo.append("                   " + dadosRequisicao[0][5]);
		corpo.append("                 </td> ");
		corpo.append("               </tr>    ");

		// corpo.append(" <tr> ");
		// corpo.append(" <td height='25' width='23%' align='right'
		// class='tdintranet2'> ");
		// corpo.append(" <STRONG>Detalhes da alteração:&nbsp;</STRONG>
		// ");
		// corpo.append(" </td> ");
		// corpo.append(" <td class='tdintranet2' width='77%'> ");
		// corpo.append(" " + detalhes);
		// corpo.append(" </td> ");
		// corpo.append(" </tr> ");

		corpo.append("               <tr> ");
		corpo.append("                   <td colspan='2'  height='8' class='tdintranet2'></td> ");
		corpo.append("               </tr>      ");
		corpo.append("               <tr> ");
		corpo.append("                 <td colspan='2'  height='3' class='tdIntranet'></td> ");
		corpo.append("               </tr>    ");
		corpo.append("           <tr> ");
		corpo.append("              <td colspan='2'  height='3' class='tdIntranet'></td> ");
		corpo.append("           </tr>    ");
		corpo.append("     </table><br>");

		corpo.append("     <table border='0' width='610' cellpadding='0' cellspacing='0'> ");
		corpo.append("           <tr> ");
		corpo.append("             <td colspan='3'  height='18' class='tdCabecalho'> ");
		corpo.append("              <STRONG>&nbsp;&nbsp;DETALHES DA ALTERAÇÃO</STRONG> ");
		corpo.append("             </td> ");
		corpo.append("           </tr> ");

		corpo.append("               <tr> ");
		corpo.append("                   <td colspan='2'  height='8' class='tdintranet2'></td> ");
		corpo.append("               </tr>      ");

		for (int i = 0; i < dadosAlterados.length; i++) {
			corpo.append("               <tr> ");
			corpo.append("                 <td height='25' width='30%' align='right' class='tdintranet2'> ");
			corpo.append("                   <STRONG>" + dadosAlterados[i][0] + ":&nbsp;</STRONG> ");
			corpo.append("                 </td> ");
			corpo.append("                 <td class='tdintranet2' width='70%'> ");
			corpo.append("                   " + "<STRONG>de:</STRONG> " + dadosAlterados[i][1]
					+ "                   " + "<br><STRONG>para:</STRONG> " + dadosAlterados[i][2]);
			corpo.append("                 </td> ");
			corpo.append("               </tr>    ");
			corpo.append("               <tr> ");
			corpo.append("                   <td colspan='2'  height='8' class='tdintranet2'></td> ");
			corpo.append("               </tr>      ");

		}
		corpo.append("               <tr> ");
		corpo.append("                   <td colspan='2'  height='8' class='tdintranet2'></td> ");
		corpo.append("               </tr>      ");

		corpo.append("               <tr> ");
		corpo.append("                 <td colspan='2'  height='3' class='tdIntranet'></td> ");
		corpo.append("               </tr>    ");

		corpo.append("               <tr> ");
		corpo.append("                 <td colspan='2' align='center' class='tdNormal'");
		corpo.append(
				"                    <br><br>Esta é uma mensagem automática, por favor não responda este e-mail.");
		corpo.append("                 </td>");
		corpo.append("               </tr>    ");
		corpo.append("         </table>     ");

		corpo.append(" </center><br><br> ");
		corpo.append("</body>");

		return corpo.toString();		
	}

	/**
	 * Envia mensagem de alterção para os participantes no Workflow de aprovação
	 *
	 * @param usuario,
	 *            requisicao, emailPara[]
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemAlteracao(Usuario usuario, Requisicao requisicao)
			throws RequisicaoPessoalException {

		try {
			// -- Objetos de controle
			RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();

			// -- Objetos
			List listEmail = new ArrayList();
			String[] listaEmails = null;
			String email = null;

			listaEmails = requisicaoAprovacaoControl.getEmailsEnvolvidosWorkFlow(requisicao);

			String assunto = "A Requisição Pessoal n° " + requisicao.getCodRequisicao()
					+ " foi analisada e alterada pela Gerência de Pessoal.";

			String mensagem = geraCorpoEmailAlteracao(requisicao.getCodRequisicao(), usuario.getChapa());

			// Adicionando lista de e-mail recebida como parâmetro
			for (int i = 0; i < listaEmails.length; i++) {
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
	 * Workflow de aprovação
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

			String assunto = "Retorno da Requisição n° " + requisicao.getCodRequisicao()
					+ " para o Solicitante (Homologação)";
			String mensagem = "<br>A Requisição de Pessoal N° <b>" + requisicao.getCodRequisicao()
					+ "</b> foi homologada pela Gerência de Pessoal (NEC) e encaminhada para análise de aprovação.<br><br>";

			// Adicionando lista de e-mail recebida como parâmetro
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
//			listaEmails = requisicaoAprovacaoControl.getEmailsHomologadoresGEP();
//			for (int i = 0; listaEmails != null && i < listaEmails.length; i++) {
//				listEmail.add(listaEmails[i]);
//			}

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
	 * Envia mensagem notificando o gerente da unidade responsável e o gerente
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

		String assunto = "Retorno da Requisição n° " + requisicao.getCodRequisicao()
				+ " para o Solicitante (Homologada)";
		String mensagem = "<br>A Requisição de Pessoal N° <b>" + requisicao.getCodRequisicao()
				+ "</b> foi homologada pela Gerência de Pessoal e encaminhada para análise de aprovação.<br><br>";

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
	 * Envia mensagem notificando a aprovação final da RP
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemAprovacao(Usuario usuario, Requisicao requisicao, String[] emailPara)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Retorno da Requisição n° " + requisicao.getCodRequisicao() + " para o Solicitante (Aprovada)";
		String mensagem = "A Requisição de Pessoal N° <b>" + requisicao.getCodRequisicao()
				+ "</b> foi analisada e aprovada pela Gerência de Pessoal.";
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem notificando a reprovação da RP
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemReprovacao(Usuario usuario, Requisicao requisicao, String[] emailPara,
			String dscMotivo) throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Retorno da Requisição n° " + requisicao.getCodRequisicao()
				+ " para o Solicitante (Reprovada)";
		String mensagem = "<br>A Requisição de Pessoal N° <b>" + requisicao.getCodRequisicao()
				+ "</b> foi analisada e reprovada, pelo(s) seguinte(s) motivos:<br><br>" + dscMotivo + "<br><br>";
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem notificando os usuários do Workflow que a RP foi estornada
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemEstorno(Usuario usuario, Requisicao requisicao, String[] emailPara)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Retorno da Requisição n° " + requisicao.getCodRequisicao() + " para o Solicitante (Estorno)";
		String mensagem = "A Requisição de Pessoal N° <b>" + requisicao.getCodRequisicao() + "</b> foi estornada.";
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia mensagem notificando os usuários com perfil de criação da unidade
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */
	public static void enviaMensagemSolicitarRevisao(Usuario usuario, Requisicao requisicao, String dscMotivo)
			throws RequisicaoPessoalException, AdmTIException {
		String assunto = "Retorno da Requisição n° " + requisicao.getCodRequisicao() + " para o Solicitante (Revisar)";
		String mensagem = "<br>Solicitação de revisão da Requisição de Pessoal N° <b>" + requisicao.getCodRequisicao()
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
		String assunto = "Retorno da Requisição n° " + requisicao.getCodRequisicao() + " para o Solicitante (Revisada)";
		String mensagem = "<br>A Requisição de Pessoal N° <b>" + requisicao.getCodRequisicao()
				+ "</b> foi revisada e encaminhada para análise.<br><br>";
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
		String assunto = "Cancelamento da Requisição n° " + requisicao.getCodRequisicao();
		String mensagem = "<br>A Requisição de Pessoal N° <b>" + requisicao.getCodRequisicao()
				+ "</b> foi cancelada pelo(s) seguinte(s) motivos:<br><br>" + dscMotivo + "<br><br>";
		enviaMensagem(usuario, requisicao, mensagem, emailPara, assunto);
	}

	/**
	 * Envia e-mail com remetente rpessoal@sp.senac.br
	 *
	 * @throws RequisicaoPessoalException,
	 *             AdmTIException
	 */

	public static void enviaMensagem(Usuario usuario, Requisicao requisicao, String mensagem, String[] emailPara,
			String assunto) throws RequisicaoPessoalException, AdmTIException {

		SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
		Email email = new Email();
		SistemaParametro smtp = null;
		String[] para = emailPara;
		String emailRemetente = usuario.getEmail();

		try {
			smtp = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "SMTP");
		} catch (Exception e) {
			throw new AdmTIException("Requisição de Pessoal: Erro ao enviar e-mail:", e.getMessage());
		}
		email.setSTMPServer(smtp.getVlrSistemaParametro());
		email.setTipoTexto("text/html");
		email.setAssunto(assunto);
		email.setRemetente(emailRemetente);
		email.setCorpoEmail(mensagem.contains("DETALHES DA ALTERAÇÃO")? mensagem :
				TemplateCorpoEmail.getCorpoEmail(requisicao, mensagem).toString());
		email.setParaVarios(para);

		try {
			email.enviarEmailRemetentesSimples();
		} catch (Exception e) {
			LOG.error(e.getMessage());
			System.out.println(e.getMessage());
		}
	}

	public static void enviaMensagem2(Usuario usuario, Requisicao requisicao, String mensagem, String[] emailPara,
			String assunto) throws RequisicaoPessoalException, AdmTIException {

		SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
		Email email = new Email();

		SistemaParametro smtp = null;
		String[] para = emailPara;
		String emailRemetente = usuario.getEmail();

		try {
			smtp = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "SMTP");
		} catch (Exception e) {
			throw new AdmTIException("Requisição de Pessoal: Erro ao enviar e-mail:", e.getMessage());
		}

		email.setSTMPServer(smtp.getVlrSistemaParametro());
		email.setTipoTexto("text/html");
		email.setRemetente(emailRemetente);
		email.setCorpoEmail(mensagem);

		String ambiente = PropertyResourceBundle.getBundle("properties.main").getString("ambiente");
		if (ambiente.equals("desenvolvimento")) {
			for (int i = 0; i < para.length; i++) {
				assunto = assunto + " / email:" + para[i];
			}
			String para_desenv[] = { "consultor.solucoes@sp.senac.br" };
			para = para_desenv;
		}

		email.setParaVarios(para);
		email.setAssunto(assunto);

		try {
			email.enviarEmailRemetentesSimples();
		} catch (Exception e) {
			LOG.error(e.getMessage());
			System.out.println(e.getMessage());
		}
	}

	/*
	 * public static void enviaMensagemCritica(String pagina, String mensagem,
	 * Usuario usuario) throws AdmTIException {
	 *
	 * SistemaParametroControl sistemaParametroControl = new
	 * SistemaParametroControl(); StringBuffer corpo = new StringBuffer(); Email
	 * email = new Email();
	 *
	 * SistemaParametro smtp = null; SistemaParametro emailRemetente = null;
	 * String[] para = { "marcus.soliveira@sp.senac.br" };
	 *
	 * try { smtp =
	 * sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.
	 * ID_SISTEMA, "SMTP"); emailRemetente =
	 * sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.
	 * ID_SISTEMA, "EMAIL_REMETENTE"); } catch (Exception e) { throw new
	 * AdmTIException("Requisição de Pessoal: Erro ao enviar e-mail:",
	 * e.getMessage()); }
	 *
	 * corpo.append("<b>Página :</b> " + pagina + "<BR><BR>");
	 * corpo.append("<b>Crítica:</b> " + mensagem + "<BR><BR>");
	 *
	 * if (usuario != null) { corpo.append("<b>Usuário:</b> " +
	 * usuario.getNome() + "<BR>"); corpo.append("<b>Chapa  :</b> " +
	 * usuario.getChapa() + "<BR>"); corpo.append("<b>Perfil :</b> " +
	 * usuario.getSistemaPerfil().getNomSistemaPerfil() + "<BR>");
	 * corpo.append("<b>Unidade:</b> " + usuario.getUnidade().getSigla()); }
	 *
	 * email.setSTMPServer(smtp.getVlrSistemaParametro());
	 * email.setTipoTexto("text/html");
	 * email.setAssunto("Crítica: Requisição de Pessoal");
	 * email.setRemetente(emailRemetente.getVlrSistemaParametro());
	 * email.setCorpoEmail(corpo.toString()); email.setParaVarios(para);
	 *
	 * try { email.enviarEmailRemetentesSimples(); } catch (Exception e) {
	 * System.out.println(e.getMessage()); } }
	 */
}