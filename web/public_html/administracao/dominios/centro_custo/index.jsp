<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.reqpes.Control.CentroCustoControl" %>
<%@ page import="br.senac.sp.reqpes.model.CentroCusto" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>

<jsp:include page="../../../template/cabecalho.jsp"/>

<% 
   CentroCustoControl ccControl = new CentroCustoControl();
   Usuario usuario = (Usuario) session.getAttribute("usuario");
   Iterator it = null;
   CentroCusto cc = null;
   
   List lstCC1 = ccControl.getSegmentos(1, usuario);
   List lstCC2 = ccControl.getSegmentos(2, usuario);
   List lstCC3 = ccControl.getSegmentos(3, usuario);
   List lstCC4 = ccControl.getSegmentos(4, usuario);
   List lstCC5 = ccControl.getSegmentos(5, usuario);
   List lstCC6 = ccControl.getSegmentos(6, usuario);
   List lstCC7 = ccControl.getSegmentos(7, usuario);
%>

<br>
<script language="javaScript" src="../../../js/formulario.js"></script>
<script language="javaScript" src="../../../js/regrasRequisicao.js"></script>
<script language="javaScript" src="../../../js/ajaxItens.js"></script>
<script language="javaScript">
	function validar(){
	  if(decode(document.getElementById('segmento3'),"Selecione o segmento Uniorg Destino!",-1,"",null))
		if(decode(document.getElementById('segmento4'),"Selecione o segmento Área / Sub-área!",-1,"",null))
		  if(decode(document.getElementById('segmento5'),"Selecione o segmento Serviço / Produto!",-1,"",null))
		    if(decode(document.getElementById('segmento6'),"Selecione o segmento Especificação!",-1,"",null))
			  if(decode(document.getElementById('segmento7'),"Selecione o segmento Modalidade!",-1,"",null))
				 getIdCodeCombination(document.getElementById('segmento1').value
									 ,document.getElementById('segmento2').value
									 ,document.getElementById('segmento3').value
									 ,document.getElementById('segmento4').value
									 ,document.getElementById('segmento5').value
									 ,document.getElementById('segmento6').value
									 ,document.getElementById('segmento7').value);
	}
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr>
      <td colspan="2" height="18" class="tdCabecalho" background="../../../imagens/tit_item.gif">
        <STRONG>&nbsp;&nbsp;CADASTRO DE COMBINAÇÃO DE CENTRO DE CUSTO (ID CODE COMBINATION)</STRONG>
      </td>
    </tr>
    <tr class="tdintranet2">
      <td colspan="2">&nbsp;</td>
    </tr>                     
    <tr>
      <td height="25" width="20%" align="right" class="tdintranet2">
        <strong>Empresa:&nbsp;</strong>
      </td>
      <td height="25" width="80%" align="left" class="tdintranet2">
          <select name="segmento1" id="segmento1" class="select" style="width: 450px;">
	          <%
	            it = lstCC1.iterator();
	          	while (it.hasNext()) {
	          		cc = (CentroCusto) it.next();
	          		out.print("<option value=\""+ cc.getCodSegmento() +"\">"+ cc.getDscSegmento() +"</option>");
	          	}	          
	          %>
          </select>
      </td>					  					
    </tr>
    <tr>
      <td height="25" width="20%" align="right" class="tdintranet2">
        <strong>Uniorg Emitente:&nbsp;</strong>
      </td>
      <td height="25" width="80%" align="left" class="tdintranet2">             
          <select name="segmento2" id="segmento2" class="select" style="width: 450px;">
	          <%
	            it = lstCC2.iterator();
	          	while (it.hasNext()) {
	          		cc = (CentroCusto) it.next();
	          		out.print("<option value=\""+ cc.getCodSegmento() +"\">"+ cc.getDscSegmento() +"</option>");
	          	}	          
	          %>
          </select>
      </td>						  					
    </tr>           
    <tr>
      <td height="25" width="20%" align="right" class="tdintranet2">
        <strong>Uniorg Destino:&nbsp;</strong>
      </td>
      <td height="25" width="80%" align="left" class="tdintranet2">             
          <select name="segmento3" id="segmento3" class="select" style="width: 450px;">
          	  <option value="-1">SELECIONE</option>
	          <%
	            it = lstCC3.iterator();
	          	while (it.hasNext()) {
	          		cc = (CentroCusto) it.next();
	          		out.print("<option value=\""+ cc.getCodSegmento() +"\">"+ cc.getDscSegmento() +"</option>");
	          	}	          
	          %>
          </select>
      </td>					  					
    </tr>          
    <tr>
      <td height="25" width="20%" align="right" class="tdintranet2">
        <strong>Área / Sub-área:&nbsp;</strong>
      </td>
      <td height="25" width="80%" align="left" class="tdintranet2">             
          <select name="segmento4" id="segmento4" class="select" style="width: 450px;">
          	  <option value="-1">SELECIONE</option>
	          <%
	            it = lstCC4.iterator();
	          	while (it.hasNext()) {
	          		cc = (CentroCusto) it.next();
	          		out.print("<option value=\""+ cc.getCodSegmento() +"\">"+ cc.getDscSegmento() +"</option>");
	          	}	          
	          %>
          </select>
      </td>					  					
    </tr>          
    <tr>
      <td height="25" width="20%" align="right" class="tdintranet2">
        <strong>Serviço / Produto:&nbsp;</strong>
      </td>
      <td height="25" width="80%" align="left" class="tdintranet2">             
          <select name="segmento5" id="segmento5" class="select" style="width: 450px;">
          	  <option value="-1">SELECIONE</option>
	          <%
	            it = lstCC5.iterator();
	          	while (it.hasNext()) {
	          		cc = (CentroCusto) it.next();
	          		out.print("<option value=\""+ cc.getCodSegmento() +"\">"+ cc.getDscSegmento() +"</option>");
	          	}	          
	          %>
          </select>
      </td>					  					
    </tr>          
    <tr>
      <td height="25" width="20%" align="right" class="tdintranet2">
        <strong>Especificação:&nbsp;</strong>
      </td>
      <td height="25" width="80%" align="left" class="tdintranet2">             
          <select name="segmento6" id="segmento6" class="select" style="width: 450px;">
          	  <option value="-1">SELECIONE</option>
	          <%
	            it = lstCC6.iterator();
	          	while (it.hasNext()) {
	          		cc = (CentroCusto) it.next();
	          		out.print("<option value=\""+ cc.getCodSegmento() +"\">"+ cc.getDscSegmento() +"</option>");
	          	}	          
	          %>
          </select>
      </td>					  					
    </tr>          
    <tr>
      <td height="25" width="20%" align="right" class="tdintranet2">
        <strong>Modalidade:&nbsp;</strong>
      </td>
      <td height="25" width="80%" align="left" class="tdintranet2">             
          <select name="segmento7" id="segmento7" class="select" style="width: 450px;">
          	  <option value="-1">SELECIONE</option>
	          <%
	            it = lstCC7.iterator();
	          	while (it.hasNext()) {
	          		cc = (CentroCusto) it.next();
	          		out.print("<option value=\""+ cc.getCodSegmento() +"\">"+ cc.getDscSegmento() +"</option>");
	          	}	          
	          %>
          </select>
      </td>					  					
    </tr>
    <tr class="tdintranet2">
      <td colspan="2" style="text-align:center; padding-top:10px;" class="tdintranet2" background="../../../imagens/chapeu_fim_610.gif">
        <a href="javaScript:validar();">
        	<img src="../../../imagens/bt_submeter.gif" border="0"/>
        </a>
      </td>
    </tr>
    <tr>
      <td colspan="2" height="3" class="tdintranet2"  >
      </td>
    </tr>        
    <tr>
      <td colspan="2" height="3" class="tdCabecalho" background="../../../imagens/fio_azul_end.gif" width="100%">
      </td>
    </tr>               
  </table>
  <input type="hidden" id="idCodeCombination" />
  <div id="divDados" style="display:none;">
  	<table>
  		<tr>
  			<td style="padding-top:15px; color:red; font-weight:bold;" align="center">Combinação validada/criada com sucesso!</td>
  		</tr>
  	</table>
  </div>
</center> 
<br>

<jsp:include page="../../../template/fimTemplateIntranet.jsp"/>