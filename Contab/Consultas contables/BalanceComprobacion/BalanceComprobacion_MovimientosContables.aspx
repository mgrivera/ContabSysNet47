<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="BalanceComprobacion_MovimientosContables.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.BalanceComprobacion.BalanceComprobacion_MovimientosContables" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<script type="text/javascript">
    function PopupWin(url,w,h){
    ///Parameters url=page to open, w=width, h=height
    window.open(url, "_blank", "width=" + w +",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
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
                      DataSourceID="MovimientosContables_LinqDataSource">
           
            <LayoutTemplate>
                <table id="Table1" runat="server">
                    <tr id="Tr1" runat="server">
                        <td id="Td1" runat="server">
                            <table ID="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6" class="smallfont" cellspacing="0" rules="none">
                                <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave">
                                    <th id="Th3" runat="server" class="padded" style="text-align: left; padding-bottom: 10px;">
                                        Descripción asiento
                                    </th>
                                    <th id="Th1" runat="server" class="padded" style="text-align: center; padding-bottom: 10px;">
                                        #Comp
                                    </th>
                                    <th id="Th2" runat="server" class="padded" style="text-align: center; padding-bottom: 10px;">
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
                                    <th id="Th8" runat="server" class="padded" style="text-align: left; padding-bottom: 10px;">
                                        Compañía
                                    </th>
                                </tr>

                                <tr ID="itemPlaceholder" runat="server">
                                </tr>

                                <tr id="Tr4" runat="server" style="" class="ListViewHeader_Suave">
                                    <th id="Th9" runat="server" class="padded" style="padding-top: 5px; padding-bottom: 5px;" />
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
                    <td class="padded" style="text-align: left; ">
                        <asp:Label ID="Label12" runat="server" Text='<%# Eval("DescripcionPartida") %>' />
                    </td>
                    <td class="padded" style="text-align: center;">
                         <a href="javascript:PopupWin('../Cuentas y movimientos/CuentasYMovimientos_Comprobantes.aspx?NumeroAutomatico=' + <%# Eval("NumeroAutomatico") %>, 1000, 680)">
                                    <%#Eval("NumeroComprobanteContable")%></a>    
                    </td>
                     <td class="padded" style="text-align: center;">
                        <asp:Label ID="Label1"  runat="server" 
                            Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
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
                        <asp:Label ID="Label6"  runat="server" 
                            Text='<%# Eval("SimboloMonedaOriginal") %>' />
                    </td>
                    <td class="padded" style="text-align: left;">
                        <asp:Label ID="Label7"  runat="server" 
                            Text='<%# Eval("NombreCiaContab") %>' />
                    </td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
               
              <tr style="" class="ListViewAlternatingRow">
                    <td class="padded" style="text-align: left; ">
                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("DescripcionPartida") %>' />
                    </td>
                    <td class="padded" style="text-align: center;">
                        <a href="javascript:PopupWin('../Cuentas y movimientos/CuentasYMovimientos_Comprobantes.aspx?NumeroAutomatico=' + <%# Eval("NumeroAutomatico") %>, 1000, 680)">
                                    <%#Eval("NumeroComprobanteContable")%></a>    
                    </td>
                     <td class="padded" style="text-align: center; white-space: nowrap; ">
                        <asp:Label ID="Label3"  runat="server" 
                            Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
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
            
    <asp:LinqDataSource ID="MovimientosContables_LinqDataSource" runat="server" 
          ContextTypeName="ContabSysNet_Web.ModelosDatos.dbContabDataContext" OrderBy="Asiento.Fecha, Asiento.Numero, Partida" 
          Select="new (NumeroAutomatico, Asiento.Numero As NumeroComprobanteContable, Asiento.Fecha As Fecha, 
          Descripcion As DescripcionPartida, Referencia, Debe, Haber,
          CuentasContable.CuentaEditada As CuentaContableEditada, 
          CuentasContable.Descripcion As NombreCuentaContable, Asiento.Compania_Contab.Abreviatura As NombreCiaContab,
          Asiento.Moneda_Contab.Simbolo As SimboloMoneda, Asiento.Moneda_Contab1.Simbolo As SimboloMonedaOriginal)" 
          TableName="dAsientos" 
          
        Where="CuentaContableID == @CuentaContableID &amp;&amp; Asiento.Moneda == @Moneda &amp;&amp; Asiento.Fecha &gt;= @FechaInicialPeriodo &amp;&amp; Asiento.Fecha &lt;= @FechaFinalPeriodo" 
        EntityTypeName="">
        <WhereParameters>
            <asp:Parameter Name="CuentaContableID" Type="Int32" DefaultValue="-999" />
            <asp:Parameter Name="Moneda" Type="Int32" DefaultValue="-999" />
            <asp:Parameter Name="FechaInicialPeriodo" Type="DateTime" DefaultValue="1960-01-01" />
            <asp:Parameter Name="FechaFinalPeriodo" Type="DateTime" DefaultValue="1960-01-01" />
        </WhereParameters>
    </asp:LinqDataSource>
</asp:Content>
