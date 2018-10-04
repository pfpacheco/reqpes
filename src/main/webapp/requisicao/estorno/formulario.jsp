<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>

<jsp:include page="../../template/cabecalho.jsp"/>

<% 
  //-- Parametros de página
  int codRequisicao = (request.getParameter("codRequisicao")==null)?0:Integer.parseInt(request.getParameter("codRequisicao"));
 
  //-- Resgatando os dados da requisição
  Requisicao requisicao = new RequisicaoControl().getRequisicao(codRequisicao);
%>

<script language="JavaScript" src="<%=request.getContextPath()%>/js/formulario.js" charset="utf-8" type="text/javascript"></script> 
<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js"  charset="utf-8"  type="text/javascript"></script> 
<script language="JavaScript" src="<%=request.getContextPath()%>/js/regrasRequisicao.js" type="text/javascript" charset="utf-8"></script>
<script language="javaScript">
  //--
  function estornar(parametro){
    if(validarRadio(document.frmRequisicao.indTipoEstorno,"Informe o tipo de estorno!"))
      if(confirm("Deseja realmente estornar esta RP?")){
        document.frmRequisicao.submit();
      }  
  }    
  //--
  function voltar(){
    window.history.go(-1);
  }      
</script>

<center>
<br>
<form name="frmRequisicao" action="estornar.jsp" method="POST">  
  <input type="HIDDEN" name="codRequisicao" value="<%=codRequisicao%>"/>
  <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">      
    <tr>
      <td colspan="2"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
       <STRONG>&nbsp;&nbsp;ESTORNO DE REQUISIÇÕES</STRONG>
      </td>
    </tr>  
    <tr>
      <td height="25" align="right" class="tdintranet2" width="20%">
        <strong>Número da RP:&nbsp;</strong>
      </td>
      <td height="25" align="left" class="tdintranet2">
        <%=requisicao.getCodRequisicao()%>
      </td>					  					
    </tr>                    
    <tr>
      <td height="25"  align="right" class="tdintranet2">
        <strong>Cargo:&nbsp;</strong>
      </td>
      <td height="25" align="left" class="tdintranet2">
        <%=requisicao.getDscCargo()%>
      </td>					  					
    </tr>             
    <tr>
      <td height="25"  align="right" class="tdintranet2">
        <strong>Unidade:&nbsp;</strong>
      </td>
      <td height="25" align="left" class="tdintranet2">
        <%=requisicao.getDscUnidade()%>
      </td>
    </tr> 
    <tr>
      <td height="25"  align="right" class="tdintranet2">
        <strong>Tipo de estorno:&nbsp;</strong>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      </td>
      <td height="25" align="left" class="tdintranet2">
        <input type="radio" name="indTipoEstorno" value="S">Simples (retorna a RP ao nível anterior no workflow de aprovação)
        <br>
        <input type="radio" name="indTipoEstorno" value="R">Revisão (retorna a RP para homologação GEP-AP&amp;B)
      </td>
    </tr> 
    <tr>
      <td colspan="2" height="35" class="tdIntranet2" align="right">
        <a href="javascript:voltar();">
          <img src="<%=request.getContextPath()%>/imagens/bt_voltar.gif" border="0" title="Voltar"/>
        </a>
        <a href="javascript:estornar();">
          <img src="<%=request.getContextPath()%>/imagens/bt_submeter.gif" border="0" title="Estornar" hspace="15"/>
        </a>      
      </td>
    </tr>           
    <tr>
      <td colspan="2" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
    </tr>            
   </table>
</form>
<br>
</center>

<jsp:include page="../../template/fimTemplateIntranet.jsp"/>