<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>

<jsp:include page="../../template/cabecalho.jsp"/>

<%        
   //-- Parametros de página
   int codRequisicao = (request.getParameter("codRequisicao") == null)?0:Integer.parseInt(request.getParameter("codRequisicao"));
   int nivelWorkFlow = (request.getParameter("nivelWorkFlow") == null)?0:Integer.parseInt(request.getParameter("nivelWorkFlow"));
%>

<BR/>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/formulario.js" type="text/javascript"></script>  
<script language="javaScript">
  function submeter(){
    if(decode(document.frm.dscMotivo,"Informe o motivo da reprovação da Requisição!",0,"",null)){
        document.frm.submit();
    }
  }  
</script>

<center>
<form name="frm" method="POST" action="reprovar.jsp">
  <input type="HIDDEN" name="codRequisicao" value="<%=codRequisicao%>">
  <input type="HIDDEN" name="nivelWorkFlow" value="<%=nivelWorkFlow%>">
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
      <tr>
        <td colspan="2"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
          <STRONG>&nbsp;&nbsp;REPROVAÇÃO DE REQUISIÇÕES</STRONG>
        </td>
	  </tr>
	  <tr>
		<td class="tdintranet2" align="center">
		<br>
		 <strong>Motivo da reprovação da requisição nº <%=codRequisicao%>&nbsp;</strong>(Limite 2000 caracteres)&nbsp;
		  <input type="text" name="qtdMotivoSolicitacao" class="label" readonly="readonly" value="0" size="4" align="middle">              
		</td>
	  </tr>
	  <tr>
		<td class="tdintranet2" align="center">
		  <textarea cols="80" rows="6" name="dscMotivo"
					onKeyDown="limitarCaracteres(this,document.frm.qtdMotivoSolicitacao,2000);"
					onKeyUP  ="limitarCaracteres(this,document.frm.qtdMotivoSolicitacao,2000);" ></textarea>
		</td>
	  </tr>    
	  <tr>
		<td height="10" class="tdintranet2" colspan="2"  > </td>
	  </tr>                              
	  <tr>
		<td height="23" class="tdintranet2" colspan="2" align="center">
		  <a href="javaScript:submeter();">                  
			<img src="<%= request.getContextPath()%>/imagens/bt_submeter.gif" border="0" alt="Submeter reprovação"/>
		  </a>&nbsp;&nbsp;
		  <a href="<%=request.getContextPath()%>/requisicao/aprovar/index.jsp">                  
			<img src="<%= request.getContextPath()%>/imagens/bt_voltar.gif" border="0" alt="Voltar"/>
		  </a>                    
		</td>
	  </tr>        
	  <tr>
		<td height="3" colspan="2" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif'></td>
	  </tr>                                  
  </table>
</form>    
</center> 
<br>

<jsp:include page="../../template/fimTemplateIntranet.jsp"/>