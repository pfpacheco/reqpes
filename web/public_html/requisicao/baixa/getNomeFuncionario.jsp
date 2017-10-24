<%@ page import="br.senac.sp.reqpes.Control.RequisicaoControl" %>
<%@ page errorPage="../../error/error.jsp" %>

<%
    //-- Objetos de controle
    RequisicaoControl requisicaoControl = new RequisicaoControl();
    
    //-- Parametros de página
    String chapa  = (request.getParameter("P_CHAPA")==null)?"":request.getParameter("P_CHAPA").trim();
    String nomDiv = (request.getParameter("P_DIV")==null)?"":request.getParameter("P_DIV").trim();
    
    //-- Objetos
    StringBuffer sql = new StringBuffer();
    String[][] funcionario = null;
    boolean invalido = false;
    
    //-- Query de pesquisa
    if (chapa.equals("")) chapa = "0";
    sql.append(" SELECT F.NOME ");
    sql.append("       ,LPAD(F.COD_UNIORG,3,'0') COD_UNIDADE ");
    sql.append("       ,F.TIPO_COLAB ");
    sql.append("       ,F.ATIVO ");
    sql.append(" FROM   FUNCIONARIOS F ");
    sql.append(" WHERE  F.ID = " + chapa);
  
    //-- Executando o resultado da consulta
    funcionario = requisicaoControl.getMatriz(sql.toString());       
%>
<%if(funcionario.length > 0 && funcionario[0][2].equals("P")){
    invalido = true; %>
    <font color="Red">O funcionário deve ser CLT!</font>
    <input type="HIDDEN" name="nomFuncionario" value="-1"/>
    <input type="HIDDEN" name="codUnidadeFuncSelecionado" value="0"/>
<%}%>

<%--
<%if(funcionario.length > 0 && !funcionario[0][3].equals("A")){
    invalido = true; %>
    <font color="Red">O funcionário está inativo!</font>
    <input type="HIDDEN" name="nomFuncionario" value="-1"/>
    <input type="HIDDEN" name="codUnidadeFuncSelecionado" value="0"/>
<%}%>
--%>

<%if(funcionario.length > 0 && !invalido){%>
    <input class="input" size="70" name="nomFuncionario" value="<%=funcionario[0][0]%>" readonly/>
    <input type="HIDDEN" name="codUnidadeFuncSelecionado" value="<%=funcionario[0][1]%>"/>
<%}else{
      if(!invalido){%>
        <font color="Red">Funcionário não encontrado!</font>
        <input type="HIDDEN" name="nomFuncionario" value="-1"/>
        <input type="HIDDEN" name="codUnidadeFuncSelecionado" value="0"/>
    <%}
  }%>