<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page errorPage="../../../error/error.jsp" %>
<%
    //-- Objetos de controle
    InstrucaoControl instrucaoControl = new InstrucaoControl();
    
    //-- Parametros de página
    int codCargo       = (request.getParameter("P_COD_CARGO")==null)?0:Integer.parseInt(request.getParameter("P_COD_CARGO"));
    int cotaCargo      = (request.getParameter("P_COTA_CARGO")==null)?-1:Integer.parseInt(request.getParameter("P_COTA_CARGO"));
    int codTabSalarial = (request.getParameter("P_COD_TAB_SALARIAL")==null)?-1:Integer.parseInt(request.getParameter("P_COD_TAB_SALARIAL"));
    String codUnidade  = request.getParameter("P_COD_UNIDADE");
    String segmento4   = request.getParameter("P_SEGMENTO4");
    
    //-- Objetos
    boolean isValidaIN15 = false;
    
    //-- Executando a pesquisa
    if(codCargo > 0 && cotaCargo > -1 && codUnidade != null && segmento4 != null){
      isValidaIN15 = instrucaoControl.validaIN15(codUnidade, codCargo, cotaCargo, codTabSalarial, segmento4);
      //-- Caso ocorra problema na consulta, gera crítica.
      if(!isValidaIN15){
        RequisicaoMensagemControl.enviaMensagemCritica("validaIN15.jsp", "Não foi encontrada nenhuma cota associada nas tabelas salariais! <br><b>Cargo:</b> " + codCargo + "<br><b>Cota:</b> " + cotaCargo + "<br><b>Unidade:</b> " + codUnidade + "<br><b>Segmento4:</b> " + segmento4 + "<br><b>TabelaSalarial:</b> " + codTabSalarial, (Usuario) session.getAttribute("usuario"));
      }                
    }else{
        RequisicaoMensagemControl.enviaMensagemCritica("validaIN15.jsp", "Erro parâmetros! <br><b>Cargo:</b> " + codCargo + "<br><b>Cota:</b> " + cotaCargo + "<br><b>Unidade:</b> " + codUnidade + "<br><b>Segmento4:</b> " + segmento4 + "<br><b>TabelaSalarial:</b> " + codTabSalarial, (Usuario) session.getAttribute("usuario"));
    }
    
    //-- Retorna o resultado da validação
    //-- Retorno: false (Erro, não encontrado na IN15) / true (Sucesso, encontrado na IN15)
    out.print(isValidaIN15);
%>