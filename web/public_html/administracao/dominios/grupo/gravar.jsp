<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %> 
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:useBean id="grupoNec" class="br.senac.sp.reqpes.model.GrupoNec" />
<jsp:setProperty name="grupoNec" property="*" />

<jsp:useBean id="grupoNecUnidade" class="br.senac.sp.reqpes.model.GrupoNecUnidade" />
<jsp:setProperty name="grupoNecUnidade" property="*" />

<%   
  //-- Objetos control
  GrupoNecControl grupoNecControl = new GrupoNecControl();
  GrupoNecUnidadeControl grupoNecUnidadeControl = new GrupoNecUnidadeControl();
  
  //-- Pegando o usuário da sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Parametros de página
  String[] unidade = request.getParameterValues("codUnidade");
    
  //-- Grava os dados da Instrucao
  int retorno = grupoNecControl.gravaGrupoNec(grupoNec, usuario);
  
  if(retorno > 0){
    //-- Grava as atribuições
    grupoNecUnidade.setCodGrupo(retorno);
    for(int i=0; i<unidade.length; i++){
      //-- setando valores
      grupoNecUnidade.setCodGrupo(retorno);
      grupoNecUnidade.setCodUnidade(unidade[i]);
      grupoNecUnidadeControl.gravaGrupoNecUnidade(grupoNecUnidade);
    }
  }
%>

<script language="JavaScript">
  window.location = "index.jsp";  
</script>