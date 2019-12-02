<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="ActivoFijo_page.aspx.cs" Inherits="ContabSysNetWeb.ActivosFijos.Consultas.ConsultaActivosFijos.ActivoFijo_page" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:FormView ID="ActivoFijo_FormView"
                  DataSourceID="ActivosFijos_EntityDataSource"
                  AllowPaging="True"
                  runat="server" CellPadding="3" BackColor="White" 
        BorderColor="#999999" BorderStyle="None" BorderWidth="1px" GridLines="Vertical">
        
        <FooterStyle BackColor="#CCCCCC" ForeColor="Black" />
        
        <HeaderStyle forecolor="white" backcolor="#000084" Font-Bold="True" />   

        <HeaderTemplate>
            Información para el activo fijo seleccionado
        </HeaderTemplate>
        
        <ItemTemplate>

            <cc1:tabcontainer id="TabContainer1" runat="server" activetabindex="0" style="text-align: left; ">
                <cc1:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1" >
                    <ContentTemplate>   
                        <br />
                        <table cellspacing="5">
                            <tr>
                                <td style="text-align: right; "><b>Moneda:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label20" runat="server" Text='<%# Eval("Moneda1.Simbolo") %>' /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td style="text-align: right; "><b>Descripción:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label1" runat="server" Text='<%# Eval("Descripcion") %>' /></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; "><b>Producto:</b></td>
                                <td style="text-align: left; "><asp:Label id="ProductIDLabel" runat="server" Text='<%# Eval("Producto") %>' /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td style="text-align: right; "><b>Tipo:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label3" runat="server" Text='<%# Eval("TiposDeProducto.Descripcion") %>' /></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; "><b>Proveedor:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label4" runat="server" Text='<%# Eval("Proveedore.Nombre") %>' /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td style="text-align: right; "><b>Serial:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label5" runat="server" Text='<%# Eval("Serial") %>' /></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; "><b>Departamento:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label2" runat="server" Text='<%# Eval("tDepartamento.Descripcion") %>' /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td style="text-align: right; "><b>Placa:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label7" runat="server" Text='<%# Eval("Placa") %>' /></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; "><b>Modelo:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label6" runat="server" Text='<%# Eval("Modelo") %>' /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td style="text-align: right; "><b>F compra:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label9" runat="server" Text='<%# Eval("FechaCompra", "{0:dd-MMMM-yyyy}") %>' /></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; "><b>Factura:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label8" runat="server" Text='<%# Eval("Factura") %>' /></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td style="text-align: right; "><b>Cia:</b></td>
                                <td style="text-align: left; "><asp:Label id="Label11" runat="server" Text='<%# Eval("Compania.Nombre") %>' /></td>
                            </tr>
                            
                        </table>  
                        <br />
                    </ContentTemplate>
                </cc1:TabPanel>

                <cc1:TabPanel HeaderText="Costo y desincorporación" runat="server" ID="TabPanel2" >
                    <ContentTemplate>   
                        <br />
                        <fieldset style="text-align: left; margin-left: 15px; ">
                            <legend>Costo:</legend>

                            <table>
                                <tr align="center">
                                    <td align="center"><b>Costo total</b></td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td align="center"><b>Valor residual</b></td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td align="center"><b>Monto a depreciar</b></td>
                                </tr>
                                <tr align="center">
                                    <td align="center"><asp:Label id="Label22" runat="server" Text='<%# Eval("CostoTotal", "{0:N2}") %>' /></td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td align="center"><asp:Label id="Label23" runat="server" Text='<%# Eval("ValorResidual", "{0:N2}") %>' /></td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td align="center"><asp:Label id="Label26" runat="server" Text='<%# Eval("MontoADepreciar", "{0:N2}") %>' /></td>
                                </tr>
                            </table> 
                    </fieldset>
                    <br /><br /><br /><br />
                    <fieldset style="text-align: left; margin-left: 15px; ">
                            <legend>Desincorporación:</legend>
                            <table>
                                <tr>
                                    <td style="text-align: right; "><b></b></td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td align="center"><b>Fecha</b></td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td style="text-align: left; "><b>Autorizado por</b></td>
                                </tr>
                                <tr>
                                    <td style="text-align: left; "><asp:CheckBox id="Label24" runat="server" Checked=
                                        '<%# Eval("DesincorporadoFlag") == null ? false : Eval("DesincorporadoFlag") %>' /> Desincorporado</td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td align="center"><asp:Label id="Label25" runat="server" Text='<%# Eval("FechaDesincorporacion", "{0:dd-MMM-yyyy}") %>' /></td>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td style="text-align: left; "><asp:Label id="Label27" runat="server" Text='<%# Eval("tEmpleado.Nombre") %>' /></td>
                                </tr>
                            </table> 
                            <br />
                            <b>&nbsp;&nbsp;&nbsp;Motivo:</b><br />&nbsp;&nbsp;&nbsp;<asp:Label id="Label28" runat="server" Text='<%# Eval("MotivoDesincorporacion") %>' />
                        </fieldset>
                         
                    </ContentTemplate>
                </cc1:TabPanel>

                <cc1:TabPanel HeaderText="Depreciación" runat="server" ID="TabPanel3" >
                    <ContentTemplate>  
                    
                        <table>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <fieldset style="text-align: left; margin-left: 15px; ">
                                        <legend>Depreciación (resumen):</legend>
                                        <br />
                                        <table>
                                            <tr align="center">
                                                <td>&nbsp;&nbsp;&nbsp;</td>
                                                <td style="text-align: right; "><b>Fecha compra: </b></td>
                                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                <td style="text-align: left; "><asp:Label id="Label10" runat="server" Text='<%# Eval("FechaCompra", "{0:dd-MMM-yyyy}") %>' /></td>
                                                <td>&nbsp;&nbsp;&nbsp;</td>
                                            </tr>
                                            <tr align="center">
                                                <td></td>
                                                <td style="text-align: right; "><b>Cant años:</b></td>
                                                <td>&nbsp;&nbsp;</td>
                                                <td style="text-align: left; "><asp:Label id="Label12" runat="server" Text='<%# Eval("NumeroDeAnos", "{0:N2}") %>' /></td>
                                                <td></td>
                                            </tr>
                                            <tr align="center">
                                                <td></td>
                                                <td style="text-align: right; "><b>Monto dep<br />mensual:</b></td>
                                                <td>&nbsp;&nbsp;</td>
                                                <td style="text-align: left; "><asp:Label id="Label13" runat="server" Text='<%# Eval("MontoDepreciacionMensual", "{0:N2}") %>' /></td>
                                                <td></td>
                                            </tr>
                                            <tr align="center">
                                                <td></td>
                                                <td style="text-align: right; "><b>Desde:</b></td>
                                                <td>&nbsp;&nbsp;</td>
                                                <td style="text-align: left; "><asp:Label id="Label14" runat="server" Text='<%# Eval("DepreciarDesdeMes") %>' />
                                                                 /
                                                                 <asp:Label id="Label17" runat="server" Text='<%# Eval("DepreciarDesdeAno") %>' />
                                                </td>
                                                <td></td>
                                            </tr>
                                            <tr align="center">
                                                <td></td>
                                                <td style="text-align: right; "><b>Hasta:</b></td>
                                                <td>&nbsp;&nbsp;</td>
                                                <td style="text-align: left; "><asp:Label id="Label15" runat="server" Text='<%# Eval("DepreciarHastaMes") %>' />
                                                                 /
                                                                 <asp:Label id="Label18" runat="server" Text='<%# Eval("DepreciarHastaAno") %>' />
                                                </td>
                                                <td></td>
                                            </tr>
                                            <tr align="center">
                                                <td></td>
                                                <td style="text-align: right; "><b>Cant meses:</b></td>
                                                <td>&nbsp;&nbsp;</td>
                                                <td style="text-align: left; "><asp:Label id="Label16" runat="server" Text='<%# Eval("CantidadMesesADepreciar") %>' /></td>
                                                <td></td>
                                            </tr>
                                
                                        </table> 
                                        <br />
                                </fieldset>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </table> 
                        <br />
                    </ContentTemplate>
                </cc1:TabPanel>

                <cc1:TabPanel HeaderText="Atributos" runat="server" ID="TabPanel4" >
                    <ContentTemplate>  
                    
                        <table>
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td>
                                    <asp:ListBox ID="lst_Atributos" 
                                                 runat="server" 
                                                 DataSourceID="AtributosAsignados_SqlDataSource"
                                                 DataTextField="NombreAtributo" 
                                                 AutoPostBack="False" 
                                                 Rows="10" />
                                </td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
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

    <asp:EntityDataSource ID="ActivosFijos_EntityDataSource" 
                          runat="server" 
                          ConnectionString="name=dbContab_ActFijos_Entities" 
                          DefaultContainerName="dbContab_ActFijos_Entities" 
                          EnableFlattening="False" 
                          Include="Compania, Proveedore, TiposDeProducto, tDepartamento, tEmpleado, Moneda1"
                          EntitySetName="InventarioActivosFijos"
                          Where="it.ClaveUnica = @ActivoFijoID" >
            <WhereParameters>
                <asp:Parameter Name="ActivoFijoID" Type="Int32" />
            </WhereParameters>
        </asp:EntityDataSource>

    <asp:SqlDataSource ID="AtributosAsignados_SqlDataSource" 
                        runat="server" 
                        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                        SelectCommand="SELECT a.Descripcion As NombreAtributo 
                                        FROM AtributosAsignados s Inner Join Atributos a On s.AtributoID = a.Atributo
                                        WHERE (s.ActivoFijoID = @ActivoFijoID) 
                                        ORDER BY a.Descripcion">
        <SelectParameters>
            <asp:Parameter Name="ActivoFijoID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>


</asp:Content>