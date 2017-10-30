<%@ page import="br.senac.sp.reqpes.Control.RequisicaoControl" %>
<%@ page import="br.senac.sp.reqpes.Interface.InterfaceDataBase" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page errorPage="../../error/error.jsp" %>

<% 
  //-- Objetos
  StringBuffer sqlQuery = new StringBuffer();
  String codCargo = "";
  
  //-- Parametros de página
  String codUnidade  = request.getParameter("P_COD_UNIDADE");
  String where       = request.getParameter("P_WHERE").trim().replaceAll("aspas","'");
  Boolean isRPAntiga = Boolean.valueOf(request.getParameter("P_IS_RP_ANTIGA").trim());

  //-- Objetos
  String[][] requisicoes = null;
  
  //-- Tratamento dos dados
  where = where.replaceAll("percent","%");
  
  //-- Query contendo a pesquisa de acordo com os parametros recebidos
  sqlQuery.append(" SELECT V.COD_CARGO ");
  sqlQuery.append("       ,V.DSC_CARGO ");
  sqlQuery.append("       ,V.REQUISICAO_SQ ");
  sqlQuery.append("       ,TO_CHAR(V.DAT_REQUISICAO, 'dd/mm/yyyy') DAT_REQUISICAO ");
  sqlQuery.append("       ,V.TIPO_REQUISICAO ");
  sqlQuery.append("       ,V.DSC_STATUS ");
  sqlQuery.append("       ,V.DSC_MOTIVO_SOLICITACAO ");
  sqlQuery.append("       ,V.DSC_TIPO_CONTRATACAO ");
  sqlQuery.append("       ,V.CHAPA_FUNC_BAIXADO ");
  sqlQuery.append("       ,V.NOM_FUNC_BAIXADO ");
  sqlQuery.append("       ,V.COD_STATUS ");
  sqlQuery.append(" FROM   VW_DADOS_COMPLETOS_REQUISICAO V ");
  sqlQuery.append(" WHERE  V.COD_UNIDADE = '"+ codUnidade +"' ");
  sqlQuery.append(where);
  sqlQuery.append(" ORDER  BY V.COD_CARGO, V.REQUISICAO_SQ ");
  
  //-- Verificando em qual owner realizar a pesquisa, RP atuais ou antigas
  if(isRPAntiga.booleanValue()){
    requisicoes = new RequisicaoControl().getMatriz(sqlQuery.toString(), InterfaceDataBase.DATA_BASE_NAME_VS_ANTERIOR);
  }else{
    requisicoes = new RequisicaoControl().getMatriz(sqlQuery.toString());
  }
%>

<table border="0" bgcolor="#FFFFFF" cellpadding="0" cellspacing="0"  width="100%">
<tr>
  <td width="100%">
    <table border="0"  bgcolor="#FFFFFF"  width="100%">                 
        <%
          String classCSS = "borderintranet";
          for(int i=0; i<requisicoes.length; i++){
            classCSS = ((i%2)==1)?"borderintranet":"tdintranet2";     
            if(!codCargo.equals(requisicoes[i][0])){                      
              codCargo = requisicoes[i][0]; 
            %>
              <tr >
                <td colspan="5" height="3" align="left" class="borderintranet" width="100%"> </td>
              </tr>            
              <tr >
                <td colspan="5" align="left" class="tdIntranet" width="100%"><STRONG>Cargo:&nbsp;</STRONG><%=(requisicoes[i][1]==null)?"NÃO INFORMADO":requisicoes[i][1]%></td>
              </tr>                      
              <tr>
                <td align="center" class="tdintranet2" width="10%">
                  <strong>RP</strong>
                </td>
                <td align="center" class="tdintranet2" width="15%">
                  <strong>Data</strong>
                </td>
                <td align="center" class="tdintranet2" width="20%">
                  <strong>Recrutamento</strong>
                </td>                  
                <td align="center" class="tdintranet2" width="35%">
                  <strong>Motivo solicitação</strong>
                </td>                 
                <td align="center" class="tdintranet2" width="20%">
                  <strong>Status</strong>
                </td>                   
              </tr>                
            <%}%>
          <tr>
            <td align="center" class="<%=classCSS%>" width="10%">
              <a href="javaScript:requisicaoDados('codRequisicao=<%=requisicoes[i][2]%>');" title="Visualizar RP"><%=requisicoes[i][2]%></a>
            </td>          
            <td align="center" class="<%=classCSS%>" width="15%">
              <a href="javaScript:requisicaoHistorico('codRequisicao=<%=requisicoes[i][2]%>');" title="Visualizar histórico da RP"><%=requisicoes[i][3]%></a>
            </td>
            <td align="center" class="<%=classCSS%>" width="20%">
              <%=(requisicoes[i][4]==null)?"---":requisicoes[i][4]%>
            </td>  
            <td align="center" class="<%=classCSS%>" width="35%">
              <%=(requisicoes[i][6]==null)?"---":requisicoes[i][6]%>
            </td>            
            <td align="center" class="<%=classCSS%>" width="20%">
              <%=(requisicoes[i][5]==null)?"---":requisicoes[i][5]%>
            </td>                   
          </tr>  
          <%if(requisicoes[i][10].equals("6")){%>
            <tr>
              <td align="center" class="tdintranet2" colspan="5">
                <br><strong>&nbsp;&nbsp;&nbsp;&nbsp;
                Funcionário utilizado na baixa:</strong>
                <%=(requisicoes[i][8] != null && requisicoes[i][9] != null)?requisicoes[i][8]+" - "+requisicoes[i][9]:"Funcionário não localizado."%>
                <br>&nbsp;
              </td>          
            </tr>
          <%}%>
       <%}%>
    </table>
  </td>
</tr>
</table>