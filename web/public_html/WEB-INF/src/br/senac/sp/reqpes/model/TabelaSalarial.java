package br.senac.sp.reqpes.model;

/**
* @author Thiago Lima Coutinho
* @since 26/5/2009
*/

public class TabelaSalarial{

  private int codTabelaSalarial;
  private String dscTabelaSalarial;
  private String indAtivo;
  private String indExibeAreaSubarea;
  private int codTabelaRHEV;

  public TabelaSalarial(){
  }


  public void setCodTabelaSalarial(int codTabelaSalarial)
  {
    this.codTabelaSalarial = codTabelaSalarial;
  }


  public int getCodTabelaSalarial()
  {
    return codTabelaSalarial;
  }


  public void setDscTabelaSalarial(String dscTabelaSalarial)
  {
    this.dscTabelaSalarial = dscTabelaSalarial;
  }


  public String getDscTabelaSalarial()
  {
    return (dscTabelaSalarial==null)?"":dscTabelaSalarial;
  }


  public void setIndAtivo(String indAtivo)
  {
    this.indAtivo = indAtivo;
  }


  public String getIndAtivo()
  {
    return (indAtivo==null)?"":indAtivo;
  }


  public void setIndExibeAreaSubarea(String indExibeAreaSubarea)
  {
    this.indExibeAreaSubarea = indExibeAreaSubarea;
  }


  public String getIndExibeAreaSubarea()
  {
    return (indExibeAreaSubarea==null)?"":indExibeAreaSubarea;
  }


  public void setCodTabelaRHEV(int codTabelaRHEV)
  {
    this.codTabelaRHEV = codTabelaRHEV;
  }


  public int getCodTabelaRHEV()
  {
    return codTabelaRHEV;
  }
}