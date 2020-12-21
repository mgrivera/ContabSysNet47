namespace ContabSysNet_Web.ModelosDatos_EF.code_first.contab
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class ContabContext : DbContext
    {
        public ContabContext() : base("dbContabConnectionString")
        {
            // para que EF ni siquiera intente generar migrations ... 
            Database.SetInitializer<ContabContext>(null);
        }

        public virtual DbSet<Asientos> Asientos { get; set; }
        public virtual DbSet<CentrosCosto> CentrosCosto { get; set; }
        public virtual DbSet<Companias> Companias { get; set; }
        public virtual DbSet<ConsultaCuentasYMovimientos> ConsultaCuentasYMovimientos { get; set; }
        public virtual DbSet<ConsultaCuentasYMovimientos_Movimientos> ConsultaCuentasYMovimientos_Movimientos { get; set; }
        public virtual DbSet<CuentasContables> CuentasContables { get; set; }
        public virtual DbSet<dAsientos> dAsientos { get; set; }
        public virtual DbSet<Monedas> Monedas { get; set; }
        public virtual DbSet<ParametrosContab> ParametrosContab { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Asientos>()
                .Property(e => e.FactorDeCambio)
                .HasPrecision(19, 4);

            modelBuilder.Entity<CentrosCosto>()
                .Property(e => e.DescripcionCorta)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<Companias>()
                .HasMany(e => e.Asientos)
                .WithRequired(e => e.Companias)
                .HasForeignKey(e => e.Cia)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Companias>()
                .HasMany(e => e.CuentasContables)
                .WithRequired(e => e.Companias)
                .HasForeignKey(e => e.Cia)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Companias>()
                .HasOptional(e => e.ParametrosContab)
                .WithRequired(e => e.Companias)
                .WillCascadeOnDelete();

            modelBuilder.Entity<ConsultaCuentasYMovimientos>()
                .HasMany(e => e.ConsultaCuentasYMovimientos_Movimientos)
                .WithRequired(e => e.ConsultaCuentasYMovimientos)
                .HasForeignKey(e => e.ParentID);

            modelBuilder.Entity<ConsultaCuentasYMovimientos_Movimientos>()
                .Property(e => e.Monto)
                .HasPrecision(19, 4);

            modelBuilder.Entity<CuentasContables>()
                .HasMany(e => e.ConsultaCuentasYMovimientos)
                .WithRequired(e => e.CuentasContables)
                .HasForeignKey(e => e.CuentaContableID);

            modelBuilder.Entity<CuentasContables>()
                .HasMany(e => e.dAsientos)
                .WithRequired(e => e.CuentasContables)
                .HasForeignKey(e => e.CuentaContableID)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<dAsientos>()
                .Property(e => e.Debe)
                .HasPrecision(19, 4);

            modelBuilder.Entity<dAsientos>()
                .Property(e => e.Haber)
                .HasPrecision(19, 4);

            modelBuilder.Entity<Monedas>()
                .HasMany(e => e.Asientos)
                .WithRequired(e => e.Monedas)
                .HasForeignKey(e => e.Moneda)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Monedas>()
                .HasMany(e => e.Asientos1)
                .WithRequired(e => e.Monedas1)
                .HasForeignKey(e => e.MonedaOriginal)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Monedas>()
                .HasMany(e => e.Companias)
                .WithOptional(e => e.Monedas)
                .HasForeignKey(e => e.MonedaDefecto);
        }
    }
}
