<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Bancos_VencimientoFacturas_VencimientoFacturas_Filter" Codebehind="VencimientoFacturas_Filter.aspx.cs" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="../../../radcalendar.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 <div class="notsosmallfont" style="padding-left: 25px; padding-right: 25px; padding-bottom: 25px;">

        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" class=" errmessage_background generalfont errmessage"
            ForeColor="" />
       
                    <div style="text-align: left; margin-left: 20px; margin-bottom:15px; " class="generalfont">
                        <table style="" cellspacing="15px">
                            <tr>
                                <td>
                                    Facturas pendientes al:
                                </td>
                                <td>
                                    <asp:TextBox ID="Desde_TextBox" runat="server" Width="80px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="Desde_TextBox_CalendarExtender" runat="server" Enabled="True"
                                        Format="dd-MM-yy" PopupButtonID="DesdeCalendar_PopUpButton" CssClass="radcalendar"
                                        TargetControlID="Desde_TextBox">
                                    </cc1:CalendarExtender>
                                    <asp:ImageButton ID="DesdeCalendar_PopUpButton" runat="server" alt="" src="../../../Pictures/Calendar.png"
                                        CausesValidation="False" TabIndex="-1" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Desde_TextBox"
                                        CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="Ud. debe indicar una fecha">*</asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="Desde_TextBox"
                                        CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                                        Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator>
                                </td>
                                <td>
                                    Número factura:
                                </td>
                                <td>
                                    <asp:TextBox ID="Sql_Facturas_NumeroFactura_String" runat="server" Width="80px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Tipo de consulta:
                                </td>
                                <td>
                                    <asp:DropDownList ID="TipoConsulta_DropDownList" runat="server">
                                        <asp:ListItem Text="Montos por vencer" Value="1" Selected="True" />
                                        <asp:ListItem Text="Montos vencidos" Value="2" />
                                    </asp:DropDownList>
                                </td>
                                <td>
                                </td>
                                <td>
                                </td>
                            </tr>
                        </table>

                    </div>
             
                    <table>
                        <tr>
                            <td class="ListViewHeader_Suave generalfont">
                                Monedas
                            </td>
                            <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td class="ListViewHeader_Suave generalfont">
                                Cias Contab
                            </td>
                            <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td class="ListViewHeader_Suave generalfont">
                                Compañías
                            </td>
                             <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td class="ListViewHeader_Suave generalfont">
                                Tipo
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_CuotasFactura_Moneda_Numeric" runat="server" DataSourceID="Monedas_SqlDataSource"
                                    DataTextField="Descripcion" DataValueField="Moneda" Height="193px" SelectionMode="Multiple"
                                    Width="100px" CssClass="notsosmallfont"></asp:ListBox>
                            </td>
                            <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:ListBox ID="Sql_CuotasFactura_Cia_Numeric" runat="server" 
                                    DataTextField="NombreCorto" DataValueField="Numero" Height="193px" SelectionMode="Multiple"
                                    Width="120px" CssClass="notsosmallfont"></asp:ListBox>
                            </td>
                            <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>
                               <asp:ListBox ID="Sql_CuotasFactura_Proveedor_String" runat="server" DataSourceID="Companias_SqlDataSource"
                                    DataTextField="Nombre" DataValueField="Proveedor" Height="193px" SelectionMode="Multiple"
                                    Width="200px" CssClass="notsosmallfont"></asp:ListBox>
                            </td>
                             <td>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:ListBox ID="Sql_CuotasFactura_CxCCxPFlag_Numeric" runat="server" Height="193px" SelectionMode="Multiple"
                                    Width="100px" CssClass="notsosmallfont">
                                    <asp:ListItem Text="Proveedores" Value="1" />
                                    <asp:ListItem Text="Clientes" Value="2" />
                                </asp:ListBox>
                            </td>
                        </tr>
                    </table>
               
        <br />
        <div style="text-align: left;">
            <asp:CheckBox ID="AplicarFechasRecepcionPlanillasRetencionImpuestos_CheckBox" 
                          runat="server" 
                          Text="Retención de impuestos: aplicar solo si se han recibido " 
                          ToolTip="Marcar si se desea restar retenciones del total a pagar de la factura, solo si se han recibido sus planillas respectivas y se han actualizado estas fechas en la factura" />
        </div>
        
        <br />
        <br />
        <div style="text-align: right;">
            <asp:Button ID="LimpiarFiltro_Button" runat="server" Text="Limpiar filtro" 
                CausesValidation="False" onclick="LimpiarFiltro_Button_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="AplicarFiltro_Button" runat="server" Text="Aplicar filtro" 
                onclick="AplicarFiltro_Button_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>

        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Descripcion, Moneda FROM Monedas ORDER BY Descripcion">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="Companias_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Proveedor, Nombre FROM Proveedores ORDER BY Nombre">
        </asp:SqlDataSource>
        
    </div>
    
</asp:Content>

