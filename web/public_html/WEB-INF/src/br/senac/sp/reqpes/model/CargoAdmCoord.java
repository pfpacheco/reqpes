package br.senac.sp.reqpes.model;

public class CargoAdmCoord {
  private String codUnidade;
  private String nomUnidade;
  
  public CargoAdmCoord() {
  }

  public void setCodUnidade(String codUnidade) {
    this.codUnidade = codUnidade;
  }

  public String getCodUnidade() {
    return codUnidade;
  }

  public void setNomUnidade(String nomUnidade) {
    this.nomUnidade = nomUnidade;
  }

  public String getNomUnidade() {
    return nomUnidade;
  }
}