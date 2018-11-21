<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.Master" AutoEventWireup="true" CodeBehind="Facturas_ExportarAExcel.aspx.cs" Inherits="ContabSysNet_Web.Bancos.Consultas_facturas.Facturas.Facturas_ExportarAExcel" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="notsosmallfont" 
         style="width: 20%; border: 1px solid #C0C0C0; vertical-align: top; background-color: #F7F7F7; float: left; text-align: center; padding: 5px; margin-left: 5px; ">
        
        <br />

        <asp:ImageButton ID="DownLoadFile_ImageButton" 
                         runat="server" 
                         ImageUrl="~/Pictures/download_25x25.png" 
                         OnClick="DownLoadFile_ImageButton_Click" />

        <asp:LinkButton ID="DownLoadFile2_LinkButton" 
                        runat="server" 
                        OnClick="DownLoadFile2_LinkButton_Click">Download
        </asp:LinkButton>

        <hr />

    </div>

    <div style="float: right; width: 70%;">

        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <span id="GeneralMessage_Span" runat="server" class="infomessage infomessage_background generalfont" style="display: block;" />
                <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

                <fieldset style="margin: 0px 5px 10px 5px; padding: 5px; text-align: center;" class="generalfont">
                    <legend>Seleccione una opción: </legend>
                    <br />
                    <asp:DropDownList ID="ExportarMicrosoftExcel_DropDownList"
                        runat="server"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ExportarMicrosoftExcel_DropDownList_SelectedIndexChanged">
                        <asp:ListItem Value="0">Seleccione una opción ...</asp:ListItem>
                        <asp:ListItem Value="1">Libro de ventas</asp:ListItem>
                        <asp:ListItem Value="2">Libro de compras</asp:ListItem>
                    </asp:DropDownList>
                </fieldset>

                <fieldset runat="server" id="OpcionesReporte_Fieldset" visible="false" class="generalfont" style="margin: 0px 5px 0px 0px; " >
                    <legend class="generalfont">Indique un período ...</legend>

                    <div style="padding: 15px; white-space: nowrap; ">

                        <asp:TextBox ID="Periodo_FechaInicial_TextBox" runat="server" Width="80px"></asp:TextBox>

                        <asp:CalendarExtender
                            ID="CalenderExtender1" runat="server" Enabled="True"
                            Format="dd-MM-yy" PopupButtonID="Calendar_PopUpButton" CssClass="radcalendar"
                            TargetControlID="Periodo_FechaInicial_TextBox">
                        </asp:CalendarExtender>

                        - <asp:TextBox ID="Periodo_FechaFinal_TextBox" runat="server" Width="80px"></asp:TextBox>

                        <asp:CalendarExtender
                            ID="CalendarExtender2" runat="server" Enabled="True"
                            Format="dd-MM-yy" PopupButtonID="Calendar_PopUpButton" CssClass="radcalendar"
                            TargetControlID="Periodo_FechaFinal_TextBox">
                        </asp:CalendarExtender>

                    </div>

                    <asp:Button ID="ExportarInformacionMicrosoftExcel_Button"
                                runat="server"
                                Text="Exportar a Excel"
                                OnClick="ExportarInformacionMicrosoftExcel_Button_Click" />
                </fieldset>

                <br /><br />

            </ContentTemplate>
        </asp:UpdatePanel>

    </div>

    <div style="clear: both; " />

</asp:Content>
