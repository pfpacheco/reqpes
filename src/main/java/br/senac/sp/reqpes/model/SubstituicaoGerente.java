package br.senac.sp.reqpes.model;
import java.sql.Date;

public class SubstituicaoGerente{

  private int chapa;
  private String codUnidade;
  private Date datInicioVigencia;
  private Date datFimVigencia;
  private String nomGerente;

  public SubstituicaoGerente(){
  }


  public void setChapa(int chapa)
  {
    this.chapa = chapa;
  }


  public int getChapa()
  {
    return chapa;
  }


  public void setCodUnidade(String codUnidade)
  {
    this.codUnidade = codUnidade;
  }


  public String getCodUnidade()
  {
    return (codUnidade==null)?"":codUnidade;
  }


  public void setDatInicioVigencia(Date datInicioVigencia)
  {
    this.datInicioVigencia = datInicioVigencia;
  }


  public Date getDatInicioVigencia()
  {
    return datInicioVigencia;
  }


  public void setDatFimVigencia(Date datFimVigencia)
  {
    this.datFimVigencia = datFimVigencia;
  }


  public Date getDatFimVigencia()
  {
    return datFimVigencia;
  }


  public void setNomGerente(String nomGerente)
  {
    this.nomGerente = nomGerente;
  }


  public String getNomGerente()
  {
    return (nomGerente==null)?"":nomGerente;
  }
}