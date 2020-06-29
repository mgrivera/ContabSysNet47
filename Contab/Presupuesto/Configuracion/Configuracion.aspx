<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Configuracion" Codebehind="Configuracion.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">

    <script type="text/javascript">
        function PopupWin(url, w, h) {
            ///Parameters url=page to open, w=width, h=height
            var left = parseInt((screen.availWidth / 2) - (w / 2));
            var top = parseInt((screen.availHeight / 2) - (h / 2));
            window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,left=" + left + ",top=" + top + "screenX=" + left + ",screenY=" + top);
        }

    function PopupWinFullWidthAndHeight(url) {
        window.open(url, "external", "width=1024,height=768,resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
    }
    </script>

    <script runat="server">
        protected String GetApplicationName()
        {
            return HttpContext.Current.Request.ApplicationPath.ToString();
        }

        protected String GetCodigosPresupuesto_UriAddress()
        {
            // este es la dirección que espera mvc; notamos que debemos agregar el nombre de la aplicación (ej: ContabSysNet46) cuando no estamos en 
            // ambiente de desarrollo; es decir, cuando ejecutamos desde iis ... 
            string pagePath = GetApplicationName() + "/Presupuesto/CodigosPresupuesto/Index";
            pagePath = pagePath.Replace("//", "/");

            return pagePath;
        }

        protected String GetMontosEstimados_UriAddress()
        {
            // este es la dirección que espera mvc; notamos que debemos agregar el nombre de la aplicación (ej: ContabSysNet46) cuando no estamos en 
            // ambiente de desarrollo; es decir, cuando ejecutamos desde iis ... 
            string pagePath = GetApplicationName() + "/Presupuesto/CodigosPresupuesto/MontosEstimados";
            pagePath = pagePath.Replace("//", "/");

            return pagePath;
        }
    </script>

    <%-- div en la izquierda para mostrar funciones de la página --%>
    <%--  --%>
    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top;
        background-color: #F7F7F7; float: left; text-align: center; ">
        <br />
        <br />

        <a href="javascript:PopupWin('<% = GetCodigosPresupuesto_UriAddress() %>', 1000, 680)">Códigos de presupuesto</a><br />
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <a href="javascript:PopupWin('<% = GetMontosEstimados_UriAddress() %>', 1000, 680)">Registro de montos<br /> estimados por año</a><br />
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <a href="javascript:PopupWin('Copia codigos entre cias/CopiaCodigosPresupuesto.aspx', 1000, 680)">Conversión de cifras de<br /> presupuesto usando factores de<br /> conversión registrados</a><br />
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px; "></i>

        <hr />
        <br />
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>

