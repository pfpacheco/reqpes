package br.senac.sp.reqpes.Control;

//-- Classes da aplicação
import java.util.List;

import br.senac.sp.componente.Exception.AdmTIException;
import br.senac.sp.componente.model.Usuario;
import br.senac.sp.reqpes.DAO.CentroCustoDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;

public class CentroCustoControl {

	CentroCustoDAO ccDAO;

	public CentroCustoControl() {
		ccDAO = new CentroCustoDAO();
	}

	public String getIdCodeCombination(String centroCusto) throws RequisicaoPessoalException {
		return ccDAO.getIdCodeCombination(centroCusto);
	}

	public List getSegmentos(int tipoSegmento, Usuario usuario) throws RequisicaoPessoalException, AdmTIException {
		return ccDAO.getSegmentos(tipoSegmento, usuario);
	}
}