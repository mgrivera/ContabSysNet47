<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReportOptions.ascx.cs" Inherits="ContabSysNet_Web.UserControls.ReportOptions" %>

<fieldset style="margin: 0px 25px 25px 25px; padding: 15px; text-align: center; " class="generalfont">
    <legend>Opciones para la obtención del reporte: </legend>

    <div style="padding: 5px; text-align: left; ">
        Título del reporte:<br /> 
        <asp:TextBox runat="server" 
                     ID="TituloReporte_TextBox" 
                     Width="300px" Height="18px" />
            <br /><br />
        Subtítulo del reporte:<br /> 
        <asp:TextBox runat="server" 
                     ID="SubTituloReporte_TextBox" Height="18px" Width="300px" />
        <br /><br />

        <div style="border: 1px solid #E5E5E5; margin: 20px; padding: 10px; ">
            <asp:RadioButton ID="NormalFormat_RadioButton" runat="server" GroupName="ReportFormat" Text="Normal" />
            <asp:RadioButton ID="PdfFormat_RadioButton" runat="server" GroupName="ReportFormat" Text="Pdf" />
            <br />
            <asp:RadioButton ID="HorizontalOrientation_RadioButton" runat="server" GroupName="ReportOrientation" Text="Horizontal" />
            <asp:RadioButton ID="VerticalOrientation_RadioButton" runat="server" GroupName="ReportOrientation" Text="Vertical" />
            <br />
            <asp:CheckBox ID="UsarColores_CheckBox" runat="server" Checked="true" Text="Usar colores en el reporte" />
            <br />
            <asp:CheckBox ID="SimpleFont_CheckBox" runat="server" Checked="true" Text="Impresora de impacto" />
            <br />
            <asp:CheckBox ID="SoloTotales_CheckBox" runat="server" Checked="false" Text="Solo totales" 
                          ToolTip="Para mostrar solo los totales en el reporte (y ocultar los registros con información detallada)" />
        </div>
    </div>
</fieldset>
