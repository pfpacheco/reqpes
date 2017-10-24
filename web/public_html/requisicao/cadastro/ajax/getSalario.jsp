<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
  //-- Objetos de controle
  RequisicaoControl requisicaoControl = new RequisicaoControl();
  
  //-- Parametros de página
  String codUnidade = (request.getParameter("P_COD_UNIDADE")==null)?"":request.getParameter("P_COD_UNIDADE");
  String nomDiv     = (request.getParameter("P_DIV")==null)?"":request.getParameter("P_DIV").trim();
  String codCargo   = (request.getParameter("P_COD_CARGO")==null)?"":request.getParameter("P_COD_CARGO");
  String cota       = (request.getParameter("P_COTA")==null)?"0":(request.getParameter("P_COTA").trim().equals(""))?"0":request.getParameter("P_COTA").trim();
  
  //-- Objetos
  StringBuffer sql = new StringBuffer();
  String[][] dadosSalario = null;
  
  //-- Query de pesquisa
  sql.append(" SELECT LPAD((TSNS.POSICAO_STEP - 1),2,'0') AS STEP ");
  sql.append("       ,TSNS.STEP AS NADA ");
  sql.append("       ,TRIM(TO_CHAR(TSNS.VALOR_STEP, '999999D99')) SALARIO ");
  sql.append(" FROM   UNIORG_CARGO_TAB_NIVEL   UCTN ");
  sql.append("       ,TAB_SALARIAL_NIVEL_STEPS TSNS ");
  sql.append("       ,UNIDADES_ORGANIZACIONAIS UO ");
  sql.append("       ,UNIDADES_ORGANIZACIONAIS UO1 ");
  sql.append(" WHERE  UO.CODIGO LIKE '"+codUnidade+"%' ");
  sql.append(" AND    UCTN.ID_CARGO = "+codCargo);
  sql.append(" AND    (UCTN.COD_UNIORG = UO.CODIGO_PAI OR UCTN.COD_UNIORG = 'SENAC') ");
  sql.append(" AND    UO.NIVEL = 2  ");
  sql.append(" AND    UO.DATA_ENCERRAMENTO IS NULL ");    
  sql.append(" AND    UCTN.TAB_SALARIAL = TSNS.TAB_SALARIAL ");
  sql.append(" AND    UCTN.NIVEL = TSNS.NIVEL ");
  sql.append(" AND    UO.CODIGO_PAI = UO1.CODIGO ");
  sql.append(" AND    UO1.DATA_ENCERRAMENTO IS NULL ");
  sql.append(" AND    LPAD((TSNS.POSICAO_STEP - 1),2,'0') = "+cota);
  sql.append(" ORDER  BY LPAD((TSNS.POSICAO_STEP - 1),2,'0') ");

  //-- Executando o resultado da consulta
  dadosSalario = requisicaoControl.getMatriz(sql.toString());    
%>

<%if(dadosSalario.length > 0){%>
   <input class="input" size="15" name="salario" id="salario" value="<%=dadosSalario[0][2]%>" readonly/>
   &nbsp;&nbsp;<strong>Carga horária semanal:</strong>
<%}else{
    //-- Enviando e-mail de crítica
    RequisicaoMensagemControl.enviaMensagemCritica("getSalario.jsp", "Nenhum salário associado a esta cota! <br><b>Unidade:</b> "+codUnidade+"<br><b>Cargo:</b> "+codCargo+"<br><b>Cota:</b> "+cota, (Usuario) session.getAttribute("usuario"));
    %>    
  <font color="Red">Nenhum salário<br>associado a esta cota!</font>  
<%}%>