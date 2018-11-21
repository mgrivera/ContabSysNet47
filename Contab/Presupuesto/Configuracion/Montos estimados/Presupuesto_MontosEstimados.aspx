<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Configuracion_Montos_estimados_Presupuesto_MontosEstimados" Codebehind="Presupuesto_MontosEstimados.aspx.cs" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
    <Services>
        <asp:ServiceReference  Path="~/MostrarProgreso.asmx" />
    </Services>
</asp:ScriptManagerProxy>

<%--  para que la página sepa, cuando se refresca (postback), que lo hizo la función js --%>
<span id="RebindFlagSpan">
    <asp:HiddenField id="RebindPage_HiddenField" runat="server" value="0" />
</span>

<script type="text/javascript">
    function showprogress() {
        document.getElementById("Progressbar_div").style.visibility = "visible";
        // document.getElementById("Progressbar_div").style.height = ""; 

        showprogress_continue();
    }
    function showprogress_continue() {
        // nótese como, simplemente, ejecutamos el web service y pasamos la función (SucceededCallback) 
        // que regresa con los resultados del WS en forma 'directa'.
        MostrarProgreso.GetProgressPercentaje(function(Result) {
            // primero mostramos el progreso (%) 
            var a = Result.Progress_Percentage;
            if (!(a == null)) {
                document.getElementById("ProgressbarProgress_div").style.width = a + "%";
                document.getElementById("ProgressbarMessage_div").innerHTML = a + "%";
            }
            // si el proceso no se ha completado, volvemos a ejecutar el web service
            var b = Result.Progress_Completed;
            if (!(b == 1))
                setTimeout("showprogress_continue()", 1000);
            else {
                // la tarea terminó - escondemos (nuevamente) el progress bar y hacemos un refresh 
                document.getElementById("Progressbar_div").style.visibility = "hidden";
                window.document.getElementById('<%=RebindPage_HiddenField.ClientID%>').value = "1";
                window.document.forms(0).submit();
            }
        });
    }
</script>

<div style="text-align: left; ">

       <cc1:tabcontainer id="TabContainer1" runat="server" activetabindex="0">
            <cc1:TabPanel HeaderText="Montos estimados" runat="server" ID="TabPanel1">
                <ContentTemplate>
                    <div class="smallfont">
                        &nbsp;&nbsp;&nbsp;Cias Contab:&nbsp;&nbsp;
                        <asp:DropDownList ID="CiasContab_DropDownList" runat="server" DataSourceID="CiasContab0_SqlDataSource"
                            DataTextField="NombreCiaContab" DataValueField="CiaContab" 
                            CssClass="smallfont" 
                            onselectedindexchanged="CiasContab_DropDownList_SelectedIndexChanged" AutoPostBack="True">
                        </asp:DropDownList>
                        &nbsp;&nbsp;&nbsp;Monedas:&nbsp;&nbsp;
                        <asp:DropDownList ID="Monedas_DropDownList" runat="server" DataSourceID="Monedas0_SqlDataSource"
                            DataTextField="NombreMoneda" DataValueField="Moneda" CssClass="smallfont" 
                            onselectedindexchanged="Monedas_DropDownList_SelectedIndexChanged" AutoPostBack="True">
                        </asp:DropDownList>
                        &nbsp;&nbsp;&nbsp;Años:&nbsp;&nbsp; 
                        <asp:DropDownList ID="Anos_DropDownList" runat="server" DataSourceID="Anos_SqlDataSource"
                            DataTextField="Ano" DataValueField="Ano" CssClass="smallfont" 
                            onselectedindexchanged="Anos_DropDownList_SelectedIndexChanged" AutoPostBack="True">
                        </asp:DropDownList>
                        &nbsp;&nbsp;&nbsp;Código:&nbsp;&nbsp; 
                        <asp:TextBox ID="CodigoCuentaPresupuesto_TextBox" 
                            runat="server" 
                            CssClass="smallfont"
                            AutoPostBack="true" 
                            OnTextChanged="CodigoCuentaPresupuesto_TextBox_TextChanged" />
                    </div>
                   
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">

                        <ContentTemplate>
                            <span id="GeneralMessage_Span" runat="server" class="infomessage infomessage_background generalfont" style="display: block;" />
                            <span id="GeneralError_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

                            <asp:ListView ID="PresupuestoMontos_ListView" runat="server" 
                                DataKeyNames="CodigoPresupuesto,CiaContab,Moneda,Ano"
                                DataSourceID="Presupuesto_Montos_LinqDataSource" 
                                onitemupdating="PresupuestoMontos_ListView_ItemUpdating">
                                <LayoutTemplate>
                                    <table runat="server">
                                        <tr runat="server">
                                            <td runat="server">
                                                <table id="itemPlaceholderContainer" runat="server" style="border: 1px solid #E6E6E6"
                                                    class="smallfont" cellspacing="0" rules="none">
                                                    <tr runat="server" class="ListViewHeader_Suave" style="">
                                                        <th runat="server">
                                                        </th>
                                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                            Código
                                                        </th>
                                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                            Descripción
                                                        </th>
                                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                            Mes 01 / Mes 07
                                                        </th>
                                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                            Mes 02 / Mes 08
                                                        </th>
                                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                            Mes 03 / Mes 09
                                                        </th>
                                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                            Mes 04 / Mes 10
                                                        </th>
                                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                            Mes 05 / Mes 11
                                                        </th>
                                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                            Mes 06 / Mes 12
                                                        </th>
                                                    </tr>
                                                    <tr runat="server" id="itemPlaceholder">
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr runat="server">
                                            <td runat="server" style="">
                                                <asp:DataPager ID="DataPager1" runat="server">
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
                                        <td>
                                            <asp:ImageButton ID="Edit_Button" runat="server" CausesValidation="False" CommandName="Edit"
                                                ImageUrl="~/Pictures/ListView_Buttons/edit_14x14.png" Text="Edit" ToolTip="Editar" />
                                            <asp:ImageButton ID="Delete_Button" runat="server" CausesValidation="False" CommandName="Delete"
                                                ImageUrl="~/pictures/ListView_Buttons/delete_14x14.png" Text="Delete" ToolTip="Eliminar" />
                                            <cc1:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" ConfirmText="¿Desea eliminar el registro?"
                                                TargetControlID="Delete_Button">
                                            </cc1:ConfirmButtonExtender>
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:DynamicControl runat="server" DataField="CodigoPresupuesto" Mode="ReadOnly" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label13" runat="server" Text='<%#Eval("Presupuesto_Codigo.Descripcion") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label4" runat="server" Text='<%#Eval("Mes01_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label1" runat="server" Text='<%#Eval("Mes02_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label2" runat="server" Text='<%#Eval("Mes03_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label3" runat="server" Text='<%#Eval("Mes04_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label5" runat="server" Text='<%#Eval("Mes05_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label6" runat="server" Text='<%#Eval("Mes06_Est", "{0:N2}") %>' />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label7" runat="server" Text='<%#Eval("Mes07_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label8" runat="server" Text='<%#Eval("Mes08_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label9" runat="server" Text='<%#Eval("Mes09_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label10" runat="server" Text='<%#Eval("Mes10_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label11" runat="server" Text='<%#Eval("Mes11_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label12" runat="server" Text='<%#Eval("Mes12_Est", "{0:N2}") %>' />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr style="" class="ListViewAlternatingRow">
                                        <td>
                                            <asp:ImageButton ID="Edit_Button" runat="server" CausesValidation="False" CommandName="Edit"
                                                ImageUrl="~/Pictures/ListView_Buttons/edit_14x14.png" Text="Edit" ToolTip="Editar" />
                                            <asp:ImageButton ID="Delete_Button" runat="server" CausesValidation="False" CommandName="Delete"
                                                ImageUrl="~/pictures/ListView_Buttons/delete_14x14.png" Text="Delete" ToolTip="Eliminar" />
                                            <cc1:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" ConfirmText="¿Desea eliminar el registro?"
                                                TargetControlID="Delete_Button">
                                            </cc1:ConfirmButtonExtender>
                                        </td>
                                        <td class="padded" style="text-align: left; white-space: nowrap; ">
                                            <asp:DynamicControl ID="DynamicControl7" runat="server" DataField="CodigoPresupuesto" Mode="ReadOnly" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label13" runat="server" Text='<%#Eval("Presupuesto_Codigo.Descripcion") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label4" runat="server" Text='<%#Eval("Mes01_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label1" runat="server" Text='<%#Eval("Mes02_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label2" runat="server" Text='<%#Eval("Mes03_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label3" runat="server" Text='<%#Eval("Mes04_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label5" runat="server" Text='<%#Eval("Mes05_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label6" runat="server" Text='<%#Eval("Mes06_Est", "{0:N2}") %>' />
                                        </td>
                                    </tr>
                                    <tr class="ListViewAlternatingRow">
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label7" runat="server" Text='<%#Eval("Mes07_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label8" runat="server" Text='<%#Eval("Mes08_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label9" runat="server" Text='<%#Eval("Mes09_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label10" runat="server" Text='<%#Eval("Mes10_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label11" runat="server" Text='<%#Eval("Mes11_Est", "{0:N2}") %>' />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:Label ID="Label12" runat="server" Text='<%#Eval("Mes12_Est", "{0:N2}") %>' />
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <EditItemTemplate>
                                    <tr style="" class="smallfont">
                                        <td>
                                            <asp:ImageButton ID="Update_Button" runat="server" CommandName="Update" Text="Update"
                                                ImageUrl="~/pictures/ListView_Buttons/ok_14x14.png" ValidationGroup="EditValGroup"
                                                ToolTip="Actualizar" />
                                            <asp:ImageButton ID="Cancel_Button" runat="server" CommandName="Cancel" Text="Clear"
                                                ImageUrl="~/pictures/ListView_Buttons/undo1_14x14.png" CausesValidation="False"
                                                ToolTip="Cancelar" />
                                        </td>
                                        <td class="padded" style="text-align: left; white-space: nowrap; ">
                                            <asp:DynamicControl ID="DynamicControl7" runat="server" DataField="CodigoPresupuesto" Mode="ReadOnly" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox13" runat="server" Text='<%#Bind("Presupuesto_Codigo.Descripcion") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox4" runat="server" Text='<%#Bind("Mes01_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox1" runat="server" Text='<%#Bind("Mes02_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox2" runat="server" Text='<%#Bind("Mes03_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox3" runat="server" Text='<%#Bind("Mes04_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox5" runat="server" Text='<%#Bind("Mes05_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox6" runat="server" Text='<%#Bind("Mes06_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td />
                                        <td />
                                        <td />
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox14" runat="server" Text='<%#Bind("Mes07_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox15" runat="server" Text='<%#Bind("Mes08_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox16" runat="server" Text='<%#Bind("Mes09_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox17" runat="server" Text='<%#Bind("Mes10_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox18" runat="server" Text='<%#Bind("Mes11_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:TextBox ID="TextBox19" runat="server" Text='<%#Bind("Mes12_Est", "{0:N2}") %>' CssClass="smallfont" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td />
                                        <td />
                                        <td />
                                        <td colspan="6" style="color: #FF0000; padding: 15px; ">
                                            <p>(Si Ud. indica valores para algunos meses, pero deja otros en blanco, el valor indicado para un mes
                                             será tomado para los próximos que estén en blanco. </p>
                                             <p>Ejemplo: si inidca valores para Enero, Mayo y Octubre, y deja el resto de los meses en blanco, los meses
                                             Febrero, Marzo y Abril tomaran el valor indicado para Enero; <br />
                                             los meses Junio, Julio, Agosto y Septiembre tomarán 
                                             el valor indicado para Mayo y así sucesivamente.) </p>
                                        </td>
                                    </tr>
                                </EditItemTemplate>
                                <EmptyDataTemplate>
                                    <table runat="server" style="">
                                        <tr>
                                            <td style="color: blue; ">
                                                <br />
                                                No se seleccionaron registros; Ud. puede indicar un filtro diferente para corregir esta situación. 
                                            </td>
                                        </tr>
                                    </table>
                                </EmptyDataTemplate>
                            </asp:ListView>



                            <%--para mostrar un diálogo que permita al usuario continuar/cancelar--%>
                            <asp:Panel ID="pnlPopup" runat="server" CssClass="modalpopup" Style="display: none">
                                <div class="popup_container" style="max-width: 500px; min-width: 200px; ">
                                    <div class="popup_form_header" style="overflow: hidden;">
                                        <div id="ModalPopupTitle_div" style="width: 85%; margin-top: 5px; float: left;">
                                            <span runat="server" id="ModalPopupTitle_span" style="font-weight: bold;">
                                                Ajuste de montos estimados 
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
                                            <div runat="server" id="ModalPopupBody_div">
                                                <p>
                                                    Mediante este proceso, Ud. puede aumentar o disminuir los montos mensuales para
                                                    las cuentas de presupuesto seleccionadas en la lista, en el porcentaje que Ud. indique. 
                                                </p>
                                                <p>
                                                    Si Ud. indica un porcentaje negativo, los montos mensuales de las cuentas de presupuesto
                                                    seleccionadas, serán disminuídas en la proporción indicada. 
                                                </p>
                                                <hr />
                                                <p>
                                                    Aumentar (o disminuír) los montos mensuales de las cuentas seleccionadas en el porcentaje
                                                    que se indica ... 
                                                </p>
                                                <p>
                                                    <asp:TextBox ID="AjustarMontosMensuales_Porcentaje_TextBox" runat="server" />%
                                                </p>
                                            </div>
                                        </div>
                                        <div class="popup_form_footer">
                                            <asp:Button ID="AjustarMontosEstimados_btnOk" runat="server" 
                                                        Text="Continuar" 
                                                        OnClick="AjustarMontosEstimados_btnOk_Click" />
                                            <asp:Button ID="btnCancel" 
                                                        runat="server" 
                                                        Text="Cancelar" 
                                                        OnClientClick="$find('popup').hide(); return false;" 
                                                        Width="80px" />
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:LinkButton ID="AjustarMontos_LinkButton" runat="server">Ajustar montos estimados ...</asp:LinkButton>
                            <cc1:modalpopupextender id="ModalPopupExtender"
                                                    runat="server"
                                                    behaviorid="popup"
                                                    targetcontrolid="AjustarMontos_LinkButton"
                                                    popupcontrolid="pnlPopup"
                                                    backgroundcssclass="modalBackground"
                                                    popupdraghandlecontrolid="ModalPopupTitle_div"
                                                    drag="True" />








                            <%--para mostrar un diálogo que permita al usuario continuar/cancelar--%>
                            <asp:Panel ID="pnlPopup2" runat="server" CssClass="modalpopup" Style="display: none">
                                <div class="popup_container" style="max-width: 500px; min-width: 200px; ">
                                    <div class="popup_form_header" style="overflow: hidden;">
                                        <div id="ModalPopupTitle_div2" style="width: 85%; margin-top: 5px; float: left;">
                                            <span runat="server" id="ModalPopupTitle_span2" style="font-weight: bold;">
                                            </span>
                                        </div>
                                        <div style="width: 15%; float: right;">
                                            <asp:ImageButton ID="ImageButton2" 
                                                             runat="server" 
                                                             OnClientClick="$find('popup2').hide(); return false;" 
                                                             ImageUrl="~/Pictures/PopupCloseButton.png" />
                                        </div>
                                    </div>
                                    <div class="inner_container">
                                        <div class="popup_form_content">
                                            <span runat="server" id="ModalPopupBody_span2">
                                            </span>
                                        </div>
                                        <div class="popup_form_footer">
                                            <asp:Button ID="AjustarMontosEstimados_Confirmacion_Button" runat="server" 
                                                        Text="Continuar" 
                                                        OnClick="AjustarMontosEstimados_Confirmacion_Button_Click" />
                                            <asp:Button ID="AjustarMontosEstimados_Cancel_Button_Click" 
                                                        runat="server" 
                                                        Text="Cancelar" 
                                                        OnClientClick="$find('popup2').hide(); return false;" 
                                                        Width="80px" />
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>

                            <asp:HiddenField ID="HiddenField2" runat="server" />
                            <cc1:modalpopupextender id="ModalPopupExtender1"
                                                    runat="server"
                                                    behaviorid="popup2"
                                                    targetcontrolid="HiddenField2"
                                                    popupcontrolid="pnlPopup2"
                                                    backgroundcssclass="modalBackground"
                                                    popupdraghandlecontrolid="ModalPopupTitle_div2"
                                                    drag="True" />


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
                    
                </ContentTemplate>
            </cc1:TabPanel>
           <cc1:TabPanel HeaderText="Creación de registros para un año" runat="server" ID="TabPanel2">
               <ContentTemplate>
                           <div style="text-align: center;">
                          
                               <div style="width: 90%; text-align: left;" class="notsosmallfont">
                                   <h3>
                                       Creación de registros de montos estimados para un año de presupuesto</h3>
                                   <p>
                                       Este proceso le permite agregar registros para los códigos de presupuesto, en los
                                       cuales pueda registrar los montos estimados que corresponden a los distintos meses
                                       del año.
                                   </p>
                                   <p>
                                       Nótese que este proceso debe ser ejecutado con el comienzo de cada año, para que
                                       sus registros de montos estimados para los códigos de presupuesto que existen sean
                                       creados.
                                   </p>
                                   <p>
                                       En general, Ud. necesita un registro de montos estimados para cada código de presupuesto
                                       que exista para una compañía Contab. Además, cuando exista más de una moneda en
                                       el sistema, Ud. puede crear registros de montos estimados para cada código de presupuesto
                                       y moneda.
                                   </p>
                                   <p>
                                       Luego de haber creado los registros para un año en particular, Ud. debe editarlos
                                       para registrar los montos estimados que corresponden a cada mes.
                                   </p>
                                   <p>
                                       Cada vez que Ud. construya, mediante este proceso, los registros de montos para
                                       los códigos de presupuesto y un año particular, el proceso leerá y copiará, si existen,
                                       los registros y sus montos definidos para el año anterior. Si es necesario, Ud.
                                       podrá editar estos montos para cambiarlos.
                                   </p>
                                   <br />
                               </div>
                               <div class="notsosmallfont">
                                   <table cellspacing="0" cellpadding="0">
                                       <tr>
                                           <td>
                                               <div class="ListViewHeader_Suave" style="width: 200px;">
                                                   Compañías Contab
                                               </div>
                                           </td>
                                           <td>
                                               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                           </td>
                                           <td>
                                               <div class="ListViewHeader_Suave" style="width: 200px;">
                                                   Monedas
                                               </div>
                                           </td>
                                       </tr>
                                       <tr>
                                           <td>
                                               <asp:ListBox ID="CiasContab_ListBox" 
                                                            runat="server" 
                                                            DataSourceID="CiasContab_SqlDataSource"
                                                            DataTextField="NombreCorto" 
                                                            DataValueField="Numero" 
                                                            CssClass="notsosmallfont"
                                                            Rows="8" 
                                                            Width="200px">
                                               </asp:ListBox>

                                               <asp:RequiredFieldValidator ID="RequiredFieldValidator2" 
                                                                           runat="server" 
                                                                           ErrorMessage="Ud. debe seleccionar una compañía de la lista."
                                                                           Display="None" 
                                                                           ControlToValidate="CiasContab_ListBox" 
                                                                           ValidationGroup="CrearRegistros_ValGroup"
                                                                           Text="*"></asp:RequiredFieldValidator>
                                           </td>
                                           <td>
                                               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                           </td>
                                           <td>
                                               <asp:ListBox ID="Monedas_ListBox" 
                                                            runat="server" 
                                                            DataSourceID="Monedas_SqlDataSource"
                                                            DataTextField="Descripcion" 
                                                            DataValueField="Moneda" 
                                                            CssClass="notsosmallfont"
                                                            Rows="8" 
                                                            Width="200px">
                                               </asp:ListBox>

                                               <asp:RequiredFieldValidator ID="RequiredFieldValidator3" 
                                                                           runat="server" 
                                                                           ErrorMessage="Ud. debe seleccionar una moneda de la lista."
                                                                           Display="None" 
                                                                           ControlToValidate="Monedas_ListBox" 
                                                                           ValidationGroup="CrearRegistros_ValGroup"
                                                                           Text="*"></asp:RequiredFieldValidator>
                                           </td>
                                       </tr>
                                       <tr>
                                           <td colspan="3">
                                               <br />
                                               <div class="notsosmallfont" style="text-align: left;">
                                                   <table>
                                                       <tr>
                                                           <td>
                                                               <p>
                                                                   <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
                                                                       style="display: block;"></span>
                                                                   &nbsp;
                                                                   <asp:ValidationSummary ID="ValidationSummary1"
                                                                           runat="server" DisplayMode="List" ValidationGroup="CrearRegistros_ValGroup" CssClass="errmessage errmessage_background" />
                                                                   Crear registros de montos estimados para el año &nbsp;&nbsp;
                                                                   <asp:TextBox ID="Ano_TextBox" runat="server" Width="40px"></asp:TextBox>

                                                                   <asp:RequiredFieldValidator ID="RequiredFieldValidator1" 
                                                                                               runat="server" 
                                                                                               ErrorMessage="Ud. debe indicar un año en este campo; ejemplo: 2005"
                                                                                               Display="Dynamic" 
                                                                                               ControlToValidate="Ano_TextBox" 
                                                                                               ValidationGroup="CrearRegistros_ValGroup"
                                                                                               Text="*" 
                                                                                               style="color: red; " />

                                                                   <asp:CompareValidator ID="CompareValidator1"
                                                                                         runat="server" 
                                                                                         ErrorMessage="Ud. debe indicar un año en este campo; ejemplo: 2005."
                                                                                         Display="Dynamic" 
                                                                                         ValidationGroup="CrearRegistros_ValGroup" 
                                                                                         Text="*" 
                                                                                         ControlToValidate="Ano_TextBox"
                                                                                         Operator="DataTypeCheck" 
                                                                                         Type="Integer" 
                                                                                         style="color: red; " />

                                                                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                   <asp:Button ID="CrearRegistrosMontos_Button" 
                                                                               runat="server" 
                                                                               ToolTip="... click para ejecutar el proceso que crea los registros de montos estimados"
                                                                               ValidationGroup="CrearRegistros_ValGroup" 
                                                                               OnClick="CrearRegistrosMontos_Button_Click" 
                                                                               Text="Crear registros">
                                                                   </asp:Button>
                                                                   <br />
                                                               </p>
                                                           </td>
                                                           <td>
                                                               <%-- divs para mostrar el progress bar --%>
                                                               <div id="Progressbar_div" style="visibility: hidden; width: 150px;">
                                                                   <div id="ProgressbarBorder_div" style="margin-left: 5px; margin-right: 5px; border: 1px solid #808080;
                                                                       height: 10px;">
                                                                       <div id="ProgressbarProgress_div" style="background: url(../../../../Pictures/safari.gif) 0% 0% repeat-x;
                                                                           height: 10px; width: 0%;">
                                                                       </div>
                                                                   </div>
                                                                   <div id="ProgressbarMessage_div" style="text-align: center;" class="smallfont">
                                                                   </div>
                                                               </div>
                                                               <%-- --------------------------------- --%>
                                                           </td>
                                                       </tr>
                                                       <tr>
                                                           <td>
                                                               Cuenta de presupuesto: 
                                                               <asp:TextBox ID="CuentaPresupuesto_AgregarMontos_Filter_TextBox" runat="server"></asp:TextBox>
                                                               (Ejemplo: 4-001*, *-006, 4-001, etc.)
                                                           </td>
                                                           <td></td>
                                                       </tr>
                                                       <tr>
                                                           <td>
                                                               <asp:CheckBox ID="ActualizarAunqueExistan_CheckBox" runat="server" />
                                                               Actualizar los montos que de cuentas de presupuesto que <b><em>ya existan</em></b> para el año indicado<br />
                                                               (pues fueron copiadas por este proceso en una ejecución anterior). 
                                                           </td>
                                                           <td></td>
                                                       </tr>
                                                       <tr>
                                                           <td>
                                                               <asp:CheckBox ID="AgregarDesdeTablaCodigosPresupuesto_CheckBox" runat="server" />
                                                               Agregar, desde la tabla <em>Códigos de Presupuesto</em>, registros de monto estimado 
                                                               para códigos que <b><em>no existan</em></b><br />
                                                               para el año indicado
                                                               (pues no se han agregado antes registros de montos para estos códigos de presupuesto y año). 
                                                           </td>
                                                           <td></td>
                                                       </tr>
                                                   </table>
                                                   <span id="Message_Span" runat="server" class="infomessage infomessage_background generalfont"
                                                       style="display: block;"></span>
                                               </div>
                                           </td>
                                       </tr>
                                   </table>
                               </div>
                           </div>
                           <%-- 
                          
                           --%>
                        </ContentTemplate>
           </cc1:TabPanel>
           
        </cc1:tabcontainer>
        
    <asp:SqlDataSource ID="CiasContab_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="SELECT Numero, NombreCorto FROM Companias ORDER BY NombreCorto">
    </asp:SqlDataSource> 
    
    <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT Moneda, Descripcion FROM Monedas ORDER BY Descripcion">
    </asp:SqlDataSource> 
    
    <asp:LinqDataSource ID="Presupuesto_Montos_LinqDataSource"
                        runat="server" 
                        OnSelecting="Presupuesto_Montos_LinqDataSource_Selecting"
                        ContextTypeName="ContabSysNet_Web.ModelosDatos.dbContabDataContext" 
                        EnableDelete="True" 
                        EnableUpdate="True" 
                        TableName="Presupuesto_Montos">
    </asp:LinqDataSource>

    <%--<asp:LinqDataSource ID="LinqDataSource1"
                        runat="server" 
                        OnSelecting="Presupuesto_Montos_LinqDataSource_Selecting"
                        ContextTypeName="ContabSysNet_Web.ModelosDatos.dbContabDataContext" 
                        EnableDelete="True" 
                        EnableUpdate="True" 
                        TableName="Presupuesto_Montos" 
                        Where="CiaContab == @CiaContab &amp;&amp; Moneda == @Moneda &amp;&amp; Ano == @Ano">
        <WhereParameters>
            <asp:Parameter Name="CiaContab" Type="Int32" DefaultValue="-999" />
            <asp:Parameter Name="Moneda" Type="Int32" DefaultValue="-999" />
            <asp:Parameter Name="Ano" Type="Int16" DefaultValue="-999" />
            <asp:Parameter Name="CodigoPresupuesto" Type="String" DefaultValue="*" />
        </WhereParameters>
    </asp:LinqDataSource>
    --%>
    
    
     <asp:SqlDataSource ID="CiasContab0_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT DISTINCT Presupuesto_Montos.CiaContab, Companias.NombreCorto AS NombreCiaContab FROM Presupuesto_Montos INNER JOIN Companias ON Presupuesto_Montos.CiaContab = Companias.Numero ORDER BY NombreCiaContab">
    </asp:SqlDataSource> 
    
    <asp:SqlDataSource ID="Monedas0_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        
           SelectCommand="SELECT DISTINCT Presupuesto_Montos.Moneda, Monedas.Descripcion AS NombreMoneda FROM Presupuesto_Montos INNER JOIN Monedas ON Presupuesto_Montos.Moneda = Monedas.Moneda ORDER BY NombreMoneda">
    </asp:SqlDataSource> 

    <asp:SqlDataSource ID="Anos_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT Distinct Ano FROM Presupuesto_Montos ORDER BY Ano Desc">
    </asp:SqlDataSource> 
</div>

</asp:Content>

