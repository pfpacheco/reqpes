<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="java.util.*"%>

<jsp:include page="../../../template/cabecalho.jsp"/>

<% 
   //-- Objetos
   List          unidades = new CargoAdmCoordControl().getCargoAdmCoord();
   Iterator      iterator = null;
   CargoAdmCoord cargoAdmCoord = null;
%>

<BR/>
<script language="javaScript">
  function cadastrar(){
      window.location = "formulario.jsp";
  }  
  //--
  function excluir(idParametro){
        if(confirm("Deseja excluir realmente Unidade?"))
           window.location = "excluir.jsp?codUnidade=" + idParametro;
  } 
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr>
      <td colspan="2"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
        <STRONG>&nbsp;&nbsp;CADASTRO DE CARGOS ADMINISTRATIVOS</STRONG>
      </td>
    </tr>
    <tr class="tdintranet2">
      <td height="35" align="left" width="80%">
        &nbsp;&nbsp;&nbsp;Cadastro contendo as UO's que podem ter o cargo de <b>Assist. Téc. Administrativo I</b><br>&nbsp;&nbsp;&nbsp;como <b>Coordenador Administrativo</b>.
      </td>
      <td width="15%" height="23" class="tdintranet2" background="<%=request.getContextPath()%>/imagens/chapeu_fim_610.gif" align="right" >
        <a href="javaScript:cadastrar();">                  
        <img src="<%= request.getContextPath()%>/imagens/bt_novo.gif" border="0" alt="Clique para adicionar um novo usuário da GEP."/>
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
      <td height="20" class="tdCabecalho"  colspan="2">
      </td>
    </tr>                    
  </table>

<%-- IMPRESSÃO DOS VALORES --%>       
 <%if(unidades != null && unidades.size() > 0){%>
    <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <tr >
      <td align="left"   height="25"  class="tdTemplateLista" width="10%"><STRONG>&nbsp;&nbsp;Código</STRONG></td>
      <td align="left"   height="25"  class="tdTemplateLista" width="80%"><STRONG>&nbsp;Unidade</STRONG></td>
      <td align="center" height="25"  class="tdTemplateLista" width="10%"><STRONG>Opção</STRONG></td>
    </tr>
    <% 
      iterator = unidades.iterator();
      String classCSS = "borderintranet";
      int i = 0;
      while(iterator != null && iterator.hasNext()){        
        classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
        cargoAdmCoord = (CargoAdmCoord) iterator.next();
        i++;
    %>
        <tr>
          <td align="left"   height="25" class="<%= classCSS %>" width="10%">&nbsp;&nbsp;<%=cargoAdmCoord.getCodUnidade()%></td>          
          <td align="left"   height="25" class="<%= classCSS %>" width="80%">&nbsp;<%=cargoAdmCoord.getNomUnidade()%></td>
          <td align="center" height="25" class="<%= classCSS %>" width="10%">
            <a href="javaScript:excluir('<%=cargoAdmCoord.getCodUnidade()%>');">
              <img src="<%= request.getContextPath()%>/imagens/excluir.gif" border="0" alt="Excluir este usuário"/>
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

<jsp:include page="../../../template/fimTemplateIntranet.jsp"/>