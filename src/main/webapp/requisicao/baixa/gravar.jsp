<%session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:useBean id="requisicaoBaixa" class="br.senac.sp.reqpes.model.RequisicaoBaixa" />
<jsp:setProperty name="requisicaoBaixa" property="*" />

<%
  //-- Objetos control
  RequisicaoBaixaControl requisicaoBaixaControl = new RequisicaoBaixaControl();

  //-- Resgatando objeto da sessão  
  Usuario usuario  = (Usuario) session.getAttribute("usuario");
  
  //-- Parametros de página
  String  indTipo  = request.getParameter("indTipo");

  //-- Gravando
  int retorno = requisicaoBaixaControl.gravaRequisicaoBaixa(requisicaoBaixa, usuario);
%>

<script language="JavaScript">
  if(<%=retorno%> > 0){
    alert('Baixa realizada com sucesso!');
    window.location = '<%=(indTipo.equals("B"))?"index.jsp":"./expirando/index.jsp"%>';
  }else{
    if(<%=retorno%> == 0){
      alert('Erro ao realizar a baixa na RP nº <%=requisicaoBaixa.getCodRequisicao()%>!\nContate a GES.');
      window.location = '<%=(indTipo.equals("B"))?"index.jsp":"./expirando/index.jsp"%>';
    }else{
        if(<%=retorno%> == -1){
          alert('Erro ao realizar a baixa na RP nº <%=requisicaoBaixa.getCodRequisicao()%>!\n - Já existe uma RP baixada com o número de chapa informado!');
          window.location = '<%=(indTipo.equals("B"))?"index.jsp":"./expirando/index.jsp"%>';
        }    
      }
  }
</script>