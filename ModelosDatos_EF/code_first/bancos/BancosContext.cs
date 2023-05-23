namespace ContabSysNet_Web.ModelosDatos_EF.code_first.bancos
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class BancosContext : DbContext
    {
        public BancosContext() : base("dbContabConnectionString")
        {
            // para que EF ni siquiera intente generar migrations ... 
            Database.SetInitializer<BancosContext>(null);
        }

        public virtual DbSet<Factura> Facturas { get; set; }
        public virtual DbSet<Facturas_Impuestos> Facturas_Impuestos { get; set; }
        public virtual DbSet<Moneda> Monedas { get; set; }
        public virtual DbSet<tTempWebReport_ConsultaFacturas> tTempWebReport_ConsultaFacturas { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Factura>()
                .Property(e => e.NcNdFlag)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<Factura>()
                .Property(e => e.NumeroComprobante)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<Factura>()
                .Property(e => e.MontoFacturaSinIva)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.MontoFacturaConIva)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.Tasa)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.TipoAlicuota)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<Factura>()
                .Property(e => e.IvaPorc)
                .HasPrecision(6, 3);

            modelBuilder.Entity<Factura>()
                .Property(e => e.Iva)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.TotalFactura)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.MontoSujetoARetencion)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.ImpuestoRetenidoPorc)
                .HasPrecision(6, 3);

            modelBuilder.Entity<Factura>()
                .Property(e => e.ImpuestoRetenidoISLRAntesSustraendo)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.ImpuestoRetenidoISLRSustraendo)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.ImpuestoRetenido)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.RetencionSobreIvaPorc)
                .HasPrecision(6, 3);

            modelBuilder.Entity<Factura>()
                .Property(e => e.RetencionSobreIva)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.OtrosImpuestos)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.OtrasRetenciones)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.TotalAPagar)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.Anticipo)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .Property(e => e.Saldo)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Factura>()
                .HasMany(e => e.Facturas_Impuestos)
                .WithRequired(e => e.Factura)
                .HasForeignKey(e => e.FacturaID);

            modelBuilder.Entity<Facturas_Impuestos>()
                .Property(e => e.MontoBase)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Facturas_Impuestos>()
                .Property(e => e.Porcentaje)
                .HasPrecision(6, 3);

            modelBuilder.Entity<Facturas_Impuestos>()
                .Property(e => e.MontoAntesSustraendo)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Facturas_Impuestos>()
                .Property(e => e.Sustraendo)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Facturas_Impuestos>()
                .Property(e => e.Monto)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Moneda>()
                .HasMany(e => e.Facturas)
                .WithRequired(e => e.Moneda1)
                .HasForeignKey(e => e.Moneda)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.NumeroComprobante)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.MontoFacturaSinIva)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.MontoFacturaConIva)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.MontoTotalFactura)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.Tasa)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.BaseImponible_Reducido)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.BaseImponible_General)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.BaseImponible_Adicional)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.TipoAlicuota)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.IvaPorc)
                .HasPrecision(6, 3);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.IvaPorc_Reducido)
                .HasPrecision(6, 3);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.IvaPorc_General)
                .HasPrecision(6, 3);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.IvaPorc_Adicional)
                .HasPrecision(6, 3);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.Iva)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.Iva_Reducido)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.Iva_General)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.Iva_Adicional)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.TotalFactura)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.MontoSujetoARetencion)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.ImpuestoRetenidoPorc)
                .HasPrecision(6, 3);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.ImpuestoRetenidoISLRAntesSustraendo)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.ImpuestoRetenidoISLRSustraendo)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.ImpuestoRetenido)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.ImpuestoRetenido_Reducido)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.ImpuestoRetenido_General)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.ImpuestoRetenido_Adicional)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.RetencionSobreIvaPorc)
                .HasPrecision(6, 3);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.RetencionSobreIva)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.ImpuestosVarios)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.RetencionesVarias)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.TotalAPagar)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.Anticipo)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.Saldo)
                .HasPrecision(19, 4);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.NombreEstado)
                .IsFixedLength();

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.NombreCxCCxPFlag)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<tTempWebReport_ConsultaFacturas>()
                .Property(e => e.MontoPagado)
                .HasPrecision(19, 4);
        }
    }
}
