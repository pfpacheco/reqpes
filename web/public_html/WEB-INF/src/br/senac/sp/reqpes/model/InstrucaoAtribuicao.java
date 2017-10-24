package br.senac.sp.reqpes.model;

public class InstrucaoAtribuicao{
  private int codInstrucao;
  private String codUnidade;
  private String indSelecionado;
  private String siglaUnidade;
  private String dscUnidade;
  private String indLocalUnidade;

  public InstrucaoAtribuicao(){
  }


  public void setCodInstrucao(int codInstrucao)
  {
    this.codInstrucao = codInstrucao;
  }


  public int getCodInstrucao()
  {
    return codInstrucao;
  }


  public void setCodUnidade(String codUnidade)
  {
    this.codUnidade = codUnidade;
  }


  public String getCodUnidade()
  {
    return (codUnidade==null)?"":codUnidade;
  }


  public void setIndSelecionado(String indSelecionado)
  {
    this.indSelecionado = indSelecionado;
  }


  public String getIndSelecionado()
  {
    return (indSelecionado==null)?"N":indSelecionado;
  }


  public void setSiglaUnidade(String siglaUnidade)
  {
    this.siglaUnidade = siglaUnidade;
  }


  public String getSiglaUnidade()
  {
    return (siglaUnidade==null)?"":siglaUnidade;
  }


  public void setDscUnidade(String dscUnidade)
  {
    this.dscUnidade = dscUnidade;
  }


  public String getDscUnidade()
  {
    return (dscUnidade==null)?"":dscUnidade;
  }


  public void setIndLocalUnidade(String indLocalUnidade)
  {
    this.indLocalUnidade = indLocalUnidade;
  }


  public String getIndLocalUnidade()
  {
    return (indLocalUnidade==null)?"":indLocalUnidade;
  }
}