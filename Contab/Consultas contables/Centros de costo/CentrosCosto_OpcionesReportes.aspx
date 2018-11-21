<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Centros_de_costo.CentrosCosto_OpcionesReportes" Codebehind="CentrosCosto_OpcionesReportes.aspx.cs" %>
<%@ Register TagPrefix="My" TagName="ReportOptions" Src="~/UserControls/ReportOptions.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

          <div style="margin: 5px;" class="generalfont">

                <My:ReportOptions runat="server" ID="reportOptionsUserControl" Modifiers="public"/>

                <asp:Button runat="server" 
                            style="margin: 0px 25px; float:right; "
                            ID="Ok_Button" 
                            onclick="Ok_Button_Click" 
                            Text="Obtener reporte" /> 

            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
    
</asp:Content>
