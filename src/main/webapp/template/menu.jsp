<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.DAO.ManipulacaoDAO" %>
<%@ page import="br.senac.sp.reqpes.Interface.*" %>
<%
	String contextPath = request.getContextPath();
%>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/ddsmoothmenu.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.3.2.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ddsmoothmenu.js">
  /***********************************************
  * Smooth Navigational Menu- (c) Dynamic Drive DHTML code library (www.dynamicdrive.com)
  * This notice MUST stay intact for legal use
  * Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
  ***********************************************/
</script>
<script type="text/javascript">
  ddsmoothmenu.init({
    mainmenuid: "sistemaMenu",
    imgPath: "<%=contextPath%>/imagens/"
  });
</script>
<%
	Usuario usuario = (Usuario) session.getAttribute("usuario");
	if (usuario != null) {
		StringBuffer sql = new StringBuffer();
		sql.append(" SELECT VW.COD_SISTEMA_MENU ");
		sql.append("       ,VW.NOM_MENU ");
		sql.append("       ,VW.DSC_LINK ");
		sql.append("       ,VW.COD_SISTEMA_MENU_PAI ");
		sql.append("       ,VW.NUM_POSICAO_TELA ");
		sql.append(" FROM   ADM_TI.VW_MENU_SISTEMA     VW ");
		sql.append("       ,ADM_TI.SISTEMA_PERFIL_MENU SPM ");
		sql.append(" WHERE  VW.COD_SISTEMA_MENU = SPM.COD_SISTEMA_MENU ");
		sql.append(" AND    COD_SISTEMA = " + Config.ID_SISTEMA);
		sql.append(" AND    COD_SISTEMA_PERFIL = " + usuario.getSistemaPerfil().getCodSistemaPerfil());
		sql.append(" ORDER  BY 5");

		String[][] menu = new ManipulacaoDAO().getMatriz(sql.toString(), InterfaceDataBase.DATA_BASE_NAME_INFOGES);

		out.println("<div id=\"sistemaMenu\" style=\"visibility: hidden; text-align: left;\">");
		out.println(doMenus(menu, null, contextPath));
		out.println("<br style=\"clear: left;\" />");
		out.println("</div>");
    	out.println("<div style=\"text-align:left; padding-left:5px; padding-top:8px; padding-bottom:0px;\">");
		out.println("<b>Usuário:</b>&nbsp;"+ usuario.getNome());
    	out.println("</div>");
	}
%>
<%!
	private String doMenus(String[][] menu, String idMenuPai, String contextPath) {
		StringBuffer str = new StringBuffer();
		for (int i = 0; i < menu.length; i++) {
			if ((menu[i][3] == null && idMenuPai == null) || (menu[i][3] != null && menu[i][3].equals(idMenuPai))) {
				if (str.length() == 0)
					str.append("<ul>");
				
				str.append("<li>");
				if (menu[i][2] == null)
					str.append("<a>" + menu[i][1] + "</a>");
				else
					str.append("<a href=\"" + contextPath + "/" + menu[i][2] + "\">" + menu[i][1] + "</a>");
				str.append(doMenus(menu, menu[i][0], contextPath));
				str.append("</li>");
			}
		}
		if (str.length() > 0)
			str.append("</ul>");
		
		return str.toString();
	}
%>