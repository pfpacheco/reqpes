<%@ page import="br.senac.sp.componente.model.*" %>
<%@ page import="br.senac.sp.componente.control.*" %>
<%@ page import="br.senac.sp.componente.DAO.*" %>
<%@ page import="br.senac.sp.componente.util.Data" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.DAO.ResponsavelEstruturaDAO" %>

<%
  //-- Objetos de controle
  UsuarioControl usuarioControl = new UsuarioControl(); 
  SistemaPerfilControl sistemaPerfilControlUsuario = new SistemaPerfilControl();  
  ResponsavelEstruturaDAO responsavelEstruturaControl = new ResponsavelEstruturaDAO();  
  RequisicaoControl requisicaoControl = new RequisicaoControl();
  SistemaParametroDAO sistemaParametroControl = new SistemaParametroDAO();

  //-- Carreganco os id's dos perfis
  SistemaParametro idPerfilAPR = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_APR_GEP");
  SistemaParametro idPerfilHOM_UO = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_UO");
  SistemaParametro idPerfilHOM_GEP = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_GEP");
  SistemaParametro uoAPR = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"UNIDADE_APROVADORA");

  int perfil = 0;
  int chapa = Integer.parseInt(request.getParameter("chapa"));
  StringBuffer sql = new StringBuffer();  
  String[] resultado = null;
  String[][] resultado2 = null;
  String retorno = null;
  
  out.println("APR "+idPerfilAPR.getVlrSistemaParametro()+"<br>");
  out.println("HOM_UO "+idPerfilHOM_UO.getVlrSistemaParametro()+"<br>");
  out.println("HOM_GEP "+idPerfilHOM_GEP.getVlrSistemaParametro()+"<br>");

  out.println("TEOR "+ responsavelEstruturaControl.getTeorCodWorkflow()+"<br>");
  
  sql.append(" SELECT COUNT(*),'teste' ");
  sql.append(" FROM   RESPONSAVEL_ESTRUTURA RE ");
  sql.append(" WHERE  RE.TEOR_COD = '" + responsavelEstruturaControl.getTeorCodWorkflow()+"'");
  sql.append(" AND    RE.FUNC_ID  =  " + chapa);
  sql.append(" AND    TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN ");    
  
  out.println(sql.toString() + " <BR>");
  resultado2 = requisicaoControl.getMatriz(sql.toString(),"DsRequisicaoPessoal");
  out.println((resultado2[0][0]));
  
  out.println("<br>"+responsavelEstruturaControl.isAprovadorFinal(chapa)+"<BR>");
  
  //-- Verificando se o funcionário está na responsável estrutura
  if(resultado2 != null && Integer.parseInt(resultado2[0][0]) > 0){
    out.print("passou");
    sql.delete(0,sql.length());
    resultado = null;
    sql.append(" SELECT COUNT(*) ");
    sql.append(" FROM   RESPONSAVEL_ESTRUTURA RE ");
    sql.append(" WHERE  RE.TEOR_COD = '"+ responsavelEstruturaControl.getTeorCodWorkflow()+"' ");
    sql.append(" AND    RE.UNOR_COD = '"+ uoAPR.getVlrSistemaParametro()+"' ");
    sql.append(" AND    RE.FUNC_ID  =  "+ chapa);
    sql.append(" AND    TRUNC(SYSDATE) BETWEEN RE.REST_DAT_INI_VIGEN AND RE.REST_DAT_FIN_VIGEN "); 
    resultado = requisicaoControl.getLista(sql.toString());
    
    //-- Verificando se o funcionário é gerente da unidade aprovadora - 012C
    if(resultado != null && Integer.parseInt(resultado[0]) > 0){
      //-- Setando o perfil de APROVADOR FINAL
      perfil = Integer.parseInt(idPerfilAPR.getVlrSistemaParametro());
      retorno = ("APROVADOR FINAL"+"<br>");
    }else{
      //-- Setando o perfil de HOMOLOGADOR DE UNIDADE (GERENTE)
      perfil = Integer.parseInt(idPerfilHOM_UO.getVlrSistemaParametro());        
      retorno = ("HOMOLOGADOR UO"+"<br>");
    }
    
  }else{
  out.print("não passou");
  
  }
  /*
  else{  
    
      //-- verifica se é homologador da GEP
      if(responsavelEstruturaControl.isUsuarioHomologadorGEP(chapa)){
        // seta perfil de HOMOLOGADOR GEP
        perfil = Integer.parseInt(idPerfilHOM_GEP.getVlrSistemaParametro());
        retorno = ("HOMOLOGADOR GEP"+"<br>");
      //-- retorna perfil padrão
      }else{
          // retorna o mesmo perfil, no caso de CRIAÇÃO ou ADMINISTRADOR
          perfil = 0;
          retorno = ("PADRÃO - CRIAÇÃO ou ADMINISTRAÇÃO"+"<br>");
      }   
  } */

  out.println(retorno);
  out.println("perfil = "+perfil+"<br>");    
%>