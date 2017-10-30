<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.TipoAvisoControl" %>
<%@ page import="br.senac.sp.reqpes.model.TipoAviso" %>

<jsp:include page="../../../template/cabecalho.jsp"/>

<% 
   //-- Objetos
   TipoAviso[] tipoAviso = new TipoAvisoControl().getTipoAvisos();    
%>

<BR>
<script language="javaScript">
  function cadastrar(){
      window.location = "formulario.jsp";
  }  
  //--
  function editar(idParametro){
      window.location = "formulario.jsp?codTipoAviso=" + idParametro;
  } 
  //--
  function excluir(idParametro){
      if(confirm("Deseja excluir realmente este registro?"))
         window.location = "excluir.jsp?codTipoAviso=" + idParametro;
  } 
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr>
      <td colspan="4"  height="18" class="tdCabecalho" background='../../../imagens/tit_item.gif' >
        <STRONG>&nbsp;&nbsp;TIPO AVISO</STRONG>
      </td>
        <tr class="tdintranet2">
          <td height="18" align="left" width="80%">
            &nbsp;&nbsp;&nbsp;Cadastro de tipo de avisos para cargos.
          </td>
          <td width="15%" height="23" class="tdintranet2" background="../../../imagens/chapeu_fim_610.gif" colspan="3" align="right" >
            <a href="javaScript:cadastrar();">                  
            <img src="../../../imagens/bt_novo.gif" border="0" alt="Clique para adicionar uma nova Tabela."/>
            </a>&nbsp;
          </td>
        </tr>
        <tr>
          <td class="tdintranet2" colspan="5">
            <table border="0" cellpadding="0" cellspacing="0" width="100%" >
              <tr>
                <td height="3" class="tdintranet2"  >
                </td>
              </tr>        
              <tr>
                <td height="3" class="tdCabecalho" background='../../../imagens/fio_azul_end.gif' width="100%">
                </td>
              </tr>               
            </table>
              <tr>
                <td height="20" class="tdCabecalho"  >
                </td>
              </tr>                    
          </td>
        </tr>
    </table>

<%-- IMPRESSÃO DOS VALORES --%>       
 <%if(tipoAviso != null && tipoAviso.length > 0){%>
    <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr >
      <td align="left" height="25"  class="tdTemplateLista" width="45%"><STRONG>&nbsp;&nbsp;&nbsp;Título</STRONG></td>
      <td align="left" height="25"  class="tdTemplateLista" width="23%"><STRONG>&nbsp;Chave de pesquisa</STRONG></td>
      <td align="left" height="25"  class="tdTemplateLista" width="12%"><STRONG>&nbsp;Regime</STRONG></td>
      <td align="center" height="25"  class="tdTemplateLista" width="10%"><STRONG>Opções</STRONG></td>
    </tr>
    <% 
      String classCSS = "borderintranet";
      for(int i=0; i<tipoAviso.length; i++){
        classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
    %>
        <tr >
          <td align="left" height="25" class="<%= classCSS %>" width="45%">&nbsp;&nbsp;<%=tipoAviso[i].getTitulo()%></td>
          <td align="left" height="25" class="<%= classCSS %>" width="23%">&nbsp;<%=tipoAviso[i].getCargoChave()%></td>
          <td align="left" height="25" class="<%= classCSS %>" width="12%">&nbsp;<%=tipoAviso[i].getDscRegime()%></td>
          <td align="center" height="25" class="<%= classCSS %>" width="10%">
            <a href="javaScript:editar(<%=tipoAviso[i].getCodTipoAviso()%>);">
              <img src="../../../imagens/ico-pag.gif" align="absmiddle" border="0" alt="Editar"/>
            </a>
            <a href="javaScript:excluir(<%=tipoAviso[i].getCodTipoAviso()%>);">
              <img src="../../../imagens/excluir.gif" align="absmiddle" border="0" alt="Excluir"/>
            </a>
          </td>
        </tr>
    <%}%>
        <tr>
            <td colspan="4"  height="8" class="tdintranet2"></td>
        </tr>    
        <tr>
            <td colspan="4"  height="3" class="tdCabecalho" background='../../../imagens/fio_azul_end.gif'></td>
        </tr> 
    </table>
  <%}%>     
</center> 
<br>

<jsp:include page="../../../template/fimTemplateIntranet.jsp"/>