<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios.MovimientosBancarios_OpcionesReportes" Codebehind="MovimientosBancarios_OpcionesReportes.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

  <div style="margin: 5px;" class="generalfont">
        <fieldset>
            <legend>Opciones de reporte: </legend>
            <div style="padding: 5px; text-align: left; ">
                Título del reporte:<br /> 
                <asp:TextBox runat="server" 
                             ID="TituloReporte_TextBox" 
                             Width="300px" />
                 <br /><br />
                Subtítulo del reporte:<br /> 
                <asp:TextBox runat="server" 
                             ID="SubTituloReporte_TextBox" 
                             Height="18px" 
                             Width="300px" />

                <br /><br />

                <asp:Button runat="server" 
                            style="margin: 5px; float:right; "
                            ID="Ok_Button" 
                            onclick="Ok_Button_Click" 
                            Text="Obtener reporte" /> 
            </div>
        </fieldset>
    </div>
    
</asp:Content>
