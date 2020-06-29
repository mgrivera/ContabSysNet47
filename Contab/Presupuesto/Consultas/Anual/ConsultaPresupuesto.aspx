<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Consultas_Anual_ConsultaPresupuesto" CodeBehind="ConsultaPresupuesto.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" runat="Server">

    <%--<script type="text/javascript">
    function PopupWin(url, w, h) {
        ///Parameters url=page to open, w=width, h=height
        window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
    }
     function RefreshPage() {
        window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
        window.document.forms(0).submit();
    }
</script>--%>

    <script src="<%= this.Page.ResolveUrl("~/Scripts/jquery/jquery-1.10.2.js") %>"></script>

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

    <asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
        <Services>
            <asp:ServiceReference Path="~/MostrarProgreso.asmx" />
        </Services>
    </asp:ScriptManagerProxy>

    <%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
    <span id="RebindFlagSpan">
        <asp:HiddenField ID="ExecuteThread_HiddenField" runat="server" Value="0" ClientIDMode="Static" />
        <asp:HiddenField ID="RebindPage_HiddenField" runat="server" Value="0" ClientIDMode="Static" />
        <asp:HiddenField ID="SelectedRecs_HiddenField" runat="server" Value="0" ClientIDMode="Static" />
    </span>

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
                    window.document.getElementById('<%=RebindPage_HiddenField.ClientID%>').value = "1";
            window.document.forms(0).submit();
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

    <%--  --%>
    <%-- div en la izquierda para mostrar funciones de la página --%>
    <%--  --%>
    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top; background-color: #F7F7F7; float: left; text-align: center;">
        
        <br />
        <br />

        <a href="javascript:PopupWin('ConsultaPresupuesto_Filtro.aspx', 1000, 680)">Definir y aplicar<br /> un filtro</a><br />
        <i class="fas fa-filter fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <asp:HyperLink ID="ControlPresupuesto_Reportes_HyperLink" 
                       runat="server" 
                       CssClass="generalfont"
                       NavigateUrl="javascript:PopupWin('../../../../ReportViewer2.aspx?rpt=ptoconsanual&conv=0', 1000, 680)">
            Reporte
        </asp:HyperLink><br />
        <i class="fas fa-print fa-2x" style="margin-top: 5px; "></i>

        <br /><br />

        Cant niveles:<br />
        <asp:DropDownList ID="CantNiveles_DropDownList"
            runat="server"
            AutoPostBack="True"
            Font-Names="Tahoma"
            Font-Size="9px">
            <asp:ListItem Selected="True" Text="---" Value="7" />
            <asp:ListItem Text="1" Value="1" />
            <asp:ListItem Text="2" Value="2" />
            <asp:ListItem Text="3" Value="3" />
            <asp:ListItem Text="4" Value="4" />
            <asp:ListItem Text="5" Value="5" />
            <asp:ListItem Text="6" Value="6" />
        </asp:DropDownList>

        <hr />

        <a href="javascript:PopupWin('../../../UltimoMesCerradoContable.aspx', 1000, 680)">Fechas de último<br /> cierre contable</a><br />
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px; "></i>

        <br />
        <hr />

        <asp:LinkButton ID="LinkButton1"
                        runat="server" 
                        OnClick="AplicarFactorConversion_LinkButton_Click">
                Conversión de cifras de presupuesto usando factores de conversión registrados
        </asp:LinkButton><br /> 
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px; "></i>

        <br />
        <br />

        <%-- divs para mostrar el progress bar --%>
        <div id="Progressbar_div" style="visibility: hidden; height: 0px;">
            <div id="ProgressbarBorder_div" style="margin-left: 5px; margin-right: 5px; border: 1px solid #808080; height: 10px; text-align: left;">
                <div id="ProgressbarProgress_div" style="background: url(../../../../Pictures/safari.gif) 0% 0% repeat-x; height: 10px; width: 0%;">
                </div>
            </div>
            <div id="ProgressbarMessage_div" style="text-align: center;">
            </div>
            <hr />
        </div>
        <%-- --------------------------------- --%>
    </div>

    <%-- div en la derecha para mostrar el contenido regular de la página  --%>
    <div style="text-align: left; float: right; width: 88%;">

        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;"></span>

        <h3 runat="server" id="TituloConsulta_H2"></h3>

        <div class="notsosmallfont">
            Compañías:&nbsp;&nbsp;
            <asp:DropDownList ID="CiasContab_DropDownList" runat="server"
                DataSourceID="CiasContab_SqlDataSource" DataTextField="Nombre"
                DataValueField="CiaContab" CssClass="notsosmallfont" AutoPostBack="True"
                OnSelectedIndexChanged="CiasContab_DropDownList_SelectedIndexChanged">
            </asp:DropDownList>

            &nbsp;&nbsp;&nbsp;&nbsp;Monedas:&nbsp;&nbsp;
            <asp:DropDownList ID="Monedas_DropDownList" runat="server"
                DataSourceID="Monedas_SqlDataSource" DataTextField="Descripcion"
                DataValueField="Moneda" CssClass="notsosmallfont" AutoPostBack="True"
                OnSelectedIndexChanged="Monedas_DropDownList_SelectedIndexChanged">
            </asp:DropDownList>
        </div>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:ListView ID="ConsultaPresupuesto_ListView"
                    runat="server"
                    DataKeyNames="CiaContab,Moneda,AnoFiscal,CodigoPresupuesto,NombreUsuario"
                    DataSourceID="ConsultaPresupuesto_SqlDataSource">
                    <LayoutTemplate>
                        <table runat="server">
                            <tr runat="server">
                                <td runat="server">
                                    <table id="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                                        class="smallfont" cellspacing="0" rules="none">

                                        <tr id="Tr1" runat="server" style="" class="ListViewHeader">
                                            <th id="Th13" runat="server" class="padded" style="border-width: 0px; border-color: #FFFFFF; text-align: center; padding-top: 4px; padding-bottom: 4px;" colspan="3">Cuenta de presupuesto</th>
                                            <th id="Th14" runat="server" class="padded" style="border-width: 1px; border-color: #FFFFFF; text-align: center; padding-top: 4px; padding-bottom: 4px; border-left-style: solid; border-right-style: solid;" colspan="24">Montos ejecutados (y porcentajes de ejecución) para cada mes fiscal</th>
                                            <th id="Th15" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px;" colspan="3">Totales</th>
                                        </tr>

                                        <tr runat="server" style="" class="ListViewHeader_Suave">
                                            <th id="Th0" runat="server" class="padded" style="text-align: center; padding-bottom: 8px; padding-top: 8px;"></th>
                                            <th runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px;">Código</th>
                                            <th runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px;">Descripción</th>
                                            <th id="Mes01_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 01</th>
                                            <th id="Mes02_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 02</th>
                                            <th id="Mes03_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 03</th>
                                            <th id="Mes04_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 04</th>
                                            <th id="Mes05_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 05</th>
                                            <th id="Mes06_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 06</th>
                                            <th id="Mes07_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 07</th>
                                            <th id="Mes08_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 08</th>
                                            <th id="Mes09_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 09</th>
                                            <th id="Mes10_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 10</th>
                                            <th id="Mes11_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 11</th>
                                            <th id="Mes12_th" runat="server" colspan="2" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid; border-right-style: solid">Mes 12</th>
                                            <th runat="server" class="padded" style="text-align: right; padding-top: 4px; padding-bottom: 4px;">Ejecutado</th>
                                            <th runat="server" class="padded" style="text-align: right; padding-top: 4px; padding-bottom: 4px;">Presupuestado</th>
                                            <th runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px;">%</th>
                                        </tr>
                                        <tr id="itemPlaceholder" runat="server">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr runat="server">
                                <td runat="server" style="">
                                    <asp:DataPager ID="DataPager1" runat="server" PageSize="16">
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
                        <tr style="">
                            <td style="text-align: center;">
                                <asp:ImageButton ID="Select_ImageButton" runat="server" Text="Select"
                                    CommandName="Select" ImageUrl="~/Pictures/ListView_Buttons/select1.gif" />
                            </td>
                            <td class="padded" style="text-align: left; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Fix_URL(Eval("CiaContab").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("CodigoPresupuesto")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreCodigoPresupuestoLabel" runat="server"
                                    Text='<%# Eval("NombreCodigoPresupuesto") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# Fix_URL2("01", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes01_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes01_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes01_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl='<%# Fix_URL2("02", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes02_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes02_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes02_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl='<%# Fix_URL2("03", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes03_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes03_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes03_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl='<%# Fix_URL2("04", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes04_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes04_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes04_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink6" runat="server" NavigateUrl='<%# Fix_URL2("05", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes05_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes05_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes05_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink7" runat="server" NavigateUrl='<%# Fix_URL2("06", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes06_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes06_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes06_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink8" runat="server" NavigateUrl='<%# Fix_URL2("07", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes07_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes07_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes07_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink9" runat="server" NavigateUrl='<%# Fix_URL2("08", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes08_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes08_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes08_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink10" runat="server" NavigateUrl='<%# Fix_URL2("09", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes09_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes09_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes09_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink11" runat="server" NavigateUrl='<%# Fix_URL2("10", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes10_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes10_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes10_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink12" runat="server" NavigateUrl='<%# Fix_URL2("11", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes11_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes11_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes11_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink13" runat="server" NavigateUrl='<%# Fix_URL2("12", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes12_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes12_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes12_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink14" runat="server" NavigateUrl='<%# Fix_URL3("12", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("TotalEjecutado", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="TotalPresupuestadoLabel" runat="server"
                                    Text='<%# Eval("TotalPresupuestado", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="VariacionLabel" runat="server" Text='<%# Eval("Variacion", "{0:N1}") %>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr style="" class="ListViewAlternatingRow">
                            <td style="text-align: center;">
                                <asp:ImageButton ID="Select_ImageButton" runat="server" Text="Select"
                                    CommandName="Select" ImageUrl="~/Pictures/ListView_Buttons/select1.gif" />
                            </td>
                            <td class="padded" style="text-align: left; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Fix_URL(Eval("CiaContab").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("CodigoPresupuesto")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreCodigoPresupuestoLabel" runat="server"
                                    Text='<%# Eval("NombreCodigoPresupuesto") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# Fix_URL2("01", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes01_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes01_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes01_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl='<%# Fix_URL2("02", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes02_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes02_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes02_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl='<%# Fix_URL2("03", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes03_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes03_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes03_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl='<%# Fix_URL2("04", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes04_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes04_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes04_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink6" runat="server" NavigateUrl='<%# Fix_URL2("05", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes05_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes05_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes05_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink7" runat="server" NavigateUrl='<%# Fix_URL2("06", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes06_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes06_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes06_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink8" runat="server" NavigateUrl='<%# Fix_URL2("07", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes07_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes07_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes07_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink9" runat="server" NavigateUrl='<%# Fix_URL2("08", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes08_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes08_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes08_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink10" runat="server" NavigateUrl='<%# Fix_URL2("09", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes09_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes09_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes09_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink11" runat="server" NavigateUrl='<%# Fix_URL2("10", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes10_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes10_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes10_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink12" runat="server" NavigateUrl='<%# Fix_URL2("11", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes11_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes11_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes11_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink13" runat="server" NavigateUrl='<%# Fix_URL2("12", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes12_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes12_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes12_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink14" runat="server" NavigateUrl='<%# Fix_URL3("12", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("TotalEjecutado", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="TotalPresupuestadoLabel" runat="server"
                                    Text='<%# Eval("TotalPresupuestado", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="VariacionLabel" runat="server" Text='<%# Eval("Variacion", "{0:N1}") %>' />
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <SelectedItemTemplate>
                        <tr style="" class="ListViewSelectedRow">
                            <td style="text-align: center;">
                                <asp:ImageButton ID="Select_ImageButton" runat="server" Text="Select"
                                    CommandName="Select" ImageUrl="~/Pictures/ListView_Buttons/selected1.gif" />
                            </td>
                            <td class="padded" style="text-align: left; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Fix_URL(Eval("CiaContab").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("CodigoPresupuesto")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreCodigoPresupuestoLabel" runat="server"
                                    Text='<%# Eval("NombreCodigoPresupuesto") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# Fix_URL2("01", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes01_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes01_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes01_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl='<%# Fix_URL2("02", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes02_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes02_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes02_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl='<%# Fix_URL2("03", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes03_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes03_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes03_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl='<%# Fix_URL2("04", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes04_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes04_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes04_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink6" runat="server" NavigateUrl='<%# Fix_URL2("05", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes05_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes05_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes05_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink7" runat="server" NavigateUrl='<%# Fix_URL2("06", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes06_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes06_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes06_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink8" runat="server" NavigateUrl='<%# Fix_URL2("07", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes07_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes07_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes07_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink9" runat="server" NavigateUrl='<%# Fix_URL2("08", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes08_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes08_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes08_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink10" runat="server" NavigateUrl='<%# Fix_URL2("09", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes09_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes09_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes09_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink11" runat="server" NavigateUrl='<%# Fix_URL2("10", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes10_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes10_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes10_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink12" runat="server" NavigateUrl='<%# Fix_URL2("11", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes11_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes11_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes11_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink13" runat="server" NavigateUrl='<%# Fix_URL2("12", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("Mes12_Eje", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Mes12_Eje_PorcLabel" runat="server"
                                    Text='<%# Eval("Mes12_Eje_Porc", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:HyperLink ID="HyperLink14" runat="server" NavigateUrl='<%# Fix_URL3("12", Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("NombreCodigoPresupuesto").ToString()) %>'>
                            <%# Eval("TotalEjecutado", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="TotalPresupuestadoLabel" runat="server"
                                    Text='<%# Eval("TotalPresupuestado", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="VariacionLabel" runat="server" Text='<%# Eval("Variacion", "{0:N1}") %>' />
                            </td>
                        </tr>
                    </SelectedItemTemplate>
                    <EmptyDataTemplate>
                        <table runat="server" style="">
                            <tr>
                                <td>Defina y aplique un filtro para leer y mostrar información.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="CiasContab_DropDownList"
                    EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="Monedas_DropDownList"
                    EventName="TextChanged" />
            </Triggers>
        </asp:UpdatePanel>

        <asp:SqlDataSource ID="ConsultaPresupuesto_SqlDataSource" runat="server"
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT tTempWebReport_PresupuestoConsultaAnual.CiaContab, tTempWebReport_PresupuestoConsultaAnual.Moneda, tTempWebReport_PresupuestoConsultaAnual.AnoFiscal, tTempWebReport_PresupuestoConsultaAnual.CodigoPresupuesto, Presupuesto_Codigos.Descripcion AS NombreCodigoPresupuesto, tTempWebReport_PresupuestoConsultaAnual.Mes01_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes01_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes02_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes02_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes03_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes03_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes04_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes04_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes05_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes05_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes06_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes06_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes07_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes07_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes08_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes08_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes09_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes09_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes10_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes10_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes11_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes11_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.Mes12_Eje, tTempWebReport_PresupuestoConsultaAnual.Mes12_Eje_Porc, tTempWebReport_PresupuestoConsultaAnual.TotalEjecutado, tTempWebReport_PresupuestoConsultaAnual.TotalPresupuestado, tTempWebReport_PresupuestoConsultaAnual.Variacion, tTempWebReport_PresupuestoConsultaAnual.NombreUsuario FROM Presupuesto_Codigos RIGHT OUTER JOIN tTempWebReport_PresupuestoConsultaAnual ON Presupuesto_Codigos.CiaContab = tTempWebReport_PresupuestoConsultaAnual.CiaContab AND Presupuesto_Codigos.Codigo = tTempWebReport_PresupuestoConsultaAnual.CodigoPresupuesto WHERE (tTempWebReport_PresupuestoConsultaAnual.CiaContab = @CiaContab) AND (tTempWebReport_PresupuestoConsultaAnual.Moneda = @Moneda) AND (tTempWebReport_PresupuestoConsultaAnual.NombreUsuario = @NombreUsuario)">
            <SelectParameters>
                <asp:Parameter DefaultValue="-999" Name="CiaContab" Type="Int32" />
                <asp:Parameter DefaultValue="-999" Name="Moneda" Type="Int32" />
                <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>


        <asp:SqlDataSource ID="CiasContab_SqlDataSource" runat="server"
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT tTempWebReport_PresupuestoConsultaAnual.CiaContab, Companias.Nombre FROM tTempWebReport_PresupuestoConsultaAnual INNER JOIN Companias ON tTempWebReport_PresupuestoConsultaAnual.CiaContab = Companias.Numero WHERE (tTempWebReport_PresupuestoConsultaAnual.NombreUsuario = @NombreUsuario) ORDER BY Companias.Nombre">
            <SelectParameters>
                <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server"
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT tTempWebReport_PresupuestoConsultaAnual.Moneda, Monedas.Descripcion FROM tTempWebReport_PresupuestoConsultaAnual INNER JOIN Monedas ON tTempWebReport_PresupuestoConsultaAnual.Moneda = Monedas.Moneda WHERE (tTempWebReport_PresupuestoConsultaAnual.NombreUsuario = @NombreUsuario) ORDER BY Monedas.Descripcion">
            <SelectParameters>
                <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
            </SelectParameters>
        </asp:SqlDataSource>

    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" runat="Server">
    <br />
</asp:Content>

