package br.senac.sp.reqpes.Control;

//-- Classes da aplicação
import br.senac.sp.reqpes.DAO.CargoAdmCoordDAO;
import br.senac.sp.reqpes.Exception.RequisicaoPessoalException;
import br.senac.sp.reqpes.model.CargoAdmCoord;
import br.senac.sp.componente.model.Usuario;
import java.util.List;

/**
 * @author Thiago Lima Coutinho
 * @version 1
 * @data: 5/11/2009
 */
 
public class CargoAdmCoordControl {
  CargoAdmCoordDAO cargoAdmCoordDAO;
  
  public CargoAdmCoordControl() {
    cargoAdmCoordDAO = new CargoAdmCoordDAO();
  }
  
  public int gravaCargoAdmCoord(CargoAdmCoord cargoAdmCoord, Usuario usuario) throws RequisicaoPessoalException{ 
    return cargoAdmCoordDAO.gravaCargoAdmCoord(cargoAdmCoord, usuario);
  }

  public int deletaCargoAdmCoord(CargoAdmCoord cargoAdmCoord, Usuario usuario) throws RequisicaoPessoalException{ 
    return cargoAdmCoordDAO.deletaCargoAdmCoord(cargoAdmCoord, usuario);
  }
  
  public List getCargoAdmCoord() throws RequisicaoPessoalException {
    return cargoAdmCoordDAO.getCargoAdmCoord();
  }
  
  public List getComboUnidades() throws RequisicaoPessoalException {
    return cargoAdmCoordDAO.getComboUnidades();
  }
}