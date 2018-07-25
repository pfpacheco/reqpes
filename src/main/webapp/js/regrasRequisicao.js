//------------------------------------------------------------------------------
var dias = ["Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado", "Domingo"];
//------------------------------------------------------------------------------

	//------------------------------------------------------------------------------
      // Função que realiza a validação das regras dos campos
      function validaRegras(apb){
        var retorno = false;
        
        // Funcionário substituído
        if(document.frmRequisicao.codRPPara.value != "1" && document.frmRequisicao.codMotivoSolicitacao.value != "1"){
          if(decode(document.frmRequisicao.idSubstitutoHist,"Informe o número da chapa do funcionário substituído!",0,"",null)){
            retorno = true;
          }else{
            return false;
          }
        }
  
        // Verifica se foi selecionado a opção de cargo administrativo como coordenador
        if(document.getElementById('indCargoAdministrativo').value == 'S'){
          if(validarRadio(document.frmRequisicao.indRespAdm,"Informe se o cargo é responsável pela área Administrativa!")){
            retorno = true;
          }else{
            return false;
          }
        }else{
          retorno = true;
        }
        
        // Tipo de contratação
        if(document.frmRequisicao.codRecrutamento.value != '1'){
          if(decode(document.frmRequisicao.indTipoContratacao,"Selecione o tipo de contratação!",0,"",null)){            
            if(document.frmRequisicao.codRPPara.value != "3" && (document.frmRequisicao.indTipoContratacao.value != "1" || document.frmRequisicao.indTipoContratacao.value != "0") ){
              if(decode(document.frmRequisicao.datInicioContratacao,"Informe a data de previsão de início da contratação!",0,"",null)){
                retorno = true;
              }else{
                return false;
              }
            }
            if(document.frmRequisicao.indTipoContratacao.value != "1"){
              if(decode(document.frmRequisicao.prazoContratacao,"Informe o prazo de contratação!",0,"",null))            
                if(decode(document.frmRequisicao.datFimContratacao,"Informe a data de fim da contratação!",0,"",null))
                  if(Verifica_Data_Mes('datInicioContratacao', 1)){
                    retorno = true;
                  }else{
                    return false;
                  }
            }
          }
        }
                
        // Outro local de trabalho
        if(document.frmRequisicao.indLocalTrabalho.value == "2"){
          if(decode(document.frmRequisicao.outroLocal,"Informe a sigla(s) da(s) unidade(s) ou endereço do outro local de trabalho!",0,"",null)){
            retorno = true;
          }else{
            return false;
          }
        }         
        
        // Número de funcionários de supervisão
        if(document.frmRequisicao.indSupervisao[1].checked){
          if(decode(document.frmRequisicao.numFuncionariosSupervisao,"Informe o número de funcionários da supervisão!",0,"",null)){
            retorno = true;
          }else{
            return false;
          }
        }
            
        // Verifica se o horário de trabalho informado condiz com a jornada de trabalho do cargo selecionado           
        if(document.getElementById('indTipoHorario').value != 'P' && document.getElementById('codEscala').value == ''){
          alert('Efetue a pesquisa de Escala Horária!\nApós realização da pesquisa, selecione a escala desejada!');
          return false;
        }else{
          retorno = true;
        }
  
        // Verifica se foi informado ID Calendário
        if(document.getElementById('codCalendario').value == '0'){
          alert('Selecione o ID Calendário!');
          document.getElementById('codCalendario').focus();
          return false;
        }
        
        // Verifica se foi informado ID Calendário válido
        if(document.getElementById('codCalendario').value == "-1"){
          alert('Nenhum calendário associado com o horário informado!');
          if(document.getElementById('codCalendario') != null){
        	  document.getElementById('codCalendario').focus();
          }
          return false;
        }else{
          retorno = true;
        }
        
        // Recrutamento Interno, valida a data de transferência
        if(document.frmRequisicao.codRecrutamento.value == '1'){
          if(document.frmRequisicao.datTransferencia.value == '0'){
            alert('Informe a data de previsão de transferência!');
            document.frmRequisicao.datTransferencia.focus();
            return false;
          }else{
            retorno = true;          
          }
        }
        
        // Valida total da jornada de trabalho semanal
        if(document.frmRequisicao.indCargoRegime.value == 'H'){
        	var obj = document.getElementById('jornadaTrabalho');
        	if(eval(obj.value) > 44){
        		alert('A carga horária semanal não pode ultrapassar 44 horas!');
        		obj.focus();
        		return false;
        	}
        }
        
        // Valida o campo Função no Perfil da RP
        if(apb < 2){
        	if(document.getElementById('indTipoHorario').value == 'P'){
    			if(document.frmRequisicao.codFuncao[0].value == '0'){
    				alert("Selecione a Função!");
    				document.frmRequisicao.codFuncao[0].focus();
    				return false;
    			}
        	}else{
        		if(!decode(document.frmRequisicao.codFuncao,"Selecione a Função!",0,"",null))
        			return false;
        	}
        }
    	
    	
    	// Valida o IDCodeCombination
    	if(document.getElementById('idCodeCombination').value == '0'){
    		alert('IDCodeCombination inválido!\nSelecione novamente os segmentos.');
    		return false;
    	}

        //-- retorno da função
        return retorno;
      }

  //------------------------------------------------------------------------------
      // Função que realiza a validação dos campos
      function submete(apb){
    	  
    	if(apb === undefined){
    		apb = 0;
    	}  
    	  
        var validacaoCampos = false;            
        var objetoAjax  = createXMLHTTP();          
        var parametros  = "P_COD_UNIDADE=" + document.getElementById('idcodUnidade').value;
            parametros += "&P_COD_CARGO=" + document.getElementById('codCargo').value;
            parametros += "&P_COTA_CARGO=" + document.getElementById('cotaCargo').value;
            parametros += "&P_COD_TAB_SALARIAL=" + ((document.getElementById('indTipoHorario').value == 'M')? 7 : 0);
            
            if(apb == 0)
            	parametros += "&P_SEGMENTO4=" + document.getElementById('idsegmento4').value;
            else 
            	parametros += "&P_SEGMENTO4=" + document.getElementById('cc').nextSibling.nextSibling.textContent.split('.')[3]; 		
            
            
            //--validando prazo
            if(document.frmRequisicao.indTipoContratacao.value > 1){
            	if(!verificaPrazoContratacao(document.frmRequisicao.prazoContratacao.value,document.frmRequisicao.vlrAprendizPrazo.value,document.frmRequisicao.vlrPrazo.value))
                    return false;
            }
            
			//-- Validando qtd de caracteres dos campos textarea
			if (!limitarCaracteres(document.frmRequisicao.dscMotivoSolicitacao,document.frmRequisicao.qtdMotivoSolicitacao,2000,"Justificativa"))
            	return;
			
			if(apb < 2){
				if (!limitarCaracteres(document.frmRequisicao.dscAtividadesCargo,document.frmRequisicao.qtdDscAtividadesCargo,4000,"Principais atividades do cargo"))
	            	return;
	            
	            if (!limitarCaracteres(document.frmRequisicao.descricaoFormacao,document.frmRequisicao.qtdFormacao,4000,"Escolaridade mínima"))
	            	return;
	            
	            if (!limitarCaracteres(document.frmRequisicao.dscExperiencia,document.frmRequisicao.qtdExperiencia,4000,"Experiência profissional"))
	            	return;
	            
	            if (!limitarCaracteres(document.frmRequisicao.dscConhecimentos,document.frmRequisicao.qtdConhecimentos,4000,"Conhecimentos específicos"))
	            	return;
	            
	            if (!limitarCaracteres(document.frmRequisicao.outrasCarateristica,document.frmRequisicao.qtdOutrasCaracteristicas,4000,"Competências"))
	            	return;
	            
	            if (!limitarCaracteres(document.frmRequisicao.comentarios,document.frmRequisicao.qtdComentarios,2000,"Observações"))
	            	return;
			}
            
            //-- setando o destino o metodo  			  
            objetoAjax.open("post", "ajax/validaIN15.jsp", true);		  
            objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
         
            //-- setando a função
            objetoAjax.onreadystatechange=function(){  
              if(objetoAjax.readyState == 4){
                var retorno = Trim(objetoAjax.responseText);
                //-- Validando a IN15
                if(document.frmRequisicao.indCaraterExcecao[0].checked && retorno == 'false'){
                  alert('De acordo com a Instrução 04/2011 não é permitido contratar o cargo e cota selecionados,\nverifique a instrução e selecione o cargo correto.');
                  document.frmRequisicao.codCargo.focus();
                  return false;
                }else{                  
                  //-- Realizando validação em campos obrigatórios
                  if(apb == 0){
                	  if(decode(document.frmRequisicao.segmento1,"Selecione o segmento Empresa!",-1,"",null))
                          if(decode(document.frmRequisicao.segmento2,"Selecione o segmento Uniorg Emitente!",-1,"",null))
                            if(decode(document.frmRequisicao.segmento3,"Selecione o segmento Uniorg Destino!",-1,"",null))
                              if(decode(document.frmRequisicao.segmento4,"Selecione o segmento área / Sub-área!",-1,"",null))
                                if(decode(document.frmRequisicao.segmento5,"Selecione o segmento Serviço / Produto!",-1,"",null))
                                  if(decode(document.frmRequisicao.segmento6,"Selecione o segmento Especificação!",-1,"",null))
                                    if(decode(document.frmRequisicao.segmento7,"Selecione o segmento Modalidade!",-1,"",null))
                                    	if(decode(document.frmRequisicao.nomUnidade,"Informe os dados da unidade!",0,"",null))
                                    		null;
                  }
                                             	
	                            
	                              if(decode(document.frmRequisicao.codRecrutamento,"Selecione a tipo de recrutamento!",0,"",null))
	                                if(decode(document.frmRequisicao.codCargo,"Selecione o cargo!",0,"",null))
	                                  if(decode(document.frmRequisicao.cotaCargo,"Informe a cota salarial!",'',"",null))
	                                    if(decode(document.frmRequisicao.salario,"Informe o salário!",0,"",null))
	                                      if(decode(document.frmRequisicao.jornadaTrabalho,"Informe a carga horária semanal!",0,"",null))
	                                        if(decode(document.frmRequisicao.codClassificacaoFuncional,"Selecione a classificação funcional!",0,"",null))
	                                          if(decode(document.frmRequisicao.codRPPara,"Selecione o campo RP Para!",0,"",null)){
	                                            // caso o tipo da RP seja COMPLEMENTO DE QUADRO, não valida o motivo da solicitação
	                                            if(document.frmRequisicao.codRPPara.value != '1'){
	                                              if(document.frmRequisicao.codMotivoSolicitacao.value == '0'){
	                                                alert('Selecione o motivo da solicitação!');
	                                                document.frmRequisicao.codMotivoSolicitacao.focus();
	                                                return false;
	                                              }
	                                            }
	                                            if(decode(document.frmRequisicao.dscMotivoSolicitacao,"Informe a justificativa!",0,"",null))
	                                              if(decode(document.frmRequisicao.indLocalTrabalho,"Selecione o local de trabalho!",0,"",null))                                        
	                                                if(decode(document.frmRequisicao.indViagem,"Selecione o tipo de viagem!",0,"",null))
	                                                  if(validarRadio(document.frmRequisicao.indSupervisao,"Informe a supervisão de funcionários!"))
	                                                	  //se estiver no modo edição do ap&b, encerra a validação aqui.
	                                                	  if(apb == 2)
	                                                		  validacaoCampos = true;
	                                            
	                                            		if(apb < 2){
	                                            			if(decode(document.frmRequisicao.codArea,"Selecione a área!",0,"",null))
	  	                                                      if(decode(document.frmRequisicao.codNivelHierarquia,"Selecione o nível hierárquico!",0,"",null))
	  	                                                        if(decode(document.frmRequisicao.dscAtividadesCargo,"Informe as principais atividades do cargo!",0,"",null))
	  	                                                          if(decode(document.frmRequisicao.descricaoFormacao,"Informe a escolaridade mínima!",0,"",null))
	  	                                                            if(decode(document.frmRequisicao.dscExperiencia,"Informe a experiência profissional!",0,"",null))
	  	                                                              if(decode(document.frmRequisicao.dscConhecimentos,"Informe os conhecimentos específicos!",0,"",null))
	  	                                                                if(decode(document.frmRequisicao.outrasCarateristica,"Informe as competências!",0,"",null)){
	  	                                                                  validacaoCampos = true;
	  	                                                                }
	                                            		}
	                                                    
	                                            }
                                            
                    //-- Enviando as informações
                    if(validacaoCampos && validaRegras(apb)){
                       //-- validação da carga horária do cargo com a escala para os PROFESSORES
	                   if(document.getElementById('indTipoHorario').value == 'P'){
						    //-- setando os parametros 
						    var pHorario  = "P_CARGA_HORARIA=" + document.frmRequisicao.jornadaTrabalho.value;
						    	pHorario += "&P_SEG_ENTRADA1="+ document.frmRequisicao.hrDigSegundaEntrada1.value;
						        pHorario += "&P_SEG_SAIDA1="  + document.frmRequisicao.hrDigSegundaSaida1.value;
						        pHorario += "&P_SEG_ENTRADA2="+ document.frmRequisicao.hrDigSegundaEntrada2.value; 
						        pHorario += "&P_SEG_SAIDA2="  + document.frmRequisicao.hrDigSegundaSaida2.value;
						        pHorario += "&P_SEG_ENTRADA3="+ document.frmRequisicao.hrDigSegundaEntrada3.value;
						        pHorario += "&P_SEG_SAIDA3="  + document.frmRequisicao.hrDigSegundaSaida3.value;
						        pHorario += "&P_SEG_ENTRADA4="+ document.frmRequisicao.hrDigSegundaEntrada4.value; 
						        pHorario += "&P_SEG_SAIDA4="  + document.frmRequisicao.hrDigSegundaSaida4.value;
						        
						    	pHorario += "&P_TER_ENTRADA1="+ document.frmRequisicao.hrDigTercaEntrada1.value;
						        pHorario += "&P_TER_SAIDA1="  + document.frmRequisicao.hrDigTercaSaida1.value;
						        pHorario += "&P_TER_ENTRADA2="+ document.frmRequisicao.hrDigTercaEntrada2.value; 
						        pHorario += "&P_TER_SAIDA2="  + document.frmRequisicao.hrDigTercaSaida2.value;
						        pHorario += "&P_TER_ENTRADA3="+ document.frmRequisicao.hrDigTercaEntrada3.value;
						        pHorario += "&P_TER_SAIDA3="  + document.frmRequisicao.hrDigTercaSaida3.value;
						        pHorario += "&P_TER_ENTRADA4="+ document.frmRequisicao.hrDigTercaEntrada4.value; 
						        pHorario += "&P_TER_SAIDA4="  + document.frmRequisicao.hrDigTercaSaida4.value;
						        
						    	pHorario += "&P_QUA_ENTRADA1="+ document.frmRequisicao.hrDigQuartaEntrada1.value;
						        pHorario += "&P_QUA_SAIDA1="  + document.frmRequisicao.hrDigQuartaSaida1.value;
						        pHorario += "&P_QUA_ENTRADA2="+ document.frmRequisicao.hrDigQuartaEntrada2.value; 
						        pHorario += "&P_QUA_SAIDA2="  + document.frmRequisicao.hrDigQuartaSaida2.value;
						        pHorario += "&P_QUA_ENTRADA3="+ document.frmRequisicao.hrDigQuartaEntrada3.value;
						        pHorario += "&P_QUA_SAIDA3="  + document.frmRequisicao.hrDigQuartaSaida3.value;
						        pHorario += "&P_QUA_ENTRADA4="+ document.frmRequisicao.hrDigQuartaEntrada4.value; 
						        pHorario += "&P_QUA_SAIDA4="  + document.frmRequisicao.hrDigQuartaSaida4.value;
						        
						    	pHorario += "&P_QUI_ENTRADA1="+ document.frmRequisicao.hrDigQuintaEntrada1.value;
						        pHorario += "&P_QUI_SAIDA1="  + document.frmRequisicao.hrDigQuintaSaida1.value;
						        pHorario += "&P_QUI_ENTRADA2="+ document.frmRequisicao.hrDigQuintaEntrada2.value; 
						        pHorario += "&P_QUI_SAIDA2="  + document.frmRequisicao.hrDigQuintaSaida2.value;
						        pHorario += "&P_QUI_ENTRADA3="+ document.frmRequisicao.hrDigQuintaEntrada3.value;
						        pHorario += "&P_QUI_SAIDA3="  + document.frmRequisicao.hrDigQuintaSaida3.value;
						        pHorario += "&P_QUI_ENTRADA4="+ document.frmRequisicao.hrDigQuintaEntrada4.value; 
						        pHorario += "&P_QUI_SAIDA4="  + document.frmRequisicao.hrDigQuintaSaida4.value;
						        
						    	pHorario += "&P_SEX_ENTRADA1="+ document.frmRequisicao.hrDigSextaEntrada1.value;
						        pHorario += "&P_SEX_SAIDA1="  + document.frmRequisicao.hrDigSextaSaida1.value;
						        pHorario += "&P_SEX_ENTRADA2="+ document.frmRequisicao.hrDigSextaEntrada2.value; 
						        pHorario += "&P_SEX_SAIDA2="  + document.frmRequisicao.hrDigSextaSaida2.value;
						        pHorario += "&P_SEX_ENTRADA3="+ document.frmRequisicao.hrDigSextaEntrada3.value;
						        pHorario += "&P_SEX_SAIDA3="  + document.frmRequisicao.hrDigSextaSaida3.value;
						        pHorario += "&P_SEX_ENTRADA4="+ document.frmRequisicao.hrDigSextaEntrada4.value; 
						        pHorario += "&P_SEX_SAIDA4="  + document.frmRequisicao.hrDigSextaSaida4.value;
						        
						    	pHorario += "&P_SAB_ENTRADA1="+ document.frmRequisicao.hrDigSabadoEntrada1.value;
						        pHorario += "&P_SAB_SAIDA1="  + document.frmRequisicao.hrDigSabadoSaida1.value;
						        pHorario += "&P_SAB_ENTRADA2="+ document.frmRequisicao.hrDigSabadoEntrada2.value; 
						        pHorario += "&P_SAB_SAIDA2="  + document.frmRequisicao.hrDigSabadoSaida2.value;
						        pHorario += "&P_SAB_ENTRADA3="+ document.frmRequisicao.hrDigSabadoEntrada3.value;
						        pHorario += "&P_SAB_SAIDA3="  + document.frmRequisicao.hrDigSabadoSaida3.value;
						        pHorario += "&P_SAB_ENTRADA4="+ document.frmRequisicao.hrDigSabadoEntrada4.value; 
						        pHorario += "&P_SAB_SAIDA4="  + document.frmRequisicao.hrDigSabadoSaida4.value;
						        
						    	pHorario += "&P_DOM_ENTRADA1="+ document.frmRequisicao.hrDigDomingoEntrada1.value;
						        pHorario += "&P_DOM_SAIDA1="  + document.frmRequisicao.hrDigDomingoSaida1.value;
						        pHorario += "&P_DOM_ENTRADA2="+ document.frmRequisicao.hrDigDomingoEntrada2.value; 
						        pHorario += "&P_DOM_SAIDA2="  + document.frmRequisicao.hrDigDomingoSaida2.value;
						        pHorario += "&P_DOM_ENTRADA3="+ document.frmRequisicao.hrDigDomingoEntrada3.value;
						        pHorario += "&P_DOM_SAIDA3="  + document.frmRequisicao.hrDigDomingoSaida3.value;
						        pHorario += "&P_DOM_ENTRADA4="+ document.frmRequisicao.hrDigDomingoEntrada4.value; 
						        pHorario += "&P_DOM_SAIDA4="  + document.frmRequisicao.hrDigDomingoSaida4.value;          
						  
						    //-- setando o destino o metodo  			  
						    objetoAjax.open("post", "ajax/validaHora.jsp", true);		  
						     
						    //-- setando o tipo de request
						    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
						   
						    //-- setando a função
						    objetoAjax.onreadystatechange = function(){  
						                                      if(objetoAjax.readyState == 4){
						                                    	var retorno = objetoAjax.responseText;
						                                        if(retorno == '0'){
						                                           //-- Desabilita os botões antes do envio
						                                           document.frmRequisicao.btnSubmete.disabled = true;
						                                           document.frmRequisicao.btnVoltar.disabled  = true;
						                                           document.frmRequisicao.submit();						                     	                   
						                                        }else{
						                                           alert('As '+ document.frmRequisicao.jornadaTrabalho.value +' horas semanais não correspondem às horas informadas no quadro de horário de trabalho!\nDiferença de horas: '+ retorno);						                                          
						                                        }
						                                      }
						                                    };
						                              
						    // -- setando o parametros para o AJAX
						    objetoAjax.send(pHorario);
	                   }else{
	                	   //-- Desabilita os botões antes do envio
	                	   document.frmRequisicao.btnSubmete.disabled = true;
	                	   document.frmRequisicao.btnVoltar.disabled  = true;
	                	   document.frmRequisicao.submit();
                       }
                    }
                }
              }
            };
          objetoAjax.send(parametros);              
      }
  
  //------------------------------------------------------------------------------    
      // Função de regra de exceção de Cota Salarial
      //-- Cargo: 8473 - ASSISTENTE TECNICO ADMINISTRATIVO I
      //-- Area/Subarea: 0101 - APOIO ADMINISTRATIVO            
      function configAreaAdministrativa(opcao){
        var segmento4  = document.getElementById('idsegmento4').value;
        var codCargo   = document.getElementById('codCargo').value;
        var codUnidade = document.getElementById('idcodUnidade').value;    
        var tipo       = (document.frmRequisicao.indCaraterExcecao[0].checked)?'N':'S';
              
        if(opcao == 'S'){
          //-- TABELA 01 GERAL - RESPONSÁVEL PELA ÁREA ADMINISTRATIVA
          getCota(tipo, codUnidade, codCargo, 3, segmento4);
        }else{
          //-- TABELA 01 GERAL
          getCota(tipo, codUnidade, codCargo, 1, segmento4);
        }
        exibeOcultaDiv('divAreaAdministrativa', false);
        document.getElementById('indCargoAdministrativo').value = 'N';
        document.frmRequisicao.indRespAdm[0].checked = false;
        document.frmRequisicao.indRespAdm[1].checked = false;
      }
    
  //-----------------------------------------------------------------------------------------------------------------------
      // Carregando o salário do cargo de acordo com a cota informada
      function getSalarioPorCota(cota, edicao){
    	  
        if(edicao == undefined){
        	edicao = 0;
        }  	
    	  
        if(Trim(cota) != ''){
          if(document.frmRequisicao.codCargo.value != 0){
        	if(edicao > 0){
        		var segmento3 = document.getElementById('cc').nextSibling.nextSibling.textContent.split('.')[2];
        		carregaSalarioPorCota(cota, segmento3, document.frmRequisicao.codCargo.value, 'divSalario');
        	} else {
        		carregaSalarioPorCota(cota, document.frmRequisicao.segmento3.value, document.frmRequisicao.codCargo.value, 'divSalario');
        	}
          }else{
            alert('Selecione o cargo!');
            document.frmRequisicao.codCargo.focus();
          }
        }else{
          document.frmRequisicao.salario.value = '';
        }
      } 
      
  //-----------------------------------------------------------------------------------------------------------------------
      // Carregando a descrição da classificação funcional  
      function getDescricaoClassificacaoFuncional(codClassificacaoFuncional, tipoRP){    
        // Carregando a descrição da classificação funcional no textarea
        carregaDadosClassificacaoFuncional(codClassificacaoFuncional,'divDescricaoClassificacaoFuncional'); 
      }      
      
  //-----------------------------------------------------------------------------------------------------------------------      
      // Carregando o nome do funcionario que será substituído
      function getNomeFuncionario(chapa){
        if(Trim(chapa) != ''){
          carregaNomeFuncionario(chapa, 'divNomeSubstituido');
        }
      }           
  
  //-----------------------------------------------------------------------------------------------------------------------      
      // Carregando a jornada de trabalho do cargo selecionado      
      function getJornadaTrabalho(codCargo, edicao){    
    	 
    	if(edicao === undefined){
    		edicao = 0;
      	} 
    	  
    	if(edicao < 1)
    		var codUnidade = document.frmRequisicao.segmento3.value;
    	else
    		var segmento3 = document.getElementById('cc').nextSibling.nextSibling.textContent.split('.')[2];
    	
        //-- limpando campos relacionados com o cargo selecionado
        document.getElementById('cotaCargo').value = '';
        document.getElementById('salario').value = '';
        document.getElementById('codEscala').value = '';
        document.getElementById('jornadaTrabalho').value = '';
        resetComboCalendario();
        novaPesquisaEscala();
 
        if(document.frmRequisicao.codCargo.value != '0'){
          // Carregando a jornada semanal (horas)    
          carregaHorasJornadaTrabalho(codCargo, codUnidade, 'divHorasJornadaTrabalho');
          // Seta atributo da unidade referente a unidade informada
          verificaCargoUnidade(codUnidade, codCargo, edicao);
        }else{
          document.frmRequisicao.codCargo.focus();
        }
      }      

  //-----------------------------------------------------------------------------------------------------------------------        
      // Função genérica que exibe e oculta as DIV'S
      function exibeOcultaDiv(divParam,indExibe){
        var div = document.getElementById(divParam);
      
        if(indExibe){
          div.style.visibility = 'visible';
          div.style.display = '';
        }else{
          div.style.visibility = 'hidden';
          div.style.display = 'none';
        }
      }  

  //-----------------------------------------------------------------------------------------------------------------------              
      // Função que exibe / oculta os campos de tipo de contratação DETERMINADO
      function exibePeriodoTipoContratacao(indTipoContratacao){
        
        if(document.frmRequisicao.codRPPara.value == '3' && (indTipoContratacao == '1' || indTipoContratacao == '0') ){
          exibeOcultaDiv('divExibePrazoContratacao',false);
          exibeOcultaDiv('divPrazoContratacao',false);
          exibeOcultaDiv('divDataInicioContratacao1',false);
          exibeOcultaDiv('divDataInicioContratacao2',false);          
          exibeOcultaDiv('divDataFimContratacao',false);        
        }else if(indTipoContratacao == '1' || indTipoContratacao == '0'){
                exibeOcultaDiv('divExibePrazoContratacao',false);
                exibeOcultaDiv('divPrazoContratacao',false);
                exibeOcultaDiv('divDataFimContratacao',false);
              }else{    
                // Exibição das datas de período
                exibeOcultaDiv('divExibePrazoContratacao',true);
                exibeOcultaDiv('divPrazoContratacao',true);
                exibeOcultaDiv('divDataInicioContratacao1',true);
                exibeOcultaDiv('divDataInicioContratacao2',true);          
                exibeOcultaDiv('divDataFimContratacao',true);
              }
      }      
      
  //------------------------------------------------------------------------------    
   // Função que verifica se o prazo de contratação
      function verificaPrazoContratacao(prazo, vlrAprendizPrazo, vlrPrazo){
    	var vlrAprendizCargo = document.getElementById('aprendizCargo').value; 
        vlrAprendizCargo = vlrAprendizCargo.split(',');
        var achouAprendiz = false;
        var i;

        for(i = 0; i < vlrAprendizCargo.length; i++) {
        	//-- validando prazo de acordo com o cargo informado
			if(document.getElementById('codCargo').value == vlrAprendizCargo[i]){
				achouAprendiz = true;
		    	//-- prazo: 30 a 395 dias (cargo de APRENDIZ)
				//foi alterado para meses devido o chamado 910659
		        if(eval(prazo) < 1 || eval(prazo) > eval(vlrAprendizPrazo)){
		        	alert('O Período Contratação deve ser entre 1 e ' + vlrAprendizPrazo + ' meses!');
		            document.frmRequisicao.prazoContratacao.focus();
		            limpaDatas();
		            return false;
		        }
		        break;	        
		    }
		}
		//foi alterado para meses devido o chamado 910659
		if (!achouAprendiz) {
	        //-- prazo: 30 a 180 dias (demais cargos)
	        if(eval(prazo) < 1 || eval(prazo) > eval(vlrPrazo)){
	          alert('O Período Contratação deve ser entre 1 e ' + vlrPrazo + ' meses!');
	          document.frmRequisicao.prazoContratacao.focus();
	          limpaDatas();
	          return false;
	        }
		}


        // limpando os campos de datas		
        //limpaDatas();
        return true;
      }
      
      // Função que carrega a data final do prazo de contratação
      function carregaDataFim(dataInicial){
    	  
        if(document.frmRequisicao.indTipoContratacao.value != "1" && document.frmRequisicao.indTipoContratacao.value != "0"){
          if(document.frmRequisicao.prazoContratacao.value != ''){
            if(dataInicial != ''){
              if(Verifica_Data_Mes('datInicioContratacao', 1)){    
                // calcula a data final 
                carregaDataFimContratacao(dataInicial, document.frmRequisicao.prazoContratacao.value, 'divDataFimContratacao');
              }
            }
          }else{
            alert('Informe o Prazo de contratação!');
            document.frmRequisicao.prazoContratacao.focus();
          }
        }
      }      
      
      
  //------------------------------------------------------------------------------    
      // Copia os horários nos campos da semana
      function copiaHorario(indTipoHorario){ 
        var qtdSelecao = 0;
        var obj;
        
        //-- verificando qual objeto deve ser utilizado
        if(indTipoHorario == 'E'){
        	obj = document.frmRequisicao.tkSelDia;
        }else{
        	obj = document.frmRequisicao.hrSelDia;
        }

        for(idx=0; idx<obj.length; idx++){
        	qtdSelecao += (obj[idx].checked) ? 1 : 0;
        }
        
        if(qtdSelecao == 0){
        	alert('Para utilizar a cópia de horários, preencha o horário de trabalho na linha correspondente\na segunda-feira e escolha os dias da semana que o horário se repetirá.');     
        }else{
        	if(indTipoHorario == 'E'){
        		for(idx=0; idx<obj.length; idx++){
        			if(obj[idx].checked){
        				document.frmRequisicao.tkDia[idx+1].value = document.frmRequisicao.tkDia[0].value;
        				document.frmRequisicao.tkClassificacao[idx+1].value = document.frmRequisicao.tkClassificacao[0].value;
        				document.frmRequisicao.tkHrEntrada[idx+1].value = document.frmRequisicao.tkHrEntrada[0].value;
        				document.frmRequisicao.tkHrIntervalo[idx+1].value = document.frmRequisicao.tkHrIntervalo[0].value;
        				document.frmRequisicao.tkHrRetorno[idx+1].value = document.frmRequisicao.tkHrRetorno[0].value;
        				document.frmRequisicao.tkHrSaida[idx+1].value = document.frmRequisicao.tkHrSaida[0].value;
        			}
        		}
        	}else{
        		        		
        		for(idx=0; idx<obj.length; idx++){
        			if(obj[idx].checked){
        				for(j=1; j<5; j++){
        					//-- Atribui os valores informados na linha referente a segunda-feira aos demais dias selecionados
        					document.getElementById('hrDig'+dias[idx+1]+'Entrada'+j).value = document.getElementById('hrDig'+dias[0]+'Entrada'+j).value;
        					document.getElementById('hrDig'+dias[idx+1]+'Saida'  +j).value = document.getElementById('hrDig'+dias[0]+'Saida'  +j).value;
        				}        				
        			}
        		}       		
        	}
        }
      }      
      
  //------------------------------------------------------------------------------            
      // Valida a hora da jornada de trabalho
      function validaHora(obj, horario){
        var hora   = horario.slice(0,2);
        var minuto = horario.slice(3,6);
        var campo  = document.getElementById(obj);
                        
        // valida as horas
        if(hora >= 24){
          alert('Hora inválida!');
          setTimeout(function(){campo.focus();},300);
        }    
        // valida os minutos
        if(minuto >= 60){
          alert('Minuto inválido!');
          setTimeout(function(){campo.focus();},300);
        }  
        // complementa os valores
        switch(horario.length){
          case 1: campo.value = campo.value+'0:00'; break;
          case 2: campo.value = campo.value+':00'; break;
          case 3: campo.value = campo.value+'00'; break;
          case 4: campo.value = campo.value+'0'; break;
        }
      }  
      
  //------------------------------------------------------------------------------            
      // Função que limpa as datas quando o tipo de contratação é alterado
      function limpaDatas(){
        document.frmRequisicao.datInicioContratacao.value = '';
        document.frmRequisicao.datFimContratacao.value = '';
      }      
      
  //------------------------------------------------------------------------------
      // Função que retorna os dados do funcionário indicado na substituição
      function getDadosFuncionario(chapa){
        if(Trim(chapa) != ''){
          carregaDadosFuncionarioSubstituido(chapa, 'divNomeFuncionarioSubstituido');
          carregaDadosFuncionarioSubstituido(chapa, 'divUnidadeFuncionarioSubstituido');
        }
      }         
      
  //------------------------------------------------------------------------------    
      // Verificação utilizada no formulário de pesquisa de requisições
      function desabilitaSup(valor, combo){
        if(valor == '0'){
          //-- habilita todos os campos        
          document.frmPesquisa.supSA.disabled = false;
          document.frmPesquisa.supSO.disabled = false;
          document.frmPesquisa.supSU.disabled = false;
          document.frmPesquisa.supSD.disabled = false;        
          document.frmPesquisa.unidadeCodigo.disabled = false;  
          document.frmPesquisa.unidadeSigla.disabled = false;  
          return false;
        }
        //-- desabilita os combos restantes
        if(combo == 'SA'){
          document.frmPesquisa.supSO.disabled = true;
          document.frmPesquisa.supSU.disabled = true;
          document.frmPesquisa.supSD.disabled = true;
          document.frmPesquisa.supSU.disabled = true;
          document.frmPesquisa.supSD.disabled = true;      
          document.frmPesquisa.unidadeSigla.disabled = true;
          document.frmPesquisa.unidadeCodigo.disabled = true;
          document.frmPesquisa.supSO.value = 0;
          document.frmPesquisa.supSU.value = 0;
          document.frmPesquisa.supSD.value = 0;
          document.frmPesquisa.unidadeCodigo.value = 0;
          document.frmPesquisa.unidadeSigla.value = 0;          
        }else if(combo == 'SO'){
                document.frmPesquisa.supSA.disabled = true;
                document.frmPesquisa.supSU.disabled = true;
                document.frmPesquisa.supSD.disabled = true;
                document.frmPesquisa.unidadeSigla.disabled = true;
                document.frmPesquisa.unidadeCodigo.disabled = true;
                document.frmPesquisa.supSA.value = 0;
                document.frmPesquisa.supSU.value = 0;
                document.frmPesquisa.supSD.value = 0;
                document.frmPesquisa.unidadeCodigo.value = 0;
                document.frmPesquisa.unidadeSigla.value = 0;
              }else if(combo == 'SU'){
                      document.frmPesquisa.supSA.disabled = true;
                      document.frmPesquisa.supSO.disabled = true;
                      document.frmPesquisa.supSD.disabled = true;
                      document.frmPesquisa.unidadeSigla.disabled = true;
                      document.frmPesquisa.unidadeCodigo.disabled = true;
                      document.frmPesquisa.supSA.value = 0;
                      document.frmPesquisa.supSO.value = 0;
                      document.frmPesquisa.supSD.value = 0;                  
                      document.frmPesquisa.unidadeCodigo.value = 0;
                      document.frmPesquisa.unidadeSigla.value = 0;
                    }else if(combo == 'SD'){
                            document.frmPesquisa.supSA.disabled = true;
                            document.frmPesquisa.supSO.disabled = true;
                            document.frmPesquisa.supSU.disabled = true;
                            document.frmPesquisa.unidadeSigla.disabled = true;
                            document.frmPesquisa.unidadeCodigo.disabled = true;
                            document.frmPesquisa.supSA.value = 0;
                            document.frmPesquisa.supSO.value = 0;
                            document.frmPesquisa.supSU.value = 0;   
                            document.frmPesquisa.unidadeCodigo.value = 0;
                            document.frmPesquisa.unidadeSigla.value = 0;
                          }else if(combo == 'UO'){
                                  document.frmPesquisa.supSA.disabled = true;
                                  document.frmPesquisa.supSO.disabled = true;
                                  document.frmPesquisa.supSU.disabled = true;
                                  document.frmPesquisa.supSD.disabled = true;
                                  document.frmPesquisa.unidadeSigla.disabled = true;
                                  document.frmPesquisa.supSA.value = 0;
                                  document.frmPesquisa.supSO.value = 0;
                                  document.frmPesquisa.supSU.value = 0;                        
                                  document.frmPesquisa.supSD.value = 0;                        
                                  document.frmPesquisa.unidadeSigla.value = 0;
                                }else if(combo == 'SG'){
                                        document.frmPesquisa.supSA.disabled = true;
                                        document.frmPesquisa.supSO.disabled = true;
                                        document.frmPesquisa.supSU.disabled = true;
                                        document.frmPesquisa.supSD.disabled = true;
                                        document.frmPesquisa.unidadeCodigo.disabled = true;
                                        document.frmPesquisa.supSA.value = 0;
                                        document.frmPesquisa.supSO.value = 0;
                                        document.frmPesquisa.supSU.value = 0;                        
                                        document.frmPesquisa.supSD.value = 0;                        
                                        document.frmPesquisa.unidadeCodigo.value = 0;
                                      }
     }      

  //------------------------------------------------------------------------------            
      // Reseta a linha da jornada de trabalho de acordo com o dia informado
      function resetRowPesquisa(idx){
        if(idx > 0){
          document.frmRequisicao.tkSelDia[idx-1].checked = false;
        }
        document.frmRequisicao.tkDia[idx].value = '0';
        document.frmRequisicao.tkClassificacao[idx].value = '0';
        document.frmRequisicao.tkHrEntrada[idx].value = '';
        document.frmRequisicao.tkHrIntervalo[idx].value = '';
        document.frmRequisicao.tkHrRetorno[idx].value = '';
        document.frmRequisicao.tkHrSaida[idx].value = '';        
      }

  //------------------------------------------------------------------------------            
      // Limpa a hora da jornada de trabalho de acordo com o dia informado
      function limpaHoras(indTipoHorario, idx){
        if(indTipoHorario == 'E'){
	        if(!document.frmRequisicao.tkSelDia[idx-1].checked){
	          resetRowPesquisa(idx);
	        }
        }else{
        	if(!document.frmRequisicao.hrSelDia[idx-1].checked){
	    		for(j=1; j<5; j++){
	    			document.getElementById('hrDig'+ dias[idx] +'Entrada'+ j).value = '';
	    			document.getElementById('hrDig'+ dias[idx] +'Saida'  + j).value = '';
	    		}
        	}
        }
      }

  //------------------------------------------------------------------------------            
      // Exibe o tipo de pesquisa no formulário de pesquisa
      function exibeComplementoPesquisa(tipoPesquisa){
        if(tipoPesquisa == 'C'){
          exibeOcultaDiv('divCombosSegmentos',true);      
          exibeOcultaDiv('divCombosSuperintendencias',false);        
          //-- Limpa todos os campos de superintendência
          limpaCamposSuperintendencia();  
          desabilitaSup('0', 'combo');          
        }else if(tipoPesquisa == 'S'){
                exibeOcultaDiv('divCombosSegmentos',false);      
                exibeOcultaDiv('divCombosSuperintendencias',true);                
                //-- Limpa todos os campos dos segmentos
                document.frmPesquisa.segmento3.value = -1;
                document.frmPesquisa.segmento4.value = -1;
                document.frmPesquisa.segmento5.value = -1;                                
                document.frmPesquisa.segmento6.value = -1;                         
                document.frmPesquisa.segmento7.value = -1;                                         
              }else{
                exibeOcultaDiv('divCombosSegmentos',false);      
                exibeOcultaDiv('divCombosSuperintendencias',false);
                //-- Limpa todos os campos dos segmentos
                document.frmPesquisa.segmento3.value = -1;
                document.frmPesquisa.segmento4.value = -1;
                document.frmPesquisa.segmento5.value = -1;                                
                document.frmPesquisa.segmento6.value = -1;                         
                document.frmPesquisa.segmento7.value = -1;                                         
                //-- Limpa todos os campos de superintendência
                limpaCamposSuperintendencia();
                desabilitaSup('0', 'combo');                          
              }              
      }

  //------------------------------------------------------------------------------            
      // Limpa todos os campos do formulário de pesquisa referentes a superintendências
      function limpaCamposSuperintendencia(){
          //-- Limpa todos os campos de superintendência
          document.frmPesquisa.supSA.value = 0;
          document.frmPesquisa.supSO.value = 0;
          document.frmPesquisa.supSU.value = 0;                                
          document.frmPesquisa.supSD.value = 0;             
      }
      
  //------------------------------------------------------------------------------            
      // Limpa todos os campos do formulário de pesquisa quando um número de requisição é informado
      function limpaCampos(tipo, isRPAntiga){
        document.frmPesquisa.cargo_sq.value = 0;
        document.frmPesquisa.rpPara.value = 0;
        document.frmPesquisa.codMotivoSolicitacao.value = 0;
        document.frmPesquisa.codTipoContratacao.value = 0;
        document.frmPesquisa.statusRequisicao.value = 0;
        document.frmPesquisa.datInicio.value = '';
        document.frmPesquisa.datFim.value = '';
        
        // limpando os campos onde podem ser informados a RP
        if(tipo == 'RP'){
          document.frmPesquisa.idFuncBaixado.value = '';
        }else{
          document.frmPesquisa.requisicaoSq.value = '';
        }
        
        // zerando os combos de complemento de pesquisa, de acordo com o formulário que está chamando a função
        if(isRPAntiga){
          // RP's antigas
          limpaCamposSuperintendencia();
        }else{
          // RP's atuais
          exibeComplementoPesquisa('0');
          if(document.frmPesquisa.compPesquisa[0] != null && document.frmPesquisa.compPesquisa[1] != null){
            document.frmPesquisa.compPesquisa[0].checked = false;
            document.frmPesquisa.compPesquisa[1].checked = false;
          }
        }
      }      

  //------------------------------------------------------------------------------            
      //-- Envia a pesquisa após ser informada a tecla enter
      function OnEnterPesquisa(evt){
          var key_code = evt.keyCode?evt.keyCode:evt.charCode?evt.charCode:evt.which?evt.which:void 0;
          if(key_code == 13){
            document.frmPesquisa.submit();
          }
      }
      
  //------------------------------------------------------------------------------                  
      //-- Valida a jornada de trabalho informada na pesquisa
      function validaEscala(){
        var executa = false;
        
        if(Trim(document.frmRequisicao.jornadaTrabalho.value) == '' || document.frmRequisicao.jornadaTrabalho.value == '0' || document.frmRequisicao.jornadaTrabalho.value == '0.0'){
           alert('Informe a carga horária semanal ou selecione um cargo!');
           document.frmRequisicao.jornadaTrabalho.focus();          
        }else{               
          //-- Realiza validação do horário informado
          for(i=0; i<document.frmRequisicao.tkDia.length; i++){              
              //-- Valida o dia da semana
              if(document.frmRequisicao.tkDia[i].value == '0' && document.frmRequisicao.tkClassificacao[i].value != '0'){
                alert('Selecione o dia da semana!');
                document.frmRequisicao.tkDia[i].focus();
                return false;
              }              
              //-- Valida a Classificação do Dia
              if(document.frmRequisicao.tkDia[i].value != '0'){
                if(!decode(document.frmRequisicao.tkClassificacao[i],"Selecione a classificação do dia!",0,"",null)){
                  return false;                  
                }
              }
              //-- Validações complementares
              if(document.frmRequisicao.tkHrEntrada[i].value != '' || document.frmRequisicao.tkHrIntervalo[i].value != '' || 
                 document.frmRequisicao.tkHrRetorno[i].value != '' || document.frmRequisicao.tkHrSaida[i].value != ''){                   
                   if(decode(document.frmRequisicao.tkClassificacao[i],"Selecione a classificação do dia!",0,"",null)){
                      if(decode(document.frmRequisicao.tkDia[i],"Selecione o dia da semana!",0,"",null)){
                        executa = true;
                      }else{
                        return false;
                      }
                   }else{
                      return false;
                   }
              }
              if(document.frmRequisicao.tkClassificacao[i].value == 'TRAB' &&
                  (document.frmRequisicao.tkHrEntrada[i].value == '' && document.frmRequisicao.tkHrIntervalo[i].value == '' &&
                   document.frmRequisicao.tkHrRetorno[i].value == '' && document.frmRequisicao.tkHrSaida[i].value == '')){      
                alert('Informe o horário conforme a classificação do dia indicado!');
                document.frmRequisicao.tkClassificacao[i].focus();
                return false;
              }              
          }
          //-- Carrega iFrame com resultado da pesquisa
          if(executa){
            exibeOcultaDiv('divEscalaCarregando',true); 
            exibeOcultaDiv('divEscalaHorario',false);
            setTimeout('pesquisaEscala(5,1)', 120);
          }
        }
      }
      
  //------------------------------------------------------------------------------                  
      //-- Seta os valores dos campos
      function setVlrClaDiaHorario(idClaDia, valor){
        document.getElementById(idClaDia).value = valor;
      }      
      
  //------------------------------------------------------------------------------                  
      //-- Valida a jornada de trabalho informada na pesquisa      
      function novaPesquisaEscala(){
        exibePesquisaEscala(false);
        document.getElementById('codEscala').value = '';
        resetComboCalendario();
      }
      
  //------------------------------------------------------------------------------                  
      function novaPesquisaGrade(){
        desabilitaHorarioGrade(false);
        // Carrega o combo de calendário sem valoes   
        document.getElementById('codCalendario').value = '-1';
        // Limpando combo
        resetComboCalendario();
      }
      
  //------------------------------------------------------------------------------                  
      //-- Carrega os horários da pesquisa realizada na jornada de trabalho
      function carregarEscalaHorario(codEscala){
        document.getElementById('codEscala').value = codEscala;
        //-- Carrega o idCalendario correspondente a escala escolhida
        getIdCalendario(document.getElementById('idcodUnidade').value, codEscala, '', '', '', '', '', '', '');        
        //-- Regras de exibição das informações
        exibeOcultaDiv('divCarregaEscalaHorario',false);
        exibePesquisaEscala(true);
      }
      
  //------------------------------------------------------------------------------                  
      //-- Configura a exibição da área de pesquisa de horários
      function exibePesquisaEscala(isExibe){       
        if(isExibe){                  
          exibeOcultaDiv('divEscala',false);
          exibeOcultaDiv('divPesquisaEscala',false);
          exibeOcultaDiv('divRowPesquisa',false);
          exibeOcultaDiv('divBtnPesquisaEscala',false);
          exibeOcultaDiv('divBtnNovaPesquisa',true);
        }else{
          exibeOcultaDiv('divEscalaHorario',false);
          exibeOcultaDiv('divPesquisaEscala',true);
          exibeOcultaDiv('divRowPesquisa',true);
          exibeOcultaDiv('divBtnPesquisaEscala',true);
          exibeOcultaDiv('divBtnNovaPesquisa',false);        
        }
      }

  //------------------------------------------------------------------------------                  
      //-- Configura as DIV's de exibição dos campos
      //-- (1) Interna - Transferência / (2) Externa - Admissão
      function configuraRP(tipoRecrutamento){ 
        
        //-- Configurando tipo e prazos de contratação
        if(tipoRecrutamento == '1'){
          exibeOcultaDiv('divTipoContratacao1',false);
          exibeOcultaDiv('divTipoContratacao2',false);          
          exibeOcultaDiv('divExibePrazoContratacao',false);
          exibeOcultaDiv('divPrazoContratacao',false);
          exibeOcultaDiv('divDataInicioContratacao1',false);
          exibeOcultaDiv('divDataInicioContratacao2',false);
          exibeOcultaDiv('divDataFimContratacao',false);        
          document.getElementById('indTipoContratacao').value = '0';
        }else{
          exibeOcultaDiv('divTipoContratacao1',true);
          exibeOcultaDiv('divTipoContratacao2',true);
          exibeOcultaDiv('divExibePrazoContratacao',true);
          exibeOcultaDiv('divPrazoContratacao',true);
          exibeOcultaDiv('divDataInicioContratacao1',true);
          exibeOcultaDiv('divDataInicioContratacao2',true);
          exibeOcultaDiv('divDataFimContratacao',true);
          
          //-- Configura o tipo de contratação
          if(document.frmRequisicao.indTipoContratacao.value != '0'){
        	  exibePeriodoTipoContratacao(document.frmRequisicao.indTipoContratacao.value);
          }
        }
        
        //-- Configura data de transferência
        if(tipoRecrutamento == '1' || tipoRecrutamento == '0'){
          exibeOcultaDiv('divDatTransferencia1',true);
          exibeOcultaDiv('divDatTransferencia2',true);
        }else{
          exibeOcultaDiv('divDatTransferencia1',false);
          exibeOcultaDiv('divDatTransferencia2',false);        
        }
               
        //-- Carrega os combos do formulário de acordo com o tipo informado
        carregaCombos(tipoRecrutamento);
      }
            
  //------------------------------------------------------------------------------
      //-- Carrega com o calendário informado (executado apenas na edição)
      function getComboCalendario(codEscala){
        getIdCalendario(document.getElementById('idcodUnidade').value, codEscala, '', '', '', '', '', '', '');
      }      
  
  //------------------------------------------------------------------------------
      //-- Configura a linha de horário
      function configLinha(dia, valor){
        if(valor == "TRAB" || valor == "0"){
          document.frmRequisicao.tkHrEntrada[dia].disabled = false;
          document.frmRequisicao.tkHrIntervalo[dia].disabled = false;
          document.frmRequisicao.tkHrRetorno[dia].disabled = false;
          document.frmRequisicao.tkHrSaida[dia].disabled = false;
          
          if(dia > 0){
            document.frmRequisicao.tkSelDia[dia-1].disabled = false;
          }
          
        }else{
          
          document.frmRequisicao.tkHrEntrada[dia].value = '';
          document.frmRequisicao.tkHrIntervalo[dia].value = '';
          document.frmRequisicao.tkHrRetorno[dia].value = '';
          document.frmRequisicao.tkHrSaida[dia].value = '';
          document.frmRequisicao.tkHrEntrada[dia].disabled = true;
          document.frmRequisicao.tkHrIntervalo[dia].disabled = true;
          document.frmRequisicao.tkHrRetorno[dia].disabled = true;
          document.frmRequisicao.tkHrSaida[dia].disabled = true;
          
          if(dia > 0){
            document.frmRequisicao.tkSelDia[dia-1].disabled = true;
            document.frmRequisicao.tkSelDia[dia-1].checked  = false;
          }
          
        }
      }
      
  //------------------------------------------------------------------------------
      //-- Seta o combo de Classificação do Dia quando um horário for digitado
      function setClaDia(dia, valor){     
        if(valor == ''){
          if(document.frmRequisicao.tkHrEntrada[dia].value == '' && document.frmRequisicao.tkHrIntervalo[dia].value == '' && 
             document.frmRequisicao.tkHrRetorno[dia].value == '' && document.frmRequisicao.tkHrSaida[dia].value == ''){
                document.frmRequisicao.tkClassificacao[dia].options[0].selected = true;
          }
        }else{
          document.frmRequisicao.tkClassificacao[dia].options[1].selected = true;
        }
      }      
      
  //------------------------------------------------------------------------------
      //-- Seta a cota salarial de acordo com a Instrução 15 ou Regra de Exceção
      //-- Tipo (Caráter Exceção): (N)ão / (S)im
      function setCota(tipo, tipoEdicao){   
    	  
		if(tipoEdicao === undefined){
		   tipoEdicao = 0;
	    }    
    	  
        var regra = false;
           
        if(tipoEdicao > 0){
        	regra = true;
        } else {
	        //-- Valida os campos necessários para busca da cota
	        if(decode(document.frmRequisicao.segmento1,"Selecione o segmento Empresa!",-1,"",null))
	          if(decode(document.frmRequisicao.segmento2,"Selecione o segmento Uniorg Emitente!",-1,"",null))
	            if(decode(document.frmRequisicao.segmento3,"Selecione o segmento Uniorg Destino!",-1,"",null))
	              //-- Thiago 18/04/2011: a tabela de monitores não necessita mais de área-subárea
	              //if(decode(document.frmRequisicao.segmento4,"Selecione o segmento área / Sub-área!",-1,"",null))      
	                if(decode(document.frmRequisicao.codCargo,"Selecione o cargo!",0,"",null)){
	                  regra = true;
	                }
        }
        
        if(regra){
          var segmento4  = '0'; //document.getElementById('idsegmento4').value;
          var codCargo   = document.getElementById('codCargo').value;
          var codUnidade = document.getElementById('idcodUnidade').value;
                     
          //-- Verifica se o cargo informado é Monitor
          if(document.getElementById('indTipoHorario').value == 'M'){
            //-- TABELA 05 - MONITORES
            getCota(tipo, codUnidade, codCargo, 7, segmento4, tipoEdicao);
          }else{          
            //-- Carregando cota
            getCota(tipo, codUnidade, codCargo, 0, segmento4, tipoEdicao);
          }
          
        }else{
          document.frmRequisicao.codCargo.value = '0';
          limpaCargoConfig();
          return false;
        }
      }
    
  //-------------------------------------------------------------------------------
    //-- Limpa o combo de IdCalendário
    function resetComboCalendario(){
        var campo  = '<select name="codCalendario" id="codCalendario" style="width:402px;">';
            campo += '<option value="-1">SELECIONE</option>';
            campo += '</select>';
            
        document.getElementById('divIdCalendario').innerHTML = campo;    
    }
    
  //------------------------------------------------------------------------------            
    //-- Função que limpa as os campos de cota e salário
    function limpaCargoConfig(){
      document.frmRequisicao.indCaraterExcecao[0].checked = true;
      document.getElementById('cotaCargo').value = '';      
      document.getElementById('salario').value = '';
    }
    
  //------------------------------------------------------------------------------            
    //-- Função que adiciona linhas na pesquisa de escala
    function addRowPesquisa(){    
      var idItem = document.frmRequisicao.tkDia.length;    
      var row  = '<table id="tabRow'+ idItem +'" border="0" cellpadding="0" cellspacing="0" width="100%">';
          row += '  <tr>';
          row += '    <td height="25" align="center" class="tdintranet2" width="24%">';
          row += '      <select name="tkDia" class="select" style="width: 130px;">';
          row += '        <option value="0">SELECIONE</option>';
          row += '        <option value="SEG">SEGUNDA-FEIRA</option>';
          row += '        <option value="TER">TERÇA-FEIRA</option>';
          row += '        <option value="QUA">QUARTA-FEIRA</option>';
          row += '        <option value="QUI">QUINTA-FEIRA</option>';
          row += '        <option value="SEX">SEXTA-FEIRA</option>';
          row += '        <option value="SAB">SÁBADO</option>';
          row += '        <option value="DOM">DOMINGO</option>';
          row += '      </select>';
          row += '    </td>';
          row += '    <td height="25" align="center" class="tdintranet2" width="20%">';
          row += '      <select name="tkClassificacao" class="select" style="width: 110px;" onchange="configLinha('+ idItem +', this.value); ">';
          row += '        <option value="0">SELECIONE</option>';
          row += '        <option value="TRAB">TRABALHADO</option>';
          row += '        <option value="DSRM">DESCANSO</option>';
          row += '        <option value="COMP">COMPENSADO</option>';
          row += '      </select>';
          row += '    </td>';
          row += '    <td height="25" align="center" class="tdintranet2" width="12%">';
          row += '      <input class="input" name="tkHrEntrada" id="tkHrEntrada'+ idItem +'" onkeyPress="return Ajusta_Hora(this,event);" onblur="validaHora(\'tkHrEntrada'+ idItem +'\',this.value); setClaDia('+ idItem +',this.value);" size="5" maxlength="5" >';
          row += '    </td>';
          row += '    <td height="25" align="center" class="tdintranet2" width="12%">';
          row += '      <input class="input" name="tkHrIntervalo" id="tkHrIntervalo'+ idItem +'" onkeyPress="return Ajusta_Hora(this,event);" onblur="validaHora(\'tkHrIntervalo'+ idItem +'\',this.value); setClaDia('+ idItem +',this.value);" size="5" maxlength="5" >';
          row += '    </td>';
          row += '    <td height="25" align="center" class="tdintranet2" width="12%">';
          row += '      <input class="input" name="tkHrRetorno" id="tkHrRetorno'+ idItem +'" onkeyPress="return Ajusta_Hora(this,event);" onblur="validaHora(\'tkHrRetorno'+ idItem +'\',this.value); setClaDia('+ idItem +',this.value);" size="5" maxlength="5" >';
          row += '    </td>';
          row += '    <td height="25" align="center" class="tdintranet2" width="12%">';
          row += '      <input class="input" name="tkHrSaida" id="tkHrSaida'+ idItem +'" onkeyPress="return Ajusta_Hora(this,event);" onblur="validaHora(\'tkHrSaida'+ idItem +'\',this.value); setClaDia('+ idItem +',this.value);" size="5" maxlength="5" >';
          row += '    </td>';
          row += '    <td height="25" align="center" class="tdintranet2" width="3%">';
          row += '       <a onClick="resetRowPesquisa('+ idItem +');" style="cursor:pointer;">';
          row += '         <img src="../../imagens/bt_reset.png" alt="Limpar linha" border="0" align="middle"/>';
          row += '       </a>';
          row += '    </td>';
          row += '    <td height="25" align="center" class="tdintranet2" width="5%">';
          row += '       <input type="CHECKBOX" name="tkSelDia" onclick="limpaHoras('+ idItem +');" onkeydown="limpaHoras('+ idItem +');">';
          row += '    </td>';
          row += '  </tr>';
          row += '</table>';
          
      document.getElementById('divRowPesquisa').innerHTML += row;    
    }
    

  //------------------------------------------------------------------------------
    //-- Carrega o idCalendario correspondente ao horário informado (Grade de Horário - Monitor)
    function getCalendarioByGradeHorario(isDesabilitaCampos){
      var indSeg = 'N';
      var indTer = 'N';
      var indQua = 'N';
      var indQui = 'N';
      var indSex = 'N';
      var indSab = 'N';
      var indDom = 'N';
      
      //-- Setando objetos de pesquisa
      if(document.frmRequisicao.hrDigSegundaEntrada1.value != '' || document.frmRequisicao.hrDigSegundaSaida1.value != '' || 
         document.frmRequisicao.hrDigSegundaEntrada2.value != '' || document.frmRequisicao.hrDigSegundaSaida2.value != '' ||
         document.frmRequisicao.hrDigSegundaEntrada3.value != '' || document.frmRequisicao.hrDigSegundaSaida3.value != '' || 
         document.frmRequisicao.hrDigSegundaEntrada4.value != '' || document.frmRequisicao.hrDigSegundaSaida4.value != ''){
            indSeg = 'S';
      }

      if(document.frmRequisicao.hrDigTercaEntrada1.value != '' || document.frmRequisicao.hrDigTercaSaida1.value != '' ||
         document.frmRequisicao.hrDigTercaEntrada2.value != '' || document.frmRequisicao.hrDigTercaSaida2.value != '' ||
         document.frmRequisicao.hrDigTercaEntrada3.value != '' || document.frmRequisicao.hrDigTercaSaida3.value != '' ||
         document.frmRequisicao.hrDigTercaEntrada4.value != '' || document.frmRequisicao.hrDigTercaSaida4.value != ''){
            indTer = 'S';
      }
      
      if(document.frmRequisicao.hrDigQuartaEntrada1.value != '' || document.frmRequisicao.hrDigQuartaSaida1.value != '' ||
         document.frmRequisicao.hrDigQuartaEntrada2.value != '' || document.frmRequisicao.hrDigQuartaSaida2.value != '' ||
         document.frmRequisicao.hrDigQuartaEntrada3.value != '' || document.frmRequisicao.hrDigQuartaSaida3.value != '' ||
         document.frmRequisicao.hrDigQuartaEntrada4.value != '' || document.frmRequisicao.hrDigQuartaSaida4.value != ''){
            indQua = 'S';
      }
      
      if(document.frmRequisicao.hrDigQuintaEntrada1.value != '' || document.frmRequisicao.hrDigQuintaSaida1.value != '' ||
         document.frmRequisicao.hrDigQuintaEntrada2.value != '' || document.frmRequisicao.hrDigQuintaSaida2.value != '' ||
         document.frmRequisicao.hrDigQuintaEntrada3.value != '' || document.frmRequisicao.hrDigQuintaSaida3.value != '' ||
         document.frmRequisicao.hrDigQuintaEntrada4.value != '' || document.frmRequisicao.hrDigQuintaSaida4.value != ''){
            indQui = 'S';
      }
      
      if(document.frmRequisicao.hrDigSextaEntrada1.value != '' || document.frmRequisicao.hrDigSextaSaida1.value != '' ||
         document.frmRequisicao.hrDigSextaEntrada2.value != '' || document.frmRequisicao.hrDigSextaSaida2.value != '' ||
         document.frmRequisicao.hrDigSextaEntrada3.value != '' || document.frmRequisicao.hrDigSextaSaida3.value != '' ||
         document.frmRequisicao.hrDigSextaEntrada4.value != '' || document.frmRequisicao.hrDigSextaSaida4.value != ''){
            indSex = 'S';
      }
      
      if(document.frmRequisicao.hrDigSabadoEntrada1.value != '' || document.frmRequisicao.hrDigSabadoSaida1.value != '' ||
         document.frmRequisicao.hrDigSabadoEntrada2.value != '' || document.frmRequisicao.hrDigSabadoSaida2.value != '' ||
         document.frmRequisicao.hrDigSabadoEntrada3.value != '' || document.frmRequisicao.hrDigSabadoSaida3.value != '' ||
         document.frmRequisicao.hrDigSabadoEntrada4.value != '' || document.frmRequisicao.hrDigSabadoSaida4.value != ''){
            indSab = 'S';
      }
      
      if(document.frmRequisicao.hrDigDomingoEntrada1.value != '' || document.frmRequisicao.hrDigDomingoSaida1.value != '' ||
         document.frmRequisicao.hrDigDomingoEntrada2.value != '' || document.frmRequisicao.hrDigDomingoSaida2.value != '' ||
         document.frmRequisicao.hrDigDomingoEntrada3.value != '' || document.frmRequisicao.hrDigDomingoSaida3.value != '' ||
         document.frmRequisicao.hrDigDomingoEntrada4.value != '' || document.frmRequisicao.hrDigDomingoSaida4.value != ''){
            indDom = 'S';
      }            

      if(document.frmRequisicao.hrDigSegundaEntrada1.value == '00:00' && document.frmRequisicao.hrDigSegundaSaida1.value == '00:00' &&
         document.frmRequisicao.hrDigSegundaEntrada2.value == '00:00' && document.frmRequisicao.hrDigSegundaSaida2.value == '00:00' &&
         document.frmRequisicao.hrDigSegundaEntrada3.value == '00:00' && document.frmRequisicao.hrDigSegundaSaida3.value == '00:00' &&
         document.frmRequisicao.hrDigSegundaEntrada4.value == '00:00' && document.frmRequisicao.hrDigSegundaSaida4.value != ''){
            indSeg = 'N';
      }
      
      if(document.frmRequisicao.hrDigTercaEntrada1.value == '00:00' && document.frmRequisicao.hrDigTercaSaida1.value == '00:00' &&
         document.frmRequisicao.hrDigTercaEntrada2.value == '00:00' && document.frmRequisicao.hrDigTercaSaida2.value == '00:00' &&
         document.frmRequisicao.hrDigTercaEntrada3.value == '00:00' && document.frmRequisicao.hrDigTercaSaida3.value == '00:00' &&
         document.frmRequisicao.hrDigTercaEntrada4.value == '00:00' && document.frmRequisicao.hrDigTercaSaida4.value != ''){
            indTer = 'N';
      }        
      
      if(document.frmRequisicao.hrDigQuartaEntrada1.value == '00:00' && document.frmRequisicao.hrDigQuartaSaida1.value == '00:00' &&
         document.frmRequisicao.hrDigQuartaEntrada2.value == '00:00' && document.frmRequisicao.hrDigQuartaSaida2.value == '00:00' &&
         document.frmRequisicao.hrDigQuartaEntrada3.value == '00:00' && document.frmRequisicao.hrDigQuartaSaida3.value == '00:00' &&
         document.frmRequisicao.hrDigQuartaEntrada4.value == '00:00' && document.frmRequisicao.hrDigQuartaSaida4.value != ''){
            indQua = 'N';
      }        
      
      if(document.frmRequisicao.hrDigQuintaEntrada1.value == '00:00' && document.frmRequisicao.hrDigQuintaSaida1.value == '00:00' &&
         document.frmRequisicao.hrDigQuintaEntrada2.value == '00:00' && document.frmRequisicao.hrDigQuintaSaida2.value == '00:00' &&
         document.frmRequisicao.hrDigQuintaEntrada3.value == '00:00' && document.frmRequisicao.hrDigQuintaSaida3.value == '00:00' &&
         document.frmRequisicao.hrDigQuintaEntrada4.value == '00:00' && document.frmRequisicao.hrDigQuintaSaida4.value != ''){
            indQui = 'N';
      }
      
      if(document.frmRequisicao.hrDigSextaEntrada1.value == '00:00' && document.frmRequisicao.hrDigSextaSaida1.value == '00:00' &&
         document.frmRequisicao.hrDigSextaEntrada2.value == '00:00' && document.frmRequisicao.hrDigSextaSaida2.value == '00:00' &&
         document.frmRequisicao.hrDigSextaEntrada3.value == '00:00' && document.frmRequisicao.hrDigSextaSaida3.value == '00:00' &&
         document.frmRequisicao.hrDigSextaEntrada4.value == '00:00' && document.frmRequisicao.hrDigSextaSaida4.value != ''){
            indSex = 'N';
      }
      
      if(document.frmRequisicao.hrDigSabadoEntrada1.value == '00:00' && document.frmRequisicao.hrDigSabadoSaida1.value == '00:00' &&
         document.frmRequisicao.hrDigSabadoEntrada2.value == '00:00' && document.frmRequisicao.hrDigSabadoSaida2.value == '00:00' &&
         document.frmRequisicao.hrDigSabadoEntrada3.value == '00:00' && document.frmRequisicao.hrDigSabadoSaida3.value == '00:00' &&
         document.frmRequisicao.hrDigSabadoEntrada4.value == '00:00' && document.frmRequisicao.hrDigSabadoSaida4.value != ''){
            indSab = 'N';
      }
      
      if(document.frmRequisicao.hrDigDomingoEntrada1.value == '00:00' && document.frmRequisicao.hrDigDomingoSaida1.value == '00:00' &&
         document.frmRequisicao.hrDigDomingoEntrada2.value == '00:00' && document.frmRequisicao.hrDigDomingoSaida2.value == '00:00' &&
         document.frmRequisicao.hrDigDomingoEntrada3.value == '00:00' && document.frmRequisicao.hrDigDomingoSaida3.value == '00:00' &&
         document.frmRequisicao.hrDigDomingoEntrada4.value == '00:00' && document.frmRequisicao.hrDigDomingoSaida4.value != ''){
            indDom = 'N';
      } 

      //-- Realizando busca
      if(indSeg == 'S' || indTer == 'S' || indQua == 'S' || indQui == 'S' || indSex == 'S' || indSab == 'S' || indDom == 'S'){
     	getIdCalendario(document.getElementById('idcodUnidade').value, '', indSeg, indTer, indQua, indQui, indSex, indSab, indDom);
        desabilitaHorarioGrade(isDesabilitaCampos);
      }else{
        alert('Preencha a grade de horário de trabalho!');
      }
    }
    
  //------------------------------------------------------------------------------                  
    //-- Habilita ou Desabilita campos dos horários
    function desabilitaHorarioGrade(isDesabilita){    	
    	for(idx=0; idx<document.frmRequisicao.hrSelDia.length; idx++){
    		document.frmRequisicao.hrSelDia[idx].disabled = isDesabilita;
    	}
    	
    	if(isDesabilita){        
    		exibeOcultaDiv('divBtnConfirmar',false);        
    		exibeOcultaDiv('divBtnAlterar',true);
    		
    		for(d=0; d<dias.length; d++){
    			for(j=1; j<5; j++){
    				document.getElementById('hrDig'+ dias[d] +'Entrada'+ j).setAttribute('readOnly','readOnly');
    				document.getElementById('hrDig'+ dias[d] +'Saida'  + j).setAttribute('readOnly','readOnly');
    			}
    		}
    	}else{
    		exibeOcultaDiv('divBtnConfirmar',true);
    		exibeOcultaDiv('divBtnAlterar',false);
    		
    		for(d=0; d<dias.length; d++){
    			for(j=1; j<5; j++){
    				document.getElementById('hrDig'+ dias[d] +'Entrada'+ j).removeAttribute('readOnly');
    				document.getElementById('hrDig'+ dias[d] +'Saida'  + j).removeAttribute('readOnly');
    			}
    		}          
    	}
    }
    
  //---------------------------------------------------------------------------------
    //-- Configura a forma da jornada de trabalho
    function setTipoHorarioTrabalho(indTipoHorario){
    	if(indTipoHorario == 'P'){
    		exibeOcultaDiv('divHorarioEscala',false);
    		exibeOcultaDiv('divHorarioGrade',true);
    		document.getElementById('divBtnAddFuncao').style.display = 'inline';
    	}else{
    		exibeOcultaDiv('divHorarioEscala',true);
    		exibeOcultaDiv('divHorarioGrade',false);
    		document.getElementById('divBtnAddFuncao').style.display = 'none';
    	}
    }
    
  //---------------------------------------------------------------------------------
    //-- Adiciona linha com novo combo de função    
    function addFuncao(){
    	var obj = document.getElementById('divPerfilFuncao');
    	var valores;

    	if(obj.innerHTML.length == 0){
    		if(!decode(document.frmRequisicao.codFuncao,"Selecione a Função!",0,"",null)) 
    			return;
    		valores = document.frmRequisicao.codFuncao.innerHTML;
    	}else{
    		for(idx=0; idx<document.frmRequisicao.codFuncao.length; idx++){
    			if(document.frmRequisicao.codFuncao[idx].value == '0'){
    				alert("Selecione a Função!");
    				document.frmRequisicao.codFuncao[idx].focus();
    				return;    				
    			}
    		}
    		valores = document.frmRequisicao.codFuncao[0].innerHTML;
    	}
    	
    	var cbo  = '<table border="0" cellpadding="0" cellspacing="0" width="100%">';
    		cbo +=   '<tr>';
    		cbo +=     '<td height="25">';
    		cbo +=        '<select name="codFuncao" class="select" style="width:386px;">';
    		cbo += 		     valores.replace('selected','');
    		cbo +=        '</select>';
    		cbo +=	   '</td>';
    		cbo +=   '</tr>';
    		cbo += '</table>';
    	
    	obj.innerHTML += cbo;
    }
    
  //---------------------------------------------------------------------------------
    //-- Verifica a exibição dos dados complementares da RP
    function verificaSegmentos(){
    	var segmento1 = document.getElementById('idsegmento1').value;
    	var segmento2 = document.getElementById('idsegmento2').value;
    	var segmento3 = document.getElementById('idsegmento3').value;
    	var segmento4 = document.getElementById('idsegmento4').value;
    	var segmento5 = document.getElementById('idsegmento5').value;
    	var segmento6 = document.getElementById('idsegmento6').value;
    	var segmento7 = document.getElementById('idsegmento7').value;
    	
    	if(segmento3 != '-1' && segmento4 != '-1' && segmento5 != '-1' && segmento6 != '-1' && segmento7 != '-1'){
			getIdCodeCombination(segmento1, segmento2, segmento3, segmento4, segmento5, segmento6, segmento7);
    	}
    }
    
  //---------------------------------------------------------------------------------
    //-- Carrega os dados do Gerente e Cargos da Unidade selecionada no Segmento três
    function getDadosUnidade(codUnidade, codCargo, tipoEdicao){
	    //-- Carregando os dados da unidade
	    carregaDadosUnidade('divDadosAdicionaisUnidade', '', codUnidade);
	    carregaDadosUnidade('divNomUnidade', 'nomUnidade', codUnidade);         
	    carregaDadosUnidade('divTelUnidade', 'telUnidade', codUnidade);
	    carregaDadosUnidade('divResponsavelUnidade', 'nomSuperior', codUnidade);
	   
	    //-- Carregando dados do cargo
	    carregaComboCargo(codUnidade, codCargo, tipoEdicao);
    }   