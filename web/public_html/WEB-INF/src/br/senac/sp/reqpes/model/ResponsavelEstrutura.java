package br.senac.sp.reqpes.model;

import br.senac.sp.componente.model.Unidade;

public class ResponsavelEstrutura{

  private int codPerfilUsuario;
  private int codUnidadeUsuario;
  private Unidade[] unidades; 

  public ResponsavelEstrutura(){
  }


  public void setCodPerfilUsuario(int codPerfilUsuario)
  {
    this.codPerfilUsuario = codPerfilUsuario;
  }


  public int getCodPerfilUsuario()
  {
    return codPerfilUsuario;
  }


  public void setCodUnidadeUsuario(int codUnidadeUsuario)
  {
    this.codUnidadeUsuario = codUnidadeUsuario;
  }


  public int getCodUnidadeUsuario()
  {
    return codUnidadeUsuario;
  }


  public void setUnidades(Unidade[] unidades)
  {
    this.unidades = unidades;
  }


  public Unidade[] getUnidades()
  {
    return unidades;
  }

}