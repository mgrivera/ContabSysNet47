using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ContabSysNet_Web.Areas.Bancos.Models.islr_pagoAnticipado
{
    public class EventoPagoAnticipado_Config
    {
        [Required(ErrorMessage = "El registro debe tener un ID")]
        [DisplayName("Id")]
        [BsonId]
        public string _id { get; set; }

        [DisplayName("Dirección base del api")]
        public string ApiBaseAddress { get; set; }

        [Required(ErrorMessage = "El registro debe estar asociado a una compania Contab")]
        [DisplayName("Cia Contab")]
        public int Cia { get; set; }
    }
}