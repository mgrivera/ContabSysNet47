using MongoDB.Bson;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.mongodb
{
    public class Temp_FacturaImportarDesdeExcel
    {
        public ObjectId Id { get; set; }

        public string Cliente { get; set; }
        public string Rif { get; set; }
        public string ApellidoPropietario { get; set; }
        public string NombrePropietario { get; set; }
        public string Telefono { get; set; }
        public string Celular { get; set; }
        public string Email { get; set; }
        public string Direccion { get; set; }
        public string Ciudad { get; set; }
        public string Estado { get; set; }
        public DateTime VigDesde { get; set; }
        public DateTime VigHasta { get; set; }
        public string Certificado { get; set; }
        public string CertAsoc { get; set; }
        public string Representante { get; set; }
        public string MarcaModeloVersion { get; set; }
        public string Placa { get; set; }

        public decimal Membresia { get; set; }
        public decimal MembresiaBase { get; set; }
        public decimal MembresiaIva { get; set; }

        public decimal ArysVial { get; set; }
        public decimal ArysVialBase { get; set; }
        public decimal ArysVialIva { get; set; }

        public DateTime FechaRegistro { get; set; }
        public string Estatus { get; set; }
        public DateTime? FecBaja { get; set; }

        public string NumeroFacturaEnBancos { get; set; }
        public string NumeroControlEnBancos { get; set; }
        public string NumeroLoteEnBancos { get; set; }

        public string Usuario { get; set; }
    }
}