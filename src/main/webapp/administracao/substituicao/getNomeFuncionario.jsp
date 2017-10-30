<%@ page import="br.senac.sp.reqpes.Control.SubstituicaoGerenteControl" %>
<%@ page errorPage="../../error/error.jsp" %>

<%
    //-- Objetos de controle
    SubstituicaoGerenteControl substituicaoGerenteControl = new SubstituicaoGerenteControl();
    
    //-- Parametros de página
    String chapa  = (request.getParameter("P_CHAPA")==null)?"":request.getParameter("P_CHAPA").trim();
    
    //-- Objetos
    String[][] funcionario = null;
     
    //-- Executando o resultado da consulta
    funcionario = substituicaoGerenteControl.getMatriz(" SELECT F.NOME FROM FUNCIONARIOS F WHERE F.ID = "+ chapa +" AND F.ATIVO = 'A' ");
%>

<%if(funcionario.length > 0){%>
    <input class="label" size="70" name="nomFuncionario" value="<%=funcionario[0][0]%>" readonly/>
<%}else{%>
    <font color="Red">Funcionário não encontrado!</font>
    <input type="HIDDEN" name="nomFuncionario" value="0"/>
<%}%>