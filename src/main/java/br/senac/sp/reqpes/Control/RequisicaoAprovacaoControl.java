package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.componente.model.Usuario;

//-- Classes do componente
import br.senac.sp.reqpes.DAO.RequisicaoAprovacaoDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.RequisicaoAprovacao;
import br.senac.sp.reqpes.model.Requisicao;

public class RequisicaoAprovacaoControl{
  
  RequisicaoAprovacaoDAO requisicaoAprovacaoDAO;
  
   public RequisicaoAprovacaoControl(){
     requisicaoAprovacaoDAO = new RequisicaoAprovacaoDAO();
   }
  
   public int homologaRequisicao(RequisicaoAprovacao requisicao, Usuario usuario) throws RequisicaoPessoalException{
      return requisicaoAprovacaoDAO.homologaRequisicao(requisicao, usuario);
   }  
   
   public int aprovaRequisicao(RequisicaoAprovacao requisicao, Usuario usuario) throws RequisicaoPessoalException{
      return requisicaoAprovacaoDAO.aprovaRequisicao(requisicao, usuario);
   }    
   
   public int reprovaRequisicao(RequisicaoAprovacao requisicao, Usuario usuario) throws RequisicaoPessoalException{
      return requisicaoAprovacaoDAO.reprovaRequisicao(requisicao, usuario);
   }     
   
   public String[][] getMatriz(String sql) throws RequisicaoPessoalException{
      return requisicaoAprovacaoDAO.getMatriz(sql);
   }    
   
   public String[] getLista(String sql) throws RequisicaoPessoalException{
      return requisicaoAprovacaoDAO.getLista(sql);
   }     
   
   public String[][] getRequisicoesParaHomologacaoUO(int codUnidade, String codUnidadesLista) throws RequisicaoPessoalException{
      return requisicaoAprovacaoDAO.getRequisicoesParaHomologacaoUO(codUnidade, codUnidadesLista);
   }

   public String[][] getRequisicoesParaHomologacaoGEP() throws RequisicaoPessoalException{
      return requisicaoAprovacaoDAO.getRequisicoesParaHomologacaoGEP();
   }

   public String[][] getRequisicoesParaHomologacaoNEC(int chapa) throws RequisicaoPessoalException{
      String[][] unidades = new GrupoNecUsuarioControl().getUnidadesByUsuario(chapa);
      String todasUnidades = "";
      
      //-- Verificando as unidades de acesso
      for(int i=0; unidades != null && i < unidades.length; i++){
        todasUnidades += ((i==0)?" ":",") + unidades[i][0];
      }       
   
      return requisicaoAprovacaoDAO.getRequisicoesParaHomologacaoNEC(todasUnidades);
   }
   
   public String[][] getRequisicoesParaHomologacaoAPR() throws RequisicaoPessoalException{
      return requisicaoAprovacaoDAO.getRequisicoesParaHomologacaoAPR();
   }   
  
   public String[][] getRequisicoesParaHomologacao(String condicao) throws RequisicaoPessoalException{
     return requisicaoAprovacaoDAO.getRequisicoesParaHomologacao(condicao);
   }

   public String[][] getRequisicoesParaHomologacao() throws RequisicaoPessoalException{
     return getRequisicoesParaHomologacao("");
   }   
   
   public String getUnidadeRHEvolutionByChapa(int chapa) throws RequisicaoPessoalException{
     return requisicaoAprovacaoDAO.getUnidadeRHEvolutionByChapa(chapa);
   }
   
   public String getUnidadeRHEvolutionByCodUnidade(int codUnidade) throws RequisicaoPessoalException{
     return requisicaoAprovacaoDAO.getUnidadeRHEvolutionByCodUnidade(codUnidade);
   }   
   
   public String[] getEmailsEnvolvidosWorkFlow(Requisicao requisicao) throws RequisicaoPessoalException, AdmTIException{
     return requisicaoAprovacaoDAO.getEmailsEnvolvidosWorkFlow(requisicao);
   }
   
   public String[] getEmailsHomologadoresGEP() throws RequisicaoPessoalException{
     return requisicaoAprovacaoDAO.getEmailsHomologadoresGEP();
   }
   
   public String getEmailByChapa(int chapa) throws RequisicaoPessoalException{
     return requisicaoAprovacaoDAO.getEmailByChapa(chapa);
   }
   
   public String getEmailResponsavelUO(String codUnidade) throws RequisicaoPessoalException, AdmTIException{
     return requisicaoAprovacaoDAO.getEmailResponsavelUO(codUnidade);
   }    
   
   public int getNivelAprovacaoAtual(int codRequisicao) throws RequisicaoPessoalException{
     return requisicaoAprovacaoDAO.getNivelAprovacaoAtual(codRequisicao);
   }   
}