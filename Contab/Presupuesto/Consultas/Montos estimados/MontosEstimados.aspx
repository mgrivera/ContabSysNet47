<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Consultas_Montos_estimados_MontosEstimados" CodeBehind="MontosEstimados.aspx.cs" %>

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
            $("#RebindFlagHiddenField").val("1");
            $("form").submit();
        }
    </script>

    <%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
    <span id="RebindFlagSpan">
        <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" ClientIDMode="Static" />
    </span>

    <%--  --%>
    <%-- div en la izquierda para mostrar funciones de la página --%>
    <%--  --%>
    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top; background-color: #F7F7F7; float: left; text-align: center;">
        <br />
        <br />
        
        <a href="javascript:PopupWin('MontosEstimados_Filter.aspx', 1000, 680)">Definir y aplicar<br /> un filtro</a><br />
        <i class="fas fa-filter fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <asp:HyperLink ID="ControlPresupuesto_Reportes_HyperLink" 
                       runat="server" 
                       CssClass="generalfont"
                       NavigateUrl="javascript:PopupWin('../../../../ReportViewer2.aspx?rpt=ptomtosest', 1000, 680)">
            Reporte
        </asp:HyperLink><br />
        <i class="fas fa-print fa-2x" style="margin-top: 5px; "></i>

        <hr />

    </div>

    <%-- div en la derecha para mostrar el contenido regular de la página  --%>
    <div style="text-align: left; float: right; width: 88%;">

        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;"></span>

        <div style="margin-bottom: 5px;">
            &nbsp;&nbsp; 
            <span class="notsosmallfont">Compañías Contab:&nbsp;&nbsp;</span>
            <asp:DropDownList ID="CiasContab_DropDownList" runat="server"
                DataSourceID="CiasContab_SqlDataSource"
                DataTextField="NombreCorto" DataValueField="CiaContab" Font-Names="Tahoma" Font-Size="8pt"
                OnSelectedIndexChanged="CiasContab_DropDownList_SelectedIndexChanged" AutoPostBack="True">
            </asp:DropDownList>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
            <span class="notsosmallfont">Monedas:&nbsp;&nbsp;</span>
            <asp:DropDownList ID="Monedas_DropDownList" runat="server" DataSourceID="Monedas_SqlDataSource"
                DataTextField="Descripcion" DataValueField="Moneda" Font-Names="Tahoma" Font-Size="8pt"
                OnSelectedIndexChanged="Monedas_DropDownList_SelectedIndexChanged" AutoPostBack="True">
            </asp:DropDownList>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
            <span class="notsosmallfont">Años:&nbsp;&nbsp;</span>
            <asp:DropDownList ID="Anos_DropDownList" runat="server" DataSourceID="Anos_SqlDataSource"
                DataTextField="AnoFiscal" DataValueField="AnoFiscal" Font-Names="Tahoma" Font-Size="8pt"
                OnSelectedIndexChanged="Anos_DropDownList_SelectedIndexChanged" AutoPostBack="True">
            </asp:DropDownList>

            <asp:SqlDataSource ID="CiasContab_SqlDataSource" runat="server"
                ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                SelectCommand="SELECT DISTINCT tTempWebReport_PresupuestoConsultaMontosEstimados.CiaContab, Companias.NombreCorto FROM tTempWebReport_PresupuestoConsultaMontosEstimados INNER JOIN Companias ON tTempWebReport_PresupuestoConsultaMontosEstimados.CiaContab = Companias.Numero Where NombreUsuario = @NombreUsuario ORDER BY Companias.NombreCorto">
                <SelectParameters>
                    <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server"
                ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                SelectCommand="SELECT DISTINCT tTempWebReport_PresupuestoConsultaMontosEstimados.Moneda, Monedas.Descripcion FROM tTempWebReport_PresupuestoConsultaMontosEstimados INNER JOIN Monedas ON tTempWebReport_PresupuestoConsultaMontosEstimados.Moneda = Monedas.Moneda Where NombreUsuario = @NombreUsuario ORDER BY Monedas.Descripcion">
                <SelectParameters>
                    <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="Anos_SqlDataSource" runat="server"
                ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                SelectCommand="SELECT DISTINCT tTempWebReport_PresupuestoConsultaMontosEstimados.AnoFiscal FROM tTempWebReport_PresupuestoConsultaMontosEstimados Where NombreUsuario = @NombreUsuario ORDER BY tTempWebReport_PresupuestoConsultaMontosEstimados.AnoFiscal">
                <SelectParameters>
                    <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
                </SelectParameters>
            </asp:SqlDataSource>
        </div>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:ListView ID="MontosEstimados_ListView"
                    runat="server"
                    DataKeyNames="Moneda,CiaContab,AnoFiscal,CodigoPresupuesto,NombreUsuario"
                    DataSourceID="MontosEstimados_SqlDataSource"
                    OnPagePropertiesChanged="MontosEstimados_ListView_PagePropertiesChanged">
                    <LayoutTemplate>
                        <table runat="server">
                            <tr runat="server">
                                <td runat="server">
                                    <table id="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                                        class="smallfont" cellspacing="0" rules="none">

                                        <tr id="Tr0" runat="server" style="" class="ListViewHeader">
                                            <th id="Th15" runat="server" class="padded" style="border-width: 0px; border-color: #FFFFFF; text-align: center; padding-top: 4px; padding-bottom: 4px;" colspan="3">Cuenta de presupuesto</th>
                                            <th id="Th16" runat="server" class="padded" style="border-width: 1px; border-color: #FFFFFF; text-align: center; padding-top: 4px; padding-bottom: 4px; border-left-style: solid; border-right-style: solid;" colspan="12">Montos estimados para cada mes del año fiscal</th>
                                        </tr>

                                        <tr id="Tr1" runat="server" style="" class="ListViewHeader_Suave">
                                            <th id="Th0" runat="server" class="padded" style="text-align: center; padding-bottom: 8px; padding-top: 8px;"></th>
                                            <th id="Th1" runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px;">Código</th>
                                            <th id="Th2" runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px;">Descripción</th>
                                            <th id="Th3" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 01</th>
                                            <th id="Th4" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 02</th>
                                            <th id="Th5" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 03</th>
                                            <th id="Th6" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 04</th>
                                            <th id="Th7" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 05</th>
                                            <th id="Th8" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 06</th>
                                            <th id="Th9" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 07</th>
                                            <th id="Th10" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 08</th>
                                            <th id="Th11" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 09</th>
                                            <th id="Th12" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 10</th>
                                            <th id="Th13" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid;">Mes 11</th>
                                            <th id="Th14" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; border-width: 1px; border-color: #FFFFFF; border-left-style: solid; border-right-style: solid">Mes 12</th>
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
                                <asp:Label ID="Mes01_EstLabel" runat="server" Text='<%# Eval("Mes01_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes02_EstLabel" runat="server" Text='<%# Eval("Mes02_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes03_EstLabel" runat="server" Text='<%# Eval("Mes03_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes04_EstLabel" runat="server" Text='<%# Eval("Mes04_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes05_EstLabel" runat="server" Text='<%# Eval("Mes05_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes06_EstLabel" runat="server" Text='<%# Eval("Mes06_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("Mes07_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("Mes08_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label7" runat="server" Text='<%# Eval("Mes09_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label9" runat="server" Text='<%# Eval("Mes10_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label11" runat="server" Text='<%# Eval("Mes11_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label13" runat="server" Text='<%# Eval("Mes12_Est", "{0:N0}") %>' />
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
                                <asp:Label ID="Mes01_EstLabel" runat="server" Text='<%# Eval("Mes01_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes02_EstLabel" runat="server" Text='<%# Eval("Mes02_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes03_EstLabel" runat="server" Text='<%# Eval("Mes03_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes04_EstLabel" runat="server" Text='<%# Eval("Mes04_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes05_EstLabel" runat="server" Text='<%# Eval("Mes05_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes06_EstLabel" runat="server" Text='<%# Eval("Mes06_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("Mes07_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("Mes08_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label7" runat="server" Text='<%# Eval("Mes09_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label9" runat="server" Text='<%# Eval("Mes10_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label11" runat="server" Text='<%# Eval("Mes11_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label13" runat="server" Text='<%# Eval("Mes12_Est", "{0:N0}") %>' />
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
                                <asp:Label ID="Mes01_EstLabel" runat="server" Text='<%# Eval("Mes01_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes02_EstLabel" runat="server" Text='<%# Eval("Mes02_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes03_EstLabel" runat="server" Text='<%# Eval("Mes03_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes04_EstLabel" runat="server" Text='<%# Eval("Mes04_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes05_EstLabel" runat="server" Text='<%# Eval("Mes05_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Mes06_EstLabel" runat="server" Text='<%# Eval("Mes06_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("Mes07_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("Mes08_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label7" runat="server" Text='<%# Eval("Mes09_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label9" runat="server" Text='<%# Eval("Mes10_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label11" runat="server" Text='<%# Eval("Mes11_Est", "{0:N0}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="Label13" runat="server" Text='<%# Eval("Mes12_Est", "{0:N0}") %>' />
                            </td>
                        </tr>
                    </SelectedItemTemplate>
                    <EmptyDataTemplate>
                        <table runat="server" style="">
                            <tr>
                                <td>No data was returned.</td>
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
                <asp:AsyncPostBackTrigger ControlID="Anos_DropDownList"
                    EventName="TextChanged" />
            </Triggers>
        </asp:UpdatePanel>

        <asp:SqlDataSource ID="MontosEstimados_SqlDataSource" runat="server"
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT tTempWebReport_PresupuestoConsultaMontosEstimados.Moneda, Monedas.Descripcion AS NombreMoneda, Monedas.Simbolo AS SimboloMoneda, tTempWebReport_PresupuestoConsultaMontosEstimados.CiaContab, Companias.Nombre AS NombreCiaContab, tTempWebReport_PresupuestoConsultaMontosEstimados.AnoFiscal, tTempWebReport_PresupuestoConsultaMontosEstimados.CodigoPresupuesto, Presupuesto_Codigos.Descripcion AS NombreCodigoPresupuesto, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes01_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes02_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes03_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes04_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes05_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes06_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes07_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes08_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes09_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes10_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes11_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.Mes12_Est, tTempWebReport_PresupuestoConsultaMontosEstimados.NombreUsuario FROM tTempWebReport_PresupuestoConsultaMontosEstimados INNER JOIN Monedas ON tTempWebReport_PresupuestoConsultaMontosEstimados.Moneda = Monedas.Moneda INNER JOIN Companias ON tTempWebReport_PresupuestoConsultaMontosEstimados.CiaContab = Companias.Numero INNER JOIN Presupuesto_Codigos ON tTempWebReport_PresupuestoConsultaMontosEstimados.CiaContab = Presupuesto_Codigos.CiaContab AND tTempWebReport_PresupuestoConsultaMontosEstimados.CodigoPresupuesto = Presupuesto_Codigos.Codigo WHERE (tTempWebReport_PresupuestoConsultaMontosEstimados.CiaContab = @CiaContab) AND (tTempWebReport_PresupuestoConsultaMontosEstimados.Moneda = @Moneda) AND (tTempWebReport_PresupuestoConsultaMontosEstimados.AnoFiscal = @AnoFiscal) AND (tTempWebReport_PresupuestoConsultaMontosEstimados.NombreUsuario = @NombreUsuario)">
            <SelectParameters>
                <asp:Parameter DefaultValue="-999" Name="CiaContab" Type="Int32" />
                <asp:Parameter DefaultValue="-999" Name="Moneda" Type="Int32" />
                <asp:Parameter DefaultValue="-999" Name="AnoFiscal" Type="Int32" />
                <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>

    </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" runat="Server">
    <br />
</asp:Content>

