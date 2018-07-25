<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page errorPage="../error/error.jsp" %>

<%
  //-- Objetos de sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");  
  
  if(usuario == null){
    out.print("<script>window.location = '../error/error.jsp';</script>");  
  }

  //-- Objetos Control
  RequisicaoControl requisicaoControl = new RequisicaoControl();
  ResponsavelEstruturaControl responsavelEstruturaControl = new ResponsavelEstruturaControl();
  SistemaParametroControl     sistemaParametroControl     = new SistemaParametroControl();   
  
  //-- Parametros de página
  int codRequisicao   = Integer.parseInt(request.getParameter("codRequisicao"));
  Boolean isRPAntiga  = (request.getParameter("isRPAntiga")==null)?Boolean.FALSE:Boolean.valueOf(request.getParameter("isRPAntiga").trim());  
  
  //-- Objetos
  SistemaParametro[] idPerfilGEP = null;
  SistemaParametro unidadeAPR = null; 
  String[][] historico = null;
  String[][] historicoCampos = null;
  String[][] dadosHistoricoAtual = null;
  String[] gerenteAtual = null;    
  String dataSource = null;
  String classCSS = "borderintranet";
  String perfil = null;
  String conteudo = "";
  
  //-- Verificando em qual owner realizar a pesquisa, RP atuais ou antigas  
  if(isRPAntiga.booleanValue()){
    dataSource = InterfaceDataBase.DATA_BASE_NAME_VS_ANTERIOR;
  }else{
    dataSource = InterfaceDataBase.DATA_BASE_NAME;
  }
  
  //-- Resgatando os dados de histórico
  historico = requisicaoControl.getHistoricoRequisicao(codRequisicao, dataSource);
  
  //-- Resgatando os dados de histórico campos alterados
  historicoCampos = requisicaoControl.getHistoricoPerfilCampos(codRequisicao, dataSource);  
  
  
  //-- Resgatando os dados do usuário que está com a RP
  if(historico != null && historico.length > 0 && historico[historico.length-1][9] != null){
     switch (Integer.parseInt(historico[historico.length-1][9])){
      //-- Gerente de Unidade
      case 1:  perfil = "GERENTE DA UNIDADE";
               gerenteAtual = responsavelEstruturaControl.buscarUnidadeDestino(historico[0][8]); //Retorno: 0-UO / 1-CHAPA
               dadosHistoricoAtual = requisicaoControl.getDadosUsuarioAtualHistorico(Integer.parseInt(gerenteAtual[1]));
               break;
               
      //-- Homologador Unidade Aprovadora
      case 3:  perfil = "HOMOLOGADOR GEP - AP&B";
               idPerfilGEP = sistemaParametroControl.getSistemaParametros(" WHERE SP.COD_SISTEMA = "+Config.ID_SISTEMA+" AND SP.NOM_PARAMETRO = 'HOMOLOGADOR_GEP'");
               dadosHistoricoAtual = requisicaoControl.getDadosUsuarioAtualHistorico(Integer.parseInt(idPerfilGEP[0].getVlrSistemaParametro()));
               break;                              
               
      //-- Homologador Unidade Aprovadora
      case 2:  perfil = "HOMOLOGADOR GEP - NEC";
               dadosHistoricoAtual = requisicaoControl.getDadosUsuarioAtualHistorico(historico[0][8]);
               break;                    

      //-- Gerente Unidade Aprovadora
      case 4:  perfil = "APROVADOR GEP";
               unidadeAPR  = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"UNIDADE_APROVADORA");
               gerenteAtual = responsavelEstruturaControl.buscarUnidadeDestino(unidadeAPR.getVlrSistemaParametro()); //Retorno: 0-UO / 1-CHAPA
               dadosHistoricoAtual = requisicaoControl.getDadosUsuarioAtualHistorico(Integer.parseInt(gerenteAtual[1]));      
               break;
     
      case 5: perfil = "";
		      break;
               
      default: perfil = "ADMINISTRATIVO";
               dadosHistoricoAtual = requisicaoControl.getDadosUsuarioAtualHistoricoPorUsuarioSq(Integer.parseInt(historico[0][10]));
               break;
     }                
  }
%>

<!DOCTYPE html>
<html>
<style>
.tooltip {
    position: relative;
    display: inline-block;
    border-bottom: 1px dotted black;
}

.tooltip .tooltiptext {
    visibility: hidden;
    background-color: #555;
    color: #fff;
    min-width: 425px;
    text-align: center;
    border-radius: 6px;
    padding-left: 5px;
    position: absolute;
    padding-right: 5px;
    z-index: 1;
    /* left: 20%; */
    margin-left: -600px;
    /* margin-top: -250px; */
    margin-top: 8px;
    opacity: 0;
    transition: opacity 0s;
}

.tooltip .tooltiptext p{
	white-space: pre;
}

/*.tooltip .tooltiptext::before {
    content: "";
    position: absolute;
    top: -50%;
    left: 50%;
    margin-left: -5px;
    border-width: 10px;
    border-style: solid;
    border-color: transparent transparent #555 transparent;
}*/

.ponta {
    content: "";
    position: absolute;
    top: 0px;
    left: 50%;
    border-width: 10px;
    border-style: solid;
    border-color: transparent transparent #555 transparent;
    visibility: hidden;
    opacity: 0;
}

.tooltip:hover .tooltiptext {
    visibility: visible;
    opacity: 1;
}

.tooltip:hover .ponta {
    visibility: visible;
    opacity: 1;
}

</style>

<head>
  <link href="<%=request.getContextPath()%>/css/stylesheet.css" rel="STYLESHEET" type="text/css"/>
  <title><%=Config.NOME_SISTEMA%></title>
</head>

<body onload="focus();">

<script language="javaScript">
  function imprimir(){    
    botoes.style.visibility="hidden";    
    window.print();
  }
</script>

<%if(historico != null && historico.length > 0){%>
  <table width="617" border="0" align="center">
      <tr>
        <td>
          <table width="100%" border="0" cellpadding="0" cellspacing="1">
            <tr>
              <td colspan="4" height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
               <STRONG>DADOS DA REQUISIÇÃO</STRONG>
              </td>
            </tr>           
            <tr>
              <td height="23" align="left" class="tdIntranet2" width="20%">
               &nbsp;<STRONG>Número RP</STRONG><br>&nbsp;<%=historico[0][0]%>
              </td>
              <td height="23" align="left" class="tdIntranet2" width="20%">
               &nbsp;<STRONG>Tipo <%=(isRPAntiga.booleanValue())?"":"de recrutamento"%></STRONG><br>&nbsp;<%=historico[0][1]%>
              </td>                
              <td height="23" align="left" class="tdIntranet2" width="20%">
               &nbsp;<STRONG>Data de criação</STRONG><br>&nbsp;<%=historico[0][2]%>
              </td>        
              <td height="23" align="left" class="tdIntranet2" width="20%">
               &nbsp;<STRONG>Unidade</STRONG><br>&nbsp;<%=historico[0][8]%>
              </td>                  
            </tr>    
            <tr>
              <td height="3" colspan="4" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
            </tr>              
          </table>
          <br>
          <table width="100%" border="0" cellpadding="0" cellspacing="1">
            <tr>
              <td colspan="6" height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
               <STRONG>HISTÓRICO</STRONG>
              </td>
            </tr>           
            <tr>
              <td height="23" align="center" class="tdIntranet" width="45%">
               <STRONG>Usuário</STRONG>
              </td>
              <td height="23" align="center" class="tdIntranet" width="8%">
               <STRONG>Da<br>Unidade</STRONG>
              </td>                
              <td height="23" align="center" class="tdIntranet" width="22%">
               <STRONG>Em</STRONG>
              </td>        
              <td height="23" align="center" class="tdIntranet" width="17%">
               <STRONG>Ação</STRONG>
              </td>                  
              <td height="23" align="center" class="tdIntranet" width="9%">
               <STRONG>Para a<br>Unidade</STRONG>
              </td>  


            </tr> 
            
            <% // Varrendo o array de histórico da requisição informada 
               for(int i=0; i<historico.length; i++){
                 classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
                 conteudo="";
               
               for(int j=0; j<historicoCampos.length; j++ ){
            	 if (historico[i][10].equals( historicoCampos[j][1])) {
            		 if (historico[i][5].equals( historicoCampos[j][2])) {
                         if(historico[i][6].equals("alterou"))
            			   conteudo= conteudo + "<p>" + historicoCampos[j][3] +" - foi alterado de "  + historicoCampos[j][4] + " para " + historicoCampos[j][5]+"</p>";
            			else
            				conteudo= conteudo + "<p>" + historicoCampos[j][3] +"</p>";
                	 }
               	 }
               }
            %>
                  <tr>
                    <td height="23" align="left"   class="<%=classCSS%>" width="45%">&nbsp;<%=(historico[i][4]==null)?"":historico[i][4]%></td>
                    <td height="23" align="center" class="<%=classCSS%>" width="8%"><%=(historico[i][3]==null)?"-":historico[i][3]%></td>                
                    <td height="23" align="left"   class="<%=classCSS%>" width="22%">&nbsp;<%=(historico[i][5]==null)?"":historico[i][5]%></td> 
                
                
               <% if(conteudo!="") { %> 
                    <td height="23" align="left" class="<%=classCSS%>" width="17%">&nbsp;<div class="tooltip"><%=(historico[i][6]==null)?"":(historico[i][6].equals("solicitou revis?o"))?"solicitou revisão":historico[i][6]%>
                    <div class="ponta"></div>
                    <span class="tooltiptext"><%=conteudo %></span></div></td>
               <% } else { %>
                    <td height="23" align="left" class="<%=classCSS%>" width="17%">&nbsp;<%=(historico[i][6]==null)?"":(historico[i][6].equals("solicitou revis?o"))?"solicitou revisão":historico[i][6]%><%=conteudo %></td>
               <% } %> 
                
                    <td height="23" align="center" class="<%=classCSS%>" width="10%"><%=(historico[i][7]==null)?"":historico[i][7]%></td>  
                  </tr>             
             <%}%>
            
            <tr>
              <td height="3" colspan="6" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
            </tr>              
          </table>
          <br>
          <%//-- Imprimindo o usuário atual com a RP            
            if(perfil != null && !perfil.equals("")){%>
              <table width="100%" border="0" cellpadding="0" cellspacing="1">
                <tr>
                  <td colspan="3" height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
                   <STRONG>STATUS NO WORKFLOW</STRONG>
                  </td>
                </tr>           
                <tr>
                  <td height="23" align="center" class="tdIntranet" width="10%">
                   <STRONG>UO</STRONG>
                  </td>            
                  <td height="23" align="center" class="tdIntranet" width="30%">
                   <STRONG>Perfil</STRONG>
                  </td>
                  <td height="23" align="center" class="tdIntranet" width="60%">
                   <STRONG>Usuário</STRONG>
                  </td>
                </tr>
                <tr>
                  <td height="23" align="center" class="tdIntranet2" width="10%"><%=dadosHistoricoAtual[0][0]%></td>
                  <td height="23" align="center" class="tdIntranet2" width="30%"><%=perfil%></td>
                  <td height="23" align="center" class="tdIntranet2" width="60%">&nbsp;<%=dadosHistoricoAtual[0][1]%></td>
                </tr>    
                <tr>
                  <td height="3" colspan="3" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
                </tr>             
              </table>          
              <br>
          <%}%>
          <div id="botoes" align="center">
            <img style="cursor: hand;" src="<%= request.getContextPath()%>/imagens/bt_imprimir.gif" onclick="imprimir();"/>
            &nbsp;&nbsp;
            <img style="cursor: hand;" src="<%= request.getContextPath()%>/imagens/bt_fechar.gif" onclick="javascript: window.close();"/>
          </div>            
        </td>
      </tr>
    </table>
<%}else{%> 
    <table width="617" border="0" align="center">
      <tr>
        <td align="center">
          <table width="100%" border="0" cellpadding="0" cellspacing="1">
            <tr>
              <td height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
               <STRONG>HISTÓRICO DE REQUISIÇÃO</STRONG>
              </td>
            </tr>           
            <tr>
              <td height="23" align="left" class="tdIntranet2" width="20%">
               &nbsp;Não exitem registros de histórico associado com a RP: <STRONG><%=codRequisicao%></STRONG>
              </td>
            </tr>    
            <tr>
              <td height="3" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
            </tr>              
          </table>
          <br>
          <img style="cursor: hand;" src="<%= request.getContextPath()%>/imagens/bt_fechar.gif" onclick="javascript: window.close();"/>
        </td>
      </tr>
    </table>
<%}%>
</body>