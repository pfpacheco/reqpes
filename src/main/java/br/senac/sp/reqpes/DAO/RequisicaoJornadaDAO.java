package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;

//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.Horarios;
import br.senac.sp.reqpes.model.RequisicaoJornada;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Iterator;

import oracle.jdbc.OracleTypes;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 16/09/2008
 */
public class RequisicaoJornadaDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO  = new ManipulacaoDAO();

  public RequisicaoJornadaDAO(){

  }


  /**
   * @return int
   * @param  requisicaoJornada
   * @Procedure PROCEDURE SP_DML_REQUISICAO_JORNADA(  P_IN_DML                 IN NUMBER
                                                     ,P_IN_REQUISICAO_SQ       IN NUMBER
                                                     ,P_IN_COD_ESCALA          IN VARCHAR2
                                                     ,P_IN_ID_CALENDARIO       IN NUMBER
                                                     ,P_IN_IND_TIPO_HORARIO    IN VARCHAR2
                                                     -- 
                                                     ,P_IN_HR_SEGUNDA_ENTRADA1 IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_SAIDA1   IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_ENTRADA2 IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_SAIDA2   IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_ENTRADA3 IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_SAIDA3   IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_ENTRADA4 IN VARCHAR2
                                                     ,P_IN_HR_SEGUNDA_SAIDA4   IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_TERCA_ENTRADA1   IN VARCHAR2
                                                     ,P_IN_HR_TERCA_SAIDA1     IN VARCHAR2
                                                     ,P_IN_HR_TERCA_ENTRADA2   IN VARCHAR2
                                                     ,P_IN_HR_TERCA_SAIDA2     IN VARCHAR2
                                                     ,P_IN_HR_TERCA_ENTRADA3   IN VARCHAR2
                                                     ,P_IN_HR_TERCA_SAIDA3     IN VARCHAR2
                                                     ,P_IN_HR_TERCA_ENTRADA4   IN VARCHAR2
                                                     ,P_IN_HR_TERCA_SAIDA4     IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_QUARTA_ENTRADA1  IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_SAIDA1    IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_ENTRADA2  IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_SAIDA2    IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_ENTRADA3  IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_SAIDA3    IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_ENTRADA4  IN VARCHAR2
                                                     ,P_IN_HR_QUARTA_SAIDA4    IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_QUINTA_ENTRADA1  IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_SAIDA1    IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_ENTRADA2  IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_SAIDA2    IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_ENTRADA3  IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_SAIDA3    IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_ENTRADA4  IN VARCHAR2
                                                     ,P_IN_HR_QUINTA_SAIDA4    IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_SEXTA_ENTRADA1   IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_SAIDA1     IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_ENTRADA2   IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_SAIDA2     IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_ENTRADA3   IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_SAIDA3     IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_ENTRADA4   IN VARCHAR2
                                                     ,P_IN_HR_SEXTA_SAIDA4     IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_SABADO_ENTRADA1  IN VARCHAR2
                                                     ,P_IN_HR_SABADO_SAIDA1    IN VARCHAR2
                                                     ,P_IN_HR_SABADO_ENTRADA2  IN VARCHAR2
                                                     ,P_IN_HR_SABADO_SAIDA2    IN VARCHAR2
                                                     ,P_IN_HR_SABADO_ENTRADA3  IN VARCHAR2
                                                     ,P_IN_HR_SABADO_SAIDA3    IN VARCHAR2
                                                     ,P_IN_HR_SABADO_ENTRADA4  IN VARCHAR2
                                                     ,P_IN_HR_SABADO_SAIDA4    IN VARCHAR2
                                                     --
                                                     ,P_IN_HR_DOMINGO_ENTRADA1 IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_SAIDA1   IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_ENTRADA2 IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_SAIDA2   IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_ENTRADA3 IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_SAIDA3   IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_ENTRADA4 IN VARCHAR2
                                                     ,P_IN_HR_DOMINGO_SAIDA4   IN VARCHAR2) IS
   */
   
   private int dmlRequisicaoJornada(int tipoDML, RequisicaoJornada requisicaoJornada, Integer chapa)throws RequisicaoPessoalException{    
     int sucesso = 1;     
     Transacao transacao = new Transacao(DATA_BASE_NAME);
     String tipoTransacao = "";
     CallableStatement stmt = null;

     // Gerando log com parâmetros recebidos
     StringBuffer parametros = new StringBuffer();     
     parametros.append("\n1,"+tipoDML);
     parametros.append("\n2,"+requisicaoJornada.getCodRequisicao());
     parametros.append("\n3,"+requisicaoJornada.getCodEscala());        
     parametros.append("\n4,"+requisicaoJornada.getCodCalendario());        
     parametros.append("\n5,"+requisicaoJornada.getIndTipoHorario());
     
     switch(tipoDML){
       case  0 : tipoTransacao = "inserir" ; break;
       case  1 : tipoTransacao = "alterar" ; break;
     };

     try{
        stmt = transacao.getCallableStatement("{call reqpes.SP_DML_REQUISICAO_JORNADA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
        stmt.setInt(1,tipoDML); // 0 INSERT, 1 UPDATE
        stmt.setInt(2,requisicaoJornada.getCodRequisicao());
        stmt.setString(3,requisicaoJornada.getCodEscala());
        stmt.setInt(4,requisicaoJornada.getCodCalendario());      
        stmt.setString(5,requisicaoJornada.getIndTipoHorario());
        stmt.setInt(6,chapa);
        int idx = 7;
        
        if(requisicaoJornada.getCodEscala() == null || requisicaoJornada.getCodEscala().equals("")){
        	parametros.append("\n7, <Grade Horária>");
        	Horarios[] h = requisicaoJornada.getHorarios();
        	for(int i=0; i < h.length; i++){
	        	stmt.setString(idx++, h[i].getEntrada());
	        	stmt.setString(idx++, h[i].getIntervalo());
	        	stmt.setString(idx++, h[i].getRetorno());
	        	stmt.setString(idx++, h[i].getSaida());
	        	stmt.setString(idx++, h[i].getEntradaExtra());
	        	stmt.setString(idx++, h[i].getIntervaloExtra());
	        	stmt.setString(idx++, h[i].getRetornoExtra());
	        	stmt.setString(idx++, h[i].getSaidaExtra());
        	}
        }else{
        	parametros.append("\n7, <Escala Timekeeper>");
        	while(idx <= 62 /*N° de parâmetros da procedure*/){
	        	stmt.setNull(idx++, OracleTypes.VARCHAR);
        	}
        }
       
        // registrando parametro de saida
        stmt.registerOutParameter(2,Types.INTEGER);      
        transacao.executeCallableStatement(stmt);
        
        if(tipoDML >= 0){
          sucesso = stmt.getInt(2);
        }
        
     }catch(SQLException e){
       sucesso = 0;
       throw new RequisicaoPessoalException("SQLException: Ocorreu um erro ao "+ tipoTransacao +" a RequisicaoJornada: \n "+ parametros.toString(), e.getMessage());
     }catch(Exception e){
       sucesso = 0;
       throw new RequisicaoPessoalException("Exception: Ocorreu um erro ao "+ tipoTransacao +" a RequisicaoJornada: \n "+ parametros.toString(), e.getMessage());
     }finally{
       try{
          stmt.close();
          transacao.end();
       }catch(SQLException e){
          throw new RequisicaoPessoalException("Erro ao fechar conexao com RequisicaoJornada " ,e.getMessage());
       }
     }
      return sucesso;   
   }

  /**
   * @param requisicao
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_REQUISICAO_JORNADA
  */   
  public int gravaRequisicaoJornada(RequisicaoJornada requisicaoJornada)throws RequisicaoPessoalException{
    return this.dmlRequisicaoJornada(0, requisicaoJornada, null);
  }


  /**
   * @param requisicao
   * @return int
   * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
   * @procedure: SP_DML_REQUISICAO_JORNADA
  */
  public int alteraRequisicaoJornada(RequisicaoJornada requisicaoJornada, Integer chapa)throws RequisicaoPessoalException{
    return this.dmlRequisicaoJornada(1, requisicaoJornada, chapa);
  }


  /**
   * Retorna uma instancia da classe RequisicaoJornada, de acordo com o codigo informado
   * @return RequisicaoJornada
   * @throws br.senac.sp.exception.RequisicaoPessoalException
   */
  public RequisicaoJornada getRequisicaoJornada(int codRequisicao) throws RequisicaoPessoalException{   
      StringBuffer sql = new StringBuffer();
      ArrayList listHorarios = new ArrayList();
      RequisicaoJornada requisicaoJornada = new RequisicaoJornada();
      Horarios horario = new Horarios();
      Horarios[] horarios = null;
      Transacao transacao = new Transacao(DATA_BASE_NAME);
      ResultSet rs = null;
     
      sql.append(" SELECT CODIGO_ESCALA ");
	  sql.append("       ,ID_CALENDARIO ");
	  sql.append("       ,IND_TIPO_HORARIO ");
	  sql.append("       ,DIA ");
	  sql.append("       ,HORARIO_ENTRADA ");
	  sql.append("       ,HORARIO_ALMOCO ");
	  sql.append("       ,HORARIO_RETORNO ");
	  sql.append("       ,HORARIO_SAIDA ");
	  sql.append("       ,HORARIO_ENTRADA_EXTRA ");
	  sql.append("       ,HORARIO_ALMOCO_EXTRA ");
	  sql.append("       ,HORARIO_RETORNO_EXTRA ");
	  sql.append("       ,HORARIO_SAIDA_EXTRA ");
	  sql.append(" FROM   reqpes.VW_REQUISICAO_JORNADA ");
	  sql.append(" WHERE  REQUISICAO_SQ = " + codRequisicao);

      try{
         rs = transacao.getCursor(sql.toString());         
         while(rs.next()){
            // Setando os atributos            
            requisicaoJornada.setCodEscala(rs.getString("CODIGO_ESCALA"));
            requisicaoJornada.setCodCalendario(rs.getInt("ID_CALENDARIO"));
            requisicaoJornada.setIndTipoHorario(rs.getString("IND_TIPO_HORARIO"));
            
            // Adicionando os horários
            horario = new Horarios();
            horario.setDia(rs.getString("DIA"));
            horario.setEntrada(rs.getString("HORARIO_ENTRADA"));
            horario.setIntervalo(rs.getString("HORARIO_ALMOCO"));
            horario.setRetorno(rs.getString("HORARIO_RETORNO"));
            horario.setSaida(rs.getString("HORARIO_SAIDA"));
            horario.setEntradaExtra(rs.getString("HORARIO_ENTRADA_EXTRA"));
            horario.setIntervaloExtra(rs.getString("HORARIO_ALMOCO_EXTRA"));
            horario.setRetornoExtra(rs.getString("HORARIO_RETORNO_EXTRA"));
            horario.setSaidaExtra(rs.getString("HORARIO_SAIDA_EXTRA"));
            listHorarios.add(horario);            
        }

        horarios = new Horarios[listHorarios.size()];
        listHorarios.toArray(horarios);
        
        requisicaoJornada.setCodRequisicao(codRequisicao);
        requisicaoJornada.setHorarios(horarios);
    
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoJornadaDAO  \n -> Problemas na consulta de RequisicaoJornada: \n\n " + sql.toString(), e.getMessage());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("RequisicaoJornadaDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(), e.getMessage());
       }
    }
    return requisicaoJornada;
  }


   /**
   * @param sql
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
   public String[][] getEscala(String jornadaTrabalho, ArrayList horariosList) throws RequisicaoPessoalException{
                               
    StringBuffer sql = new StringBuffer();
    Iterator i = horariosList.iterator();
    Horarios horario = new Horarios();
    String[][] retorno = null;
    boolean isEntrada = false;
    boolean isIntervalo = false;
    boolean isRetorno = false;

    while(i.hasNext()){
      horario = (Horarios) i.next();
      if(!horario.getDia().equals("0")){
        sql.append("INTERSECT");
        sql.append(" SELECT H.CODIGO_ESCALA ");
        sql.append("       ,H.DESCRICAO_ESCALA ");
        sql.append("       ,T.JORNADA_SEMANAL ");
        sql.append("       ,TRANSLATE(ROUND(T.TOTAL_HORAS,1),',','.') AS TOTAL_HORAS ");
        sql.append(" FROM   VW_ESCALA_HORARIO H ");
        sql.append("      ,(SELECT T.CODIGO_ESCALA ");
        sql.append("              ,SUM(TOTAL_DA_JORNADA) AS TOTAL_HORAS ");
        sql.append("              ,CASE ");
        sql.append("                WHEN T.DESCRICAO_ESCALA LIKE '%MENSALISTA%' THEN ");
        sql.append("                  (T.JORNADA_ESCALA / 5) ");
        sql.append("                WHEN T.DESCRICAO_ESCALA LIKE '%HORISTA%' THEN ");
        sql.append("                  (T.JORNADA_ESCALA / 4.5) ");
        sql.append("                ELSE ");
        sql.append("                  NULL ");
        sql.append("               END JORNADA_SEMANAL ");
        sql.append("        FROM   VW_ESCALA_HORARIO T ");
        sql.append("        GROUP  BY T.CODIGO_ESCALA, T.DESCRICAO_ESCALA, T.JORNADA_ESCALA) T ");
	  
        sql.append(" WHERE  H.DIA = '"+ horario.getDia() +"' ");
        sql.append(" AND   (( ");
        
        if(horario.getClassificacao().equals("TRAB")){
          sql.append(" ( ");
            if(horario.getEntrada() != null && !horario.getEntrada().equals("")){
              isEntrada = true;
              sql.append(" TO_CHAR(H.HORARIO_ENTRADA,'HH24:MI') = '"+ horario.getEntrada() +"' ");
            }else{
              isEntrada = false;
            }
            
            if(horario.getIntervalo() != null && !horario.getIntervalo().equals("")){
              isIntervalo = true;
              if(isEntrada){
                sql.append(" AND ");  
              }
              sql.append(" TO_CHAR(H.HORARIO_ALMOCO,'HH24:MI') = '"+ horario.getIntervalo() +"' ");
            }else{
              isIntervalo = false;
            }
            
            if(horario.getRetorno() != null && !horario.getRetorno().equals("")){
              isRetorno = true;
              if(isEntrada || isIntervalo){
                sql.append(" AND ");  
              }
              sql.append(" TO_CHAR(H.HORARIO_RETORNO,'HH24:MI') = '"+ horario.getRetorno() +"' ");
            }else{
              isRetorno = false;
            }
            
            if(horario.getSaida() != null && !horario.getSaida().equals("")){
              if(isEntrada || isIntervalo || isRetorno){
                sql.append(" AND ");  
              }
              sql.append(" TO_CHAR(H.HORARIO_SAIDA,'HH24:MI') = '"+ horario.getSaida() +"' ");
            }
            sql.append(" ) AND ");
        }

        sql.append("          '"+ horario.getClassificacao() +"' NOT IN ('DSRM', 'COMP') ");
        sql.append("         )OR CODIGO_HORARIO = '"+ horario.getClassificacao() +"') ");
        sql.append(" AND   H.CODIGO_ESCALA = T.CODIGO_ESCALA ");
        sql.append(" AND   (TRANSLATE(T.JORNADA_SEMANAL,',','.') = '"+ jornadaTrabalho +"' OR TRANSLATE(ROUND(T.TOTAL_HORAS,1),',','.') = '"+ jornadaTrabalho +"') ");
      }
    }
    
    //RequisicaoMensagemControl.enviaMensagemCritica(horariosList.size()+"", sql.toString().substring(9,sql.length()), null);
    
    try{
      //-- Realiza a consulta retirando o primeiro INTERSECT
      retorno = manipulaDAO.getMatriz(sql.toString().substring(9,sql.length()), DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoJornadaDAO  \n -> Problemas na consulta de getEscala: \n" + sql.toString().substring(9,sql.length()), e.getMessage());
    }
    return retorno;   
   }                               


   /**
   * @param sql
   * @return String[][]
   * @throws RequisicaoPessoalException
   */
   public String[][] getEscalaHorario(String codEscala) throws RequisicaoPessoalException{    
      StringBuffer sql = new StringBuffer();
      String[][] retorno = null;
      
      sql.append(" SELECT DECODE(DIA,'SEG','SEGUNDA-FEIRA' ");
      sql.append("                  ,'TER','TERÇA-FEIRA' ");
      sql.append("                  ,'QUA','QUARTA-FEIRA' ");
      sql.append("                  ,'QUI','QUINTA-FEIRA' ");
      sql.append("                  ,'SEX','SEXTA-FEIRA' ");
      sql.append("                  ,'SAB','SÁBADO' ");
      sql.append("                  ,'DOM','DOMINGO') AS DIA ");
      sql.append("       ,DECODE(CODIGO_HORARIO,'COMP','COMPENSADO' ");
      sql.append("                             ,'DSRM','DESCANSO' ");
      sql.append("                             ,'TRABALHADO') DSC_HORARIO ");
      sql.append("       ,TO_CHAR(H.HORARIO_ENTRADA, 'HH24:MI') ENTRADA ");
      sql.append("       ,TO_CHAR(H.HORARIO_ALMOCO,  'HH24:MI') INTERVALO ");
      sql.append("       ,TO_CHAR(H.HORARIO_RETORNO, 'HH24:MI') RETORNO ");
      sql.append("       ,TO_CHAR(H.HORARIO_SAIDA,   'HH24:MI') SAIDA ");
      sql.append("       ,ROUND(TOTAL_DA_JORNADA, 2) HORAS ");
      sql.append(" FROM   VW_ESCALA_HORARIO H ");
      sql.append(" WHERE  H.CODIGO_ESCALA = '"+ codEscala +"' ");
     
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoJornadaDAO  \n -> Problemas na consulta de getEscalaHorario: "+codEscala+ "\n\n " + sql.toString(), e.getMessage());
    }
    return retorno;            
   }
 

  /**
   * @param codUnidade, codEscala
   * @return String[]
   * @throws RequisicaoPessoalException
   */  
  public String[][] getIdCalendario(String codUnidade, String codEscala) throws RequisicaoPessoalException{
      StringBuffer sql = new StringBuffer();
      String[][] retorno = null;
      
      sql.append(" SELECT CALENDARIO ");
      sql.append("       ,TC.DESCRICAO ");
      sql.append("       ,CODIGO_ESCALA ");
      sql.append(" FROM   (SELECT C.ID CALENDARIO ");
      sql.append("               ,DECODE(C.SEGUNDA_V,'N','S','N') SEG ");
      sql.append("               ,DECODE(C.TERCA_V,  'N','S','N') TER ");
      sql.append("               ,DECODE(C.QUARTA_V, 'N','S','N') QUA ");
      sql.append("               ,DECODE(C.QUINTA_V, 'N','S','N') QUI ");
      sql.append("               ,DECODE(C.SEXTA_V,  'N','S','N') SEX ");
      sql.append("               ,DECODE(C.SABADO_V, 'N','S','N') SAB ");
      sql.append("               ,DECODE(C.DOMINGO_V,'N','S','N') DOM ");
      sql.append("         FROM   TIPO_CALENDARIO C ");
      sql.append("         WHERE  (C.SEGUNDA_V = 'S' OR C.TERCA_V = 'S' OR C.QUARTA_V = 'S' OR C.QUINTA_V = 'S' OR C.SEXTA_V = 'S' OR C.SABADO_V = 'S' OR C.DOMINGO_V = 'S')) CAL ");
      sql.append("       ,(SELECT FCE.CODIGO_ESCALA ");
      sql.append("               ,MAX(DECODE(FCE.DIA,'SEG',DECODE(FCE.CLASSIFICACAO_DIA,'TRA','S','N'))) SEG ");
      sql.append("               ,MAX(DECODE(FCE.DIA,'TER',DECODE(FCE.CLASSIFICACAO_DIA,'TRA','S','N'))) TER ");
      sql.append("               ,MAX(DECODE(FCE.DIA,'QUA',DECODE(FCE.CLASSIFICACAO_DIA,'TRA','S','N'))) QUA ");
      sql.append("               ,MAX(DECODE(FCE.DIA,'QUI',DECODE(FCE.CLASSIFICACAO_DIA,'TRA','S','N'))) QUI ");
      sql.append("               ,MAX(DECODE(FCE.DIA,'SEX',DECODE(FCE.CLASSIFICACAO_DIA,'TRA','S','N'))) SEX ");
      sql.append("               ,MAX(DECODE(FCE.DIA,'SAB',DECODE(FCE.CLASSIFICACAO_DIA,'TRA','S','N'))) SAB ");
      sql.append("               ,MAX(DECODE(FCE.DIA,'DOM',DECODE(FCE.CLASSIFICACAO_DIA,'TRA','S','N'))) DOM ");
      sql.append("         FROM   FREQ_CALENDARIO_ESCALA FCE  ");
      sql.append("         GROUP  BY FCE.CODIGO_ESCALA) ESC   ");      
      sql.append("       ,UNIORG_ENDERECO UOE ");
      sql.append("       ,TIPO_CALENDARIO TC ");
      sql.append(" WHERE  CAL.SEG || CAL.TER || CAL.QUA || CAL.QUI || CAL.SEX || CAL.SAB || CAL.DOM = ESC.SEG || ESC.TER || ESC.QUA || ESC.QUI || ESC.SEX || ESC.SAB || ESC.DOM  ");
      sql.append(" AND    DECODE(UOE.CIDADE,'SAO PAULO',CAL.CALENDARIO,SUBSTR(UOE.COD_UNIORG,1,LENGTH(UOE.COD_UNIORG) - 1) || SUBSTR(CAL.CALENDARIO,LENGTH(UOE.COD_UNIORG),LENGTH(CAL.CALENDARIO) - 2)) = CAL.CALENDARIO ");
      sql.append(" AND    LENGTH(CAL.CALENDARIO) <= DECODE(UOE.CIDADE,'SAO PAULO',2,LENGTH(CAL.CALENDARIO)) ");
      sql.append(" AND    TC.ID             = CAL.CALENDARIO ");
      sql.append(" AND    UOE.COD_UNIORG    = UO_CODIGO_NIVEL('" + codUnidade + "',1) ");
      sql.append(" AND    ESC.CODIGO_ESCALA = '" + codEscala + "' ");
     
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoJornadaDAO  \n -> Problemas na consulta de getCalendario: \nUnidade: " + codUnidade + "\n Escala :" + codEscala + "\n\n " + sql.toString(), e.getMessage());
    }
    return retorno;               
  }
  
  /**
   * @param codUnidade, indSegunda, indTerca, indQuarta, indQuinta, indSexta, indSabado, indDomingo
   * @return String[]
   * @throws RequisicaoPessoalException
   */  
  public String[][] getIdCalendario(String codUnidade, String indSegunda, String indTerca, String indQuarta, String indQuinta, String indSexta, String indSabado, String indDomingo) throws RequisicaoPessoalException{
      StringBuffer sql = new StringBuffer();
      String[][] retorno = null;
      
      sql.append(" SELECT CALENDARIO ");
      sql.append("       ,TC.DESCRICAO ");
      sql.append(" FROM   (SELECT DISTINCT C.ID CALENDARIO ");
      sql.append("               ,DECODE(C.SEGUNDA_V,'N','S','N') SEG ");
      sql.append("               ,DECODE(C.TERCA_V,  'N','S','N') TER ");
      sql.append("               ,DECODE(C.QUARTA_V, 'N','S','N') QUA ");
      sql.append("               ,DECODE(C.QUINTA_V, 'N','S','N') QUI ");
      sql.append("               ,DECODE(C.SEXTA_V,  'N','S','N') SEX ");
      sql.append("               ,DECODE(C.SABADO_V, 'N','S','N') SAB ");
      sql.append("               ,DECODE(C.DOMINGO_V,'N','S','N') DOM ");
      sql.append("         FROM   TIPO_CALENDARIO C ");
      sql.append("               ,UNIORG_ENDERECO UOE ");       
      sql.append("         WHERE  (C.SEGUNDA_V = 'S' OR C.TERCA_V = 'S' OR C.QUARTA_V = 'S' OR C.QUINTA_V = 'S' OR C.SEXTA_V = 'S' OR C.SABADO_V = 'S' OR C.DOMINGO_V = 'S') ");
      sql.append("         AND    DECODE(UOE.CIDADE,'SAO PAULO',C.ID,SUBSTR(UOE.COD_UNIORG,1,LENGTH(UOE.COD_UNIORG) - 1) || SUBSTR(C.ID,LENGTH(UOE.COD_UNIORG),LENGTH(C.ID) - 2)) = C.ID ");
      sql.append("         AND    LENGTH(C.ID) <= DECODE(UOE.CIDADE,'SAO PAULO',2,LENGTH(C.ID)) ");
      sql.append("         AND    UOE.COD_UNIORG = UO_CODIGO_NIVEL('" + codUnidade + "',1)) DIAS ");
      sql.append("       ,TIPO_CALENDARIO TC ");
      sql.append(" WHERE  TC.ID    = DIAS.CALENDARIO ");
      sql.append(" AND    DIAS.SEG = '" + indSegunda + "' "); //-- S/N
      sql.append(" AND    DIAS.TER = '" + indTerca   + "' "); //-- S/N
      sql.append(" AND    DIAS.QUA = '" + indQuarta  + "' "); //-- S/N
      sql.append(" AND    DIAS.QUI = '" + indQuinta  + "' "); //-- S/N
      sql.append(" AND    DIAS.SEX = '" + indSexta   + "' "); //-- S/N
      sql.append(" AND    DIAS.SAB = '" + indSabado  + "' "); //-- S/N
      sql.append(" AND    DIAS.DOM = '" + indDomingo + "' "); //-- S/N
     
    try{
      retorno = manipulaDAO.getMatriz(sql.toString(),DATA_BASE_NAME);
    }catch(Exception e){
      throw new RequisicaoPessoalException("RequisicaoJornadaDAO  \n -> Problemas na consulta de getCalendario: \n Unidade: " + codUnidade + "\n Indicadores: " + indSegunda + "," + indTerca + "," + indQuarta + "," + indQuinta + "," + indSexta + "," + indSabado + "," + indDomingo + "\n\n " + sql.toString(), e.getMessage());
    }
    return retorno;               
  } 
}