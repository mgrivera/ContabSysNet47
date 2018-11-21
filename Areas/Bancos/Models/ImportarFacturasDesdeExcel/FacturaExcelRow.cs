using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.ImportarFacturasDesdeExcel
{
    public class FacturaExcelRow
    {
        public string Cliente { get; set; }
        public string Rif { get; set; }
        public string ApellidoPropietario { get; set; }
        public string NombrePropietario { get; set; }
        public string Telefono { get; set; }
        public string Celular { get; set; }
        public string Email { get; set; }
        public string Direccion { get; set; }
        public string  Ciudad { get; set; }
        public string  Estado { get; set; }
        public string  VigDesde { get; set; }
        public string  VigHasta { get; set; }
        public string  Certificado { get; set; }
        public string  CertAsoc { get; set; }
        public string  Representante { get; set; }
        public string  MarcaModeloVersion { get; set; }
        public string  Placa { get; set; }
        public string Membresia { get; set; }
        public string ArysVial { get; set; }

        public string MembresiaBase { get; set; }
        public string MembresiaIva { get; set; }

        public string ArysVialBase { get; set; }
        public string ArysVialIva { get; set; }

        public string  FechaRegistro { get; set; }
        public string  Estatus { get; set; }
        public string  FecBaja { get; set; }
    }
}