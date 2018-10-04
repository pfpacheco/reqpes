<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:include page="../../../template/cabecalho.jsp"/>

<% 
  //-- Objetos Control
  GrupoNecControl grupoNecControl = new GrupoNecControl();
  GrupoNecUnidadeControl grupoNecUnidadeControl = new GrupoNecUnidadeControl();
  
  //-- Parametros de página
  int codGrupo = (request.getParameter("codGrupo")==null)?0:Integer.parseInt(request.getParameter("codGrupo"));
      
  //-- Objetos da página
  GrupoNec grupoNec = grupoNecControl.getGrupoNec(codGrupo);   
  String[][] listaSA = null;
  String[][] listaSD = null;
  String[][] listaSO = null;
  String[][] listaSU = null;
  String[][] listaGO1 = null;
  String[][] listaGO2 = null;
  String[][] listaGO3 = null;
  
  int qtdColunas = 0;
  int totalUnidades = 0;
  int colunas = 4;  
  
  String acaoForm  = "gravar.jsp";
  String botaoForm = "bt_cadastrar.gif";
  String altBotao  = "Cadastrar";
  
  //-- Verificando instância do objeto
  if(grupoNec == null){
    grupoNec  = new GrupoNec();
  }else{
    // Configurando botões
    acaoForm  = "atualizar.jsp";
    botaoForm = "bt_atualizar.gif";
    altBotao  = "Atualizar";  
  }
  
  //-- Carregando os valores das unidades
  listaSA = grupoNecUnidadeControl.getUnidadesSuperintendencia(codGrupo, "SA");
  listaSD = grupoNecUnidadeControl.getUnidadesSuperintendencia(codGrupo, "SD");
  listaSO = grupoNecUnidadeControl.getUnidadesSuperintendencia(codGrupo, "SO");
  listaSU = grupoNecUnidadeControl.getUnidadesSuperintendencia(codGrupo, "SU");
  
  listaGO1 = grupoNecUnidadeControl.getUnidadesGO(codGrupo, 1);
  listaGO2 = grupoNecUnidadeControl.getUnidadesGO(codGrupo, 2);
  listaGO3 = grupoNecUnidadeControl.getUnidadesGO(codGrupo, 3);
%>

<br>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/formulario.js" charset="utf-8" type="text/javascript"></script> 
<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js"    charset="utf-8" type="text/javascript"></script> 

<script language="javaScript">
  function cadastrar(){
    if(decode(document.frm.dscGrupo,"Informe a descrição!",0,"",null))
      if(validaCheck(document.frm.codUnidade)){
        document.frm.submit();
      }else{
        alert('Selecione uma unidade!');
      }
  }
  //--
  function checkUncheckAll(obj, tipo){  
    var t = 0; //-- quantidade de itens
    var opcao = document.getElementById(obj);
    
    for(t=0; t<frm.elements.length; t++){
      if(frm.elements[t].type == "checkbox"){ 
        if(frm.elements[t].nivel == tipo){
          frm.elements[t].checked = opcao.checked;
        }
      }
    }
  } 
  //--
  function validaCheck(objeto){   
    var cont = 0;
    for(z=0; z<objeto.length; z++){
      if(objeto[z].type == 'checkbox' && objeto[z].checked)
        cont = cont + 1;        
      }
    return (cont != 0);
  }      
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <form name="frm" method="POST" action="<%=acaoForm%>">
      <input type="HIDDEN" name="codGrupo" value="<%=grupoNec.getCodGrupo()%>">  
          <tr>
            <td colspan="2"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
              <STRONG>&nbsp;&nbsp;GRUPO DE ACESSO - NEC (NÚCLEO DE EDUCAÇÃO CORPORATIVA)</STRONG>
            </td>
          </tr>        
          <tr>
            <td height="10" class="tdintranet2" colspan="2"> </td>
          </tr>            
          <tr class="tdintranet2">
            <td height="23" align="right" width="25%">
              <STRONG>Descrição:&nbsp;</STRONG>
            </td>
            <td width="75%" class="tdintranet2" align="left" >
              <input class="input" size="80" maxlength="400" name="dscGrupo" id="dscGrupo" value="<%=grupoNec.getDscGrupo()%>">
            </td>
          </tr>  
          <tr>
            <td height="10" class="tdintranet2" colspan="2"> </td>
          </tr>
          <%-- SUPERINTENDENCIA ADMINISTRATIVA --%>
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="center">
              <br>
              <fieldset class="tdIntranet2" style="width:580px;">
                <legend><strong><font color="Black"><input name="indSA" id="indSA" type="checkbox" onclick="checkUncheckAll('indSA','SA');">Superintendência Administrativa </font></strong></legend>
                <br>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <%                                                 
                            for(int c=0; c<listaSA.length; c++){
                              if(qtdColunas == colunas){ 
                                 qtdColunas = 0;
                          %>                        
                        </tr><tr>
                            <%} //-- final do if %>
                          <td width="16%" height="26" align="left">   
                            &nbsp;&nbsp;&nbsp;<input name="codUnidade" type="checkbox" <%=(listaSA[c][0].equals("S"))?"CHECKED":""%> nivel="SA" value="<%=listaSA[c][1]%>" title="<%=listaSA[c][3]%>"><%=listaSA[c][2]%>
                          </td>
                            <% 
                              if((c+1)==listaSA.length && qtdColunas < colunas)
                                for(int r=qtdColunas; r<colunas-1; r++){
                                  out.print("<td></td>");
                                }
                                qtdColunas++;
                                totalUnidades++;
                            } //-- fim 1º for de unidades
                           %>
                        </tr>                                          
                      </table>
                  </td>
                </tr>
              </table>
            </fieldset>                 
            </td>
          </tr>
          <%-- SUPERINTENDENCIA DESENVOLVIMENTO --%>
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="center">
              <br>
              <fieldset class="tdIntranet2" style="width:580px;">
                <legend><strong><font color="Black"><input name="indSD" id="indSD" type="checkbox" onclick="checkUncheckAll('indSD','SD');">Superintendência de Desenvolvimento </font></strong></legend>
                <br>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <%
                            qtdColunas = 0;
                            totalUnidades = 0;                          

                            for(int c=0; c<listaSD.length; c++){
                              if(qtdColunas == colunas){ 
                                 qtdColunas = 0;
                          %>                        
                        </tr><tr>
                            <%} //-- final do if %>
                          <td width="16%" height="26" align="left">   
                            &nbsp;&nbsp;&nbsp;<input name="codUnidade" type="checkbox" <%=(listaSD[c][0].equals("S"))?"CHECKED":""%> nivel="SD" value="<%=listaSD[c][1]%>" title="<%=listaSD[c][3]%>"><%=listaSD[c][2]%>
                          </td>
                            <% 
                              if((c+1)==listaSD.length && qtdColunas < colunas)
                                for(int r=qtdColunas; r<colunas-1; r++){
                                  out.print("<td></td>");
                                }
                                qtdColunas++;
                                totalUnidades++;
                            } //-- fim 1º for de unidades
                           %>
                        </tr>                                          
                      </table>
                  </td>
                </tr>
              </table>
            </fieldset>                 
            </td>
          </tr>
          <%-- SUPERINTENDENCIA OPERACIONAL --%>
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="center">
              <br>
              <fieldset class="tdIntranet2" style="width:580px;">
                <legend><strong><font color="Black"><input name="indSO" id="indSO" type="checkbox" onclick="checkUncheckAll('indSO','SO');">Superintendência Operacional </font></strong></legend>
                <br>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <%
                            qtdColunas = 0;
                            totalUnidades = 0;                          

                            for(int c=0; c<listaSO.length; c++){
                              if(qtdColunas == colunas){ 
                                 qtdColunas = 0;
                          %>                        
                        </tr><tr>
                            <%} //-- final do if %>
                          <td width="16%" height="26" align="left">   
                            &nbsp;&nbsp;&nbsp;<input name="codUnidade" type="checkbox" <%=(listaSO[c][0].equals("S"))?"CHECKED":""%> nivel="SO" value="<%=listaSO[c][1]%>" title="<%=listaSO[c][3]%>"><%=listaSO[c][2]%>
                          </td>
                            <% 
                              if((c+1)==listaSO.length && qtdColunas < colunas)
                                for(int r=qtdColunas; r<colunas-1; r++){
                                  out.print("<td></td>");
                                }
                                qtdColunas++;
                                totalUnidades++;
                            } //-- fim 1º for de unidades
                           %>
                        </tr>                                          
                      </table>
                  </td>
                </tr>
              </table>
            </fieldset>                 
            </td>
          </tr>          
          <%-- SUPERINTENDENCIA UNIVERSITÁRIA --%>
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="center">
              <br>
              <fieldset class="tdIntranet2" style="width:580px;">
                <legend><strong><font color="Black"><input name="indSU" id="indSU" type="checkbox" onclick="checkUncheckAll('indSU','SU');">Superintendência Universitária </font></strong></legend>
                <br>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <%
                            qtdColunas = 0;
                            totalUnidades = 0;                          

                            for(int c=0; c<listaSU.length; c++){
                              if(qtdColunas == colunas){ 
                                 qtdColunas = 0;
                          %>                        
                        </tr><tr>
                            <%} //-- final do if %>
                          <td width="16%" height="26" align="left">   
                            &nbsp;&nbsp;&nbsp;<input name="codUnidade" type="checkbox" <%=(listaSU[c][0].equals("S"))?"CHECKED":""%> nivel="SU" value="<%=listaSU[c][1]%>" title="<%=listaSU[c][3]%>"><%=listaSU[c][2]%>
                          </td>
                            <% 
                              if((c+1)==listaSU.length && qtdColunas < colunas)
                                for(int r=qtdColunas; r<colunas-1; r++){
                                  out.print("<td></td>");
                                }
                                qtdColunas++;
                                totalUnidades++;
                            } //-- fim 1º for de unidades
                           %>
                        </tr>                                          
                      </table>
                  </td>
                </tr>
              </table>
            </fieldset>                 
            </td>
          </tr>          
          <%-- GERENCIA DE OPERAÇÕES 1 --%>
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="center">
              <br>
              <fieldset class="tdIntranet2" style="width:580px;">
                <legend><strong><font color="Black"><input name="indGO1" id="indGO1" type="checkbox" onclick="checkUncheckAll('indGO1','GO1');">Gerência de Operações 1 </font></strong></legend>
                <br>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <%
                            qtdColunas = 0;
                            totalUnidades = 0;                          

                            for(int c=0; c<listaGO1.length; c++){
                              if(qtdColunas == colunas){ 
                                 qtdColunas = 0;
                          %>                        
                        </tr><tr>
                            <%} //-- final do if %>
                          <td width="16%" height="26" align="left">   
                            &nbsp;&nbsp;&nbsp;<input name="codUnidade" type="checkbox" <%=(listaGO1[c][0].equals("S"))?"CHECKED":""%> nivel="GO1" value="<%=listaGO1[c][1]%>" title="<%=listaGO1[c][3]%>"><%=listaGO1[c][2]%>
                          </td>
                            <% 
                              if((c+1)==listaGO1.length && qtdColunas < colunas)
                                for(int r=qtdColunas; r<colunas-1; r++){
                                  out.print("<td></td>");
                                }
                                qtdColunas++;
                                totalUnidades++;
                            } //-- fim 1º for de unidades
                           %>
                        </tr>                                          
                      </table>
                  </td>
                </tr>
              </table>
            </fieldset>                 
            </td>
          </tr>      
          <%-- GERENCIA DE OPERAÇÕES 2 --%>
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="center">
              <br>
              <fieldset class="tdIntranet2" style="width:580px;">
                <legend><strong><font color="Black"><input name="indGO2" id="indGO2" type="checkbox" onclick="checkUncheckAll('indGO2','GO2');">Gerência de Operações 2 </font></strong></legend>
                <br>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <%
                            qtdColunas = 0;
                            totalUnidades = 0;                          

                            for(int c=0; c<listaGO2.length; c++){
                              if(qtdColunas == colunas){ 
                                 qtdColunas = 0;
                          %>                        
                        </tr><tr>
                            <%} //-- final do if %>
                          <td width="16%" height="26" align="left">   
                            &nbsp;&nbsp;&nbsp;<input name="codUnidade" type="checkbox" <%=(listaGO2[c][0].equals("S"))?"CHECKED":""%> nivel="GO2" value="<%=listaGO2[c][1]%>" title="<%=listaGO2[c][3]%>"><%=listaGO2[c][2]%>
                          </td>
                            <% 
                              if((c+1)==listaGO2.length && qtdColunas < colunas)
                                for(int r=qtdColunas; r<colunas-1; r++){
                                  out.print("<td></td>");
                                }
                                qtdColunas++;
                                totalUnidades++;
                            } //-- fim 1º for de unidades
                           %>
                        </tr>                                          
                      </table>
                  </td>
                </tr>
              </table>
            </fieldset>                 
            </td>
          </tr>
          <%-- GERENCIA DE OPERAÇÕES 3 --%>
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="center">
              <br>
              <fieldset class="tdIntranet2" style="width:580px;">
                <legend><strong><font color="Black"><input name="indGO3" id="indGO3" type="checkbox" onclick="checkUncheckAll('indGO3','GO3');">Gerência de Operações 3 </font></strong></legend>
                <br>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <%
                            qtdColunas = 0;
                            totalUnidades = 0;                          

                            for(int c=0; c<listaGO3.length; c++){
                              if(qtdColunas == colunas){ 
                                 qtdColunas = 0;
                          %>                        
                        </tr><tr>
                            <%} //-- final do if %>
                          <td width="16%" height="26" align="left">   
                            &nbsp;&nbsp;&nbsp;<input name="codUnidade" type="checkbox" <%=(listaGO3[c][0].equals("S"))?"CHECKED":""%> nivel="GO3" value="<%=listaGO3[c][1]%>" title="<%=listaGO3[c][3]%>"><%=listaGO3[c][2]%>
                          </td>
                            <% 
                              if((c+1)==listaGO3.length && qtdColunas < colunas)
                                for(int r=qtdColunas; r<colunas-1; r++){
                                  out.print("<td></td>");
                                }
                                qtdColunas++;
                                totalUnidades++;
                            } //-- fim 1º for de unidades
                           %>
                        </tr>                                          
                      </table>
                  </td>
                </tr>
              </table>
            </fieldset>                 
            </td>
          </tr>             
          <tr>
            <td height="10" class="tdintranet2" colspan="2"> </td>
          </tr>          
          <tr>
            <td height="23" class="tdintranet2" colspan="2" align="right">
              <a href="javaScript:cadastrar();">                  
                <img src="<%= request.getContextPath()%>/imagens/<%=botaoForm%>" border="0" alt="<%=altBotao%>"/>
              </a>
              <a href="index.jsp">                  
                <img src="<%= request.getContextPath()%>/imagens/bt_voltar.gif" border="0" alt="Voltar" hspace="15"/>
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