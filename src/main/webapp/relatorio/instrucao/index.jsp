<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.TabelaSalarial" %>

<jsp:include page="../../template/cabecalho.jsp"/>

<%
  //-- Carregando os combos
  TabelaSalarial[] tabelaSalarial = new TabelaSalarialControl().getTabelaSalarials();
  String[][] comboCargo = new InstrucaoControl().getComboCargo(0);  
  String[][] comboUnidade = new RequisicaoControl().getComboUnidade();
%>

<script language="javaScript">
  function pesquisar(){
	var parametros  = 'codInstrucao=0';
		parametros += '&codTabela=' + document.getElementById('codTabela').value;
		parametros += '&codCargo=' + document.getElementById('codCargo').value;
		parametros += '&cota=' + document.getElementById('cota').value;
		parametros += '&codUnidade=' + document.getElementById('codUnidade').value;

	var  w, h, left, top;
	
	w = window.screen.width;
	h = window.screen.height;    
	    
	left =(w-900)/2;
	top  =(h-600)/2;
	    	   		  
	window.open('report.jsp?' + parametros,'Relatório','left='+left+',top='+top+',toolbar=no,width=900,height=600,scrollbars=yes');
  }
</script>

<center>
<br>
<form name="frm" action="index.jsp" method="POST" >
   <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">  
    <tr>
      <td>
        <table border="0" width="610" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="3"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
             <STRONG>&nbsp;&nbsp;RELATÓRIO - INSTRUÇÃO 04/2011</STRONG>
            </td>
          </tr>  
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Tabela salarial:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
              <select name="codTabela" id="codTabela" class="select" style="width: 450px;">
                <option value="0">SELECIONE</option>
                <%for(int i=0; i<tabelaSalarial.length; i++){%>
                  <option value="<%=tabelaSalarial[i].getCodTabelaSalarial()%>" ><%=tabelaSalarial[i].getDscTabelaSalarial().toUpperCase()%></option>
                <%}%>
              </select>
            </td>					  					
          </tr>             
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Cargo:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="codCargo" id="codCargo" class="select" style="width: 450px;">
                  <option value="0">SELECIONE</option>
                  <%for(int i=0; i<comboCargo.length; i++){%>
                    <option value="<%=comboCargo[i][0]%>" ><%=comboCargo[i][1]%></option>
                  <%}%>
                </select> 
            </td>
          </tr>
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Cota:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="cota" id="cota" class="select" style="width: 450px;">
                  <option value="-1">SELECIONE</option>
                  <%for(int i=0; i<=9; i++){%>
                    <option value="<%=i%>" ><%=i%></option>
                  <%}%>
                </select> 
            </td>
          </tr>          
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Unidade:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="codUnidade" id="codUnidade" class="select" style="width: 450px;">
                  <option value="0">SELECIONE</option>
                  <%for(int i=0; i<comboUnidade.length; i++){%>
                    <option value="<%=comboUnidade[i][0]%>" ><%=comboUnidade[i][0] + " - " + comboUnidade[i][1]%></option>
                  <%}%>
                </select> 
            </td>
          </tr>
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="right">
              <a href="##" onclick="pesquisar();">
                <img src="<%=request.getContextPath()%>/imagens/bt_pesquisar.gif" border="0" hspace="15"/>
              </a>
            </td>
          </tr>           
          <tr>
            <td colspan="2" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
          </tr>                     
        </table>
      </td>
    </tr>        
   </table>
</form>   
<br>
<div id="divListInstrucao">
</div>
</center>
<br>
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>