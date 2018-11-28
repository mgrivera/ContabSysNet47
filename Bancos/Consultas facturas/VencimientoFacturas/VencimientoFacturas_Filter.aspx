<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple_With_BS40.master" AutoEventWireup="true" Inherits="Bancos_VencimientoFacturas_VencimientoFacturas_Filter" Codebehind="VencimientoFacturas_Filter.aspx.cs" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">   
    <link href="../../../radcalendar.css" rel="stylesheet" type="text/css" />
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 <div class="notsosmallfont" style="padding-left: 25px; padding-right: 25px; padding-bottom: 25px;">

     <div class="row">
        <div class="col-sm">
            <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" class=" errmessage_background generalfont errmessage" ForeColor="" />
        </div>
    </div>

     <div class="row" style="margin-top: 15px; ">
        <div class="col-sm-4" style="text-align: right; font-weight: bold; ">
            Facturas pendientes al:
        </div>
        <div class="col-sm-2" style="text-align: left; ">
            <asp:TextBox ID="Hasta_TextBox" runat="server" Width="80px"></asp:TextBox>
            <cc1:CalendarExtender ID="Desde_TextBox_CalendarExtender" runat="server" Enabled="True"
                Format="dd-MM-yy" PopupButtonID="DesdeCalendar_PopUpButton" CssClass="radcalendar"
                TargetControlID="Hasta_TextBox">
            </cc1:CalendarExtender>
            <asp:ImageButton ID="HastaCalendar_PopUpButton" runat="server" alt="" src="../../../Pictures/Calendar.png"
                CausesValidation="False" TabIndex="-1" />
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Hasta_TextBox"
                CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="Ud. debe indicar una fecha">
                *
            </asp:RequiredFieldValidator>
            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="Hasta_TextBox"
                CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                Operator="DataTypeCheck" Type="Date">
                *
            </asp:CompareValidator>
        </div>
        <div class="col-sm-6" style="text-align: left; ">
            <p>
                El proceso leerá las facturas pendientes hasta esta fecha, no posteriores. Además, calculará los vencimientos también en base a 
                la fecha que se indique aquí. 
            </p>
        </div>
    </div>

     <div class="row" style="margin-top: 15px; ">
        <div class="col-sm-4" style="text-align: right; font-weight: bold; ">
            Leer facturas a partir de:
        </div>
        <div class="col-sm-2" style="text-align: left; ">
            <asp:TextBox ID="Desde_TextBox" runat="server" Width="80px"></asp:TextBox>
            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Enabled="True"
                Format="dd-MM-yy" PopupButtonID="DesdeCalendar_PopUpButton" CssClass="radcalendar"
                TargetControlID="Desde_TextBox">
            </cc1:CalendarExtender>
            <asp:ImageButton ID="ImageButton1" runat="server" alt="" src="../../../Pictures/Calendar.png"
                CausesValidation="False" TabIndex="-1" />
            <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="Desde_TextBox"
                CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                Operator="DataTypeCheck" Type="Date">
                *
            </asp:CompareValidator>
        </div>
        <div class="col-sm-6" style="text-align: left; ">
            <p>
                Ud. puede o no indicar una fecha aquí. Si la indica, solo facturas a partir de esa fecha serán leídas; si no la indica, 
                el proceso leerá las facturas (pendientes) desde la más antigua. 
            </p>
        </div>
    </div>

     <div class="row" style="margin-top: 15px; ">
        <div class="col-sm" style="text-align: right; font-weight: bold; ">
            Número factura:
        </div>
         <div class="col-sm" style="text-align: left; ">
            <asp:TextBox ID="Sql_Facturas_NumeroFactura_String" runat="server"></asp:TextBox>
        </div>
        <div class="col-sm">
        </div>
    </div>

     <div class="row" style="margin-top: 15px; ">
        <div class="col-sm" style="text-align: right; font-weight: bold; ">
            Tipo de consulta:
        </div>
         <div class="col-sm" style="text-align: left; ">
            <asp:DropDownList ID="TipoConsulta_DropDownList" runat="server">
                <asp:ListItem Text="Montos por vencer" Value="1" Selected="True" />
                <asp:ListItem Text="Montos vencidos" Value="2" />
            </asp:DropDownList>
        </div>
        <div class="col-sm">
        </div>
    </div>

    <br /> 

     <div class="row" style="margin-top: 15px; ">
        <div class="col-sm" style="text-align: center; ">
            <div style="font-weight: bold;">
                Monedas
            </div>
            <br /> 
            <asp:ListBox ID="Sql_CuotasFactura_Moneda_Numeric" runat="server" DataSourceID="Monedas_SqlDataSource"
                DataTextField="Descripcion" DataValueField="Moneda" Height="193px" SelectionMode="Multiple"
                CssClass="notsosmallfont">
            </asp:ListBox>
        </div>
        <div class="col-sm" style="text-align: center; ">
            <div style="font-weight: bold;">
                Cias Contab
            </div>
            <br /> 
            <asp:ListBox ID="Sql_CuotasFactura_Cia_Numeric" runat="server" 
                DataTextField="NombreCorto" DataValueField="Numero" Height="193px" SelectionMode="Multiple"
                CssClass="notsosmallfont">
            </asp:ListBox>
        </div>
        <div class="col-sm" style="text-align: center; ">
            <div style="font-weight: bold;">
                Compañías 
            </div>
            <br /> 
            <asp:ListBox ID="Sql_CuotasFactura_Proveedor_String" runat="server" DataSourceID="Companias_SqlDataSource"
                DataTextField="Nombre" DataValueField="Proveedor" Height="193px" SelectionMode="Multiple"
                CssClass="notsosmallfont">
            </asp:ListBox>
        </div>
        <div class="col-sm" style="text-align: center; ">
            <div style="font-weight: bold;">
                Tipos
            </div>
            <br /> 
            <asp:ListBox ID="Sql_CuotasFactura_CxCCxPFlag_Numeric" runat="server" Height="193px" SelectionMode="Multiple"
                CssClass="notsosmallfont">
                <asp:ListItem Text="Proveedores" Value="1" />
                <asp:ListItem Text="Clientes" Value="2" />
            </asp:ListBox>
        </div>
    </div>

 
    <div class="row" style="margin-top: 15px; ">
        <div class="col-sm">
            <asp:CheckBox ID="AplicarFechasRecepcionPlanillasRetencionImpuestos_CheckBox" 
                          runat="server" 
                          Text="Retención de impuestos: aplicar solo si se han recibido " 
                          ToolTip="Marcar si se desea restar retenciones del total a pagar de la factura, solo si se han recibido sus planillas respectivas y se han actualizado estas fechas en la factura" />
        </div>
    </div>

     <div class="row" style="margin-top: 15px; ">
        <div class="col-sm">
            <asp:Button ID="LimpiarFiltro_Button" runat="server" Text="Limpiar filtro" 
                CausesValidation="False" onclick="LimpiarFiltro_Button_Click" />
        </div>
        <div class="col-sm">
            <asp:Button ID="AplicarFiltro_Button" runat="server" Text="Aplicar filtro" 
                onclick="AplicarFiltro_Button_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>
    </div>
                    

    <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="SELECT Descripcion, Moneda FROM Monedas ORDER BY Descripcion">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="Companias_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="SELECT Proveedor, Nombre FROM Proveedores ORDER BY Nombre">
    </asp:SqlDataSource>
        
    </div>
    
</asp:Content>

