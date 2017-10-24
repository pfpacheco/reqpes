<%  session.setAttribute("root","../../../../"); %>
<%@ page errorPage="../../../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:include page="../../../../template/cabecalho.jsp"/>

<% 
  //-- Objetos Control  
  GrupoNecUsuarioControl grupoNecUsuarioControl = new GrupoNecUsuarioControl();
  
  //-- Parametros de página
  int chapa = (request.getParameter("chapa")==null)?0:Integer.parseInt(request.getParameter("chapa"));
      
  //-- Objetos da página
  GrupoNecUsuario grupoNecUsuario = grupoNecUsuarioControl.getGrupoNecUsuario(chapa);
  String[][] grupos = grupoNecUsuarioControl.getGruposNecByUsuario(chapa);
  String[][] comboUsuarios = null;
  
  String acaoForm  = "gravar.jsp";
  String botaoForm = "bt_cadastrar.gif";
  String altBotao  = "Cadastrar";
  
  //-- Verificando instância do objeto
  if(grupoNecUsuario == null){
    grupoNecUsuario = new GrupoNecUsuario();
    comboUsuarios = grupoNecUsuarioControl.getComboUsuarios();
  }else{
    // Configurando botões
    acaoForm  = "atualizar.jsp";
    botaoForm = "bt_atualizar.gif";
    altBotao  = "Atualizar";  
  }
%>

<br>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/formulario.js" type="text/javascript"></script> 
<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js"    type="text/javascript"></script> 

<script language="javaScript">
  function cadastrar(){
    if(decode(document.frm.chapa,"Selecione um usuário!",0,"",null))
      if(validaCheck(document.frm.codGrupo)){
        document.frm.submit();
      }else{
        alert('Selecione um grupo de acesso!');
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
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <form name="frm" method="GET" action="<%=acaoForm%>">       
          <tr>
            <td colspan="2"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
              <STRONG>&nbsp;&nbsp;USUÁRIO DE ACESSO - NEC (NÚCLEO DE EDUCAÇÃO CORPORATIVA)</STRONG>
            </td>
          </tr>        
          <tr>
            <td height="10" class="tdintranet2" colspan="2"> </td>
          </tr>            
          <tr class="tdintranet2">
            <td height="23" align="right" width="12%">
              <STRONG>Usuário:&nbsp;</STRONG>
            </td>
            <td width="75%" class="tdintranet2" align="left" >
              <%if(grupoNecUsuario.getChapa() > 0){%>
                  <input type="hidden" name="chapa" value="<%=grupoNecUsuario.getChapa()%>">
                  <input class="label" readonly size="80" maxlength="400" name="nome" value="<%=grupoNecUsuario.getNomUsuario()%>">
              <%}else{%>
                  <select name="chapa" class="select" style="width: 450px;">
                    <option value="0">SELECIONE</option>
                    <%for(int i=0; i<comboUsuarios.length; i++){%>
                        <option value="<%=comboUsuarios[i][0]%>"><%=comboUsuarios[i][1]%></option>
                    <%}%>
                  </select>
              <%}%>
            </td>
          </tr>  
          <tr>
            <td height="10" class="tdintranet2" colspan="2"> </td>
          </tr>
          <tr>
            <td height="23" class="tdintranet" colspan="2"><strong>&nbsp;&nbsp;&nbsp;&nbsp;Grupos de acesso</strong></td>
          </tr>          
          <%-- imprimindo valores --%>
          <%
            for(int i=0; i<grupos.length; i++){ %>
              <tr>
                <td height="10" class="tdintranet2" colspan="2">
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="codGrupo" value="<%=grupos[i][1]%>" <%=grupos[i][0].equals("S")?"CHECKED":""%>><%=grupos[i][2]%>
                </td>
              </tr>            
          <%}%>
          <tr>
            <td height="10" class="tdintranet2" colspan="2"> </td>
          </tr>          
          <tr>
            <td height="23" class="tdintranet2" colspan="2" align="right">
              <a href="javaScript:cadastrar();">                  
                <img src="<%= request.getContextPath()%>/imagens/<%=botaoForm%>" border="0" alt="<%=altBotao%>"/>
              </a>                    
               <a href="index.jsp">                  
                <img src="<%= request.getContextPath()%>/imagens/bt_voltar.gif" border="0" alt="Voltar" hspace="15"/>
              </a>
            </td>
          </tr>        
          <tr>
            <td height="3" colspan="2" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif'></td>
          </tr>                            
      </form>
    </table>
</center> 
<br>

<jsp:include page="../../../../template/fimTemplateIntranet.jsp"/>