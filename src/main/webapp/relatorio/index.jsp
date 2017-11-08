<%@ page import="java.util.Date" %>
<%@ page import="br.senac.sp.reqpes.model.RequisicaoJornada" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%@ page import="br.senac.sp.componente.util.ConverteDate" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page errorPage="../error/error.jsp" %>
<%
  //-- Objetos Control
  RequisicaoControl requisicaoControl = new RequisicaoControl();  
  SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  GrupoNecUsuarioControl grupoNecUsuarioControl = new GrupoNecUsuarioControl();
  String[][] usuariosNec = null;
  boolean nec = false;
  
  //-- Parametros de página
  int codRequisicao = Integer.parseInt(request.getParameter("codRequisicao"));
  int idPerfilNEC = Integer.parseInt((sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_NEC").getVlrSistemaParametro()));
  
  Boolean isEmail = (request.getParameter("isEmail")==null)? Boolean.FALSE : Boolean.valueOf(request.getParameter("isEmail").trim());

  //-- Objetos  
  StringBuffer sql = new StringBuffer();
  RequisicaoJornada requisicaoJornada = new RequisicaoJornadaControl().getRequisicaoJornada(codRequisicao);
  String[][] requisicao = null;
  String[][] dataUltimoNivel = null;
  String[][] versaoAtualSistema = null;

  //-- Configurando regra de exibição dos campos
  dataUltimoNivel = requisicaoControl.getMatriz(" SELECT TO_CHAR(MAX(T.DT_HISTORICO_SQL),'DD/MM/YYYY') FROM VW_HISTORICO_REQUISICAO T WHERE T.REQUISICAO_SQ =  " + codRequisicao);
  Date dataIntegracao = ConverteDate.stringToDate(((new SistemaParametroControl().getSistemaParametroPorSistemaNome(Config.ID_SISTEMA, "DATA_INTEGRACAO")).getVlrSistemaParametro()));
  boolean isExibe = (dataIntegracao.compareTo(ConverteDate.stringToDate(dataUltimoNivel[0][0])) == 1);
  
  //-- Configurando exibiçao da versao da aplicaçao na qual a RP foi criada
  sql.append(" SELECT 1 ");
  sql.append(" FROM   HISTORICO_REQUISICAO T ");
  sql.append(" WHERE  T.REQUISICAO_SQ = " + codRequisicao);
  sql.append(" AND    T.DT_ENVIO = (SELECT MAX(T1.DT_ENVIO) ");
  sql.append("                      FROM   HISTORICO_REQUISICAO T1 ");
  sql.append("                      WHERE  T1.REQUISICAO_SQ = T.REQUISICAO_SQ ");
  sql.append("                      AND    TRUNC(T1.DT_ENVIO) < TO_DATE('25/11/2009','DD/MM/YYYY') "); // data de integraçao com IN15
  sql.append("                      AND    T1.NIVEL = 1) "); // criada ou revisada
  dataUltimoNivel = requisicaoControl.getMatriz(sql.toString());    
  
  versaoAtualSistema = requisicaoControl.getMatriz("SELECT MAX(VERSAO) FROM VERSAO");
  
  //-- Resgatando os dados  
  requisicao = requisicaoControl.getPesquisaRequisicao(codRequisicao);
  
  //verifica se tem perfil nec
  if(usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilNEC){
	//confirma se, apesar de ter perfil nec, tem permissão a unidade
	usuariosNec = grupoNecUsuarioControl.getUsuariosByUnidade(requisicao[0][1]);
		if(usuariosNec != null){
	 		for(String[] u:usuariosNec){
				if(u[0].equals(String.valueOf(usuario.getChapa())))
					nec = true;
	 		}	  
		}
  	}
%>

<link href="<%=request.getContextPath()%>/css/stylesheet.css" rel="STYLESHEET" type="text/css"/>
<body onload="focus();">
<script language="JavaScript" src="../js/formulario.js" charset="utf-8" type="text/javascript"></script>
<script language="JavaScript" src="../js/ajaxItens.js" charset="utf-8" type="text/javascript"></script>
<script language="javaScript" charset="utf-8">   

  function atualizaTextos(){
	  var objetoAjax  = createXMLHTTP();          
      var parametros  = "codRequisicao=" + document.getElementById('codRequisicao').value;
      	  parametros += "&dscAtividadesCargo=" + document.getElementById('dscAtividadesCargo').value;
          parametros += "&descricaoFormacao=" + document.getElementById('descricaoFormacao').value;
          parametros += "&dscExperiencia=" + document.getElementById('dscExperiencia').value;
          parametros += "&dscConhecimentos=" + document.getElementById('dscConhecimentos').value;
          parametros += "&outrasCarateristica=" + document.getElementById('outrasCarateristica').value;
          parametros += "&comentarios=" + document.getElementById('comentarios').value;

          objetoAjax.open("post", "ajax/atualizaTextos.jsp", true);            	  
          objetoAjax.setRequestHeader('Content-type', 'application/x-www-form-urlencoded; charset=utf-8');   
          objetoAjax.onreadystatechange = function(){  
          	if(objetoAjax.readyState == 4){
            	var retorno = objetoAjax.responseText;
                if(Number(retorno) > 0){
                	alert('Atualizado com sucesso!');
                	window.close();
                } else {
                	alert('Não foi possível atualizar o perfil da reguisição.' + retorno);
                }              
            }
          };
     	  objetoAjax.send(parametros);
  }	

  function imprimir(){    
    divBotoes.style.visibility = "hidden";
    divBotoes.style.display = "none";
    divCaraterExcecao.style.visibility = "hidden";
    divCaraterExcecao.style.display = "none";
    divVersaoSistema.style.visibility = "hidden";
    divVersaoSistema.style.display = "none";
    window.print();
  }
  //--
  function telaInicial(){
    window.location = "../requisicao/aprovar/index.jsp";
  }
  //--
  function sessaoExpirada(){
	  window.location = "../template/sessaoExpirada.jsp";
  }  
</script>

<%if(requisicao != null && requisicao.length > 0){%>
  <table width="610" border="0" align="center">
      <tr>
        <td>
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td>
                  <jsp:include page="../template/cabecalhoRelatorio.jsp">
                    <jsp:param name="titulo" value="Requisição de Pessoal"/>
                  </jsp:include>
                </td>
              </tr>
            </table>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="3" height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
                 <STRONG>DADOS DA REQUISIÇÃO</STRONG>
                </td>
              </tr>           
              <tr>
                <td height="23" align="left" class="tdIntranet2" width="33%">
                 <input type="hidden" id="codRequisicao" value="<%=requisicao[0][0]%>">
                 &nbsp;<STRONG>Número RP</STRONG><br>&nbsp;<%=requisicao[0][0]%>
                </td>
                <td height="23" align="left" class="tdIntranet2" width="40%">
                 &nbsp;<STRONG>Tipo <%=(isExibe)?"":"de recrutamento"%></STRONG><br>&nbsp;<%=(isExibe)? (requisicao[0][79]==null)?"":requisicao[0][79] : (requisicao[0][53]==null)?"":requisicao[0][53]%>
                </td>                
                <td height="23" align="left" class="tdIntranet2" width="27%">
                 &nbsp;<STRONG>Data de criação</STRONG><br>&nbsp;<%=requisicao[0][31]%>
                </td>                                
              </tr>    
              <tr>
                <td align="center" class="tdIntranet2" colspan="3">
                  <div id="divVersaoSistema" align="justify" style="padding-left:12px; padding-right:12px; color:#ff0000;">
                    <%if((versaoAtualSistema!=null) && (dataUltimoNivel != null && dataUltimoNivel.length > 0) && (requisicao[0][80] == null || !requisicao[0][80].equals(versaoAtualSistema[0][0]))){%>
                        <b>Atenção:</b> RP criada/revisada por uma versão anterior a atual. Favor abrir chamado e solicitar que as configurações de arquivos de internet, temporários e de histórico, item <i><b>"Verificar se há versões mais atualizadas das páginas armazenadas"</b></i>, seja alterado para: <i><b>"Sempre que eu visitar a página da web"</b></i>.
                    <%}%>
                  </div>
                </td>
              </tr>
              <tr>
                <td height="3" colspan="3" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
              </tr>              
            </table>
            <br>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="4" height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
                 <STRONG>SOLICITANTE</STRONG>
                </td>
              </tr>  
              <tr>
                <td height="26" align="left" class="tdIntranet2" width="9%">
                 &nbsp;<STRONG>Unidade</STRONG><br>&nbsp;<%=(requisicao[0][56]==null)?"":requisicao[0][56]%>
                </td>
                <td height="26" align="left" class="tdIntranet2" width="31%">
                  <%if(requisicao[0][45]==null){%>
                      &nbsp;<STRONG>UO/MA/SMA</STRONG><br>&nbsp;<%=requisicao[0][1].substring(0,requisicao[0][1].length()-1)%>&nbsp;|&nbsp;<%=(requisicao[0][6]==null)?"":requisicao[0][6]%>&nbsp;|&nbsp;<%=(requisicao[0][7]==null)?"":requisicao[0][7]%>
                  <%}else{%>
                      &nbsp;<STRONG>Centro de custo</STRONG><br>&nbsp;<%=requisicao[0][46]+"."+requisicao[0][47]+"."+requisicao[0][48]+"."+requisicao[0][49]+"."+requisicao[0][50]+"."+requisicao[0][51]+"."+requisicao[0][52]%>
                  <%}%>
                </td>                
                <td height="26" align="left" class="tdIntranet2" width="45%">
                 &nbsp;<STRONG>Nome superior imediato</STRONG><br>&nbsp;<%=(requisicao[0][11]==null)?"":requisicao[0][11]%>
                </td>
                <td height="26" align="left" class="tdIntranet2" width="15%">
                 &nbsp;<STRONG>Telefone</STRONG><br>&nbsp;<%=(requisicao[0][12]==null)?"":requisicao[0][12]%>
                </td>                
              </tr>    
              <tr>
                <td height="3" colspan="4" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
              </tr>                
            </table>
            <br>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="4" height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
                 <STRONG>DADOS DE REFERÊNCIA DO CARGO</STRONG>
                </td>
              </tr>  
              <%if(isExibe){%>
                  <tr>
                    <td colspan="4" height="23" class="tdIntranet2" style="text-align=justify;">
                     &nbsp;<STRONG>Tipo de recrutamento</STRONG><br>&nbsp;<%=(requisicao[0][30]==null)?"":requisicao[0][30]%>
                    </td>
                  </tr>
              <%}else{%>
              	  <%if(requisicao[0][69] != null){%>
	                  <tr>
	                    <td colspan="4" height="23" class="tdIntranet2">
	                      <div align="justify" style="padding-left:5px; padding-right:5px;">
	                        <STRONG>Justificativa do tipo de recrutamento</STRONG><br><%=requisicao[0][69]%>
	                      </div>
	                    </td>
	                  </tr>
	              <%}%>
              <%}%>
              <tr>               
                <td height="29" class="tdIntranet2" width="38%">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Título do cargo</STRONG><br><%=(requisicao[0][5]==null)?"":requisicao[0][5]%>
                  </div>

                 <div id="divCaraterExcecao">
                   <%
                     //-- Regra de contrataçao em carater de exceçao
                     if(requisicao[0][77] != null && requisicao[0][77].equals("SIM")){
                        out.println("<font color=\"Red\">&nbsp;Contratação em caráter de exceção</font>");  
                     }
                   %>
                 </div>
                 
                </td>                
                <td height="29" align="left" class="tdIntranet2" width="22%">
                 &nbsp;<STRONG>Código do cargo</STRONG><br>&nbsp;<%=(requisicao[0][4]==null)?"":requisicao[0][4]%>
                </td>
                <td height="29" align="left" class="tdIntranet2" width="20%">
                 &nbsp;<STRONG>Cota</STRONG><br>&nbsp;<%=(requisicao[0][8]==null)?"":requisicao[0][8]%>
                </td>                
                <td height="29" align="left" class="tdIntranet2" width="20%">
                 &nbsp;<STRONG>Salário</STRONG><br>&nbsp;<%=(requisicao[0][24]==null)?"":requisicao[0][24]%>
                </td>                                
              </tr>    
              <tr>               
                <td colspan="4" height="29" class="tdIntranet2">
                 &nbsp;<STRONG>Classificação funcional</STRONG><br>&nbsp;<%=(requisicao[0][36]==null)?"":requisicao[0][36]%>
                </td>         
              </tr>    
              <tr>               
                <td height="29" class="tdIntranet2">
                 &nbsp;<STRONG>RP para</STRONG><br>&nbsp;<%=(requisicao[0][17]==null)?"":requisicao[0][17]%>
                </td>                
                <td height="29" align="left" class="tdIntranet2" colspan="3">
                 &nbsp;<STRONG>Funcionário substituído (Chapa/Nome)</STRONG><br>&nbsp;<%=(requisicao[0][39]==null)?"":requisicao[0][39]+" - "+requisicao[0][40]%>
                </td>
              </tr>                  
              <tr>               
                <td height="29" class="tdIntranet2">
                 &nbsp;<STRONG>Motivo da solicitação</STRONG><br>&nbsp;<%=(requisicao[0][33]==null)?"":requisicao[0][33]%>
                </td>                
                <td height="29" class="tdIntranet2" colspan="3">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Justificativa</STRONG><br><%=(requisicao[0][34]==null)?"":requisicao[0][34]%>
                  </div>
                </td>
              </tr>  
              <tr>               
                <td height="29" class="tdIntranet2" colspan="<%=(isExibe)?"1":"4"%>">
                 &nbsp;<STRONG>Previsão de Transferência</STRONG><br>&nbsp;<%=(requisicao[0][41]==null)?"":requisicao[0][41]%>
                </td>
                <%if(isExibe){%>
                    <td height="29" align="left" class="tdIntranet2">
                     &nbsp;<STRONG>Carta-Convite</STRONG><br>&nbsp;<%=(requisicao[0][42]==null)?"":requisicao[0][42]%>
                    </td>
                    <td height="29" align="left" class="tdIntranet2" >
                     &nbsp;<STRONG>Ex-Carta-Convite</STRONG><br>&nbsp;<%=(requisicao[0][43]==null)?"":requisicao[0][43]%>
                    </td>                
                    <td height="29" align="left" class="tdIntranet2">
                     &nbsp;<STRONG>Ex-Funcionário</STRONG><br>&nbsp;<%=(requisicao[0][44]==null)?"":requisicao[0][44]%>
                    </td>                                
                <%}%>
              </tr>  
              <tr>
                <td height="29" align="left" class="tdIntranet2" colspan="1">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Local de trabalho</STRONG><br><%=(requisicao[0][15]==null)?"":requisicao[0][15]%>
                  </div>
                </td>                
                <td height="29" align="left" class="tdIntranet2" colspan="3">
                 &nbsp;<STRONG>Sigla(s) da(s) unidade(s) ou endereço do outro local</STRONG><br>&nbsp;<%=(requisicao[0][25]==null)?"":requisicao[0][25]%>
                </td>                
              </tr>
              <tr>
                <td height="29" align="left" class="tdIntranet2">
                 &nbsp;<STRONG>Tipo contratação</STRONG><br>&nbsp;<%=(requisicao[0][10]==null)?"":requisicao[0][10]%>
                </td>                
                <td height="29" align="left" class="tdIntranet2" >
                 &nbsp;<STRONG>Previsão de início<br>&nbsp;da contratação</STRONG><br>&nbsp;<%=(requisicao[0][27]==null)?"":requisicao[0][27]%>
                </td>                
                <td height="29" align="left" class="tdIntranet2">
                 &nbsp;<STRONG>Fim contrato</STRONG><br>&nbsp;<%=(requisicao[0][28]==null)?"":requisicao[0][28]%>
                </td>                                
                <td height="29" align="left" class="tdIntranet2" nowrap>
                 &nbsp;<STRONG>Carga horária semanal</STRONG>&nbsp;<br>&nbsp;<%=(requisicao[0][13]==null)?"":requisicao[0][13]+"&nbsp;horas"%>
                </td>                                                
              </tr>
              <tr>
                <td height="3" colspan="4" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
              </tr>                
            </table>
            <br>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="4" height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
                 <STRONG>HORÁRIO DE TRABALHO</STRONG>
                </td>
              </tr>
              <tr>
                <td class="tdIntranet2" colspan="4">              
                  <table border="0" width="100%">
                      <%for(int i=0; i<requisicaoJornada.getHorarios().length; i++){%>
                          <tr>
                            <td height="20" align="left" class="tdIntranet2" width="15%">
                              <STRONG>
                              <%
                                if(requisicaoJornada.getHorarios()[i].getDia().equals("SEG"))
                                  out.print("Segunda-feira");
                                else if(requisicaoJornada.getHorarios()[i].getDia().equals("TER"))
                                       out.print("Terça-feira");
                                     else if(requisicaoJornada.getHorarios()[i].getDia().equals("QUA"))
                                            out.print("Quarta-feira");
                                          else if(requisicaoJornada.getHorarios()[i].getDia().equals("QUI"))
                                                 out.print("Quinta-feira");
                                               else if(requisicaoJornada.getHorarios()[i].getDia().equals("SEX"))
                                                      out.print("Sexta-feira");
                                                    else if(requisicaoJornada.getHorarios()[i].getDia().equals("SAB"))
                                                           out.print("Sábado");
                                                         else
                                                           out.print("Domingo");
                              
                              %>
                              </STRONG>
                            </td>
                                                        
                            <%-- Impressão de jornada sem escala cadastrada, professores --%>
                            <%if(!isExibe && (requisicaoJornada.getCodEscala() == null || requisicaoJornada.getCodEscala().equals(""))){%>
	                            <td align="center" class="tdIntranet2"><%=requisicaoJornada.getHorarios()[i].getEntrada()%></td>
	                            <td align="center" class="tdIntranet2"><%=requisicaoJornada.getHorarios()[i].getIntervalo()%></td>
	                            <td align="center" class="tdIntranet2"><%=requisicaoJornada.getHorarios()[i].getRetorno()%></td>
	                            <td align="center" class="tdIntranet2"><%=requisicaoJornada.getHorarios()[i].getSaida()%></td>
	                            <td align="center" class="tdIntranet2"><%=requisicaoJornada.getHorarios()[i].getEntradaExtra()%></td>
	                            <td align="center" class="tdIntranet2"><%=requisicaoJornada.getHorarios()[i].getIntervaloExtra()%></td>
	                            <td align="center" class="tdIntranet2"><%=requisicaoJornada.getHorarios()[i].getRetornoExtra()%></td>
	                            <td align="center" class="tdIntranet2"><%=requisicaoJornada.getHorarios()[i].getSaidaExtra()%></td>
                            <%}else{%>
	                            <td align="center" class="tdIntranet2" width="20%">
	                              <%= (requisicaoJornada.getHorarios()[i].getEntrada().equals("00:00") && requisicaoJornada.getHorarios()[i].getIntervalo().equals("00:00")) || requisicaoJornada.getHorarios()[i].getEntrada().equals("") ? "-" : requisicaoJornada.getHorarios()[i].getEntrada() %>
	                            </td>
	                            <td width="3%" align="center" class="tdIntranet2">
	                              <%= (requisicaoJornada.getHorarios()[i].getEntrada().equals("00:00") && requisicaoJornada.getHorarios()[i].getIntervalo().equals("00:00")) || requisicaoJornada.getHorarios()[i].getEntrada().equals("") ? "-" : "&nbsp;às&nbsp;" %>
	                            </td>
	                            <td align="center" class="tdIntranet2" width="20%">
	                              <%= (requisicaoJornada.getHorarios()[i].getEntrada().equals("00:00") && requisicaoJornada.getHorarios()[i].getIntervalo().equals("00:00")) || requisicaoJornada.getHorarios()[i].getIntervalo().equals("") ? "-" : requisicaoJornada.getHorarios()[i].getIntervalo() %>
	                            </td>	                            
	                            <td align="center" class="tdIntranet2" width="20%">
	                              <%= (requisicaoJornada.getHorarios()[i].getRetorno().equals("00:00") && requisicaoJornada.getHorarios()[i].getSaida().equals("00:00")) || requisicaoJornada.getHorarios()[i].getRetorno().equals("")  ? "-" : requisicaoJornada.getHorarios()[i].getRetorno() %>
	                            </td>
	                            <td width="3%" align="center" class="tdIntranet2">
	                              <%= (requisicaoJornada.getHorarios()[i].getRetorno().equals("00:00") && requisicaoJornada.getHorarios()[i].getSaida().equals("00:00")) || requisicaoJornada.getHorarios()[i].getRetorno().equals("")  ? "-" : "&nbsp;às&nbsp;" %>
	                            </td>
	                            <td align="center" class="tdIntranet2" width="20%">
	                              <%= (requisicaoJornada.getHorarios()[i].getRetorno().equals("00:00") && requisicaoJornada.getHorarios()[i].getSaida().equals("00:00")) || requisicaoJornada.getHorarios()[i].getSaida().equals("")  ? "-" : requisicaoJornada.getHorarios()[i].getSaida() %>
	                            </td>
                            <%}%>                           
                          </tr>
                      <%}%>
                  </table>
                </td>
              </tr>             
              <%if(!isExibe){%>
                  <tr>
                    <td height="26" align="left" class="tdIntranet2" colspan="2">
                      &nbsp;<STRONG>Código da escala (TimeKeeper)</STRONG><br>&nbsp;<%=(requisicao[0][75]==null)?"":requisicao[0][75]%>
                    </td>                
                    <td height="26" align="left" class="tdIntranet2">
                      &nbsp;<STRONG>ID Calendário (RHEvolution)</STRONG><br>&nbsp;<%=(requisicao[0][76]==null)?"":requisicao[0][76]%>
                    </td>   
                  </tr>
              <%}%>
              <tr>
                <td height="26" align="left" class="tdIntranet2">
                  &nbsp;<STRONG>Supervisão de funcionários</STRONG><br>&nbsp;<%=(requisicao[0][19]==null)?"":requisicao[0][19]%>
                </td>                
                <td height="26" align="left" class="tdIntranet2">
                  &nbsp;<STRONG>Nº de funcionários</STRONG><br>&nbsp;<%=requisicao[0][20]%>
                </td>   
                <td height="26" align="left" class="tdIntranet2">
                  &nbsp;<STRONG>Viagens</STRONG><br>&nbsp;<%=(requisicao[0][23]==null)?"":requisicao[0][23]%>
                </td>   
              </tr>
              <%if(isExibe){%>
                  <tr>
                    <td height="26" class="tdIntranet2" colspan="7">
                      <div align="justify" style="padding-left:5px; padding-right:5px;">
                        <STRONG>Descrição das tarefas que irá desempenhar</STRONG><br><%=(requisicao[0][21]==null)?"":requisicao[0][21]%>
                      </div>
                    </td>                
                  </tr>
              <%}%>
              <tr>
                <td height="3" colspan="4" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
              </tr>                
            </table>
            <br>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="4" height="18" align="center" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif'>
                 <STRONG>PERFIL DO CANDIDATO</STRONG>
                </td>
              </tr>               
              <%if(isExibe){%>
                  <tr>
                    <td height="28" align="left" class="tdIntranet2" width="15%"%>
                      &nbsp;<STRONG>Idade (faixa)</STRONG><br>&nbsp;<%=(requisicao[0][60]==null)?"":requisicao[0][60]+ " a "+requisicao[0][61]%>
                    </td>               
                    <td height="28" align="left" class="tdIntranet2" width="22%">
                      &nbsp;<STRONG>Sexo</STRONG><br>&nbsp;<%=(requisicao[0][57]==null)?"":requisicao[0][57]%>
                    </td>                               
                    <td height="28" align="left" class="tdIntranet2" width="22%">
                      &nbsp;<STRONG>Tempo de experiência</STRONG><br>&nbsp;<%=(requisicao[0][63]==null)?"":requisicao[0][63]+"&nbsp;meses"%>
                    </td>                                               
                    <td height="28" align="left" class="tdIntranet2" width="41%">
                      &nbsp;<STRONG>Tipo de experiência</STRONG><br>&nbsp;<%=(requisicao[0][64]==null)?"":requisicao[0][64]%>
                    </td>                                                            
                  </tr>              
                  <tr>                              
                    <td height="28" class="tdIntranet2" colspan="3">
                      <div align="justify" style="padding-left:5px; padding-right:5px;">
                        <STRONG>Escolaridade</STRONG><br>&nbsp;<%=(requisicao[0][58]==null)?"":requisicao[0][58]%>
                      </div>
                    </td>
                    <td height="28" class="tdIntranet2">
                      <div align="justify" style="padding-left:5px; padding-right:5px;">
                        <STRONG>Formação desejável</STRONG><br><%=(requisicao[0][59]==null)?"":requisicao[0][59]%>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td height="28" class="tdIntranet2" colspan="4">
                      &nbsp;<STRONG>Outras características</STRONG><br><%=(requisicao[0][62]==null)?"":requisicao[0][62]%>
                    </td>               
                  </tr>
              <%}else{%>
                  <tr>
                    <td colspan="4" height="28" align="left" class="tdIntranet2">
                      &nbsp;<STRONG>Área</STRONG><br>&nbsp;<%=(requisicao[0][70]==null)?"":requisicao[0][70]%>
                    </td>               
                  </tr>              
                  <tr>
                    <td colspan="4" height="28" align="left" class="tdIntranet2">
                      &nbsp;<STRONG>Função</STRONG><br>&nbsp;<%=(requisicao[0][71]==null)?"":requisicao[0][71]%>
                    </td>               
                  </tr>              
                  <tr>
                    <td colspan="4" height="28" align="left" class="tdIntranet2">
                      &nbsp;<STRONG>Nível hierárquico</STRONG><br>&nbsp;<%=(requisicao[0][72]==null)?"":requisicao[0][72]%>
                    </td>
                  </tr>
                  <% if(requisicao[0][73] != null){ %>
	                  <tr>
	                    <td colspan="4" height="28" class="tdIntranet2">
	                      <div align="justify" style="padding-left:5px; padding-right:5px;">
	                        <STRONG>Descrição da vaga</STRONG><br><%=requisicao[0][73]%>
	                      </div>
	                    </td>               
	                  </tr>
	              <%}%>
                  <tr>
                    <td colspan="4" height="28" align="left" class="tdIntranet2">
                      <div style="padding-left:5px; padding-right:5px;">
                      	<STRONG>Principais atividades do cargo</STRONG><br>
                      	<% if(nec && requisicao[0][54].equals("2")){%>	                      	
	                      	<textarea cols="73" rows="5" id="dscAtividadesCargo"
	                      		onKeyDown="limitarCaracteres(this,document.getElementById('qtdDscAtividadesCargo'),4000);" 
		                    	onKeyUP  ="limitarCaracteres(this,document.getElementById('qtdDscAtividadesCargo'),4000);"><%=(requisicao[0][74]==null)?"":requisicao[0][74]%></textarea>
	                      	<br>
	                      	<input id="qtdDscAtividadesCargo" type="text" name="qtdDscAtividadesCargo" class="label" readonly="readonly" value="<%=((requisicao[0][74]==null)?0:requisicao[0][74].length())%>" size="4" align="middle">
	                      	<br>
                      	<%} else {%>
                        	<%=(requisicao[0][74]==null)?"":requisicao[0][74]%>
                        <% } %>
                      </div>
                    </td>               
                  </tr>                    
                  <tr>
                    <td colspan="4" height="28" align="left" class="tdIntranet2">
                      <div align="justify" style="padding-left:5px; padding-right:5px;">
                      	<STRONG>Escolaridade mínima</STRONG><br>
                      	<% if(nec && requisicao[0][54].equals("2")) {%>
	                      	<textarea cols="73" rows="5" id="descricaoFormacao" 
	                      		onKeyDown="limitarCaracteres(this,document.getElementById('qtdFormacao'),4000);" 
		                    	onKeyUP  ="limitarCaracteres(this,document.getElementById('qtdFormacao'),4000);"><%=(requisicao[0][59]==null)?((requisicao[0][58]==null)?"":requisicao[0][58]):requisicao[0][59]%></textarea>
	                      	<br>
	                      	<input id="qtdFormacao" type="text" name="qtdFormacao" class="label" readonly="readonly" value="<%=(requisicao[0][59]==null)?((requisicao[0][58]==null)?0:requisicao[0][58].length()):requisicao[0][59].length()%>" size="4" align="middle">
	                      	<br>
                      	<%} else {%>
                        	<%=(requisicao[0][59]==null)?((requisicao[0][58]==null)?"":requisicao[0][58]):requisicao[0][59]%>
                        <% } %>
                      </div>
                    </td>               
                  </tr>
                  <tr>
                    <td colspan="4" height="28" class="tdIntranet2">
                      <div align="justify" style="padding-left:5px; padding-right:5px;">
                      	<STRONG>Experiência profissional</STRONG><br>
                      	<% if(nec && requisicao[0][54].equals("2")) {%>                      		
                      		<textarea cols="73" rows="5" id="dscExperiencia" 
	                    		onKeyDown="limitarCaracteres(this,document.getElementById('qtdExperiencia'),4000);" 
	                      		onKeyUP  ="limitarCaracteres(this,document.getElementById('qtdExperiencia'),4000);"><%=(requisicao[0][78]==null)?"":requisicao[0][78]%></textarea>
				          	<br>
				         	<input id="qtdExperiencia" type="text" name="qtdExperiencia" class="label" readonly="readonly" value="<%=(requisicao[0][78]==null)?0:requisicao[0][78].length()%>" size="4" align="middle">
				         	<br>
                      	<%} else { %>
                        	<%=(requisicao[0][78]==null)?"":requisicao[0][78]%>
                        <% } %>
                      </div>
                    </td>               
                  </tr>
                  <tr>
                    <td colspan="4" height="28" class="tdIntranet2">
                      <div align="justify" style="padding-left:5px; padding-right:5px;">
                      	<STRONG>Conhecimentos específicos</STRONG><br>
                      	<% if(nec && requisicao[0][54].equals("2")) {%>                      		
                      	  	<textarea cols="73" rows="5" id="dscConhecimentos" 
	                      		onKeyDown="limitarCaracteres(this,document.getElementById('qtdConhecimentos'),4000);" 
	                      		onKeyUP  ="limitarCaracteres(this,document.getElementById('qtdConhecimentos'),4000);" ><%=(requisicao[0][81]==null)?"":requisicao[0][81]%></textarea>
	                      	<br>
	              			<input id="qtdConhecimentos" type="text" name="qtdConhecimentos" class="label" readonly="readonly" value="<%=(requisicao[0][81]==null)?0:requisicao[0][81].length()%>" size="4" align="middle">
	              			<br>
                      	<%} else {%>
                        	<%=(requisicao[0][81]==null)?"":requisicao[0][81]%>
                        <% } %>
                      </div>
                    </td>               
                  </tr>
                  <tr>
                    <td colspan="4" height="28" class="tdIntranet2">
                      <div align="justify" style="padding-left:5px; padding-right:5px;">
                      	<STRONG>Competências</STRONG><br>
                      	<% if(nec && requisicao[0][54].equals("2")) {%>
                      		<textarea cols="73" rows="5" id="outrasCarateristica" title="Relate os comportamentos, habilidades e atitudes desejadas para o desempenho da função."
	                      		onKeyDown="limitarCaracteres(this,document.getElementById('qtdOutrasCaracteristicas'),4000);" 
	                      		onKeyUP  ="limitarCaracteres(this,document.getElementById('qtdOutrasCaracteristicas'),4000);" ><%=(requisicao[0][62]==null)?"":requisicao[0][62]%></textarea>
	              			<br>
	              			<input id="qtdOutrasCaracteristicas" type="text" name="qtdOutrasCaracteristicas" class="label" readonly="readonly" value="<%=(requisicao[0][62]==null)?0:requisicao[0][62].length()%>" size="4" align="middle">
	              			<br>
	              		<%} else {%>
                        	<%=(requisicao[0][62]==null)?"":requisicao[0][62]%>
                        <% } %>
                      </div>
                    </td>               
                  </tr>    
              <%}%>
              <tr>
                <td height="28" class="tdIntranet2" colspan="4">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                  	<STRONG>Observações</STRONG><br>
                  	<% if(nec && requisicao[0][54].equals("2")) {%>
	                  	<textarea cols="73" rows="5" id="comentarios"
		                	onKeyDown="limitarCaracteres(this,document.getElementById('qtdComentarios'),2000);" 
		                    onKeyUP  ="limitarCaracteres(this,document.getElementById('qtdComentarios'),2000);" ><%=(requisicao[0][65]==null)?"":requisicao[0][65]%></textarea>
		              	<br>
		              	<input id="qtdComentarios" type="text" name="qtdComentarios" class="label" readonly="readonly" value="<%=(requisicao[0][65]==null)?0:requisicao[0][65].length()%>" size="4" align="middle">
		              	<br>
		            <%} else {%>
                    	<%=(requisicao[0][65]==null)?"":requisicao[0][65]%>
                    <% } %>
                  </div>
                </td>               
              </tr>
              <%if(isExibe){%>
                  <tr>
                    <td height="28" align="left" class="tdIntranet2" colspan="4">
                      &nbsp;<STRONG>Indicado - Nome</STRONG><br>&nbsp;<%=(requisicao[0][26]==null)?"":((requisicao[0][37]==null)?"":requisicao[0][37]+" - ") + requisicao[0][26]%>
                    </td>               
                  </tr>
                  <tr>
                    <td height="28" align="left" class="tdIntranet2" colspan="4">
                      &nbsp;<STRONG>Indicado - Unidade</STRONG><br>&nbsp;<%=(requisicao[0][66]==null)?"":requisicao[0][66]%>
                    </td>               
                  </tr>                            
              <%}%>
              <tr>
                <td height="28" align="left" class="tdIntranet2" colspan="4">
                  &nbsp;<STRONG>Funcionário utilizado na Baixa</STRONG><br>&nbsp;<%=(requisicao[0][67]==null)?"":requisicao[0][67]+" - "+requisicao[0][68]%>
                </td>               
              </tr>              
              <tr>
                <td height="3" colspan="4" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/fio_azul_end.gif' ></td>
              </tr>              
            </table>
            <br>
            <div id="divBotoes" align="center">
              <%if(isEmail.booleanValue()){%>
                <input type="button" class="botaoIntranet" value="Acessar área de aprovação" onclick="telaInicial();">
                &nbsp;&nbsp;
              <%}%>
              <input type="button" class="botaoIntranet" value="Imprimir" onclick="imprimir();">
              &nbsp;&nbsp;
              <input type="button" class="botaoIntranet" value="  Fechar " onclick="window.close();">
              <% if(nec) {%>
              	&nbsp;&nbsp;
              	<input type="button" name="btnAtualizaTexto" class="botaoIntranet" value="Atualizar" onclick="atualizaTextos();">&nbsp;
              <% }%>
            </div>            
        </td>
      </tr>
    </table>
<%}else{%> 
  <table width="610" border="0" align="center">
    <tr>
      <td class="tdIntranet" height="10"></td>
    </tr>
    <tr>
      <td class="tdIntranet2" height="25" align="center">
        <strong>Nenhuma informação referente a RP nº <%=codRequisicao%> foi encontrada!</strong>
      </td>
    </tr>
    <tr>
      <td class="tdIntranet" height="10"></td>
    </tr>
  </table>
<%}%>
</body>