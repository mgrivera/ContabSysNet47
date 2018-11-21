<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="ComprobantesContables_Lista.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Comprobantes.ComprobantesContables_Lista" %>
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

    <asp:DynamicDataManager id="DynamicDataManager1" runat="server" />

    <asp:ListView ID="AsientosContables_ListView" 
                runat="server" 
                DataSourceID="ComprobantesContables_SqlDataSource" >
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
                                    Tipo
                                </th>
                                <th id="Th3" runat="server" class="padded" style="text-align: center;">
                                    Fecha
                                </th>
                                <th id="th4" runat="server" class="padded" style="text-align: left;">
                                    Descripción
                                </th>
                                <th id="Th5" runat="server" class="padded" style="text-align: center;">
                                    Moneda
                                </th>
                                <th id="Th10" runat="server" class="padded" style="text-align: left;">
                                    Proviene de
                                </th>
                                <th id="Th8" runat="server" class="left padded" style="text-align: center;">
                                    Cant<br />partidas
                                </th>
                                <th id="Th6" runat="server" class="left padded" style="text-align: right;">
                                    Total debe
                                </th>
                                <th id="Th7" runat="server" class="padded" style="text-align: right;">
                                    Total haber
                                </th>
                                <th id="Th9" runat="server" class="padded" style="text-align: center;">
                                    Cia contab
                                </th>
                                <th id="Th11" runat="server" class="padded" style="text-align: left;">
                                    Usuario
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
                    <a href="javascript:PopupWin('../Cuentas y movimientos/CuentasYMovimientos_Comprobantes.aspx?NumeroAutomatico=' + <%# Eval("NumeroAutomatico") %>, 1000, 680)">
                        <%#Eval("Numero")%></a>
                </td>
                <td class="padded" style="text-align: center; white-space:nowrap; ">
                    <asp:Label ID="Label5" runat="server" Text='<%# Eval("Tipo") %>' />
                </td>
                <td class="left padded" style="text-align: center; white-space:nowrap; ">
                    <asp:Label ID="Label6" runat="server" Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
                </td>
                <td class="left padded" style="text-align: left; ">
                    <asp:Label ID="Label7" runat="server" Text='<%# Eval("Descripcion") %>' />
                </td>
                <td class="left padded" style="white-space:nowrap; text-align: center; ">
                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("SimboloMoneda") %>' />
                </td>
                <td class="left padded" style="white-space:nowrap; text-align: left; ">
                    <asp:Label ID="Label10" runat="server" Text='<%# Eval("ProvieneDe") %>' />
                </td>
                <td class="padded" style="white-space:nowrap; text-align: center; ">
                   <asp:Label ID="Label1" runat="server" Text='<%# Eval("CantPartidas") %>' />
                </td>
                <td class="padded" style="white-space:nowrap; text-align: right; ">
                   <asp:Label ID="Label8" runat="server" Text='<%# Eval("TotalDebe", "{0:N2}") %>' />
                </td>
                <td class="padded" style="white-space:nowrap; text-align: right; ">
                   <asp:Label ID="Label9" runat="server" Text='<%# Eval("TotalHaber", "{0:N2}") %>' />
                </td>
                <td class="left padded" style="white-space:nowrap; text-align: center; ">
                    <asp:Label ID="Label3" runat="server" Text='<%# Eval("CiaContab") %>' />
                </td>
                <td class="left padded" style="white-space:nowrap; text-align: left; ">
                    <asp:Label ID="Label11" runat="server" Text='<%# Eval("Usuario") %>' />
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

    <asp:SqlDataSource ID="ComprobantesContables_SqlDataSource" 
                       runat="server" 
                       ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
                       SelectCommand="Select a.NumeroAutomatico, a.Numero, a.Tipo, a.Fecha, a.Descripcion, m.Simbolo As SimboloMoneda, 
                                             a.ProvieneDe, COUNT(*) As CantPartidas, 
                                             SUM(d.Debe) As TotalDebe, SUM(d.Haber) As TotalHaber, c.Abreviatura As CiaContab, a.Usuario
                                      From Asientos a 
                                      Inner Join dAsientos d 
                                      On a.NumeroAutomatico = d.NumeroAutomatico
                                      Inner Join Companias c 
                                      On a.Cia = c.Numero
                                      Inner Join Monedas m 
                                      On a.Moneda = m.Moneda
                                      Where a.ProvieneDe = @ProvieneDe And a.ProvieneDe_ID = @ProvieneDe_ID
                                      Group By a.NumeroAutomatico, a.Numero, a.Tipo, a.Fecha, a.Descripcion, m.Simbolo, a.ProvieneDe, c.Abreviatura, a.Usuario
                                      Order By a.Fecha, a.Numero">
        <SelectParameters>
            <asp:Parameter Name="ProvieneDe" Type="String" />
            <asp:Parameter Name="ProvieneDe_ID" Type="Int32" />
        </SelectParameters>

    </asp:SqlDataSource>

</asp:Content>