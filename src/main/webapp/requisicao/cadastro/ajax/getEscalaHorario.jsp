<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>
<%@ page errorPage="../../../error/error.jsp" %>

<%
  //-- Objetos de Controle  
  RequisicaoJornadaControl requisicaoJornadaControl = new RequisicaoJornadaControl();
   
  //-- Parâmetros de página
  String codEscala = request.getParameter("P_ESCALA");
  boolean isExibeDiv = request.getParameter("P_EXIBE_DIV").equals("true");

  //-- Carregando os horários da escala informada
  String classCSS      = null;  
  String[][] horarios = requisicaoJornadaControl.getEscalaHorario(codEscala);

  if(horarios != null && horarios.length > 0){
    out.print("<table border=\"0\" width=\"595\" cellpadding=\"1\" cellspacing=\"1\" bgcolor=\"#3C6F8F\">");
    out.print("  <tr>");
    out.print("    <td class=\"tdintranet\" width=\"20%\" ><STRONG>&nbsp;&nbsp;Dia da semana</STRONG></td>");
    out.print("    <td class=\"tdintranet\" width=\"22%\"><STRONG>&nbsp;&nbsp;Classificação do dia</STRONG></td>");
    out.print("    <td class=\"tdintranet\" align=\"center\" width=\"12%\"><STRONG>Entrada</STRONG></td>");
    out.print("    <td class=\"tdintranet\" align=\"center\" width=\"12%\"><STRONG>Intervalo</STRONG></td>");
    out.print("    <td class=\"tdintranet\" align=\"center\" width=\"12%\"><STRONG>Retorno</STRONG></td>");
    out.print("    <td class=\"tdintranet\" align=\"center\" width=\"12%\"><STRONG>Saída</STRONG></td>");
    out.print("    <td class=\"tdintranet\" align=\"center\" width=\"10%\"><STRONG>Total de<br>horas</STRONG></td>");
    out.print("  </tr>");
      for(int i=0; i<horarios.length; i++){
        classCSS = ((i%2)==1) ? "tdintranet2" : "borderintranet";
        
        //-- Montando apresentação dos valores
        horarios[i][2] = horarios[i][2] == null ? "-" : (horarios[i][2].equals("") || (horarios[i][2].equals("00:00") && horarios[i][3].equals("00:00")) )?"-":horarios[i][2];
        horarios[i][3] = horarios[i][3] == null ? "-" : (horarios[i][3].equals("") || horarios[i][2].equals("-"))?"-":horarios[i][3];
        horarios[i][4] = horarios[i][4] == null ? "-" : (horarios[i][4].equals("") || (horarios[i][4].equals("00:00") && horarios[i][5].equals("00:00")) )?"-":horarios[i][4];
        horarios[i][5] = horarios[i][5] == null ? "-" : (horarios[i][5].equals("") || horarios[i][4].equals("-"))?"-":horarios[i][5];
        
        out.print("<tr>");
        out.print("  <td height=\"23\" class=\""+ classCSS +"\">&nbsp;"+ horarios[i][0] +"</td>");
        out.print("  <td height=\"23\" class=\""+ classCSS +"\">&nbsp;"+ horarios[i][1] +"</td>");
        out.print("  <td height=\"23\" class=\""+ classCSS +"\" align=\"center\">"+ horarios[i][2] +"</td>");
        out.print("  <td height=\"23\" class=\""+ classCSS +"\" align=\"center\">"+ horarios[i][3] +"</td>");
        out.print("  <td height=\"23\" class=\""+ classCSS +"\" align=\"center\">"+ horarios[i][4] +"</td>");
        out.print("  <td height=\"23\" class=\""+ classCSS +"\" align=\"center\">"+ horarios[i][5] +"</td>");
        out.print("  <td height=\"23\" class=\""+ classCSS +"\" align=\"center\">"+ horarios[i][6] +"</td>");
        out.print("</tr>");
      }    
    out.print("</table>");
    
    if(isExibeDiv){
      out.print("<table border=\"0\" width=\"595\">");
      out.print("  <tr>");
      out.print("    <td class=\"tdintranet2\" align=\"right\">");
      out.print("      <div id=\"divCarregaEscalaHorario\" style=\"padding-top:5px; padding-bottom:5px;\">");
      out.print("        <input type=\"button\" name=\"btnCarregaEscalaHorario\" class=\"botaoIntranet\" value=\"Selecionar este horário\" onclick=\"carregarEscalaHorario('"+ codEscala +"');\">");
      out.print("      </div>");
      out.print("    </td>");
      out.print("  </tr>");
      out.print("</table>");
    }

 }else{
   out.print("<table border=\"0\" width=\"100%\"");
   out.print("  <tr>");
   out.print("    <td class=\"tdintranet\" align=\"center\">");
   out.print("      <STRONG>Nenhuma horário associado com a escala informada!</STRONG>");
   out.print("    </td>");
   out.print("  </tr>");
   out.print("</table>");
 }    
%>