<%@ Page Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" CodeBehind="BalanceComprobacion.aspx.cs" Inherits="ContabSysNet_Web.Contab.Consultas_contables.BalanceComprobacion.BalanceComprobacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">

    <%--<script src="<%= this.Page.ResolveUrl("~/Scripts/jquery/jquery-1.10.2.js") %>"></script>--%>
    <script type="text/javascript">
        function PopupWin(url, w, h) {
            ///Parameters url=page to open, w=width, h=height
            var left = parseInt((screen.availWidth / 2) - (w / 2));
            var top = parseInt((screen.availHeight / 2) - (h / 2));
            window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,left=" + left + ",top=" + top + "screenX=" + left + ",screenY=" + top);
        }

        function RefreshPage() {
            // nótese como usamos jquery para asignar el valor al field ... 
            $("#ExecuteThread_HiddenField").val("1");
            $("form").submit();
        }
    </script>

    <%-- function y div para mostrar el progress bar --%>
    <script type="text/javascript">

        function showprogress() {
            document.getElementById("Progressbar_div").style.visibility = "visible";
            document.getElementById("Progressbar_div").style.height = "";
            showprogress_continue();
        }

        function showprogress_continue() {

            // nótese como, simplemente, ejecutamos el web service y pasamos la función (SucceededCallback) 
            // que regresa con los resultados del WS en forma 'directa'.

            MostrarProgreso.GetProgressPercentaje(function (Result) {
                // primero mostramos el progreso (%) 
                var a = Result.Progress_Percentage;
                if (!(a == null)) {
                    document.getElementById("ProgressbarProgress_div").style.width = a + "%";
                    document.getElementById("ProgressbarMessage_div").innerHTML = a + "%";
                }
                // si el proceso no se ha completado, volvemos a ejecutar el web service
                var b = Result.Progress_Completed;
                var c = Result.Progress_SelectedRecs;
                if (!(b == 1))
                    setTimeout("showprogress_continue()", 1000);
                else {
                    // cuando la tarea termina, hacemos un refresh de la página para que se muestren los datos 
                    // seleccionados en el grid
                    // window.document.forms(0).submit();
                    // intentamos mostrar la cantidad de registros seleccionados
                    document.getElementById("ProgressbarMessage_div").innerHTML = c + " registros seleccionados";
                    document.getElementById("ProgressbarBorder_div").style.display = "none";
            // ponemos el item que sigue en 1 y hacemos un postback para que el código haga un 
            // DataBind de los controles que muestran la selección al usuario
            <%--window.document.getElementById('<%=RebindPage_HiddenField.ClientID%>').value = "1";
            window.document.forms(0).submit(); --%>
                $("#RebindPage_HiddenField").val("1");
                $("form").submit();
            }
            });
        }

        function showprogress_displayselectedrecs() {

            // para mostrar la cantidad de registros seleccionados luego que se aplica el filtro y 
            // se construye la selección de registros 

            document.getElementById("Progressbar_div").style.visibility = "visible";
            document.getElementById("Progressbar_div").style.height = "";

            // nótese como usamos Session("Progress_SelectedRecs") que trae un valor desde 
            // code behind

            document.getElementById("ProgressbarMessage_div").innerHTML = document.getElementById('<%=SelectedRecs_HiddenField.ClientID%>').value + " registros seleccionados";
        document.getElementById("ProgressbarBorder_div").style.display = "none";
        }
    </script>



    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/MostrarProgreso.asmx" />
        </Services>
    </asp:ScriptManagerProxy>

    <%--  para refrescar la página cuando el modal (filtro) se cierra (y saber que el refresh es por eso) --%>
    <span id="RebindFlagSpan">
        <asp:HiddenField ID="ExecuteThread_HiddenField" runat="server" Value="0" ClientIDMode="Static" />
        <asp:HiddenField ID="RebindPage_HiddenField" runat="server" Value="0" ClientIDMode="Static" />
        <asp:HiddenField ID="SelectedRecs_HiddenField" runat="server" Value="0" />
    </span>

    <%--  --%>
    <%-- div en la izquierda para mostrar funciones de la página --%>
    <%--  --%>
    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top; background-color: #F7F7F7; float: left; text-align: center; ">
        <br />
        <br />

        <a href="javascript:PopupWin('BalanceComprobacion_Filter.aspx', 1000, 680)">Definir y aplicar<br /> un filtro</a><br />
        <i class="fas fa-filter fa-2x" style="margin-top: 5px;"></i>

        <hr />

        <%-- divs para mostrar el progress bar --%>
        <div id="Progressbar_div" style="visibility: hidden; height: 0px;">
            <div id="ProgressbarBorder_div" style="margin-left: 5px; margin-right: 5px; border: 1px solid #808080; height: 10px; text-align: left;">
                <div id="ProgressbarProgress_div" style="background: url(../../../Pictures/safari.gif) 0% 0% repeat-x; height: 8px; width: 0%;">
                </div>
            </div>
            <div id="ProgressbarMessage_div" style="text-align: center;">
            </div>
            <hr />
        </div>
        <%-- --------------------------------- --%>

        
        <asp:HyperLink ID="ComprobantesContables_Reporte_HyperLink" 
                       runat="server" 
                       CssClass="generalfont"
                       NavigateUrl="javascript:PopupWin('BalanceComprobacion_OpcionesReportes.aspx', 1000, 680)">
            Reporte
        </asp:HyperLink><br />
        <i class="fas fa-print fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <a href="javascript:PopupWin('../../UltimoMesCerradoContable.aspx', 1000, 680)">Fechas de último<br /> cierre contable</a><br />
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px; "></i>

        <hr />
        <br />
    </div>

    <div style="text-align: left; float: right; width: 88%;">
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;"></span>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="False">
            <ContentTemplate>

                <table>
                    <tr>
                        <td style="border: 1px solid #C0C0C0; vertical-align: top; background-color: #EEEEEE;">&nbsp;
                    <span class="smallfont">Compañías:&nbsp;
                        <asp:DropDownList ID="CompaniasFilter_DropDownList"
                            runat="server"
                            ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.Compania"
                            DataTextField="NombreCorto"
                            DataValueField="Numero"
                            AutoPostBack="True"
                            CssClass="smallfont"
                            SelectMethod="Companias_DropBox_GetData"
                            OnSelectedIndexChanged="AplicarMiniFiltro">
                        </asp:DropDownList>
                    </span>

                            &nbsp;&nbsp; 

                    <span class="smallfont">Monedas:&nbsp;
                        <asp:DropDownList ID="MonedasFilter_DropDownList"
                            runat="server"
                            ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.Moneda"
                            DataTextField="Descripcion"
                            DataValueField="Moneda1"
                            AutoPostBack="True"
                            CssClass="smallfont"
                            SelectMethod="Monedas_DropBox_GetData"
                            OnSelectedIndexChanged="AplicarMiniFiltro">
                        </asp:DropDownList>

                        &nbsp;&nbsp; 

                        Cuenta contable:&nbsp;
                        <asp:TextBox ID="CuentaContableFilter_TextBox"
                            runat="server"
                            CssClass="smallfont"
                            AutoPostBack="True"
                            OnTextChanged="AplicarMiniFiltro" />

                        &nbsp;&nbsp; 
                        Descripción de cuenta contable:&nbsp;
                        <asp:TextBox ID="CuentaContableDescripcionFilter_TextBox"
                            runat="server"
                            CssClass="smallfont"
                            AutoPostBack="True"
                            OnTextChanged="AplicarMiniFiltro" />
                    </span>

                            &nbsp;&nbsp; 

                    <span class="smallfont">(<b>10:</b> todo lo que contenga 10; <b>10*:</b> todo lo que comience por 10; <b>*10:</b> todo lo que termine en 10) 
                    </span>
                            &nbsp;
                        </td>
                    </tr>
                </table>

                <asp:ListView ID="BalanceComprobacion_ListView"
                    runat="server"
                    ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.Contab_BalanceComprobacion"
                    DataKeyNames="ID"
                    SelectMethod="BalanceComprobacion_ListView_GetData">

                    <LayoutTemplate>
                        <table id="Table1" runat="server">
                            <tr id="Tr1" runat="server">
                                <td id="Td1" runat="server">
                                    <table id="itemPlaceholderContainer" 
                                        runat="server" 
                                        border="0" 
                                        style="border: 1px solid #E6E6E6" 
                                        class="smallfont" 
                                        cellspacing="0" 
                                        rules="none">
                                        <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave">
                                            <th id="Th1" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; ">
                                                Cuenta<br />contable
                                            </th>
                                            <th id="Th2" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; ">
                                                Descripción
                                            </th>
                                            <th id="Th3" runat="server" class="padded" style="text-align: right; padding-bottom: 5px; padding-top: 5px; ">
                                                Saldo<br />anterior
                                            </th>
                                            <th id="Th4" runat="server" class="padded" style="text-align: right; padding-bottom: 5px; padding-top: 5px; ">
                                                Debe
                                            </th>
                                            <th id="Th5" runat="server" class="padded" style="text-align: right; padding-bottom: 5px; padding-top: 5px; ">
                                                Haber
                                            </th>
                                            <th id="Th8" runat="server" class="padded" style="text-align: right; padding-bottom: 5px; padding-top: 5px; ">
                                                Diferencia<br />(debe-haber)
                                            </th>
                                            <th id="Th6" runat="server" class="padded" style="text-align: right; padding-bottom: 5px; padding-top: 5px;">
                                                Saldo<br />actual
                                            </th>
                                            <th id="Th7" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; ">
                                                Cant<br />movtos
                                            </th>
                                        </tr>
                                        <tr id="itemPlaceholder" runat="server">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="Tr3" runat="server">
                                <td id="Td2" runat="server" style="" class="generalfont">
                                    <asp:DataPager ID="BalanceComprobacion_DataPager" runat="server" PageSize="20">
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
                            <td class="padded" style="text-align: left; white-space: nowrap;">
                                <a href="javascript:PopupWin('BalanceComprobacion_MovimientosContables.aspx?cta=' + <%# Item.CuentaContableID %> + '&mon=' + <%# Item.Moneda %> + '&cia=' + <%# Item.CuentasContable.Cia %>, 1000, 680)">
                                    <%# Item.CuentasContable.Cuenta %>
                                </a>
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label1" runat="server" Text='<%# Item.CuentasContable.Descripcion %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label2" runat="server" Text='<%# Item.SaldoAnterior != null ? Item.SaldoAnterior.Value.ToString("N2") : "" %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Item.Debe != null ? Item.Debe.Value.ToString("N2") : "" %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label4" runat="server" Text='<%# Item.Haber != null ? Item.Haber.Value.ToString("N2") : "" %>' />
                            </td>

                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label7" runat="server" 
                                           Text='<%# (Item.Debe != null && Item.Haber != null) ? (Item.Debe.Value - Item.Haber.Value).ToString("N2") : "" %>' />
                            </td>

                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label5" runat="server" Text='<%# Item.SaldoActual != null ? Item.SaldoActual.Value.ToString("N2") : "" %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="Label6" runat="server" Text='<%# Item.CantidadMovimientos != null ? Item.CantidadMovimientos.Value.ToString() : "" %>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr style="" class="ListViewAlternatingRow">
                            <td class="padded" style="text-align: left; white-space: nowrap;">
                                <a href="javascript:PopupWin('BalanceComprobacion_MovimientosContables.aspx?cta=' + <%# Item.CuentaContableID %> + '&mon=' + <%# Item.Moneda %> + '&cia=' + <%# Item.CuentasContable.Cia %>, 1000, 680)">
                                    <%# Item.CuentasContable.Cuenta %>
                                </a>
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label1" runat="server" Text='<%# Item.CuentasContable.Descripcion %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label2" runat="server" Text='<%# Item.SaldoAnterior != null ? Item.SaldoAnterior.Value.ToString("N2") : "" %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Item.Debe != null ? Item.Debe.Value.ToString("N2") : "" %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label4" runat="server" Text='<%# Item.Haber != null ? Item.Haber.Value.ToString("N2") : "" %>' />
                            </td>

                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label7" runat="server" 
                                           Text='<%# (Item.Debe != null && Item.Haber != null) ? (Item.Debe.Value - Item.Haber.Value).ToString("N2") : "" %>' />
                            </td>

                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label5" runat="server" Text='<%# Item.SaldoActual != null ? Item.SaldoActual.Value.ToString("N2") : "" %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="Label6" runat="server" Text='<%# Item.CantidadMovimientos != null ? Item.CantidadMovimientos.Value.ToString() : "" %>' />
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <EmptyDataTemplate>
                        <table id="Table2" runat="server" style="">
                            <tr>
                                <td>
                                    <br />
                                    Aplique un filtro para seleccionar información.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>

            </ContentTemplate>

            <%--como tenemos ChildrenAsTriggers en el UpdatePanel en False, tenemos que agregar cada control que deba refrescar el panel aquí ... --%>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="CompaniasFilter_DropDownList" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="MonedasFilter_DropDownList" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="CuentaContableFilter_TextBox" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="CuentaContableDescripcionFilter_TextBox" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="BalanceComprobacion_ListView" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="BalanceComprobacion_ListView" EventName="PagePropertiesChanged" />
            </Triggers>

        </asp:UpdatePanel>
    </div>
   
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
 <br />
</asp:Content>
