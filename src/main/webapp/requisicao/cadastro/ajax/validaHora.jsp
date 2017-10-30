<%@ page import="br.senac.sp.reqpes.Control.RequisicaoControl"%><%@ page import="java.math.BigDecimal"%><%@ page errorPage="../../../error/error.jsp"%><%
  RequisicaoControl requisicaoControl = new RequisicaoControl();
  BigDecimal somatoria = new BigDecimal("0");
  
  String segEntrada1 = (request.getParameter("P_SEG_ENTRADA1")==null)?"0":request.getParameter("P_SEG_ENTRADA1");
  String segSaida1   = (request.getParameter("P_SEG_SAIDA1")==null)?"0":request.getParameter("P_SEG_SAIDA1");
  String segEntrada2 = (request.getParameter("P_SEG_ENTRADA2")==null)?"0":request.getParameter("P_SEG_ENTRADA2");
  String segSaida2   = (request.getParameter("P_SEG_SAIDA2")==null)?"0":request.getParameter("P_SEG_SAIDA2");
  String segEntrada3 = (request.getParameter("P_SEG_ENTRADA3")==null)?"0":request.getParameter("P_SEG_ENTRADA3");
  String segSaida3   = (request.getParameter("P_SEG_SAIDA3")==null)?"0":request.getParameter("P_SEG_SAIDA3");
  String segEntrada4 = (request.getParameter("P_SEG_ENTRADA4")==null)?"0":request.getParameter("P_SEG_ENTRADA4");
  String segSaida4   = (request.getParameter("P_SEG_SAIDA4")==null)?"0":request.getParameter("P_SEG_SAIDA4");
  
  String terEntrada1 = (request.getParameter("P_TER_ENTRADA1")==null)?"0":request.getParameter("P_TER_ENTRADA1");
  String terSaida1   = (request.getParameter("P_TER_SAIDA1")==null)?"0":request.getParameter("P_TER_SAIDA1");
  String terEntrada2 = (request.getParameter("P_TER_ENTRADA2")==null)?"0":request.getParameter("P_TER_ENTRADA2");
  String terSaida2   = (request.getParameter("P_TER_SAIDA2")==null)?"0":request.getParameter("P_TER_SAIDA2");
  String terEntrada3 = (request.getParameter("P_TER_ENTRADA3")==null)?"0":request.getParameter("P_TER_ENTRADA3");
  String terSaida3   = (request.getParameter("P_TER_SAIDA3")==null)?"0":request.getParameter("P_TER_SAIDA3");
  String terEntrada4 = (request.getParameter("P_TER_ENTRADA4")==null)?"0":request.getParameter("P_TER_ENTRADA4");
  String terSaida4   = (request.getParameter("P_TER_SAIDA4")==null)?"0":request.getParameter("P_TER_SAIDA4");
  
  String quaEntrada1 = (request.getParameter("P_QUA_ENTRADA1")==null)?"0":request.getParameter("P_QUA_ENTRADA1");
  String quaSaida1   = (request.getParameter("P_QUA_SAIDA1")==null)?"0":request.getParameter("P_QUA_SAIDA1");
  String quaEntrada2 = (request.getParameter("P_QUA_ENTRADA2")==null)?"0":request.getParameter("P_QUA_ENTRADA2");
  String quaSaida2   = (request.getParameter("P_QUA_SAIDA2")==null)?"0":request.getParameter("P_QUA_SAIDA2");
  String quaEntrada3 = (request.getParameter("P_QUA_ENTRADA3")==null)?"0":request.getParameter("P_QUA_ENTRADA3");
  String quaSaida3   = (request.getParameter("P_QUA_SAIDA3")==null)?"0":request.getParameter("P_QUA_SAIDA3");
  String quaEntrada4 = (request.getParameter("P_QUA_ENTRADA4")==null)?"0":request.getParameter("P_QUA_ENTRADA4");
  String quaSaida4   = (request.getParameter("P_QUA_SAIDA4")==null)?"0":request.getParameter("P_QUA_SAIDA4");
  
  String quiEntrada1 = (request.getParameter("P_QUI_ENTRADA1")==null)?"0":request.getParameter("P_QUI_ENTRADA1");
  String quiSaida1   = (request.getParameter("P_QUI_SAIDA1")==null)?"0":request.getParameter("P_QUI_SAIDA1");
  String quiEntrada2 = (request.getParameter("P_QUI_ENTRADA2")==null)?"0":request.getParameter("P_QUI_ENTRADA2");
  String quiSaida2   = (request.getParameter("P_QUI_SAIDA2")==null)?"0":request.getParameter("P_QUI_SAIDA2");
  String quiEntrada3 = (request.getParameter("P_QUI_ENTRADA3")==null)?"0":request.getParameter("P_QUI_ENTRADA3");
  String quiSaida3   = (request.getParameter("P_QUI_SAIDA3")==null)?"0":request.getParameter("P_QUI_SAIDA3");
  String quiEntrada4 = (request.getParameter("P_QUI_ENTRADA4")==null)?"0":request.getParameter("P_QUI_ENTRADA4");
  String quiSaida4   = (request.getParameter("P_QUI_SAIDA4")==null)?"0":request.getParameter("P_QUI_SAIDA4");
  
  String sexEntrada1 = (request.getParameter("P_SEX_ENTRADA1")==null)?"0":request.getParameter("P_SEX_ENTRADA1");
  String sexSaida1   = (request.getParameter("P_SEX_SAIDA1")==null)?"0":request.getParameter("P_SEX_SAIDA1");
  String sexEntrada2 = (request.getParameter("P_SEX_ENTRADA2")==null)?"0":request.getParameter("P_SEX_ENTRADA2");
  String sexSaida2   = (request.getParameter("P_SEX_SAIDA2")==null)?"0":request.getParameter("P_SEX_SAIDA2");
  String sexEntrada3 = (request.getParameter("P_SEX_ENTRADA3")==null)?"0":request.getParameter("P_SEX_ENTRADA3");
  String sexSaida3   = (request.getParameter("P_SEX_SAIDA3")==null)?"0":request.getParameter("P_SEX_SAIDA3");
  String sexEntrada4 = (request.getParameter("P_SEX_ENTRADA4")==null)?"0":request.getParameter("P_SEX_ENTRADA4");
  String sexSaida4   = (request.getParameter("P_SEX_SAIDA4")==null)?"0":request.getParameter("P_SEX_SAIDA4");
  
  String sabEntrada1 = (request.getParameter("P_SAB_ENTRADA1")==null)?"0":request.getParameter("P_SAB_ENTRADA1");
  String sabSaida1   = (request.getParameter("P_SAB_SAIDA1")==null)?"0":request.getParameter("P_SAB_SAIDA1");
  String sabEntrada2 = (request.getParameter("P_SAB_ENTRADA2")==null)?"0":request.getParameter("P_SAB_ENTRADA2");
  String sabSaida2   = (request.getParameter("P_SAB_SAIDA2")==null)?"0":request.getParameter("P_SAB_SAIDA2"); String sabEntrada3 = (request.getParameter("P_SAB_ENTRADA3")==null)?"0":request.getParameter("P_SAB_ENTRADA3");
  String sabSaida3   = (request.getParameter("P_SAB_SAIDA3")==null)?"0":request.getParameter("P_SAB_SAIDA3");    
  String sabEntrada4 = (request.getParameter("P_SAB_ENTRADA4")==null)?"0":request.getParameter("P_SAB_ENTRADA4");
  String sabSaida4   = (request.getParameter("P_SAB_SAIDA4")==null)?"0":request.getParameter("P_SAB_SAIDA4");    
  
  String domEntrada1 = (request.getParameter("P_DOM_ENTRADA1")==null)?"0":request.getParameter("P_DOM_ENTRADA1");
  String domSaida1   = (request.getParameter("P_DOM_SAIDA1")==null)?"0":request.getParameter("P_DOM_SAIDA1");    
  String domEntrada2 = (request.getParameter("P_DOM_ENTRADA2")==null)?"0":request.getParameter("P_DOM_ENTRADA2");
  String domSaida2   = (request.getParameter("P_DOM_SAIDA2")==null)?"0":request.getParameter("P_DOM_SAIDA2");
  String domEntrada3 = (request.getParameter("P_DOM_ENTRADA3")==null)?"0":request.getParameter("P_DOM_ENTRADA3");
  String domSaida3   = (request.getParameter("P_DOM_SAIDA3")==null)?"0":request.getParameter("P_DOM_SAIDA3");    
  String domEntrada4 = (request.getParameter("P_DOM_ENTRADA4")==null)?"0":request.getParameter("P_DOM_ENTRADA4");
  String domSaida4   = (request.getParameter("P_DOM_SAIDA4")==null)?"0":request.getParameter("P_DOM_SAIDA4");
  double cargaHoraria = (request.getParameter("P_CARGA_HORARIA")==null)?0:Double.parseDouble(request.getParameter("P_CARGA_HORARIA"));
  
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(segEntrada1,segSaida1));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(segEntrada2,segSaida2));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(segEntrada3,segSaida3));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(segEntrada4,segSaida4));
  
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(terEntrada1,terSaida1));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(terEntrada2,terSaida2));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(terEntrada3,terSaida3));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(terEntrada4,terSaida4));
  
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(quaEntrada1,quaSaida1));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(quaEntrada2,quaSaida2));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(quaEntrada3,quaSaida3));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(quaEntrada4,quaSaida4));
  
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(quiEntrada1,quiSaida1));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(quiEntrada2,quiSaida2));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(quiEntrada3,quiSaida3));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(quiEntrada4,quiSaida4));
  
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(sexEntrada1,sexSaida1));    
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(sexEntrada2,sexSaida2));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(sexEntrada3,sexSaida3));    
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(sexEntrada4,sexSaida4));
  
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(sabEntrada1,sabSaida1));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(sabEntrada2,sabSaida2));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(sabEntrada3,sabSaida3));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(sabEntrada4,sabSaida4));  
  
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(domEntrada1,domSaida1));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(domEntrada2,domSaida2));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(domEntrada3,domSaida3));
  somatoria = somatoria.add(requisicaoControl.validaHorarioTrabalho(domEntrada4,domSaida4));    

  if(cargaHoraria == somatoria.doubleValue() && somatoria.doubleValue() > 0){
	out.print("0");
  }else{
	out.print((cargaHoraria - somatoria.doubleValue()));
  }
%>