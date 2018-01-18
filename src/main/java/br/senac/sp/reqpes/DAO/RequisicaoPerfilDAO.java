package br.senac.sp.reqpes.DAO;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.RequisicaoPerfil;
import oracle.jdbc.OracleTypes;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 16/09/2008
 */
public class RequisicaoPerfilDAO implements InterfaceDataBase {
	ManipulacaoDAO manipulaDAO = new ManipulacaoDAO();

	public RequisicaoPerfilDAO() {

	}

	/**
	 * Retorna todas as requisicaos cadastradas no sistema
	 *
	 * @param requisicao
	 * @return RequisicaoPerfil[]
	 * @throws br.senac.sp.exception.RequisicaoPessoalException
	 */
	public RequisicaoPerfil[] getRequisicaoPerfils() throws RequisicaoPessoalException {
		return getRequisicaoPerfils("");
	}

	private int dmlRequisicaoPerfil(int tipoDML, RequisicaoPerfil requisicaoPerfil, int... gravaHistoricoChapa)
			throws RequisicaoPessoalException {

		int sucesso = 1;
		Transacao transacao = new Transacao(DATA_BASE_NAME);
		StringBuffer parametros = new StringBuffer();
		String tipoTransacao = "";
		CallableStatement stmt = null;

		switch (tipoDML) {
		case 0:
			tipoTransacao = "inserir";
			break;
		case 1:
			tipoTransacao = "alterar";
			break;
		}
		;

		try {
			stmt = transacao.getCallableStatement(
					"{call reqpes.SP_DML_REQUISICAO_PERFIL(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			stmt.setInt(1, tipoDML); // 0 INSERT, 1 UPDATE
			stmt.setInt(2, requisicaoPerfil.getCodRequisicao());
			stmt.setInt(3, requisicaoPerfil.getSqNivel());
			stmt.setString(4, requisicaoPerfil.getSexo());
			stmt.setString(5, requisicaoPerfil.getDescricaoFormacao());
			stmt.setInt(6, requisicaoPerfil.getFaixaEtariaIni());
			stmt.setInt(7, requisicaoPerfil.getFaixaEtariaFim());
			stmt.setString(8, requisicaoPerfil.getOutrasCarateristica());
			stmt.setInt(9, requisicaoPerfil.getExperiencia());
			stmt.setString(10, requisicaoPerfil.getComplementoEscolaridade());
			stmt.setString(11, requisicaoPerfil.getTipoExperiencia());
			stmt.setString(12, requisicaoPerfil.getComentarios());
			stmt.setString(13, requisicaoPerfil.getDscOportunidade());
			stmt.setString(14, requisicaoPerfil.getDscAtividadesCargo());
			stmt.setInt(15, requisicaoPerfil.getCodArea());
			stmt.setInt(16, requisicaoPerfil.getCodNivelHierarquia());
			stmt.setInt(17, requisicaoPerfil.getCodFuncao());
			stmt.setString(18, requisicaoPerfil.getDscExperiencia());
			stmt.setString(19, requisicaoPerfil.getDscConhecimentos());

			if (requisicaoPerfil.getListFuncao() == null) {
				stmt.setNull(20, OracleTypes.VARCHAR);
			} else {
				stmt.setString(20, requisicaoPerfil.getListFuncao());
			}

			if (gravaHistoricoChapa.length > 0) {
				stmt.setInt(21, gravaHistoricoChapa[0]);
			} else {
				stmt.setInt(21, 0);
			}

			// Gerando log com parâmetros recebidos
			parametros.append("\n1," + tipoDML);
			parametros.append("\n2," + requisicaoPerfil.getCodRequisicao());
			parametros.append("\n3," + requisicaoPerfil.getSqNivel());
			parametros.append("\n4," + requisicaoPerfil.getSexo());
			parametros.append("\n5," + requisicaoPerfil.getDescricaoFormacao());
			parametros.append("\n6," + requisicaoPerfil.getFaixaEtariaIni());
			parametros.append("\n7," + requisicaoPerfil.getFaixaEtariaFim());
			parametros.append("\n8," + requisicaoPerfil.getOutrasCarateristica());
			parametros.append("\n9," + requisicaoPerfil.getExperiencia());
			parametros.append("\n10," + requisicaoPerfil.getComplementoEscolaridade());
			parametros.append("\n11," + requisicaoPerfil.getTipoExperiencia());
			parametros.append("\n12," + requisicaoPerfil.getComentarios());
			parametros.append("\n13," + requisicaoPerfil.getDscOportunidade());
			parametros.append("\n14," + requisicaoPerfil.getDscAtividadesCargo());
			parametros.append("\n15," + requisicaoPerfil.getCodArea());
			parametros.append("\n16," + requisicaoPerfil.getCodNivelHierarquia());
			parametros.append("\n17," + requisicaoPerfil.getCodFuncao());
			parametros.append("\n18," + requisicaoPerfil.getDscExperiencia());
			parametros.append("\n19," + requisicaoPerfil.getDscConhecimentos());
			parametros.append("\n20," + requisicaoPerfil.getListFuncao());

			// registrando parametro de saida
			stmt.registerOutParameter(2, Types.INTEGER);
			transacao.executeCallableStatement(stmt);

			if (tipoDML >= 0) {
				sucesso = stmt.getInt(2);
			}

		} catch (SQLException e) {
			sucesso = 0;
			throw new RequisicaoPessoalException(
					"Ocorreu um erro ao " + tipoTransacao + " a RequisicaoPerfil: \n: " + parametros.toString(),
					e.getMessage());

		} catch (Exception e) {
			sucesso = 0;
			throw new RequisicaoPessoalException(
					"Ocorreu um erro ao " + tipoTransacao + " a RequisicaoPerfil: \n: " + parametros.toString(),
					e.getMessage());
		} finally {
			try {
				stmt.close();
				transacao.end();
			} catch (SQLException e) {
				throw new RequisicaoPessoalException("Erro ao fechar conexao com RequisicaoPerfil ", e.getMessage());
			}
		}

		return sucesso;
	}

	/**
	 * @param requisicao
	 * @return int
	 * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
	 * @procedure: SP_DML_REQUISICAO_JORNADA
	 */
	public int gravaRequisicaoPerfil(RequisicaoPerfil requisicaoPerfil) throws RequisicaoPessoalException {
		return this.dmlRequisicaoPerfil(0, requisicaoPerfil);
	}

	/**
	 * @param requisicao
	 * @return int
	 * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
	 * @procedure: SP_DML_REQUISICAO_JORNADA
	 */
	public int alteraRequisicaoPerfil(RequisicaoPerfil requisicaoPerfil) throws RequisicaoPessoalException {
		return this.dmlRequisicaoPerfil(1, requisicaoPerfil);
	}

	/**
	 * @param requisicao,
	 *            historico
	 * @return int
	 * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
	 * @procedure: SP_DML_REQUISICAO_JORNADA
	 */
	public int alteraRequisicaoPerfil(RequisicaoPerfil requisicaoPerfil, int gravaHistoricoChapa)
			throws RequisicaoPessoalException {
		return this.dmlRequisicaoPerfil(1, requisicaoPerfil, gravaHistoricoChapa);
	}

	/**
	 * Retorna uma instancia da classe RequisicaoPerfil, de acordo com o codigo
	 * informado
	 *
	 * @return RequisicaoPerfil
	 * @throws br.senac.sp.exception.RequisicaoPessoalException
	 */
	public RequisicaoPerfil getRequisicaoPerfil(int codRequisicao) throws RequisicaoPessoalException {
		RequisicaoPerfil[] requisicao = getRequisicaoPerfils(" WHERE RP.REQUISICAO_SQ = " + codRequisicao);
		return (requisicao.length > 0) ? requisicao[0] : null;
	}

	/**
	 * Retorna um array de objetos RequisicaoPerfil que satifaz a condição
	 * informada
	 *
	 * @param condicao
	 * @return array de objetos RequisicaoPerfil
	 * @throws br.senac.sp.exception.RequisicaoPessoalException
	 */

	public RequisicaoPerfil[] getRequisicaoPerfils(String condicao) throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		ArrayList listaRequisicaoPerfil = new ArrayList();
		RequisicaoPerfil requisicaoPerfil = new RequisicaoPerfil();
		RequisicaoPerfil[] requisicaoPerfils = null;
		Transacao transacao = new Transacao(DATA_BASE_NAME);
		ResultSet rs = null;

		sql.append(" SELECT RP.REQUISICAO_SQ ");
		sql.append("       ,RP.SQ_NIVEL ");
		sql.append("       ,RP.SEXO ");
		sql.append("       ,RP.DS_FORMACAO ");
		sql.append("       ,RP.FAIXA_ETARIA_INI ");
		sql.append("       ,RP.FAIXA_ETARIA_FIM ");
		sql.append("       ,RP.OUTRAS_CARATERISTICA ");
		sql.append("       ,RP.EXPERIENCIA ");
		sql.append("       ,RP.COMPLEMENTO_ESCOLARIDADE ");
		sql.append("       ,RP.TP_EXPERIENCIA ");
		sql.append("       ,RP.COMENTARIOS ");
		sql.append("       ,RP.DSC_OPORTUNIDADE ");
		sql.append("       ,RP.DSC_ATIVIDADES_CARGO ");
		sql.append("       ,RP.COD_AREA ");
		sql.append("       ,RP.COD_NIVEL_HIERARQUIA ");
		sql.append("       ,RP.COD_FUNCAO ");
		sql.append("       ,RP.DSC_EXPERIENCIA ");
		sql.append("       ,RP.DSC_CONHECIMENTOS ");
		sql.append("       ,F_GET_PERFIL_COD_FUNCAO(RP.REQUISICAO_SQ) AS LIST_FUNCAO ");
		sql.append(" FROM   reqpes.REQUISICAO_PERFIL RP ");
		sql.append(condicao);

		try {
			rs = transacao.getCursor(sql.toString());
			while (rs.next()) {
				// Setando os atributos
				requisicaoPerfil.setCodRequisicao(rs.getInt("REQUISICAO_SQ"));
				requisicaoPerfil.setComentarios(rs.getString("COMENTARIOS"));
				requisicaoPerfil.setComplementoEscolaridade(rs.getString("COMPLEMENTO_ESCOLARIDADE"));
				requisicaoPerfil.setDescricaoFormacao(rs.getString("DS_FORMACAO"));
				requisicaoPerfil.setExperiencia(rs.getInt("EXPERIENCIA"));
				requisicaoPerfil.setFaixaEtariaIni(rs.getInt("FAIXA_ETARIA_INI"));
				requisicaoPerfil.setFaixaEtariaFim(rs.getInt("FAIXA_ETARIA_FIM"));
				requisicaoPerfil.setOutrasCarateristica(rs.getString("OUTRAS_CARATERISTICA"));
				requisicaoPerfil.setSexo(rs.getString("SEXO"));
				requisicaoPerfil.setTipoExperiencia(rs.getString("TP_EXPERIENCIA"));
				requisicaoPerfil.setSqNivel(rs.getInt("SQ_NIVEL"));
				requisicaoPerfil.setDscOportunidade(rs.getString("DSC_OPORTUNIDADE"));
				requisicaoPerfil.setDscAtividadesCargo(rs.getString("DSC_ATIVIDADES_CARGO"));
				requisicaoPerfil.setCodArea(rs.getInt("COD_AREA"));
				requisicaoPerfil.setCodNivelHierarquia(rs.getInt("COD_NIVEL_HIERARQUIA"));
				requisicaoPerfil.setCodFuncao(rs.getInt("COD_FUNCAO"));
				requisicaoPerfil.setDscExperiencia(rs.getString("DSC_EXPERIENCIA"));
				requisicaoPerfil.setDscConhecimentos(rs.getString("DSC_CONHECIMENTOS"));
				requisicaoPerfil.setListFuncao(rs.getString("LIST_FUNCAO"));

				// Adicionando na lista
				listaRequisicaoPerfil.add(requisicaoPerfil);
				requisicaoPerfil = new RequisicaoPerfil();
			}

			// Dimensionando o array
			requisicaoPerfils = new RequisicaoPerfil[listaRequisicaoPerfil.size()];

			// Transferindo a lista para o array
			listaRequisicaoPerfil.toArray(requisicaoPerfils);

		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"RequisicaoPerfilDAO  \n -> Problemas na consulta de RequisicaoPerfil: \n\n " + sql.toString(),
					e.getMessage());
		} finally {
			try {
				rs.close();
				rs = null;
				transacao.end();
			} catch (Exception e) {
				throw new RequisicaoPessoalException(
						"RequisicaoPerfilDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(),
						e.getMessage());
			}
		}
		return requisicaoPerfils;
	}

	/**
	 * Carrega o combo de Escolaridades
	 *
	 * @return String[][]
	 * @throws RequisicaoPessoalException
	 */
	public String[][] getComboEscolaridade() throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		String[][] retorno = null;

		// -- Query que retorna os tipos de escolaridades
		sql.append(" SELECT E.CODIGO ");
		sql.append("       ,E.DESCRICAO ");
		sql.append(" FROM   ESCOLARIDADES E ");
		sql.append(" ORDER  BY E.CODIGO ");

		try {
			retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME);
		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"RequisicaoPerfilDAO  \n -> Problemas na consulta  de Requisicao: \n\n " + sql.toString(),
					e.getMessage());
		}
		return retorno;
	}

	/**
	 * Carrega os valores dos combos de domínios do sistema de RECRUTAMENTO E
	 * SELEÇÃO
	 *
	 * @return String[][]
	 * @throws RequisicaoPessoalException
	 */
	public String[][] getComboDominioRecru(String grupo) throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		String[][] retorno = null;

		sql.append(" SELECT ID_TIPO ");
		sql.append("       ,UPPER(NOME) ");
		sql.append(" FROM   recru.RECRU_TIPO ");
		sql.append(" WHERE  GRUPO = '" + grupo + "' ");
		sql.append(" AND    FL_ATIVO = 'S' ");
		sql.append(" ORDER  BY NOME ");

		try {
			retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME);
		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"RequisicaoPerfilDAO  \n -> Problemas na consulta  de getComboDominioRecru: \n\n " + sql.toString(),
					e.getMessage());
		}
		return retorno;
	}

	/**
	 * Carrega os valores do combo de FUNÇÕES do sistema de RECRUTAMENTO E
	 * SELEÇÃO
	 *
	 * @return String[][]
	 * @throws RequisicaoPessoalException
	 */
	public String[][] getComboFuncao() throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		String[][] retorno = null;

		sql.append(" SELECT ID_FUNCAO ");
		sql.append("       ,UPPER(NOME) ");
		sql.append(" FROM   recru.RECRU_FUNCAO ");
		sql.append(" ORDER  BY NOME ");

		try {
			retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME);
		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"RequisicaoPerfilDAO  \n -> Problemas na consulta  de getComboFuncao: \n\n " + sql.toString(),
					e.getMessage());
		}
		return retorno;
	}
}