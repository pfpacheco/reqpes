<%@ page import="br.senac.sp.reqpes.Control.RequisicaoControl" %>
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
    sql.append(" SELECT F.NOME FROM FUNCIONARIOS F WHERE F.ID = "+ chapa +" AND F.TIPO_COLAB <> 'P' ");    
  
    //-- Executando o resultado da consulta
    funcionario = requisicaoControl.getMatriz(sql.toString());       
%>

<%if(funcionario.length > 0){%>
    <input class="input" size="53" name="nomFuncionarioSubst" value="<%=funcionario[0][0]%>" readonly/>
<%}else{%>
    <font color="Red">Funcionário não encontrado!</font>
    <input type="HIDDEN" name="nomFuncionarioSubst" value="0"/>
<%}%>