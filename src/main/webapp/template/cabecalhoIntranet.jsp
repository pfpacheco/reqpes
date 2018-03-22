<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html" charset=UTF-8>

<%
    /**
    autor: Luciano Silva <luciano.csilva@sp.senac.br>
    data:  23/02/2006
           Essa é uma página simples que contém as imagens e mapeamento para montar o cabeçalho do template.
    **/
%>
<script language="JavaScript">
 var codtesteira="348";
function buscaGeral(){
 document.buscageral.keywords.value=document.temp.txt_busca22.value;
 if(codtesteira=="") document.buscageral.testeira.value="348";
 else document.buscageral.testeira.value=codtesteira;

 if(document.buscageral.start.value=="") document.buscageral.start.value="1";
 document.buscageral.submit();
}
</script>
<table width="595" height="58" border="0" cellpadding="0" cellspacing="0">
  <form name="temp" action="javascript:buscaGeral()">
	<tr> 		            
	  <td><img src="http://www.intranet.sp.senac.br/imagens/sobre_menu_new2.gif" width="493" height="26" border="0" usemap="#Map"></td>
	  <td><input name="txt_busca22" type="text" size="16" style="font-family: verdana; color:#000000; font-size: 10px"></td>		            
	  <td><a href="javascript:buscaGeral();"><img src="http://www.intranet.sp.senac.br/imagens/sobre_menu2.gif" width="19" height="26" border="0"></a></td>
	</tr>              
	</form>
	<tr> 
	  <td height="36" colspan="8"><img src="http://www.intranet.sp.senac.br/imagens/menu_superior2009.gif" width="622" height="35" usemap="#mapa_superior2009" border="0"></td>
	</tr>
  </form>
<form method="get" name="buscageral" action="http://www.intranet.sp.senac.br/jsp/search.jsp">
	<input type="hidden" name="newsID" value="DYNAMIC,oracle.br.dataservers.SearchDataServer,selectContent">
  <input type="hidden" name="template" value="576.dwt">
  <input type="hidden" name="context" value="N">
  <input type="hidden" name="keywords" value="">
  <input type="hidden" name="start" value="">
  <input type="hidden" name="testeira" value="">
</form>
<form method="GET" name="formDefault">
	<input type="hidden" name="tab" value="">
	<input type="hidden" name="newsID" value="">
	<input type="hidden" name="subTab" value="">
	<input type="hidden" name="uf" value="">
	<input type="hidden" name="local" value="">
	<input type="hidden" name="testeira" value="">
	<input type="hidden" name="l"> 
	<input type="hidden" name="template"> 
  <input type="hidden" name="unit">
</form>
</table>

<!-- MAP MENU PRINCIPAL -->
<map name="mapa_superior2009" id="mapa_superior2009">
  <!-- PRESIDÊNCIA SUPERINTENDÊNCIA -->
  <area shape="rect" coords="6,4,140,15" href="http://www.intranet.sp.senac.br/jsp/default.jsp?newsID=a2662.htm&destaque=1244&testeira=676&unit=DIREG">
  <!-- GERÊNCIAS FUNCIONAIS -->
  <area shape="rect" coords="151,4,262,15" href="http://www.intranet.sp.senac.br/jsp/default.jsp?template=717.dwt&infog=gerencias_funcionais2009&testeira=346">
  <!-- GERÊNCIA DE DESENVOLVIMENTO -->
  <area shape="rect" coords="277,4,427,15" href="http://www.intranet.sp.senac.br/jsp/default.jsp?template=717.dwt&infog=infografico_gd&testeira=660">
  <!-- GERÊNCIAS OPERAÇÕES -->
  <area shape="rect" coords="437,4,562,15" href="http://www.intranet.sp.senac.br/jsp/default.jsp?template=717.dwt&infog=infografico_go&testeira=661">
  <!-- FALE CONOSCO -->
  <area shape="rect" coords="551,3,617,15" href="http://www.intranet.sp.senac.br/jsp/default.jsp?newsID=a13883.htm&testeira=545&unit=FLC">
  <!-- HOTÉIS -->
  <area shape="rect" coords="574,3,615,16" href="http://www.intranet.sp.senac.br/jsp/default.jsp?template=717.dwt&infog=hoteis2009&testeira=386">
  <!-- CENTRO UNIVERSITÁRIO (CAMPUS SENAC) -->
  <area shape="rect" coords="2,20,118,32" href="http://www.intranet.sp.senac.br/jsp/default.jsp?template=717.dwt&infog=ensino_superior2005&testeira=384">
  <!-- UNIDADES GRANDE SÃO PAULO -->
  <area shape="rect" coords="131,20,271,32" href="http://www.intranet.sp.senac.br/jsp/default.jsp?template=717.dwt&infog=mapa_cidade2006&testeira=721">  
  <!-- UNIDADES INTERIOR -->
  <area shape="rect" coords="289,20,383,32" href="http://www.intranet.sp.senac.br/jsp/default.jsp?template=717.dwt&infog=unidades2006&testeira=722">
  <!-- GAC -->
  <area shape="rect" coords="338,20,507,32" href="http://www.intranet.sp.senac.br/jsp/default.jsp?newsID=a28533.htm&testeira=1156&unit=GAC">
  <!-- EDITORA -->
  <area shape="rect" coords="517,20,556,32" href="http://www.intranet.sp.senac.br/jsp/default.jsp?newsID=a1768.htm&destaque=1245&testeira=387&unit=EDS">
  <!-- BIBLIOTECA -->
  <area shape="rect" coords="565,20,617,32" href="http://www.sp.senac.br/jsp/default.jsp?newsID=a373.htm&testeira=386" target="_blank">
</map>

<!-- MAP SOBRE-MENU -->
<map name="Map">
  <!-- INTERNET -->
  <area shape="rect" coords="1,7,44,20" href="http://www.sp.senac.br/jsp/redir.jsp?url=http://www.sp.senac.br" target="_top">
  <!-- BIBLIOTECA -->
  <area shape="rect" coords="61,6,102,19" href="http://www.intranet.sp.senac.br/jsp/default.jsp?template=463.dwt">
  <!-- AGENDA -->
  <area shape="rect" coords="113,5,199,19" href="http://www.intranet.sp.senac.br/jsp/defaultnocache.jsp?newsID=DYNAMIC,oracle.br.aniversariantes.Aniversariante,selectPesquisa&template=593.dwt&testeira=594">
  <!-- ANIVERSARIANTES -->
  <area shape="rect" coords="213,5,316,19" href="http://www.intranet.sp.senac.br/jsp/priv/default.jsp?template=740.dwt&ALLOW=T">
  <!-- WEBMAIL -->
  <area shape="rect" coords="330,5,379,19" href="http://www.intranet.sp.senac.br/jsp/default.jsp?tab=00002&newsID=a4543.htm&subTab=00061&uf=&local=&testeira=362&l=&template=&unit">
  <!-- HELP DESK -->
  <area shape="rect" coords="393,5,442,19" href="http://www.intranet.sp.senac.br/jsp/default.jsp?template=1043.dwt&testeira=1046&cec=/simples/abertura_chamado_s.aspx?tipo=u">
</map>

<!-- MAP TESTEIRA -->
<map name="testeira">
  <!-- HOME-UNIDADE -->
  <area shape="rect" coords="122,5,613,36" href="http://www.intranet.sp.senac.br/jsp/default.jsp?newsID=a1455.htm&testeira=413">
  <!-- NOTÍCIAS E EVENTOS SOBRE O TEMA -->
  <area shape="rect" coords="454,37,614,50" href="http://www.intranet.sp.senac.br/jsp/default.jsp?start=1&order=datepublished&newsID=DYNAMIC,oracle.br.dataservers.BreakingNewsDataServer,selectBreakingNews&long=T&chanid=1&uf=&themeid=29&sectid=&unit=&template=469.dwt&testeira=413">
</map>

<!-- MAP RODAPÉ -->
<map name="map_rodape" id="map_rodape">
  <!-- EXPEDIENTE -->
  <area shape="rect" coords="70,7,130,22" href="http://www.intranet.sp.senac.br/jsp/default.jsp?newsID=a17590.htm&testeira=860&local=expediente"/>
  <!-- MAPA DO SITE -->
  <area shape="rect" coords="143,7,213,22" href="http://www.intranet.sp.senac.br/jsp/default.jsp?template=575.dwt&testeira=394"/>
</map>