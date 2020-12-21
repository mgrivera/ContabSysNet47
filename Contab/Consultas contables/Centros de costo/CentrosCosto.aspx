<%@ Page Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Centros_de_costo.CentrosCosto" Title="Centros de costo - Consulta" Codebehind="CentrosCosto.aspx.cs" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

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
            //window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
            //window.document.forms(0).submit();
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
    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top;
        background-color: #F7F7F7; float: left; text-align: center; ">
        <br />
 
        <a runat="server" 
            id="filterLink"
            href="javascript:PopupWin('CentrosCosto_Filter.aspx', 1000, 600)">
                <img id="Img3" 
                        border="0" 
                        runat="server"
                        alt="Para definir y aplicar un filtro que regrese los registros que se desea consultar" 
                        src="~/Pictures/filter_25x25.png" />
        </a>
        <br />
        <a href="javascript:PopupWin('CentrosCosto_Filter.aspx', 1000, 600)">Definir y aplicar<br />un filtro</a>

        <hr />

            <a runat="server" 
            id="reportLink"
            href="javascript:PopupWin('CentrosCosto_OpcionesReportes.aspx', 1000, 600)">
                <img id="Img4" 
                        runat="server"
                        border="0" 
                        alt="Para obtener un reporte que muestre los registros seleccionados" 
                        src="~/Pictures/print_25x25.png" />
        </a>
        <br />
        <a href="javascript:PopupWin('CentrosCosto_OpcionesReportes.aspx', 1000, 600)">Reporte</a>

        <hr />
        <br />
    </div>
    
    <div style="text-align: left; float: right; width: 88%;">

        <ajaxToolkit:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" 
                                                  runat="server"
                                                  TargetControlID="UpdatePanel1" 
                                                  Enabled="True">
            <Animations>
                <OnUpdating>
                    <Parallel duration=".5">
                        <%-- fade-out the GridView --%>
                        <FadeOut minimumOpacity=".5" />
                    </Parallel>
                </OnUpdating>
                <OnUpdated>
                    <Parallel duration=".5">
                        <%-- fade back in the GridView --%>
                        <FadeIn minimumOpacity=".5" />
                    </Parallel>
                </OnUpdated>
            </Animations>
        </ajaxToolkit:UpdatePanelAnimationExtender>
       
         <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:ValidationSummary ID="ValidationSummary1" 
                                   runat="server" 
                                   class="errmessage_background generalfont errmessage"
                                   ShowModelStateErrors="true"
                                   ForeColor="" />

                <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" Display="None" EnableClientScript="False" />

                <table style="border: 1px solid #C0C0C0; vertical-align: top; background-color: #EEEEEE;">
                    <tr>
                        <td>
                            &nbsp;
                            <span class="smallfont">Compañías:&nbsp;
                                <asp:DropDownList ID="CompaniasFilter_DropDownList" 
                                                  runat="server" 
                                                  ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.Compania"
                                                  DataTextField="NombreCorto" 
                                                  DataValueField="Numero" 
                                                  AutoPostBack="True"
                                                  CssClass="smallfont" 
                                                  SelectMethod="CompaniasFilter_DropDownList_SelectMethod"
                                                  onselectedindexchanged="AplicarMiniFiltro">
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
                                                  SelectMethod="MonedasFilter_DropDownList_SelectMethod"
                                                  OnSelectedIndexChanged="AplicarMiniFiltro">
                                </asp:DropDownList>

                                 &nbsp;&nbsp; 

                                Centro costo:&nbsp;
                                <asp:TextBox ID="CentroCostoFilter_TextBox" 
                                             runat="server" 
                                             CssClass="smallfont"
                                             AutoPostBack="True"  
                                             OnTextChanged="AplicarMiniFiltro" />

                                &nbsp;&nbsp; 

                                Cuenta contable:&nbsp;
                                <asp:TextBox ID="CuentaContableFilter_TextBox" 
                                             runat="server" 
                                             CssClass="smallfont"
                                             AutoPostBack="True"  
                                             OnTextChanged="AplicarMiniFiltro" />

                                 &nbsp;&nbsp; 
                                Nombre de la cuenta contable:&nbsp;
                                <asp:TextBox ID="CuentaContableDescripcionFilter_TextBox"
                                             runat="server" 
                                             CssClass="smallfont"
                                             AutoPostBack="True"  
                                             OnTextChanged="AplicarMiniFiltro" />
                            </span>
                        </td>
                    </tr>

                    <tr>
                        <td style="text-align: right; ">
                            <span class="smallfont">
                                (<b>10:</b> todo lo que contenga 10; <b>10*:</b> todo lo que comience por 10; <b>*10:</b> todo lo que termine en 10) 
                            </span>
                        </td>
                    </tr>
                </table>

                <asp:GridView runat="server" 
                              ID="MovimientosContables_GridView"
                              ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.dAsiento" 
                              DataKeyNames="NumeroAutomatico,Partida" 
                              SelectMethod="MovimientosContables_GridView_GetData"  
                              OnPageIndexChanged="MovimientosContables_GridView_PageIndexChanged"
                              AutoGenerateColumns="False" 
                              AllowPaging="True" 
                              PageSize="12"  
                              CssClass="Grid">
                            <Columns>
                                <asp:buttonfield CommandName="Select" Text="Select"/>

                               <%-- <asp:boundfield DataField="Asiento.Moneda1.Simbolo" HeaderText="Moneda" >
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:boundfield>--%>
                                
                                <asp:boundfield datafield="CentrosCosto.DescripcionCorta" headertext="Centro<br/>costo" HtmlEncode="False"> 
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:boundfield>

                                <asp:boundfield datafield="CuentasContable.Cuenta" headertext="Cuenta<br/>contable" HtmlEncode="False">      
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                </asp:boundfield>

                                <asp:boundfield datafield="Asiento.Fecha" headertext="Fecha" dataformatstring="{0:dd-MM-yy}" htmlencode="false">      
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:boundfield>

                                <asp:boundfield datafield="Asiento.Moneda1.Simbolo" headertext="Mon" htmlencode="false">      
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:boundfield>

                                <asp:boundfield datafield="CuentasContable.Descripcion" headertext="Nombre<br/>cuenta" HtmlEncode="False">      
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>

                                <asp:DynamicField DataField="Descripcion" HeaderText="Descripción" >          
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:DynamicField>

                                <asp:boundfield datafield="Asiento.Numero" headertext="Comprobante">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>

                                <asp:boundfield datafield="Referencia" headertext="Referencia">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>

                                <asp:boundfield datafield="Asiento.ProvieneDe" headertext="Proviene<br/>de" HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                </asp:boundfield>

                                <asp:TemplateField HeaderText="Monto">
                                    <ItemTemplate>
                                        <asp:Label ID="startDateLabel" runat="server" Text='<%# MontoAsiento(Eval("Debe").ToString(), Eval("Haber").ToString())%>'>
                                        </asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle Wrap="False" />
                                </asp:TemplateField>

                               <%-- <asp:boundfield datafield="Asiento.Compania.Abreviatura" headertext="Cia<br/>contab" HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>--%>

                            </Columns>

                            <EmptyDataTemplate>
                                <br />
                                Defina y aplique un filtro que regrese la información que Ud. desee. 
                            </EmptyDataTemplate> 

                            <SelectedRowStyle backcolor="LightCyan" forecolor="DarkBlue" font-bold="True" />  
                            <AlternatingRowStyle CssClass="GridAltItem" />
				            <RowStyle CssClass="GridItem" />
				            <HeaderStyle CssClass="GridHeader" />
				            <PagerStyle CssClass="GridPager" />
                            <EmptyDataRowStyle CssClass="GridEmptyData" />

                        </asp:GridView>
               
            </ContentTemplate>
        </asp:UpdatePanel>
        
    </div>
    
    <div>

    </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>