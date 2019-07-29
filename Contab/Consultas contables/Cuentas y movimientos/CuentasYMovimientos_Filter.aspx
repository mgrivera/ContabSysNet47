<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="CuentasYMovimientos_Filter.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Cuentas_y_movimientos.CuentasYMovimientos_Filter" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

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

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="notsosmallfont" style="padding-left: 25px; padding-right: 25px; padding-bottom: 3px; ">

    <cc1:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
        TargetControlID="UpdatePanel1" Enabled="True">
        <Animations>
            <OnUpdating>
                <Parallel duration=".5">
                    <FadeOut minimumOpacity=".5" />
                </Parallel>
            </OnUpdating>
            <OnUpdated>
                <Parallel duration=".5">
                    <FadeIn minimumOpacity=".5" />
                </Parallel>
            </OnUpdated>
        </Animations>
    </cc1:UpdatePanelAnimationExtender>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <asp:ValidationSummary ID="ValidationSummary1" runat="server" class=" errmessage_background generalfont errmessage" ForeColor=""/>

            <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

            <table>
                <tr>
                    <td class="ListViewHeader_Suave smallfont2">
                        Compañías (Contab) 
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td class="ListViewHeader_Suave smallfont2">
                        Mon
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td class="ListViewHeader_Suave smallfont2">
                        Mon orig.
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td class="ListViewHeader_Suave smallfont2">
                        Centros de costo
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td class="ListViewHeader_Suave smallfont2">
                        Grupos contables
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td class="ListViewHeader_Suave smallfont2">
                        Cuentas contables
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:ListBox ID="Sql_Asientos_Cia_Numeric" 
                                     runat="server" 
                                     DataTextField="Abreviatura" 
                                     DataValueField="Numero" 
                                     Height="193px" 
                                     SelectionMode="Multiple"
                                     Width="100px" 
                                     CssClass="smallfont, ciaListBox" />
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td>
                        <asp:ListBox ID="Sql_Asientos_Moneda_Numeric" 
                                     runat="server" 
                                     DataSourceID="Monedas_SqlDataSource"
                                     DataTextField="Simbolo" 
                                     DataValueField="Moneda" 
                                     Height="193px" 
                                     SelectionMode="Multiple"
                                     Width="70px" 
                                     CssClass="smallfont" />
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td>
                        <asp:ListBox ID="Sql_Asientos_MonedaOriginal_Numeric" 
                                     runat="server" 
                                     DataSourceID="Monedas_SqlDataSource"
                                     DataTextField="Simbolo" 
                                     DataValueField="Moneda" 
                                     Height="193px" 
                                     SelectionMode="Multiple"
                                     Width="70px" 
                                     CssClass="smallfont" />
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td>
                        <asp:ListBox ID="Sql_dAsientos_CentroCosto_Numeric" 
                                     runat="server" 
                                     DataSourceID="CentrosCosto_SqlDataSource"
                                     DataTextField="DescripcionCorta" 
                                     DataValueField="CentroCosto" 
                                     Height="193px"
                                     SelectionMode="Multiple" 
                                     Width="150px" 
                                     CssClass="smallfont" />
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td>
                        <asp:ListBox ID="Sql_CuentasContables_Grupo_Numeric" 
                                     runat="server" 
                                     DataSourceID="GruposContables_SqlDataSource"
                                     DataTextField="Descripcion" 
                                     DataValueField="Grupo" 
                                     Height="193px"
                                     SelectionMode="Multiple" 
                                     Width="150px" 
                                     CssClass="smallfont" />
                    </td>
                    <td>&nbsp;&nbsp;</td>
                    <td style="vertical-align: top; text-align: left; ">
                        <label for="select1">
                          Typee para iniciar una búsqueda de cuentas contables 
                          <select id="select1" 
                                  name="select1" 
                                  runat="server" 
                                  multiple="true" 
                                  class="select2-input" 
                                  style="width: 85%; ">
                          </select>
                        </label>
                    </td>
                </tr>
            </table>

            <table style="margin-top: 10px; ">
                <tr>
                    <td colspan="2" style="background-color: #E5E5E5; border: 1px solid #C0C0C0">Cuentas contables
                    </td>
                
                    <td>
                    </td>
               
                    <td colspan="2" style="background-color: #E5E5E5; border: 1px solid #C0C0C0">Movimiento contable (Asientos)
                    </td>
                </tr>
                <tr>
                    <td>Número: 
                    </td>
                    <td style="padding-right: 10px; ">
                        <asp:TextBox ID="Sql_CuentasContables2_Cuenta_String" 
                                     runat="server" 
                                     Width="500px" 
                                     Rows="2" 
                                     TextMode="MultiLine" 
                                     CssClass="cuentas-contables-text-area"
                                     placeholder="(Separe varias cuentas así: 5010202, 5010203, 5010204; además use * para generalizar: 203*; también: 206*, 4021300, 301*)">
                        </asp:TextBox>
                    </td>
                    <td>
                    </td>
                    <td>Número: 
                    </td>
                    <td style="padding-right:10px; "><asp:TextBox ID="Sql_Asientos_Numero_Numeric" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>Nombre: 
                    </td>
                    <td style="padding-right:10px; "><asp:TextBox ID="Sql_CuentasContables_Descripcion_String" Width="500px" runat="server"></asp:TextBox>
                    </td>
                    <td>
                    </td>
                    <td>Descripcion: 
                    </td>
                    <td style="padding-right:10px; "><asp:TextBox ID="Sql_dAsientos_Descripcion_String" runat="server"></asp:TextBox>
                    </tdSql_dAsientos_Descripcion_String
                </tr>
                <tr>
                    <td style="padding-right:10px; ">
                        Código condi: 
                    </td>
                    <td style="padding-right:10px; ">
                        <asp:TextBox ID="codigoCondi" 
                                     Width="500px" 
                                     runat="server" 
                                     TextMode="MultiLine" 
                                     Rows="2" 
                                     placeholder="(Separe varios códigos así: 5010202, 5010203, 5010204)">
                        </asp:TextBox>
                    </td>
                    <td />
                    <td>Referencia: 
                    </td>
                    <td style="padding-right:10px; "><asp:TextBox ID="Sql_dAsientos_Referencia_String" runat="server"></asp:TextBox>
                    </td>
                </tr>
            </table>

        </ContentTemplate>
    </asp:UpdatePanel>

        <br />
        <div style="text-align: left;" class="generalfont">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Período: &nbsp;&nbsp;
           <asp:TextBox ID="Desde_TextBox" runat="server" Width="105px"></asp:TextBox>
                            <cc1:CalendarExtender ID="Desde_TextBox_CalendarExtender" runat="server" Enabled="True"
                                Format="dd-MM-yy" PopupButtonID="DesdeCalendar_PopUpButton" CssClass="radcalendar"
                                TargetControlID="Desde_TextBox">
                            </cc1:CalendarExtender>
                            <asp:ImageButton ID="DesdeCalendar_PopUpButton" runat="server" 
                alt="" src="../../../Pictures/Calendar.png"
                                CausesValidation="False" TabIndex="-1" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" 
                runat="server" ControlToValidate="Desde_TextBox"
                                CssClass="errmessage generalfont" Display="Dynamic" 
                ErrorMessage="Ud. debe indicar una fecha" ForeColor="Red">*</asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="Desde_TextBox"
                                CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                                Operator="DataTypeCheck" Type="Date">Red</asp:CompareValidator>
            &nbsp;/&nbsp;&nbsp;
             <asp:TextBox ID="Hasta_TextBox" runat="server" Width="105px"></asp:TextBox>
                            <cc1:CalendarExtender ID="Hasta_TextBox_CalendarExtender" runat="server" Enabled="True"
                                Format="dd-MM-yy" PopupButtonID="HastaCalendar_PopUpButton" CssClass="radcalendar"
                                TargetControlID="Hasta_TextBox">
                            </cc1:CalendarExtender>
                            <asp:ImageButton ID="HastaCalendar_PopUpButton" runat="server" 
                alt="" src="../../../Pictures/Calendar.png"
                                CausesValidation="False" TabIndex="-1" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" 
                runat="server" ControlToValidate="Hasta_TextBox"
                                CssClass="errmessage generalfont" Display="Dynamic" 
                ErrorMessage="Ud. debe indicar una fecha" ForeColor="Red">*</asp:RequiredFieldValidator>
                            <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="Hasta_TextBox"
                                CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                                Operator="DataTypeCheck" Type="Date" ForeColor="Red">*</asp:CompareValidator>
                            <asp:CompareValidator ID="CompareValidator3" runat="server" ControlToValidate="Hasta_TextBox"
                                CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El intervalo indicado no es válido."
                                Operator="GreaterThanEqual" Type="Date" 
                ControlToCompare="Desde_TextBox" ForeColor="Red">*</asp:CompareValidator>

             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            <asp:CheckBox ID="NoMostrarSaldoInicialPeriodo_CheckBox" 
                          runat="server" 
                          Text="Para cada cuenta contable seleccionada, no mostrar el saldo inicial del período"
                          Checked="False" />
        </div>

         <br />
         
        <div style="text-align: left;">
            <fieldset style="text-align: left; margin-left: 15px; ">
                <legend>Excluir cuentas contables:</legend>

                <table>
                    <tr >
                        <td style="width:50%; ">
                            <asp:CheckBox ID="ExcluirCuentasSinMovimientos_CheckBox" 
                                          runat="server" 
                                          Text="Sin movimientos en el período de selección"
                                          Checked="False" />
                        </td>
                        <td style="width:50%; ">
                            <asp:CheckBox ID="ExcluirCuentasConSaldosInicialFinalCero_CheckBox" 
                                          runat="server" 
                                          Text="Con saldos (inicial y final) en cero"
                                          Checked="False" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width:50%; ">
                            <asp:CheckBox ID="ExcluirCuentasSinSaldoYSinMovtos_CheckBox" 
                                          runat="server" 
                                          Text="Con saldo cero y sin movimientos"
                                          Checked="False" />
                        </td>
                        <td style="width:50%; ">
                            <asp:CheckBox ID="ExcluirCuentasConSaldoFinalCero_CheckBox" 
                                          runat="server" 
                                          Text="Con saldo final en cero"
                                          Checked="False" />
                        </td>
                    </tr>
                     <tr>
                        <td style="width:50%; " colspan="2">
                            <asp:CheckBox ID="ExcluirMovimientosDeAsientosDeTipoCierreAnual_CheckBox" 
                                          runat="server" 
                                          Text="Excluir movimientos que correspondan a asientos de tipo Cierre Anual"
                                          Checked="False" />
                        </td>
                    </tr>
                </table>
            </fieldset>
            <br />
        </div>
         
        <div style="text-align: right; margin-top: 15px; ">
            
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
        
      <%--  
        <asp:SqlDataSource ID="Companias_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Abreviatura, Numero FROM Companias ORDER BY Abreviatura">
        </asp:SqlDataSource>--%>

        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Simbolo, Moneda FROM Monedas ORDER BY Simbolo">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="CentrosCosto_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT CentrosCosto.CentroCosto, CentrosCosto.DescripcionCorta FROM CentrosCosto INNER JOIN dAsientos ON CentrosCosto.CentroCosto = dAsientos.CentroCosto ORDER BY CentrosCosto.DescripcionCorta">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="GruposContables_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Descripcion, Grupo FROM tGruposContables Order By OrdenBalanceGeneral">
        </asp:SqlDataSource>

    </div>

    <div>
        <script type="text/javascript" src="<%= this.Page.ResolveUrl("~/Scripts/select2-4.0.8/select2.min.js") %>"></script>
    </div>
</asp:Content>