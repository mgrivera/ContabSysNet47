<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple_With_BS40.Master" AutoEventWireup="true" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Comprobantes.ComprobantesContables_Funciones" Codebehind="ComprobantesContables_Funciones.aspx.cs" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">   
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="margin: 0 25px 25px 25px;" class="generalfont">
    
        <asp:HiddenField ID="FileName_HiddenField" runat="server" />

        <h4>Contab - Asientos contables - Funciones</h4>
    
        <span id="GeneralMessage_Span" runat="server" class="infomessage infomessage_background generalfont"
           style="display: block;"></span>

        <asp:ValidationSummary ID="ValidationSummary1" 
                                   runat="server" 
                                   class="errmessage_background generalfont errmessage"
                                   ShowModelStateErrors="true"
                                   ForeColor="" ValidationGroup="copiarAsientos_validationGroup" />

        <asp:CustomValidator ID="CustomValidator1" 
                             runat="server" 
                             ErrorMessage="CustomValidator" 
                             Display="None" 
                             EnableClientScript="False" />
       
        <asp:DropDownList ID="DropDownList1" runat="server" 
                          AutoPostBack="True" 
                          onselectedindexchanged="DropDownList1_SelectedIndexChanged" 
                          style="margin: 20px; " >

                <asp:ListItem Selected="True" Value="0">Seleccione una función</asp:ListItem>
                <asp:ListItem Value="1">Copia de asientos contables</asp:ListItem>
                <asp:ListItem Value="2">Exportar a un archivo</asp:ListItem>

        </asp:DropDownList>

        <fieldset runat="server" id="AsientosContables_Copiar_Fieldset" style="margin-bottom: 10px; border: 1px solid gray; padding: 10px; ">

            <div style="padding: 0 10px 10px 10px; text-align: left; ">

                <div class="row" style="margin-top: 15px; ">
                    <div class="col-sm-12">
                        <p>
                            Esta función copia los asientos contables que se han seleccionado al aplicar el filtro indicado. Los asientos contables 
                            con copiados a la compañía <em>Contab</em> que Ud. indique. 
                        </p>
                        <p>
                            <b>Nota: </b>Los asientos contables que existan en la compañía que se indique <b>no son sustituídos</b>. Los asientos contables 
                            que puedan existir en la compañía indicada se mantendrán y los nuevos serán agregados. Al final de la copia existirán, en la 
                            compañía seleccionada, tanto los asientos que puedan haber existido antes, como los nuevos que sean producto de esta copia. 
                        </p>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-6">
                        Seleccione una compañía: 
                    </div>
                    <div class="col-sm-6">
                        <asp:DropDownList ID="CiaContab_DropDownList" 
                                  runat="server" 
                                  DataSourceID="CiasContab_SqlDataSource" 
                                  DataTextField="NombreCorto" 
                                  DataValueField="Numero">
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="row" style="margin-top: 15px; font-weight: bold; ">
                    <div class="col-sm-12">
                        Al efectuar la copia y antes de grabar cada comprobante: 
                    </div>
                </div>

                <div class="row" style="margin-top: 15px; ">
                    <div class="col-sm-6">
                        Multiplicar cada partida (debe y haber) por este monto:  
                    </div>
                    <div class="col-sm-6">
                        <asp:TextBox ID="multiplicarPor_textBox" 
                                    runat="server" 
                                    CausesValidation="True" 
                                    ValidationGroup="copiarAsientos_validationGroup" />

                        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="multiplicarPor_textBox"
                                        CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser numérico."
                                        Operator="DataTypeCheck" Type="Double" Style="color: red; " 
                                        ValidationGroup="copiarAsientos_validationGroup">*</asp:CompareValidator>
                    </div>
                </div>

                <div class="row" style="margin-top: 5px; ">
                    <div class="col-sm-6">
                        Dividir cada partida (debe y haber) por este monto: 
                    </div>
                    <div class="col-sm-6">
                        <asp:TextBox ID="dividirPor_textBox" 
                                    runat="server" 
                                    CausesValidation="True" 
                                    ValidationGroup="copiarAsientos_validationGroup" /> 

                        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="dividirPor_textBox"
                                        CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser numérico."
                                        Operator="DataTypeCheck" Type="Double" Style="color: red; " 
                                        ValidationGroup="copiarAsientos_validationGroup">*</asp:CompareValidator>
                    </div>
                </div>

                <div class="row" style="text-align: center; margin-top: 15px; ">
                    <div class="col-sm-12">
                        <asp:Button ID="AsientosContables_Copiar_Button" 
                                    style="min-width: 100px; "
                                    runat="server" 
                                    Text="Copiar" 
                                    onclick="AsientosContables_Copiar_Button_Click" 
                                    ValidationGroup="copiarAsientos_validationGroup" />
                    </div>
                </div>

            </div>
        </fieldset>

        <fieldset runat="server" id="AsientosContables_Exportar_Fieldset" style="margin-bottom: 10px; border: 1px solid gray; padding: 10px; ">
        
            <div style="padding: 10px; text-align: center; ">

                <div class="row" style="margin-top: 15px; text-align: left; ">
                    <div class="col-sm-12">
                        <p>
                            Esta función exporta los asientos contables que se han seleccionado al aplicar el filtro indicado. Los archivos son copiados 
                            a un archivo en el disco duro local. Los asientos contables son exportados al formato que Ud. indique: Xml o Excel. 
                        </p>
                        <p>
                            Al finalizar el proceso que logra exportar los asientos al formato indicado, se mostrará un <em>link</em> que permite copiar (<em>download</em>) 
                            el archivo al disco duro local. 
                        </p>
                    </div>
                </div>

                <div class="row" style="margin-top: 15px; ">
                    <div class="col-sm-12">
                        <fieldset style="margin-bottom: 10px; border: 1px solid gray; padding: 10px; ">
                            <asp:RadioButtonList id="Formato_RadioButtonList" runat="server" RepeatDirection="Horizontal">
                               <asp:ListItem value="excel" selected="true" Text="&nbsp;Excel&nbsp;&nbsp;" />
                               <asp:ListItem Value="xml" Text="&nbsp;xml" /> 
                            </asp:RadioButtonList>
                        </fieldset>
                    </div>
                </div>

                <div class="row" style="margin-top: 15px; ">
                    <div class="col-sm-12">
                        <asp:Button ID="AsientosContables_Exportar_Button" 
                                runat="server" 
                                Text="Exportar" 
                                onclick="AsientosContables_Exportar_Button_Click" />
                    </div>
                </div>

                <div class="row" style="margin-top: 15px; text-align: right; ">
                    <div class="col-sm-12">
                        <asp:LinkButton ID="DownloadFile_LinkButton" 
                                        runat="server"
                                        OnClick="DownloadFile_LinkButton_Click" 
                                        Visible="False">
                                Copiar el archivo al disco duro local
                        </asp:LinkButton>
                    </div>
                </div>
            
            </div>
        </fieldset>


        <%--para mostrar un diálogo que permita al usuario continuar/cancelar--%> 
        <asp:Panel ID="pnlPopup" runat="server" CssClass="modalpopup" style="display:none">
            <div class="popup_container" style="width: 500px; ">
                <div class="popup_form_header" style="overflow: hidden; ">
                    <div id="ModalPopupTitle_div" style="width: 85%; margin-top: 5px;  float: left; text-align: left;">
                        <span runat="server" id="ModalPopupTitle_span" style="font-weight: bold; "/> 
                    </div>
                    <div style="width: 15%; float: right; ">
                        <asp:ImageButton ID="ImageButton1" runat="server" OnClientClick="$find('popup').hide(); return false;" ImageUrl="~/Pictures/PopupCloseButton.png" />
                    </div>
                </div>
                <div class="inner_container">
                    <div class="popup_form_content" style="text-align: left; ">
                        <span runat="server" id="ModalPopupBody_span"/> 
                    </div>
                    <div class="popup_form_footer">
                        <asp:Button ID="btnOk" runat="server" Text="Continuar" OnClick="btnOk_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancelar" OnClientClick="$find('popup').hide(); return false;" Width="80px"/>
                    </div>   
                </div>                                          
            </div>
        </asp:Panel>

        <asp:HiddenField ID="HiddenField1" runat="server" />
        <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" 
                                        runat="server" 
                                        BehaviorID="popup" 
                                        TargetControlID="HiddenField1" 
                                        PopupControlID="pnlPopup" 
                                        BackgroundCssClass="modalBackground" 
                                        PopupDragHandleControlID="ModalPopupTitle_div" 
                                        Drag="True" />

    </div>
    
    <asp:SqlDataSource ID="CiasContab_SqlDataSource" 
                       runat="server" 
                       ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
                       SelectCommand="SELECT NombreCorto, Numero FROM Companias ORDER BY NombreCorto">
    </asp:SqlDataSource>
    
</asp:Content>

