using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace ContabSysNet_Web.ModelosDatos_EF.Contab
{
    [MetadataType(typeof(Asiento.Metadata))]
    public partial class Asiento
    {
        private abstract class Metadata
        {
            [DisplayFormat(DataFormatString = "{0:d-MMM-yy}", ApplyFormatInEditMode = false)]
            public Object Fecha { get; set; }

            [DisplayName("Moneda")]
            [UIHint("ForeignKey")]
            public object Moneda1 { get; set; }

            [DisplayName("Cia contab")]
            [UIHint("ForeignKey")]
            public object Compania { get; set; }
        }
    }
}