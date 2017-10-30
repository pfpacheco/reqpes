package br.senac.sp.reqpes.model;

/**
* @author Thiago Lima Coutinho
* @since 2/6/2009
*/

public class GrupoNecUsuario{
  private int codGrupo;
  private int chapa;
  private String nomUsuario;  

  public GrupoNecUsuario(){
  }


  public void setCodGrupo(int codGrupo)
  {
    this.codGrupo = codGrupo;
  }


  public int getCodGrupo()
  {
    return codGrupo;
  }


  public void setChapa(int chapa)
  {
    this.chapa = chapa;
  }


  public int getChapa()
  {
    return chapa;
  }


  public void setNomUsuario(String nomUsuario)
  {
    this.nomUsuario = nomUsuario;
  }


  public String getNomUsuario()
  {
    return (nomUsuario==null)?"":nomUsuario;
  }

}