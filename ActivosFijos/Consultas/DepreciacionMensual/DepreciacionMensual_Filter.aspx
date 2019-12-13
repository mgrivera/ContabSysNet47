<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_Simple.master" CodeBehind="DepreciacionMensual_Filter.aspx.cs" Inherits="ContabSysNet_Web.ActivosFijos.Consultas.DepreciacionMensual.DepreciacionMensual_Filter" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div style="text-align: left; padding: 0px 20px 0px 20px;">

    <asp:ValidationSummary ID="ValidationSummary1" 
                           runat="server" 
                           class="errmessage_background generalfont errmessage"
                           ForeColor="" />

    <cc1:tabcontainer id="TabContainer1" runat="server" activetabindex="0">

        <cc1:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1" >

            <ContentTemplate>

                <table style="font-size: x-small; ">

                    <tr>
                        <td>
                            Mes y año <br />de la consulta: 
                        </td>

                        <td style="padding-right:20px; ">
                            <asp:DropDownList id="drpdwn_MesConsulta" 
                                              runat="server" 
                                              style="font-size: small; ">
                                <asp:ListItem Value="0">Seleccione un mes</asp:ListItem>
                                <asp:ListItem Value="1">Enero</asp:ListItem>
                                <asp:ListItem Value="2">Febrero</asp:ListItem>
                                <asp:ListItem Value="3">Marzo</asp:ListItem>
                                <asp:ListItem Value="4">Abril</asp:ListItem>
                                <asp:ListItem Value="5">Mayo</asp:ListItem>
                                <asp:ListItem Value="6">Junio</asp:ListItem>
                                <asp:ListItem Value="7">Julio</asp:ListItem>
                                <asp:ListItem Value="8">Agosto</asp:ListItem>
                                <asp:ListItem Value="9">Septiembre</asp:ListItem>
                                <asp:ListItem Value="10">Octubre</asp:ListItem>
                                <asp:ListItem Value="11">Noviembre</asp:ListItem>
                                <asp:ListItem Value="12">Diciembre</asp:ListItem>
                            </asp:DropDownList>

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" 
                                                    runat="server" 
                                                    ControlToValidate="drpdwn_MesConsulta"
                                                    CssClass="errmessage generalfont" 
                                                    Display="Dynamic" 
                                                    InitialValue = "0"
                                                    ForeColor="Red"
                                                    ErrorMessage="Ud. debe indicar el mes de la consulta">*
                            </asp:RequiredFieldValidator>

                            <asp:TextBox ID="txt_AnoConsulta" 
                                         runat="server" 
                                         Width="50px" />

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" 
                                                    runat="server" 
                                                    ControlToValidate="txt_AnoConsulta"
                                                    CssClass="errmessage generalfont" 
                                                    Display="Dynamic" 
                                                    ForeColor="Red"
                                                    ErrorMessage="Ud. debe indicar el año de la consulta">*
                            </asp:RequiredFieldValidator>

                            <asp:CompareValidator ID="CompareValidator2" 
                                                  runat="server" 
                                                  ControlToValidate="txt_AnoConsulta"
                                                  CssClass="errmessage generalfont" 
                                                  Display="Dynamic" 
                                                  ErrorMessage="El valor indicado no es válido. Debe ser un entero de cuatro dígitos."
                                                  Operator="DataTypeCheck" 
                                                  ForeColor="Red">*
                            </asp:CompareValidator>

                            <br />
                        </td>
                       
                        <td />
                        <td />
                    </tr>

                    <tr>
                        <td>
                            Producto: 
                        </td>
                        <td style="padding-right:20px; ">
                            <asp:TextBox ID="Sql_it_Producto_String" runat="server" />
                        </td>
                       
                        <td>
                            Descripcion: 
                        </td>
                        <td style="padding-right:20px; ">
                            <asp:TextBox ID="Sql_it_Descripcion_String" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>Serial: 
                        </td>
                        <td style="padding-right:20px; "><asp:TextBox ID="Sql_it_Serial_String" runat="server" />
                      
                        </td>
                        <td>Placa: 
                        </td>
                        <td style="padding-right:20px; "><asp:TextBox ID="Sql_it_Placa_String" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Modelo: 
                        </td>
                        <td style="padding-right:20px; ">
                            <asp:TextBox ID="Sql_it_Modelo_String" runat="server" />
                        </td>
                        
                        <td>
                            F compra: 
                        </td>
                        <td style="padding-right:20px; ">
                            <asp:TextBox ID="fCompra_desde" runat="server" TextMode="Date" />/
                            <asp:TextBox ID="fCompra_hasta" runat="server" TextMode="Date" />
                            <asp:CompareValidator ID="CompareValidator3" runat="server" ControlToValidate="fCompra_hasta"
                                CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El intervalo indicado no es válido."
                                Operator="GreaterThanEqual" Type="Date" ControlToCompare="fCompra_desde" Style="color: red; ">*</asp:CompareValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>

                        <td style="padding-right:20px; ">         
                            <asp:CheckBox ID="ckh_ExcluirDepreciadosAnosAnteriores" 
                                          runat="server" 
                                          Text="" />
                            <b>Totalmente depreciados:</b> Excluir<br /> activos totalmente<br />depreciados en años anteriores<br />al año de la consulta
                        </td>
                       
                        <td style="white-space: nowrap">F desincorporación: 
                        </td>
                        <td style="padding-right:20px; ">
                            <asp:TextBox ID="fDesincorporacion_desde" runat="server" TextMode="Date" />/
                            <asp:TextBox ID="fDesincorporacion_hasta" runat="server" TextMode="Date" />
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="fDesincorporacion_hasta"
                                CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El intervalo indicado no es válido."
                                Operator="GreaterThanEqual" Type="Date" ControlToCompare="fDesincorporacion_desde" Style="color: red; ">*</asp:CompareValidator>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td style="padding-right:20px; ">         
                            <asp:CheckBox ID="chk_AplicarInfoDesincorporacion" 
                                            runat="server" 
                                            Text="" />
                            <b>Desincorporados:</b> depreciar<br />hasta el mes anterior<br />al indicado en la fecha de <br />desincorporación del activo 
                        </td>
                        <td />
                        <td />
                    </tr>

                    <tr>
                        <td>
                            &nbsp;
                        </td>
                        <td />
                        <td />
                        <td />
                    </tr>

                    <tr>
                        <td>
                            &nbsp;</td>
                        <td style="padding-right:20px; ">         
                            &nbsp;</td>
                        <td />
                        <td />
                    </tr>

                    <tr>
                        <td />
                        <td style="padding-right:20px; ">         
                            &nbsp;</td>
                        <td />
                        <td />
                    </tr>

                </table>

            </ContentTemplate>

            </cc1:TabPanel>


        <cc1:TabPanel HeaderText="Lista (1)" runat="server" ID="TabPanel2" >

            <ContentTemplate>

                <table style="width: 100%; height: 100%;">
                    <tr>
                        <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                            Cias contab
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                            Monedas
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                            Departamentos
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                            Tipos de producto
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="Sql_it_Cia_Numeric" 
                                runat="server" 
                                DataTextField="NombreCorto" DataValueField="Numero" 
                                AutoPostBack="False" 
                                SelectionMode="Single" 
                                Rows="20"
                                >
                            </asp:ListBox>

                            <asp:RequiredFieldValidator ID="CiaContab_RequiredFieldValidator" 
                                                        runat="server" 
                                                        ControlToValidate="Sql_it_Cia_Numeric"
                                                        CssClass="errmessage generalfont" 
                                                        Display="Dynamic" 
                                                        ForeColor="Red"
                                                        ErrorMessage="Ud. debe seleccionar una cia contab.">*
                            </asp:RequiredFieldValidator>
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:ListBox ID="Sql_it_Moneda_Numeric" 
                                runat="server" 
                                DataSourceID="Monedas_SqlDataSource"
                                DataTextField="Descripcion" 
                                DataValueField="Moneda" 
                                AutoPostBack="False" 
                                SelectionMode="Multiple" 
                                Rows="20">
                            </asp:ListBox>
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:ListBox ID="Sql_it_Departamento_Numeric" 
                                runat="server" 
                                DataSourceID="Departamentos_SqlDataSource"
                                DataTextField="Descripcion" DataValueField="Departamento" 
                                SelectionMode="Multiple"
                                Rows="20"
                                AutoPostBack="False" >
                            </asp:ListBox>
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:ListBox ID="Sql_it_Tipo_Numeric" 
                                runat="server" 
                                DataSourceID="TiposProducto_SqlDataSource"
                                DataTextField="Descripcion" DataValueField="Tipo" 
                                SelectionMode="Multiple"
                                Rows="20"
                                AutoPostBack="False" >
                            </asp:ListBox>
                        </td>

                    </tr>
                </table>

            </ContentTemplate>
        </cc1:TabPanel>

         <cc1:TabPanel HeaderText="Lista (2)" runat="server" ID="TabPanel3" >

            <ContentTemplate>

                <table style="width: 100%; height: 100%;">
                    <tr>
                        <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                            Proveedores
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                         <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                            Atributos
                        </td>
                         <td>
                            &nbsp;&nbsp;
                        </td>
                         <td>
                            &nbsp;&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="Sql_it_Proveedor_Numeric" 
                                runat="server" 
                                DataSourceID="Proveedores_SqlDataSource"
                                DataTextField="Nombre" DataValueField="Proveedor" 
                                AutoPostBack="False" 
                                SelectionMode="Multiple" 
                                Rows="20"
                                >
                            </asp:ListBox>
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                         <td>
                            <asp:ListBox ID="lst_Atributos" 
                                         runat="server" 
                                         DataSourceID="Atributos_SqlDataSource"
                                         DataTextField="Descripcion" 
                                         DataValueField="Atributo" 
                                         AutoPostBack="False" 
                                         SelectionMode="Multiple" 
                                         Rows="20">
                            </asp:ListBox>
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                         <td>
                            &nbsp;&nbsp;
                        </td>

                    </tr>
                </table>

            </ContentTemplate>
        </cc1:TabPanel>

        <cc1:TabPanel HeaderText="Notas" runat="server" ID="TabPanel4" >

            <ContentTemplate>
                <div style="padding: 10px; ">
                    <p>
                        El usuario debe siempre seleccionar una compañía <em>Contab</em>. Además, solo podrá seleccionar una, y no varias. 
                    </p>
                    <p>
                        La consulta siempre se obtiene para un mes y año. El usuario debe indicar siempre estos valores. El año debe tener 4 dígitos (ej: 2011).  
                    </p>
                    <p>
                        El usuario puede aplicar las fechas en el filtro de esta forma: 
                        <ul>
                            <li>
                                Si solo usa la fecha de inicio (<em>desde</em>), se seleccionarán registros para la fecha indicada.  
                            </li>
                            <li>
                                Si usa ambas fechas (<em>desde</em>, <em>hasta</em>), se seleccionarán registros que cumplan este período.  
                            </li>
                        </ul>
                    </p>
                    <p>
                        En campos alfanuméricos, puede usar '*' para <em>generalizar</em>; ejemplos:   
                        <ul>
                            <li>
                                <em>*casa*</em>: lo que contenga la palabra casa.  
                            </li>
                            <li>
                                <em>casa*</em>: lo que empiece por la palabra casa. 
                            </li>
                            <li>
                                <em>*casa</em>: lo que termine en la palabra casa. 
                            </li>
                            <li>
                                <em>casa</em> (solo): para usar el valor exacto.  
                            </li>
                        </ul>
                    </p>
                </div>
            </ContentTemplate>
        </cc1:TabPanel>

    </cc1:tabcontainer>
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
                    onclick="AplicarFiltro_Button_Click" />

</asp:panel>
      
<asp:SqlDataSource ID="Proveedores_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
    SelectCommand="SELECT Proveedor, Nombre From Proveedores Where ProveedorClienteFlag = 1 Or ProveedorClienteFlag = 3 Order By Nombre">
</asp:SqlDataSource>

<asp:SqlDataSource ID="Departamentos_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
    SelectCommand="SELECT Departamento, Descripcion FROM tDepartamentos ORDER BY Descripcion">
</asp:SqlDataSource>

<asp:SqlDataSource ID="TiposProducto_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
    SelectCommand="SELECT Tipo, Descripcion FROM TiposDeProducto ORDER BY Descripcion">
</asp:SqlDataSource>

<asp:SqlDataSource ID="Atributos_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
    SelectCommand="SELECT Atributo, Descripcion FROM Atributos Where Origen = 'ActFijo' ORDER BY Descripcion">
</asp:SqlDataSource>

<asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
    SelectCommand="SELECT Moneda, Descripcion FROM Monedas ORDER BY Descripcion">
</asp:SqlDataSource>
                                  
</asp:Content>