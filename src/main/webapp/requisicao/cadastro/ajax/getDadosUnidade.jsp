<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%//@ page errorPage="../../../error/error.jsp" %>

<%
  //-- Objetos de controle
  RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();
  ResponsavelEstruturaControl responsavelEstruturaControl = new ResponsavelEstruturaControl();
  
  //-- Parametros de página
  int    codUnidade = (request.getParameter("P_COD_UNIDADE")==null || request.getParameter("P_COD_UNIDADE").equals(""))?0:Integer.parseInt(request.getParameter("P_COD_UNIDADE"));
  String nomCampo   = (request.getParameter("P_NOM_CAMPO")==null)?"":request.getParameter("P_NOM_CAMPO");
  String nomDiv     = (request.getParameter("P_DIV")==null)?"":request.getParameter("P_DIV").trim();

  //-- Objetos de sessão
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  
  //-- Objetos
  StringBuffer sql = new StringBuffer();
  String[][] dadosResponsavel = null;
  String[] dadosRespEstrutura = null;  
  String codUOResponsavel = null;
  
  int chapaGerente = 0;  
  //-- Resgata o código da unidade no formato do RHEvolution
  String codUnidadeRHEV = requisicaoAprovacaoControl.getUnidadeRHEvolutionByCodUnidade(codUnidade);  
  
  //-- Resgatando a UO e a chapa do Gerente responsavél pela Unidade informada na Responsável Estrutura
  if(codUnidadeRHEV != null){
    dadosRespEstrutura = responsavelEstruturaControl.buscarUnidadeDestino(codUnidadeRHEV);
    if(dadosRespEstrutura != null){
      codUOResponsavel = dadosRespEstrutura[0];
      chapaGerente     = Integer.parseInt(dadosRespEstrutura[1]);
    }
  }
  
  //-- Resgada os dados para serem setados nos campos apresentados na tela
  if(codUOResponsavel != null && chapaGerente > 0){
    dadosResponsavel = responsavelEstruturaControl.getDadosResponsavel(codUnidadeRHEV, chapaGerente);  
  }
%>

<%if(dadosResponsavel == null && nomDiv.equals("divDadosAdicionaisUnidade")){%>
    <% 
      //-- Enviando e-mail de crítica
      RequisicaoMensagemControl.enviaMensagemCritica("getDadosUnidade.jsp", "Nenhuma informação encontrada referente a unidade selecionada! <br>Unidade: " + codUnidade, usuario);
    %>
    <p align="center">
      <font color="Red">
        <br>Nenhuma informação encontrada referente a unidade selecionada!
        <br>Contate a Gerência de Sistemas.
      </font>
    </p>
    <input type="HIDDEN" name="nomUnidade" id="idnomUnidade" value="0"/>
<%}%> 

<%if(dadosResponsavel != null && dadosResponsavel.length > 0 && nomCampo.equals("nomUnidade")){%>
    <input class="input" size="87" name="nomUnidade" id="idnomUnidade" value="<%=dadosResponsavel[0][0]%>" readonly/>
    
<%} else if(dadosResponsavel != null && dadosResponsavel.length > 0 && nomCampo.equals("nomSuperior")){%>
          <input class="input" size="87" name="nomSuperior" id="idnomSuperior" value="<%=dadosResponsavel[0][1]%>" readonly/>          

    <%} else if(dadosResponsavel != null && dadosResponsavel.length > 0 && nomCampo.equals("telUnidade")){%>
               <input class="input" size="87" name="telUnidade" id="idtelUnidade" value="<%=dadosResponsavel[0][2]%>" readonly/>

              <%}%>   

<%if(dadosResponsavel != null && dadosResponsavel.length > 0 && nomDiv.equals("divDadosAdicionaisUnidade")){%>
    <input type="HIDDEN" name="codUnidade"   id="idcodUnidade"   value="<%=codUnidadeRHEV%>"/>
    <input type="HIDDEN" name="codUODestino" id="idcodUODestino" value="<%=codUOResponsavel%>"/>
    <input type="HIDDEN" name="chapaGerente" id="idchapaGerente"   value="<%=chapaGerente%>"/>
<%}%> 