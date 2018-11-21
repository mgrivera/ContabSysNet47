<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Comprobantes.OpcionesReportes" Codebehind="OpcionesReportes.aspx.cs" %>
<%@ Register TagPrefix="My" TagName="ReportOptions" Src="~/UserControls/ReportOptions.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>

        
        <script src="<%= this.Page.ResolveUrl("~/Scripts/jquery/jquery-1.10.2.js") %>"></script>

        <script type="text/javascript">
            // desabilitamos el salto de página por 'fecha' cuando el ordenamiendo es por 'comprobante' ... 

            // para asegurarnos que el dom está cargado en el browser ... 
            $().ready(function () {
                // si el usuario cambia el ordenamiento, ponemos salto de página en ninguno 
                $('#orderByFecha_RadioButton').click(function () {
                    $('#SaltoPaginaNinguno_RadioButton').prop('checked', true);
                    // el usuario ordena por fecha; puede 'saltar' por fecha ...
                    $('#SaltoPaginaFecha_RadioButton').attr("disabled", false);
                });
                $('#orderByNumero_RadioButton').click(function () {
                    $('#SaltoPaginaNinguno_RadioButton').prop('checked', true);
                    // el usuario ordena por comprobante; no puede 'saltar' por fecha ...
                    $('#SaltoPaginaFecha_RadioButton').attr("disabled", true);
                });

                // cuando abrimos la página, desabilitamos 'saltar por fecha' si esta seleccionado 'ordenar por comprobante' ... 
                if ($('#orderByNumero_RadioButton').is(':checked')) {
                    if ($('#SaltoPaginaFecha_RadioButton').is(':checked')) {
                        $('#SaltoPaginaNinguno_RadioButton').prop('checked', false);
                    }; 
                    $('#SaltoPaginaFecha_RadioButton').attr("disabled", true);
                }; 
            }); 
            
        </script>

        <div style="margin: 0 25px 0 25px;">
            <span id="GeneralMessage_Span" runat="server" class="infomessage infomessage_background generalfont" style="display: block;" />
            <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />
        </div>
            
        <div style="margin: 5px;" class="generalfont">

            <table>
                <tr>
                    <td>
                        <My:ReportOptions runat="server" ID="reportOptionsUserControl" Modifiers="public"/>
                    </td>
                    <td style="text-align: left; vertical-align: top; ">
                        <fieldset style="margin: 0px 25px 25px 25px; padding: 15px; " class="generalfont">
                            <legend>Otras opciones del reporte: </legend>
                            <table>
                                <tr>
                                    <td colspan="3">
                                        <span style="text-decoration: underline; margin-left: 6px; ">Ordenar por: </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="orderByFecha_RadioButton" runat="server" GroupName="sortBy" Text="Fecha" ClientIDMode="Static" />
                                    </td>
                                    <td>
                                        <asp:RadioButton ID="orderByNumero_RadioButton" runat="server" GroupName="sortBy" Text="#Comprobante" ClientIDMode="Static" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br />
                                        <span style="text-decoration: underline; margin-left: 6px; ">Debe/Haber (solo vertical): </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="unaColumna_RadioButton" runat="server" GroupName="cantidadColumnas" Text="1 columna" />
                                    </td>
                                    <td>
                                        <asp:RadioButton ID="dosColumna_RadioButton" runat="server" GroupName="cantidadColumnas" Text="2 columnas" />
                                    </td>
                                    <td>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br />
                                        <asp:CheckBox ID="Fecha_CheckBox" runat="server" Checked="true" Text="" style="margin-left: 4px; "/>
                                        <span style="text-decoration: underline;">&nbsp;Fecha: </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="fechaHoy_RadioButton" runat="server" GroupName="fechaReporte" Text="Hoy" />
                                    </td>
                                    <td>
                                        <asp:RadioButton ID="fechaPropia_RadioButton" runat="server" GroupName="fechaReporte" Text="Propia" />
                                    </td>
                                    <td> 
                                        <asp:TextBox runat="server" ID="FechaPropia_TextBox" Width="120px" Height="16px" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br />
                                        <span style="text-decoration: underline; margin-left: 6px; ">Salto de página: </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="SaltoPaginaAsiento_RadioButton" runat="server" GroupName="saltoPagina" Text="Asiento" ClientIDMode="Static" />
                                    </td>
                                    <td>
                                        <asp:RadioButton ID="SaltoPaginaFecha_RadioButton" runat="server" GroupName="saltoPagina" Text="Fecha" ClientIDMode="Static" />
                                    </td>
                                    <td>
                                        <asp:RadioButton ID="SaltoPaginaNinguno_RadioButton" runat="server" GroupName="saltoPagina" Text="Ninguno" ClientIDMode="Static" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:Button runat="server" 
                                    style="margin: 0px 25px; float:right; "
                                    ID="Ok_Button" 
                                    onclick="Ok_Button_Click" 
                                    Text="Obtener reporte" /> 
                    </td>
                </tr>
            </table>

        </div>

    </ContentTemplate>
</asp:UpdatePanel>
    
</asp:Content>
