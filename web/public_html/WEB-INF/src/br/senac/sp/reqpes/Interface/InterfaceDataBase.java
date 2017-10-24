package br.senac.sp.reqpes.Interface;

/**
 * @author Thiago Lima Coutinho
 * @date   11/09/2008
 * @version 1
 * @since  
 */
public interface InterfaceDataBase{

  // Esta constante representa o nome do Data Source do sistema. 
	public static final String DATA_BASE_NAME = "DsRequisicaoPessoal"; 

  // Esta constante representa o nome do Data Source do sistema. 
	public static final String DATA_BASE_NAME_VS_ANTERIOR = "DsRequisicaoPessoalVsAnterior"; 
  
  // Esta constante representa o nome do Data Source do INFOGES, para carga dos perfis e menus
	public static final String DATA_BASE_NAME_INFOGES = "DsAdmTI"; 
  
  // Este Atributo representa o nome do DataSource para pesquisa de usuario do Login Unico
	public static final String LOGIN_UNICO = "LoginUnico";
  
}  