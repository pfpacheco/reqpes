package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.RequisicaoBaixaDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.RequisicaoBaixa;
import br.senac.sp.componente.model.Usuario;

public class RequisicaoBaixaControl{

  RequisicaoBaixaDAO requisicaoBaixaDAO;
  
  public RequisicaoBaixaControl(){
    requisicaoBaixaDAO = new RequisicaoBaixaDAO();
  }
  
   public int gravaRequisicaoBaixa(RequisicaoBaixa requisicao, Usuario usuario) throws RequisicaoPessoalException{
      return requisicaoBaixaDAO.gravaRequisicaoBaixa(requisicao, usuario);
   }  
   
   public String[][] getMatriz(String sql) throws RequisicaoPessoalException{
      return requisicaoBaixaDAO.getMatriz(sql);
   }    
   
   public String[][] getRequisicoesParaBaixa(String condicao) throws RequisicaoPessoalException{
      return requisicaoBaixaDAO.getRequisicoesParaBaixa(condicao);
   }
   
   public String[][] getRequisicoesParaBaixaExpirando(int contratacaoValidade, int expiracaoAviso, String condicao) throws RequisicaoPessoalException{         
      return requisicaoBaixaDAO.getRequisicoesParaBaixaExpirando(contratacaoValidade, expiracaoAviso, condicao);
   }
  
   public String[][] getComboCargosBaixa() throws RequisicaoPessoalException{
      return requisicaoBaixaDAO.getComboCargosBaixa();
   }  

   public String[][] getComboUnidadesBaixa() throws RequisicaoPessoalException{
      return requisicaoBaixaDAO.getComboUnidadesBaixa();
   }  
}