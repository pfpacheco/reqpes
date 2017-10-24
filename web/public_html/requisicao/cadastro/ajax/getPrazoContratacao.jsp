<%@ page import="br.senac.sp.reqpes.Control.RequisicaoControl" %>
<%@ page import="br.senac.sp.reqpes.Interface.Config" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
  //-- Objetos de controle
  RequisicaoControl requisicaoControl = new RequisicaoControl();
  SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
  
  //-- Parametros de página
  int codClassificacaoFuncional = (request.getParameter("P_COD_CLASSIFICACAO")==null)?1:Integer.parseInt(request.getParameter("P_COD_CLASSIFICACAO"));
  String nomDiv                 = (request.getParameter("P_DIV")==null)?"":request.getParameter("P_DIV").trim();
  String dataInicio             = (request.getParameter("P_DATA_INICIO")==null)?"":request.getParameter("P_DATA_INICIO").trim();
  String dataFim                = (request.getParameter("P_DATA_FIM")==null)?"":request.getParameter("P_DATA_FIM").trim();
  
  //-- Carregando parâmetros do sistema
  String vlrAprendizCargo = (sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"APRENDIZ_CARGO") != null)?sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"APRENDIZ_CARGO").getVlrSistemaParametro():""; 
  int vlrAprendizPrazo = (sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"APRENDIZ_CONTRATACAO_PRAZO") != null)?Integer.parseInt(sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"APRENDIZ_CONTRATACAO_PRAZO").getVlrSistemaParametro()):0;
  int vlrPrazo         = (sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"CONTRATACAO_PRAZO") != null)?Integer.parseInt(sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"CONTRATACAO_PRAZO").getVlrSistemaParametro()):0;


  //-- Objetos
  SistemaParametro[] sistemaParametro = null;   
  String[][] prazoContratacao = null;
 
  //-- Resgatando o valor do parametro de prazo de contratação
  if(dataInicio.equals("") && dataFim.equals("")){
     //-- Se for uma nova requisição, resgata o valor cadastrado no parâmetro do sistema
     sistemaParametro = sistemaParametroControl.getSistemaParametros(" WHERE SP.COD_SISTEMA="+Config.ID_SISTEMA+" AND SP.NOM_PARAMETRO = 'CONTRATACAO_PRAZO'");
  }else{
     //-- Caso a requisição já exista, realiza uma conta com as datas para adquirir o prazo da contratação
     prazoContratacao = requisicaoControl.getMatriz(" SELECT TO_DATE('"+dataFim+"','dd/mm/yyyy') - TO_DATE('"+dataInicio+"', 'dd/mm/yyyy') AS PRAZO_CONTRATACAO FROM DUAL ");
  }
%>

<%if(sistemaParametro != null && sistemaParametro.length > 0){%>
	<input type="hidden" name="aprendizCargo" id="aprendizCargo" value="<%=vlrAprendizCargo%>" />
	<input type="hidden" name="vlrAprendizPrazo" id="vlrAprendizPrazo" value="<%=vlrAprendizPrazo%>" />
	<input type="hidden" name="vlrPrazo" id="vlrPrazo" value="<%=vlrPrazo%>" />
	<input class="input" size="4" id="prazoContratacao" maxlength="4" onkeyup="verificaPrazoContratacao(this.value,<%=vlrAprendizPrazo%>,<%=vlrPrazo%>);" onblur="limpaDatas();"  onkeypress="return Bloqueia_Caracteres(event);" name="prazoContratacao"  value="<%=(codClassificacaoFuncional == 4)?Integer.parseInt(sistemaParametro[0].getVlrSistemaParametro())*2:Integer.parseInt(sistemaParametro[0].getVlrSistemaParametro())%>" /><label for="prazoContratacao"> meses</label>
	<!-- <input class="input" size="4" maxlength="4" name="prazoContratacao" onkeypress="return Bloqueia_Caracteres(event);" onblur="verificaPrazoContratacao(this.value);" value="<%=(codClassificacaoFuncional == 4)?Integer.parseInt(sistemaParametro[0].getVlrSistemaParametro())*2:Integer.parseInt(sistemaParametro[0].getVlrSistemaParametro())%>" /> meses -->
<%}%>

<%if(prazoContratacao != null && prazoContratacao.length > 0){%>
	<input type="hidden" name="aprendizCargo" id="aprendizCargo" value="<%=vlrAprendizCargo%>" />
	<input type="hidden" name="vlrAprendizPrazo" id="vlrAprendizPrazo" value="<%=vlrAprendizPrazo%>" />
	<input type="hidden" name="vlrPrazo" id="vlrPrazo" value="<%=vlrPrazo%>" />
	<input class="input" size="4" id="prazoContratacao" maxlength="4" onkeyup="verificaPrazoContratacao(this.value,<%=vlrAprendizPrazo%>,<%=vlrPrazo%>);" onblur="limpaDatas();"  onkeypress="return Bloqueia_Caracteres(event);" name="prazoContratacao"  value="<%=prazoContratacao[0][0]%>" /><label for="prazoContratacao"> meses</label>
    <!-- <input class="input" size="4" maxlength="4" name="prazoContratacao" onkeypress="return Bloqueia_Caracteres(event);" onblur="verificaPrazoContratacao(this.value);" value="<%=prazoContratacao[0][0]%>" /> dias -->
<%}%>