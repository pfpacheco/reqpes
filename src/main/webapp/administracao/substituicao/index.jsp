<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<jsp:include page="../../template/cabecalho.jsp"/>

<% 
   //-- Objetos Control
   SubstituicaoGerenteControl substituicaoGerenteControl = new SubstituicaoGerenteControl();
   
   //-- Parametros de página
   String codUnidade = request.getParameter("codUnidade");
   
   //-- Objetos
   SimpleDateFormat sf = new SimpleDateFormat("dd/MM/yyyy");
   String[][] comboUnidades = null;
   SubstituicaoGerente[] substituicaoGerente = null;
   
   //-- Carregando o combo de unidades
   comboUnidades = substituicaoGerenteControl.getComboUnidades();
   
   //-- Carregando as substituições existentes da unidade selecionada
   if(codUnidade != null){
      substituicaoGerente = substituicaoGerenteControl.getSubstituicaoGerentes(" AND R.UNOR_COD = '"+codUnidade+"' ");
   }
%>

<BR/>
<script language="javaScript">
  function editar(codUnidade){
      document.frm.isAlteracaoGerente.value = 'N';
      document.frm.action = "formulario.jsp?codUnidade="+codUnidade;
      document.frm.submit();
  }  
  //--
  function novo(codUnidade){
      document.frm.isAlteracaoGerente.value = 'S';
      document.frm.action = "formulario.jsp?codUnidade="+codUnidade;
      document.frm.submit();
  }  
  //--
  function pesquisar(){
    document.frm.submit();
  }
</script>

<center>
<form action="index.jsp" name="frm" method="POST">
  <input type="hidden" name="isAlteracaoGerente" value="0">
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
      <tr>
        <td colspan="2" height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
          <STRONG>&nbsp;&nbsp;SUBSTITUIÇÃO INFORMAL DE GERENTES</STRONG>
        </td>
      </tr>
      <tr class="tdintranet2">
        <td height="8" align="left" colspan="2"></td>
      </tr>
      <tr class="tdintranet2">
        <td height="25" align="right" width="15%">
          <STRONG>Unidade:&nbsp;</STRONG>
        </td>
        <td height="25" align="left" width="95%">
          <select name="codUnidade" class="select" style="width: 460px;" onchange="pesquisar();">
            <option value="0">SELECIONE</option>
            <%for(int i=0; i<comboUnidades.length; i++){%>
                <option value="<%=comboUnidades[i][0]%>" <%=(comboUnidades[i][0].equals(codUnidade))?" SELECTED":""%>><%=comboUnidades[i][1]%></option>
            <%}%>
          </select>
        </td>          
      </tr>
      <tr class="tdintranet2">
        <td height="8" align="left" colspan="2"></td>
      </tr>
      <tr>
        <td height="3" colspan="2" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif'>
        </td>
      </tr>                   
  </table>
</form>
<br>
  
<%-- IMPRESSÃO DOS VALORES --%>       
<%if(substituicaoGerente != null && substituicaoGerente.length > 0){%>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr>
      <td align="center" height="25" class="tdTemplateLista" width="10%"><STRONG>Chapa</STRONG></td>
      <td align="left"   height="25" class="tdTemplateLista" width="60%"><STRONG>&nbsp;Nome</STRONG></td>
      <td align="center" height="25" class="tdTemplateLista" width="30%"><STRONG>Vigência</STRONG></td>
    </tr>
    <% 
      String classCSS = "borderintranet";
      for(int i=0;i<substituicaoGerente.length;i++){
        classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
    %>
        <tr >
          <td align="center" height="25" class="<%=classCSS%>" width="10%"><%=substituicaoGerente[i].getChapa()%></td>
          <td align="left"   height="25" class="<%=classCSS%>" width="60%">&nbsp;<%=substituicaoGerente[i].getNomGerente()%></td>
          <td align="center" height="25" class="<%=classCSS%>" width="40%"><%=sf.format(substituicaoGerente[i].getDatInicioVigencia())+" à "+sf.format(substituicaoGerente[i].getDatFimVigencia())%></td>
        </tr>
    <%}%>
        <tr>
            <td align="right" colspan="3" height="25" class="tdintranet2">
              <a href="javaScript:editar('<%=codUnidade%>');">
                <img src="<%=request.getContextPath()%>/imagens/bt_atualizar.gif" title="Atualizar os dados do gerente atual" border="0">
              </a>
              <a href="javaScript:novo('<%=codUnidade%>');">
                <img src="<%=request.getContextPath()%>/imagens/bt_novo.gif" title="Incluir novo gerente" border="0" hspace="16">
              </a>              
            </td>
        </tr>    
        <tr>
            <td colspan="3"  height="3" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif'></td>
        </tr> 
    </table>
  <%}%>     
</center> 
<br>

<jsp:include page="../../template/fimTemplateIntranet.jsp"/>