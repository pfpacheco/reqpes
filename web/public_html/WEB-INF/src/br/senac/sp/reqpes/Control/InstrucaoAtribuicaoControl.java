package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.InstrucaoAtribuicaoDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.InstrucaoAtribuicao;

public class InstrucaoAtribuicaoControl{

  InstrucaoAtribuicaoDAO instrucaoAtribuicaoDAO;
  
  public InstrucaoAtribuicaoControl(){
    instrucaoAtribuicaoDAO = new InstrucaoAtribuicaoDAO();
  }
  
  public int gravaInstrucaoAtribuicao(InstrucaoAtribuicao atribuicao) throws RequisicaoPessoalException{
    return instrucaoAtribuicaoDAO.gravaInstrucaoAtribuicao(atribuicao);
  }
  
  public int deletaInstrucaoAtribuicao(InstrucaoAtribuicao atribuicao) throws RequisicaoPessoalException{
    return instrucaoAtribuicaoDAO.deletaInstrucaoAtribuicao(atribuicao);
  }
  
  public InstrucaoAtribuicao[] getInstrucaoAtribuicao(int codInstrucao) throws RequisicaoPessoalException{
    return instrucaoAtribuicaoDAO.getInstrucaoAtribuicao(codInstrucao);
  }
}