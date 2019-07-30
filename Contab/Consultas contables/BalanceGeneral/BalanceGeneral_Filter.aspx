<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="BalanceGeneral_Filter.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral.BalanceGeneral_Filter" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

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

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="notsosmallfont" style="padding-left: 25px; padding-right: 25px; padding-bottom: 3px; text-align: left; ">

        <asp:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
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
        </asp:UpdatePanelAnimationExtender>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <asp:ValidationSummary ID="ValidationSummary1" 
                                   runat="server" 
                                   class="errmessage_background generalfont errmessage"
                                   ShowModelStateErrors="true"
                                   ForeColor="" />

                <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

                <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" Display="None" EnableClientScript="False" />

                    <asp:tabcontainer id="TabContainer1" runat="server" activetabindex="0" TabStripPlacement="Top">

                        <asp:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1" >

                            <ContentTemplate>
                                <br />
                                <asp:CalendarExtender ID="CalendarExtender1" 
                                    runat="server" 
                                    TodaysDateFormat="dd-MM-yyyy" 
                                    TargetControlID="Desde_TextBox" 
                                    Format="dd-MM-yyyy" Enabled="True" />

                                <asp:CalendarExtender ID="CalendarExtender2" 
                                    runat="server" 
                                    TodaysDateFormat="dd-MM-yyyy" 
                                    TargetControlID="Hasta_TextBox" 
                                    Format="dd-MM-yyyy" Enabled="True" />

                                Desde: 
                                <asp:TextBox ID="Desde_TextBox" runat="server" />
                                &nbsp;&nbsp;&nbsp; 
                                Hasta: 
                                <asp:TextBox ID="Hasta_TextBox" runat="server" />

                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Por favor indique un périodo válido." ControlToValidate="Desde_TextBox" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor indique un périodo válido." ControlToValidate="Hasta_TextBox" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="Por favor indique un périodo válido." ControlToValidate="Desde_TextBox" Operator="DataTypeCheck" Type="Date" Display="Dynamic" ForeColor="Red">*</asp:CompareValidator>
                                <asp:CompareValidator ID="CompareValidator2" runat="server" ErrorMessage="Por favor indique un périodo válido." ControlToValidate="Hasta_TextBox" Operator="DataTypeCheck" Type="Date" Display="Dynamic" ForeColor="Red">*</asp:CompareValidator>
                                <asp:CompareValidator ID="CompareValidator3" runat="server" ErrorMessage="Por favor indique un périodo válido." ControlToValidate="Hasta_TextBox" Type="Date" ControlToCompare="Desde_TextBox" Operator="GreaterThanEqual" Display="Dynamic" ForeColor="Red">*</asp:CompareValidator>

                                <br /><br />

                                <fieldset style="border: 1px solid #C0C0C0; padding: 10px; ">
                                    <asp:RadioButton ID="BalanceGeneral_RadioButton" runat="server" GroupName="BalGen_GyP" Text="Balance General" />
                                    <br />
                                    <asp:RadioButton ID="GyP_RadioButton" runat="server" GroupName="BalGen_GyP" Text="Ganancias y Pérdidas" />
                                </fieldset>

                                <br />

                                <ul>
                                    <li  style="list-style: none;"> 
                                        <asp:CheckBox ID="ExcluirCuentasSinSaldoNiMovtos_CheckBox" 
                                                      runat="server" 
                                                      Text="Excluir cuentas contables con saldo inicial, debe y haber en cero <br />&nbsp;&nbsp;&nbsp;&nbsp(para el período indicado)" />
                                    </li>
                                    <li  style="list-style: none;"> 
                                        <asp:CheckBox ID="ExcluirCuentasConSaldoFinalCero_CheckBox" 
                                                      runat="server" 
                                                      Text="Excluir cuentas contables con saldo final en cero" />
                                    </li>
                                    <li  style="list-style: none;"> 
                                        <asp:CheckBox ID="ExcluirCuentasSinMovimientos_CheckBox" 
                                                      runat="server" 
                                                      Text="Excluir cuentas contables sin movimientos en el período indicado" />
                                    </li>
                                </ul>
                            </ContentTemplate>

                        </asp:TabPanel>

                        <asp:TabPanel HeaderText="Lista (1)" runat="server" ID="TabPanel2" >

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
                                        <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                                            Monedas (original)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:ListBox ID="Sql_it_Cia_Numeric" 
                                                            runat="server" 
                                                            DataTextField="Nombre" 
                                                            DataValueField="Numero" 
                                                            AutoPostBack="true" 
                                                            SelectionMode="Single" 
                                                            Rows="20" 
                                                            CssClass="smallfont ciaListBox" />
                                        </td>
                                        <td>
                                            &nbsp;&nbsp;
                                        </td>
                                        <td>
                                             <asp:ListBox ID="Monedas_ListBox" 
                                                             Width="200px"
                                                             runat="server" 
                                                             DataSourceID="Monedas_SqlDataSource"
                                                             DataTextField="Descripcion" 
                                                             DataValueField="Moneda" 
                                                             AutoPostBack="False" 
                                                             SelectionMode="Single" 
                                                             Rows="20" 
                                                             CssClass="smallfont" />
                                        </td>
                                        <td>
                                            &nbsp;&nbsp;
                                        </td>
                                        <td>
                                            <asp:ListBox ID="MonedasOriginales_ListBox" 
                                                             Width="200px"
                                                             runat="server" 
                                                             DataSourceID="Monedas_SqlDataSource"
                                                             DataTextField="Descripcion" 
                                                             DataValueField="Moneda" 
                                                             AutoPostBack="False" 
                                                             SelectionMode="Single" 
                                                             Rows="20" 
                                                             CssClass="smallfont" AppendDataBoundItems="True">
                                                <asp:ListItem Text="Todas" Value="0" />
                                            </asp:ListBox>
                                        </td>

                                    </tr>
                                </table>

                            </ContentTemplate>
                        </asp:TabPanel>

                        <asp:TabPanel HeaderText="Cuentas contables" runat="server" ID="TabPanel3">
                            <ContentTemplate>
                                <table style="min-width: 700px; ">
                                    <tr>
                                        <td class="ListViewHeader_Suave generalfont" style="width: 49%; ">
                                            Cuentas contables
                                        </td>
                                        <td style="width: 2%; "></td>
                                        <td class="ListViewHeader_Suave generalfont" style="width: 49%; ">
                                            Cuentas contables
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; vertical-align: top; " class="generalfont">
                                            <asp:TextBox ID="Sql_it_Cuenta_String"
                                                        runat="server"
                                                        Rows="2"
                                                        TextMode="MultiLine"
                                                        CssClass="cuentas-contables-text-area"
                                                        width="98%"
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
                        </asp:TabPanel>

                </asp:tabcontainer>

            </ContentTemplate>
        </asp:UpdatePanel>

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
       
        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Descripcion, Moneda FROM Monedas ORDER BY Simbolo">
        </asp:SqlDataSource>
    </div>

    <div>
        <script type="text/javascript" src="<%= this.Page.ResolveUrl("~/Scripts/select2-4.0.8/select2.min.js") %>"></script>
    </div>
</asp:Content>