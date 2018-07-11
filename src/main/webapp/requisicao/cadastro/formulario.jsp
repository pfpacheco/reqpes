<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.text.SimpleDateFormat"  %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page import="br.senac.sp.componente.util.ConverteDate" %>

<jsp:include page="../../template/cabecalho.jsp"/>
<%
  //-- Objetos control
  RequisicaoControl        requisicaoControl        = new RequisicaoControl();
  RequisicaoJornadaControl requisicaoJornadaControl = new RequisicaoJornadaControl();
  RequisicaoPerfilControl  requisicaoPerfilControl  = new RequisicaoPerfilControl();
  SistemaParametroControl  sistemaParametroControl  = new SistemaParametroControl();
  CentroCustoControl 	   ccControl 				= new CentroCustoControl();
  
  //-- Parametros de página
  int codRequisicao = (request.getParameter("codRequisicao")==null)?0:Integer.parseInt(request.getParameter("codRequisicao"));
  int tipoEdicao = (request.getParameter("tipoedicao") == null)?0:Integer.parseInt(request.getParameter("tipoedicao"));
  
  //-- Carregando parâmetros do sistema
  String vlrAprendizCargo = (sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"APRENDIZ_CARGO") != null)?sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"APRENDIZ_CARGO").getVlrSistemaParametro():""; 
  int vlrAprendizPrazo = (sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"APRENDIZ_CONTRATACAO_PRAZO") != null)?Integer.parseInt(sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"APRENDIZ_CONTRATACAO_PRAZO").getVlrSistemaParametro()):0;
  int vlrPrazo         = (sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"CONTRATACAO_PRAZO") != null)?Integer.parseInt(sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"CONTRATACAO_PRAZO").getVlrSistemaParametro()):0;
  
  //-- Objetos  
  SimpleDateFormat formatoData = new SimpleDateFormat("dd/MM/yyyy");
  Usuario usuario   = (Usuario) session.getAttribute("usuario");
  Requisicao        requisicao        = null;
  String[][] requisicaoPesquisa = null;
  RequisicaoJornada requisicaoJornada = null;
  RequisicaoPerfil  requisicaoPerfil  = null;
  Iterator it = null;
  CentroCusto cc = null;
  
  String[][] comboClassificacaoFuncional = null;
  String[][] comboTipoContratacao = null;
  String[][] comboRecrutamento    = null;
  String[][] comboNivelHierarquia = null;
  String[][] comboArea   = null;
  String[][] comboFuncao = null;
  List comboCC1 = null;
  List comboCC2 = null;
  List comboCC3 = null;
  List comboCC4 = null;
  List comboCC5 = null;
  List comboCC6 = null;
  List comboCC7 = null;
  
  boolean isExibe = false;      //-- Indicador de exibição do lembrete de revisão do Horário de Trabalho  
  boolean isHabilitaCH = false; //-- Indicador de habilitaçao do campo de Jornada de Trabalho para Cargo de Prefessores
  String versaoSistema = "1.2"; //-- Indicador da versão do sistema no Browser do Usuário
   
  String acaoForm  = "gravar.jsp";
  String botaoForm = "bt_cadastrar.gif";
  String altBotao  = "Cadastrar";
  String prazoContratacao = "";

  //-- Carregando as informações da requisição
  requisicao = requisicaoControl.getRequisicao(codRequisicao);
  requisicaoPesquisa = requisicaoControl.getPesquisaRequisicao(codRequisicao);
  
  //-- Verificando instância da requisição 
  if(requisicao == null){
    requisicao        = new Requisicao();
    requisicaoJornada = new RequisicaoJornada();
    requisicaoPerfil  = new RequisicaoPerfil();
    requisicao.setIndStatus(1); // REQUISIÇÃO ABERTA
    requisicao.setNivelWorkflow(1);
  }else{
    // Carregando instâncias da requisicao 
    requisicaoJornada = requisicaoJornadaControl.getRequisicaoJornada(codRequisicao);
    requisicaoPerfil  = requisicaoPerfilControl.getRequisicaoPerfil(codRequisicao);    
    
    // Caso não tenha os objetos resgatados, cria nova instância
    requisicaoJornada = (requisicaoJornada == null)? new RequisicaoJornada() : requisicaoJornada;
    requisicaoPerfil  = (requisicaoPerfil  == null)? new RequisicaoPerfil()  : requisicaoPerfil;
    
    // Configurando botões

    acaoForm  = "atualizar.jsp";
    botaoForm = "bt_atualizar.gif";
    altBotao  = "Atualizar";
    
    // Montando prazo de contratação
    if(requisicao.getDatInicioContratacao() != null && requisicao.getDatFimContratacao() != null){
      prazoContratacao = requisicaoControl.getMatriz(" SELECT TO_DATE('"+ formatoData.format(requisicao.getDatFimContratacao()) +"','dd/mm/yyyy') - TO_DATE('"+ formatoData.format(requisicao.getDatInicioContratacao()) +"', 'dd/mm/yyyy') AS PRAZO_CONTRATACAO FROM DUAL ")[0][0];
    }
    
    //-- Configurando regra de exibição dos campos
    String[][] dataUltimoNivel = requisicaoControl.getMatriz(" SELECT TO_CHAR(MAX(T.DT_REQUISICAO_SQL),'DD/MM/YYYY') FROM VW_HISTORICO_REQUISICAO T WHERE T.REQUISICAO_SQ = " + codRequisicao);
    Date dataIntegracao = ConverteDate.stringToDate(((new SistemaParametroControl().getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "DATA_INTEGRACAO")).getVlrSistemaParametro()));
    isExibe = (dataIntegracao.compareTo(ConverteDate.stringToDate(dataUltimoNivel[0][0])) == 1);
    
    //-- Habilitaçao de campo de Jornada de Trabalho do cargo para Professores
    String[] professor = requisicaoControl.getLista(" SELECT CASE WHEN DESCRICAO LIKE '%PROFESSOR%' THEN 'S' ELSE 'N' END IND_PROF FROM CARGO_DESCRICOES WHERE ID = " + requisicao.getCodCargo());
    isHabilitaCH = (professor[0].equals("S"));
  }
   
  //-- Carregando os valores dos combos
  comboClassificacaoFuncional = requisicaoControl.getComboClassificacaoFuncional();
  comboTipoContratacao = requisicaoControl.getComboTipoContratacao(); 
  comboRecrutamento    = requisicaoControl.getComboRecrutamento();
  comboNivelHierarquia = requisicaoPerfilControl.getComboNivelHierarquia();
  comboArea    = requisicaoPerfilControl.getComboArea();
  comboFuncao  = requisicaoPerfilControl.getComboFuncao();
  comboCC1 	   = ccControl.getSegmentos(1, usuario);
  comboCC2 	   = ccControl.getSegmentos(2, usuario);
  comboCC3 	   = ccControl.getSegmentos(3, usuario);
  comboCC4 	   = ccControl.getSegmentos(4, usuario);
  comboCC5 	   = ccControl.getSegmentos(5, usuario);
  comboCC6 	   = ccControl.getSegmentos(6, usuario);
  comboCC7 	   = ccControl.getSegmentos(7, usuario);

  //-- Tratamento do valor no campo de IdFuncionario substituido
  String numChapaSubst = (String.valueOf(requisicao.getIdSubstitutoHist()).equals("0"))?"":String.valueOf(requisicao.getIdSubstitutoHist());
%>

<br>
<script src="../../js/formulario.js" type="text/javascript" charset="UTF-8"></script> 
<script src="../../js/mascara.js"    type="text/javascript" charset="UTF-8"></script>
<script src="../../js/ajaxItens.js"  type="text/javascript" charset="UTF-8"></script>
<script src="../../js/regrasRequisicao.js" type="text/javascript" charset="UTF-8"></script>

<script>
  //------------------------------------------------------------------------------
    // Função que verifica se exibe os campos de funcionário substituído    
    function exibeFuncionarioSubstituido(codigo, tipo){
      if('<%=numChapaSubst%>' == ''){
        document.frmRequisicao.idSubstitutoHist.value = '';
        document.frmRequisicao.nomFuncionarioSubst.value = '';
      }

      if(tipo == 'RP_PARA'){
        //-- CAMPO: RPPARA
        //-- Complementação de Quadro
        if(codigo == '1'){
          exibeOcultaDiv('divExibeSubst1',false);
          exibeOcultaDiv('divExibeSubst2',false);
          exibeOcultaDiv('divNomeSubstituido',false);
          exibeOcultaDiv('divExibeMotivS1',false);
          exibeOcultaDiv('divExibeMotivS2',false);          
          document.frmRequisicao.idSubstitutoHist.value = '';
          document.frmRequisicao.nomFuncionarioSubst.value = ''; 
          document.frmRequisicao.codMotivoSolicitacao.value = '0';  
        }else{
          exibeOcultaDiv('divExibeSubst1',true);
          exibeOcultaDiv('divExibeSubst2',true);
          exibeOcultaDiv('divNomeSubstituido',true);        
          exibeOcultaDiv('divExibeMotivS1',true);
          exibeOcultaDiv('divExibeMotivS2',true);          
        }
      
      }else{
        //-- CAMPO: MOTIVO SUBSTITUIÇÃO / TRANSFERENCIA
        if(codigo == '1'){
          exibeOcultaDiv('divExibeSubst1',false);
          exibeOcultaDiv('divExibeSubst2',false);
          exibeOcultaDiv('divNomeSubstituido',false);
          document.frmRequisicao.idSubstitutoHist.value = '';
          document.frmRequisicao.nomFuncionarioSubst.value = ''; 
        }else{
          exibeOcultaDiv('divExibeSubst1',true);
          exibeOcultaDiv('divExibeSubst2',true);
          exibeOcultaDiv('divNomeSubstituido',true);
        }      
      }
    } 
    
  //------------------------------------------------------------------------------
    // Função que verifica se exibe o campo de outro local de trabalho
    function exibeOutroLocalTrabalho(indLocalTrabalho){
      if(indLocalTrabalho == 2 || indLocalTrabalho == 0){
        // Na gerencia / UO Solicitanate
        exibeOcultaDiv('divExibeOutroLocal1',true);
        exibeOcultaDiv('divExibeOutroLocal2',true);
        document.frmRequisicao.outroLocal.value = '<%=requisicao.getOutroLocal()%>';
      }else{    
        // Outro local
        exibeOcultaDiv('divExibeOutroLocal1',false);
        exibeOcultaDiv('divExibeOutroLocal2',false);
        document.frmRequisicao.outroLocal.value = '';
      }
    }  

  //------------------------------------------------------------------------------
    // Oculta e exibe o campo de número de funcionários 
    function exibeNumerosFuncionarios(indExibe){
      if(indExibe == 'S'){
        exibeOcultaDiv('divExibeNumFuncionarios',true);
        document.frmRequisicao.numFuncionariosSupervisao.value = '<%=requisicao.getNumFuncionariosSupervisao()%>';
      }else{
        exibeOcultaDiv('divExibeNumFuncionarios',false);
        document.frmRequisicao.numFuncionariosSupervisao.value = '0';
      }
    }

  //------------------------------------------------------------------------------
    // Realiza carga dos combos que podem ser alterados de acordo com o Recrutamento
    function carregaCombos(tipoRecrutamento){
      carregaComboRPPara('divRPPara',tipoRecrutamento, '<%=requisicao.getCodRPPara()%>');      
      if('<%=requisicao.getCodRequisicao()%>' != '0'){
        carregaComboMotivoSolicitacao('divExibeMotivS2', '<%=requisicao.getCodRecrutamento()%>', '<%=requisicao.getCodMotivoSolicitacao()%>', '<%=requisicao.getCodRPPara()%>');
      }      
    }
    
  //------------------------------------------------------------------------------    
      
</script>

<center>
<form name="frmRequisicao" action="<%=acaoForm%>" method="POST">
  <input type="HIDDEN" name="codRequisicao"     value="<%=requisicao.getCodRequisicao()%>">
  <input type="HIDDEN" name="indStatus"         value="<%=requisicao.getIndStatus()%>">
  <input type="HIDDEN" name="nivelWorkflow"     value="<%=requisicao.getNivelWorkflow()%>">
  <input type="HIDDEN" name="idCodeCombination" value="<%=requisicao.getIdCodeCombination()%>" id="idCodeCombination">  
  <input type="HIDDEN" name="versaoSistema"     value="<%=versaoSistema%>">    
  <input type="HIDDEN" name="tipoedicao"        value="<%=tipoEdicao%>">    
  <input type="HIDDEN" name="indCargoAdministrativo" id="indCargoAdministrativo" value="N">
 
  <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td>
        <%-- DADOS DA ÚLTIMA REVISÃO --%>
        <%if(codRequisicao > 0){%>
            <jsp:include page="revisao/index.jsp">
              <jsp:param name="codRequisicao" value="<%=codRequisicao%>"/>
            </jsp:include>           
        <%}%>      
        
        <% if (tipoEdicao==2 || tipoEdicao == 1) { %>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="3" height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
                 <STRONG>DADOS DA REQUISIÇÃO</STRONG>
                </td>
              </tr>           
              <tr>
                <td height="23" align="left" class="tdIntranet2" width="33%">
                 <input type="hidden" id="codRequisicao" value="<%=requisicaoPesquisa[0][0]%>">
                 &nbsp;<STRONG>Número RP</STRONG><br>&nbsp;<%=requisicaoPesquisa[0][0]%>
                </td>
                <td height="23" align="left" class="tdIntranet2" width="40%">
                 &nbsp;<STRONG>Tipo <%=(isExibe)?"":"de recrutamento"%></STRONG><br>&nbsp;<%=(isExibe)? (requisicaoPesquisa[0][79]==null)?"":requisicaoPesquisa[0][79] : (requisicaoPesquisa[0][53]==null)?"":requisicaoPesquisa[0][53]%>
                </td>                
                <td height="23" align="left" class="tdIntranet2" width="27%">
                 &nbsp;<STRONG>Data de criação</STRONG><br>&nbsp;<%=requisicaoPesquisa[0][31]%>
                </td>                                
              </tr>                  
              <tr>
                <td height="3" colspan="3" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
              </tr>              
            </table>
            <br>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="4" height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
                 <STRONG>SOLICITANTE</STRONG>
                </td>
              </tr>  
              <tr>
                <td height="26" align="left" class="tdIntranet2" width="9%">
                 &nbsp;<STRONG>Unidade</STRONG><br>&nbsp;<%=(requisicaoPesquisa[0][56]==null)?"":requisicaoPesquisa[0][56]%>
                </td>
                <td height="26" align="left" class="tdIntranet2" width="31%">
                  <%if(requisicaoPesquisa[0][45]==null){%>
                      &nbsp;<STRONG>UO/MA/SMA</STRONG><br>&nbsp;<%=requisicaoPesquisa[0][1].substring(0,requisicaoPesquisa[0][1].length()-1)%>&nbsp;|&nbsp;<%=(requisicaoPesquisa[0][6]==null)?"":requisicaoPesquisa[0][6]%>&nbsp;|&nbsp;<%=(requisicaoPesquisa[0][7]==null)?"":requisicaoPesquisa[0][7]%>
                  <%}else{%>
                      &nbsp;<STRONG>Centro de custo</STRONG><br>&nbsp;<%=requisicaoPesquisa[0][46]+"."+requisicaoPesquisa[0][47]+"."+requisicaoPesquisa[0][48]+"."+requisicaoPesquisa[0][49]+"."+requisicaoPesquisa[0][50]+"."+requisicaoPesquisa[0][51]+"."+requisicaoPesquisa[0][52]%>
                  <%}%>
                </td>                
                <td height="26" align="left" class="tdIntranet2" width="45%">
                 &nbsp;<STRONG>Nome superior imediato</STRONG><br>&nbsp;<%=(requisicaoPesquisa[0][11]==null)?"":requisicaoPesquisa[0][11]%>
                </td>
                <td height="26" align="left" class="tdIntranet2" width="15%">
                 &nbsp;<STRONG>Telefone</STRONG><br>&nbsp;<%=(requisicaoPesquisa[0][12]==null)?"":requisicaoPesquisa[0][12]%>
                </td>                
              </tr>    
              <tr>
                <td height="3" colspan="4" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
              </tr>                
            </table>
        <%} else {%>
            <%-- DADOS DO SOLICITANTE (CODE COMBINATION) --%>
            <table border="0" width="100%" cellpadding="0" cellspacing="0">
              <tr>
                <td colspan="3" height="18" class="tdCabecalho" background="../../imagens/tit_item.gif">
                 <STRONG>&nbsp;&nbsp;DADOS DO SOLICITANTE</STRONG>
                </td>
              </tr>           
              <tr>
                <td colspan="2" height="10" class="tdIntranet2"></td>
              </tr>                      
              <tr>
                <td height="25" width="20%" align="right" class="tdintranet2">
                  <strong>Empresa:&nbsp;</strong>
                </td>
                <td height="25" width="80%" align="left" class="tdintranet2">
    	          <select name="segmento1" id="idsegmento1" onchange="verificaSegmentos();" class="select" style="width: 450px;">
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
                <td height="25" width="20%" align="right" class="tdintranet2">
                  <strong>Uniorg Emitente:&nbsp;</strong>
                </td>
                <td height="25" width="80%" align="left" class="tdintranet2">
    	          <select name="segmento2" id="idsegmento2" onchange="verificaSegmentos();" class="select" style="width: 450px;">
    		          <%
    		            it = comboCC2.iterator();
    		          	while (it.hasNext()) {
    		          		cc = (CentroCusto) it.next();
    		          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(requisicao.getSegmento2()) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
    		          	}	          
    		          %>
    	          </select>
                </td>					  					
              </tr>           
              <tr>
                <td height="25" width="20%" align="right" class="tdintranet2">
                  <strong>Uniorg Destino:&nbsp;</strong>
                </td>
                <td height="25" width="80%" align="left" class="tdintranet2">
    	          <select name="segmento3" id="idsegmento3" onchange="getDadosUnidade(this.value, '0'); verificaSegmentos(); limpaCargoConfig();" class="select" style="width: 450px;">
    	          	  <option value="-1">SELECIONE</option>
    		          <%
    		            it = comboCC3.iterator();
    		          	while (it.hasNext()) {
    		          		cc = (CentroCusto) it.next();
    		          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(requisicao.getSegmento3()) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
    		          	}	          
    		          %>
    	          </select>
                </td>					  					
              </tr>          
              <tr>
                <td height="25" width="20%" align="right" class="tdintranet2">
                  <strong>Área / Sub-área:&nbsp;</strong>
                </td>
                <td height="25" width="80%" align="left" class="tdintranet2">
    	          <select name="segmento4" id="idsegmento4" onchange="verificaSegmentos();" class="select" style="width: 450px;">
    	          	  <option value="-1">SELECIONE</option>
    		          <%
    		            it = comboCC4.iterator();
    		          	while (it.hasNext()) {
    		          		cc = (CentroCusto) it.next();
    		          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(requisicao.getSegmento4()) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
    		          	}	          
    		          %>
    	          </select>
                </td>
              </tr>
              <tr>
                <td height="25" width="20%" align="right" class="tdintranet2">
                  <strong>Serviço / Produto:&nbsp;</strong>
                </td>
                <td height="25" width="80%" align="left" class="tdintranet2">
    	          <select name="segmento5" id="idsegmento5" onchange="verificaSegmentos();" class="select" style="width: 450px;">
    	          	  <option value="-1">SELECIONE</option>
    		          <%
    		            it = comboCC5.iterator();
    		          	while (it.hasNext()) {
    		          		cc = (CentroCusto) it.next();
    		          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(requisicao.getSegmento5()) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
    		          	}	          
    		          %>
    	          </select>
                </td>					  					
              </tr>          
              <tr>
                <td height="25" width="20%" align="right" class="tdintranet2">
                  <strong>Especificação:&nbsp;</strong>
                </td>
                <td height="25" width="80%" align="left" class="tdintranet2">
    	          <select name="segmento6" id="idsegmento6" onchange="verificaSegmentos();" class="select" style="width: 450px;">
    	          	  <option value="-1">SELECIONE</option>
    		          <%
    		            it = comboCC6.iterator();
    		          	while (it.hasNext()) {
    		          		cc = (CentroCusto) it.next();
    		          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(requisicao.getSegmento6()) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
    		          	}	          
    		          %>
    	          </select>
                </td>					  					
              </tr>          
              <tr>
                <td height="25" width="20%" align="right" class="tdintranet2">
                  <strong>Modalidade:&nbsp;</strong>
                </td>
                <td height="25" width="80%" align="left" class="tdintranet2">
    	          <select name="segmento7" id="idsegmento7" onchange="verificaSegmentos();" class="select" style="width: 450px;">
    	          	  <option value="-1">SELECIONE</option>
    		          <%
    		            it = comboCC7.iterator();
    		          	while (it.hasNext()) {
    		          		cc = (CentroCusto) it.next();
    		          		out.print("<option value=\""+ cc.getCodSegmento() +"\""+ (cc.getCodSegmento().equals(requisicao.getSegmento7()) ? " SELECTED": "") +">"+ cc.getDscSegmento() +"</option>");
    		          	}	          
    		          %>
    	          </select>
                </td>					  					
              </tr>          
              <tr>
                <td colspan="3" height="10" class="tdIntranet2"></td>
              </tr>                      
              <tr>
                <td  colspan="2" height="3" class="tdCabecalho" background="../../imagens/fio_azul_end.gif"></td>
              </tr>            
            </table> 
        <%}%>
        <br>
        
        <%-- DADOS RESTANTES DA RP --%>
        <div id="divDados" style="display:none;">
            <%-- DADOS DA UNIDADE --%>
	        <table border="0" width="100%" cellpadding="0" cellspacing="0">
            <%if(tipoEdicao != 2 && tipoEdicao != 1) {%>
	          <tr>
	            <td colspan="3" height="18" class="tdCabecalho" background="../../imagens/tit_item.gif">
	             <STRONG>&nbsp;&nbsp;DADOS DA UNIDADE</STRONG>            
	            </td>
	          </tr>       
	          <tr>
	            <td colspan="3" height="10" class="tdIntranet2"></td>
	          </tr>                      
	          <tr>
	            <td height="25" width="20%" align="right" class="tdintranet2">
	              <STRONG>Unidade:&nbsp;</STRONG>
	            </td>
	            <td class="tdintranet2" >
	              <div id="divNomUnidade">
	                <input class="input" size="87" name="nomUnidade" id="idnomUnidade" value="" readonly/>
	              </div>
	            </td>
	          </tr> 
	          <tr>
	            <td height="25" width="20%" align="right" class="tdintranet2">
	              <STRONG>Responsável:&nbsp;</STRONG>
	            </td>
	            <td class="tdintranet2" >
	              <div id="divResponsavelUnidade">
	                <input class="input" size="87" name="nomSuperior" id="idnomSuperior" value="<%=requisicao.getNomSuperior()%>" maxlength="60" readonly/>
	              </div>
	            </td>
	          </tr>     
	          <tr>
	            <td height="25" width="20%" align="right" class="tdintranet2">
	              <STRONG>Telefone:&nbsp;</STRONG>
	            </td>
	            <td class="tdintranet2" >
	              <div id="divTelUnidade">              
	                <input class="input" size="87" name="telUnidade" id="idtelUnidade" value="<%=requisicao.getTelUnidade()%>" maxlength="15" readonly/>
	              </div>
	            </td>
	          </tr> 
            <%}%>
	          <tr>
	            <td class="tdintranet2" colspan="2">
	              <div id="divDadosAdicionaisUnidade">
	                <input type="HIDDEN" name="codUnidade"   id="idcodUnidade" value="<%=requisicao.getCodUnidade()%>" maxlength="4"/>
	                <input type="HIDDEN" name="codUODestino" id="idcodUODestino"/>
	                <input type="HIDDEN" name="chapaGerente" id="idchapaGerente"/>
	              </div>            
	            </td>
	          </tr>
            <%if(tipoEdicao != 2) {%>
	          <tr>
	            <td colspan="3" height="10" class="tdIntranet2"></td>
	          </tr>                      
	          <tr>
	            <td colspan="2" height="3" class="tdCabecalho" background="../../imagens/fio_azul_end.gif"></td>
	          </tr>                      
            <%}%>
	        </table>  
            <%if(tipoEdicao != 2) {%>      
	           <br>
	        <%}%>
	        <%-- DADOS DA REQUISIÇÃO --%>
	        <table border="0" width="100%" cellpadding="0" cellspacing="0">
	          <tr>
	            <td colspan="4"  height="18" class="tdCabecalho" background="../../imagens/tit_item.gif">
	             <STRONG>&nbsp;&nbsp;DADOS DA REQUISIÇÃO</STRONG>
	            </td>
	          </tr>           
	          <tr>
	            <td colspan="4" height="10" class="tdIntranet2"></td>
	          </tr>                      
	          <tr>
	            <td height="25" width="37%"  align="right" class="tdintranet2">
	              <strong>Tipo de recrutamento:&nbsp;</strong>
	            </td>
	            <td height="25" align="left" class="tdintranet2" colspan="3">
	              <select name="codRecrutamento" id="codRecrutamento" onchange="configuraRP(this.value);" class="select" style="width: 386px;">
	                <option value="0">SELECIONE</option>
	                <%for(int i=0; i<comboRecrutamento.length; i++){%>
	                  <option value="<%=comboRecrutamento[i][0]%>" <%=(comboRecrutamento[i][0].equals(String.valueOf(requisicao.getCodRecrutamento())))?" SELECTED":""%>><%=comboRecrutamento[i][1]%></option>
	                <%}%>
	              </select>
	            </td>
	          </tr>
	          
	          <%-- 26/09/2011 Solicitado pelo NEC
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <strong>Justificativa do tipo&nbsp;<br>de recrutamento:&nbsp;</strong>
	            </td>
	            <td class="tdintranet2" colspan="3">
	              (Limite 4000 caracteres)&nbsp;
	              <input type="text" name="qtdRecrutamento" class="label" readonly="readonly" value="<%=(((codRequisicao == 0)?0:4000) - requisicao.getDscRecrutamento().length())%>" size="4" align="middle">              
	            </td>
	          </tr>
	          <tr>
	            <td class="tdintranet2" align="right" valign="top">
	              <a href="javascript:void(0);" class="dcontexto">
	                <img src="../../imagens/help.gif" border="0" align="middle">&nbsp;
	                <span>A justificativa do tipo de recrutamento é fundamental principalmente nos casos de recrutamento interno, devendo ser complementada pelo formulário de solicitação para recrutamento interno que precisa ser encaminhado à GEP e validado pelo Direg.</span>
	              </a>              
	            </td>
	            <td class="tdintranet2" colspan="3">
	              <textarea cols="73" rows="4" name="dscRecrutamento" title="A justificativa do tipo de recrutamento é fundamental principalmente nos casos de recrutamento interno, devendo ser complementada pelo formulário de solicitação para recrutamento interno que precisa ser encaminhado à GEP e validado pelo Direg." style="text-transform: uppercase;"
	                        onKeyDown="limitarCaracteres(this,document.frmRequisicao.qtdRecrutamento,4000);"
	                        onKeyUP  ="limitarCaracteres(this,document.frmRequisicao.qtdRecrutamento,4000);" ><%=requisicao.getDscRecrutamento()%></textarea>
	            </td>
	          </tr>
	          --%>
	          
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <strong>Tipo de enquadramento:&nbsp;</strong>
	            </td>
	            <td height="25" align="left" class="tdintranet2" colspan="3">              
	              <input type="radio" name="indCaraterExcecao" value="N" onclick="verificaCargoUnidade(document.getElementById('idcodUnidade').value, document.getElementById('codCargo').value);" <%=(requisicao.getIndCaraterExcecao().equals("N"))?" CHECKED":""%>>De acordo com a Instrução 04/2011
	            </td>
	          </tr>
	          <tr>
	            <td height="25" align="right" class="tdintranet2"></td>
	            <td height="25" align="left" class="tdintranet2" colspan="3">              
	              <input type="radio" name="indCaraterExcecao" value="S" onclick="verificaCargoUnidade(document.getElementById('idcodUnidade').value, document.getElementById('codCargo').value);" <%=(requisicao.getIndCaraterExcecao().equals("S"))?" CHECKED":""%>>Em caráter de exceção
	            </td>	
	          </tr>           
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <strong>Título do cargo:&nbsp;</strong>
	            </td>
	            <td height="25" align="left" class="tdintranet2" colspan="3">
	              <div id="divComboCargo">
	                <select name="codCargo" id="codCargo" onchange="getJornadaTrabalho(this.value);" class="select" style="width: 386px;">
	                  <option value="0">SELECIONE</option>                
	                </select>
	              </div>
	            </td>
	          </tr>
	          <tr>
	            <td class="tdintranet2"></td>
	            <td class="tdintranet2" colspan="3">
	              <div id="divAreaAdministrativa" style="visibility:hidden; display:none;">
	                <br>
	                <table border="1" cellpadding="0" cellspacing="0" width="94%">
	                  <tr>
	                    <td class="tdintranet" align="center" height="45">
	                      <img src="../../imagens/question.gif" border="0" align="middle">&nbsp;&nbsp;
	                      <strong>Responsável pela Área Administrativa?</strong>
	                      <input type="radio" name="indRespAdm" onclick="configAreaAdministrativa(this.value);" value="S">Sim&nbsp;&nbsp;
	                      <input type="radio" name="indRespAdm" onclick="configAreaAdministrativa(this.value);" value="N">Não
	                    </td>
	                  </tr>
	                </table>
	                <br>
	              </div>
	            </td>
	          </tr>       
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <STRONG>Cota:&nbsp;</STRONG>
	            </td>
	            <td class="tdintranet2" width="19%">
	              <input class="input" size="3" name="cotaCargo" id="cotaCargo" onkeypress="return Bloqueia_Caracteres(event);" onchange="getSalarioPorCota(this.value);" value="<%=(String.valueOf(requisicao.getCodRequisicao()).equals("0"))?"":String.valueOf(requisicao.getCotaCargo())%>" maxlength="1" <% if (tipoEdicao!=2) {%> readonly <% } %>/>
	              &nbsp;&nbsp;&nbsp;<strong>Salário:&nbsp;</strong>
	            </td>
	            <td class="tdintranet2" width="62%">
	              <div id="divSalario">
	              <input class="input" size="15" name="salario" id="salario" value="<%=requisicao.getSalario()%>" readonly />
	              &nbsp;&nbsp;<strong>Carga horária semanal:</strong>
	              </div>
	            </td>
	            <td class="tdintranet2">              
	              <div id="divHorasJornadaTrabalho">                
	                &nbsp;<input class="input" size="4" maxlength="7" id="jornadaTrabalho" name="jornadaTrabalho" value="<%=requisicao.getJornadaTrabalho()%>" onkeypress="return maskJornadaTrabalho(event);" readonly />
	                <input type="HIDDEN" name="indTipoHorario" id="indTipoHorario" value="<%=requisicaoJornada.getIndTipoHorario()%>">
	                <input type="HIDDEN" name="indCargoRegime" id="indCargoRegime" value="<%=requisicao.getIndCargoRegime()%>">
	              </div>              
	            </td>
	          </tr>                     
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <STRONG>Classificação funcional:&nbsp;</STRONG>
	            </td>
	            <td class="tdintranet2" colspan="3">
	              <select name="codClassificacaoFuncional" id="codClassificacaoFuncional" onchange="getDescricaoClassificacaoFuncional(this.value, 'A');" class="select" style="width: 386px;">              
	                <option value="0">SELECIONE</option>
	                <%for(int i=0; i< comboClassificacaoFuncional.length; i++){%>
	                  <option value="<%=comboClassificacaoFuncional[i][0]%>" <%=(comboClassificacaoFuncional[i][0].equals(String.valueOf(requisicao.getCodClassificacaoFuncional())))?" SELECTED":""%> ><%=comboClassificacaoFuncional[i][1]%></option>
	                <%}%>
	              </select>
	            </td>
	          </tr>                        
	          <tr>
	            <td height="25" align="right" class="tdintranet2">&nbsp;</td>
	            <td class="tdintranet2" colspan="3">
	              <div id="divDescricaoClassificacaoFuncional">
	                <textarea readonly cols="73" rows="4" name="dscClassificacaoFuncional"></textarea>
	              </div>
	            </td>
	          </tr>                                  
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <strong>RP para:&nbsp;</strong>
	            </td>
	            <td class="tdintranet2" colspan="3">
	              <div id="divRPPara">
	                <select name="codRPPara" class="select" style="width: 386px;" onClick="alert('Selecione o tipo de recrutamento!'); document.frm" onchange="exibeFuncionarioSubstituido(this.value, true); carregaComboMotivoSolicitacao('divExibeMotivS2', document.frmRequisicao.codRecrutamento.value, '0', this.value);">
	                  <option value="0">SELECIONE</option>
	                </select>
	              </div>
	            </td>
	          </tr>   
	          <tr>
	            <td align="right" class="tdintranet2">
	              <div id="divExibeMotivS1">
	                <strong>Motivo da solicitação:&nbsp;</strong>
	              </div>
	            </td>
	            <td class="tdintranet2" colspan="3">
	              <div id="divExibeMotivS2">
	                <select name="codMotivoSolicitacao" class="select" onclick="alert('Selecione o campo RP Para!');" style="width: 386px;">
	                  <option value="0">SELECIONE</option>
	                </select>              
	              </div>
	            </td>
	          </tr>
	          <tr>
	            <td height="3" colspan="4" class="tdintranet2"/>
	          </tr>
	          <tr>
	            <td align="right" class="tdintranet2">
	              <div id="divExibeSubst1">
	                <strong title="Número da chapa do funcionário substituído">Chapa do funcionário:&nbsp;</strong>
	              </div>
	            </td>
	            <td class="tdintranet2" width="20%">
	              <div id="divExibeSubst2">
	                <input class="input" maxlength="6" size="7" onkeypress="return Bloqueia_Caracteres(event);" onchange="getNomeFuncionario(this.value); verificaIDSubstituido(this.value);" name="idSubstitutoHist" value="<%=numChapaSubst%>"/>&nbsp;&nbsp;<strong>Nome:&nbsp;</strong>
	              </div>
	            </td>
	            <td class="tdintranet2" align="left" colspan="2">
	              <div id="divNomeSubstituido">
	                <input class="input" size="53" name="nomFuncionarioSubst" value="" readonly/>
	              </div>
	            </td>
	          </tr>            
	          <tr>
	            <td height="3" colspan="4" class="tdintranet2"/>
	          </tr>
	          <tr>
	            <td align="right" class="tdintranet2">
	               <div id="divDatTransferencia1">
	                 <strong>Previsão de transferência:&nbsp;</strong>
	              </div>
	            </td>
	            <td class="tdintranet2" colspan="3">
	              <div id="divDatTransferencia2">
	                 <input class="input" size="12" maxlength="10" onfocus="this.value = '';" onkeypress="return Ajusta_Data(this,event);" onblur="Verifica_Data('datTransferencia', 1);" name="datTransferencia" id="datTransferencia" value="<%=(requisicao.getDatTransferencia()==null)?"":formatoData.format(requisicao.getDatTransferencia())%>" />&nbsp;&nbsp;(dd/mm/aaaa)
	              </div>
	            </td>
	          </tr>            
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <strong>Justificativa:&nbsp;</strong>
	            </td>
	            <td class="tdintranet2" colspan="3">
	              (Limite 2000 caracteres)&nbsp;
	              <input type="text" name="qtdMotivoSolicitacao" class="label" readonly="readonly" value="<%=(((codRequisicao == 0)?0:2000) - requisicao.getDscMotivoSolicitacao().length())%>" size="4" align="middle">              
	            </td>
	          </tr>
	          <tr>
	            <td class="tdintranet2">
	              &nbsp;
	            </td>
	            <td class="tdintranet2" colspan="3">
	              <textarea cols="73" rows="4" name="dscMotivoSolicitacao"
	                        onKeyDown="limitarCaracteres(this,document.frmRequisicao.qtdMotivoSolicitacao,2000);"
	                        onKeyUP  ="limitarCaracteres(this,document.frmRequisicao.qtdMotivoSolicitacao,2000);" ><%=requisicao.getDscMotivoSolicitacao()%></textarea>
	            </td>
	          </tr>          
	          </table>
	          <table border="0" width="100%" cellpadding="0" cellspacing="0">
	          <tr>
	            <td height="25" align="right" class="tdintranet2" width="32%">
	              <strong>Local de trabalho:&nbsp;</strong>
	            </td>
	            <td class="tdintranet2" colspan="3" width="68%">
	              <select name="indLocalTrabalho" class="select" style="width: 386px;" onchange="exibeOutroLocalTrabalho(this.value);">              
	                <option value="0">SELECIONE</option>
	                <option value="1" <%=(requisicao.getIndLocalTrabalho().equals("1"))?" SELECTED":""%>>NA GERÊNCIA/UO SOLICITANTE</option>
	                <option value="2" <%=(requisicao.getIndLocalTrabalho().equals("2"))?" SELECTED":""%>>OUTROS</option>
	              </select>
	            </td>
	          </tr> 
	          <tr>
	            <td align="right" class="tdintranet2">
	              <div id="divExibeOutroLocal1">
	                <strong>Sigla(s) da(s) unidade(s) ou&nbsp;&nbsp;<br>endereço do outro local:&nbsp;</strong>
	              </div>
	            </td>
	            <td class="tdintranet2" colspan="3">
	              <div id="divExibeOutroLocal2">
	                <input class="input" size="74" style="height: 26" name="outroLocal" value="<%=requisicao.getOutroLocal()%>" maxlength="2000"/>
	              </div>
	            </td>
	          </tr>
	          <tr>
	            <td height="3" colspan="4" class="tdintranet2"/>
	          </tr>             
	          <tr>
	            <td align="right" class="tdintranet2">
	              <div id="divTipoContratacao1">
	                <strong>Tipo de contratação:&nbsp;</strong>
	              </div>
	            </td>
	            <td class="tdintranet2" colspan="3">
	              <div id="divTipoContratacao2">
	                <select name="indTipoContratacao" id="indTipoContratacao" class="select" style="width: 386px;" onchange="exibePeriodoTipoContratacao(this.value);">
	                  <option value="0">SELECIONE</option>
	                  <%for(int i=0; i< comboTipoContratacao.length; i++){%>
	                    <option value="<%=comboTipoContratacao[i][0]%>" <%=(comboTipoContratacao[i][0].equals(requisicao.getIndTipoContratacao()))?" SELECTED":""%> ><%=comboTipoContratacao[i][1]%></option>
	                  <%}%>                    
	                </select>
	              </div>
	            </td>
	          </tr> 
	          <tr>
	            <td height="3" colspan="4" class="tdintranet2"/>
	          </tr>          
	          <tr>
	            <td align="right" class="tdintranet2">
	              <div id="divExibePrazoContratacao">
	                <strong>Prazo de contratação:&nbsp;</strong>
	              </div>
	            </td>
	            <td class="tdintranet2" colspan="3">
	              <div id="divPrazoContratacao">
	              	<input type="hidden" name="aprendizCargo" id="aprendizCargo" value="<%=vlrAprendizCargo%>" />
	              	<input type="hidden" name="vlrAprendizPrazo" id="vlrAprendizPrazo" value="<%=vlrAprendizPrazo%>" />
	              	<input type="hidden" name="vlrPrazo" id="vlrPrazo" value="<%=vlrPrazo%>" />
	                <input class="input" size="4" id="prazoContratacao" maxlength="4" onkeyup="verificaPrazoContratacao(this.value,<%=vlrAprendizPrazo%>,<%=vlrPrazo%>);" onblur="limpaDatas();"  onkeypress="return Bloqueia_Caracteres(event);" name="prazoContratacao"  value="<%=prazoContratacao%>" /><label for="prazoContratacao"> meses</label>
	              </div>
	            </td>
	          </tr> 
	          <tr>
	            <td height="3" colspan="4" class="tdintranet2"/>
	          </tr>
	          <tr>
	            <td class="tdintranet2" align="right">
	              <div id="divDataInicioContratacao1">
	                <strong>Previsão de início&nbsp;&nbsp;<br>da contratação:&nbsp;</strong>
	              </div>
	            </td>
	            <td class="tdintranet2" width="23%">            
	              <div id="divDataInicioContratacao2">
	                <input class="input" size="7" maxlength="7" onfocus="this.value='';" onkeypress="return Ajusta_Data_Mes(this,event);" onblur="carregaDataFim('01/'+this.value);" name="datInicioContratacao" id="datInicioContratacao" value="<%=(requisicao.getDatInicioContratacao()==null)?"":formatoData.format(requisicao.getDatInicioContratacao()).substring(3,10)%>" />&nbsp;(mm/aaaa)
	              </div>
	            </td>
	            <td class="tdintranet2">
	              <div id="divDataFimContratacao">
	                <strong title="Fim contratação">&nbsp;&nbsp;&nbsp;Fim:</strong>
	                &nbsp;<input class="input" size="7" maxlength="7" readonly name="datFimContratacao" value="<%=(requisicao.getDatFimContratacao()==null)?"":formatoData.format(requisicao.getDatFimContratacao()).substring(3,10)%>" />
	              </div>                
	            </td>
	          </tr>         
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <strong>Viagens:&nbsp;</strong>
	            </td>
	            <td class="tdintranet2" colspan="3">
	              <select name="indViagem" class="select" style="width: 120px;">              
	                <option value="0">SELECIONE</option>
	                <option value="1" <%=(requisicao.getIndViagem().equals("1"))?" SELECTED":""%>>FREQUENTES</option>
	                <option value="2" <%=(requisicao.getIndViagem().equals("2"))?" SELECTED":""%>>RARAS</option>
	              </select>
	            </td>
	          </tr>            
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <strong>Supervisão de funcionários:&nbsp;</strong>
	            </td>
	            <td class="tdintranet2" colspan="1">
	              <input type="radio" name="indSupervisao" onclick="exibeNumerosFuncionarios('N');" value="N" <%=(requisicao.getIndSupervisao().equals("N"))?" CHECKED":""%>>Não&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        
	              <input type="radio" name="indSupervisao" onclick="exibeNumerosFuncionarios('S');" value="S" <%=(requisicao.getIndSupervisao().equals("S"))?" CHECKED":""%>>Sim&nbsp;&nbsp;&nbsp;
	            </td>
	            <td class="tdintranet2" colspan="2">
	              <div id="divExibeNumFuncionarios" <%=(requisicao.getIndSupervisao().equals("N"))?" style=\"visibility:hidden;\"":"style=\"visibility:visible;\""%>>
	                <strong>Nº de funcionários:</strong>
	                <input class="input" size="12" maxlength="3" onkeypress="return Bloqueia_Caracteres(event);" name="numFuncionariosSupervisao" value="<%=requisicao.getNumFuncionariosSupervisao()%>"/>
	              </div>
	            </td>
	          </tr>         
	          <tr>
	            <td colspan="4" height="10" class="tdIntranet2"></td>
	          </tr>            
	          <tr>
	            <td colspan="4" height="3" class="tdCabecalho" background="../../imagens/fio_azul_end.gif"></td>
	          </tr>           
	        </table>        
	        <br>        
	        
	        <%-- HORÁRIO DE TRABALHO --%>
	        <table border="0" width="100%" cellpadding="0" cellspacing="0">
	          <tr>
	            <td colspan="2" height="18" class="tdCabecalho" background="../../imagens/tit_item.gif">
	             <STRONG>&nbsp;&nbsp;HORÁRIO DE TRABALHO</STRONG>
	            </td>
	          </tr>
	          <tr>
	            <td colspan="2">
	              <%-- ESCALA --%>
	              <div id="divHorarioEscala">
	                <table border="0" width="100%" cellpadding="0" cellspacing="0">
	                  <tr>
	                    <td align="left" class="tdintranet2">
	                      <br>
	                      &nbsp;&nbsp;&nbsp;&nbsp;O horário de trabalho deve ser associado a uma escala horária cadastrada no <i>TimeKeeper</i>, caso o &nbsp;&nbsp;&nbsp;&nbsp;horário desejado não esteja cadastrado, favor solicitar cadastro junto a GEP.
	                      <br><br>
	                      &nbsp;&nbsp;&nbsp;&nbsp;<strong>Código da escala selecionada:&nbsp;</strong>
						  <%
						  // TRATA ESCALA INATIVA
						  if (requisicao.getCodRequisicao() > 0 && requisicaoJornada.getCodEscala().equals("")) {
						  %>
							<strong style="color: #FF0000;">A escala selecionada está inativa. Por favor, selecione outra escala.</strong>
						  <%
						  }
						  %>
						  <input class="label" name="codEscala" id="codEscala" value="<%=requisicaoJornada.getCodEscala()%>" size="15" readonly>
	                    </td>
	                  </tr>
	                  <tr>
	                    <td align="left" class="tdintranet2">
	                      <div id="divPesquisaEscala">
	                        <br>
	                        <table border="0" width="100%" cellpadding="0" cellspacing="0">
	                          <tr>
	                            <td height="20" align="center" class="tdintranet" width="24%">
	                              <STRONG>Dia da semana</STRONG>
	                            </td>
	                            <td height="20" align="center" class="tdintranet" width="20%">
	                              <STRONG>Classificação do dia</STRONG>
	                            </td>            
	                            <td height="20" align="center" class="tdintranet" width="12%">
	                              <STRONG>Entrada</STRONG>
	                            </td>
	                            <td height="20" align="center" class="tdintranet" width="12%">
	                              <STRONG title="Saída para o almoço">Intervalo</STRONG>
	                            </td>            
	                            <td height="20" align="center" class="tdintranet" width="12%">
	                              <STRONG title="Retorno do almoço">Retorno</STRONG>
	                            </td>                        
	                            <td height="20" align="center" class="tdintranet" width="12%">
	                              <STRONG>Saída</STRONG>              
	                            </td>  
	                            <td colspan="2" height="20" align="center" class="tdintranet" width="8%"></td>
	                          </tr>
	                          <%for(int i=0; i<7; i++){%>
	                              <tr>
	                                <td height="25" align="center" class="tdintranet2">
	                                  <select name="tkDia" class="select" style="width: 130px;">
	                                    <option value="0">SELECIONE</option>
	                                    <option value="SEG">SEGUNDA-FEIRA</option>
	                                    <option value="TER">TERÇA-FEIRA</option>
	                                    <option value="QUA">QUARTA-FEIRA</option>
	                                    <option value="QUI">QUINTA-FEIRA</option>
	                                    <option value="SEX">SEXTA-FEIRA</option>
	                                    <option value="SAB">SÁBADO</option>
	                                    <option value="DOM">DOMINGO</option>
	                                  </select>
	                                </td>
	                                <td height="25" align="center" class="tdintranet2">
	                                  <select name="tkClassificacao" class="select" style="width: 110px;" onchange="configLinha(<%=i%>, this.value); ">
	                                    <option value="0">SELECIONE</option>
	                                    <option value="TRAB">TRABALHADO</option>
	                                    <option value="DSRM">DESCANSO</option>
	                                    <option value="COMP">COMPENSADO</option>
	                                  </select>
	                                </td>
	                                <td height="25" align="center" class="tdintranet2">
	                                  <input class="input" name="tkHrEntrada" id="tkHrEntrada<%=i%>" onkeyPress="return Ajusta_Hora(this,event);" onblur="validaHora('tkHrEntrada<%=i%>',this.value); setClaDia(<%=i%>,this.value);" size="5" maxlength="5" >
	                                </td>
	                                <td height="25" align="center" class="tdintranet2">
	                                  <input class="input" name="tkHrIntervalo" id="tkHrIntervalo<%=i%>" onkeyPress="return Ajusta_Hora(this,event);" onblur="validaHora('tkHrIntervalo<%=i%>',this.value); setClaDia(<%=i%>,this.value);" size="5" maxlength="5" >
	                                </td>                      
	                                <td height="25" align="center" class="tdintranet2">
	                                  <input class="input" name="tkHrRetorno" id="tkHrRetorno<%=i%>" onkeyPress="return Ajusta_Hora(this,event);" onblur="validaHora('tkHrRetorno<%=i%>',this.value); setClaDia(<%=i%>,this.value);" size="5" maxlength="5" >
	                                </td>                        
	                                <td height="25" align="center" class="tdintranet2">
	                                  <input class="input" name="tkHrSaida" id="tkHrSaida<%=i%>" onkeyPress="return Ajusta_Hora(this,event);" onblur="validaHora('tkHrSaida<%=i%>',this.value); setClaDia(<%=i%>,this.value);" size="5" maxlength="5" >
	                                </td>                                
	                                <td height="25" align="center" class="tdintranet2" width="3%">
	                                  <a onClick="resetRowPesquisa(<%=i%>);" style="cursor:pointer;">
	                                    <img src="../../imagens/bt_reset.png" alt="Limpar linha" border="0" align="middle"/>
	                                  </a>
	                                </td>
	                                <%if(i==0){%>
	                                  <td height="25" align="center" class="tdintranet2" width="5%">
	                                    <a href="#horas#" onClick="copiaHorario('E');" name="horas">
	                                      <img src="../../imagens/bt_copiar.png" alt="Copiar horário" border="0" align="middle"/>
	                                    </a>
	                                  </td>
	                                <%}else{%>
	                                  <td height="25" align="center" class="tdintranet2" width="5%">
	                                    <input type="CHECKBOX" name="tkSelDia" onclick="limpaHoras('E',<%=i%>);" onkeydown="limpaHoras('E',<%=i%>);">
	                                  </td>
	                                <%}%>
	                              </tr> 
	                          <%}%>
	                        </table>
	                      </div>
	                    </td>
	                  </tr>
	                  <%-- LINHA ADICIONAL DE PESQUISA --%>
	                  <tr>
	                    <td class="tdintranet2">
	                      <div id="divRowPesquisa"></div>
	                    </td>
	                  </tr>                  
	                  <tr>
	                    <td height="30" class="tdintranet2" align="right">
	                      <div id="divBtnPesquisaEscala">
	                        <input type="button" class="botaoIntranet" value=" Adicionar Linha " name="btnAddRowPesquisa" onclick="addRowPesquisa();">
	                        &nbsp;                        
	                        <input type="button" class="botaoIntranet" value=" Pesquisar Escala " name="btnPesquisarEscala" onclick="validaEscala();">
	                        &nbsp;
	                      </div>
	                      <div id="divBtnNovaPesquisa" style="visibility:hidden; display:none;">
	                        <input type="button" class="botaoIntranet" value=" Nova Pesquisa " name="btnNovaPesquisa" onclick="novaPesquisaEscala();">
	                        &nbsp;
	                      </div>              
	                    </td>
	                  </tr>                  
	                  <%-- LISTA DE ESCALAS PESQUISADAS --%>
	                  <tr>
	                    <td class="tdintranet2">
	                      <div id="divEscala" style="visibility:hidden; display:none;">
	                        <table width="100%" border="0">
	                          <tr>
	                            <td class="tdintranet" width="80%">
	                             <STRONG>&nbsp;&nbsp;Escala</STRONG>
	                            </td>
	                            <td class="tdintranet" width="20%">
	                             <STRONG>&nbsp;&nbsp;Jornada</STRONG>
	                            </td>      
	                          </tr>
	                          <tr>
	                            <td colspan="2">
	                              <%-- HORÁRIO DA ESCALA SELECIONADA --%>
	                              <div id="divEscalaCarregando" style="visibility:hidden; display:none;">
	                                <img src="../../imagens/ico_sinc.gif"/>&nbsp;Carregando...
	                              </div>
	                              <div id="divEscalaOpcao">
	                              </div>
	                            </td>
	                          </tr>
	                        </table>
	                      </div>
	                      <div id="divEscalaHorario" style="padding-left:6px; padding-right:6px; padding-bottom:6px;"></div>
	                    </td>
	                  </tr>
	                </table>
	              </div>
	              
	              <%-- GRADE DE DIGITAÇÃO --%>
	              <div id="divHorarioGrade" style="visibility: 'hidden'; display: 'none';">
	                <table border="0" width="100%" cellpadding="0" cellspacing="0">
	                  <tr>
	                    <td colspan="10" class="tdintranet2">&nbsp;</td>
	                  </tr>
	                  <tr>
	                    <td height="20" align="center" class="tdintranet">
	                      <STRONG>Dia da semana</STRONG>
	                    </td>
	                    <td height="20" align="center" class="tdintranet">
	                      <STRONG>Entrada</STRONG>
	                    </td>
	                    <td height="20" align="center" class="tdintranet">
	                      <STRONG>Saída</STRONG>
	                    </td>
	                    <td height="20" align="center" class="tdintranet">
	                      <STRONG>Entrada</STRONG>
	                    </td>
	                    <td height="20" align="center" class="tdintranet">
	                      <STRONG>Saída</STRONG>
	                    </td>
	                    <td height="20" align="center" class="tdintranet">
	                      <STRONG>Entrada</STRONG>
	                    </td>
	                    <td height="20" align="center" class="tdintranet">
	                      <STRONG>Saída</STRONG>
	                    </td>
	                    <td height="20" align="center" class="tdintranet">
	                      <STRONG>Entrada</STRONG>
	                    </td>
	                    <td height="20" align="center" class="tdintranet">
	                      <STRONG>Saída</STRONG>
	                    </td>
	                    <td height="20" align="center" class="tdintranet">
	                      <STRONG>&nbsp;</STRONG>
	                    </td>            
	                  </tr>
	                  
	                  <%
	                    String[] diaSemana = {"Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado", "Domingo"};
	                  	String[] objSemana = {"Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado", "Domingo"};                  	
	                  	Horarios[] horarios;
	                  	
	                  	if(requisicao.getCodRequisicao() == 0 || requisicaoJornada.getHorarios().length == 0){
	                  		//-- Inicia um array com os dias de uma semana
	                  		horarios = new Horarios[7];
	                  		for(int i=0; i<7; i++){
	                  			horarios[i] = new Horarios();
	                  		}
	                  	}else{
	                  		//-- Seta objeto com os horários salvos na RP
	                  		horarios = requisicaoJornada.getHorarios();
	                  	}
	
	                    for(int i=0; i<7; i++){ %>
		                  <tr>
		                    <td height="25" align="left" class="tdintranet2">
		                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=diaSemana[i]%>
		                    </td>	                    
		                    <td height="25" align="center" class="tdintranet2">
		                      <input class="input" name="hrDig<%=objSemana[i]%>Entrada1" id="hrDig<%=objSemana[i]%>Entrada1" onkeyPress="return Ajusta_Hora(this,event)"  onblur="validaHora('hrDig<%=objSemana[i]%>Entrada1', this.value);" size="5" maxlength="5" value="<%=horarios[i].getEntrada()%>">
		                    </td>
		                    <td height="25" align="center" class="tdintranet2">
		                      <input class="input" name="hrDig<%=objSemana[i]%>Saida1" id="hrDig<%=objSemana[i]%>Saida1" onkeyPress="return Ajusta_Hora(this,event)"  onblur="validaHora('hrDig<%=objSemana[i]%>Saida1',this.value);" size="5" maxlength="5" value="<%=horarios[i].getIntervalo()%>">
		                    </td>                      
		                    <td height="25" align="center" class="tdintranet2">
		                      <input class="input" name="hrDig<%=objSemana[i]%>Entrada2" id="hrDig<%=objSemana[i]%>Entrada2" onkeyPress="return Ajusta_Hora(this,event)"  onblur="validaHora('hrDig<%=objSemana[i]%>Entrada2',this.value);" size="5" maxlength="5" value="<%=horarios[i].getRetorno()%>">              
		                    </td>                        
		                    <td height="25" align="center" class="tdintranet2">
		                      <input class="input" name="hrDig<%=objSemana[i]%>Saida2" id="hrDig<%=objSemana[i]%>Saida2" onkeyPress="return Ajusta_Hora(this,event)"  onblur="validaHora('hrDig<%=objSemana[i]%>Saida2',this.value);" size="5" maxlength="5" value="<%=horarios[i].getSaida()%>">
		                    </td>  
		                    <td height="25" align="center" class="tdintranet2">
		                      <input class="input" name="hrDig<%=objSemana[i]%>Entrada3" id="hrDig<%=objSemana[i]%>Entrada3" onkeyPress="return Ajusta_Hora(this,event)"  onblur="validaHora('hrDig<%=objSemana[i]%>Entrada3',this.value);" size="5" maxlength="5" value="<%=horarios[i].getEntradaExtra()%>">              
		                    </td>                        
		                    <td height="25" align="center" class="tdintranet2">
		                      <input class="input" name="hrDig<%=objSemana[i]%>Saida3" id="hrDig<%=objSemana[i]%>Saida3" onkeyPress="return Ajusta_Hora(this,event)"  onblur="validaHora('hrDig<%=objSemana[i]%>Saida3',this.value);" size="5" maxlength="5" value="<%=horarios[i].getIntervaloExtra()%>">
		                    </td>                      
		                    <td height="25" align="center" class="tdintranet2">
		                      <input class="input" name="hrDig<%=objSemana[i]%>Entrada4" id="hrDig<%=objSemana[i]%>Entrada4" onkeyPress="return Ajusta_Hora(this,event)"  onblur="validaHora('hrDig<%=objSemana[i]%>Entrada4',this.value);" size="5" maxlength="5" value="<%=horarios[i].getRetornoExtra()%>">              
		                    </td>                        
		                    <td height="25" align="center" class="tdintranet2">
		                      <input class="input" name="hrDig<%=objSemana[i]%>Saida4" id="hrDig<%=objSemana[i]%>Saida4" onkeyPress="return Ajusta_Hora(this,event)"  onblur="validaHora('hrDig<%=objSemana[i]%>Saida4',this.value);" size="5" maxlength="5" value="<%=horarios[i].getSaidaExtra()%>">
		                    </td>
		                    <%if(i == 0){ %>
			                    <td height="25" align="center" class="tdintranet2">
			                      <a href="#horas#" onClick="javaScript:copiaHorario('P');" name="horas">
			                        <img src="../../imagens/bt_copiar.png" alt="Copiar horário" border="0" align="middle"/>
			                      </a>
			                    </td>
			                <%}else{%>
			                    <td height="25" align="center" class="tdintranet2">
			                      <input type="CHECKBOX" name="hrSelDia" onclick="limpaHoras('P',<%=i%>);" onkeydown="limpaHoras('P',<%=i%>);">
			                    </td>
			                <%}%>
		                  </tr>
		              <%}%>
	                  <tr>
	                    <td colspan="10" height="30" class="tdintranet2" align="right">
	                      <div id="divBtnConfirmar">
	                        <input type="button" class="botaoIntranet" value=" Confirmar Horário " name="btnConfirmar" onclick="getCalendarioByGradeHorario(true);">&nbsp;
	                      </div>
	                      <div id="divBtnAlterar" style="visibility: hidden; display: none;">
	                        <input type="button" class="botaoIntranet" value=" Alterar Horário " name="btnAlterar" onclick="novaPesquisaGrade();">
	                        &nbsp;
	                      </div>              
	                    </td>
	                  </tr>                   
	                </table>
	              </div>
	            </td>
	          </tr>
	          <tr>
	            <td colspan="2" height="3" class="tdCabecalho" background="../../imagens/fio_azul_end.gif"></td>
	          </tr>            
	          <tr>
	            <td height="26" class="tdintranet2" width="24%" align="right">
	              <STRONG>ID Calendário:&nbsp;</STRONG>
	            </td>
	            <td height="35" class="tdintranet2">
	              <div id="divIdCalendario">
	                <select name="codCalendario" id="codCalendario" style="width:402px;">
	                  <option value="<%=requisicaoJornada.getCodCalendario()%>">SELECIONE</option>
	                </select>
	              </div>
	            </td>
	          </tr>            
	          <tr>
	            <td colspan="2" height="3" class="tdCabecalho" background="../../imagens/fio_azul_end.gif"></td>
	          </tr>             
	        </table>       
	        <br>        
	        
	        <%-- PERFIL DO CANDIDATO --%>
            <%if(tipoEdicao !=2) {%>
	        <table border="0" width="100%" cellpadding="0" cellspacing="0">
	          <tr>
	            <td colspan="3" height="18" class="tdCabecalho" background="../../imagens/tit_item.gif">
	             <STRONG>&nbsp;&nbsp;PERFIL DO CANDIDATO</STRONG>
	            </td>
	          </tr>           
	          <tr>
	            <td colspan="2" height="10" class="tdIntranet2"></td>
	          </tr>
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <strong>Área:&nbsp;</strong>
	            </td>
	            <td class="tdintranet2">
	              <select name="codArea" class="select" style="width: 386px;">
	              	<option value="0">SELECIONE</option>
	                <%for(int i=0; i<comboArea.length; i++){%>
	                  <option value="<%=comboArea[i][0]%>" <%=(comboArea[i][0].equals(String.valueOf(requisicaoPerfil.getCodArea())))?" SELECTED":""%>><%=comboArea[i][1]%></option>
	                <%}%>                    	                  	
	              </select>
	            </td>
	          </tr>          
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <strong>Função:&nbsp;</strong>
	            </td>
	            <td class="tdintranet2">
                  <select name="codFuncao" class="select" style="width: 386px;">
                  	<option value="0">SELECIONE</option>
	                <%for(int i=0; i<comboFuncao.length; i++){%>
	                  <option value="<%=comboFuncao[i][0]%>" <%=(comboFuncao[i][0].equals(String.valueOf(requisicaoPerfil.getCodFuncao())))?" SELECTED":""%>><%=comboFuncao[i][1]%></option>
	                <%}%>                    	 	                                              
	              </select>
	              <div id="divBtnAddFuncao" style="display:none;">
		              <a href="javascript: addFuncao();" title="Adicionar outra função">
		              	<img src="../../imagens/add.png" border="0" align="top"/>
		              </a>
	              </div>
	            </td>
	          </tr>
	          <tr>
	          	<td colspan="2" class="tdintranet2" style="padding-left:183px;">
	          		<div id="divPerfilFuncao"><%
	          		  if(requisicaoPerfil.getListFuncao() != null){
	          			  String[] funcoes = requisicaoPerfil.getListFuncao().split(","); 
	          			  for(int idx=0; idx<funcoes.length; idx++){         				  
	          	              out.print("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">");
	          	              out.print("<tr><td height=\"25\">");
	          				  out.print("<select name=\"codFuncao\" class=\"select\" style=\"width: 386px;\">");
	          	              out.print("<option value=\"0\">SELECIONE</option>");                          
	          	              for(int i=0; i<comboFuncao.length; i++){
	                            out.print("<option value=\""+ comboFuncao[i][0] +"\"" +(comboFuncao[i][0].equals(funcoes[idx])?" SELECTED":"") +">"+ comboFuncao[i][1] +"</option>");
	                          }
	                          out.print("</td></tr></select></table>");
	          			  }          		
	          		  }
	          		%></div>
	          	</td>
	          </tr>
	          <tr>
	            <td height="25" align="right" class="tdintranet2">
	              <strong>Nível hierárquico:&nbsp;</strong>
	            </td>
	            <td class="tdintranet2">
	              <select name="codNivelHierarquia" class="select" style="width: 386px;">
	              	<option value="0">SELECIONE</option>
		            <%for(int i=0; i<comboNivelHierarquia.length; i++){%>
		              <option value="<%=comboNivelHierarquia[i][0]%>" <%=(comboNivelHierarquia[i][0].equals(String.valueOf(requisicaoPerfil.getCodNivelHierarquia())))?" SELECTED":""%>><%=comboNivelHierarquia[i][1]%></option>
		            <%}%>                    	                               
	              </select>
	            </td>
	          </tr>
	          
	          <%-- 26/09/2011 Solicitado pelo NEC
	          <tr>
	            <td height="25" width="30%" align="right" class="tdintranet2" valign="top">
	              <STRONG>Descrição da vaga:&nbsp;</STRONG>
	              <br>
	              <a href="javascript:void(0);" class="dcontexto">
	                <img src="../../imagens/help.gif" border="0" align="middle">&nbsp;
	                <span>Descreva a oportunidade de forma a atrair o interesse do candidato para o cargo e para fazer parte da Instituição.</span>
	              </a>
	            </td>
	            <td class="tdintranet2" >
	              <textarea cols="73" rows="5" name="dscOportunidade" title="Descreva a oportunidade de forma a atrair o interesse do candidato para o cargo e para fazer parte da Instituição."
	                      onKeyDown="limitarCaracteres(this,document.frmRequisicao.qtdDscOportunidade,4000);" 
	                      onKeyUP  ="limitarCaracteres(this,document.frmRequisicao.qtdDscOportunidade,4000);" ><%=requisicaoPerfil.getDscOportunidade()%></textarea>
	              <input type="text" name="qtdDscOportunidade" class="label" readonly="readonly" value="<%=(((codRequisicao == 0)?0:4000) - requisicaoPerfil.getDscOportunidade().length())%>" size="4" align="middle">
	            </td>
	          </tr>
	          --%>
	                     
	          <tr>
	            <td colspan="2" height="6" class="tdIntranet2"></td>
	          </tr>  
	          <tr>
	            <td height="25" width="30%" align="right" class="tdintranet2" valign="top">
	              <STRONG>Principais atividades&nbsp;&nbsp;<br>do cargo:&nbsp;</STRONG>
	              <br>
	              <a href="javascript:void(0);" class="dcontexto">
	                <img src="../../imagens/help.gif" border="0" align="middle">&nbsp;
	                <span>Relate as principais atividades que o profissional irá desempenhar.</span>
	              </a>              
	            </td>
	            <td class="tdintranet2" >
	              <textarea cols="73" rows="5" name="dscAtividadesCargo" title="Relate as principais atividades que o profissional irá desempenhar."
	                      onKeyDown="limitarCaracteres(this,document.frmRequisicao.qtdDscAtividadesCargo,4000);" 
	                      onKeyUP  ="limitarCaracteres(this,document.frmRequisicao.qtdDscAtividadesCargo,4000);" <%  if (tipoEdicao==2){%> readonly="readonly" <%}%>><%=requisicaoPerfil.getDscAtividadesCargo()%></textarea>
	              <input type="text" name="qtdDscAtividadesCargo" class="label" readonly="readonly" value="<%=(((codRequisicao == 0)?0:4000) - requisicaoPerfil.getDscAtividadesCargo().length())%>" size="4" align="middle">
	            </td>
	          </tr>           
	          <tr>
	            <td colspan="2" height="6" class="tdIntranet2"></td>
	          </tr>
	          <tr>
	            <td height="25" width="30%" align="right" class="tdintranet2" valign="top">
	              <STRONG>Escolaridade mínima:&nbsp;</STRONG>
	              <br>
	              <a href="javascript:void(0);" class="dcontexto">
	                <img src="../../imagens/help.gif" border="0" align="middle">&nbsp;
	                <span>Informe a escolaridade mínima obrigatória e o curso ou área de Formação e caso exista restrição, informe também a escolaridade máxima desejada.</span>
	              </a>                            
	            </td>
	            <td class="tdintranet2" >
	              <textarea cols="73" rows="5" name="descricaoFormacao" title="Informe a escolaridade mínima obrigatória e o curso ou área de Formação e caso exista restrição, informe também a escolaridade máxima desejada."
	                      onKeyDown="limitarCaracteres(this,document.frmRequisicao.qtdFormacao,4000);" 
	                      onKeyUP  ="limitarCaracteres(this,document.frmRequisicao.qtdFormacao,4000);" <%  if (tipoEdicao==2){%> readonly="readonly" <%}%> ><%=requisicaoPerfil.getDescricaoFormacao()%></textarea>
	              <input type="text" name="qtdFormacao" class="label" readonly="readonly" value="<%=(((codRequisicao == 0)?0:4000) - requisicaoPerfil.getDescricaoFormacao().length())%>" size="4" align="middle">
	            </td>
	          </tr>    
	          <tr>
	            <td colspan="2" height="6" class="tdIntranet2"></td>
	          </tr> 
	          <tr>
	            <td height="25" width="30%" align="right" class="tdintranet2" valign="top">
	              <STRONG>Experiência profissional:&nbsp;</STRONG>
	              <br>
	              <a href="javascript:void(0);" class="dcontexto">
	                <img src="../../imagens/help.gif" border="0" align="middle">&nbsp;
	                <span>A solicitação do tempo de experiência poderá ser de no máximo 6 meses. Procure relatar as experiências profissionais, atividades ou vivências anteriores que são relevantes para o desempenho da oportunidade.</span>
	              </a>   
	            </td>
	            <td class="tdintranet2">
	              <textarea cols="73" rows="5" name="dscExperiencia" title="A solicitação do tempo de experiência poderá ser de no máximo 6 meses. Procure relatar as experiências profissionais, atividades ou vivências anteriores que são relevantes para o desempenho da oportunidade."
	                      onKeyDown="limitarCaracteres(this,document.frmRequisicao.qtdExperiencia,4000);" 
	                      onKeyUP  ="limitarCaracteres(this,document.frmRequisicao.qtdExperiencia,4000);" <%  if (tipoEdicao==2){%> readonly="readonly" <%}%> ><%=requisicaoPerfil.getDscExperiencia()%></textarea>
	              <input type="text" name="qtdExperiencia" class="label" readonly="readonly" value="<%=(((codRequisicao == 0)?0:4000) - requisicaoPerfil.getDscExperiencia().length())%>" size="4" align="middle">
	            </td>
	          </tr>
	          <tr>
	            <td colspan="2" height="6" class="tdIntranet2"></td>
	          </tr> 
	          <tr>
	            <td height="25" width="30%" align="right" class="tdintranet2" valign="top">
	              <STRONG>Conhecimentos específicos:&nbsp;</STRONG>
	              <br>
	              <a href="javascript:void(0);" class="dcontexto">
	                <img src="../../imagens/help.gif" border="0" align="middle">&nbsp;
	                <span>Descrever os conhecimentos específicos necessários para exercer a função em questão. Exemplos: idiomas, informática, certificações diversas, etc.</span>
	              </a>   
	            </td>
	            <td class="tdintranet2" >
	              <textarea cols="73" rows="5" name="dscConhecimentos" title="Descrever os conhecimentos específicos necessários para exercer a função em questão. Exemplos: idiomas, informática, certificações diversas, etc."
	                      onKeyDown="limitarCaracteres(this,document.frmRequisicao.qtdConhecimentos,4000);" 
	                      onKeyUP  ="limitarCaracteres(this,document.frmRequisicao.qtdConhecimentos,4000);" <%  if (tipoEdicao==2){%> readonly="readonly" <%}%> ><%=requisicaoPerfil.getDscConhecimentos()%></textarea>
	              <input type="text" name="qtdConhecimentos" class="label" readonly="readonly" value="<%=(((codRequisicao == 0)?0:4000) - requisicaoPerfil.getDscConhecimentos().length())%>" size="4" align="middle">
	            </td>
	          </tr>
	          <tr>
	            <td colspan="2" height="6" class="tdIntranet2"></td>
	          </tr>            
	          <tr>
	            <td height="25" width="30%" align="right" class="tdintranet2" valign="top">
	              <STRONG>Competências:&nbsp;</STRONG>
	              <br>
	              <a href="javascript:void(0);" class="dcontexto">
	                <img src="../../imagens/help.gif" border="0" align="middle">&nbsp;
	                <span>Relate os comportamentos, habilidades e atitudes desejadas para o desempenho da função.</span>
	              </a>  
	            </td>
	            <td class="tdintranet2">
	              <textarea cols="73" rows="5" name="outrasCarateristica" title="Relate os comportamentos, habilidades e atitudes desejadas para o desempenho da função."
	                      onKeyDown="limitarCaracteres(this,document.frmRequisicao.qtdOutrasCaracteristicas,4000);" 
	                      onKeyUP  ="limitarCaracteres(this,document.frmRequisicao.qtdOutrasCaracteristicas,4000);" <%  if (tipoEdicao==2){%> readonly="readonly" <%}%>><%=requisicaoPerfil.getOutrasCarateristica()%></textarea>
	              <input type="text" name="qtdOutrasCaracteristicas" class="label" readonly="readonly" value="<%=(((codRequisicao == 0)?0:4000) - requisicaoPerfil.getOutrasCarateristica().length())%>" size="4" align="middle">
	            </td>
	          </tr> 
	          <tr>
	            <td colspan="2" height="6" class="tdIntranet2"></td>
	          </tr>            
	          <tr>
	            <td height="25" width="30%" align="right" class="tdintranet2" valign="top">
	              <STRONG>Observações:&nbsp;</STRONG>
	            </td>
	            <td class="tdintranet2">
	              <textarea cols="73" rows="5" name="comentarios"
	                      onKeyDown="limitarCaracteres(this,document.frmRequisicao.qtdComentarios,2000);" 
	                      onKeyUP  ="limitarCaracteres(this,document.frmRequisicao.qtdComentarios,2000);" <%  if (tipoEdicao==2){%> readonly="readonly" <%}%>><%=requisicaoPerfil.getComentarios()%></textarea>
	              <input type="text" name="qtdComentarios" class="label" readonly="readonly" value="<%=(((codRequisicao == 0)?0:2000) - requisicaoPerfil.getComentarios().length())%>" size="4" align="middle">
	            </td>
	          </tr>          
	          <tr>
	            <td colspan="2" height="10" class="tdIntranet2"></td>
	          </tr>                             
	          <tr>
	            <td colspan="2" height="3" class="tdCabecalho" background="../../imagens/fio_azul_end.gif"></td>
	          </tr>                      
	        </table>              
            <%} else {%>       
<!--        PERFIL AP E B, SO CONSULTA -->
			<table border="0" width="100%" cellpadding="0" cellspacing="0">
	          <tr>
	            <td colspan="3" height="18" class="tdCabecalho" background="../../imagens/tit_item.gif">
	             <STRONG>&nbsp;&nbsp;PERFIL DO CANDIDATO</STRONG>
	            </td>
	          </tr>           
	          <tr>
                <td colspan="2" height="10" class="tdIntranet2"></td>
              </tr>
              <tr>
                <td colspan="4" height="28" align="left" class="tdIntranet2">
                  &nbsp;<STRONG>Área</STRONG><br>&nbsp;<%=(requisicaoPesquisa[0][70]==null)?"":requisicaoPesquisa[0][70]%>
                </td>               
              </tr> 
              <tr>
                <td colspan="4" height="28" align="left" class="tdIntranet2">
                  &nbsp;<STRONG>Função</STRONG><br>&nbsp;<%=(requisicaoPesquisa[0][71] == null) ? "" : requisicaoPesquisa[0][71]%> 
                </td>
              </tr>
              <!--  mantida essa linha pois por algum motivo se tirar não funciona o preenchimento do combo id calendario -->
              <tr>
	            <td class="tdintranet2">
	              <div id="divBtnAddFuncao" style="display:none;">
		              <a href="javascript: addFuncao();" title="Adicionar outra função">
		              	<img src="../../imagens/add.png" border="0" align="top"/>
		              </a>
	              </div>
	            </td>
	          </tr>
	          <tr>
                <td colspan="4" height="28" align="left" class="tdIntranet2">
                  &nbsp;<STRONG>Nível hierárquico</STRONG><br>&nbsp;<%=(requisicaoPesquisa[0][72]==null)?"":requisicaoPesquisa[0][72]%>
                </td>
              </tr>
              <% if(requisicaoPesquisa[0][73] != null){ %>
                <tr>
                  <td colspan="4" height="28" class="tdIntranet2">
                    <div align="justify" style="padding-left:5px; padding-right:5px;">
                      <STRONG>Descrição da vaga</STRONG><br><%=requisicaoPesquisa[0][73]%>
                    </div>
                  </td>               
                </tr>
              <%}%>
              <tr>
                <td colspan="4" height="28" align="left" class="tdIntranet2">
                  <div style="padding-left:5px; padding-right:5px;">
                    <STRONG>Principais atividades do cargo</STRONG><br>
                    <%=(requisicaoPesquisa[0][74]==null)?"":requisicaoPesquisa[0][74]%>                        
                  </div>
                </td>               
              </tr> 
              <tr>
                <td colspan="4" height="28" align="left" class="tdIntranet2">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Escolaridade mínima</STRONG><br>
                    <%=(requisicaoPesquisa[0][59]==null)?((requisicaoPesquisa[0][58]==null)?"":requisicaoPesquisa[0][58]):requisicaoPesquisa[0][59]%>                        
                  </div>
                </td>               
              </tr>
              <tr>
                <td colspan="4" height="28" class="tdIntranet2">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Experiência profissional</STRONG><br>
                    <%=(requisicaoPesquisa[0][78]==null)?"":requisicaoPesquisa[0][78]%>                        
                  </div>
                </td>               
              </tr>
              <tr>
                <td colspan="4" height="28" class="tdIntranet2">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Conhecimentos específicos</STRONG><br>
                    <%=(requisicaoPesquisa[0][81]==null)?"":requisicaoPesquisa[0][81]%>                        
                  </div>
                </td>               
              </tr>
              <tr>
                <td colspan="4" height="28" class="tdIntranet2">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Competências</STRONG><br>
                    <%=(requisicaoPesquisa[0][62]==null)?"":requisicaoPesquisa[0][62]%>
                  </div>
                </td>               
              </tr>   
              <tr>
                <td height="28" class="tdIntranet2" colspan="4">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Observações</STRONG><br>
                    <%=(requisicaoPesquisa[0][65]==null)?"":requisicaoPesquisa[0][65]%>
                  </div>
                </td>               
              </tr> 
              <tr>
                <td colspan="2" height="10" class="tdIntranet2"></td>
              </tr>                             
              <tr>
                <td colspan="2" height="3" class="tdCabecalho" background="../../imagens/fio_azul_end.gif"></td>
              </tr>                                                                 
	        </table>           
	        <%}%>
	        <br>
	        
	        <%-- BOTÕES DE ENVIO --%>
	        <table border="0" width="100%" cellpadding="0" cellspacing="0">     
	          <tr>
	            <td colspan="2" height="3" class="tdCabecalho" background="../../imagens/fio_azul_end.gif"></td>
	          </tr>             
	          <tr>
	            <td align="right" class="tdIntranet2" colspan="2" height="30">
	              <%if(tipoEdicao !=2){%>
	              	<input type="button" name="btnSubmete" class="botaoIntranet" value="<%=altBotao%>" onclick="submete();">&nbsp;
	              <%} else {%>
	              	<input type="button" name="btnSubmete" class="botaoIntranet" value="<%=altBotao%>" onclick="submete(true);">&nbsp;
	              <%}%>
	              <input type="button" name="btnVoltar"  class="botaoIntranet" value="   Voltar   "  onclick="window.history.back();">
	              &nbsp;&nbsp;&nbsp;
	            </td>
	          </tr>  
	          <tr>
	            <td colspan="2" height="3" class="tdCabecalho" background="../../imagens/fio_azul_end.gif"></td>
	          </tr>             
	        </table>
        </div>
      </td>
    </tr>
</table>
</form>
</center>

<%-- Carregando valores dos campos em ajax --%>
<script language="JavaScript">
  var pagina = '<%=request.getContextPath()%>/requisicao/cadastro/ajax/getComboSegmento.jsp'; 

  //-- Verificando regras de scripts na tela
  <%if(codRequisicao > 0){%>
	  // Exibe a div principal do formulário
	  exibeOcultaDiv('divDados', true);
	  
      // Carrega os dados da unidade e cargo
      getDadosUnidade('<%=requisicao.getSegmento3()%>', '<%=requisicao.getCodCargo()%>');
              
      // Carrega os combos vinculados com o tipo de recrutamento
      configuraRP('<%=requisicao.getCodRecrutamento()%>');      

      // Carregando a descrição da classificação funcional no textarea
      carregaDadosClassificacaoFuncional(document.frmRequisicao.codClassificacaoFuncional.value,'divDescricaoClassificacaoFuncional');

      // Carregando o prazo de contratação          
      <%if((requisicao.getDatInicioContratacao() != null && !requisicao.getDatInicioContratacao().equals("")) && 
           (requisicao.getDatFimContratacao() != null && !requisicao.getDatFimContratacao().equals(""))){%>
          carregaPrazoContratacao(document.frmRequisicao.codClassificacaoFuncional.value, 'divPrazoContratacao','<%=formatoData.format(requisicao.getDatInicioContratacao())%>','<%=formatoData.format(requisicao.getDatFimContratacao())%>');
      <%}else{%>
          carregaPrazoContratacao(document.frmRequisicao.codClassificacaoFuncional.value, 'divPrazoContratacao','',''); 
      <%}%>
      
      // Caso exista uma substituição, carrega o nome do funcionário  
      <%if(requisicao.getIdSubstitutoHist() > 0){%>      
          carregaNomeFuncionario(document.frmRequisicao.idSubstitutoHist.value, 'divNomeSubstituido');
      <%}%>  
      
      // Controla exibição do campo de substituição (chapa e nome)
      exibeFuncionarioSubstituido('<%=requisicao.getCodRPPara()%>', 'RP_PARA');
      
      if('<%=requisicao.getCodMotivoSolicitacao()%>' != '0' && '<%=requisicao.getCodMotivoSolicitacao()%>' != ''){
        exibeFuncionarioSubstituido('<%=requisicao.getCodMotivoSolicitacao()%>', 'MOTIVO_SOLICITACAO');
      }

      // Controla exibição do campo local de trabalho (outro local de trabalho)
      exibeOutroLocalTrabalho(document.frmRequisicao.indLocalTrabalho.value);
      
      // Controla exibição dos campos de períodos de contratação (datas)
      exibePeriodoTipoContratacao(document.frmRequisicao.indTipoContratacao.value);
           
      // Configura a área de pesquisa de escala      
      setTipoHorarioTrabalho('<%=requisicaoJornada.getIndTipoHorario()%>');

      if('<%=requisicaoJornada.getIndTipoHorario()%>' == 'P'){
    	getCalendarioByGradeHorario(true);
      }else{
       	exibePesquisaEscala(true);
       	getEscalaHorario('<%=requisicaoJornada.getCodEscala()%>', false);
        getComboCalendario('<%=requisicaoJornada.getCodEscala()%>');
      }

      if(<%=isHabilitaCH%>){
        document.getElementById('jornadaTrabalho').removeAttribute('readOnly');
      } 
      
      
      document.frmRequisicao.dscAtividadesCargo.onkeyup();
      document.frmRequisicao.descricaoFormacao.onkeyup();
      document.frmRequisicao.dscExperiencia.onkeyup();
      document.frmRequisicao.dscConhecimentos.onkeyup();
      document.frmRequisicao.outrasCarateristica.onkeyup();
      document.frmRequisicao.comentarios.onkeyup();
      
  <%}%> 
 
</script>
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>