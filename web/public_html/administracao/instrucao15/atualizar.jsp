<%  session.setAttribute("root","../../"); %>
<%@ page errorPage="../../error/error.jsp" %>
<%@ page import="br.senac.sp.componente.model.Usuario" %>
<%@ page import="br.senac.sp.reqpes.Control.*" %>
<%@ page import="br.senac.sp.reqpes.model.*" %>

<jsp:useBean id="instrucao" class="br.senac.sp.reqpes.model.Instrucao" />
<jsp:setProperty name="instrucao" property="*" />

<jsp:useBean id="instrucaoAtribuicao" class="br.senac.sp.reqpes.model.InstrucaoAtribuicao" />
<jsp:setProperty name="instrucaoAtribuicao" property="*" />

<%
  //-- Objetos Control
  InstrucaoControl instrucaoControl = new InstrucaoControl();
  InstrucaoAtribuicaoControl instrucaoAtribuicaoControl = new InstrucaoAtribuicaoControl();
  
  //-- Objetos da página
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  String[] unidade = request.getParameterValues("codUnidade");  
  String[] validacao = instrucaoControl.isGravaInstrucao(instrucao, 1, unidade);
 
  //-- Verifica se já existe instruçao cadastrada com os mesmos dados
  if(validacao[0].equals("0")){
    //-- Alterando a instrução
    instrucaoControl.alteraInstrucao(instrucao, usuario);
    //-- Alterando as atribuições
    instrucaoAtribuicao.setCodInstrucao(instrucao.getCodInstrucao());
    instrucaoAtribuicaoControl.deletaInstrucaoAtribuicao(instrucaoAtribuicao);    
    for(int i=0; i<unidade.length; i++){      
      instrucaoAtribuicao.setCodInstrucao(instrucao.getCodInstrucao());
      instrucaoAtribuicao.setCodUnidade(unidade[i]);
      instrucaoAtribuicaoControl.gravaInstrucaoAtribuicao(instrucaoAtribuicao);
    }
  }
%>

<script language="JavaScript">
  switch(eval(<%=validacao[0]%>)){
    case 0: alert('Alteração realizada com sucesso!'); 
            break;
    case 1: alert('ATENÇÃO!\nNão foi possível alterar os dados desta Instrução.\nJá existe uma instrução cadastrada no sistema com os mesmos valores!'); 
            break;
    case 2: alert('ATENÇÃO!\nNão foi possível alterar os dados desta Instrução.\nJá existe uma instrução/atribuição cadastrada no sistema \npara a(s) seguinte(s) unidade(s): <%=validacao[1]%>.');
            break;
  }
  window.location = "formulario.jsp?codInstrucao=<%=instrucao.getCodInstrucao()%>";
</script>