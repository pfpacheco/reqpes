package br.senac.sp.reqpes.Control;

import br.senac.sp.componente.model.Usuario;
//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.InstrucaoDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.Instrucao;

public class InstrucaoControl {

	InstrucaoDAO instrucaoDAO;

	public InstrucaoControl() {
		instrucaoDAO = new InstrucaoDAO();
	}

	public Instrucao[] getInstrucaos() throws RequisicaoPessoalException {
		return instrucaoDAO.getInstrucaos();
	}

	public int gravaInstrucao(Instrucao tabelaSalarial, Usuario usuario) throws RequisicaoPessoalException {
		return instrucaoDAO.gravaInstrucao(tabelaSalarial, usuario);
	}

	public int alteraInstrucao(Instrucao tabelaSalarial, Usuario usuario) throws RequisicaoPessoalException {
		return instrucaoDAO.alteraInstrucao(tabelaSalarial, usuario);
	}

	public int deletaInstrucao(Instrucao tabelaSalarial, Usuario usuario) throws RequisicaoPessoalException {
		return instrucaoDAO.deletaInstrucao(tabelaSalarial, usuario);
	}

	public Instrucao getInstrucao(int codInstrucao) throws RequisicaoPessoalException {
		return instrucaoDAO.getInstrucao(codInstrucao);
	}

	public Instrucao[] getInstrucaos(String condicao) throws RequisicaoPessoalException {
		return instrucaoDAO.getInstrucaos(condicao);
	}

	public String[][] getMatriz(String sql) throws RequisicaoPessoalException {
		return instrucaoDAO.getMatriz(sql);
	}

	public String[] getLista(String sql) throws RequisicaoPessoalException {
		return instrucaoDAO.getLista(sql);
	}

	public String[][] getComboCargo(int codTabelaSalarial) throws RequisicaoPessoalException {
		return instrucaoDAO.getComboCargo(codTabelaSalarial);
	}

	public String[][] getComboAreaSubArea() throws RequisicaoPessoalException {
		return instrucaoDAO.getComboAreaSubArea();
	}

	public int getCotaCargo(String codUnidade, int codCargo, int codTabSalarial, String segmento4)
			throws RequisicaoPessoalException {
		String condicao = "";

		switch (codTabSalarial) {
		case 1: // -- TABELA 01 - GERAL
			condicao = " AND COD_TAB_SALARIAL NOT IN (2,3,4)";
			break;

		case 3: // -- TABELA 01 - RESPOSÃ�VEL PELA Ã�REA ADMINISTRATIVA
			condicao = " AND COD_TAB_SALARIAL = " + codTabSalarial;
			break;

		case 7: // -- TABELA 05 - MONITORES
				// -- Thiago 18/04/2011: a tabela de monitores não necessita
				// mais de área-subárea
				// condicao = (segmento4.trim().equals(""))?"":" AND
				// COD_AREA_SUBAREA = '" + segmento4 + "'";
			condicao = " AND I.COD_TAB_SALARIAL = 7";
			break;

		default:
			condicao = "";
			break;
		}

		return instrucaoDAO.getCotaCargo(codUnidade, codCargo, condicao);
	}

	public String[] isGravaInstrucao(Instrucao instrucao, int dml, String[] unidades)
			throws RequisicaoPessoalException {
		// -- dml 0: Insert
		// -- dml 1: Update
		return instrucaoDAO.isGravaInstrucao(instrucao, dml, unidades);
	}

	public boolean validaIN15(String codUnidade, int codCargo, int cotaCargo, int codTabSalarial, String segmento4)
			throws RequisicaoPessoalException {
		String condicao = "";

		switch (codTabSalarial) {
		case 1: // -- TABELA 01 - GERAL
			condicao = " AND COD_TAB_SALARIAL NOT IN (2,3,4)";
			break;

		case 3: // -- TABELA 01 - RESPONSÁVEL PELA ÁREA ADMINISTRATIVA
			condicao = " AND COD_TAB_SALARIAL = 3";
			break;

		case 7: // -- TABELA 05 - MONITORES
				// -- Thiago 18/04/2011: a tabela de monitores não necessita
				// mais de área-subárea
				// condicao = (segmento4.trim().equals(""))?"":" AND
				// COD_AREA_SUBAREA = '" + segmento4 + "'";
			condicao = " AND I.COD_TAB_SALARIAL = 7";
			break;

		default:
			condicao = "";
			break;
		}

		// -- Retorno: 0 (Erro, não encontrado) / 1 (Sucesso, quantidade de
		// registros)
		return ((instrucaoDAO.validaIN15(codUnidade, codCargo, cotaCargo, condicao)) >= 1);
	}
}