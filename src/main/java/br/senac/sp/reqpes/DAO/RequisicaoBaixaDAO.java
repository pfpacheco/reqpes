package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.RequisicaoBaixa;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 08/10/2008
 */
 
public class RequisicaoBaixaDAO implements InterfaceDataBase{

  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public RequisicaoBaixaDAO(){

  }

  /**
   * @return int
   * @param  requisicao, usuario
   * @Procedure PROCEDURE SP_DML_REQUISICAO_BAIXA(P_IN_DML                IN NUMBER
                                                 ,P_IN_REQUISICAO_SQ      IN NUMBER
                                                 ,P_IN_OUT_FUNCIONARIO_ID IN OUT NUMBER
                                                 ,P_IN_USUARIO            IN VARCHAR2) IS
   */
   
   public int gravaRequisicaoBaixa(RequisicaoBaixa requisicao, Usuario usuario)throws RequisicaoPessoalException{
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    CallableStatement stmt = null;
    
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_REQUISICAO_BAIXA(?,?,?,?)}");
        stmt.setInt(1,0); // 0 indica INSERT        
        stmt.setInt(2,requisicao.getCodRequisicao());
        stmt.setInt(3,requisicao.getIdFuncionarioBaixado());
        stmt.setString(4,String.valueOf(usuario.getUsuarioSq()));

        // registrando parametro de saida
        stmt.registerOutParameter(3,Types.INTEGER);
        
        transacao.executeCallableStatement(stmt);
        sucesso = stmt.getInt(3);
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao gravar a RequisicaoBaixa: \nRequisição: "+requisicao.getCodRequisicao()+"\n",e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao gravar a RequisicaoBaixa: \nRequisição: "+requisicao.getCodRequisicao()+"\n",e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com RequisicaoBaixa ",e.getMessage());
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
      throw new RequisicaoPessoalException("RequisicaoBaixaDAO  \n -> Problemas na consulta de RequisicaoBaixa: " + "\n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getRequisicoesParaBaixa(String condicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna as requisições que podem ser efetuadas baixas
    sql.append(" SELECT REQUISICAO_SQ ");
    sql.append("       ,DT_REQUISICAO ");
    sql.append("       ,CARGO ");
    sql.append("       ,COD_UNIDADE ");
    sql.append("       ,IND_TIPO_REQUISICAO ");
    sql.append("       ,SGL_UNIDADE ");
    sql.append("       ,NOM_UNIDADE ");
    sql.append(" FROM   reqpes.VW_REQUISICOES_PARA_BAIXA ");
    sql.append(" WHERE  1 = 1 ");
    sql.append(condicao);

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoBaixaDAO  \n -> Problemas na consulta de getRequisicoesParaBaixa: " + "\n\n" + sql.toString(), e.getMessage());
    }
    return retorno; 
  } 
 
 
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getRequisicoesParaBaixaExpirando(int contratacaoValidade, int expiracaoAviso, String condicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna as requisições que estão expirando para baixa
    sql.append(" SELECT R.REQUISICAO_SQ ");
    sql.append("       ,TO_CHAR(R.DT_REQUISICAO,'dd/mm/yyyy') DT_REQUISICAO ");
    sql.append("       ,TO_CHAR(HR.DT_ENVIO,'dd/mm/yyyy')     DT_APROVADA ");
    sql.append("       ,TO_CHAR(HR.DT_ENVIO + " + contratacaoValidade + ",'dd/mm/yyyy') DT_EXPIRACAO ");        
    sql.append("       ,CD.DESCRICAO CARGO ");
    sql.append("       ,R.COD_UNIDADE ");
    sql.append("       ,TRIM(U.SIGLA) ");
    sql.append("       ,TRIM(UPPER(U.NOME)) ");
    sql.append(" FROM   reqpes.REQUISICAO            R  ");
    sql.append("       ,CARGO_DESCRICOES      CD ");
    sql.append("       ,reqpes.UNIDADE               U  ");
    sql.append("              ,(SELECT * ");
    sql.append("                FROM   reqpes.HISTORICO_REQUISICAO HR ");
    sql.append("                WHERE  HR.DT_ENVIO = (SELECT MAX(HR1.DT_ENVIO) ");
    sql.append("                                      FROM   reqpes.HISTORICO_REQUISICAO HR1 ");
    sql.append("                                      WHERE  HR1.REQUISICAO_SQ = HR.REQUISICAO_SQ)) HR ");
    sql.append(" WHERE  HR.REQUISICAO_SQ          = R.REQUISICAO_SQ ");
    sql.append(" AND    LPAD(U.COD_UNIDADE,3,'0') = SUBSTR(R.COD_UNIDADE,1,3) ");
    sql.append(" AND    CD.ID                 (+) = R.CARGO_SQ ");
    sql.append(" AND    R.COD_STATUS              IN (1, 2, 3, 4) "); //-- STATUS: ABERTA, HOMOLOGAÃ‡ÃƒO, REVISÃƒO, APROVADA
    sql.append(" AND    SYSDATE > HR.DT_ENVIO + " + contratacaoValidade + " - " + expiracaoAviso);
    sql.append(condicao);
    sql.append(" ORDER  BY HR.DT_ENVIO + " + contratacaoValidade + " - " + expiracaoAviso + " , R.REQUISICAO_SQ ");

    try{      
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoBaixaDAO  \n -> Problemas na consulta de getRequisicoesParaBaixaExpirando: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }   
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboCargosBaixa() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna os cargos relacionados as requisições para baixa
    sql.append(" SELECT UNIQUE T.CARGO_SQ ");
    sql.append("       ,T.CARGO ");
    sql.append(" FROM   reqpes.VW_REQUISICOES_PARA_BAIXA T ");
    sql.append(" ORDER  BY T.CARGO ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoBaixaDAO  \n -> Problemas na consulta getComboCargosBaixa: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboUnidadesBaixa() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna as unidades relacionadas as requisições para baixa
    sql.append(" SELECT UNIQUE T.COD_UNIDADE ");
    sql.append("       ,T.COD_UNIDADE || ' - ' ||T.NOM_UNIDADE ");
    sql.append(" FROM   reqpes.VW_REQUISICOES_PARA_BAIXA T ");
    sql.append(" ORDER  BY T.COD_UNIDADE ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoBaixaDAO  \n -> Problemas na consulta getComboUnidadesBaixa: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }    
}