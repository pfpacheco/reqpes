<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="br.senac.sp.reqpes.Interface.Config" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.DAO.*" %>
<%@ page import="br.senac.sp.componente.model.*" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>

<jsp:include page="../../template/cabecalho.jsp"/>

<%
  //-- Objetos control
  RequisicaoControl          requisicaoControl          = new RequisicaoControl();
  RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();
  SistemaParametroControl    sistemaParametroControl    = new SistemaParametroControl();
  CentroCustoControl 	     ccControl 					= new CentroCustoControl();
  
  //-- Objetos de sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  int codPerfilUsuario  = usuario.getSistemaPerfil().getCodSistemaPerfil();
  int codUnidadeUsuario = usuario.getUnidade().getCodUnidade();  
  
  //-- Parametros de página
  String codRequisicao        = (request.getParameter("requisicaoSq")==null)?"":request.getParameter("requisicaoSq");  
  String datInicio            = (request.getParameter("datInicio")==null)?"":request.getParameter("datInicio");
  String datFim               = (request.getParameter("datFim")==null)?"":request.getParameter("datFim");
  String cargoSq              = (request.getParameter("cargo_sq")==null)?"0":request.getParameter("cargo_sq");  
  String codRecrutamento      = (request.getParameter("codRecrutamento")==null)?"0":request.getParameter("codRecrutamento");
  String rpPara               = (request.getParameter("rpPara")==null)?"0":request.getParameter("rpPara");  
  String codMotivoSolicitacao = (request.getParameter("codMotivoSolicitacao")==null)?"0":request.getParameter("codMotivoSolicitacao");
  String codTipoContratacao   = (request.getParameter("codTipoContratacao")==null)?"0":request.getParameter("codTipoContratacao");
  String statusRequisicao     = (request.getParameter("statusRequisicao")==null)?"0":request.getParameter("statusRequisicao");  
  String idFuncBaixado        = (request.getParameter("idFuncBaixado")==null)?"":request.getParameter("idFuncBaixado");  
  String compPesquisa         = (request.getParameter("compPesquisa")==null)?"0":request.getParameter("compPesquisa");  
    
  //-- Segmentos
  String segmento1  = (request.getParameter("segmento1")==null)?"":request.getParameter("segmento1");
  String segmento2  = (request.getParameter("segmento2")==null)?"":request.getParameter("segmento2");
  String segmento3  = (request.getParameter("segmento3")==null)?"":request.getParameter("segmento3");
  String segmento4  = (request.getParameter("segmento4")==null)?"":request.getParameter("segmento4");
  String segmento5  = (request.getParameter("segmento5")==null)?"":request.getParameter("segmento5");
  String segmento6  = (request.getParameter("segmento6")==null)?"":request.getParameter("segmento6");
  String segmento7  = (request.getParameter("segmento7")==null)?"":request.getParameter("segmento7");
  
  //-- Unidades
  String supSA         = (request.getParameter("supSA")==null)?"0":request.getParameter("supSA");
  String supSO         = (request.getParameter("supSO")==null)?"0":request.getParameter("supSO");
  String supSU         = (request.getParameter("supSU")==null)?"0":request.getParameter("supSU");
  String supSD         = (request.getParameter("supSD")==null)?"0":request.getParameter("supSD");  
  String unidadeCodigo = (request.getParameter("unidadeCodigo")==null)?"0":request.getParameter("unidadeCodigo");
  String unidadeSigla  = (request.getParameter("unidadeSigla")==null)?"0":request.getParameter("unidadeSigla");
  
  //-- Objetos  
  StringBuffer sql = new StringBuffer();
  String[][] pesquisa = null;
  String[][] unidades = null;
  Iterator it = null;
  CentroCusto cc = null;
  String where = ""; 
  String nomeDiv     = "divRequisicoesByUnidade";
  String functionDiv = "buscarRequisicaoByUnidade";
  String div = "", id = "";  

  //-- Parâmetros do sistema
  SistemaParametro idPerfilHOM = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_UO");
  SistemaParametro idPerfilCRI = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_CRI");
  SistemaParametro codUnidadeAPR = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"UNIDADE_APROVADORA");

  //-- Setando unidade do usuário no formato RHEvolution
  String codUnidadeRHEV = requisicaoAprovacaoControl.getUnidadeRHEvolutionByCodUnidade(codUnidadeUsuario);
  
  //-- Cargas de comboBox
  String[][] comboCargo  = requisicaoControl.getComboCargosExistentesRequisicao();
  String[][] comboRecrutamento = requisicaoControl.getComboRecrutamento();
  String[][] comboRPPara = requisicaoControl.getComboRPPara();
  String[][] comboMotivoSolicitacao = requisicaoControl.getComboMotivoSolicitacao();
  String[][] comboTipoContratacao   = requisicaoControl.getComboTipoContratacao();
  String[][] comboStatusRequisicao  = requisicaoControl.getComboStatusRequisicao();
  String[][] comboSupSA  = requisicaoControl.getComboSuperintendenciaUnidades("SA"); //-- Superintendencia Administrativa
  String[][] comboSupSO  = requisicaoControl.getComboSuperintendenciaUnidades("SO"); //-- Superintendencia Operacional
  String[][] comboSupSU  = requisicaoControl.getComboSuperintendenciaUnidades("SU"); //-- Superintendencia Universitária
  String[][] comboSupSD  = requisicaoControl.getComboSuperintendenciaUnidades("SD"); //-- Superintendencia Desenvolvimento  
  String[][] comboUnidadeCodigo = requisicaoControl.getComboUnidade("C"); //-- Busca código das unidades
  String[][] comboUnidadeSigla  = requisicaoControl.getComboUnidade("S"); //-- Busca siglas das unidades
  List comboCC1 = ccControl.getSegmentos(1, usuario);
  List comboCC2 = ccControl.getSegmentos(2, usuario);
  List comboCC3 = ccControl.getSegmentos(3, usuario);
  List comboCC4 = ccControl.getSegmentos(4, usuario);
  List comboCC5 = ccControl.getSegmentos(5, usuario);
  List comboCC6 = ccControl.getSegmentos(6, usuario);
  List comboCC7 = ccControl.getSegmentos(7, usuario);

  boolean isDataInicial = true;
  boolean isExibeSuperintendencias = true;
  
  //------------------------------------------------------------------------------------------------------------------------
  //-- ADICIONANDO AS CONDIÇÕES DE PESQUISA
  //------------------------------------------------------------------------------------------------------------------------
    //-- Caso o usuário não seja da Unidade Aprovadora (GEP) e Administrador do sistema, apresenta apenas as unidades de acesso
    if(codPerfilUsuario == Integer.parseInt(idPerfilHOM.getVlrSistemaParametro()) || (codPerfilUsuario == Integer.parseInt(idPerfilCRI.getVlrSistemaParametro()) && !codUnidadeAPR.getVlrSistemaParametro().equals(codUnidadeRHEV))){
      //-- setando flag de exibição da pesquisa por Superintendencias
      isExibeSuperintendencias = false;
      //-- verificando as unidades de acesso
      String todasUnidades = String.valueOf(codUnidadeUsuario);

      for(int i=0; usuario.getUnidades() != null && i < usuario.getUnidades().length; i++){
        todasUnidades += "," + usuario.getUnidades()[i].getCodUnidade();        
      }                       

      //-- Setando data inicial de pesquisa
      if(datInicio.equals("") && codRequisicao.equals("") && !where.equals("")){
        SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
        Date dataHoje = new Date();
        datInicio = formato.format(dataHoje);
        isDataInicial = false;
        // adicionando condição inicial na pesquisa
        where += " AND DAT_REQUISICAO = TO_DATE('"+datInicio+"','DD/MM/YYYY') ";
      }
      
      todasUnidades = ((todasUnidades.equals("") || todasUnidades.equals(","))?"0":todasUnidades);
      where += " AND DECODE(SUBSTR(COD_UNIDADE,0,1), '0', SUBSTR(COD_UNIDADE,2,2), SUBSTR(COD_UNIDADE,1,3)) IN ("+ todasUnidades +")";
    }  
    
    //-- Pesquisa por requisicao
    if(!codRequisicao.trim().equals("")){
      where += " AND REQUISICAO_SQ = "+codRequisicao;
    }     
    
    //-- Pesquisas por data de inicio
    if(isDataInicial && !datInicio.trim().equals("")){
      where += " AND DAT_REQUISICAO >= TO_DATE('"+datInicio+"','DD/MM/YYYY') ";
    }
    
    //-- Pesquisas por data fim
    if(!datFim.trim().equals("")){
      where += " AND DAT_REQUISICAO <= TO_DATE('"+datFim+"','DD/MM/YYYY') ";
    }  
    
    //-- Pesquisas por segmentos
    if(!segmento3.trim().equals("") && !segmento3.equals("-1")){
      where += " AND COD_SEGMENTO1 = '1' ";
      where += " AND COD_SEGMENTO2 = '"+segmento2+"' ";
      where += " AND COD_SEGMENTO3 = '"+segmento3+"' ";    
    }    
    if(!segmento4.trim().equals("") && !segmento4.equals("-1")){
      where += " AND COD_SEGMENTO4 = '"+segmento4+"' ";
    }    
    if(!segmento5.trim().equals("") && !segmento5.equals("-1")){
      where += " AND COD_SEGMENTO5 = '"+segmento5+"' ";
    }    
    if(!segmento6.trim().equals("") && !segmento6.equals("-1")){
      where += " AND COD_SEGMENTO6 = '"+segmento6+"' ";
    }    
    if(!segmento7.trim().equals("") && !segmento7.equals("-1")){
      where += " AND COD_SEGMENTO7 = '"+segmento7+"' ";
    }  
    
    //-- Pesquisa por cargo
    if(!cargoSq.equals("0")){
      where += " AND COD_CARGO = "+cargoSq;
    }  

    //-- Pesquisa por tipo de recrutamento
    if(!codRecrutamento.equals("0")){
      where += " AND COD_RECRUTAMENTO = "+codRecrutamento;
    }  
    
    //-- Pesquisa por rpPara
    if(!rpPara.equals("0")){
      where += " AND COD_RP_PARA = "+rpPara;
    }  
    
    //-- Pesquisa por motivo solicitação
    if(!codMotivoSolicitacao.equals("0")){
      where += " AND COD_MOTIVO_SOLICITACAO = "+codMotivoSolicitacao;
    }    
    
    //-- Pesquisa por tipo de contratação
    if(!codTipoContratacao.equals("0")){
      where += " AND COD_TP_CONTRATACAO = "+codTipoContratacao;
    }    
    
    //-- Pesquisa por tipo de contratação
    if(!statusRequisicao.equals("0")){
      where += " AND COD_STATUS = " + statusRequisicao;
    }    
    
    //-- Pesquisa pelo código da unidade
    if(!unidadeCodigo.equals("0")){
      where += " AND COD_UNIDADE = '" + unidadeCodigo + "'";
    }
  
    //-- Pesquisa pela sigla da unidade
    if(!unidadeSigla.equals("0")){
      where += " AND SIGLA_UNIDADE = '" + unidadeSigla + "'";
    }  
  
    //-- Pesquisa pelo código da superintendencia SA
    if(!supSA.equals("0")){
      where += " AND COD_UNIDADE = '" + supSA + "'";
    }
  
    //-- Pesquisa pelo código da superintendencia SO
    if(!supSO.equals("0")){
      where += " AND COD_UNIDADE = '" + supSO + "'";
    }  
  
    //-- Pesquisa pelo código da superintendencia SU
    if(!supSU.equals("0")){
      where += " AND COD_UNIDADE = '" + supSU + "'";
    }  
    
    //-- Pesquisa pelo código da superintendencia SD
    if(!supSD.equals("0")){
      where += " AND COD_UNIDADE = '" + supSD + "'";
    }   
    
    //-- Pesquisa pelo ID do funcionario baixado
    if(!idFuncBaixado.equals("")){
      where += " AND CHAPA_FUNC_BAIXADO = " + idFuncBaixado;
    }     
  
  //-- Carregando as unidades de acordo com o filtro selecionado pelo usuário
  if(!where.equals("")){
    sql.append(" SELECT UNIQUE V.COD_UNIDADE ");
    sql.append("       ,V.DSC_UNIDADE ");
    sql.append(" FROM   VW_DADOS_COMPLETOS_REQUISICAO V ");
    sql.append(" WHERE  1 = 1 ");
    unidades = requisicaoControl.getMatriz(sql.toString() + where);
  }
%>

<br>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/ajaxItens.js" charset="utf-8"  type="text/javascript"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js"    type="text/javascript"></script> 
<script language="JavaScript" src="<%=request.getContextPath()%>/js/regrasRequisicao.js" type="text/javascript" charset="utf-8"></script>

<script language="JavaScript">
 var isTreeViewAberta = false;
 
  function submete(){
    if(Verifica_Data('datInicio', 0) && Verifica_Data('datFim', 0)){
      document.frmPesquisa.submit();
    }
  }
  //--
 function acaoTreeView(){
  <%for(int idx=0; unidades!=null && idx<unidades.length; idx++){
      id=unidades[idx][0]; 
      div=nomeDiv+idx; 
      out.println(functionDiv+"('"+div+"','"+unidades[idx][0]+"');");  
    }
  %>
   //-- confirma ação da função
   (isTreeViewAberta)?false:true;   
 }    
  //--
  function requisicaoDados(parametro){
    popUP('<%=request.getContextPath()%>/relatorio/index.jsp?consulta=S&'+parametro,'link','toolbar=no,width=760,height=600,scrollbars=yes');
  }
  //--
  function requisicaoHistorico(parametro){
    popUP('<%=request.getContextPath()%>/relatorio/historico.jsp?'+parametro,'link','toolbar=no,width=760,height=600,scrollbars=yes');
  }    
  //--
  function buscarRequisicaoByUnidade(div, codUnidade){
      var where = '<%=where.replaceAll("'","aspas")%>';
      where = where.replace("%","percent");
      carregaRequisicaoByUnidade(div, codUnidade, where, false);      
  }
  //--
</script>
  
<center>
<form name="frmPesquisa" action="index.jsp" method="POST" >  
  <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">  
    <tr>
      <td>
        <table border="0" width="610" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="3"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
             <STRONG>&nbsp;&nbsp;RELATÓRIO - REQUISIÇÃO PESSOAL</STRONG>
            </td>
          </tr>                                 
          <tr>
            <td colspan="2" height="6" class="tdIntranet2">&nbsp;</td>
          </tr>        
          <tr>
            <td height="25" align="right" class="tdintranet2">
              <strong>Número da RP:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
              <input class="input" size="9" name="requisicaoSq" maxlength="8" value="<%=codRequisicao%>" onkeyup="this.value = this.value.replace(/\D/g,'')" onkeypress="OnEnterPesquisa(event); return Bloqueia_Caracteres(event);" onblur="limpaCampos('RP', false);"/>
            </td>					  					
          </tr>                    
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Cargo:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="cargo_sq" id="cargo_sq" class="select" style="width: 450px;">
                <option value="0">SELECIONE</option>
                <%for(int i=0; i<comboCargo.length; i++){%>
                  <option value="<%=comboCargo[i][0]%>" <%=(comboCargo[i][0].equals(cargoSq))?" SELECTED":""%> ><%=comboCargo[i][1]%></option>
                <%}%>
                </select>
            </td>					  					
          </tr>
          <tr>
            <td height="25" align="right" class="tdintranet2">
              <strong>Tipo de recrutamento:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
              <select name="codRecrutamento" class="select" style="width: 450px;">
                <option value="0">SELECIONE</option>
                <%for(int i=0; i<comboRecrutamento.length; i++){%>
                  <option value="<%=comboRecrutamento[i][0]%>" <%=(comboRecrutamento[i][0].equals(codRecrutamento))?" SELECTED":""%>><%=comboRecrutamento[i][1]%></option>
                <%}%>
              </select>
            </td>					  					
          </tr>              
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>RP para:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="rpPara" id="rpPara" class="select" style="width: 450px;">
                <option value="0">SELECIONE</option>
                <%for(int i=0; i<comboRPPara.length; i++){%>
                  <option value="<%=comboRPPara[i][0]%>" <%=(comboRPPara[i][0].equals(rpPara))?" SELECTED":""%> ><%=comboRPPara[i][1]%></option>
                <%}%>
                </select>
            </td>					  					
          </tr>   
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Motivo da solicitação:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="codMotivoSolicitacao" id="codMotivoSolicitacao" class="select" style="width: 450px;">
                <option value="0">SELECIONE</option>
                <%for(int i=0; i<comboMotivoSolicitacao.length; i++){%>
                  <option value="<%=comboMotivoSolicitacao[i][0]%>" <%=(comboMotivoSolicitacao[i][0].equals(codMotivoSolicitacao))?" SELECTED":""%> ><%=comboMotivoSolicitacao[i][1]%></option>
                <%}%>
                </select>
            </td>					  					
          </tr>                 
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Tipo contratação:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="codTipoContratacao" id="codTipoContratacao" class="select" style="width: 450px;">
                <option value="0">SELECIONE</option>
                <%for(int i=0; i<comboTipoContratacao.length; i++){%>
                  <option value="<%=comboTipoContratacao[i][0]%>" <%=(comboTipoContratacao[i][0].equals(codTipoContratacao))?" SELECTED":""%> ><%=comboTipoContratacao[i][1]%></option>
                <%}%>
                </select>
            </td>					  					
          </tr>      
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Status:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="statusRequisicao" id="statusRequisicao" class="select" style="width: 450px;">
                  <option value="0">SELECIONE</option>
                  <%for(int i=0; i<comboStatusRequisicao.length; i++){%>
                    <option value="<%=comboStatusRequisicao[i][0]%>" <%=(comboStatusRequisicao[i][0].equals(statusRequisicao))?" SELECTED":""%> ><%=comboStatusRequisicao[i][1]%></option>
                  <%}%>
                </select>
            </td>					  					
          </tr>  
          <tr>
            <td height="25" align="right" class="tdintranet2">
              <strong>Data de criação de:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
              <input class="input" onfocus="this.value = '';" onkeypress="OnEnterPesquisa(event); return Ajusta_Data(this,event);" onblur="Verifica_Data('datInicio', 0);" size="12" name="datInicio" id="datInicio" maxlength="10" value="<%=datInicio%>"/>
              &nbsp;<strong>até&nbsp;</strong>
              <input class="input" onfocus="this.value = '';" onkeypress="OnEnterPesquisa(event); return Ajusta_Data(this,event);" onblur="Verifica_Data('datFim', 0);" size="12" name="datFim" id="datFim" maxlength="10" value="<%=datFim%>"/>
              &nbsp;&nbsp;<strong>ID funcionário baixado:&nbsp;</strong>
              <input class="input" size="12" name="idFuncBaixado" onkeypress="OnEnterPesquisa(event); return Bloqueia_Caracteres(event);" maxlength="8" value="<%=idFuncBaixado%>" onblur="limpaCampos('BAIXA', false);"/>
            </td>					  					
          </tr>        
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Tipo da pesquisa:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
              <input type="radio" name="compPesquisa" value="C" onclick="exibeComplementoPesquisa(this.value);" <%=(compPesquisa.equals("C"))?" CHECKED":""%>> Centro de Custo&nbsp;&nbsp;&nbsp;
              <%if(isExibeSuperintendencias){%>
                  <input type="radio" name="compPesquisa" value="S" onclick="exibeComplementoPesquisa(this.value);" <%=(compPesquisa.equals("S"))?" CHECKED":""%>> Superintendências                      
              <%}%>
            </td>					             
          </tr>            
          <tr>
            <td colspan="2" class="tdintranet2" align="center">
              <div id="divCombosSegmentos" style="visibility: hidden; display: none;">
                <table border="0" width="92%" cellpadding="0" cellspacing="0">
                  <tr>
                    <td colspan="2" height="6" class="tdIntranet2">&nbsp;</td>
                  </tr>                     
                  <tr>
                    <td height="25" align="right" class="tdintranet2">
                      <strong>Empresa:&nbsp;</strong>
                    </td>
                    <td height="25"  align="left" class="tdintranet2">
			          <select name="segmento1" id="idsegmento1" class="select" style="width: 450px;">
				          <%
				            it = comboCC1.iterator();
				          	while (it.hasNext()) {
				          		cc = (CentroCusto) it.next();
				          		out.print("<option value=\""+ cc.getCodSegmento() +"\">"+ cc.getDscSegmento() +"</option>");
				          	}	          
				          %>
			          </select>
                    </td>					  					
                  </tr>
                  <tr>
                    <td height="25" align="right" class="tdintranet2">
                      <strong>UO Origem:&nbsp;</strong>
                    </td>
                    <td height="25"  align="left" class="tdintranet2">
			          <select name="segmento2" id="idsegmento2" class="select" style="width: 450px;">
				          <%
				            it = comboCC2.iterator();
				          	while (it.hasNext()) {
				          		cc = (CentroCusto) it.next();
				          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(segmento2) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
				          	}	          
				          %>
			          </select>
                    </td>					  					
                  </tr>
                  <tr>
                    <td height="25" align="right" class="tdintranet2">
                      <strong>UO Destino:&nbsp;</strong>
                    </td>
                    <td height="25"  align="left" class="tdintranet2">
			          <select name="segmento3" id="idsegmento3" class="select" style="width: 450px;">
			          	  <option value="-1">SELECIONE</option>
				          <%
				            it = comboCC3.iterator();
				          	while (it.hasNext()) {
				          		cc = (CentroCusto) it.next();
				          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(segmento3) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
				          	}	          
				          %>
			          </select>
                    </td>					  					
                  </tr>
                  <tr>
                    <td height="25" align="right" class="tdintranet2">
                      <strong>Área / Sub-área:&nbsp;</strong>
                    </td>
                    <td height="25"  align="left" class="tdintranet2">
			          <select name="segmento4" id="idsegmento4" class="select" style="width: 450px;">
			          	  <option value="-1">SELECIONE</option>
				          <%
				            it = comboCC4.iterator();
				          	while (it.hasNext()) {
				          		cc = (CentroCusto) it.next();
				          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(segmento4) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
				          	}	          
				          %>
			          </select>
                    </td>					  					
                  </tr>
                  <tr>
                    <td height="25" align="right" class="tdintranet2">
                      <strong>Serviço / Produto:&nbsp;</strong>
                    </td>
                    <td height="25"  align="left" class="tdintranet2">
			          <select name="segmento5" id="idsegmento5" class="select" style="width: 450px;">
			          	  <option value="-1">SELECIONE</option>
				          <%
				            it = comboCC5.iterator();
				          	while (it.hasNext()) {
				          		cc = (CentroCusto) it.next();
				          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(segmento5) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
				          	}	          
				          %>
			          </select>
                    </td>					  					
                  </tr>
                  <tr>
                    <td height="25" align="right" class="tdintranet2">
                      <strong>Especificação:&nbsp;</strong>
                    </td>
                    <td height="25"  align="left" class="tdintranet2">
			          <select name="segmento6" id="idsegmento6" class="select" style="width: 450px;">
			          	  <option value="-1">SELECIONE</option>
				          <%
				            it = comboCC6.iterator();
				          	while (it.hasNext()) {
				          		cc = (CentroCusto) it.next();
				          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(segmento6) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
				          	}	          
				          %>
			          </select>
                    </td>					  					
                  </tr>
                  <tr>
                    <td height="25" align="right" class="tdintranet2">
                      <strong>Modalidade:&nbsp;</strong>
                    </td>
                    <td height="25"  align="left" class="tdintranet2">
			          <select name="segmento7" id="idsegmento7" class="select" style="width: 450px;">
			          	  <option value="-1">SELECIONE</option>
				          <%
				            it = comboCC7.iterator();
				          	while (it.hasNext()) {
				          		cc = (CentroCusto) it.next();
				          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(segmento7) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
				          	}	          
				          %>
			          </select>
                    </td>					  					
                  </tr>  
                </table>
              </div>
              <div id="divCombosSuperintendencias" style="visibility: hidden; display: none;">
                <table border="0" width="91%" cellpadding="0" cellspacing="0">
                  <tr>
                    <td colspan="2" height="6" class="tdIntranet2">&nbsp;</td>
                  </tr>       
                  <tr>
                    <td height="25"  align="right" class="tdintranet2">
                      <strong title="Superintendencia Administrativa">Sup. Admin. (SA):&nbsp;</strong>
                    </td>
                    <td height="25" align="left" class="tdintranet2">
                        <select name="supSA" id="supSA" class="select" style="width: 450px;" onchange="desabilitaSup(this.value, 'SA');">
                          <option value="0">SELECIONE</option>
                          <%for(int i=0; i<comboSupSA.length; i++){%>
                            <option value="<%=comboSupSA[i][0]%>" <%=(comboSupSA[i][0].equals(supSA))?" SELECTED":""%> ><%=comboSupSA[i][0]+" - "+comboSupSA[i][1]%></option>
                          <%}%>
                        </select>
                    </td>					  					
                  </tr>            
                  <tr>
                    <td height="25"  align="right" class="tdintranet2">
                      <strong title="Superintendencia Operacional">Sup. Admin. (SO):&nbsp;</strong>
                    </td>
                    <td height="25" align="left" class="tdintranet2">
                        <select name="supSO" id="supSO" class="select" style="width: 450px;" onchange="desabilitaSup(this.value, 'SO');">
                          <option value="0">SELECIONE</option>
                          <%for(int i=0; i<comboSupSO.length; i++){%>
                            <option value="<%=comboSupSO[i][0]%>" <%=(comboSupSO[i][0].equals(supSO))?" SELECTED":""%> ><%=comboSupSO[i][0]+" - "+comboSupSO[i][1]%></option>
                          <%}%>
                        </select>
                    </td>					  					
                  </tr>        
                  <tr>
                    <td height="25"  align="right" class="tdintranet2">
                      <strong title="Superintendencia Universitária">Sup. Admin. (SU):&nbsp;</strong>
                    </td>
                    <td height="25" align="left" class="tdintranet2">
                        <select name="supSU" id="supSU" class="select" style="width: 450px;" onchange="desabilitaSup(this.value, 'SU');">
                          <option value="0">SELECIONE</option>
                          <%for(int i=0; i<comboSupSU.length; i++){%>
                            <option value="<%=comboSupSU[i][0]%>" <%=(comboSupSU[i][0].equals(supSU))?" SELECTED":""%> ><%=comboSupSU[i][0]+" - "+comboSupSU[i][1]%></option>
                          <%}%>
                        </select>
                    </td>					  					
                  </tr>          
                  <tr>
                    <td height="25"  align="right" class="tdintranet2">
                      <strong title="Superintendencia de Desenvolvimento">Sup. Admin. (SD):&nbsp;</strong>
                    </td>
                    <td height="25" align="left" class="tdintranet2">
                        <select name="supSD" id="supSD" class="select" style="width: 450px;" onchange="desabilitaSup(this.value, 'SD');">
                          <option value="0">SELECIONE</option>
                          <%for(int i=0; i<comboSupSD.length; i++){%>
                            <option value="<%=comboSupSD[i][0]%>" <%=(comboSupSD[i][0].equals(supSD))?" SELECTED":""%> ><%=comboSupSD[i][0]+" - "+comboSupSD[i][1]%></option>
                          <%}%>
                        </select>
                    </td>					  					
                  </tr> 
                  <tr>
                    <td height="25"  align="right" class="tdintranet2">
                      <strong>UO:&nbsp;</strong>
                    </td>
                    <td height="25" align="left" class="tdintranet2">
                        <select name="unidadeCodigo" id="unidadeCodigo" class="select" style="width: 206px;" onchange="desabilitaSup(this.value, 'UO');">
                          <option value="0">SELECIONE</option>
                          <%for(int i=0; i<comboUnidadeCodigo.length; i++){%>
                            <option value="<%=comboUnidadeCodigo[i][0]%>" <%=(comboUnidadeCodigo[i][0].equals(unidadeCodigo))?" SELECTED":""%> ><%=comboUnidadeCodigo[i][0]%></option>
                          <%}%>
                        </select>
                        &nbsp; ou &nbsp;
                        <select name="unidadeSigla" id="unidadeSigla" class="select" style="width: 206px;" onchange="desabilitaSup(this.value, 'SG');">
                          <option value="0">SELECIONE</option>
                          <%for(int i=0; i<comboUnidadeSigla.length; i++){%>
                            <option value="<%=comboUnidadeSigla[i][0]%>" <%=(comboUnidadeSigla[i][0].equals(unidadeSigla))?" SELECTED":""%> ><%=comboUnidadeSigla[i][0]%></option>
                          <%}%>
                        </select>
                    </td>					  					
                  </tr>                                         
                </table>
              </div>              
            </td>
          </tr>
          <% 
            // Exibe a div do tipo de pesquisa após a submissão da página
              if(!compPesquisa.equals("0")){
                if(compPesquisa.equals("C"))
                  out.println("<script language=\"JavaScript\">document.frmPesquisa.compPesquisa[0].click();</script>");
                else
                  out.println("<script language=\"JavaScript\">document.frmPesquisa.compPesquisa[1].click();</script>");
              }
          %>             
          <tr>
            <td height="25" colspan="2" align="right" class="tdintranet2">
              <input type="button" name="btnSubmete" class="botaoIntranet" value="Pesquisar" onclick="submete();">
              &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            </td>
          </tr>              
          <tr>
            <td colspan="2" class="tdIntranet2" align="right"></td>
          </tr> 
          <tr>
            <td colspan="2" height="6" class="tdIntranet2"></td>
          </tr>           
          <tr>
            <td colspan="2" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
          </tr>           
        </table>
      </td>
    </tr>
  </table>
</form>

<%-- RESULTADO PESQUISA --%>
   <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>    
     <%if(unidades != null && unidades.length == 0){%>
        <td align="center" width="100%">
            <b>Nenhuma RP localizada!</b>
        </td>
     <%}else if(unidades != null && unidades.length > 0){%>      
              <td align="right" width="100%">
                  <a href="##" onClick="javaScript:acaoTreeView();" title="Abrir / Fechar níveis da pesquisa" >
                    <b>Abrir / Fechar</b>
                  </a> 
              </td>
             <%}%>
    </tr>
    </table>
    <br>
  <%if(unidades != null && unidades.length > 0){%>
    <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
          <table border="0" width="610" cellpadding="0" cellspacing="0">
            <tr>
              <td height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
               <STRONG>&nbsp;&nbsp;RESULTADO DA PESQUISA</STRONG>
              </td>
            </tr>           
          </table>
          <table border="0" width="610" cellpadding="0" cellspacing="0">
            <tr>
                <td class="tdNivel3">
                    <table border="0" width="100%" bgcolor="#FFFFFF">
                        <%
                          for(int i=0;i<unidades.length;i++){
                            id=unidades[i][0]; 
                            div=nomeDiv+i;                      
                        %>
                          <tr>
                            <td>
                             <table border="0"  cellpadding="0" width="100%">
                                <tr >
                                  <td width="3%" >
                                      <a href="javascript:<%=functionDiv%>('<%=div%>','<%=unidades[i][0]%>');" >
                                        <img id="i<%=div%>" src="<%= request.getContextPath()%>/imagens/bt_mais.gif" border="0">
                                      </a>
                                  </td>		 
                                  <td  align="left" width="82%"><b>UNIDADE: </b><%=unidades[i][0]+" - "+((unidades[i][1]==null)?"DESCRIÇÃO NÃO INFORMADA":unidades[i][1])%></td> 
                                </tr> 
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <td  class="tdNivel3" >
                              <span id="<%=div%>" ></span>
                            </td>
                          </tr>
                          <tr>
                            <td height="3" class="tdintranet"></td>
                          </tr>                          
                        <%}%>  
                    </table>                
                </td>
            </tr>        
            <tr>
              <td height="3" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
            </tr>                  
          </table>
        </td>
      </tr>
    </table>
  <%}%>

<%
  //-- Abrindo os blocos de pesquisa
  if(unidades != null && unidades.length > 0){
    out.println("<script language=\"javaScript\">");
    out.println("  acaoTreeView(); ");
    out.println("</script>");
  }
%>

</center>
<br>
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>