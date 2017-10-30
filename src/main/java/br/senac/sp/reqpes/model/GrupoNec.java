package br.senac.sp.reqpes.model;

/**
* @author Thiago Lima Coutinho
* @since 2/6/2009
*/

public class GrupoNec{
  private int codGrupo;
  private String dscGrupo;

  public GrupoNec(){
  }


  public void setCodGrupo(int codGrupo)
  {
    this.codGrupo = codGrupo;
  }


  public int getCodGrupo()
  {
    return codGrupo;
  }


  public void setDscGrupo(String dscGrupo)
  {
    this.dscGrupo = dscGrupo;
  }


  public String getDscGrupo()
  {
    return (dscGrupo==null)?"":dscGrupo;
  }
}