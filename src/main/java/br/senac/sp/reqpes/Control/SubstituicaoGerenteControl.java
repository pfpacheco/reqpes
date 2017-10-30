package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.reqpes.DAO.SubstituicaoGerenteDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.SubstituicaoGerente;
import br.senac.sp.componente.model.Usuario;

public class SubstituicaoGerenteControl{
  
  SubstituicaoGerenteDAO substituicaoGerenteDAO;
  
  public SubstituicaoGerenteControl(){
    substituicaoGerenteDAO = new SubstituicaoGerenteDAO();
  }
  
   public SubstituicaoGerente[] getSubstituicaoGerentes() throws RequisicaoPessoalException, AdmTIException{
      return substituicaoGerenteDAO.getSubstituicaoGerentes();
   }

   public int gravaSubstituicaoGerente(SubstituicaoGerente substituicaoGerente, Usuario usuario) throws RequisicaoPessoalException{
      return substituicaoGerenteDAO.gravaSubstituicaoGerente(substituicaoGerente, usuario);
   }

   public int alteraSubstituicaoGerente(SubstituicaoGerente substituicaoGerente, Usuario usuario) throws RequisicaoPessoalException{
      return substituicaoGerenteDAO.alteraSubstituicaoGerente(substituicaoGerente, usuario);
   }

   public SubstituicaoGerente getSubstituicaoGerenteAtual(String codUnidade) throws RequisicaoPessoalException, AdmTIException{
      return substituicaoGerenteDAO.getSubstituicaoGerenteAtual(codUnidade);
   }
 
   public SubstituicaoGerente[] getSubstituicaoGerentes(String condicao) throws RequisicaoPessoalException, AdmTIException{
      return substituicaoGerenteDAO.getSubstituicaoGerentes(condicao);
   }

   public String[][] getMatriz(String sql) throws RequisicaoPessoalException{
      return substituicaoGerenteDAO.getMatriz(sql);
   }     
   
   public String[] getLista(String sql) throws RequisicaoPessoalException{
      return substituicaoGerenteDAO.getLista(sql);
   }      
   
   public String[][] getComboUnidades() throws RequisicaoPessoalException{
      return substituicaoGerenteDAO.getComboUnidades();
   }  
}