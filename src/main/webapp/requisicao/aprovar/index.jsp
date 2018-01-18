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
  
  //-- Objetos de sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Parametros de página
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

  //-- Variáveis da página  
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
  
  //-- Verificando as unidades de acesso
  for(int i=0; usuario.getUnidades() != null && i < usuario.getUnidades().length; i++){
    todasUnidades += ((i==0)?" ":",") + usuario.getUnidades()[i].getCodUnidade();
  } 
  
  //-- Verificando qual método chamar para listagem de requisições do WorkFlow
  if(idPerfilUsuario == Integer.parseInt(idPerfilADM.getVlrSistemaParametro())){
    //-- todas as requisições no processo de aprovação
    isPerfilADM = true;
    requisicao = requisicaoAprovacaoControl.getRequisicoesParaHomologacao(where);    
    //out.println("(ADMINISTRADOR GERAL)");
    
  }else if(idPerfilUsuario == Integer.parseInt(idPerfilAPR.getVlrSistemaParametro())){
          //-- NIVEL 54 (APROVADOR)
          //-- requisições homologadas pela GEP
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

                
                //-- requisições homologadas pelos gerentes das unidades
                requisicao  = requisicaoAprovacaoControl.getRequisicoesParaHomologacaoGEP();
                //out.println("(HOMOLOGADOR GEP - AP&B)");                
                
              }else if(idPerfilUsuario == Integer.parseInt(idPerfilNEC.getVlrSistemaParametro())){
                      //-- NIVEL 4 (HOMOLOGADOR NEC)
                      isPerfilNEC = true;
                      //nivelWorkFlow = 4; original     
                       nivelWorkFlow = 3;
                      
                      //-- requisições solicitadas pelas unidades em que é responsável
                      requisicao = requisicaoAprovacaoControl.getRequisicoesParaHomologacaoNEC(usuario.getChapa());
                      //out.println("(HOMOLOGADOR GEP - NEC)");
                      
                    }else if(idPerfilUsuario == Integer.parseInt(idPerfilHOM.getVlrSistemaParametro())){
                            //-- NIVEL 2 (HOMOLOGADOR UO)
                            isPerfilHOM = true;
                            nivelWorkFlow = 2;                  
                            
                            //-- requisições solicitadas pelas unidades em que é responsável
                            requisicao = requisicaoAprovacaoControl.getRequisicoesParaHomologacaoUO(usuario.getUnidade().getCodUnidade(),todasUnidades);
                            //out.println("(HOMOLOGADOR UNIDADE)");                           
                          }else{
                            //-- NIVEL 1 (CRIADOR)
                            isPerfilCRI = true;                      
                            //-- requisições em revisão
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
    // verifica se atingiu o número máximo de revisões
    if(parseInt(qtdRevisoes) < <%=Integer.parseInt(qtdRevisoesRP.getVlrSistemaParametro())%>){    
      if(confirm("Deseja realmente solicitar revisão da RP nº "+codRequisicao+"?")){
        window.location = "<%=request.getContextPath()%>/requisicao/cadastro/revisao/formulario.jsp?codRequisicao="+codRequisicao;
      }  
    }else{
      alert('Não é possível solicitar revisão para a RP '+codRequisicao+'!\nO número de revisões atingiu o máximo permitido pelo sistema (<%=qtdRevisoesRP.getVlrSistemaParametro()%> revisões).');
    }
  }
  //--
  function cancelar(codRequisicao){
    if(confirm("Deseja realmente cancelar a RP nº "+codRequisicao+"?")){
      window.location = "<%=request.getContextPath()%>/requisicao/cadastro/exclusao/formulario.jsp?indWorkFlow=true&codRequisicao="+codRequisicao;
    }  
  }
  //--
  function aprovar(codRequisicao){
    if(confirm("Confirma a aprovação da RP nº "+codRequisicao+"?")){
      window.location = "<%=request.getContextPath()%>/requisicao/aprovar/aprovar.jsp?nivelWorkFlow=<%=nivelWorkFlow%>&codRequisicao="+codRequisicao;
    }  
  }
  //--
  function reprovar(codRequisicao){
    if(confirm("Deseja realmente reprovar a RP nº "+codRequisicao+"?")){
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
             <STRONG>&nbsp;&nbsp;APROVAÇÃO DE REQUISIÇÕES</STRONG>
            </td>
          </tr>  
          <%-- EXIBE O FILTRO APENAS PARA O ADMINISTRADOR DO SISTEMA --%>
          <%if(isPerfilADM){%>
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
          <%}%>
          <tr>
            <td colspan="2" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
          </tr>            
        </table>
        
        <%=(isPerfilADM)?"<br>":""%>
   
        <%-- IMPRESSÃO DOS VALORES --%>       
        <table border="0" cellpadding="0" cellspacing="0" width="610" >
        <%if(requisicao != null && requisicao.length > 0){
           if(!isPerfilADM){%>
              <tr>
                <td colspan="5" height="30" class="tdIntranet2">
                  <%-- GERAÇÃO DA LEGENDA --%>
                  <table width="100%" class="tdIntranet" align="center">
                    <tr>
                      <%if(isPerfilCRI){%>
                          <td align="center" width="100%">
                            <img src="<%=request.getContextPath()%>/imagens/bt_revisar.png" border="0"/><br>Efetuar revisão
                          </td>
                      <%}else{%>                      
                          <td align="center" width="20%">
                            <img src="<%=request.getContextPath()%>/imagens/bt_revisao.png" border="0"/><br>Solicitar revisão
                          </td>
                          <%-- Exibe legenda de CANCELAMENTO de RP's aos homologadores (Exceto GERENTE DA UO Aprovadora) --%>
                          <%if(isPerfilHOM || isPerfilGEP || isPerfilNEC){%>
                              <td align="center" width="20%">
                                <img src="<%=request.getContextPath()%>/imagens/bt_cancelar.png" border="0"/><br>Cancelar
                              </td>
                              <td align="center" width="20%">
                                <img src="<%=request.getContextPath()%>/imagens/bt_revisar.png" border="0"/><br>Efetuar revisão
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
            <td align="center" height="25"  class="tdTemplateLista" width="15%"><STRONG><%=(isPerfilADM)?"Status":"Opções"%></STRONG></td>
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
                  <a href="javaScript:requisicaoHistorico('codRequisicao=<%=requisicao[i][0]%>');" title="Visualizar histórico da RP">
                    <%=requisicao[i][1]%>
                  </a>
                </td>
                <td align="left"   height="25" class="<%= classCSS %>" width="47%">&nbsp;&nbsp;<%=(requisicao[i][2]==null)?"":requisicao[i][2]%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="15%" title="<%=requisicao[i][8]%>"><%=(requisicao[i][3]==null)?"":requisicao[i][3]+" / "+requisicao[i][7]%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="15%">
                 <%if(isPerfilADM){
                    out.print(requisicao[i][5]+"&nbsp;");                    
                  }else if(isPerfilCRI){%>
                      <a href="javaScript:revisar(<%=requisicao[i][0]%>);" title="Efetuar revisão">
                        <img src="<%=request.getContextPath()%>/imagens/bt_revisar.png" border="0"/>
                      </a>
                  <%}else{%>
                      <% // Rotina que traz a quantidade de revisões que a RP teve
                         qtdRevisoes = requisicaoRevisaoControl.getQtdRevisoes(Integer.parseInt(requisicao[i][0]));                      
                                            
                         // Exibe opção de CANCELAMENTO de RP's aos homologadores (Exceto GERENTE DA UO Aprovadora)
                         if(isPerfilHOM || isPerfilGEP || isPerfilNEC){%>
                           <a href="javaScript:cancelar(<%=requisicao[i][0]%>);" title="Cancelar">
                            <img src="<%=request.getContextPath()%>/imagens/bt_cancelar.png" border="0"/>
                           </a>                     
                           <%-- Exibe RP's em revisão para os gerentes de unidades (Exceto UO Aprovadora) --%>
                           <%if(requisicao[i][6].equals("3")){%>
                               <a href="javaScript:revisar(<%=requisicao[i][0]%>);" title="Efetuar revisão">
                                 <img src="<%=request.getContextPath()%>/imagens/bt_revisar.png" border="0"/>
                               </a>                      
                           <%}else{%>
                               <a href="javaScript:solicitarRevisao(<%=requisicao[i][0]%>,<%=qtdRevisoes%>);" title="Solicitar revisão">
                                 <img src="<%=request.getContextPath()%>/imagens/bt_revisao.png" border="0"/>                                 
                               </a>
                               <a href="javaScript:aprovar(<%=requisicao[i][0]%>);" title="Aprovar">
                                 <img src="<%=request.getContextPath()%>/imagens/bt_aprovar.png" border="0"/>
                               </a>                                                        
                          <%}%>                        
                        <%}%>
                        <%if(isPerfilAPR){%>
                            <a href="javaScript:solicitarRevisao(<%=requisicao[i][0]%>,<%=qtdRevisoes%>);" title="Solicitar revisão">
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
          <%-- PAGINAÇÃO --%>
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
              <br><strong>Não existem requisições no processo de WorkFlow!</strong><br>&nbsp;
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