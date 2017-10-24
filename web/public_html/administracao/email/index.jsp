<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.UsuarioAvisoEmailControl" %>
<%@ page import="br.senac.sp.reqpes.model.UsuarioAvisoEmail" %>

<jsp:include page="../../template/cabecalho.jsp"/>

<% 
   UsuarioAvisoEmail[] usuarioAvisoEmail = new UsuarioAvisoEmailControl().getUsuarioAvisoEmails();    
%>

<BR/>
<script language="javaScript">
  function cadastrar(){
    window.location = "formulario.jsp";
  }  
  //--
  function excluir(chapa){
    if(confirm("Deseja excluir realmente este usuário da lista de e-mail com cópia?"))
       window.location = "excluir.jsp?chapa=" + chapa;
  } 
  //--
  function editar(chapa){
    window.location = "formulario.jsp?chapa=" + chapa;
  } 
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr>
      <td colspan="2" height="18" class="tdCabecalho" background='../../imagens/tit_item.gif' >
        <STRONG>&nbsp;&nbsp;CADASTRO DE USUÁRIOS</STRONG>
      </td>
    </tr>
    <tr class="tdintranet2">
      <td height="26" align="left" width="85%">
        &nbsp;&nbsp;&nbsp;Cadastro de usuários para recebimento de cópias de e-mails de requisições.
      </td>
      <td width="15%" height="23" class="tdintranet2" background="<%=request.getContextPath()%>/imagens/chapeu_fim_610.gif" align="right" >
        <a href="javaScript:cadastrar();">                  
        <img src="../../imagens/bt_novo.gif" border="0" alt="Clique para adicionar um novo usuário da GEP."/>
        </a>&nbsp;
      </td>
    </tr>
    <tr>
      <td colspan="2" height="3" class="tdintranet2"  >
      </td>
    </tr>        
    <tr>
      <td colspan="2" height="3" class="tdCabecalho" background='../../imagens/fio_azul_end.gif' width="100%">
      </td>
    </tr>               
    <tr>
      <td colspan="2" height="20" class="tdCabecalho"  >
      </td>
    </tr>                    
 </table>

<%-- IMPRESSÃO DOS VALORES --%>       
 <%if(usuarioAvisoEmail != null && usuarioAvisoEmail.length > 0){%>
    <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr >
      <td align="left"   height="25"  class="tdTemplateLista" width="10%"><STRONG>&nbsp;&nbsp;&nbsp;Chapa</STRONG></td>
      <td align="left"   height="25"  class="tdTemplateLista" width="40%"><STRONG>&nbsp;Nome</STRONG></td>
      <td align="left"   height="25"  class="tdTemplateLista" width="40%"><STRONG>&nbsp;E-mail</STRONG></td>
      <td align="center" height="25"  class="tdTemplateLista" width="10%"><STRONG>Opção</STRONG></td>
    </tr>
    <% 
      String classCSS = "borderintranet";
      for(int i=0;i<usuarioAvisoEmail.length;i++){
        classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
    %>
        <tr >
          <td align="left" height="25" class="<%= classCSS %>" width="10%">&nbsp;&nbsp;<%=usuarioAvisoEmail[i].getChapa()%></td>
          <td align="left" height="25" class="<%= classCSS %>" width="40%">&nbsp;<%=usuarioAvisoEmail[i].getNome()%></td>
          <td align="left" height="25" class="<%= classCSS %>" width="40%">&nbsp;<%=usuarioAvisoEmail[i].getEmail()%></td>
          <td align="center" height="25" class="<%= classCSS %>" width="10%">
            <a href="javaScript:editar(<%=usuarioAvisoEmail[i].getChapa()%>);">
              <img src="../../imagens/ico-pag.gif" align="middle" border="0" alt="Editar este usuário"/>
            </a>
            <a href="javaScript:excluir(<%=usuarioAvisoEmail[i].getChapa()%>);">
              <img src="../../imagens/excluir.gif" align="middle" border="0" alt="Excluir este usuário"/>
            </a>
          </td>
        </tr>
    <%}%>
        <tr>
            <td colspan="4"  height="8" class="tdintranet2"></td>
        </tr>    
        <tr>
            <td colspan="4"  height="3" class="tdCabecalho" background='../../imagens/fio_azul_end.gif'></td>
        </tr> 
    </table>
  <%}%>     
</center> 
<br>

<jsp:include page="../../template/fimTemplateIntranet.jsp"/>