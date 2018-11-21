<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios.MovimientosBancarios_ExportarInfoWord" Codebehind="MovimientosBancarios_ExportarInfoWord.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

  <div style="margin: 5px;" class="generalfont">
        <fieldset>
            <legend>Indique un tipo de información que desea exportar: </legend>
                <div style="padding: 15px 5px 15px 5px; text-align: left; ">
                    Tipo de información:<br /> 
               
                    <asp:DropDownList ID="TipoProceso_DropDownList" 
                                      runat="server">
                        <asp:ListItem Selected="True">Seleccione un tipo de proceso</asp:ListItem>
                        <asp:ListItem Value="10">Ordenes de pago</asp:ListItem>
                    </asp:DropDownList>

                    <br /><br />

                    <asp:Button runat="server" 
                                style="margin: 5px; float:right; "
                                ID="Ok_Button" 
                                onclick="Ok_Button_Click" 
                                Text="Iniciar proceso" /> 
                </div>
        </fieldset>
    </div>
    
</asp:Content>
