package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.RequisicaoEstornoDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.RequisicaoEstorno;
import br.senac.sp.componente.model.Usuario;

public class RequisicaoEstornoControl{
  
  RequisicaoEstornoDAO requisicaoEstornoDAO;
  
   public RequisicaoEstornoControl(){
     requisicaoEstornoDAO = new RequisicaoEstornoDAO();
   }
  
   public int estornaRequisicao(RequisicaoEstorno requisicao, Usuario usuario) throws RequisicaoPessoalException{
      return requisicaoEstornoDAO.estornaRequisicao(requisicao, usuario);
   }  
   
   public String[][] getMatriz(String sql) throws RequisicaoPessoalException{
      return requisicaoEstornoDAO.getMatriz(sql);
   }    
   
   public String[][] getRequisicoesParaEstorno(String condicao) throws RequisicaoPessoalException{
      return requisicaoEstornoDAO.getRequisicoesParaEstorno(condicao);
   }
   
   public String[][] getComboCargosEstorno() throws RequisicaoPessoalException{
      return requisicaoEstornoDAO.getComboCargosEstorno();
   }  

   public String[][] getComboUnidadesEstorno() throws RequisicaoPessoalException{
      return requisicaoEstornoDAO.getComboUnidadesEstorno();
   }    
}