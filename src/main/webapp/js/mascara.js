function popUP(url, nome, settings){
    var  w, h, left, top;
    w= window.screen.width;
    h= window.screen.height;    
        
    left =(w-660)/2;
    top  =(h-600)/2;
    
    settings+=",left="+left+",top="+top;
    
    window.open(url, nome, settings);
}

 //Verifica qual o browser do visitante e armazena na variável pública clientNavigator,
 //Caso Internet Explorer(IE) outros (Other)
 if (navigator.appName.indexOf('Microsoft') != -1){
 	clientNavigator = "IE";
 }else{
 	clientNavigator = "Other";
 }
 
 function Verifica_Data(data, obrigatorio){
 //Se o parâmetro obrigatório for igual á zero, significa que elepode estar vazio, caso contrário, não
  var data = document.getElementById(data);
 	var strdata = data.value;
 	if((obrigatorio == 1) || (obrigatorio == 0 && strdata != "")){
 		//Verifica a quantidade de digitos informada esta correta.
 		if (strdata.length != 10){
 			alert("Formato da data não é válido.\nFormato correto: dd/mm/aaaa.");
 			setTimeout(function(){data.focus();},300);
 			return false; 			
 		}
 		//Verifica máscara da data
 		if ("/" != strdata.substr(2,1) || "/" != strdata.substr(5,1)){
 			alert("Formato da data não é válido.\nFormato correto: dd/mm/aaaa.");
 			setTimeout(function(){data.focus();},300);
 			return false; 			
 		}
 		dia = strdata.substr(0,2);
 		mes = strdata.substr(3,2);
 		ano = strdata.substr(6,4);
 		//Verifica o dia
 		if (isNaN(dia) || dia > 31 || dia < 1){
 			alert("Formato do dia não é válido.");
 			setTimeout(function(){data.focus();},300);
 			return false;
 		}
 		if (mes == 4 || mes == 6 || mes == 9 || mes == 11){
 			if (dia == "31"){
 				alert("O mês informado não possui 31 dias.");
 				setTimeout(function(){data.focus();},300);
 				return false;
 			}
 		}
 		if (mes == "02"){
 			bissexto = ano % 4;
 			if (bissexto == 0){
 				if (dia > 29){
 					alert("O mês informado possui somente 29 dias.");
 					setTimeout(function(){data.focus();},300);
 					return false;
 				}
 			}else{
 				if (dia > 28){
 					alert("O mês informado possui somente 28 dias.");
 					setTimeout(function(){data.focus();},300);
 					return false;
 				}
 			}
 		}
 	//Verifica o mês
 		if (isNaN(mes) || mes > 12 || mes < 1){
 			alert("Formato do mês não é válido.");
 			setTimeout(function(){data.focus();},300);
 			return false;
 		}
 		//Verifica o ano
 		if (isNaN(ano)){
 			alert("Formato do ano não é válido.");
 			setTimeout(function(){data.focus();},300);
 			return false;
 		}
 	}
  
 	return true;
 }
 
 function Verifica_Data_Mes(data, obrigatorio){
 //Se o parâmetro obrigatório for igual a zero, significa que elepode estar vazio, caso contrário, não
  var data = document.getElementById(data);
 	var strdata = '01/' + data.value;
 	if((obrigatorio == 1) || (obrigatorio == 0 && strdata != "")){
 		//Verifica a quantidade de digitos informada esta correta.
 		if (strdata.length != 10){
 			alert("Formato da data inválido.\nFormato correto: mm/aaaa.");
 			data.focus();
 			return false;
 		}
 		//Verifica máscara da data
 		if ("/" != strdata.substr(2,1) || "/" != strdata.substr(5,1)){
 			alert("Formato da data inválido.\nFormato correto: mm/aaaa.");
 			data.focus();
 			return false;
 		}
 		dia = strdata.substr(0,2);
 		mes = strdata.substr(3,2);
 		ano = strdata.substr(6,4);
 		//Verifica o dia
 		if (isNaN(dia) || dia > 31 || dia < 1){
 			alert("Formato do dia não é válido.");
 			data.focus();
 			return false;
 		}
 		if (mes == 4 || mes == 6 || mes == 9 || mes == 11){
 			if (dia == "31"){
 				alert("O mês informado não possui 31 dias.");
 				data.focus();
 				return false;
 			}
 		}
 		if (mes == "02"){
 			bissexto = ano % 4;
 			if (bissexto == 0){
 				if (dia > 29){
 					alert("O mês informado possui somente 29 dias.");
 					data.focus();
 					return false;
 				}
 			}else{
 				if (dia > 28){
 					alert("O mês informado possui somente 28 dias.");
 					data.focus();
 					return false;
 				}
 			}
 		}
 	//Verifica o mês
 		if (isNaN(mes) || mes > 12 || mes < 1){
 			alert("Formato do mês não é válido.");
 			data.focus();
 			return false;
 		}
 		//Verifica o ano
 		if (isNaN(ano)){
 			alert("Formato do ano não é válido.");
 			data.focus();
 			return false;
 		}
 	}
  return true;
 }  
 
 function Compara_Datas(data_inicial, data_final){
 	//Verifica se a data inicial é maior que a data final
    
	if(!(Verifica_Data(data_inicial,1)&&Verifica_Data(data_final,1))){
	  return false;
	}
		
 	var data_inicial = document.getElementById(data_inicial);
 	var data_final   = document.getElementById(data_final);
	
	
 	str_data_inicial = data_inicial.value;
 	str_data_final   = data_final.value;
 	dia_inicial      = data_inicial.value.substr(0,2);
 	dia_final        = data_final.value.substr(0,2);
 	mes_inicial      = data_inicial.value.substr(3,2);
 	mes_final        = data_final.value.substr(3,2);
 	ano_inicial      = data_inicial.value.substr(6,4);
 	ano_final        = data_final.value.substr(6,4);
	
 	if(ano_inicial > ano_final){
 	   alert("A data inicial deve ser menor que a data final."); 
 	   data_inicial.focus();
 	   return false;
 	}else{
  	   if(ano_inicial == ano_final){
   	      if(mes_inicial > mes_final){
    	     alert("A data inicial deve ser menor que a data final.");
 			 data_final.focus();
 			 return false;
 		  }else{
 		     if(mes_inicial == mes_final){
 			    if(dia_inicial > dia_final){
 				   alert("A data inicial deve ser menor que a data final.");
 				      data_final.focus();
 					  return false;
 				}
 			 }else{
			   return true;
			 }
 		  }
 	   }else{
	     return true;
	   }
 	}
 }
 
 function Verifica_Hora(hora, obrigatorio){
 //Se o parâmetro obrigatório for igual a zero, significa que elepode estar vazio, caso contrário, não
 	var hora = document.getElementById(hora);
 	if((obrigatorio == 1) || (obrigatorio == 0 && hora.value != "")){
 		if(hora.value.length < 5){
 			alert("Formato da hora inválido.Por favor, informe a hora no formato correto: hh:mm");
 			hora.focus();
 			return false;
 		}
 		if(hora.value.substr(0,2) > 23 || isNaN(hora.value.substr(0,2))){
 			alert("Formato da hora inválido.");
 			hora.focus();
 			return false;
 		}
 		if(hora.value.substr(3,2) > 59 || isNaN(hora.value.substr(3,2))){
 			alert("Formato do minuto inválido.");
 			hora.focus();
 			return false;
 		}
 	}
 }
 
 function Verifica_Email(email, obrigatorio){
 //Se o parâmetro obrigatório for igual a zero, significa que elepode estar vazio, caso contrário, não
 	var email = document.getElementById(email);
 	if((obrigatorio == 1) || (obrigatorio == 0 && email.value != "")){
 		if(!email.value.match(/([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+.[a-zA-Z0-9._-]+)/gi)){
 			alert("Informe um e-mail válido");
 			email.focus();
 			return false;
 		}
 	}
 }
 
 function Verifica_Tamanho(campo, tamanho){
 //usado para campos textarea onde não se tem o atributo maxlenght
 	var campo = document.getElementById(campo);
 	if(campo.value.length > tamanho){
 		alert("O campo suporta no máximo " + tamanho + " caracteres.");
 		campo.focus();
 		return false;
 	}
 }
 
 function Verifica_Cep(cep, obrigatorio){
 //Se o parâmetro obrigatório for igual a zero, significa que elepode estar vazio, caso contrário, não
 	var cep    = document.getElementById(cep);
 	var strcep = cep.value;
 	if((obrigatorio == 1) || (obrigatorio == 0 && strcep != "")){
 		if (strcep.length != 9){
 			alert("CEP informado inválido.");
 			cep.focus();
 			return false;
 		}else{
 			if (strcep.indexOf("-") != 5){
 				alert("Formato de CEP informado inválido.");
 				cep.focus();
 				return false;
 			}else{
 				if (isNaN(strcep.replace("-","0"))){
 					alert("CEP informado inválido.");
 					cep.focus();
 					return false;
 				}
 			}
 		}
 	}	  
 }
 

 
 function Ajusta_Data(input, evnt){
 //Ajusta máscara de Data e só permite digitação de números
 	if (input.value.length == 2 || input.value.length == 5){
 		if(clientNavigator == "IE"){
 			input.value += "/";
 		}else{
 			if(evnt.keyCode == 0){
 				input.value += "/";
 			}
 		}
 	}
 //Chama a função Bloqueia_Caracteres para só permitir a digitação de números
 	return Bloqueia_Caracteres(evnt);
 }

 function Ajusta_Data_Mes(input, evnt){
 //Ajusta máscara de Data e só permite digitação de números ex: 02/2010
 	if (input.value.length == 2){
 		if(clientNavigator == "IE"){
 			input.value += "/";
 		}else{
 			if(evnt.keyCode == 0){
 				input.value += "/";
 			}
 		}
 	}
 //Chama a função Bloqueia_Caracteres para só permitir a digitação de números
 	return Bloqueia_Caracteres(evnt);
 }

 function Ajusta_Hora(input, evnt){
 //Ajusta máscara de HORA e só permite digitação de números
 	if (input.value.length == 2){
 		if(clientNavigator == "IE"){
 			input.value += ":";
 		}else{
 			if(evnt.keyCode == 0){
 				input.value += ":";
 			}
 		}
 	}
 //Chama a função Bloqueia_Caracteres para só permitir a digitação de números
 	return Bloqueia_Caracteres(evnt);
 }
 
 function Bloqueia_Caracteres(evnt){
 //Função permite digitação de números
 	if (clientNavigator == "IE"){
 		if (evnt.keyCode < 48 || evnt.keyCode > 57){
 			return false;
 		}
 	}else{
 		if ((evnt.charCode < 48 || evnt.charCode > 57) && evnt.keyCode == 0){
 			return false;
 		}
 	}
 }

 function maskJornadaTrabalho(evnt){
  //Função permite digitação de números e "."
 	if (clientNavigator == "IE"){
 		if (evnt.keyCode < 46 || evnt.keyCode == 47 || evnt.keyCode > 57){
 			return false;
 		}
 	}else{
 		if ((evnt.keyCode < 46 || evnt.keyCode == 47 || evnt.keyCode > 57) && evnt.keyCode == 0){
 			return false;
 		}
 	}
 }
 
 function Ajusta_Hora(input, evnt){
 //Ajusta máscara de Hora e só permite digitação de números
 	if (input.value.length == 2){
 		if(clientNavigator == "IE"){
 			input.value += ":";
 		}else{
 			if(evnt.keyCode == 0){
 				input.value += ":";
 			}
 		}
 	}
 //Chama a função Bloqueia_Caracteres para só permitir a digitação de números
 	return Bloqueia_Caracteres(evnt);
 }
 
 function Ajusta_Cep(input, evnt){
 //Ajusta máscara de CEP e só permite digitação de números
 	if (input.value.length == 5){
 		if(clientNavigator == "IE"){
 			input.value += "-";
 		}else{
 			if(evnt.keyCode == 0){
 				input.value += "-";
 			}
 		}
 	}
 //Chama a função Bloqueia_Caracteres para só permitir a digitação de números
 	return Bloqueia_Caracteres(evnt);
 }
 
 function Atualiza_Opener(){
 //Atualiza a página opener da popup que chamar a função
 	window.opener.location.reload();
 }

 function Mascara(objeto, evt, mask) {
  var LetrasU = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  var LetrasL = 'abcdefghijklmnopqrstuvwxyz';
  var Letras  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  var Numeros = '0123456789';
  var Fixos  = '().-:/ '; 
  var Charset = " !\'#$%&\()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_/`abcdefghijklmnopqrstuvwxyz{|}~";

  evt = (evt) ? evt : (window.event) ? window.event : "";
  var value = objeto.value;
  if(evt){
    var ntecla = (evt.which) ? evt.which : evt.keyCode;
    tecla = Charset.substr(ntecla - 32, 1);
    if (ntecla < 32) return true;
  
    var tamanho = value.length;
    if (tamanho >= mask.length) return false;
  
    var pos = mask.substr(tamanho,1); 
   
    while (Fixos.indexOf(pos) != -1){
     value += pos;
     tamanho = value.length;
     if (tamanho >= mask.length) return false;
     pos = mask.substr(tamanho,1);
    }
  
    switch(pos){
      case '#' : if (Numeros.indexOf(tecla) == -1) return false; break;
      case 'A' : if (LetrasU.indexOf(tecla) == -1) return false; break;
      case 'a' : if (LetrasL.indexOf(tecla) == -1) return false; break;
      case 'Z' : if (Letras.indexOf(tecla) == -1) return false; break;
      case '*' : objeto.value = value; return true; break;
      default : return false; break;
    }
  }
  objeto.value = value; 
  return true;
 }

  function MaskCEP(objeto, evt) { 
  return Mascara(objeto, evt, '##.###-###');
  }
  
  function MaskMoney(objeto, evt) { 
  return Mascara(objeto, evt, '###.###,##');
  }
  
  function MaskTelefone(objeto, evt) { 
  return Mascara(objeto, evt, '(##) ####-####');
  }
  
  function MaskCPF(objeto, evt) { 
  return Mascara(objeto, evt, '###.###.###-##');
  }
  
  function MaskPlacaCarro(objeto, evt) { 
  return Mascara(objeto, evt, 'AAA-####');
  }
  
  function FormataValor(campo,tammax,teclapres) {
  var tecla = teclapres.keyCode;
  vr = campo.value;
  vr = vr.replace( "/", "" );
  vr = vr.replace( "/", "" );
  vr = vr.replace( ",", "" );
  vr = vr.replace( ".", "" );
  vr = vr.replace( ".", "" );
  vr = vr.replace( ".", "" );
  vr = vr.replace( ".", "" );
  tam = vr.length;
  if (tam < tammax && tecla != 8){ tam = vr.length + 1; }
  if (tecla == 8 ){ tam = tam - 1; }
  if ( tecla == 8 || tecla >= 48 && tecla <= 57 || tecla >= 96 && tecla <= 105 ){
  if ( tam <= 2 ){ 
  campo.value = vr; }
  if ( (tam > 2) && (tam <= 5) ){
  campo.value = vr.substr( 0, tam - 2 ) + ',' + vr.substr( tam - 2, tam ); }
  if ( (tam >= 6) && (tam <= 8) ){
  campo.value = vr.substr( 0, tam - 5 ) + '.' + vr.substr( tam - 5, 3 ) + ',' + vr.substr( tam - 2, tam ); }
  if ( (tam >= 9) && (tam <= 11) ){
  campo.value = vr.substr( 0, tam - 8 ) + '.' + vr.substr( tam - 8, 3 ) + '.' + vr.substr( tam - 5, 3 ) + ',' + vr.substr( tam - 2, tam ); }
  if ( (tam >= 12) && (tam <= 14) ){
  campo.value = vr.substr( 0, tam - 11 ) + '.' + vr.substr( tam - 11, 3 ) + '.' + vr.substr( tam - 8, 3 ) + '.' + vr.substr( tam - 5, 3 ) + ',' + vr.substr( tam - 2, tam ); }
  if ( (tam >= 15) && (tam <= 17) ){
  campo.value = vr.substr( 0, tam - 14 ) + '.' + vr.substr( tam - 14, 3 ) + '.' + vr.substr( tam - 11, 3 ) + '.' + vr.substr( tam - 8, 3 ) + '.' + vr.substr( tam - 5, 3 ) + ',' + vr.substr( tam - 2, tam );}
  }
}

/*
É só salvar esse blocão de texto num arquivo funcoes.js por exemplo e "importar" ele nas páginas(pra quem não sabe <script language="JavaScript" type="text/javascript" src="../inc/funcoes.js"></script> ) que desejarem usar as funções...pra utilizar é bem simples...nas de validação é só adicionar algo do tipo 
if(Verifica_Cep("cep", 0) == false){ return false } 
if(Verifica_Email("email", 0) == false){ return false } 
if(Verifica_Data("data_nascimento", 1) == false){ return false } 

dentro da validação principal da sua página...ficaria algo do tipo 

Code:

function Valida(){
 	if(document.formulario.nome.value == ""){
 		alert("Preencha o nome da pessoa");
 	}
 	if(Verifica_Data("data_nascimento", 1) == false){ return false }
 	if(Verifica_Hora("hora_compromisso", 1) == false){ return false }
 	if(Verifica_Cep("cep", 0) == false){ return false }
 	if(Verifica_Email("email", 0) == false){ return false }
 	if(Verifica_Email("descricao", 4000) == false){ return false }
 }
 
 <input name="data" type="text" id="data" maxlength="10" onKeypress="return Ajusta_Data(this, event);"> 
 <input name="hora" type="text" id="hora" maxlength="5" onKeypress="return Ajusta_Hora(this, event);"> 
 <input name="cep" type="text" id="cep" maxlength="9" onKeypress="return Ajusta_Cep(this, event);">
 <input name="numero" type="text" id="numero" maxlength="20" onKeypress="return Bloqueia_Caracteres(event);"">
 
*/
