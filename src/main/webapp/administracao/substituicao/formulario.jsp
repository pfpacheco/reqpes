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
   String codUnidade  = request.getParameter("codUnidade");
   String isAlteracaoGerente = (request.getParameter("isAlteracaoGerente")==null)?"S":request.getParameter("isAlteracaoGerente");
   
   //-- Objetos
   SimpleDateFormat sf = new SimpleDateFormat("dd/MM/yyyy");
   SubstituicaoGerente gerenteAtual = null;
   String botao = "bt_atualizar";
   String acao  = "atualizar.jsp";
      
   //-- Carregando os dados do gerente atual
   if(codUnidade != null){
      gerenteAtual = substituicaoGerenteControl.getSubstituicaoGerenteAtual(codUnidade);
   }
   
   if(isAlteracaoGerente.equals("S")){
      botao = "bt_cadastrar";
      acao  = "gravar.jsp";
   }
%>

<BR/>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/ajaxItens.js" charset="utf-8"  type="text/javascript"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js"    type="text/javascript"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/formulario.js" type="text/javascript"></script>
<script language="javaScript">
  //--
  function submeter(){
    if(decode(document.frm.chapa,"Informe o número da chapa do funcionário!",0,"",null))
      if(decode(document.frm.datInicioVigencia,"Informe a data de início da vigência!",0,"",null))
        if(decode(document.frm.datFimVigencia,"Informe a data de fim da vigência!",0,"",null))
          if(Verifica_Data('datInicioVigencia', 1))
            if(Verifica_Data('datFimVigencia', 1))
              if(document.frm.datInicioVigencia.value != document.frm.datFimVigencia.value){
                if(comparaDataAnterior(document.frm.datInicioVigencia.value, document.frm.datFimVigencia.value, 'D'))
                  if(comparaDataAnterior('<%=sf.format(gerenteAtual.getDatInicioVigencia())%>',document.frm.datInicioVigencia.value, 'V'))
                    window.document.frm.submit();
              }else{
                alert('As datas do período da Vigência devem ser diferentes!');
              }
  }  
  //--
  function getNome(chapa){
    if(Trim(chapa)){
      carregaNomeFuncionarioGerente(chapa, 'divNomeFuncionario');
    }
  }  
  //-- 
  function voltar(){
    window.history.back();
  }
  //--
 function comparaDataAnterior(dataAnterior, dataAtual, tipo){   
    // data de inicio do gerente anterior
    diaAnterior = dataAnterior.substr(0,2);
    mesAnterior = dataAnterior.substr(3,2);
    anoAnterior = dataAnterior.substr(6,4);
    
    // data de inicio do novo gerente
    diaAtual = dataAtual.substr(0,2); 	
    mesAtual = dataAtual.substr(3,2); 	
    anoAtual = dataAtual.substr(6,4);
    
    dataAn = new Date(diaAnterior, mesAnterior, anoAnterior);
    dataAt = new Date(diaAtual, mesAtual, anoAtual);
   
    // caso de atualização dos dados do gerente atual
    if((document.frm.chapa.value == '<%=gerenteAtual.getChapa()%>') && (dataAn == dataAt)){
      return true;
    }else{ 
        if(dataAn > dataAt){                 
          if(tipo == 'V'){
            //alert('A data de início do novo gerente deve ser superior a data de início do gerente anterior!');
            return true;
          }else{
            alert('A data de início deve ser menor que a data de término!');
          }
          return false;
        }else{
          return true;
        }
    }
 }  
</script>

<center>
<form action="<%=acao%>" name="frm" method="POST">
  <input type="hidden" name="codUnidade" value="<%=codUnidade%>">
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
      <tr>
        <td colspan="2" height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
          <STRONG>&nbsp;&nbsp;SUBSTITUIÇÃO INFORMAL DE GERENTES</STRONG>
        </td>
      </tr>
      <%-- VERIFICA SE É ALTERAÇÃO DE GERENTE --%>
      <%if(isAlteracaoGerente.equals("S")){%>
          <tr class="tdintranet">
            <td height="25" align="left" colspan="2">
              <STRONG>&nbsp;&nbsp;DADOS DO GERENTE ATUAL</STRONG>
            </td>
          </tr>
          <tr class="tdintranet2">
            <td height="8" align="left" colspan="2"></td>
          </tr>
          <tr class="tdintranet2">
            <td height="25" align="right" width="15%">
              <STRONG>Chapa:&nbsp;</STRONG>
            </td>
            <td height="25" align="left" width="95%">
              <%=gerenteAtual.getChapa()%>
            </td>          
          </tr>
          <tr class="tdintranet2">
            <td height="25" align="right" width="15%">
              <STRONG>Nome:&nbsp;</STRONG>
            </td>
            <td height="25" align="left" width="95%">
              <%=gerenteAtual.getNomGerente()%>
            </td>          
          </tr>
          <tr class="tdintranet2">
            <td height="25" align="right" width="15%">
              <STRONG>Vigência de:&nbsp;</STRONG>
            </td>
            <td height="25" align="left" width="95%">
              <%=sf.format(gerenteAtual.getDatInicioVigencia())+"&nbsp;&nbsp;<b>à</b>&nbsp;&nbsp;"+sf.format(gerenteAtual.getDatFimVigencia())%>
            </td>          
          </tr>      
          <tr class="tdintranet2">
            <td height="8" align="left" colspan="2"></td>
          </tr>      
          <tr class="tdintranet">
            <td height="25" align="left" colspan="2">
              <STRONG>&nbsp;&nbsp;DADOS DO NOVO GERENTE</STRONG>
            </td>
          </tr>
          <tr class="tdintranet2">
            <td height="8" align="left" colspan="2"></td>
          </tr>
          <tr class="tdintranet2">
            <td height="25" align="right" width="15%">
              <STRONG>Chapa:&nbsp;</STRONG>
            </td>
            <td height="25" align="left" width="95%">
              <input class="input" name="chapa" id="chapa" maxlength="6" size="7" onkeypress="return Bloqueia_Caracteres(event);" onchange="getNome(this.value);">
            </td>          
          </tr>
          <tr class="tdintranet2">
            <td height="25" align="right" width="15%">
              <STRONG>Nome:&nbsp;</STRONG>
            </td>
            <td height="25" align="left" width="95%">
              <div id="divNomeFuncionario">
                <input class="label" name="nomFuncionario" id="nomFuncionario" readonly>
              </div>
            </td>          
          </tr>
          <tr class="tdintranet2">
            <td height="25" align="right" width="15%">
              <STRONG>Vigência de:&nbsp;</STRONG>
            </td>
            <td height="25" align="left" width="95%">
              <input class="input" size="12" maxlength="10" onfocus="this.value = '';" onkeypress="return Ajusta_Data(this,event);" name="datInicioVigencia" id="datInicioVigencia"/>&nbsp;&nbsp;
              <STRONG>à&nbsp;&nbsp;</STRONG>
              <input class="input" size="12" maxlength="10" onfocus="this.value = '';" onkeypress="return Ajusta_Data(this,event);" name="datFimVigencia" id="datFimVigencia"/>&nbsp;&nbsp;&nbsp;
            </td>          
          </tr>      
      <%}else{%>          
          <tr class="tdintranet2">
            <td height="8" align="left" colspan="2"></td>
          </tr>
          <tr class="tdintranet2">
            <td height="25" align="right" width="15%">
              <STRONG>Chapa:&nbsp;</STRONG>
            </td>
            <td height="25" align="left" width="95%">
              <input class="label" name="chapa" id="chapa" maxlength="6" size="7" value="<%=gerenteAtual.getChapa()%>" readonly>
            </td>          
          </tr>
          <tr class="tdintranet2">
            <td height="25" align="right" width="15%">
              <STRONG>Nome:&nbsp;</STRONG>
            </td>
            <td height="25" align="left" width="95%">
              <input class="label" name="nomFuncionario" id="nomFuncionario" size="80" value="<%=gerenteAtual.getNomGerente()%>" readonly>
            </td>          
          </tr>
          <tr class="tdintranet2">
            <td height="25" align="right" width="15%">
              <STRONG>Vigência de:&nbsp;</STRONG>
            </td>
            <td height="25" align="left" width="95%">
              <input class="input" size="12" maxlength="10" onkeypress="return Ajusta_Data(this,event);" name="datInicioVigencia" id="datInicioVigencia" value="<%=sf.format(gerenteAtual.getDatInicioVigencia())%>" readonly/>&nbsp;
              <STRONG>à&nbsp;&nbsp;</STRONG>
              <input class="input" size="12" maxlength="10" onkeypress="return Ajusta_Data(this,event);" name="datFimVigencia" id="datFimVigencia" value="<%=sf.format(gerenteAtual.getDatFimVigencia())%>"/>&nbsp;&nbsp;&nbsp;
            </td>          
          </tr>                
      <%}%>
      <tr class="tdintranet2">
        <td height="8" align="left" colspan="2"></td>
      </tr>
      <tr>
        <td align="right" colspan="2" height="25" class="tdintranet2">
          <a href="javaScript:submeter();">
            <img src="<%=request.getContextPath()%>/imagens/<%=botao%>.gif" border="0">
          </a>
          <a href="javaScript:voltar();">
            <img src="<%=request.getContextPath()%>/imagens/bt_voltar.gif" title="Voltar" border="0" hspace="16">
          </a>          
        </td>
      </tr>          
      <tr>
        <td height="3" colspan="2" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif'>
        </td>
      </tr>         
  </table>
  </form>
</center> 
<br>

<jsp:include page="../../template/fimTemplateIntranet.jsp"/>