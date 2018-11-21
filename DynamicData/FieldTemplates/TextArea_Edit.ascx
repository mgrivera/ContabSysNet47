<%@ Control Language="C#" Inherits="TextArea_EditField" Codebehind="TextArea_Edit.ascx.cs" %>

<asp:TextBox ID="TextBox1" runat="server" TextMode="MultiLine" Text='<%# FieldValueEditString %>' Width="100%"></asp:TextBox>

<asp:RequiredFieldValidator runat="server" id="RequiredFieldValidator1" ControlToValidate="TextBox1" Display="Dynamic" Enabled="false" />
<asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidator1" ControlToValidate="TextBox1" Display="Dynamic" Enabled="false" />
<asp:DynamicValidator runat="server" id="DynamicValidator1" ControlToValidate="TextBox1" Display="Dynamic" />