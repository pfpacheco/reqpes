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

  //-- Resgatando objeto da sess�o  
  Usuario usuario  = (Usuario) session.getAttribute("usuario");
  
  //-- Parametros de p�gina
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
      alert('Erro ao realizar a baixa na RP n� <%=requisicaoBaixa.getCodRequisicao()%>!\nContate a GES.');
      window.location = '<%=(indTipo.equals("B"))?"index.jsp":"./expirando/index.jsp"%>';
    }else{
        if(<%=retorno%> == -1){
          alert('Erro ao realizar a baixa na RP n� <%=requisicaoBaixa.getCodRequisicao()%>!\n - J� existe uma RP baixada com o n�mero de chapa informado!');
          window.location = '<%=(indTipo.equals("B"))?"index.jsp":"./expirando/index.jsp"%>';
        }    
      }
  }
</script>