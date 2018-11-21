
<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="reconversionMonetaria_filter.aspx.cs" Inherits="ContabSysNet_Web.Otros.reconversionMonetaria.reconversionMonetaria_filter" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="../../../radcalendar.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="notsosmallfont" style="padding-left: 25px; padding-right: 25px; padding-bottom: 25px;">

        <asp:ValidationSummary ID="ValidationSummary1" runat="server" class=" errmessage_background generalfont errmessage" ForeColor="" />
        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" /> 
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

        <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="1" style="text-align: left;">
            <asp:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1">
                <ContentTemplate>
                    <div style="text-align: left;" class="generalfont">
                        <table cellpadding="16px">
                            <tr>

                            </tr>
                                <td valign="top">
                                    Cantidad de dígitos:&nbsp;&nbsp;
                                    <asp:TextBox ID="cantidadDigitos_textBox" runat="server" Width="105px"></asp:TextBox>
                                </td>
                                <td valign="top">
                                </td>
                            <tr>
                                <td>
                                    <div class="ListViewHeader_Suave generalfont">Seleccione un año</div>
                                    <asp:ListBox ID="anosRegistrados_listBox" 
                                             runat="server" 
                                             Width="350px" 
                                             CssClass="notsosmallfont" Rows="10" />
                                </td>
                                <td>
                                    <div class="ListViewHeader_Suave generalfont">Seleccione una cuenta contable</div>
                                    <asp:ListBox ID="cuentasContables_listBox" 
                                        runat="server" 
                                        DataSourceID="CuentasContables_SqlDataSource"
                                        DataTextField="CuentaContableYNombre" 
                                        DataValueField="ID" 
                                        Width="350px" 
                                        Rows="10"
                                        CssClass="notsosmallfont" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </ContentTemplate>
            </asp:TabPanel>
        </asp:TabContainer>

        <br />
        <br />

        <div style="text-align: right;">
            <asp:Button ID="LimpiarFiltro_Button" 
                        runat="server" 
                        Text="Limpiar filtro" 
                        CausesValidation="False" 
                        onclick="LimpiarFiltro_Button_Click" />
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            <asp:Button ID="AplicarFiltro_Button" 
                        runat="server" 
                        Text="Aplicar filtro" 
                        onclick="AplicarFiltro_Button_Click" 
                        ClientIDMode="Static" />
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div> 
        
    </div>

    <div>
        <asp:SqlDataSource ID="CuentasContables_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT CuentasContables.Cuenta + ' - ' + CuentasContables.Descripcion + ' (' + Companias.Abreviatura + ')' AS CuentaContableYNombre, 
                           CuentasContables.ID FROM CuentasContables INNER JOIN Companias ON CuentasContables.Cia = Companias.Numero 
                           WHERE (CuentasContables.TotDet = 'D' And CuentasContables.ActSusp = 'A' And CuentasContables.Cia = @ciaContab) 
                           ORDER BY Companias.NombreCorto, CuentasContables.Cuenta + N' ' + CuentasContables.Descripcion">
            <SelectParameters>
                <asp:Parameter DefaultValue="55" Name="ciaContab" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
