package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.TabelaSalarial;

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
 
public class TabelaSalarialDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public TabelaSalarialDAO(){

  }

  /**
   * Retorna todas as tabelaSalarials cadastradas no sistema
   * @param  tabelaSalarial
   * @return TabelaSalarial[]
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public TabelaSalarial[] getTabelaSalarials() throws RequisicaoPessoalException {
    return getTabelaSalarials("");
  }

  /**
   * @return int
   * @param  tabelaSalarial, usuario
   * @Procedure PROCEDURE SP_DML_TABELA_SALARIAL(P_IN_DML                    IN NUMBER
                                                ,P_IN_COD_TAB_SALARIAL       IN OUT NUMBER
                                                ,P_IN_DSC_TAB_SALARIAL       IN VARCHAR2
                                                ,P_IN_IND_ATIVO              IN VARCHAR2
                                                ,P_IN_IND_EXIBE_AREA_SUBAREA IN VARCHAR2
                                                ,P_IN_USUARIO                IN VARCHAR2) IS
   */
   
   private int dmlTabelaSalarial(int tipoDML, TabelaSalarial tabelaSalarial, Usuario usuario) throws RequisicaoPessoalException{
    
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    String tipoTransacao = "";
    CallableStatement stmt = null;
    
    switch(tipoDML){
      case -1 : tipoTransacao = "excluir" ; break;
      case  0 : tipoTransacao = "inserir" ; break;
      case  1 : tipoTransacao = "alterar" ; break;
    };
    
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_TABELA_SALARIAL(?,?,?,?,?,?)}");
        stmt.setInt(1,tipoDML); // 0 INSERT, 1 UPDATE, -1 DELETE 
        stmt.setInt(2,tabelaSalarial.getCodTabelaSalarial());
        stmt.setString(3,tabelaSalarial.getDscTabelaSalarial());        
        stmt.setString(4,tabelaSalarial.getIndAtivo());
        stmt.setString(5,tabelaSalarial.getIndExibeAreaSubarea());
        stmt.setString(6,String.valueOf(usuario.getChapa()));
        
        // registrando parametro de saida
        stmt.registerOutParameter(2,Types.INTEGER);
        transacao.executeCallableStatement(stmt);
        
        if(tipoDML >= 0){
          sucesso = stmt.getInt(2);
        }
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a TabelaSalarial: \n" ,e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a TabelaSalarial: \n" ,e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com TabelaSalarial " ,e.getMessage());
      }
    }
     return sucesso;        
   }
   
  /**
   * @param tabelaSalarial, usuario
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_INSTRUCAO
  */
  public int gravaTabelaSalarial(TabelaSalarial tabelaSalarial, Usuario usuario) throws RequisicaoPessoalException{
     return this.dmlTabelaSalarial(0, tabelaSalarial, usuario);
  }


  /**
   * @param tabelaSalarial, usuario
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_INSTRUCAO
  */
  public int alteraTabelaSalarial(TabelaSalarial tabelaSalarial, Usuario usuario) throws RequisicaoPessoalException{
    return this.dmlTabelaSalarial(1, tabelaSalarial, usuario);
  }

  /**
   * @param tabelaSalarial, usuario
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @OBS: Realiza apenas a exclusão lógica da requisição
   * @Procedure SP_DML_INSTRUCAO
  */
  public int deletaTabelaSalarial(TabelaSalarial tabelaSalarial, Usuario usuario) throws RequisicaoPessoalException{
    return this.dmlTabelaSalarial(-1, tabelaSalarial, usuario);
  }

  /**
   * Retorna uma instancia da classe TabelaSalarial, de acordo com o codigo informado
   * @return TabelaSalarial
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public TabelaSalarial getTabelaSalarial(int codTabelaSalarial) throws RequisicaoPessoalException{
    TabelaSalarial[] tabelaSalarial = getTabelaSalarials(" WHERE T.COD_TAB_SALARIAL = " + codTabelaSalarial);
    return (tabelaSalarial.length>0)?tabelaSalarial[0]:null;
  }

  /**
   * Retorna um array de objetos TabelaSalarial que satifaz a condição informada
   * @param condicao
   * @return array de objetos TabelaSalarial
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */

  public TabelaSalarial[] getTabelaSalarials(String condicao) throws RequisicaoPessoalException {
      StringBuffer sql = new StringBuffer();
      ArrayList listaTabelaSalarial = new ArrayList();
      TabelaSalarial tabelaSalarial = new TabelaSalarial();
      TabelaSalarial[] tabelaSalarials = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      ResultSet rs = null;
      
      sql.append(" SELECT T.COD_TAB_SALARIAL ");
      sql.append("       ,T.DSC_TAB_SALARIAL ");
      sql.append("       ,T.IND_ATIVO ");
      sql.append("       ,T.IND_EXIBE_AREA_SUBAREA ");
      sql.append(" FROM   reqpes.TABELA_SALARIAL T ");
      sql.append(condicao);
      sql.append(" ORDER BY 2");

      try{
         rs = transacao.getCursor(sql.toString());
         while(rs.next()){
             // Setando os atributos
             tabelaSalarial.setCodTabelaSalarial(rs.getInt("COD_TAB_SALARIAL"));
             tabelaSalarial.setDscTabelaSalarial(rs.getString("DSC_TAB_SALARIAL"));
             tabelaSalarial.setIndAtivo(rs.getString("IND_ATIVO"));
             tabelaSalarial.setIndExibeAreaSubarea(rs.getString("IND_EXIBE_AREA_SUBAREA"));
            
            // Adicionando na lista
            listaTabelaSalarial.add(tabelaSalarial);
            tabelaSalarial = new TabelaSalarial();
        }

        // Dimensionando o array
        tabelaSalarials = new TabelaSalarial[listaTabelaSalarial.size()];

        // Transferindo a lista para o array
        listaTabelaSalarial.toArray(tabelaSalarials);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("TabelaSalarialDAO  \n -> Problemas na consulta de TabelaSalarial: \n\n " + sql.toString(), e.getMessage());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("TabelaSalarialDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(), e.getMessage());
       }
    }
    return tabelaSalarials;
   }


   /**
   * @param sql
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getMatriz(String sql) throws RequisicaoPessoalException{
    String[][] retorno = null;
    try{
      retorno = manipulaDAO.getMatriz(sql,DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("TabelaSalarialDAO  \n -> Problemas na consulta  de TabelaSalarial: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }

  /**
   * @param sql
   * @return String[]
   * @throws RequisicaoPessoalException
   */
   public String[] getLista(String sql) throws RequisicaoPessoalException{
    String[] retorno = null;
    try{
      retorno = manipulaDAO.getLista(sql,DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("TabelaSalarialDAO  \n -> Problemas na consulta de TabelaSalarial: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }
}  