<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Cuentas_y_movimientos.CuentasYMovimientos_OpcionesReportes" Codebehind="CuentasYMovimientos_OpcionesReportes.aspx.cs" %>
<%@ Register TagPrefix="My" TagName="ReportOptions" Src="~/UserControls/ReportOptions.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

        <div>

            <table>
                <tr>
                    <td>
                        <My:ReportOptions runat="server" ID="reportOptionsUserControl" Modifiers="public"/>
                    </td>
                    <td style="text-align: left; vertical-align: top; ">
                        <fieldset style="margin: 0px 25px 25px 25px; padding: 15px; " class="generalfont">
                            <legend>Otras opciones del reporte: </legend>
                            <table>
                                <tr>
                                    <td colspan="3">
                                        <br />
                                        <span style="text-decoration: underline; margin-left: 6px; ">Salto de página: </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="SaltoPaginaCuentasContables_RadioButton" runat="server" GroupName="saltoPagina" Text="Cuenta contable" ClientIDMode="Static" />
                                    </td>
                                    <td>
                                        <asp:RadioButton ID="SaltoPaginaNinguno_RadioButton" runat="server" GroupName="saltoPagina" Text="Ninguno" ClientIDMode="Static" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:Button runat="server" 
                                    style="margin: 0px 25px; float:right; "
                                    ID="Ok_Button" 
                                    onclick="Ok_Button_Click" 
                                    Text="Obtener reporte" /> 
                    </td>
                </tr>
            </table>

        </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
