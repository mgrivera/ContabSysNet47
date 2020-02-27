/*    Lunes, 25 de Junio de 2.013 	-   v0.00.341.sql 

	Cambios leves a la tabla tMaestraRubros 
*/


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
DROP TABLE dbo.tMaestraRubrosId
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tMaestraRubros
	(
	Rubro int NOT NULL IDENTITY (1, 1),
	NombreCortoRubro nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Descripcion nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Tipo nvarchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	TipoNomina nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Periodicidad nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Desde datetime NULL,
	Hasta datetime NULL,
	Siempre bit NULL,
	MontoAAplicar money NULL,
	RubroAAplicar int NULL,
	GrupoAAplicar int NULL,
	DeLaNomina nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DeLaNominaDesde smalldatetime NULL,
	DeLaNominaHasta smalldatetime NULL,
	VariableAAplicar tinyint NULL,
	BaseCalculoVariableFlag char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Factor1 float(53) NULL,
	Factor2 float(53) NULL,
	Divisor1 float(53) NULL,
	Divisor2 float(53) NULL,
	Porcentaje float(53) NULL,
	PorcentajeMas float(53) NULL,
	PorcentajeMas2 float(53) NULL,
	LunesDelMes bit NULL,
	Tope money NULL,
	Categoria smallint NULL,
	MostrarEnElReciboFlag bit NULL,
	SSOFlag bit NULL,
	ISRFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tMaestraRubros ON
GO
IF EXISTS(SELECT * FROM dbo.tMaestraRubros)
	 EXEC('INSERT INTO dbo.Tmp_tMaestraRubros (Rubro, NombreCortoRubro, Descripcion, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag, SSOFlag, ISRFlag)
		SELECT Rubro, NombreCortoRubro, Descripcion, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag, SSOFlag, ISRFlag FROM dbo.tMaestraRubros WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tMaestraRubros OFF
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros
	DROP CONSTRAINT FK_SueldoAumentado_Definicion_Rubros_tMaestraRubros
GO
DROP TABLE dbo.tMaestraRubros
GO
EXECUTE sp_rename N'dbo.Tmp_tMaestraRubros', N'tMaestraRubros', 'OBJECT' 
GO
ALTER TABLE dbo.tMaestraRubros ADD CONSTRAINT
	PK_tMaestraRubros PRIMARY KEY NONCLUSTERED 
	(
	Rubro
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros ADD CONSTRAINT
	FK_SueldoAumentado_Definicion_Rubros_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tMaestraRubros
	(
	Rubro int NOT NULL IDENTITY (1, 1),
	NombreCortoRubro nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Descripcion nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Tipo nvarchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	SalarioFlag bit NULL,
	TipoNomina nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Periodicidad nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Desde datetime NULL,
	Hasta datetime NULL,
	Siempre bit NULL,
	MontoAAplicar money NULL,
	RubroAAplicar int NULL,
	GrupoAAplicar int NULL,
	DeLaNomina nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DeLaNominaDesde smalldatetime NULL,
	DeLaNominaHasta smalldatetime NULL,
	VariableAAplicar tinyint NULL,
	BaseCalculoVariableFlag char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Factor1 float(53) NULL,
	Factor2 float(53) NULL,
	Divisor1 float(53) NULL,
	Divisor2 float(53) NULL,
	Porcentaje float(53) NULL,
	PorcentajeMas float(53) NULL,
	PorcentajeMas2 float(53) NULL,
	LunesDelMes bit NULL,
	Tope money NULL,
	Categoria smallint NULL,
	MostrarEnElReciboFlag bit NULL,
	SSOFlag bit NULL,
	ISRFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tMaestraRubros ON
GO
IF EXISTS(SELECT * FROM dbo.tMaestraRubros)
	 EXEC('INSERT INTO dbo.Tmp_tMaestraRubros (Rubro, NombreCortoRubro, Descripcion, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag, SSOFlag, ISRFlag)
		SELECT Rubro, NombreCortoRubro, Descripcion, Tipo, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag, SSOFlag, ISRFlag FROM dbo.tMaestraRubros WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tMaestraRubros OFF
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros
	DROP CONSTRAINT FK_SueldoAumentado_Definicion_Rubros_tMaestraRubros
GO
DROP TABLE dbo.tMaestraRubros
GO
EXECUTE sp_rename N'dbo.Tmp_tMaestraRubros', N'tMaestraRubros', 'OBJECT' 
GO
ALTER TABLE dbo.tMaestraRubros ADD CONSTRAINT
	PK_tMaestraRubros PRIMARY KEY NONCLUSTERED 
	(
	Rubro
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros ADD CONSTRAINT
	FK_SueldoAumentado_Definicion_Rubros_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT





BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tMaestraRubros
	(
	Rubro int NOT NULL IDENTITY (1, 1),
	NombreCortoRubro nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Descripcion nvarchar(250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Tipo nvarchar(1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	SalarioFlag bit NULL,
	TipoNomina nvarchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Periodicidad nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Desde datetime NULL,
	Hasta datetime NULL,
	Siempre bit NULL,
	MontoAAplicar money NULL,
	RubroAAplicar int NULL,
	GrupoAAplicar int NULL,
	DeLaNomina nvarchar(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DeLaNominaDesde smalldatetime NULL,
	DeLaNominaHasta smalldatetime NULL,
	VariableAAplicar tinyint NULL,
	BaseCalculoVariableFlag char(2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Factor1 float(53) NULL,
	Factor2 float(53) NULL,
	Divisor1 float(53) NULL,
	Divisor2 float(53) NULL,
	Porcentaje float(53) NULL,
	PorcentajeMas float(53) NULL,
	PorcentajeMas2 float(53) NULL,
	LunesDelMes bit NULL,
	Tope money NULL,
	Categoria smallint NULL,
	MostrarEnElReciboFlag bit NULL,
	SSOFlag bit NULL,
	ISRFlag bit NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tMaestraRubros ON
GO
IF EXISTS(SELECT * FROM dbo.tMaestraRubros)
	 EXEC('INSERT INTO dbo.Tmp_tMaestraRubros (Rubro, NombreCortoRubro, Descripcion, Tipo, SalarioFlag, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag, SSOFlag, ISRFlag)
		SELECT Rubro, NombreCortoRubro, Descripcion, Tipo, SalarioFlag, TipoNomina, Periodicidad, Desde, Hasta, Siempre, MontoAAplicar, RubroAAplicar, GrupoAAplicar, DeLaNomina, DeLaNominaDesde, DeLaNominaHasta, VariableAAplicar, BaseCalculoVariableFlag, Factor1, Factor2, Divisor1, Divisor2, Porcentaje, PorcentajeMas, PorcentajeMas2, LunesDelMes, Tope, Categoria, MostrarEnElReciboFlag, SSOFlag, ISRFlag FROM dbo.tMaestraRubros WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tMaestraRubros OFF
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros
	DROP CONSTRAINT FK_SueldoAumentado_Definicion_Rubros_tMaestraRubros
GO
DROP TABLE dbo.tMaestraRubros
GO
EXECUTE sp_rename N'dbo.Tmp_tMaestraRubros', N'tMaestraRubros', 'OBJECT' 
GO
ALTER TABLE dbo.tMaestraRubros ADD CONSTRAINT
	PK_tMaestraRubros PRIMARY KEY NONCLUSTERED 
	(
	Rubro
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros ADD CONSTRAINT
	FK_SueldoAumentado_Definicion_Rubros_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.SueldoAumentado_Definicion_Rubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.341', GetDate()) 