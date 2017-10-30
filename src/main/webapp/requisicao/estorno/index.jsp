<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="java.text.SimpleDateFormat"  %>

<jsp:include page="../../template/cabecalho.jsp"/>

<%
  //-- Objetos control
  RequisicaoEstornoControl requisicaoEstornoControl = new RequisicaoEstornoControl();
  
  //-- Parametros de página
  String codRequisicao = (request.getParameter("codRequisicao")==null)?"":request.getParameter("codRequisicao");  
  String codUnidade    = (request.getParameter("codUnidade")==null)?"0":request.getParameter("codUnidade");  
  String codCargo      = (request.getParameter("codCargo")==null)?"0":request.getParameter("codCargo");   
  int numeroDaPagina   = (request.getParameter("numeroDaPagina")==null)?1:Integer.parseInt(request.getParameter("numeroDaPagina"));   
  int qtdPorPagina     = (request.getParameter("qtdPorPagina")==null)?40:Integer.parseInt(request.getParameter("qtdPorPagina"));   
  
  //-- Objetos
  String where = "";
  String[][] requisicoesParaEstorno = null;
  String[][] comboUnidade = null;
  String[][] comboCargo = null;
  
  //-- Carregando os combos
  comboUnidade = requisicaoEstornoControl.getComboUnidadesEstorno();
  comboCargo   = requisicaoEstornoControl.getComboCargosEstorno();  
  
  //-- Verificando as cláusulas da pesquisa
  if(!codRequisicao.equals("")){
    where += " AND REQUISICAO_SQ = " + codRequisicao ;
  }

  if(!codUnidade.equals("0")){
    where += " AND COD_UNIDADE = '" + codUnidade +"'";
  }
  
  if(!codCargo.equals("0")){
    where += " AND CARGO_SQ = " + codCargo ;
  }  

  //-- Resgatando as requisições para estorno
  requisicoesParaEstorno = requisicaoEstornoControl.getRequisicoesParaEstorno(where);
%>

<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js"    type="text/javascript"></script> 
<script language="JavaScript" src="<%=request.getContextPath()%>/js/regrasRequisicao.js" type="text/javascript" charset="utf-8"></script>
<script language="javaScript">
  //--
  function estornar(parametro){
    window.location = "formulario.jsp?codRequisicao="+parametro;
  }
  //--
  function irParaPagina(qtdPorPagina,numeroDaPagina){
    document.frmRequisicao.numeroDaPagina.value = numeroDaPagina;
    document.frmRequisicao.qtdPorPagina.value   = qtdPorPagina;
    document.frmRequisicao.submit();
  }   
  //-- 
  function limpaCampos(){
    document.frmRequisicao.codCargo.value = 0;
    document.frmRequisicao.codUnidade.value = 0;
  }
  //--
  function pesquisar(){
    document.frmRequisicao.submit();
    
  }  
  //--
  function requisicaoDados(parametro){
    popUP('<%=request.getContextPath()%>/relatorio/index.jsp?'+parametro,'link','toolbar=no,width=660,height=600,scrollbars=yes');
  }
  //--
  function requisicaoHistorico(parametro){
    popUP('<%=request.getContextPath()%>/relatorio/historico.jsp?'+parametro,'link','toolbar=no,width=660,height=600,scrollbars=yes');
  }     
</script>

<center>
<br>
  <form name="frmRequisicao" action="index.jsp" method="POST" >
    <input type="HIDDEN" name="numeroDaPagina" value="<%=numeroDaPagina%>"/>
    <input type="HIDDEN" name="qtdPorPagina" value="<%=qtdPorPagina%>"/>
    <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">     
    <tr>
      <td>
        <table border="0" width="610" cellpadding="0" cellspacing="0">
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
              <input class="input" size="9" name="codRequisicao" maxlength="8" value="<%=codRequisicao%>" onkeyup="this.value = this.value.replace(/\D/g,'')" onkeypress="return Bloqueia_Caracteres(event);" onblur="limpaCampos();"/>
            </td>					  					
          </tr>                    
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Cargo:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="codCargo" class="select" style="width: 450px;">
                <option value="0">SELECIONE</option>
                <%for(int i=0; i<comboCargo.length; i++){%>
                  <option value="<%=comboCargo[i][0]%>" <%=(comboCargo[i][0].equals(codCargo))?" SELECTED":""%> ><%=comboCargo[i][1]%></option>
                <%}%>
                </select>
            </td>					  					
          </tr>             
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>UO:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="codUnidade" class="select" style="width: 450px;">
                  <option value="0">SELECIONE</option>
                  <%for(int i=0; i<comboUnidade.length; i++){%>
                    <option value="<%=comboUnidade[i][0]%>" <%=(comboUnidade[i][0].equals(codUnidade))?" SELECTED":""%> ><%=comboUnidade[i][1]%></option>
                  <%}%>
                </select> 
            </td>
          </tr> 
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="right">
              <a href="##" onclick="pesquisar();">
                <img src="<%=request.getContextPath()%>/imagens/bt_pesquisar.gif" border="0" hspace="10"/>
              </a>
            </td>
          </tr>           
          <tr>
            <td colspan="2" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
          </tr>            
        </table>
        <br>        
      <%-- IMPRESSÃO DOS VALORES --%>       
       <%if(requisicoesParaEstorno != null && requisicoesParaEstorno.length > 0){%>
          <table border="0" cellpadding="0" cellspacing="0" width="610" >
            <tr >
              <td align="center" height="25"  class="tdTemplateLista" width="8%"><STRONG>RP</STRONG></td>
              <td align="center" height="25"  class="tdTemplateLista" width="10%"><STRONG>Data</STRONG></td>
              <td align="left"   height="25"  class="tdTemplateLista" width="45%">&nbsp;&nbsp;<STRONG>Cargo</STRONG></td>
              <td align="center" height="25"  class="tdTemplateLista" width="16%"><STRONG>Unidade</STRONG></td>
              <td align="center" height="25"  class="tdTemplateLista" width="10%"><STRONG>Status</STRONG></td>              
              <td align="center" height="25"  class="tdTemplateLista" width="8%"><STRONG>Estornar</STRONG></td>
            </tr>
          <% 
            String classCSS = "borderintranet";
            int qtdLinhas      = requisicoesParaEstorno.length;
            qtdPorPagina       = (qtdLinhas>qtdPorPagina)?qtdPorPagina:qtdLinhas;
            int registroIncial = ((numeroDaPagina -1) * qtdPorPagina);
            int registroFinal  = registroIncial + qtdPorPagina;
            registroFinal      = (qtdLinhas>registroFinal)?registroFinal:qtdLinhas;      
      
            for(int i=registroIncial;i<registroFinal;i++){
              classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
          %>
              <tr >
                <td align="center" height="25" class="<%= classCSS %>" width="8%">
                  <a href="javaScript:requisicaoDados('codRequisicao=<%=requisicoesParaEstorno[i][0]%>');" title="Visualizar RP">
                    <%=requisicoesParaEstorno[i][0]%>
                  </a>
                </td>
                <td align="center" height="25" class="<%= classCSS %>" width="10%">
                  <a href="javaScript:requisicaoHistorico('codRequisicao=<%=requisicoesParaEstorno[i][0]%>');" title="Visualizar histórico da RP">
                    <%=requisicoesParaEstorno[i][1]%>
                  </a>
                </td>
                <td align="left"   height="25" class="<%= classCSS %>" width="45%">&nbsp;&nbsp;<%=(requisicoesParaEstorno[i][2]==null)?"":requisicoesParaEstorno[i][2]%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="16%" title="<%=requisicoesParaEstorno[i][4]%>"><%=(requisicoesParaEstorno[i][3]==null)?"":requisicoesParaEstorno[i][3]+" / "+requisicoesParaEstorno[i][6]%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="10%"><%=(requisicoesParaEstorno[i][5]==null)?"":requisicoesParaEstorno[i][5]%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="8%">
                  <a href="javaScript:estornar(<%=requisicoesParaEstorno[i][0]%>);" title="Estornar esta RP">
                    <img src="<%=request.getContextPath()%>/imagens/estorno.png" border="0"/>
                  </a>                
                </td>                
              </tr>
        <%}%>
          </table>
          <%-- PAGINAÇÃO --%>
          <jsp:include page="../../template/paginacao.jsp"                      >
            <jsp:param  name="pNumeroDeRegistros" value="<%=requisicoesParaEstorno.length%>"/>
            <jsp:param  name="pQtdPorPagina"      value="<%=qtdPorPagina%>"    />
            <jsp:param  name="pNumeroDaPagina"    value="<%=numeroDaPagina%>"  />
            <jsp:param  name="pUrlLink"           value="index.jsp"            />
          </jsp:include>             
        <tr>
          <td colspan="4" height="3" class="tdIntranet2">&nbsp;</td>
        </tr>           
        <tr>
          <td colspan="4" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
        </tr>           
      <%}else{%>
          <tr>
            <td colspan="4" height="3" align="center"><strong>Nenhuma RP foi localizada!</strong></td>
          </tr>                 
      <%}%>

   </table>
   </form>   
<br>
</center>

<jsp:include page="../../template/fimTemplateIntranet.jsp"/>