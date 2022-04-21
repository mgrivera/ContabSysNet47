<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Bancos_Facturas_Facturas_Filter" Codebehind="Facturas_Filter.aspx.cs" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../../../radcalendar.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="notsosmallfont" style="padding-left: 25px; padding-right: 25px;">
    
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
            class=" errmessage_background generalfont errmessage"
            ForeColor="" />
            
        <span id="ErrMessage_Span" runat="server" 
            class="errmessage errmessage_background generalfont"
            style="display: block;" />
            
        <cc1:tabcontainer id="TabContainer1" runat="server" activetabindex="0">
            <cc1:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1">
                <ContentTemplate>
                    <table style="margin-top:20px; ">
                        <tr>
                            <td style="text-align: left; ">Número factura:&nbsp;
                            </td>
                            <td> <asp:TextBox ID="Sql_Facturas_NumeroFactura_String" runat="server" Width="105px"></asp:TextBox>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="text-align: left; ">F emisión:&nbsp;
                            </td>
                            <td> <asp:TextBox ID="Sql_Facturas_FechaEmision_Date" runat="server" Width="105px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; ">F recepción: 
                            </td>
                            <td><asp:TextBox ID="Sql_Facturas_FechaRecepcion_Date" runat="server" Width="105px"></asp:TextBox>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="text-align: left; ">Tipo: 
                            </td>
                            <td><asp:DropDownList ID="Sql_Facturas_CxCCxPFlag_Numeric" runat="server" Width="105px">
                                <asp:ListItem Text="" Value="" />
                                <asp:ListItem Text="CxP" Value="1" />
                                <asp:ListItem Text="CxC" Value="2" />
                            </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; ">F pago: 
                            </td>
                            <td><asp:TextBox ID="Sql_pg_Fecha_Date" runat="server" Width="105px"></asp:TextBox>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td style="text-align: left; ">
                                <asp:CheckBox ID="SoloNotasCredito_CheckBox" runat="server" Text="Solo notas de crédito" />
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; ">Lote: 
                            </td>
                            <td><asp:TextBox ID="Sql_Facturas_Lote_String" runat="server" Width="105px" ToolTip="Solo facturas cargadas en forma 'masiva', al menos por ahora, tienen un número de lote "></asp:TextBox>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; color: #0046D5;" colspan="5">
                            <br />
                            Fechas de recepción de planillas de retención de impuestos: <br />
                            (Use un solo tipo de retención (Iva o Islr) 
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; ">Islr: 
                            </td>
                            <td><asp:TextBox ID="Sql_FacturasImpuestos_FRecepcionRetencionISLR_Date" runat="server" 
                                            Width="105px"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                            <td>Iva: 
                            </td>
                            <td><asp:TextBox ID="Sql_FacturasImpuestos_FRecepcionRetencionIVA_Date" runat="server" 
                                            Width="105px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; color: #0046D5;" colspan="5">
                            Montos de impuestos retenidos: 
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; ">Islr: 
                            </td>
                            <td><asp:TextBox ID="Sql_FacturasImpuestos_ImpuestoRetenido_Numeric" runat="server" 
                                            Width="105px"></asp:TextBox>
                            </td>
                            <td>
                            </td>
                            <td>Iva: 
                            </td>
                            <td><asp:TextBox ID="Sql_FacturasImpuestos_RetencionSobreIva_Numeric" runat="server" 
                                            Width="105px"></asp:TextBox>
                            </td>
                        </tr>

                    </table>

                    <br /><br />

                    <div style="margin-bottom: 20px; ">
                        <fieldset style="text-align: left; width: 70%;">
                            <legend>Solo facturas con:</legend>
                            <asp:CheckBox ID="MostrarSoloFacturasRetencionISLR_CheckBox" runat="server" Text="Retención ISLR" Checked="False" />
                            <br />
                            <asp:CheckBox ID="MostrarSoloFacturasRetencionIva_CheckBox" runat="server" Text="Retención Iva" Checked="False" />
                            <br />
                            <asp:CheckBox ID="MostrarSoloFacturasOtrosImpuestos_CheckBox" runat="server" Text="Impuestos/Retenciones varios" Checked="False" />
                            <br />
                            <asp:CheckBox ID="AfectaLibroCompras_CheckBox" runat="server" Text="Aplican al libro de compras (en Proveedores)" Checked="False" />
                        </fieldset>

                        <br /><br />

                        <div style="margin-left: 0; text-align: left; ">
                            Título para el reporte (opcional):&nbsp;
                            <asp:TextBox ID="Report_SubTitle_TextBox" runat="server"></asp:TextBox>
                        </div>

                        <br /><br />

                        <div style="width: 100%; ">
                            <div style="text-align: left; width: 48%; float: left; ">
                                <fieldset>
                                    <legend>Control de caja chica:</legend>
                                    <asp:CheckBox ID="LeerFacturasControlCajaChica_CheckBox" 
                                        runat="server" 
                                        Text="Leer y mostrar facturas marcadas para que aparezcan en el libro de compras"
                                        Checked="False" />
                                    <br />
                                    <div  style="margin-left: 15px; ">
                                        <asp:CheckBox ID="LeerSoloFacturasControlCajaChica_CheckBox" 
                                            runat="server" 
                                            Text="Leer y mostrar SOLO estas facturas en la consulta"
                                            Checked="False" />
                                    </div>
                                </fieldset>
                            </div>

                            <div style="text-align: left; width: 48%; float: right;">
                                <fieldset>
                                    <legend>Reconversión (2021):</legend>
                                    <asp:CheckBox ID="ReconvertirCifrasAntes_01Oct2021_CheckBox" 
                                                  runat="server" 
                                                  Text="Reconvertir cifras anteriores al 1/Oct/21" 
                                                  Checked="False" />
                                    </div>
                                </fieldset>
                            </div>

                        </div>
                        
                    </div>
                </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel HeaderText="Compañías Contab, monedas" runat="server" ID="TabPanel2">
                <ContentTemplate>
                <table>
                        <tr>
                            <td class="ListViewHeader_Suave generalfont">
                                Cias contab
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
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_Facturas_Cia_Numeric" runat="server" 
                                    DataTextField="NombreCorto" DataValueField="Numero" Height="193px" SelectionMode="Multiple"
                                    Width="200px" CssClass="notsosmallfont"></asp:ListBox>
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:ListBox ID="Sql_Facturas_Moneda_Numeric" runat="server" DataSourceID="Monedas_SqlDataSource"
                                    DataTextField="Descripcion" DataValueField="Moneda" Height="193px" SelectionMode="Multiple"
                                    Width="200px" CssClass="notsosmallfont"></asp:ListBox>
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel HeaderText="Proveedores y clientes" runat="server" ID="TabPanel3">
                <ContentTemplate>
                <table>
                        <tr>
                            <td>
                                <div class="ListViewHeader_Suave generalfont" style="width: 420px; ">
                                    Proveedores y clientes
                                </div>
                                
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_Facturas_Proveedor_String" 
                                             runat="server" 
                                             DataSourceID="Companias_SqlDataSource"
                                             DataTextField="Nombre" 
                                             DataValueField="Proveedor" 
                                             Height="193px"
                                             SelectionMode="Multiple" 
                                             Width="420" 
                                             CssClass="generalfont" />


                                <cc1:ListSearchExtender ID="ListSearchExtender1" 
                                                        runat="server" 
                                                        TargetControlID="Sql_Facturas_Proveedor_String" 
                                                        IsSorted="True" 
                                                        QueryPattern="Contains" 
                                                        PromptText="Tipee para buscar ..." 
                                                        PromptPosition="Bottom" PromptCssClass="smallfont_blue" />

                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left;" class="generalfont">
                                <br />
                                Nombre de la compañía:&nbsp;&nbsp;
                                <asp:TextBox ID="Sql_Proveedores_Nombre_String" runat="server"></asp:TextBox>
                                <p>Ud. puede indicar <em><b>parte</b></em> del nombre de la compañía, para que se lean sus facturas;<br /> por ejemplo, 
                                    para buscar facturas de la compañía <em>'Empresas Polar'</em>,<br /> Ud. puede indicar <em>'pola'</em> en este campo.
                                </p>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel HeaderText="Tipos, condiciones de pago, estados" runat="server" ID="TabPanel4">
                <ContentTemplate>
                
                    <table>
                        <tr>
                            <td class="ListViewHeader_Suave generalfont">
                                Tipos
                            </td>
                            <td></td>
                            <td class="ListViewHeader_Suave generalfont">
                                Cond pago
                            </td>
                            <td></td>
                            <td class="ListViewHeader_Suave generalfont">
                                Estados
                            </td>
                        </tr>
                        <tr>
                            <td>
                             <asp:ListBox ID="Sql_Facturas_Tipo_Numeric" 
                                          runat="server" 
                                          DataSourceID="Tipos_SqlDataSource"
                                          DataTextField="Descripcion" 
                                          DataValueField="Tipo" 
                                          Height="193px" 
                                          Width="180px" 
                                          SelectionMode="Multiple" 
                                          CssClass="generalfont" />


                             <cc1:ListSearchExtender ID="ListSearchExtender2" 
                                                        runat="server" 
                                                        TargetControlID="Sql_Facturas_Tipo_Numeric" 
                                                        IsSorted="True" 
                                                        QueryPattern="Contains" 
                                                        PromptText="Tipee para buscar ..." 
                                                        PromptPosition="Bottom" PromptCssClass="smallfont_blue" />

                              <br />

                            </td>
                            <td>&nbsp;&nbsp;&nbsp;</td>
                            <td>
                             <asp:ListBox ID="Sql_Facturas_CondicionesDePago_Numeric" runat="server" DataSourceID="CondPago_SqlDataSource"
                                    DataTextField="Descripcion" DataValueField="FormaDePago" Height="193px"  Width="180px"
                                    SelectionMode="Multiple"  CssClass="generalfont"></asp:ListBox>
                            </td>
                            <td>&nbsp;&nbsp;&nbsp;</td>
                            <td>
                             <asp:ListBox ID="Sql_Facturas_Estado_Numeric" runat="server" 
                                    Height="193px"  Width="180px" SelectionMode="Multiple" CssClass="generalfont">
                                        <asp:ListItem Text="Pendiente" Value="1" />
                                        <asp:ListItem Text="Parcial" Value="2" />
                                        <asp:ListItem Text="Pagada" Value="3" />
                                        <asp:ListItem Text="Anulada" Value="4" />
                             </asp:ListBox>
                            </td>
                        </tr>
                    </table>
               
                </ContentTemplate>
            </cc1:TabPanel>
        </cc1:tabcontainer>
        <br />
        
        <div style="text-align: right;">
            <asp:Button ID="LimpiarFiltro_Button" 
                        runat="server" 
                        Text="Limpiar filtro" 
                        CausesValidation="False" 
                        onclick="LimpiarFiltro_Button_Click" />
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            <asp:Button ID="AplicarFiltro_Button" 
                        runat="server" Text="Aplicar filtro" 
                        onclick="AplicarFiltro_Button_Click" 
                        ClientIDMode="Static" />

            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>

       <%-- <asp:SqlDataSource ID="CiasContab_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT NombreCorto, Numero FROM Companias ORDER BY NombreCorto">
        </asp:SqlDataSource>--%>

        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Descripcion, Moneda FROM Monedas ORDER BY Descripcion">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="Companias_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT Nombre, Proveedor FROM Proveedores ORDER BY Nombre">
        </asp:SqlDataSource>
        
        <asp:SqlDataSource ID="Tipos_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT Tipo, Descripcion FROM TiposProveedor ORDER BY Descripcion">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="CondPago_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT FormaDePago, Descripcion FROM FormasDePago ORDER BY Descripcion">
        </asp:SqlDataSource>

        <script type="text/javascript">
            // TODO: agregar el código que sigue, para que el boton Ok reciba el focus ... 
            //$(function () {
            //    debugger; 
            //    $('#AplicarFiltro_Button').focus();
            //}
            //); 
        </script>
        
    </div>
</asp:Content>

