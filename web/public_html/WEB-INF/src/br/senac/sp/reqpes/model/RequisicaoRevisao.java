package br.senac.sp.reqpes.model;

public class RequisicaoRevisao{

  private int codRequisicao;
  private int nroRevisoes;
  private String dscMotivo;
  private String dataHoraEnvio;
  private String nomRevisor;
  private String codUnidadeRevisor;
  private String nomUnidadeRevisor;  
  private String dataHoraCriacao;
  private String nomCriador;
  private String codUnidadeCriador;
  private String nomUnidadeCriador;  

  public RequisicaoRevisao(){
  }


  public void setCodRequisicao(int codRequisicao)
  {
    this.codRequisicao = codRequisicao;
  }


  public int getCodRequisicao()
  {
    return codRequisicao;
  }


  public void setDscMotivo(String dscMotivo)
  {
    this.dscMotivo = dscMotivo;
  }


  public String getDscMotivo()
  {
    return (dscMotivo==null)?"":dscMotivo;
  }


  public void setNomRevisor(String nomRevisor)
  {
    this.nomRevisor = nomRevisor;
  }


  public String getNomRevisor()
  {
    return (nomRevisor==null)?"":nomRevisor;
  }


  public void setNroRevisoes(int nroRevisoes)
  {
    this.nroRevisoes = nroRevisoes;
  }


  public int getNroRevisoes()
  {
    return nroRevisoes;
  }


  public void setCodUnidadeRevisor(String codUnidadeRevisor)
  {
    this.codUnidadeRevisor = codUnidadeRevisor;
  }


  public String getCodUnidadeRevisor()
  {
    return (codUnidadeRevisor==null)?"":codUnidadeRevisor;
  }


  public void setNomUnidadeRevisor(String nomUnidadeRevisor)
  {
    this.nomUnidadeRevisor = nomUnidadeRevisor;
  }


  public String getNomUnidadeRevisor()
  {
    return (nomUnidadeRevisor==null)?"":nomUnidadeRevisor;
  }


  public void setDataHoraEnvio(String dataHoraEnvio)
  {
    this.dataHoraEnvio = dataHoraEnvio;
  }


  public String getDataHoraEnvio()
  {
    return (dataHoraEnvio==null)?"":dataHoraEnvio;
  }


  public void setDataHoraCriacao(String dataHoraCriacao)
  {
    this.dataHoraCriacao = dataHoraCriacao;
  }


  public String getDataHoraCriacao()
  {
    return (dataHoraCriacao==null)?"":dataHoraCriacao;
  }


  public void setNomCriador(String nomCriador)
  {
    this.nomCriador = nomCriador;
  }


  public String getNomCriador()
  {
    return (nomCriador==null)?"":nomCriador;
  }


  public void setCodUnidadeCriador(String codUnidadeCriador)
  {
    this.codUnidadeCriador = codUnidadeCriador;
  }


  public String getCodUnidadeCriador()
  {
    return (codUnidadeCriador==null)?"":codUnidadeCriador;
  }


  public void setNomUnidadeCriador(String nomUnidadeCriador)
  {
    this.nomUnidadeCriador = nomUnidadeCriador;
  }


  public String getNomUnidadeCriador()
  {
    return (nomUnidadeCriador==null)?"":nomUnidadeCriador;
  }
}