<%@ page import="br.senac.sp.reqpes.Control.RequisicaoControl" %>
<%@ page import="br.senac.sp.reqpes.Control.RequisicaoMensagemControl" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
    //-- Objetos de controle
    RequisicaoControl requisicaoControl = new RequisicaoControl();
    
    //-- Parametros de página
    String chapa  = (request.getParameter("P_CHAPA")==null)?"0":request.getParameter("P_CHAPA").trim();
    String nomDiv = (request.getParameter("P_DIV")==null)?"":request.getParameter("P_DIV").trim();
    
    //-- Objetos
    StringBuffer sql = new StringBuffer();
    String[][] funcionario = null;
    
    //-- Query de pesquisa    
    sql.append(" SELECT F.NOME ");
    sql.append("       ,F.ID ");
    sql.append("       ,F.COD_UNIORG ");
    sql.append("       ,UO.DESCRICAO ");
    sql.append(" FROM   FUNCIONARIOS             F ");
    sql.append("       ,UNIDADES_ORGANIZACIONAIS UO ");
    sql.append(" WHERE  F.COD_UNIORG = UO.CODIGO ");
    sql.append(" AND    F.ID         = " + chapa);    
  
    //-- Executando o resultado da consulta
    funcionario = requisicaoControl.getMatriz(sql.toString());       
%>

<%if(funcionario.length > 0){
    if(nomDiv.equals("divNomeFuncionarioSubstituido")){ %>
      <input class="input" size="70" name="nomIndicado" value="<%=funcionario[0][0]%>" readonly/>
    <%}
    if(nomDiv.equals("divUnidadeFuncionarioSubstituido")){ %>
      <input class="input" size="81" name="nomUnidadeOrigem" value="<%=funcionario[0][3]%>" readonly/>
    <%}%>
<%}else{
    RequisicaoMensagemControl.enviaMensagemCritica("getDadosFuncionarioSubstituido.jsp", "Não foi encontrado nenhum colaborador com a chapa informada! <br><b>Chapa:</b> " + chapa, (Usuario) session.getAttribute("usuario"));
  %>
  <font color="Red">Dados não encontrados!</font>
  <input type="HIDDEN" name="nomIndicado" value="0"/>
<%}%>