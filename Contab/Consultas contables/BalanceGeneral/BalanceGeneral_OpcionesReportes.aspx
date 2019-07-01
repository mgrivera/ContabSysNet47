<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral.BalanceGeneral_OpcionesReportes" Codebehind="BalanceGeneral_OpcionesReportes.aspx.cs" %>
<%@ Register TagPrefix="My" TagName="ReportOptions" Src="~/UserControls/ReportOptions.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

  <div style="margin: 5px;" class="generalfont">

    <asp:ValidationSummary ID="ValidationSummary1" 
                           runat="server" 
                           class="errmessage_background generalfont errmessage"
                           ForeColor="" />

    <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" Display="None" EnableClientScript="False" />

        <My:ReportOptions runat="server" ID="reportOptionsUserControl" Modifiers="public"/>

        <fieldset style="margin: 0px 25px 5px 25px; padding: 15px; text-align: center; " class="generalfont">
            <legend>Otras opciones: </legend>
            <div style="padding: 5px; text-align: left; ">
                Cantidad de niveles a mostrar en el reporte:&nbsp; 
                <asp:DropDownList ID="CantidadNiveles_DropDownList" runat="server">
                    <asp:ListItem Enabled="True" Text="Todos (hasta nivel detalle)" Value="-1" />
                    <asp:ListItem Enabled="True" Text="Nivel antes detalle" Value="-2" />
                    <asp:ListItem Enabled="True" Text="1 nivel" Value="1" />
                    <asp:ListItem Enabled="True" Text="2 niveles" Value="2" />
                    <asp:ListItem Enabled="True" Text="3 niveles" Value="3" />
                    <asp:ListItem Enabled="True" Text="4 niveles" Value="4" />
                    <asp:ListItem Enabled="True" Text="5 niveles" Value="5" />
                </asp:DropDownList>
                <br /><br />
                <asp:CheckBox ID="SoloColumnaSaldoFinal_CheckBox" 
                              runat="server" 
                              Checked="false" 
                              Text="Mostrar <b>solo</b> coulumna de saldo final (sin saldo inicial, debe o haber)" />
                
            </div>
        </fieldset>

        <div style="margin: 0px 0px 5px 25px; padding: 15px; text-align: right; ">
            <asp:Button runat="server" 
                                style="margin: 5px; float:right; "
                                ID="Ok_Button" 
                                onclick="Ok_Button_Click" 
                                Text="Obtener reporte" /> 
        </div>
          
    </div>
    
</asp:Content>
