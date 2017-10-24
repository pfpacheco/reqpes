<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page errorPage="../../../error/error.jsp" %>

<% 
  //-- Jornada de trabalho
  String jornadaTrabalho = (request.getParameter("jornadaTrabalho")==null)?"0":request.getParameter("jornadaTrabalho");
  
  //-- Paginação
  int numeroDaPagina = (request.getParameter("numeroDaPagina")==null)?1:Integer.parseInt(request.getParameter("numeroDaPagina"));   
  int qtdPorPagina   = (request.getParameter("qtdPorPagina")==null)?5:Integer.parseInt(request.getParameter("qtdPorPagina"));
  
  //-- Objetos
  String[][] escalas = null;
  String classCSS = null;
   
  //-- Carregando as escalas
  /*
  for(int i=0; i< horarioArray.length; i++){
    out.print(horarioArray[i].getDia()+"&nbsp;&nbsp;"+horarioArray[i].getClassificacao()+"&nbsp;&nbsp;"+horarioArray[i].getEntrada()+"&nbsp;&nbsp;"+horarioArray[i].getIntervalo()+"&nbsp;&nbsp;"+horarioArray[i].getRetorno()+"&nbsp;&nbsp;"+horarioArray[i].getSaida()+"<BR>");  
  }*/  
  escalas = new RequisicaoJornadaControl().getEscala(jornadaTrabalho,
                                                     request.getParameterValues("dia"),
                                                     request.getParameterValues("classificacao"),
                                                     request.getParameterValues("entrada"),
                                                     request.getParameterValues("intervalo"),
                                                     request.getParameterValues("retorno"),
                                                     request.getParameterValues("saida"));
%>

<%-- ITENS DA PESQUISA --%>
<%if(escalas != null && escalas.length > 0){%>
    <table width="100%" border="0" cellpadding="1" cellspacing="1">
      <%
        int qtdLinhas      = escalas.length;
        qtdPorPagina       = (qtdLinhas>qtdPorPagina)?qtdPorPagina:qtdLinhas;
        int registroIncial = ((numeroDaPagina -1) * qtdPorPagina);
        int registroFinal  = registroIncial + qtdPorPagina;
        registroFinal      = (qtdLinhas>registroFinal)?registroFinal:qtdLinhas;       
        
        for(int i=registroIncial;i<registroFinal;i++){
          classCSS = ((i%2)==1)?"tdintranet2":"borderintranet"; %>
          <tr>
            <td class="<%=classCSS%>" width="80%">
              &nbsp;&nbsp;
              <input type="radio" name="codEscala" value="<%=escalas[i][0]%>" onclick="getEscalaHorario(this.value, true);" style="width:12px; height:15px;">
              <%=escalas[i][1]%>
            </td>
            <td class="<%=classCSS%>" width="20%">
              &nbsp;&nbsp;<%=(escalas[i][2]==null)?escalas[i][3]:escalas[i][2]%>&nbsp;horas
            </td>      
          </tr>
      <%}%>
          <%-- PAGINAÇÃO --%>
          <jsp:include page="../../../template/paginacao.jsp">
            <jsp:param  name="pNumeroDeRegistros" value="<%=escalas.length%>" />
            <jsp:param  name="pQtdPorPagina"      value="<%=qtdPorPagina  %>" />
            <jsp:param  name="pNumeroDaPagina"    value="<%=numeroDaPagina%>" />
            <jsp:param  name="pUrlLink"           value="getEscala.jsp"       />
          </jsp:include>  
    </table>
    
<%}else{%>      
    <br>
    <div align="justify" style="padding-left:12px; padding-right:12px; color:#ff0000;">
        Não foi localizada nenhuma escala que contenha o(s) horário(s) informado(s) acima, cuja carga horária semanal esteja de acordo com o cargo selecionado.<br><br>
        Verifique o campo "Titulo do cargo" e os horários digitados, se houver erro corrija e refaça a pesquisa, caso contrário solicite à GEP, através de e-mail e planilha contendo a nova escala, que efetue o cadastro, para só então cadastrar a RP.
    </div>
    <br>
<%}%>
