<%@ Control Language="C#" Inherits="ForeignKeyField" Codebehind="ForeignKey.ascx.cs" %>

<asp:HyperLink ID="HyperLink1" runat="server"
    Text="<%# GetDisplayString() %>"
    NavigateUrl="<%# GetNavigateUrl() %>"  />