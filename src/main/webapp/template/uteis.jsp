<%!
  /*FUN플O PARA TIRAR CARACTERE DE UMA STRING*/
  public String tiraCaracter(String valor, char caracter) {
     String retorno = "";
     for (int posicao = 0; posicao < valor.length(); posicao ++) {
        if (valor.charAt(posicao) != caracter){
           retorno  += valor.charAt(posicao);
        }
     }
     return retorno ;
  }

  /*FUN플O PARA RETORNAR NUMEROS FLOAT*/
  public float parseFloat(String valor){
    return Float.parseFloat(tiraCaracter(valor,'.').replace(',','.')) ;
  }
  
  /*FUN플O PARA RETORNAR NUMEROS DOUBLE*/
  public int  parseInt(String valor){
   return Integer.parseInt(tiraCaracter(valor,'.').replace(',','.')) ;
  }
  /*FUN플O PARA RETORNAR NUMEROS DOUBLE*/
  public double  parseDouble(String valor){
   return Double.parseDouble(tiraCaracter(valor,'.').replace(',','.')) ;
  } 
%>