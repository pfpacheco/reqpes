<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.UsuarioAvisoEmailControl" %>
<%@ page import="br.senac.sp.reqpes.model.UsuarioAvisoEmail" %>
<jsp:include page="../../template/cabecalho.jsp"/>

<% 
  //-- Objetos Control
  UsuarioAvisoEmailControl usuarioAvisoEmailControl = new UsuarioAvisoEmailControl();
     
  //-- Parametros de página
  int chapa = (request.getParameter("chapa")==null)?0:Integer.parseInt(request.getParameter("chapa"));
  
  //-- Objetos da página
  UsuarioAvisoEmail usuarioAvisoEmail = usuarioAvisoEmailControl.getUsuarioAvisoEmail(chapa);   
  String[][] comboUnidades = usuarioAvisoEmailControl.getComboUnidades();
  String[][] listTipoAviso = usuarioAvisoEmailControl.getTipoAvisoUsuario(chapa);
  String botaoForm = "bt_cadastrar.gif";
  String altBotao  = "Cadastrar";
  
  //-- Verificando instância do objeto
  if(usuarioAvisoEmail == null){
    usuarioAvisoEmail = new UsuarioAvisoEmail();
  }else{
    // Configurando botões
    botaoForm = "bt_atualizar.gif";
    altBotao  = "Atualizar";  
  }     
%>

<BR/>
<script language="JavaScript" src="../../js/ajaxItens.js" type="text/javascript"></script>
<script language="JavaScript" src="../../js/formulario.js" type="text/javascript"></script> 
<script language="javaScript">
  function cadastrar(){
    if(decode(document.frm.codUnidade,"Selecione a unidade!",0,"",null))
      if(decode(document.frm.chapa,"Selecione o usuário!",0,"",null))
        if(validaCheck(document.frm.codTipoAviso)){
          document.frm.submit();
        }else{
          alert('Selecione os cargos a serem notificados!');
        }
  }  
  //--
  function validaCheck(objeto){   
    var cont = 0;
    for(z=0; z<objeto.length; z++){
      if(objeto[z].type == 'checkbox' && objeto[z].checked)
        cont = cont + 1;        
      }
    return (cont != 0);
  }
  //--
  function checkUncheckAll(opt){  
    if(opt == 1){
      for(z=1; z<document.frm.codTipoAviso.length; z++){
         document.frm.codTipoAviso[z].checked = false;
         document.frm.codTipoAviso[z].disabled = (document.frm.codTipoAviso[0].checked);
      }            
    }else{
      document.frm.codTipoAviso[0].checked = false;
    }
  }  
</script>

<center>
<form name="frm" method="POST" action="gravar.jsp">
  <table border="0" cellpadding="0" cellspacing="0" width="610">
      <tr>
        <td colspan="2"  height="18" class="tdCabecalho" background='../../imagens/tit_item.gif' >
          <STRONG>&nbsp;&nbsp;CADASTRO DE USUÁRIOS</STRONG>
        </td>
      </tr>
      <tr>
        <td height="10" class="tdintranet2" colspan="2"> </td>
      </tr>        
      <%if(usuarioAvisoEmail.getChapa() == 0){%>
          <tr class="tdintranet2">
            <td height="23" align="right" width="20%">
              <STRONG>Unidade:&nbsp;</STRONG>
            </td>
            <td width="80%" class="tdintranet2" align="left" >
              <select name="codUnidade" class="select" style="width: 400px;" onchange="getComboFuncionarios(this.value);">
                <option value="0">SELECIONE</option>
                <%for(int i=0; i<comboUnidades.length; i++){%>
                  <option value="<%=comboUnidades[i][0]%>"><%=comboUnidades[i][0]+" - "+comboUnidades[i][1]%></option>
                <%}%>
              </select>
            </td>
          </tr>
          <tr class="tdintranet2">
            <td height="23" align="right" width="20%">
              <STRONG>Usuário:&nbsp;</STRONG>
            </td>
            <td width="80%" class="tdintranet2" align="left" >
              <div id="divFuncionarios">
                <select name="chapa" id="chapa" class="select" style="width: 400px;">
                  <option value="0">SELECIONE</option>
                </select>
              </div>
            </td>
          </tr>
      <%}else{%>
          <tr class="tdintranet2">
            <td height="18" align="right" width="20%">
	          <input type="HIDDEN" name="codUnidade" id="codUnidade" value="1">
	          <input type="HIDDEN" name="chapa" id="chapa" value="<%=usuarioAvisoEmail.getChapa()%>">
              <STRONG>Usuário:&nbsp;</STRONG>
            </td>
            <td width="80%" height="30" class="tdintranet2" align="left" ><%=usuarioAvisoEmail.getNome()%></td>
          </tr>      
      <%}%>
      <tr>
        <td height="10" class="tdintranet2" colspan="2"> </td>
      </tr>              
      <tr>
        <td height="23" class="tdintranet" colspan="2"><strong>&nbsp;&nbsp;Cargos a serem notificados</strong></td>
      </tr>          
      <%-- imprimindo valores --%>
      <%
        for(int i=0; i<listTipoAviso.length; i++){ %>
          <tr>
            <td height="10" class="tdintranet2" colspan="2">
              &nbsp;&nbsp;&nbsp;<input type="checkbox" name="codTipoAviso" value="<%=listTipoAviso[i][0]%>" onclick="checkUncheckAll(this.value);" <%=listTipoAviso[i][2]%>><%=listTipoAviso[i][1]%>
            </td>
          </tr>            
      <%}%>
      <tr>
        <td height="10" class="tdintranet2" colspan="2"  > </td>
      </tr>                              
      <tr>
        <td height="23" class="tdintranet2" colspan="2" align="right">
          <a href="javaScript:cadastrar();">                  
            <img src="../../imagens/<%=botaoForm%>" border="0" alt="<%=altBotao%>"/>
          </a>
          <a href="index.jsp">                  
            <img src="../../imagens/bt_voltar.gif" border="0" alt="Voltar" hspace="20"/>
          </a>                    
        </td>
      </tr>        
      <tr>
        <td height="3" colspan="2" class="tdCabecalho" background='../../imagens/fio_azul_end.gif'></td>
      </tr>                                
  </table>
</form>  
</center> 
<br>
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>