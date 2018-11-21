<%@ Page Language="C#" AutoEventWireup="true" Inherits="Bancos_Disponibilidad_en_bancos_Disponibilidad_MontosRestringidos_ReportViewer" Codebehind="MontosRestringidos_ReportViewer.aspx.cs" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <link href="~/general.css" rel="stylesheet" type="text/css" />
   <title>ContabSysNet - Reportes</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
     <%-- usamos una tabla (y no un div) pues no se muestra si no tiene contenido   --%>
    <table>
        <tr>
            <td id="ErrMessage_Cell" runat="server" class="generalfont errmessage errmessage_background">
            </td>
        </tr>
    </table>
     <div>
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" 
            Height="605px" Font-Names="Verdana" Font-Size="8pt">
        </rsweb:ReportViewer>
    </div>
         <asp:ScriptManager ID="ScriptManager1" runat="server">
         </asp:ScriptManager>
    </div>
    </form>
</body>
</html>
