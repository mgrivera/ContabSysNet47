<%--nótese como ponemos EnableEventValidation en false; esto es necesario para que funcionen los ajax cascading dropdownlists--%>
<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_Simple.master" CodeBehind="ConciliacionBancaria_Criterios.aspx.cs" Inherits="ContabSysNet_Web.Bancos.ConciliacionBancaria.ConciliacionBancaria_Criterios" 
    EnableEventValidation="false" EnableViewState="True" %>                
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <script type="text/javascript">
        function CloseCurrentWindow() {
            ///Parameters url=page to open, w=width, h=height
            window.close;
        }
        
    </script>

<div style="text-align: left; padding: 0px 20px 0px 20px; ">

  <%--  <ajaxToolkit:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
        TargetControlID="UpdatePanel1" Enabled="True">
        <Animations>
            <OnUpdating>
                <Parallel duration=".5">
                    <FadeOut minimumOpacity=".5" />
                </Parallel>
            </OnUpdating>
            <OnUpdated>
                <Parallel duration=".5">
                    <FadeIn minimumOpacity=".5" />
                </Parallel>
            </OnUpdated>
        </Animations>
    </ajaxToolkit:UpdatePanelAnimationExtender>--%>

   <%-- <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional" >
        <ContentTemplate>--%>

            <asp:HiddenField runat="server" ID="CiaContabSeleccionada_HiddenField" Value="0"/>

            <span id="ErrMessage_Span" 
                  runat="server" 
                  class="errmessage errmessage_background generalfont"
                  style="display: block;" />

            <asp:ValidationSummary ID="ValidationSummary1" 
                                   runat="server" 
                                   class="errmessage_background generalfont errmessage"
                                   ShowModelStateErrors="true"
                                   ForeColor="" />

            <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" Display="None" EnableClientScript="False" />

            <ajaxToolkit:tabcontainer id="TabContainer1" runat="server" activetabindex="0" >

                <ajaxToolkit:TabPanel HeaderText="Lista" runat="server" ID="TabPanel1" >

                    <ContentTemplate>

                       <asp:GridView runat="server" 
                                     ID="ConciliacionesBancarias_GridView"
                                     ItemType="ContabSysNet_Web.ModelosDatos_EF.Bancos.ConciliacionesBancaria" 
                                     DataKeyNames="ID" 
                                     SelectMethod="ConciliacionesBancarias_GridView_GetData"
                                     OnSelectedIndexChanged="ConciliacionesBancarias_GridView_SelectedIndexChanged"     
                                     AutoGenerateColumns="False" 
                                     AllowPaging="True" 
                                     PageSize="6"  
                                     CssClass="Grid">
                            <Columns>
                                <asp:buttonfield CommandName="Select" Text="Select"/>
                                <asp:boundfield DataField="Descripcion" HeaderText="Descripción" >
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>
                                <asp:boundfield datafield="Compania.NombreCorto" headertext="Cia contab">
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:boundfield>
                                
                                <asp:TemplateField HeaderText="Cuenta bancaria">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Item.CuentasBancaria.CuentaBancaria + " - " + Item.CuentasBancaria.Moneda1.Simbolo + " - " + Item.CuentasBancaria.Agencia1.Banco1.NombreCorto %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Cuenta contable">
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Item.CuentasContable.CuentaEditada + " - " + Item.CuentasContable.Descripcion %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                                <asp:DynamicField DataField="Desde" HeaderText="Desde" >
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle Wrap="False" HorizontalAlign="Center" />
                                </asp:DynamicField>
                                <asp:DynamicField DataField="Hasta" HeaderText="Hasta" >          
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle Wrap="False" HorizontalAlign="Center" />
                                </asp:DynamicField>
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

                        <br />
                
                        <asp:LinkButton ID="AddItem_LinkButton" runat="server" Text="Agregar nuevo registro" OnClick="AddItem_LinkButton_Click"/>

                    </ContentTemplate>

                    </ajaxToolkit:TabPanel>


                <ajaxToolkit:TabPanel HeaderText="Agregar" runat="server" ID="TabPanel2">
                    <ContentTemplate>
                        <asp:FormView runat="server" 
                                      ID="ConciliacionesBancarias_FormView"
                                      ItemType="ContabSysNet_Web.ModelosDatos_EF.Bancos.ConciliacionesBancaria"

                                      InsertMethod="ConciliacionesBancarias_FormView_InsertItem"
                                      SelectMethod="ConciliacionesBancarias_FormView_GetItem"
                                      UpdateMethod="ConciliacionesBancarias_FormView_UpdateItem"
                                      DeleteMethod="ConciliacionesBancarias_FormView_DeleteItem"

                                      OnItemInserted="ConciliacionesBancarias_FormView_ItemInserted"
                                      OnItemDeleted="ConciliacionesBancarias_FormView_ItemDeleted"
                                      OnItemUpdated="ConciliacionesBancarias_FormView_ItemUpdated" 

                                      OnDataBound="ConciliacionesBancarias_FormView_DataBound"
                                      OnItemUpdating="ConciliacionesBancarias_FormView_ItemUpdating"
                                      OnItemInserting="ConciliacionesBancarias_FormView_ItemInserting"

                                      DataKeyNames="ID"
                            
                                      BackColor="White" 
                                      BorderColor="#E7E7FF" 
                                      BorderStyle="None" 
                                      BorderWidth="1px" 
                                      CellPadding="3" 
                                      GridLines="Horizontal" Font-Size="Small">

                            <ItemTemplate>
                                <table cellspacing="10px" style="border: 1px solid #808080; font-size: x-small;">
                                    <tr>
                                        <td style="text-align: left; font-weight: bold; ">Cia contab:</td>
                                        <td><%# Eval("Compania.NombreCorto") %></td>
                                        <td>&nbsp;</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; font-weight: bold; ">Descripción:</td>
                                        <td><asp:DynamicControl ID="DynamicControl1" runat="server" DataField="Descripcion" Mode="ReadOnly" /></td>
                                        <td>&nbsp;</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; font-weight: bold; ">Desde:</td>
                                        <td><asp:DynamicControl ID="DynamicControl2" runat="server" DataField="Desde" Mode="ReadOnly" /></td>
                                        <td>&nbsp;</td>
                                        <td style="text-align: left; font-weight: bold; ">Hasta:</td>
                                        <td><asp:DynamicControl ID="DynamicControl3" runat="server" DataField="Hasta" Mode="ReadOnly" /></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; text-wrap:avoid; font-weight: bold; ">Cuenta bancaria:</td>
                                        <td><%# Eval("CuentasBancaria.CuentaBancaria") %> &nbsp;-&nbsp;
                                            <%# Eval("CuentasBancaria.Moneda1.Simbolo") %> &nbsp;-&nbsp; 
                                            <%# Eval("CuentasBancaria.Agencia1.Banco1.Abreviatura") %></td>
                                        <td>&nbsp;</td>
                                        <td style="text-align: left; text-wrap: avoid; font-weight: bold; ">Cuenta contable:</td>
                                        <td><%# Eval("CuentasContable.CuentaEditada") %><br />
                                            <%# Eval("CuentasContable.Descripcion") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td>&nbsp;</td>
                                        <td></td>
                                        <td style="text-align: center; margin-right: 15px; ">
                                            <asp:LinkButton id="Edit_LinkButton" Text="Editar" CommandName="Edit" Runat="server"  />
                                            &nbsp;&nbsp;
                                            <asp:LinkButton id="Delete_LinkButton" Text="Eliminar" CommandName="Delete" 
                                                            OnClientClick="return confirm('Desea eliminar este registro?');" 
                                                            runat="server" />
                                            &nbsp;&nbsp;
                                            <asp:LinkButton id="New_LinkButton" Text="Nuevo" CommandName="New" Runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>

                            <InsertItemTemplate>
                                <table style="width: 100%; font-size: x-small; ">
                                    <tr>
                                        <td style="text-align: left; ">Cia contab:</td>
                                        <td>
                                            <asp:DropDownList ID="CiasContab_DropDownList"
                                                              AutoPostBack="true" 
                                                              runat="server"
                                                              DataTextField="NombreCorto"
                                                              DataValueField="Numero"
                                                              SelectedValue="<%# BindItem.CiaContab %>" 
                                                              OnDataBinding="CiasContab_DDL_DataBinding"
                                                              OnSelectedIndexChanged="CiasContab_DropDownList_SelectedIndexChanged"
                                                              Font-Size="X-Small">
                                            </asp:DropDownList>

                                            <asp:SqlDataSource ID="CiasContab_SqlDataSource" 
                                                               runat="server" 
                                                               ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
                                                               SelectCommand="SELECT NombreCorto, Numero FROM Companias Order By NombreCorto">
                                            </asp:SqlDataSource>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; ">Descripción:</td>
                                        <td>
                                            <asp:TextBox ID="Descripcion_TextBox" runat="server" Text='<%# Bind("Descripcion") %>' Font-Size="X-Small" TextMode="MultiLine" Rows="3" Width="250px" />
                                        </td>
                                        <td>&nbsp;</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; ">Desde:</td>
                                        <td>
                                            <asp:TextBox ID="Desde_TextBox" runat="server" Text='<%# Bind("Desde", "{0:dd/MM/yyyy}") %>' Font-Size="X-Small" />
                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="Desde_TextBox" Format="d-MM-yyyy" PopupPosition="BottomLeft" />
                                        </td>
                                        <td>&nbsp;</td>
                                        <td style="text-align: left; ">Hasta:</td>
                                        <td>
                                            <asp:TextBox ID="Hasta_TextBox" runat="server" Text='<%# Bind("Hasta_TextBox", "{0:dd/MM/yyyy}") %>' Font-Size="X-Small" />
                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="Hasta_TextBox" Format="d-MM-yyyy" PopupPosition="BottomLeft" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; ">Cuenta bancaria:</td>
                                        <td>
                                            <asp:DropDownList ID="CuentasBancarias_DropDownList" 
                                                                  runat="server"
                                                                  DataSourceID="CuentasBancarias_SqlDataSource"
                                                                  DataTextField="CuentaBancaria"
                                                                  DataValueField="CuentaInterna" Font-Size="X-Small" />

                                            <asp:SqlDataSource ID="CuentasBancarias_SqlDataSource" 
                                                               runat="server" 
                                                               ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
                                                               SelectCommand="SELECT CuentasBancarias.CuentaInterna, CuentasBancarias.CuentaBancaria + ' - ' + Monedas.Simbolo + ' - ' + 
                                                                                Bancos.NombreCorto AS CuentaBancaria FROM CuentasBancarias INNER JOIN Agencias ON CuentasBancarias.Agencia = Agencias.Agencia 
                                                                                INNER JOIN Bancos ON Agencias.Banco = Bancos.Banco INNER JOIN Monedas ON CuentasBancarias.Moneda = Monedas.Moneda 
                                                                                Where CuentasBancarias.Cia = @CiaContab 
                                                                                ORDER BY Bancos.NombreCorto, CuentaBancaria">

                                                <SelectParameters>
                                                    <asp:Parameter Name="CiaContab" />
                                                </SelectParameters>

                                             </asp:SqlDataSource>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td style="text-align: left; ">Cuenta contable:</td>
                                        <td style="width: 100px; ">
                                            <asp:DropDownList ID="CuentasContables_DropDownList" 
                                                              runat="server"
                                                              DataSourceID="CuentasContables_SqlDataSource"
                                                              DataTextField="CuentaContable"
                                                              DataValueField="ID" Font-Size="X-Small" />

                                             <asp:SqlDataSource ID="CuentasContables_SqlDataSource" 
                                                                runat="server" 
                                                                ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
                                                                SelectCommand="SELECT CuentasContables.ID, 
                                                                                CuentasContables.Cuenta + ' - ' + Lower((Substring(CuentasContables.Descripcion, 1, 30))) AS CuentaContable 
                                                                                FROM CuentasContables
                                                                                Where CuentasContables.Cia = @CiaContab And CuentasContables.TotDet = 'D' 
                                                                                ORDER BY CuentasContables.Cuenta">
    
                                                <SelectParameters>
                                                    <asp:Parameter Name="CiaContab" />
                                                </SelectParameters>

                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td>&nbsp;</td>
                                        <td></td>
                                        <td style="text-align: center; margin-right: 15px; ">
                                            <asp:LinkButton ID="InsertButton" runat="server" Text="Agregar" CommandName="Insert" />
                                            &nbsp;&nbsp;
                                            <asp:LinkButton ID="CancelButton" runat="server" Text="Cancelar" CommandName="Cancel" CausesValidation="False" />
                                        </td>
                                    </tr>
                                </table>
                            </InsertItemTemplate>

                            <EditItemTemplate>
                                <table style="width: 100%; font-size: x-small; ">
                                    <tr>
                                        <td style="text-align: left; ">Cia contab:</td>
                                        <td><%# Eval("Compania.NombreCorto") %></td>
                                        <%--<td>
                                            <asp:DropDownList ID="CiasContab_DropDownList"
                                                              AutoPostBack="true" 
                                                              runat="server"
                                                              DataSourceID="CiasContab_SqlDataSource"
                                                              DataTextField="NombreCorto"
                                                              DataValueField="Numero"
                                                              SelectedValue="<%# BindItem.CiaContab %>" 
                                                              OnSelectedIndexChanged="CiasContab_DropDownList_SelectedIndexChanged"
                                                              AppendDataBoundItems="True" Font-Size="X-Small">
                                                <asp:ListItem Text=" " Value="-999" />
                                            </asp:DropDownList>

                                            <asp:SqlDataSource ID="CiasContab_SqlDataSource" 
                                                               runat="server" 
                                                               ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
                                                               SelectCommand="SELECT NombreCorto, Numero FROM Companias Order By NombreCorto">
                                            </asp:SqlDataSource>
                                        </td>--%>
                                        <td>&nbsp;</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; ">Descripción:</td>
                                        <td>
                                            <asp:TextBox ID="Descripcion_TextBox" runat="server" Text='<%# Bind("Descripcion") %>' Font-Size="X-Small" TextMode="MultiLine" Rows="3" Width="250px" />
                                        </td>
                                        <td>&nbsp;</td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; ">Desde:</td>
                                        <td>
                                            <asp:TextBox ID="Desde_TextBox" runat="server" Text='<%# Bind("Desde", "{0:dd/MM/yyyy}") %>' Font-Size="X-Small" />
                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="Desde_TextBox" Format="d-MM-yyyy" PopupPosition="BottomLeft" />
                                        </td>
                                        <td>&nbsp;</td>
                                        <td style="text-align: left; ">Hasta:</td>
                                        <td>
                                            <asp:TextBox ID="Hasta_TextBox" runat="server" Text='<%# Bind("Hasta", "{0:dd/MM/yyyy}") %>' Font-Size="X-Small" />
                                            <ajaxToolkit:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="Hasta_TextBox" Format="d-MM-yyyy" PopupPosition="BottomLeft" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; ">Cuenta bancaria:</td>
                                        <td>
                                            <asp:DropDownList ID="CuentasBancarias_DropDownList" 
                                                                  runat="server"
                                                                  DataSourceID="CuentasBancarias_SqlDataSource"
                                                                  DataTextField="CuentaBancaria"
                                                                  DataValueField="CuentaInterna" Font-Size="X-Small" />

                                            <asp:SqlDataSource ID="CuentasBancarias_SqlDataSource" 
                                                               runat="server" 
                                                               ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
                                                               SelectCommand="SELECT CuentasBancarias.CuentaInterna, CuentasBancarias.CuentaBancaria + ' - ' + Monedas.Simbolo + ' - ' + 
                                                                                Bancos.NombreCorto AS CuentaBancaria FROM CuentasBancarias INNER JOIN Agencias ON CuentasBancarias.Agencia = Agencias.Agencia 
                                                                                INNER JOIN Bancos ON Agencias.Banco = Bancos.Banco INNER JOIN Monedas ON CuentasBancarias.Moneda = Monedas.Moneda 
                                                                                Where CuentasBancarias.Cia = @CiaContab 
                                                                                ORDER BY Bancos.NombreCorto, CuentaBancaria">

                                                <SelectParameters>
                                                    <asp:Parameter Name="CiaContab" />
                                                </SelectParameters>

                                             </asp:SqlDataSource>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td style="text-align: left; ">Cuenta contable:</td>
                                        <td style="width: 100px; ">
                                            <asp:DropDownList ID="CuentasContables_DropDownList" 
                                                              runat="server"
                                                              DataSourceID="CuentasContables_SqlDataSource"
                                                              DataTextField="CuentaContable"
                                                              DataValueField="ID" Font-Size="X-Small"/>

                                             <asp:SqlDataSource ID="CuentasContables_SqlDataSource" 
                                                                runat="server" 
                                                                ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
                                                                SelectCommand="SELECT CuentasContables.ID, 
                                                                                CuentasContables.Cuenta + ' - ' + Lower((Substring(CuentasContables.Descripcion, 1, 30))) AS CuentaContable 
                                                                                FROM CuentasContables
                                                                                Where CuentasContables.Cia = @CiaContab And CuentasContables.TotDet = 'D' 
                                                                                ORDER BY CuentasContables.Cuenta">
    
                                                <SelectParameters>
                                                    <asp:Parameter Name="CiaContab" />
                                                </SelectParameters>

                                            </asp:SqlDataSource>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td>&nbsp;</td>
                                        <td></td>
                                        <td style="text-align: center; margin-right: 15px; ">
                                            <asp:LinkButton ID="UpdateButton" runat="server" Text="Modificar" CommandName="Update" />
                                            &nbsp;&nbsp;
                                            <asp:LinkButton ID="CancelButton" runat="server" Text="Cancelar" CommandName="Cancel" CausesValidation="False" />
                                        </td>
                                    </tr>
                                </table>
                            </EditItemTemplate>

                            <EmptyDataTemplate>
                                <div style="margin: 15px 80px 15px 15px; background-color: #EAEAEA; border: 1px solid #808000; ">
                                    <span>
                                        Haga un click en <em><b>Agregar nuevo registro</b></em> para agregar un registro ...
                                    </span>
                                </div>
                                
                                <asp:LinkButton ID="AddItem2_LinkButton" runat="server" Text="Agregar nuevo registro" OnClick="AddItem_LinkButton_Click"/>
                            </EmptyDataTemplate>

                            <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                            <HeaderStyle BackColor="#4A3C8C" Font-Bold="True" ForeColor="#F7F7F7" />
                            <EditRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                            <PagerStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" HorizontalAlign="Right" />
                            <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" Font-Size="Small" />

                        </asp:FormView>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>

            </ajaxToolkit:tabcontainer>

            <div style="text-align: right; margin-top: 15px; ">
                <asp:Button ID="Button1" 
                            runat="server" 
                            Text="Establecer conciliación" 
                            ToolTip="Para establecer los criterios de conciliación bancaria que se usarán en el resto del proceso"  
                            OnClick="Button1_Click"/>
            </div>

          <%--  </ContentTemplate>
        </asp:UpdatePanel>--%>

</div>

<asp:panel style="text-align: right; padding: 20px;" 
           runat="server">

</asp:panel>
       
                                  
</asp:Content>