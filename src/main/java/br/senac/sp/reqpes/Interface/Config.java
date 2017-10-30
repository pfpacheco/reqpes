package br.senac.sp.reqpes.Interface;

import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

/**
 * @author Thiago Lima Coutinho
 * @date 11/09/2008
 * @version 1
 * @since
 */

public class Config {

	public static final String NOME_SISTEMA = "REQUISIÇÃO DE PESSOAL";
	public static final int ID_SISTEMA = 7;
	public static final String EMAIL_ERRO = "GrupoGES-SistemasTecnologia@sp.senac.br";

	public static final ResourceBundle main = PropertyResourceBundle.getBundle("properties.main");
	public static final String smtp = main.getString("smtp");
	public static final String SMTP = smtp;

	public Config() {
	}
}