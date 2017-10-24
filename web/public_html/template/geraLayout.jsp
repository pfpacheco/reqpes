<%@ page import="java.util.ArrayList"%>

<%!

   
  public StringBuffer getAbreBlocoDeDados(String root,String div,String nome){
    StringBuffer blocoDeDados = new StringBuffer();
    blocoDeDados.append(" <table border='0' align='center' width='610' cellspacing='0' cellpadding='0'>");
    blocoDeDados.append(" <tr>");
    blocoDeDados.append("  <td height='18' class='tdCabecalho' background='" + root +  "/imagens/tit_item.gif' >");
    blocoDeDados.append(" <a class='div' onclick=\"swapLayers('" + div + "'); return false\" href=\"javascript://\">");
    blocoDeDados.append(" &nbsp;<img  alt = \"Clique para minimizar\" id=i" + div + "  src=\"" + root +  "/imagens/bt_menos.gif\" align=\"button\" border=\"0\">");
    blocoDeDados.append("</a><STRONG>" + nome.toUpperCase() + "</STRONG>");
    blocoDeDados.append("</td> </tr></table>");
    return blocoDeDados;
  } 
  
  public StringBuffer getAbreBlocoDeDadosCheck(String root,String nameCheck,String acaoClick,String rotulo, String nome){
    StringBuffer blocoDeDados = new StringBuffer();
    blocoDeDados.append(" <table border='0' align='center' width='610' cellspacing='0' cellpadding='0'>");
    blocoDeDados.append(" <tr>");
    blocoDeDados.append("  <td height='18' class='tdCabecalho' background='" + root +  "/imagens/tit_item.gif' >");
    blocoDeDados.append("  <input type='CHECKBOX' name='"+ nameCheck + "' onClick=\""+ acaoClick + "\">");
    blocoDeDados.append("&nbsp;" + rotulo + "&nbsp;&nbsp;<STRONG>" + nome.toUpperCase() + "</STRONG>");
    blocoDeDados.append("</td> </tr></table>");
    return blocoDeDados;
  }   

  public StringBuffer getFechaBlocoDeDados(int colSpam,String root){
     StringBuffer texto = new StringBuffer();
       texto.append(" <tr> ");
       texto.append("     <td colspan=' " + colSpam + " '  height='5' class='tdIntranet2'  ></td> ");
       texto.append("   </tr>       ");
       texto.append("   <tr> ");
       texto.append("     <td  colspan=' " + colSpam + " '  height='3' class='tdCabecalho' background='" + root + "imagens/fio_azul_end.gif' ></td> ");
       texto.append("   </tr> ");
    return texto;
  }

  public StringBuffer getLinhaCheck(String  nomeCampo,int colspan){
    StringBuffer texto = new StringBuffer();
       texto.append(" <tr>\n ");
         texto.append("<td  height='25' colspan=" + colspan +  "   align='left' class='tdintranet2'>\n ");
         texto.append("&nbsp;"); 
        texto.append(" <input type='CHECKBOX'  name='" + nomeCampo + "' >" );
         texto.append("</td>\n ");  
       texto.append("</tr> \n ");
    return texto;
  }
%>

<!--- 
  /*
  <%--
   
      

            <form name="frmColaborador" action="colaborador/excluir.jsp" method="POST" >
          <input type="HIDDEN" name="codSistema" value="<%=codSistema%>">
          <td height="25" width="3%" align="right" valign="top" class="tdintranet2"> 
            <STRONG></STRONG> </td>
            <td class="tdintranet2" width="76%" height="25"> 
              <a href="#" onclick="addColaborador(<%=codSistema%>)">Adicionar 
              Colaborador(es) </a> 
              <% if ( sistemaColaborador.length > 0) {%>
              / <a href="#" onclick="remColaborador()">Remover 
              Colaborador(es) selecionado(s)</a><br> 
            <% }%>
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
              <% if ( sistemaColaborador.length > 0) {%>
              <tr > 
                <td height="25" width="10%" align="right" class="tdintranet2"> <div align="left"><STRONG>Unidade</STRONG> 
                  </div></td>
                <td width="49%" align="right" class="tdintranet2"> <div align="left"><STRONG>Colaborador</STRONG> 
                  </div></td>
                <td width="33%" align="right" class="tdintranet2"> <div align="left"><STRONG>Perfil</STRONG> 
                  </div></td>  
                <td class="tdintranet2" width="10%"> <div align="center"><strong>Opção</strong> 
                  </div></td>
              </tr>
              <% } %>
              <% int d;
                  for ( d=0;d<sistemaColaborador.length;d++) {
                  %>
              <tr> 
                <td  align="right" class="tdintranet2">
                <div align="left"> 
                    <%=sistemaColaborador[d].getUsuario().getUnidade().getSigla()%> 
                  </div></td>
                <td  align="right" class="tdintranet2"> <div align="left"> 
                    <%=sistemaColaborador[d].getUsuario().getNome()%> 
                  </div></td>
                <td  align="left" class="tdintranet2">                            
                    <div id="<%=sistemaColaborador[d].getUsuario().getChapa()%>">
                      <%=sistemaColaborador[d].getTipoColaborador().getNomeTipoColab()%>
                    </div>                    
                </td>
                <td class="tdintranet2" align="center">
                    <input type="checkbox" id="chapa<%=sistemaColaborador[d].getUsuario().getChapa()%>"  name="chapa<%=sistemaColaborador[d].getUsuario().getChapa()%>" value="<%=sistemaColaborador[d].getUsuario().getChapa()%>" onClick="buscarComboBox('<%=sistemaColaborador[d].getUsuario().getChapa()%>','<%=sistemaColaborador[d].getSistema().getCodSistema()%>','<%=sistemaColaborador[d].getTipoColaborador().getCodigoTipoColab()%>',this,'<%=sistemaColaborador[d].getTipoColaborador().getNomeTipoColab()%>' );" >
                </td>	  
              </tr>
              <% } %>
              <input type="HIDDEN" name="totalColaboradores" value="<%= d %>">
            </table></td>
          </tr></form>
        </table>
          </td>
      </tr>
       
          <tr>
            <td colspan="2"  height="3" class="tdCabecalho" background='../../imagens/fio_azul_end.gif' >             
            </td>
          </tr>
          <tr>
            <td colspan="2"  height="8" class="tdCabecalho"  >
            </td>
        </tr>    
        <tr>
    </table>
  <%-- FIM DIV SISTEMA_COLABORADORES --%>
  </div>  
  ---->
  