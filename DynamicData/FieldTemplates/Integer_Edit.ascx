<%@ Control Language="C#" Inherits="Integer_EditField" Codebehind="Integer_Edit.ascx.cs" %>

<asp:TextBox ID="TextBox1" runat="server" Text="<%# FieldValueEditString %>" Columns="10"></asp:TextBox>

<asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator1" ControlToValidate="TextBox1" Display="Dynamic" Enabled="false" />
<asp:CompareValidator runat="server" ID="CompareValidator1" ControlToValidate="TextBox1" Display="Dynamic"
    Operator="DataTypeCheck" Type="Integer"/>
<asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidator1" ControlToValidate="TextBox1" Display="Dynamic" Enabled="false" />
<asp:RangeValidator runat="server" ID="RangeValidator1" ControlToValidate="TextBox1" Type="Integer"
    Enabled="false" EnableClientScript="true" MinimumValue="0" MaximumValue="100" Display="Dynamic" />
<asp:DynamicValidator runat="server" ID="DynamicValidator1" ControlToValidate="TextBox1" Display="Dynamic" />