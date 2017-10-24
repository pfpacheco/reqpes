package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.GrupoNecUnidadeDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.GrupoNecUnidade;

public class GrupoNecUnidadeControl{

   GrupoNecUnidadeDAO grupoNecUnidadeDAO;
  
   public GrupoNecUnidadeControl(){
      grupoNecUnidadeDAO = new GrupoNecUnidadeDAO();
   }

   public int gravaGrupoNecUnidade(GrupoNecUnidade grupoNecUnidade) throws RequisicaoPessoalException{
      return grupoNecUnidadeDAO.gravaGrupoNecUnidade(grupoNecUnidade);
   }

   public int deletaGrupoNecUnidade(GrupoNecUnidade grupoNecUnidade) throws RequisicaoPessoalException{
      return grupoNecUnidadeDAO.deletaGrupoNecUnidade(grupoNecUnidade);
   }

   public String[][] getUnidadesSuperintendencia(int codGrupo, String codSuperintendencia) throws RequisicaoPessoalException{
      return grupoNecUnidadeDAO.getUnidadesSuperintendencia(codGrupo, codSuperintendencia);
   }

   public String[][] getUnidadesGO(int codGrupo, int indGO) throws RequisicaoPessoalException{
      String codGO = null;
      
      switch (indGO) {
        case 1: codGO = "120C"; break;
        case 2: codGO = "121C"; break;
        case 3: codGO = "122C"; break;
      }
      
      return grupoNecUnidadeDAO.getUnidadesGO(codGrupo, codGO);
   }
}