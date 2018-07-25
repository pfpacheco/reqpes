<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page import="br.senac.sp.reqpes.Interface.Config" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>

<jsp:include page="../../../template/cabecalho.jsp"/>

<%
  //-- Objetos de controle
  RequisicaoBaixaControl  requisicaoBaixaControl  = new RequisicaoBaixaControl();
  SistemaParametroControl sistemaParametroControl = new SistemaParametroControl();  
  RequisicaoControl       requisicaoControl       = new RequisicaoControl();
  
  //-- Objetos
  StringBuffer sqlSistemaParametro = new StringBuffer();
  SistemaParametro idPerfilHOM = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_UO");
  SistemaParametro[] sistemaParametro = null;
  String[][] requisicoesExpirando = null;
  String[][] comboUnidade = null;
  String[][] comboCargo = null;
  String where = "";
  String todasUnidades = "";
  
  //-- Objeto de sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Parametros de página
  String codRequisicao = (request.getParameter("codRequisicao")==null)?"":request.getParameter("codRequisicao");  
  String codUnidade    = (request.getParameter("codUnidade")==null)?"0":request.getParameter("codUnidade");  
  String codCargo      = (request.getParameter("codCargo")==null)?"0":request.getParameter("codCargo");       
  int numeroDaPagina   = (request.getParameter("numeroDaPagina")==null)?1:Integer.parseInt(request.getParameter("numeroDaPagina"));   
  int qtdPorPagina     = (request.getParameter("qtdPorPagina")==null)?40:Integer.parseInt(request.getParameter("qtdPorPagina"));   
  
  //-- Carregando o combo de cargos
  comboCargo = requisicaoControl.getComboCargosExistentesRequisicao();  
  //-- Carregando o combo de unidades de acordo com as unidades de acesso do usuario
  if(usuario.getSistemaPerfil().getCodSistemaPerfil() == Integer.parseInt(idPerfilHOM.getVlrSistemaParametro())){
    //-- verificando as unidades de acesso    
    for(int i=0; usuario.getUnidades() != null && i < usuario.getUnidades().length; i++){
      todasUnidades += ((i==0)?" ":",") + usuario.getUnidades()[i].getCodUnidade();
    } 
    
    // combo preenchido apenas com as unidade de acesso (HOMOLOGADOR - Gerente)
    comboUnidade  = requisicaoControl.getComboUnidadesRelacionadas(usuario.getUnidade().getCodUnidade(), todasUnidades);
  }else{
    // combo com todas as unidades (ADM, HOMOLOGADOR-GEP e APROVADOR)
    comboUnidade = requisicaoControl.getComboUnidadesRelacionadas();  
  }
  
  //-- Verificando as cláusulas da pesquisa
  if(!codRequisicao.equals("")){
    where += " AND R.REQUISICAO_SQ = " + codRequisicao ;
  }

  if(!codUnidade.equals("0")){
    where += " AND R.COD_UNIDADE = '" + codUnidade +"'";
  }
  
  if(!codCargo.equals("0")){
    where += " AND R.CARGO_SQ = " + codCargo ;
  }     
  
  //-- Resgatando os parametros do sistema utilizados na expiração
  sqlSistemaParametro.append(" WHERE  SP.COD_SISTEMA = " + Config.ID_SISTEMA);
  sqlSistemaParametro.append(" AND    SP.NOM_PARAMETRO IN ('CONTRATACAO_VALIDADE', 'EXPIRACAO_AVISO') ");
  sqlSistemaParametro.append(" ORDER BY SP.NOM_PARAMETRO ");
  sistemaParametro = sistemaParametroControl.getSistemaParametros(sqlSistemaParametro.toString());
  
  //-- Caso haja valores nos parametros, chama o método que retorna as requisições que estão expirando
  if(sistemaParametro != null && sistemaParametro.length > 0){
    int contratacaoValidade = (sistemaParametro[0].getVlrSistemaParametro()==null)?0:Integer.parseInt(sistemaParametro[0].getVlrSistemaParametro());
    int expiracaoAviso      = (sistemaParametro[1].getVlrSistemaParametro()==null)?0:Integer.parseInt(sistemaParametro[1].getVlrSistemaParametro());
    
    //-- Monta a condição where para o HOMOLOGADOR (Gerente), para visualização de suas RP's apenas
    if(usuario.getSistemaPerfil().getCodSistemaPerfil() == Integer.parseInt(idPerfilHOM.getVlrSistemaParametro())){
      todasUnidades = (todasUnidades.equals(""))?"0":todasUnidades;
      where += "AND (SUBSTR(R.COD_UNIDADE,1,3) = LPAD("+usuario.getUnidade().getCodUnidade()+",3,0) OR U.COD_UNIDADE IN ("+todasUnidades+"))";    
    }
    
    requisicoesExpirando = requisicaoBaixaControl.getRequisicoesParaBaixaExpirando(contratacaoValidade, expiracaoAviso, where);
  }
%>

<script language="JavaScript" src="<%=request.getContextPath()%>/js/mascara.js" type="text/javascript"></script> 
<script language="javaScript">   
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
  //--
  function limpaCampos(){
    document.frmRequisicao.codCargo.value = 0;
    document.frmRequisicao.codUnidade.value = 0;
  }    
  //--
  function requisicaoDados(parametro){
    popUP('<%=request.getContextPath()%>/relatorio/index.jsp?'+parametro,'link','toolbar=no,width=660,height=600,scrollbars=yes');
  }
  //--
  function requisicaoHistorico(parametro){
    popUP('<%=request.getContextPath()%>/relatorio/historico.jsp?'+parametro,'link','toolbar=no,width=860,height=600,scrollbars=yes');
  }    
</script>

<center>
<br>
<form name="frmRequisicao" action="index.jsp" method="POST" >  
  <input type="HIDDEN" name="numeroDaPagina" value="<%=numeroDaPagina%>"/>
  <input type="HIDDEN" name="qtdPorPagina"   value="<%=qtdPorPagina%>"/>
  <table width="610" border="0" align="center" cellpadding="0" cellspacing="0">  
    <tr>
      <td>
        <table border="0" width="610" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="4"  height="18" class="tdCabecalho" background='<%= request.getContextPath()%>/imagens/tit_item.gif' >
             <STRONG>&nbsp;&nbsp;REQUISIÇÕES APROVADAS EXPIRANDO</STRONG>
            </td>
          </tr> 
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
          <tr>
            <td colspan="2" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
          </tr>             
        </table>
        <br>
      <%-- IMPRESSÃO DOS VALORES --%>       
       <%if(requisicoesExpirando != null && requisicoesExpirando.length > 0){%>
          <table border="0" cellpadding="0" cellspacing="0" width="610" >
          <tr >
            <td align="center" height="25"  class="tdTemplateLista" width="8%"><STRONG>RP</STRONG></td>
            <td align="center" height="25"  class="tdTemplateLista" width="12%"><STRONG>Data</STRONG></td>
            <td align="center" height="25"  class="tdTemplateLista" width="12%"><STRONG>Aprovada</STRONG></td>
            <td align="center" height="25"  class="tdTemplateLista" width="12%"><STRONG>Expiração</STRONG></td>
            <td align="left"   height="25"  class="tdTemplateLista" width="45%"><STRONG>Cargo</STRONG></td>
            <td align="center" height="25"  class="tdTemplateLista" width="12%"><STRONG>Unidade</STRONG></td>
          </tr>
          <% 
            String classCSS = "borderintranet";
            int qtdLinhas      = requisicoesExpirando.length;
            qtdPorPagina       = (qtdLinhas>qtdPorPagina)?qtdPorPagina:qtdLinhas;
            int registroIncial = ((numeroDaPagina -1) * qtdPorPagina);
            int registroFinal  = registroIncial + qtdPorPagina;
            registroFinal      = (qtdLinhas>registroFinal)?registroFinal:qtdLinhas;      

            for(int i=registroIncial; i<registroFinal;i++){
              classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
          %>
              <tr >
                <td align="center" height="25" class="<%= classCSS %>" width="8%">
                  <a href="javaScript:requisicaoDados('codRequisicao=<%=requisicoesExpirando[i][0]%>');" title="Visualizar RP">
                    <%=requisicoesExpirando[i][0]%>
                  </a>                
                </td>
                <td align="center" height="25" class="<%= classCSS %>" width="12%">
                  <a href="javaScript:requisicaoHistorico('codRequisicao=<%=requisicoesExpirando[i][0]%>');" title="Visualizar histórico da RP">
                    <%=requisicoesExpirando[i][1]%>
                  </a>
                </td>
                <td align="center" height="25" class="<%= classCSS %>" width="12%"><%=requisicoesExpirando[i][2]%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="12%"><%=requisicoesExpirando[i][3]%></td>
                <td align="left"   height="25" class="<%= classCSS %>" width="45%"><%=(requisicoesExpirando[i][4]==null)?"":requisicoesExpirando[i][4]%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="12%" title="<%=requisicoesExpirando[i][7]%>"><%=requisicoesExpirando[i][5]+" / "+ requisicoesExpirando[i][6]%></td>
              </tr>
        <%}%>
          </table>
          <%-- PAGINAÇÃO --%>
          <jsp:include page="../../../template/paginacao.jsp"                      >
            <jsp:param  name="pNumeroDeRegistros" value="<%=requisicoesExpirando.length%>"/>
            <jsp:param  name="pQtdPorPagina"      value="<%=qtdPorPagina%>"    />
            <jsp:param  name="pNumeroDaPagina"    value="<%=numeroDaPagina%>"  />
            <jsp:param  name="pUrlLink"           value="index.jsp"            />
          </jsp:include>     

        <tr>
          <td colspan="4" height="3" class="tdIntranet2">&nbsp;</td>
        </tr>           
        <tr>
          <td colspan="4" height="3" class="tdCabecalho" background="<%= request.getContextPath()%>/imagens/fio_azul_end.gif"></td>
        </tr>           
      <%}else{%>
          <tr>
            <td colspan="4" height="3" align="center"><strong>Nenhuma RP foi localizada!</strong></td>
          </tr>                 
      <%}%>
      </td>
    </tr>         
  </table>
</form>   
</center>
<br>
<jsp:include page="../../../template/fimTemplateIntranet.jsp"/>