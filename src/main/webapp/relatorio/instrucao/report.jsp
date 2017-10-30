<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.util.GerarRelatorioJasper" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.SQLException" %>

<%
  //-- Objetos de sessão
  Usuario usuario = (Usuario)session.getAttribute("usuario");  
  String  msgErr  = null;
  String  nomeArquivo = "REL_INSTRUCAO_"+ usuario.getChapa() +".pdf";
  
  try{
    
    GerarRelatorioJasper gerarRelatorio = new GerarRelatorioJasper();  
    
    String pathJasper = request.getRealPath("/relatorio/ireport/jasper/") + "/"; // Caminho do arquivo jasper
    String pathOutput = request.getRealPath("/relatorio/ireport/gerar/") + "/"; // caminho de saída do relatório
    String pathImagem = request.getRealPath("/imagens") + "/";
    
    gerarRelatorio.setCaminhoJasper(pathJasper + "REL_INSTRUCAO.jasper");
    gerarRelatorio.setCaminhoOutput(pathOutput);
    gerarRelatorio.setNomeArquivo(nomeArquivo);
    
    HashMap parametros = new HashMap();   
    parametros.put("P_IMG_PATH", pathImagem );
    parametros.put("P_COD_INSTRUCAO", request.getParameter("codInstrucao"));
    parametros.put("P_COD_TAB_SALARIAL",request.getParameter("codTabela"));
    parametros.put("P_COD_CARGO",request.getParameter("codCargo"));
    parametros.put("P_COTA", request.getParameter("cota"));
    parametros.put("P_COD_UNIDADE", request.getParameter("codUnidade"));

    gerarRelatorio.setParameters(parametros);
    gerarRelatorio.setTipoRelatorio("PDF");    
    gerarRelatorio.gerar();
    
  }catch(SQLException e){
	  msgErr = "SQL: " + e.getMessage(); 
  }catch(Exception e){
	  msgErr = e.getMessage(); 
  }  
%>

<body onload="focus();">
  <script language=javascript>
  	if (<%=msgErr == null%>) {
    	window.location.href = "<%=request.getContextPath()%>/relatorio/ireport/gerar/<%=nomeArquivo%>";
  	}else{
  	  	alert('Ocorreu o seguinte erro na geração do relatório:\n\n<%=msgErr%>');
  	}
  </script>
</body>