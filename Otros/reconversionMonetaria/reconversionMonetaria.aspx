
<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_1.master" CodeBehind="reconversionMonetaria.aspx.cs" Inherits="ContabSysNet_Web.Otros.reconversionMonetaria.reconversionMonetaria" %>
<%@ MasterType  virtualPath="~/MasterPage_1.master"%>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">

    <script type="text/javascript" src="<%= this.Page.ResolveUrl("~/Scripts/jquery/jquery-1.10.2.js") %>"></script>
    <script type="text/javascript">
        function PopupWin(url, w, h) {
            ///Parameters url=page to open, w=width, h=height
            var left = parseInt((screen.availWidth / 2) - (w / 2));
            var top = parseInt((screen.availHeight / 2) - (h / 2));
            window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,left=" + left + ",top=" + top + "screenX=" + left + ",screenY=" + top);
        }

        function RefreshPage() {
            // nótese como usamos jquery para asignar el valor al field ... 
            $("#RebindFlagHiddenField").val("1");
            $("form").submit();
        }
    </script>

    <%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
    <span id="RebindFlagSpan">
        <%-- clientIdMode 'static' para que el id permanezca hasta el cliente (browser) --%>
        <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" ClientIDMode="Static" />
    </span>

    <div style="text-align: center; ">
        <asp:UpdatePanel ID="UpdatePanelValidationSummaryHome" ChildrenAsTriggers="false" UpdateMode="Conditional" runat="server">
            <ContentTemplate>
                <div ID="errorMessageDiv" runat="server" style="width: 80%; text-align: left; " class="errmessage_background generalfont errmessage" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <div class="row">
        <div class="col-md-5 col-offset-1" style="text-align: left;">
            <span style="text-align: left; font-size: large; color: #004080; font-style: italic; padding-left: 200px;">
                contab - Reconversión monetaria

            </span>
        </div>
        <div class="col-md-5 col-offset-1" style="text-align: right;">
            <asp:Label ID="companiaSeleccionada_label" runat="server"
                Text="" Style="text-align: right; font-size: small; color: #004080; font-style: italic;"></asp:Label>
        </div>
    </div>

    <table style="width: 100%" class="miniminheight">
    
        <tr>
            <%--   column en la izquierda con links   --%>
            <td style="border: 1px solid #C0C0C0; width: 10%; vertical-align: top; background-color: #F7F7F7; text-align: center; ">
                <br />
                <i class="fa fa-filter"></i>
                <a href="javascript:PopupWin('reconversionMonetaria_filter.aspx', 1000, 600)">Definir y aplicar un filtro</a>
                <hr />
            </td>

            <td style="vertical-align: top; ">
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
                
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" /> 
                        <span id="InfoMessage_Span" runat="server" class="infomessage infomessage_background generalfont" style="display: block;" /> 
                    </ContentTemplate>
                </asp:UpdatePanel>

                <br /> 

                <div class="row"> 
                    <div class="col-sm-5 col-sm-offset-1"> 

                        <p runat="server" id="texto1" style="margin-left: 100px; "> 
                            Parámetros para ejecutar la reconversión: <br /><br />
                            <ul style="margin-left:150px; "">
                                <li>Año (<em>fiscal</em>): <span runat="server" id="ano_span" style="font-weight: bold; "></span></li>
                                <li>Moneda: <span runat="server" id="monedaNacional_span" style="font-weight: bold; "></span></li>
                                <li>Cantidad de dígitos: <span runat="server" id="cantidadDigitos_span" style="font-weight: bold; "></span></li>
                                <li>Divisor para la reconversión: <span runat="server" id="divisor_span" style="font-weight: bold; "></span></li>
                                <li>Cuenta contable para ajustar asientos: <span runat="server" id="cuentaContable_span" style="font-weight: bold; "></span></li>
                            </ul>
                        </p>

                        <div style="text-align: center; margin-top: 25px; ">
                            <asp:Button runat="server" ID="ejecutarReconversion_button" class="btn btn-primary btn-md" Text="Iniciar reconversión" visible="false" OnClick="ejecutarReconversion_button_Click" />
                            <br /><br />
                        </div>

                    </div>
            
                    <div class="col-sm-5 col-sm-offset-1"> 
                        <fieldset style="text-align: left; margin-left: 15px; width: 400px; " class="scheduler-border">
                            <legend class="scheduler-border">Proceso a ejecutar: </legend>
                            <asp:RadioButton ID="proceso_contabilidad_RadioButton"
                                runat="server"
                                GroupName="ejecutarProceso_radioButtonGroupName" />
                            &nbsp;&nbsp;Contabilidad - Reconvertir asientos contables

                            <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    
                            <asp:RadioButton ID="proceso_contabilidad_saldosIniciales_RadioButton"
                                runat="server"
                                GroupName="ejecutarProceso_radioButtonGroupName" />
                            &nbsp;&nbsp;Contabilidad - Ajustar saldos iniciales del año

                            <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    
                            <asp:RadioButton ID="proceso_contabilidad_saldosIniciales_cuadrar_RadioButton"
                                runat="server"
                                GroupName="ejecutarProceso_radioButtonGroupName" />
                            &nbsp;&nbsp;Contabilidad - Cuadrar saldos iniciales del año

                            <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    
                            <asp:RadioButton ID="proceso_contabilidad_asientos_RadioButton"
                                runat="server"
                                GroupName="ejecutarProceso_radioButtonGroupName" />
                            &nbsp;&nbsp;Contabilidad - Ajustar (para 'cuadrar') asientos contables
                            <br />     
                            <asp:RadioButton ID="proceso_bancos_RadioButton"
                                runat="server"
                                GroupName="ejecutarProceso_radioButtonGroupName"  />
                            &nbsp;&nbsp;Bancos
                            <br />     
                            <%--<asp:RadioButton ID="proceso_cajaChica_RadioButton"
                                runat="server"
                                GroupName="ejecutarProceso_radioButtonGroupName" />
                            &nbsp;&nbsp;Caja chica
                            <br />      --%>       
                            <%--<asp:RadioButton ID="proceso_nomina_RadioButton"
                                runat="server"
                                GroupName="ejecutarProceso_radioButtonGroupName" />
                            &nbsp;&nbsp;Nómina
                            <br />   --%>  
                            <asp:RadioButton ID="proceso_activosFijos_RadioButton"
                                runat="server"
                                GroupName="ejecutarProceso_radioButtonGroupName" />
                            &nbsp;&nbsp;Activos fijos
                        </fieldset>
                    </div>
                </div>
                
                <br /> 
            </td>
        </tr>
    </table>

    <div>

      
        
    </div>
</asp:Content>

<%--  footer place holder --%>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>
