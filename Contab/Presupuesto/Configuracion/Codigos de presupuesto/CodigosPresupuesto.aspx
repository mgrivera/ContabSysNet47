<%@ Page Title="Códigos de presupuesto" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Configuracion_Codigos_de_presupuesto_CodigosPresupuesto" Codebehind="CodigosPresupuesto.aspx.cs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!-- Enable dynamic behavior. The GridView must be 
     registered with the manager. See code-behind file. -->
    <asp:DynamicDataManager ID="DynamicDataManager1" runat="server" AutoLoadForeignKeys="true" />

<%--  --%>

    <div style="text-align: left; width: 85%;">
       
    <table class="notsosmallfont" style="border: 1px solid #9BBCFF; text-align: left; " 
            cellspacing="10">
        <tr>
            <td>Cantidad de niveles: 
            </td>
            <td>
                <asp:DropDownList ID="CantidadNiveles_DropDownList" runat="server">
                    <asp:ListItem Value="1" Text="1" Selected="True" />
                    <asp:ListItem Value="2" Text="2" />
                    <asp:ListItem Value="3" Text="3" />
                    <asp:ListItem Value="4" Text="4" />
                    <asp:ListItem Value="5" Text="5" />
                    <asp:ListItem Value="6" Text="6" />
                    <asp:ListItem Value="7" Text="7" />
                </asp:DropDownList>
            </td>
            <td>(Indique la cantidad de niveles de los códigos que desea editar o grabar)
            </td>
            <td>Códigos de agrupación: 
            </td>
            <td>
                <asp:CheckBox ID="Grupo_CheckBox" runat="server" Text="" />
            </td>
            <td>(Indique si los códigos a tratar son grupos, o si son, directamente, códigos de presupuesto)
            </td>
        </tr>
        <tr>
            <td>Compañía: 
            </td>
            <td>
                <asp:DropDownList ID="CiasContab_DropDownList" runat="server" 
                    DataSourceID="CiasContab_SqlDataSource" DataTextField="NombreCia" 
                    DataValueField="Numero">
                </asp:DropDownList>
            </td>
            <td>(Indique la compañía (Contab) a la cual corresponden los códigos a tratar)
            </td>
            <td>
            </td>
            <td>
                <asp:Button ID="Ok_Button" runat="server" Text="Ok" Height="21px" 
                    Width="75px" onclick="Ok_Button_Click" CausesValidation="False" />
            </td>
            <td>(Haga un click en Ok para leer y mostrar los códigos que existan para el criterio indicado)
            </td>
        </tr>
    </table>
    
        <table id="EditarCodigosPresupuesto_Table" runat="server" style="border: 1px solid #9BBCFF; margin-top: 5px; margin-bottom: 5px; " >
            <tr>
                <td style="border: 0px solid #C0C0C0; width: 30%; vertical-align: top; text-align: center; ">
                    <br />
                    <asp:ListBox ID="NivelesPrevios_ListBox" runat="server" 
                        DataSourceID="NivelesPrevios_SqlDataSource" DataTextField="Descripcion" 
                        DataValueField="Codigo" Rows="10"></asp:ListBox>
                        
                    <cc1:ListSearchExtender ID="ListSearchExtender1" runat="server" 
                        TargetControlID="NivelesPrevios_ListBox" PromptText="tipee para buscar" PromptCssClass="smallfont">
                    </cc1:ListSearchExtender>
                </td>
                <td style="border: 1px solid #C0C0C0; width: 5%; "></td>
                <td style="border: 0px solid #C0C0C0; width: 60%;  text-align: center; vertical-align: top; ">
                    
                    <%--<asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>--%>
                        
                            <!-- Para mostrar errores que no son de dynamic data -->
                            <span id="ErrMessage_Span" runat="server" 
                                class="errmessage errmessage_background generalfont"
                                style="display: block;"></span>
                        
                            <!-- Capture validation exceptions -->
                            
                            <asp:DynamicValidator ID="DynamicValidator3" 
                                CssClass="errmessage errmessage_background generalfont" 
                                ControlToValidate="PresupuestoCodigos_ListView" 
                                runat="server" 
                                Display="Dynamic" /> 
                                
                            <asp:DynamicValidator ID="DynamicValidator0" 
                                CssClass="errmessage errmessage_background generalfont" 
                                ControlToValidate="PresupuestoCodigos_ListView" 
                                runat="server" 
                                Display="Dynamic" 
                                ValidationGroup="InsertValGroup" /> 
                                                  
                            <asp:DynamicValidator ID="DynamicValidator1" 
                                CssClass="errmessage errmessage_background generalfont" 
                                ControlToValidate="PresupuestoCodigos_ListView" 
                                runat="server" 
                                Display="Dynamic" 
                                ValidationGroup="EditValGroup"  /> 
                            
                            <asp:DynamicValidator ID="DynamicValidator2" 
                                CssClass="errmessage errmessage_background generalfont" 
                                ControlToValidate="PresupuestoCodigos_ListView" 
                                runat="server" Display="Dynamic" 
                                ValidationGroup="DelValGroup"  /> 
                                
                            <asp:ListView ID="PresupuestoCodigos_ListView" 
                                          runat="server" 
                                          DataKeyNames="Codigo,CiaContab"
                                          DataSourceID="PresupuestoCodigos_LinqDataSource" 
                                          InsertItemPosition="LastItem"
                                          OnItemInserting="PresupuestoCodigos_ListView_ItemInserting" 
                                          OnItemCreated="PresupuestoCodigos_ListView_ItemCreated" 
                                          oniteminserted="PresupuestoCodigos_ListView_ItemInserted">
                                <LayoutTemplate>
                                    <table id="Table1" runat="server">
                                        <tr id="Tr1" runat="server">
                                            <td id="Td1" runat="server">
                                                <table id="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                                                    class="notsosmallfont" cellspacing="0" rules="none">
                                                    <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave">
                                                        <th id="Th1" runat="server">
                                                        </th>
                                                        <th id="Th2" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                            padding-top: 8px;">
                                                            Código
                                                        </th>
                                                        <th id="Th3" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                            padding-top: 8px;">
                                                            Descripción
                                                        </th>
                                                        <th id="Th4" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                            padding-top: 8px;">
                                                            Grupo
                                                        </th>
                                                        <th id="Th5" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                            padding-top: 8px;">
                                                            Suspendido
                                                        </th>
                                                    </tr>
                                                    <tr id="itemPlaceholder" runat="server">
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr id="Tr3" runat="server">
                                            <td id="Td2" runat="server" style="">
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
                                            <asp:ImageButton ID="Edit_Button" runat="server" CommandName="Edit" Text="Edit" ImageUrl="~/Pictures/ListView_Buttons/edit_14x14.png"
                                                CausesValidation="False" ToolTip="Editar" />
                                            <asp:ImageButton ID="Delete_Button" runat="server" CommandName="Delete" Text="Delete"
                                                ImageUrl="~/pictures/ListView_Buttons/delete_14x14.png" CausesValidation="False"
                                                ToolTip="Eliminar" />
                                            <cc1:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" TargetControlID="Delete_Button"
                                                ConfirmText="¿Desea eliminar el registro?">
                                            </cc1:ConfirmButtonExtender>
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:DynamicControl ID="Codigo_DynamicControl" runat="server" DataField="Codigo"
                                                Mode="ReadOnly" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:DynamicControl ID="Descripcion_DynamicControl" runat="server" DataField="Descripcion"
                                                Mode="ReadOnly" />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:DynamicControl ID="GrupoFlag_DynamicControl" runat="server" DataField="GrupoFlag"
                                                Mode="ReadOnly" />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:DynamicControl ID="SuspendidoFlag_DynamicControl" runat="server" DataField="SuspendidoFlag"
                                                Mode="ReadOnly" />
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr style="" class="ListViewAlternatingRow">
                                        <td>
                                            <asp:ImageButton ID="Edit_Button" runat="server" CommandName="Edit" Text="Edit" ImageUrl="~/Pictures/ListView_Buttons/edit_14x14.png"
                                                CausesValidation="False" ToolTip="Editar" />
                                            <asp:ImageButton ID="Delete_Button" runat="server" CommandName="Delete" Text="Delete"
                                                ImageUrl="~/pictures/ListView_Buttons/delete_14x14.png" CausesValidation="False"
                                                ToolTip="Eliminar" />
                                            <cc1:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" TargetControlID="Delete_Button"
                                                ConfirmText="¿Desea eliminar el registro?">
                                            </cc1:ConfirmButtonExtender>
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:DynamicControl ID="Codigo_DynamicControl" runat="server" DataField="Codigo"
                                                Mode="ReadOnly" />
                                        </td>
                                        <td class="padded" style="text-align: left;">
                                            <asp:DynamicControl ID="Descripcion_DynamicControl" runat="server" DataField="Descripcion"
                                                Mode="ReadOnly" />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:DynamicControl ID="GrupoFlag_DynamicControl" runat="server" DataField="GrupoFlag"
                                                Mode="ReadOnly" />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:DynamicControl ID="SuspendidoFlag_DynamicControl" runat="server" DataField="SuspendidoFlag"
                                                Mode="ReadOnly" />
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <InsertItemTemplate>
                                    <tr style="">
                                        <td>
                                            <asp:ImageButton ID="Insert_Button" runat="server" CommandName="Insert" Text="Insert"
                                                ImageUrl="~/pictures/ListView_Buttons/add_14x14.png" ValidationGroup="InsertValGroup"
                                                CausesValidation="True"
                                                ToolTip="Agregar" />
                                            <asp:ImageButton ID="Cancel_Button" runat="server" CommandName="Cancel" Text="Clear"
                                                ImageUrl="~/pictures/ListView_Buttons/undo1_14x14.png" CausesValidation="False"
                                                ToolTip="Cancelar" />
                                        </td>
                                        <td>
                                            <asp:DynamicControl ID="Codigo_DynamicControl" runat="server" DataField="Codigo"
                                                Mode="Insert" ValidationGroup="InsertValGroup" />
                                        </td>
                                        <td>
                                            <asp:DynamicControl ID="Descripcion_DynamicControl" runat="server" DataField="Descripcion"
                                                Mode="Insert" ValidationGroup="InsertValGroup" />
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="GrupoFlag_CheckBox" runat="server" Checked='<%# Bind("GrupoFlag") %>' />
                                            <asp:DynamicControl ID="CantNiveles_DynamicControl" runat="server" DataField="CantNiveles"
                                                Mode="Insert" Visible="False" />
                                            <asp:DynamicControl ID="CiaContab_DynamicControl" runat="server" DataField="CiaContab"
                                                Mode="Insert" Visible="False" />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:DynamicControl ID="SuspendidoFlag_DynamicControl" runat="server" DataField="SuspendidoFlag"
                                                Mode="Insert" ValidationGroup="InsertValGroup" />
                                        </td>
                                    </tr>
                                </InsertItemTemplate>
                                <EditItemTemplate>
                                    <tr style="">
                                        <td>
                                            <asp:ImageButton ID="Update_Button" runat="server" CommandName="Update" Text="Update"
                                                ImageUrl="~/pictures/ListView_Buttons/ok_14x14.png" ValidationGroup="EditValGroup"
                                                ToolTip="Actualizar" />
                                            <asp:ImageButton ID="Cancel_Button" runat="server" CommandName="Cancel" Text="Clear"
                                                ImageUrl="~/pictures/ListView_Buttons/undo1_14x14.png" CausesValidation="False"
                                                ToolTip="Cancelar" />
                                        </td>
                                        <td>
                                            <asp:DynamicControl ID="Codigo_DynamicControl" runat="server" ValidationGroup="EditValGroup"
                                                DataField="Codigo" Mode="Edit" />
                                        </td>
                                        <td>
                                            <asp:DynamicControl ID="Descripcion_DynamicControl2" runat="server" ValidationGroup="EditValGroup"
                                                DataField="Descripcion" Mode="Edit" />
                                        </td>
                                        <td>
                                            <asp:DynamicControl ID="GrupoFlag_DynamicControl" runat="server" ValidationGroup="EditValGroup"
                                                DataField="GrupoFlag" Mode="Edit" />
                                        </td>
                                        <td class="padded" style="text-align: center;">
                                            <asp:DynamicControl ID="SuspendidoFlag_DynamicControl" runat="server" DataField="SuspendidoFlag"
                                                Mode="Edit" ValidationGroup="EditValGroup" />
                                        </td>
                                    </tr>
                                </EditItemTemplate>
                                <EmptyDataTemplate>
                                    <table id="Table2" runat="server" style="">
                                        <tr>
                                            <td>
                                                No data was returned.
                                            </td>
                                        </tr>
                                    </table>
                                </EmptyDataTemplate>
                            </asp:ListView>
                            
                       <%-- </ContentTemplate>
                    </asp:UpdatePanel>--%>
                </td>
            </tr>
            <tr>
                <td style="width: 30%;  text-align: center; ">
                    <span id="ListBoxHelp_Span" runat="server">
                        (Seleccione de la lista el código para el cual va a agregar 'sub niveles') 
                    </span>
                </td>
                 <td style="width: 5%; "></td>
                <td style="width: 60%;  text-align: center; ">
                <span id="ListBoxHelp2_Span" runat="server">
                    
                </span>
                </td>
            </tr>
        </table>
    
    
    
    </div>
    
    <asp:SqlDataSource ID="CiasContab_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT Numero, NombreCorto AS NombreCia FROM Companias ORDER BY NombreCia"></asp:SqlDataSource>
        
    <asp:SqlDataSource ID="NivelesPrevios_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        
    SelectCommand="SELECT Codigo, CASE SuspendidoFlag WHEN 0 THEN CASE GrupoFlag WHEN 1 THEN Codigo + '  ' + Descripcion + '  (grupo)' ELSE Codigo + '  ' + Descripcion END ELSE CASE GrupoFlag WHEN 1 THEN Codigo + '  ' + Descripcion + '  (grupo - susp)' ELSE Codigo + '  ' + Descripcion  + '  (susp)' END END AS Descripcion FROM Presupuesto_Codigos WHERE (CantNiveles = @CantNiveles) AND (CiaContab = @CiaContab) ORDER BY Codigo">
        <SelectParameters>
            <asp:Parameter DefaultValue="-99" Name="CantNiveles" />
            <asp:Parameter DefaultValue="-99" Name="CiaContab" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    <asp:LinqDataSource ID="PresupuestoCodigos_LinqDataSource" runat="server" 
        ContextTypeName="ContabSysNet_Web.ModelosDatos.dbContabDataContext" 
            EnableDelete="True" EnableInsert="True" 
            EnableUpdate="True" OrderBy="Codigo" TableName="Presupuesto_Codigos" 
            Where="CantNiveles == @CantNiveles &amp;&amp; CiaContab == @CiaContab">
        <WhereParameters>
            <asp:Parameter Name="CantNiveles" Type="Int16" DefaultValue="-99" />
            <asp:Parameter Name="CiaContab" Type="Int32" DefaultValue="-99" />
        </WhereParameters>
    </asp:LinqDataSource>
    
</asp:Content>

