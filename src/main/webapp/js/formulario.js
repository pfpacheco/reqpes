// hex2rgb -> traduz uma cor definida em Hexadecimal para o sistema RGB
// str -> cor em hexadecimal
// cssret -> se definido como true, ao invés de retornar um objeto, a função 
//           retornará uma string assim: 120, 120, 120
  function hex2rgb(str, cssret){
    var ret = {}, hexStr = str.replace(/^#?/,""); 
    if(/^([\dA-Fa-f]{2})([\dA-Fa-f]{2})([\dA-Fa-f]{2})$/.test(hexStr))
    ret.r = parseInt("0x" + RegExp.$1);
    ret.g = parseInt("0x" + RegExp.$2);
    ret.b = parseInt("0x" + RegExp.$3); 
    return cssret ? +ret.r+','+ret.g+','+ret.b : ret;
  } 
  
//--
   function alertaEmail(){         
     alert('Nenhum colaborador associado!');
   }
//--
   function janelaEmail(condicao){         
     window.open('../../email/index.jsp?'+condicao,'email','resizable,toolbar=no,statusbar=no,scrollbars=yes,width=650; height=500');
   }
//--
  function isArray(obj){
    if(obj.length==null){
      return false;
    }else{
       return true;
    }
  }
//--
function controlaTagSpan(id,mostrar){
  var idSpam = document.getElementById(id);
  if( mostrar){
    idSpam.style.visibility="visible";
  }else{
    idSpam.style.visibility="hidden";
  }
}
//--
//function limitarCaracteres(origem,mostrador,maximoCaracter){
//    if(origem.value.length>maximoCaracter){
//      alert("Neste campo a quantidade máxima de caracteres é " + maximoCaracter);
//      origem.value =origem.value.substr(0,maximoCaracter);
//    }
//    mostrador.value = origem.value.length;
//}
function limitarCaracteres(origem,mostrador,maximoCaracter,nomeCampo){
	var ret = true;
    if(origem.value.length>maximoCaracter){
    	if (nomeCampo)
    		alert("A quantidade de caracteres inseridos no campo \"" + nomeCampo + "\" ultrapassa o máximo permitido (" + maximoCaracter + " caracteres).");
    	else
    		alert("Neste campo a quantidade máxima de caracteres é " + maximoCaracter);
      origem.value =origem.value.substr(0,maximoCaracter);
      ret = false;
    }
    mostrador.value = origem.value.length;
    return ret;
}
//---
function controlaGrupos(id,imagemAbre,imagemFecha) {
  var div = getElemRefs(id);
  if(div.css.visibility == ""){
    escondeGrupo(id,imagemAbre);
  }else{
    if(div.css.visibility == "hidden"){
      mostraGrupo(id,imagemFecha);
    }else{
      escondeGrupo(id,imagemAbre);
    }
  }         
}
//---
function mostraGrupo(id,imagem) {
  var lyr = getElemRefs(id);
  var img = "i" + id;
  if (lyr && lyr.css){
    lyr.css.visibility = "visible";
    lyr.css.display = "";
    getElemRefs(img).src = imagem;
    getElemRefs(img).alt = "Clique para minimizar";
  }
}
//---
function escondeGrupo(id,imagem) {
  var lyr = getElemRefs(id);
  var img = "i" + id;
  if (lyr && lyr.css){
    lyr.css.visibility = "hidden";
    lyr.css.display = "none";
    getElemRefs(img).src = imagem;
    getElemRefs(img).alt = "Clique para maximizar";
  }
}      
//---
function getElemRefs(id) {
  var el = (document.getElementById)? document.getElementById(id): (document.all)? document.all[id]: (document.layers)? getLyrRef(id,document): null;
  if (el) el.css = (el.style)? el.style: el;
  return el;
}
//--
function validarRadio(obj,mensagem){
  for(i=0;i<obj.length;i++){
    if (obj[i].checked){
      return true;
    }
  }
  alert(mensagem);
  return false;
}

//---
function decode(obj,mensagem,opcao1){
  if(obj.value!=null){
    obj.value = Trim(obj.value);
  }
  var valido = true;
  if(obj.value != opcao1){
    return true;
  }else{
    alert(mensagem);
    if(obj.type != "RADIO"){
      obj.focus();
    }
    return false;
  }
}
//---
function decodeDuplo(obj,mensagem,opcao1,opcao2){
  if(obj.value!=null){
    obj.value = Trim(obj.value);
  }
  
  var valido = true;
  if(obj.value == opcao1){
    valido = false;
  }else{
     if(opcao2!="IGNORAR" && obj.value == opcao2){
       valido = false;
     }
  }
  if(valido){
    return true;
  }else{
    alert(mensagem);
    if(!obj.type =="RADIO"){
      obj.focus();
    }
    return false;
  }
}
//--
function decodeTriplo(obj,mensagem,opcao1,opcao2,opcao3){
  var valido = true;
  if(obj.value!=null){
    obj.value = Trim(obj.value);
  }
  if(obj.value == opcao1){
    valido = false;
  }else{
     if(opcao2!="IGNORAR" && obj.value == opcao2){
       valido = false;
     }else{
       if(opcao2!="IGNORAR" && obj.value == opcao3){
         valido = false;
       }
     }
  }
  if(valido){
    return true;
  }else{
    alert(mensagem);
    if(!obj.type =="RADIO"){
      obj.focus();
    }
    return false;
  }
}
//--
function Trim(valor){
	return valor.replace(/^\s*/, "").replace(/\s*$/, "");
} 
//--
function decodeComplexo(obj,mensagem,tamanhoMinimo,nomeCampo,opcao1,opcao2,opcao3){
  var valido = true;
  if(obj.value!=null){
    obj.value = Trim(obj.value);
  }
  if(obj.value == opcao1){
    valido = false;
  }else{
     if(obj.value.length < eval(tamanhoMinimo) ){
       valido   = false;
       mensagem = "Quantidade mínima de caracter para o campo " + nomeCampo + " é " +  tamanhoMinimo + " caracteres.";
     }else{
       if(opcao2!="IGNORAR" && obj.value == opcao2){
         valido = false;
       }else{
         if(opcao2!="IGNORAR" && obj.value == opcao3){
           valido = false;
         }
       }
     }
  }
  if(valido){
    return true;
  }else{
    alert(mensagem);
    if(!obj.type =="RADIO"){
      obj.focus();
    }
    return false;
  }
}
//--
function insereLinhaTable(id,idInput,valor){
  var x=document.getElementById(id).insertRow(2);
  var y=x.insertCell(0);
  var z=x.insertCell(1);
  y.innerHTML= valor + "<input name='tipoContato' type='hidden' value='" + valor + "'>";
  z.innerHTML="<input name='i" + idInput + "' class='input' value=''>";
}
//--
function getLabelSelect(objSelect){
  return objSelect[objSelect.selectedIndex].text;
}
//--
function somenteNumeros(evento){
 if ((evento.keyCode < 48)||(evento.keyCode > 57)){
  alert("Digitar somente números!");
  evento.returnValue= false;
 }
}

//--
function Del()
{

    var cont=0;
    cont = isAnyChecked(document.enquete);
	
	if(cont==0){
		alert('Selecione uma opção');
		return false;
    }
}

 

function isAnyChecked(F){

    var chkcount = 0; // contador de checkboxes ticados
    for (i=0;i<F.length;i++) {
        if (F.elements[i].type == "radio" && F.elements[i].checked == true) {
            chkcount++;
            //alert(" foi selecionado pelo menos um checkbox" + chkcount);
        }
    }
   return chkcount;
}

function isCNPJ(parametroCNPJ) {
CNPJ = parametroCNPJ.value;
erro = new String;
if (CNPJ.length < 14) erro += "é necessario preencher corretamente o número do CNPJ! \n\n";
/*if ((CNPJ.charAt(2) != ".") || (CNPJ.charAt(6) != ".") || (CNPJ.charAt(10) != "/") || (CNPJ.charAt(15) != "-")){
if (erro.length == 0) erro += "é necessario preencher corretamente o numero do CNPJ! \n\n";
}*/
//substituir os caracteres que nao sao numeros
if(document.layers && parseInt(navigator.appVersion) == 4){
x = CNPJ.substring(0,2);
x += CNPJ.substring(3,6);
x += CNPJ.substring(7,10);
x += CNPJ.substring(11,15);
x += CNPJ.substring(16,18);
CNPJ = x; 
} else {
CNPJ = CNPJ.replace(".","");
CNPJ = CNPJ.replace(".","");
CNPJ = CNPJ.replace("-","");
CNPJ = CNPJ.replace("/","");
}
var nonNumbers = /\D/;
if (nonNumbers.test(CNPJ)) erro += "A verificacao de CNPJ suporta apenas números! \n\n"; 
var a = [];
var b = new Number;
var c = [6,5,4,3,2,9,8,7,6,5,4,3,2];
for (i=0; i<12; i++){
a[i] = CNPJ.charAt(i);
b += a[i] * c[i+1];
}
if ((x = b % 11) < 2) { a[12] = 0; } else { a[12] = 11-x; }
b = 0;
for (y=0; y<13; y++) {
b += (a[y] * c[y]); 
}
if ((x = b % 11) < 2) { a[13] = 0; } else { a[13] = 11-x; }
if ((CNPJ.charAt(12) != a[12]) || (CNPJ.charAt(13) != a[13])){
erro +="CNPJ inválido!\nDigito verificador com problema!";
}
if (erro.length > 0){
  alert(erro);
  parametroCNPJ.focus();
  return false;
} 
return true;
}

function isCPF(parametroCPF){ 
  var i; 
  s = parametroCPF.value; 
  var c = s.substr(0,9); 
  var dv = s.substr(9,2); 
  var d1 = 0; 

  for (i = 0; i < 9; i++){ 
    d1 += c.charAt(i)*(10-i); 
  } 

  if (d1 == 0){ 
   alert("CPF Inválido");
   return false; 
  } 

  d1 = 11 - (d1 % 11); 

  if (d1 > 9) d1 = 0; 

  if (dv.charAt(0) != d1){ 
   alert("CPF Inválido");
   return false; 
  } 
  d1 *= 2; 
  for (i = 0; i < 9; i++){ 
    d1 += c.charAt(i)*(11-i); 
  } 
  d1 = 11 - (d1 % 11); 
  if (d1 > 9) d1 = 0; 
  if (dv.charAt(1) != d1){ 
   alert("CPF Inválido");
   return false; 
  } 
  return true; 
} 

function isEmail(email, obrigatorio){
 //Se o parâmetro obrigatório for igual é zero, significa que elepode estar vazio, caso contrário, não
 	var email = document.getElementById(email);
 	if((obrigatorio == 1) || (obrigatorio == 0 && email.value != "")){
 		if(!email.value.match(/([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+.[a-zA-Z0-9._-]+)/gi)){
 			alert("Informe um e-mail válido");
 			email.focus();
 			return false;
 		}else{
        return true;
        }
 	}
}

function swapLayers(id) {
  var div = getElemRefs(id);
  if(div.css.visibility == ""){
    hideLayer(id);
  }else{
    if(div.css.visibility == "hidden"){
      showLayer(id);
    }else{
      hideLayer(id);
    }
  }         
}  

function showLayer(id) {
  var lyr = getElemRefs(id);
  var img = "i" + id;
  if (lyr && lyr.css){
    lyr.css.visibility = "visible";
    lyr.css.display = "";
    getElemRefs(img).src = "../../imagens/fecha_bloco.gif";
    getElemRefs(img).alt = "Clique para minimizar";
  }
}

function hideLayer(id) {
  var lyr = getElemRefs(id);
  var img = "i" + id;
  if (lyr && lyr.css){
    lyr.css.visibility = "hidden";
    lyr.css.display = "none";
    getElemRefs(img).src = "../../imagens/abre_bloco.gif";
    getElemRefs(img).alt = "Clique para maximizar";
  }
}        

function getElemRefs(id) {
  var el = (document.getElementById)? document.getElementById(id): (document.all)? document.all[id]: (document.layers)? getLyrRef(id,document): null;
  if (el) el.css = (el.style)? el.style: el;
  return el;
}   
