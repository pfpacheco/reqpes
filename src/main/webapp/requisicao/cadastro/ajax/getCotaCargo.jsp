<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.componente.model.SistemaParametro" %>
<%@ page import="br.senac.sp.componente.control.SistemaParametroControl" %>
<%@ page errorPage="../../../error/error.jsp" %>
<%
    //-- Objetos de controle
    InstrucaoControl instrucaoControl = new InstrucaoControl();
	SistemaParametroControl spc = new SistemaParametroControl();
    
    //-- Parametros de página
    int codCargo       = (request.getParameter("P_COD_CARGO")==null)?0:Integer.parseInt(request.getParameter("P_COD_CARGO"));    
    int codTabSalarial = (request.getParameter("P_COD_TAB_SALARIAL")==null)?-1:Integer.parseInt(request.getParameter("P_COD_TAB_SALARIAL"));        
    String codUnidade  = request.getParameter("P_COD_UNIDADE");
    String indExcecao  = request.getParameter("P_IND_EXCECAO");
    String segmento4   = request.getParameter("P_SEGMENTO4");
    SistemaParametro parametroCargosExcecao = spc.getSistemaParametroPorSistemaNome(7, "CARGOS_EXCECAO"); 
    String indTipoHorario = null;
    String[][] resultQuery = null;
    
    StringBuffer sql = new StringBuffer();
    sql.append(" SELECT UNIQUE C.HORAS_SEMANAIS ");
    sql.append("       ,CASE ");    
    sql.append("          WHEN T.TAB_SALARIAL IN(4,9,11)  OR C.ID IN ("+parametroCargosExcecao.getVlrSistemaParametro()+") THEN "); //-- Tabela de PROFESSORES
    sql.append("               'P' ");    
    sql.append("          WHEN T.TAB_SALARIAL = 5 THEN "); //-- Tabela de MONITORES
    sql.append("               'M' "); 
    sql.append("          ELSE ");
    sql.append("               'E' ");
    sql.append("        END TIPO_HORARIO ");
    sql.append(" FROM   CARGOS           C ");
    sql.append("       ,CARGO_DESCRICOES CD ");
    sql.append("       ,(SELECT UNIQUE U.TAB_SALARIAL, U.ID_CARGO FROM UNIORG_CARGO_TAB_NIVEL U) T ");
    sql.append(" WHERE  C.ID         = " + codCargo);
    sql.append(" AND    C.ID         = CD.ID ");
    sql.append(" AND    T.ID_CARGO   = C.ID ");
    resultQuery = instrucaoControl.getMatriz(sql.toString());
    
    if(resultQuery != null && resultQuery.length > 0){
      indTipoHorario = resultQuery[0][1];
    }
    
    //-- Objetos
    int cota = -1;
       
    //-- Executando a pesquisa
    if(codCargo > 0 && codTabSalarial >= 0 && codUnidade != null && indExcecao != null){    
      if(indExcecao.equals("N")){
        if(codTabSalarial == 3 || codTabSalarial == 1){
            cota = instrucaoControl.getCotaCargo(codUnidade, codCargo, codTabSalarial, segmento4);
        }else if(codTabSalarial == 7 || codTabSalarial == 0){               
                if(indTipoHorario != null){
                  if(indTipoHorario.equals("M")){
                    //-- Tabela de MONITORES
                    cota = instrucaoControl.getCotaCargo(codUnidade, codCargo, 7, segmento4);
                  }else{
                    //-- Tabela GERAL
                    cota = instrucaoControl.getCotaCargo(codUnidade, codCargo, 0, segmento4);
                  }
                }
              }      
          
        //-- Caso ocorra problema na consulta, gera crítica.
        /*
        if(cota < 0){
          RequisicaoMensagemControl.enviaMensagemCritica("getCotaCargo.jsp", "Não foi encontrada nenhuma cota associada nas tabelas salariais! <br><b>Cargo:</b> " + codCargo + "<br><b>Unidade:</b> " + codUnidade +"<br><b>TabSalarial:</b> " + codTabSalarial + "<br><b>indExcecao:</b> " + indExcecao + "<br><b>Segment4:</b> " + segmento4 + "<br><b>indTipoHorario:</b> " + indTipoHorario, (Usuario) session.getAttribute("usuario"));
        }*/        
      }
    }
    
    //-- Retorna a cota
    out.print(cota);
%>