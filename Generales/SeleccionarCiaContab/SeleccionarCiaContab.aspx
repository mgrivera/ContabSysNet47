<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_1_With_BS4.Master" AutoEventWireup="true" CodeBehind="SeleccionarCiaContab.aspx.cs" Inherits="ContabSysNet_Web.Generales.SeleccionarCiaContab.SeleccionarCiaContab" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">

   <script type="text/javascript">
       function PopupWin(url, w, h) {
           ///Parameters url=page to open, w=width, h=height
           window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
       }
       function RefreshPage() {
           window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
           window.document.forms(0).submit();
       }
    </script>

    <%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
    <span id="RebindFlagSpan">
        <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" />
    </span>

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

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">

        <ContentTemplate>

            <div class="container">
              <div class="row">
                <div class="col-sm">
                  
                </div>
                <div class="col-sm">
                  
                    <h6>Por favor, seleccione una compañía de la lista.</h6>

                    <asp:ValidationSummary ID="ValidationSummary1" 
                                           runat="server" 
                                           class="errmessage_background generalfont errmessage"
                                           ShowModelStateErrors="true"
                                           ForeColor="" />

                    <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" Display="None" EnableClientScript="False" />
            
                    <asp:GridView ID="GridView1" 
                                  runat="server" 
                                  DataKeyNames="Numero" 
                                  OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
                                  OnPageIndexChanging="GridView1_PageIndexChanging"   
                                  AutoGenerateColumns="False" 
                                  AllowPaging="True" 
                                  PageSize="20"  
                                  CssClass="Grid">

                        <Columns>  

                            <asp:buttonfield CommandName="Select" ImageUrl="../../Pictures/SelectRow.png" ButtonType="Image" Text="Select" />

                            <asp:BoundField DataField="Nombre" HeaderText="Compañía" ReadOnly="True" SortExpression="Nombre" >  
                                <HeaderStyle HorizontalAlign="Left" Font-Size="Medium" />
                                <ItemStyle HorizontalAlign="Left" Font-Size="Small" />
                            </asp:BoundField>
                   
                        </Columns>  

                        <EmptyDataTemplate>
                            <br />
                            No hay registros que mostrar; probablemente no existen compañías registradas en la tabla Compañías ...
                        </EmptyDataTemplate>
                
                        <%--agregamos Font-Size para cambiar el font (smaller) que se indica en el cssclass ...--%>  

                        <SelectedRowStyle CssClass="GridSelectedItem" />  
                        <AlternatingRowStyle CssClass="GridAltItem" />
				        <RowStyle CssClass="GridItem"  />
				        <HeaderStyle CssClass="GridHeader" />
				        <PagerStyle CssClass="GridPager" />
                        <EmptyDataRowStyle CssClass="GridEmptyData" />

                    </asp:GridView>

                </div>
                <div class="col-sm d-flex justify-content-end" style="font-size: Medium; color: #004080; font-style: italic; ">
                    <asp:Literal ID="nombreCompaniaSeleccionada_literal" runat="server"></asp:Literal>
                </div>
              </div>
            </div>

        </ContentTemplate>

    </asp:UpdatePanel>
</asp:Content>

<%--  footer place holder --%>
<asp:Content ID="Content3" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>
