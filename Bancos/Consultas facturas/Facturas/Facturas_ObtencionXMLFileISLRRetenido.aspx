<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Bancos_Consultas_facturas_Facturas_Facturas_ObtencionXMLFileISLRRetenido" Codebehind="Facturas_ObtencionXMLFileISLRRetenido.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <script type="text/javascript">
        function PopupWin(url, w, h) {
            ///Parameters url=page to open, w=width, h=height
            window.open(url, "external3", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
        }
    </script>

    <script runat="server">
        protected String GetApplicationName()
        {
            return HttpContext.Current.Request.ApplicationPath.ToString();
        }

        protected String GetRelacionMontosAPagar_UriAddress()
        {
            // este es la dirección que espera mvc; notamos que debemos agregar el nombre de la aplicación (ej: ContabSysNet46) cuando no estamos en 
            // ambiente de desarrollo; es decir, cuando ejecutamos desde iis ... 
            string pagePath = GetApplicationName() + "/Bancos/RelacionMontosAPagar/Index?cuentaBancaria=" + CuentasBancarias_DropDownList.SelectedValue.ToString(); 
            pagePath = pagePath.Replace("//", "/");

            return pagePath;
        }
    </script>

    <div style="margin: 0 25px 25px 25px;" class="generalfont">
    
        <asp:HiddenField ID="FileName_HiddenField" runat="server" />

        <h3>Exportar a archivos de texto</h3>
    
        <span id="GeneralMessage_Span" runat="server" class="infomessage infomessage_background generalfont"
           style="display: block;"></span>

        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;">
        </span>
        
        <br />

        <asp:DropDownList ID="DropDownList1" runat="server" 
                          AutoPostBack="True" 
                          onselectedindexchanged="DropDownList1_SelectedIndexChanged" 
                          style="margin: 0 20px 20px 20px; " >
                <asp:ListItem Selected="True" Value="0">Seleccione una consulta</asp:ListItem>
                <asp:ListItem Value="1">Retenciones impuesto Iva (txt)</asp:ListItem>
                <asp:ListItem Value="2">Retenciones impuesto Islr (xml)</asp:ListItem>
                <asp:ListItem Value="3">Relación de montos a pagar (txt)</asp:ListItem>
        </asp:DropDownList>

        <fieldset runat="server" 
                  id="OpcionesRetencionesIslr_Fieldset">

            <legend style="color: Navy; ">Seleccione una compañía e indique<br />el período de selección (aaaamm): </legend>
            <div style="padding: 15px; text-align: center; ">
            
                <asp:DropDownList ID="CiaContab_DropDownList" runat="server" 
                    DataSourceID="CiasContab_SqlDataSource" DataTextField="NombreCorto" 
                    DataValueField="CiaContab">
                </asp:DropDownList>
                
                <br /><br />
            
                <asp:TextBox ID="PeriodoSeleccion_TextBox" runat="server"></asp:TextBox>
                
                <div style="text-align: left; margin-top: 15px; margin-bottom: 15px; ">
                    <asp:CheckBox ID="LeerNomina_CheckBox" 
                                  runat="server" 
                                  Text="Agregar registros de retención ISLR desde nómina de pago" />
                    <br />
                    <asp:CheckBox ID="retencionISLR_NumeroControl_ConvertirNumeros_CheckBox" 
                                runat="server" 
                                Text="Eliminar guiones, letras, etc. del número de control" />
                </div>

                <asp:Button ID="GenerarXMLFile_Button" runat="server" 
                    Text="Construir archivo xml" onclick="GenerarXMLFile_Button_Click" />
                <br /><br />
                <div style="text-align: right; ">
                    <asp:LinkButton ID="DownloadFile_LinkButton" runat="server" 
                        onclick="DownloadFile_LinkButton_Click" Visible="False">
                     Copiar el archivo al disco duro local
                    </asp:LinkButton>
                </div>
            </div>
        </fieldset>

        <fieldset runat="server" 
                  id="OpcionesRetencionesIva_Fieldset"
                  style="padding: 25px; text-align: left; ">
            <legend style="color: Navy; ">Archivo de retenciones de impuestos Iva: </legend>

            <br />
            <br />
            <asp:CheckBox ID="ObtencionArchivoRetencionesIva_AgregarEncabezados_CheckBox" 
                            runat="server" 
                            Text="Agregar linea de encabezado al archivo" />
            <br />
            <asp:CheckBox ID="NumeroControl_ConvertirSoloNumeros_CheckBox" 
                            runat="server" 
                            Text="Eliminar guiones, letras, etc. del número de control" />
            <br />
            <asp:CheckBox ID="UsarFechaEmision_CheckBox" 
                            runat="server" 
                            Text="Usar la fecha de emisión al construir el archivo (no marcar si se desea la fecha de recepción)" />
            <br />
            <br />

            <div style="text-align: center; ">
                <asp:Button ID="ObtencionArchivoRetencionesIva_ObtenerArchivo_Button" 
                        runat="server" 
                        Text="Construir archivo txt" 
                        onclick="GenerarArchivoRetencionesIva_Button_Click" />
            </div>
            
            <br />
            <br />

            <div style="text-align: right; ">
                <asp:LinkButton ID="ObtencionArchivoRetencionesIva_DownloadFile_LinkButton" 
                                runat="server" 
                                onclick="DownloadFile_LinkButton_Click" 
                                Visible="False">
                    Copiar el archivo al disco duro local
                </asp:LinkButton>
            </div>

        </fieldset>

        <fieldset runat="server" 
                  id="RelacionMontosAPagar_Fieldset"
                  style="padding: 10px; ">
            <legend style="color: Navy; ">Relación (para el banco) de montos a pagar: </legend>

            <br />
            <span id="ErrMessage_RelacionPagosBanco_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;"></span>
            <div id="GeneralMessage_RelacionPagosBanco_Span" runat="server" class="generalfont" style="text-align: right; font-style: italic; color: blue; "></div>
            <br />

            <asp:DropDownList ID="CuentasBancarias_DropDownList" 
                              runat="server" 
                              DataSourceID="CuentasBancarias_SqlDataSource" 
                              DataTextField="Nombre" 
                              DataValueField="CuentaBancariaID" AutoPostBack="True">
            </asp:DropDownList>

            <br />
            <br />
           
            <div style="text-align: center; ">
               <%-- <a href="javascript:PopupWin('<% = GetRelacionMontosAPagar_UriAddress() %>', 1200, 700)">
                    Abrir página con montos a pagar
                </a>--%>
                <a href="<% = GetRelacionMontosAPagar_UriAddress() %>">
                    Abrir página con montos a pagar
                </a>
            </div>
        </fieldset>

    </div>
    
    <asp:SqlDataSource ID="CiasContab_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT distinct tTempWebReport_ConsultaFacturas.CiaContab, Companias.NombreCorto FROM tTempWebReport_ConsultaFacturas INNER JOIN Companias ON tTempWebReport_ConsultaFacturas.CiaContab = Companias.Numero WHERE (tTempWebReport_ConsultaFacturas.NombreUsuario = @NombreUsuario) ORDER BY Companias.NombreCorto">
        <SelectParameters>
            <asp:Parameter Name="NombreUsuario" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="CuentasBancarias_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="Select c.CuentaBancaria + ' ' + b.Abreviatura + ' ' + co.Abreviatura AS Nombre, c.CuentaInterna As CuentaBancariaID
                        From CuentasBancarias c Inner Join Agencias a On c.Agencia = a.Agencia 
                        Inner Join Bancos b On a.Banco = b.Banco 
                        Inner Join Companias co On c.Cia = co.Numero
                        WHERE (c.Cia = @Cia) 
                        Order By b.Abreviatura, c.CuentaBancaria">
        <SelectParameters>
            <asp:Parameter Name="Cia" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    
</asp:Content>

