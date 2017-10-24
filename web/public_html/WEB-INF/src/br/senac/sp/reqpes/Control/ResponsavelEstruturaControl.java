package br.senac.sp.reqpes.Control;
import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.componente.model.Usuario;
import br.senac.sp.reqpes.DAO.ResponsavelEstruturaDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.ResponsavelEstrutura;
 
public class ResponsavelEstruturaControl{

  ResponsavelEstruturaDAO responsavelEstruturaDAO;
  
  public ResponsavelEstruturaControl(){
    responsavelEstruturaDAO = new ResponsavelEstruturaDAO();
  }
  
  public String[] buscarUnidadeDestino(String codUnidade) throws RequisicaoPessoalException{
    return responsavelEstruturaDAO.buscarUnidadeDestino(codUnidade);
  }
  
  public String[][] getMatriz(String sql) throws RequisicaoPessoalException{
    return responsavelEstruturaDAO.getMatriz(sql);
  }
  
  public String[] getLista(String sql) throws RequisicaoPessoalException{
    return responsavelEstruturaDAO.getLista(sql);
  }
  
  public boolean isUsuarioWorkflow(int chapa) throws RequisicaoPessoalException, AdmTIException{
    return responsavelEstruturaDAO.isUsuarioWorkflow(chapa);
  }
  
  public boolean isAprovadorFinal(int chapa) throws RequisicaoPessoalException, AdmTIException{
    return responsavelEstruturaDAO.isAprovadorFinal(chapa);
  }  
    
  public boolean isUsuarioHomologadorGEP(int chapa) throws RequisicaoPessoalException{
    return responsavelEstruturaDAO.isUsuarioHomologadorGEP(chapa);
  }    
  
  public ResponsavelEstrutura getResponsavelEstrutura(Usuario usuario) throws RequisicaoPessoalException{
    return responsavelEstruturaDAO.getResponsavelEstrutura(usuario);
  }   

  public String[][] getDadosResponsavel(String codUnidade, int chapa) throws RequisicaoPessoalException{
    return responsavelEstruturaDAO.getDadosResponsavel(codUnidade, chapa);
  }       
  
  public String getCodUnidadeByUsuarioWorkFlow(int chapa) throws RequisicaoPessoalException, AdmTIException{
    return responsavelEstruturaDAO.getCodUnidadeByUsuarioWorkFlow(chapa);
  }    
  
  public ResponsavelEstrutura getCodUnidade(String codUnidadeRHEV) throws RequisicaoPessoalException{
    return responsavelEstruturaDAO.getCodUnidade(codUnidadeRHEV);
  }     
  
  public String getTeorCodWorkflow() throws AdmTIException{  
    return responsavelEstruturaDAO.getTeorCodWorkflow();
  }
}