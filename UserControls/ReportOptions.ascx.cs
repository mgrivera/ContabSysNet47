using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContabSysNet_Web.UserControls
{
    public partial class ReportOptions : System.Web.UI.UserControl
    {
        public ReportOptions()
        {
            this.MostrarOrientation = true;
            this.MostrarSoloTotales = false; 
        }

        public string Titulo
        {
            get { return !string.IsNullOrEmpty(this.TituloReporte_TextBox.Text) ? this.TituloReporte_TextBox.Text : ""; }
            set { this.TituloReporte_TextBox.Text = value; } 
        }

        public string SubTitulo 
        {
            get { return !string.IsNullOrEmpty(this.SubTituloReporte_TextBox.Text) ? this.SubTituloReporte_TextBox.Text : ""; }
            set { this.SubTituloReporte_TextBox.Text = value; } 
        }

        public string Orientation
        {
            get { return this.HorizontalOrientation_RadioButton.Checked ? "h" : "v"; }
        }

        public string Format
        {
            get { return this.PdfFormat_RadioButton.Checked ? "pdf" : "normal"; }
        }

        public bool Colors
        {
            get { return this.UsarColores_CheckBox.Checked;  }
        }

        public bool MatrixPrinter
        {
            get { return this.SimpleFont_CheckBox.Checked; }
        }

        // para mostrar o no alguna de las opciones al usuario 
        public bool MostrarOrientation { get; set; }
        public bool MostrarSoloTotales { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!MostrarOrientation)
            {
                this.HorizontalOrientation_RadioButton.Visible = false;
                this.VerticalOrientation_RadioButton.Visible = false; 
            }

            if (!MostrarSoloTotales)
                this.SoloTotales_CheckBox.Visible = false; 
        }
    }
}