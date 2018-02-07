package br.senac.sp.reqpes.DAO;

//-- Classes do Java
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

//-- Componentes
import br.senac.sp.Transacao;
import br.senac.sp.componente.DAO.ManipulacaoDAO;
import br.senac.sp.componente.model.Usuario;
//-- Classes da aplicação
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.Interface.InterfaceDataBase;
import br.senac.sp.reqpes.model.CargoAdmCoord;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 5/11/2009
 */

public class CargoAdmCoordDAO implements InterfaceDataBase {
	ManipulacaoDAO manipulaDAO = new ManipulacaoDAO();

	public CargoAdmCoordDAO() {
	}

	/**
	 * @return int
	 * @param cargoAdmCoord,
	 *            usuario
	 * @Procedure PROCEDURE SP_DML_CARGO_ADM_COORD(P_IN_DML IN NUMBER
	 *            ,P_IN_COD_UNIDADE IN VARCHAR2 ,P_IN_USUARIO IN NUMBER) IS
	 */

	private int dmlCargoAdmCoord(int tipoDML, CargoAdmCoord cargoAdmCoord, Usuario usuario)
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
			stmt = transacao.getCallableStatement("{call reqpes.SP_DML_CARGO_ADM_COORD(?,?,?)}");
			stmt.setInt(1, tipoDML); // 0 INSERT, -1 DELETE
			stmt.setString(2, cargoAdmCoord.getCodUnidade());
			stmt.setInt(3, usuario.getChapa());

			transacao.executeCallableStatement(stmt);

		} catch (SQLException e) {
			sucesso = 0;
			throw new RequisicaoPessoalException("Ocorreu um erro ao " + tipoTransacao + " em CargoAdmCoordDAO: \n",
					e.getMessage() + cargoAdmCoord.getCodUnidade());
		} catch (Exception e) {
			sucesso = 0;
			throw new RequisicaoPessoalException("Ocorreu um erro ao " + tipoTransacao + " em CargoAdmCoordDAO: \n",
					e.getMessage() + cargoAdmCoord.getCodUnidade());
		} finally {
			try {
				stmt.close();
				transacao.end();
			} catch (SQLException e) {
				throw new RequisicaoPessoalException("Erro ao fechar conexao com dmlCargoAdmCoord ", e.getMessage());
			}
		}
		return sucesso;
	}

	/**
	 * @param cargoAdmCoord,
	 *            usuario
	 * @return int
	 * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
	 * @procedure: SP_DML_CARGO_ADM_COORD
	 */
	public int gravaCargoAdmCoord(CargoAdmCoord cargoAdmCoord, Usuario usuario) throws RequisicaoPessoalException {
		return this.dmlCargoAdmCoord(0, cargoAdmCoord, usuario);
	}

	/**
	 * @param cargoAdmCoord,
	 *            usuario
	 * @return int
	 * @throws br.senac.sp.descontosCorporativos.Exception.RequisicaoPessoalException
	 * @procedure: SP_DML_CARGO_ADM_COORD
	 */
	public int deletaCargoAdmCoord(CargoAdmCoord cargoAdmCoord, Usuario usuario) throws RequisicaoPessoalException {
		return this.dmlCargoAdmCoord(-1, cargoAdmCoord, usuario);
	}

	/**
	 * @return List de objetos CargoAdmCoord
	 * @throws br.senac.sp.exception.RequisicaoPessoalException
	 */
	public List getCargoAdmCoord() throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		ArrayList listUnidades = new ArrayList();
		CargoAdmCoord cargoAdmCoord = new CargoAdmCoord();
		Transacao transacao = new Transacao(DATA_BASE_NAME);
		ResultSet rs = null;

		sql.append(" SELECT T.COD_UNIDADE ");
		sql.append("       ,UO.DESCRICAO ");
		sql.append(" FROM   reqpes.UO_CARGO_ADM_COORD       T ");
		sql.append("       ,rhev.UNIDADES_ORGANIZACIONAIS UO ");
		sql.append(" WHERE  UO.CODIGO = T.COD_UNIDADE ");
		sql.append(" ORDER  BY DESCRICAO ");

		try {
			rs = transacao.getCursor(sql.toString());
			while (rs.next()) {
				// Setando os atributos
				cargoAdmCoord.setCodUnidade(rs.getString("COD_UNIDADE"));
				cargoAdmCoord.setNomUnidade(rs.getString("DESCRICAO"));

				// Adicionando na lista
				listUnidades.add(cargoAdmCoord);
				cargoAdmCoord = new CargoAdmCoord();
			}

		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"CargoAdmCoordDAO  \n -> Problemas na consulta de getCargoAdmCoord: \n\n " + sql.toString(),
					e.getMessage());
		} finally {
			try {
				rs.close();
				rs = null;
				transacao.end();
			} catch (Exception e) {
				throw new RequisicaoPessoalException(
						"CargoAdmCoordDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(),
						e.getMessage());
			}
		}
		return listUnidades;
	}

	/**
	 * @return List de objetos CargoAdmCoord (todas as unidades)
	 * @throws br.senac.sp.exception.RequisicaoPessoalException
	 */
	public List getComboUnidades() throws RequisicaoPessoalException {
		StringBuffer sql = new StringBuffer();
		ArrayList listUnidades = new ArrayList();
		CargoAdmCoord cargoAdmCoord = new CargoAdmCoord();
		Transacao transacao = new Transacao(DATA_BASE_NAME);
		ResultSet rs = null;

		sql.append(" SELECT UO.CODIGO ");
		sql.append("       ,UO.DESCRICAO ");
		sql.append(" FROM   rhev.UNIDADES_ORGANIZACIONAIS UO ");
		sql.append(" WHERE  UO.NIVEL = 2 ");
		sql.append(" AND    UO.DATA_ENCERRAMENTO IS NULL ");
		sql.append(" AND    UO.CODIGO NOT IN ('SA', 'SD', 'SO', 'SU') ");
		sql.append(" AND    NOT EXISTS (SELECT 1 FROM UO_CARGO_ADM_COORD T WHERE T.COD_UNIDADE = UO.CODIGO) ");
		sql.append(" ORDER  BY UO.CODIGO, UO.DESCRICAO ");

		try {
			rs = transacao.getCursor(sql.toString());
			while (rs.next()) {
				// Setando os atributos
				cargoAdmCoord.setCodUnidade(rs.getString("CODIGO"));
				cargoAdmCoord.setNomUnidade(rs.getString("DESCRICAO"));

				// Adicionando na lista
				listUnidades.add(cargoAdmCoord);
				cargoAdmCoord = new CargoAdmCoord();
			}

		} catch (Exception e) {
			throw new RequisicaoPessoalException(
					"CargoAdmCoordDAO  \n -> Problemas na consulta de getComboUnidades: \n\n " + sql.toString(),
					e.getMessage());
		} finally {
			try {
				rs.close();
				rs = null;
				transacao.end();
			} catch (Exception e) {
				throw new RequisicaoPessoalException(
						"CargoAdmCoordDAO  \n -> Problemas ao fechar a conexão: \n\n " + sql.toString(),
						e.getMessage());
			}
		}
		return listUnidades;
	}
}