package br.senac.sp.reqpes.model;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 08/10/2008
 */

public class RequisicaoBaixa{
  private int codRequisicao;
  private int idFuncionarioBaixado;
  
  public RequisicaoBaixa(){
    
  }


  public void setCodRequisicao(int codRequisicao)
  {
    this.codRequisicao = codRequisicao;
  }


  public int getCodRequisicao()
  {
    return codRequisicao;
  }


  public void setIdFuncionarioBaixado(int idFuncionarioBaixado)
  {
    this.idFuncionarioBaixado = idFuncionarioBaixado;
  }


  public int getIdFuncionarioBaixado()
  {
    return idFuncionarioBaixado;
  }
}