<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.util.ConverteDate" %>
<%@ page import="br.senac.sp.reqpes.Control.SubstituicaoGerenteControl" %>
<%@ page import="br.senac.sp.reqpes.model.SubstituicaoGerente" %>

<%  
  //-- Resgatando o usuario da sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");

  //-- Resgatando os campos
  SubstituicaoGerente substituicaoGerente = new SubstituicaoGerente();
  substituicaoGerente.setChapa(Integer.parseInt(request.getParameter("chapa")));
  substituicaoGerente.setCodUnidade(request.getParameter("codUnidade"));
  substituicaoGerente.setDatInicioVigencia(ConverteDate.stringToSqlDate(request.getParameter("datInicioVigencia")));
  substituicaoGerente.setDatFimVigencia(ConverteDate.stringToSqlDate(request.getParameter("datFimVigencia")));
 
  //-- Gravando
  int retorno = new SubstituicaoGerenteControl().gravaSubstituicaoGerente(substituicaoGerente, usuario);  
%>

<script language="JavaScript">
  if(<%=retorno%> > 0){
    alert('Cadastro realizado com sucesso!');   
  }else{
    alert('Erro ao alterar o gerente da unidade!');
  }
  
  window.location = "index.jsp?codUnidade=<%=substituicaoGerente.getCodUnidade()%>";
</script>