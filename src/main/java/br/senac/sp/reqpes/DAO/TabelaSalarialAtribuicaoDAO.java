package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.TabelaSalarialAtribuicao;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 27/05/2009
 */
 
public class TabelaSalarialAtribuicaoDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public TabelaSalarialAtribuicaoDAO(){

  }

  /**
   * @return int
   * @param  tabelaSalarialAtribuicao
   * @Procedure PROCEDURE SP_DML_TAB_SALARIAL_ATRIBUICAO(P_IN_DML                 IN NUMBER
                                                        ,P_IN_COD_TABELA_SALARIAL IN OUT NUMBER
                                                        ,P_IN_COD_TABELA          IN NUMBER) IS
   */
   
   private int dmlTabelaSalarialAtribuicao(int tipoDML, TabelaSalarialAtribuicao tabelaSalarialAtribuicao) throws RequisicaoPessoalException{
    
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    String tipoTransacao = "";
    CallableStatement stmt = null;    
    
    switch(tipoDML){
      case -1 : tipoTransacao = "excluir" ; break;
      case  0 : tipoTransacao = "inserir" ; break;
    };
    
    try{
        stmt = transacao.getCallableStatement("{call SP_DML_TAB_SALARIAL_ATRIBUICAO(?,?,?)}");
        stmt.setInt(1,tipoDML); // 0 INSERT, -1 DELETE 
        stmt.setInt(2,tabelaSalarialAtribuicao.getCodTabelaSalarial());
        stmt.setInt(3,tabelaSalarialAtribuicao.getCodTabelaRHEV());
        
        // registrando parametro de saida
        stmt.registerOutParameter(2,Types.INTEGER);
        transacao.executeCallableStatement(stmt);
        
        if(tipoDML >= 0){
          sucesso = stmt.getInt(2);
        }
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a TabelaSalarialAtribuicao: \n" ,e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a TabelaSalarialAtribuicao: \n" ,e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com TabelaSalarialAtribuicao " ,e.getMessage());
      }
    }
     return sucesso;        
   }
   
   
  /**
   * @param tabelaSalarialAtribuicao
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_TAB_SALARIAL_ATRIBUICAO
  */
  public int gravaTabelaSalarialAtribuicao(TabelaSalarialAtribuicao tabelaSalarialAtribuicao) throws RequisicaoPessoalException{
     return this.dmlTabelaSalarialAtribuicao(0, tabelaSalarialAtribuicao);
  }


  /**
   * @param tabelaSalarialAtribuicao
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_TAB_SALARIAL_ATRIBUICAO
  */
  public int deletaTabelaSalarialAtribuicao(TabelaSalarialAtribuicao tabelaSalarialAtribuicao) throws RequisicaoPessoalException{
    return this.dmlTabelaSalarialAtribuicao(-1, tabelaSalarialAtribuicao);
  }


  /**
   * Retorna um array de objetos TabelaSalarialAtribuicao que satifaz a condição informada
   * @param condicao
   * @return array de objetos TabelaSalarialAtribuicao
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */

  public TabelaSalarialAtribuicao[] getTabelaSalarialAtribuicao(int codTabelaSalarial) throws RequisicaoPessoalException {
      StringBuffer sql = new StringBuffer();
      ArrayList listaTabelaSalarialAtribuicao = new ArrayList();
      TabelaSalarialAtribuicao tabelaSalarialAtribuicao = new TabelaSalarialAtribuicao();
      TabelaSalarialAtribuicao[] tabelaSalarialAtribuicaos = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      ResultSet rs = null;

      sql.append(" SELECT F_GET_SEL_TABELA_SALARIAL("+ codTabelaSalarial +", G.COD_TABELA) IND_SELECIONADO ");
      sql.append("       ,G.COD_TABELA ");
      sql.append("       ,G.DSC_TABELA ");
      sql.append(" FROM   reqpes.VW_RHEV_TABELA_SALARIAL G ");
      sql.append("       ,reqpes.TABELA_SALARIAL_ATRIBUICAO T ");
      sql.append(" WHERE  T.COD_TAB_SALARIAL_RHEV (+) = G.COD_TABELA ");
      sql.append(" AND    T.COD_TAB_SALARIAL (+) = " + codTabelaSalarial);
      sql.append(" ORDER  BY G.DSC_TABELA ");

      try{
         rs = transacao.getCursor(sql.toString());
         while(rs.next()){
            // Setando os atributos
            tabelaSalarialAtribuicao.setCodTabelaSalarial(codTabelaSalarial);
            tabelaSalarialAtribuicao.setCodTabelaRHEV(rs.getInt("COD_TABELA"));
            tabelaSalarialAtribuicao.setDscTabelaRHEV(rs.getString("DSC_TABELA"));
            tabelaSalarialAtribuicao.setIndSelecionado(rs.getString("IND_SELECIONADO"));
            
            // Adicionando na lista
            listaTabelaSalarialAtribuicao.add(tabelaSalarialAtribuicao);
            tabelaSalarialAtribuicao = new TabelaSalarialAtribuicao();
        }

        // Dimensionando o array
        tabelaSalarialAtribuicaos = new TabelaSalarialAtribuicao[listaTabelaSalarialAtribuicao.size()];

        // Transferindo a lista para o array
        listaTabelaSalarialAtribuicao.toArray(tabelaSalarialAtribuicaos);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("TabelaSalarialAtribuicaoDAO  \n -> Problemas na consulta de TabelaSalarialAtribuicao: \n\n " + sql.toString(), e.getMessage());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("TabelaSalarialAtribuicaoDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(), e.getMessage());
       }
    }
    return tabelaSalarialAtribuicaos;
   } 
}