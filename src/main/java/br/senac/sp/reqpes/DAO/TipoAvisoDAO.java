package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.TipoAviso;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 30/3/2010
 */
 
public class TipoAvisoDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public TipoAvisoDAO(){

  }

  /**
   * Retorna todas as tipoAvisos cadastradas no sistema
   * @return TipoAviso[]
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   */
  public TipoAviso[] getTipoAvisos() throws RequisicaoPessoalException {
    return getTipoAvisos("");
  }

  /**
   * @return int
   * @param  tipoAviso, usuario
   * @Procedure PROCEDURE SP_DML_TIPO_AVISO(P_IN_DML            IN NUMBER
                                           ,P_IN_COD_TIPO_AVISO IN OUT NUMBER
                                           ,P_IN_TITULO         IN VARCHAR2
                                           ,P_IN_CARGO_CHAVE    IN VARCHAR2
                                           ,P_IN_CARGO_REGIME   IN VARCHAR2
                                           ,P_IN_USUARIO        IN NUMBER) IS
   */
   
   private int dmlTipoAviso(int tipoDML, TipoAviso tipoAviso, Usuario usuario) throws RequisicaoPessoalException{
    
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    String tipoTransacao = "";
    
    switch(tipoDML){
      case -1 : tipoTransacao = "excluir" ; break;
      case  0 : tipoTransacao = "inserir" ; break;
      case  1 : tipoTransacao = "alterar" ; break;
    };
    
    try{
        CallableStatement stmt = transacao.getCallableStatement("{call reqpes.SP_DML_TIPO_AVISO(?,?,?,?,?,?)}");
        stmt.setInt(1,tipoDML); // 0 INSERT, 1 UPDATE, -1 DELETE 
        stmt.setInt(2,tipoAviso.getCodTipoAviso());
        stmt.setString(3,tipoAviso.getTitulo());
        stmt.setString(4,tipoAviso.getCargoChave());
        stmt.setString(5,tipoAviso.getCargoRegime());
        stmt.setInt(6,usuario.getChapa());
        
        // registrando parametro de saida
        stmt.registerOutParameter(2,Types.INTEGER);
        transacao.executeCallableStatement(stmt);
        
        if(tipoDML >= 0){
          sucesso = stmt.getInt(2);
        }
        
        stmt.close();
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a TipoAviso: \n" ,e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a TipoAviso: \n" ,e.getMessage());
    }finally{
      try{
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com TipoAviso " ,e.getMessage());
      }
    }
     return sucesso;        
   }
   
  /**
   * @param tipoAviso, usuario
   * @return int
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_TIPO_AVISO
  */
  public int gravaTipoAviso(TipoAviso tipoAviso, Usuario usuario) throws RequisicaoPessoalException{
     return this.dmlTipoAviso(0, tipoAviso, usuario);
  }


  /**
   * @param tipoAviso, usuario
   * @return int
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_TIPO_AVISO
  */
  public int alteraTipoAviso(TipoAviso tipoAviso, Usuario usuario) throws RequisicaoPessoalException{
    return this.dmlTipoAviso(1, tipoAviso, usuario);
  }

  /**
   * @param tipoAviso, usuario
   * @return int
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   * @OBS: Realiza apenas a exclusão lógica da requisição
   * @Procedure SP_DML_TIPO_AVISO
  */
  public int deletaTipoAviso(TipoAviso tipoAviso, Usuario usuario) throws RequisicaoPessoalException{
    return this.dmlTipoAviso(-1, tipoAviso, usuario);
  }

  /**
   * Retorna uma instancia da classe TipoAviso, de acordo com o codigo informado
   * @return TipoAviso
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   */
  public TipoAviso getTipoAviso(int codTipoAviso) throws RequisicaoPessoalException{
    TipoAviso[] tipoAviso = getTipoAvisos(" WHERE T.COD_TIPO_AVISO = " + codTipoAviso);
    return (tipoAviso.length>0)?tipoAviso[0]:null;
  }

  /**
   * Retorna um array de objetos TipoAviso que satifaz a condição informada
   * @param condicao
   * @return array de objetos TipoAviso
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   */

  public TipoAviso[] getTipoAvisos(String condicao) throws RequisicaoPessoalException {
      StringBuffer sql = new StringBuffer();
      ArrayList listaTipoAviso = new ArrayList();
      TipoAviso tipoAviso = new TipoAviso();
      TipoAviso[] tipoAvisos = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);

      sql.append(" SELECT T.COD_TIPO_AVISO ");
      sql.append("       ,T.TITULO ");
      sql.append("       ,T.CARGO_CHAVE ");
      sql.append("       ,T.CARGO_REGIME ");
      sql.append("       ,DECODE(T.CARGO_REGIME, 'M', 'MENSALISTA' ");
      sql.append("                             , 'H', 'HORISTA' ");
      sql.append("                             , NULL, 'NENHUM') AS DSC_REGIME ");
      sql.append(" FROM   reqpes.TIPO_AVISO T ");
      sql.append(condicao);
      sql.append(" ORDER  BY T.TITULO ");

      try{
         ResultSet rs = transacao.getCursor(sql.toString());
         while(rs.next()){
             // Setando os atributos
             tipoAviso.setCodTipoAviso(rs.getInt("COD_TIPO_AVISO"));
             tipoAviso.setTitulo(rs.getString("TITULO"));
             tipoAviso.setCargoChave(rs.getString("CARGO_CHAVE"));
             tipoAviso.setCargoRegime(rs.getString("CARGO_REGIME"));
             tipoAviso.setDscRegime(rs.getString("DSC_REGIME"));
            
            // Adicionando na lista
            listaTipoAviso.add(tipoAviso);
            tipoAviso = new TipoAviso();
        }

        // Dimensionando o array
        tipoAvisos = new TipoAviso[listaTipoAviso.size()];

        // Transferindo a lista para o array
        listaTipoAviso.toArray(tipoAvisos);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("TipoAvisoDAO  \n -> Problemas na consulta de TipoAviso: \n\n " + sql.toString(), e.getMessage());
    }finally{
       try{
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("TipoAvisoDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(), e.getMessage());
       }
    }
    return tipoAvisos;
   }

}