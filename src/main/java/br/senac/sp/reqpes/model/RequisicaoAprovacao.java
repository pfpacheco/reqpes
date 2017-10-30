package br.senac.sp.reqpes.model;

public class RequisicaoAprovacao{

  private int codRequisicao;
  private String dscMotivo; 
  private String codUnidadeAprovadora;
  private String codUnidadeHomologador;
  private int nivelWorkFlow;

  public RequisicaoAprovacao(){
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


  public void setCodUnidadeAprovadora(String codUnidadeAprovadora)
  {
    this.codUnidadeAprovadora = codUnidadeAprovadora;
  }


  public String getCodUnidadeAprovadora()
  {
    return (codUnidadeAprovadora==null)?"":codUnidadeAprovadora;
  }


  public void setCodUnidadeHomologador(String codUnidadeHomologador)
  {
    this.codUnidadeHomologador = codUnidadeHomologador;
  }


  public String getCodUnidadeHomologador()
  {
    return (codUnidadeHomologador==null)?"":codUnidadeHomologador;
  }


  public void setNivelWorkFlow(int nivelWorkFlow)
  {
    this.nivelWorkFlow = nivelWorkFlow;
  }


  public int getNivelWorkFlow()
  {
    return nivelWorkFlow;
  }
}