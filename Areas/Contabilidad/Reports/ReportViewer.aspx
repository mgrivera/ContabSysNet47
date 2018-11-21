<%@ Page Language="C#" AutoEventWireup="true" Inherits="ContabSysNet_Web.Areas.Contabilidad.Reports.ReportViewer" Codebehind="ReportViewer.aspx.cs" %>
<%--<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>--%>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link href="../../../general.css" rel="stylesheet" />
    <title>ContabSysNet - Reportes</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div id="errorMessage_div" runat="server"  class="generalfont errmessage errmessage_background" />
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" SizeToReportContent="True" Width="100%" Height="100%" >
        </rsweb:ReportViewer>
    </div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0"></asp:ScriptManager> 
    </form>
</body>
</html>
