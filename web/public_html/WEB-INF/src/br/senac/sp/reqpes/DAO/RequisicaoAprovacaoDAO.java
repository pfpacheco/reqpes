package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.Requisicao;
import br.senac.sp.reqpes.model.RequisicaoAprovacao;
import br.senac.sp.reqpes.Interface.Config;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.SQLException;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 30/10/2008
 */
 
public class RequisicaoAprovacaoDAO implements InterfaceDataBase{

  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public RequisicaoAprovacaoDAO(){

  }

  /**
   * @return int
   * @param  requisicao, usuario
   * @Procedure PROCEDURE SP_DML_REQUISICAO_HOMOLOGACAO(P_IN_TIPO               IN VARCHAR2
                                                       ,P_IN_REQUISICAO_SQ      IN NUMBER
                                                       ,P_IN_COD_UO_APROVADORA  IN VARCHAR2
                                                       ,P_IN_COD_UO_HOMOLOGADOR IN VARCHAR2                                                         
                                                       ,P_IN_NIVEL              IN NUMBER
                                                       ,P_IN_DSC_MOTIVO         IN VARCHAR2
                                                       ,P_IN_USUARIO            IN VARCHAR2) IS
   */
   
   public int homologaRequisicao(RequisicaoAprovacao requisicao, Usuario usuario)throws RequisicaoPessoalException{
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    CallableStatement stmt = null;
    
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_REQUISICAO_HOMOLOGACAO(?,?,?,?,?,?,?)}");
        stmt.setString(1,"A"); // A indica Aprovação na Homologação do gerente de unidade ou homologador da GEP
        stmt.setInt(2,requisicao.getCodRequisicao());
        stmt.setString(3,requisicao.getCodUnidadeAprovadora());
        stmt.setString(4,requisicao.getCodUnidadeHomologador());
        stmt.setInt(5,requisicao.getNivelWorkFlow());
        stmt.setString(6,requisicao.getDscMotivo());
        stmt.setString(7,String.valueOf(usuario.getUsuarioSq()));
        
        transacao.executeCallableStatement(stmt);
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro em homologaRequisicao: \nRequisição: "+requisicao.getCodRequisicao()+"\n",e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro em homologaRequisicao: \nRequisição: "+requisicao.getCodRequisicao()+"\n",e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com RequisicaoAprovacao ",e.getMessage());
      }
    }
     return sucesso;
  }  

   public int aprovaRequisicao(RequisicaoAprovacao requisicao, Usuario usuario)throws RequisicaoPessoalException{
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    CallableStatement stmt = null;
    
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_REQUISICAO_HOMOLOGACAO(?,?,?,?,?,?,?)}");
        stmt.setString(1,"AF"); // AF indica Aprovação Final na Homologação do gerente da Unidade Aprovadora
        stmt.setInt(2,requisicao.getCodRequisicao());
        stmt.setString(3,requisicao.getCodUnidadeAprovadora());
        stmt.setString(4,requisicao.getCodUnidadeHomologador());
        stmt.setInt(5,requisicao.getNivelWorkFlow());
        stmt.setString(6,requisicao.getDscMotivo());
        stmt.setString(7,String.valueOf(usuario.getUsuarioSq()));
        
        transacao.executeCallableStatement(stmt);
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro em aprovaRequisicao: \nRequisição: "+requisicao.getCodRequisicao()+"\n",e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro em aprovaRequisicao: \nRequisição: "+requisicao.getCodRequisicao()+"\n",e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com aprovaRequisicao ",e.getMessage());
      }
    }
     return sucesso;
  }  


   public int reprovaRequisicao(RequisicaoAprovacao requisicao, Usuario usuario)throws RequisicaoPessoalException{
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    CallableStatement stmt = null;
    
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_REQUISICAO_HOMOLOGACAO(?,?,?,?,?,?,?)}");
        stmt.setString(1,"R"); // R indica Reprovação
        stmt.setInt(2,requisicao.getCodRequisicao());
        stmt.setString(3,requisicao.getCodUnidadeAprovadora());
        stmt.setString(4,requisicao.getCodUnidadeHomologador());
        stmt.setInt(5,requisicao.getNivelWorkFlow());
        stmt.setString(6,requisicao.getDscMotivo());
        stmt.setString(7,String.valueOf(usuario.getUsuarioSq()));
        
        transacao.executeCallableStatement(stmt);
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao alterar a RequisicaoAprovacao: \nRequisição: "+requisicao.getCodRequisicao()+"\n",e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao alterar a RequisicaoAprovacao: \nRequisição: "+requisicao.getCodRequisicao()+"\n",e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com RequisicaoAprovacao ",e.getMessage());
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
      throw new RequisicaoPessoalException("RequisicaoAprovacaoDAO  \n -> Problemas na consulta de RequisicaoAprovacao: " + "\n\n" + sql.toString(), e.getMessage());
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
      throw new RequisicaoPessoalException("RequisicaoAprovacaoDAO  \n -> Problemas na consulta de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * Retorna as requisições para aprovação pelo homologador da unidade (ou unidades que o mesmo acessa)
   * @return String[][]
   * @throws RequisicaoPessoalException
   */  
  public String[][] getRequisicoesParaHomologacaoUO(int codUnidade, String codUnidadesLista) throws RequisicaoPessoalException{
    // Verifica se houve unidade relacionada ao perfil do usuário
    String complemento = "";
    if(codUnidadesLista != null && !codUnidadesLista.equals("") && !codUnidadesLista.equals(",") && !codUnidadesLista.equals("0")){
      complemento = " OR V.COD_UNIDADE_NUM IN ("+codUnidadesLista+") ";
    }
    String[][] requisicao = getRequisicoesParaHomologacao(" AND (V.NIVEL_WORKFLOW = 1 OR V.COD_STATUS = 3) AND (V.COD_UNIDADE_DESTINO LIKE LPAD("+codUnidade+",3,'0') || '%'  "+ complemento +") ");
    return (requisicao.length>0)?requisicao:null;
  }  
  
   /**
   * Retorna as requisições para aprovação pelo homologador da GEP (AP&B)
   * @return String[][]
   * @throws RequisicaoPessoalException
   */  
  public String[][] getRequisicoesParaHomologacaoGEP() throws RequisicaoPessoalException{
    String[][] requisicao = getRequisicoesParaHomologacao(" AND (V.COD_STATUS = 2 AND V.NIVEL_WORKFLOW = 2) OR (V.COD_STATUS = 3 AND V.COD_UNIDADE IN ('002C','012C'))");
    return (requisicao.length>0)?requisicao:null;
  }   
  
   /**
   * Retorna as requisições para aprovação pelo homologador da GEP (NEC)
   * @return String[][]
   * @throws RequisicaoPessoalException
   */  
  public String[][] getRequisicoesParaHomologacaoNEC(String listaUO) throws RequisicaoPessoalException{
    String[][] requisicao = getRequisicoesParaHomologacao(" AND V.COD_UNIDADE IN ("+ listaUO +") AND ((V.COD_STATUS = 2 AND V.NIVEL_WORKFLOW = 3) OR (V.COD_STATUS = 3 AND V.COD_UNIDADE IN ('002C','012C')))");
    return (requisicao.length>0)?requisicao:null;
  }   
  
   /**
   * Retorna as requisições para aprovação pelo aprovador geral
   * @return String[][]
   * @throws RequisicaoPessoalException
   */  
  public String[][] getRequisicoesParaHomologacaoAPR() throws RequisicaoPessoalException{
    String[][] requisicao = getRequisicoesParaHomologacao(" AND V.COD_STATUS = 2 AND V.NIVEL_WORKFLOW = 4 ");
    return (requisicao.length>0)?requisicao:null;
  } 
   

   /**
   * Retorna todas as requisições em processo de WorkFlow
   * @return String[][]
   * @throws RequisicaoPessoalException
   */  
  public String[][] getRequisicoesParaHomologacao() throws RequisicaoPessoalException{
    String[][] requisicao = getRequisicoesParaHomologacao("");
    return (requisicao.length>0)?requisicao:null;
  } 

   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getRequisicoesParaHomologacao(String condicao) throws RequisicaoPessoalException{
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
    sql.append(" WHERE 1 = 1");
    sql.append(condicao);
    sql.append(" ORDER  BY V.DT_REQUISICAO_SQL ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoAprovacaoDAO  \n -> Problemas na consulta de getRequisicoesParaHomologacao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno; 
  } 

   /**
   * Retorna o código da unidade do usuário no formato do RHEvolution. Ex: 014C
   * @return String[][]
   * @throws RequisicaoPessoalException
   */  
  public String getUnidadeRHEvolutionByChapa(int chapa) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    // Retorna o código da unidade do usuário no formato do RHEvolution. Ex: 014C
    sql.append(" SELECT U.UNIDADE ");
    sql.append(" FROM   reqpes.USUARIO U ");
    sql.append(" WHERE  U.IDENTIFICACAO = " + chapa);
    
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoAprovacaoDAO  \n -> Problemas na consulta de getUnidadeRHEvolutionByChapa: \n\n" + sql.toString(), e.getMessage());
    }
    return (retorno != null && retorno.length > 0)?retorno[0][0]:null;    
  }
  
   /**
   * Retorna o código da unidade formato do RHEvolution. Ex: 014C
   * @return String[][]
   * @throws RequisicaoPessoalException
   */  
  public String getUnidadeRHEvolutionByCodUnidade(int codUnidade) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    // Retorna o código da unidade no formato do RHEvolution. Ex: 014C
    sql.append(" SELECT UO.CODIGO ");
    sql.append(" FROM   UNIDADES_ORGANIZACIONAIS UO ");
    sql.append(" WHERE  UO.CODIGO LIKE LPAD('"+codUnidade+"',3,'0') || '%' ");
    sql.append(" AND    UO.NIVEL = 2 ");
    sql.append(" AND    UO.DATA_ENCERRAMENTO IS NULL ");
    
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoAprovacaoDAO  \n -> Problemas na consulta de getUnidadeRHEvolutionByCodUnidade: \n\n" + sql.toString(), e.getMessage());
    }
    return (retorno != null && retorno.length > 0)?retorno[0][0]:null;
  }  
  
   /**
   * Retorna os e-mails dos colaboradores envolvidos no processo de WorkFlow
   * @return String[]
   * @throws RequisicaoPessoalException
   */  
  public String[] getEmailsEnvolvidosWorkFlow(Requisicao requisicao) throws RequisicaoPessoalException, AdmTIException{
    
    ResponsavelEstruturaDAO responsavelEstruturaDAO = new ResponsavelEstruturaDAO();
    StringBuffer sql = new StringBuffer();
    String[] retorno = null;

    //-- Consulta: Retorna lista de e-mails de todos os envolvidos no processo de homologação da RP
    //--           exceto o e-mail do aprovador final da lista de envolvidos no workflow
    sql.append(" SELECT UNIQUE FC.E_MAIL ");
    sql.append(" FROM   reqpes.HISTORICO_REQUISICAO    HR ");
    sql.append("       ,FUNCIONARIO_COMPLEMENTO FC ");
    sql.append("       ,reqpes.USUARIO                 U ");
    sql.append(" WHERE  U.USUARIO_SQ     = HR.USUARIO_SQ ");
    sql.append(" AND    U.IDENTIFICACAO  = FC.ID_FUNCIONARIO ");
    sql.append(" AND    HR.REQUISICAO_SQ = " + requisicao.getCodRequisicao());
    sql.append(" AND    HR.NIVEL         <> 5 "); 
    sql.append(" AND    U.FL_ATIVO       = 'S' ");
    
    //-- Carregando lista de usuários do NEC
    sql.append(" UNION ");
    sql.append(" SELECT FC.E_MAIL ");
    sql.append(" FROM   reqpes.REQUISICAO              R ");
    sql.append("       ,reqpes.GRUPO_NEC_UNIDADES      G ");
    sql.append("       ,reqpes.GRUPO_NEC_USUARIOS      U ");
    sql.append("       ,FUNCIONARIO_COMPLEMENTO FC ");
    sql.append("       ,FUNCIONARIOS            F ");
    sql.append(" WHERE  R.REQUISICAO_SQ = " + requisicao.getCodRequisicao());
    sql.append(" AND    R.COD_UNIDADE   = G.COD_UNIDADE ");
    sql.append(" AND    G.COD_GRUPO     = U.COD_GRUPO ");
    sql.append(" AND    U.CHAPA         = FC.ID_FUNCIONARIO ");
    sql.append(" AND    F.ID            = FC.ID_FUNCIONARIO ");
    sql.append(" AND    F.ATIVO         = 'A' ");
        
    //-- Adicionando e-mail do gerente vigente
    if(!requisicao.getCodUnidade().equals("012C")){
      sql.append(" UNION  ");
      sql.append(" SELECT FC.E_MAIL ");
      sql.append(" FROM   FUNCIONARIO_COMPLEMENTO FC ");
      sql.append("       ,rhev.RESPONSAVEL_ESTRUTURA   RE ");
      sql.append(" WHERE  FC.ID_FUNCIONARIO = RE.FUNC_ID ");
      sql.append(" AND    RE.TEOR_COD    = '"+ responsavelEstruturaDAO.getTeorCodWorkflow() +"' ");
      sql.append(" AND    RE.UNOR_COD    = '"+ requisicao.getCodUnidade() +"' ");
      sql.append(" AND    TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN ");
    }
    
    try{
      retorno = manipulaDAO.getLista(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoAprovacaoDAO  \n -> Problemas na consulta de getUnidadeRHEvolutionByCodUnidade: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }    
  
   /**
   * Retorna os e-mails dos homologadores da Unidade aprovadora (GEP)
   * @return String[]
   * @throws RequisicaoPessoalException
   */  
  public String[] getEmailsHomologadoresGEP() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[] retorno = null;

    sql.append(" SELECT FC.E_MAIL ");
    sql.append(" FROM   adm_ti.SISTEMA_PARAMETRO       S ");
    sql.append("       ,geral.FUNCIONARIO_COMPLEMENTO FC ");
    sql.append("       ,geral.FUNCIONARIOS            F ");
    sql.append(" WHERE  S.COD_SISTEMA = " + Config.ID_SISTEMA);
    sql.append(" AND    S.NOM_PARAMETRO = 'HOMOLOGADOR_GEP' ");
    sql.append(" AND    F.ATIVO = 'A' ");
    sql.append(" AND    F.ID = FC.ID_FUNCIONARIO ");
    sql.append(" AND    FC.ID_FUNCIONARIO = S.VLR_SISTEMA_PARAMETRO ");
    sql.append(" AND    FC.E_MAIL IS NOT NULL ");
    
    try{
      retorno = manipulaDAO.getLista(sql.toString(),DATA_BASE_NAME_INFOGES);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoAprovacaoDAO  \n -> Problemas na consulta de getEmailsHomologadoresGEP: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * Retorna o e-mail do funcionário informado
   * @return String[]
   * @throws RequisicaoPessoalException
   */  
  public String getEmailByChapa(int chapa) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[] retorno = null;
    
    sql.append(" SELECT F.E_MAIL ");
    sql.append(" FROM   FUNCIONARIO_COMPLEMENTO F ");
    sql.append(" WHERE  F.ID_FUNCIONARIO = "+ chapa);
    
    try{
      retorno = manipulaDAO.getLista(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoAprovacaoDAO  \n -> Problemas na consulta de getEmailByChapa: \n\n" + sql.toString(), e.getMessage());
    }
    return (retorno != null && retorno.length > 0)?retorno[0]:null;
  }
  
   /**
   * Retorna o e-mail do responsável pela unidade informada
   * @return String[]
   * @throws RequisicaoPessoalException
   */  
  public String getEmailResponsavelUO(String codUnidade) throws RequisicaoPessoalException, AdmTIException{
    ResponsavelEstruturaDAO responsavelEstruturaDAO = new ResponsavelEstruturaDAO();
    StringBuffer sql = new StringBuffer();
    String[] retorno = null;
    
    sql.append(" SELECT FC.E_MAIL ");
    sql.append(" FROM   RESPONSAVEL_ESTRUTURA   RE ");
    sql.append("       ,FUNCIONARIO_COMPLEMENTO FC ");
    sql.append(" WHERE  RE.TEOR_COD = '" + responsavelEstruturaDAO.getTeorCodWorkflow()+"' ");
    sql.append(" AND    RE.UNOR_COD = '" + codUnidade +"' ");
    sql.append(" AND    RE.FUNC_ID  = FC.ID_FUNCIONARIO ");
    sql.append(" AND    SYSDATE BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN ");
    
    try{
      retorno = manipulaDAO.getLista(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoAprovacaoDAO  \n -> Problemas na consulta de getEmailResponsavelUO: \n\n" + sql.toString(),e.getMessage());
    }
    return (retorno != null && retorno.length > 0)?retorno[0].trim():null;
  }    
  
   /**
   * Retorna o nível atual no workflow de aprovação da RP
   * @return int 0 - ERRO
   *             1 - Gerente Unidade
   *             2 - AP&B
   *             3 - NEC
   *             4 - Aprovador Final
   * @throws RequisicaoPessoalException
   */  
  public int getNivelAprovacaoAtual(int codRequisicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[] retorno = null;
    
    sql.append(" SELECT H.NIVEL ");
    sql.append(" FROM   reqpes.HISTORICO_REQUISICAO H ");
    sql.append(" WHERE  H.DT_ENVIO = (SELECT MAX(H1.DT_ENVIO) ");
    sql.append("                      FROM   HISTORICO_REQUISICAO H1 ");
    sql.append("                      WHERE  H1.REQUISICAO_SQ = " + codRequisicao);
    sql.append("                      AND    H1.NIVEL BETWEEN 1 AND 4) ");
    
    try{
      retorno = manipulaDAO.getLista(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoAprovacaoDAO  \n -> Problemas na consulta de getNivelAprovacaoAtual: \n\n" + sql.toString(),e.getMessage());
    }
    return (retorno != null && retorno.length > 0)?Integer.parseInt(retorno[0]):0;
  }    
}