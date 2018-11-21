<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="Facturas_Cuotas.aspx.cs" Inherits="ContabSysNet_Web.Bancos.Consultas_facturas.Facturas.Facturas_Cuotas" %>
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

    <asp:DynamicDataManager ID="DynamicDataManager1" runat="server" />

    <asp:ListView ID="FacturasCuotas_ListView" 
                runat="server" 
                DataKeyNames="ClaveUnica"
                DataSourceID="FacturasCuotas_EntityDataSource" >
        <LayoutTemplate>
            <table id="Table1" runat="server" >
                <tr id="Tr1" runat="server">
                    <td id="Td1" runat="server">
                        <table id="itemPlaceholderContainer" runat="server" border="0"  
                                style="border: 1px solid #E6E6E6" class="smallfont" 
                                cellspacing="0" rules="none">

                            <tr id="Tr2" runat="server" class="ListViewHeader">
                                <th id="th1" runat="server" class="padded" style="text-align: center;">
                                    #
                                </th>
                                <th id="Th2" runat="server" class="padded" style="text-align: center;">
                                    Días<br />venc
                                </th>
                                <th id="Th3" runat="server" class="padded" style="text-align: center;">
                                    Fecha<br />venc
                                </th>
                                <th id="th4" runat="server" class="padded" style="text-align: center;">
                                    Proporción<br />(%)
                                </th>
                                <th id="Th5" runat="server" class="padded" style="text-align: right;">
                                    Monto
                                </th>
                                <th id="Th6" runat="server" class="left padded" style="text-align: right;">
                                    Iva
                                </th>

                                <th id="Th13" runat="server" class="left padded" style="text-align: right;">
                                    Imp<br />varios
                                </th>

                                <th id="Th7" runat="server" class="padded" style="text-align: right;">
                                    Retención<br />Iva
                                </th>
                                <th id="Th8" runat="server" class="padded" style="text-align: right;">
                                    Retención<br />Islr
                                </th>
                                <th id="Th14" runat="server" class="left padded" style="text-align: right;">
                                    Ret<br />varias
                                </th>

                                <th id="Th9" runat="server" class="padded" style="text-align: right;">
                                    Total
                                </th>
                                <th id="Th10" runat="server" class="right padded" style="text-align: right;">
                                    Anticipo
                                </th>

                                <th id="Th11" runat="server" class="padded" style="text-align: center;">
                                    Saldo
                                </th>
                                <th id="Th12" runat="server" class="padded" style="text-align: center;">
                                    Estado
                                </th>
                            </tr>
                            <tr id="itemPlaceholder" runat="server">
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="Tr3" runat="server">
                    <td id="Td2" runat="server" style="text-align: left; background-color: #CCCCCC;
                        font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000; font-size: small; ">
                        <asp:DataPager ID="ConsultaDisponibilidad_DataPager" runat="server" PageSize="25">
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

        <ItemTemplate>
            <tr class="ListViewRow">
                <td class="left padded" style="text-align: center; ">
                    <asp:DynamicControl ID="DynamicControl02" runat="server" DataField="NumeroCuota" />
                </td>
                <td class="padded" style="text-align: center; white-space:nowrap; ">
                    <asp:DynamicControl ID="DynamicControl03" runat="server" DataField="DiasVencimiento" />
                </td>
                <td class="left padded" style="text-align: center; white-space:nowrap; ">
                    <asp:DynamicControl ID="DynamicControl1" runat="server" DataField="FechaVencimiento" />
                </td>
                <td class="left padded" style="text-align: center; ">
                    <asp:DynamicControl ID="DynamicControl4" runat="server" DataField="ProporcionCuota" />
                </td>
                <td class="left padded" style="white-space:nowrap; text-align: right; ">
                    <asp:DynamicControl ID="DynamicControl5" runat="server" DataField="MontoCuota" />
                </td>
                <td class="padded" style="white-space:nowrap; text-align: right; ">
                    <asp:DynamicControl ID="DynamicControl6" runat="server" DataField="Iva" />
                </td>
                <td class="padded" style="white-space:nowrap; text-align: right; ">
                    <asp:DynamicControl ID="DynamicControl13" runat="server" DataField="OtrosImpuestos" />
                </td>
                <td class="padded" style="white-space:nowrap; text-align: right; ">
                    <asp:DynamicControl ID="DynamicControl08" runat="server" DataField="RetencionSobreIva" />
                </td>
                <td class="padded" style="text-align: right; ">
                    <asp:DynamicControl ID="DynamicControl09" runat="server" DataField="RetencionSobreISLR" />
                </td>
                <td class="padded" style="text-align: right; ">
                    <asp:DynamicControl ID="DynamicControl14" runat="server" DataField="OtrasRetenciones" />
                </td>
                <td class="padded" style="text-align: right; ">
                    <asp:DynamicControl ID="DynamicControl10" runat="server" DataField="TotalCuota" />
                </td>
                <td class="padded" style="text-align: right; white-space:nowrap; ">
                    <asp:DynamicControl ID="DynamicControl11" runat="server" DataField="Anticipo" />
                </td>
                <td class="padded" style="text-align: right; ">
                    <asp:DynamicControl ID="DynamicControl7" runat="server" DataField="SaldoCuota" />
                </td>
                <td class="padded" style="text-align: center; ">
                    <asp:DynamicControl ID="DynamicControl12" runat="server" DataField="EstadoCuota" />
                </td>
            </tr>     
        </ItemTemplate>

        <EmptyDataTemplate>
            <table id="Table1" runat="server" style="background-color: #FFFFFF; border-collapse: collapse;
                border-color: #999999; border-style: none; border-width: 1px;">
                <tr>
                    <td>
                        No se han encontrado registros que mostrar en esta lista.
                    </td>
                </tr>
            </table>
        </EmptyDataTemplate>
    </asp:ListView>

     <asp:EntityDataSource ID="FacturasCuotas_EntityDataSource" 
                              runat="server" 
                              ContextTypeName="ContabSysNet_Web.ModelosDatos_EF.Bancos.BancosEntities"
                              EnableFlattening="False" 
                              EntitySetName="CuotasFacturas"
                              Where="it.ClaveUnicaFactura = @FacturaID" >
                                    <WhereParameters>
                                        <asp:Parameter Name="FacturaID" Type="Int32" />
                                    </WhereParameters>
        </asp:EntityDataSource>

</asp:Content>