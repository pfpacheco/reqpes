package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.InstrucaoAtribuicao;

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
 
public class InstrucaoAtribuicaoDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public InstrucaoAtribuicaoDAO(){

  }

  /**
   * @return int
   * @param  instrucaoAtribuicao, usuario
   * @Procedure PROCEDURE SP_DML_INSTRUCAO_ATRIBUICAO(P_IN_DML           IN NUMBER
                                                     ,P_IN_COD_INSTRUCAO IN OUT NUMBER
                                                     ,P_IN_COD_UNIDADE   IN VARCHAR2) IS
   */
   
   private int dmlInstrucaoAtribuicao(int tipoDML, InstrucaoAtribuicao instrucaoAtribuicao) throws RequisicaoPessoalException{
    
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    String tipoTransacao = "";
    CallableStatement stmt = null;
    
    switch(tipoDML){
      case -1 : tipoTransacao = "excluir" ; break;
      case  0 : tipoTransacao = "inserir" ; break;
    };
    
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_INSTRUCAO_ATRIBUICAO(?,?,?)}");
        stmt.setInt(1,tipoDML); // 0 INSERT, -1 DELETE 
        stmt.setInt(2,instrucaoAtribuicao.getCodInstrucao());
        stmt.setString(3,instrucaoAtribuicao.getCodUnidade());
        
        // registrando parametro de saida
        stmt.registerOutParameter(2,Types.INTEGER);
        transacao.executeCallableStatement(stmt);
        
        if(tipoDML >= 0){
          sucesso = stmt.getInt(2);
        }       
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a InstrucaoAtribuicao: \n" ,e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a InstrucaoAtribuicao: \n" ,e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com InstrucaoAtribuicao " ,e.getMessage());
      }
    }
     return sucesso;        
   }
   
   
  /**
   * @param instrucaoAtribuicao
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_INSTRUCAO_ATRIBUICAO
  */
  public int gravaInstrucaoAtribuicao(InstrucaoAtribuicao instrucaoAtribuicao) throws RequisicaoPessoalException{
     return this.dmlInstrucaoAtribuicao(0, instrucaoAtribuicao);
  }


  /**
   * @param instrucaoAtribuicao
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_INSTRUCAO_ATRIBUICAO
  */
  public int deletaInstrucaoAtribuicao(InstrucaoAtribuicao instrucaoAtribuicao) throws RequisicaoPessoalException{
    return this.dmlInstrucaoAtribuicao(-1, instrucaoAtribuicao);
  }


  /**
   * Retorna um array de objetos InstrucaoAtribuicao que satifaz a condição informada
   * @param condicao
   * @return array de objetos InstrucaoAtribuicao
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */

  public InstrucaoAtribuicao[] getInstrucaoAtribuicao(int codInstrucao) throws RequisicaoPessoalException {
      StringBuffer sql = new StringBuffer();
      ArrayList listaInstrucaoAtribuicao = new ArrayList();
      InstrucaoAtribuicao instrucaoAtribuicao = new InstrucaoAtribuicao();
      InstrucaoAtribuicao[] instrucaoAtribuicaos = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      ResultSet rs = null;

      sql.append(" SELECT F_GET_SEL_INSTRUCAO_ATRIBUICAO(" + codInstrucao + ", UO.CODIGO) AS IND_SELECIONADO ");
      sql.append("       ,UO.CODIGO ");
      sql.append("       ,UO.SIGLA||' - '||UO.CODIGO AS SIGLA");
      sql.append("       ,UO.DESCRICAO ");    
      sql.append("       ,UD.VALOR ");    
      sql.append(" FROM   UNIDADES_ORGANIZACIONAIS UO ");
      sql.append("       ,UNIORG_DADO_ADICIONAL    UD ");
      sql.append(" WHERE  UO.CODIGO_PAI = UD.COD_UNIORG ");
      sql.append(" AND    UD.TDAU_CODIGO = 206 ");
      sql.append(" AND    UO.NIVEL = 2 ");
      sql.append(" AND    UO.DATA_ENCERRAMENTO IS NULL ");
      sql.append(" AND    UO.CODIGO NOT IN ('SA', 'SO', 'SD', 'SU') ");
      sql.append(" ORDER BY UO.SIGLA ");

      try{
         rs = transacao.getCursor(sql.toString());
         while(rs.next()){
             // Setando os atributos
             instrucaoAtribuicao.setCodInstrucao(codInstrucao);
             instrucaoAtribuicao.setCodUnidade(rs.getString("CODIGO"));
             instrucaoAtribuicao.setDscUnidade(rs.getString("DESCRICAO"));
             instrucaoAtribuicao.setIndSelecionado(rs.getString("IND_SELECIONADO"));
             instrucaoAtribuicao.setSiglaUnidade(rs.getString("SIGLA"));
             instrucaoAtribuicao.setIndLocalUnidade(rs.getString("VALOR"));
            
            // Adicionando na lista
            listaInstrucaoAtribuicao.add(instrucaoAtribuicao);
            instrucaoAtribuicao = new InstrucaoAtribuicao();
        }

        // Dimensionando o array
        instrucaoAtribuicaos = new InstrucaoAtribuicao[listaInstrucaoAtribuicao.size()];

        // Transferindo a lista para o array
        listaInstrucaoAtribuicao.toArray(instrucaoAtribuicaos);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("InstrucaoAtribuicaoDAO  \n -> Problemas na consulta de InstrucaoAtribuicao: \n\n " + sql.toString(), e.getMessage());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("InstrucaoAtribuicaoDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(), e.getMessage());
       }
    }
    return instrucaoAtribuicaos;
   } 
}