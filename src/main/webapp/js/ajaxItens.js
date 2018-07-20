  //----------------------------------------------------------------------------------------------------------------		
  //-- FUNÇÃO QUE GERA PROCESSO ASSÍNCRONO (AJAX)
  //----------------------------------------------------------------------------------------------------------------		
  function createXMLHTTP(){ 
    var ajax;
    try{
      ajax = new ActiveXObject("Microsoft.XMLHTTP");
    }catch(e){
      try{
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
      }catch(ex){
        try{   
          ajax = new XMLHttpRequest();
        }catch(exc){
          alert("Esse browser não tem recursos para uso do Ajax");
          ajax = null;
        }
      }
      return ajax;
    }
    return ajax;
  }
  
  //----------------------------------------------------------------------------------------------------------------		
  function execScript(codigoHTMLcomScript){
     // Cria elemento de script
     var scriptObj = document.createElement('script');
     var iniScript = codigoHTMLcomScript.toLowerCase().indexOf('<script language=javascript>')+28;
     var fimScript = codigoHTMLcomScript.toLowerCase().indexOf('</script>');
     var scriptCode;
  
     // Copia somente o código Script da página
     scriptCode = codigoHTMLcomScript.substr(iniScript, fimScript);
     fimScript  = scriptCode.indexOf('</');
     scriptCode = scriptCode.substr(0,fimScript);
  
     // Define parâmetro language=javascript para o objeto de script 
     scriptObj.setAttribute('language', 'javascript');
  
     // Atribui o código-fonte do script ao obj de script
     scriptObj.text = scriptCode;
  
     // Executar o script
     document.body.appendChild(scriptObj);    
  }  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaComboValorSetado(P_FORM,P_COD_SEGMENTO_PAI, P_COD_SEGMENTO,P_DIV,P_VALOR_SELECIONADO, P_NOME_COMBO, P_COD_SEGMENTO3, P_COD_SEGMENTO4, P_COD_SEGMENTO5, P_COD_SEGMENTO6, P_COD_SEGMENTO7){
    
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();
       
    //-- setando os parametros 
    var parametros  = "P_COD_SEGMENTO="      + P_COD_SEGMENTO;      //-- ORDEM DO SEGMENTO
      parametros += "&P_COD_SEGMENTO_PAI="   + P_COD_SEGMENTO_PAI;  //-- codigo do segmento pai
      parametros += "&P_DIV="                + P_DIV;               //-- nome da div que recebera o retorno
      parametros += "&P_VALOR_SELECIONADO="  + P_VALOR_SELECIONADO; //-- codigo do segmento que deverá ser ficar selecionado
      parametros += "&P_NOME_COMBO="         + P_NOME_COMBO;        //-- nome do combo a ser criado
      parametros += "&COD_SEGMENTO3="        + P_COD_SEGMENTO3;     //-- nome do combo a ser criado
      parametros += "&COD_SEGMENTO4="        + P_COD_SEGMENTO4;     //-- nome do combo a ser criado
      parametros += "&COD_SEGMENTO5="        + P_COD_SEGMENTO5;     //-- nome do combo a ser criado
      parametros += "&COD_SEGMENTO6="        + P_COD_SEGMENTO6;     //-- nome do combo a ser criado
      parametros += "&COD_SEGMENTO7="        + P_COD_SEGMENTO7;     //-- nome do combo a ser criado			  			  		   	  
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getComboSegmento.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);	
  }
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaDadosUnidade(P_DIV, P_NOME_CAMPO, P_COD_UNIDADE){	         
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros   = "P_COD_UNIDADE="+ P_COD_UNIDADE;
        parametros  += "&P_NOM_CAMPO=" + P_NOME_CAMPO; 
        parametros  += "&P_DIV="       + P_DIV; 
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getDadosUnidade.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }   
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaComboCargo(P_COD_UNIDADE, P_COD_CARGO, tipoEdicao){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      

    //-- setando os parametros 
    var parametros   = "P_COD_UNIDADE="+ P_COD_UNIDADE;
        parametros  += "&P_COD_CARGO=" + P_COD_CARGO; 
        parametros  += "&tipoEdicao=" + tipoEdicao;
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getComboCargo.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById('divComboCargo').innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }       
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaHorasJornadaTrabalho(P_COD_CARGO, P_COD_UNIDADE, P_DIV){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros   = "P_COD_CARGO="    + P_COD_CARGO;
        parametros  += "&P_COD_UNIDADE=" + P_COD_UNIDADE; 
        parametros  += "&P_DIV="         + P_DIV; 
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getHorasJornadaTrabalho.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                      //-- Configurando a grade de horários
                                      setTipoHorarioTrabalho(document.getElementById('indTipoHorario').value);
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }      
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaSalarioPorCota(P_COTA, P_COD_UNIDADE, P_COD_CARGO, P_DIV){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros   = "P_COTA="         + P_COTA;
        parametros  += "&P_COD_UNIDADE=" + P_COD_UNIDADE; 
        parametros  += "&P_COD_CARGO="   + P_COD_CARGO; 
        parametros  += "&P_DIV="         + P_DIV; 
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getSalario.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }     
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaDadosClassificacaoFuncional(P_COD_CLASSIFICACAO, P_DIV){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros   = "P_COD_CLASSIFICACAO=" + P_COD_CLASSIFICACAO;
        parametros  += "&P_DIV="              + P_DIV; 
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getClassificacaoFuncional.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }      
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaPrazoContratacao(P_COD_CLASSIFICACAO, P_DIV, P_DATA_INICIO, P_DATA_FIM){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros   = "P_COD_CLASSIFICACAO=" + P_COD_CLASSIFICACAO;
        parametros  += "&P_DIV="              + P_DIV; 
        parametros  += "&P_DATA_INICIO="      + P_DATA_INICIO; 
        parametros  += "&P_DATA_FIM="         + P_DATA_FIM; 
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getPrazoContratacao.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }       
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaNomeFuncionario(P_CHAPA, P_DIV){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros   = "P_CHAPA=" + P_CHAPA;
        parametros  += "&P_DIV="  + P_DIV; 
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getNomeFuncionario.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }     
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaDataFimContratacao(P_INICIO_CONTRATACAO, P_PRAZO_CONTRATACAO, P_DIV){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
  
    //-- setando os parametros 
    var parametros   = "P_INICIO_CONTRATACAO=" + P_INICIO_CONTRATACAO;
        parametros  += "&P_PRAZO_CONTRATACAO="  + P_PRAZO_CONTRATACAO;
        parametros  += "&P_DIV="  + P_DIV;           
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getDataFimContratacao.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);      
  }     
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaDadosFuncionarioSubstituido(P_CHAPA, P_DIV){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
  
    //-- setando os parametros 
    var parametros   = "P_CHAPA="+ P_CHAPA;
        parametros  += "&P_DIV=" + P_DIV;
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getDadosFuncionarioSubstituido.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);      
  }       
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaRequisicaoByUnidade(P_DIV, P_COD_UNIDADE, P_WHERE, P_IS_RP_ANTIGA){
    var div = document.getElementById(P_DIV);    
    var img = "i" + P_DIV ;
    
    //-- setando os parametros 
    var parametros   = "P_DIV="           + P_DIV;
        parametros  += "&P_COD_UNIDADE="  + P_COD_UNIDADE;
        parametros  += "&P_WHERE="        + P_WHERE;  
        parametros  += "&P_IS_RP_ANTIGA=" + P_IS_RP_ANTIGA;  
    
    if(div.innerHTML==""){        
      var buscador = createXMLHTTP();
      
      //-- setando o destino o metodo  			  
      buscador.open("post", "../ajax/getRequisicaoByUnidade.jsp", true);
      
      //-- setando o tipo de request
      buscador.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");     
      div.innerHTML = "<br><img border='0' src='../../imagens/ico_sinc.gif'> Processando...";
      buscador.onreadystatechange=function(){                                   
                                    if(buscador.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = buscador.responseText;
                                      document.getElementById(img).src = "../../imagens/bt_menos.gif";
                                    }
                                  };
      buscador.send(parametros);
    }else{
     div.innerHTML="";
     document.getElementById(img).src = "../../imagens/bt_mais.gif";
    }        
  } 
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaNomeFuncionarioBaixado(P_CHAPA, P_DIV){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros   = "P_CHAPA=" + P_CHAPA;
        parametros  += "&P_DIV="  + P_DIV; 
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "getNomeFuncionario.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }     
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaNomeFuncionarioGerente(P_CHAPA, P_DIV){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros   = "P_CHAPA=" + P_CHAPA;
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "getNomeFuncionario.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }      
    
  
  //----------------------------------------------------------------------------------------------------------------
  function verificaIDSubstituido(chapaSubst){	 
    //-- setando os parametros 
    var parametros   = "P_CHAPA=" + chapaSubst;
  
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();
    var retorno;
    
    if(Trim(chapaSubst) != ''){	 
      //-- setando o destino o metodo  			  
      objetoAjax.open("post", "ajax/verificaSubstituido.jsp", true);		  
       
      //-- setando o tipo de request
      objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
     
      //-- setando a função
      objetoAjax.onreadystatechange=function(){  
                                       if(objetoAjax.readyState == 4){
                                          retorno = Trim(objetoAjax.responseText);
                                          if(retorno != '0'){
                                            alert('O funcionário que está sendo substituído, já foi utilizado na(s)\n seguinte(s) RP(s): '+ retorno +'.\n\nInforme o motivo da utilização do funcionário no campo "Justificativa".');
                                            document.frmRequisicao.dscMotivoSolicitacao.focus();
                                          }
                                       }
                                    };
      // -- setando o parametros para o AJAX
      objetoAjax.send(parametros);
    }
  } 
  
  
  //---------------------------------------------------------------------------------------------------------------- 
  function pesquisaEscala(qtdPorPagina, numeroDaPagina){
  
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
    var parametros   = "qtdPorPagina="     + qtdPorPagina; 
        parametros  += "&numeroDaPagina="  + numeroDaPagina; 
        parametros  += "&jornadaTrabalho=" + eval(document.frmRequisicao.jornadaTrabalho.value);     
    
    //-- setando os parametros 
    for(idx=0; idx<document.frmRequisicao.tkDia.length; idx++){  
        parametros += '&dia=' + document.frmRequisicao.tkDia[idx].value;
        parametros += '&classificacao=' + document.frmRequisicao.tkClassificacao[idx].value;
        parametros += '&entrada=' + document.frmRequisicao.tkHrEntrada[idx].value;
        parametros += '&intervalo=' + document.frmRequisicao.tkHrIntervalo[idx].value;
        parametros += '&retorno=' + document.frmRequisicao.tkHrRetorno[idx].value;
        parametros += '&saida=' + document.frmRequisicao.tkHrSaida[idx].value;
    }       
   
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getEscala.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
  
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById('divEscalaOpcao').innerHTML = objetoAjax.responseText;
                                      exibeOcultaDiv('divEscalaCarregando',false); 
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);              
    exibeOcultaDiv('divEscala',true);       
  }
   
   
  //----------------------------------------------------------------------------------------------------------------         
  function irParaPagina(qtdPorPagina, numeroDaPagina){
    //-- Paginação das escalas
    pesquisaEscala(qtdPorPagina, numeroDaPagina);
  }      
  
              
  //----------------------------------------------------------------------------------------------------------------     
  function getEscalaHorario(codEscala, isExibeDivConfirmacao){
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros  = "P_ESCALA=" + codEscala;
        parametros += "&P_EXIBE_DIV=" + isExibeDivConfirmacao;
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getEscalaHorario.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                     document.getElementById('divEscalaHorario').innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
    exibeOcultaDiv('divEscalaHorario',true);
  }   
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaComboRPPara(P_DIV, P_TIPO_RECRU, P_COD_RP_PARA){
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
  
    //-- setando os parametros 
    var parametros   = "P_TIPO_RECRU="  + P_TIPO_RECRU;
        parametros  += "&P_COD_RP_PARA="+ P_COD_RP_PARA;
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getComboRPPara.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }          
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaComboMotivoSolicitacao(P_DIV, P_TIPO_RECRU, P_COD_MOTIVO_SOLICITACAO, P_RPPARA){
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
  
    //-- setando os parametros 
    var parametros   = "P_TIPO_RECRU="+P_TIPO_RECRU;
        parametros  += "&P_COD_MOTIVO_SOLICITACAO="+P_COD_MOTIVO_SOLICITACAO;
        parametros  += "&P_RPPARA="+P_RPPARA;
        
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getComboMotivoSolicitacao.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById(P_DIV).innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }     
  
  
  //----------------------------------------------------------------------------------------------------------------
  function getIdCalendario(P_UNIDADE, P_ESCALA, P_IND_SEG, P_IND_TER, P_IND_QUA, P_IND_QUI, P_IND_SEX, P_IND_SAB, P_IND_DOM){
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros  =  "P_UNIDADE=" + P_UNIDADE; 
        parametros += "&P_ESCALA="  + P_ESCALA;
        parametros += "&P_IND_SEG=" + P_IND_SEG; 
        parametros += "&P_IND_TER=" + P_IND_TER; 
        parametros += "&P_IND_QUA=" + P_IND_QUA; 
        parametros += "&P_IND_QUI=" + P_IND_QUI; 
        parametros += "&P_IND_SEX=" + P_IND_SEX; 
        parametros += "&P_IND_SAB=" + P_IND_SAB; 
        parametros += "&P_IND_DOM=" + P_IND_DOM;
        parametros += "&P_COD_CALENDARIO=" + document.getElementById('codCalendario').value;
        
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getCalendario.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){                               
                                       document.getElementById('divIdCalendario').innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }
  
  
  //----------------------------------------------------------------------------------------------------------------
  function getCota(P_IND_EXCECAO, P_COD_UNIDADE, P_COD_CARGO, P_COD_TAB_SALARIAL, P_SEGMENTO4, tipoEdicao){	 
	  
	if(tipoEdicao === undefined){
		tipoEdicao = 0;
  	}  
	  
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros  = "P_IND_EXCECAO="       + P_IND_EXCECAO;
        parametros += "&P_COD_UNIDADE="      + P_COD_UNIDADE;
        parametros += "&P_COD_CARGO="        + P_COD_CARGO;
        parametros += "&P_COD_TAB_SALARIAL=" + P_COD_TAB_SALARIAL;
        parametros += "&P_SEGMENTO4="        + P_SEGMENTO4;
        parametros += "&tipoEdicao="	     + tipoEdicao;
        
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getCotaCargo.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                       var retorno = objetoAjax.responseText;
                                       var cota    = document.getElementById('cotaCargo');
                                       
                                       if(Trim(retorno) == '-1'){                                          
                                          if(P_IND_EXCECAO == 'N'){ 
                                            cota.setAttribute('readOnly','readOnly');
                                            alert('De acordo com a Instrução 04/2011 não é permitido contratar o cargo selecionado, verifique\na instrução e selecione o cargo correto.');
                                            //-- limpando valores dos campos
                                            limpaCargoConfig();
                                            document.frmRequisicao.codCargo.focus();
                                          }else{
                                            cota.removeAttribute('readOnly');                                          
                                          }
                                       }else{
                                          cota.value = retorno;
                                          cota.setAttribute('readOnly','readOnly');
                                          getSalarioPorCota(retorno, tipoEdicao);
                                       }
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }    
  
  
  //----------------------------------------------------------------------------------------------------------------
  function carregaComboCargoInstrucao(P_COD_TABELA_SALARIAL, P_COD_CARGO, P_COD_INSTRUCAO){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
  
    //-- setando os parametros 
    var parametros   = "P_COD_TABELA_SALARIAL="+ P_COD_TABELA_SALARIAL;
        parametros  += "&P_COD_CARGO="     + P_COD_CARGO; 
        parametros  += "&P_COD_INSTRUCAO=" + P_COD_INSTRUCAO; 
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getComboCargo.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById('divComboCargo').innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }
  
  //----------------------------------------------------------------------------------------------------------------
  function verificaCargoUnidade(codUnidade, codCargo, tipoEdicao){	   
	  
	if(tipoEdicao === undefined){
		tipoEdicao = 0;
	}   
	  	  
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();
    
    //-- setando os parametros 
    var parametros = "P_COD_UNIDADE=" + codUnidade;    
    
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/verificaCargoUnidade.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      var retorno   = Trim(objetoAjax.responseText);
                                      
                                      if(tipoEdicao > 0)
                                    	var segmento4 = document.getElementById('cc').nextSibling.nextSibling.textContent.split('.')[3];
                                      else
                                        var segmento4 = document.getElementById('idsegmento4').value;
                                      
                                      var tipo = (document.frmRequisicao.indCaraterExcecao[0].checked)?'N':'S';
                                      
                                      //-- Validando exceção de cargo
                                        //-- Cargo: 8473 - ASSISTENTE TECNICO ADMINISTRATIVO I
                                        //-- Area/Subarea: 0101 - APOIO ADMINISTRATIVO          
                                      if(codCargo == '8473'){
                                        if(segmento4 == '0101' && retorno == 'S'){
                                          exibeOcultaDiv('divAreaAdministrativa', true);
                                          document.getElementById('indCargoAdministrativo').value = 'S';
                                        }else{
                                          setCota((document.frmRequisicao.indCaraterExcecao[0].checked)?'N':'S', tipoEdicao);                                        
                                        }
                                      }else{
                                        exibeOcultaDiv('divAreaAdministrativa', false);
                                        document.getElementById('indCargoAdministrativo').value = 'N';                                      
                                        setCota((document.frmRequisicao.indCaraterExcecao[0].checked)?'N':'S', tipoEdicao);
                                      }
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }
  
  //----------------------------------------------------------------------------------------------------------------
  function getListInstrucao(P_PAGINA, P_QTD_PAGINA){
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
       
    //-- setando os parametros 
    var parametros  = "P_TAB_SALARIAL=" + document.getElementById('codTabela').value;
        parametros += "&P_CARGO=" + document.getElementById('codCargo').value;
        parametros += "&P_UNIDADE=" + document.getElementById('codUnidade').value;
        parametros += "&P_PAGINA=" + P_PAGINA;          
        parametros += "&P_QTD_PAGINA=" + P_QTD_PAGINA;
        
    var div = document.getElementById('divListInstrucao');
    
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getListInstrucao.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
    div.innerHTML = "<br><img border='0' src='../../imagens/ico_sinc.gif'> Processando...";
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
			                        if(objetoAjax.readyState==4){
			                          div.innerHTML = objetoAjax.responseText;
			                        }
			                      };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }   
  
  //----------------------------------------------------------------------------------------------------------------
  function getComboFuncionarios(P_COD_UNIDADE){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
  
    //-- setando os parametros 
    var parametros = "P_COD_UNIDADE="+ P_COD_UNIDADE;
  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getFuncionarios.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                      document.getElementById('divFuncionarios').innerHTML = objetoAjax.responseText;
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send(parametros);
  }  
  
  //----------------------------------------------------------------------------------------------------------------
  function getIdCodeCombination(P_SEGMENTO1, P_SEGMENTO2, P_SEGMENTO3, P_SEGMENTO4, P_SEGMENTO5, P_SEGMENTO6, P_SEGMENTO7){	 
    //-- lendo o componente ajax
    var objetoAjax = createXMLHTTP();      
  
    //-- setando os parametros 
	var centroCusto = P_SEGMENTO1 +'.'+ P_SEGMENTO2 +'.'+ P_SEGMENTO3 +'.'+ P_SEGMENTO4 +'.'+ P_SEGMENTO5 +'.'+ P_SEGMENTO6 +'.'+ P_SEGMENTO7;
	  
    //-- setando o destino o metodo  			  
    objetoAjax.open("post", "ajax/getIdCodeCombination.jsp", true);		  
     
    //-- setando o tipo de request
    objetoAjax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");		  
   
    //-- setando a função
    objetoAjax.onreadystatechange=function(){  
                                    if(objetoAjax.readyState == 4){
                                    	var retorno = Trim(objetoAjax.responseText).split("|");
                                    	if(parseFloat(retorno[0]) > 0){
                                    		//-- Sucesso                                    		
                                    		exibeOcultaDiv('divDados', true);
                                    		document.getElementById('idCodeCombination').value = retorno[0];
                                    	}else if(retorno[0] == '-1'){
                                    			  //-- Erro no sistema
                                    			  alert('Ocorreu o seguinte erro na tentativa de criação da combinação:\n\n'+ retorno[1]);
                                    			  exibeOcultaDiv('divDados', false);
                                    			  document.getElementById('idCodeCombination').value = '0';
                                    		  }else{
                                    			  //-- Mensagem de erro retornada pela API
                                    			  alert('O Centro de Custo '+ centroCusto +' é inválido!\nFavor entrar em contato com a GEF - Equipe Orçamentária informando a mensagem de erro abaixo:\n\n'+ retorno[1]);
                                    			  exibeOcultaDiv('divDados', false);
                                    			  document.getElementById('idCodeCombination').value = '0';
                                    		  }
                                    }
                                  };
    // -- setando o parametros para o AJAX
    objetoAjax.send('centroCusto='+ centroCusto);
  }