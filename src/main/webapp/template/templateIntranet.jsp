<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html" charset=UTF-8>
<%@ page import="java.util.PropertyResourceBundle"%>
<%@ page import="java.util.ResourceBundle"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Parametro responsável por imprimir o titulo da página na testeira
    String sub = request.getParameter("sub") == null ? "" : request.getParameter("sub");
	ResourceBundle main = PropertyResourceBundle.getBundle("properties.main");
	String admti_path = main.getString("admti_path");
%>
<c:set var="admti_path" value="<%=admti_path%>" scope="session"/>
<html>
  <head>
	<title>Intranet do Senac São Paulo</title>
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