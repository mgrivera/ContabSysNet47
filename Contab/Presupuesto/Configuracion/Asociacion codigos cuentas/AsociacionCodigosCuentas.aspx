<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Configuracion_Asociacion_codigos_cuentas_AsociacionCodigosCuentas" Codebehind="AsociacionCodigosCuentas.aspx.cs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        
<div class="notsosmallfont">
    <table>
        <tr>
            <td style="width:25%; "></td>
            <td style="width:25%; text-align: left; ">Cias Contab 
                <asp:DropDownList ID="CiasContab_DropDownList" runat="server" 
                    DataSourceID="CiasContab_SqlDataSource" DataTextField="NombreCorto" 
                    DataValueField="Numero" AutoPostBack="True" 
                    onselectedindexchanged="CiasContab_DropDownList_SelectedIndexChanged" AppendDataBoundItems="True">
                    <asp:ListItem Text="Seleccione una compañía Contab" Value="-1" />
                </asp:DropDownList>
            </td>
            <td style="width:25%; ">(Seleccione una Cia Contab para mostrar sus códigos de presupuesto, 
                sus cuentas contables y permitir su asociación) 
            </td>
            <td style="width:25%; "></td>
        </tr>
    </table>
 </div>   
 
<br />
<hr style="color: #B0BDDB; line-height: 1px;" />
    <div style="width: 80%; text-align: center;">
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;"></span>
    </div>

<br />
 <div class="notsosmallfont">
     <table>
         <tr>
             <td>
                 <table>
                     <tr>
                         <td class="ListViewHeader_Suave generalfont">Códigos de presupuesto
                         </td>
                     </tr>
                     <tr>
                         <td>
                             <asp:ListBox ID="CodigosPresupuesto_ListBox" runat="server" DataSourceID="CodigosPresupuesto_SqlDataSource"
                                 DataTextField="Descripcion" DataValueField="Codigo" Height="193px" Width="200px"
                                 CssClass="notsosmallfont"></asp:ListBox>
                                 
                             <cc1:listsearchextender id="ListSearchExtender1" runat="server" targetcontrolid="CodigosPresupuesto_ListBox"
                                 prompttext="tipee para buscar" promptcssclass="smallfont" PromptPosition="Bottom">
                             </cc1:listsearchextender>
                         </td>
                     </tr>
                 </table> 
             </td>
             <td>
                 &nbsp;&nbsp;
             </td>
             <td>
                 <table>
                     <tr>
                         <td class="ListViewHeader_Suave generalfont">
                             Cuentas contables
                         </td>
                     </tr>
                     <tr>
                         <td>
                             <asp:ListBox ID="CuentasContables_ListBox" runat="server" DataSourceID="CuentasContables_SqlDataSource"
                                 DataTextField="Descripcion" DataValueField="ID" Height="193px" SelectionMode="Multiple"
                                 Width="386px" CssClass="notsosmallfont"></asp:ListBox>
                                 
                             <cc1:listsearchextender id="ListSearchExtender2" runat="server" targetcontrolid="CuentasContables_ListBox"
                                 prompttext="tipee para buscar" promptcssclass="smallfont" PromptPosition="Bottom">
                             </cc1:listsearchextender>
                         </td>
                     </tr>
                 </table>
             </td>
         </tr>
         <tr>
             <td>
                 1) Leer las cuentas contables asociadas<br /> al código de presupuesto seleccionado
                 <asp:Button ID="LeerCuentasContablesAsociadas_Button" runat="server" 
                     Text="" onclick="LeerCuentasContablesAsociadas_Button_Click" Height="19px" Width="25px" />
                 <br /><br />
                 <span id="CodigosPresupuesto_Message_Span" runat="server" class="infomessage infomessage_background generalfont"
                    style="display: block;"></span>
             </td>
             <td>
                 &nbsp;&nbsp;
             </td>
             <td>
                 2) Asociar las cuentas contables seleccionadas<br />  al códigode presupuesto seleccionado
                 <asp:Button ID="AsociarCodigosACuentaContable_Button" runat="server" 
                     Text="" onclick="AsociarCodigosACuentaContable_Button_Click" Height="19px" Width="25px" />
                 <br /><br />
                 <span id="CuentasContables_Message_Span" runat="server" class="infomessage infomessage_background generalfont"
                    style="display: block;"></span>
             </td>
         </tr>
     </table>
 
 
 
 
 
 
 </div>    
 
       
    <asp:SqlDataSource ID="CiasContab_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT Numero, NombreCorto FROM Companias ORDER BY NombreCorto">
    </asp:SqlDataSource> 
        
    <asp:SqlDataSource ID="CodigosPresupuesto_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        
        SelectCommand="SELECT Codigo, Codigo + ' - '  + Descripcion As Descripcion FROM Presupuesto_Codigos WHERE (GrupoFlag IS NOT NULL) AND (GrupoFlag = 0) AND (CiaContab = @CiaContab) ORDER BY Codigo">
        <SelectParameters>
             <asp:Parameter DefaultValue="-999" Name="CiaContab" />
        </SelectParameters>
    </asp:SqlDataSource> 
        
    <asp:SqlDataSource ID="CuentasContables_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        
        SelectCommand="SELECT ID, Cuenta + ' - '  + Descripcion As Descripcion FROM CuentasContables WHERE (TotDet = 'D') AND (Cia = @CiaContab) ORDER BY Cuenta">
        <SelectParameters>
            <asp:Parameter DefaultValue="-999" Name="CiaContab" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    </ContentTemplate>
    </asp:UpdatePanel>
    
</asp:Content>

