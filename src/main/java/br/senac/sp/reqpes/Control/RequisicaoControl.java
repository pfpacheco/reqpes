package br.senac.sp.reqpes.Control;

import java.math.BigDecimal;

//-- Classes da aplicação
import br.senac.sp.componente.model.Usuario;
import br.senac.sp.reqpes.DAO.RequisicaoDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.Requisicao;

public class RequisicaoControl {

	RequisicaoDAO requisicaoDAO;

	public RequisicaoControl() {
		requisicaoDAO = new RequisicaoDAO();
	}

	public Requisicao[] getRequisicaos() throws RequisicaoPessoalException {
		return requisicaoDAO.getRequisicaos();
	}

	public int gravaRequisicao(Requisicao requisicao, Usuario usuario) throws RequisicaoPessoalException {
		return requisicaoDAO.gravaRequisicao(requisicao, usuario);
	}

	public int alteraRequisicao(Requisicao requisicao, Usuario usuario) throws RequisicaoPessoalException {
		return requisicaoDAO.alteraRequisicao(requisicao, usuario);
	}

	public int alteraRequisicaoCompleta(Requisicao requisicao, Usuario usuario) throws RequisicaoPessoalException {
		return requisicaoDAO.alteraRequisicaoCompleta(requisicao, usuario);
	}

	public int deletaRequisicao(Requisicao requisicao, Usuario usuario) throws RequisicaoPessoalException {
		return requisicaoDAO.deletaRequisicao(requisicao, usuario);
	}

	public Requisicao getRequisicao(int idRequisicao) throws RequisicaoPessoalException {
		return requisicaoDAO.getRequisicao(idRequisicao);
	}

	public Requisicao[] getRequisicaos(String condicao) throws RequisicaoPessoalException {
		return requisicaoDAO.getRequisicaos(condicao);
	}

	public String[][] getMatriz(String sql) throws RequisicaoPessoalException {
		return requisicaoDAO.getMatriz(sql);
	}

	public String[][] getMatriz(String sql, String dataSource) throws RequisicaoPessoalException {
		return requisicaoDAO.getMatriz(sql, dataSource);
	}

	public String[] getLista(String sql) throws RequisicaoPessoalException {
		return requisicaoDAO.getLista(sql);
	}

	public String[][] getComboClassificacaoFuncional() throws RequisicaoPessoalException {
		return requisicaoDAO.getComboClassificacaoFuncional();
	}

	public String[][] getComboRPPara(int tipoRecrutamento) throws RequisicaoPessoalException {
		return requisicaoDAO.getComboRPPara(tipoRecrutamento);
	}

	public String[][] getComboRPPara() throws RequisicaoPessoalException {
		return requisicaoDAO.getComboRPPara();
	}

	public String[][] getComboMotivoSolicitacao(int indMotivo) throws RequisicaoPessoalException {
		String tipo = "'0'";

		switch (indMotivo) {
		case 2:
			tipo = "'S'";
			break;
		case 3:
			tipo = "'T'";
			break;
		}

		return requisicaoDAO.getComboMotivoSolicitacao(tipo);
	}

	public String[][] getComboMotivoSolicitacao() throws RequisicaoPessoalException {
		return requisicaoDAO.getComboMotivoSolicitacao();
	}

	public String[][] getComboTipoContratacao() throws RequisicaoPessoalException {
		return requisicaoDAO.getComboTipoContratacao();
	}

	public String[][] getComboRecrutamento() throws RequisicaoPessoalException {
		return requisicaoDAO.getComboRecrutamento();
	}

	public String[][] getPesquisaRequisicao(int codRequisicao) throws RequisicaoPessoalException {
		return requisicaoDAO.getPesquisaRequisicao(codRequisicao);
	}

	public String[][] getPesquisaRequisicaoAntiga(int codRequisicao) throws RequisicaoPessoalException {
		return requisicaoDAO.getPesquisaRequisicaoAntiga(codRequisicao);
	}

	public String[][] getComboCargosExistentesRequisicao() throws RequisicaoPessoalException {
		return requisicaoDAO.getComboCargosExistentesRequisicao();
	}

	public String[][] getComboStatusRequisicao() throws RequisicaoPessoalException {
		return requisicaoDAO.getComboStatusRequisicao();
	}

	public String[][] getComboUnidade(String tipoPesquisa) throws RequisicaoPessoalException {
		return requisicaoDAO.getComboUnidade(tipoPesquisa);
	}

	public String[][] getComboUnidade() throws RequisicaoPessoalException {
		return requisicaoDAO.getComboUnidade(null);
	}

	public String[][] getComboSuperintendenciaUnidades(String tipoPesquisa) throws RequisicaoPessoalException {
		return requisicaoDAO.getComboSuperintendenciaUnidades(tipoPesquisa);
	}

	public String[][] getComboUnidadesRelacionadas() throws RequisicaoPessoalException {
		return requisicaoDAO.getComboUnidadesRelacionadas();
	}

	public String[][] getComboUnidadesRelacionadas(int codUnidade, String listaUnidadesAcesso)
			throws RequisicaoPessoalException {
		return requisicaoDAO.getComboUnidadesRelacionadas(codUnidade, listaUnidadesAcesso);
	}

	public String[][] getRequisicoesParaExclusao(String condicao) throws RequisicaoPessoalException {
		return requisicaoDAO.getRequisicoesParaExclusao(condicao);
	}

	public String[][] getHistoricoRequisicao(int codRequisicao, String dataSource) throws RequisicaoPessoalException {
		return requisicaoDAO.getHistoricoRequisicao(codRequisicao, dataSource);
	}

	public String[][] getHistoricoPerfilCampos(int codRequisicao, String dataSource) throws RequisicaoPessoalException {
		return requisicaoDAO.getHistoricoPerfilCampos(codRequisicao, dataSource);
	}

	public String[][] getDadosUsuarioAtualHistorico(int chapa) throws RequisicaoPessoalException {
		return requisicaoDAO.getDadosUsuarioAtualHistorico(chapa);
	}

	public String[][] getDadosUsuarioAtualHistorico(String codUnidade) throws RequisicaoPessoalException {
		return requisicaoDAO.getDadosUsuarioAtualHistorico(codUnidade);
	}

	public BigDecimal validaHorarioTrabalho(String horaEntrada, String horaSaida) throws RequisicaoPessoalException {
		return requisicaoDAO.validaHorarioTrabalho(horaEntrada, horaSaida);
	}

	public String verificaSubstituido(int numChapaSubst) throws RequisicaoPessoalException {
		return requisicaoDAO.verificaSubstituido(numChapaSubst);
	}

	public String[][] getDscClassificacaoFuncional(int codClassificacaoFuncional) throws RequisicaoPessoalException {
		return requisicaoDAO.getDscClassificacaoFuncional(codClassificacaoFuncional);
	}

	public String[][] getComboCargo(String codUnidade) throws RequisicaoPessoalException {
		return requisicaoDAO.getComboCargo(codUnidade);
	}

	public String getDataFimContratacao(String datInicio, int prazo) throws RequisicaoPessoalException {
		return requisicaoDAO.getDataFimContratacao(datInicio, prazo);
	}
}