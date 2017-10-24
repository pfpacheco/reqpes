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
  //-- Objetos control
  InstrucaoControl instrucaoControl = new InstrucaoControl();
  InstrucaoAtribuicaoControl instrucaoAtribuicaoControl = new InstrucaoAtribuicaoControl();
  
  //-- Objetos da p�gina
  Usuario usuario = (Usuario) session.getAttribute("usuario");
  String[][] dadosCargo = null;
  String[] unidade = request.getParameterValues("codUnidade");    
  int codCargo = Integer.parseInt(request.getParameter("codCargo"));
  String[] validacao = instrucaoControl.isGravaInstrucao(instrucao, 0, unidade);
  int retorno = 0;
   
  //-- Verifica se j� existe instru�ao cadastrada com os mesmos dados
  if(validacao[0].equals("0")){
    //-------------------------------------------------------------------------------------
    //-- Caso seja selecionada a op��o de grava�ao para todos os cargos, percorre o cursor
    //-------------------------------------------------------------------------------------
    if(codCargo == 0){
      //-- Resgata combo de cargos da tabela salarial selecionada
      dadosCargo = instrucaoControl.getComboCargo(instrucao.getCodTabelaSalarial());
      
      //-- Efetua a grava�ao dos dados
      for(int i=0; i<dadosCargo.length; i++){
        instrucao.setCodCargo(Integer.parseInt(dadosCargo[i][0]));
        retorno = instrucaoControl.gravaInstrucao(instrucao, usuario);
      
        //-- Grava as atribui�oes
        if(retorno > 0){
          //-- Grava as atribui��es
          instrucaoAtribuicao.setCodInstrucao(retorno);
          for(int j=0; j<unidade.length; j++){
            //-- Setando valores
            instrucaoAtribuicao.setCodInstrucao(retorno);
            instrucaoAtribuicao.setCodUnidade(unidade[j]);
            instrucaoAtribuicaoControl.gravaInstrucaoAtribuicao(instrucaoAtribuicao);
          }
        }
      }
    }else{
      //--------------------------------------------------------------
      //-- Grava os dados da Instrucao para um cargo espec�fico
      //--------------------------------------------------------------
      retorno = instrucaoControl.gravaInstrucao(instrucao, usuario);
  
      //-- Grava as atribui�oes
      if(retorno > 0){
        //-- Grava as atribui��es
        instrucaoAtribuicao.setCodInstrucao(retorno);
        for(int i=0; i<unidade.length; i++){
          //-- Setando valores
          instrucaoAtribuicao.setCodInstrucao(retorno);
          instrucaoAtribuicao.setCodUnidade(unidade[i]);
          instrucaoAtribuicaoControl.gravaInstrucaoAtribuicao(instrucaoAtribuicao);
        }
      }    
    }
  }
%>

<script language="JavaScript">
  switch(eval(<%=validacao[0]%>)){
    case 0: alert('Cadastro realizado com sucesso!');
            window.location = "formulario.jsp?codInstrucao=<%=retorno%>";
            break;
    case 1: alert('ATEN��O!\nN�o foi poss�vel cadastrar os dados desta Instru��o.\nJ� existe uma instru��o cadastrada no sistema com os mesmos valores!');             
            window.location = "formulario.jsp";
            break;
    case 2: alert('ATEN��O!\nN�o foi poss�vel cadastrar os dados desta Instru��o.\nJ� existe uma instru��o/atribui��o cadastrada no sistema \npara a(s) seguinte(s) unidade(s): <%=validacao[1]%>.');
            window.location = "formulario.jsp";
            break;
  }
</script>