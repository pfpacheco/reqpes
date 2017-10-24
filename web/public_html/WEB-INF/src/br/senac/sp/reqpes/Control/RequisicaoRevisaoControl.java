package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.RequisicaoRevisaoDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.RequisicaoRevisao;
import br.senac.sp.componente.model.Usuario;
  
public class RequisicaoRevisaoControl{

  RequisicaoRevisaoDAO requisicaoRevisaoDAO;
  
  public RequisicaoRevisaoControl(){
    requisicaoRevisaoDAO = new RequisicaoRevisaoDAO();
  }
  
   public int gravaRequisicaoRevisao(RequisicaoRevisao requisicao, Usuario usuario) throws RequisicaoPessoalException{
      return requisicaoRevisaoDAO.gravaRequisicaoRevisao(requisicao, usuario);
   }  

   public int alteraRequisicaoRevisao(RequisicaoRevisao requisicao, Usuario usuario, boolean isPerfilHOM) throws RequisicaoPessoalException{
      return requisicaoRevisaoDAO.alteraRequisicaoRevisao(requisicao, usuario, (isPerfilHOM ? 1 : 0));
   } 
   
   public String[][] getMatriz(String sql) throws RequisicaoPessoalException{
      return requisicaoRevisaoDAO.getMatriz(sql);
   }    
   
   public String[][] getRequisicoesParaRevisao(int codUnidade, String todasUnidades) throws RequisicaoPessoalException{
      return requisicaoRevisaoDAO.getRequisicoesParaRevisao(codUnidade, todasUnidades);
   }
   
   public RequisicaoRevisao[] getDadosRevisao(int codRequisicao) throws RequisicaoPessoalException{
      return requisicaoRevisaoDAO.getDadosRevisao(codRequisicao);
   }
   
   public int getQtdRevisoes(int codRequisicao) throws RequisicaoPessoalException{
      return requisicaoRevisaoDAO.getQtdRevisoes(codRequisicao);
   }   
}