<%@ Page Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" CodeBehind="CuentasYMovimientos.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Cuentas_y_movimientos.CuentasYMovimientos" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" runat="Server">
    <%--  --%>
    <%-- para abrir un popup  --%>
    <%--  --%>
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
                window.document.forms(0).submit();--%>

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

    <%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
    <span id="Span1">
        <%-- clientIdMode 'static' para que el id permanezca hasta el cliente (browser) --%>
        <asp:HiddenField ID="RebindPage_HiddenField" runat="server" Value="0" ClientIDMode="Static" />
        <asp:HiddenField ID="ExecuteThread_HiddenField" runat="server" Value="0" ClientIDMode="Static" />
        <%--<asp:HiddenField id="RebindPage_HiddenField" runat="server" value="0" />--%>
        <asp:HiddenField ID="SelectedRecs_HiddenField" runat="server" Value="0" />
    </span>

    <%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
    <span id="RebindFlagSpan">
        <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" />
    </span>

    <%--  --%>
    <%-- div en la izquierda para mostrar funciones de la página --%>
    <%--  --%>

    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top; background-color: #F7F7F7; float: left; text-align: center;">
        <br />
        <br />

        <a href="javascript:PopupWin('CuentasYMovimientos_Filter.aspx', 1200, 680)">Definir y aplicar<br />un filtro</a><br />
        <i class="fas fa-filter fa-2x" style="margin-top: 5px;"></i>

        <hr />

        <%-- divs para mostrar el progress bar --%>
        <div id="Progressbar_div" style="visibility: hidden; height: 0px;">
            <div id="ProgressbarBorder_div" style="margin-left: 5px; margin-right: 5px; border: 1px solid #808080; height: 10px;">
                <div id="ProgressbarProgress_div" style="background: url(../../../Pictures/safari.gif) 0% 0% repeat-x; height: 8px; width: 0%;">
                </div>
            </div>
            <div id="ProgressbarMessage_div" style="text-align: center;">
            </div>
            <hr />
        </div>
        <%-- --------------------------------- --%>

        <a href="javascript:PopupWin('CuentasYMovimientos_OpcionesReportes.aspx', 1000, 680)">Reporte</a><br />
        <i class="fas fa-print fa-2x" style="margin-top: 5px;"></i>

        <hr />

        <a href="javascript:PopupWin('../../UltimoMesCerradoContable.aspx', 1000, 680)">Fechas de último<br /> cierre contable</a><br />
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px;"></i>

        <hr />
        <br />
    </div>

    <div style="text-align: left; float: right; width: 88%;">
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

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

                <table>
                    <tr>
                        <td style="vertical-align: top;">
                            <asp:ListView ID="CuentasContables_ListView"
                                runat="server"
                                ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.Contab_ConsultaCuentasYMovimientos"
                                DataKeyNames="ID"
                                OnPagePropertiesChanged="CuentasContables_ListView_PagePropertiesChanged"
                                OnSelectedIndexChanged="CuentasContables_ListView_SelectedIndexChanged"
                                SelectMethod="CuentasContables_ListView_GetData">
                                <LayoutTemplate>
                                    <table id="Table1" runat="server" style="border: 1px solid #E6E6E6">

                                        <tr id="Tr1" runat="server">
                                            <td id="Td1" runat="server">
                                                <table id="itemPlaceholderContainer" runat="server" border="0" class="ListView smallfont"
                                                    style="background-color: #FFFFFF; padding: 10 5 10 5; border-collapse: collapse; border-color: #999999; border-style: none; border-width: 1px;">
                                                    <tr id="Tr2" runat="server" style="" class="ListViewHeader smallfont">
                                                        <th id="Th1" runat="server" class="padded" style="text-align: left; margin-bottom: 10px;"></th>
                                                        <th id="Th11" runat="server" class="padded" style="text-align: left; margin-bottom: 10px;">Cuenta<br />
                                                            contable
                                                        </th>
                                                        <th id="Th2" runat="server" class="padded" style="text-align: left; margin-bottom: 10px;">Descripción
                                                        </th>
                                                        <th id="Th3" runat="server" class="padded" style="text-align: center; margin-bottom: 10px;">Mon
                                                        </th>
                                                        <th id="Th12" runat="server" class="padded" style="text-align: center; margin-bottom: 10px;">Cant<br />
                                                            mvtos
                                                        </th>
                                                    </tr>
                                                    <tr id="Tr3" runat="server" style="height: 5px;">
                                                        <th></th>
                                                        <th></th>
                                                        <th></th>
                                                        <th></th>
                                                    </tr>
                                                    <tr id="itemPlaceholder" runat="server">
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr id="Tr4" runat="server" class="generalfont">
                                            <td id="Td2" runat="server" style="">
                                                <asp:DataPager ID="CuentasContables_DataPager" runat="server" PageSize="20">
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
                                        <td class="padded">
                                            <asp:ImageButton ID="SelectItems_Button" runat="server" AlternateText="***" CommandName="Select"
                                                ImageUrl="~/Pictures/arrow_right_13x11.png" ToolTip="Click para mostrar los movimientos de la cuenta" />
                                        </td>
                                        <td class="padded" style="text-align: left; white-space: nowrap;">
                                            <asp:Label ID="CuentaLabel" runat="server" Text='<%# Item.CuentasContable.CuentaEditada %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Item.CuentasContable.Descripcion %>' />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Compania_ContabLabel" runat="server" Text='<%# Item.Moneda1.Simbolo %>' />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Label5" runat="server" Text='<%# Item.CantMovtos.ToString() %>' />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr style="" class="smallfont ListViewAlternatingRow">
                                        <td class="padded">
                                            <asp:ImageButton ID="SelectItems_Button" runat="server" AlternateText="***" CommandName="Select"
                                                ImageUrl="~/Pictures/arrow_right_13x11.png" ToolTip="Click para mostrar los movimientos de la cuenta" />
                                        </td>
                                        <td class="padded" style="text-align: left; white-space: nowrap;">
                                            <asp:Label ID="CuentaLabel" runat="server" Text='<%# Item.CuentasContable.CuentaEditada %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Item.CuentasContable.Descripcion %>' />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Compania_ContabLabel" runat="server" Text='<%# Item.Moneda1.Simbolo %>' />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Label5" runat="server" Text='<%# Item.CantMovtos.ToString() %>' />
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <SelectedItemTemplate>
                                    <tr class="smallfont ListViewSelectedRow">
                                        <td class="padded"></td>
                                        <td class="padded" style="text-align: left; white-space: nowrap;">
                                            <asp:Label ID="CuentaLabel" runat="server" Text='<%# Item.CuentasContable.CuentaEditada %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Item.CuentasContable.Descripcion %>' />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Compania_ContabLabel" runat="server" Text='<%# Item.Moneda1.Simbolo %>' />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Label5" runat="server" Text='<%# Item.CantMovtos.ToString() %>' />
                                        </td>
                                    </tr>
                                </SelectedItemTemplate>
                                <EmptyDataTemplate>
                                    <table id="Table2" runat="server" style="">
                                        <tr>
                                            <td>Aplique un filtro para mostrar información.
                                            </td>
                                        </tr>
                                    </table>
                                </EmptyDataTemplate>
                            </asp:ListView>
                        </td>
                        <td style="vertical-align: top;">
                            <asp:ListView ID="CuentasContables_Movimientos_ListView"
                                runat="server"
                                DataSourceID="CuentasContables_Movimientos_SqlDataSource">
                                <LayoutTemplate>
                                    <table id="Table3" runat="server" style="border: 1px solid #E6E6E6">
                                        <tr id="Tr5" runat="server">
                                            <td id="Td3" runat="server">
                                                <table id="itemPlaceholderContainer" runat="server" border="0" class="ListView smallfont"
                                                    style="background-color: #FFFFFF; padding: 10px 5px 10px 5px; border-collapse: collapse; border-color: #999999; border-style: none; border-width: 1px;">
                                                    <tr id="Tr6" runat="server" style="" class="ListViewHeader smallfont">
                                                        <th id="Th5" runat="server" class="padded" style="text-align: center;">Comp</th>
                                                        <th id="Th6" runat="server" class="padded" style="text-align: center;">Fecha</th>
                                                        <th id="Th7" runat="server" class="padded" style="text-align: center;">Centro<br />Costo</th>
                                                        <th id="Th8" runat="server" class="padded" style="text-align: center;">Mon<br />orig</th>
                                                        <th id="Th10" runat="server" class="padded" style="text-align: left;">Descripción</th>
                                                        <th id="Th9" runat="server" class="padded" style="text-align: right;">Monto</th>
                                                        <th id="Th17" runat="server" class="padded" style="text-align: center;">Cant<br />uploads</th>
                                                    </tr>
                                                    <tr id="Tr1" runat="server" style="height: 5px;">
                                                        <th></th>
                                                        <th></th>
                                                        <th></th>
                                                        <th></th>
                                                        <th></th>
                                                        <th></th>
                                                        <th></th>
                                                    </tr>
                                                    <tr id="itemPlaceholder" runat="server">
                                                    </tr>

                                                    <tr id="Tr8" runat="server" style="" class="ListViewFooter smallfont">
                                                        <th id="Th4" runat="server" class="padded" style="text-align: center;"></th>
                                                        <th id="Th13" runat="server" class="padded" style="text-align: center;"></th>
                                                        <th id="Th14" runat="server" class="padded" style="text-align: center;"></th>
                                                        <th id="Th15" runat="server" class="padded" style="text-align: center;"></th>
                                                        <th id="Th16" runat="server" class="padded" style="text-align: left;">Saldo final de la cuenta contable:</th>
                                                        <th id="SumOfMonto" runat="server" class="padded" style="text-align: right;">
                                                            <asp:Label ID="SumOfMonto_Label" runat="server" Text="Label"></asp:Label>
                                                        </th>
                                                        <th id="Th18" runat="server" class="padded" style="text-align: center;"></th>
                                                    </tr>

                                                </table>
                                            </td>
                                        </tr>
                                        <tr id="Tr7" runat="server" class="generalfont">
                                            <td id="Td4" runat="server" style="">
                                                <asp:DataPager ID="CuentasContables_Movimientos_DataPager" runat="server" PageSize="25">
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
                                            <a href="javascript:PopupWin('CuentasYMovimientos_Comprobantes.aspx?NumeroAutomatico=' + <%# Eval("NumeroAutomatico") %>, 1000, 680)">
                                                <%# Eval("Comprobante")%></a>
                                        </td>
                                        <td class="padded" style="text-align: center; white-space: nowrap;">
                                            <asp:Label ID="Compania_ContabLabel" runat="server" Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("NombreCentroCosto") %>' />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Label2" runat="server" Text='<%# Eval("SimboloMonedaOriginal") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label4" runat="server" Text='<%# Eval("Descripcion") %>' />
                                        </td>
                                        <td class="padded" style="text-align: right; white-space: nowrap;">
                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: right; white-space: nowrap;">
                                            <asp:Label ID="Label7" runat="server" Text='<%# Eval("NumLinks", "{0:#}") %>' />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr style="" class="smallfont ListViewAlternatingRow">
                                        <td class="padded" style="text-align: center;">
                                            <a href="javascript:PopupWin('CuentasYMovimientos_Comprobantes.aspx?NumeroAutomatico=' + <%# Eval("NumeroAutomatico") %>, 1000, 680)">
                                                <%# Eval("Comprobante")%></a>
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Compania_ContabLabel" runat="server" Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("NombreCentroCosto") %>' />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:Label ID="Label2" runat="server" Text='<%# Eval("SimboloMonedaOriginal") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label4" runat="server" Text='<%# Eval("Descripcion") %>' />
                                        </td>
                                        <td class="padded" style="text-align: right; white-space: nowrap;">
                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: right; white-space: nowrap;">
                                            <asp:Label ID="Label7" runat="server" Text='<%# Eval("NumLinks", "{0:#}") %>' />
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <EmptyDataTemplate>
                                    <table id="Table4" runat="server" style="">
                                        <tr>
                                            <td></td>
                                        </tr>
                                    </table>
                                </EmptyDataTemplate>
                            </asp:ListView>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>

            <%--como tenemos ChildrenAsTriggers en el UpdatePanel en False, tenemos que agregar cada control que deba refrescar el panel aquí ... --%>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="CompaniasFilter_DropDownList" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="MonedasFilter_DropDownList" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="CuentaContableFilter_TextBox" EventName="TextChanged" />

                <asp:AsyncPostBackTrigger ControlID="CuentaContableDescripcionFilter_TextBox" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="CuentasContables_ListView" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="CuentasContables_ListView" EventName="PagePropertiesChanged" />

                <asp:AsyncPostBackTrigger ControlID="CuentasContables_Movimientos_ListView" EventName="PagePropertiesChanged" />
            </Triggers>
        </asp:UpdatePanel>

        <asp:SqlDataSource ID="CuentasContables_Movimientos_SqlDataSource"
            runat="server"
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="Select Asientos.Numero As Comprobante,
                Asientos.NumeroAutomatico,  
                Asientos.Fecha, 
                CentrosCosto.DescripcionCorta AS NombreCentroCosto, 
                Monedas.Simbolo AS SimboloMonedaOriginal, 
                Contab_ConsultaCuentasYMovimientos_Movimientos.Descripcion,
                Contab_ConsultaCuentasYMovimientos_Movimientos.Monto, 
                Count(Asientos_Documentos_Links.Id) as NumLinks
                FROM 
                Contab_ConsultaCuentasYMovimientos_Movimientos Inner Join Contab_ConsultaCuentasYMovimientos On 
                Contab_ConsultaCuentasYMovimientos_Movimientos.ParentID = Contab_ConsultaCuentasYMovimientos.ID 
                Left Outer Join Asientos On Contab_ConsultaCuentasYMovimientos_Movimientos.AsientoID = Asientos.NumeroAutomatico
                Left Outer Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico And 
                Contab_ConsultaCuentasYMovimientos_Movimientos.Partida = dAsientos.Partida
                Left Outer JOIN Monedas ON Asientos.MonedaOriginal = Monedas.Moneda 
                LEFT OUTER JOIN CentrosCosto ON dAsientos.CentroCosto = CentrosCosto.CentroCosto
                LEFT OUTER JOIN Asientos_Documentos_Links ON Contab_ConsultaCuentasYMovimientos_Movimientos.AsientoID = Asientos_Documentos_Links.NumeroAutomatico 
                WHERE (Contab_ConsultaCuentasYMovimientos_Movimientos.ParentID = @ParentID) 
                Group by Contab_ConsultaCuentasYMovimientos_Movimientos.Secuencia, Asientos.Numero, Asientos.NumeroAutomatico, Asientos.Fecha, 
                CentrosCosto.DescripcionCorta, Monedas.Simbolo, Contab_ConsultaCuentasYMovimientos_Movimientos.Descripcion, 
                Contab_ConsultaCuentasYMovimientos_Movimientos.Monto 
                Order By Contab_ConsultaCuentasYMovimientos_Movimientos.Secuencia 
                ">

            <SelectParameters>
                <asp:Parameter Name="ParentID" />
            </SelectParameters>
        </asp:SqlDataSource>

    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>