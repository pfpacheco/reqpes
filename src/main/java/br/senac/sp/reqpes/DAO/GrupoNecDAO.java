package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.GrupoNec;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 2/6/2009
 */
 
public class GrupoNecDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public GrupoNecDAO(){

  }

  /**
   * Retorna todas as grupoNecs cadastradas no sistema
   * @return GrupoNec[]
   * @throws    * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   */
  public GrupoNec[] getGrupoNecs() throws RequisicaoPessoalException {
    return getGrupoNecs("");
  }

  /**
   * @return int
   * @param  grupoNec, usuario
   * @Procedure PROCEDURE SP_DML_GRUPO_NEC(P_IN_DML        IN NUMBER
                                          ,P_IN_COD_GRUPO  IN OUT NUMBER
                                          ,P_IN_DSC_GRUPO  IN VARCHAR2
                                          ,P_IN_USUARIO    IN VARCHAR2) IS
   */
   
   private int dmlGrupoNec(int tipoDML, GrupoNec grupoNec, Usuario usuario) throws RequisicaoPessoalException{
    
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
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_GRUPO_NEC(?,?,?,?)}");
        stmt.setInt(1,tipoDML); // 0 INSERT, 1 UPDATE, -1 DELETE 
        stmt.setInt(2,grupoNec.getCodGrupo());
        stmt.setString(3,grupoNec.getDscGrupo());        
        stmt.setString(4,String.valueOf(usuario.getChapa()));
        
        // registrando parametro de saida
        stmt.registerOutParameter(2,Types.INTEGER);
        transacao.executeCallableStatement(stmt);
        
        if(tipoDML >= 0){
          sucesso = stmt.getInt(2);
        }      
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a GrupoNec: \n" ,e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a GrupoNec: \n" ,e.getMessage());
    }finally{
      try{
         stmt.close();      
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com GrupoNec " ,e.getMessage());
      }
    }
     return sucesso;        
   }
   
  /**
   * @param grupoNec, usuario
   * @return int
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_GRUPO_NEC
  */
  public int gravaGrupoNec(GrupoNec grupoNec, Usuario usuario) throws RequisicaoPessoalException{
     return this.dmlGrupoNec(0, grupoNec, usuario);
  }


  /**
   * @param grupoNec, usuario
   * @return int
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_GRUPO_NEC
  */
  public int alteraGrupoNec(GrupoNec grupoNec, Usuario usuario) throws RequisicaoPessoalException{
    return this.dmlGrupoNec(1, grupoNec, usuario);
  }

  /**
   * @param grupoNec, usuario
   * @return int
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   * @OBS: Realiza apenas a exclusão lógica da requisição
   * @Procedure SP_DML_GRUPO_NEC
  */
  public int deletaGrupoNec(GrupoNec grupoNec, Usuario usuario) throws RequisicaoPessoalException{
    return this.dmlGrupoNec(-1, grupoNec, usuario);
  }

  /**
   * Retorna uma instancia da classe GrupoNec, de acordo com o codigo informado
   * @return GrupoNec
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   */
  public GrupoNec getGrupoNec(int codGrupoNec) throws RequisicaoPessoalException{
    GrupoNec[] grupoNec = getGrupoNecs(" WHERE T.COD_GRUPO = " + codGrupoNec);
    return (grupoNec.length>0)?grupoNec[0]:null;
  }

  /**
   * Retorna um array de objetos GrupoNec que satifaz a condição informada
   * @param condicao
   * @return array de objetos GrupoNec
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   */

  public GrupoNec[] getGrupoNecs(String condicao) throws RequisicaoPessoalException {
      StringBuffer sql = new StringBuffer();
      ArrayList listaGrupoNec = new ArrayList();
      GrupoNec grupoNec = new GrupoNec();
      GrupoNec[] grupoNecs = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      ResultSet rs = null;

      sql.append(" SELECT T.COD_GRUPO ");
      sql.append("       ,T.DSC_GRUPO ");
      sql.append(" FROM   reqpes.GRUPO_NEC T ");
      sql.append(condicao);
      sql.append(" ORDER  BY T.DSC_GRUPO ");

      try{
         rs = transacao.getCursor(sql.toString());
         while(rs.next()){
             // Setando os atributos
             grupoNec.setCodGrupo(rs.getInt("COD_GRUPO"));
             grupoNec.setDscGrupo(rs.getString("DSC_GRUPO"));
            
            // Adicionando na lista
            listaGrupoNec.add(grupoNec);
            grupoNec = new GrupoNec();
        }

        // Dimensionando o array
        grupoNecs = new GrupoNec[listaGrupoNec.size()];

        // Transferindo a lista para o array
        listaGrupoNec.toArray(grupoNecs);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("GrupoNecDAO  \n -> Problemas na consulta de GrupoNec: \n\n " + sql.toString(), e.getMessage());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("GrupoNecDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(), e.getMessage());
       }
    }
    return grupoNecs;
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
      throw new RequisicaoPessoalException("GrupoNecDAO  \n -> Problemas na consulta  de GrupoNec: \n\n " + sql.toString(), e.getMessage());
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
      throw new RequisicaoPessoalException("GrupoNecDAO  \n -> Problemas na consulta de GrupoNec: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }
}