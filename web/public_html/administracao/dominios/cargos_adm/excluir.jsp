<%  session.setAttribute("root","../../../"); %>
<%@ page errorPage="../../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:useBean id="cargoAdmCoord" class="br.senac.sp.reqpes.model.CargoAdmCoord" />
<jsp:setProperty name="cargoAdmCoord" property="*" />

<%
  //-- Gravando
  new CargoAdmCoordControl().deletaCargoAdmCoord(cargoAdmCoord, (Usuario) session.getAttribute("usuario"));    
%>

<script language="JavaScript">
  window.location = "index.jsp";
</script>