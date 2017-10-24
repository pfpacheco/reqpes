<%@ page errorPage="../../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.Control.InstrucaoControl" %>
<%@ page import="br.senac.sp.reqpes.model.Instrucao" %>

<%  
  //-- Objetos
  Instrucao[] instrucao = null;
  StringBuffer where = new StringBuffer();
   
  //-- Parametros de página
  int codTabela      = (request.getParameter("P_TAB_SALARIAL")==null)?0:Integer.parseInt(request.getParameter("P_TAB_SALARIAL"));
  int codCargo       = (request.getParameter("P_CARGO")==null)?0:Integer.parseInt(request.getParameter("P_CARGO"));  
  int numeroDaPagina = (request.getParameter("P_PAGINA")==null)?1:Integer.parseInt(request.getParameter("P_PAGINA"));   
  int qtdPorPagina   = (request.getParameter("P_QTD_PAGINA")==null)?60:Integer.parseInt(request.getParameter("P_QTD_PAGINA"));
  String codUnidade  = request.getParameter("P_UNIDADE");
   
  //-- Verificando as cláusulas da pesquisa
  if(codTabela != 0){
    where.append(" AND T.COD_TAB_SALARIAL = " + codTabela);
  }
  
  if(codCargo != 0){
	where.append(" AND T.COD_CARGO = " + codCargo);
  }   
  
  if(!codUnidade.equals("0")){
	where.append(" AND EXISTS (SELECT 1 ");
	where.append(" FROM   INSTRUCAO_ATRIBUICAO IA ");
	where.append(" WHERE  IA.COD_INSTRUCAO = T.COD_INSTRUCAO ");
	where.append(" AND    IA.COD_UNIDADE = '"+ codUnidade +"')");
  }     
  
  //-- Resgatando as instruçoes
  instrucao = new InstrucaoControl().getInstrucaos(where.toString());
%>

<table width="610" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>
      <%-- IMPRESSÃO DOS VALORES --%>       
       <%if(instrucao != null && instrucao.length > 0){%>
          <table border="0" cellpadding="0" cellspacing="0" width="610" >
            <tr>
              <td align="left" height="25"  class="tdTemplateLista" width="42%"><STRONG>&nbsp;Tabela Salarial</STRONG></td>
              <td align="left" height="25"  class="tdTemplateLista" width="45%"><STRONG>Cargo</STRONG></td>
              <td align="center" height="25"  class="tdTemplateLista" width="5%"><STRONG>Cota</STRONG></td>
              <td align="center" height="25"  class="tdTemplateLista" width="8%" ><STRONG>Opções</STRONG></td>
            </tr>
          <% 
            String classCSS = "borderintranet";
            int qtdLinhas      = instrucao.length;
            qtdPorPagina       = (qtdLinhas>qtdPorPagina)?qtdPorPagina:qtdLinhas;
            int registroIncial = ((numeroDaPagina -1) * qtdPorPagina);
            int registroFinal  = registroIncial + qtdPorPagina;
            registroFinal      = (qtdLinhas>registroFinal)?registroFinal:qtdLinhas;      
      
            for(int i=registroIncial;i<registroFinal;i++){
              classCSS = ((i%2)==1)?"tdintranet2":"borderintranet";
          %>
              <tr >
                <td align="left"   height="25" class="<%= classCSS %>" width="42%">&nbsp;<%=instrucao[i].getTabelaSalarial().getDscTabelaSalarial().toUpperCase()%></td>
                <td align="left"   height="25" class="<%= classCSS %>" width="45%"><%=instrucao[i].getDscCargo()%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="5%"><%=instrucao[i].getCota()%></td>
                <td align="center" height="25" class="<%= classCSS %>" width="8%">
                  <a href="javaScript:editar(<%=instrucao[i].getCodInstrucao()%>);">
                    <img src="../../imagens/ico-pag.gif" border="0" alt="Editar"/>
                  </a>
                  <a href="javaScript:excluir(<%=instrucao[i].getCodInstrucao()%>);">
                    <img src="../../imagens/excluir.gif" border="0" alt="Excluir"/>
                  </a>
                </td>
              </tr>
        <%}%>
          </table>
          <%-- PAGINAÇÃO --%>
          <jsp:include page="../../../template/paginacao.jsp"                      >
            <jsp:param  name="pNumeroDeRegistros" value="<%=instrucao.length%>"/>
            <jsp:param  name="pQtdPorPagina"      value="<%=qtdPorPagina%>"    />
            <jsp:param  name="pNumeroDaPagina"    value="<%=numeroDaPagina%>"  />
            <jsp:param  name="pUrlLink"           value="index.jsp"            />
          </jsp:include>             
        <tr>
          <td colspan="4" height="3" class="tdIntranet2">&nbsp;</td>
        </tr>           
        <tr>
          <td colspan="4" height="3" class="tdCabecalho" background="../../imagens/fio_azul_end.gif"></td>
        </tr>           
      <%}else{%>
          <tr>
            <td colspan="4" height="3" align="center"><strong>Nenhuma informação foi localizada!</strong></td>
          </tr>                 
      <%}%>
    </td>
  </tr>    
</table>