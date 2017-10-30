package br.senac.sp.reqpes.Control;
 
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.RequisicaoJornadaDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.Horarios;
import br.senac.sp.reqpes.model.RequisicaoJornada;
import java.util.ArrayList;


public class RequisicaoJornadaControl{

   RequisicaoJornadaDAO requisicaoJornadaDAO;
  
   public RequisicaoJornadaControl(){
      requisicaoJornadaDAO = new RequisicaoJornadaDAO();
   }

   public int gravaRequisicaoJornada(RequisicaoJornada requisicaoJornada) throws RequisicaoPessoalException{
      return requisicaoJornadaDAO.gravaRequisicaoJornada(requisicaoJornada);
   }

   public int alteraRequisicaoJornada(RequisicaoJornada requisicaoJornada) throws RequisicaoPessoalException{
      return requisicaoJornadaDAO.alteraRequisicaoJornada(requisicaoJornada);
   }

   public RequisicaoJornada getRequisicaoJornada(int idRequisicao) throws RequisicaoPessoalException{
      return requisicaoJornadaDAO.getRequisicaoJornada(idRequisicao);
   }

   public String[][] getEscala(String jornadaTrabalho,
                               String[] dias,
                               String[] classificacao,
                               String[] entrada,
                               String[] intervalo,
                               String[] retorno,
                               String[] saida
                               ) throws RequisicaoPessoalException{

      Horarios horario = null;
      ArrayList horariosList = new ArrayList();

      for(int i=0; i<dias.length; i++){
        horario = new Horarios();
        horario.setDia(dias[i]);
        horario.setClassificacao(classificacao[i]);
        horario.setEntrada(entrada[i]);
        horario.setIntervalo(intervalo[i]);
        horario.setRetorno(retorno[i]);
        horario.setSaida(saida[i]);
        horariosList.add(horario);
      }        

      return requisicaoJornadaDAO.getEscala(jornadaTrabalho, horariosList);
   }

   public String[][] getEscalaHorario(String sql) throws RequisicaoPessoalException{
      return requisicaoJornadaDAO.getEscalaHorario(sql);
   }           
      
   public String[][] getIdCalendario(String codUnidade, String codEscala) throws RequisicaoPessoalException{
     return requisicaoJornadaDAO.getIdCalendario(codUnidade, codEscala);
   }
   
   public String[][] getIdCalendario(String codUnidade, String indSegunda, String indTerca, String indQuarta, String indQuinta, String indSexta, String indSabado, String indDomingo) throws RequisicaoPessoalException{
	 return requisicaoJornadaDAO.getIdCalendario(codUnidade, indSegunda, indTerca, indQuarta, indQuinta, indSexta, indSabado, indDomingo);
   }
}