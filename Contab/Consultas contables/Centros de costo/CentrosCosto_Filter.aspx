<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_Simple.master" CodeBehind="CentrosCosto_Filter.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Centros_de_costo.CentrosCosto_Filter" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div style="text-align: left; padding: 0px 20px 0px 20px;">

    <cc1:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
        TargetControlID="UpdatePanel1" Enabled="True">
        <Animations>
            <OnUpdating>
                <Parallel duration=".5">
                    <%-- fade-out the GridView --%>
                    <FadeOut minimumOpacity=".5" />
                </Parallel>
            </OnUpdating>
            <OnUpdated>
                <Parallel duration=".5">
                    <%-- fade back in the GridView --%>
                    <FadeIn minimumOpacity=".5" />
                </Parallel>
            </OnUpdated>
        </Animations>
    </cc1:UpdatePanelAnimationExtender>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

    <asp:ValidationSummary ID="ValidationSummary1" 
                           runat="server" 
                           class="errmessage_background generalfont errmessage"
                           ForeColor="" />

    <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

    <cc1:tabcontainer id="TabContainer1" runat="server" activetabindex="0">

        <cc1:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1" >

            <ContentTemplate>

                <table style="font-size: x-small; ">

                    <tr>
                        <td>
                            Fecha: 
                        </td>

                        <td>
                            <asp:TextBox ID="Sql_it_Asiento_Fecha_Date" runat="server" />
                        </td>
                       
                        <td />
                        <td />

                        <td>
                            Debe: 
                        </td>
                       
                        <td />
                            <asp:TextBox ID="Sql_it_Debe_Numeric" runat="server" />
                        <td />
                    </tr>

                     <tr>
                        <td>
                        </td>

                        <td>
                        </td>
                       
                        <td />
                        <td />

                        <td>
                            Haber: 
                        </td>
                       
                        <td />
                            <asp:TextBox ID="Sql_it_Haber_Numeric" runat="server" />
                        <td />
                    </tr>

                     <tr>
                        <td colspan="5">
                         <asp:CheckBox ID="ConCentroCostoAsignado_CheckBox" 
                             runat="server" 
                             Checked="true" 
                             Text="Solo movimientos contables con centro de costo asignado" 
                             ToolTip="Si este campo no es marcado, serán seleccionados también movimientos contables a los cuales el usuario no ha asignado un centro de costo" />
                        <td />
                    </tr>

                </table>

            </ContentTemplate>

            </cc1:TabPanel>


        <cc1:TabPanel HeaderText="Lista (1)" runat="server" ID="TabPanel2" >

            <ContentTemplate>

                <table style="width: 100%; height: 100%;">
                    <tr>
                        <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                            Cias contab
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                            Monedas
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td class="ListViewHeader_Suave smallfont2">
                            <table style="width:100%; ">
                                <tr>
                                    <td>
                                        Cuentas contables&nbsp;&nbsp;
                                    </td>
                                    <td style="text-align: right; ">
                                        <asp:TextBox ID="CuentasContablesFilter_TextBox"
                                                     CssClass="smallfont"
                                                     runat="server" 
                                                     AutoPostBack="True" 
                                                     ontextchanged="CuentasContablesFilter_TextBox_TextChanged" 
                                                     style="width: 150px; margin-right: 10px; " />

                                        <cc1:TextBoxWaterMarkExtender ID="TextBoxWaterMarkExtender1" 
                                                                      runat="server" 
                                                                      WatermarkText="Escriba (y Enter) para buscar ..." 
                                                                      TargetControlID="CuentasContablesFilter_TextBox" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="Sql_it_Asiento_Cia_Numeric" 
                                            runat="server" 
                                            DataTextField="Nombre" DataValueField="Numero" 
                                            AutoPostBack="true" 
                                            SelectionMode="Multiple" 
                                            onselectedindexchanged="Sql_Asientos_Cia_Numeric_SelectedIndexChanged" 
                                            Rows="20" 
                                            CssClass="smallfont" />
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                             <asp:ListBox ID="Sql_it_Asiento_Moneda_Numeric" 
                                             Width="200px"
                                             runat="server" 
                                             DataSourceID="Monedas_SqlDataSource"
                                             DataTextField="Descripcion" 
                                             DataValueField="Moneda" 
                                             AutoPostBack="False" 
                                             SelectionMode="Multiple" 
                                             Rows="20" 
                                             CssClass="smallfont" />
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:ListBox ID="Sql_it_CuentasContable_Cuenta_String" 
                                        runat="server" 
                                        DataSourceID="CuentasContables_SqlDataSource"
                                        DataTextField="CuentaContableYNombre" 
                                        DataValueField="Cuenta" 
                                        SelectionMode="Multiple" 
                                        Width="350px" 
                                        Rows="20"
                                        CssClass="smallfont" />
                        </td>

                    </tr>
                </table>

            </ContentTemplate>
        </cc1:TabPanel>

         <cc1:TabPanel HeaderText="Lista (2)" runat="server" ID="TabPanel3" >
            <ContentTemplate>
                    <table style="width: auto; height: 100%;">
                        <tr>
                            <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                                Grupos contables
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                                Centros de costo
                            </td>
                             <td>
                                &nbsp;&nbsp;
                            </td>
                             <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                                Proviene de
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_it_CuentasContable_Grupo_Numeric" 
                                             Width="200px" 
                                             runat="server" 
                                             DataSourceID="GruposContables_SqlDataSource"
                                             DataTextField="Descripcion" 
                                             DataValueField="Grupo" 
                                             AutoPostBack="False" 
                                             SelectionMode="Multiple" 
                                             Rows="20" CssClass="smallfont" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
                               <asp:ListBox ID="Sql_it_CentroCosto_Numeric" 
                                             Width="200px" 
                                             runat="server" 
                                             DataSourceID="CentrosCosto_SqlDataSource"
                                             DataTextField="NombreCentroCosto" 
                                             DataValueField="CentroCosto" 
                                             AutoPostBack="False" 
                                             SelectionMode="Multiple" 
                                             Rows="20" CssClass="smallfont" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
                               <asp:ListBox ID="Sql_it_Asiento_ProvieneDe_String" 
                                             Width="200px" 
                                             runat="server" 
                                             DataSourceID="ProvieneDe_SqlDataSource"
                                             DataTextField="ProvieneDe" 
                                             DataValueField="ProvieneDe" 
                                             AutoPostBack="False" 
                                             SelectionMode="Multiple" 
                                             Rows="20" CssClass="smallfont" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </cc1:TabPanel>


            <cc1:TabPanel HeaderText="Lista (3)" runat="server" ID="TabPanel4" >
                <ContentTemplate>
                    <table style="width: auto; height: 100%;">
                        <tr>
                            <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                                Usuarios
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
 
                            </td>
                             <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
 
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_it_Asiento_Usuario_String" 
                                             Width="200px" 
                                             runat="server" 
                                             DataSourceID="Usuarios_SqlDataSource"
                                             DataTextField="Usuario" 
                                             DataValueField="Usuario" 
                                             AutoPostBack="False" 
                                             SelectionMode="Multiple" 
                                             Rows="20" CssClass="smallfont" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
 
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
                               
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </cc1:TabPanel>

    </cc1:tabcontainer>

        </ContentTemplate>
    </asp:UpdatePanel>
</div>

<asp:panel style="text-align: right; padding: 20px;" 
           runat="server" DefaultButton="AplicarFiltro_Button">

        <asp:Button ID="LimpiarFiltro_Button" 
                    runat="server" 
                    Text="Limpiar filtro" 
                    CausesValidation="False" 
                    onclick="LimpiarFiltro_Button_Click" />

        <asp:Button ID="AplicarFiltro_Button" 
                    runat="server" 
                    Text="Aplicar filtro" 
                    ClientIDMode="Static"
                    onclick="AplicarFiltro_Button_Click" />

</asp:panel>
      
<asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="SELECT [Moneda], [Descripcion] FROM [Monedas] ORDER BY [Descripcion]">
</asp:SqlDataSource>

<asp:SqlDataSource ID="CuentasContables_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
    SelectCommand="SELECT CuentasContables.Cuenta + ' - ' + CuentasContables.Descripcion + ' (' + Companias.Abreviatura + ')' AS CuentaContableYNombre, CuentasContables.Cuenta FROM CuentasContables INNER JOIN Companias ON CuentasContables.Cia = Companias.Numero WHERE (CuentasContables.TotDet = 'D' And CuentasContables.ActSusp = 'A') ORDER BY Companias.NombreCorto, CuentasContables.Cuenta + N' ' + CuentasContables.Descripcion">
</asp:SqlDataSource>

<asp:SqlDataSource ID="Usuarios_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="Select Distinct Usuario From Asientos Order By Usuario">
</asp:SqlDataSource>

<asp:SqlDataSource ID="CentrosCosto_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="SELECT Descripcion + ' (' + DescripcionCorta + ')' AS NombreCentroCosto, CentroCosto FROM CentrosCosto ORDER BY Descripcion">
</asp:SqlDataSource>

<asp:SqlDataSource ID="ProvieneDe_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="Select Distinct ProvieneDe From Asientos Where LTrim(RTrim(ProvieneDe)) &lt;&gt; '' Order By ProvieneDe">
</asp:SqlDataSource>

<asp:SqlDataSource ID="GruposContables_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
    SelectCommand="SELECT Grupo, Descripcion FROM tGruposContables ORDER BY OrdenBalanceGeneral">
</asp:SqlDataSource>
                                  
</asp:Content>