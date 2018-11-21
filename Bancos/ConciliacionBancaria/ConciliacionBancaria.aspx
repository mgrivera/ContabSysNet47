<%@ Page Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" Inherits="ContabSysNet_Web.Bancos.ConciliacionBancaria.ConciliacionBancaria" Title="Untitled Page" Codebehind="ConciliacionBancaria.aspx.cs" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">

   <script type="text/javascript">
        function PopupWin(url, w, h)
        {
            ///Parameters url=page to open, w=width, h=height
            window.open(url, "external2", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
        }
        //function RefreshPage()
        //{
        //    window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
        //    window.document.forms(0).submit();
        //}
        function RefreshPage() {
            //window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
            $(document).ready(function () {
                $('[id$=RebindFlagHiddenField]').val('1');
            });

            window.document.forms(0).submit();
        }
    </script>

    <%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
    <span id="RebindFlagSpan">
        <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" />
    </span>

    <%--  --%>
    <%-- div en la izquierda para mostrar funciones de la página --%>
    <%--  --%>

    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top;
        background-color: #F7F7F7; float: left; text-align: center; ">
        <br />
        <br />

        <a runat="server" 
                   id="filterLink"
                   href="javascript:PopupWin('ConciliacionBancaria_Criterios.aspx', 1000, 600)">
                        <img id="Img4" 
                             border="0" 
                             runat="server"
                             alt="Para establecer los criterios de ejecución de la conciliación bancaria" 
                             src="~/Pictures/Edit_25x25.png" />
        </a>
        <br />
        <a href="javascript:PopupWin('ConciliacionBancaria_Criterios.aspx', 1000, 600)">Criterios de ejecución<br />de la conciliación bancaria</a>

        <hr />

        <a runat="server" 
                   id="A2"
                   href="javascript:PopupWin('ConciliacionBancaria_UploadMovBanco.aspx', 1000, 600)">
                        <img id="Img3" 
                             border="0" 
                             runat="server"
                             alt="Para registrar (Upload) los movimientos obtenidos desde el banco" 
                             src="~/Pictures/upload25x25.png" />
        </a>
        <br />
        <a href="javascript:PopupWin('ConciliacionBancaria_UploadMovBanco.aspx', 1000, 600)">Grabar movimientos<br />del banco</a>

        <hr />

        <asp:LinkButton runat="server" 
            id="SeleccionarMovimientos_LinkButton1"
             OnClick="SeleccionarMovimientos_LinkButton_Click">
                <img id="Img6" 
                        border="0" 
                        runat="server"
                        alt="Para seleccionar los movimientos, bancarios y contables, que corresponden a los criterios indicados antes." 
                        src="~/Pictures/ShowItems_25x25.png" />
        </asp:LinkButton>
        <br />
        <asp:LinkButton  runat="server" id="SeleccionarMovimientos_LinkButton2" OnClick="SeleccionarMovimientos_LinkButton_Click" ToolTip="Para seleccionar los movimientos, bancarios y contables, que corresponden a los criterios indicados antes.">Seleccionar movimientos<br />del banco</asp:LinkButton>

        <hr />

        <asp:LinkButton runat="server" 
            id="CompararMovimientos_LinkButton"
             OnClick="CompararMovimientos_LinkButton_Click">
                <img id="Img1" 
                        border="0" 
                        runat="server"
                        alt="Para comparar los movimientos obtenidos desde el banco, contra los movimientos bancarios (nuestros) y contables." 
                        src="~/Pictures/Gears_25x25.png" />
        </asp:LinkButton>
        <br />
        <asp:LinkButton  runat="server" id="CompararMovimientos_LinkButton2" OnClick="CompararMovimientos_LinkButton_Click" ToolTip="Para seleccionar los movimientos, bancarios y contables, que corresponden a los criterios indicados antes.">Comparar<br />movimientos</asp:LinkButton>

        <hr />

        <br />
    </div>
    
    <div style="text-align: left; float: right; width: 88%;">
       
         <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:ValidationSummary ID="ValidationSummary1" 
                                   runat="server" 
                                   class="errmessage_background generalfont errmessage"
                                   ShowModelStateErrors="true"
                                   ForeColor="" />

                <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" Display="None" EnableClientScript="False" />

                <div id="CriteriosConciliacion_Div" runat="server" class="notsosmallfont_blue" 
                     style="padding: 5px; border: 1px solid #C0C0C0;"/>

                <ajaxToolkit:tabcontainer id="TabContainer1" runat="server" activetabindex="0" >

                    <ajaxToolkit:TabPanel HeaderText="Movimientos bancarios (banco)" runat="server" ID="TabPanel1" >
                        <ContentTemplate>

                            <asp:DropDownList ID="MovimientosBanco_Filtro_DropDownList" runat="server" CssClass="notsosmallfont" AutoPostBack="True" 
                                              OnSelectedIndexChanged="MovimientosBanco_Filtro_DropDownList_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="0">Todos</asp:ListItem>
                                <asp:ListItem Value="1">Mov banc encontrado</asp:ListItem>
                                <asp:ListItem Value="2">Mov cont encontrado</asp:ListItem>
                                <asp:ListItem Value="3">Movtos banc y cont encontrados</asp:ListItem>
                            </asp:DropDownList>

                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                            <asp:LinkButton ID="MovBanco_Report_LinkButton" 
                                            runat="server" 
                                            OnPreRender="MovBanco_Report_LinkButton_PreRender">Obtener reporte</asp:LinkButton>
               
                            <asp:GridView runat="server" 
                                         ID="MovimientosBanco_GridView"
                                         ItemType="ContabSysNet_Web.ModelosDatos_EF.Bancos.MovimientosDesdeBanco" 
                                         DataKeyNames="ID" 
                                         SelectMethod="MovimientosBanco_GridView_GetData"
                                         OnSelectedIndexChanged="MovimientosBanco_GridView_SelectedIndexChanged"   
                                         OnPageIndexChanging="MovimientosBanco_GridView_PageIndexChanging" 
                                         AutoGenerateColumns="False" 
                                         AllowPaging="True" 
                                         PageSize="15"  
                                         CssClass="Grid">
                                <Columns>
                                    <asp:buttonfield CommandName="Select" Text="Select"/>

                                    <asp:TemplateField HeaderText="ID">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.ID %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:boundfield DataField="Fecha" HeaderText="Fecha" DataFormatString="{0:dd-MM-yy}" >
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle Wrap="False" HorizontalAlign="Center" />
                                    </asp:boundfield>

                                    <asp:boundfield DataField="Descripcion" HeaderText="Descripción" >
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" />
                                    </asp:boundfield>
                                    
                                    <asp:boundfield DataField="Referencia" HeaderText="Referencia" >          
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle Wrap="False" HorizontalAlign="Left" />
                                    </asp:boundfield>

                                    <asp:boundfield DataField="Monto" HeaderText="Monto"  DataFormatString="{0:N2}" >          
                                        <HeaderStyle HorizontalAlign="Right" />
                                        <ItemStyle Wrap="False" HorizontalAlign="Right" />
                                    </asp:boundfield>

                                    <asp:TemplateField HeaderText="Mov banc">
                                        <ItemTemplate>
                                            <%--<asp:Label ID="Label1" runat="server" Text='<%# Item.MovimientosBancarios.FirstOrDefault().Transaccion %>'></asp:Label>--%>
                                            <asp:Label ID="Label2" runat="server" Text='<%# this.GetMovBancarioConciliado(Item) %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Mov cont">
                                        <ItemTemplate>
                                            <%--<asp:Label ID="Label1" runat="server" Text='<%# Item.dAsientos.FirstOrDefault().Partida %>'></asp:Label>--%>
                                            <asp:Label ID="Label2" runat="server" Text='<%# this.GetMovContableConciliado(Item) %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>
                                </Columns>

                               <EmptyDataTemplate>
                                    <br />
                                    No hay registros que mostrar; probablemente no se han establecido criterios de ejecución y seleccionado registros (movimientos) ... 
                                </EmptyDataTemplate> 

                                <SelectedRowStyle backcolor="LightCyan" forecolor="DarkBlue" font-bold="True" />  
                                <AlternatingRowStyle CssClass="GridAltItem" />
				                <RowStyle CssClass="GridItem" />
				                <HeaderStyle CssClass="GridHeader" />
				                <PagerStyle CssClass="GridPager" />
                                <EmptyDataRowStyle CssClass="GridEmptyData" />

                            </asp:GridView>

                        </ContentTemplate>
                    </ajaxToolkit:TabPanel>

                    <ajaxToolkit:TabPanel HeaderText="Movimientos bancarios (nuestros)" runat="server" ID="TabPanel2" >
                        <ContentTemplate>

                            <asp:DropDownList ID="MovimientosBancarios_Filtro_DropDownList" runat="server" CssClass="notsosmallfont" AutoPostBack="True" 
                                              OnSelectedIndexChanged="MovimientosBancarios_Filtro_DropDownList_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="0">Todos</asp:ListItem>
                                <asp:ListItem Value="1">Encontrados</asp:ListItem>
                                <asp:ListItem Value="2">No encontrados</asp:ListItem>
                            </asp:DropDownList>

                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                            <asp:LinkButton ID="MovBancarios_Report_LinkButton" 
                                            runat="server" 
                                            OnPreRender="MovBancarios_Report_LinkButton_PreRender">Obtener reporte</asp:LinkButton>

                            <asp:GridView runat="server" 
                                         ID="MovimientosBancarios_GridView"
                                         ItemType="ContabSysNet_Web.ModelosDatos_EF.Bancos.MovimientosBancario" 
                                         DataKeyNames="ClaveUnica" 
                                         SelectMethod="MovimientosBancarios_GridView_GetData"
                                         OnPageIndexChanging="MovimientosBancarios_GridView_PageIndexChanging"
                                         AutoGenerateColumns="False" 
                                         AllowPaging="True" 
                                         PageSize="15"  
                                         CssClass="Grid">
                                <Columns>
                                    <asp:buttonfield CommandName="Select" Text="Select"/>

                                    <asp:TemplateField HeaderText="Número">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Transaccion %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Tipo">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Tipo %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Fecha">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Fecha.ToString("dd-MM-yy") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Beneficiario">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Beneficiario %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" Wrap="True" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Concepto">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Concepto %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" Wrap="True" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Monto">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Monto.ToString("N2") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Right" />
                                        <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Conciliado">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.ConciliacionMovimientoID %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>

                                </Columns>

                               <EmptyDataTemplate>
                                    <br />
                                    No hay registros que mostrar; probablemente no se han establecido criterios de ejecución y seleccionado registros (movimientos) ... 
                                </EmptyDataTemplate> 

                                <SelectedRowStyle backcolor="LightCyan" forecolor="DarkBlue" font-bold="True" />  
                                <AlternatingRowStyle CssClass="GridAltItem" />
				                <RowStyle CssClass="GridItem" />
				                <HeaderStyle CssClass="GridHeader" />
				                <PagerStyle CssClass="GridPager" />
                                <EmptyDataRowStyle CssClass="GridEmptyData" />

                            </asp:GridView>
               
                        </ContentTemplate>
                    </ajaxToolkit:TabPanel>

                    <ajaxToolkit:TabPanel HeaderText="Movimientos contables" runat="server" ID="TabPanel3" >
                        <ContentTemplate>

                            <asp:DropDownList ID="MovimientosContables_Filtro_DropDownList" runat="server" CssClass="notsosmallfont" AutoPostBack="True" 
                                              OnSelectedIndexChanged="MovimientosContables_Filtro_DropDownList_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="0">Todos</asp:ListItem>
                                <asp:ListItem Value="1">Encontrados</asp:ListItem>
                                <asp:ListItem Value="2">No encontrados</asp:ListItem>
                            </asp:DropDownList>

                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                            <asp:LinkButton ID="MovContables_Report_LinkButton" 
                                            runat="server" 
                                            OnPreRender="MovContables_Report_LinkButton_PreRender">Obtener reporte</asp:LinkButton>

                            <asp:GridView runat="server" 
                                         ID="MovimientosContables_GridView"
                                         ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.dAsiento" 
                                         DataKeyNames="NumeroAutomatico, Partida" 
                                         SelectMethod="MovimientosContables_GridView_GetData"
                                         OnPageIndexChanging="MovimientosContables_GridView_PageIndexChanging"
                                         AutoGenerateColumns="False" 
                                         AllowPaging="True" 
                                         PageSize="15"  
                                         CssClass="Grid">
                                <Columns>
                                    <asp:buttonfield CommandName="Select" Text="Select"/>

                                    <asp:TemplateField HeaderText="Fecha">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Asiento.Fecha.ToString("dd-MM-yy") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Número">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Asiento.Numero %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Descripción">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Descripcion %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Referencia">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Referencia %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" Wrap="True" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Debe">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Debe.ToString("N2") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Right" />
                                        <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Haber">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.Haber.ToString("N2") %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Right" />
                                        <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Conciliado">
                                        <ItemTemplate>
                                            <asp:Label ID="Label1" runat="server" Text='<%# Item.ConciliacionMovimientoID %>'></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>

                                </Columns>

                               <EmptyDataTemplate>
                                    <br />
                                    No hay registros que mostrar; probablemente no se han establecido criterios de ejecución y seleccionado registros (movimientos) ... 
                                </EmptyDataTemplate> 

                                <SelectedRowStyle backcolor="LightCyan" forecolor="DarkBlue" font-bold="True" />  
                                <AlternatingRowStyle CssClass="GridAltItem" />
				                <RowStyle CssClass="GridItem" />
				                <HeaderStyle CssClass="GridHeader" />
				                <PagerStyle CssClass="GridPager" />
                                <EmptyDataRowStyle CssClass="GridEmptyData" />

                            </asp:GridView>
               
                        </ContentTemplate>
                    </ajaxToolkit:TabPanel>
                </ajaxToolkit:tabcontainer>

                <asp:Panel ID="pnlPopup" runat="server" CssClass="modalpopup" style="display:none">
                    <div class="popup_container" style="max-width: 500px; ">
                        <div class="popup_form_header" style="overflow: hidden; ">
                            <div style="width: 85%; margin-top: 5px;  float: left;  ">
                                <span runat="server" id="ModalPopupTitle_span" /> 
                            </div>
                            <div style="width: 15%; float: right; ">
                                <asp:ImageButton ID="ImageButton1" runat="server" OnClientClick="$find('popup').hide(); return false;" ImageUrl="~/Pictures/PopupCloseButton.png" />
                            </div>
                        </div>
                        <div class="inner_container">
                            <div class="popup_form_content">
                                <span runat="server" id="ModalPopupBody_span" /> 
                            </div>
                            <div class="popup_form_footer">
                                <%-- <asp:Button ID="btnOk" runat="server" Text="Yes" Width="40px" />--%>
                                <asp:Button ID="btnCancel" runat="server" Text="Ok" Width="80px" OnClientClick="$find('popup').hide(); return false;" />
                            </div>   
                        </div>                                          
                    </div>
                </asp:Panel>

                <asp:HiddenField ID="HiddenField1" runat="server" />
                <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" 
                                                runat="server" 
                                                BehaviorID="popup" 
                                                TargetControlID="HiddenField1" 
                                                PopupControlID="pnlPopup" 
                                                BackgroundCssClass="modalBackground" />

            </ContentTemplate>
        </asp:UpdatePanel>
        
    </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>

