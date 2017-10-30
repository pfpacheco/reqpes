package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.TabelaSalarialDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.TabelaSalarial;
import br.senac.sp.componente.model.Usuario;


public class TabelaSalarialControl{

  TabelaSalarialDAO tabelaSalarialDAO;
  
  public TabelaSalarialControl(){
    tabelaSalarialDAO = new TabelaSalarialDAO();
  }

   public TabelaSalarial[] getTabelaSalarials() throws RequisicaoPessoalException{
      return tabelaSalarialDAO.getTabelaSalarials();
   }

   public int gravaTabelaSalarial(TabelaSalarial tabelaSalarial, Usuario usuario) throws RequisicaoPessoalException{
      return tabelaSalarialDAO.gravaTabelaSalarial(tabelaSalarial, usuario);
   }

   public int alteraTabelaSalarial(TabelaSalarial tabelaSalarial, Usuario usuario) throws RequisicaoPessoalException{
      return tabelaSalarialDAO.alteraTabelaSalarial(tabelaSalarial, usuario);
   }

   public int deletaTabelaSalarial(TabelaSalarial tabelaSalarial, Usuario usuario) throws RequisicaoPessoalException{
      return tabelaSalarialDAO.deletaTabelaSalarial(tabelaSalarial, usuario);
   }

   public TabelaSalarial getTabelaSalarial(int codTabelaSalarial) throws RequisicaoPessoalException{
      return tabelaSalarialDAO.getTabelaSalarial(codTabelaSalarial);
   }
 
   public TabelaSalarial[] getTabelaSalarials(String condicao) throws RequisicaoPessoalException{
      return tabelaSalarialDAO.getTabelaSalarials(condicao);
   }

   public String[][] getMatriz(String sql) throws RequisicaoPessoalException{
      return tabelaSalarialDAO.getMatriz(sql);
   }     
   
   public String[] getLista(String sql) throws RequisicaoPessoalException{
      return tabelaSalarialDAO.getLista(sql);
   }  
}