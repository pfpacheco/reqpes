<%@ page contentType="text/html; charset=iso-8859-1" language="java" %>
<%
    // Parametro respons�vel por imprimir o titulo da p�gina na testeira
    String sub = request.getParameter("sub") == null ? "" : request.getParameter("sub");
%>
<html>
  <head>
	<title>Intranet do Senac S�o Paulo</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" href="http://www.intranet.sp.senac.br/css/estilos.css" type="text/css">
	<!-- SCRIPTS -->
	<script language="JavaScript" src="http://www.intranet.sp.senac.br/js/senac.js"></script>	
	<script language="JavaScript">
	  var arrNomeTemas 			= new Array();
	  var arrNomeEspecialidades = new Array();
	  var arrIdEspecialidades 	= new Array();
	  var currIdEspecialidade 	= null;
	  var currNomeTema 			= null;
	  var currNomeEspecialidade = null;
	  var currCourseType 		= null;
	</script>
</head>
<body leftmargin="0" topmargin="0">
<jsp:include page="index.jsp" />
<table width="772" height"100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
	<td width="150" height="100%" valign="top">
	<!-- INICIO CABECALHO -->
		<table align="right" border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
			<tr valign="top">
				<td align="center" width="100%" height="100%"><!---// //---><!--- INICIO TESTEIRA ---><!---// //--->
 			<!---// INICIO CONTEUDO //--->
 	  <table width="620" border="0" align="center" cellpadding="0" cellspacing="0">
         <tr>
           <td valign="middle" align="left">
             <jsp:include page="menu.jsp"/>
           </td>
         </tr> 
      </table>		