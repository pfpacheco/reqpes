package br.senac.sp.reqpes.model;

public class TabelaSalarialAtribuicao{
  private int codTabelaSalarial;
  private int codTabelaRHEV;
  private String dscTabelaRHEV;
  private String indSelecionado;

  public TabelaSalarialAtribuicao(){
  }


  public void setCodTabelaSalarial(int codTabelaSalarial)
  {
    this.codTabelaSalarial = codTabelaSalarial;
  }


  public int getCodTabelaSalarial()
  {
    return codTabelaSalarial;
  }


  public void setCodTabelaRHEV(int codTabelaRHEV)
  {
    this.codTabelaRHEV = codTabelaRHEV;
  }


  public int getCodTabelaRHEV()
  {
    return codTabelaRHEV;
  }


  public void setDscTabelaRHEV(String dscTabelaRHEV)
  {
    this.dscTabelaRHEV = dscTabelaRHEV;
  }


  public String getDscTabelaRHEV()
  {
    return (dscTabelaRHEV==null)?"":dscTabelaRHEV;
  }


  public void setIndSelecionado(String indSelecionado)
  {
    this.indSelecionado = indSelecionado;
  }


  public String getIndSelecionado()
  {
    return (indSelecionado==null)?"N":indSelecionado;
  }
}