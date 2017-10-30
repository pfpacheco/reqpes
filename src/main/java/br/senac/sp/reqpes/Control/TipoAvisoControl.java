package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.TipoAvisoDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.TipoAviso;
import br.senac.sp.componente.model.Usuario;


public class TipoAvisoControl{

  TipoAvisoDAO grupoNecDAO;
  
  public TipoAvisoControl(){
    grupoNecDAO = new TipoAvisoDAO();
  }

   public TipoAviso[] getTipoAvisos() throws RequisicaoPessoalException{
      return grupoNecDAO.getTipoAvisos();
   }

   public int gravaTipoAviso(TipoAviso grupoNec, Usuario usuario) throws RequisicaoPessoalException{
      return grupoNecDAO.gravaTipoAviso(grupoNec, usuario);
   }

   public int alteraTipoAviso(TipoAviso grupoNec, Usuario usuario) throws RequisicaoPessoalException{
      return grupoNecDAO.alteraTipoAviso(grupoNec, usuario);
   }

   public int deletaTipoAviso(TipoAviso grupoNec, Usuario usuario) throws RequisicaoPessoalException{
      return grupoNecDAO.deletaTipoAviso(grupoNec, usuario);
   }

   public TipoAviso getTipoAviso(int codTipoAviso) throws RequisicaoPessoalException{
      return grupoNecDAO.getTipoAviso(codTipoAviso);
   }

   public TipoAviso[] getTipoAvisos(String condicao) throws RequisicaoPessoalException{
      return grupoNecDAO.getTipoAvisos(condicao);
   }
}