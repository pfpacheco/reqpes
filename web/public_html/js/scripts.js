var isNav4, isNav, isIE;
if (parseInt(navigator.appVersion.charAt(0)) >= 4) {
  isNav = (navigator.appName=="Netscape") ? true : false;
  isIE = (navigator.appName.indexOf("Microsoft") != -1) ? true : false;
}
if (navigator.appName=="Netscape") {
	isNav4 = (parseInt(navigator.appVersion.charAt(0))==4);
}

function Formatador(campo,tammax,teclapres) {
	var tecla = teclapres.keyCode;
	vr = campo.value;
	vr = vr.replace( "/", "" );
	vr = vr.replace( "/", "" );
	vr = vr.replace( ",", "" );
	vr = vr.replace( "", "" );
	vr = vr.replace( "", "" );
	vr = vr.replace( "", "" );
	vr = vr.replace( "", "" );
	tam = vr.length;
	if (tam < tammax && tecla != 8){ tam = vr.length + 1 ; }
	if (tecla == 8 ){	tam = tam - 1 ; }
	if ( tecla == 8 || tecla >= 48 && tecla <= 57 || tecla >= 96 && tecla <= 105 ){
	if ( tam <= 2 ){ campo.value = vr ; }
	if ( (tam > 2) && (tam <= 5) ){campo.value = vr.substr( 0, tam - 2 ) + ',' + vr.substr( tam - 2, tam ) ; }
	if ( (tam >= 6) && (tam <= 8) ){campo.value = vr.substr( 0, tam - 5 ) + '' + vr.substr( tam - 5, 3 ) + ',' + vr.substr( tam - 2, tam ) ; }
	if ( (tam >= 9) && (tam <= 11) ){campo.value = vr.substr( 0, tam - 8 ) + '' + vr.substr( tam - 8, 3 ) + '' + vr.substr( tam - 5, 3 ) + ',' + vr.substr( tam - 2, tam ) ; }
	if ( (tam >= 12) && (tam <= 14) ){campo.value = vr.substr( 0, tam - 11 ) + '' + vr.substr( tam - 11, 3 ) + '' + vr.substr( tam - 8, 3 ) + '' + vr.substr( tam - 5, 3 ) + ',' + vr.substr( tam - 2, tam ) ; }
	if ( (tam >= 15) && (tam <= 17) ){campo.value = vr.substr( 0, tam - 14 ) + '' + vr.substr( tam - 14, 3 ) + '' + vr.substr( tam - 11, 3 ) + '' + vr.substr( tam - 8, 3 ) + '' + 
		vr.substr( tam - 5, 3 ) + ',' + vr.substr( tam - 2, tam ) ;}
		}
}

function formatarOnKeyUp(OBJ){
  var decimal,inteiro;
  var i,count;
  STR = new String(OBJ.value);
  STR = tirarZerosEsquerda(STR);
  inteiro='';
  if (isIE) {
		if (STR.length == 1){
			  inteiro  = '0';
			  decimal = '0' + STR;
			}
			else { 
			  if (STR.length == 2){
				  inteiro  = '0';
				  decimal = STR;
				}
				else{
				  decimal = STR.substring(STR.length-2,STR.length);
				  i=3;
				  count=0;
				  while (i<=STR.length){
			 		if (count==3) {
					  inteiro = '' + inteiro;
					  count = 0;
					}
				    inteiro = STR.charAt(STR.length-i) + inteiro;
					count++;
					i++;
				  }
				}
			}
    
  
		if (inteiro == '') {
		  inteiro = '0';
		}
  
		if (decimal == '') {
		  decimal = '00';
		}
		OBJ.value = inteiro+','+decimal;
  }
}

function formatarOnKeyDown(OBJ){
  var decimal,inteiro;
  var i,count;
  STR = new String(OBJ.value);
  
  inteiro='';
  
  if (isIE) {	  
	if (OBJ.maxLength > STR.length){     
	  STR = tirarZerosEsquerda(STR); //ESTA FUNCAO TIRA TAMBEM PONTO E VIRGULA
	  
	  if ( ((event.keyCode > 47) && (event.keyCode < 59)) || ((event.keyCode > 95) && (event.keyCode < 106))   ){
	      
			if (STR.length == 0){
			  inteiro  = '0';
			  decimal = '0' + STR;
			}
			else { 
			  if (STR.length == 1){
			    inteiro  = '0';
			    decimal = STR;
			  }
			  else{
			    decimal = STR.substring(STR.length-1,STR.length);
			    i=2;
			    count=0;
			    while (i<=STR.length){
			 		if (count==3) {
			  	  inteiro = '.' + inteiro;
			  	  count = 0;
			  	}
			      inteiro = STR.charAt(STR.length-i) + inteiro;
			  	count++;
			  	i++;
			    }
			  }
			}   
	 
	  }
	  else{ 
	    if (event.keyCode == 8){

	      if (STR.length == 0){
			  inteiro  = '0';
			  decimal = '000';
			}
			else { 
			  if (STR.length == 1){
			    inteiro  = '0';
			    decimal = '00' + STR;
			  }
			  else { 
			    if (STR.length == 2){
		          inteiro  = '0';
			      decimal = '0' + STR;
			     }
		         else{
	 			   decimal = STR.substring(STR.length-3,STR.length);
				   i=4;
				   count=0;
				   while (i<=STR.length){
			 		 if (count==3) {
					   inteiro = '.' + inteiro;
					   count = 0;
					  }
				      inteiro = STR.charAt(STR.length-i) + inteiro;
					  count++;
					  i++;
				    }
			     }
			  } 
	      }
	    }
	    else {
	      
	      if (STR.length == 1){
		 	  inteiro  = '0';
		      decimal = '0' + STR;
			}
			else { 
			  if (STR.length == 2){
				  inteiro  = '0';
				  decimal = STR;
				}
				else{
				  decimal = STR.substring(STR.length-2,STR.length);
				  i=3;
				  count=0;
				  while (i<=STR.length){
			 		if (count==3) {
					  inteiro = '.' + inteiro;
					  count = 0;
					}
				    inteiro = STR.charAt(STR.length-i) + inteiro;
					count++;
					i++;
				  }
				}
			}        
	    }
	  }
	  
	  if (inteiro == '') {
	    inteiro = '0';
	  }
  
	  if (decimal == '') {
	    decimal = '00';
	  }
	  OBJ.value = inteiro+','+decimal;
	}
  }
}

function tirarZerosEsquerda(STR){

  var sAux='';
  var i=0;
  STR=new String(STR);
  
  while (i < STR.length ){
    if ((STR.charAt(i)!='.') && (STR.charAt(i)!=',')){
	  sAux += STR.charAt(i);
    }
	i++;
  }
  
  
  STR = new String(sAux);
  sAux = '';
  i=0;
  
  while (i < STR.length ){
    if (STR.charAt(i) != '0'){
      sAux = STR.substring(i,STR.length);
	  i = STR.length;
	}
    i++;
  }
  
  return  sAux;
}

function formataval(item)
{
	var valor = item;
    var str="";
    var j=0;
    if(valor.value!=""){
    if(range(valor)){
		alert("Por Favor digite um valor válido.");
		form.valor.focus();
		form.valor.select();
		return;
    }
    str = valor.value + ",";
    arredonda(valor);
    }
}

function checkDecimal(campo) {
	if (campo.value.length == 2)
		campo.value = '0,' + campo.value;
	if (campo.value.length == 1)
		campo.value = '0,' + campo.value + '0';
}

function onlynum(){
	if((event.keyCode<48)||(event.keyCode>57)){
		event.keyCode=0;
	}
}

function refreshCampo(obj){
	if (isIE) {
		obj.value = obj.value;
	}
}

function formata(valor) {
    var str="";
    var j=0;
    range(valor);
    if(valor.value=="") {
        valor.value="0";
    }
    str = valor.value + ",";
    arredonda(valor);
}

function arredonda(valor) {
    var j=0, str="";
    for(var i=0; (i<=valor.value.length-1)&&(valor.value.charAt(i)!=',');i++) {
        str=str+valor.value.charAt(i);
        j++;
    }
    if(valor.value.charAt(0)==',')
        str=str+"0";
    str=str + ",";
    j++;
    if(valor.value.charAt(j)=='')
        str=str+0;
    else
        str=str+valor.value.charAt(j);
    if(valor.value.charAt(j+1)=='')
        str=str+0;
    else
        str=str+valor.value.charAt(j+1);
    valor.value=str;
    str="";
    str=str+valor.value;
    valor.value=str;
}

function range(campo) {
    for(var i=0; i<=(eval(campo.value.length)-1); i++)
        if(campo.value.charAt(i)!='0' && campo.value.charAt(i)!='1' && campo.value.charAt(i)!='2'
           && campo.value.charAt(i)!='3' && campo.value.charAt(i)!='4' && campo.value.charAt(i)!='5'
           && campo.value.charAt(i)!='6' && campo.value.charAt(i)!='7' && campo.value.charAt(i)!='8'
           && campo.value.charAt(i)!='9' && campo.value.charAt(i)!=',')
        {
            alert("Valor inválido. Favor redigitar.");
            campo.value=0;
        }
}


function maskDate( Field ){
/**********************************************************************
    Função - Mascara para input de Data
	Exemplo: <input type='text' name='campo' onKeyPress='maskDate(this);'>
************************************************************************/
var tamanho = Field.value.length;
	if( tamanho == 2 ){ Field.value = Field.value + '/'; }
	else if( tamanho == 5 ){ Field.value = Field.value + '/'; }
}

function formatCurrency(num) {
  //coloca data no formatao 1.000,00
  num = num.toString().replace(/\$|\,/g,'');
  if(isNaN(num))
    num = "0";
  sign = (num == (num = Math.abs(num)));
  num = Math.floor(num*100+0.50000000001);
  cents = num%100;
  num = Math.floor(num/100).toString();
  if(cents<10)
    cents = "0" + cents;
  for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
    num = num.substring(0,num.length-(4*i+3))+'.'+
  num.substring(num.length-(4*i+3));
  return (((sign)?'':'-') + '' + num + ',' + cents);
}

function formata_numero(num, decimais){
	// transforma 1.000,00 em 1000.00 traz a qtd de decimais ou 2 decimais como default
	var valor, resultado="", ponto, qt_decimais;
	valor = new String(num);
	if (!decimais) decimais=2;
	if (valor.length>0){			
		for (cont=0;cont<valor.length;cont++){
			if (valor.charAt(cont)!="."){
				if (valor.charAt(cont)==","){			
					resultado=resultado+".";
					ponto=1;
					qt_decimais=0;
				}else{
					if (ponto==1){
						if (  eval(qt_decimais) < eval(decimais)  ){
							resultado=resultado+valor.charAt(cont);	
							qt_decimais++;			
						}					
					}else{
						resultado=resultado+valor.charAt(cont);
					}					
				}
			}
		}
		return resultado;
	}else{
		return 0;
	}
}

function formataHora(tex){
	  if(tex.value.length == 2){			
		tex.value = tex.value + ':';
	  }
}


function checkDate( Input ){
	var Data = Input.value;

	/*Expressão Regular comentada para modelo mais específico /^([0-9]{2})[\/]([0-9]{2})[\/]([0-9]{4})$/; */
	var DataRegEx = /^([012][0-9]|3[01])\/(0[1-9]|1[012])\/([0-9]{4})$/;

	if(!(Matches = Data.match(DataRegEx))){
		alert("Formato de data inválido.\nPor favor preencha o campo novamente!");
		Input.focus();
		return false;
	}

	// quebra a data em DIA, MES e ANO
	var Dia = Matches[1], Mes = Matches[2], Ano = Matches[3];

	if(Dia<1 || Dia>31){ alert("Data inválida.\nPor favor preencha o campo novamente!"); Input.focus(); return false; }
	if(Mes<1 || Mes>12){ alert("Data inválida.\nPor favor preencha o campo novamente!"); Input.focus(); return false; }
	if ((Mes==4 || Mes==6 || Mes==9 || Mes==11) && Dia>30){ alert("Data inválida.\nPor favor preencha o campo novamente!"); Input.focus(); return false; }

	if (Mes==2) {
		var Resto = (Ano % 4); 
	
		if (Resto==0 && Dia>29){ alert("Em anos bissextos, o mês de fevereiro só tem 29 dias.\nPor favor preencha o campo novamente!"); Input.focus(); return false; }
		if (Resto != 0 && Dia>28){ alert("Data inválida.\nPor favor preencha o campo novamente!"); Input.focus(); return false; }	
	}
	
	return true;
}// fim checkDate



function checkPeriodo( objFrm, dataInicio, dataTermino ){
/*********************************************************************************
	VALIDARPERIODO( FORM, DATA1, DATA2 );
		Função genérica para validação de período entre datas.
		Tem como objetivo verificar se a data de término é menor que
		a data de inicio do período.

	Exemplo de como chamar a função:
		<input type="button" name="botao" value="! validar !" onClick="checkPeriodo( frm, 'fldDataIni', 'fldDataFim' );">

	Nota: Veja que os campos aonde estão as datas são passados como string comum.
***********************************************************************************/
	var dtIni, dtFim;
	var ctlDt1, ctlDt2;
	// obter o value do campo
	var dtInicio	= eval( "objFrm." + dataInicio );
	var dtTermino	= eval( "objFrm." + dataTermino );

	// retirar a barra de separação para transformar
	// em um numero inteiro
	// ex.:  27/01/1982 - 27011982
	ctlDt1	= dtInicio.value.split("/");
	ctlDt2	= dtTermino.value.split("/");

	// para validar o período deve-se iniciar do Ano para o Dia
	dtIni	= ctlDt1[2] + ctlDt1[1] + ctlDt1[0];
	dtFim	= ctlDt2[2] + ctlDt2[1] + ctlDt2[0];

	if ( parseInt(dtIni) > parseInt(dtFim) ){
		alert( "Período inválido!\nA data final é menor que a data de inicio do período." );
		dtInicio.focus();
		return false;
	}
	return true;
}

function getSelectedRadio(buttonGroup) {
   // returns the array number of the selected radio button or -1 if no button is selected
   if (buttonGroup[0]) { // if the button group is an array (one button is not an array)
      for (var i=0; i<buttonGroup.length; i++) {
         if (buttonGroup[i].checked) {
            return i;
         }
      }
   } else {
      if (buttonGroup.checked) { return 0; } // if the one button is checked, return zero
   }
   // if we get to this point, no radio button is selected
   return -1;
} // Ends the "getSelectedRadio" function

/* passar o objeto*/
function getSelectedRadioValue(buttonGroup) {
   // returns the value of the selected radio button or "" if no button is selected
   var i = getSelectedRadio(buttonGroup);
   if (i == -1) {
      return "";
   } else {
      if (buttonGroup[i]) { // Make sure the button group is an array (not just one button)
         return buttonGroup[i].value;
      } else { // The button group is just the one button, and it is checked
         return buttonGroup.value;
      }
   }
} 

function replaceAll(string, token, newtoken) {
	while (string.indexOf(token) != -1) {
 		string = string.replace(token, newtoken);
	}
	return string;
}