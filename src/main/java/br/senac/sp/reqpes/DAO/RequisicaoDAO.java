package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.Requisicao;

//-- Classes do Java
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

import oracle.jdbc.OracleTypes;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 16/09/2008
 */
 
public class RequisicaoDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public RequisicaoDAO(){

  }

  /**
   * Retorna todas as requisicaos cadastradas no sistema
   * @param  requisicao
   * @return Requisicao[]
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public Requisicao[] getRequisicaos() throws RequisicaoPessoalException {
    return getRequisicaos("");
  }

  /**
   * @return int
   * @param  requisicao, usuario
   * @Procedure PROCEDURE SP_DML_REQUISICAO(P_IN_DML                     IN NUMBER
                                           ,P_IN_OUT_REQUISICAO_SQ       IN OUT NUMBER
                                           ,P_IN_COD_UNIDADE             IN VARCHAR2
                                           ,P_IN_COD_MA                  IN VARCHAR2
                                           ,P_IN_COD_SMA                 IN VARCHAR2                                             
                                           ,P_IN_USUARIO_SQ              IN NUMBER
                                           ,P_IN_CARGO_SQ                IN NUMBER
                                           ,P_IN_COTA                    IN NUMBER
                                           ,P_IN_TP_CONTRATACAO          IN VARCHAR2
                                           ,P_IN_NM_SUPERIOR             IN VARCHAR2
                                           ,P_IN_FONE_UNIDADE            IN VARCHAR2
                                           ,P_IN_JORNADA_TRABALHO        IN NUMBER
                                           ,P_IN_LOCAL_TRABALHO          IN VARCHAR2
                                           ,P_IN_MOTIVO_SOLICITACAO      IN VARCHAR2
                                           ,P_IN_OBS                     IN VARCHAR2
                                           ,P_IN_SUPERVISAO              IN VARCHAR2
                                           ,P_IN_NR_FUNCIONARIO          IN NUMBER
                                           ,P_IN_DS_TAREFA               IN VARCHAR2
                                           ,P_IN_VIAGEM                  IN VARCHAR2
                                           ,P_IN_SALARIO                 IN NUMBER
                                           ,P_IN_OUTRO_LOCAL             IN VARCHAR2
                                           ,P_IN_NM_INDICADO             IN VARCHAR2
                                           ,P_IN_INICIO_CONTRATACAO      IN DATE
                                           ,P_IN_FIM_CONTRATACAO         IN DATE
                                           ,P_IN_COD_RECRUTAMENTO        IN NUMBER
                                           ,P_IN_COD_AREA                IN NUMBER
                                           ,P_IN_RAZAO_SUBSTITUICAO      IN VARCHAR2
                                           ,P_IN_TIPO_INDICACAO          IN VARCHAR2
                                           ,P_IN_DS_MOTIVO_SOLICITACAO   IN VARCHAR2
                                           ,P_IN_CLASSIFICACAO_FUNCIONAL IN NUMBER
                                           ,P_IN_ID_INDICADO             IN NUMBER
                                           ,P_IN_SUBSTITUIDO_ID_HIST     IN NUMBER
                                           ,P_IN_TRANSFERENCIA_DATA      IN DATE
                                           ,P_IN_IND_CARTA_CONVTE        IN CHAR
                                           ,P_IN_IND_EX_CARTA_CONVTE     IN CHAR
                                           ,P_IN_IND_EX_FUNCIONARIO      IN CHAR
                                           ,P_IN_IND_TIPO_REQUISICAO     IN VARCHAR2
                                           ,P_IN_COD_STATUS              IN NUMBER
                                           ,P_IN_USUARIO                 IN VARCHAR2
                                           ,P_IN_SEGMENTO_1              IN VARCHAR2
                                           ,P_IN_SEGMENTO_2              IN VARCHAR2
                                           ,P_IN_SEGMENTO_3              IN VARCHAR2
                                           ,P_IN_SEGMENTO_4              IN VARCHAR2
                                           ,P_IN_SEGMENTO_5              IN VARCHAR2
                                           ,P_IN_SEGMENTO_6              IN VARCHAR2
                                           ,P_IN_SEGMENTO_7              IN VARCHAR2
                                           ,P_IN_NIVEL                   IN NUMBER
                                           ,P_IN_DSC_RECRUTAMENTO        IN VARCHAR2
                                           ,P_IN_CARATER_EXCECAO         IN VARCHAR2
                                           ,P_IN_VERSAO_SISTEMA          IN VARCHAR2
                                           ,P_IN_ID_CODE_COMBINATION	 IN NUMBER) IS
   */
   
   private int dmlRequisicao(int tipoDML, Requisicao requisicao, Usuario usuario)throws RequisicaoPessoalException{
    
    int sucesso = 1;
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    StringBuffer parametros = new StringBuffer();
    String tipoTransacao = "";
    CallableStatement stmt = null;
    
    switch(tipoDML){
      case -1 : tipoTransacao = "excluir" ; break;
      case  0 : tipoTransacao = "inserir" ; break;
      case  1 : tipoTransacao = "alterar" ; break;
    };
    
    try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_REQUISICAO(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
        stmt.setInt(1,tipoDML); // 0 INSERT, 1 UPDATE, -1 DELETE 
        stmt.setInt(2,requisicao.getCodRequisicao());
        stmt.setString(3,requisicao.getCodUnidade());
        stmt.setString(4,requisicao.getCodMA());
        stmt.setString(5,requisicao.getCodSMA());
        stmt.setInt(6,usuario.getUsuarioSq());
        stmt.setInt(7,requisicao.getCodCargo());
        stmt.setInt(8,requisicao.getCotaCargo());
        stmt.setString(9,requisicao.getIndTipoContratacao());
        stmt.setString(10,requisicao.getNomSuperior());
        stmt.setString(11,requisicao.getTelUnidade());
        stmt.setDouble(12,requisicao.getJornadaTrabalho());
        stmt.setString(13,requisicao.getIndLocalTrabalho());
        stmt.setString(14,requisicao.getCodRPPara());
        stmt.setString(15,requisicao.getComentarios());
        stmt.setString(16,requisicao.getIndSupervisao());
        stmt.setInt(17,requisicao.getNumFuncionariosSupervisao());
        stmt.setString(18,requisicao.getDscTarefasDesempenhadas());
        stmt.setString(19,requisicao.getIndViagem());
        stmt.setString(20,requisicao.getSalario());
        stmt.setString(21,requisicao.getOutroLocal());
        stmt.setString(22,requisicao.getNomIndicado());
        
        if(requisicao.getCodRecrutamento() != 1){
        	stmt.setDate(23,requisicao.getDatInicioContratacao());
        	if(requisicao.getIndTipoContratacao().equals("1")){
        		stmt.setNull(24,OracleTypes.DATE);
        	}else{
        		stmt.setDate(24,requisicao.getDatFimContratacao());
        	}      	
        }else{
        	stmt.setNull(23,OracleTypes.DATE);
        	stmt.setNull(24,OracleTypes.DATE);
        }
        
        stmt.setInt(25,requisicao.getCodRecrutamento());
        stmt.setInt(26,requisicao.getCodArea());
        stmt.setString(27,requisicao.getCodMotivoSolicitacao());
        stmt.setString(28,requisicao.getIndTipoIndicacao());
        stmt.setString(29,requisicao.getDscMotivoSolicitacao());
        stmt.setInt(30,requisicao.getCodClassificacaoFuncional());
        stmt.setInt(31,requisicao.getIdIndicado());        
        stmt.setInt(32,requisicao.getIdSubstitutoHist());
        
        if(requisicao.getCodRecrutamento() == 1){
        	stmt.setDate(33,requisicao.getDatTransferencia());
        }else{
        	stmt.setNull(33, OracleTypes.DATE);
        }
        
        stmt.setDate(33,requisicao.getDatTransferencia());
        stmt.setString(34,requisicao.getIndCartaConvite());
        stmt.setString(35,requisicao.getIndExCartaConvite());
        stmt.setString(36,requisicao.getIndExFuncionario());
        stmt.setString(37,requisicao.getIndTipoRequisicao());
        stmt.setInt(38,requisicao.getIndStatus());       
        stmt.setString(39,String.valueOf(usuario.getChapa()));
        stmt.setString(40,requisicao.getSegmento1());
        stmt.setString(41,requisicao.getSegmento2());
        stmt.setString(42,requisicao.getSegmento3());
        stmt.setString(43,requisicao.getSegmento4());
        stmt.setString(44,requisicao.getSegmento5());
        stmt.setString(45,requisicao.getSegmento6());
        stmt.setString(46,requisicao.getSegmento7());
        stmt.setString(47,requisicao.getCodUODestino());
        stmt.setInt(48,requisicao.getNivelWorkflow());
        stmt.setString(49,requisicao.getDscRecrutamento());
        stmt.setString(50,requisicao.getIndCaraterExcecao());
        stmt.setString(51,requisicao.getVersaoSistema());
        stmt.setLong(52,requisicao.getIdCodeCombination());
        
        // Gerando log com parâmetros recebidos
        parametros.append("\n1,"+tipoDML);
        parametros.append("\n2,"+requisicao.getCodRequisicao());
        parametros.append("\n3,"+requisicao.getCodUnidade());
        parametros.append("\n4,"+requisicao.getCodMA());
        parametros.append("\n5,"+requisicao.getCodSMA());
        parametros.append("\n6,"+usuario.getUsuarioSq());
        parametros.append("\n7,"+requisicao.getCodCargo());
        parametros.append("\n8,"+requisicao.getCotaCargo());
        parametros.append("\n9,"+requisicao.getIndTipoContratacao());
        parametros.append("\n10,"+requisicao.getNomSuperior());
        parametros.append("\n11,"+requisicao.getTelUnidade());
        parametros.append("\n12,"+requisicao.getJornadaTrabalho());
        parametros.append("\n13,"+requisicao.getIndLocalTrabalho());
        parametros.append("\n14,"+requisicao.getCodRPPara());
        parametros.append("\n15,"+requisicao.getComentarios());
        parametros.append("\n16,"+requisicao.getIndSupervisao());
        parametros.append("\n17,"+requisicao.getNumFuncionariosSupervisao());
        parametros.append("\n18,"+requisicao.getDscTarefasDesempenhadas());
        parametros.append("\n19,"+requisicao.getIndViagem());
        parametros.append("\n20,"+requisicao.getSalario());
        parametros.append("\n21,"+requisicao.getOutroLocal());
        parametros.append("\n22,"+requisicao.getNomIndicado());
        parametros.append("\n23,"+requisicao.getDatInicioContratacao());
        parametros.append("\n24,"+requisicao.getDatFimContratacao());
        parametros.append("\n25,"+requisicao.getCodRecrutamento());
        parametros.append("\n26,"+requisicao.getCodArea());
        parametros.append("\n27,"+requisicao.getCodMotivoSolicitacao());
        parametros.append("\n28,"+requisicao.getIndTipoIndicacao());
        parametros.append("\n29,"+requisicao.getDscMotivoSolicitacao());
        parametros.append("\n30,"+requisicao.getCodClassificacaoFuncional());
        parametros.append("\n31,"+requisicao.getIdIndicado());
        parametros.append("\n32,"+requisicao.getIdSubstitutoHist());
        parametros.append("\n33,"+requisicao.getDatTransferencia());
        parametros.append("\n34,"+requisicao.getIndCartaConvite());
        parametros.append("\n35,"+requisicao.getIndExCartaConvite());
        parametros.append("\n36,"+requisicao.getIndExFuncionario());
        parametros.append("\n37,"+requisicao.getIndTipoRequisicao());
        parametros.append("\n38,"+requisicao.getIndStatus());       
        parametros.append("\n39,"+String.valueOf(usuario.getChapa()));
        parametros.append("\n40,"+requisicao.getSegmento1());
        parametros.append("\n41,"+requisicao.getSegmento2());
        parametros.append("\n42,"+requisicao.getSegmento3());
        parametros.append("\n43,"+requisicao.getSegmento4());
        parametros.append("\n44,"+requisicao.getSegmento5());
        parametros.append("\n45,"+requisicao.getSegmento6());
        parametros.append("\n46,"+requisicao.getSegmento7());
        parametros.append("\n47,"+requisicao.getCodUODestino());
        parametros.append("\n48,"+requisicao.getNivelWorkflow());
        parametros.append("\n49,"+requisicao.getDscRecrutamento());
        parametros.append("\n50,"+requisicao.getIndCaraterExcecao());
        parametros.append("\n51,"+requisicao.getVersaoSistema());
        parametros.append("\n52,"+requisicao.getIdCodeCombination());

        // registrando parametro de saida
        stmt.registerOutParameter(2,Types.INTEGER);
        transacao.executeCallableStatement(stmt);
        sucesso = stmt.getInt(2);
        
    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException( "Ocorreu um erro ao "+ tipoTransacao +" a Requisicao: \n"+ parametros.toString() +"\n",e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a Requisicao: \n"+ parametros.toString() +"\n",e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com Requisicao ",e.getMessage());
      }
    }
     return sucesso;   
   }

  /**
   * @param requisicao, usuario
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_REQUISICAO
  */   
   public int gravaRequisicao(Requisicao requisicao, Usuario usuario)throws RequisicaoPessoalException{
    return this.dmlRequisicao(0, requisicao, usuario);
   }


  /**
   * @param requisicao, usuario
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_REQUISICAO
  */
  public int alteraRequisicao(Requisicao requisicao, Usuario usuario)throws RequisicaoPessoalException{
    return this.dmlRequisicao(1, requisicao, usuario);
  }

  /**
   * @param requisicao, usuario
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @OBS: Realiza apenas a exclusão lógica da requisição
   * @Procedure SP_DML_REQUISICAO
  */
  public int deletaRequisicao(Requisicao requisicao, Usuario usuario)throws RequisicaoPessoalException{
    return this.dmlRequisicao(-1, requisicao, usuario);
  }

  /**
   * Retorna uma instancia da classe Requisicao, de acordo com o codigo informado
   * @return Requisicao
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public Requisicao getRequisicao(int codRequisicao) throws RequisicaoPessoalException{
    Requisicao[] requisicao = getRequisicaos(" AND  R.REQUISICAO_SQ = " + codRequisicao);
    return (requisicao.length>0)?requisicao[0]:null;
  }

  /**
   * Retorna um array de objetos Requisicao que satifaz a condição informada
   * @param condicao
   * @return array de objetos Requisicao
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */

  public Requisicao[] getRequisicaos(String condicao) throws RequisicaoPessoalException {
      StringBuffer sql = new StringBuffer();
      ArrayList listaRequisicao = new ArrayList();
      Requisicao requisicao = new Requisicao();
      Requisicao[] requisicaos = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      ResultSet rs = null;

     sql.append(" SELECT R.REQUISICAO_SQ ");
     sql.append("       ,R.COD_UNIDADE ");
     sql.append("       ,R.USUARIO_SQ ");
     sql.append("       ,R.CARGO_SQ ");
     sql.append("       ,R.COD_MA ");
     sql.append("       ,R.COD_SMA ");
     sql.append("       ,R.COTA ");
     sql.append("       ,R.TP_CONTRATACAO ");
     sql.append("       ,R.NM_SUPERIOR ");
     sql.append("       ,R.FONE_UNIDADE ");
     sql.append("       ,R.JORNADA_TRABALHO ");
     sql.append("       ,R.LOCAL_TRABALHO ");
     sql.append("       ,R.MOTIVO_SOLICITACAO ");
     sql.append("       ,R.OBS ");
     sql.append("       ,R.SUPERVISAO ");
     sql.append("       ,R.NR_FUNCIONARIO ");
     sql.append("       ,R.DS_TAREFA ");
     sql.append("       ,R.VIAGEM ");
     sql.append("       ,TRIM(TO_CHAR(R.SALARIO,'999999D99')) SALARIO ");
     sql.append("       ,R.OUTRO_LOCAL ");
     sql.append("       ,R.NM_INDICADO ");
     sql.append("       ,R.INICIO_CONTRATACAO ");
     sql.append("       ,R.FIM_CONTRATACAO ");
     sql.append("       ,R.COD_RECRUTAMENTO ");
     sql.append("       ,R.COD_AREA ");
     sql.append("       ,R.RAZAO_SUBSTITUICAO ");
     sql.append("       ,R.TIPO_INDICACAO ");
     sql.append("       ,R.DS_MOTIVO_SOLICITACAO ");
     sql.append("       ,R.CLASSIFICACAO_FUNCIONAL ");
     sql.append("       ,R.ID_INDICADO ");
     sql.append("       ,R.SUBSTITUIDO_ID_HIST ");
     sql.append("       ,R.TRANSFERENCIA_DATA ");
     sql.append("       ,R.IND_CARTA_CONVTE ");
     sql.append("       ,R.IND_EX_CARTA_CONVTE ");
     sql.append("       ,R.IND_EX_FUNCIONARIO ");
     sql.append("       ,R.ID_CODE_COMBINATION ");
     sql.append("       ,R.IND_TIPO_REQUISICAO ");
     sql.append("       ,R.COD_STATUS ");
     sql.append("       ,R.COD_SEGMENTO1 ");
     sql.append("       ,R.COD_SEGMENTO2 ");
     sql.append("       ,R.COD_SEGMENTO3 ");
     sql.append("       ,R.COD_SEGMENTO4 ");
     sql.append("       ,R.COD_SEGMENTO5 ");
     sql.append("       ,R.COD_SEGMENTO6 ");
     sql.append("       ,R.COD_SEGMENTO7 ");  
     sql.append("       ,CD.DESCRICAO AS DSC_CARGO ");  
     sql.append("       ,UO.DESCRICAO AS DSC_UNIDADE "); 
     sql.append("       ,TO_CHAR(R.DT_REQUISICAO, 'dd/mm/yyyy HH24:MM:MI') AS DT_REQUISICAO "); 
     sql.append("       ,FC.E_MAIL AS EMAIL_CRIADOR_RP "); 
     sql.append("       ,R.DSC_RECRUTAMENTO "); 
     sql.append("       ,R.IND_CARATER_EXCECAO "); 
     sql.append("       ,R.VERSAO_SISTEMA ");
     sql.append("       ,C.REGIME ");
     sql.append(" FROM   reqpes.REQUISICAO                 R  ");
     sql.append("       ,CARGO_DESCRICOES           CD ");
     sql.append("       ,UNIDADES_ORGANIZACIONAIS   UO ");
     sql.append("       ,reqpes.USUARIO                    U ");
     sql.append("       ,FUNCIONARIO_COMPLEMENTO    FC ");
     sql.append("       ,CARGOS    					C ");
     sql.append(" WHERE  UO.CODIGO                  = R.COD_UNIDADE ");
     sql.append(" AND    U.USUARIO_SQ           (+) = R.USUARIO_SQ ");
     sql.append(" AND    U.IDENTIFICACAO            = FC.ID_FUNCIONARIO (+) ");
     sql.append(" AND    CD.ID                      = R.CARGO_SQ");
     sql.append(" AND    C.ID                       = R.CARGO_SQ");
     sql.append(condicao);

      try{
         rs = transacao.getCursor(sql.toString());
         while(rs.next()){
             // Setando os atributos
              requisicao.setCodRequisicao(rs.getInt("REQUISICAO_SQ"));
              requisicao.setCodUnidade(rs.getString("COD_UNIDADE"));
              requisicao.setCodMA(rs.getString("COD_MA"));
              requisicao.setCodSMA(rs.getString("COD_SMA"));
              requisicao.setNumUsuarioSq(rs.getInt("USUARIO_SQ"));
              requisicao.setCodCargo(rs.getInt("CARGO_SQ"));
              requisicao.setCotaCargo(rs.getInt("COTA"));
              requisicao.setIndTipoContratacao(rs.getString("TP_CONTRATACAO"));
              requisicao.setNomSuperior(rs.getString("NM_SUPERIOR"));
              requisicao.setTelUnidade(rs.getString("FONE_UNIDADE"));
              requisicao.setJornadaTrabalho(rs.getDouble("JORNADA_TRABALHO"));
              requisicao.setIndLocalTrabalho(rs.getString("LOCAL_TRABALHO"));
              requisicao.setCodRPPara(rs.getString("MOTIVO_SOLICITACAO"));
              requisicao.setComentarios(rs.getString("OBS"));
              requisicao.setIndSupervisao(rs.getString("SUPERVISAO"));
              requisicao.setNumFuncionariosSupervisao(rs.getInt("NR_FUNCIONARIO"));
              requisicao.setDscTarefasDesempenhadas(rs.getString("DS_TAREFA"));
              requisicao.setIndViagem(rs.getString("VIAGEM"));
              requisicao.setSalario(rs.getString("SALARIO"));
              requisicao.setOutroLocal(rs.getString("OUTRO_LOCAL"));
              requisicao.setNomIndicado(rs.getString("NM_INDICADO"));
              requisicao.setDatInicioContratacao(rs.getDate("INICIO_CONTRATACAO"));
              requisicao.setDatFimContratacao(rs.getDate("FIM_CONTRATACAO"));
              requisicao.setCodRecrutamento(rs.getInt("COD_RECRUTAMENTO"));
              requisicao.setCodArea(rs.getInt("COD_AREA"));
              requisicao.setCodMotivoSolicitacao(rs.getString("RAZAO_SUBSTITUICAO"));
              requisicao.setIndTipoIndicacao(rs.getString("TIPO_INDICACAO"));
              requisicao.setDscMotivoSolicitacao(rs.getString("DS_MOTIVO_SOLICITACAO"));
              requisicao.setCodClassificacaoFuncional(rs.getInt("CLASSIFICACAO_FUNCIONAL"));
              requisicao.setIdIndicado(rs.getInt("ID_INDICADO"));
              requisicao.setIdSubstitutoHist(rs.getInt("SUBSTITUIDO_ID_HIST"));
              requisicao.setDatTransferencia(rs.getDate("TRANSFERENCIA_DATA"));
              requisicao.setIndCartaConvite(rs.getString("IND_CARTA_CONVTE"));
              requisicao.setIndExCartaConvite(rs.getString("IND_EX_CARTA_CONVTE"));
              requisicao.setIndExFuncionario(rs.getString("IND_EX_FUNCIONARIO"));
              requisicao.setIdCodeCombination(rs.getLong("ID_CODE_COMBINATION"));
              requisicao.setIndTipoRequisicao(rs.getString("IND_TIPO_REQUISICAO"));
              requisicao.setIndStatus(rs.getInt("COD_STATUS"));        
              requisicao.setSegmento1(rs.getString("COD_SEGMENTO1"));
              requisicao.setSegmento2(rs.getString("COD_SEGMENTO2"));
              requisicao.setSegmento3(rs.getString("COD_SEGMENTO3"));
              requisicao.setSegmento4(rs.getString("COD_SEGMENTO4"));
              requisicao.setSegmento5(rs.getString("COD_SEGMENTO5"));
              requisicao.setSegmento6(rs.getString("COD_SEGMENTO6"));
              requisicao.setSegmento7(rs.getString("COD_SEGMENTO7"));
              requisicao.setDscCargo(rs.getString("DSC_CARGO"));
              requisicao.setDscUnidade(rs.getString("DSC_UNIDADE"));
              requisicao.setDatRequisicao(rs.getString("DT_REQUISICAO"));
              requisicao.setEmailCriadorRP(rs.getString("EMAIL_CRIADOR_RP"));
              requisicao.setDscRecrutamento(rs.getString("DSC_RECRUTAMENTO"));
              requisicao.setIndCaraterExcecao(rs.getString("IND_CARATER_EXCECAO"));
              requisicao.setVersaoSistema(rs.getString("VERSAO_SISTEMA"));
              requisicao.setIndCargoRegime(rs.getString("REGIME"));
              
            // Adicionando na lista
            listaRequisicao.add(requisicao);
            requisicao = new Requisicao();
        }

        // Dimensionando o array
        requisicaos = new Requisicao[listaRequisicao.size()];

        // Transferindo a lista para o array
        listaRequisicao.toArray(requisicaos);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("Requisicao  \n -> Problemas na consulta de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas ao fechar a conexão: \n\n" + sql.toString(), e.getMessage());
       }
    }
    return requisicaos;
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
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }
  
   /**
   * @param sql, dataSource
   * @return String[][]
   * @throws RequisicaoPessoalException
   */  
  public String[][] getMatriz(String sql, String dataSource) throws RequisicaoPessoalException{
    String[][] retorno = null;
    try{
      retorno = manipulaDAO.getMatriz(sql,dataSource);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
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
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboClassificacaoFuncional() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna as classificações funcionais
    sql.append(" SELECT CF.CLFU_COD ");
    sql.append("       ,CF.CLFU_DES CLFU_DESC ");
    sql.append(" FROM   CLASSIFICACAO_FUNCIONAL CF ");
    sql.append(" ORDER  BY CLFU_COD ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * @param tipoRecrutamento | 1 - Interno / 2 - Externo / 3 - Misto
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboRPPara(int tipoRecrutamento) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
        
    //-- Query que retorna as opções de RP Para
    sql.append(" SELECT S.ID  ");
    sql.append("       ,S.DESCRICAO  ");
    sql.append(" FROM   reqpes.SOLICITACAO_MOTIVO S ");
    sql.append("       ,reqpes.SOLICITACAO_MOTIVO_RECRU SR ");
    sql.append(" WHERE  S.ID = SR.ID_SOLICITACAO ");
    sql.append(" AND    SR.ID_RECRUTAMENTO = " + tipoRecrutamento);
    sql.append(" AND    S.ATIVO = 'S' ");
    sql.append(" ORDER  BY ID ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }   
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboRPPara() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
        
    //-- Query que retorna as opções de RP Para
    sql.append(" SELECT ID ");
    sql.append("       ,DESCRICAO ");
    sql.append(" FROM   reqpes.SOLICITACAO_MOTIVO ");
    sql.append(" WHERE  ATIVO = 'S' ");
    sql.append(" ORDER  BY ID ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }   
  
   /**
   * @param indMotivo
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboMotivoSolicitacao(String indMotivo) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
        
    //-- Query que retorna os motivos de solicitação de RP
    sql.append(" SELECT TRANSFERENCIA_MOTIVO_ID ");
    sql.append("       ,DESCRICAO ");
    sql.append(" FROM   reqpes.VW_RHEV_TRANSFERENCIA_MOTIVO ");
    sql.append(" WHERE  IND_MOTIVO = " + indMotivo);
    sql.append(" ORDER  BY DESCRICAO ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }    
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboMotivoSolicitacao() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
        
    //-- Query que retorna os motivos de solicitação de RP
    sql.append(" SELECT UNIQUE TRANSFERENCIA_MOTIVO_ID ");
    sql.append("       ,DESCRICAO ");
    sql.append(" FROM   reqpes.VW_RHEV_TRANSFERENCIA_MOTIVO ");
    sql.append(" ORDER  BY DESCRICAO ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }      
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboTipoContratacao() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna os tipos de contratações existentes no Senac
    sql.append(" SELECT T.COD_TIPO_CONTRATACAO ");
    sql.append("       ,T.DESCRICAO ");
    sql.append(" FROM   reqpes.TIPO_CONTRATACAO T ");
    sql.append(" WHERE  T.IND_ATIVO = 'S' ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  } 
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboCargosExistentesRequisicao() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna os cargos associados nas requisições cadastradas
    sql.append(" SELECT CD.ID ");
    sql.append("       ,CD.DESCRICAO ");
    sql.append(" FROM   CARGO_DESCRICOES CD ");
    sql.append(" WHERE  EXISTS (SELECT 1 CARGO_SQ FROM reqpes.REQUISICAO R WHERE R.CARGO_SQ = CD.ID) ");
    sql.append(" ORDER  BY CD.DESCRICAO ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }   
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboStatusRequisicao() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna os status associados nas requisições cadastradas
    sql.append(" SELECT T.COD_STATUS ");
    sql.append("       ,T.DSC_STATUS ");
    sql.append(" FROM   reqpes.REQUISICAO_STATUS T ");
    sql.append(" ORDER BY T.DSC_STATUS ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }   
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboRecrutamento() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
        
    //-- Query que retorna os tipos de recrutamentos de acordo com o tipo de requisição
    sql.append(" SELECT ID_RECRUTAMENTO ");
    sql.append("       ,DESCRICAO ");
    sql.append(" FROM   reqpes.RECRUTAMENTO ");
    sql.append(" WHERE  ATIVO = 'S' ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * @param  tipo = C - codUnidade | S - siglaUnidade | null - codigo e descricao
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboUnidade(String tipo) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
        
    //-- Query que retorna informações da unidade de acordo com o parâmetro recebido
    sql.append(" SELECT ");
    
    if(tipo == null){
    	sql.append(" UO.CODIGO, UO.DESCRICAO ");
    }else{
		if(tipo.equals("C")){
		  sql.append(" UO.CODIGO ");
		}else{
		  sql.append(" UO.SIGLA ");
		}
    }
    
    sql.append(" FROM   UNIDADES_ORGANIZACIONAIS UO ");
    sql.append(" WHERE  UO.DATA_ENCERRAMENTO IS NULL ");
    sql.append(" AND    UO.NIVEL = 2 ");
    
    if(tipo == null){
    	sql.append(" AND UO.CODIGO NOT IN ('SA', 'SO', 'SD', 'SU') ");
    }
    
    if(tipo == null){
    	sql.append(" ORDER BY UO.CODIGO ");
    }else{
	    if(tipo.equals("C")){
	      sql.append(" ORDER BY UO.CODIGO ");
	    }else{
	      sql.append(" ORDER BY UO.SIGLA ");
	    }
    }

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  } 
  
  /**
   * @param  tipo = SA | SO | SU | SD
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboSuperintendenciaUnidades(String tipo) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
        
    //-- Query que retorna as unidades da superintendencia administrativa
    sql.append(" SELECT T.CODIGO, T.DESCRICAO ");
    sql.append(" FROM   ESTRUTURA_ORGANIZACIONAL R ");
    sql.append("       ,UNIDADES_ORGANIZACIONAIS T ");
    sql.append(" WHERE R.UNOR_COD = T.CODIGO ");
    sql.append(" AND   T.DATA_ENCERRAMENTO IS NULL ");
    sql.append(" AND    R.TEOR_COD = 'RHEV' ");
    sql.append(" AND    R.UNOR_COD_PAI = '" + tipo + "' ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }      
    
   /**
   * @param codRequisicao
   * @return String[][]
   * @throws RequisicaoPessoalException
   * @Utilização Método utilizado para carga no relatário por RP
   */
  public String[][] getPesquisaRequisicaoAntiga(int codRequisicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
        
    //-- Query que retorna todas as informações das requisições
    sql.append(" SELECT REQUISICAO_SQ ");
    sql.append("       ,COD_UNIDADE ");
    sql.append("       ,DSC_UNIDADE ");
    sql.append("       ,COD_USUARIO_SQ_CRIACAO ");
    sql.append("       ,COD_CARGO ");  //4
    sql.append("       ,DSC_CARGO ");  //5
    sql.append("       ,COD_MA ");     //6
    sql.append("       ,COD_SMA ");   //7
    sql.append("       ,COTA ");   //8
    sql.append("       ,COD_TP_CONTRATACAO "); //9
    sql.append("       ,DSC_TIPO_CONTRATACAO "); //10
    sql.append("       ,NOM_SUPERIOR ");    // 11
    sql.append("       ,FONE_UNIDADE ");    // 12
    sql.append("       ,JORNADA_TRABALHO "); //13
    sql.append("       ,COD_LOCAL_TRABALHO "); //14
    sql.append("       ,DSC_LOCAL_TRABALHO "); //15
    sql.append("       ,COD_RP_PARA "); //16
    sql.append("       ,DSC_RP_PARA "); //17
    sql.append("       ,COMENTARIOS ");
    sql.append("       ,IND_SUPERVISAO "); //19
    sql.append("       ,NR_FUNCIONARIO ");   //20
    sql.append("       ,TAREFAS_DESEMPENHADAS "); //21
    sql.append("       ,COD_VIAGEM ");
    sql.append("       ,DSC_VIAGEM "); //23
    sql.append("       ,SALARIO ");   //24
    sql.append("       ,OUTRO_LOCAL "); //25
    sql.append("       ,NOM_INDICADO "); //26
    sql.append("       ,DAT_INICIO_CONTRATACAO "); //27
    sql.append("       ,DAT_FIM_CONTRATACAO "); //28
    sql.append("       ,COD_RECRUTAMENTO ");
    sql.append("       ,DSC_RECRUTAMENTO "); // 30
    sql.append("       ,TO_CHAR(DAT_REQUISICAO, 'dd/mm/yyyy') DAT_REQUISICAO"); //31
    sql.append("       ,COD_MOTIVO_SOLICITACAO "); //32
    sql.append("       ,DSC_MOTIVO_SOLICITACAO "); //33
    sql.append("       ,JUSTIFICATIVA "); //34
    sql.append("       ,COD_CLASSIF_FUNCIONAL ");
    sql.append("       ,DSC_CLASSIF_FUNCIONAL "); //36
    sql.append("       ,CHAPA_FUNC_INDICADO "); //37
    sql.append("       ,NOM_FUNC_INDICADO "); //38
    sql.append("       ,CHAPA_FUNC_SUBSTITUIDO "); //39
    sql.append("       ,NOM_FUNC_SUBSTITUIDO "); //40
    sql.append("       ,TRANSFERENCIA_DATA "); //41
    sql.append("       ,IND_CARTA_CONVTE "); //42
    sql.append("       ,IND_EX_CARTA_CONVTE ");
    sql.append("       ,IND_EX_FUNCIONARIO ");
    sql.append("       ,ID_CODE_COMBINATION "); //45
    sql.append("       ,COD_SEGMENTO1 "); //46
    sql.append("       ,COD_SEGMENTO2 "); //47
    sql.append("       ,COD_SEGMENTO3 "); //48
    sql.append("       ,COD_SEGMENTO4 "); //49
    sql.append("       ,COD_SEGMENTO5 "); //50
    sql.append("       ,COD_SEGMENTO6 "); //51
    sql.append("       ,COD_SEGMENTO7 "); //52
    sql.append("       ,TIPO_REQUISICAO ");               //53
    sql.append("       ,COD_STATUS ");                    //54
    sql.append("       ,DSC_STATUS ");                    //55
    sql.append("       ,SIGLA_UNIDADE ");                 //56    
    sql.append("       ,HR_SEGUNDA_ENTRADA1 "); //57
    sql.append("       ,HR_SEGUNDA_SAIDA1 ");
    sql.append("       ,HR_SEGUNDA_ENTRADA2 ");
    sql.append("       ,HR_SEGUNDA_SAIDA2 "); 
    sql.append("       ,HR_TERCA_ENTRADA1 "); //61
    sql.append("       ,HR_TERCA_SAIDA1 ");
    sql.append("       ,HR_TERCA_ENTRADA2 ");
    sql.append("       ,HR_TERCA_SAIDA2 ");
    sql.append("       ,HR_QUARTA_ENTRADA1 "); //65
    sql.append("       ,HR_QUARTA_SAIDA1 ");
    sql.append("       ,HR_QUARTA_ENTRADA2 ");
    sql.append("       ,HR_QUARTA_SAIDA2 ");
    sql.append("       ,HR_QUINTA_ENTRADA1 "); //69
    sql.append("       ,HR_QUINTA_SAIDA1 ");
    sql.append("       ,HR_QUINTA_ENTRADA2 ");
    sql.append("       ,HR_QUINTA_SAIDA2 ");
    sql.append("       ,HR_SEXTA_ENTRADA1 "); //73
    sql.append("       ,HR_SEXTA_SAIDA1 ");
    sql.append("       ,HR_SEXTA_ENTRADA2 ");
    sql.append("       ,HR_SEXTA_SAIDA2 ");
    sql.append("       ,HR_SABADO_ENTRADA1 "); //77
    sql.append("       ,HR_SABADO_SAIDA1 ");
    sql.append("       ,HR_SABADO_ENTRADA2 ");
    sql.append("       ,HR_SABADO_SAIDA2 ");
    sql.append("       ,HR_DOMINGO_ENTRADA1 "); //81
    sql.append("       ,HR_DOMINGO_SAIDA1 ");
    sql.append("       ,HR_DOMINGO_ENTRADA2 ");
    sql.append("       ,HR_DOMINGO_SAIDA2 ");
    sql.append("       ,SEXO "); //85
    sql.append("       ,DSC_FORMACAO "); //86
    sql.append("       ,DSC_FORMACAO_DESEJADA "); //87
    sql.append("       ,FAIXA_ETARIA_INI "); //88
    sql.append("       ,FAIXA_ETARIA_FIM "); //89
    sql.append("       ,DSC_OUTRAS_CARACTERISTICAS "); //90
    sql.append("       ,TEMPO_EXPERIENCIA "); //91
    sql.append("       ,DSC_TIPO_EXPERIENCIA "); //92
    sql.append("       ,PERFIL_COMENTARIO  "); //93
    sql.append("       ,UNIDADE_FUNC_INDICADO  "); //94
    sql.append("       ,CHAPA_FUNC_BAIXADO  "); //95
    sql.append("       ,NOM_FUNC_BAIXADO  "); //96
    sql.append("       ,JUST_RECRUTAMENTO "); //97
    sql.append("       ,DSC_AREA "); //98
    sql.append("       ,DSC_FUNCAO "); //99
    sql.append("       ,DSC_NIVEL_HIERARQUIA "); //100
    sql.append("       ,DSC_OPORTUNIDADE "); //101
    sql.append("       ,DSC_ATIVIDADES_CARGO "); //102    
    sql.append("       ,COD_ESCALA "); //103    
    sql.append("       ,ID_CALENDARIO "); //104    
    sql.append("       ,IND_TIPO_REQUISICAO ");  // 105
    sql.append(" FROM   requisicao.VW_DADOS_COMPLETOS_REQUISICAO ");
    sql.append(" WHERE  REQUISICAO_SQ = " + codRequisicao);

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME_VS_ANTERIOR);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * @param codRequisicao
   * @return String[][]
   * @throws RequisicaoPessoalException
   * @Utilização Método utilizado para carga no relatário por RP
   */
  public String[][] getPesquisaRequisicao(int codRequisicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
        
    //-- Query que retorna todas as informações das requisições   
    sql.append(" SELECT R.REQUISICAO_SQ "); /*0*/
    sql.append("       ,R.COD_UNIDADE "); /*1*/
    sql.append("       ,R.DSC_UNIDADE "); /*2*/
    sql.append("       ,R.COD_USUARIO_SQ_CRIACAO "); /*3*/
    sql.append("       ,R.COD_CARGO "); /*4*/
    sql.append("       ,R.DSC_CARGO "); /*5*/
    sql.append("       ,R.COD_MA "); /*6*/
    sql.append("       ,R.COD_SMA "); /*7*/
    sql.append("       ,R.COTA "); /*8*/
    sql.append("       ,R.COD_TP_CONTRATACAO "); /*9*/
    sql.append("       ,R.DSC_TIPO_CONTRATACAO "); /*10*/
    sql.append("       ,R.NOM_SUPERIOR "); /*11*/
    sql.append("       ,R.FONE_UNIDADE "); /*12*/
    sql.append("       ,R.JORNADA_TRABALHO "); /*13*/
    sql.append("       ,R.COD_LOCAL_TRABALHO "); /*14*/
    sql.append("       ,R.DSC_LOCAL_TRABALHO "); /*15*/
    sql.append("       ,R.COD_RP_PARA "); /*16*/
    sql.append("       ,R.DSC_RP_PARA "); /*17*/
    sql.append("       ,R.COMENTARIOS "); /*18*/
    sql.append("       ,R.IND_SUPERVISAO "); /*19*/
    sql.append("       ,R.NR_FUNCIONARIO "); /*20*/
    sql.append("       ,R.TAREFAS_DESEMPENHADAS "); /*21*/
    sql.append("       ,R.COD_VIAGEM "); /*22*/
    sql.append("       ,R.DSC_VIAGEM "); /*23*/
    sql.append("       ,R.SALARIO "); /*24*/
    sql.append("       ,R.OUTRO_LOCAL "); /*25*/
    sql.append("       ,R.NOM_INDICADO "); /*26*/
    sql.append("       ,R.DAT_INICIO_CONTRATACAO "); /*27*/
    sql.append("       ,R.DAT_FIM_CONTRATACAO "); /*28*/
    sql.append("       ,R.COD_RECRUTAMENTO "); /*29*/
    sql.append("       ,R.DSC_RECRUTAMENTO "); /*30*/
    sql.append("       ,TO_CHAR(R.DAT_REQUISICAO,'dd/mm/yyyy') DAT_REQUISICAO "); /*31*/
    sql.append("       ,R.COD_MOTIVO_SOLICITACAO "); /*32*/
    sql.append("       ,R.DSC_MOTIVO_SOLICITACAO "); /*33*/
    sql.append("       ,R.JUSTIFICATIVA "); /*34*/
    sql.append("       ,R.COD_CLASSIF_FUNCIONAL "); /*35*/
    sql.append("       ,R.DSC_CLASSIF_FUNCIONAL "); /*36*/
    sql.append("       ,R.CHAPA_FUNC_INDICADO "); /*37*/
    sql.append("       ,R.NOM_FUNC_INDICADO "); /*38*/
    sql.append("       ,R.CHAPA_FUNC_SUBSTITUIDO "); /*39*/
    sql.append("       ,R.NOM_FUNC_SUBSTITUIDO "); /*40*/
    sql.append("       ,R.TRANSFERENCIA_DATA "); /*41*/
    sql.append("       ,R.IND_CARTA_CONVTE "); /*42*/
    sql.append("       ,R.IND_EX_CARTA_CONVTE "); /*43*/
    sql.append("       ,R.IND_EX_FUNCIONARIO "); /*44*/
    sql.append("       ,R.ID_CODE_COMBINATION "); /*45*/
    sql.append("       ,R.COD_SEGMENTO1 "); /*46*/
    sql.append("       ,R.COD_SEGMENTO2 "); /*47*/
    sql.append("       ,R.COD_SEGMENTO3 "); /*48*/
    sql.append("       ,R.COD_SEGMENTO4 "); /*49*/
    sql.append("       ,R.COD_SEGMENTO5 "); /*50*/
    sql.append("       ,R.COD_SEGMENTO6 "); /*51*/
    sql.append("       ,R.COD_SEGMENTO7 "); /*52*/
    sql.append("       ,R.TIPO_REQUISICAO "); /*53*/
    sql.append("       ,R.COD_STATUS "); /*54*/
    sql.append("       ,R.DSC_STATUS "); /*55*/
    sql.append("       ,R.SIGLA_UNIDADE "); /*56*/
    sql.append("       ,R.SEXO "); /*57*/
    sql.append("       ,R.DSC_FORMACAO "); /*58*/
    sql.append("       ,R.DSC_FORMACAO_DESEJADA "); /*59*/
    sql.append("       ,R.FAIXA_ETARIA_INI "); /*60*/
    sql.append("       ,R.FAIXA_ETARIA_FIM "); /*61*/
    sql.append("       ,R.DSC_OUTRAS_CARACTERISTICAS "); /*62*/
    sql.append("       ,R.TEMPO_EXPERIENCIA "); /*63*/
    sql.append("       ,R.DSC_TIPO_EXPERIENCIA "); /*64*/
    sql.append("       ,R.PERFIL_COMENTARIO "); /*65*/
    sql.append("       ,R.UNIDADE_FUNC_INDICADO "); /*66*/
    sql.append("       ,R.CHAPA_FUNC_BAIXADO "); /*67*/
    sql.append("       ,R.NOM_FUNC_BAIXADO "); /*68*/
    sql.append("       ,R.JUST_RECRUTAMENTO "); /*69*/
    sql.append("       ,R.DSC_AREA "); /*70*/
    sql.append("       ,R.DSC_FUNCAO "); /*71*/
    sql.append("       ,R.DSC_NIVEL_HIERARQUIA "); /*72*/
    sql.append("       ,R.DSC_OPORTUNIDADE "); /*73*/
    sql.append("       ,R.DSC_ATIVIDADES_CARGO "); /*74*/
    sql.append("       ,R.COD_ESCALA "); /*75*/
    sql.append("       ,R.ID_CALENDARIO "); /*76*/
    sql.append("       ,R.IND_CARATER_EXCECAO "); /*77*/
    sql.append("       ,R.DSC_EXPERIENCIA "); /*78*/
    sql.append("       ,R.IND_TIPO_REQUISICAO "); /*79*/
    sql.append("       ,R.VERSAO_SISTEMA "); /*80*/
    sql.append("       ,R.DSC_CONHECIMENTOS "); /*81*/
    sql.append(" FROM   reqpes.VW_DADOS_COMPLETOS_REQUISICAO R ");
    sql.append(" WHERE  R.REQUISICAO_SQ = " + codRequisicao);

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de Requisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }   

   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboUnidadesRelacionadas() throws RequisicaoPessoalException{
    return getComboUnidadesRelacionadas("");
  }

   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboUnidadesRelacionadas(int codUnidade, String listaUnidades) throws RequisicaoPessoalException{
    String complemento = "";
    if(listaUnidades != null && !listaUnidades.equals("") && !listaUnidades.equals(",") && !listaUnidades.equals("0")){
      complemento = " OR U.COD_UNIDADE IN (" + listaUnidades + ") ";
    }  
    return getComboUnidadesRelacionadas(" AND (SUBSTR(UO.CODIGO,1,3) = LPAD(" + codUnidade + ",3,0) " + complemento + ") ");
  }
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboUnidadesRelacionadas(String condicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
        
    //-- Query que retorna as unidades que existem requisições relacionadas
    sql.append(" SELECT UO.CODIGO ");
    sql.append("       ,UO.CODIGO||' - '||UO.DESCRICAO DESCRICAO ");
    sql.append(" FROM   UNIDADES_ORGANIZACIONAIS UO ");
    sql.append("       ,reqpes.UNIDADE                  U ");
    sql.append(" WHERE  SUBSTR(UO.CODIGO,1,3) = LPAD(U.COD_UNIDADE,3,'0') ");
    sql.append(" AND    UO.DATA_ENCERRAMENTO IS NULL ");
    sql.append(" AND    EXISTS (SELECT 1 FROM reqpes.REQUISICAO R WHERE R.COD_UNIDADE = UO.CODIGO) ");
    sql.append(condicao);
    sql.append(" ORDER BY UO.CODIGO ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta  de getComboUnidadesRelacionadas: " + "\n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }   
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   * @coments Apenas requisições com status que podem ser excluídas
   */
  public String[][] getRequisicoesParaExclusao(String condicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna as requisições que podem ser efetuadas exclusões
    sql.append(" SELECT R.REQUISICAO_SQ ");
    sql.append("       ,TO_CHAR(R.DT_REQUISICAO, 'dd/mm/yyyy') DT_REQUISICAO ");
    sql.append("       ,CD.DESCRICAO CARGO ");
    sql.append("       ,R.COD_UNIDADE ");
    sql.append("       ,UO.DESCRICAO UNIDADE ");
    sql.append("       ,RS.DSC_STATUS ");
    sql.append("       ,UO.SIGLA ");
    sql.append(" FROM   reqpes.REQUISICAO               R ");
    sql.append("       ,UNIDADES_ORGANIZACIONAIS UO ");
    sql.append("       ,CARGO_DESCRICOES         CD ");
    sql.append("       ,reqpes.REQUISICAO_STATUS        RS ");
    sql.append(" WHERE  UO.CODIGO                = R.COD_UNIDADE ");
    sql.append(" AND    CD.ID                    = R.CARGO_SQ ");
    sql.append(" AND    RS.COD_STATUS            = R.COD_STATUS ");
    sql.append(" AND    R.COD_STATUS BETWEEN 1 AND 5 "); //-- ABERTA, EM HOMOLOGAÇÃO, EM REVISÃO, APROVADA, REPROVADA
    sql.append(condicao);
    sql.append(" ORDER BY R.DT_REQUISICAO, UO.DESCRICAO, CD.DESCRICAO ");

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta de getRequisicoesParaEstorno: " + "\n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }   
  
   /**
   * @param codRequisicao, dataSource
   * @return String[][]
   * @throws RequisicaoPessoalException
   * @coments Histórico da requisição informada
   */
  public String[][] getHistoricoRequisicao(int codRequisicao, String dataSource) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    //-- Query que retorna o histórico da requisição informada
    sql.append(" SELECT T.REQUISICAO_SQ ");
    sql.append("       ,T.RP_TIPO ");
    sql.append("       ,T.DT_CRIACAO ");
    sql.append("       ,T.UO_USUARIO ");
    sql.append("       ,T.NOME ");
    sql.append("       ,T.DT_HISTORICO ");
    sql.append("       ,T.STATUS ");
    sql.append("       ,T.UO_PARA_UNIDADE ");
    sql.append("       ,T.UO_REQUISICAO ");
    sql.append("       ,T.NIVEL_WORKFLOW ");
    
    if (dataSource.equals(InterfaceDataBase.DATA_BASE_NAME_VS_ANTERIOR)) {
    	sql.append(" FROM   requisicao.VW_HISTORICO_REQUISICAO T ");
	} else {
        sql.append(" FROM   reqpes.VW_HISTORICO_REQUISICAO T ");        
	}
    
    sql.append(" WHERE  T.REQUISICAO_SQ = " + codRequisicao);

    try{
      retorno = manipulaDAO.getMatriz(sql.toString(), dataSource);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoDAO  \n -> Problemas na consulta de getHistoricoRequisicao: \n\n" + sql.toString(), e.getMessage());
    }
    return retorno;
  }  
  
  /**
  * @param chapa
  * @return String[]
  * @throws RequisicaoPessoalException
  * @coments Retorna os dados do usuário atual no histórico da requisição
  */  
  public String[][] getDadosUsuarioAtualHistorico(int chapa) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT U.UNIDADE ");
    sql.append("       ,F.NOME ");
    sql.append(" FROM   reqpes.USUARIO U ");
    sql.append("       ,FUNCIONARIOS F ");
    sql.append(" WHERE  U.IDENTIFICACAO = F.ID ");
    sql.append(" AND    U.IDENTIFICACAO = " + chapa);
    
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("getDadosUsuarioAtualHistorico  \n -> Problemas na consulta de getDadosUsuarioAtualHistorico: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;    
  }  
  
  /**
  * @param codUnidade
  * @return String[]
  * @throws RequisicaoPessoalException
  * @coments Retorna os dados do usuário atual no histórico da requisição
  */  
  public String[][] getDadosUsuarioAtualHistorico(String codUnidade) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT UU.UNIDADE ");
    sql.append("       ,F.NOME ");
    sql.append(" FROM   reqpes.GRUPO_NEC_UNIDADES U ");
    sql.append("       ,reqpes.GRUPO_NEC_USUARIOS S ");
    sql.append("       ,FUNCIONARIOS       F ");
    sql.append("       ,reqpes.USUARIO            UU ");
    sql.append(" WHERE  U.COD_GRUPO      = S.COD_GRUPO ");
    sql.append(" AND    UU.IDENTIFICACAO = F.ID ");    
    sql.append(" AND    F.ID             = S.CHAPA ");
    sql.append(" AND    U.COD_UNIDADE    = '" + codUnidade + "'");
    
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("getDadosUsuarioAtualHistorico  \n -> Problemas na consulta de getDadosUsuarioAtualHistorico: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;    
  }   
  
  
  /**
   * @param horaEntrada e horaSaida
   * @return número de horas no período informado
   * @throws RequisicaoPessoalException
   */
  public BigDecimal validaHorarioTrabalho(String horaEntrada, String horaSaida) throws RequisicaoPessoalException{
     Transacao transacao = new Transacao(DATA_BASE_NAME);
     BigDecimal retorno = new BigDecimal("0");
     CallableStatement stmt = null;
     
     try{    
        stmt = transacao.getCallableStatement("{ ? = call reqpes.F_VALIDA_HORARIO_TRABALHO(?,?)}");
        stmt.setString(2,horaEntrada);
        stmt.setString(3,horaSaida);
        stmt.registerOutParameter(1,Types.DOUBLE);
          
        transacao.executeCallableStatement(stmt);
        retorno = stmt.getBigDecimal(1);           
        
        return retorno;
        
    }catch(Exception e){
        throw new RequisicaoPessoalException("validaHorarioTrabalho  \n -> Problemas na consulta de validaHorarioTrabalho: \n\n" + horaEntrada + " - " + horaSaida, e.getMessage());
    }finally{
        try{
           stmt.close();
           transacao.end();
        }catch(SQLException e){
           throw new RequisicaoPessoalException("Erro ao fechar conexao ",e.getMessage());
        }
    }
  }   
  
  /**
   * @param  numChapaSubst
   * @return RP's que estáo utilizando a chapa do funcionário substituido
   * @throws RequisicaoPessoalException
   */
  public String verificaSubstituido(int numChapaSubst) throws RequisicaoPessoalException{
     Transacao transacao = new Transacao(DATA_BASE_NAME);
     String retorno = null;
     CallableStatement stmt = null;
     
     try{    
        stmt = transacao.getCallableStatement("{ ? = call reqpes.F_VERIFICA_SUBSTUIDO_ID(?)}");
        stmt.setInt(2,numChapaSubst);
        stmt.registerOutParameter(1,Types.VARCHAR);
          
        transacao.executeCallableStatement(stmt);
        retorno = stmt.getString(1);           
        
        return retorno;
        
    }catch(Exception e){
        throw new RequisicaoPessoalException("verificaSubstituido  \n -> Problemas na consulta de verificaSubstituido: Chapa - " + numChapaSubst + "\n\n", e.getMessage());
    }finally{
        try{
           stmt.close();
           transacao.end();
        }catch(SQLException e){
           throw new RequisicaoPessoalException("Erro ao fechar conexao ",e.getMessage());
        }
    }
  }    
  
  /**
  * @param codClassificacaoFuncional
  * @return String[][]
  * @throws RequisicaoPessoalException
  * @coments Retorna a descrição da CLAFU
  */  
  public String[][] getDscClassificacaoFuncional(int codClassificacaoFuncional) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT CF.CLFU_COD ");
    sql.append("       ,CF.CLFU_DES CLFU_DESC ");
    sql.append("       ,CD.DESCRICAO ");
    sql.append(" FROM   CLASSIFICACAO_FUNCIONAL CF ");
    sql.append("       ,CLAFU_DESC              CD ");
    sql.append(" WHERE  CD.CLFU_COD = CF.CLFU_COD ");
    sql.append(" AND    CF.CLFU_COD = " + codClassificacaoFuncional);
    
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("getDscClassificacaoFuncional  \n -> Problemas na consulta de getDscClassificacaoFuncional: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;    
  }   
  
  /**
  * @param codUnidade
  * @return String[][]
  * @throws RequisicaoPessoalException
  * @coments Retorna combo com os cargos da unidade informada
  */  
  public String[][] getComboCargo(String codUnidade) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT C.ID ");
    sql.append("       ,C.HORAS_SEMANAIS ");
    sql.append("       ,CD.DESCRICAO ");
    sql.append("       ,UCTN.TAB_SALARIAL ");   
    sql.append(" FROM   CARGOS                   C ");
    sql.append("       ,CARGO_DESCRICOES         CD ");
    sql.append("       ,UNIORG_CARGO_TAB_NIVEL   UCTN ");
    sql.append("       ,UNIDADES_ORGANIZACIONAIS U ");
    sql.append(" WHERE  C.ID                = CD.ID ");
    sql.append(" AND    C.ID                = UCTN.ID_CARGO ");
    sql.append(" AND    (UCTN.COD_UNIORG = U.CODIGO_PAI OR UCTN.COD_UNIORG = 'SENAC') ");
    sql.append(" AND    C.IN_SITUACAO_CARGO = 'A' ");
    sql.append(" AND    U.NIVEL = 2 ");
    sql.append(" AND    U.DATA_ENCERRAMENTO IS NULL ");
    sql.append(" AND    U.CODIGO LIKE '" + codUnidade + "%' ");
    sql.append(" ORDER  BY DESCRICAO ");
    
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("getComboCargo  \n -> Problemas na consulta de getComboCargo: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;    
  }  
  
  /**
  * @param datInicio (inicio contratação), prazo (prazo de contratação)
  * @return String
  * @throws RequisicaoPessoalException
  * @coments Retorna o prazo final da contratação
  */  
  public String getDataFimContratacao(String datInicio, int prazo) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[] retorno = null;
    
    /* Soma-se 5 para garantir suprir a diferença de dias entre os meses */
//    sql.append(" SELECT TO_CHAR(TO_DATE('" + datInicio + "', 'dd/mm/yyyy') + 5 + " + prazo + ", 'dd/mm/yyyy') AS FIM_CONTRATACAO ");
//    sql.append(" FROM   DUAL ");
    
    sql.append(" SELECT TO_CHAR(ADD_MONTHS(TO_DATE('" + datInicio + "', 'dd/mm/yyyy'), " + prazo + " ) , 'dd/mm/yyyy') AS FIM_CONTRATACAO ");
    sql.append(" FROM   DUAL ");
    
    try{
      retorno = manipulaDAO.getLista(sql.toString(),DATA_BASE_NAME);            
    }catch(Exception e){
      throw new RequisicaoPessoalException("getDataFimContratacao  \n -> Problemas na consulta de getDataFimContratacao: \n\n " + sql.toString(), e.getMessage());
    }
    return (retorno!=null && retorno.length>0)?retorno[0]:null;
  }    
}