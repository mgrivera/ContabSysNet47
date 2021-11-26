<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_Simple.master" CodeBehind="CentrosCosto_Filter.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Centros_de_costo.CentrosCosto_Filter" %>
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
                            Período: 
                        </td>

                        <td>
                            <asp:TextBox ID="Desde_TextBox" runat="server" TextMode="Date" Width="125px" />
           
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" 
                                                        runat="server" 
                                                        ControlToValidate="Desde_TextBox"
                                                        CssClass="errmessage generalfont" 
                                                        Display="Dynamic" 
                                                        ErrorMessage="Ud. debe indicar una fecha" 
                                                        ForeColor="Red">
                                *
                            </asp:RequiredFieldValidator>

                            <asp:CompareValidator ID="CompareValidator1" 
                                                  runat="server" 
                                                  ControlToValidate="Desde_TextBox"
                                                  CssClass="errmessage generalfont" 
                                                  Display="Dynamic" 
                                                  ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                                                  Operator="DataTypeCheck" 
                                                  Type="Date" 
                                                  ForeColor="Red">
                            </asp:CompareValidator>

                            &nbsp;/&nbsp;&nbsp;

                            <asp:TextBox ID="Hasta_TextBox" runat="server" TextMode="Date" Width="125px" />

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" 
                                                        runat="server" 
                                                        ControlToValidate="Hasta_TextBox"
                                                        CssClass="errmessage generalfont" 
                                                        Display="Dynamic" 
                                                        ErrorMessage="Ud. debe indicar una fecha" 
                                                        ForeColor="Red">
                                *
                            </asp:RequiredFieldValidator>

                            <asp:CompareValidator ID="CompareValidator2" runat="server" 
                                                  ControlToValidate="Hasta_TextBox"
                                                  CssClass="errmessage generalfont" 
                                                  Display="Dynamic" 
                                                  ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                                                  Operator="DataTypeCheck" 
                                                  Type="Date" 
                                                  ForeColor="Red">
                                *
                            </asp:CompareValidator>

                            <asp:CompareValidator ID="CompareValidator3" 
                                                  runat="server" 
                                                  ControlToValidate="Hasta_TextBox"
                                                  CssClass="errmessage generalfont" 
                                                  Display="Dynamic" 
                                                  ErrorMessage="El intervalo indicado no es válido."
                                                  Operator="GreaterThanEqual" 
                                                  Type="Date" 
                                                  ControlToCompare="Desde_TextBox" 
                                                  ForeColor="Red">
                                *
                            </asp:CompareValidator>
                        </td>
                       
                        <td />
                        <td />

                        <td>
                        </td>
                       
                        <td />
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
                        </td>
                       
                        <td />
                        <td />
                    </tr>
                </table>

                <table style="font-size: x-small; ">
                     <tr>
                        <td style="width: 48%; ">
                            <br /><br />
                            <fieldset style="text-align: left; margin-left: 15px; vertical-align: top; ">
                                <legend>Centro de costo:</legend>

                                <table>
                                    <tr>
                                        <td>
                                            <asp:RadioButton ID="ConCentroCosto_RadioButton" runat="server" GroupName="CentroCostoAsignado" Text="Con centro de costo asignado" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:RadioButton ID="SinCentroCosto_RadioButton" runat="server" GroupName="CentroCostoAsignado" Text="Sin centro de costo asignado" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:RadioButton ID="Todos_RadioButton" runat="server" GroupName="CentroCostoAsignado" Text="Todos" />
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                        <td />

                        <td style="width: 4%; " />
                        <td style="width: 48%; vertical-align: top; ">
                            <br /><br />
                            <fieldset style="text-align: left; margin-left: 15px; vertical-align: top; ">
                                <legend>Reconversión 2.021:</legend>
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
                        </td>
                    </tr>

                </table>
            </ContentTemplate>
        </cc1:TabPanel>

        <cc1:TabPanel HeaderText="Cias, Monedas" runat="server" ID="TabPanel2" >
            <ContentTemplate>
                <table style="width: auto; height: 100%;">
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
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="Sql_Asientos_Cia_Numeric" 
                                            Width="200px"
                                            runat="server" 
                                            DataTextField="Nombre" 
                                            DataValueField="Numero" 
                                            AutoPostBack="false" 
                                            SelectionMode="Multiple" 
                                            Rows="20" 
                                            CssClass="smallfont ciaListBox" />
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                             <asp:ListBox ID="Sql_Asientos_Moneda_Numeric" 
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
                    </tr>
                </table>

            </ContentTemplate>
        </cc1:TabPanel>

         <cc1:TabPanel HeaderText="Grupos, Centros de costo, Proviene de" runat="server" ID="TabPanel3" >
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
                                <asp:ListBox ID="Sql_CuentasContables_Grupo_Numeric" 
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
                               <asp:ListBox ID="Sql_dAsientos_CentroCosto_Numeric" 
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
                               <asp:ListBox ID="Sql_Asientos_ProvieneDe_String" 
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

            <cc1:TabPanel HeaderText="Cuentas contables" runat="server" ID="TabPanel5">
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
            </cc1:TabPanel>

            <cc1:TabPanel HeaderText="Usuarios" runat="server" ID="TabPanel4" >
                <ContentTemplate>
                    <table style="width: auto; height: 100%;">
                        <tr>
                            <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                                Usuarios
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_Asientos_Usuario_String" 
                                             Width="200px" 
                                             runat="server" 
                                             DataSourceID="Usuarios_SqlDataSource"
                                             DataTextField="Usuario" 
                                             DataValueField="Usuario" 
                                             AutoPostBack="False" 
                                             SelectionMode="Multiple" 
                                             Rows="20" CssClass="smallfont" />
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
        SelectCommand="SELECT CentroCosto, 
    Case (Suspendido) When 1 Then Descripcion + ' - ' + + DescripcionCorta + ' (Susp)' Else Descripcion + ' - ' + + DescripcionCorta End As NombreCentroCosto  
    FROM CentrosCosto 
    ORDER BY Descripcion">
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