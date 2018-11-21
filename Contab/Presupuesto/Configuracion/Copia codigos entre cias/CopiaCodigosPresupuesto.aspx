<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Configuracion_CopiaCodigosEntreCias_CopiaCodigosPresupuesto" Codebehind="CopiaCodigosPresupuesto.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
    <Services>
        <asp:ServiceReference  Path="~/MostrarProgreso.asmx" />
    </Services>
</asp:ScriptManagerProxy>

<%--  para que la página sepa, cuando se refresca (postback), que lo hizo la función js --%>
<span id="RebindFlagSpan">
    <asp:HiddenField id="RebindPage_HiddenField" runat="server" value="0" />
</span>

<script type="text/javascript">
    function showprogress() {
        document.getElementById("Progressbar_div").style.visibility = "visible";
        // document.getElementById("Progressbar_div").style.height = ""; 

        showprogress_continue();
    }
    function showprogress_continue() {
        // nótese como, simplemente, ejecutamos el web service y pasamos la función (SucceededCallback) 
        // que regresa con los resultados del WS en forma 'directa'.
        MostrarProgreso.GetProgressPercentaje(function(Result) {
            // primero mostramos el progreso (%) 
            var a = Result.Progress_Percentage;
            if (!(a == null)) {
                document.getElementById("ProgressbarProgress_div").style.width = a + "%";
                document.getElementById("ProgressbarMessage_div").innerHTML = a + "%";
            }
            // si el proceso no se ha completado, volvemos a ejecutar el web service
            var b = Result.Progress_Completed;
            if (!(b == 1))
                setTimeout("showprogress_continue()", 1000);
            else {
                // la tarea terminó - escondemos (nuevamente) el progress bar y hacemos un refresh 
                document.getElementById("Progressbar_div").style.visibility = "hidden";
                window.document.getElementById('<%=RebindPage_HiddenField.ClientID%>').value = "1";
                window.document.forms(0).submit();
            }
        });
    }
</script>

<div style="width: 80%; text-align: center; " class="notsosmallfont">
    <h3>Copia de códigos de presupuesto de una compañía a otra</h3>
    <div style="text-align: left;">
    
    <p>
       Este proceso permite al usuario copiar (duplicar) los códigos de presupuesto registrados para 
       una compañía, a otra diferente. Esto facilita el registro de estos códigos para una compañía, cuando ya fueron 
       registrados para otra y, además, cuando las codificaciones escogidas para ambas comañías son iguales
       o similares. 
    </p>
    <p>
       Nótese que, además de duplicar los códigos de presupuesto a la nueva compañía, Ud. puede también 
       duplicar los registros de montos estimados para un año determinado, si éstos han sido registrados. 
    </p>
    <p>
       Si la compañía que va a recibir los códigos de presupuesto ya los tiene, Ud. puede marcar la opción
       que corresponde para que estos sean eliminados antes de ser efectuada la copia. 
    </p>
    <br />
    </div>
    <span id="ErrMessage_Span" runat="server" 
          class="errmessage errmessage_background generalfont"
          style="display: block;">
    </span>
    <span id="Message_Span" runat="server" class="infomessage infomessage_background generalfont"
     style="display: block;">
    </span>
    <table cellspacing="20">
        <tr>
            <td>
            Seleccione la compañía que contiene<br />
            los códigos de presupuesto a copiar
            </td>
            <td>
            Seleccione la compañía a la cual serán<br />
            copiados los códigos de presupuesto
            </td>
        </tr>
        <tr>
            <td>
                <asp:ListBox ID="SourceCiaContab_ListBox" runat="server" 
                    DataSourceID="SourceCiasContab_SqlDataSource" DataTextField="Nombre" 
                    DataValueField="Numero" AutoPostBack="True" Rows="8" CssClass="notsosmallfont"
                    onselectedindexchanged="SourceCiaContab_ListBox_SelectedIndexChanged"></asp:ListBox>
            </td>
            <td><asp:ListBox ID="TargetCiaContab_ListBox" runat="server"  CssClass="notsosmallfont"
                    DataSourceID="TargetCiasContab_SqlDataSource" DataTextField="Nombre" Rows="8"
                    DataValueField="Numero"></asp:ListBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:CheckBox ID="CopiarMontos_CheckBox" runat="server" Text="Copiar también los montos estimados registrados para la compañía seleccionada y para el año" />
                &nbsp;&nbsp;
                <asp:DropDownList ID="CopiarMontos_DropDownList" runat="server" 
                    DataSourceID="AnosMontosEstimadosSourceCia_SqlDataSource" DataTextField="Ano" 
                    DataValueField="Ano">
                </asp:DropDownList>
            </td>
            <td>
                <asp:CheckBox ID="EliminarCodigos_CheckBox" runat="server" Text="Eliminar antes los códigos que puedan existir para la compañía seleccionada"/>
            </td>
        </tr>
        
        <tr>
            <td>
               
            </td>
            <td>
                <asp:Button ID="CopiarCodigosPresupuesto_Button" runat="server" 
                    Text="Iniciar copia" onclick="CopiarCodigosPresupuesto_Button_Click" />
                    
                <%-- divs para mostrar el progress bar --%>
               <div id="Progressbar_div" style="visibility: hidden; width: 150px;">
                   <div id="ProgressbarBorder_div" style="margin-left: 5px; margin-right: 5px; border: 1px solid #808080;
                       height: 10px;">
                       <div id="ProgressbarProgress_div" style="background: url(../../../../Pictures/safari.gif) 0% 0% repeat-x;
                           height: 10px; width: 0%;">
                       </div>
                   </div>
                   <div id="ProgressbarMessage_div" style="text-align: center;" class="smallfont">
                   </div>
               </div>
               <%-- --------------------------------- --%>
            </td>
        </tr>
    </table>

    <asp:SqlDataSource ID="SourceCiasContab_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT Numero, Nombre FROM Companias ORDER BY Nombre">
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="TargetCiasContab_SqlDataSource" runat="server"
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT Numero, Nombre FROM Companias ORDER BY Nombre">
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="AnosMontosEstimadosSourceCia_SqlDataSource" runat="server"
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        
        SelectCommand="SELECT DISTINCT Ano FROM Presupuesto_Montos WHERE (CiaContab = @CiaContab) ORDER BY Ano DESC">
        <SelectParameters>
            <asp:Parameter DefaultValue="-999" Name="CiaContab" DbType="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    
</div>
</asp:Content>

