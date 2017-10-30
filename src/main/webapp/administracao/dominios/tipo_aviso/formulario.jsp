<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.TipoAvisoControl" %>
<%@ page import="br.senac.sp.reqpes.model.TipoAviso" %>

<jsp:include page="../../../template/cabecalho.jsp"/>

<%  
  //-- Parametros de página
  int codTipoAviso = (request.getParameter("codTipoAviso")==null)?0:Integer.parseInt(request.getParameter("codTipoAviso"));
  
  //-- Objetos da página
  TipoAviso tipoAviso = new TipoAvisoControl().getTipoAviso(codTipoAviso);   
  String acaoForm  = "gravar.jsp";
  String botaoForm = "bt_cadastrar.gif";
  String altBotao  = "Cadastrar";
  
  //-- Verificando instância do objeto
  if(tipoAviso == null){
    tipoAviso = new TipoAviso();
  }else{
    // Configurando botões
    acaoForm  = "atualizar.jsp";
    botaoForm = "bt_atualizar.gif";
    altBotao  = "Atualizar";  
  }  
%>

<br>
<script language="JavaScript" src="../../../js/formulario.js" type="text/javascript"></script> 
<script language="JavaScript" src="../../../js/mascara.js"    type="text/javascript"></script> 

<script language="javaScript">
  function cadastrar(){
    if(decode(document.frm.titulo,"Informe o título!",0,"",null))
      if(decode(document.frm.cargoChave,"Informe a palavra chave de pesquisa!",0,"",null)){
        document.frm.submit();
      }
  }  
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <form name="frm" method="POST" action="<%=acaoForm%>">
      <input type="HIDDEN" name="codTipoAviso" value="<%=tipoAviso.getCodTipoAviso()%>">  
          <tr>
            <td colspan="2"  height="18" class="tdCabecalho" background='../../../imagens/tit_item.gif' >
              <STRONG>&nbsp;&nbsp;TIPO DE AVISO</STRONG>
            </td>
          </tr>        
          <tr>
            <td height="10" class="tdintranet2" colspan="2"> </td>
          </tr>            
          <tr class="tdintranet2">
            <td height="23" align="right" width="25%">
              <STRONG>Título:&nbsp;</STRONG>
            </td>
            <td width="75%" class="tdintranet2" align="left" >
              <input class="input" size="80" maxlength="200" name="titulo" id="titulo" value="<%=tipoAviso.getTitulo()%>">
            </td>
          </tr>
          <tr class="tdintranet2">
            <td height="23" align="right" width="25%">
              <STRONG>Chave de pesquisa:&nbsp;</STRONG>
            </td>
            <td width="75%" class="tdintranet2" align="left" >
              <input class="input" size="80" maxlength="100" name="cargoChave" id="cargoChave" value="<%=tipoAviso.getCargoChave()%>">
            </td>
          </tr>
          <tr class="tdintranet2">
            <td height="23" align="right" width="25%">
              <STRONG>Regime:&nbsp;</STRONG>
            </td>
            <td width="75%" class="tdintranet2" align="left" >
              <input type="radio" name="cargoRegime" value="N" <%=(tipoAviso.getCargoRegime().equals("N"))?" CHECKED":""%>>Nenhum&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <input type="radio" name="cargoRegime" value="M" <%=(tipoAviso.getCargoRegime().equals("M"))?" CHECKED":""%>>Mensalista&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <input type="radio" name="cargoRegime" value="H" <%=(tipoAviso.getCargoRegime().equals("H"))?" CHECKED":""%>>Horista
            </td>
          </tr>
          <tr>
            <td height="10" class="tdintranet2" colspan="2"> </td>
          </tr>            
          <tr>
            <td height="23" class="tdintranet2" colspan="2" align="right">
              <a href="javaScript:cadastrar();">                  
                <img src="../../../imagens/<%=botaoForm%>" border="0" alt="<%=altBotao%>"/>
              </a>
              <a href="index.jsp">                  
                <img src="../../../imagens/bt_voltar.gif" border="0" alt="Voltar" hspace="15"/>
              </a>                    
            </td>
          </tr>        
          <tr>
            <td height="3" colspan="2" class="tdCabecalho" background='../../../imagens/fio_azul_end.gif'></td>
          </tr>                            
      </form>
    </table>
</center> 
<br>

<jsp:include page="../../../template/fimTemplateIntranet.jsp"/>