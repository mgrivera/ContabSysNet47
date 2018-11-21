using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.Companias
{
    public class Compania_ActualizarCuentasBancarias
    {
        public string nombre { get; set; }
        public int id { get; set; }
        public string ciudad { get; set; }
        public short? clienteProveedor { get; set; }
        public string tipo { get; set; }
        public string rif { get; set; }
        public int naturalJuridico { get; set; }

        public List<Compania_ActualizarCuentasBancarias_CuentaBancaria> cuentasBancarias { get; set; }

        public Compania_ActualizarCuentasBancarias()
        {
            this.cuentasBancarias = new List<Compania_ActualizarCuentasBancarias_CuentaBancaria>(); 
        }
    }

    public class Compania_ActualizarCuentasBancarias_CuentaBancaria
    {
        public string numero { get; set; }
        public int banco { get; set; }
        public string tipo { get; set; }
        public bool isDefault { get; set; }
    }
}