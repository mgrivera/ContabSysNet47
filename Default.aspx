<%@ Page Language="C#" AutoEventWireup="true" Inherits="Default" Codebehind="Default.aspx.cs" %>
<!-- 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
-->

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ContabSysNet</title>
    <link href="general.css" rel="stylesheet" type="text/css" />
       <style type="text/css">
       
       
        html, body
        {
          height: 100%;
          width: 100%;
          margin: 10 0 0 0;
          padding: 0 0 0 0;
          text-align: center;
          background-color: #FFFFFF;
        }
        #header
        {
            height: expression(document.body.clientHeight / 100 * 10);
            width: 85%;
            margin: 0 0 0 0;
            background: #d5ddf3;
            border-bottom-style: solid;
            border-bottom: 2px #36c;
            text-align: right;
            border: 1px solid #A7BCE9;
        }
        #header_divider
        {
            height: expression(document.body.clientHeight / 100 * 1);
            width: 85%; 
            margin: 0 0 0 0; 
            background: #36c;
        }
         #main
        {
            border-style:none solid solid solid;
            border-width: 1px;
            border-color: #8B8B8B;
            height: expression(document.body.clientHeight / 100 * 70);
            width: 85%;
            background: #EBEBEB;
        }
        #main_left
        {
            height: expression(document.body.clientHeight / 100 * 70);
            width: 29%; 
            background: #F7F6F3;
            text-align: left; 
            padding: 10 0 0 10; 
            float:left; 
        }
         #main-right
        {
            height: expression(document.body.clientHeight / 100 * 70);
            width: 69%; 
            text-align: center; 
            padding: 35 0 0 10; 
            float:right; 
        }
        #footer
        {
            border: 1px solid #000000;
            height: expression(document.body.clientHeight / 100 * 5);
            width: 85%;
            background: #4c4c4c;
            clear: both;
        }
         #div_menu
        {
            border: 1px solid #8B8B8B;
            height: expression(document.body.clientHeight / 100 * 5);
            width: 85%;
            background: #F7F6F3;
            clear: both;
        }
       h1
      {
          color: #000080;
      }
       h2
      {
          color: #666666;
      }
    </style>
</head>

<body>
    <form id="form1" runat="server">
    <br />
    <!--               header div              -->
    <div id="header">
        <h1 style="font-style: italic">ContabSysNet&nbsp;&nbsp;</h1>
    </div>
     <!--               div para el menú               -->
    <div id="div_menu" style="border-bottom-style: solid; border-bottom: 1px #36c; text-align: left; padding-left:10px; ">
    
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background notsosmallfont"
                    style="display: block;"></span>
                    
        <asp:Menu ID="Menu1" runat="server" DataSourceID="SiteMapDataSource1" BackColor="#E3EAEB"
            DynamicHorizontalOffset="2" Font-Names="Verdana" Font-Size="0.8em" ForeColor="#666666"
            StaticSubMenuIndent="10px" Orientation="Horizontal" 
            MaximumDynamicDisplayLevels="6">
            <StaticMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" 
                BackColor="#E1E1E1" ForeColor="White" />
            <DynamicHoverStyle BackColor="#D8D8D8" ForeColor="#272727" />
            <DynamicMenuStyle BackColor="#E1E1E1" />
            <DynamicSelectedStyle BackColor="#E1E1E1" ForeColor="#666666" />
            <DynamicMenuItemStyle HorizontalPadding="5px" VerticalPadding="0px" />
            <StaticHoverStyle BackColor="#E1E1E1" ForeColor="White" />
            <StaticSelectedStyle BackColor="#E1E1E1" ForeColor="#666666" />
        </asp:Menu>

    </div>
    
    <!--               main div              -->
    <div id="main">
        <!--               main_left div              -->
        <div id="main_left">
            
            
           
        </div>
        <div id="main-right" style="vertical-align:middle; ">
            <img alt="logo cia usuaria" src="Pictures/logo_cia_usuaria.png?id=1" />
        </div>
    </div>
    <!--               footer div              -->
    <div id="footer" style="border-bottom-style: solid; border-bottom: 1px #36c; vertical-align: middle; ">
        <span style="font-size: 12px; color: #FFFFFF;">
            <asp:LoginName ID="LoginName1" runat="server" />
            &nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;
            <asp:LoginStatus ID="LoginStatus1" runat="server" Font-Size="12px" ForeColor="White" LoginText="Log in" LogoutText="Log out" />
        </span>
       
    </div>
        <asp:SiteMapDataSource ID="SiteMapDataSource1" runat="server" ShowStartingNode="true"/>
    </form>
</body>
</html>
