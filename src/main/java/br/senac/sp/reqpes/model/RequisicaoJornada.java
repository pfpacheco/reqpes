package br.senac.sp.reqpes.model;

/**
* @author Thiago Lima Coutinho 
* @since 15/09/2008
*/

public class RequisicaoJornada{

  private int codRequisicao;
  private int codCalendario;
  private String codEscala;
  private String indTipoHorario;
  private Horarios[] horarios;

  public  RequisicaoJornada(){
  }


  public void setCodRequisicao(int codRequisicao)
  {
    this.codRequisicao = codRequisicao;
  }


  public int getCodRequisicao()
  {
    return codRequisicao;
  }


  public void setCodEscala(String codEscala)
  {
    this.codEscala = codEscala;
  }


  public String getCodEscala()
  {
    return (codEscala==null)?"":codEscala;
  }


  public void setCodCalendario(int codCalendario)
  {
    this.codCalendario = codCalendario;
  }


  public int getCodCalendario()
  {
    return codCalendario;
  }


  public void setIndTipoHorario(String indTipoHorario)
  {
    this.indTipoHorario = indTipoHorario;
  }


  public String getIndTipoHorario()
  {
    return (indTipoHorario==null)?"":indTipoHorario;
  }


  public void setHorarios(Horarios[] horarios)
  {
    this.horarios = horarios;
  }


  public Horarios[] getHorarios()
  {
    return horarios;
  }

}