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
    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top; background-color: #F7F7F7; float: left; text-align: center; ">
        <br />
        <br />

        <a href="javascript:PopupWin('CentrosCosto_Filter.aspx', 1000, 680)">Definir y aplicar<br /> un filtro</a><br />
        <i class="fas fa-filter fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <a href="javascript:PopupWin('CentrosCosto_OpcionesReportes.aspx', 1000, 680)" >Reporte</a><br />
        <i class="fas fa-print fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <a href="javascript:PopupWin('../../UltimoMesCerradoContable.aspx', 1000, 680)">Fechas de último<br /> cierre contable</a><br />
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px; "></i>

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
                                                  ItemType="ContabSysNet_Web.ModelosDatos_EF.code_first.contab.Companias" 
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
                                                  ItemType="ContabSysNet_Web.ModelosDatos_EF.code_first.contab.Monedas" 
                                                  DataTextField="Descripcion" 
                                                  DataValueField="Moneda" 
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
                                (<em>gasto:</em> todo lo que contenga <em>gasto:</em>) 
                            </span>
                        </td>
                    </tr>
                </table>

                <asp:GridView runat="server" 
                              ID="MovimientosContables_GridView"
                              DataSourceID="SqlDataSource1"
                              DataKeyNames="NumeroAutomatico, Partida" 
                              AutoGenerateColumns="False" 
                              AllowPaging="True" 
                              OnPageIndexChanging ="MovimientosContables_GridView_PageIndexChanging" 
                              PageSize="12"  
                              CssClass="Grid">
                            <Columns>
                                <asp:buttonfield CommandName="Select" Text="Select"/>

                                <asp:boundfield datafield="centrosCostoDescripcion" headertext="Centro<br/>costo" HtmlEncode="False"> 
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:boundfield>

                                <asp:boundfield datafield="cuentaContable" headertext="Cuenta<br/>contable" HtmlEncode="False">      
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                </asp:boundfield>

                                <asp:boundfield datafield="fecha" headertext="Fecha" dataformatstring="{0:dd-MM-yy}" htmlencode="false">      
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:boundfield>

                                <asp:boundfield datafield="monedaSimbolo" headertext="Mon" htmlencode="false">      
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:boundfield>

                                <asp:boundfield datafield="monedaOriginalSimbolo" headertext="Mon<br />orig" htmlencode="false">      
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:boundfield>

                                <asp:boundfield datafield="cuentaContableDescripcion" headertext="Nombre<br/>cuenta" HtmlEncode="False">      
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>

                                <asp:boundfield DataField="descripcion" HeaderText="Descripción" >          
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>

                                <asp:TemplateField HeaderText="#Com<br />prob">
                                    <ItemTemplate>
                                        <a href="javascript:PopupWin('../Cuentas y movimientos/CuentasYMovimientos_Comprobantes.aspx?NumeroAutomatico=' + <%# Eval("numeroAutomatico") %>, 1000, 680)"><%#Eval("numero")%> </a>     
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>

                                <asp:boundfield datafield="referencia" headertext="Referencia">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>

                                <asp:boundfield datafield="provieneDe" headertext="Proviene<br/>de" HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                </asp:boundfield>

                                <asp:TemplateField HeaderText="Monto">
                                    <ItemTemplate>
                                        <asp:Label ID="startDateLabel" runat="server" Text='<%# MontoAsiento(Eval("debe").ToString(), Eval("haber").ToString())%>'>
                                        </asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle Wrap="False" />
                                </asp:TemplateField>

                                <asp:boundfield datafield="usuario" headertext="Usuario" HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>

                                <asp:boundfield datafield="companiaAbreviatura" headertext="Cia<br/>contab" HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>

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

    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
             SelectCommand="Select top 50 a.NumeroAutomatico as numeroAutomatico, a.Numero as numero, d.Partida, c.Cuenta as cuentaContable, 
                            c.Descripcion as cuentaContableDescripcion, a.Fecha as fecha, d.Descripcion as descripcion, 
                            d.Referencia as referencia, a.ProvieneDe as provieneDe,   
		                    d.Debe as debe, d.Haber as haber, a.Usuario as usuario, 
                            m.Simbolo as monedaSimbolo, mo.Simbolo as monedaOriginalSimbolo, 
                            d.Debe as debe, d.Haber as haber, 
                            cc.DescripcionCorta as centrosCostoDescripcion, comp.Abreviatura as companiaAbreviatura  
                            From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico 
                            Inner Join CuentasContables c On d.CuentaContableID = c.ID 
                            Inner Join Monedas m On a.Moneda = m.Moneda 
                            Inner Join Monedas mo On a.MonedaOriginal = mo.Moneda 
                            Inner Join Companias comp On a.Cia = comp.Numero 
                            Left Outer Join CentrosCosto cc On d.CentroCosto = cc.CentroCosto
                            Where a.Cia = 99999
        ">
    </asp:SqlDataSource>

    <%--<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
             SelectCommand="Select CentrosCosto.DescripcionCorta, CuentasContables.Cuenta, Asientos.Fecha, Asientos.Monedas.Simbolo, Asientos.Monedas1.Simbolo,  
		                CuentasContables.Descripcion, Descripcion, Asientos.NumeroAutomatico, Asientos.Numero, Referencia, Asientos.ProvieneDe,   
		                Debe, Haber, Asientos.Usuario, Asientos.Companias.Abreviatura 
                        From dAsientos 
                        Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
                        Inner Join CuentasContables On dAsientos.CuentaContableID = CuentasContables.ID 
                        Left Outer Join CentrosCosto On dAsientos.CentroCosto = CentrosCosto.CentroCosto">
    </asp:SqlDataSource>--%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>