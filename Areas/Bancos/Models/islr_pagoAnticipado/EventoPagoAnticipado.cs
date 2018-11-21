using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using MongoDB.Bson.Serialization.Attributes;

namespace ContabSysNet_Web.Areas.Bancos.Models.islr_pagoAnticipado
{
    public class EventoPagoAnticipado
    {
        [Required(ErrorMessage = "El registro debe tener un ID")]
        [DisplayName("Id")]
        [BsonId]
        public string _id { get; set; }

        [Required(ErrorMessage = "Ud. debe indicar un número de Rif")]
        [DisplayName("Rif del contribuyente")]
        [StringLength(10, ErrorMessage = "El Rif debe contener 10 caracteres para que sea válido (ej: J065228331)", MinimumLength = 10)]
        public string Rif { get; set; }

        [Required(ErrorMessage = "Ud. debe indicar la fecha de informe del impuesto")]
        [DisplayName("Fecha del impuesto")]
        [DataType(DataType.Date)]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:yyyy-MM-dd}")]
        public DateTime Fecha { get; set; }

        [Required(ErrorMessage = "La fecha del día del registro es requerida")]
        [DisplayName("Fecha del registro")]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd-MM-yyyy hh:mm}")]
        public DateTime FechaRegistro { get; set; }

        [Required(ErrorMessage = "Ud. debe indicar el monto base para la determinación del impuesto")]
        [Range(0, 999999999999999999)]
        [DisplayName("Monto base para el cálculo del impuesto")]
        public Decimal Monto { get; set; }

        public EventoPagoAnticipado_ResultStatus EstatusFinal { get; set; }

        [Required(ErrorMessage = "El registro debe estar asociado a un nombre de usuario")]
        [DisplayName("Usuario")]
        public string Usuario { get; set; }

        [Required(ErrorMessage = "El registro debe estar asociado a una compania Contab")]
        [DisplayName("Cia Contab")]
        public int Cia { get; set; }
    }

    public class EventoPagoAnticipado_ResultStatus
    {

        [DisplayName("Estatus del resultado al grabar el evento")]
        public string Estatus { get; set; }

        [DisplayName("Mensaje del resultado al grabar el evento")]
        public string Mensaje { get; set; }
    }
}