<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %>  
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="java.util.*"%>

<jsp:include page="../../../template/cabecalho.jsp"/>

<% 
   //-- Objetos
   Iterator iterator = new CargoAdmCoordControl().getComboUnidades().iterator();
   CargoAdmCoord cargoAdmCoord = null;
%>

<BR/>
<script language="javaScript">
  function cadastrar(){
      if(document.frm.codUnidade.value == '0'){
        alert('Selecione uma Unidade!');
      }else{
        document.frm.submit();
      }
  }  
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <form name="frm" method="POST" action="gravar.jsp">
      <tr>
        <td colspan="2"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
          <STRONG>&nbsp;&nbsp;CADASTRO DE CARGOS ADMINISTRATIVOS</STRONG>
        </td>
          <tr class="tdintranet2">
            <td height="18" align="right" width="20%">
              <STRONG>Unidade:&nbsp;</STRONG>
            </td>
            <td width="80%" height="30" class="tdintranet2" background="<%=request.getContextPath()%>/imagens/chapeu_fim_610.gif" align="left" >
                <select name="codUnidade" class="select" style="width: 400px;">
                  <option value="0">SELECIONE</option>                  
                  <%while(iterator != null && iterator.hasNext()){
                       cargoAdmCoord = (CargoAdmCoord) iterator.next();%>
                    <option value="<%=cargoAdmCoord.getCodUnidade()%>"><%=cargoAdmCoord.getCodUnidade()+" - "+cargoAdmCoord.getNomUnidade()%></option>
                  <%}%>
                </select>
            </td>
          </tr>
          <tr>
            <td height="10" class="tdintranet2" colspan="2"  > </td>
          </tr>                              
          <tr>
            <td height="23" class="tdintranet2" colspan="2" align="right">
              <a href="javaScript:cadastrar();">                  
                <img src="<%= request.getContextPath()%>/imagens/bt_cadastrar.gif" border="0" alt="Cadastrar"/>
              </a>
              <a href="index.jsp">                  
                <img src="<%= request.getContextPath()%>/imagens/bt_voltar.gif" border="0" alt="Voltar" hspace="20"/>
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

<jsp:include page="../../../template/fimTemplateIntranet.jsp"/>