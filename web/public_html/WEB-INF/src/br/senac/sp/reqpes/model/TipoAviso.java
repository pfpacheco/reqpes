package br.senac.sp.reqpes.model;

public class TipoAviso{
  
  private int codTipoAviso;
  private String titulo;
  private String cargoChave;
  private String cargoRegime;
  private String dscRegime;
  
  public TipoAviso(){
  }

  public void setCodTipoAviso(int codTipoAviso){
    this.codTipoAviso = codTipoAviso;
  }

  public int getCodTipoAviso(){
    return codTipoAviso;
  }

  public void setTitulo(String titulo){
    this.titulo = titulo;
  }

  public String getTitulo(){
    return (titulo==null)?"":titulo;
  }

  public void setCargoChave(String cargoChave){
    this.cargoChave = cargoChave;
  }

  public String getCargoChave(){
    return (cargoChave==null)?"":cargoChave;
  }

  public void setCargoRegime(String cargoRegime){
    this.cargoRegime = cargoRegime;
  }

  public String getCargoRegime(){
    return (cargoRegime==null)?"N":cargoRegime;
  }

  public void setDscRegime(String dscRegime){
    this.dscRegime = dscRegime;
  }

  public String getDscRegime(){
    return (dscRegime==null)?"":dscRegime;
  }
}