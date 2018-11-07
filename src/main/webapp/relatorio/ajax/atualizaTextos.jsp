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
    
    requisicaoPerfil.setDscAtividadesCargo(new String(request.getParameter("dscAtividadesCargo").getBytes(),"ISO-8859-1"));
    requisicaoPerfil.setDescricaoFormacao(new String(request.getParameter("descricaoFormacao").getBytes(),"ISO-8859-1"));
    requisicaoPerfil.setDscExperiencia(new String(request.getParameter("dscExperiencia").getBytes(),"ISO-8859-1"));
    requisicaoPerfil.setDscConhecimentos(new String(request.getParameter("dscConhecimentos").getBytes(),"ISO-8859-1"));
    requisicaoPerfil.setOutrasCarateristica(new String(request.getParameter("outrasCarateristica").getBytes(),"ISO-8859-1"));
    requisicaoPerfil.setComentarios(new String(request.getParameter("comentarios").getBytes(),"ISO-8859-1"));
     
    int retorno = 0;
    String erro = "";
       
    try{
       retorno = requisicaoPerfilControl.alteraRequisicaoPerfil(requisicaoPerfil, 1, usuario.getChapa());
       out.print(retorno);
    } catch (Exception e) {
       erro = e.getMessage();
       out.print(erro);
    }
   
%>
