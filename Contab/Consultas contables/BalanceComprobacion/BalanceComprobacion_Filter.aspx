<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="BalanceComprobacion_Filter.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.BalanceComprobacion.BalanceComprobacion_Filter" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

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
                    url: "/webServices/Select2_GetData.asmx/AccessRemoteData",        // Webservice  - WCSelect2 and WebMethod -AccessRemoteData
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

        <cc1:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" style="text-align: left; ">
            <cc1:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1">
                <ContentTemplate>
                    <div style="text-align: left;" class="generalfont">
                        &nbsp;&nbsp;Período: &nbsp;&nbsp;
                        <asp:TextBox ID="Desde_TextBox" runat="server" Width="105px"></asp:TextBox>
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
                        &nbsp;&nbsp;/&nbsp;&nbsp;
                        <asp:TextBox ID="Hasta_TextBox" runat="server" Width="105px"></asp:TextBox>
                        <cc1:CalendarExtender ID="Hasta_TextBox_CalendarExtender" runat="server" Enabled="True"
                            Format="dd-MM-yy" PopupButtonID="HastaCalendar_PopUpButton" CssClass="radcalendar"
                            TargetControlID="Hasta_TextBox">
                        </cc1:CalendarExtender>
                        <asp:ImageButton ID="HastaCalendar_PopUpButton" runat="server" alt="" src="../../../Pictures/Calendar.png"
                            CausesValidation="False" TabIndex="-1" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Hasta_TextBox"
                            CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="Ud. debe indicar una fecha">*</asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="Hasta_TextBox"
                            CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                            Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator>
                        <asp:CompareValidator ID="CompareValidator3" runat="server" ControlToValidate="Hasta_TextBox"
                            CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El intervalo indicado no es válido."
                            Operator="GreaterThanEqual" Type="Date" ControlToCompare="Desde_TextBox">*</asp:CompareValidator>
                            
                            
                    </div>
                    <br /><br />
                    <fieldset style="text-align:left; " class="generalfont">
                        <legend style="color: Navy; ">Cuentas contables sin movimientos en el período indicado:</legend>
                        <asp:CheckBox ID="MostrarCuentasSinSaldoYSinMvtos_CheckBox" 
                                      cssclass="generalfont"
                                      runat="server" 
                                      Text="Mostrar cuentas con saldo inicial del período igual a cero" />
                        <br />
                        <asp:CheckBox ID="MostrarCuentasConSaldoYSinMvtos_CheckBox" 
                                      cssclass="generalfont"
                                      runat="server" 
                                      Text="Mostrar cuentas con saldo inicial del período diferente a cero"
                                      Checked="True" />
                    </fieldset>
                    <br />
                    <br />
                    <div style="border: 1px solid #C0C0C0; text-align:left; padding:10px; " class="generalfont">

                        <asp:CheckBox ID="MostrarCuentasConSaldosEnCero_CheckBox" 
                                      cssclass="generalfont"
                                      runat="server" 
                                      Checked="False" 
                                      Text="Mostrar cuentas con saldos, inicial y final, en cero " />
                        <br />
                        <asp:CheckBox ID="MostrarCuentasConSaldoFinalEnCero_CheckBox" 
                                      cssclass="generalfont"
                                      runat="server" 
                                      Checked="True" 
                                      Text="Mostrar cuentas con saldo final en cero " />
                        <br />
                        <asp:CheckBox ID="ExcluirAsientosTipoCierreAnual_CheckBox" 
                                      cssclass="generalfont"
                                      runat="server" 
                                      Checked="True" 
                                      Text="Excluir asientos de tipo 'cierre anual' " />
                    </div>
                            
                </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel HeaderText="Compañías, monedas" runat="server" ID="TabPanel2">
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
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_CuentasContables_Cia_Numeric" 
                                runat="server" DataTextField="NombreCorto" 
                                               DataValueField="Numero" 
                                               Height="193px" 
                                               SelectionMode="Single"
                                               Width="200px" 
                                               CssClass="notsosmallfont ciaListBox" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:ListBox ID="Sql_SaldosContables_Moneda_Numeric" runat="server" DataSourceID="Monedas_SqlDataSource"
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
            <cc1:TabPanel HeaderText="Cuentas contables" runat="server" ID="TabPanel3">
                <ContentTemplate>
                    <table style="min-width: 700px; ">
                        <tr>
                            <td class="ListViewHeader_Suave generalfont" style="width: 49%; ">Cuentas contables
                            </td>
                            <td style="width: 2%; "></td>
                            <td class="ListViewHeader_Suave generalfont" style="width: 49%; ">Cuentas contables
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; vertical-align: top; " class="generalfont">
                                <asp:TextBox ID="Sql_CuentasContables2_Cuenta_String"
                                            runat="server"
                                            Rows="2"
                                            width="98%"
                                            TextMode="MultiLine"
                                            CssClass="cuentas-contables-text-area"
                                            placeholder="(Separe varias cuentas así: 5010202, 5010203, 5010204; además use * para generalizar: 203*; también: 206*, 4021300, 301*)">
                                </asp:TextBox>
                            </td>
                            <td></td>
                            <td style="vertical-align: top; text-align: left; " class="generalfont">
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
            </cc1:TabPanel>
        </cc1:TabContainer>
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
                        ClientIDMode="Static"
                        onclick="AplicarFiltro_Button_Click" />
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>

        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Descripcion, Moneda FROM Monedas ORDER BY Descripcion">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="TiposAsiento_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="SELECT Tipo, Descripcion FROM TiposDeAsiento ORDER BY Tipo">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="ProvieneDe_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="Select Distinct ProvieneDe From Asientos Where ProvieneDe &lt;&gt; '' And ProvieneDe Is Not Null Order By ProvieneDe">
        </asp:SqlDataSource>

        <div>
            <script type="text/javascript" src="<%= this.Page.ResolveUrl("~/Scripts/select2-4.0.8/select2.min.js") %>"></script>
        </div>
    </div>
</asp:Content>
