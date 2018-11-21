<%@ Control Language="C#" Inherits="Decimal_EditField" Codebehind="Decimal_Edit.ascx.cs" %>
<link href="../../general.css" rel="stylesheet" type="text/css" />

<asp:TextBox ID="TextBox1" runat="server" Text='<%# FieldValueEditString %>' Columns="10" CssClass="notsosmallfont">
</asp:TextBox>

<asp:RequiredFieldValidator runat="server" ID="RequiredFieldValidator1" ControlToValidate="TextBox1" Display="Dynamic" Enabled="false" />
<asp:CompareValidator runat="server" ID="CompareValidator1" ControlToValidate="TextBox1" Display="Dynamic"
    Operator="DataTypeCheck" Type="Currency" Text="valor inválido!" Enabled="false" />
<asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidator1" ControlToValidate="TextBox1" Display="Dynamic" Enabled="true" ValidationExpression="^\$?[0-9]+(.[0-9]{3})*(\,[0-9]{0,4})?$" Text="valor inválido!" />
<asp:RangeValidator runat="server" ID="RangeValidator1" ControlToValidate="TextBox1" Type="Double"
    Enabled="false" EnableClientScript="true" MinimumValue="0" MaximumValue="100" Display="Dynamic" />
<asp:DynamicValidator runat="server" ID="DynamicValidator1" ControlToValidate="TextBox1" Display="Dynamic" />
