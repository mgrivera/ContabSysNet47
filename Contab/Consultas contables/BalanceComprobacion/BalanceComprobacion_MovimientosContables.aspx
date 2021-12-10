<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="BalanceComprobacion_MovimientosContables.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.BalanceComprobacion.BalanceComprobacion_MovimientosContables" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<script type="text/javascript">
    function PopupWin(url, w, h) {
        ///Parameters url=page to open, w=width, h=height
        var left = parseInt((screen.availWidth / 2) - (w / 2));
        var top = parseInt((screen.availHeight / 2) - (h / 2));
        window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,left=" + left + ",top=" + top + "screenX=" + left + ",screenY=" + top);
    }
</script>

<div style="text-align: left; padding-left: 20px; ">
    <h4 id="TituloPagina" runat="server">
    </h4>
</div>
      
<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>

    <asp:ValidationSummary ID="ValidationSummary1" 
                            runat="server" 
                            class="errmessage_background generalfont errmessage"
                            ShowModelStateErrors="true"
                            ForeColor="" />

    <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" Display="None" EnableClientScript="False" />
       
    <asp:ListView ID="BalanceComprobacion_ListView" 
                    runat="server" 
                    DataSourceID="MovimientosContables_SqlDataSource"
                    OnPagePropertiesChanging="BalanceComprobacion_ListView_PagePropertiesChanging"
        >
           
        <LayoutTemplate>
            <table id="Table1" runat="server">
                <tr id="Tr1" runat="server">
                    <td id="Td1" runat="server">
                        <table ID="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6" class="smallfont" cellspacing="0" rules="none">
                            <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave">
                                <th id="Th14" runat="server" class="padded" style="text-align: center; padding-bottom: 10px;">
                                    #Partida
                                </th>
                                <th id="Th3" runat="server" class="padded" style="text-align: left; padding-bottom: 10px;">
                                    Descripción partida
                                </th>
                                <th id="Th1" runat="server" class="padded" style="text-align: center; padding-bottom: 10px;">
                                    #Comp
                                </th>
                                <th id="Th2" runat="server" class="padded" style="text-align: center; padding-bottom: 10px; white-space: nowrap; ">
                                    Fecha
                                </th>
                                <th id="Th20"  runat="server" class="padded" style="text-align: left; padding-bottom: 10px;">
                                    Referencia
                                </th>
                                <th id="Th4"  runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                    Debe
                                </th>
                                <th id="Th5"  runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                    Haber
                                </th>
                                <th id="Th6" runat="server" class="padded" style="text-align: center; padding-bottom: 10px;">
                                    Mon
                                </th>
                                <th id="Th7" runat="server" class="padded" style="text-align: center; padding-bottom: 10px;">
                                    Mon<br />orig
                                </th>
                                <th id="Th21" runat="server" class="padded" style="text-align: center; padding-bottom: 10px;">
                                    Cant<br />uploads
                                </th>
                                <th id="Th8" runat="server" class="padded" style="text-align: left; padding-bottom: 10px;">
                                    Compañía
                                </th>
                            </tr>

                            <tr ID="itemPlaceholder" runat="server">
                            </tr>

                            <tr id="Tr4" runat="server" style="" class="ListViewHeader_Suave">
                                <th id="Th9" runat="server" class="padded" style="padding-top: 5px; padding-bottom: 5px;" />
                                <th id="Th15" runat="server" class="padded" style="padding-top: 5px; padding-bottom: 5px;" />
                                <th id="Th10" runat="server" class="padded" style="padding-top: 5px; padding-bottom: 5px;" />
                                <th id="Th11" runat="server" class="padded" style="padding-top: 5px; padding-bottom: 5px;" />
                                <th id="Th12"  runat="server" class="padded" style="padding-top: 5px; padding-bottom: 5px;" />
                                <th id="Th13"  runat="server" class="padded" style="text-align: right; padding-top: 5px; padding-bottom: 5px;">
                                    <asp:Label ID="SumOfDebe_Label" runat="server" Text="Label" />
                                </th>
                                <th id="Th16"  runat="server" class="padded" style="text-align: right; padding-top: 5px; padding-bottom: 5px;">
                                    <asp:Label ID="SumOfHaber_Label" runat="server" Text="Label" />
                                </th>
                                <th id="Th17" runat="server" class="padded" style="padding-top: 5px; padding-bottom: 5px;" />
                                <th id="Th18" runat="server" class="padded" style="padding-top: 5px; padding-bottom: 5px;" />
                                <th id="Th22" runat="server" class="padded" style="padding-top: 5px; padding-bottom: 5px;" />
                                <th id="Th19" runat="server" class="padded" style="padding-top: 5px; padding-bottom: 5px;" />
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="Tr3" runat="server" style="text-align: left; ">
                        <td id="Td2" runat="server" style="">
                        <asp:DataPager ID="ComprobantesContables_DataPager" runat="server" PageSize="20">
                            <Fields>
                                <asp:NextPreviousPagerField ButtonType="Image"
                                    FirstPageText="&lt;&lt;" NextPageText="&gt;" PreviousPageImageUrl="~/Pictures/ListView_Buttons/PgPrev.gif"
                                    PreviousPageText="&lt;" ShowFirstPageButton="True" ShowNextPageButton="False"
                                    ShowPreviousPageButton="True" FirstPageImageUrl="~/Pictures/ListView_Buttons/PgFirst.gif" />
                                <asp:NumericPagerField />
                                <asp:NextPreviousPagerField ButtonType="Image" LastPageImageUrl="~/Pictures/ListView_Buttons/PgLast.gif"
                                    LastPageText="&gt;&gt;" NextPageImageUrl="~/Pictures/ListView_Buttons/PgNext.gif" NextPageText="&gt;"
                                    PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True" ShowPreviousPageButton="False" />
                            </Fields>
                        </asp:DataPager>
                    </td>
                </tr>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr style="">
                <td class="padded" style="text-align: center; ">
                    <asp:Label ID="Label10" runat="server" Text='<%# Eval("Partida") %>' />
                </td>
                <td class="padded" style="text-align: left; ">
                    <asp:Label ID="Label12" runat="server" Text='<%# Eval("DescripcionPartida") %>' />
                </td>
                <td class="padded" style="text-align: center;">
                        <a href="javascript:PopupWin('../Cuentas y movimientos/CuentasYMovimientos_Comprobantes.aspx?NumeroAutomatico=' + <%# Eval("NumeroAutomatico") %>, 1000, 680)">
                                <%#Eval("NumeroComprobanteContable")%></a>    
                </td>
                    <td class="padded" style="text-align: center; white-space: nowrap; ">
                    <asp:Label ID="Label1"  runat="server" style="white-space: nowrap; " Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="Label2" runat="server" 
                        Text='<%# Eval("Referencia", "{0:N2}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label ID="Label3"  runat="server" 
                        Text='<%# Eval("Debe", "{0:N2}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label ID="Label4" runat="server" 
                        Text='<%# Eval("Haber", "{0:N2}") %>' />
                </td>
                    <td class="padded" style="text-align: center;">
                    <asp:Label ID="Label5"  runat="server" 
                        Text='<%# Eval("SimboloMoneda") %>' />
                </td>
                <td class="padded" style="text-align: center;">
                    <asp:Label ID="Label6"  runat="server" Text='<%# Eval("SimboloMonedaOriginal") %>' />
                </td>
                <td class="padded" style="text-align: center;">
                    <asp:Label ID="Label11"  runat="server" Text='<%# Eval("NumLinks", "{0:#}") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="Label7"  runat="server" 
                        Text='<%# Eval("NombreCiaContab") %>' />
                </td>
            </tr>
        </ItemTemplate>
        <AlternatingItemTemplate>
               
            <tr style="" class="ListViewAlternatingRow">
                <td class="padded" style="text-align: center; ">
                    <asp:Label ID="Label10" runat="server" Text='<%# Eval("Partida") %>' />
                </td>
                <td class="padded" style="text-align: left; ">
                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("DescripcionPartida") %>' />
                </td>
                <td class="padded" style="text-align: center;">
                    <a href="javascript:PopupWin('../Cuentas y movimientos/CuentasYMovimientos_Comprobantes.aspx?NumeroAutomatico=' + <%# Eval("NumeroAutomatico") %>, 1000, 680)">
                                <%#Eval("NumeroComprobanteContable")%></a>    
                </td>
                    <td class="padded" style="text-align: center; white-space: nowrap; ">
                    <asp:Label ID="Label3"  runat="server" style="white-space: nowrap; " Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
                </td>
                <td class="padded" style="text-align: left; ">
                    <asp:Label ID="Label4" runat="server" 
                        Text='<%# Eval("Referencia", "{0:N2}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label ID="Label5"  runat="server" 
                        Text='<%# Eval("Debe", "{0:N2}") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label ID="Label6" runat="server" 
                        Text='<%# Eval("Haber", "{0:N2}") %>' />
                </td>
                    <td class="padded" style="text-align: center;">
                    <asp:Label ID="Label7"  runat="server" 
                        Text='<%# Eval("SimboloMoneda") %>' />
                </td>
                <td class="padded" style="text-align: center;">
                    <asp:Label ID="Label8"  runat="server" 
                        Text='<%# Eval("SimboloMonedaOriginal") %>' />
                </td>
                <td class="padded" style="text-align: center;">
                    <asp:Label ID="Label11"  runat="server" Text='<%# Eval("NumLinks", "{0:#}") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="Label9"  runat="server" 
                        Text='<%# Eval("NombreCiaContab") %>' />
                </td>
            </tr>
        </AlternatingItemTemplate>
        <EmptyDataTemplate>
            <div style="text-align: left; ">
                <table id="Table2" runat="server" style="">
                    <tr>
                        <td>
                            <br />
                            &nbsp;&nbsp;&nbsp;&nbsp;No existen movimientos contables para la cuenta y el período indicado.
                        </td>
                    </tr>
                </table>
            </div>
               
        </EmptyDataTemplate>
    </asp:ListView>

    </ContentTemplate>
</asp:UpdatePanel>
            
<asp:SqlDataSource ID="MovimientosContables_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="Select d.Partida, d.NumeroAutomatico, a.Numero As NumeroComprobanteContable, a.Fecha As Fecha, 
        d.Descripcion As DescripcionPartida, d.Referencia, d.Debe, d.Haber, Count(l.Id) as NumLinks,  
        co.Abreviatura As NombreCiaContab,
        m.Simbolo As SimboloMoneda, mo.Simbolo As SimboloMonedaOriginal 
        From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico 
		Inner Join Monedas m on a.Moneda = m.Moneda 
		Inner Join Monedas mo on a.MonedaOriginal = mo.Moneda 
		Inner Join Companias co on a.Cia = co.Numero
        Left Join Asientos_Documentos_Links l on a.NumeroAutomatico = l.NumeroAutomatico 
        Where d.CuentaContableID = @CuentaContableID And a.Moneda = @Moneda And (a.Fecha &gt;= @FechaInicialPeriodo and Fecha &lt;= @FechaFinalPeriodo) And 
        (d.Referencia Is Null Or d.Referencia &lt;&gt; 'Reconversión 2021') 
        Group By d.Partida, d.NumeroAutomatico, a.Numero, a.Fecha, d.Descripcion, d.Referencia, d.Debe, d.Haber, co.Abreviatura, m.Simbolo, mo.Simbolo 
        Order By a.Fecha, a.Numero, d.Partida">

          <SelectParameters>
            <asp:Parameter Name="CuentaContableID" Type="Int32" DefaultValue="-999" />
            <asp:Parameter Name="Moneda" Type="Int32" DefaultValue="-999" />
            <asp:Parameter Name="FechaInicialPeriodo" Type="DateTime" DefaultValue="1960-01-01" />
            <asp:Parameter Name="FechaFinalPeriodo" Type="DateTime" DefaultValue="1960-01-01" />
        </SelectParameters>
</asp:SqlDataSource>

</asp:Content>





        
