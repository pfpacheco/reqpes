package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.UsuarioAvisoEmail;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 26/09/2008
 */
public class UsuarioAvisoEmailDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public UsuarioAvisoEmailDAO(){

  }

  /**
   * @param  requisicao
   * @return UsuarioAvisoEmail[]
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public UsuarioAvisoEmail[] getUsuarioAvisoEmails() throws RequisicaoPessoalException {
    return getUsuarioAvisoEmails("");
  }

  /**
   * @return int
   * @param  usuarioAvisoEmail, usuario
   * @Procedure PROCEDURE SP_DML_USUARIO_AVISO(P_IN_DML            IN NUMBER
                                              ,P_IN_OUT_CHAPA      IN OUT NUMBER
                                              ,P_IN_COD_TIPO_AVISO IN NUMBER
                                              ,P_IN_USUARIO        IN NUMBER) IS
   */
   private int dmlUsuarioAvisoEmail(int tipoDML, UsuarioAvisoEmail usuarioAvisoEmail, Usuario usuario) throws RequisicaoPessoalException{
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    CallableStatement stmt = null;
    String tipoTransacao = null;
    
    switch(tipoDML){
      case -1 : tipoTransacao = "excluir" ; break;
      case  1 : tipoTransacao = "alterar" ; break;
      case  0 : tipoTransacao = "inserir" ; break;
    }
        
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_USUARIO_AVISO(?,?,?,?)}");
        stmt.setInt(1,tipoDML);
        stmt.setInt(2,usuarioAvisoEmail.getChapa());
        stmt.setInt(3,usuarioAvisoEmail.getCodTipoAviso());
        stmt.setInt(4,usuario.getChapa());
        stmt.registerOutParameter(2,Types.INTEGER);
        transacao.executeCallableStatement(stmt);
        
        if(tipoDML >= 0){
          sucesso = stmt.getInt(2);
        }
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException( "Ocorreu um erro ao "+ tipoTransacao +" a UsuarioAvisoEmail: \n" ,e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a UsuarioAvisoEmail: \n" ,e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com UsuarioAvisoEmail " ,e.getMessage());
      }
    }
     return sucesso;
  }

  /**
   * @param usuarioAvisoEmail, usuario
   * @return int
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_USUARIO_AVISO
  */
  public int gravaUsuarioAvisoEmail(UsuarioAvisoEmail usuarioAvisoEmail, Usuario usuario) throws RequisicaoPessoalException{
     return this.dmlUsuarioAvisoEmail(0, usuarioAvisoEmail, usuario);
  }
  

  /**
   * @param usuarioAvisoEmail, usuario
   * @return int
   * @throws br.senac.sp.reqpes.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_USUARIO_AVISO
  */
  public int deletaUsuarioAvisoEmail(UsuarioAvisoEmail usuarioAvisoEmail, Usuario usuario) throws RequisicaoPessoalException{
     return this.dmlUsuarioAvisoEmail(-1, usuarioAvisoEmail, usuario);
  }
  
  /**
   * Retorna uma instancia da classe UsuarioAvisoEmail, de acordo com o codigo informado
   * @return UsuarioAvisoEmail
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public UsuarioAvisoEmail getUsuarioAvisoEmail(int chapa) throws RequisicaoPessoalException{
    UsuarioAvisoEmail[] usuarioAvisoEmail = getUsuarioAvisoEmails(" AND UA.CHAPA = " + chapa);
    return (usuarioAvisoEmail.length>0)?usuarioAvisoEmail[0]:null;
  }
  
  /**
   * Retorna um array de instancias da classe UsuarioAvisoEmail
   * @return UsuarioAvisoEmail
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public UsuarioAvisoEmail[] getUsuarioAvisoEmail() throws RequisicaoPessoalException{    
    return getUsuarioAvisoEmails("");
  }

  /**
   * Retorna um array de objetos UsuarioAvisoEmail que satifaz a condição informada
   * @param condicao
   * @return array de objetos UsuarioAvisoEmail
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */

  public UsuarioAvisoEmail[] getUsuarioAvisoEmails(String condicao) throws RequisicaoPessoalException {
      StringBuffer sql = new StringBuffer();
      ArrayList listaUsuarioAvisoEmail = new ArrayList();
      UsuarioAvisoEmail usuarioAvisoEmail = new UsuarioAvisoEmail();
      UsuarioAvisoEmail[] usuarioAvisoEmails = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      ResultSet rs = null;

     sql.append(" SELECT UNIQUE UA.CHAPA ");
     sql.append("       ,FC.E_MAIL ");
     sql.append("       ,F.NOME ");
     sql.append(" FROM   reqpes.USUARIO_AVISO UA ");
     sql.append("       ,FUNCIONARIOS  F ");
     sql.append("       ,FUNCIONARIO_COMPLEMENTO FC ");
     sql.append(" WHERE  F.ID = UA.CHAPA ");
     sql.append(" AND    F.ID = FC.ID_FUNCIONARIO ");
     sql.append(condicao);
     sql.append(" ORDER  BY F.NOME ");
     

      try{
         rs = transacao.getCursor(sql.toString());
         while(rs.next()){
             // Setando os atributos
             usuarioAvisoEmail.setChapa(rs.getInt("CHAPA"));
             usuarioAvisoEmail.setEmail(rs.getString("E_MAIL"));
             usuarioAvisoEmail.setNome(rs.getString("NOME"));
            
            // Adicionando na lista
            listaUsuarioAvisoEmail.add(usuarioAvisoEmail);
            usuarioAvisoEmail = new UsuarioAvisoEmail();
        }

        // Dimensionando o array
        usuarioAvisoEmails = new UsuarioAvisoEmail[listaUsuarioAvisoEmail.size()];

        // Transferindo a lista para o array
        listaUsuarioAvisoEmail.toArray(usuarioAvisoEmails);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("UsuarioAvisoEmailDAO  \n -> Problemas na consulta de UsuarioAvisoEmail: \n\n " + sql.toString(), e.getMessage());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("UsuarioAvisoEmailDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(), e.getMessage());
       }
    }
    return usuarioAvisoEmails;
   }

   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboUnidades() throws RequisicaoPessoalException{
    String[][] retorno = null;
    StringBuffer sql = new StringBuffer();
    sql.append(" SELECT UO.CODIGO ");
    sql.append("       ,UO.DESCRICAO ");
    sql.append(" FROM   UNIDADES_ORGANIZACIONAIS UO ");
    sql.append(" WHERE  UO.NIVEL = 2 ");
    sql.append(" AND    UO.DATA_ENCERRAMENTO IS NULL ");
    sql.append(" AND    UO.CODIGO NOT IN ('SA', 'SO', 'SD', 'SU') ");
    sql.append(" ORDER BY UO.CODIGO ");
    
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("UsuarioAvisoEmailDAO  \n -> Problemas na consulta  de getUnidades: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }
 
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboUsuarios(String codUnidade) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna os usuarios da unidade informada que contenham e-mail
    sql.append(" SELECT F.ID ");
    sql.append("       ,F.NOME ");
    sql.append(" FROM   FUNCIONARIOS F ");
    sql.append("       ,UNIDADES_ORGANIZACIONAIS UO1 ");
    sql.append("       ,UNIDADES_ORGANIZACIONAIS UO2 ");
    sql.append(" WHERE  F.ATIVO        = 'A' ");
    sql.append(" AND    F.TIPO_COLAB   <> 'P' ");
    sql.append(" AND    F.COD_UNIORG   = UO1.CODIGO ");
    sql.append(" AND    UO1.CODIGO_PAI = UO2.CODIGO ");
    sql.append(" AND    UO2.CODIGO_PAI = '" + codUnidade + "' ");
    sql.append(" AND    EXISTS (SELECT 1 ");
    sql.append("                FROM   FUNCIONARIO_COMPLEMENTO FC ");
    sql.append("                WHERE  FC.ID_FUNCIONARIO = F.ID ");
    sql.append("                AND    FC.E_MAIL IS NOT NULL) ");
    sql.append(" AND    NOT EXISTS (SELECT 1 FROM USUARIO_AVISO U WHERE U.CHAPA = F.ID) ");
    sql.append(" ORDER BY F.NOME ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("UsuarioAvisoEmailDAO  \n -> Problemas na consulta  de getComboUsuarios: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }     
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getTipoAvisoUsuario(int chapa) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT T.COD_TIPO_AVISO ");
    sql.append("       ,T.TITULO ");
    sql.append("       ,DECODE(U.CHAPA, " + chapa + ", 'checked', NULL) IND_CHECKED ");
    sql.append(" FROM   TIPO_AVISO    T ");
    sql.append("       ,USUARIO_AVISO U ");
    sql.append(" WHERE  T.COD_TIPO_AVISO = U.COD_TIPO_AVISO(+) ");
    sql.append(" AND    U.CHAPA(+) = " + chapa);
    sql.append(" ORDER  BY T.COD_TIPO_AVISO ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("UsuarioAvisoEmailDAO  \n -> Problemas na consulta  de getTipoAvisoUsuario: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }       
  
   /**
   * Retorna os e-mails dos colaboradores envolvidos no processo de WorkFlow obedecendo a regra do tipo de aviso associado com o cargo informado
   * @return String[]
   * @throws RequisicaoPessoalException
   */  
  public String[] getEmailsUsuariosAviso(int codCargo) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[] retorno = null;
    
    sql.append(" SELECT FC.E_MAIL ");
    sql.append(" FROM   USUARIO_AVISO U ");
    sql.append("       ,TIPO_AVISO    T ");
    sql.append("       ,FUNCIONARIO_COMPLEMENTO FC ");
    sql.append(" WHERE  T.COD_TIPO_AVISO = U.COD_TIPO_AVISO ");
    sql.append(" AND    U.CHAPA          = FC.ID_FUNCIONARIO ");
    sql.append(" AND    EXISTS (SELECT 1 ");
    sql.append("                FROM   CARGO_DESCRICOES D ");
    sql.append("                      ,CARGOS           C ");
    sql.append("                WHERE  C.ID = D.ID ");
    sql.append("                AND    C.ID =  " + codCargo );
    sql.append("                AND    D.DESCRICAO LIKE '%'||T.CARGO_CHAVE||'%' ");
    sql.append("                AND    C.REGIME = T.CARGO_REGIME) ");
    sql.append(" UNION ");
    sql.append(" SELECT FC.E_MAIL ");
    sql.append(" FROM   USUARIO_AVISO U ");
    sql.append("       ,TIPO_AVISO    T ");
    sql.append("       ,FUNCIONARIO_COMPLEMENTO FC ");
    sql.append(" WHERE  T.COD_TIPO_AVISO = U.COD_TIPO_AVISO ");
    sql.append(" AND    U.CHAPA          = FC.ID_FUNCIONARIO ");
    sql.append(" AND    T.COD_TIPO_AVISO = 1 "); //-- Opção Todos
    
    try{
      retorno = manipulaDAO.getLista(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("UsuarioAvisoEmailDAO  \n -> Problemas na consulta de getEmailsUsuariosAviso: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }     
}