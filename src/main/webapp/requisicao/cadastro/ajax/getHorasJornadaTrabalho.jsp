<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
    //-- Objetos de controle
    RequisicaoControl requisicaoControl = new RequisicaoControl();
	SistemaParametroControl spc = new SistemaParametroControl();
    
    //-- Parametros de página
    String codUnidade = (request.getParameter("P_COD_UNIDADE")==null)?"":request.getParameter("P_COD_UNIDADE");
    String nomDiv     = (request.getParameter("P_DIV")==null)?"":request.getParameter("P_DIV").trim();
    String codCargo   = (request.getParameter("P_COD_CARGO")==null)?"":request.getParameter("P_COD_CARGO");
    SistemaParametro parametroCargosExcecao = spc.getSistemaParametroPorSistemaNome(7, "CARGOS_EXCECAO");    
    //-- Objetos
    StringBuffer sql = new StringBuffer();
    String[][] dadosJornada = null;
    
    //-- Query de pesquisa
    sql.append(" SELECT UNIQUE C.HORAS_SEMANAIS ");    
    sql.append("       ,CASE ");    
    sql.append("          WHEN T.TAB_SALARIAL IN(4,9,11) OR C.ID IN ("+parametroCargosExcecao.getVlrSistemaParametro()+") THEN "); //-- Tabela de PROFESSORES
    sql.append("               'P' ");    
    sql.append("          WHEN T.TAB_SALARIAL = 5 THEN "); //-- Tabela de MONITORES
    sql.append("               'M' "); 
    sql.append("          ELSE ");
    sql.append("               'E' ");
    sql.append("        END TIPO_HORARIO ");
    sql.append("       ,C.REGIME ");
    sql.append(" FROM   CARGOS           C ");
    sql.append("       ,CARGO_DESCRICOES CD ");
    sql.append("       ,(SELECT UNIQUE U.TAB_SALARIAL, U.ID_CARGO FROM UNIORG_CARGO_TAB_NIVEL U) T ");
    sql.append(" WHERE  C.ID         = " + codCargo);
    sql.append(" AND    C.ID         = CD.ID ");
    sql.append(" AND    T.ID_CARGO   = C.ID ");
  
    //-- Executando o resultado da consulta
    dadosJornada = requisicaoControl.getMatriz(sql.toString());    
%>

<%if(dadosJornada != null && dadosJornada.length > 0){ %>
      
   &nbsp;<input class="input" size="4" maxlength="7" id="jornadaTrabalho" name="jornadaTrabalho" onkeypress="return maskJornadaTrabalho(event);" value="<%=(dadosJornada[0][2].equals("H"))?"":dadosJornada[0][0]%>" <%=(dadosJornada[0][2].equals("H"))?"":" readonly"%> />
   <input type="HIDDEN" name="indTipoHorario" id="indTipoHorario" value="<%=dadosJornada[0][1]%>">
   <input type="HIDDEN" name="indCargoRegime" id="indCargoRegime" value="<%=dadosJornada[0][2]%>">
<%}else{
    //-- Enviando e-mail de crítica
   // RequisicaoMensagemControl.enviaMensagemCritica("getHorasJornadaTrabalho.jsp", "Nenhuma carga horária associada ao cargo selecionado! <br><b>Unidade:</b> "+codUnidade+"<br><b>Cargo:</b> "+codCargo, (Usuario) session.getAttribute("usuario"));
    %>
  <font color="Red">Nenhuma carga horária <br>associada ao cargo selecionado!</font>
<%}%>