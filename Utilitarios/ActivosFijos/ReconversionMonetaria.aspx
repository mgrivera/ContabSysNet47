<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple_WithButtons.master" AutoEventWireup="true" Inherits="ContabSysNet_Web.Utilitarios.ActivosFijos.ReconversionMonetaria" Codebehind="ReconversionMonetaria.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <table class="notsosmallfont" width="500px">
        <tr>
            <td>
                <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
                    style="display: block;"></span>
            </td>
        </tr>
        <tr>
            <td>
                <span id="Message_Span" runat="server" class="generalfont" style="display: block;">
                </span>
            </td>
        </tr>
        <tr>
            <td>
                <div style="width: 90%; text-align: left; padding: 10px; ">
                    Este proceso lee los activos fijos cuya fecha de compra es anterior al 1-1-2008 
                    y convierte sus montos a bolivares fuertes.
                    Para hacerlo, simplemente divide cada monto por 1.000. Además, y como indica la 
                    norma, los decimales que puedan existir
                    son redondeados para que queden solo dos. El redondeo que se aplica es el 
                    método: &quot;acercar al superior&quot;. Es decir, un
                    monto igual a &quot;1000,562&quot; queda en &quot;1000,56&quot;; sin embargo, un monto &quot;1000,565&quot; 
                    queda en &quot;1000.57&quot;.
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div runat="server" id="MensajeResultado_div">
                
                </div>
            </td>
        </tr>
        <tr>        
            <td>
                <br />
                    <asp:Button ID="ReconversionMonetaria_Button" runat="server" 
                            Text="Efectuar reconversión monetaria" 
                            onclick="ReconversionMonetaria_Button_Click" />
            
            </td>
        </tr>
         <tr>
            <td>
                <br />
                <div style="width: 90%; text-align: left; background-color: #EBEBEB; padding: 10px; ">
                <b>Nota importante:</b> este proceso no debe ser ejecutado dos veces consecutivas, 
                    pues aplicaría la reconversión dos veces, en efecto, dividiendo dos veces por 
                    1000 cada monto.
                </div>
            </td>
        </tr>
    </table>
</asp:Content>

