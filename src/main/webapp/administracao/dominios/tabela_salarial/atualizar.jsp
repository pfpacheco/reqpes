<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:useBean id="tabelaSalarial" class="br.senac.sp.reqpes.model.TabelaSalarial" />
<jsp:setProperty name="tabelaSalarial" property="*" />

<jsp:useBean id="tabelaSalarialAtribuicao" class="br.senac.sp.reqpes.model.TabelaSalarialAtribuicao" />
<jsp:setProperty name="tabelaSalarialAtribuicao" property="*" />

<%
  //-- Objetos Control
  TabelaSalarialControl tabelaSalarialControl = new TabelaSalarialControl();
  TabelaSalarialAtribuicaoControl tabelaSalarialAtribuicaoControl = new TabelaSalarialAtribuicaoControl();
  
  //-- Resgatando o usuario da sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
 
  //-- Resgatando parametros selecionados da página
  String[] tabela = request.getParameterValues("codTabelaRHEV");
  
  //-- Gravando
  int retorno = tabelaSalarialControl.alteraTabelaSalarial(tabelaSalarial, usuario);  
  
  //-- Grava as atribuições
  if(retorno > 0){
    //-- Limpando lista
    tabelaSalarialAtribuicao.setCodTabelaSalarial(retorno);
    tabelaSalarialAtribuicaoControl.deletaTabelaSalarialAtribuicao(tabelaSalarialAtribuicao);

    for(int i=0; tabela != null && i<tabela.length; i++){
      //-- setando valores
      tabelaSalarialAtribuicao.setCodTabelaSalarial(retorno);
      tabelaSalarialAtribuicao.setCodTabelaRHEV(Integer.parseInt(tabela[i]));
      retorno = tabelaSalarialAtribuicaoControl.gravaTabelaSalarialAtribuicao(tabelaSalarialAtribuicao);
    }  
  }  
%>

<script language="JavaScript">
  window.location = "index.jsp";  
</script>