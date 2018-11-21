<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" Inherits="Bancos_Disponibilidad_en_bancos_Disponibilidad_MontosRestringidos" CodeBehind="MontosRestringidos.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" runat="Server">

    <script src="<%= this.Page.ResolveUrl("~/Scripts/jquery/jquery-1.10.2.js") %>"></script>

    <script type="text/javascript">
        function PopupWin(url, w, h) {
            ///Parameters url=page to open, w=width, h=height
            window.open(url, "external2", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
        }
        function RefreshPage() {
            // nótese como usamos jquery para asignar el valor al field ... 
            $("#RebindFlagHiddenField").val("1");
            $("form").submit();
        }
    </script>

    <%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
    <span id="RebindFlagSpan">
        <%-- clientIdMode 'static' para que el id permanezca hasta el cliente (browser) --%>
        <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" ClientIDMode="Static" />
    </span>

    <%--  --%>
    <%-- div en la izquierda para mostrar funciones de la página --%>
    <%--  --%>
    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top; background-color: #F7F7F7; float: left; text-align: center;">
        <br />
        <br />
        <img id="Filter_img" alt="Para definir y aplicar un filtro para seleccionar la información que desea consultar."
            runat="server" src="~/Pictures/filter_16x16.gif" />
        <a href="javascript:PopupWin('MontosRestringidos_Filter.aspx', 1000, 680)">Definir
            y aplicar un filtro</a>
        <hr />

        <img id="Img1" runat="server" alt="Reporte" src="~/Pictures/print_16x16.gif" />
        <asp:HyperLink ID="HyperLink1" runat="server" CssClass="generalfont"
            NavigateUrl="javascript:PopupWin('MontosRestringidos_ReportViewer.aspx', 1000, 680)">Reporte de montos restringidos</asp:HyperLink>
        <br />
        <br />
    </div>

    <div style="text-align: left; float: right; width: 88%;">
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;"></span>

        <cc1:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0">
            <cc1:TabPanel ID="TabPanel1" runat="server" HeaderText="Lista" TabIndex="0">
                <HeaderTemplate>
                    Lista
                </HeaderTemplate>
                <ContentTemplate>
                    <h5>Lista de montos restringidos</h5>

                    <asp:ListView ID="MontosRestringidos_Lista_ListView" runat="server"
                        DataKeyNames="ID"
                        DataSourceID="MontosRestringidos_Lista_SqlDataSource"
                        OnPagePropertiesChanged="MontosRestringidos_Lista_ListView_PagePropertiesChanged"
                        OnSelectedIndexChanged="MontosRestringidos_Lista_ListView_SelectedIndexChanged"
                        OnSorted="MontosRestringidos_Lista_ListView_Sorted">

                        <LayoutTemplate>
                            <table runat="server">
                                <tr runat="server">
                                    <td runat="server" style="">
                                        <table id="itemPlaceholderContainer" runat="server" border="0" cellspacing="0"
                                            class="notsosmallfont" rules="none" style="border: 1px solid #E6E6E6">
                                            <tr runat="server" class="ListViewHeader_Suave" style="">
                                                <th id="Th1" runat="server" class="padded" style="text-align: center; padding-bottom: 8px; padding-top: 8px;"></th>
                                                <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                    <asp:LinkButton ID="LinkButton2" runat="server"
                                                        CommandArgument="NombreCiaContab" CommandName="Sort"
                                                        CssClass="ListViewColHeader">Compañía</asp:LinkButton>
                                                </th>
                                                <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px; padding-top: 8px;">
                                                    <asp:LinkButton ID="LinkButton3" runat="server" CommandArgument="SimboloMoneda"
                                                        CommandName="Sort" CssClass="ListViewColHeader">Mon</asp:LinkButton>
                                                </th>
                                                <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                    <asp:LinkButton ID="LinkButton4" runat="server"
                                                        CommandArgument="NombreCuentaBancaria" CommandName="Sort"
                                                        CssClass="ListViewColHeader">Cuenta</asp:LinkButton>
                                                </th>
                                                <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                    <asp:LinkButton ID="LinkButton5" runat="server" CommandArgument="NombreBanco"
                                                        CommandName="Sort" CssClass="ListViewColHeader">Banco</asp:LinkButton>
                                                </th>
                                                <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px; padding-top: 8px;">
                                                    <asp:LinkButton ID="LinkButton6" runat="server" CommandArgument="Fecha"
                                                        CommandName="Sort" CssClass="ListViewColHeader">Fecha</asp:LinkButton>
                                                </th>
                                                <th runat="server" class="padded" style="text-align: right; padding-bottom: 8px; padding-top: 8px;">
                                                    <asp:LinkButton runat="server" CommandArgument="Monto" CommandName="Sort"
                                                        CssClass="ListViewColHeader">Monto</asp:LinkButton>
                                                </th>
                                                <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px; padding-top: 8px;">Susp
                                                </th>
                                                <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px; padding-top: 8px;">Desactivar
                                                </th>
                                            </tr>
                                            <tr id="itemPlaceholder" runat="server">
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr runat="server">
                                    <td runat="server">
                                        <asp:DataPager ID="DataPager1" runat="server">
                                            <Fields>
                                                <asp:NextPreviousPagerField ButtonType="Image"
                                                    FirstPageImageUrl="~/Pictures/ListView_Buttons/PgFirst.gif"
                                                    FirstPageText="&lt;&lt;" NextPageText="&gt;"
                                                    PreviousPageImageUrl="~/Pictures/ListView_Buttons/PgPrev.gif"
                                                    PreviousPageText="&lt;" ShowFirstPageButton="True" ShowNextPageButton="False"
                                                    ShowPreviousPageButton="True" />
                                                <asp:NumericPagerField />
                                                <asp:NextPreviousPagerField ButtonType="Image"
                                                    LastPageImageUrl="~/Pictures/ListView_Buttons/PgLast.gif"
                                                    LastPageText="&gt;&gt;"
                                                    NextPageImageUrl="~/Pictures/ListView_Buttons/PgNext.gif" NextPageText="&gt;"
                                                    PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True"
                                                    ShowPreviousPageButton="False" />
                                            </Fields>
                                        </asp:DataPager>
                                    </td>
                                </tr>
                            </table>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <tr style="">
                                <td style="text-align: center;" class="padded">
                                    <asp:ImageButton ID="Select_ImageButton" runat="server" CommandName="Select"
                                        ImageUrl="~/Pictures/ListView_Buttons/select1.gif" Text="Select" />
                                </td>
                                <td class="padded" style="text-align: left;">
                                    <asp:Label ID="NombreCiaContabLabel" runat="server"
                                        Text='<%# Eval("NombreCiaContab") %>' />
                                </td>
                                <td style="text-align: center;">
                                    <asp:Label ID="SimboloMonedaLabel" runat="server"
                                        Text='<%# Eval("SimboloMoneda") %>' />
                                </td>
                                <td class="padded" style="text-align: left;">
                                    <asp:Label ID="NombreCuentaBancariaLabel" runat="server"
                                        Text='<%# Eval("NombreCuentaBancaria") %>' />
                                </td>
                                <td class="padded" style="text-align: left;">
                                    <asp:Label ID="NombreBancoLabel" runat="server"
                                        Text='<%# Eval("NombreBanco") %>' />
                                </td>
                                <td class="padded" style="text-align: center;">
                                    <asp:Label ID="FechaLabel" runat="server"
                                        Text='<%# Eval("Fecha", "{0:d-MMM-y}") %>' />
                                </td>
                                <td class="padded" style="text-align: right;">
                                    <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                                </td>
                                <td class="padded" style="text-align: center;">
                                    <asp:CheckBox ID="SuspendidoFlagCheckBox" runat="server"
                                        Checked='<%# Eval("SuspendidoFlag") %>' Enabled="false" />
                                </td>
                                <td class="padded" style="text-align: center;">
                                    <asp:Label ID="DesactivarElLabel" runat="server"
                                        Text='<%# Eval("DesactivarEl", "{0:d-MMM-y}") %>' />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <AlternatingItemTemplate>
                            <tr style="" class="ListViewAlternatingRow">
                                <td class="padded" style="text-align: center;">
                                    <asp:ImageButton ID="Select_ImageButton" runat="server" CommandName="Select"
                                        ImageUrl="~/Pictures/ListView_Buttons/select1.gif" Text="Select" />
                                </td>
                                <td class="padded" style="text-align: left;">
                                    <asp:Label ID="NombreCiaContabLabel" runat="server"
                                        Text='<%# Eval("NombreCiaContab") %>' />
                                </td>
                                <td style="text-align: center;">
                                    <asp:Label ID="SimboloMonedaLabel" runat="server"
                                        Text='<%# Eval("SimboloMoneda") %>' />
                                </td>
                                <td class="padded" style="text-align: left;">
                                    <asp:Label ID="NombreCuentaBancariaLabel" runat="server"
                                        Text='<%# Eval("NombreCuentaBancaria") %>' />
                                </td>
                                <td class="padded" style="text-align: left;">
                                    <asp:Label ID="NombreBancoLabel" runat="server"
                                        Text='<%# Eval("NombreBanco") %>' />
                                </td>
                                <td class="padded" style="text-align: center;">
                                    <asp:Label ID="FechaLabel" runat="server"
                                        Text='<%# Eval("Fecha", "{0:d-MMM-y}") %>' />
                                </td>
                                <td class="padded" style="text-align: right;">
                                    <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                                </td>
                                <td class="padded" style="text-align: center;">
                                    <asp:CheckBox ID="SuspendidoFlagCheckBox" runat="server"
                                        Checked='<%# Eval("SuspendidoFlag") %>' Enabled="false" />
                                </td>
                                <td class="padded" style="text-align: center;">
                                    <asp:Label ID="DesactivarElLabel" runat="server"
                                        Text='<%# Eval("DesactivarEl", "{0:d-MMM-y}") %>' />
                                </td>
                            </tr>
                        </AlternatingItemTemplate>
                        <SelectedItemTemplate>
                            <tr style="" class="ListViewSelectedRow">
                                <td style="text-align: center;" class="padded">
                                    <asp:ImageButton runat="server"
                                        ImageUrl="~/Pictures/ListView_Buttons/selected1.gif" />
                                </td>
                                <td class="padded" style="text-align: left;">
                                    <asp:Label ID="NombreCiaContabLabel" runat="server"
                                        Text='<%# Eval("NombreCiaContab") %>' />
                                </td>
                                <td style="text-align: center;">
                                    <asp:Label ID="SimboloMonedaLabel" runat="server"
                                        Text='<%# Eval("SimboloMoneda") %>' />
                                </td>
                                <td class="padded" style="text-align: left;">
                                    <asp:Label ID="NombreCuentaBancariaLabel" runat="server"
                                        Text='<%# Eval("NombreCuentaBancaria") %>' />
                                </td>
                                <td class="padded" style="text-align: left;">
                                    <asp:Label ID="NombreBancoLabel" runat="server"
                                        Text='<%# Eval("NombreBanco") %>' />
                                </td>
                                <td class="padded" style="text-align: center;">
                                    <asp:Label ID="FechaLabel" runat="server"
                                        Text='<%# Eval("Fecha", "{0:d-MMM-y}") %>' />
                                </td>
                                <td class="padded" style="text-align: right;">
                                    <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                                </td>
                                <td class="padded" style="text-align: center;">
                                    <asp:CheckBox ID="SuspendidoFlagCheckBox" runat="server"
                                        Checked='<%# Eval("SuspendidoFlag") %>' Enabled="false" />
                                </td>
                                <td class="padded" style="text-align: center;">
                                    <asp:Label ID="DesactivarElLabel" runat="server"
                                        Text='<%# Eval("DesactivarEl", "{0:d-MMM-y}") %>' />
                                </td>
                            </tr>
                        </SelectedItemTemplate>
                        <EmptyDataTemplate>
                            <table runat="server" style="">
                                <tr>
                                    <td>No existen registros - Defina y aplique un filtro para mostrar registros.</td>
                                </tr>
                            </table>
                        </EmptyDataTemplate>

                    </asp:ListView>

                    <asp:SqlDataSource ID="MontosRestringidos_Lista_SqlDataSource" runat="server"
                        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                        SelectCommand="SELECT Disponibilidad_MontosRestringidos.ID, Companias.NombreCorto AS NombreCiaContab, 
                            Monedas.Simbolo AS SimboloMoneda, 
                            CuentasBancarias.CuentaBancaria AS NombreCuentaBancaria,
                            Bancos.NombreCorto AS NombreBanco, 
                            Disponibilidad_MontosRestringidos.Fecha, 
                            Disponibilidad_MontosRestringidos.Monto, 
                            Disponibilidad_MontosRestringidos.SuspendidoFlag, 
                            Disponibilidad_MontosRestringidos.DesactivarEl 
                            FROM Disponibilidad_MontosRestringidos 
                            INNER JOIN CuentasBancarias ON Disponibilidad_MontosRestringidos.CuentaBancaria = CuentasBancarias.CuentaInterna 
                            INNER JOIN Companias ON CuentasBancarias.Cia = Companias.Numero 
                            Inner Join Agencias On CuentasBancarias.Agencia = Agencias.Agencia
                            INNER JOIN Bancos ON Agencias.Banco = Bancos.Banco 
                            INNER JOIN Monedas ON CuentasBancarias.Moneda = Monedas.Moneda"></asp:SqlDataSource>

                </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel ID="TabPanel2" runat="server" HeaderText="Registro" TabIndex="1">
                <ContentTemplate>
                    <h5>Registro y edición de montos restringidos</h5>

                    <asp:FormView ID="MontosRestringidos_FormView" runat="server" AllowPaging="True"
                        DataKeyNames="ID"
                        DataSourceID="MontosRestringidos_SqlDataSource"
                        OnItemInserting="MontosRestringidos_FormView_ItemInserting"
                        OnItemCreated="MontosRestringidos_FormView_ItemCreated"
                        OnItemUpdating="MontosRestringidos_FormView_ItemUpdating"
                        OnItemDeleted="MontosRestringidos_FormView_ItemDeleted"
                        OnItemInserted="MontosRestringidos_FormView_ItemInserted"
                        OnItemUpdated="MontosRestringidos_FormView_ItemUpdated">

                        <ItemTemplate>
                            <table style="border: 1px solid #7798DD; width: 100%; background-color: #F7F9FD;" cellspacing="15px" class="notsosmallfont">
                                <tr>
                                    <td colspan="2">
                                        <span style="color: #000080; font-weight: bold">ID:</span>&nbsp;&nbsp;<%# Eval("ID") %>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="color: #000080; font-weight: bold">Compañía:</span>&nbsp;&nbsp;<%# Eval("NombreCiaContab") %>
                                    </td>
                                    <td>
                                        <span style="color: #000080; font-weight: bold">Moneda:</span>&nbsp;&nbsp;<%# Eval("NombreMoneda") %>
                                    </td>
                                    <td>
                                        <span style="color: #000080; font-weight: bold">Cuenta:</span>&nbsp;&nbsp;<%# Eval("NombreCuentaBancaria") %>&nbsp;&nbsp;
                                                                                                              <%# Eval("NombreBanco") %>
                                    </td>

                                </tr>
                                <tr>
                                    <td>
                                        <span style="color: #000080; font-weight: bold">Fecha:</span> &nbsp;&nbsp; <%# Eval("Fecha", "{0:dd-MMM-yyyy}") %>
                                    </td>
                                    <td>
                                        <span style="color: #000080; font-weight: bold">Monto:</span> &nbsp;&nbsp; <%# Eval("Monto", "{0:N2}") %>
                                    </td>
                                    <td>
                                        <span style="color: #000080; font-weight: bold">Suspendida:</span> &nbsp;&nbsp;
                                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("SuspendidoFlag") %>' Enabled="False" />
                                    </td>
                                </tr>
                                <tr style="vertical-align: top;">
                                    <td>
                                        <span style="color: #000080; font-weight: bold; white-space: nowrap;">Desactivar el:</span> &nbsp;&nbsp; <%# Eval("DesactivarEl", "{0:dd-MMM-yyyy}") %>
                                    </td>
                                    <td colspan="2">
                                        <span style="color: #000080; font-weight: bold">Observaciones:</span>
                                        <br />
                                        <%# Eval("Comentarios") %>
                               
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="color: #000080; font-weight: bold">Ingreso</span>
                                        <br />
                                        '<%# Eval("Registro_Fecha", "{0:dd-MMM-yyyy hh:mm tt}") %>'
                                      &nbsp;&nbsp; 
                                     '<%# Eval("Registro_Usuario") %>'
                                    </td>
                                    <td></td>
                                    <td>
                                        <span style="color: #000080; font-weight: bold">Ultima actualización</span>
                                        <br />
                                        '<%# Eval("UltAct_Fecha", "{0:dd-MMM-yyyy hh:mm tt}") %>'
                                      &nbsp;&nbsp; 
                                     '<%# Eval("UltAct_Usuario") %>'
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="3" style="background-color: #F9F9F9; border: 1px solid #C0C0C0; padding: 10px;">
                                        <asp:LinkButton ID="LinkButton0" runat="server" CommandName="New" Text="Nuevo" />
                                        &nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="LinkButton1" runat="server" CommandName="Edit" Text="Modificar" />
                                        &nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="LinkButton2" runat="server" CommandName="Delete" Text="Eliminar" />
                                    </td>
                                </tr>
                            </table>

                        </ItemTemplate>

                        <InsertItemTemplate>

                            <table style="border: 1px solid #7798DD; width: 100%; background-color: #F7F9FD;" cellspacing="15px" class="notsosmallfont">
                                <tr style="vertical-align: middle;">
                                    <td>Compañía:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="CiasContab_DropDownList" runat="server"
                                            AppendDataBoundItems="True" AutoPostBack="True"
                                            DataSourceID="CiasContab_SqlDataSource" DataTextField="NombreCorto"
                                            DataValueField="Numero"
                                            OnSelectedIndexChanged="CiaContab_DropDownList_SelectedIndexChanged"
                                            SelectedValue='<%# Bind("CiaContab") %>'>
                                            <asp:ListItem Selected="True" Text="" Value="0" />
                                        </asp:DropDownList>
                                    </td>
                                    <td>Moneda:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="Monedas_DropDownList" runat="server" AutoPostBack="True"
                                            DataSourceID="Monedas_SqlDataSource" DataTextField="Descripcion"
                                            DataValueField="Moneda" SelectedValue='<%# Bind("Moneda") %>' />
                                    </td>
                                    <td>Cuenta:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="Cuentas_DropDownList" runat="server"
                                            DataSourceID="Cuentas_SqlDataSource" DataTextField="CuentaBancariaMasBanco"
                                            DataValueField="CuentaInterna" />
                                    </td>
                                </tr>
                                <tr style="vertical-align: middle;">
                                    <td>Fecha:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="FechaTextBox" runat="server" Text='<%# Bind("Fecha") %>' />
                                        <cc1:CalendarExtender
                                            ID="FechaTextBox_CalendarExtender" runat="server" Enabled="True"
                                            Format="dd-MM-yy" CssClass="radcalendar"
                                            TargetControlID="FechaTextBox">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td style="white-space: nowrap;">Monto:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Monto") %>' />
                                    </td>
                                    <td style="white-space: nowrap;">Suspendida:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="SuspendidoFlagCheckBox" runat="server"
                                            Checked='<%# Bind("SuspendidoFlag") %>' />
                                    </td>
                                </tr>
                                <tr style="vertical-align: middle;">
                                    <td style="white-space: nowrap;">Desactivar el:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="DesactivarElTextBox" runat="server" Text='<%# Bind("DesactivarEl") %>' />
                                        <cc1:CalendarExtender
                                            ID="CalendarExtender1" runat="server" Enabled="True"
                                            Format="dd-MM-yy" CssClass="radcalendar"
                                            TargetControlID="DesactivarElTextBox">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td>Observaciones:<br />
                                    </td>
                                    <td colspan="3">
                                        <asp:TextBox ID="ComentariosTextBox" runat="server" Height="64px"
                                            Text='<%# Bind("Comentarios") %>' TextMode="MultiLine" Width="396px" />

                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True"
                                            CommandName="Insert" Text="Agregar" />
                                        &nbsp;&nbsp;&nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server"
                                            CausesValidation="False" CommandName="Cancel" Text="Cancelar" />
                                    </td>
                                </tr>
                            </table>

                            <asp:SqlDataSource ID="CiasContab_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                                SelectCommand="SELECT Numero, NombreCorto FROM Companias ORDER BY NombreCorto"></asp:SqlDataSource>
                            <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                                SelectCommand="SELECT Moneda, Descripcion FROM Monedas ORDER BY Descripcion"></asp:SqlDataSource>

                            <asp:SqlDataSource ID="Cuentas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                                SelectCommand="SELECT CuentasBancarias.CuentaInterna, CuentasBancarias.CuentaBancaria + N' - ' + Bancos.Abreviatura AS CuentaBancariaMasBanco FROM CuentasBancarias Inner Join Agencias On CuentasBancarias.Agencia = Agencias.Agencia INNER JOIN Bancos ON Agencias.Banco = Bancos.Banco WHERE (CuentasBancarias.Cia = @Cia) ORDER BY CuentasBancarias.CuentaBancaria + N' - ' + Bancos.NombreCorto">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="-999" Name="Cia" />
                                </SelectParameters>
                            </asp:SqlDataSource>

                        </InsertItemTemplate>

                        <EditItemTemplate>
                            <table style="border: 1px solid #7798DD; width: 100%; background-color: #F7F9FD;" cellspacing="15px" class="notsosmallfont">
                                <tr>
                                    <td style="color: #000080; font-weight: bold">ID:
                                    </td>
                                    <td colspan="5">
                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("ID") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Compañía:
                                    </td>
                                    <td>
                                        <asp:Label runat="server" Text='<%# Eval("NombreCiaContab") %>' />
                                    </td>
                                    <td>Moneda:
                                    </td>
                                    <td>
                                        <asp:Label runat="server" Text='<%# Eval("NombreMoneda") %>' />
                                    </td>
                                    <td>Cuenta:
                                    </td>
                                    <td>
                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("NombreCuentaBancaria") %>' />
                                        &nbsp;&nbsp;
                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("NombreBanco") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Fecha:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="FechaTextBox" runat="server" Text='<%# Bind("Fecha", "{0:dd-MM-yyyy}") %>' />
                                        <cc1:CalendarExtender
                                            ID="FechaTextBox_CalendarExtender" runat="server" Enabled="True"
                                            Format="dd-MM-yy" CssClass="radcalendar"
                                            TargetControlID="FechaTextBox">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td>Monto:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Monto") %>' />
                                    </td>
                                    <td>Suspendida:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="SuspendidoFlagCheckBox" runat="server"
                                            Checked='<%# Bind("SuspendidoFlag") %>' />
                                    </td>
                                </tr>
                                <tr style="vertical-align: top;">
                                    <td style="white-space: nowrap;">Desactivar el:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="DesactivarElTextBox" runat="server"
                                            Text='<%# Bind("DesactivarEl", "{0:dd-MMM-yyyy}") %>' />
                                    </td>
                                    <td>Observaciones:<br />
                                    </td>
                                    <td colspan="3">
                                        <asp:TextBox ID="ComentariosTextBox" runat="server" Height="64px"
                                            Text='<%# Bind("Comentarios") %>' TextMode="MultiLine" Width="396px" />

                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True"
                                            CommandName="Update" Text="Actualizar" />
                                        &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server"
                                            CausesValidation="False" CommandName="Cancel" Text="Cancelar" />
                                    </td>
                                </tr>
                            </table>

                        </EditItemTemplate>
                        <EmptyDataTemplate>
                            <asp:Button ID="Button1" runat="server" Text="Agregar un nuevo registro" CommandName="New" />
                        </EmptyDataTemplate>

                    </asp:FormView>

                    <asp:SqlDataSource ID="MontosRestringidos_SqlDataSource" runat="server"
                        OldValuesParameterFormatString="old_{0}"
                        ConflictDetection="CompareAllValues"
                        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                        SelectCommand="SELECT Disponibilidad_MontosRestringidos.ID, 
                    Disponibilidad_MontosRestringidos.Fecha, 
                    Disponibilidad_MontosRestringidos.Monto, 
                    Disponibilidad_MontosRestringidos.Comentarios, 
                    Disponibilidad_MontosRestringidos.SuspendidoFlag, 
                    Disponibilidad_MontosRestringidos.DesactivarEl, 
                    Disponibilidad_MontosRestringidos.Registro_Fecha, 
                    Disponibilidad_MontosRestringidos.Registro_Usuario, 
                    Disponibilidad_MontosRestringidos.UltAct_Fecha, 
                    Disponibilidad_MontosRestringidos.UltAct_Usuario, 
                    Companias.NombreCorto AS NombreCiaContab, 
                    Monedas.Descripcion AS NombreMoneda, 
                    CuentasBancarias.CuentaBancaria AS NombreCuentaBancaria, 
                    Bancos.Nombre As NombreBanco 
                    FROM Disponibilidad_MontosRestringidos 
                    INNER JOIN CuentasBancarias ON Disponibilidad_MontosRestringidos.CuentaBancaria = CuentasBancarias.CuentaInterna 
                    INNER JOIN Companias ON CuentasBancarias.Cia = Companias.Numero 
                    Inner Join Agencias On CuentasBancarias.Agencia = Agencias.Agencia
                    INNER JOIN Bancos ON Agencias.Banco = Bancos.Banco 
                    INNER JOIN Monedas ON CuentasBancarias.Moneda = Monedas.Moneda 
                    WHERE (Disponibilidad_MontosRestringidos.ID = @ID)"
                        InsertCommand="INSERT INTO Disponibilidad_MontosRestringidos(CuentaBancaria, Fecha, Monto, Comentarios, SuspendidoFlag, DesactivarEl, Registro_Fecha, Registro_Usuario, UltAct_Fecha, UltAct_Usuario) VALUES (@CuentaBancaria, @Fecha, @Monto, @Comentarios, @SuspendidoFlag, @DesactivarEl, @Registro_Fecha, @Registro_Usuario, @UltAct_Fecha, @UltAct_Usuario)"
                        UpdateCommand="UPDATE Disponibilidad_MontosRestringidos SET Fecha = @Fecha, Monto = @Monto, Comentarios = @Comentarios, SuspendidoFlag = @SuspendidoFlag, DesactivarEl = @DesactivarEl, UltAct_Fecha = @UltAct_Fecha , UltAct_Usuario = @UltAct_Usuario WHERE (ID = @old_ID)"
                        DeleteCommand="DELETE FROM Disponibilidad_MontosRestringidos WHERE (ID = @Old_ID)">

                        <SelectParameters>
                            <asp:Parameter DefaultValue="-999" Name="ID" />
                        </SelectParameters>
                        <DeleteParameters>
                            <asp:Parameter Name="ID" />
                        </DeleteParameters>
                        <UpdateParameters>
                            <asp:Parameter Name="Fecha" />
                            <asp:Parameter Name="Monto" />
                            <asp:Parameter Name="Comentarios" />
                            <asp:Parameter Name="SuspendidoFlag" />
                            <asp:Parameter Name="DesactivarEl" />
                            <asp:Parameter Name="UltAct_Fecha" />
                            <asp:Parameter Name="UltAct_Usuario" />
                            <asp:Parameter Name="old_ID" />
                        </UpdateParameters>
                        <InsertParameters>
                            <asp:Parameter Name="CuentaBancaria" />
                            <asp:Parameter Name="Fecha" />
                            <asp:Parameter Name="Monto" />
                            <asp:Parameter Name="Comentarios" />
                            <asp:Parameter Name="SuspendidoFlag" />
                            <asp:Parameter Name="DesactivarEl" />
                            <asp:Parameter Name="Registro_Fecha" />
                            <asp:Parameter Name="Registro_Usuario" />
                            <asp:Parameter Name="UltAct_Fecha" />
                            <asp:Parameter Name="UltAct_Usuario" />
                        </InsertParameters>
                    </asp:SqlDataSource>

                </ContentTemplate>
            </cc1:TabPanel>
        </cc1:TabContainer>

    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" runat="Server">
    <br />
</asp:Content>

