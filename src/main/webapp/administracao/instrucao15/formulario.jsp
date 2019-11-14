<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>

<jsp:include page="../../template/cabecalho.jsp"/>

<%
  //-- Objetos control
  InstrucaoControl instrucaoControl = new InstrucaoControl();
   
  //-- Parametros de página
  int codInstrucao = (request.getParameter("codInstrucao")==null)?0:Integer.parseInt(request.getParameter("codInstrucao"));   
  
  //-- Objetos
  Instrucao instrucao = null;
  InstrucaoAtribuicao[] instrucaoAtribuicao = null;
  TabelaSalarial[] tabelaSalarial = null;
  
  String acaoForm  = "gravar.jsp";
  String botaoForm = "bt_cadastrar.gif";
  String altBotao  = "Cadastrar";
  
  //-- Carregando objetos
  tabelaSalarial = new TabelaSalarialControl().getTabelaSalarials(" WHERE T.IND_ATIVO = 'S' ");
  instrucao = instrucaoControl.getInstrucao(codInstrucao);     
  instrucaoAtribuicao = new InstrucaoAtribuicaoControl().getInstrucaoAtribuicao(codInstrucao);
  
  //-- Verificando instância do objeto
  if(instrucao == null){
    instrucao = new Instrucao();
    instrucao.setCota(-1);
    instrucao.setTabelaSalarial(new TabelaSalarial());    
  }else{
    // Configurando botões
    acaoForm  = "atualizar.jsp";
    botaoForm = "bt_atualizar.gif";
    altBotao  = "Atualizar";  
  }  
%>

<script language="JavaScript" src="<%=request.getContextPath()%>/js/formulario.js" type="text/javascript"></script> 
<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js"    type="text/javascript"></script> 
<script language="JavaScript" src="<%=request.getContextPath()%>/js/ajaxItens.js" charset="utf-8"  type="text/javascript"></script> 

<script language="javaScript">
  //--
  function gravar(){
    if(decode(document.frm.codTabelaSalarial,"Selecione a tabela salarial!",0,"",null))
      if(decode(document.frm.codCargo,"Selecione o cargo!",-1,"",null))
      	if(decode(document.frm.cota,"Selecione a cota!",-1,"",null))
        	if(validaCheck(document.frm.codUnidade)){
              document.frm.submit();
            }else{
              alert('Selecione uma unidade!');
            }
  }
  //--
  function checkUncheckAll(objeto, tipo) {  
    var z,t = 0; //-- quantidade de itens
    if(tipo == 'T'){    
      for(z=0; z<objeto.length; z++){
         objeto[z].checked = true;
      }    
    }else{   
      for(t=0; t<frm.elements.length; t++){
        if(frm.elements[t].type == "checkbox"){ 
          if(frm.elements[t].nivel == tipo){
            frm.elements[t].checked = true;
          }else{
            frm.elements[t].checked = false;
          }
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
  //--
  function imprimir(){
	var parametros  = 'codInstrucao=' + document.getElementById('codInstrucao').value;
	    parametros += '&codTabela=0&codCargo=0&cota=-1&codUnidade=0';

	var  w, h, left, top;
	
	w = window.screen.width;
	h = window.screen.height;    
	    
	left =(w-900)/2;
	top  =(h-600)/2;
	    	   		  
	window.open('../../relatorio/instrucao/report.jsp?' + parametros,'Relatório','left='+left+',top='+top+',toolbar=no,width=900,height=600,scrollbars=yes');
  }  
</script>

<center>
<br>
<form name="frm" action="<%=acaoForm%>" method="POST">
  <input type="HIDDEN" name="codInstrucao" id="codInstrucao" value="<%=instrucao.getCodInstrucao()%>">
  <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td>
        <table border="0" width="610" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="3"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
             <STRONG>&nbsp;&nbsp;INSTRUÇÃO - 10/2019</STRONG>
            </td>
          </tr>  
          <tr>
            <td height="25"  align="right" class="tdintranet2" width="20%">
              <strong>Tabela salarial:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2" width="80%">
			  <select name="codTabelaSalarial" id="codTabelaSalarial" onchange="carregaComboCargoInstrucao(this.value, <%=instrucao.getCodCargo()%>, <%=instrucao.getCodInstrucao()%>);" class="select" style="width: 450px;">
                <option value="-1">SELECIONE</option>
                  <%for(int i=0; i<tabelaSalarial.length; i++){%>
                    <option value="<%=tabelaSalarial[i].getCodTabelaSalarial()%>" <%=(tabelaSalarial[i].getCodTabelaSalarial() == instrucao.getTabelaSalarial().getCodTabelaSalarial())?" SELECTED":""%>><%=tabelaSalarial[i].getDscTabelaSalarial().toUpperCase()%></option>
                  <%}%>
              </select>              
            </td>					  					
          </tr>             
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Cargo:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
               <div id="divComboCargo">
                 <%if(instrucao.getCodInstrucao() == 0){%>
                     <select name="codCargo" class="select" style="width: 450px;">
                       <option value="0">SELECIONE</option>
                     </select>
                 <%}else{%>
                     <input class="label" name="dscCargo" size="90" value="<%=instrucao.getDscCargo()%>" readonly>
                     <input type="hidden" name="codCargo" value="<%=instrucao.getCodCargo()%>">                     
                 <%}%>
               </div>
            </td>
          </tr> 
          <tr>
            <td height="25"  align="right" class="tdintranet2">
              <strong>Cota:&nbsp;</strong>
            </td>
            <td height="25" align="left" class="tdintranet2">
                <select name="cota" class="select" style="width: 450px;">
                  <option value="-1">SELECIONE</option>
                  <%for(int i=0; i<=9; i++){%>
                    <option value="<%=i%>" <%=(i == instrucao.getCota())?"SELECTED":""%>><%=i%></option>
                  <%}%>
                </select> 
            </td>
          </tr>           
          <tr>
            <td colspan="2" height="30" class="tdIntranet2" align="center">
              <br>
              <fieldset class="tdIntranet2" style="width:580px;">
                <legend ><strong><font color="Black">Unidades</font></strong></legend>
                <br>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td>
                      <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td height="35" align="center" colspan="6">                          
                              &nbsp;&nbsp;<input name="todasUnidades" type="radio" value="T" onclick="checkUncheckAll(document.frm.codUnidade, this.value);"><b>Todas as Unidades</b>&nbsp;&nbsp;&nbsp;&nbsp;
                              &nbsp;&nbsp;<input name="todasUnidades" type="radio" value="C" onclick="checkUncheckAll(document.frm.codUnidade, this.value);"><b>Todas Unidades da Capital</b>&nbsp;&nbsp;&nbsp;&nbsp;
                              &nbsp;&nbsp;<input name="todasUnidades" type="radio" value="I" onclick="checkUncheckAll(document.frm.codUnidade, this.value);"><b>Todas Unidades do Interior</b>&nbsp;&nbsp;&nbsp;&nbsp;
                          </td>
                        </tr>                                                  
                        <tr>
                          <%                                                 
                            int qtdColunas=0;
                            int totalUnidades=0;
                            for(int c=0; c<instrucaoAtribuicao.length; c++){
                              if(qtdColunas==4){ 
                                qtdColunas=0;
                          %>                        
                        </tr><tr>
                            <%} //-- final do if %>
                          <td width="16%" height="26" align="left">   
                            &nbsp;&nbsp;&nbsp;<input name="codUnidade" type="checkbox" <%=(instrucaoAtribuicao[c].getIndSelecionado().equals("S"))?"CHECKED":""%> nivel="<%=instrucaoAtribuicao[c].getIndLocalUnidade()%>" value="<%=instrucaoAtribuicao[c].getCodUnidade()%>" title="<%=instrucaoAtribuicao[c].getDscUnidade()%>"><%=instrucaoAtribuicao[c].getSiglaUnidade()%>
                          </td>
                            <% 
                              if((c+1)==instrucaoAtribuicao.length && qtdColunas < 4)
                                for(int r=qtdColunas; r<3; r++){
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
            <td colspan="2" height="30" class="tdIntranet2" align="right">
              <a href="index.jsp">
                <img src="<%=request.getContextPath()%>/imagens/bt_voltar.gif" border="0"/>
              </a>
              <%if(codInstrucao > 0){%>
	              &nbsp;&nbsp;&nbsp;
	              <a href="##" onclick="imprimir();">
	                <img src="<%=request.getContextPath()%>/imagens/bt_imprimir.gif" alt="Imprimir ficha com unidades selecionadas" border="0"/>
	              </a>
	          <%}%>
              <a href="##" onclick="gravar();">
                <img src="<%=request.getContextPath()%>/imagens/<%=botaoForm%>" alt="<%=altBotao%>" border="0" hspace="15"/>
              </a>
            </td>
          </tr>           
          <tr>
            <td colspan="2" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
          </tr>                     
        </table>
      </td>
     </tr>
   </table>
</form>
</center>

<script language="javaScript">  
  <%
    //-- Carrega o combo de cargos de acordo com a tabela salarial selecionada
    if(instrucao.getCodInstrucao() == 0){
      out.print("carregaComboCargoInstrucao(" + instrucao.getCodTabelaSalarial() + "," + instrucao.getCodCargo() + "," + instrucao.getCodInstrucao() + ");\n");
    }
  %>
</script>

<br>
<jsp:include page="../../template/fimTemplateIntranet.jsp"/>