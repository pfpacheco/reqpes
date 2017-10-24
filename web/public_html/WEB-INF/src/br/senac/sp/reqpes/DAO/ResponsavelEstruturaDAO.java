package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.componente.control.SistemaParametroControl;
import br.senac.sp.componente.control.UnidadeControl;
import br.senac.sp.componente.model.SistemaParametro;
import br.senac.sp.componente.model.Unidade;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Control.GrupoNecUsuarioControl;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.Config;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.GrupoNecUsuario;
import br.senac.sp.reqpes.model.ResponsavelEstrutura;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 26/09/2008
 */
public class ResponsavelEstruturaDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO = new ManipulacaoDAO();

  public ResponsavelEstruturaDAO(){

  }

  /**
   * @return lista ([0]..[1]) UO_CERTA .. ID_GERENTE
   * @param  codUnidade Ex: 014C
   * @Procedure PROCEDURE SP_GET_UNIDADE_DESTINO(P_COD_UNIORG IN OUT VARCHAR2
                                                ,P_UO_CERTA   IN OUT VARCHAR2
                                                ,P_ID_GER     IN OUT NUMBER
                                                ,P_TENTATIVA  IN OUT NUMBER
                                                ,P_TEOR_COD   IN OUT VARCHAR2) IS
   */
   
   public String[] buscarUnidadeDestino(String codUnidade) throws RequisicaoPessoalException{
    String[] sucesso = null;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    CallableStatement stmt = null;
        
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_GET_UNIDADE_DESTINO(?,?,?,?,?)}");
        stmt.setString(1,codUnidade);
        stmt.setString(2,null);
        stmt.setInt(3,0);
        stmt.setInt(4,1);
        stmt.setString(5,this.getTeorCodWorkflow());

        // registrando parametros de saida
        stmt.registerOutParameter(2,Types.VARCHAR); // retornando a UO correta no WorkFlow
        stmt.registerOutParameter(3,Types.INTEGER); // retornando a chapa do Gerente responsável pela UO

        transacao.executeCallableStatement(stmt);
        
        sucesso = new String[] {stmt.getString(2), String.valueOf(stmt.getInt(3))};
        
    }catch(SQLException e){
      sucesso = null;
      throw new RequisicaoPessoalException( "Ocorreu um erro ao buscarUnidadeDestino: \n"+codUnidade+"\n" ,e.getMessage());
    }catch(Exception e){
      sucesso = null;
      throw new RequisicaoPessoalException("Ocorreu um erro ao buscarUnidadeDestino: \n"+codUnidade+"\n" ,e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com ResponsavelEstrutura " ,e.getMessage());
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
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta  de ResponsavelEstrutura: \n\n " + sql.toString(), e.getMessage());
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
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta de ResponsavelEstrutura: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public boolean isUsuarioWorkflow(int chapa) throws RequisicaoPessoalException, AdmTIException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna se a chapa informada está no WorkFlow (RESPONSAVEL_ESTRUTURA)
    sql.append(" SELECT COUNT(*), ''");
    sql.append(" FROM   RESPONSAVEL_ESTRUTURA RE ");
    sql.append(" WHERE  RE.TEOR_COD = '" + this.getTeorCodWorkflow().trim()+"'");
    sql.append(" AND    RE.FUNC_ID  =  " + chapa);
    sql.append(" AND    TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta de isUsuarioWorkflow: \n\n " + sql.toString(), e.getMessage());
    }
    return (retorno != null && Integer.parseInt(retorno[0][0]) > 0);
  }  

   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public boolean isAprovadorFinal(int chapa) throws RequisicaoPessoalException, AdmTIException{
    //-- Objetos de controle
    SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
    
    StringBuffer sql = new StringBuffer();
    String[] retorno = null;

    //-- Resgatando os homologadores da GEP
    SistemaParametro unidadeAprovadora = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "UNIDADE_APROVADORA");
    
    sql.append(" SELECT COUNT(*) ");
    sql.append(" FROM   RESPONSAVEL_ESTRUTURA RE ");
    sql.append(" WHERE  RE.TEOR_COD = '"+ this.getTeorCodWorkflow()+"' ");
    sql.append(" AND    RE.UNOR_COD = '"+ unidadeAprovadora.getVlrSistemaParametro()+"' ");
    sql.append(" AND    RE.FUNC_ID  =  "+ chapa);
    sql.append(" AND    TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN ");    

    try{
      retorno = manipulaDAO.getLista(sql.toString(),"DsRequisicaoPessoal");
    }catch(Exception e){
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta de isAprovadorFinal: \n\n " + sql.toString(), e.getMessage());
    }
    return (retorno != null && Integer.parseInt(retorno[0]) > 0);
  } 
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public boolean isUsuarioHomologadorGEP(int chapa) throws RequisicaoPessoalException{
    //-- Objetos de controle
    SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
    boolean retorno = false;
    
    try{
      //-- Resgatando os homologadores da GEP
      SistemaParametro[] homologadoresGEP = sistemaParametroControl.getSistemaParametrosPorSistemaNome(Config.ID_SISTEMA, "HOMOLOGADOR_GEP");
      
      //-- Verificando se a chapa informada está na lista de homologadores
      for(int i=0; i<homologadoresGEP.length; i++){
        if(Integer.parseInt(homologadoresGEP[i].getVlrSistemaParametro()) == chapa){
          retorno = true;
          break;
        }
      }

    }catch(Exception e){
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta de isUsuarioHomologadorGEP: \n\n " , e.getMessage());
    }
    return retorno;
  } 
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public boolean isUsuarioHomologadorNEC(int chapa) throws RequisicaoPessoalException{
    GrupoNecUsuario usuario = null;
    
    try{
        usuario = new GrupoNecUsuarioControl().getGrupoNecUsuario(chapa);
    }catch(Exception e){
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta de isUsuarioHomologadorNEC: \n\n " , e.getMessage());
    }
    return (usuario != null);
  }   
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public ResponsavelEstrutura getResponsavelEstrutura(Usuario usuario) throws RequisicaoPessoalException{
    //-- Objetos de controle
    SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
    ResponsavelEstrutura    responsavelEstrutura    = new ResponsavelEstrutura();
        
    Unidade[] listaUnidades = null;
    int chapa     = usuario.getChapa();
    int codPerfil = usuario.getSistemaPerfil().getCodSistemaPerfil();
    
    
    try{    
      //-- Carreganco os id's dos perfis
      SistemaParametro idPerfilAPR = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_APR_GEP");
      SistemaParametro idPerfilHOM = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_UO");
      SistemaParametro idPerfilGEP = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_GEP");
      SistemaParametro idPerfilNEC = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_NEC");

      //-- verifica se está no Workflow
      if(this.isUsuarioWorkflow(chapa)){
        if(this.isAprovadorFinal(chapa)){
          // seta perfil de APROVADOR FINAL (GEP)
          responsavelEstrutura.setCodPerfilUsuario(Integer.parseInt(idPerfilAPR.getVlrSistemaParametro()));
        }else{
          // seta perfil de HOMOLOGADOR UO (GERENTE)
          responsavelEstrutura.setCodPerfilUsuario(Integer.parseInt(idPerfilHOM.getVlrSistemaParametro()));
          // seta as unidades de acesso do gerente com a da RESPOSAVEL_ESTRUTURA            
          listaUnidades = this.getUnidadesAcessoWorkflow(usuario);
          responsavelEstrutura.setUnidades(listaUnidades);          
        }
      }else{        
          //-- verifica se é homologador da GEP - AP&B
          if(this.isUsuarioHomologadorGEP(chapa)){
             responsavelEstrutura.setCodPerfilUsuario(Integer.parseInt(idPerfilGEP.getVlrSistemaParametro()));
          }else
             //-- verifica se é homologador da GEP - NEC
             if(this.isUsuarioHomologadorNEC(chapa)){
               responsavelEstrutura.setCodPerfilUsuario(Integer.parseInt(idPerfilNEC.getVlrSistemaParametro()));                       
             }else{
               // retorna o mesmo perfil, no caso de CRIAÇÃO ou ADMINISTRADOR
               responsavelEstrutura.setCodPerfilUsuario(codPerfil);
             }        
      }

    }catch(Exception e){
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta de getResponsavelEstrutura: \n\n" + e.getMessage());
    }
    return responsavelEstrutura;
  }    
  
   /**
   * @return String[] (Nome da Unidade, Nome do gerente, telefone do Gerente)
   * @throws RequisicaoPessoalException
   */  
  public String[][] getDadosResponsavel(String codUnidade, int chapa) throws RequisicaoPessoalException{   
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;

    sql.append(" SELECT UO.DESCRICAO DSC_UNIDADE ");
    sql.append("       ,F.NOME       NOM_GERENTE ");
    sql.append("       ,FD.VALOR     TELEFONE ");
    sql.append(" FROM   FUNCIONARIOS               F ");
    sql.append("       ,FUNCIONARIO_DADO_ADICIONAL FD ");
    sql.append("       ,UNIDADES_ORGANIZACIONAIS   UO ");
    sql.append(" WHERE  F.ID                 = FD.ID_FUNCIONARIO ");
    sql.append(" AND    F.ID                 = " + chapa);
    sql.append(" AND    FD.TDAF_CODIGO       = 181 ");
    sql.append(" AND    UO.CODIGO            = '"+codUnidade+"' ");
    sql.append(" AND    UO.DATA_ENCERRAMENTO IS NULL ");
    sql.append(" AND    UO.NIVEL             = 2 ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta de getDadosResponsavel: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }
  
  /**
   * Retorna o workflow que está sendo utilizado na folha
   * @return String teorCodWorkflow
   * @throws br.senac.sp.exception.AdmTIException
   */
   public String getTeorCodWorkflow() throws AdmTIException{     
      //-- Resgatando o WorkFlow da Folha que está sendo utilizado
      SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
      String teorCodWorkflow = null;
      try{
        SistemaParametro teorCod = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "TEOR_COD_WORKFLOW");
        teorCodWorkflow = teorCod.getVlrSistemaParametro();
      }catch (Exception e){
        throw new AdmTIException("Requisição de Pessoal: Erro em getTeorCodWorkflow:\n\n", e.getMessage());
      }      
     return teorCodWorkflow;
   }  

  /**
   * Retorna lista de unidades de acesso na responsavel estrutura
   * @return String[] getUnidadesAcessoWorkflow
   * @throws RequisicaoPessoalException, AdmTIException
   */
   public Unidade[] getUnidadesAcessoWorkflow(Usuario usuario) throws RequisicaoPessoalException, AdmTIException{     
    //-- Objetos de controle
    UnidadeControl unidadeControl = new UnidadeControl();
        
    StringBuffer sql = new StringBuffer();
    Unidade[]  unidades = null;
    String[][] retorno  = null;
    String listaUnidadesUsuario  = "";
    String listaUnidadesWorkflow = "";
    String where = "";
    
    sql.append(" SELECT DECODE(SUBSTR(RE.UNOR_COD,0,1), '0', SUBSTR(RE.UNOR_COD,2,2), SUBSTR(RE.UNOR_COD,1,3)) UO, ' '");
    sql.append(" FROM   RESPONSAVEL_ESTRUTURA RE ");
    sql.append(" WHERE  RE.TEOR_COD = '"+ this.getTeorCodWorkflow()+"' ");
    sql.append(" AND    RE.FUNC_ID  =  "+ usuario.getChapa());
    sql.append(" AND    TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN ");    
    
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);

      //-- Carregando as unidades adicionais do usuário
      for(int i=0; usuario.getUnidades()!=null && i<usuario.getUnidades().length; i++){
        listaUnidadesUsuario += ((i==0)?"":",") + usuario.getUnidades()[i].getCodUnidade();
      }       
            
      //-- Carregando resultado da pesquisa 
      for(int i=0; retorno!= null && i<retorno.length; i++){
        listaUnidadesWorkflow += ((i==0)?"":",") + retorno[i][0];
      }

      if(!listaUnidadesUsuario.equals("") && !listaUnidadesUsuario.equals(",") && !listaUnidadesUsuario.equals(" ,") ){
        where = listaUnidadesUsuario;
      }
      
      if(!listaUnidadesWorkflow.equals("") && !listaUnidadesWorkflow.equals(",") && !listaUnidadesWorkflow.equals(" ,")){
        if(where.equals("")){
          where = listaUnidadesWorkflow;
        }else{
          where += " , " + listaUnidadesWorkflow;
        }
      }

      unidades = unidadeControl.getUnidades(" WHERE COD_UNIDADE IN ("+ where +")");
      
    }catch(Exception e){
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta de getCodUnidadeByUsuarioWorkFlow: \nCláusula de pesquisa:"+where+"\nUsuário:"+usuario.getChapa()+"\n\n " + sql.toString(), e.getMessage());
    }
    return unidades;    
  }
   
  /**
   * Retorna o código da unidade do usuario informado
   * @return String getCodUnidadeByUsuarioWorkFlow
   * @throws RequisicaoPessoalException, AdmTIException
   */
   public String getCodUnidadeByUsuarioWorkFlow(int chapa) throws RequisicaoPessoalException, AdmTIException{        
    StringBuffer sql = new StringBuffer();
    String[] retorno = null;
    
    sql.append(" SELECT RE.UNOR_COD ");
    sql.append(" FROM   RESPONSAVEL_ESTRUTURA RE ");
    sql.append(" WHERE  RE.TEOR_COD = '"+ this.getTeorCodWorkflow()+"' ");
    sql.append(" AND    RE.FUNC_ID  =  "+ chapa);
    sql.append(" AND    TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN ");    

    try{
      retorno = manipulaDAO.getLista(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta de getCodUnidadeByUsuarioWorkFlow: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno[0];    
  }
  
  /**
   * Retorna o código da unidade em formato numérico
   * @return int getCodUnidade
   * @throws RequisicaoPessoalException
   */
   public ResponsavelEstrutura getCodUnidade(String codUnidadeRHEV) throws RequisicaoPessoalException{         
    StringBuffer sql = new StringBuffer();
    ResponsavelEstrutura responsavelEstrutura = new ResponsavelEstrutura();
    String[] retorno = null;
    int codUnidade;
    
    sql.append(" SELECT UNIQUE U.COD_UNIDADE FROM USUARIO U WHERE U.UNIDADE = '"+ codUnidadeRHEV +"' ");    

    try{
      retorno = manipulaDAO.getLista(sql.toString(),DATA_BASE_NAME);
      codUnidade = (retorno != null)?Integer.parseInt(retorno[0]):0;
      responsavelEstrutura.setCodUnidadeUsuario(codUnidade);
    }catch(Exception e){
      throw new RequisicaoPessoalException("ResponsavelEstruturaDAO  \n -> Problemas na consulta de getCodUnidade: \n\n " + sql.toString(), e.getMessage());
    }
    return responsavelEstrutura;
  }  
  
}