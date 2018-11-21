<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Configuracion" Codebehind="Configuracion.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">

    <script type="text/javascript">
    function PopupWin(url,w,h){
    ///Parameters url=page to open, w=width, h=height
        window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
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
       <img id="Img4" runat="server" alt="Registro y actualización de los códigos de presupuesto" src="~/Pictures/application_16x16.gif" />
        <%-- <a href="javascript:PopupWin('Codigos de presupuesto/CodigosPresupuesto.aspx', 1000, 680)">Códigos de presupuesto</a> --%>

        
        <a href="javascript:PopupWin('<% = GetCodigosPresupuesto_UriAddress() %>', 1300, 680)">
            Códigos de presupuesto</a>

       <%-- <a href="javascript:PopupWin('/Presupuesto/CodigosPresupuesto/Index', 1300, 680)">
            Códigos de presupuesto</a>--%>

        <hr />
       
      <%-- <img id="Img1" runat="server" alt="Registro de asociación códigos-cuentas contables" src="~/Pictures/application_16x16.gif" />
        <a href="javascript:PopupWin('Asociacion codigos cuentas/AsociacionCodigosCuentas.aspx', 1000, 680)">
            Asociación códigos de presuesto-cuentas contables</a>
        <hr />--%>

        <img id="Img3" runat="server" alt="Registro de montos estimados de presupuesto por año" src="~/Pictures/application_16x16.gif" />

        <a href="javascript:PopupWin('<% = GetMontosEstimados_UriAddress() %>', 1300, 680)">
            Registro de montos estimados por año</a>
        <hr />
        <%--<a href="javascript:PopupWin('Montos estimados/Presupuesto_MontosEstimados.aspx', 1300, 680)">--%>
        <%--<a href="javascript:PopupWinFullWidthAndHeight('Montos estimados/Presupuesto_MontosEstimados.aspx')">--%>
            

        <img id="Img2" runat="server" alt="Copia de información de configuración desde una compañía a otra" src="~/Pictures/application_16x16.gif" />
        <a href="javascript:PopupWin('Copia codigos entre cias/CopiaCodigosPresupuesto.aspx', 1000, 680)">
            Duplicación de información de configuración entre compañías</a>
        <hr />
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>

