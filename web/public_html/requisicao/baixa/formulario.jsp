<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>

<jsp:include page="../../template/cabecalho.jsp"/>

<%
  //-- Objetos control
  RequisicaoBaixaControl requisicaoBaixaControl = new RequisicaoBaixaControl();
  RequisicaoControl requisicaoControl           = new RequisicaoControl();
  
  //-- Objetos
  String[][] requisicoesParaBaixa = null;
  Requisicao requisicao = null;
  String where = "";
  
  //-- Resgatando as requisições que podem ser dada baixa
  requisicoesParaBaixa = requisicaoBaixaControl.getRequisicoesParaBaixa(where);
  
  //-- Parametros de página
  int    codRequisicao = (request.getParameter("codRequisicao")==null)?0:Integer.parseInt(request.getParameter("codRequisicao"));
  String indTipo       = request.getParameter("indTipo"); //-- Indica se o formulário foi chamado pela Baixa ou Expiração
    
  //-- Verificando requisição
  requisicao = requisicaoControl.getRequisicao(codRequisicao);
%>

<script language="JavaScript" src="<%=request.getContextPath()%>/js/formulario.js" type="text/javascript"></script> 
<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js"   type="text/javascript"></script>  
<script language="JavaScript" src="<%=request.getContextPath()%>/js/ajaxItens.js" type="text/javascript"></script>  
<script language="javaScript">
  var codUnidadeRequisicao = '<%=requisicao.getCodUnidade().substring(0,3)%>';
  //--
  function requisicaoDados(parametro){
    popUP('<%=request.getContextPath()%>/relatorio/index.jsp?'+parametro,'link','toolbar=no,width=660,height=600,scrollbars=yes');
  }
  //--
  function getNomeFuncionarioBaixado(chapa){
    if(Trim(chapa) != ''){
      // Carregando o nome do funcionario que será substituído
      carregaNomeFuncionarioBaixado(chapa, 'divNomeFuncionarioBaixado');
    }else{
      alert('Informe a chapa do funcionário!');
    }
  }    
  //--
  function voltar(){
    window.location = '<%=(indTipo.equals("B"))?"index.jsp":"./expirando/index.jsp"%>';
  }  
  //--
  function cadastrar(){
    if(decode(document.frmRequisicao.idFuncionarioBaixado,"Informe a chapa do funcionário!",0,"",null))
      if(decode(document.frmRequisicao.nomFuncionario,"A chapa informada não pode ser utilizada como baixa na requisição",-1,"",null))
        if(codUnidadeRequisicao != document.frmRequisicao.codUnidadeFuncSelecionado.value){
          if(confirm("ATENÇÃO! O funcionário selecionado não pertence à unidade da RP aprovada!\nProsseguir com a baixa desta RP com este funcionário?")){
            document.frmRequisicao.submit();
          }
        }else{
          document.frmRequisicao.submit();
        }      
  }
  //--
  function onEnter(evt){
      var key_code = evt.keyCode?evt.keyCode:evt.charCode?evt.charCode:evt.which?evt.which:void 0;
      if(key_code == 13){
        getNomeFuncionarioBaixado(document.frmRequisicao.idFuncionarioBaixado.value);
      }
  }  
</script>

<center>
<br>
<form name="frmRequisicao" action="gravar.jsp" method="POST" >
  <input type="HIDDEN" name="codRequisicao" value="<%=requisicao.getCodRequisicao()%>">      
  <input type="HIDDEN" name="indTipo"  value="<%=indTipo%>">    
  <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">  
    <tr>
      <td>
        <table border="0" width="610" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="3"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
             <STRONG>&nbsp;&nbsp;BAIXA DE REQUISIÇÕES</STRONG>
            </td>
          </tr> 
          <tr>
            <td colspan="3" align="center" height="25" class="tdIntranet2" width="100%">
              <strong>Funcionário aprovado para a RP nº <%=requisicao.getCodRequisicao()%></strong>
              <a href="javaScript:requisicaoDados('codRequisicao=<%=requisicao.getCodRequisicao()%>');">(Visualizar requisição)</a>                
            </td>          
          </tr> 
          <tr>
            <td align="right" height="25" class="tdIntranet2" width="20%">
              <strong>Chapa:&nbsp;</strong>
            </td>          
            <td align="left" height="25" class="tdIntranet2" width="5%">
              <input class="input" name="idFuncionarioBaixado" id="idFuncionarioBaixado" size="7" maxlength="6" onkeypress="onEnter(event); return Bloqueia_Caracteres(event);" onchange="getNomeFuncionarioBaixado(this.value);" >&nbsp;
            </td>
            <td align="left" height="25" class="tdIntranet2" width="75%">
              <div id="divNomeFuncionarioBaixado">
                <input class="input" name="nomFuncionario" id="nomFuncionario" size="70" readonly>
                <input type="HIDDEN" name="codUnidadeFuncSelecionado"/>
              </div>
            </td>                      
          </tr>           
        </table>
      </td>
    </tr>
    <tr>
      <td colspan="3" height="29" class="tdintranet2" align="right" background="<%=request.getContextPath()%>/imagens/chapeu_fim_610.gif">
        <a href="javaScript:cadastrar();">                  
          <img src="<%= request.getContextPath()%>/imagens/bt_submeter.gif" border="0" alt="Clique para realizar a baixa da RP"/>
        </a>
        <a href="javaScript:voltar();">                  
          <img src="<%= request.getContextPath()%>/imagens/bt_voltar.gif" border="0" alt="Voltar" hspace="10" />
        </a>
      </td>
    </tr>      
    <tr>
      <td colspan="3" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
    </tr>     
  </table>
</form>   
<br>
</center>
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>