<%@page import="br.senac.sp.reqpes.model.RequisicaoPerfil"%>
<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.reqpes.model.Requisicao" %>
<%@ page import="br.senac.sp.reqpes.model.Horarios" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.util.ConverteDate" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>

<jsp:useBean id="requisicaoPerfil" class="br.senac.sp.reqpes.model.RequisicaoPerfil" />
<jsp:setProperty name="requisicaoPerfil" property="*" />

<%      
    int codRequisicao = (request.getParameter("codRequisicao")==null)?0:Integer.parseInt(request.getParameter("codRequisicao"));
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    RequisicaoPerfilControl requisicaoPerfilControl = new RequisicaoPerfilControl();

    int retorno = 0;
    String erro = "";
       
    try{
       retorno = requisicaoPerfilControl.alteraRequisicaoPerfil(requisicaoPerfil, usuario.getChapa());
       out.print(retorno);
    } catch (Exception e) {
       erro = e.getMessage();
       out.print(erro);
    }
   
%>
