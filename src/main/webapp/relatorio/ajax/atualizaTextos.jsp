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


<%      
    int codRequisicao = (request.getParameter("codRequisicao")==null)?0:Integer.parseInt(request.getParameter("codRequisicao"));
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    RequisicaoPerfilControl requisicaoPerfilControl = new RequisicaoPerfilControl();
    
    RequisicaoPerfil requisicaoPerfil = new RequisicaoPerfil();
    requisicaoPerfil = requisicaoPerfilControl.getRequisicaoPerfil(codRequisicao);
    
    requisicaoPerfil.setDscAtividadesCargo(request.getParameter("dscAtividadesCargo"));
    requisicaoPerfil.setDescricaoFormacao(request.getParameter("descricaoFormacao"));
    requisicaoPerfil.setDscExperiencia(request.getParameter("dscExperiencia"));
    requisicaoPerfil.setDscConhecimentos(request.getParameter("dscConhecimentos"));
    requisicaoPerfil.setOutrasCarateristica(request.getParameter("outrasCarateristica"));
    requisicaoPerfil.setComentarios(request.getParameter("comentarios"));
     
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
