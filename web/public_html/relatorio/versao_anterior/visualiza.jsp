<%@ page import="br.senac.sp.reqpes.Control.RequisicaoControl" %>
<%@ page errorPage="../../error/error.jsp" %>

<%
  String[][] requisicao = new RequisicaoControl().getPesquisaRequisicaoAntiga(Integer.parseInt(request.getParameter("codRequisicao")));
%>

<link href="../../css/stylesheet.css" rel="STYLESHEET" type="text/css"/>
<body onload="focus();">

<script language="javaScript">   
  function imprimir(){    
	  
    divBotoes.style.visibility = "hidden";
    divBotoes.style.display = "none";

    try{
        divCaraterExcecao.style.visibility = "hidden";
    	divCaraterExcecao.style.display = "none";
    }
    catch(e){}

    try{
    	divVersaoSistema.style.visibility = "hidden";
        divVersaoSistema.style.display = "none";
    }
    catch(e){}
    
    window.print();
  }
</script>

<%if(requisicao != null && requisicao.length > 0){%>
  <table width="610" border="0" align="center">
      <tr>
        <td>
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td>
                  <jsp:include page="../../template/cabecalhoRelatorio.jsp">
                    <jsp:param name="titulo" value="Requisição de Pessoal"/>
                  </jsp:include>
                </td>
              </tr>
            </table>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="3" height="18" align="center" class="tdCabecalho" background='../../imagens/tit_item.gif'>
                 <STRONG>DADOS DA REQUISIÇÃO</STRONG>
                </td>
              </tr>           
              <tr>
                <td height="23" align="left" class="tdIntranet2" width="33%">
                 &nbsp;<STRONG>Número RP</STRONG><br>&nbsp;<%=requisicao[0][0]%>
                </td>
                <td height="23" align="left" class="tdIntranet2" width="40%">
                 &nbsp;<STRONG>Tipo</STRONG><br>&nbsp;<%=(requisicao[0][105]==null)?"":requisicao[0][105] %>
                </td>                
                <td height="23" align="left" class="tdIntranet2" width="27%">
                 &nbsp;<STRONG>Data de criação</STRONG><br>&nbsp;<%=requisicao[0][31]%>
                </td>                                
              </tr>    
              <tr>
                <td height="3" colspan="3" class="tdCabecalho" background='../../imagens/fio_azul_end.gif' ></td>
              </tr>              
            </table>
            <br>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="4" height="18" align="center" class="tdCabecalho" background='../../imagens/tit_item.gif'>
                 <STRONG>SOLICITANTE</STRONG>
                </td>
              </tr>  
              <tr>
                <td height="26" align="left" class="tdIntranet2" width="9%">
                 &nbsp;<STRONG>Unidade</STRONG><br>&nbsp;<%=(requisicao[0][56]==null)?"":requisicao[0][56]%>
                </td>
                <td height="26" align="left" class="tdIntranet2" width="31%">
                    &nbsp;<STRONG>UO/MA/SMA</STRONG><br>&nbsp;<%=requisicao[0][1].substring(0,requisicao[0][1].length()-1)%>&nbsp;|&nbsp;<%=(requisicao[0][6]==null)?"":requisicao[0][6]%>&nbsp;|&nbsp;<%=(requisicao[0][7]==null)?"":requisicao[0][7]%>
                </td>                
                <td height="26" align="left" class="tdIntranet2" width="45%">
                 &nbsp;<STRONG>Nome superior imediato</STRONG><br>&nbsp;<%=(requisicao[0][11]==null)?"":requisicao[0][11]%>
                </td>
                <td height="26" align="left" class="tdIntranet2" width="15%">
                 &nbsp;<STRONG>Telefone</STRONG><br>&nbsp;<%=(requisicao[0][12]==null)?"":requisicao[0][12]%>
                </td>                
              </tr>    
              <tr>
                <td height="3" colspan="4" class="tdCabecalho" background='../../imagens/fio_azul_end.gif' ></td>
              </tr>                
            </table>
            <br>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="4" height="18" align="center" class="tdCabecalho" background='../../imagens/tit_item.gif'>
                 <STRONG>DADOS DE REFERÊNCIA DO CARGO</STRONG>
                </td>
              </tr>  
              <tr>
                <td colspan="4" height="23" class="tdIntranet2" style="text-align=justify;">
                 &nbsp;<STRONG>Tipo de recrutamento</STRONG><br>&nbsp;<%=(requisicao[0][30]==null)?"":requisicao[0][30]%>
                </td>
              </tr>
              <tr>               
                <td height="29" class="tdIntranet2" width="38%">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Título do cargo</STRONG><br><%=(requisicao[0][5]==null)?"":requisicao[0][5]%>
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
                <td height="29" class="tdIntranet2" colspan="1">
                 &nbsp;<STRONG>Previsão de Transferência</STRONG><br>&nbsp;<%=(requisicao[0][41]==null)?"":requisicao[0][41]%>
                </td>
                <td height="29" align="left" class="tdIntranet2">
                 &nbsp;<STRONG>Carta-Convite</STRONG><br>&nbsp;<%=(requisicao[0][42]==null)?"":requisicao[0][42]%>
                </td>
                <td height="29" align="left" class="tdIntranet2" >
                 &nbsp;<STRONG>Ex-Carta-Convite</STRONG><br>&nbsp;<%=(requisicao[0][43]==null)?"":requisicao[0][43]%>
                </td>                
                <td height="29" align="left" class="tdIntranet2">
                 &nbsp;<STRONG>Ex-Funcionário</STRONG><br>&nbsp;<%=(requisicao[0][44]==null)?"":requisicao[0][44]%>
                </td>                                
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
                <td height="3" colspan="4" class="tdCabecalho" background='../../imagens/fio_azul_end.gif' ></td>
              </tr>                
            </table>
            <br>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="4" height="18" align="center" class="tdCabecalho" background='../../imagens/tit_item.gif'>
                 <STRONG>HORÁRIO DE TRABALHO</STRONG>
                </td>
              </tr>
              <tr>
                <td class="tdIntranet2" colspan="4">              
                  <table border="0" width="100%">
                    <tr>
                      <td height="20" align="left" class="tdIntranet2" width="15%">
                        <STRONG>Segunda</STRONG>
                      </td>                 
                      <td align="center" class="tdIntranet2" width="20%">
                        <%=requisicao[0][57]%>
                      </td>
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td align="center" class="tdIntranet2" width="20%">
                        <%=requisicao[0][58]%>
                      </td>
                      <td align="center" class="tdIntranet2" width="20%">
                        <%=requisicao[0][59]%>
                      </td>                
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td align="center" class="tdIntranet2" width="20%">
                        <%=requisicao[0][60]%>
                      </td>
                    </tr>
                    <tr>
                      <td height="20" align="left" class="tdIntranet2" width="13%">
                        <STRONG>Terça</STRONG>
                      </td>                 
                      <td width="13%" align="center" class="tdIntranet2">
                        <%=requisicao[0][61]%>
                      </td>
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="20%" align="center" class="tdIntranet2">
                        <%=requisicao[0][62]%>
                      </td>
                      <td width="23%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][63]%>
                      </td>                
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="25%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][64]%>
                      </td>
                    </tr>
                    <tr>
                      <td height="20" align="left" class="tdIntranet2" width="13%">
                        <STRONG>Quarta</STRONG>
                      </td>                 
                      <td width="13%" align="center" class="tdIntranet2">
                        <%=requisicao[0][65]%>
                      </td>
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="20%" align="center" class="tdIntranet2">
                        <%=requisicao[0][66]%>
                      </td>
                      <td width="23%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][67]%>
                      </td>                
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="25%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][68]%>
                      </td>
                    </tr>       
                    <tr>
                      <td height="20" align="left" class="tdIntranet2" width="13%">
                        <STRONG>Quinta</STRONG>
                      </td>                 
                      <td width="13%" align="center" class="tdIntranet2">
                        <%=requisicao[0][69]%>
                      </td>
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="20%" align="center" class="tdIntranet2">
                        <%=requisicao[0][70]%>
                      </td>
                      <td width="23%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][71]%>
                      </td>                
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="25%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][72]%>
                      </td>
                    </tr>        
                    <tr>
                      <td height="20" align="left" class="tdIntranet2" width="13%">
                        <STRONG>Sexta</STRONG>
                      </td>                 
                      <td width="13%" align="center" class="tdIntranet2">
                        <%=requisicao[0][73]%>
                      </td>
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="20%" align="center" class="tdIntranet2">
                        <%=requisicao[0][74]%>
                      </td>
                      <td width="23%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][75]%>
                      </td>                
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="25%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][76]%>
                      </td>
                    </tr>               
                    <tr>
                      <td height="20" align="left" class="tdIntranet2" width="13%">
                        <STRONG>Sábado</STRONG>
                      </td>                 
                      <td width="13%" align="center" class="tdIntranet2">
                        <%=requisicao[0][77]%>
                      </td>
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="20%" align="center" class="tdIntranet2">
                        <%=requisicao[0][78]%>
                      </td>
                      <td width="23%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][79]%>
                      </td>                
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="25%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][80]%>
                      </td>
                    </tr>   
                    <tr>
                      <td height="20" align="left" class="tdIntranet2" width="13%">
                        <STRONG>Domingo</STRONG>
                      </td>                 
                      <td width="13%" align="center" class="tdIntranet2">
                        <%=requisicao[0][81]%>
                      </td>
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="20%" align="center" class="tdIntranet2">
                        <%=requisicao[0][82]%>
                      </td>
                      <td width="23%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][83]%>
                      </td>                
                      <td width="3%" align="center" class="tdIntranet2">
                          &nbsp;às&nbsp;
                      </td>
                      <td width="25%" align="center" class="tdIntranet2" >
                        <%=requisicao[0][84]%>
                      </td>
                    </tr>                    
                  </table>
                </td>
              </tr>             
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
              <tr>
                <td height="26" class="tdIntranet2" colspan="7">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Descrição das tarefas que irá desempenhar</STRONG><br><%=(requisicao[0][21]==null)?"":requisicao[0][21]%>
                  </div>
                </td>                
              </tr>
              <tr>
                <td height="3" colspan="4" class="tdCabecalho" background='../../imagens/fio_azul_end.gif' ></td>
              </tr>                
            </table>
            <br>
            <table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td colspan="4" height="18" align="center" class="tdCabecalho" background='../../imagens/tit_item.gif'>
                 <STRONG>PERFIL DO CANDIDATO</STRONG>
                </td>
              </tr>               
              <tr>
                <td height="28" align="left" class="tdIntranet2" width="15%"%>
                  &nbsp;<STRONG>Idade (faixa)</STRONG><br>&nbsp;<%=(requisicao[0][88]==null)?"":requisicao[0][88]+ " a "+requisicao[0][89]%>
                </td>               
                <td height="28" align="left" class="tdIntranet2" width="22%">
                  &nbsp;<STRONG>Sexo</STRONG><br>&nbsp;<%=(requisicao[0][85]==null)?"":requisicao[0][85]%>
                </td>                               
                <td height="28" align="left" class="tdIntranet2" width="22%">
                  &nbsp;<STRONG>Tempo de experiência</STRONG><br>&nbsp;<%=(requisicao[0][91]==null)?"":requisicao[0][91]+"&nbsp;meses"%>
                </td>                                               
                <td height="28" align="left" class="tdIntranet2" width="41%">
                  &nbsp;<STRONG>Tipo de experiência</STRONG><br>&nbsp;<%=(requisicao[0][92]==null)?"":requisicao[0][92]%>
                </td>                                                            
              </tr>              
              <tr>                              
                <td height="28" class="tdIntranet2" colspan="3">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Escolaridade</STRONG><br>&nbsp;<%=(requisicao[0][86]==null)?"":requisicao[0][86]%>
                  </div>
                </td>
                <td height="28" class="tdIntranet2">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Formação desejável</STRONG><br><%=(requisicao[0][87]==null)?"":requisicao[0][87]%>
                  </div>
                </td>
              </tr>
              <tr>
                <td height="28" class="tdIntranet2" colspan="4">
                  &nbsp;<STRONG>Outras características</STRONG><br><%=(requisicao[0][90]==null)?"":requisicao[0][90]%>
                </td>               
              </tr>
              <tr>
                <td height="28" class="tdIntranet2" colspan="4">
                  <div align="justify" style="padding-left:5px; padding-right:5px;">
                    <STRONG>Observações</STRONG><br><%=(requisicao[0][93]==null)?"":requisicao[0][93]%>
                  </div>
                </td>               
              </tr>
              <tr>
                <td height="28" align="left" class="tdIntranet2" colspan="4">
                  &nbsp;<STRONG>Indicado - Nome</STRONG><br>&nbsp;<%=(requisicao[0][26]==null)?"":((requisicao[0][37]==null)?"":requisicao[0][37]+" - ") + requisicao[0][26]%>
                </td>               
              </tr>
              <tr>
                <td height="28" align="left" class="tdIntranet2" colspan="4">
                  &nbsp;<STRONG>Indicado - Unidade</STRONG><br>&nbsp;<%=(requisicao[0][94]==null)?"":requisicao[0][94]%>
                </td>               
              </tr>                            
              <tr>
                <td height="28" align="left" class="tdIntranet2" colspan="4">
                  &nbsp;<STRONG>Funcionário utilizado na Baixa</STRONG><br>&nbsp;<%=(requisicao[0][95]==null)?"":requisicao[0][95]+" - "+requisicao[0][96]%>
                </td>               
              </tr>              
              <tr>
                <td height="3" colspan="4" class="tdCabecalho" background='../../imagens/fio_azul_end.gif' ></td>
              </tr>              
            </table>
            <br>
            <div id="divBotoes" align="center">
              <input type="button" class="botaoIntranet" value="Imprimir" onclick="imprimir();">
              &nbsp;&nbsp;
              <input type="button" class="botaoIntranet" value="  Fechar " onclick="window.close();">
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
        <strong>Nenhuma informação referente a RP foi encontrada!</strong>
      </td>
    </tr>
    <tr>
      <td class="tdIntranet" height="10"></td>
    </tr>
  </table>
<%}%>
</body>