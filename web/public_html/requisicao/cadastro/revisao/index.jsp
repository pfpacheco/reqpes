<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<%
  //-- Parametros de página
  int codRequisicao = Integer.parseInt(request.getParameter("codRequisicao"));
  
  //-- Resgatando o último histórico de revisão da RP
  RequisicaoRevisao[] requisicaoRevisao = new RequisicaoRevisaoControl().getDadosRevisao(codRequisicao);
%>

<%if(requisicaoRevisao != null && requisicaoRevisao.length > 0){%>
  <table border="0" width="610" cellpadding="0" cellspacing="0">
    <tr>
      <td colspan="2"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
       <STRONG>&nbsp;&nbsp;SOLICITAÇÃO DE REVISÃO</STRONG>
      </td>
    </tr>
    <tr>
      <td height="25" align="left" class="tdintranet" colspan="2"><strong>&nbsp;&nbsp;DADOS DA REQUISIÇÃO</strong></td>
    </tr>
    <tr>
      <td height="25" align="right" class="tdintranet2" width="20%"><strong>Número da RP:&nbsp;</strong></td>
      <td height="25" align="left" class="tdintranet2"><%=requisicaoRevisao[0].getCodRequisicao()%></td>					  					
    </tr>
    <tr>
      <td height="25" align="right" class="tdintranet2" width="20%"><strong>Data de criação:&nbsp;</strong></td>
      <td height="25" align="left" class="tdintranet2"><%=requisicaoRevisao[0].getDataHoraCriacao()%></td>					  					
    </tr>
    <tr>
      <td height="25" align="right" class="tdintranet2" width="20%"><strong>Nome do criador:&nbsp;</strong></td>
      <td height="25" align="left" class="tdintranet2"><%=requisicaoRevisao[0].getNomCriador()%></td>					  					
    </tr>
    <tr>
      <td height="25" align="right" class="tdintranet2" width="20%"><strong>UO do criador:&nbsp;</strong></td>
      <td height="25" align="left" class="tdintranet2"><%=requisicaoRevisao[0].getCodUnidadeCriador() +" - "+ requisicaoRevisao[0].getNomUnidadeCriador()%></td>
    </tr>
    <tr>
      <td height="25" align="left" class="tdintranet" colspan="2"><strong>&nbsp;&nbsp;DADOS DA REVISÃO</strong></td>
    </tr>
    <tr>
      <td height="25" align="right" class="tdintranet2" width="20%"><strong>Total de revisões:&nbsp;</strong></td>
      <td height="25" align="left" class="tdintranet2"><%=requisicaoRevisao[0].getNroRevisoes()%></td>					  					
    </tr>    
    <tr>
      <td height="25" align="right" class="tdintranet2" width="20%"><strong>Data da revisão:&nbsp;</strong></td>
      <td height="25" align="left" class="tdintranet2"><%=requisicaoRevisao[0].getDataHoraEnvio()%></td>					  					
    </tr>
    <tr>
      <td height="25" align="right" class="tdintranet2" width="20%"><strong>Nome do revisor:&nbsp;</strong></td>
      <td height="25" align="left" class="tdintranet2"><%=requisicaoRevisao[0].getNomRevisor()%></td>					  					
    </tr>
    <tr>
      <td height="25" align="right" class="tdintranet2" width="20%"><strong>UO do revisor:&nbsp;</strong></td>
      <td height="25" align="left" class="tdintranet2"><%=requisicaoRevisao[0].getCodUnidadeRevisor() +" - "+ requisicaoRevisao[0].getNomUnidadeRevisor()%></td>
    </tr>
    <tr>
      <td height="25" align="right" class="tdintranet2" width="20%" valign="top"><strong>Motivo:&nbsp;</strong></td>
      <td height="25" align="left" class="tdintranet2" valign="top"><%=requisicaoRevisao[0].getDscMotivo()%></td>
    </tr>    
    <tr>
      <td colspan="2" height="10" class="tdIntranet2" align="right"></td>
    </tr>                       
    <tr>
      <td colspan="2" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
    </tr>            
  </table>
  <br>
<%}%>