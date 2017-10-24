package br.senac.sp.reqpes.model;

public class UsuarioAvisoEmail {

  private int chapa;
  private String email;
  private String nome;
  private int codTipoAviso;

  public UsuarioAvisoEmail(){
  }

  public void setChapa(int chapa){
    this.chapa = chapa;
  }

  public int getChapa(){
    return chapa;
  }

  public void setEmail(String email){
    this.email = email;
  }

  public String getEmail(){
    return email;
  }

  public void setNome(String nome){
    this.nome = nome;
  }

  public String getNome(){
    return nome;
  }

  public void setCodTipoAviso(int codTipoAviso){
    this.codTipoAviso = codTipoAviso;
  }

  public int getCodTipoAviso(){
    return codTipoAviso;
  }
}