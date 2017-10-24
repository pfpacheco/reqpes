package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.TabelaSalarialAtribuicaoDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.TabelaSalarialAtribuicao;

public class TabelaSalarialAtribuicaoControl{

  TabelaSalarialAtribuicaoDAO tabelaSalarialAtribuicaoDAO;
  
  public TabelaSalarialAtribuicaoControl(){
    tabelaSalarialAtribuicaoDAO = new TabelaSalarialAtribuicaoDAO();
  }
  
  public int gravaTabelaSalarialAtribuicao(TabelaSalarialAtribuicao tabelaSalarialAtribuicao) throws RequisicaoPessoalException{
    return tabelaSalarialAtribuicaoDAO.gravaTabelaSalarialAtribuicao(tabelaSalarialAtribuicao);
  }
  
  public int deletaTabelaSalarialAtribuicao(TabelaSalarialAtribuicao tabelaSalarialAtribuicao) throws RequisicaoPessoalException{
    return tabelaSalarialAtribuicaoDAO.deletaTabelaSalarialAtribuicao(tabelaSalarialAtribuicao);
  }
  
  public TabelaSalarialAtribuicao[] getTabelaSalarialAtribuicao(int codTabelaSalarial) throws RequisicaoPessoalException{
    return tabelaSalarialAtribuicaoDAO.getTabelaSalarialAtribuicao(codTabelaSalarial);
  }
}