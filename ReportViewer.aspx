
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportViewer.aspx.cs" Inherits="ContabSysNetWeb.ReportViewer" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
        <title>ContabSysNet - Reportes</title>

        <style>
            html,body,form,#div1 {
                height: 100%; 
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <div id="div1">
                <asp:ScriptManager runat="server"></asp:ScriptManager>        
                <%-- usamos una tabla (y no un div) pues no se muestra si no tiene contenido   --%>
                <table>
                    <tr>
                        <td id="ErrMessage_Cell" runat="server" class="generalfont errmessage errmessage_background">
                        </td>
                    </tr>
                </table>

                <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="100%">
                </rsweb:ReportViewer>
            </div>
        </form>
    </body>
</html>
