<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:include page="../../../template/cabecalho.jsp"/>

<%  
  //-- Parametros de página
  int codTabelaSalarial = (request.getParameter("codTabelaSalarial")==null)?0:Integer.parseInt(request.getParameter("codTabelaSalarial"));
     
  //-- Objetos da sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Objetos da página
  TabelaSalarial tabelaSalarial = new TabelaSalarialControl().getTabelaSalarial(codTabelaSalarial);   
  TabelaSalarialAtribuicao[] tabelas = new TabelaSalarialAtribuicaoControl().getTabelaSalarialAtribuicao(codTabelaSalarial);
  String acaoForm  = "gravar.jsp";
  String botaoForm = "bt_cadastrar.gif";
  String altBotao  = "Cadastrar";
  
  //-- Verificando instância do objeto
  if(tabelaSalarial == null){
    tabelaSalarial = new TabelaSalarial();
  }else{
    // Configurando botões
    acaoForm  = "atualizar.jsp";
    botaoForm = "bt_atualizar.gif";
    altBotao  = "Atualizar";  
  }  
%>

<br>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/formulario.js" type="text/javascript"></script> 
<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js"    type="text/javascript"></script> 

<script language="javaScript">
  function cadastrar(){
    if(decode(document.frm.dscTabelaSalarial,"Informe a descrição!",0,"",null))
      if(validarRadio(document.frm.indAtivo,"Informe se a tabela esta ativa!"))
        if(validarRadio(document.frm.indExibeAreaSubarea,"Informe se a tabela exibe área/subarea!")){
          document.frm.submit();
        }
  }  
</script>

<center>
  <table border="0" cellpadding="0" cellspacing="0" width="610" >
    <form name="frm" method="POST" action="<%=acaoForm%>">
      <input type="HIDDEN" name="codTabelaSalarial" value="<%=tabelaSalarial.getCodTabelaSalarial()%>">  
          <tr>
            <td colspan="2"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
              <STRONG>&nbsp;&nbsp;TABELA SALARIAL</STRONG>
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
              <input class="input" size="80" maxlength="400" name="dscTabelaSalarial" id="dscTabelaSalarial" value="<%=tabelaSalarial.getDscTabelaSalarial()%>">
            </td>
          </tr>
          <tr class="tdintranet2">
            <td height="23" align="right" width="25%">
              <STRONG>Ativo:&nbsp;</STRONG>
            </td>
            <td width="75%" class="tdintranet2" align="left" >
              <input type="radio" name="indAtivo" value="S" <%=(tabelaSalarial.getIndAtivo().equals("S"))?" CHECKED":""%>>Sim&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <input type="radio" name="indAtivo" value="N" <%=(tabelaSalarial.getIndAtivo().equals("N"))?" CHECKED":""%>>Não&nbsp;&nbsp;              
            </td>
          </tr>
          <tr class="tdintranet2">
            <td height="23" align="right" width="25%">
              <STRONG>Exibe Área/Subárea:&nbsp;</STRONG>
            </td>
            <td width="75%" class="tdintranet2" align="left" >
              <input type="radio" name="indExibeAreaSubarea" value="S" <%=(tabelaSalarial.getIndExibeAreaSubarea().equals("S"))?" CHECKED":""%>>Sim&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <input type="radio" name="indExibeAreaSubarea" value="N" <%=(tabelaSalarial.getIndExibeAreaSubarea().equals("N"))?" CHECKED":""%>>Não&nbsp;&nbsp;              
            </td>
          </tr>          
          <tr>
            <td height="10" class="tdintranet2" colspan="2"> </td>
          </tr>                
          <tr>
            <td height="23" class="tdintranet" colspan="2"><strong>&nbsp;&nbsp;Tabelas de acesso no <i>RHEvolution</i></strong></td>
          </tr>          
          <%-- imprimindo valores --%>
          <%
            for(int i=0; i<tabelas.length; i++){ %>
              <tr>
                <td height="10" class="tdintranet2" colspan="2">
                  &nbsp;&nbsp;&nbsp;<input type="checkbox" name="codTabelaRHEV" value="<%=tabelas[i].getCodTabelaRHEV()%>" <%=tabelas[i].getIndSelecionado().equals("S")?"CHECKED":""%>><%=tabelas[i].getDscTabelaRHEV()%>
                </td>
              </tr>            
          <%}%>
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