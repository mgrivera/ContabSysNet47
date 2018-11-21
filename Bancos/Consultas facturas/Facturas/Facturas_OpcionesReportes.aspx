<%@ Page Title="Opciones de reportes" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Bancos_Facturas_Facturas_OpcionesReportes" Codebehind="Facturas_OpcionesReportes.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

            <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />
            <span id="GeneralMessage_Span" runat="server" class="infomessage infomessage_background generalfont" style="display: block;" />

            <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" 
                    onselectedindexchanged="DropDownList1_SelectedIndexChanged" style="margin: 10px; " >
                <asp:ListItem Selected="True" Value="0">Seleccione una consulta</asp:ListItem>
                <asp:ListItem Value="1">General</asp:ListItem>
                <asp:ListItem Value="2">Retenciones Iva</asp:ListItem>
                <asp:ListItem Value="3">Retenciones Islr</asp:ListItem>
                <asp:ListItem Value="4">Libro de compras</asp:ListItem>
                <asp:ListItem Value="5">Libro de ventas</asp:ListItem>
                <asp:ListItem Value="6">IVA: comprobantes de retención</asp:ListItem>
            </asp:DropDownList>


            <fieldset style="margin: 0px 10px 0px 10px; " runat="server" id="OpcionesLibroCompras_Fieldset">
                <legend style="color: Blue; ">Opciones de la consulta: </legend>
        
                    <table>
                        <tr>
                            <td style="text-align: right; ">Título: </td>
                            <td>&nbsp;&nbsp;&nbsp;</td>
                            <td style="text-align: left; "><asp:TextBox ID="Titulo_TextBox" runat="server" Width="400px"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="text-align: right; ">Sub título: </td>
                            <td>&nbsp;&nbsp;&nbsp;</td>
                            <td style="text-align: left; "><asp:TextBox ID="SubTitulo_TextBox" runat="server" Width="400px"></asp:TextBox></td>
                        </tr>
                        <tr style="text-align: right; ">
                            <td>Período: </td>
                            <td>&nbsp;&nbsp;&nbsp;</td>
                            <td style="text-align: left; "><asp:TextBox ID="Período_TextBox" runat="server" /> &nbsp; (ej: Enero / 2.011)</td>
                        </tr>
                        <tr style="text-align: right; ">
                            <td>Nombre cia contab: </td>
                            <td>&nbsp;&nbsp;&nbsp;</td>
                            <td style="text-align: left; "><asp:TextBox ID="CiaContabNombre_TextBox" runat="server" Width="400px"></asp:TextBox></td>
                        </tr>
                        <tr style="text-align: right; ">
                            <td>Rif cia contab: </td>
                            <td>&nbsp;&nbsp;&nbsp;</td>
                            <td style="text-align: left; "><asp:TextBox ID="CiaContabRif_TextBox" runat="server"></asp:TextBox></td>
                        </tr>
                    </table>

            </fieldset>

            <div runat="server" 
                 id="OpcionesConsultaGeneral_Div" 
                 style="width: 300px; ">

                <fieldset style="margin: 10px; padding: 20px 10px 10px 10px; " runat="server" id="Fieldset1">
                    <legend style="color: Blue; ">Reporte: </legend>

                    <asp:CheckBox ID="AgruparPorCompania_CheckBox" 
                                  runat="server" 
                                  Text="Agrupar facturas por compañía (proveedor o cliente)" />

                    <br /><br />

                    <asp:CheckBox ID="MostrarConcepto_CheckBox" 
                                  runat="server" 
                                  Text="Mostrar concepto de la factura" />

                </fieldset>

                <br /><br />

                <div class="notsosmallfont" style="text-align: left; margin: 0px 20px 0px 20px; ">
                    <b>Agrupar por compañía:</b> muestra las facturas agrupadas por cada compañía. Muestra el nombre completo de la
                    compañía. Si el usuario escoge 'no agrupar', solo se muestra la abreviatura de la compañía y el reporte es 
                    más compacto. 
                </div>
            </div>

            <fieldset style="margin: 0px 10px 0px 10px; " runat="server" id="OpcionesComprobantesRetencionIva_Fieldset">
                <legend style="color: Blue; ">Opciones de la consulta: </legend>
        
                <table>
                    <tr>
                        <td style="text-align: right; ">Fecha del comprobante: </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left; ">
                            <asp:TextBox ID="ComprobanteIva_CiudadParaFecha_TextBox" runat="server" Width="150" />
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td style="text-align: left; ">
                            <asp:TextBox ID="ComprobanteIva_FechaEscrita_TextBox" runat="server" Width="200" />
                        </td>
                    </tr>
                </table>

                <fieldset style="margin: 0px 10px 0px 10px; " runat="server" id="Fieldset2">
                    <legend style="color: Blue; ">Generación correo: </legend>


                    <table>
                        <tr>
                            <td style="text-align: right; ">
                                Firma del correo: 
                            </td>
                            <td>&nbsp;&nbsp;</td>
                            <td>

                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; ">
                                Linea #1: 
                            </td>
                            <td>&nbsp;&nbsp;</td>
                            <td>
                                <asp:TextBox ID="Email_Linea1_TextBox" runat="server" Width="200" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; ">
                                Linea #2: 
                            </td>
                            <td>&nbsp;&nbsp;</td>
                            <td>
                                <asp:TextBox ID="Email_Linea2_TextBox" runat="server" Width="200" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; ">
                                Linea #3: 
                            </td>
                            <td>&nbsp;&nbsp;</td>
                            <td>
                                <asp:TextBox ID="Email_Linea3_TextBox" runat="server" Width="200" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; ">
                                Linea #4: 
                            </td>
                            <td>&nbsp;&nbsp;</td>
                            <td>
                                <asp:TextBox ID="Email_Linea4_TextBox" runat="server" Width="200" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; ">
                                Linea #5: 
                            </td>
                            <td>&nbsp;&nbsp;</td>
                            <td>
                                <asp:TextBox ID="Email_Linea5_TextBox" runat="server" Width="200" />
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;&nbsp;</td>
                            <td>&nbsp;&nbsp;</td>
                            <td>&nbsp;&nbsp;</td>
                        </tr>
                        <tr>
                            <td>
                                Enviar correo a: 
                            </td>
                            <td>&nbsp;&nbsp;</td>
                            <td style="text-align: left; ">
                                <asp:CheckBox ID="Email_EnviarCorreoCompania_CheckBox" runat="server" />&nbsp;Compañía
                            </td>
                        </tr>
                        <tr>
                            <td>
                                
                            </td>
                            <td>&nbsp;&nbsp;</td>
                            <td style="text-align: left; ">
                                <asp:CheckBox ID="Email_EnviarCorreoUsuario_CheckBox" runat="server" />&nbsp;Usuario
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; ">
                                Formato: 
                            </td>
                            <td>&nbsp;&nbsp;</td>
                            <td style="text-align: left; ">
                                <asp:RadioButton ID="ComprobanteIva_FormatoPdf_RadioButton" runat="server" GroupName="ComprobanteIva_Formato" />&nbsp;pdf
                                <asp:RadioButton ID="ComprobanteIva_FormatoEmail_RadioButton" runat="server" GroupName="ComprobanteIva_Formato" />&nbsp;email
                                <asp:RadioButton ID="ComprobanteIva_FormatoNormal_RadioButton" runat="server" GroupName="ComprobanteIva_Formato" />&nbsp;normal
                            </td>
                               
                        </tr>
                    </table>

                </fieldset>

            </fieldset>

            <br />
            <div style="text-align: center; ">
                <asp:Button ID="Button1" 
                            runat="server" 
                            Text="Obtener consulta" 
                            onclick="Button1_Click" 
                            style="margin: 0px 0px  10px 0px; " />
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>

