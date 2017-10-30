package br.senac.sp.reqpes.DAO;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.componente.control.SistemaParametroControl;
import br.senac.sp.componente.model.SistemaParametro;
import br.senac.sp.componente.model.Usuario;

//-- Classes da aplicação
import br.senac.sp.reqpes.Control.RequisicaoAprovacaoControl;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.Config;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.CentroCusto;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 02/12/2011
 */
 
public class CentroCustoDAO implements InterfaceDataBase{
  ManipulacaoDAO manipulaDAO = new ManipulacaoDAO();

  public CentroCustoDAO(){

  }

  /**
   * @return String
   * @Function FUNCTION F_GET_ID_CODE_COMBINATION(P_IN_CENTRO_CUSTO IN VARCHAR2) RETURN VARCHAR2
   */
   public String getIdCodeCombination(String centroCusto) throws RequisicaoPessoalException{
    
    Transacao transacao = new Transacao(DATA_BASE_NAME);
    CallableStatement stmt = null;
    String msg = null;
       
    try{
        stmt = transacao.getCallableStatement("{? = call reqpes.F_GET_ID_CODE_COMBINATION(?) }");
        stmt.registerOutParameter(1,Types.VARCHAR);       
        stmt.setString(2,centroCusto);
        transacao.executeCallableStatement(stmt);
        msg = stmt.getString(1);
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("CentroCustoDAO  \n -> Problemas na consulta getIdCodeCombination: \n" ,e.getMessage());
    }finally{
      try{
         stmt.close();
         transacao.end();
      }catch(SQLException e){
         throw new RequisicaoPessoalException("CentroCustoDAO  \n -> Problemas ao fechar a conexão: " ,e.getMessage());
      }
    }
     return msg;
   }
  
   
   /**
    * @return List of CentroCusto Objects 
    */ 
  public List getSegmentos(int tipoSegmento, Usuario usuario) throws RequisicaoPessoalException, AdmTIException {
	  Transacao transacao = new Transacao(DATA_BASE_NAME);
	  StringBuffer sql = new StringBuffer();
      ArrayList listSegmentos = new ArrayList();      
      ResultSet rs = null;
      CentroCusto cc = null;
      
      sql.append(" SELECT T.COD_SEGMENTO ");
	  sql.append("       ,T.COD_SEGMENTO || ' - ' || T.DESCRICAO AS DSC_SEGMENTO ");
	  sql.append(" FROM   reqpes.CODE_DESCRICOES_RH T ");
	  sql.append(" WHERE  T.TIPO_SEGMENTO = " + tipoSegmento);
	  sql.append(" AND    T.COD_SEGMENTO <> '-' ");	  
	  //-- Cláusula exclusiva para os segmentos referentes de unidades
	  if (tipoSegmento == 2){
		  sql.append(" AND T.COD_SEGMENTO = '012' ");
	  }else if (tipoSegmento == 3) {
		      //-- Segmento trÃªs associado com as unidades existentes no RHEvolution
			  sql.append(" AND EXISTS (SELECT 1 ");
			  sql.append(" 		       FROM   rhev.UNIDADES_ORGANIZACIONAIS U ");
			  sql.append("        	   WHERE  SUBSTR(U.CODIGO, 1, 3) = T.COD_SEGMENTO ");
			  sql.append("         	   AND    U.NIVEL = 2 ");
			  sql.append("         	   AND    U.DATA_ENCERRAMENTO IS NULL) ");
			  
			  //-- Listagem com as unidades de acesso no perfil
		  	  SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
			  SistemaParametro idPerfilHOM = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_UO");
			  SistemaParametro idPerfilCRI = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_CRI");
			  SistemaParametro codUnidadeAPR = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"UNIDADE_APROVADORA");
		      String codUnidadeRHEV = new RequisicaoAprovacaoControl().getUnidadeRHEvolutionByCodUnidade(usuario.getUnidade().getCodUnidade());
		      
			  //-- Caso o usuário não seja da Unidade Aprovadora (GEP) e Administrador do sistema, apresenta apenas as unidades de acesso
			  if(usuario.getSistemaPerfil().getCodSistemaPerfil() == Integer.parseInt(idPerfilHOM.getVlrSistemaParametro()) || (usuario.getSistemaPerfil().getCodSistemaPerfil() == Integer.parseInt(idPerfilCRI.getVlrSistemaParametro()) && !codUnidadeAPR.getVlrSistemaParametro().equals(codUnidadeRHEV))){
			    //-- verificando as unidades de acesso
				String todasUnidades = "";
			    for(int i=0; usuario.getUnidades() != null && i < usuario.getUnidades().length; i++){
			      todasUnidades += ((i==0)?" ":",") + usuario.getUnidades()[i].getCodUnidade();        
			    }
			    todasUnidades = (todasUnidades.equals("") ? "0" : todasUnidades);			    
			    sql.append(" AND (TO_NUMBER(T.COD_SEGMENTO) = "+ usuario.getUnidade().getCodUnidade() +" OR TO_NUMBER(T.COD_SEGMENTO) IN ("+ todasUnidades +"))");      
			  }
			    
	  		}
	  sql.append(" ORDER  BY 2 ");

      try{
         rs = transacao.getCursor(sql.toString());
         while(rs.next()){
             // Setando os atributos
        	 cc = new CentroCusto();
        	 cc.setCodSegmento(rs.getString("COD_SEGMENTO"));
        	 cc.setDscSegmento(rs.getString("DSC_SEGMENTO"));
        	 listSegmentos.add(cc);
        }
        
    }catch(Exception e){
      throw new RequisicaoPessoalException("CentroCustoDAO  \n -> Problemas na consulta getSegmentos: \n\n " + sql.toString(), e.getMessage());
    }finally{
       try{
         rs.close();
         rs = null;
         transacao.end();
       }catch(Exception e){
         throw new RequisicaoPessoalException("CentroCustoDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(), e.getMessage());
       }
    }
    return listSegmentos;
   }
}  