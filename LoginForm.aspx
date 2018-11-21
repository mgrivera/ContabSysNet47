<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginForm.aspx.cs" Inherits="ContabSysNetWeb.LoginForm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>ContabSysNet - indique un nombre de usuario y password</title>
    <style type="text/css">
        .MarginTop
        {
            margin-top: 15px; 
        }
        .MarginBottom
        {
            padding-bottom: 5px; 
            padding-top: 5px; 
        }
        .generalfont
        {
            font-family: tahoma;
            font-size: small;
        }
        .errmessage
        {
            padding-left: 10px;
            padding-right: 10px;
            color: #FF0000;
        }
        .errmessage_background
        {
            background-color: #FFFFBB;
            border: 1px solid #E6E600;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    
    <div style="padding-top:45px; padding-left:45px; " >

         <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background notsosmallfont"
                    style="display: block; margin-bottom: 15px;"></span>
       
        <asp:Login ID="Login1" runat="server" BackColor="#EFF3FB" BorderColor="#B5C7DE" 
                BorderPadding="15" BorderStyle="Solid" BorderWidth="1px" 
                DisplayRememberMe="True" Font-Names="Verdana" Font-Size="12px" 
                ForeColor="#333333" LoginButtonText="Iniciar sesión" 
                    DestinationPageUrl="~/Main/Home"  
            TitleText="ContabSysNet  -  Iniciar sesión" 
            CreateUserText="Registre un nuevo usuario aquí" 
            CreateUserUrl="~/Otros/Control acceso/AgregarUsuario.aspx" 
            onloggedin="Login1_LoggedIn" RememberMeText="Recordarme la próxima vez">
                <TextBoxStyle Font-Size="12px" />
                <LoginButtonStyle BackColor="White" BorderColor="#507CD1" BorderStyle="Solid" 
                    BorderWidth="1px" Font-Names="Verdana" Font-Size="12px" 
                    ForeColor="#284E98" CssClass="MarginTop" />
                <InstructionTextStyle Font-Italic="True" ForeColor="Black" />
                <TitleTextStyle BackColor="#507CD1" Font-Bold="True" Font-Size="0.9em" 
                    ForeColor="White" 
                    CssClass="MarginBottom" />
        </asp:Login> 
               
    </div>
    
   <%-- DestinationPageUrl="Default.aspx"  --%>
    
    </form>
</body>
</html>
