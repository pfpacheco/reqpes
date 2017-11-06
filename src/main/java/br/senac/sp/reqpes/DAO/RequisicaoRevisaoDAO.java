package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.RequisicaoRevisao;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 30/10/2008
 */
 
public class RequisicaoRevisaoDAO implements InterfaceDataBase{

  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public RequisicaoRevisaoDAO(){

  }

  /**
   * @return int
   * @param  requisicao, usuario
   * @Procedure PROCEDURE SP_DML_REQUISICAO_REVISAO(P_IN_DML           IN NUMBER
                                                   ,P_IN_REQUISICAO_SQ IN NUMBER
                                                   ,P_IN_MOTIVO        IN VARCHAR2
                                                   ,P_IN_USUARIO_SQ    IN NUMBER
                                                   ,P_IN_PERFIL_HOM    IN NUMBER
                                                   ,P_IN_CHAPA         IN NUMBER) IS
   */
   
   private int dmlRequisicaoRevisao(int tipoDML, RequisicaoRevisao requisicao, Usuario usuario, int indPerfilHOM)throws RequisicaoPessoalException{
    
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    String tipoTransacao = "";
    CallableStatement stmt = null;
    
    switch(tipoDML){
      case  0 : tipoTransacao = "inserir" ; break;
      case  1 : tipoTransacao = "alterar" ; break;
    };
    
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_REQUISICAO_REVISAO(?,?,?,?,?,?)}");
        stmt.setInt(1,tipoDML); // 0 INSERT, 1 UPDATE
        stmt.setInt(2,requisicao.getCodRequisicao());
        stmt.setString(3,requisicao.getDscMotivo());
        stmt.setString(4,String.valueOf(usuario.getUsuarioSq()));
        stmt.setInt(5,indPerfilHOM);
        stmt.setString(6,String.valueOf(usuario.getChapa()));
        
        //-- Registrando parametro de saída
        stmt.registerOutParameter(2, Types.INTEGER);
        
        transacao.executeCallableStatement(stmt);
        sucesso = stmt.getInt(2);
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a RequisicaoRevisao: \nRequisição: "+requisicao.getCodRequisicao()+"\n" ,e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a RequisicaoRevisao: \nRequisição: "+requisicao.getCodRequisicao()+"\n" ,e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com RequisicaoRevisao " ,e.getMessage());
      }
    }
     return sucesso;      
   }   
   
   public int gravaRequisicaoRevisao(RequisicaoRevisao requisicao, Usuario usuario) throws RequisicaoPessoalException{
      return this.dmlRequisicaoRevisao(0, requisicao, usuario, 0);
   }  

   public int alteraRequisicaoRevisao(RequisicaoRevisao requisicao, Usuario usuario, int indPerfilHOM) throws RequisicaoPessoalException{
      return this.dmlRequisicaoRevisao(1, requisicao, usuario, indPerfilHOM);
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
      throw new RequisicaoPessoalException("RequisicaoRevisaoDAO  \n -> Problemas na consulta de RequisicaoRevisao: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getRequisicoesParaRevisao(int codUnidade, String listaUnidade) throws RequisicaoPessoalException{
    // Verifica se houve unidade relacionada ao perfil do usuário
    String complemento = "";
    if(listaUnidade != null && !listaUnidade.equals("") && !listaUnidade.equals(",") && !listaUnidade.equals("0")){
      complemento = " OR V.COD_UNIDADE_NUM IN ("+listaUnidade+") ";
    }
    return getRequisicoesParaRevisao(" AND (V.COD_UNIDADE LIKE LPAD("+codUnidade+",3,'0') || '%'  "+ complemento +") ");    
  }
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getRequisicoesParaRevisao(String condicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna as requisições que podem ser efetuadas baixas
    sql.append(" SELECT V.REQUISICAO_SQ ");
    sql.append("       ,V.DT_REQUISICAO ");
    sql.append("       ,V.CARGO ");
    sql.append("       ,V.COD_UNIDADE ");
    sql.append("       ,V.IND_TIPO_REQUISICAO ");
    sql.append("       ,V.DSC_STATUS ");
    sql.append("       ,V.COD_STATUS ");
    sql.append("       ,V.SGL_UNIDADE ");
    sql.append("       ,V.NOM_UNIDADE ");    
    sql.append(" FROM   reqpes.VW_REQUISICOES_PARA_APROVACAO V ");
    sql.append(" WHERE  V.COD_STATUS = 3 "); //-- STATUS: EM REVISÃO
    sql.append(condicao);
    sql.append(" ORDER  BY V.DT_REQUISICAO, V.REQUISICAO_SQ, V.COD_UNIDADE, V.CARGO ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoRevisaoDAO  \n -> Problemas na consulta de getRequisicoesParaBaixa: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno; 
  } 
  
  
  public RequisicaoRevisao[] getDadosRevisao(int codRequisicao) throws RequisicaoPessoalException{
      StringBuffer sql = new StringBuffer();
      ArrayList listaRequisicao = new ArrayList();
      RequisicaoRevisao requisicaoRevisao = new RequisicaoRevisao();
      RequisicaoRevisao[] requisicaoRevisoes = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      ResultSet rs = null;

      //-- Query que retorna os dados de revisão de uma determinada requisição
      sql.append(" SELECT RV.REQUISICAO_SQ ");
      sql.append("       ,RV.NRO_REVISAO ");
      sql.append("       ,FC.NOME        AS NOM_CRIADOR ");
      sql.append("       ,UC.UNIDADE     AS COD_UO_CRIADOR ");
      sql.append("       ,UOC.DESCRICAO  AS DSC_UO_CRIADOR ");
      sql.append("       ,TO_CHAR(R.DT_REQUISICAO, 'dd/mm/yyyy HH24:mm:ss') AS DAT_CRIACAO ");
      sql.append("       ,FR.NOME       AS NOM_REVISOR ");
      sql.append("       ,UR.UNIDADE    AS COD_UO_REVISOR ");
      sql.append("       ,UOR.DESCRICAO AS DSC_UO_REVISOR ");
      sql.append("       ,TO_CHAR(HR.DT_ENVIO, 'dd/mm/yyyy HH24:mm:ss') AS DAT_REVISAO ");
      sql.append("       ,RV.MOTIVO ");
      sql.append(" FROM   reqpes.USUARIO                   UR ");
      sql.append("       ,reqpes.USUARIO                   UC ");
      sql.append("       ,FUNCIONARIOS  		           FR ");
      sql.append("       ,FUNCIONARIOS            		   FC ");  
      sql.append("       ,reqpes.REQUISICAO_REVISAO        RV ");
      sql.append("       ,UNIDADES_ORGANIZACIONAIS 	       UOR ");
      sql.append("       ,UNIDADES_ORGANIZACIONAIS 		   UOC ");      
      sql.append("       ,reqpes.HISTORICO_REQUISICAO      HR ");
      sql.append("       ,reqpes.REQUISICAO                R ");
      sql.append(" WHERE  UR.IDENTIFICACAO   = FR.ID ");
      sql.append(" AND    UC.IDENTIFICACAO   = FC.ID ");
      sql.append(" AND    UR.USUARIO_SQ      = HR.USUARIO_SQ ");
      sql.append(" AND    UC.USUARIO_SQ      = R.USUARIO_SQ ");
      sql.append(" AND    UR.UNIDADE         = UOR.CODIGO ");
      sql.append(" AND    UC.UNIDADE         = UOC.CODIGO ");
      sql.append(" AND    HR.REQUISICAO_SQ   = RV.REQUISICAO_SQ ");
      sql.append(" AND    R.REQUISICAO_SQ    = RV.REQUISICAO_SQ ");
      sql.append(" AND    RV.STATUS          = 'aberta' ");
      sql.append(" AND    HR.DT_ENVIO        = (SELECT MAX(HR1.DT_ENVIO)  ");
      sql.append("                              FROM   reqpes.HISTORICO_REQUISICAO HR1 ");
      sql.append("                              WHERE  HR1.REQUISICAO_SQ = HR.REQUISICAO_SQ ");
      sql.append("                              AND    HR1.STATUS        = 'solicitou revisão') ");
      sql.append(" AND    R.REQUISICAO_SQ    = " + codRequisicao);

      try{
         rs = transacao.getCursor(sql.toString());
         while(rs.next()){
           // Setando os atributos
           requisicaoRevisao.setCodRequisicao(rs.getInt("REQUISICAO_SQ"));
           requisicaoRevisao.setNroRevisoes(rs.getInt("NRO_REVISAO"));
           requisicaoRevisao.setDscMotivo(rs.getString("MOTIVO"));
           requisicaoRevisao.setDataHoraEnvio(rs.getString("DAT_REVISAO"));
           requisicaoRevisao.setDataHoraCriacao(rs.getString("DAT_CRIACAO"));
           
           requisicaoRevisao.setNomRevisor(rs.getString("NOM_REVISOR"));                      
           requisicaoRevisao.setCodUnidadeRevisor(rs.getString("COD_UO_REVISOR"));
           requisicaoRevisao.setNomUnidadeRevisor(rs.getString("DSC_UO_REVISOR"));

           requisicaoRevisao.setNomCriador(rs.getString("NOM_CRIADOR"));                      
           requisicaoRevisao.setCodUnidadeCriador(rs.getString("COD_UO_CRIADOR"));
           requisicaoRevisao.setNomUnidadeCriador(rs.getString("DSC_UO_CRIADOR"));           
          
           // Adicionando na lista
           listaRequisicao.add(requisicaoRevisao);
           requisicaoRevisao = new RequisicaoRevisao();
        }

        // Dimensionando o array
        requisicaoRevisoes = new RequisicaoRevisao[listaRequisicao.size()];

        // Transferindo a lista para o array
        listaRequisicao.toArray(requisicaoRevisoes);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoRevisaoDAO  \n -> Problemas na consulta getDadosRevisao: " + e.getMessage(), e.getMessage() + " \n \n" + sql.toString());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("RequisicaoRevisaoDAO  \n -> Problemas ao fechar a conexão: " + e.getMessage(),e.getMessage() + " \n \n" + sql.toString());
       }
    }
    return requisicaoRevisoes;
   }  
   
   /**
   * @return int codRequisicao
   * @throws RequisicaoPessoalException
   */
  public int getQtdRevisoes(int codRequisicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[] retorno = null;
    
    //-- Query que retorna a quantidade de vezes que a requisição foi revisadas
    sql.append(" SELECT COUNT(*) ");
    sql.append(" FROM   reqpes.REQUISICAO_REVISAO R ");
    sql.append(" WHERE  R.REQUISICAO_SQ = " + codRequisicao);

    try{
      retorno = manipulaDAO.getLista(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoRevisaoDAO  \n -> Problemas na consulta de getRequisicoesParaBaixa: " + e.getMessage() + " \n \n" + sql.toString(),sql.toString());
    }
    return Integer.parseInt(retorno[0]);
  }    
}