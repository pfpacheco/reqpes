package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.GrupoNecDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.GrupoNec;
import br.senac.sp.componente.model.Usuario;


public class GrupoNecControl{

  GrupoNecDAO grupoNecDAO;
  
  public GrupoNecControl(){
    grupoNecDAO = new GrupoNecDAO();
  }

   public GrupoNec[] getGrupoNecs() throws RequisicaoPessoalException{
      return grupoNecDAO.getGrupoNecs();
   }

   public int gravaGrupoNec(GrupoNec grupoNec, Usuario usuario) throws RequisicaoPessoalException{
      return grupoNecDAO.gravaGrupoNec(grupoNec, usuario);
   }

   public int alteraGrupoNec(GrupoNec grupoNec, Usuario usuario) throws RequisicaoPessoalException{
      return grupoNecDAO.alteraGrupoNec(grupoNec, usuario);
   }

   public int deletaGrupoNec(GrupoNec grupoNec, Usuario usuario) throws RequisicaoPessoalException{
      return grupoNecDAO.deletaGrupoNec(grupoNec, usuario);
   }

   public GrupoNec getGrupoNec(int codGrupoNec) throws RequisicaoPessoalException{
      return grupoNecDAO.getGrupoNec(codGrupoNec);
   }

   public GrupoNec[] getGrupoNecs(String condicao) throws RequisicaoPessoalException{
      return grupoNecDAO.getGrupoNecs(condicao);
   }

   public String[][] getMatriz(String sql) throws RequisicaoPessoalException{
      return grupoNecDAO.getMatriz(sql);
   }     
   
   public String[] getLista(String sql) throws RequisicaoPessoalException{
      return grupoNecDAO.getLista(sql);
   }        
}