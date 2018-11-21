<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="MovimientoBancario_page.aspx.cs" Inherits="ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios.MovimientoBancario_page" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <script type="text/javascript">
         function PopupWin(url, w, h) {
             ///Parameters url=page to open, w=width, h=height
             window.open(url, "_blank", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
         }
         function RefreshPage() {
             window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
             window.document.forms(0).submit();
         }
    </script>

    <div style="text-align: left; padding: 0px 10px 10px 10px;">
        <table>
            <tr>
                <td style="text-align: center; ">
                    <a runat="server" id="MostrarAsientoContable_HyperLink" 
                        href="javascript:PopupWin('../../../ReportViewer.aspx?rpt=unasientocontable', 1000, 680)">
                        <img id="Img1" 
                             border="0" 
                             alt="Click para mostrar el asiento contable asociado" 
                             src="../../../Pictures/NewWindow_25x25.png" />
                    </a>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td style="color: #4F4F4F; text-align: center; font-size: small;">
                    Asiento<br />contable
                </td>
                <td>
                </td>
            </tr>
        </table>
    </div>

    <asp:ValidationSummary ID="ValidationSummary1" 
                           runat="server" 
                           class="errmessage_background generalfont errmessage"
                           ForeColor="" />

    <asp:CustomValidator ID="CustomValidator1" 
                         runat="server" 
                         ErrorMessage="" 
                         Visible="false" />

    <asp:DynamicDataManager ID="DynamicDataManager1" runat="server" />

    <asp:FormView ID="MovimientoBancario_FormView"
                  DataSourceID="MovimientoBancario_EntityDataSource"
                  DataKeyNames = "ClaveUnica"
                  AllowPaging="True"
                  runat="server" 
                  CellPadding="3" 
                  BackColor="White" 
                  BorderColor="#999999" 
                  BorderStyle="None" 
                  BorderWidth="1px" 
                  GridLines="Vertical">
        
        <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
        
        <HeaderStyle forecolor="white" backcolor="#000084" Font-Bold="True" />   

        <HeaderTemplate>
            Información para el movimiento bancario seleccionado
        </HeaderTemplate>
        
        <ItemTemplate>

            <cc1:tabcontainer id="TabContainer1" runat="server" activetabindex="0" style="text-align: left; ">
                <cc1:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1" >
                    <ContentTemplate>   
                        <table cellspacing="5">
                            <tr>
                                <td />
                                <td />
                                <td />
                                <td align="right" colspan="2" style="font-style:italic; font-size: x-small; color: Blue; ">
                                    <asp:Label id="Label21" runat="server" Text='<%# Eval("Chequera.CuentasBancaria.Compania.Nombre") %>' />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="5"/>
                            </tr>
                            <tr>
                                <td align="right"><b>Tipo:</b></td>
                                <td align="left"><asp:DynamicControl id="ProductIDLabel" runat="server"  DataField="Tipo" /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><b>Fecha:</b></td>
                                <td align="left"><asp:DynamicControl id="Label1" runat="server"  DataField="Fecha" /></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Cuenta bancaria:</b></td>
                                <td align="left"><asp:Label id="Label2" runat="server" Text='<%# Eval("Chequera.CuentasBancaria.CuentaBancaria") %>' /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><b>Compañía:</b></td>
                                <td align="left">
                                    <%--<asp:DynamicControl id="DynamicControl1" runat="server" DataField="Proveedore" />--%>
                                    <asp:Label id="Label3" runat="server" Text='<%# Eval("Proveedore.Nombre") %>' />
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Número:</b></td>
                                <td align="left"><asp:DynamicControl id="Label4" runat="server" DataField="Transaccion" /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><b>Moneda:</b></td>
                                <td align="left"><asp:Label id="Label5" runat="server" Text='<%# Eval("Chequera.CuentasBancaria.Moneda1.Simbolo") %>' /></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Beneficiario:</b></td>
                                <td align="left"><asp:DynamicControl id="Label6" runat="server" DataField="Beneficiario" /></td>
                                <td />
                                <td />
                                <td />
                            </tr>
                            <tr>
                                <td align="right"><b>Concepto:</b></td>
                                <td align="left"><asp:DynamicControl id="Label7" runat="server" DataField="Concepto" /></td>
                                <td />
                                <td />
                                <td />
                            </tr>
                            <tr>
                                <td align="right"><b>Monto base:</b></td>
                                <td align="left"><asp:DynamicControl id="Label8" runat="server" DataField="MontoBase" /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><b>Comisión:</b></td>
                                <td align="left"><asp:DynamicControl id="Label9" runat="server" DataField="Comision" /></td>
                            </tr>
                            <tr>
                                <td />
                                <td />
                                <td />
                                <td align="right"><b>Impuesto:</b></td>
                                <td align="left"><asp:DynamicControl id="Label19" runat="server" DataField="Impuestos" /></td>
                            </tr>
                            <tr>
                                <td />
                                <td />
                                <td />
                                <td align="right"><b>Monto:</b></td>
                                <td align="left"><asp:DynamicControl id="Label11" runat="server" DataField="Monto" /></td>
                            </tr>
                            <tr>
                                <td />
                                <td />
                                <td />
                                <td align="right" style="white-space: nowrap; "><b>F entregado:</b></td>
                                <td align="left"><asp:DynamicControl id="Label20" runat="server" DataField="FechaEntregado" /></td>
                            </tr>
                            
                        </table>  
                        <br />
                    </ContentTemplate>
                </cc1:TabPanel>
            </cc1:tabcontainer>               
        </ItemTemplate>

        <EditRowStyle BackColor="#008A8C" Font-Bold="True" ForeColor="White" />

        <EmptyDataTemplate>
            <table style="">
                <tr>
                    <td>
                        No se ha encontrado un registro en la base de datos que 
                        corresponda al que se ha requerido.</td>
                </tr>
            </table>
        </EmptyDataTemplate>

        <pagertemplate>   
          &nbsp;     
        </pagertemplate>
       
        <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
        <RowStyle BackColor="#EEEEEE" ForeColor="Black" />
       
    </asp:FormView>
   
     <asp:EntityDataSource ID="MovimientoBancario_EntityDataSource" 
                              runat="server" 
                              ContextTypeName="ContabSysNet_Web.ModelosDatos_EF.Bancos.BancosEntities"
                              DefaultContainerName="BancosEntities" 
                              EnableFlattening="False" 
                              Include="Chequera, 
                                       Chequera.CuentasBancaria, 
                                       Chequera.CuentasBancaria.Moneda1, 
                                       Chequera.CuentasBancaria.Agencia1, 
                                       Chequera.CuentasBancaria.Agencia1.Banco1,
                                       Proveedore,
                                       Chequera.CuentasBancaria.Compania"
                              EntitySetName="MovimientosBancarios"
                              Where="it.ClaveUnica = @MovimientoBancarioID" AutoSort="False" ConnectionString="" 
                              EntityTypeFilter="" 
                              OrderBy="it.Fecha, it.Transaccion" 
                              Select="" >
                                    <WhereParameters>
                                        <asp:Parameter Name="MovimientoBancarioID" Type="Int32" />
                                    </WhereParameters>
        </asp:EntityDataSource>


   <%-- <asp:EntityDataSource ID="EntityDataSource1" runat="server"
        ConnectionString="name=AdventureWorksLTEntities"
        DefaultContainerName="AdventureWorksLTEntities" EnableFlattening="False"
        EntitySetName="ProductCategories" ContextTypeName="DynamicDataEntityFramework.AdventureWorksLTDataContext ">
    </asp:EntityDataSource>

    <asp:EntityDataSource ID="EntityDataSource2" 
                          runat="server" 
                          ConnectionString="name=BancosEntities" 
                          DefaultContainerName="BancosEntities" 
                          EnableFlattening="False" 
                          EntitySetName="MovimientosBancarios">
    </asp:EntityDataSource>--%>

</asp:Content>