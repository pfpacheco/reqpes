package br.senac.sp.reqpes.model;

public class Horarios 
{
  private String dia;
  private String classificacao;
  private String entrada;
  private String intervalo;
  private String retorno;
  private String saida;
  private String entradaExtra;
  private String intervaloExtra;
  private String retornoExtra;
  private String saidaExtra;
  
  public Horarios(){
  }

  public Horarios(String entrada
		  		 ,String intervalo
		  		 ,String retorno
		  		 ,String saida
		  		 ,String entradaExtra
		  		 ,String intervaloExtra
		  		 ,String retornoExtra
		  		 ,String saidaExtra){
	  
	  this.setEntrada(entrada);
	  this.setIntervalo(intervalo);
	  this.setRetorno(retorno);
	  this.setSaida(saida);
	  this.setEntradaExtra(entradaExtra);
	  this.setIntervaloExtra(intervaloExtra);
	  this.setRetornoExtra(retornoExtra);
	  this.setSaidaExtra(saidaExtra);
  }
  
  public void setDia(String dia) {
    this.dia = dia;
  }

  public String getDia() {
    return dia;
  }

  public void setEntrada(String entrada) {
    this.entrada = entrada;
  }

  public String getEntrada() {
    return entrada == null ? "" : entrada;
  }

  public void setIntervalo(String intervalo) {
    this.intervalo = intervalo;
  }

  public String getIntervalo() {
    return intervalo == null ? "" : intervalo;
  }

  public void setRetorno(String retorno) {
    this.retorno = retorno;
  }

  public String getRetorno() {
    return retorno == null ? "" : retorno;
  }

  public void setSaida(String saida) {
    this.saida = saida;
  }

  public String getSaida() {
    return saida == null ? "" : saida;
  }

  public void setClassificacao(String classificacao) {
    this.classificacao = classificacao;
  }

  public String getClassificacao() {
    return classificacao;
  }

  public void setEntradaExtra(String entradaExtra) {
	this.entradaExtra = entradaExtra;
  }
	
  public String getEntradaExtra() {
	return entradaExtra == null ? "" : entradaExtra;
  }
	
  public void setIntervaloExtra(String intervaloExtra) {
	this.intervaloExtra = intervaloExtra;
  }
	
  public String getIntervaloExtra() {
	return intervaloExtra == null ? "" : intervaloExtra;
  }
	
  public void setRetornoExtra(String retornoExtra) {
	this.retornoExtra = retornoExtra;
  }
	
  public String getRetornoExtra() {
	return retornoExtra == null ? "" : retornoExtra;
  }
	
  public void setSaidaExtra(String saidaExtra) {
	this.saidaExtra = saidaExtra;
  }
	
  public String getSaidaExtra() {
	return saidaExtra == null ? "" : saidaExtra;
  }
}