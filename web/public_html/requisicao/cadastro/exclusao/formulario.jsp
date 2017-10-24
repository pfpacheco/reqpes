<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>

<jsp:include page="../../../template/cabecalho.jsp"/>

<%        
   //-- Parametros de página
   int codRequisicao   = (request.getParameter("codRequisicao") == null)?0:Integer.parseInt(request.getParameter("codRequisicao"));
   Boolean indWorkFlow = (request.getParameter("indWorkFlow") == null)?Boolean.FALSE:Boolean.valueOf(request.getParameter("indWorkFlow").trim());
%>

<BR/>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/formulario.js" type="text/javascript"></script>  
<script language="javaScript">
  function cadastrar(){
    if(decode(document.frm.dscMotivoSolicitacao,"Informe o motivo da exclusão da Requisição!",0,"",null)){
        document.frm.submit();
    }
  }  
</script>

<center>
  <form name="frm" method="POST" action="excluir.jsp">
  <input type="HIDDEN" name="codRequisicao" value="<%=codRequisicao%>">
  <input type="HIDDEN" name="indWorkFlow"   value="<%=indWorkFlow.booleanValue()%>">
    <table border="0" cellpadding="0" cellspacing="0" width="610" >
      <tr>
        <td colspan="2"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
          <STRONG>&nbsp;&nbsp;CANCELAMENTO DE REQUISIÇÕES</STRONG>
        </td>
	  </tr>
	  <tr>
		<td class="tdintranet2" align="center">
		<br>
		 <strong>Motivo do cancelamento da requisição nº <%=codRequisicao%>&nbsp;</strong>(Limite 2000 caracteres)&nbsp;
		  <input type="text" name="qtdMotivoSolicitacao" class="label" readonly="readonly" value="0" size="4" align="middle">              
		</td>
	  </tr>
	  <tr>
		<td class="tdintranet2" align="center">
		  <textarea cols="80" rows="6" name="dscMotivoSolicitacao"
					onKeyDown="limitarCaracteres(this,document.frm.qtdMotivoSolicitacao,2000);"
					onKeyUP  ="limitarCaracteres(this,document.frm.qtdMotivoSolicitacao,2000);" ></textarea>
		</td>
	  </tr>    
	  <tr>
		<td height="10" class="tdintranet2" colspan="2"  > </td>
	  </tr>                              
	  <tr>
		<td height="23" class="tdintranet2" colspan="2" align="center">
		  <a href="javaScript:cadastrar();">                  
			<img src="<%=request.getContextPath()%>/imagens/bt_submeter.gif" border="0" alt="Submeter cancelamento"/>
		  </a>&nbsp;&nbsp;
		  <a href="<%=(indWorkFlow.booleanValue())?request.getContextPath()+"/requisicao/aprovar/index.jsp":"index.jsp"%>">
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

<jsp:include page="../../../template/fimTemplateIntranet.jsp"/>