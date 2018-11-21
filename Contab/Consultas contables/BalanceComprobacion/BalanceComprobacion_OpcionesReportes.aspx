<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="ContabSysNet_Web.Contab.Consultas_contables.BalanceComprobacion.BalanceComprobacion_OpcionesReportes" Codebehind="BalanceComprobacion_OpcionesReportes.aspx.cs" %>
<%@ Register TagPrefix="My" TagName="ReportOptions" Src="~/UserControls/ReportOptions.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
              <div style="margin: 5px;" class="generalfont">

                  <fieldset style="margin: 0 25px 25px 25px; padding: 15px; text-align: left; " class="generalfont">
                    <legend>Mostrar totales para: </legend>
                        <div style="border: 0 solid #E5E5E5; margin: 0; padding: 10px 0 0 0; ">
                            <asp:RadioButton ID="Totales_SoloNivelAnterior_RadioButton" runat="server" GroupName="Report_MostrarTotalesPara" Text="solo el nivel anterior a la cuenta de detalle" Checked="true"/>
                            <br />
                            <asp:RadioButton ID="Totales_TodosLosNiveles_RadioButton" runat="server" GroupName="Report_MostrarTotalesPara" Text="todos los niveles de las cuentas contables mostradas" />
                        </div>
                </fieldset>

                <My:ReportOptions runat="server" ID="reportOptionsUserControl" Modifiers="public"/>

                <asp:Button runat="server" 
                            style="margin: 0 25px; float:right; "
                            ID="Ok_Button" 
                            onclick="Ok_Button_Click" 
                            Text="Obtener reporte" /> 

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
