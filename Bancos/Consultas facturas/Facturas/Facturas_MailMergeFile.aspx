<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.Master" AutoEventWireup="true" CodeBehind="Facturas_MailMergeFile.aspx.cs" Inherits="ContabSysNet_Web.Bancos.Consultas_facturas.Facturas.Facturas_MailMergeFile" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="notsosmallfont" 
         style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top; background-color: #F7F7F7; float: left; text-align: center; padding: 10px; ">
        
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

    <div style="float: right; width: 80%;">

        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <span id="GeneralMessage_Span"
                    runat="server"
                    class="infomessage infomessage_background generalfont"
                    style="display: block;" />

                <span id="ErrMessage_Span"
                    runat="server"
                    class="errmessage errmessage_background generalfont"
                    style="display: block;" />


                <fieldset style="margin: 0px 25px 25px 25px; padding: 15px; text-align: center;" class="generalfont">
                    <legend>Seleccione una opción: </legend>
                    <br />
                    <asp:DropDownList ID="OpcionesMailMerge_DropDownList"
                        runat="server"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="OpcionesMailMerge_DropDownList_SelectedIndexChanged">
                        <asp:ListItem Value="0">Seleccione una opción ...</asp:ListItem>
                        <asp:ListItem Value="1">Facturas impresas</asp:ListItem>
                        <asp:ListItem Value="2">Carta de impuestos retenidos (Islr) </asp:ListItem>
                        <asp:ListItem Value="3">Cartas genéricas (una por factura seleccionada) </asp:ListItem>
                    </asp:DropDownList>
                </fieldset>

                <fieldset id="DatosCartasRetencionISLR_FieldSet"
                    visible="false"
                    style="margin: 25px 25px 25px 25px; padding: 15px; text-align: center;"
                    class="generalfont"
                    runat="server">
                    <legend>Indique estos datos para la construcción de las cartas:&nbsp;:&nbsp;</legend>
                    <br />
                    <table>
                        <tr>
                            <td style="text-align: right;">Fecha para mostrar en las cartas: </td>
                            <td>
                                <asp:TextBox ID="FechaConsulta_TextBox"
                                    Width="100px"
                                    runat="server" />

                                <asp:CalendarExtender ID="CalendarExtender1"
                                    runat="server"
                                    Format="dd-MM-yyyy"
                                    TargetControlID="FechaConsulta_TextBox" />
                            </td>
                            <td></td>
                        </tr>
                        <tr>
                            <td style="text-align: right;">Período de retención: </td>
                            <td>
                                <asp:TextBox ID="PeriodoRetencion_Desde_TextBox"
                                    Width="100px"
                                    runat="server" />

                                <asp:CalendarExtender ID="CalendarExtender2"
                                    runat="server"
                                    Format="dd-MM-yyyy"
                                    TargetControlID="PeriodoRetencion_Desde_TextBox">
                                </asp:CalendarExtender>
                            </td>
                            <td>
                                <asp:TextBox ID="PeriodoRetencion_Hasta_TextBox"
                                    Width="100px"
                                    runat="server" />

                                <asp:CalendarExtender ID="CalendarExtender3"
                                    runat="server"
                                    Format="dd-MM-yyyy"
                                    TargetControlID="PeriodoRetencion_Hasta_TextBox" />
                            </td>
                        </tr>
                    </table>
                </fieldset>

                <fieldset id="CartasGenericas_Fieldset"
                    visible="false"
                    style="margin: 25px 25px 25px 25px; padding: 15px; text-align: center;"
                    class="generalfont"
                    runat="server">
                    <legend>Indique estos datos para la construcción de las cartas:&nbsp;:&nbsp;</legend>

                    <asp:Accordion ID="MyAccordion"
                                    runat="Server"
                                    SelectedIndex="-1"
                                    cssClass="accordion"
                                    HeaderCssClass="accordionHeader"
                                    HeaderSelectedCssClass="accordionHeaderSelected"
                                    ContentCssClass="accordionContent"
                                    AutoSize="None"
                                    FadeTransitions="true"
                                    TransitionDuration="250"
                                    FramesPerSecond="40"
                                    RequireOpenedPane="false"
                                    SuppressHeaderPostbacks="true">
                        <Panes>
                            <asp:AccordionPane ID="AccordionPane1" runat="server">
                                <Header>0) Introducción</Header>
                                <Content>
                                    Este proceso construye una carta por cada factura seleccionada en la lista. 
                                            Las cartas se generan en base a una 'plantilla'. Las plantillas son documentos Word (docx) 
                                            que el usuario debe crear y 'cargar' a este proceso con anticipación. 
                                </Content>
                            </asp:AccordionPane>
                            <asp:AccordionPane ID="AccordionPane2" runat="server">
                                <Header>1) Revisar plantillas cargadas</Header>
                                <Content>
                                    <p>
                                        El usuario puede revisar las plantillas que se han agregado a este proceso. Las plantillas que este proceso muestre, 
                                        se han cargado previamente y pueden ser revisadas (download). Ud. puede obtener una plantilla que se ha cargado antes, 
                                        para revisarla. También puede modificarla y 'cargarla' nuevamente, para sustutuir la original. 
                                    </p>
                                </Content>
                            </asp:AccordionPane>
                            <asp:AccordionPane ID="AccordionPane3" runat="server">
                                <Header>2) Cargar plantillas al servidor</Header>
                                <Content>
                                    <p>
                                        Ud. puede cargar un documento Word (docx) como 'plantilla', para luego usarla para generar cartas. 
                                        En general, la idea es que Ud. obtenga antes la plantilla 'base', la copie a un documento nuevo, la modifique 
                                        y 'cargue' a este proceso, para usarla posteriormente para crear cartas.
                                    </p>
                                    <p>
                                        La plantilla 'base' no puede ser modificada ni cargada. Debe existir y puede ser descargada para usarla 
                                        como base para crear una plantilla nueva y cargarla a este proceso. 
                                    </p>
                                    <p>
                                        El nombre de la plantilla 'base' es: <em>CartaModelo.docx.</em>
                                    </p>
                                </Content>
                            </asp:AccordionPane>
                            <asp:AccordionPane ID="AccordionPane4" runat="server">
                                <Header>3) Seleccionar plantilla</Header>
                                <Content>
                                    <p>
                                        Ud. debe seleccionar una plantilla, de la lista de plantillas cargadas. Luego puede hacer un click en 
                                        <em>Obtener cartas</em> para obtener las cartas en base a la plantilla seleccionada. 
                                    </p>
                    
                                </Content>
                            </asp:AccordionPane>
                            <asp:AccordionPane ID="AccordionPane5"
                                runat="server"
                                HeaderCssClass="accordionHeader"
                                HeaderSelectedCssClass="accordionHeaderSelected"
                                ContentCssClass="accordionContent">
                                <Header>4) Obtener cartas</Header>
                                <Content>
                                    <p>
                                        Para obtener las cartas, Ud. debe:
                                        <ol>
                                            <li>indicar una ciudad y fecha; ejemplo: <em>Caracas, 14 de Mayo de 2.014</em><br /></li> 
                                            <li>
                                                indicar una <em>firma para la carta</em>, usando las lineas (hasta tres) que existen para ello
                                                    (note que puede dejar lineas en blanco, si no necesita todas)
                                            </li> 
                                            <li>seleccionar una plantilla</li> 
                                            <li>hacer un click en <em>Obtener cartas</em></li> 
                                        </ol>
                                    </p>
                        
                                </Content>
                            </asp:AccordionPane>
                        </Panes>
                        <HeaderTemplate>...</HeaderTemplate>
                        <ContentTemplate>...</ContentTemplate>
                    </asp:Accordion>

                    <br />

                    <table>
                        <tr>
                            <td style="text-align: right;">1) Revisar plantillas cargadas: 
                            </td>
                            <td></td>
                            <td style="text-align: left;">
                                <asp:DropDownList ID="DownLoadPlantillas_DropDownList"
                                                  runat="server" 
                                                  OnSelectedIndexChanged="DownLoadPlantillas_DropDownList_SelectedIndexChanged">
                                </asp:DropDownList>
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: right;">2) Cargar plantillas al servidor: 
                            </td>
                            <td></td>
                            <td style="text-align: left;">
                                <input type="file" id="file1" name="file1" runat="server" />
                                &nbsp;&nbsp;&nbsp;
                                <input type="submit" 
                                       id="Submit1" 
                                       value="Upload" 
                                       runat="server" 
                                       onserverclick="Submit1_ServerClick" />
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: right;">3) Seleccionar plantilla: 
                            </td>
                            <td></td>
                            <td style="text-align: left;">
                                <asp:DropDownList ID="SeleccionarPlantillaWord_DropDownList" runat="server" />
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: right;">Ciudad y fecha: 
                            </td>
                            <td></td>
                            <td style="text-align: left;">
                                <asp:TextBox ID="CiudadFecha_CartasGenericas_TextBox" Width="300px" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right;">Firma del documento:
                            </td>
                            <td></td>
                            <td style="text-align: left;">
                                <asp:TextBox ID="FirmaCarta_Linea1_CartasGenericas_TextBox" Width="300px" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td style="text-align: left;">
                                <asp:TextBox ID="FirmaCarta_Linea2_CartasGenericas_TextBox" Width="300px" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td style="text-align: left;">
                                <asp:TextBox ID="FirmaCarta_Linea3_CartasGenericas_TextBox" Width="300px" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td>
                                <asp:Button ID="ConstruirCartasGenericas_Button"
                                    runat="server"
                                    Text="Obtener cartas"
                                    OnClick="ConstruirCartasGenericas_Button_Click" />
                            </td>
                        </tr>
                    </table>
                </fieldset>

                <asp:Button ID="GenerarMailMergeFile_Button"
                    runat="server"
                    Text="Construir archivo"
                    Visible="false"
                    OnClick="GenerarTextFile_Button_Click" />

                <br />

                <asp:LinkButton ID="DownloadFile_LinkButton"
                    Style="text-align: right;"
                    runat="server"
                    OnClick="DownloadFile_LinkButton_Click"
                    Visible="False">
                        Copiar el archivo al disco duro local
                </asp:LinkButton>

            </ContentTemplate>

            <Triggers>
                <asp:PostBackTrigger ControlID="Submit1" />
            </Triggers>
        </asp:UpdatePanel>

    </div>

    <div style="clear: both; " />

</asp:Content>
