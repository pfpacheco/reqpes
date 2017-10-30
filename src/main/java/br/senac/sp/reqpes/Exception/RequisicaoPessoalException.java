package br.senac.sp.reqpes.Exception;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

import br.senac.sp.componente.util.Email;
import br.senac.sp.reqpes.Interface.Config;

/**
 * @author Thiago Lima Coutinho
 * @date 11/09/2008
 * @version 1
 * @since
 */
public class RequisicaoPessoalException extends Exception {

	private static final long serialVersionUID = 1L;

	public RequisicaoPessoalException(String msgErro) {
		super(msgErro);
	}

	public RequisicaoPessoalException(String msgErro, String comando) {
		super(msgErro);
		enviaMensagem(msgErro + "\n\n" + comando);
	}

	public RequisicaoPessoalException(String msgErro, Exception exception) {
		super(msgErro);
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		exception.printStackTrace(pw);

		enviaMensagem(msgErro + "\n\n" + "" + sw.toString());
	}

	public RequisicaoPessoalException(Exception erro) {
		super(erro.getMessage());
	}

	public void enviaMensagem(String msg) {
		String[] para = { "GrupoGES-SistemasTecnologia@sp.senac.br" };
		Email email = new Email();
		ResourceBundle main = PropertyResourceBundle.getBundle("properties.main");
		String smtp = main.getString("smtp");
		email.setSTMPServer(smtp);
		email.setAssunto("ERRO: Requisição de Pessoal (" + main.getString("ambiente") + ")");
		email.setRemetente(Config.EMAIL_ERRO);
		email.setCorpoEmail(msg);
		email.setParaVarios(para);
		try {
			email.enviarEmailRemetentesSimples();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
}