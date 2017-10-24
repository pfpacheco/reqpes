<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.TabelaSalarialControl" %>
<%@ page import="br.senac.sp.reqpes.model.TabelaSalarial" %>

<jsp:include page="../../../template/cabecalho.jsp"/>

<% 
   //-- Objetos
   TabelaSalarial[] tabelaSalarial = new TabelaSalarialControl().getTabelaSalarials();    
%>

<BR>
<script language="javaScript">
  function cadastrar(){
      window.location = "formulario.jsp";
  }  
  //--
  function editar(idParametro){
      window.location = "formulario.jsp?codTabelaSalarial=" + idParametro;
  } 
  //--
  function excluir(idParametro){
      if(confirm("Deseja excluir realmente esta tabela salarial?"))
         window.location = "excluir.jsp?codTabelaSalarial=" + idParametro;
  } 
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr>
      <td colspan="4"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
        <STRONG>&nbsp;&nbsp;TABELA SALARIAL</STRONG>
      </td>
        <tr class="tdintranet2">
          <td height="26" align="left" width="80%">
            &nbsp;&nbsp;&nbsp;Cadastro das Tabelas Salariais dos cargos.
          </td>
          <td width="15%" height="23" class="tdintranet2" background="<%=request.getContextPath()%>/imagens/chapeu_fim_610.gif" colspan="3" align="right" >
            <a href="javaScript:cadastrar();">                  
            <img src="<%= request.getContextPath()%>/imagens/bt_novo.gif" border="0" alt="Clique para adicionar uma nova Tabela."/>
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
                <td height="3" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' width="100%">
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
 <%if(tabelaSalarial != null && tabelaSalarial.length > 0){%>
    <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr >
      <td align="left"   height="25"  class="tdTemplateLista" width="60%"><STRONG>&nbsp;&nbsp;&nbsp;Tabela</STRONG></td>
      <td align="center" height="25"  class="tdTemplateLista" width="8%"><STRONG>&nbsp;Ativo</STRONG></td>
      <td align="center" height="25"  class="tdTemplateLista" width="12%"><STRONG>&nbsp;Área/Subárea</STRONG></td>
      <td align="center" height="25"  class="tdTemplateLista" width="10%"><STRONG>Opções</STRONG></td>
    </tr>
    <% 
      String classCSS = "borderintranet";
      for(int i=0; i<tabelaSalarial.length; i++){
        classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
    %>
        <tr >
          <td align="left" height="25" class="<%= classCSS %>" width="60%">&nbsp;&nbsp;<%=tabelaSalarial[i].getDscTabelaSalarial()%></td>
          <td align="center" height="25" class="<%= classCSS %>" width="8%">&nbsp;<%=(tabelaSalarial[i].getIndAtivo().equals("S"))?"SIM":"NÃO"%></td>
          <td align="center" height="25" class="<%= classCSS %>" width="12%">&nbsp;<%=(tabelaSalarial[i].getIndExibeAreaSubarea().equals("S"))?"SIM":"NÃO"%></td>
          <td align="center" height="25" class="<%= classCSS %>" width="10%">
            <a href="javaScript:editar(<%=tabelaSalarial[i].getCodTabelaSalarial()%>);">
              <img src="<%= request.getContextPath()%>/imagens/ico-pag.gif" align="absmiddle" border="0" alt="Editar"/>
            </a>
            <a href="javaScript:excluir(<%=tabelaSalarial[i].getCodTabelaSalarial()%>);">
              <img src="<%= request.getContextPath()%>/imagens/excluir.gif" align="absmiddle" border="0" alt="Excluir"/>
            </a>
          </td>
        </tr>
    <%}%>
        <tr>
            <td colspan="4"  height="8" class="tdintranet2"></td>
        </tr>    
        <tr>
            <td colspan="4"  height="3" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif'></td>
        </tr> 
    </table>
  <%}%>     
</center> 
<br>

<jsp:include page="../../../template/fimTemplateIntranet.jsp"/>