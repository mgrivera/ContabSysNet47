<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="ComprobantesContables_Filter.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Comprobantes.ComprobantesContables_Filter" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../../../radcalendar.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../../../Scripts/select2-4.0.8/select2.min.css" />

    <script type="text/javascript">
        // todas las funciones en este script, corresponden a la funcionalidad necesaria para agregar el select2 
        // para la selección de cuentas contables ... 
        function formatState(state) {
            if (state.id && state.text) {
                return state.id + " - " + state.text; 
            } else {
                return null; 
            }
        }

        $(document).ready(function () { 
            $(".select2-input").select2({
                minimumInputLength: 3,                              // minimumInputLength for sending ajax request to server
                width: 'resolve',                                   // to use the width set in the style clause in the select, if one exists  
                closeOnSelect: false, 
                params: {
                    contentType: 'application/json; charset=utf-8'
                },
                templateResult: formatState,                        // para cambiar lo que se muestra en la lista; el default es text ... 
                templateSelection: formatState,                     // para cambiar lo que se muestra en la selección; el default es text ... 
                ajax: {
                    url: "../../../webServices/Select2_GetData.asmx/AccessRemoteData",        // Webservice  - WCSelect2 and WebMethod -AccessRemoteData
                    dataType: 'json', 
                    method: "get",
                    data: function (params) {

                        // antes de que el control ejecute su busqueda en el server, intentamos obtener un referencia al control que contiene 
                        // la lista de companias. La idea es asegurarnos que el usuario haya seleccioanado una ... 
                        var selected = []; 
                        
                        $('.ciaListBox').children('option:selected').each(function () {
                            var $this = $(this);
                            selected.push(parseInt( $this.val() )); 
                        });

                        if (selected.length != 1) {
                            alert("Por favor seleccione una compañía Contab, y solo una, antes de intentar buscar sus cuentas contables."); 
                            return; 
                        }

                        var query = {
                            search: params.term,
                            page: params.page || 1, 
                            cia: selected.length == 1 ? selected[0] : -999
                        }

                        // Query parameters will be ?search=[term]&page=[page]
                        return query;
                    }, 
                    processResults: function (result) {
                        // desde el web service recibimos el object result con sus propiedades como siguen ... 
                        return {
                                results: result.items,
                                pagination: {
                                    more: (result.resultParams.page * 20) < result.resultParams.count_filtered
                            }
                        };
                    },
                    delay: 250, // wait 250 milliseconds before triggering the request
                    cache: true
                }, 
                debug: true, 
                placeholder: "Busqueda de cuentas contables ..."
            })

            $('.select2-input').on('select2:select', function (e) {
                // cuando el usuario selecciona una opción en select2
                // en data tenemos la opción seleccionada 
                var data = e.params.data;

                // intentamos agregar la cuenta seleccionada al textbox de cuentas contables 
                var textbox = $('.cuentas-contables-text-area');

                var text = textbox.val();       // contenido del textbox 

                if (text.indexOf(data.id) == -1) {
                    // ok, la cuenta *no* existe en el textbox; la agregamos 
                    if (!text) {
                        text = data.id;
                    } else {
                        text = text + ", " + data.id;
                    }

                    textbox.val(text);
                }
            })

            $('.select2-input').on('select2:unselect', function (e) {
                // cuando el usuario de-selecciona una opción en select2 
                var data = e.params.data;

                // intentamos quitar la cuenta seleccionada del textbox de cuentas contables 
                var textbox = $('.cuentas-contables-text-area');

                var text = textbox.val();       // contenido del textbox 

                if (text.indexOf(data.id) != -1) {
                    // ok, la cuenta *existe* en el textbox; la quitamos 
                    text = text.replace(", " + data.id, "");
                    text = text.replace(data.id, "");

                    textbox.val(text);
                }
            })

            // para asignar una clase a la lista del select ... 
            $("#select1").select2({ dropdownCssClass: "smallfont" });
        })
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="notsosmallfont" style="padding-left: 25px; padding-right: 25px; padding-bottom: 25px;">

        <asp:ValidationSummary ID="ValidationSummary1" runat="server" class=" errmessage_background generalfont errmessage" ForeColor="" />
        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" /> 
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

        <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" style="text-align: left;">
            <asp:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1">
                <ContentTemplate>
                    <div style="text-align: left;" class="generalfont">

                        <table>
                            <tr>
                                <td>Número</td>
                                <td>&nbsp;&nbsp;</td>
                                <td><asp:TextBox ID="Numero_Desde_TextBox" runat="server" TextMode="Number" /></td>
                                <td>&nbsp;&nbsp;</td>
                                <td><asp:TextBox ID="Numero_Hasta_TextBox" runat="server" TextMode="Number" /></td>
                            </tr>
                            <tr>
                                <td>Período:</td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                    <asp:TextBox ID="Desde_TextBox" runat="server" TextMode="Date" />

                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Desde_TextBox"
                                        CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="Ud. debe indicar una fecha" Style="color: red; ">*</asp:RequiredFieldValidator>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                    <asp:TextBox ID="Hasta_TextBox" runat="server" TextMode="Date" />

                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Hasta_TextBox"
                                        CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="Ud. debe indicar una fecha" Style="color: red; ">*</asp:RequiredFieldValidator>

                                    <asp:CompareValidator ID="CompareValidator3" runat="server" ControlToValidate="Hasta_TextBox"
                                        CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El intervalo indicado no es válido."
                                        Operator="GreaterThanEqual" Type="Date" ControlToCompare="Desde_TextBox" Style="color: red; ">*</asp:CompareValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Lote:</td>
                                <td>&nbsp;&nbsp;</td>
                                <td><asp:TextBox ID="Sql_Asientos_Lote_String" runat="server" /></td>
                                <td>&nbsp;&nbsp;</td>
                                <td></td>
                            </tr>
                            <tr>
                                <%--<td>Cuenta contable: </td>
                                <td>&nbsp;&nbsp;</td>
                                <td><asp:TextBox ID="Sql_CuentasContables_Cuenta_String" runat="server" /></td>
                                <td>&nbsp;&nbsp;</td>
                                <td>(nota: puede usar * para generalizar; ej: 30101*)</td>--%>
                            </tr>
                        </table>

                        <br />

                        <fieldset>
                            <legend>Opciones: </legend>

                            <asp:CheckBox ID="ExcluirAsientosDeTipoCierreAnual_CheckBox" 
                                          runat="server" 
                                          Text="Excluir asientos de tipo Cierre Anual"
                                          Checked="False" />
                            <br />
                            <asp:CheckBox ID="SoloAsientosTipoCierreAnual_CheckBox" 
                                          runat="server" 
                                          Text="Solo asientos de tipo cierre anual"
                                          Checked="False" />

                            <br />
                            <asp:CheckBox ID="SoloAsientosDescuadrados_CheckBox" 
                                          runat="server" 
                                          Text="Solo asientos descuadrados (no use si va a usar la función <em>Copiar asientos</em>)"
                                          Checked="False" />

                            <br />
                            <asp:CheckBox ID="SoloAsientosConMas2Decimales_CheckBox" 
                                          runat="server" 
                                          Text="Solo asientos con montos con más de dos decimales"
                                          Checked="False" />
                            <br />
                            <asp:CheckBox ID="SoloAsientosConUploads_CheckBox" 
                                          runat="server" 
                                          Text="Solo asientos con anexos (uploads) registrados"
                                          Checked="False" />
            
                        </fieldset>

                        <br />

                        <fieldset>
                            <legend>Reconversión 2021: </legend>

                            <table>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="ReconvertirCifrasAntes_01Oct2021_CheckBox" 
                                                      runat="server" 
                                                      Text="Reconvertir cifras anteriores al 1/Oct/21" 
                                                      Checked="False" />
                                    </td>
                                </tr>
                            </table>
            
                        </fieldset>

                    </div>
                </ContentTemplate>
            </asp:TabPanel>
            <asp:TabPanel HeaderText="Compañías, monedas, tipos" runat="server" ID="TabPanel2">
                <ContentTemplate>
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
                                Tipos de asiento
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_Asientos_Cia_Numeric" 
                                             runat="server" 
                                             DataTextField="Nombre" 
                                             DataValueField="Numero" 
                                             Height="193px" 
                                             SelectionMode="Multiple"
                                             Width="300px" 
                                             CssClass="notsosmallfont ciaListBox" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:ListBox ID="Sql_Asientos_Moneda_Numeric" 
                                             runat="server" 
                                             DataSourceID="Monedas_SqlDataSource"
                                             DataTextField="Descripcion" 
                                             DataValueField="Moneda" Height="193px" 
                                             SelectionMode="Multiple"
                                             Width="200px" 
                                             CssClass="notsosmallfont" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                               <asp:ListBox ID="Sql_Asientos_Tipo_String" 
                                            runat="server" 
                                            DataSourceID="TiposAsiento_SqlDataSource"
                                            DataTextField="Descripcion" 
                                            DataValueField="Tipo" 
                                            Height="193px" 
                                            SelectionMode="Multiple"
                                            Width="250px" 
                                            CssClass="notsosmallfont" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:TabPanel>

            <asp:TabPanel HeaderText="Cuentas contables" runat="server" ID="TabPanel4">
                <ContentTemplate>
                    <table style="min-width: 700px; ">
                        <tr>
                            <td class="ListViewHeader_Suave generalfont" style="width: 49%; ">
                                Cuentas contables 
                            </td>
                            <td style="width: 2%; ">
                            </td>
                            <td class="ListViewHeader_Suave generalfont" style="width: 49%; ">
                                Cuentas contables 
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; vertical-align: top; " class="generalfont">
                                <asp:TextBox ID="Sql_CuentasContables_Cuenta_String" 
                                             runat="server" 
                                             width="98%"
                                             Rows="2" 
                                             TextMode="MultiLine" 
                                             CssClass="cuentas-contables-text-area"
                                             placeholder="(Separe varias cuentas así: 5010202, 5010203, 5010204; además use * para generalizar: 203*; también: 206*, 4021300, 301*)">
                                </asp:TextBox>
                            </td>
                            <td>
                            </td>
                            <td>
                                Typee para iniciar una búsqueda de cuentas contables<br /> 
                                <select id="select1"
                                    name="select1"
                                    runat="server"
                                    multiple="true"
                                    class="select2-input"
                                    style="width: 99%; ">
                                </select>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:TabPanel>

            <asp:TabPanel HeaderText="'proviene de' y usuarios" runat="server" ID="TabPanel3">
                <ContentTemplate>
                <table>
                        <tr>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td class="ListViewHeader_Suave generalfont">
                                Proviene de
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td class="ListViewHeader_Suave generalfont">
                                Usuarios
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                                 <asp:ListBox ID="Sql_Asientos_ProvieneDe_String" 
                                              runat="server" 
                                              DataSourceID="ProvieneDe_SqlDataSource"
                                              DataTextField="ProvieneDe" 
                                              DataValueField="ProvieneDe" 
                                              Height="193px" 
                                              SelectionMode="Multiple"
                                              Width="200px" 
                                              CssClass="notsosmallfont" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:ListBox ID="Sql_Asientos_Usuario_String" 
                                              runat="server" 
                                              DataSourceID="Usuarios_SqlDataSource"
                                              DataTextField="Usuario" 
                                              DataValueField="Usuario" 
                                              Height="193px" 
                                              SelectionMode="Multiple"
                                              Width="200px" 
                                              CssClass="notsosmallfont" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:TabPanel>
        </asp:TabContainer>
        <br />
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

        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Descripcion, Moneda FROM Monedas ORDER BY Descripcion">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="TiposAsiento_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="SELECT Tipo, Descripcion + ' - ' + Tipo As Descripcion FROM TiposDeAsiento ORDER BY Descripcion">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="ProvieneDe_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="Select Distinct ProvieneDe From Asientos Where ProvieneDe &lt;&gt; '' And ProvieneDe Is Not Null Order By ProvieneDe">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="Usuarios_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="Select Distinct Usuario From Asientos Order By Usuario">
        </asp:SqlDataSource>

        <div>
            <script type="text/javascript" src="<%= this.Page.ResolveUrl("~/Scripts/select2-4.0.8/select2.min.js") %>"></script>
        </div>
        
    </div>
</asp:Content>
