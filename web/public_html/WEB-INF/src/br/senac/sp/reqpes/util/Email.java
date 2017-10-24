package br.senac.sp.reqpes.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.*;

/**
 * Classe criada por Paulo Evaristo Rosa Dias
 * Data.: 22/06/2005
 * Objetivo classe para envio de e-mail
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
   
   public void enviarEmailSimples()throws AddressException, MessagingException{
     enviarEmail("SIMPLES");
   }
   
   public void enviarEmailCC()throws AddressException, MessagingException{
     enviarEmail("COPIA");
   }
   
   public void enviarEmailBCC()throws AddressException, MessagingException{
     enviarEmail("COPIA_OCULTA");
   }
   
   public void enviarEmailCCBCC()throws AddressException, MessagingException{
     enviarEmail("COPIA_E_COPIA_OCULTA");
   }
    public void enviarEmailRemetentesSimples()throws AddressException, MessagingException{
     enviarEmailRemetentes("SIMPLES");
   }
   
   public void enviarEmailRemetentesCC()throws AddressException, MessagingException{
     enviarEmailRemetentes("COPIA");
   }
   
   public void enviarEmailRemetentesBCC()throws AddressException, MessagingException{
     enviarEmailRemetentes("COPIA_OCULTA");
   }
   
   public void enviarEmailRemetentesCCBCC()throws AddressException, MessagingException{
     enviarEmailRemetentes("COPIA_E_COPIA_OCULTA");
   }
   private void enviarEmail(String tipo)throws AddressException, MessagingException{
     
     Properties mailProps = new Properties();
     //definição do mailserver
     mailProps.put("mail.smtp.host", getSTMPServer());
     
     Session mailSession = Session.getDefaultInstance(mailProps, null);
  
     Message message = new MimeMessage (mailSession);
     
     InternetAddress remetente    = new InternetAddress (getRemetente());
     InternetAddress destinatario = new InternetAddress (getPara());
     
     message.setFrom(remetente);
     message.setRecipient( Message.RecipientType.TO , destinatario );  

     if(tipo.equals("COPIA")){
       InternetAddress copia        = new InternetAddress (getCopiaPara());
       message.setRecipient(Message.RecipientType.CC , copia );
     }else{
       if(tipo.equals("COPIA_OCULTA")){
          InternetAddress copiaOculta  = new InternetAddress (getCopiaOculta());
          message.setRecipient( Message.RecipientType.BCC, copiaOculta );
       }else{
          if(tipo.equals("COPIA_E_COPIA_OCULTA")){
            InternetAddress copia        = new InternetAddress (getCopiaPara());
            InternetAddress copiaOculta  = new InternetAddress (getCopiaOculta());
            message.setRecipient(Message.RecipientType.CC , copia );
            message.setRecipient( Message.RecipientType.BCC, copiaOculta );
          }
         
       }
     }
    
     message.setSubject (getAssunto());
     message.setContent (corpoEmail, this.tipoTexto);

     Transport.send (message);
   }
   
  private void enviarEmailRemetentes(String tipo)throws AddressException, MessagingException{
     
     Properties mailProps = new Properties();
     //definição do mailserver
     mailProps.put("mail.smtp.host", getSTMPServer());
     
     Session mailSession = Session.getDefaultInstance(mailProps, null);
  
     Message message = new MimeMessage (mailSession);
     
     InternetAddress remetente    = new InternetAddress (getRemetente());
     message.setFrom(remetente);
     
     InternetAddress[] destinatarios = new InternetAddress[paraVarios.length];
     for(int idx=0;idx<paraVarios.length;idx++){
       destinatarios[idx] = new InternetAddress (paraVarios[idx]);    
     }
     message.setRecipients(Message.RecipientType.TO , destinatarios );  
     

     if(tipo.equals("COPIA")){
       InternetAddress[] copias = new InternetAddress[copiasPara.length];
       for(int idx=0;idx<paraVarios.length;idx++){
         copias[idx] = new InternetAddress(copiasPara[idx]);
       }
       message.setRecipients(Message.RecipientType.CC,copias);
     }else{
       if(tipo.equals("COPIA_OCULTA")){
          InternetAddress[] ocultas = new InternetAddress[copiasOcultas.length];
          for(int idx=0;idx<ocultas.length;idx++){
             ocultas[idx] = new InternetAddress(copiasOcultas[idx]);
          }
          message.setRecipients( Message.RecipientType.BCC, ocultas );
       }else{
          if(tipo.equals("COPIA_E_COPIA_OCULTA")){
             InternetAddress[] copias = new InternetAddress[copiasPara.length];
             for(int idx=0;idx<paraVarios.length;idx++){
               copias[idx] = new InternetAddress(copiasPara[idx]);
             }
             message.setRecipients(Message.RecipientType.CC,copias);
             InternetAddress[] ocultas = new InternetAddress[copiasOcultas.length];
             for(int idx=0;idx<ocultas.length;idx++){
                ocultas[idx] = new InternetAddress(copiasOcultas[idx]);
             }
             message.setRecipients( Message.RecipientType.BCC, ocultas );
          }
       }
     }
    
     message.setSubject (getAssunto());
     message.setContent (corpoEmail, this.tipoTexto);

     Transport.send (message);
   }
   

  public void setSTMPServer(String STMPServer)
  {
    this.STMPServer = STMPServer;
  }


  public String getSTMPServer()
  {
    return STMPServer;
  }


  public void setRemetente(String remetente)
  {
    this.remetente = remetente;
  }


  public String getRemetente()
  {
    return remetente;
  }


  public void setPara(String para)
  {
    this.para = para;
  }


  public String getPara()
  {
    return para;
  }


  public void setCopiaPara(String copiaPara)
  {
    this.copiaPara = copiaPara;
  }


  public String getCopiaPara()
  {
    return copiaPara;
  }


  public void setCopiaOculta(String copiaOculta)
  {
    this.copiaOculta = copiaOculta;
  }


  public String getCopiaOculta()
  {
    return copiaOculta;
  }


  public void setAssunto(String assunto)
  {
    this.assunto = assunto;
  }


  public String getAssunto()
  {
    return assunto;
  }


  public void setCorpoEmail(String corpoEmail)
  {
    this.corpoEmail = corpoEmail;
  }


  public String getCorpoEmail()
  {
    return corpoEmail;
  }


  public void setParaVarios(String[] paraVarios)
  {
    this.paraVarios = paraVarios;
  }


  public String[] getParaVarios()
  {
    return paraVarios;
  }


  public void setCopiasPara(String[] copiasPara)
  {
    this.copiasPara = copiasPara;
  }


  public String[] getCopiasPara()
  {
    return copiasPara;
  }


  public void setCopiasOcultas(String[] copiasOcultas)
  {
    this.copiasOcultas = copiasOcultas;
  }


  public String[] getCopiasOcultas()
  {
    return copiasOcultas;
  }


  public void setTipoTexto(String tipoTexto)
  {
    this.tipoTexto = tipoTexto;
  }


  public String getTipoTexto()
  {
    return tipoTexto;
  }
}