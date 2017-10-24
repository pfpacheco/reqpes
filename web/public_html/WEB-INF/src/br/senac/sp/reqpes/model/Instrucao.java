package br.senac.sp.reqpes.model;

/**
* @author Thiago Lima Coutinho
* @since 26/5/2009
*/

public class Instrucao{

  private int codInstrucao;
  private int codCargo;  
  private int cota;
  private int codTabelaSalarial;
  private TabelaSalarial TabelaSalarial;
  private String codAreaSubarea;
  private String dscCargo;
  
  public Instrucao(){
  }


  public void setCodInstrucao(int codInstrucao)
  {
    this.codInstrucao = codInstrucao;
  }


  public int getCodInstrucao()
  {
    return codInstrucao;
  }


  public void setCodCargo(int codCargo)
  {
    this.codCargo = codCargo;
  }


  public int getCodCargo()
  {
    return codCargo;
  }


  public void setCota(int cota)
  {
    this.cota = cota;
  }


  public int getCota()
  {
    return cota;
  }


  public void setCodAreaSubarea(String codAreaSubarea)
  {
    this.codAreaSubarea = codAreaSubarea;
  }


  public String getCodAreaSubarea()
  {
    return (codAreaSubarea==null)?"":codAreaSubarea;
  }


  public void setTabelaSalarial(TabelaSalarial TabelaSalarial)
  {
    this.TabelaSalarial = TabelaSalarial;
  }


  public TabelaSalarial getTabelaSalarial()
  {
    return TabelaSalarial;
  }


  public void setDscCargo(String dscCargo)
  {
    this.dscCargo = dscCargo;
  }


  public String getDscCargo()
  {
    return (dscCargo==null)?"":dscCargo;
  }


  public void setCodTabelaSalarial(int codTabelaSalarial)
  {
    this.codTabelaSalarial = codTabelaSalarial;
  }


  public int getCodTabelaSalarial()
  {
    return codTabelaSalarial;
  }

}