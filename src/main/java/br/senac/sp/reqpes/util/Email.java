package br.senac.sp.reqpes.util;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;
import java.util.PropertyResourceBundle;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;

import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.componente.control.SistemaParametroControl;

/**
 * Classe criada por Paulo Evaristo Rosa Dias Data.: 22/06/2005 Objetivo classe
 * para envio de e-mail
 */
public class Email {

	private String STMPServer;
	private String remetente;
	private String para;
	private String copiaPara;
	private String copiaOculta;
	private String[] paraVarios;
	private String[] copiasPara;
	private String[] copiasOcultas;
	private String assunto;
	private String corpoEmail;
	private String tipoTexto = "text/plain";

	public Email() {

	}

	public void enviarEmailSimples() throws AddressException, MessagingException, UnsupportedEncodingException, AdmTIException {
		enviarEmail("SIMPLES");
	}

	public void enviarEmailCC() throws AddressException, MessagingException, UnsupportedEncodingException, AdmTIException {
		enviarEmail("COPIA");
	}

	public void enviarEmailBCC() throws AddressException, MessagingException, UnsupportedEncodingException, AdmTIException {
		enviarEmail("COPIA_OCULTA");
	}

	public void enviarEmailCCBCC() throws AddressException, MessagingException, UnsupportedEncodingException, AdmTIException {
		enviarEmail("COPIA_E_COPIA_OCULTA");
	}

	public void enviarEmailRemetentesSimples() throws AddressException, MessagingException, AdmTIException, UnsupportedEncodingException {
		enviarEmailRemetentes("SIMPLES");
	}

	public void enviarEmailRemetentesCC() throws AddressException, MessagingException, AdmTIException, UnsupportedEncodingException {
		enviarEmailRemetentes("COPIA");
	}

	public void enviarEmailRemetentesBCC() throws AddressException, MessagingException, AdmTIException, UnsupportedEncodingException {
		enviarEmailRemetentes("COPIA_OCULTA");
	}

	public void enviarEmailRemetentesCCBCC() throws AddressException, MessagingException, AdmTIException, UnsupportedEncodingException {
		enviarEmailRemetentes("COPIA_E_COPIA_OCULTA");
	}

	private void enviarEmail(String tipo) throws AddressException, MessagingException, UnsupportedEncodingException, AdmTIException {
		Properties mailProps = new Properties();
		SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
		String ambiente = PropertyResourceBundle.getBundle("properties.main").getString("ambiente");
		String titulo_email=getAssunto();
		String seriaEnviado = "";
		mailProps.put("mail.smtp.host", ambiente.equals("desenvolvimento")?"localhost":getSTMPServer());
		Session mailSession = Session.getDefaultInstance(mailProps, null);
		Message message = new MimeMessage(mailSession);

		InternetAddress remetente = new InternetAddress(getRemetente());
		InternetAddress destinatario = new InternetAddress(getPara());
		
		List<String> emailsFiltrados = new ArrayList<String>();
		for (String e : paraVarios) {
			if (!emailsFiltrados.contains(e)) {
				emailsFiltrados.add(e.replace("NAO-ENVIA", ""));
			} 
		}
		
		paraVarios = Arrays.copyOf(paraVarios, emailsFiltrados.size());

		for (String email : emailsFiltrados) {
			paraVarios[emailsFiltrados.indexOf(email)] = email;
		}

		message.setFrom(remetente);
		message.setRecipient(Message.RecipientType.TO, destinatario);

		if (tipo.equals("COPIA")) {
			InternetAddress copia = new InternetAddress(getCopiaPara());
			message.setRecipient(Message.RecipientType.CC, copia);
		} else {
			if (tipo.equals("COPIA_OCULTA")) {
				InternetAddress copiaOculta = new InternetAddress(getCopiaOculta());
				message.setRecipient(Message.RecipientType.BCC, copiaOculta);
			} else {
				if (tipo.equals("COPIA_E_COPIA_OCULTA")) {
					InternetAddress copia = new InternetAddress(getCopiaPara());
					InternetAddress copiaOculta = new InternetAddress(getCopiaOculta());
					message.setRecipient(Message.RecipientType.CC, copia);
					message.setRecipient(Message.RecipientType.BCC, copiaOculta);
				}

			}
		}

		message.setSubject(MimeUtility.encodeText(getAssunto(),"utf-8","B"));
		message.setContent(corpoEmail, "text/html; charset=iso-8859-1");


		if (!ambiente.equals("producao")) {
			assunto = ambiente + " - " + getAssunto();

			message.setSubject(MimeUtility.encodeText(assunto,"utf-8","B"));
			seriaEnviado = " Em produção seria enviado para (" + getPara() + ")";

			String[] emails = sistemaParametroControl.getSistemaParametros("WHERE SP.NOM_PARAMETRO = 'EMAIL_TESTES' AND SP.COD_SISTEMA = 7 ")[0].getVlrSistemaParametro().split(",");
			InternetAddress[] destinatarios = new InternetAddress[emails.length];
			for (int i = 0; i < emails.length; i++) {
				destinatarios[i] = new InternetAddress(emails[i]);
			}

			message.setRecipients(Message.RecipientType.TO, (Address[])null);
			message.setRecipients(Message.RecipientType.TO, destinatarios);
			message.setRecipients(Message.RecipientType.CC, (Address[])null);
			message.setRecipients(Message.RecipientType.BCC, (Address[])null);
			message.setContent(corpoEmail + seriaEnviado, "text/html; charset=iso-8859-1");
		}



		Transport.send(message);
	}

	private void enviarEmailRemetentes(String tipo) throws AddressException, MessagingException, AdmTIException, UnsupportedEncodingException {

		// SE FOR DESENVOLVIMENTO MANDA PARA O PROGRAMADOR

		//recupera a variável de ambiente
		String ambiente = PropertyResourceBundle.getBundle("properties.main").getString("ambiente");
		String seriaEnviado = "";
		SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
		
		List<String> emailsFiltrados = new ArrayList<String>();
		for (String e : paraVarios) {
			if (!emailsFiltrados.contains(e)) {
				emailsFiltrados.add(e.replace("NAO-ENVIA", ""));
			} 
		}
		
		paraVarios = Arrays.copyOf(paraVarios, emailsFiltrados.size());

		for (String email : emailsFiltrados) {
			paraVarios[emailsFiltrados.indexOf(email)] = email;
		}

		Properties mailProps = new Properties();

		//altera a propridade do servidor quando o ambiente for desenvolvedor
		mailProps.put("mail.smtp.host", ambiente.equals("desenvolvimento")?"localhost":getSTMPServer());

		Session mailSession = Session.getDefaultInstance(mailProps, null);

		Message message = new MimeMessage(mailSession);
		message.setHeader("Content-Type", "text/html; charset=\"iso-8859-1\"");
		message.setHeader("Content-Transfer-Encoding", "quoted-printable");

		InternetAddress remetente = new InternetAddress(getRemetente());
		message.setFrom(remetente);
		String titulo_email=getAssunto();


		InternetAddress[] destinatarios = new InternetAddress[paraVarios.length];
		for (int idx = 0; idx < paraVarios.length; idx++) {
			destinatarios[idx] = new InternetAddress(paraVarios[idx]);
		}
		message.setRecipients(Message.RecipientType.TO, destinatarios);

		if (tipo.equals("COPIA")) {
			InternetAddress[] copias = new InternetAddress[copiasPara.length];
			for (int idx = 0; idx < paraVarios.length; idx++) {
				copias[idx] = new InternetAddress(copiasPara[idx]);
			}
			message.setRecipients(Message.RecipientType.CC, copias);
		} else {
			if (tipo.equals("COPIA_OCULTA")) {
				InternetAddress[] ocultas = new InternetAddress[copiasOcultas.length];
				for (int idx = 0; idx < ocultas.length; idx++) {
					ocultas[idx] = new InternetAddress(copiasOcultas[idx]);
				}
				message.setRecipients(Message.RecipientType.BCC, ocultas);
			} else {
				if (tipo.equals("COPIA_E_COPIA_OCULTA")) {
					InternetAddress[] copias = new InternetAddress[copiasPara.length];
					for (int idx = 0; idx < paraVarios.length; idx++) {
						copias[idx] = new InternetAddress(copiasPara[idx]);
					}
					message.setRecipients(Message.RecipientType.CC, copias);
					InternetAddress[] ocultas = new InternetAddress[copiasOcultas.length];
					for (int idx = 0; idx < ocultas.length; idx++) {
						ocultas[idx] = new InternetAddress(copiasOcultas[idx]);
					}
					message.setRecipients(Message.RecipientType.BCC, ocultas);
				}
			}
		}

		message.setSubject(titulo_email);
		message.setContent(corpoEmail, "text/html; charset=iso-8859-1");


		//alltera as propriedades caso não seja ambiente de produção
		if (!ambiente.equals("producao")) {
			//adiciona o nome do ambiente no assunto pra indicar que é um teste
			assunto = ambiente + " - " + getAssunto();

			seriaEnviado = " Em produção seria enviado para (";
			for (String e : paraVarios) {
				seriaEnviado += e.replace("NAO-ENVIA", "") + ",";
			}
			seriaEnviado += ")";

			message.setSubject(MimeUtility.encodeText(assunto,"utf-8","B"));

			//seta o destinatario de testes conforme o parametro
			String[] emails = sistemaParametroControl.getSistemaParametros("WHERE SP.NOM_PARAMETRO = 'EMAIL_TESTES' AND SP.COD_SISTEMA = 7 ")[0].getVlrSistemaParametro().split(",");
			destinatarios = new InternetAddress[emails.length];
			for (int i = 0; i < emails.length; i++) {
				destinatarios[i] = new InternetAddress(emails[i]);
			}

			//limpa os destinatarios
			message.setRecipients(Message.RecipientType.TO, (Address[])null);
			//seta o destinatarios de teste
			message.setRecipients(Message.RecipientType.TO, destinatarios);
			//limpa os destinatarios copiados
			message.setRecipients(Message.RecipientType.CC, (Address[])null);
			//limpa os destinatarios ocultos
			message.setRecipients(Message.RecipientType.BCC, (Address[])null);
			message.setContent(corpoEmail + seriaEnviado, "text/html; charset=iso-8859-1");
		}

		//comando que envia a mensagem
		Transport.send(message);
	}

	public void setSTMPServer(String STMPServer) {
		this.STMPServer = STMPServer;
	}

	public String getSTMPServer() {
		return STMPServer;
	}

	public void setRemetente(String remetente) {
		this.remetente = remetente;
	}

	public String getRemetente() {
		return remetente;
	}

	public void setPara(String para) {
		this.para = para;
	}

	public String getPara() {
		return para;
	}

	public void setCopiaPara(String copiaPara) {
		this.copiaPara = copiaPara;
	}

	public String getCopiaPara() {
		return copiaPara;
	}

	public void setCopiaOculta(String copiaOculta) {
		this.copiaOculta = copiaOculta;
	}

	public String getCopiaOculta() {
		return copiaOculta;
	}

	public void setAssunto(String assunto) {
		this.assunto = assunto;
	}

	public String getAssunto() {
		return assunto;
	}

	public void setCorpoEmail(String corpoEmail) {
		this.corpoEmail = corpoEmail;
	}

	public String getCorpoEmail() {
		return corpoEmail;
	}

	public void setParaVarios(String[] paraVarios) {
		this.paraVarios = paraVarios;
	}

	public String[] getParaVarios() {
		return paraVarios;
	}

	public void setCopiasPara(String[] copiasPara) {
		this.copiasPara = copiasPara;
	}

	public String[] getCopiasPara() {
		return copiasPara;
	}

	public void setCopiasOcultas(String[] copiasOcultas) {
		this.copiasOcultas = copiasOcultas;
	}

	public String[] getCopiasOcultas() {
		return copiasOcultas;
	}

	public void setTipoTexto(String tipoTexto) {
		this.tipoTexto = tipoTexto;
	}

	public String getTipoTexto() {
		return tipoTexto;
	}
}