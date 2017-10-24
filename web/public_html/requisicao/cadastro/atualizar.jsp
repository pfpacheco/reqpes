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

<%--
<jsp:useBean id="requisicao" class="br.senac.sp.reqpes.model.Requisicao" />
<jsp:setProperty name="requisicao" property="*" />
--%>

<jsp:useBean id="requisicaoJornada" class="br.senac.sp.reqpes.model.RequisicaoJornada" />
<jsp:setProperty name="requisicaoJornada" property="*" />

<jsp:useBean id="requisicaoPerfil" class="br.senac.sp.reqpes.model.RequisicaoPerfil" />
<jsp:setProperty name="requisicaoPerfil" property="*" />

<jsp:useBean id="requisicaoRevisao" class="br.senac.sp.reqpes.model.RequisicaoRevisao" />
<jsp:setProperty name="requisicaoRevisao" property="*" />

<%      
    //-- Objetos de controle
    RequisicaoControl          requisicaoControl          = new RequisicaoControl();
    RequisicaoAprovacaoControl requisicaoAprovacaoControl = new RequisicaoAprovacaoControl();
    SistemaParametroControl    sistemaParametroControl    = new SistemaParametroControl();  
    
    //-- Par�metros de p�gina
    int codRequisicao = (request.getParameter("codRequisicao")==null)?0:Integer.parseInt(request.getParameter("codRequisicao"));
    int chapaGerente  = (request.getParameter("chapaGerente")==null)?0:Integer.parseInt(request.getParameter("chapaGerente"));
    String indTipoHorarioSel = (request.getParameter("indTipoHorarioSel")==null)?"E":request.getParameter("indTipoHorarioSel");
    
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

    //-- Objetos da p�gina
    String[] listaEmails = null;
    boolean isPerfilHOM = false;
    boolean isPerfilGEP = false;
    boolean isPerfilNEC = false;
    int retorno = 0;
    
    //-- Objetos de sess�o
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    
    //-- Carregando configura��es
    int idPerfilHOM = Integer.parseInt((sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_UO").getVlrSistemaParametro()));
    int idPerfilGEP = Integer.parseInt((sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_GEP").getVlrSistemaParametro()));
    int idPerfilNEC = Integer.parseInt((sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"ID_PERFIL_HOM_NEC").getVlrSistemaParametro()));
    String indEnviarEmails = sistemaParametroControl.getSistemaParametroPorSistemaNome(Config.ID_SISTEMA,"IND_ENVIAR_EMAILS").getVlrSistemaParametro();    
    
    if(usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilHOM){
      // Resgata o indicador de envio de e-mails caso o usu�rio seja HOMOLOGADOR UO (GERENTE)
      isPerfilHOM = true;
    }else
        if(usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilGEP){
          // Resgata o indicador de envio de e-mails caso o usu�rio seja HOMOLOGADOR AP&B
          isPerfilGEP = true;
        }else    
            if(usuario.getSistemaPerfil().getCodSistemaPerfil() == idPerfilNEC){
              // Resgata o indicador de envio de e-mails caso o usu�rio seja HOMOLOGADOR NEC
              isPerfilNEC = true;
            }    

    //-----------------------------------------------------------------------------------------------------------------------
      //-- Formata as datas de acordo com o tipo de RP
      if(requisicao.getCodRecrutamento() == 1){
         requisicao.setIndTipoRequisicao("T");
         requisicao.setDatTransferencia(ConverteDate.stringToSqlDate(request.getParameter("datTransferencia")));
      }else{    
         requisicao.setIndTipoRequisicao("A");
         //**requisicao.setDatInicioContratacao(ConverteDate.stringToSqlDate(request.getParameter("datInicioContratacao")));
         requisicao.setDatInicioContratacao(ConverteDate.stringToSqlDate("01/" + request.getParameter("datInicioContratacao")));
         //-- verifica se o tipo de contrata��o n�o � indeterminado (n�o h� datas de contrata��o para este tipo)
         if(!requisicao.getIndTipoContratacao().equals("1")){        
            //**requisicao.setDatFimContratacao(ConverteDate.stringToSqlDate(request.getParameter("datFimContratacao")));
            requisicao.setDatFimContratacao(ConverteDate.stringToSqlDate("01/" + request.getParameter("datFimContratacao")));
         }       
      }
     
    //-----------------------------------------------------------------------------------------------------------------------      
	  //-- verificando o status da requisi��o, apenas altera se estiver EM REVIS�O
	  if(requisicao.getIndStatus() == 3){
		  //-- alterando os dados da requisi��o
		  requisicaoControl.alteraRequisicao(requisicao, usuario);
	      // setando os valores da grid de hor�rios dos professores
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
	      
	      // setando as fun��es adicionais para os professores
		  if(request.getParameterValues("codFuncao").length > 1){
			  StringBuffer funcaoExtra = new StringBuffer();
			  for(int i=1; i<request.getParameterValues("codFuncao").length; i++){
				  funcaoExtra.append("," + request.getParameterValues("codFuncao")[i]);
			  }
			  requisicaoPerfil.setListFuncao(funcaoExtra.toString().substring(1, funcaoExtra.length()));
		  }else{
			  requisicaoPerfil.setListFuncao(null);			  
		  }
	      
		  new RequisicaoJornadaControl().alteraRequisicaoJornada(requisicaoJornada);
		  new RequisicaoPerfilControl().alteraRequisicaoPerfil(requisicaoPerfil);		 
		  
		  //-- alterando o status na revis�o
		  retorno = new RequisicaoRevisaoControl().alteraRequisicaoRevisao(requisicaoRevisao, usuario, isPerfilHOM);       
			  
		  //------------------------ ENVIO DE E-MAILS --------------------------------      
			if(indEnviarEmails != null && indEnviarEmails.equals("S")){
			  //-- resgatando os dados da requisi��o que acaba de ser criada
			  requisicao = requisicaoControl.getRequisicao(codRequisicao);  
			  
			  if(isPerfilGEP || isPerfilNEC){
				//-- Realiza a notifica��o apenas quando a RP foi encaminhada para o aprovador final
				if(requisicaoAprovacaoControl.getNivelAprovacaoAtual(requisicao.getCodRequisicao()) == 4){              
				  RequisicaoMensagemControl.enviaMensagemHomologacaoGEP(usuario, requisicao);
				}else{
				  //-- Enviando e-mail para envolvidos no workflow
				  listaEmails = requisicaoAprovacaoControl.getEmailsEnvolvidosWorkFlow(requisicao);            
				
				  //-- Aprova�ao intermedi�ria (AP&B e NEC)
				  if(isPerfilGEP){
					//-- Aprova�ao AP&B => notifica o NEC
					RequisicaoMensagemControl.enviaMensagemHomologacaoAPeB(usuario, requisicao, listaEmails);
				  }else{
					//-- Aprova�ao NEC => notifica a AP&B
					RequisicaoMensagemControl.enviaMensagemHomologacaoNEC(usuario, requisicao, listaEmails);              
				  }
				}
				
			  }else if(isPerfilHOM){
					  //-- Se foi o gerente de unidade que aprovou, notifica os homologadores da GEP
					  RequisicaoMensagemControl.enviaMensagemHomologacaoUO(usuario, requisicao);
					}else{
					  //-- Se foi o usu�rio criador que revisou a RP, notifica o gerente de unidade 
					  RequisicaoMensagemControl.enviaMensagemRevisaoEfetuada(usuario, requisicao, requisicaoAprovacaoControl.getEmailResponsavelUO(requisicao.getCodUnidade()));
					}            
			}
	  }else{
	     retorno = -2;
		 RequisicaoMensagemControl.enviaMensagemCritica("atualizar.jsp", "Tentativa de viola��o dos dados cadastrais da requisi��o! <br><b>RP:</b> " + requisicao.getCodRequisicao(), (Usuario) session.getAttribute("usuario"));
	  }
%>

<script language="javascript">
  if(<%=retorno%> > 0){
    if(<%=isPerfilHOM%> || <%=isPerfilGEP%>){
      alert('Requisi��o revisada e aprovada com sucesso!');
    }else{
      alert('Revis�o realizada com sucesso!');
    }
  }else{
	switch(<%=retorno%>){
		case -1: alert('N�o foi poss�vel revisar a RP <%=codRequisicao%>!\nEsta RP j� foi revisada por outro colaborador da unidade.'); break;
		case -2: alert('N�o foi poss�vel alterar os dados da RP <%=codRequisicao%>!\nEsta RP n�o est� em revis�o. A tentativa de viola��o dos dados foi notificada aos administradores do sistema.'); break;
	}
  }
  window.location = "<%=request.getContextPath()%>/requisicao/aprovar/index.jsp";
</script>