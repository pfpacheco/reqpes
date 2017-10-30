package br.senac.sp.reqpes.util;
import br.senac.sp.reqpes.model.Requisicao;

public class TemplateCorpoEmail{
   
  public TemplateCorpoEmail(){   
  }
  
  /**
   * @Email: Corpo de Envio de e-mail nos processos de WorkFlow da requisição.
  **/
  public static StringBuffer getCorpoEmail(Requisicao requisicao, String mensagem){
    
    StringBuffer corpo = new StringBuffer();

    corpo.append("<head>" );
    corpo.append("    <title>Solicitação</title>" );
    corpo.append("    <meta http-equiv=expires content=\"Mon, 06 Jan 1990 00:00:01 GMT\">" );
    corpo.append("    <meta http-equiv=\"pragma\" content=\"no-cache\">" );
    corpo.append("    <META HTTP-EQUIV=\"CACHE-CONTROL\" CONTENT=\"NO-CACHE\">" );
    corpo.append("	<style>" );
    corpo.append("	   .tdCabecalho{font-family:verdana; color:#FFFFFF; font-size:10px; background-color:#6699CC; font-weight:normal; }");
    corpo.append("     .tdintranet2{font-family:verdana; color:#000000; font-size:10px; background-color:#E7F3FF; }");
    corpo.append("     .tdintranet {font-family:verdana; color:#000000; font-size:10px; background-color:#6699CC; }");
    corpo.append("     .tdNormal   {font-family:verdana; color:#000000; font-size:10px; background-color:#FFFFFF; }");
    corpo.append("		td.texto {" );
    corpo.append("			color: #000000;" );
    corpo.append("			font-family: Verdana, Arial, Helvetica, sans-serif;" );
    corpo.append("			font-size: 10px;" );
    corpo.append("			background-color: #FFFFFF;" );
    corpo.append("		}" );
    corpo.append("	</style>" );
    corpo.append("  </head>" ); 
    corpo.append("  <body bgcolor='#ffffff' bottommargin='0' topmargin='0' leftmargin='0' rightmargin='0' marginwidth='0' marginheight='0' >" ); 
    corpo.append("  <center><br> ");
    corpo.append("     <table border='0' width='610' cellpadding='0' cellspacing='0'> ");
    corpo.append("           <tr> ");
    corpo.append("             <td colspan='2' height='18' class='tdCabecalho'> ");
    corpo.append("              <STRONG>&nbsp;&nbsp;REQUISIÃ‡ÃƒO DE PESSOAL</STRONG> ");
    corpo.append("             </td> ");
    corpo.append("           </tr> ");
    corpo.append("           <tr> ");
    corpo.append("              <td height='25' width='5%' align='left' class='tdintranet2'> ");
    corpo.append("              &nbsp;");
    corpo.append("             </td> ");    
    corpo.append("              <td height='25' width='95%' align='left' class='tdintranet2'> ");
    corpo.append(                  mensagem);
    corpo.append("              </td> ");    
    corpo.append("           </tr>    ");   
    corpo.append("           <tr> ");
    corpo.append("              <td height='25' width='5%' align='left' class='tdintranet2'> ");
    corpo.append("              &nbsp;");
    corpo.append("             </td> ");    
    corpo.append("              <td height='25' width='95%' align='left' class='tdintranet2'> ");
    //-- LINK DE PRODUÃ‡ÃƒO
    //corpo.append(                "Para mais detalhes <a href='http://www.intranet.sp.senac.br/jsp/private/sistemaIntra.jsp?url=login/leRP.cfm?sncReqPes="+requisicao.getCodRequisicao()+"'>clique aqui</a> para visualizar os dados completos desta requisição.<br><br>");
    corpo.append(                  "Para mais detalhes <a href='http://www.intranet.sp.senac.br/intranet-frontend/sistemas-integrados/detalhes/7'>clique aqui</a> para visualizar os dados completos desta requisição.<br><br>");      
    //-- LINK DE HOMOLOGAÃ‡ÃƒO
    //corpo.append(                  "Para mais detalhes <a href='http://www.intranet.sp.senac.br/jsp/private/sistemaIntra.jsp?url=login/leRPHOM.cfm?sncReqPes="+requisicao.getCodRequisicao()+"'>clique aqui</a> para visualizar os dados completos desta requisição.<br><br>");
    corpo.append("              </td> ");
    corpo.append("           </tr>    ");  
    corpo.append("           <tr> ");
    corpo.append("              <td colspan='2'  height='3' class='tdIntranet'></td> ");
    corpo.append("           </tr>    ");     
    corpo.append("     </table><br>");
    corpo.append("     <table border='0' width='610' cellpadding='0' cellspacing='0'> ");
    corpo.append("           <tr> ");
    corpo.append("             <td colspan='3'  height='18' class='tdCabecalho'> ");
    corpo.append("              <STRONG>&nbsp;&nbsp;DADOS DA REQUISIÃ‡ÃƒO</STRONG> ");
    corpo.append("             </td> ");
    corpo.append("           </tr> ");
    corpo.append("               <tr> ");
    corpo.append("                   <td colspan='2'  height='8' class='tdintranet2'></td> ");
    corpo.append("               </tr>      ");     
    corpo.append("               <tr> ");
    corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
    corpo.append("                   <STRONG>NÃºmero da RP:&nbsp;</STRONG> ");
    corpo.append("                 </td> ");
    corpo.append("                 <td class='tdintranet2' width='77%'> ");
    corpo.append("                   "+requisicao.getCodRequisicao());
    corpo.append("                 </td> ");
    corpo.append("               </tr>    ");   
    corpo.append("               <tr> ");
    corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
    corpo.append("                   <STRONG>Unidade solicitante:&nbsp;</STRONG> ");
    corpo.append("                 </td> ");
    corpo.append("                 <td class='tdintranet2' width='77%'> ");
    corpo.append("                   "+requisicao.getDscUnidade());
    corpo.append("                 </td> ");
    corpo.append("               </tr>    ");      
    corpo.append("               <tr> ");
    corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
    corpo.append("                   <STRONG>Cargo:&nbsp;</STRONG> ");
    corpo.append("                 </td> ");
    corpo.append("                 <td class='tdintranet2' width='77%'> ");
    corpo.append("                   "+requisicao.getDscCargo());
    corpo.append("                 </td> ");
    corpo.append("               </tr>    ");      
    corpo.append("               <tr> ");
    corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
    corpo.append("                   <STRONG>Data da solicitação:&nbsp;</STRONG> ");
    corpo.append("                 </td> ");
    corpo.append("                 <td class='tdintranet2' width='77%'> ");
    corpo.append("                   "+requisicao.getDatRequisicao());
    corpo.append("                 </td> ");
    corpo.append("               </tr>    ");     
    corpo.append("               <tr> ");
    corpo.append("                 <td height='25' width='23%' align='right' class='tdintranet2'> ");
    corpo.append("                   <STRONG>Centro de custo:&nbsp;</STRONG> ");
    corpo.append("                 </td> ");
    corpo.append("                 <td class='tdintranet2' width='77%'> ");
    corpo.append("                   "+requisicao.getSegmento1()+"."+requisicao.getSegmento2()+"."+requisicao.getSegmento3()+"."+requisicao.getSegmento4()+"."+requisicao.getSegmento5()+"."+requisicao.getSegmento6()+"."+requisicao.getSegmento7());
    corpo.append("                 </td> ");
    corpo.append("               </tr>    ");     
    corpo.append("               <tr> ");
    corpo.append("                   <td colspan='2'  height='8' class='tdintranet2'></td> ");
    corpo.append("               </tr>      ");   
    corpo.append("               <tr> ");
    corpo.append("                 <td colspan='2'  height='3' class='tdIntranet'></td> ");
    corpo.append("               </tr>    ");     
    corpo.append("               <tr> ");
    corpo.append("                 <td colspan='2' align='center' class='tdNormal'");
    corpo.append("                    <br><br>Esta Ã© uma mensagem automática, por favor não responda este e-mail.");
    corpo.append("                 </td>");
    corpo.append("               </tr>    ");         
    corpo.append("         </table>     ");
    corpo.append(" </center><br> ");
    corpo.append("</body>" );      

    return corpo;
  }      
}