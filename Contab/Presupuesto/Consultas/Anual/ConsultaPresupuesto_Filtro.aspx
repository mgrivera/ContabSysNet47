﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Consultas_Anual_ConsultaPresupuesto_Filtro" Codebehind="ConsultaPresupuesto_Filtro.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div style="margin: 15px; ">
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" class=" errmessage_background generalfont errmessage"
        ForeColor="" DisplayMode="List" />
    <table>
        <tr>
            <td class="ListViewHeader_Suave generalfont">
                Compañías
            </td>
            <td>
                &nbsp;&nbsp;
            </td>
            <td class="ListViewHeader_Suave generalfont">
                Monedas
            </td>
            <td>
                &nbsp;&nbsp;
            </td>
            <td class="ListViewHeader_Suave generalfont">
                Años (fiscales)
            </td>
        </tr>
        <tr>
            <td>
                <asp:ListBox ID="Sql_PresupuestoMontos_CiaContab_Numeric" runat="server" 
                    DataTextField="NombreCorto" DataValueField="Numero" Width="200px" Rows="8" SelectionMode="Multiple">
                </asp:ListBox>

                <asp:CustomValidator ID="CustomValidator3" runat="server" ControlToValidate="Sql_PresupuestoMontos_CiaContab_Numeric"
                    ErrorMessage="Ud. debe seleccionar un compañía de la lista." OnServerValidate="CustomValidator3_ServerValidate"
                    ValidateEmptyText="True" Display="None">
                </asp:CustomValidator>
            </td>
            <td>
                &nbsp;&nbsp;
            </td>
            <td>
                <asp:ListBox ID="Sql_PresupuestoMontos_Moneda_Numeric" runat="server" DataSourceID="Monedas_SqlDataSource"
                    DataTextField="Descripcion" DataValueField="Moneda" Rows="8" Width="120" SelectionMode="Multiple">
                </asp:ListBox>
            </td>
            <td>
                &nbsp;&nbsp;
            </td>
            <td>
                <asp:ListBox ID="Sql_PresupuestoMontos_Ano_Numeric" runat="server" DataSourceID="AnosFiscales_SqlDataSource"
                    DataTextField="Ano" DataValueField="Ano" Rows="8" Width="120" SelectionMode="Single">
                </asp:ListBox>

                <asp:CustomValidator ID="CustomValidator2" runat="server" ControlToValidate="Sql_PresupuestoMontos_Ano_Numeric"
                    ErrorMessage="Ud. debe seleccionar un año de la lista." OnServerValidate="CustomValidator2_ServerValidate"
                    ValidateEmptyText="True" Display="None">
                </asp:CustomValidator>
            </td>
        </tr>
    </table>

    <br />
    <br />
    <div style="text-align: right;">
        <asp:Button ID="LimpiarFiltro_Button" runat="server" Text="Limpiar filtro" 
            CausesValidation="False" onclick="LimpiarFiltro_Button_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="AplicarFiltro_Button" runat="server" Text="Aplicar filtro" 
            onclick="AplicarFiltro_Button_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div>
 </div>
 
    <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT Moneda, Descripcion FROM Monedas ORDER BY Descripcion">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="AnosFiscales_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT DISTINCT Ano FROM Presupuesto_Montos ORDER BY Ano DESC">
    </asp:SqlDataSource>
        
</asp:Content>

