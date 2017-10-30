  <%-- ######################## INICIO DA PAGINACAO ############################# --%>
        <% 
            
            int pNumeroDeRegistros = Integer.parseInt( request.getParameter("pNumeroDeRegistros"));
            int pQtdPorPagina      = Integer.parseInt( request.getParameter("pQtdPorPagina"));
            int pNumeroDaPagina    = Integer.parseInt( request.getParameter("pNumeroDaPagina"));
            String pesquisa        =  request.getParameter("pesquisa");
            String pUrlLink        = request.getParameter("pUrlLink");
            
            if(pQtdPorPagina < pNumeroDeRegistros){ %>
          
            <table border="0" cellpadding="2" cellspacing="2" width="100%">
              <tr>
                <td width="8%" align="center" class="tdintranet2">
                  <% 
                       int qtdDePaginas = pNumeroDeRegistros/pQtdPorPagina ;
                       int resto        = pNumeroDeRegistros % pQtdPorPagina ;
                       if (resto>0){
                         qtdDePaginas++;
                       }
                       if ((pNumeroDaPagina-1 >0) && (pNumeroDaPagina-1<= qtdDePaginas)){ %>
                          <a href="javaScript:irParaPagina(<%=pQtdPorPagina%>,<%=pNumeroDaPagina-1%>)" >&lt;&lt;<br/>Anterior</a>
                       <%}else{%>   
                          &nbsp; 
                       <%}%> 
                </td>
                <td align="center" class="tdintranet2" width="83%">
                    <% 
                       for(int link = 1;link<=qtdDePaginas;link++){
                    %>      
                         <% if (pNumeroDaPagina==link){ %>
                           <b><a href="javaScript:irParaPagina(<%=pQtdPorPagina%>,<%=link%>)" ><%= link %></a></b>                      
                         <%}else{%>
                           <a href="javaScript:irParaPagina(<%=pQtdPorPagina%>,<%=link%>)" ><%= link %></a>                     
                         <%}%>
                    <%}%>
                    <br/>
                         Total de registros:&nbsp;<%=pNumeroDeRegistros%>
                    <br/>P&aacute;gina <%= pNumeroDaPagina %> de <%= qtdDePaginas %>
                </td>
                <td width="8%" align="center" class="tdintranet2">
                  <% if (pNumeroDaPagina < qtdDePaginas){ %>
                    <a href="javaScript:irParaPagina(<%=pQtdPorPagina%>,<%=pNumeroDaPagina+1%>)" >&gt;&gt;<br/>Pr&oacute;xima</a>
                  <%}else{%>   
                     &nbsp;
                  <%}%>
                </td>
              </tr>
            </table>
        <%}%>
        <%-- ##########################  FIM DA PAGINACAO ######################################--%>