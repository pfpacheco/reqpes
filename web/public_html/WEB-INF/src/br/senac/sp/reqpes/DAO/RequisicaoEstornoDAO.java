package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.RequisicaoEstorno;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 09/10/2008
 */
 
public class RequisicaoEstornoDAO implements InterfaceDataBase{

  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public RequisicaoEstornoDAO(){
  }
  
  /**
   * @return int
   * @param  requisicao, usuario
   * @Procedure PROCEDURE SP_DML_REQUISICAO_ESTORNO(P_IN_DML               IN NUMBER
                                                   ,P_IN_OUT_REQUISICAO_SQ IN OUT NUMBER
                                                   ,P_IN_USUARIO           IN VARCHAR2
                                                   ,P_IN_IND_TIPO_ESTORNO  IN VARCHAR2) IS
   */
   
   public int estornaRequisicao(RequisicaoEstorno requisicao, Usuario usuario)throws RequisicaoPessoalException{
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    CallableStatement stmt = null;
    
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_REQUISICAO_ESTORNO(?,?,?,?)}");
        stmt.setInt(1,1); // 1 indica UPDATE
        stmt.setInt(2,requisicao.getCodRequisicao());
        stmt.setString(3,String.valueOf(usuario.getUsuarioSq()));
        stmt.setString(4,requisicao.getIndTipoEstorno());

        // registrando parametro de saida
        stmt.registerOutParameter(2,Types.INTEGER);
        
        transacao.executeCallableStatement(stmt);
        sucesso = stmt.getInt(2);        
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao gravar a RequisicaoEstorno: \nRequisição: "+requisicao.getCodRequisicao()+"\n" ,e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao gravar a RequisicaoEstorno: \nRequisição: "+requisicao.getCodRequisicao()+"\n" ,e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com RequisicaoEstorno " ,e.getMessage());
      }
    }
     return sucesso;
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
      throw new RequisicaoPessoalException("RequisicaoEstornoDAO  \n -> Problemas na consulta de RequisicaoEstorno: \n\n" + sql.toString(),e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   * @coments Estorno para todos os status da requisição
   */
  public String[][] getRequisicoesParaEstorno(String condicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna as requisições que podem ser efetuadas estornos
    sql.append(" SELECT REQUISICAO_SQ ");
    sql.append("       ,DT_REQUISICAO ");
    sql.append("       ,CARGO ");
    sql.append("       ,COD_UNIDADE ");
    sql.append("       ,NOM_UNIDADE ");
    sql.append("       ,DSC_STATUS  ");
    sql.append("       ,SGL_UNIDADE ");   
    sql.append(" FROM   reqpes.VW_REQUISICOES_PARA_ESTORNO ");
    sql.append(" WHERE  1 = 1 ");
    sql.append(condicao);

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoEstornoDAO  \n -> Problemas na consulta de getRequisicoesParaEstorno: \n\n" + sql.toString(),e.getMessage());
    }
    return retorno;
  }   
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboCargosEstorno() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna os cargos relacionados as requisições para estorno
    sql.append(" SELECT UNIQUE T.CARGO_SQ ");
    sql.append("       ,T.CARGO ");
    sql.append(" FROM   reqpes.VW_REQUISICOES_PARA_ESTORNO T ");
    sql.append(" ORDER  BY T.CARGO ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoEstornoDAO  \n -> Problemas na consulta getComboCargosEstorno: \n \n" + sql.toString(),e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboUnidadesEstorno() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna as unidades relacionadas as requisições para estorno
    sql.append(" SELECT UNIQUE T.COD_UNIDADE ");
    sql.append("       ,T.COD_UNIDADE || ' - ' ||T.NOM_UNIDADE ");
    sql.append(" FROM   reqpes.VW_REQUISICOES_PARA_ESTORNO T ");
    sql.append(" ORDER  BY T.COD_UNIDADE ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoEstornoDAO  \n -> Problemas na consulta getComboUnidadesEstorno: \n \n" + sql.toString(),e.getMessage());
    }
    return retorno;
  }     
}