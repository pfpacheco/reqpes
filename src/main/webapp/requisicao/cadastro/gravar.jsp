<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page import="br.senac.sp.componente.util.*" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.Requisicao" %>
<%@ page import="br.senac.sp.reqpes.model.Horarios" %>
<%@ page import="br.senac.sp.reqpes.Interface.Config" %>

<%--
<jsp:useBean id="requisicao" class="br.senac.sp.reqpes.model.Requisicao" />
<jsp:setProperty name="requisicao" property="*" />
--%>

<jsp:useBean id="requisicaoJornada" class="br.senac.sp.reqpes.model.RequisicaoJornada" />
<jsp:setProperty name="requisicaoJornada" property="*" />

<jsp:useBean id="requisicaoPerfil" class="br.senac.sp.reqpes.model.RequisicaoPerfil" />
<jsp:setProperty name="requisicaoPerfil" property="*" />

<%      
    //-- Objetos de controle
    RequisicaoControl          requisicaoControl          = new RequisicaoControl();
    SistemaParametroControl    sistemaParametroControl    = new SistemaParametroControl();
    
    //-- Parametros do sistema
    SistemaParametro codUOAPR    = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"UNIDADE_APROVADORA");
    SistemaParametro idPerfilHOM = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_UO");
    SistemaParametro idPerfilGEP = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_GEP");
    SistemaParametro idPerfilNEC = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_NEC");
    
    //-- Parametros de página
    String indTipoHorarioSel = (request.getParameter("indTipoHorarioSel")==null)?"E":request.getParameter("indTipoHorarioSel");

    //-- pegando o usuário da sessão
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    int perfilUsuario = usuario.getSistemaPerfil().getCodSistemaPerfil();
    int codRequisicao = 0;
  
  //---------------------------------------------------------------------------------------------------------------
    //-- Setando o Bean "Requisicao"
    Requisicao requisicao = new Requisicao();   
    requisicao.setCodRequisicao(Integer.parseInt(request.getParameter("codRequisicao")));
    requisicao.setCodUnidade(request.getParameter("codUnidade"));
    requisicao.setCodCargo(Integer.parseInt(request.getParameter("codCargo")));
    requisicao.setCotaCargo(Integer.parseInt(request.getParameter("cotaCargo")));
    requisicao.setIndTipoContratacao(request.getParameter("indTipoContratacao"));
    requisicao.setNomSuperior(request.getParameter("nomSuperior"));
    requisicao.setTelUnidade(request.getParameter("telUnidade"));
    requisicao.setJornadaTrabalho(Double.parseDouble(request.getParameter("jornadaTrabalho")));
    requisicao.setIndLocalTrabalho(request.getParameter("indLocalTrabalho"));
    requisicao.setCodRPPara(request.getParameter("codRPPara"));
    requisicao.setComentarios(request.getParameter("comentarios"));
    requisicao.setIndSupervisao(request.getParameter("indSupervisao"));
    requisicao.setNumFuncionariosSupervisao(request.getParameter("numFuncionariosSupervisao") == null ? 0 : Integer.parseInt(request.getParameter("numFuncionariosSupervisao")));
    requisicao.setDscTarefasDesempenhadas(request.getParameter("dscTarefasDesempenhadas"));
    requisicao.setIndViagem(request.getParameter("indViagem"));
    requisicao.setSalario(request.getParameter("salario"));
    requisicao.setOutroLocal(request.getParameter("outroLocal"));
    requisicao.setCodArea(request.getParameter("codArea") == null ? 0 : Integer.parseInt(request.getParameter("codArea")));
    requisicao.setCodMotivoSolicitacao(request.getParameter("codMotivoSolicitacao"));
    requisicao.setDscMotivoSolicitacao(request.getParameter("dscMotivoSolicitacao"));
    requisicao.setCodClassificacaoFuncional(request.getParameter("codClassificacaoFuncional") == null ? 0 : Integer.parseInt(request.getParameter("codClassificacaoFuncional")));
    requisicao.setIdSubstitutoHist(request.getParameter("idSubstitutoHist") == null || request.getParameter("idSubstitutoHist").equals("")? 0 : Integer.parseInt(request.getParameter("idSubstitutoHist")));
    requisicao.setIndStatus(Integer.parseInt(request.getParameter("indStatus")));
    requisicao.setSegmento1(request.getParameter("segmento1"));
    requisicao.setSegmento2(request.getParameter("segmento2"));
    requisicao.setSegmento3(request.getParameter("segmento3"));
    requisicao.setSegmento4(request.getParameter("segmento4"));
    requisicao.setSegmento5(request.getParameter("segmento5"));
    requisicao.setSegmento6(request.getParameter("segmento6"));
    requisicao.setSegmento7(request.getParameter("segmento7"));
    requisicao.setCodUODestino(request.getParameter("codUODestino"));  
    requisicao.setNivelWorkflow(Integer.parseInt(request.getParameter("nivelWorkflow")));
    requisicao.setCodRecrutamento(Integer.parseInt(request.getParameter("codRecrutamento")));
    requisicao.setDscRecrutamento(request.getParameter("dscRecrutamento"));   
    requisicao.setIndCaraterExcecao(request.getParameter("indCaraterExcecao"));    
    requisicao.setVersaoSistema(request.getParameter("versaoSistema"));
    requisicao.setIdCodeCombination(Long.parseLong(request.getParameter("idCodeCombination")));
    
  //---------------------------------------------------------------------------------------------------------------        
    //-- Formata as datas de acordo com o tipo de RP
    if(requisicao.getCodRecrutamento() == 1){
       requisicao.setIndTipoRequisicao("T");
       requisicao.setDatTransferencia(ConverteDate.stringToSqlDate(request.getParameter("datTransferencia")));
    }else{    
       requisicao.setIndTipoRequisicao("A");
       //**requisicao.setDatInicioContratacao(ConverteDate.stringToSqlDate(request.getParameter("datInicioContratacao")));
       requisicao.setDatInicioContratacao(ConverteDate.stringToSqlDate("01/" + request.getParameter("datInicioContratacao")));
       //-- verifica se o tipo de contratação não é indeterminado (não há datas de contratação para este tipo)
       if(!requisicao.getIndTipoContratacao().equals("1")){        
          //**requisicao.setDatFimContratacao(ConverteDate.stringToSqlDate(request.getParameter("datFimContratacao")));
          requisicao.setDatFimContratacao(ConverteDate.stringToSqlDate("01/" + request.getParameter("datFimContratacao")));
       }       
    }

  
  //---------------------------------------------------------------------------------------------------------------    
    //-- caso seja o homologador de unidade (GERENTE) que esteja criando a RP (sobe 1 nível no WorkFlow)
    if(perfilUsuario == Integer.parseInt(idPerfilHOM.getVlrSistemaParametro())){
      requisicao.setIndStatus(2); 
    //  requisicao.setNivelWorkflow(3); // HOMOLOGAÇÃO AP&B
      requisicao.setNivelWorkflow(2); // HOMOLOGAÇÃO NEC

    }else
        //-- caso seja o homologador da unidade aprovadora (AP&B) que esteja criando a RP (sobe 2 níveis no WorkFlow)
        if(perfilUsuario == Integer.parseInt(idPerfilGEP.getVlrSistemaParametro())){
          requisicao.setIndStatus(2); 
      //    requisicao.setNivelWorkflow(3); // HOMOLOGAÇÃO NEC
          requisicao.setNivelWorkflow(4); // HOMOLOGAÇÃO AP&B

        }else        
            //-- caso seja o homologador da unidade aprovadora (NEC) que esteja criando a RP (volta 1 nível no WorkFlow)
            if(perfilUsuario == Integer.parseInt(idPerfilNEC.getVlrSistemaParametro())){
              requisicao.setIndStatus(2); 
            //  requisicao.setNivelWorkflow(2); //  HOMOLOGAÇÃO NEC
              requisicao.setNivelWorkflow(3); //HOMOLOGAÇÃO AP&B
            }    
    
    //-- caso a unidade destino seja a unidade aprovadora, altera o status da RP (sobe 1 nível no WorkFlow) 
    //-- isto ocorre quando uma RP é criada para uma unidade sem gerente
    if(requisicao.getCodUODestino().equals(codUOAPR.getVlrSistemaParametro()) && perfilUsuario != Integer.parseInt(idPerfilGEP.getVlrSistemaParametro())){
      requisicao.setIndStatus(2);
//      requisicao.setNivelWorkflow(2); // HOMOLOGAÇÃO NEC
      requisicao.setNivelWorkflow(3); // HOMOLOGAÇÃO AP&B

    }

  //---------------------------------------------------------------------------------------------------------------           
    //-- gravando os dados da requisição    
    codRequisicao = requisicaoControl.gravaRequisicao(requisicao, usuario);
        
    //-- gravando os dados adicionais da requisição
    if(codRequisicao > 0){
      // gravando o PERFIL e a JORNADA DE TRABALHO
      requisicaoPerfil.setCodRequisicao(codRequisicao);     
      requisicaoJornada.setCodRequisicao(codRequisicao);
      
      // setando os valores da grid de horários dos professores
      if(requisicaoJornada.getIndTipoHorario().equals("P")){
	  	  Horarios[] h = new Horarios[7];
	  	  String dias[] = {"Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado", "Domingo"};
	  	  
	  	  for(int i=0; i<h.length; i++){
			  h[i] = new Horarios(request.getParameter("hrDig"+ dias[i] +"Entrada1")
					  			 ,request.getParameter("hrDig"+ dias[i] +"Saida1")
					  			 ,request.getParameter("hrDig"+ dias[i] +"Entrada2")
					  			 ,request.getParameter("hrDig"+ dias[i] +"Saida2")
					  			 ,request.getParameter("hrDig"+ dias[i] +"Entrada3")
					  			 ,request.getParameter("hrDig"+ dias[i] +"Saida3")
					  			 ,request.getParameter("hrDig"+ dias[i] +"Entrada4")
					  			 ,request.getParameter("hrDig"+ dias[i] +"Saida4")
					  		     );
	  	  }	  	  
	  	  requisicaoJornada.setHorarios(h);
      }
      
      // setando as funções adicionais para os professores
	  if(request.getParameterValues("codFuncao").length > 1){
		  StringBuffer funcaoExtra = new StringBuffer();
		  for(int i=1; i<request.getParameterValues("codFuncao").length; i++){
			  funcaoExtra.append("," + request.getParameterValues("codFuncao")[i]);
		  }
		  requisicaoPerfil.setListFuncao(funcaoExtra.toString().substring(1, funcaoExtra.length()));
	  }else{
		  requisicaoPerfil.setListFuncao(null);			  
	  }
      
      new RequisicaoJornadaControl().gravaRequisicaoJornada(requisicaoJornada);
      new RequisicaoPerfilControl().gravaRequisicaoPerfil(requisicaoPerfil);
      
      //------------------------ ENVIO DE E-MAILS --------------------------------      
      SistemaParametro indEnviarEmails = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"IND_ENVIAR_EMAILS");
      if(indEnviarEmails.getVlrSistemaParametro().equals("S")){
        //-- resgatando os dados da requisição que acaba de ser criada
        requisicao = requisicaoControl.getRequisicao(codRequisicao);          
        
        //-- próximo nível do workflow (GERENTE RESPONSÁVEL PELA UNIDADE)
        int chapaGerente = (request.getParameter("chapaGerente")==null)?0:Integer.parseInt(request.getParameter("chapaGerente"));        
        RequisicaoMensagemControl.enviaMensagemCriacao(usuario, requisicao, new RequisicaoAprovacaoControl().getEmailByChapa(chapaGerente));
        
        //-- usuário que solicitou
        RequisicaoMensagemControl.enviaMensagemCriacao(usuario, requisicao, "Requisição criada e encaminhada para homologação com sucesso!", usuario.getEmail(), "Confirmação de solicitação da RP: "+requisicao.getCodRequisicao());
      }
    }
%>
    
<script language="javascript">
  if(<%=codRequisicao%> > 0){
    alert('Cadastro realizado com sucesso! Número da RP gerada: <%=codRequisicao%>');
  }    
  window.location = "<%=request.getContextPath()%>/requisicao/aprovar/index.jsp";  
</script>