package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.Instrucao;
import br.senac.sp.reqpes.model.TabelaSalarial;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 27/05/2009
 */
 
public class InstrucaoDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public InstrucaoDAO(){

  }

  /**
   * Retorna todas as instrucaos cadastradas no sistema
   * @param  instrucao
   * @return Instrucao[]
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public Instrucao[] getInstrucaos() throws RequisicaoPessoalException {
    return getInstrucaos("");
  }

  /**
   * @return int
   * @param  instrucao, usuario
   * @Procedure PROCEDURE SP_DML_INSTRUCAO(P_IN_DML                    IN NUMBER
                                          ,P_IN_COD_INSTRUCAO          IN OUT NUMBER
                                          ,P_IN_COD_TAB_SALARIAL       IN NUMBER
                                          ,P_IN_COD_CARGO              IN NUMBER
                                          ,P_IN_COTA                   IN NUMBER
                                          ,P_IN_COD_AREA_SUBAREA       IN VARCHAR2
                                          ,P_IN_USUARIO                IN VARCHAR2) IS
   */
   
   private int dmlInstrucao(int tipoDML, Instrucao instrucao, Usuario usuario) throws RequisicaoPessoalException{
    
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
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_INSTRUCAO(?,?,?,?,?,?,?)}");
        stmt.setInt(1,tipoDML); // 0 INSERT, 1 UPDATE, -1 DELETE 
        stmt.setInt(2,instrucao.getCodInstrucao());
        stmt.setInt(3,instrucao.getCodTabelaSalarial());        
        stmt.setInt(4,instrucao.getCodCargo());
        stmt.setInt(5,instrucao.getCota());
        stmt.setString(6,instrucao.getCodAreaSubarea());
        stmt.setString(7,String.valueOf(usuario.getChapa()));
        
        // registrando parametro de saida
        stmt.registerOutParameter(2,Types.INTEGER);
        transacao.executeCallableStatement(stmt);
        
        if(tipoDML >= 0){
          sucesso = stmt.getInt(2);
        }

    }catch(SQLException e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a Instrucao: \n" ,e.getMessage());
    }catch(Exception e){
      sucesso = 0;
      throw new RequisicaoPessoalException("Ocorreu um erro ao "+ tipoTransacao +" a Instrucao: \n" ,e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("Erro ao fechar conexao com Instrucao " ,e.getMessage());
      }
    }
     return sucesso;        
   }
   
  /**
   * @param instrucao, usuario
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_INSTRUCAO
  */
  public int gravaInstrucao(Instrucao instrucao, Usuario usuario) throws RequisicaoPessoalException{
     return this.dmlInstrucao(0, instrucao, usuario);
  }


  /**
   * @param instrucao, usuario
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_INSTRUCAO
  */
  public int alteraInstrucao(Instrucao instrucao, Usuario usuario) throws RequisicaoPessoalException{
    return this.dmlInstrucao(1, instrucao, usuario);
  }

  /**
   * @param instrucao, usuario
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @OBS: Realiza apenas a exclusão lógica da requisição
   * @Procedure SP_DML_INSTRUCAO
  */
  public int deletaInstrucao(Instrucao instrucao, Usuario usuario) throws RequisicaoPessoalException{
    return this.dmlInstrucao(-1, instrucao, usuario);
  }

  /**
   * Retorna uma instancia da classe Instrucao, de acordo com o codigo informado
   * @return Instrucao
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public Instrucao getInstrucao(int codInstrucao) throws RequisicaoPessoalException{
    Instrucao[] instrucao = getInstrucaos(" AND T.COD_INSTRUCAO = " + codInstrucao);
    return (instrucao.length>0)?instrucao[0]:null;
  }

  /**
   * Retorna um array de objetos Instrucao que satifaz a condição informada
   * @param condicao
   * @return array de objetos Instrucao
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */

  public Instrucao[] getInstrucaos(String condicao) throws RequisicaoPessoalException {
      StringBuffer sql = new StringBuffer();
      ArrayList listaInstrucao = new ArrayList();
      Instrucao instrucao = new Instrucao();
      TabelaSalarial tabelaSalarial = new TabelaSalarial();
      Instrucao[] instrucaos = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      ResultSet rs = null;

      sql.append(" SELECT /*+Rule*/ T.COD_INSTRUCAO ");
      sql.append("       ,T.COD_TAB_SALARIAL ");
      sql.append("       ,TS.DSC_TAB_SALARIAL ");
      sql.append("       ,T.COD_CARGO ");
      sql.append("       ,CD.DESCRICAO ");
      sql.append("       ,T.COTA ");
      sql.append("       ,T.COD_AREA_SUBAREA ");
      sql.append(" FROM   reqpes.INSTRUCAO        T ");
      sql.append("       ,reqpes.TABELA_SALARIAL  TS ");
      sql.append("       ,CARGO_DESCRICOES CD ");
      sql.append(" WHERE  T.COD_CARGO         = CD.ID ");
      sql.append(" AND    TS.COD_TAB_SALARIAL = T.COD_TAB_SALARIAL ");
      sql.append(condicao);
      sql.append(" ORDER  BY TS.DSC_TAB_SALARIAL, CD.DESCRICAO ");

      try{
         rs = transacao.getCursor(sql.toString());
         while(rs.next()){
             // Setando os atributos
             instrucao.setCodInstrucao(rs.getInt("COD_INSTRUCAO"));
             instrucao.setCodCargo(rs.getInt("COD_CARGO"));
             instrucao.setCodTabelaSalarial(rs.getInt("COD_TAB_SALARIAL"));
             instrucao.setDscCargo(rs.getString("DESCRICAO"));
             instrucao.setCodAreaSubarea(rs.getString("COD_AREA_SUBAREA"));
             instrucao.setCota(rs.getInt("COTA"));
             
             tabelaSalarial.setCodTabelaSalarial(rs.getInt("COD_TAB_SALARIAL"));
             tabelaSalarial.setDscTabelaSalarial(rs.getString("DSC_TAB_SALARIAL"));
             
             instrucao.setTabelaSalarial(tabelaSalarial);
            
            // Adicionando na lista
            listaInstrucao.add(instrucao);
            instrucao = new Instrucao();
            tabelaSalarial = new TabelaSalarial();
        }

        // Dimensionando o array
        instrucaos = new Instrucao[listaInstrucao.size()];

        // Transferindo a lista para o array
        listaInstrucao.toArray(instrucaos);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("InstrucaoDAO  \n -> Problemas na consulta de Instrucao: \n\n " + sql.toString(), e.getMessage());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("InstrucaoDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(), e.getMessage());
       }
    }
    return instrucaos;
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
      throw new RequisicaoPessoalException("InstrucaoDAO  \n -> Problemas na consulta  de Instrucao: \n\n " + sql.toString(), e.getMessage());
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
      throw new RequisicaoPessoalException("InstrucaoDAO  \n -> Problemas na consulta de Instrucao: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }
  
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboCargo(int codTabelaSalarial) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT UNIQUE C.ID ");
    sql.append("       ,CD.DESCRICAO ");
    sql.append(" FROM   CARGOS                 C ");
    sql.append("       ,CARGO_DESCRICOES       CD ");
    sql.append("       ,UNIORG_CARGO_TAB_NIVEL UCTN ");
    sql.append(" WHERE 1 = 1 ");
    
    //-- Carrega os cargos de acordo com a tabela salarial informada
    if(codTabelaSalarial > 0){
      sql.append(" AND  EXISTS (SELECT 1 ");
      sql.append("              FROM reqpes.TABELA_SALARIAL_ATRIBUICAO T ");
      sql.append("              WHERE T.COD_TAB_SALARIAL_RHEV = UCTN.TAB_SALARIAL ");
      sql.append("              AND T.COD_TAB_SALARIAL = " + codTabelaSalarial + ") ");
    }
    
    //-- Carrega a lista de cargos associados das divisões da Tebela Salarial GERAL
    //-- 1	TABELA: 01 GERAL
    //-- 2	TABELA: 01 GERAL - GERENTES
    //-- 3	TABELA: 01 GERAL - RESPONSÁVEL PELA ÁREA ADMINISTRATIVA
    //-- 4	TABELA: 01 GERAL - RESPONSÁVEL PELA ÁREA EDUCACIONAL
    if(codTabelaSalarial >= 1 && codTabelaSalarial <= 4){
      if(codTabelaSalarial == 1){
        sql.append(" AND  NOT EXISTS (SELECT 1 FROM reqpes.TABELA_SALARIAL_CARGOS TC WHERE TC.COD_CARGO = C.ID AND TC.COD_CARGO <> 8473 AND TC.COD_TAB_SALARIAL IN (2,3,4) ) ");
      }else{
        sql.append(" AND  EXISTS (SELECT 1 FROM reqpes.TABELA_SALARIAL_CARGOS TC WHERE TC.COD_CARGO = C.ID AND TC.COD_TAB_SALARIAL = " + codTabelaSalarial + ") ");        
      }
    }
    
    //-- Cláusulas restantes
    sql.append(" AND    C.ID                = CD.ID ");
    sql.append(" AND    C.ID                = UCTN.ID_CARGO ");
    sql.append(" AND    C.IN_SITUACAO_CARGO = 'A' ");
    sql.append(" ORDER  BY DESCRICAO ");
    
    try{
      retorno = this.getMatriz(sql.toString());
    }catch(Exception e){
      throw new RequisicaoPessoalException("InstrucaoDAO  \n -> Problemas na consulta de getComboCargo: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }  
  
   /**
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
  public String[][] getComboAreaSubArea() throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT UNIQUE CC.COD_SEGMENTO4 COD_SEGMENTO ");
    sql.append("       ,CD.DESCRICAO ");
    sql.append(" FROM   reqpes.CODE_COMBINATION_RH CC ");
    sql.append("       ,reqpes.CODE_DESCRICOES_RH  CD ");
    sql.append(" WHERE  CC.COD_SEGMENTO4 = CD.COD_SEGMENTO ");
    sql.append(" AND    CC.COD_SEGMENTO1 = '1' ");
    sql.append(" AND    CC.COD_SEGMENTO2 = '010' ");
    sql.append(" AND    CD.TIPO_SEGMENTO = 4 ");
    sql.append(" ORDER  BY CD.DESCRICAO ");
    
    try{
      retorno = this.getMatriz(sql.toString());
    }catch(Exception e){
      throw new RequisicaoPessoalException("InstrucaoDAO  \n -> Problemas na consulta de getComboAreaSubArea: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }
  
   /**
   * @return int
   * @throws RequisicaoPessoalException
   */
  public int getCotaCargo(String codUnidade, int codCargo, String condicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT I.COTA ");
    sql.append(" FROM   reqpes.INSTRUCAO            I ");
    sql.append("       ,reqpes.INSTRUCAO_ATRIBUICAO IA ");
    sql.append(" WHERE  I.COD_INSTRUCAO = IA.COD_INSTRUCAO ");
    sql.append(" AND    IA.COD_UNIDADE  = '" + codUnidade + "'");
    sql.append(" AND    I.COD_CARGO     = " + codCargo);
    sql.append(condicao);
    
    try{
      retorno = this.getMatriz(sql.toString());
    }catch(Exception e){
      throw new RequisicaoPessoalException("InstrucaoDAO  \n -> Problemas na consulta de getComboCotaCargo: \n\n " + sql.toString(), e.getMessage());
    }
    return (retorno != null && retorno.length > 0)? Integer.parseInt(retorno[0][0]) : -1;
  }
  
   /**
   * @return String[] 
   *         retorno[0]: status {0 (OK), 1 (INSTRUCAO PENDENTE), 2 (ATRIBUICAO PENDENTE)}
   *         retorno[1]: unidades
   *         
   * @param  Instrucao instrucao, int dml, String[] unidades
   * @throws RequisicaoPessoalException
   */
  public String[] isGravaInstrucao(Instrucao instrucao, int dml, String[] unidades) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    StringBuffer uo = null;
    String[][] result = null;
    String[] retorno = null;
       
    try{
      sql.append(" SELECT COUNT(*) AS QTD ");
      sql.append(" FROM   reqpes.INSTRUCAO T ");
      sql.append(" WHERE  T.COD_TAB_SALARIAL = " + instrucao.getCodTabelaSalarial());
      sql.append(" AND    T.COD_CARGO        = " + instrucao.getCodCargo());
      sql.append(" AND    T.COTA             = " + instrucao.getCota());
      
      if(dml == 1){
        sql.append(" AND T.COD_INSTRUCAO  <> " + instrucao.getCodInstrucao());  
      }
    
      if(instrucao.getCodAreaSubarea().equals("")){
        sql.append(" AND T.COD_AREA_SUBAREA IS NULL ");
      }else{
        sql.append(" AND T.COD_AREA_SUBAREA = " + instrucao.getCodAreaSubarea());
      }

      result = this.getMatriz(sql.toString());
      
      //-- Caso os dados da instrução estiverem válidos, verifica as unidades na atribuicao
      if(result[0][0].equals("0")){
        result = null;
        sql.delete(0, sql.length());
        sql.append(" SELECT IA.COD_UNIDADE ");
        sql.append(" FROM   reqpes.INSTRUCAO I, reqpes.INSTRUCAO_ATRIBUICAO IA ");
        sql.append(" WHERE  IA.COD_INSTRUCAO = I.COD_INSTRUCAO ");
        sql.append(" AND    I.COD_TAB_SALARIAL = " + instrucao.getCodTabelaSalarial());
        sql.append(" AND    I.COD_CARGO        = " + instrucao.getCodCargo());
        
        if(dml == 1){
          sql.append(" AND I.COD_INSTRUCAO  <> " + instrucao.getCodInstrucao());  
        }
      
        if(instrucao.getCodAreaSubarea().equals("")){
          sql.append(" AND I.COD_AREA_SUBAREA IS NULL ");
        }else{
          sql.append(" AND I.COD_AREA_SUBAREA = " + instrucao.getCodAreaSubarea());
        }
                
        sql.append(" AND IA.COD_UNIDADE IN( '' ");
        for(int i=0; i<unidades.length; i++){          
          sql.append(", '"+ unidades[i] +"'");
        }
        sql.append(" ) ");        
        sql.append(" GROUP  BY IA.COD_UNIDADE ");
        sql.append(" HAVING COUNT(*) > 0 ");
        
        result = this.getMatriz(sql.toString());
               
        if(result.length == 0 || result[0][0].equals("0")){
          // Registro pode ser salvo
          retorno = new String[]{"0", null};
        }else{
          // Duplicidade da unidade no registro da instrução
          uo = new StringBuffer();
          for(int i=0; i<result.length; i++){
            uo.append(result[i][0] +", ");
          }          
          retorno = new String[]{"2", uo.toString().substring(0,uo.length()-2)};
        }
        
      }else{
        // Duplicidade no registro da instrução
        retorno = new String[]{"1", null};
      }
      
    }catch(Exception e){
      throw new RequisicaoPessoalException("InstrucaoDAO  \n -> Problemas na consulta de isGravaInstrucao: \n\n " + sql.toString(), e.getMessage());
    }
    return retorno;
  }
  
   /**
   * @return int
   * @throws RequisicaoPessoalException
   */
  public int validaIN15(String codUnidade, int codCargo, int cotaCargo, String condicao) throws RequisicaoPessoalException{
    StringBuffer sql = new StringBuffer();
    String[][] retorno = null;
    
    sql.append(" SELECT COUNT(*) ");
    sql.append(" FROM   reqpes.INSTRUCAO            I ");
    sql.append("       ,reqpes.INSTRUCAO_ATRIBUICAO IA ");
    sql.append(" WHERE  I.COD_INSTRUCAO = IA.COD_INSTRUCAO ");
    sql.append(" AND    IA.COD_UNIDADE  = '" + codUnidade + "'");
    sql.append(" AND    I.COD_CARGO     = " + codCargo);
    sql.append(" AND    I.COTA          = " + cotaCargo);
    sql.append(condicao);   
    
    try{
      retorno = this.getMatriz(sql.toString());
    }catch(Exception e){
      throw new RequisicaoPessoalException("InstrucaoDAO  \n -> Problemas na consulta de validaIN15: \n\n " + sql.toString(), e.getMessage());
    }
    return (retorno != null && retorno.length > 0)? Integer.parseInt(retorno[0][0]) : 0;
  }  
}