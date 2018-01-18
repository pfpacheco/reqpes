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
import br.senac.sp.componente.model.Usuario;
//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.GrupoNecUsuario;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 2/6/2009
 */

public class GrupoNecUsuarioDAO implements InterfaceDataBase {
	ManipulacaoDAO manipulaDAO = new ManipulacaoDAO();

	public GrupoNecUsuarioDAO() {

	}

	/**
	 * @return int
	 * @param grupoNecUsuario,
	 *            usuario
	 * @Procedure PROCEDURE SP_DML_GRUPO_NEC_USUARIOS(P_IN_DML IN NUMBER
	 *            ,P_IN_COD_GRUPO IN OUT NUMBER ,P_IN_CHAPA IN VARCHAR2
	 *            ,P_IN_USUARIO IN VARCHAR2) IS
	 */

	private int dmlGrupoNecUsuario(int tipoDML, GrupoNecUsuario grupoNecUsuario, Usuario usuario)
			throws RequisicaoPessoalException {

		int sucesso = 1;
		Transacao transacao = new Transacao(DATA_BASE_NAME);
		String tipoTransacao = "";
		CallableStatement stmt = null;

		switch (tipoDML) {
		case -1:
			tipoTransacao = "excluir";
			break;
		case 0:
			tipoTransacao = "inserir";
			break;
		}
		;

		try {
			stmt = transacao.getCallableStatement("{call reqpes.SP_DML_GRUPO_NEC_USUARIOS(?,?,?,?)}");
			stmt.setInt(1, tipoDML); // 0 INSERT, -1 DELETE
			stmt.setInt(2, grupoNecUsuario.getCodGrupo());
			stmt.setInt(3, grupoNecUsuario.getChapa());
			stmt.setString(4, String.valueOf(usuario.getChapa()));

			// registrando parametro de saida
			stmt.registerOutParameter(2, Types.INTEGER);
			transacao.executeCallableStatement(stmt);

			if (tipoDML >= 0) {
				sucesso = stmt.getInt(2);
			}

		} catch (SQLException e) {
			sucesso = 0;
			throw new RequisicaoPessoalException("Ocorreu um erro ao " + tipoTransacao + " a GrupoNecUsuario: \n",
					e.getMessage());
		} catch (Exception e) {
			sucesso = 0;
			throw new RequisicaoPessoalException("Ocorreu um erro ao " + tipoTransacao + " a GrupoNecUsuario: \n",
					e.getMessage());
		} finally {
			try {
				stmt.close();
				transacao.end();
			} catch (SQLException e) {
				throw new RequisicaoPessoalException("Erro ao fechar conexao com GrupoNecUsuario ", e.getMessage());
			}
		}
		return sucesso;
	}

	/**
	 * @param grupoNecUsuario,
	 *            usuario
	 * @return int
	 * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
	 * @procedure: SP_DML_GRUPO_NEC_USUARIOS
	 */
	public int gravaGrupoNecUsuario(GrupoNecUsuario grupoNecUsuario, Usuario usuario)
			throws RequisicaoPessoalException {
		return this.dmlGrupoNecUsuario(0, grupoNecUsuario, usuario);
	}

	/**
	 * @param grupoNecUsuario,
	 *            usuario
	 * @return int
	 * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
	 * @procedure: SP_DML_GRUPO_NEC_USUARIOS
	 */
	public int deletaGrupoNecUsuario(GrupoNecUsuario grupoNecUsuario, Usuario usuario)
			throws RequisicaoPessoalException {
		return this.dmlGrupoNecUsuario(-1, grupoNecUsuario, usuario);
	}

	/**
	 * Retorna uma instancia da classe GrupoNecUsuario, de acordo com o codigo
	 * informado
	 *
	 * @return GrupoNecUsuario
	 * @throws br.senac.sp.exception.RequisicaoPessoalException
	 */
	public GrupoNecUsuario getGrupoNecUsuario(int chapa) throws RequisicaoPessoalException {
		GrupoNecUsuario[] grupoNecUsuario = getGrupoNecUsuarios(" AND GU.CHAPA = " + chapa);
		return (grupoNecUsuario.length > 0) ? grupoNecUsuario[0] : null;
	}

	/**
	 * Retorna um array de objetos GrupoNecUsuario que satifaz a condição
	 * informada
	 *
	 * @param condicao
	 * @return array de objetos GrupoNecUsuario
	 * @throws br.senac.sp.exception.RequisicaoPessoalException
	 */

	public GrupoNecUsuario[] getGrupoNecUsuarios(String condicao) throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		ArrayList listaGrupoNecUsuario = new ArrayList();
		GrupoNecUsuario grupoNecUsuario = new GrupoNecUsuario();
		GrupoNecUsuario[] grupoNecUsuarios = null;
		Transacao transacao = new Transacao(DATA_BASE_NAME);
		ResultSet rs = null;

		sql.append(" SELECT UNIQUE GU.CHAPA ");
		sql.append("       ,F.NOME ");
		sql.append(" FROM   reqpes.GRUPO_NEC_USUARIOS GU ");
		sql.append("       ,FUNCIONARIOS F ");
		sql.append(" WHERE GU.CHAPA = F.ID ");
		sql.append(condicao);
		sql.append(" ORDER  BY F.NOME ");

		try {
			rs = transacao.getCursor(sql.toString());
			while (rs.next()) {
				// Setando os atributos
				grupoNecUsuario.setChapa(rs.getInt("CHAPA"));
				grupoNecUsuario.setNomUsuario(rs.getString("NOME"));

				// Adicionando na lista
				listaGrupoNecUsuario.add(grupoNecUsuario);
				grupoNecUsuario = new GrupoNecUsuario();
			}

			// Dimensionando o array
			grupoNecUsuarios = new GrupoNecUsuario[listaGrupoNecUsuario.size()];

			// Transferindo a lista para o array
			listaGrupoNecUsuario.toArray(grupoNecUsuarios);

		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"GrupoNecUsuarioDAO  \n -> Problemas na consulta de GrupoNecUsuario: \n\n " + sql.toString(),
					e.getMessage());
		} finally {
			try {
				rs.close();
				rs = null;
				transacao.end();
			} catch (Exception e) {
				throw new RequisicaoPessoalException(
						"GrupoNecUsuarioDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(),
						e.getMessage());
			}
		}
		return grupoNecUsuarios;
	}

	/**
	 * @return String[][]
	 * @throws RequisicaoPessoalException
	 */
	public String[][] getComboUsuarios() throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		String[][] retorno = null;

		sql.append(" SELECT F.ID ");
		sql.append("       ,F.NOME ");
		sql.append(" FROM   FUNCIONARIOS F ");
		sql.append("       ,reqpes.USUARIO      U ");
		sql.append(" WHERE  U.IDENTIFICACAO = F.ID ");
		sql.append(" AND    F.ATIVO = 'A' ");
		sql.append(" AND    U.COD_UNIDADE = 12 ");
		sql.append(" AND    F.TIPO_COLAB <> 'P' ");
		sql.append(" AND    NOT EXISTS (SELECT 1 FROM GRUPO_NEC_USUARIOS G WHERE G.CHAPA = F.ID) ");
		sql.append(" ORDER  BY F.NOME ");

		try {
			retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME);
		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"GrupoNecUsuarioDAO  \n -> Problemas na consulta de getComboUsuarios: \n\n " + sql.toString(),
					e.getMessage());
		}
		return retorno;
	}

	/**
	 * @return String[][]
	 * @throws RequisicaoPessoalException
	 */
	public String[][] getGruposNecByUsuario(int chapa) throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		String[][] retorno = null;

		sql.append(" SELECT reqpes.F_GET_SEL_GRUPO_NEC_USUARIO(G.COD_GRUPO, " + chapa + ") IND ");
		sql.append("       ,G.COD_GRUPO ");
		sql.append("       ,G.DSC_GRUPO ");
		sql.append(" FROM   reqpes.GRUPO_NEC G ");
		sql.append(" ORDER  BY G.DSC_GRUPO ");

		try {
			retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME);
		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"GrupoNecUsuarioDAO  \n -> Problemas na consulta de getGruposNecByUsuario: \n\n " + sql.toString(),
					e.getMessage());
		}
		return retorno;
	}

	/**
	 * @return String[][]
	 * @throws RequisicaoPessoalException
	 */
	public String[][] getUnidadesByUsuario(int chapa) throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		String[][] retorno = null;

		sql.append(" SELECT ''''||COD_UNIDADE||'''' ");
		sql.append(" FROM   reqpes.GRUPO_NEC_UNIDADES G ");
		sql.append("       ,reqpes.GRUPO_NEC_USUARIOS U ");
		sql.append(" WHERE  G.COD_GRUPO = U.COD_GRUPO ");
		sql.append(" AND    U.CHAPA = " + chapa);

		try {
			retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME);
		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"GrupoNecUsuarioDAO  \n -> Problemas na consulta de getUnidadesByUsuario: \n\n " + sql.toString(),
					e.getMessage());
		}
		return retorno;
	}

	/**
	 * @return String[][]
	 * @throws RequisicaoPessoalException
	 */
	public String[][] getUsuariosByUnidade(String codUnidade) throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		String[][] retorno = null;

		sql.append(" SELECT GU.CHAPA ");
		sql.append("       ,FC.E_MAIL ");
		sql.append(" FROM   reqpes.GRUPO_NEC_USUARIOS      GU ");
		sql.append("       ,FUNCIONARIO_COMPLEMENTO FC ");
		sql.append(" WHERE  FC.ID_FUNCIONARIO = GU.CHAPA ");
		sql.append(" AND    FC.E_MAIL         IS NOT NULL ");
		sql.append(
				" AND    GU.COD_GRUPO      = (SELECT COD_GRUPO FROM (SELECT GUO.COD_GRUPO FROM GRUPO_NEC_UNIDADES GUO WHERE GUO.COD_UNIDADE =");
		sql.append(" '" + codUnidade + "') where ROWNUM <= 1)");

		try {
			retorno = manipulaDAO.getMatriz(sql.toString(), DATA_BASE_NAME);
		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"GrupoNecUsuarioDAO  \n -> Problemas na consulta de getUsuariosByUnidade: \n\n " + sql.toString(),
					e.getMessage());
		}
		return retorno;
	}
}