<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.TabelaSalarial" %>

<jsp:include page="../../template/cabecalho.jsp"/>

<%
  //-- Carregando os combos
  TabelaSalarial[] tabelaSalarial = new TabelaSalarialControl().getTabelaSalarials();
  String[][] comboCargo = new InstrucaoControl().getComboCargo(0);  
  String[][] comboUnidade = new RequisicaoControl().getComboUnidade();
%>

<script type="text/javascript" src="../../js/ajaxItens.js"></script>
<script language="javaScript">
  //--
  function editar(parametro){
    window.location = "formulario.jsp?codInstrucao="+parametro;
  }
  //--
  function excluir(parametro){
    if(confirm("Deseja excluir realmente esta instrução?"))
      window.location = "excluir.jsp?codInstrucao="+parametro;
  }    
  //--
  function pesquisar(){
    getListInstrucao(1, 60);
  } 
  //--
  function irParaPagina(qtdPorPagina,numeroDaPagina){
    getListInstrucao(numeroDaPagina, qtdPorPagina);
  }  
</script>

<center>
<br>
<form name="frm" action="index.jsp" method="POST" >
   <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">  
    <tr>
      <td>
        <table border="0" width="610" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="3"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
             <STRONG>&nbsp;&nbsp;INSTRUÇÃO - 04/2011</STRONG>
            </td>
          </tr>  
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Tabela salarial:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
              <select name="codTabela" id="codTabela" class="select" style="width: 450px;">
                <option value="0">SELECIONE</option>
                <%for(int i=0; i<tabelaSalarial.length; i++){%>
                  <option value="<%=tabelaSalarial[i].getCodTabelaSalarial()%>" ><%=tabelaSalarial[i].getDscTabelaSalarial().toUpperCase()%></option>
                <%}%>
              </select>
            </td>					  					
          </tr>             
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Cargo:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="codCargo" id="codCargo" class="select" style="width: 450px;">
                  <option value="0">SELECIONE</option>
                  <%for(int i=0; i<comboCargo.length; i++){%>
                    <option value="<%=comboCargo[i][0]%>" ><%=comboCargo[i][1]%></option>
                  <%}%>
                </select> 
            </td>
          </tr>
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Unidade:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="codUnidade" id="codUnidade" class="select" style="width: 450px;">
                  <option value="0">SELECIONE</option>
                  <%for(int i=0; i<comboUnidade.length; i++){%>
                    <option value="<%=comboUnidade[i][0]%>" ><%=comboUnidade[i][0] + " - " + comboUnidade[i][1]%></option>
                  <%}%>
                </select> 
            </td>
          </tr>
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="right">
              <a href="##" onclick="pesquisar();">
                <img src="<%=request.getContextPath()%>/imagens/bt_pesquisar.gif" border="0"/>
              </a>
              <a href="formulario.jsp">
                <img src="<%=request.getContextPath()%>/imagens/bt_novo.gif" border="0" hspace="10"/>
              </a>              
            </td>
          </tr>           
          <tr>
            <td colspan="2" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
          </tr>                     
        </table>
      </td>
    </tr>        
   </table>
</form>   
<br>
<div id="divListInstrucao">
</div>
</center>
<br>
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>