<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="Pago_page.aspx.cs" Inherits="ContabSysNet_Web.Bancos.ConsultasFacturas.Pagos.Pago_page" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <script type="text/javascript">
         function PopupWin(url, w, h) {
             ///Parameters url=page to open, w=width, h=height
             window.open(url, "_blank", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
         }
         function RefreshPage() {
             window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
             window.document.forms(0).submit();
         }
    </script>

    <div style="text-align: left;">
        <table style="margin-left: 10px; ">
            <tr>
                <td style="text-align: center; ">
                    <a runat="server" id="MostrarMovimientoBancario_HyperLink"
                        href="javascript:PopupWin('../../../ReportViewer.aspx?rpt=unasientocontable', 1000, 680)">
                        <img id="Img1"
                            border="0"
                            alt="Click para mostrar el movimiento bancario asociado"
                            src="../../../Pictures/NewWindow_25x25.png" />
                    </a>
                </td>
                <td></td>
            </tr>
            <tr>
                <td style="color: #4F4F4F; text-align: center; font-size: small;">
                    Movimiento<br />bancario
                </td>
                <td></td>
            </tr>
        </table>
    </div>


    <asp:ValidationSummary ID="ValidationSummary1" 
                           runat="server" 
                           class="errmessage_background generalfont errmessage"
                           ForeColor="" />

    <asp:CustomValidator ID="CustomValidator1" 
                         runat="server" 
                         ErrorMessage="" 
                         Visible="false" />

    <asp:DynamicDataManager ID="DynamicDataManager1" 
                            runat="server" />

    <asp:FormView ID="Pago_FormView"
                  DataSourceID="Pago_EntityDataSource"
                  DataKeyNames = "ClaveUnica"
                  AllowPaging="True"
                  runat="server" 
                  CellPadding="3" 
                  BackColor="White" 
                  BorderColor="#999999" 
                  BorderStyle="None" 
                  BorderWidth="1px" 
                  GridLines="Vertical">
        
        <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
        
        <HeaderStyle forecolor="white" backcolor="#000084" Font-Bold="True" />   

        <HeaderTemplate>
            Información para el pago seleccionado
        </HeaderTemplate>
        
        <ItemTemplate>

            <cc1:tabcontainer id="TabContainer1" runat="server" activetabindex="0" style="text-align: left; ">
                <cc1:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1" >
                    <ContentTemplate>   
                        <table cellspacing="5">
                            <tr>
                                <td align="right" colspan="8" style="font-style:italic; font-size: x-small; color: Blue; ">
                                    <asp:Label id="Label21" runat="server" Text='<%# Eval("Compania.Nombre") %>' />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="8"/>
                            </tr>

                            <tr>
                                <td align="right"><b>Compañía:</b></td>
                                <td align="left">
                                    <%--<asp:DynamicControl id="ProductIDLabel" runat="server"  DataField="Proveedore" />--%>
                                    <asp:Label id="Label11" runat="server" Text='<%# Eval("Proveedore.Nombre") %>' />
                                </td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><b>Fecha:</b></td>
                                <td align="left"><asp:DynamicControl id="Label1" runat="server"  DataField="Fecha" /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><b>Número:</b></td>
                                <td align="left"><asp:DynamicControl id="DynamicControl2" runat="server"  DataField="NumeroPago" /></td>
                            </tr>

                            <tr>
                                <td align="right"><b>Mi/Su:</b></td>
                                <td align="left"><asp:DynamicControl id="DynamicControl1" runat="server"  DataField="MiSuFlag" /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><b>Moneda:</b></td>
                                <td align="left">
                                    <%--<asp:DynamicControl id="DynamicControl3" runat="server"  DataField="Moneda1" />--%>
                                    <asp:Label id="Label12" runat="server" Text='<%# Eval("Moneda1.Simbolo") %>' />
                                </td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><b>Monto:</b></td>
                                <td align="left"><asp:DynamicControl id="DynamicControl4" runat="server"  DataField="Monto" /></td>
                            </tr>

                            <tr>
                                <td align="right"><b>Concepto:</b></td>
                                <td align="left" colspan="7"><asp:DynamicControl id="DynamicControl5" runat="server"  DataField="Concepto" /></td>
                            </tr>
                            
                        </table> 
                        
                        <fieldset style="border-width: 1px; border-color: #0000FF; margin-top: 10px; ">

                            <table cellspacing="5" style="width:100%; ">
                           
                                <tr>
                                    <td align="right">Ingreso:</td>
                                    <td align="left"><asp:DynamicControl id="DynamicControl6" runat="server"  DataField="Ingreso" /></td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td align="right">Ult act:</td>
                                    <td align="left"><asp:DynamicControl id="DynamicControl7" runat="server"  DataField="UltAct" /></td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td align="right">Usuario:</td>
                                    <td align="left"><asp:DynamicControl id="DynamicControl8" runat="server"  DataField="Usuario" /></td>
                                </tr>

                            </table> 

                        </fieldset> 
                        <br />
                    </ContentTemplate>
                </cc1:TabPanel>
            </cc1:tabcontainer>               
        </ItemTemplate>

        <EditRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />

        <EmptyDataTemplate>
            <table style="">
                <tr>
                    <td>
                        No se ha encontrado un registro en la base de datos que 
                        corresponda al que se ha requerido.</td>
                </tr>
            </table>
        </EmptyDataTemplate>

        <pagertemplate>   
          &nbsp;     
        </pagertemplate>
       
        <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
        <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
       
    </asp:FormView>

    <br />

    <asp:ListView ID="Facturas_ListView" runat="server" 
        DataSourceID="Facturas_EntityDataSource">
        <LayoutTemplate>
            <table id="Table1" runat="server">
                <tr id="Tr1" runat="server">
                    <td id="Td1" runat="server">
                        <table id="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                            class="smallfont" cellspacing="0" rules="none">

                            <tr style="color: white; background-color: #000084; font-weight: bold; margin: 5px; font-size:small; ">
                                <td colspan="10">
                                    Facturas asociadas al pago
                                </td>
                            </tr>

                            <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave">
                                <th id="Th1" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                    padding-top: 8px;">
                                    Numero<br />
                                    factura
                                </th>
                                    <th id="Th2" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                    padding-top: 8px;">
                                        Fecha<br />
                                        recepción
                                </th>
                                <th id="Th9" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                    padding-top: 8px;">
                                        Fecha<br />
                                        emisión
                                </th>
                                <th id="Th13" runat="server" class="padded" style="text-align: right; white-space: nowrap;
                                    padding-bottom: 8px; padding-top: 8px;">
                                    Total<br />
                                    factura
                                </th>
                                <th id="Th4" runat="server" class="padded" style="text-align: right; white-space: nowrap;
                                    padding-bottom: 8px; padding-top: 8px;">
                                    Iva
                                </th>
                                <th id="Th5" runat="server" class="padded" style="text-align: right; white-space: nowrap;
                                    padding-bottom: 8px; padding-top: 8px;">
                                    Total a<br />
                                    pagar
                                </th>
                                <th id="Th6" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                    padding-top: 8px;">
                                    Anticipo
                                </th>
                                <th id="Th8" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                    padding-top: 8px;">
                                    Saldo
                                </th>
                                    <th id="Th3" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                    padding-top: 8px;">
                                    Retención<br />
                                    Islr
                                </th>
                                    <th id="Th7" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                    padding-top: 8px;">
                                    Retención<br />
                                    Iva
                                </th>
                            </tr>
                            <tr id="itemPlaceholder" runat="server" />
                        </table>
                    </td>
                </tr>
                <tr id="Tr3" runat="server">
                    <td id="Td2" runat="server" style="">
                        <asp:DataPager ID="ConsultaFacturas_DataPager" runat="server">
                            <Fields>
                                <asp:NextPreviousPagerField ButtonType="Image" FirstPageText="&lt;&lt;" NextPageText="&gt;"
                                    PreviousPageImageUrl="~/Pictures/ListView_Buttons/PgPrev.gif" PreviousPageText="&lt;"
                                    ShowFirstPageButton="True" ShowNextPageButton="False" ShowPreviousPageButton="True"
                                    FirstPageImageUrl="~/Pictures/ListView_Buttons/PgFirst.gif" />
                                <asp:NumericPagerField />
                                <asp:NextPreviousPagerField ButtonType="Image" LastPageImageUrl="~/Pictures/ListView_Buttons/PgLast.gif"
                                    LastPageText="&gt;&gt;" NextPageImageUrl="~/Pictures/ListView_Buttons/PgNext.gif"
                                    NextPageText="&gt;" PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True"
                                    ShowPreviousPageButton="False" />
                            </Fields>
                        </asp:DataPager>
                    </td>
                </tr>
            </table>
        </LayoutTemplate>

        <EmptyDataTemplate>
            <table id="Table2" runat="server" style="">
                <tr>
                    <td>
                        Pago sin facturas asociadas 
                    </td>
                </tr>
            </table>
        </EmptyDataTemplate>
                    
                    
        <ItemTemplate>
                        
            <tr style="">
                <td class="padded" style="text-align: left;">
                    <a href="javascript:PopupWin('../../Consultas facturas/Facturas/Facturas_Detalles.aspx?cuf=' + <%# Eval("CuotasFactura.ClaveUnicaFactura") %>, 1000, 680)">
                        <%#Eval("CuotasFactura.Factura.NumeroFactura")%>
                    </a>
                </td>
                <td class="padded" style="text-align: center;">
                    <asp:Label id="Label2" runat="server" Text='<%# Eval("CuotasFactura.Factura.FechaEmision", "{0:d-MM-yy}") %>' />
                </td>
                    <td class="padded" style="text-align: center;">
                    <asp:Label id="Label3" runat="server" Text='<%# Eval("CuotasFactura.Factura.FechaRecepcion", "{0:d-MM-yy}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label id="Label4" runat="server" Text='<%# Eval("CuotasFactura.Factura.TotalFactura", "{0:N2}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label id="Label5" runat="server" Text='<%# Eval("CuotasFactura.Factura.Iva", "{0:N2}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label id="Label6" runat="server" Text='<%# Eval("CuotasFactura.Factura.TotalAPagar", "{0:N2}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label id="Label7" runat="server" Text='<%# Eval("CuotasFactura.Factura.Anticipo", "{0:N2}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label id="Label8" runat="server" Text='<%# Eval("CuotasFactura.Factura.Saldo", "{0:N2}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label id="Label9" runat="server" Text='<%# Eval("CuotasFactura.Factura.ImpuestoRetenido", "{0:N2}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label id="Label10" runat="server" Text='<%# Eval("CuotasFactura.Factura.RetencionSobreIva", "{0:N2}") %>' />
                </td>
            </tr>
                          
        </ItemTemplate>

    </asp:ListView>

     <asp:EntityDataSource ID="Pago_EntityDataSource" 
                              runat="server" 
                              ContextTypeName="ContabSysNet_Web.ModelosDatos_EF.Bancos.BancosEntities"
                              DefaultContainerName="BancosEntities" 
                              EnableFlattening="False" 
                              Include="Compania,
                                       Moneda1, 
                                       Proveedore"
                              EntitySetName="Pagos"
                              Where="it.ClaveUnica = @PagoID" >
                                    <WhereParameters>
                                        <asp:Parameter Name="PagoID" Type="Int32" />
                                    </WhereParameters>
        </asp:EntityDataSource>

        <asp:EntityDataSource ID="Facturas_EntityDataSource" 
                              runat="server" 
                              ContextTypeName="ContabSysNet_Web.ModelosDatos_EF.Bancos.BancosEntities"
                              DefaultContainerName="BancosEntities" 
                              EnableFlattening="False" 
                              EntitySetName="dPagos"
                              Where="it.ClaveUnicaPago = @PagoID" >
                                    <WhereParameters>
                                        <asp:Parameter Name="PagoID" Type="Int32" />
                                    </WhereParameters>
        </asp:EntityDataSource>

</asp:Content>