<%@ page import="br.senac.sp.componente.util.Data" %>

<% Data data = new Data(); %>
<html>
  <head> 
    <meta http-equiv=expires content="Mon, 06 Jan 1990 00:00:01 GMT">
    <meta http-equiv="pragma" content="no-cache">
    <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
    <link href="<%= (String)session.getAttribute("root") %>css/stylesheet.css" rel="STYLESHEET" type="text/css"/>
    <title>Cadastro de Descontos Corporativos.</title>
  </head>
  <script language="javaScript">
    function abreLink(url){
       window.open(url,'link','toolbar=no,width=780,height=560,scrollbars=yes');
    }
  </script>  
  <body>