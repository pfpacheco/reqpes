package br.senac.sp.reqpes.model;

public class RequisicaoEstorno{

  private int codRequisicao;
  private String indTipoEstorno;

  public RequisicaoEstorno(){
  }


  public void setCodRequisicao(int codRequisicao)
  {
    this.codRequisicao = codRequisicao;
  }


  public int getCodRequisicao()
  {
    return codRequisicao;
  }


  public void setIndTipoEstorno(String indTipoEstorno)
  {
    this.indTipoEstorno = indTipoEstorno;
  }


  public String getIndTipoEstorno()
  {
    return (indTipoEstorno==null)?"S":indTipoEstorno;
  }

}