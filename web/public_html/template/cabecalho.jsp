<%@ page import="br.senac.sp.componente.model.*" %>
<%@ page import="br.senac.sp.componente.control.*" %>
<%@ page import="br.senac.sp.componente.util.Data" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%@ page import="br.senac.sp.reqpes.model.ResponsavelEstrutura" %>
<%@ page import="br.senac.sp.reqpes.Control.ResponsavelEstruturaControl" %>

<%@ page import="java.util.Locale"%>

<%       
   //-- Objetos de controle
   UsuarioControl              usuarioControl              = new UsuarioControl(); 
   SistemaPerfilControl        sistemaPerfilControlUsuario = new SistemaPerfilControl();  
   SistemaParametroControl     sistemaParametroControl     = new SistemaParametroControl(); 
   ResponsavelEstruturaControl responsavelEstruturaControl = new ResponsavelEstruturaControl();  

   //-- Objetos
   Locale.setDefault(new Locale("pt","BR"));
   Data data = new Data(); 
   SistemaPerfil        sistemaPerfil        = null;
   SistemaParametro     idPerfilHOM          = null;
   SistemaParametro     idPerfilNEC          = null;
   ResponsavelEstrutura responsavelEstrutura = null;
   int indTipoSessaoExpirada = 0;

   //-- Parametros de página
   String ticket = request.getParameter("ticket");
      
   // verificando se já existe o objeto de sessão
   Usuario usuario = (Usuario) session.getAttribute("usuario");
 
   if (ticket != null && usuario == null){      
     //se não existe busca pelo ticket   
     usuario = usuarioControl.getUsuarioLoginUnico(ticket,Config.ID_SISTEMA);
     
     if(usuario != null){
       /* buscando o perfil do usuario de acordo com o sistema selecionado */
       sistemaPerfil = sistemaPerfilControlUsuario.getSistemaPerfilByUsuarioSistema(usuario.getChapa(),Config.ID_SISTEMA);
       if(sistemaPerfil != null){
         usuario.setSistemaPerfil(sistemaPerfil);
       }else{
         usuario = null;
       }     

       if(usuario != null){       
         //------------ REGRA DE PERFIL EXCLUSIVA DO SISTEMA REQUISICAO -------------                 
           //-- Carregando objeto da Responsável Estrutura através do usuário passado
           responsavelEstrutura = responsavelEstruturaControl.getResponsavelEstrutura(usuario);
           
           //-- Setando o perfil do usuário de acordo com o WorkFlow da RESPONSAVEL_ESTRUTURA
           SistemaPerfil sistemaPerfilWorkFlow = new SistemaPerfil();           
           sistemaPerfilWorkFlow.setCodSistemaPerfil(responsavelEstrutura.getCodPerfilUsuario());
           usuario.setSistemaPerfil(sistemaPerfilWorkFlow);           
           
           //-- Carregando o parâmetro de perfil de HOMOLOGADOR UO (GERENTE)
           idPerfilHOM = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_UO");
           
           //-- Setando as unidades de acesso caso o usuário seja GERENTE
           if(Integer.parseInt(idPerfilHOM.getVlrSistemaParametro()) == responsavelEstrutura.getCodPerfilUsuario()){
             Unidade[] unidades = responsavelEstrutura.getUnidades();
             usuario.setUnidades(unidades);
           }
         //---------------------------------------------------------------------------         
         session.setAttribute("usuario",usuario);
       }else{
          indTipoSessaoExpirada = 1; //-- Usuário sem acesso
       }
     }else{
      indTipoSessaoExpirada = 2; //-- Não encontrada ticket válido de autenticação
     }
   }   
%>

<jsp:include page="templateIntranet.jsp" >
  <jsp:param  name="sub" value="<%=Config.NOME_SISTEMA%>" />
</jsp:include> 

<html>
  <head>
	<!-- INICIO :: META TAGS PERSONALIZADAS WEBTRENDS -->	
	<META NAME="WT.cg_n" CONTENT="Sistemas Pessoal" />
	<META NAME="WT.cg_s" CONTENT="Requisição de Pessoal"/>	
	<!-- FIM :: META TAGS PERSONALIZADAS WEBTRENDS -->
	
    <meta http-equiv=expires content="Mon, 06 Jan 1990 00:00:01 GMT">
    <meta http-equiv="pragma" content="no-cache">
    <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
    <link rel="STYLESHEET" type="text/css" href="<%=request.getContextPath()%>/css/stylesheet.css" />
    <title><%=Config.NOME_SISTEMA%></title>
  </head>
  
  <script language="javaScript">  
   function abreLink(url){
       window.open(url,'link','toolbar=no,width=800,height=560,scrollbars=yes');
   }  
   //--
   function expirar(){
      alert('Aviso do site <%=Config.NOME_SISTEMA%>:\nSua página esta inativa desde às <%=data.getHoras() + "h" + data.getMinutos() + "min" %>!\nSalve suas informações e atualize a página, caso contrário você irá perder sua conexão.'
             + '\nSua conexão será valida até as <%=(data.getHoras()+2) + "h" + data.getMinutos() + "min" %>!');
   }
  </script>
   
  <body onLoad="setTimeout('expirar();', 6900000);">	
	<!-- START OF SmartSource Data Collector TAG -->
	<!-- Copyright (c) 1996-2011 Webtrends Inc.  All rights reserved. -->
	<!-- Version: 9.4.0 -->
	<!-- Tag Builder Version: 3.2  -->
	<!-- Created: 10/14/2011 1:33:21 PM -->
	<script src="http://www.intranet.sp.senac.br/js/webtrends.js" type="text/javascript"></script>
	<!-- ----------------------------------------------------------------------------------- -->
	<!-- Warning: The two script blocks below must remain inline. Moving them to an external -->
	<!-- JavaScript include file can cause serious problems with cross-domain tracking.      -->
	<!-- ----------------------------------------------------------------------------------- -->
	<script type="text/javascript">
		//<![CDATA[
				var _tag=new WebTrends();
				_tag.dcsGetId();
		//]]>
	</script>
	<script type="text/javascript">
		//<![CDATA[
			_tag.dcsCustom=function(){
			// Add custom parameters here.
			//_tag.DCSext.param_name=param_value;
			}
			_tag.dcsCollect();
		//]]>
	</script>
	<noscript>
		<div><img alt="DCSIMG" id="DCSIMG" width="1" height="1" src="http://webtrendssdc.sp.senac.br/dcs53t21qc4g5pi8uky8w8pi8_6x3z/njs.gif?dcsuri=/nojavascript&amp;WT.js=No&amp;WT.tv=9.3.0&amp;WT.dcssip=www.sp.senac.br"/></div>
	</noscript>
	<!-- END OF SmartSource Data Collector TAG -->

     <%
       if(usuario != null){
          if(usuario.getSistemaPerfil() != null && usuario.getSistemaPerfil().getCodSistemaPerfil() == 0){ %>
            <script language="javaScript">
              window.location = "<%=request.getContextPath()%>/template/cadastrarPerfil.jsp";
            </script>
        <%}
     }else{
        if(usuario == null){%>
          <script language="javaScript">
            var urlDestino = '<%=request.getContextPath()%>';
            
            switch(<%=indTipoSessaoExpirada%>){
              case 1:  urlDestino += "/template/sessaoExpirada.jsp?semAcesso=yes";
                       break;
              case 2:  urlDestino += "/template/sessaoExpirada.jsp";
                       break;
              default: urlDestino += "/template/sessaoExpirada.jsp";
                       break;
            }
            
            window.location = urlDestino;
          </script>
      <%}        
     }%>