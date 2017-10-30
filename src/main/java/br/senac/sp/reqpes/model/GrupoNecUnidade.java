package br.senac.sp.reqpes.model;

/**
* @author Thiago Lima Coutinho
* @since 2/6/2009
*/

public class GrupoNecUnidade{
  private int codGrupo;
  private String codUnidade;

  public GrupoNecUnidade(){
  }


  public void setCodGrupo(int codGrupo)
  {
    this.codGrupo = codGrupo;
  }


  public int getCodGrupo()
  {
    return codGrupo;
  }


  public void setCodUnidade(String codUnidade)
  {
    this.codUnidade = codUnidade;
  }


  public String getCodUnidade()
  {
    return (codUnidade==null)?"":codUnidade;
  }
}