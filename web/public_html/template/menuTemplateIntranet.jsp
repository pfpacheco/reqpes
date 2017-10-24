<%@ page import="br.senac.sp.menu.MenuControl"%>
<%@ page import="br.senac.sp.menu.bean.Menu"%>
<%@ page import="br.senac.sp.menu.bean.MenuItem"%>
<%
    /**
    autor: Luciano Silva <luciano.csilva@sp.senac.br>
    data:  23/02/2006
           Essa página é responsável por listar todos os menus e itens do menu.
           Através da classe MenuControl é feita a conexão no banco rcd01 e obtida
           todos os dados para listar a estrutura do menu.
    **/

    MenuControl mcontrol = new MenuControl();
    Menu[] mroots        = mcontrol.getRootMenu(); // obtem a estrutura de menus
    String host_intra    = "http://www.intranet.sp.senac.br";
%>
<table cellspacing="0" cellpadding="0" width="150" border="0">
<% 
  if( mroots!=null )
  {
      for(int i=0; i<mroots.length; i++)// lista os menus raizes
      {
        MenuItem[] menuItem = mroots[i].getItens();

        if( menuItem!=null )
        {

          for(int idx=0; idx<menuItem.length; idx++) // lista os itens do menu
          {
            MenuItem item = menuItem[idx];
            
            // gambi para inibir os menus, futuramente Bruno terá que inativar os duplicados
            if((item.getId() == 222 || item.getId() >= 414) && item.getId() != 473){            
              out.print("<tr>");
              out.print("<td valign='top' align='right'>");
  
              if( item.getUrl()!=null && !item.getUrl().trim().equals("") ) 
                out.print("<a href='http://www.intranet.sp.senac.br"+ item.getUrl().trim() +"'>");
  
              out.print("<img width='150' src='http://www.intranet.sp.senac.br/icon/"+ item.getImg_fsname_disabled() +"' border='0'>");
  
              if( item.getUrl()!=null && !item.getUrl().trim().equals("") )  
                out.print("</a>");
  
              out.print("</td>");
              out.println("</tr>");
            }
          }// for end - menu itens

        }//
      }// for end - menu roots
  }//
%>    
</table>