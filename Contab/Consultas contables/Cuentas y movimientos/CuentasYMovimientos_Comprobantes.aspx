<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="CuentasYMovimientos_Comprobantes.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Cuentas_y_movimientos.CuentasYMovimientos_Comprobantes" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <script type="text/javascript">
        function PopupWin(url, w, h) {
            ///Parameters url=page to open, w=width, h=height
            var left = parseInt((screen.availWidth / 2) - (w / 2));
            var top = parseInt((screen.availHeight / 2) - (h / 2));
            window.open(url, "_blank", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,left=" + left + ",top=" + top + "screenX=" + left + ",screenY=" + top);
        }

        function RefreshPage() {
            window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
            window.document.forms(0).submit();
        }
    </script>

    <div style="text-align: right; padding: 0 16px 10px 10px; ">
        <table style="width: auto; margin-right: 0px; margin-left: auto; " class="notsosmallfont">
            <tr>
                <td style="width: auto; text-align: center; ">
                    <a runat="server" id="ImprimirAsientoContable_HyperLink" href="javascript:PopupWin('../../../ReportViewer.aspx?rpt=unasientocontable', 1000, 680)">
                        Reporte
                    </a>
                </td>
                <td style="width: auto; padding-left: 10px; ">
                    <%--&nbsp;<asp:Button ID="btnShow" runat="server" Text="Modificaciones" CssClass="ButtonAsLink" />--%>
                    <a runat="server" id="anchorShowModal" href="#">Modificaciones</a>
                </td>
            </tr>
            <tr>
                <td style="width: auto; padding-top: 5px; text-align: center; ">
                    <i class="fas fa-print"></i>
                </td>
                <td style="width: auto; padding-left: 10px; padding-top: 5px; text-align: center; ">
                    <i class="fas fa-edit"></i>
                </td>
            </tr>
        </table>
    </div>


    <%--para mostrar un diálogo que permita al usuario continuar/cancelar--%>
    <asp:Panel ID="pnlPopup" runat="server" CssClass="modalpopup" Style="display: none">
        <div class="popup_container" style="max-width: 500px;">
            <div class="popup_form_header" style="overflow: hidden;">
                <div id="ModalPopupTitle_div" style="width: 85%; margin-top: 5px; float: left;">
                    <span runat="server" id="ModalPopupTitle_span" style="font-weight: bold;">
                        Modificaciones aplicadas al asiento
                    </span>
                </div>
                <div style="width: 15%; float: right;">
                    <asp:ImageButton ID="ImageButton1"
                        runat="server"
                        OnClientClick="$find('popup').hide(); return false;"
                        ImageUrl="~/Pictures/PopupCloseButton.png" />
                </div>
            </div>
            <div class="inner_container">
                <div class="popup_form_content">
                    <span runat="server" id="ModalPopupBody_span">

                        <asp:ListView ID="Asientos_Log_ListView" runat="server"
                            DataSourceID="Asientos_Log_SqlDataSource">
                            <LayoutTemplate>
                                <table id="Table2" runat="server">
                                    <tr id="Tr1" runat="server">
                                        <td id="Td1" runat="server">
                                            <table id="itemPlaceholderContainer" runat="server" border="0" style="" class="smallfont" cellspacing="0">
                                                <tr class="ListViewHeader_Suave smallfont">
                                                    <th class="padded" style="text-align: center; border-bottom: 1px solid white; border-right: 1px solid white; " colspan="2">Asiento</th>
                                                    <th class="padded" style="text-align: center; border-bottom: 1px solid white; " colspan="3">Operación</th>
                                                </tr>
                                                <tr class="ListViewHeader_Suave smallfont">
                                                    <th class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px;">Número</th>
                                                    <th class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px;">Fecha</th>
                                                    <th class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px;">Usuario</th>
                                                    <th class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px;">Fecha</th>
                                                    <th class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px;">Descripción</th>
                                                </tr>
                                                <tr id="itemPlaceholder" runat="server" class="smallfont">
                                                </tr>
                                                <tr id="Tr3" runat="server" class="ListViewFooter smallfont">
                                                    <th id="Th13" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px;"></th>
                                                    <th id="Th14" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px;"></th>
                                                    <th id="Th15" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px;"></th>
                                                    <th id="Th16" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px;"></th>
                                                    <th runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px;"></th>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr id="Tr4" runat="server">
                                        <td id="Td2" runat="server" style="text-align: left;" class="smallfont">
                                            <hr />
                                            <asp:DataPager ID="DataPager1" runat="server" PageSize="16">
                                                <Fields>
                                                    <asp:NextPreviousPagerField ButtonType="Link" FirstPageImageUrl="../../../Pictures/first_16x16.gif"
                                                        FirstPageText="&lt;&lt;" NextPageText="&gt;" PreviousPageImageUrl="../../../Pictures/left_16x16.gif"
                                                        PreviousPageText="&lt;" ShowFirstPageButton="True" ShowNextPageButton="False"
                                                        ShowPreviousPageButton="True" />
                                                    <asp:NumericPagerField />
                                                    <asp:NextPreviousPagerField ButtonType="Link" LastPageImageUrl="../../../Pictures/last_16x16.gif"
                                                        LastPageText="&gt;&gt;" NextPageImageUrl="../../../Pictures/right_16x16.gif"
                                                        NextPageText="&gt;" PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True"
                                                        ShowPreviousPageButton="False" />
                                                </Fields>
                                            </asp:DataPager>
                                        </td>
                                    </tr>
                                </table>
                            </LayoutTemplate>
                            <ItemTemplate>
                                <tr class="smallfont">
                                    <td class="padded" style="text-align: center;">
                                        <asp:Label ID="Label2" runat="server"
                                            Text='<%# Eval("NumeroAsiento") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center;">
                                        <asp:Label ID="CuentaEditadaLabel" runat="server"
                                            Text='<%# Eval("FechaAsiento", "{0:dd-MM-yyyy}") %>' />
                                    </td>
                                    <td class="padded" style="text-align: left;">
                                        <asp:Label ID="NombreCuentaLabel" runat="server"
                                            Text='<%# Eval("Usuario") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center;">
                                        <asp:Label ID="DescripcionPartidaLabel" runat="server"
                                            Text='<%# Eval("FechaOperacion", "{0:dd-MM-yyyy hh:mm tt}") %>' />
                                    </td>
                                    <td class="padded" style="text-align: left;">
                                        <asp:Label ID="ReferenciaLabel" runat="server"
                                            Text='<%# Eval("DescripcionOperacion") %>' />
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <AlternatingItemTemplate>
                                <tr class="ListViewAlternatingRow smallfont">
                                    <td class="padded" style="text-align: center;">
                                        <asp:Label ID="Label2" runat="server"
                                            Text='<%# Eval("NumeroAsiento") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center;">
                                        <asp:Label ID="CuentaEditadaLabel" runat="server"
                                            Text='<%# Eval("FechaAsiento", "{0:dd-MM-yyyy}") %>' />
                                    </td>
                                    <td class="padded" style="text-align: left;">
                                        <asp:Label ID="NombreCuentaLabel" runat="server"
                                            Text='<%# Eval("Usuario") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center;">
                                        <asp:Label ID="DescripcionPartidaLabel" runat="server"
                                            Text='<%# Eval("FechaOperacion", "{0:dd-MM-yyyy hh:mm tt}") %>' />
                                    </td>
                                    <td class="padded" style="text-align: left;">
                                        <asp:Label ID="ReferenciaLabel" runat="server"
                                            Text='<%# Eval("DescripcionOperacion") %>' />
                                    </td>
                                </tr>
                            </AlternatingItemTemplate>
                            <EmptyDataTemplate>
                                <table id="Table3" runat="server" style="">
                                    <tr>
                                        <td>No existe información que mostrar.
                                        </td>
                                    </tr>
                                </table>
                            </EmptyDataTemplate>
                        </asp:ListView>

                    </span>
                </div>
                <div class="popup_form_footer">
                    <%-- <asp:Button ID="btnOk" runat="server" Text="Continuar" OnClick="btnOk_Click" />--%>
                    <asp:Button ID="btnCancel" runat="server" Text="Cerrar" OnClientClick="$find('popup').hide(); return false;" Width="80px" />
                </div>
            </div>
        </div>
    </asp:Panel>

    

    <ajaxtoolkit:modalpopupextender id="ModalPopupExtender1"
        runat="server"
        behaviorid="popup"
        targetcontrolid="anchorShowModal"
        popupcontrolid="pnlPopup"
        backgroundcssclass="modalBackground"
        popupdraghandlecontrolid="ModalPopupTitle_div"
        drag="True" />

    <asp:ListView ID="AsientosContables_ListView" 
                  runat="server" 
                  DataSourceID="AsientosContables_SqlDataSource"
                  style="text-align: center; ">
        
        <LayoutTemplate>
            <div style="padding: 10px; margin-right: 10px; margin-left: 10px; text-align: center; ">
                <table id="Table1" runat="server" border="1" style="border-collapse: collapse; border: 1px solid #E6E6E6; width: 100%; " cellpadding="6">
                    <tr id="itemPlaceholderContainer" runat="server" >
                        <td id="itemPlaceholder" runat="server">
                        </td>
                    </tr>
                </table>
            </div>
            <div style="">
            </div>
        </LayoutTemplate>
       <ItemTemplate>

           <tr style="text-align: left; font-size: small; " class="ListViewAlternatingRow">
               <td style="padding-left: 10px; font-weight: bold; color: #000000; width: 16%; text-align: right; ">
                   Número:
               </td>
               <td style="padding-left: 10px; font-weight: bold; color: #000000; width: 16%; text-align: left; ">
                   <%# Eval("Numero") %>
               </td>
               <td style="width: 16%; text-align: right; ">
               </td>
               <td style="width: 16%;  text-align: left; ">
               </td>
               <td style="width: 16%; text-align: right; ">
               </td>
               <td style="width: 16%;  text-align: left; ">
               </td>
           </tr>

           <tr style="text-align: left; font-size: small; ">
              
               <td style="padding-left: 10px; font-weight: bold; color: #000000; text-align: right; ">
                   Fecha:
               </td>
               <td style="padding-left: 10px; text-align: left; white-space: nowrap; ">
                   <%#Eval("Fecha", "{0:dd-MMM-yy}")%>
               </td>
               <td style="padding-left: 10px; font-weight: bold; color: #000000; text-align: right; ">
                   Moneda:
               </td>
               <td style="padding-left: 10px;  text-align: left; ">
                   <%#Eval("SimboloMoneda")%>
               </td>
               <td style="padding-left: 10px; font-weight: bold; color: #000000; text-align: right; ">
                   Moneda original:
               </td>
               <td style="padding-left: 10px;  text-align: left; ">
                   <%#Eval("SimboloMonedaOriginal")%>
               </td>
           </tr>

           <tr style="text-align: left; font-size: small; " class="ListViewAlternatingRow">
               <td style="padding-left: 10px; font-weight: bold; color: #000000; text-align: right; ">
                   Descripción:
               </td>
               <td colspan="3" style="padding-left: 10px; white-space: normal; text-align: left; ">
                   <%#Eval("Descripcion")%>
               </td>
               <td style="padding-left: 10px; font-weight: bold; color: #000000; text-align: right; ">
                   Cierre anual:
               </td>
               <td style="padding-left: 10px; text-align: left; ">
                   <%#Eval("AsientoTipoCierreAnualFlag")%>
               </td>
           </tr>

           <tr style="text-align: left; font-size: small; ">
               <td style="padding-left: 10px; font-weight: bold; color: #000000; text-align: right; white-space: nowrap; ">
                   Tipo:
               </td>
               <td style="padding-left: 10px; text-align: left; white-space: nowrap; ">
                   <%#Eval("Tipo")%>
               </td>
               <td style="padding-left: 10px; font-weight: bold; color: #000000; text-align: right; white-space: nowrap; ">
                   Proviene de:
               </td>
               <td style="padding-left: 10px; text-align: left; white-space: nowrap; ">
                   <%#Eval("ProvieneDe")%>
               </td>
               <td style="padding-left: 10px; font-weight: bold; color: #000000; text-align: right; white-space: nowrap; ">
                   Factor de cambio:
               </td>
               <td style="padding-left: 10px; text-align: left; white-space: nowrap; ">
                   <%#Eval("FactorDeCambio", "{0:N2}")%>
               </td>
           </tr>

           <tr style="text-align: center; " class="ListViewAlternatingRow">
               <td colspan="6">
                
                    <table style="width: 100%; ">
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>

                        <tr style="font-size: small; ">
                            <td>
                                Ingreso
                            </td>
                            <td>
                            </td>
                            <td>
                                Ult Act
                            </td>
                            <td>
                            </td>
                            <td>
                                Usuario
                            </td>
                        </tr>

                        <tr style="font-size: small; ">
                            <td style="white-space: nowrap; ">
                                <%#Eval("Ingreso", "{0:dd-MMM-yyyy}")%>
                            </td>
                            <td>
                            </td>
                            <td style="white-space: nowrap; ">
                                <%#Eval("UltAct", "{0:dd-MMM-yyyy}")%>
                            </td>
                            <td>
                            </td>
                            <td style="white-space: nowrap; ">
                                <%#Eval("Usuario")%>
                            </td>
                        </tr>

                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>

               </td>
           </tr>

        </ItemTemplate>

        <EmptyDataTemplate>
            <table style="">
                <tr>
                    <td>
                        No existe información (asiento contable) que mostrar.
                    </td>
                </tr>
            </table>
        </EmptyDataTemplate>
      
       
    </asp:ListView>
    <br /><br />
    <asp:ListView ID="Partidas_ListView" runat="server" 
        DataSourceID="Partidas_SqlDataSource">
        <LayoutTemplate>
            <table id="Table2" runat="server">
                <tr id="Tr1" runat="server">
                    <td id="Td1" runat="server">
                        <table ID="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6" class="smallfont" cellspacing="0">
                            <tr id="Tr2" runat="server" class="ListViewHeader_Suave smallfont">
                                <th id="Th1" runat="server" class="padded" style="text-align: center; padding-bottom:5px; padding-top:5px; ">
                                    Partida</th>
                                <th id="Th8" runat="server" class="padded" style="text-align: left; padding-bottom:5px; padding-top:5px; ">
                                    Cuenta</th>
                                <th id="Th2" runat="server" class="padded" style="text-align: left; padding-bottom:5px; padding-top:5px; ">
                                    Nombre de la cuenta</th>
                                <th id="Th3" runat="server" class="padded" style="text-align: left; padding-bottom:5px; padding-top:5px; ">
                                    Descripción</th>
                                <th  runat="server" class="padded" style="text-align: left; padding-bottom:5px; padding-top:5px; ">
                                    Referencia</th>
                                <th  runat="server" class="padded" style="text-align: left; padding-bottom:5px; padding-top:5px; ">
                                    Centro costo</th>
                                <th id="Th4" runat="server" class="padded" style="text-align: right; padding-bottom:5px; padding-top:5px; ">
                                    Debe</th>
                                <th id="Th5" runat="server" class="padded" style="text-align: right; padding-bottom:5px; padding-top:5px; ">
                                    Haber</th>
                            </tr>
                            <tr ID="itemPlaceholder" runat="server" class="smallfont">
                            </tr>
                            <tr id="Tr3" runat="server" class="ListViewFooter smallfont">
                                <th id="Th6" runat="server" class="padded" style="text-align: center; padding-bottom:5px; padding-top:5px; ">
                                    </th>
                                <th id="Th9" runat="server" class="padded" style="text-align: center; padding-bottom:5px; padding-top:5px; ">
                                    </th>
                                <th id="Th7" runat="server" class="padded" style="text-align: left; padding-bottom:5px; padding-top:5px; ">
                                    </th>
                                <th  runat="server" class="padded" style="text-align: left; padding-bottom:5px; padding-top:5px; ">
                                    </th>
                                <th  runat="server" class="padded" style="text-align: left; padding-bottom:5px; padding-top:5px; ">
                                    </th>
                                <th id="Th10" runat="server" class="padded" style="text-align: left; padding-bottom:5px; padding-top:5px; ">
                                    </th>
                                <th id="Th11" runat="server" class="padded" style="text-align: right; padding-bottom:5px; padding-top:5px; ">
                                    <asp:Label ID="SumOfDebe_Label" runat="server" Text="Label"></asp:Label></th>
                                <th id="Th12" runat="server" class="padded" style="text-align: right; padding-bottom:5px; padding-top:5px; ">
                                    <asp:Label ID="SumOfHaber_Label" runat="server" Text="Label"></asp:Label></th>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="Tr4" runat="server">
                    <td id="Td2" runat="server" style="text-align: left; " class="smallfont">
                        <hr />
                        <asp:DataPager ID="DataPager1" runat="server" PageSize="16">
                            <Fields>
                                                <asp:NextPreviousPagerField ButtonType="Link" FirstPageImageUrl="../../../Pictures/first_16x16.gif"
                                                    FirstPageText="&lt;&lt;" NextPageText="&gt;" PreviousPageImageUrl="../../../Pictures/left_16x16.gif"
                                                    PreviousPageText="&lt;" ShowFirstPageButton="True" ShowNextPageButton="False"
                                                    ShowPreviousPageButton="True" />
                                                <asp:NumericPagerField />
                                                <asp:NextPreviousPagerField ButtonType="Link" LastPageImageUrl="../../../Pictures/last_16x16.gif"
                                                    LastPageText="&gt;&gt;" NextPageImageUrl="../../../Pictures/right_16x16.gif"
                                                    NextPageText="&gt;" PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True"
                                                    ShowPreviousPageButton="False" />
                                            </Fields>
                        </asp:DataPager>
                    </td>
                </tr>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr style="" class="smallfont">
                <td class="padded" style="text-align: center;">
                    <asp:Label ID="Label2" runat="server" 
                        Text='<%# Eval("Partida") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="CuentaEditadaLabel" runat="server" 
                        Text='<%# Eval("CuentaEditada") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="NombreCuentaLabel" runat="server" 
                        Text='<%# Eval("NombreCuenta") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="DescripcionPartidaLabel" runat="server" 
                        Text='<%# Eval("DescripcionPartida") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="ReferenciaLabel" runat="server" 
                        Text='<%# Eval("Referencia") %>' />
                </td>
                <td class="padded" style="text-align: center ;">
                    <asp:Label ID="Label1" runat="server" 
                        Text='<%# Eval("NombreCentroCosto") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label ID="DebeLabel" runat="server" 
                    Text='<%#(decimal)Eval("Debe")==0 ? "" : Eval("Debe", "{0:N3}")%>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label ID="HaberLabel" runat="server" 
                    Text='<%#(decimal)Eval("Haber")==0 ? "" : Eval("Haber", "{0:N3}")%>' />
                </td>
            </tr>
        </ItemTemplate>
        <AlternatingItemTemplate>
            <tr style="" class="ListViewAlternatingRow smallfont">
                <td class="padded" style="text-align: center;">
                    <asp:Label ID="Label2" runat="server" 
                        Text='<%# Eval("Partida") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="CuentaEditadaLabel" runat="server" 
                        Text='<%# Eval("CuentaEditada") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="NombreCuentaLabel" runat="server" 
                        Text='<%# Eval("NombreCuenta") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="DescripcionPartidaLabel" runat="server" 
                        Text='<%# Eval("DescripcionPartida") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="ReferenciaLabel" runat="server" 
                        Text='<%# Eval("Referencia") %>' />
                </td>
                <td class="padded" style="text-align: center ;">
                    <asp:Label ID="Label1" runat="server" 
                        Text='<%# Eval("NombreCentroCosto") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label ID="DebeLabel" runat="server" 
                    Text='<%#(decimal)Eval("Debe")==0 ? "" : Eval("Debe", "{0:N3}")%>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label ID="HaberLabel" runat="server" 
                    Text='<%#(decimal)Eval("Haber")==0 ? "" : Eval("Haber", "{0:N3}")%>' />
                </td>
            </tr>
        </AlternatingItemTemplate>
        <EmptyDataTemplate>
            <table id="Table3" runat="server" style="">
                <tr>
                    <td>
                        No existe información (partidas del asiento) que mostrar.
                    </td>
                </tr>
            </table>
        </EmptyDataTemplate>
    </asp:ListView>
   
    <asp:SqlDataSource ID="AsientosContables_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" SelectCommand="
                SELECT Asientos.Numero, Asientos.Fecha, Asientos.Tipo, Asientos.Descripcion, 
                Monedas.Simbolo AS SimboloMoneda, Monedas_1.Simbolo AS SimboloMonedaOriginal, Asientos.FactorDeCambio, Asientos.ProvieneDe, 
                Companias.NombreCorto AS NombreCiaContab, Case MesFiscal When 13 Then 'Si' Else 
                Case IsNull(AsientoTipoCierreAnualFlag, 0) When 1 Then 'Si' Else 'No' End End As AsientoTipoCierreAnualFlag, 
                Asientos.Ingreso, Asientos.UltAct, Asientos.Usuario
                FROM Asientos INNER JOIN Companias ON Asientos.Cia = Companias.Numero 
                INNER JOIN Monedas ON Asientos.Moneda = Monedas.Moneda 
                INNER JOIN Monedas AS Monedas_1 ON Asientos.MonedaOriginal = Monedas_1.Moneda
                Where NumeroAutomatico = @NumeroAutomatico">
        <SelectParameters>
            <asp:Parameter Name="NumeroAutomatico" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Partidas_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="
            SELECT dAsientos.Partida, CuentasContables.CuentaEditada, CuentasContables.Descripcion AS NombreCuenta, 
            dAsientos.Descripcion AS DescripcionPartida, dAsientos.Referencia, dAsientos.Debe, dAsientos.Haber, 
            CentrosCosto.DescripcionCorta AS NombreCentroCosto 
            FROM dAsientos INNER JOIN CuentasContables ON dAsientos.CuentaContableID = CuentasContables.ID 
            LEFT OUTER JOIN CentrosCosto ON dAsientos.CentroCosto = CentrosCosto.CentroCosto 
            WHERE (dAsientos.NumeroAutomatico = @NumeroAutomatico)
            Order By dAsientos.Partida
            ">
        <SelectParameters>
            <asp:Parameter Name="NumeroAutomatico" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Asientos_Log_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="
            SELECT NumeroAsiento, FechaAsiento, Usuario, FechaOperacion, DescripcionOperacion
            FROM Asientos_Log
            WHERE (Asientos_Log.NumeroAutomatico = @NumeroAutomatico)
            Order By Asientos_Log.FechaOperacion
            ">
        <SelectParameters>
            <asp:Parameter Name="NumeroAutomatico" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>