<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple_WithButtons.master" AutoEventWireup="true" Inherits="Otros_Control_acceso_AgregarUsuario" Codebehind="AgregarUsuario.aspx.cs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div style="padding-top: 10px; padding-left: 20px; padding-right: 20px; padding-bottom: 10px; ">

    <div style="text-align: left; ">
    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
        
        <cc1:TabContainer ID="TabContainer1" runat="server"  ActiveTabIndex="0">
        <cc1:TabPanel ID="TabPanel1" runat="server" HeaderText="Agregar" TabIndex="0">
            <ContentTemplate>
                <h5>Agregar usuarios a la aplicación</h5>
                
    
             <asp:CreateUserWizard ID="CreateUserWizard1" runat="server" BackColor="#F7F6F3" 
            BorderColor="#E6E2D8" BorderStyle="Solid" BorderWidth="1px" 
            Font-Names="Verdana" Font-Size="0.8em" 
                 ContinueDestinationPageUrl="~/Otros/Control acceso/AgregarUsuario.aspx" 
                 DisplayCancelButton="True" 
                 FinishDestinationPageUrl="~/Otros/Control acceso/AgregarUsuario.aspx" 
                 LoginCreatedUser="False">
            <SideBarStyle BackColor="#5D7B9D" Font-Size="0.9em" VerticalAlign="Top" 
                     BorderWidth="0px" />
            <SideBarButtonStyle Font-Names="Verdana" 
                ForeColor="White" BorderWidth="0px" />
            <ContinueButtonStyle BackColor="#FFFBFF" BorderColor="#CCCCCC" 
                BorderStyle="Solid" BorderWidth="1px" Font-Names="Verdana" 
                ForeColor="#284775" />
            <NavigationButtonStyle BackColor="#FFFBFF" BorderColor="#CCCCCC" 
                BorderStyle="Solid" BorderWidth="1px" Font-Names="Verdana" 
                ForeColor="#284775" />
            <HeaderStyle BackColor="#5D7B9D" BorderStyle="Solid" Font-Bold="True" 
                     Font-Size="0.9em" ForeColor="White" 
                HorizontalAlign="Center" />
            <CreateUserButtonStyle BackColor="#FFFBFF" BorderColor="#CCCCCC" 
                BorderStyle="Solid" BorderWidth="1px" Font-Names="Verdana" 
                ForeColor="#284775" />
            <TitleTextStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <StepStyle BorderWidth="0px" />
            <WizardSteps>
                <asp:CreateUserWizardStep ID="CreateUserWizardStep1" runat="server">
                </asp:CreateUserWizardStep>
                <asp:CompleteWizardStep ID="CompleteWizardStep1" runat="server">
                </asp:CompleteWizardStep>
            </WizardSteps>
        </asp:CreateUserWizard>
       

    </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel ID="TabPanel2" runat="server" HeaderText="Actualizar" TabIndex="1">
            <ContentTemplate>
                 <h5>Actualizar usuarios en la aplicación</h5>
                 
                 <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;"></span>
                 
                <asp:GridView ID="Usuarios_GridView" runat="server" AllowPaging="True" 
                     DataSourceID="Usuarios_ObjectDataSource" AutoGenerateColumns="False" 
                     CellPadding="4" ForeColor="#333333" GridLines="None" 
                     DataKeyNames="UserName" onrowupdated="Usuarios_GridView_RowUpdated">
                    <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                    <Columns>
                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
                        <asp:BoundField DataField="UserName" HeaderText="Nombre" ReadOnly="True" />
                        <asp:BoundField DataField="Email" HeaderText="Dirección de e-mail " />
                        <asp:CheckBoxField DataField="IsOnline" HeaderText="Online ahora" 
                            ReadOnly="True" >
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:CheckBoxField>
                        <asp:BoundField DataField="CreationDate" DataFormatString="{0:dd-MMM-yy hh:MM tt}" 
                            HeaderText="Fecha de creación" ReadOnly="True" >
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="LastLoginDate" DataFormatString="{0:dd-MMM-yy hh:MM tt}" 
                            HeaderText="Fecha de último acceso " ReadOnly="True" >
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                    </Columns>
                    <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                    <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                    <EditRowStyle BackColor="#999999" />
                    <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                </asp:GridView>

                <asp:ObjectDataSource ID="Usuarios_ObjectDataSource" runat="server" 
                     SelectMethod="GetUsers" TypeName="Usuarios" DeleteMethod="DeleteUser" 
                     OldValuesParameterFormatString="original_{0}" UpdateMethod="UpdateUser">
                    <DeleteParameters>
                        <asp:Parameter Name="original_UserName" Type="String" />
                    </DeleteParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="UserName" Type="String" />
                        <asp:Parameter Name="Email" Type="String" />
                        <asp:Parameter Name="IsOnline" Type="Boolean" />
                        <asp:Parameter Name="CreationDate" Type="DateTime" />
                        <asp:Parameter Name="LastLoginDate" Type="DateTime" />
                    </UpdateParameters>
                 </asp:ObjectDataSource>
                 
                 
            </ContentTemplate>
        </cc1:TabPanel>
    </cc1:TabContainer> 
    
        </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>

</asp:Content>

