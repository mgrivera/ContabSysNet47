<%--nótese como ponemos EnableEventValidation en false; esto es necesario para que funcionen los ajax cascading dropdownlists--%>
<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_Simple.master" CodeBehind="ConciliacionBancaria_UploadMovBanco.aspx.cs" Inherits="ContabSysNet_Web.Bancos.ConciliacionBancaria.ConciliacionBancaria_UploadMovBanco" 
    EnableEventValidation="false" EnableViewState="True" %>                
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div style="text-align: left; padding: 0px 20px 0px 20px;">

    <ajaxToolkit:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
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
    </ajaxToolkit:UpdatePanelAnimationExtender>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>

            <asp:ValidationSummary ID="ValidationSummary1" 
                                   runat="server" 
                                   class="errmessage_background generalfont errmessage"
                                   DisplayMode="SingleParagraph" 
                                   style="width:90%; " />

            <asp:CustomValidator ID="CustomValidator1" runat="server" Display="None" EnableClientScript="False" />

            <span id="Message_Span" runat="server" class="generalfont infomessage infomessage_background" style="display: block;">
            </span>

            <br />

   
            1) Indique cual es el documento Excel que contiene los movimientos registrados por el banco
            <ajaxToolkit:AjaxFileUpload ID="AjaxFileUpload1" 
                                        runat="server" 
                                        Width="400px" 
                                        OnUploadComplete="AjaxFileUpload1_UploadComplete"
                                        AllowedFileTypes="xlsx,xls" />

            <br /><br /><br />
            2) Cargue los registros a la base de datos<br />
            <asp:Button ID="Button1" 
                        runat="server" 
                        Text="Leer y cargar registros ... " 
                        OnClick="Button1_Click" />

       </ContentTemplate>
    </asp:UpdatePanel>

</div>

<asp:panel style="text-align: right; padding: 20px;" 
           runat="server">

</asp:panel>
       
                                  
</asp:Content>