using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Contabilidad.Models.mongodb.dbContab
{
    public class Temp_CentrosCosto_Consulta
    {
        public ObjectId Id { get; set; }

        public int CiaContabID { get; set; }
        public string CiaContabNombre { get; set; }
        public string CiaContabAbreviatura { get; set; }

        public int MonedaID { get; set; }
        public string MonedaDescripcion { get; set; }
        public string MonedaSimbolo { get; set; }

        public int CentroCostoID { get; set; }
        public string CentroCostoNombre { get; set; }
        public string CentroCostoAbreviatura { get; set; }

        public int CuentaContableID { get; set; }
        public string CuentaContableGrupo { get; set; }
        public int CuentaContableGrupoOrdenarPor { get; set; }
        public string CuentaContableNombre { get; set; }
        public string CuentaContableCuenta { get; set; }

        public string Descripcion { get; set; }
        public DateTime Fecha { get; set; }
        public decimal SaldoInicial { get; set; }
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
        public decimal SaldoFinal { get; set; }

        public int Secuencia { get; set; }
        public string Usuario { get; set; }


        // ssrs - para usar como datasource ... 
        public List<Temp_CentrosCosto_Consulta> GetReporte_CentrosCosto_Consulta()
        {
            List<Temp_CentrosCosto_Consulta> list = new List<Temp_CentrosCosto_Consulta>();
            return list;
        }
    }
}