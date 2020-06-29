<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true"
    Inherits="Contab_Presupuesto_Consultas_Mensual_ConsultaPresupuesto" CodeBehind="ConsultaPresupuesto.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" runat="Server">

    <%--<script type="text/javascript">
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
                       NavigateUrl="javascript:PopupWin('../../../../ReportViewer2.aspx?rpt=ptoconsmes', 1000, 680)">
            Reporte
        </asp:HyperLink><br />
        <i class="fas fa-print fa-2x" style="margin-top: 5px; "></i>

        <br /><br />
        Cant niveles:<br />
        <asp:DropDownList ID="CantNiveles_DropDownList"
            runat="server"
            AutoPostBack="True"
            Font-Names="Tahoma"
            Font-Size="10px">
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

        <asp:LinkButton ID="AplicarFactorConversion_LinkButton"
                        runat="server" 
                        OnClick="AplicarFactorConversion_LinkButton_Click">
                Conversión de cifras de presupuesto usando factores de conversión registrados
        </asp:LinkButton><br /> 
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px; "></i>

        <br />
        <br />

        <%-- divs para mostrar el progress bar --%>
        <div id="Progressbar_div" style="visibility: hidden;">
            <hr />
            <div id="ProgressbarBorder_div" style="margin-left: 5px; margin-right: 5px; border: 1px solid #808080; height: 10px; text-align: left;">
                <div id="ProgressbarProgress_div" style="background: url(../../../../Pictures/safari.gif) 0% 0% repeat-x; height: 10px; width: 0%;">
                </div>
            </div>
            <div id="ProgressbarMessage_div" style="text-align: center;">
            </div>
        </div>
        <%-- --------------------------------- --%>
    </div>

    <%-- div en la derecha para mostrar el contenido regular de la página  --%>
    <div style="text-align: left; float: right; width: 88%;">

        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" clientidmode="Static"
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
                    DataKeyNames="CiaContab,Moneda,AnoFiscal,MesCalendario,CodigoPresupuesto,NombreUsuario"
                    DataSourceID="ConsultaPresupuesto_LinqDataSource">
                    <LayoutTemplate>
                        <table runat="server">
                            <tr runat="server">
                                <td runat="server">
                                    <table id="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                                        class="notsosmallfont" cellspacing="0" rules="none">

                                        <tr runat="server" style="" class="ListViewHeader">
                                            <th runat="server" class="padded" style="border-width: 1px; border-color: #FFFFFF; text-align: center; padding-top: 4px; padding-bottom: 4px; border-right-style: solid;" colspan="2">Cuenta de presupuesto</th>
                                            <th runat="server" class="padded" style="border-width: 1px; border-color: #FFFFFF; text-align: center; padding-top: 4px; padding-bottom: 4px; border-right-style: solid;"></th>
                                            <th runat="server" class="padded" style="border-width: 1px; border-color: #FFFFFF; text-align: center; padding-top: 4px; padding-bottom: 4px; border-right-style: solid;" colspan="3">Cifras del mes</th>
                                            <th runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px;" colspan="3">Cifras acumuladas</th>
                                        </tr>

                                        <tr runat="server" style="" class="ListViewHeader_Suave">
                                            <th runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px;">Código</th>
                                            <th runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px;">Descripción</th>
                                            <th runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px;">Factor de<br />
                                                conversión</th>
                                            <th runat="server" class="padded" style="text-align: right; padding-top: 4px; padding-bottom: 4px;">Estimado</th>
                                            <th runat="server" class="padded" style="text-align: right; padding-top: 4px; padding-bottom: 4px;">Ejecutado</th>
                                            <th runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px;">Variación</th>
                                            <th runat="server" class="padded" style="text-align: right; padding-top: 4px; padding-bottom: 4px;">Estimado</th>
                                            <th runat="server" class="padded" style="text-align: right; padding-top: 4px; padding-bottom: 4px;">Ejecutado</th>
                                            <th runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px;">Variación</th>
                                        </tr>
                                        <tr id="itemPlaceholder" runat="server">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr runat="server">
                                <td runat="server" style="">
                                    <asp:DataPager ID="DataPager1" runat="server" PageSize="20">
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
                            <td class="padded" style="text-align: left;">
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Fix_URL(Eval("CiaContab").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("Presupuesto_Codigo.Descripcion").ToString()) %>'>
                                <%# Eval("CodigoPresupuesto")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label6" runat="server" Text='<%# Eval("Presupuesto_Codigo.Descripcion") %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("FactorConversion", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label01" runat="server" Text='<%# Eval("MontoEstimado", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# Fix_URL2(Eval("MesFiscal").ToString(), Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("Presupuesto_Codigo.Descripcion").ToString()) %>'>
                                <%# Eval("MontoEjecutado", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("Variacion", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("MontoEstimadoAcum", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl='<%# Fix_URL3(Eval("MesFiscal").ToString(), Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("Presupuesto_Codigo.Descripcion").ToString()) %>'>
                                <%# Eval("MontoEjecutadoAcum", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("VariacionAcum", "{0:N1}") %>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr style="" class="ListViewAlternatingRow">
                            <td class="padded" style="text-align: left;">
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Fix_URL(Eval("CiaContab").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("Presupuesto_Codigo.Descripcion").ToString()) %>'>
                                <%# Eval("CodigoPresupuesto")%>
                                </asp:HyperLink>
                            </td>

                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label6" runat="server" Text='<%# Eval("Presupuesto_Codigo.Descripcion") %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("FactorConversion", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label01" runat="server" Text='<%# Eval("MontoEstimado", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# Fix_URL2(Eval("MesFiscal").ToString(), Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("Presupuesto_Codigo.Descripcion").ToString()) %>'>
                                <%# Eval("MontoEjecutado", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("Variacion", "{0:N1}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("MontoEstimadoAcum", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl='<%# Fix_URL3(Eval("MesFiscal").ToString(), Eval("AnoFiscal").ToString(), Eval("CiaContab").ToString(), Eval("Moneda").ToString(), Eval("CodigoPresupuesto").ToString(), Eval("Presupuesto_Codigo.Descripcion").ToString()) %>'>
                                <%# Eval("MontoEjecutadoAcum", "{0:N0}")%>
                                </asp:HyperLink>
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("VariacionAcum", "{0:N1}") %>' />
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
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
                    EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="Monedas_DropDownList"
                    EventName="SelectedIndexChanged" />
            </Triggers>
        </asp:UpdatePanel>

        <asp:LinqDataSource ID="ConsultaPresupuesto_LinqDataSource" runat="server"
            ContextTypeName="ContabSysNet_Web.ModelosDatos.dbContabDataContext"
            TableName="tTempWebReport_PresupuestoConsultaMensuals"
            Where="NombreUsuario == @NombreUsuario &amp;&amp; CiaContab == @CiaContab &amp;&amp; Moneda == @Moneda">
            <WhereParameters>
                <asp:Parameter Name="NombreUsuario" Type="String" DefaultValue="xyz" />
                <asp:Parameter DefaultValue="-99" Name="CiaContab" Type="Int32" />
                <asp:Parameter DefaultValue="-99" Name="Moneda" Type="Int32" />
            </WhereParameters>
        </asp:LinqDataSource>

        <asp:SqlDataSource ID="CiasContab_SqlDataSource" runat="server"
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT tTempWebReport_PresupuestoConsultaMensual.CiaContab, Companias.Nombre FROM tTempWebReport_PresupuestoConsultaMensual INNER JOIN Companias ON tTempWebReport_PresupuestoConsultaMensual.CiaContab = Companias.Numero WHERE (tTempWebReport_PresupuestoConsultaMensual.NombreUsuario = @NombreUsuario) ORDER BY Companias.Nombre">
            <SelectParameters>
                <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server"
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT tTempWebReport_PresupuestoConsultaMensual.Moneda, Monedas.Descripcion FROM tTempWebReport_PresupuestoConsultaMensual INNER JOIN Monedas ON tTempWebReport_PresupuestoConsultaMensual.Moneda = Monedas.Moneda WHERE (tTempWebReport_PresupuestoConsultaMensual.NombreUsuario = @NombreUsuario) ORDER BY Monedas.Descripcion">
            <SelectParameters>
                <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
            </SelectParameters>
        </asp:SqlDataSource>









        <%--Comentamos el jquery dialog ...--%>
        <%-- <p><a href="#" id="dialog-link" class="ui-state-default ui-corner-all"><span class="ui-icon ui-icon-newwin"></span>Open Dialog</a></p>
        <div id="dialog" title="Debbuging help for this page ... " style="max-height: 600px; overflow: auto; ">
        </div>

        <script type="text/javascript">
            $("#dialog").dialog({
                autoOpen: false,
                width: 400,
                buttons: [
                    {
                        text: "Ok",
                        click: function () {
                            $(this).dialog("close");
                        }
                    },
                    {
                        text: "Cancel",
                        click: function () {
                            $(this).dialog("close");
                        }
                    }
                ]
            });


            $("#dialog-link").click(function (event) {
                $("#dialog").dialog("open");
                event.preventDefault();
            });
        </script>--%>


        <%-- function y div para mostrar el progress bar --%>
        <script type="text/javascript">

            function showprogress() {
                $('#dialog').append('<p> showprogress() </p>');

                document.getElementById("Progressbar_div").style.visibility = "visible";
                //document.getElementById("Progressbar_div").style.height = "";
                showprogress_continue();
            }
            function showprogress_continue() {
                // nótese como, simplemente, ejecutamos el web service y pasamos la función (SucceededCallback) 
                // que regresa con los resultados del WS en forma 'directa'.

                $('#dialog').append('<p> showprogress_continue() </p>');

                // nótese como pasamos el nombre del proceso al ws, para que construya el nombre del archivo al cual se escriben los valores (json)
                // del proceso (background) ejecutado 

                ContabSysNet_Web.MostrarProgreso_1.GetProgressPercentaje("Presupuesto_ConsultaMensual_",
                    function (Result) {    // callback cuando el ws se ejecuta correctamente ... 
                        //debugger;
                        $('#dialog').append('<p> GetProgressPercentaje() Progress_Completed: ' + Result.Progress_Completed +
                            '; Progress_Percentage: ' + Result.Progress_Percentage + ';  ' +
                            'Progress_SelectedRecs: ' + Result.Progress_SelectedRecs + ';   ' +
                            'Progress_ErrorMessage: ' + Result.Progress_ErrorMessage +
                            '</p>');

                        // nótese que el web service puede regresar un mensaje de error que ocurrió durante la ejecución del proceso ... 
                        var errorMessage = Result.Progress_ErrorMessage;
                        if (errorMessage) {
                            $(function () {
                                $("#ErrMessage_Span").css("display", "block");
                                $("#ErrMessage_Span").html(errorMessage);
                                return;
                            });
                        }

                        // primero mostramos el progreso (%) 
                        var a = Result.Progress_Percentage;
                        if (!(a == null)) {
                            document.getElementById("ProgressbarProgress_div").style.width = a + "%";
                            document.getElementById("ProgressbarMessage_div").textContent = a + "%";
                        }
                        // si el proceso no se ha completado, volvemos a ejecutar el web service
                        var b = Result.Progress_Completed;
                        var c = Result.Progress_SelectedRecs;
                        if (!(b == 1)) {
                            setTimeout("showprogress_continue()", 1000);
                        }
                        else {
                            // cuando la tarea termina, hacemos un refresh de la página para que se muestren los datos 
                            // seleccionados en el grid
                            // window.document.forms(0).submit();
                            // intentamos mostrar la cantidad de registros seleccionados

                            $("#ProgressbarMessage_div").text(c + " registros seleccionados");
                            $("#ProgressbarBorder_div").css("display", "none");

                            if (!errorMessage) {
                                // solo refrescamos la página si no hay un error; de otra forma, mostramos el error y terminamos 
                                // nótese que RebindPage_HiddenField indica a la página, cuando se hace el submit, que debe terminar y mostrar 
                                // la lista (GridView, ...) con los registros que determinó el proceso. Si hubo un error, no queremos mostrar los datos, 
                                // solo el error ... 
                                $("#RebindPage_HiddenField").val("1");
                                window.document.forms(0).submit();
                            }

                            //document.getElementById("ProgressbarMessage_div").innerHTML = c + " registros seleccionados";
                            //document.getElementById("ProgressbarBorder_div").style.display = "none";
                            //// ponemos el item que sigue en 1 y hacemos un postback para que el código haga un 
                            //// DataBind de los controles que muestran la selección al usuario  
                        }
                    },
                // callback que se ejecuta cuando el ws falla en su ejecución 
                function (error) {
                    debugger;
                    var stackTrace = error.get_stackTrace();
                    var message = error.get_message();
                    var statusCode = error.get_statusCode();
                    var exceptionType = error.get_exceptionType();
                    var timedout = error.get_timedOut();

                    // Display the error.    
                    var errorMessageFromWebService =
                        "Stack Trace: " + stackTrace + "<br/>" +
                        "Service Error: " + message + "<br/>" +
                        "Status Code: " + statusCode + "<br/>" +
                        "Exception Type: " + exceptionType + "<br/>" +
                        "Timedout: " + timedout;

                    $("#ErrMessage_Span").css("display", "block");
                    $("#ErrMessage_Span").html(errorMessageFromWebService);
                    return;
                });
            }
            function showprogress_displayselectedrecs() {
                // para mostrar la cantidad de registros seleccionados luego que se aplica el filtro y 
                // se construye la selección de registros 
                document.getElementById("Progressbar_div").style.visibility = "visible";
                document.getElementById("Progressbar_div").style.height = "";
                // nótese como usamos Session("Progress_SelectedRecs") que trae un valor desde code behind
                document.getElementById("ProgressbarMessage_div").innerHTML = "... " + $("#SelectedRecs_HiddenField").val() + " registros seleccionados";
                document.getElementById("ProgressbarBorder_div").style.display = "none";
            }
        </script>

    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" runat="Server">
    <br />
</asp:Content>

