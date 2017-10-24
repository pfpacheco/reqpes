package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.UsuarioAvisoEmailDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.UsuarioAvisoEmail;
import br.senac.sp.componente.model.Usuario;

public class UsuarioAvisoEmailControl{
  
  UsuarioAvisoEmailDAO usuarioAvisoEmailDAO;
  
  public UsuarioAvisoEmailControl(){
    usuarioAvisoEmailDAO = new UsuarioAvisoEmailDAO();
  }
  
   public UsuarioAvisoEmail[] getUsuarioAvisoEmails() throws RequisicaoPessoalException{
      return usuarioAvisoEmailDAO.getUsuarioAvisoEmails();
   }

   public int gravaUsuarioAvisoEmail(UsuarioAvisoEmail usuarioAvisoEmail, Usuario usuario) throws RequisicaoPessoalException{
      return usuarioAvisoEmailDAO.gravaUsuarioAvisoEmail(usuarioAvisoEmail, usuario);
   }

   public int deletaUsuarioAvisoEmail(UsuarioAvisoEmail usuarioAvisoEmail, Usuario usuario) throws RequisicaoPessoalException{
      return usuarioAvisoEmailDAO.deletaUsuarioAvisoEmail(usuarioAvisoEmail, usuario);
   }
   
   public UsuarioAvisoEmail getUsuarioAvisoEmail(int chapa) throws RequisicaoPessoalException{
      return usuarioAvisoEmailDAO.getUsuarioAvisoEmail(chapa);
   }
 
   public UsuarioAvisoEmail[] getUsuarioAvisoEmails(String condicao) throws RequisicaoPessoalException{
      return usuarioAvisoEmailDAO.getUsuarioAvisoEmails(condicao);
   }

   public String[][] getComboUnidades() throws RequisicaoPessoalException{
      return usuarioAvisoEmailDAO.getComboUnidades();
   }     

   public String[][] getTipoAvisoUsuario(int chapa) throws RequisicaoPessoalException{
      return usuarioAvisoEmailDAO.getTipoAvisoUsuario(chapa);
   }  
   
   public String[][] getComboUsuarios(String codUnidade) throws RequisicaoPessoalException{
      return usuarioAvisoEmailDAO.getComboUsuarios(codUnidade);
   }  
   
   public String[] getEmailsUsuariosAviso(int codCargo) throws RequisicaoPessoalException{
      return usuarioAvisoEmailDAO.getEmailsUsuariosAviso(codCargo);
   }  
}