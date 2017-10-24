package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.RequisicaoPerfilDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.RequisicaoPerfil;

public class RequisicaoPerfilControl{

  RequisicaoPerfilDAO requisicaoPerfilDAO;
  
  public RequisicaoPerfilControl(){
    requisicaoPerfilDAO = new RequisicaoPerfilDAO();
  }

   public RequisicaoPerfil[] getRequisicaoPerfils() throws RequisicaoPessoalException{
      return requisicaoPerfilDAO.getRequisicaoPerfils();
   }

   public int gravaRequisicaoPerfil(RequisicaoPerfil requisicaoPerfil) throws RequisicaoPessoalException{
      return requisicaoPerfilDAO.gravaRequisicaoPerfil(requisicaoPerfil);
   }

   public int alteraRequisicaoPerfil(RequisicaoPerfil requisicaoPerfil) throws RequisicaoPessoalException{
      return requisicaoPerfilDAO.alteraRequisicaoPerfil(requisicaoPerfil);
   }

   public RequisicaoPerfil getRequisicaoPerfil(int idRequisicao) throws RequisicaoPessoalException{
      return requisicaoPerfilDAO.getRequisicaoPerfil(idRequisicao);
   }
 
   public RequisicaoPerfil[] getRequisicaoPerfils(String condicao) throws RequisicaoPessoalException{
      return requisicaoPerfilDAO.getRequisicaoPerfils(condicao);
   }   
   
   public String[][] getComboEscolaridade() throws RequisicaoPessoalException{
      return requisicaoPerfilDAO.getComboEscolaridade();
   }  
   
   public String[][] getComboArea() throws RequisicaoPessoalException{
      return requisicaoPerfilDAO.getComboDominioRecru("AREA_VAGA");
   }     

   public String[][] getComboNivelHierarquia() throws RequisicaoPessoalException{
      return requisicaoPerfilDAO.getComboDominioRecru("NIVEL_HIERARQUIA");
   }     

   public String[][] getComboFuncao() throws RequisicaoPessoalException{
      return requisicaoPerfilDAO.getComboFuncao();
   }  
   
}