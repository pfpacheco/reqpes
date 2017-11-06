package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.GrupoNecUnidade;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 2/6/2009
 */
 
public class GrupoNecUnidadeDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public GrupoNecUnidadeDAO(){
  }

  /**
   * @return int
   * @param  grupoNecUnidade, usuario
   * @Procedure PROCEDURE SP_DML_GRUPO_NEC_UNIDADES(P_IN_DML         IN NUMBER
                                                   ,P_IN_COD_GRUPO   IN NUMBER
                                                   ,P_IN_COD_UNIDADE IN VARCHAR2) IS
   */
   
   private int dmlGrupoNecUnidade(int tipoDML, GrupoNecUnidade grupoNecUnidade) throws RequisicaoPessoalException{
    
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    String tipoTransacao = "";
    CallableStatement stmt = null;
    
    switch(tipoDML){
      case -1 : tipoTransacao = "excluir" ; break;
      case  0 : tipoTransacao = "inserir" ; break;
    };
    
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_GRUPO_NEC_UNIDADES(?,?,?)}");
        stmt.setInt(1,tipoDML); // 0 INSERT, -1 DELETE 
        stmt.setInt(2,grupoNecUnidade.getCodGrupo());
        stmt.setString(3,grupoNecUnidade.getCodUnidade());
        
        // registrando parametro de saida
        stmt.registerOutParameter(2,Types.INTEGER);
        transacao.executeCallableStatement(stmt);
        
        if(tipoDML >= 0){
          sucesso = stmt.getInt(2);
        }    
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a GrupoNecUnidade: \n" ,e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a GrupoNecUnidade: \n" ,e.getMessage());
    }finally{
      try{
         stmt.close();       
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com GrupoNecUnidade " ,e.getMessage());
      }
    }
     return sucesso;        
   }
   
   
  /**
   * @param grupoNecUnidade
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_GRUPO_NEC_UNIDADES
  */
  public int gravaGrupoNecUnidade(GrupoNecUnidade grupoNecUnidade) throws RequisicaoPessoalException{
     return this.dmlGrupoNecUnidade(0, grupoNecUnidade);
  }


  /**
   * @param grupoNecUnidade
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_GRUPO_NEC_UNIDADES
  */
  public int deletaGrupoNecUnidade(GrupoNecUnidade grupoNecUnidade) throws RequisicaoPessoalException{
    return this.dmlGrupoNecUnidade(-1, grupoNecUnidade);
  }


  /**
  * @return String[][]
  * @throws RequisicaoPessoalException
  */
  public String[][] getUnidadesSuperintendencia(int codGrupo, String codSuperintendencia) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT F_GET_SEL_GRUPO_NEC_UNIDADE("+ codGrupo +", T.CODIGO) AS IND ");
    sql.append("       ,T.CODIGO ");
    sql.append("       ,T.CODIGO || ' - ' || T.SIGLA AS UO ");
    sql.append("       ,T.DESCRICAO ");
    sql.append(" FROM   rhev.ESTRUTURA_ORGANIZACIONAL R ");
    sql.append("       ,rhev.UNIDADES_ORGANIZACIONAIS T ");
    sql.append(" WHERE  R.UNOR_COD     = T.CODIGO ");
    sql.append(" AND    R.UNOR_COD_PAI = '"+ codSuperintendencia +"' ");
    sql.append(" AND    R.TEOR_COD     = 'RHEV' ");
    sql.append(" AND    T.DATA_ENCERRAMENTO IS NULL ");
    //-- 02/03/2011: Thiago - Adicionando a unidade 002C na superintendência administrativa, para que o NEC possa realizar a revisão das RP's
    if(codSuperintendencia.equals("SA")){      
      sql.append(" UNION ");
      sql.append(" SELECT F_GET_SEL_GRUPO_NEC_UNIDADE("+ codGrupo +", T.CODIGO) AS IND ");
      sql.append("       ,T.CODIGO ");
      sql.append("       ,T.CODIGO || ' - ' || T.SIGLA AS UO ");
      sql.append("       ,T.DESCRICAO ");
      sql.append(" FROM   rhev.UNIDADES_ORGANIZACIONAIS T ");
      sql.append(" WHERE  T.CODIGO = '002C' ");
      sql.append(" AND    T.DATA_ENCERRAMENTO IS NULL ");
    }
    sql.append(" ORDER BY 2 ");
    
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("GrupoNecUnidadeDAO  \n -> Problemas na consulta de getUnidadesSuperintendencia: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }

  /**
  * @return String[][]
  * @throws RequisicaoPessoalException
  */
  public String[][] getUnidadesGO(int codGrupo, String codGO) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT F_GET_SEL_GRUPO_NEC_UNIDADE("+ codGrupo +", EO.UNOR_COD) AS IND ");
    sql.append("       ,U.CODIGO ");
    sql.append("       ,U.CODIGO || ' - ' || U.SIGLA AS UO ");
    sql.append("       ,U.DESCRICAO ");
    sql.append(" FROM   rhev.ESTRUTURA_ORGANIZACIONAL EO ");
    sql.append("       ,rhev.UNIDADES_ORGANIZACIONAIS U ");
    sql.append(" WHERE  EO.UNOR_COD = U.CODIGO ");
    sql.append(" AND    EO.TEOR_COD = 'RHEV' ");
    sql.append(" AND    (EO.UNOR_COD IN (SELECT EO.UNOR_COD ");
    sql.append("                         FROM   rhev.ESTRUTURA_ORGANIZACIONAL EO ");
    sql.append("                         WHERE  EO.TEOR_COD = 'RHEV' ");
    sql.append("                         AND    (EO.UNOR_COD = '" + codGO + "' OR EO.UNOR_COD_PAI = '" + codGO + "')) ");
    sql.append("                         OR EO.UNOR_COD_PAI IN (SELECT EO.UNOR_COD ");
    sql.append("                                                FROM   rhev.ESTRUTURA_ORGANIZACIONAL EO ");
    sql.append("                                                WHERE  EO.TEOR_COD = 'RHEV' ");
    sql.append("                                                AND    (EO.UNOR_COD = '" + codGO + "' OR EO.UNOR_COD_PAI = '" + codGO + "'))) ");
    sql.append(" AND   U.CODIGO NOT IN ('" + codGO + "') ");
    sql.append(" ORDER BY 2 ");
    
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("GrupoNecUnidadeDAO  \n -> Problemas na consulta de getUnidadesGO: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }
}