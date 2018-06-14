package br.senac.sp.reqpes.util;

import java.io.UnsupportedEncodingException;
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
			message.setRecipient(Message.RecipientType.TO,
					new InternetAddress(sistemaParametroControl.getSistemaParametros("WHERE SP.NOM_PARAMETRO = 'EMAIL_TESTES'")[0].getVlrSistemaParametro()));
			message.setRecipients(Message.RecipientType.CC, (Address[])null);
			message.setRecipients(Message.RecipientType.BCC, (Address[])null);
			message.setContent(corpoEmail + seriaEnviado, "text/html; charset=iso-8859-1");
		}



		Transport.send(message);
	}

	private void enviarEmailRemetentes(String tipo) throws AddressException, MessagingException, AdmTIException, UnsupportedEncodingException {

		// SE FOR DESENVOLVIMENTO MANDA PARA O PROGRAMADOR
		String ambiente = PropertyResourceBundle.getBundle("properties.main").getString("ambiente");
		String seriaEnviado = "";
		SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();


		Properties mailProps = new Properties();
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

		if (!ambiente.equals("producao")) {
			assunto = ambiente + " - " + getAssunto();

			seriaEnviado = " Em produção seria enviado para (";
			for (String e : paraVarios) {
				seriaEnviado += e.replace("NAO-ENVIA", "") + ",";
			}
			seriaEnviado += ")";

			message.setSubject(MimeUtility.encodeText(assunto,"utf-8","B"));
			message.setRecipients(Message.RecipientType.TO, (Address[])null);
			message.setRecipient(Message.RecipientType.TO,
					new InternetAddress(sistemaParametroControl.getSistemaParametros("WHERE SP.NOM_PARAMETRO = 'EMAIL_TESTES'")[0].getVlrSistemaParametro()));
			message.setRecipients(Message.RecipientType.CC, (Address[])null);
			message.setRecipients(Message.RecipientType.BCC, (Address[])null);
			message.setContent(corpoEmail + seriaEnviado, "text/html; charset=iso-8859-1");
		}

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