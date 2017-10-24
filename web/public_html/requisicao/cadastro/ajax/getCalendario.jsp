<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>
<%
    //-- Parametros de página
    String codCalendario = (request.getParameter("P_COD_CALENDARIO")==null)?"0":request.getParameter("P_COD_CALENDARIO");
    String codUnidade = (request.getParameter("P_UNIDADE")==null)?"0":request.getParameter("P_UNIDADE");
    String codEscala  = (request.getParameter("P_ESCALA" )==null)?"0":request.getParameter("P_ESCALA" );
    String indSegunda = (request.getParameter("P_IND_SEG")==null)?"0":request.getParameter("P_IND_SEG");
    String indTerca   = (request.getParameter("P_IND_TER")==null)?"0":request.getParameter("P_IND_TER");
    String indQuarta  = (request.getParameter("P_IND_QUA")==null)?"0":request.getParameter("P_IND_QUA");
    String indQuinta  = (request.getParameter("P_IND_QUI")==null)?"0":request.getParameter("P_IND_QUI");
    String indSexta   = (request.getParameter("P_IND_SEX")==null)?"0":request.getParameter("P_IND_SEX");
    String indSabado  = (request.getParameter("P_IND_SAB")==null)?"0":request.getParameter("P_IND_SAB");
    String indDomingo = (request.getParameter("P_IND_DOM")==null)?"0":request.getParameter("P_IND_DOM");

    //-- Objetos
    String[][] idCalendario = null;
    
    //-- Executando a pesquisa
    if(codEscala.equals("0") || codEscala.equals("")){
      //-- Carregando o calendario a partir dos horários informados
      idCalendario = new RequisicaoJornadaControl().getIdCalendario(codUnidade, indSegunda, indTerca, indQuarta, indQuinta, indSexta, indSabado, indDomingo);
    }else{
      //-- Carregando o calendario a partir da escala informada
      idCalendario = new RequisicaoJornadaControl().getIdCalendario(codUnidade, codEscala);
    }

    //-- Carregando lista de Id's
    if(idCalendario != null && idCalendario.length > 0){%>
      <select name="codCalendario" id="codCalendario" style="width:402px;">
        <option value="0">SELECIONE</option>
        <%for(int i=0; i<idCalendario.length; i++){%>
            <option value="<%=idCalendario[i][0]%>" <%=(idCalendario[i][0].equals(codCalendario) || idCalendario.length == 1)?" SELECTED ":""%>><%=idCalendario[i][0]+" - "+idCalendario[i][1]%></option>
        <%}%>
      </select>
  <%}else{
      out.print("<font color=\"Red\">Nenhum calendário associado com o horário informado!</font>");
      out.print("<input type=\"hidden\" name=\"codCalendario\" id=\"codCalendario\" value=\"-1\">");    
      RequisicaoMensagemControl.enviaMensagemCritica("getCalendario.jsp", "Nenhum calendário associado com o horário informado! <br><b>Escala:</b> " + codEscala + "<br><b>Unidade:</b> " + codUnidade, (Usuario) session.getAttribute("usuario"));
    }
%>