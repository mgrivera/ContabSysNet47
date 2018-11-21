<%@ Page Title="Opciones de reportes" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="ContabSysNetWeb.Bancos.Disponibilidad_en_bancos.Disponibilidad.Bancos_ConsultaDisponibilidad_OpcionesReportes" Codebehind="Bancos_ConsultaDisponibilidad_OpcionesReportes.aspx.cs" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <fieldset style="margin: 0px 10px 20px 10px; padding: 20px; " runat="server" id="OpcionesLibroCompras_Fieldset">
                    <legend style="color: Blue; ">Opciones de la consulta: </legend>

                    <br />
                    <asp:CheckBox runat="server" ID="DosColumnas_CheckBox" Text="Mostrar dos columnas (débitos/créditos) en el reporte" />
                </fieldset>

                <div style="text-align: center; ">
                    <asp:Button ID="ObtenerReporte_Button" 
                                runat="server" 
                                Text="Obtener consulta" 
                                onclick="ObtenerReporte_Button_Click"
                                style="margin: 0px 0px  10px 0px; " />
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>

    </asp:Content>

