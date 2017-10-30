package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.GrupoNecUsuarioDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.GrupoNecUsuario;
import br.senac.sp.componente.model.Usuario;


public class GrupoNecUsuarioControl{

   GrupoNecUsuarioDAO grupoNecUsuarioDAO;
  
   public GrupoNecUsuarioControl(){
      grupoNecUsuarioDAO = new GrupoNecUsuarioDAO();
   }

   public int gravaGrupoNecUsuario(GrupoNecUsuario grupoNecUnidade, Usuario usuario) throws RequisicaoPessoalException{
      return grupoNecUsuarioDAO.gravaGrupoNecUsuario(grupoNecUnidade, usuario);
   }

   public int deletaGrupoNecUsuario(GrupoNecUsuario grupoNecUnidade, Usuario usuario) throws RequisicaoPessoalException{
      return grupoNecUsuarioDAO.deletaGrupoNecUsuario(grupoNecUnidade, usuario);
   }

   public GrupoNecUsuario[] getGrupoNecUsuarios() throws RequisicaoPessoalException{
      return grupoNecUsuarioDAO.getGrupoNecUsuarios("");
   }

   public GrupoNecUsuario getGrupoNecUsuario(int chapa) throws RequisicaoPessoalException{
      return grupoNecUsuarioDAO.getGrupoNecUsuario(chapa);
   }

   public String[][] getComboUsuarios() throws RequisicaoPessoalException{
      return grupoNecUsuarioDAO.getComboUsuarios();
   }
   
   public String[][] getGruposNecByUsuario(int chapa) throws RequisicaoPessoalException{
      return grupoNecUsuarioDAO.getGruposNecByUsuario(chapa);
   }
   
   public String[][] getUnidadesByUsuario(int chapa) throws RequisicaoPessoalException{
      return grupoNecUsuarioDAO.getUnidadesByUsuario(chapa);
   }
   
   public String[][] getUsuariosByUnidade(String codUnidade) throws RequisicaoPessoalException{
      return grupoNecUsuarioDAO.getUsuariosByUnidade(codUnidade);
   }
}