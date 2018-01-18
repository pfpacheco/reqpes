<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
 
<jsp:include page="../../template/cabecalho.jsp"/>

<%
  //-- Objetos de controle
  SistemaParametroControl     sistemaParametroControl     = new SistemaParametroControl();  
  RequisicaoControl           requisicaoControl           = new RequisicaoControl();
  RequisicaoRevisaoControl    requisicaoRevisaoControl    = new RequisicaoRevisaoControl();
  RequisicaoAprovacaoControl  requisicaoAprovacaoControl  = new RequisicaoAprovacaoControl();  
  ResponsavelEstruturaControl responsavelEstruturaControl = new ResponsavelEstruturaControl();
  
  //-- Objetos de sess�o
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Parametros de p�gina
  String codRequisicao = (request.getParameter("codRequisicao")==null)?"":request.getParameter("codRequisicao");  
  String codUnidade    = (request.getParameter("codUnidade")==null)?"0":request.getParameter("codUnidade");  
  String codCargo      = (request.getParameter("codCargo")==null)?"0":request.getParameter("codCargo");   
  int numeroDaPagina   = (request.getParameter("numeroDaPagina")==null)?1:Integer.parseInt(request.getParameter("numeroDaPagina"));   
  int qtdPorPagina     = (request.getParameter("qtdPorPagina")==null)?40:Integer.parseInt(request.getParameter("qtdPorPagina"));   
  
  //-- Objetos
  SistemaParametro idPerfilADM   = null;
  SistemaParametro idPerfilAPR   = null;  
  SistemaParametro idPerfilHOM   = null;  
  SistemaParametro idPerfilGEP   = null;
  SistemaParametro idPerfilNEC   = null;
  SistemaParametro qtdRevisoesRP = null;
  
  String[][] requisicao   = null;
  String[][] comboUnidade = null;
  String[][] comboCargo   = null;  
  String where = "";
  String todasUnidades = "";   

  //-- Vari�veis da p�gina  
  int idPerfilUsuario = usuario.getSistemaPerfil().getCodSistemaPerfil();
  int nivelWorkFlow   = 0;
  int qtdRevisoes     = 0;  
  boolean isPerfilCRI = false;
  boolean isPerfilHOM = false;
  boolean isPerfilGEP = false;
  boolean isPerfilNEC = false;
  boolean isPerfilADM = false;
  boolean isPerfilAPR = false;
   
  //-- Resgatando os parametros do sistema
  idPerfilADM   = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_ADM_GES");
  idPerfilAPR   = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_APR_GEP");
  idPerfilHOM   = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_UO");
  idPerfilGEP   = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_GEP");
  idPerfilNEC   = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_NEC");
  qtdRevisoesRP = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"REQUISICAO_QTD_REVISOES");
  
  //-- Carregando os combos
  comboUnidade = requisicaoControl.getComboUnidadesRelacionadas();
  comboCargo   = requisicaoControl.getComboCargosExistentesRequisicao();  
  
  //-- Verificando as cl�usulas da pesquisa
  if(!codRequisicao.equals("")){
    where += " AND REQUISICAO_SQ = " + codRequisicao ;
  }

  if(!codUnidade.equals("0")){
    where += " AND COD_UNIDADE = '" + codUnidade +"'";
  }
  
  if(!codCargo.equals("0")){
    where += " AND CARGO_SQ = " + codCargo ;
  }    
  
  //-- Verificando as unidades de acesso
  for(int i=0; usuario.getUnidades() != null && i < usuario.getUnidades().length; i++){
    todasUnidades += ((i==0)?" ":",") + usuario.getUnidades()[i].getCodUnidade();
  } 
  
  //-- Verificando qual m�todo chamar para listagem de requisi��es do WorkFlow
  if(idPerfilUsuario == Integer.parseInt(idPerfilADM.getVlrSistemaParametro())){
    //-- todas as requisi��es no processo de aprova��o
    isPerfilADM = true;
    requisicao = requisicaoAprovacaoControl.getRequisicoesParaHomologacao(where);    
    //out.println("(ADMINISTRADOR GERAL)");
    
  }else if(idPerfilUsuario == Integer.parseInt(idPerfilAPR.getVlrSistemaParametro())){
          //-- NIVEL 54 (APROVADOR)
          //-- requisi��es homologadas pela GEP
          requisicao = requisicaoAprovacaoControl.getRequisicoesParaHomologacaoAPR();
          nivelWorkFlow = 5;
          isPerfilAPR = true;
          //out.println("(APROVADOR)");
          
        }else{
              if(idPerfilUsuario == Integer.parseInt(idPerfilGEP.getVlrSistemaParametro())){
                //-- NIVEL 3 (HOMOLOGADOR AP&B)
                isPerfilGEP = true;
               // nivelWorkFlow = 3; original
                nivelWorkFlow = 4;

                
                //-- requisi��es homologadas pelos gerentes das unidades
                requisicao  = requisicaoAprovacaoControl.getRequisicoesParaHomologacaoGEP();
                //out.println("(HOMOLOGADOR GEP - AP&B)");                
                
              }else if(idPerfilUsuario == Integer.parseInt(idPerfilNEC.getVlrSistemaParametro())){
                      //-- NIVEL 4 (HOMOLOGADOR NEC)
                      isPerfilNEC = true;
                      //nivelWorkFlow = 4; original     
                       nivelWorkFlow = 3;
                      
                      //-- requisi��es solicitadas pelas unidades em que � respons�vel
                      requisicao = requisicaoAprovacaoControl.getRequisicoesParaHomologacaoNEC(usuario.getChapa());
                      //out.println("(HOMOLOGADOR GEP - NEC)");
                      
                    }else if(idPerfilUsuario == Integer.parseInt(idPerfilHOM.getVlrSistemaParametro())){
                            //-- NIVEL 2 (HOMOLOGADOR UO)
                            isPerfilHOM = true;
                            nivelWorkFlow = 2;                  
                            
                            //-- requisi��es solicitadas pelas unidades em que � respons�vel
                            requisicao = requisicaoAprovacaoControl.getRequisicoesParaHomologacaoUO(usuario.getUnidade().getCodUnidade(),todasUnidades);
                            //out.println("(HOMOLOGADOR UNIDADE)");                           
                          }else{
                            //-- NIVEL 1 (CRIADOR)
                            isPerfilCRI = true;                      
                            //-- requisi��es em revis�o
                            requisicao = requisicaoRevisaoControl.getRequisicoesParaRevisao(usuario.getUnidade().getCodUnidade(), todasUnidades);
                            //out.println("(CRIADOR)");                      
                          }
              }
%>

<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js" type="text/javascript"></script> 
<script language="javaScript">
  //--
  function requisicaoDados(parametro){
    popUP('<%=request.getContextPath()%>/relatorio/index.jsp?'+parametro,'link','toolbar=no,width=660,height=600,scrollbars=yes');
  }
  //--
  function requisicaoHistorico(parametro){
    popUP('<%=request.getContextPath()%>/relatorio/historico.jsp?'+parametro,'link','toolbar=no,width=660,height=600,scrollbars=yes');
  }   
  //-- 
  function limpaCampos(){
    document.frmRequisicao.codCargo.value = 0;
    document.frmRequisicao.codUnidade.value = 0;
  }  
  //--
  function revisar(codRequisicao){
    window.location = "<%=request.getContextPath()%>/requisicao/cadastro/formulario.jsp?codRequisicao="+codRequisicao;
  }
  //--
  function solicitarRevisao(codRequisicao, qtdRevisoes){
    // verifica se atingiu o n�mero m�ximo de revis�es
    if(parseInt(qtdRevisoes) < <%=Integer.parseInt(qtdRevisoesRP.getVlrSistemaParametro())%>){    
      if(confirm("Deseja realmente solicitar revis�o da RP n� "+codRequisicao+"?")){
        window.location = "<%=request.getContextPath()%>/requisicao/cadastro/revisao/formulario.jsp?codRequisicao="+codRequisicao;
      }  
    }else{
      alert('N�o � poss�vel solicitar revis�o para a RP '+codRequisicao+'!\nO n�mero de revis�es atingiu o m�ximo permitido pelo sistema (<%=qtdRevisoesRP.getVlrSistemaParametro()%> revis�es).');
    }
  }
  //--
  function cancelar(codRequisicao){
    if(confirm("Deseja realmente cancelar a RP n� "+codRequisicao+"?")){
      window.location = "<%=request.getContextPath()%>/requisicao/cadastro/exclusao/formulario.jsp?indWorkFlow=true&codRequisicao="+codRequisicao;
    }  
  }
  //--
  function aprovar(codRequisicao){
    if(confirm("Confirma a aprova��o da RP n� "+codRequisicao+"?")){
      window.location = "<%=request.getContextPath()%>/requisicao/aprovar/aprovar.jsp?nivelWorkFlow=<%=nivelWorkFlow%>&codRequisicao="+codRequisicao;
    }  
  }
  //--
  function reprovar(codRequisicao){
    if(confirm("Deseja realmente reprovar a RP n� "+codRequisicao+"?")){
      window.location = "<%=request.getContextPath()%>/requisicao/aprovar/formulario.jsp?codRequisicao="+codRequisicao;
    }  
  }
  //--
  function pesquisar(){
    document.frmRequisicao.submit();
  }
  //--
  function irParaPagina(qtdPorPagina,numeroDaPagina){
    document.frmRequisicao.numeroDaPagina.value = numeroDaPagina;
    document.frmRequisicao.qtdPorPagina.value   = qtdPorPagina;
    document.frmRequisicao.submit();
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
             <STRONG>&nbsp;&nbsp;APROVA��O DE REQUISI��ES</STRONG>
            </td>
          </tr>  
          <%-- EXIBE O FILTRO APENAS PARA O ADMINISTRADOR DO SISTEMA --%>
          <%if(isPerfilADM){%>
              <tr>
                <td height="25" align="right" class="tdintranet2" width="20%">
                  <strong>N�mero da RP:&nbsp;</strong>
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
          <%}%>
          <tr>
            <td colspan="2" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
          </tr>            
        </table>
        
        <%=(isPerfilADM)?"<br>":""%>
   
        <%-- IMPRESS�O DOS VALORES --%>       
        <table border="0" cellpadding="0" cellspacing="0" width="610" >
        <%if(requisicao != null && requisicao.length > 0){
           if(!isPerfilADM){%>
              <tr>
                <td colspan="5" height="30" class="tdIntranet2">
                  <%-- GERA��O DA LEGENDA --%>
                  <table width="100%" class="tdIntranet" align="center">
                    <tr>
                      <%if(isPerfilCRI){%>
                          <td align="center" width="100%">
                            <img src="<%=request.getContextPath()%>/imagens/bt_revisar.png" border="0"/><br>Efetuar revis�o
                          </td>
                      <%}else{%>                      
                          <td align="center" width="20%">
                            <img src="<%=request.getContextPath()%>/imagens/bt_revisao.png" border="0"/><br>Solicitar revis�o
                          </td>
                          <%-- Exibe legenda de CANCELAMENTO de RP's aos homologadores (Exceto GERENTE DA UO Aprovadora) --%>
                          <%if(isPerfilHOM || isPerfilGEP || isPerfilNEC){%>
                              <td align="center" width="20%">
                                <img src="<%=request.getContextPath()%>/imagens/bt_cancelar.png" border="0"/><br>Cancelar
                              </td>
                              <td align="center" width="20%">
                                <img src="<%=request.getContextPath()%>/imagens/bt_revisar.png" border="0"/><br>Efetuar revis�o
                              </td>  
                          <%}%>                          
                          <td align="center" width="20%">
                            <img src="<%=request.getContextPath()%>/imagens/bt_aprovar.png" border="0"/><br>Aprovar
                          </td>
                          <td align="center" width="20%">
                            <img src="<%=request.getContextPath()%>/imagens/bt_reprovar.png" border="0"/><br>Reprovar
                          </td>
                      <%}%>
                    </tr>
                  </table>
                </td>
              </tr>  
              <tr> 
                <td colspan="5"><br></td>
              </tr>        
          <%}%>
          <tr >
            <td align="center" height="25"  class="tdTemplateLista" width="8%"><STRONG>RP</STRONG></td>
            <td align="center" height="25"  class="tdTemplateLista" width="10%"><STRONG>Data</STRONG></td>
            <td align="left"   height="25"  class="tdTemplateLista" width="47%">&nbsp;&nbsp;&nbsp;<STRONG>Cargo</STRONG></td>
            <td align="center" height="25"  class="tdTemplateLista" width="15%"><STRONG>Unidade</STRONG></td>
            <td align="center" height="25"  class="tdTemplateLista" width="15%"><STRONG><%=(isPerfilADM)?"Status":"Op��es"%></STRONG></td>
          </tr>
          <%
            String classCSS = "borderintranet";
            int qtdLinhas      = requisicao.length;
            qtdPorPagina       = (qtdLinhas>qtdPorPagina)?qtdPorPagina:qtdLinhas;
            int registroIncial = ((numeroDaPagina -1) * qtdPorPagina);
            int registroFinal  = registroIncial + qtdPorPagina;
            registroFinal      = (qtdLinhas>registroFinal)?registroFinal:qtdLinhas;      
      
            for(int i=registroIncial;i<registroFinal;i++){
              classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
          %>
              <tr >
                <td align="center" height="25" class="<%= classCSS %>" width="8%">
                  <a href="javaScript:requisicaoDados('codRequisicao=<%=requisicao[i][0]%>');" title="Visualizar RP">
                    <%=requisicao[i][0]%>
                  </a>
                </td>
                <td align="center" height="25" class="<%= classCSS %>" width="10%">
                  <a href="javaScript:requisicaoHistorico('codRequisicao=<%=requisicao[i][0]%>');" title="Visualizar hist�rico da RP">
                    <%=requisicao[i][1]%>
                  </a>
                </td>
                <td align="left"   height="25" class="<%= classCSS %>" width="47%">&nbsp;&nbsp;<%=(requisicao[i][2]==null)?"":requisicao[i][2]%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="15%" title="<%=requisicao[i][8]%>"><%=(requisicao[i][3]==null)?"":requisicao[i][3]+" / "+requisicao[i][7]%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="15%">
                 <%if(isPerfilADM){
                    out.print(requisicao[i][5]+"&nbsp;");                    
                  }else if(isPerfilCRI){%>
                      <a href="javaScript:revisar(<%=requisicao[i][0]%>);" title="Efetuar revis�o">
                        <img src="<%=request.getContextPath()%>/imagens/bt_revisar.png" border="0"/>
                      </a>
                  <%}else{%>
                      <% // Rotina que traz a quantidade de revis�es que a RP teve
                         qtdRevisoes = requisicaoRevisaoControl.getQtdRevisoes(Integer.parseInt(requisicao[i][0]));                      
                                            
                         // Exibe op��o de CANCELAMENTO de RP's aos homologadores (Exceto GERENTE DA UO Aprovadora)
                         if(isPerfilHOM || isPerfilGEP || isPerfilNEC){%>
                           <a href="javaScript:cancelar(<%=requisicao[i][0]%>);" title="Cancelar">
                            <img src="<%=request.getContextPath()%>/imagens/bt_cancelar.png" border="0"/>
                           </a>                     
                           <%-- Exibe RP's em revis�o para os gerentes de unidades (Exceto UO Aprovadora) --%>
                           <%if(requisicao[i][6].equals("3")){%>
                               <a href="javaScript:revisar(<%=requisicao[i][0]%>);" title="Efetuar revis�o">
                                 <img src="<%=request.getContextPath()%>/imagens/bt_revisar.png" border="0"/>
                               </a>                      
                           <%}else{%>
                               <a href="javaScript:solicitarRevisao(<%=requisicao[i][0]%>,<%=qtdRevisoes%>);" title="Solicitar revis�o">
                                 <img src="<%=request.getContextPath()%>/imagens/bt_revisao.png" border="0"/>                                 
                               </a>
                               <a href="javaScript:aprovar(<%=requisicao[i][0]%>);" title="Aprovar">
                                 <img src="<%=request.getContextPath()%>/imagens/bt_aprovar.png" border="0"/>
                               </a>                                                        
                          <%}%>                        
                        <%}%>
                        <%if(isPerfilAPR){%>
                            <a href="javaScript:solicitarRevisao(<%=requisicao[i][0]%>,<%=qtdRevisoes%>);" title="Solicitar revis�o">
                              <img src="<%=request.getContextPath()%>/imagens/bt_revisao.png" border="0"/>
                            </a>                        
                            <a href="javaScript:aprovar(<%=requisicao[i][0]%>);" title="Aprovar">
                              <img src="<%=request.getContextPath()%>/imagens/bt_aprovar.png" border="0"/>
                            </a>  
                        <%}%>                        
                        <a href="javaScript:reprovar(<%=requisicao[i][0]%>);" title="Reprovar">
                          <img src="<%=request.getContextPath()%>/imagens/bt_reprovar.png" border="0"/>
                        </a>        
                  <%}%>
                </td>                
              </tr>
          <%}%>
          </table>
          <%-- PAGINA��O --%>
          <jsp:include page="../../template/paginacao.jsp"                      >
            <jsp:param  name="pNumeroDeRegistros" value="<%=requisicao.length%>"/>
            <jsp:param  name="pQtdPorPagina"      value="<%=qtdPorPagina%>"    />
            <jsp:param  name="pNumeroDaPagina"    value="<%=numeroDaPagina%>"  />
            <jsp:param  name="pUrlLink"           value="index.jsp"            />
          </jsp:include>             
        <tr>
          <td colspan="5" height="3" class="tdIntranet2">&nbsp;</td>
        </tr>           
        <tr>
          <td colspan="5" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
        </tr>           
      <%}else{%>
          <tr>
            <td colspan="5" height="26" align="center" class="tdIntranet2">
              <br><strong>N�o existem requisi��es no processo de WorkFlow!</strong><br>&nbsp;
            </td>
          </tr>      
          <tr>
            <td colspan="5" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
          </tr>       
        </table>
      <%}%>
      </td>
    </tr>    
  </table>
</form>  
<br>
</center>
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>