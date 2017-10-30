<%  session.setAttribute("root","../../../../"); %>
<%@ page errorPage="../../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:include page="../../../../template/cabecalho.jsp"/>

<% 
   //-- Objetos Control
   GrupoNecUsuarioControl grupoNecUsuarioControl = new GrupoNecUsuarioControl();
   
   //-- Objetos
   GrupoNecUsuario[] grupoNecUsuario = grupoNecUsuarioControl.getGrupoNecUsuarios();
%>

<BR>
<script language="javaScript">
  function cadastrar(){
      window.location = "formulario.jsp";
  }  
  //--
  function editar(idParametro){
      window.location = "formulario.jsp?chapa=" + idParametro;
  } 
  //--
  function excluir(idParametro){
      if(confirm("Deseja excluir realmente este grupo de acesso?"))
         window.location = "excluir.jsp?chapa=" + idParametro;
  } 
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr>
      <td colspan="2"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
        <STRONG>&nbsp;&nbsp;USUÁRIO DE ACESSO - NEC (NÚCLEO DE EDUCAÇÃO CORPORATIVA)</STRONG>
      </td>
    </tr>
    <tr class="tdintranet2">
      <td height="26" align="left" width="80%">
        &nbsp;&nbsp;&nbsp;Cadastro dos usuários do NEC no workflow de aprovação.
      </td>
      <td width="15%" height="23" class="tdintranet2" background="<%=request.getContextPath()%>/imagens/chapeu_fim_610.gif" align="right" >
        <a href="javaScript:cadastrar();">                  
        <img src="<%= request.getContextPath()%>/imagens/bt_novo.gif" border="0" alt="Clique para adicionar uma nova Tabela."/>
        </a>&nbsp;
      </td>
    </tr>
    <tr>
      <td height="3" class="tdintranet2" colspan="2">
      </td>
    </tr>        
    <tr>
      <td height="3" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' width="100%" colspan="2">
      </td>
    </tr>               
    <tr>
      <td height="20" class="tdCabecalho" colspan="2">
      </td>
    </tr>                    
  </table>

<%-- IMPRESSÃO DOS VALORES --%>       
 <%if(grupoNecUsuario != null && grupoNecUsuario.length > 0){%>
    <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr >
      <td align="left"   height="25"  class="tdTemplateLista" width="10%"><STRONG>&nbsp;&nbsp;&nbsp;Chapa</STRONG></td>
      <td align="left"   height="25"  class="tdTemplateLista" width="80%"><STRONG>&nbsp;&nbsp;&nbsp;Nome</STRONG></td>
      <td align="center" height="25"  class="tdTemplateLista" width="10%"><STRONG>Opções</STRONG></td>
    </tr>
    <% 
      String classCSS = "borderintranet";
      for(int i=0; i<grupoNecUsuario.length; i++){
        classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
    %>
        <tr >
          <td align="left"   height="25" class="<%= classCSS %>" width="10%">&nbsp;&nbsp;<%=grupoNecUsuario[i].getChapa()%></td>
          <td align="left"   height="25" class="<%= classCSS %>" width="80%">&nbsp;&nbsp;<%=grupoNecUsuario[i].getNomUsuario()%></td>
          <td align="center" height="25" class="<%= classCSS %>" width="10%">
            <a href="javaScript:editar(<%=grupoNecUsuario[i].getChapa()%>);">
              <img src="<%= request.getContextPath()%>/imagens/ico-pag.gif" border="0" alt="Editar"/>
            </a>
            <a href="javaScript:excluir(<%=grupoNecUsuario[i].getChapa()%>);">
              <img src="<%= request.getContextPath()%>/imagens/excluir.gif" border="0" alt="Excluir"/>
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

<jsp:include page="../../../../template/fimTemplateIntranet.jsp"/>