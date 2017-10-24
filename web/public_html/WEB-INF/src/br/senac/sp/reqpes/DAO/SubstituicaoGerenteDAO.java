package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.SubstituicaoGerente;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 26/09/2008
 */
public class SubstituicaoGerenteDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO = null; 
  ResponsavelEstruturaDAO responsavelEstruturaDAO = null;

  public SubstituicaoGerenteDAO(){
    manipulaDAO = new ManipulacaoDAO();
    responsavelEstruturaDAO = new ResponsavelEstruturaDAO();
  }

  /**
   * @param  requisicao
   * @return SubstituicaoGerente[]
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public SubstituicaoGerente[] getSubstituicaoGerentes() throws RequisicaoPessoalException, AdmTIException {
    return getSubstituicaoGerentes("");
  }

  /**
   * @return int
   * @param  substituicaoGerente, usuario
   * @Procedure PROCEDURE SP_DML_SUBSTITUICAO_GERENTE(P_IN_DML                 IN NUMBER
                                                     ,P_IN_CHAPA               IN NUMBER
                                                     ,P_IN_COD_UNIDADE         IN VARCHAR2
                                                     ,P_IN_DAT_INICIO_VIGENCIA IN DATE
                                                     ,P_IN_DAT_FIM_VIGENCIA    IN DATE
                                                     ,P_IN_TEOR_COD            IN VARCHAR2) IS
   */
   private int dmlSubstituicaoGerente(int dml, SubstituicaoGerente substituicaoGerente, Usuario usuario) throws RequisicaoPessoalException{
      int sucesso = 1;      
      String acao = "gravar";
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      CallableStatement stmt = null;

      //-- Verificando o tipo de acao
      if(dml > 0){
        acao = "atualizar";
      }
   
      try{
          stmt = transacao.getCallableStatement("{call reqpes.SP_DML_SUBSTITUICAO_GERENTE(?,?,?,?,?,?)}");
          stmt.setInt(1,dml);
          stmt.setInt(2,substituicaoGerente.getChapa());
          stmt.setString(3,substituicaoGerente.getCodUnidade());
          stmt.setDate(4,substituicaoGerente.getDatInicioVigencia());
          stmt.setDate(5,substituicaoGerente.getDatFimVigencia());
          stmt.setString(6,responsavelEstruturaDAO.getTeorCodWorkflow());
  
          transacao.executeCallableStatement(stmt);
          
      }catch(SQLException e){
        sucesso = 0;
        throw new RequisicaoPessoalException( "Ocorreu um erro ao "+ acao +" a SubstituicaoGerente: \n" ,e.getMessage());
      }catch(Exception e){
        sucesso = 0;
        throw new RequisicaoPessoalException("Ocorreu um erro ao "+ acao +" a SubstituicaoGerente: \n" ,e.getMessage());
      }finally{
        try{
           stmt.close();
           transacao.end();
        }catch(SQLException e){
           throw new RequisicaoPessoalException("Erro ao fechar conexao com SubstituicaoGerente " ,e.getMessage());
        }
      }
       return sucesso;   
   }
   
   
   public int gravaSubstituicaoGerente(SubstituicaoGerente substituicaoGerente, Usuario usuario) throws RequisicaoPessoalException{
      //-- 0 indica INSERT
      return this.dmlSubstituicaoGerente(0, substituicaoGerente, usuario);
   }

   public int alteraSubstituicaoGerente(SubstituicaoGerente substituicaoGerente, Usuario usuario) throws RequisicaoPessoalException{
      //-- 1 indica UPDATE
      return this.dmlSubstituicaoGerente(1, substituicaoGerente, usuario);
   }
 
  /**
   * Retorna uma instancia da classe SubstituicaoGerente, com o gerente atual
   * @return SubstituicaoGerente
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public SubstituicaoGerente getSubstituicaoGerenteAtual(String codUnidade) throws RequisicaoPessoalException, AdmTIException{
 
    StringBuffer sql = new StringBuffer();
    sql.append(" AND R.UNOR_COD = '"+codUnidade+"' ");
    sql.append(" AND (TRUNC(SYSDATE) BETWEEN R.REST_DAT_INI_VIGEN AND R.REST_DAT_FIN_VIGEN OR ");
    sql.append("      TRUNC(SYSDATE) > (SELECT MAX(R1.REST_DAT_FIN_VIGEN) ");
    sql.append("                FROM   RESPONSAVEL_ESTRUTURA R1 ");
    sql.append("                WHERE  R1.TEOR_COD = R.TEOR_COD ");
    sql.append("                AND    R1.UNOR_COD = R.UNOR_COD)) ");
    
    SubstituicaoGerente[] gerente = getSubstituicaoGerentes(sql.toString());
    return (gerente.length>0)?gerente[0]:null;
  }

  /**
   * Retorna um array de objetos SubstituicaoGerente que satifaz a condição informada
   * @param condicao
   * @return array de objetos SubstituicaoGerente
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */

  public SubstituicaoGerente[] getSubstituicaoGerentes(String condicao) throws RequisicaoPessoalException, AdmTIException {
      StringBuffer sql = new StringBuffer();
      ArrayList listaSubstituicaoGerente = new ArrayList();
      SubstituicaoGerente substituicaoGerente = new SubstituicaoGerente();
      SubstituicaoGerente[] substituicaoGerentes = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      ResultSet rs = null;
      
      sql.append(" SELECT R.UNOR_COD ");
      sql.append("       ,R.FUNC_ID ");
      sql.append("       ,F.NOME ");
      sql.append("       ,R.REST_DAT_INI_VIGEN ");
      sql.append("       ,R.REST_DAT_FIN_VIGEN ");
      sql.append(" FROM   RESPONSAVEL_ESTRUTURA R ");
      sql.append("       ,FUNCIONARIOS          F ");
      sql.append(" WHERE  F.ID = R.FUNC_ID ");
      sql.append(" AND    R.TEOR_COD = '"+ responsavelEstruturaDAO.getTeorCodWorkflow() +"' ");
      sql.append(condicao);
      sql.append(" ORDER BY R.REST_DAT_INI_VIGEN, R.REST_DAT_FIN_VIGEN ");

      try{
         rs = transacao.getCursor(sql.toString());
         while(rs.next()){
             // Setando os atributos
             substituicaoGerente.setCodUnidade(rs.getString("UNOR_COD"));
             substituicaoGerente.setChapa(rs.getInt("FUNC_ID"));
             substituicaoGerente.setNomGerente(rs.getString("NOME"));
             substituicaoGerente.setDatInicioVigencia(rs.getDate("REST_DAT_INI_VIGEN"));
             substituicaoGerente.setDatFimVigencia(rs.getDate("REST_DAT_FIN_VIGEN"));
            
            // Adicionando na lista
            listaSubstituicaoGerente.add(substituicaoGerente);
            substituicaoGerente = new SubstituicaoGerente();
        }

        // Dimensionando o array
        substituicaoGerentes = new SubstituicaoGerente[listaSubstituicaoGerente.size()];

        // Transferindo a lista para o array
        listaSubstituicaoGerente.toArray(substituicaoGerentes);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("SubstituicaoGerenteDAO  \n -> Problemas na consulta de SubstituicaoGerente: \n\n " + sql.toString(), e.getMessage());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("SubstituicaoGerenteDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(), e.getMessage());
       }
    }
    return substituicaoGerentes;
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
      throw new RequisicaoPessoalException("SubstituicaoGerenteDAO  \n -> Problemas na consulta  de SubstituicaoGerente: \n\n " + sql.toString(), e.getMessage());
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
      throw new RequisicaoPessoalException("SubstituicaoGerenteDAO  \n -> Problemas na consulta de SubstituicaoGerente: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboUnidades() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna as unidades
    sql.append(" SELECT UO.CODIGO ");
    sql.append("       ,UO.CODIGO||' - '||UO.DESCRICAO AS DSC_UNIDADE ");
    sql.append(" FROM   UNIDADES_ORGANIZACIONAIS UO ");
    sql.append(" WHERE  UO.DATA_ENCERRAMENTO IS NULL ");
    sql.append(" AND    UO.NIVEL             =  2    ");
    sql.append(" AND    UO.CODIGO_PAI        <> 'S'  ");
    sql.append(" ORDER  BY UO.CODIGO ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("SubstituicaoGerenteDAO  \n -> Problemas na consulta de getComboUnidades: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }       
}