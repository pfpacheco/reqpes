<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.Interface.Config" %>
<%@ page import="br.senac.sp.componente.model.*" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
  //-- Objetos de controle
  SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
  
  //-- Objetos
  StringBuffer sqlQuery = new StringBuffer();
  String[][] segmentosCombo = null;
  String acao = "";
  
  //-- Objeto de sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  int codPerfilUsuario  = usuario.getSistemaPerfil().getCodSistemaPerfil();
  int codUnidadeUsuario = usuario.getUnidade().getCodUnidade();  
  
  //-- Parametros de página
  int codSegmento       = (request.getParameter("P_COD_SEGMENTO")==null)?0:Integer.parseInt(request.getParameter("P_COD_SEGMENTO"));
  String nomeCombo      = request.getParameter("P_NOME_COMBO");
  String codSegmento3   = request.getParameter("COD_SEGMENTO3");
  String codSegmento4   = request.getParameter("COD_SEGMENTO4");
  String codSegmento5   = request.getParameter("COD_SEGMENTO5");
  String codSegmentoPai = request.getParameter("P_COD_SEGMENTO_PAI");
  String valorSelecionado = request.getParameter("P_VALOR_SELECIONADO").trim();
  
  //--  SEGMENTO 1
  if(codSegmento != 0 && codSegmento == 1){
    //-- setando a query do combo
    sqlQuery.delete(0,sqlQuery.length());
    sqlQuery.append(" SELECT UNIQUE CC.COD_SEGMENTO1 COD_SEGMENTO ");
    sqlQuery.append("       ,CD.TIPO_SEGMENTO ");
    sqlQuery.append("       ,CD.DESCRICAO ");
    sqlQuery.append(" FROM   CODE_COMBINATION_RH CC ");
    sqlQuery.append("       ,CODE_DESCRICOES_RH  CD ");
    sqlQuery.append(" WHERE  CC.COD_SEGMENTO1 = CD.COD_SEGMENTO ");	     
    sqlQuery.append(" AND    CC.COD_SEGMENTO1 = '1' ");
    
    //-- setando a ação do combo
    acao = "onChange=\"javaScript:carregaComboValorSetado(document.frmPesquisa,this.value,2,'divSegmento2',-1,'segmento2', '', '', '', '', '', '"+request.getContextPath()+"/requisicao/cadastro/ajax/getComboSegmento.jsp');\"";
  }

  //--  SEGMENTO 2
  if(codSegmento != 0 && codSegmento == 2){
    //-- setando a query do combo
    sqlQuery.delete(0,sqlQuery.length());
    sqlQuery.append(" SELECT UNIQUE CC.COD_SEGMENTO2 COD_SEGMENTO ");
    sqlQuery.append("       ,CD.TIPO_SEGMENTO ");
    sqlQuery.append("       ,CD.DESCRICAO ");
    sqlQuery.append(" FROM   CODE_COMBINATION_RH CC ");
    sqlQuery.append("       ,CODE_DESCRICOES_RH  CD ");
    sqlQuery.append(" WHERE  CC.COD_SEGMENTO2 = CD.COD_SEGMENTO ");	     
    sqlQuery.append(" AND    CC.COD_SEGMENTO1 = '1' ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO2 = '012' ");
    sqlQuery.append(" AND    CD.TIPO_SEGMENTO = 2 ");
    
    //-- setando a ação do combo
    acao = "onChange=\"javaScript:carregaComboValorSetado(document.frmPesquisa,this.value,3,'divSegmento3',-1,'segmento3', '', '', '', '', '', '"+request.getContextPath()+"/requisicao/cadastro/ajax/getComboSegmento.jsp');\"";
  }  

  //--  SEGMENTO 3
  if(codSegmento != 0 && codSegmento == 3){

    //-- Carregando parametros do sistema
    SistemaParametro idPerfilHOM = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_UO");
    SistemaParametro idPerfilCRI = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_CRI");
    SistemaParametro codUnidadeAPR = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"UNIDADE_APROVADORA");

    //-- Setando unidade do usuário no formato RHEvolution
    String codUnidadeRHEV = new RequisicaoAprovacaoControl().getUnidadeRHEvolutionByCodUnidade(codUnidadeUsuario);  
  
    //-- setando a query do combo
    sqlQuery.delete(0,sqlQuery.length());
    sqlQuery.append(" SELECT UNIQUE CC.COD_SEGMENTO3 COD_SEGMENTO ");
    sqlQuery.append("       ,CD.TIPO_SEGMENTO ");
    sqlQuery.append("       ,CD.DESCRICAO ");
    sqlQuery.append(" FROM   CODE_COMBINATION_RH CC ");
    sqlQuery.append("       ,CODE_DESCRICOES_RH  CD ");
    sqlQuery.append("       ,UNIDADE       UO ");
    sqlQuery.append(" WHERE  CC.COD_SEGMENTO3 = CD.COD_SEGMENTO ");	     
    sqlQuery.append(" AND    CC.COD_SEGMENTO3 = LPAD(UO.COD_UNIDADE,3,'0') ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO1 = '1' ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO2 = '012' ");
    sqlQuery.append(" AND    CD.TIPO_SEGMENTO = 3 ");
    
    //-- Caso o usuário não seja da Unidade Aprovadora (GEP) e Administrador do sistema, apresenta apenas as unidades de acesso
    if(codPerfilUsuario == Integer.parseInt(idPerfilHOM.getVlrSistemaParametro()) || (codPerfilUsuario == Integer.parseInt(idPerfilCRI.getVlrSistemaParametro()) && !codUnidadeAPR.getVlrSistemaParametro().equals(codUnidadeRHEV))){
      //-- verificando as unidades de acesso
      String todasUnidades = "";
      for(int i=0; usuario.getUnidades() != null && i < usuario.getUnidades().length; i++){
        todasUnidades += ((i==0)?" ":",") + usuario.getUnidades()[i].getCodUnidade();        
      }             
      todasUnidades = (todasUnidades.equals("")?"0":todasUnidades);
      sqlQuery.append(" AND (CC.COD_SEGMENTO3 = LPAD('"+ codUnidadeUsuario +"',3,'0') OR UO.COD_UNIDADE IN ("+ todasUnidades +"))");
    }    
    
    sqlQuery.append(" ORDER BY CC.COD_SEGMENTO3 ");
    
    //-- setando a ação do combo
    acao = "onChange=\"javaScript:carregaComboValorSetado(document.frmPesquisa,this.value,4,'divSegmento4',-1,'segmento4', this.value, '', '', '', '', '"+request.getContextPath()+"/requisicao/cadastro/ajax/getComboSegmento.jsp'); \"";
  }  

  //--  SEGMENTO 4
  if(codSegmento != 0 && codSegmento == 4){
    //-- setando a query do combo
    sqlQuery.delete(0,sqlQuery.length());
    sqlQuery.append(" SELECT UNIQUE CC.COD_SEGMENTO4 COD_SEGMENTO ");
    sqlQuery.append("       ,CD.TIPO_SEGMENTO ");
    sqlQuery.append("       ,CD.DESCRICAO ");
    sqlQuery.append(" FROM   CODE_COMBINATION_RH CC ");
    sqlQuery.append("       ,CODE_DESCRICOES_RH  CD ");
    sqlQuery.append(" WHERE  CC.COD_SEGMENTO4 = CD.COD_SEGMENTO ");	     
    sqlQuery.append(" AND    CC.COD_SEGMENTO1 = '1' ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO2 = '012' ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO3 = '" + codSegmentoPai + "' ");    
    sqlQuery.append(" AND    CD.TIPO_SEGMENTO = 4 ");
    sqlQuery.append(" ORDER BY CC.COD_SEGMENTO4 ");
    
    //-- setando a ação do combo
    acao = "onChange=\"javaScript:carregaComboValorSetado(document.frmPesquisa,this.value,5,'divSegmento5',-1,'segmento5', '" + codSegmento3 + "', this.value, '', '', '', '"+request.getContextPath()+"/requisicao/cadastro/ajax/getComboSegmento.jsp');\"";    
  }  
  
  //--  SEGMENTO 5
  if(codSegmento != 0 && codSegmento == 5){
    //-- setando a query do combo
    sqlQuery.delete(0,sqlQuery.length());
    sqlQuery.append(" SELECT UNIQUE CC.COD_SEGMENTO5 COD_SEGMENTO ");
    sqlQuery.append("       ,CD.TIPO_SEGMENTO ");
    sqlQuery.append("       ,CD.DESCRICAO ");
    sqlQuery.append(" FROM   CODE_COMBINATION_RH CC ");
    sqlQuery.append("       ,CODE_DESCRICOES_RH  CD ");
    sqlQuery.append(" WHERE  CC.COD_SEGMENTO5 = CD.COD_SEGMENTO ");	     
    sqlQuery.append(" AND    CC.COD_SEGMENTO1 = '1' ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO2 = '012' ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO3 = '" + codSegmento3 + "' ");    
    sqlQuery.append(" AND    CC.COD_SEGMENTO4 = '" + codSegmentoPai + "' ");    
    sqlQuery.append(" AND    CD.TIPO_SEGMENTO = 5 ");
    sqlQuery.append(" ORDER BY CC.COD_SEGMENTO5 ");
    
    //-- setando a ação do combo
    acao = "onChange=\"javaScript:carregaComboValorSetado(document.frmPesquisa,this.value,6,'divSegmento6',-1,'segmento6', '" + codSegmento3 + "', '" + codSegmento4 + "', this.value, '', '', '"+request.getContextPath()+"/requisicao/cadastro/ajax/getComboSegmento.jsp');\"";    
  } 
  
  //--  SEGMENTO 6
  if(codSegmento != 0 && codSegmento == 6){
    //-- setando a query do combo
    sqlQuery.delete(0,sqlQuery.length());
    sqlQuery.append(" SELECT UNIQUE CC.COD_SEGMENTO6 COD_SEGMENTO ");
    sqlQuery.append("       ,CD.TIPO_SEGMENTO ");
    sqlQuery.append("       ,CD.DESCRICAO ");
    sqlQuery.append(" FROM   CODE_COMBINATION_RH CC ");
    sqlQuery.append("       ,CODE_DESCRICOES_RH  CD ");
    sqlQuery.append(" WHERE  CC.COD_SEGMENTO6 = CD.COD_SEGMENTO ");	     
    sqlQuery.append(" AND    CC.COD_SEGMENTO1 = '1' ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO2 = '012' ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO3 = '" + codSegmento3 + "' ");    
    sqlQuery.append(" AND    CC.COD_SEGMENTO4 = '" + codSegmento4 + "' ");    
    sqlQuery.append(" AND    CC.COD_SEGMENTO5 = '" + codSegmentoPai + "' ");    
    sqlQuery.append(" AND    CD.TIPO_SEGMENTO = 6 ");
    sqlQuery.append(" ORDER BY CC.COD_SEGMENTO6 ");
    
    //-- setando a ação do combo
    acao = "onChange=\"javaScript:carregaComboValorSetado(document.frmPesquisa,this.value,7,'divSegmento7',-1,'segmento7', '" + codSegmento3 + "', '" + codSegmento4 + "', '" + codSegmento5 + "', this.value, '', '"+request.getContextPath()+"/requisicao/cadastro/ajax/getComboSegmento.jsp');\"";    
  }  
  
  //--  SEGMENTO 7
  if(codSegmento != 0 && codSegmento == 7){
    //-- setando a query do combo
    sqlQuery.delete(0,sqlQuery.length());
    sqlQuery.append(" SELECT UNIQUE CC.COD_SEGMENTO7 COD_SEGMENTO ");
    sqlQuery.append("       ,CD.TIPO_SEGMENTO ");
    sqlQuery.append("       ,CD.DESCRICAO ");
    sqlQuery.append(" FROM   CODE_COMBINATION_RH CC ");
    sqlQuery.append("       ,CODE_DESCRICOES_RH  CD ");
    sqlQuery.append(" WHERE  CC.COD_SEGMENTO7 = CD.COD_SEGMENTO ");	     
    sqlQuery.append(" AND    CC.COD_SEGMENTO1 = '1' ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO2 = '012' ");
    sqlQuery.append(" AND    CC.COD_SEGMENTO3 = '" + codSegmento3 + "' ");    
    sqlQuery.append(" AND    CC.COD_SEGMENTO4 = '" + codSegmento4 + "' ");    
    sqlQuery.append(" AND    CC.COD_SEGMENTO5 = '" + codSegmento5 + "' ");    
    sqlQuery.append(" AND    CC.COD_SEGMENTO6 = '" + codSegmentoPai + "' ");    
    sqlQuery.append(" AND    CD.TIPO_SEGMENTO = 7 ");   
    sqlQuery.append(" ORDER BY CC.COD_SEGMENTO7 ");
  }    
%>      
<%--  gerar o combo baseado na consulta  --%>
<%if(codSegmento != 0){
  segmentosCombo = new RequisicaoControl().getMatriz(sqlQuery.toString()); 
%>
 <select name="<%=nomeCombo%>" id="<%="id"+nomeCombo%>" <%=acao%> style="width: 450px;">
      <option value="-1">SELECIONE UMA OPÇÃO</option>	
  <%for(int i=0; i<segmentosCombo.length; i++){%>
      <option value="<%=segmentosCombo[i][0]%>" <%=(segmentosCombo[i][0].equals(valorSelecionado))?" SELECTED":""%>><%=segmentosCombo[i][0]+" - "+segmentosCombo[i][2]%></option>
  <%}%>
 </select>
<%}%>