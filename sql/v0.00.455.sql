/*    
	  Martes, 12 de Diciembre de 2.023  -   v0.00.455.sql 
	  
	  Agregamos una columna timestamp a las tablas: Asientos y ParametrosContab
	  También agregamos el Tipo al view: v_utilitarios_contab_asientos_lista
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
ALTER TABLE dbo.Asientos ADD rowversion timestamp NULL
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.ParametrosContab ADD rowversion timestamp NULL
GO
ALTER TABLE dbo.ParametrosContab SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



-- ********************************************************************************
-- v_utilitarios_contab_asientos_lista - agregamos el tipo de asientos al view
-- ********************************************************************************

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.v_utilitarios_contab_asientos_lista ', 'V') IS NOT NULL
  DROP VIEW dbo.v_utilitarios_contab_asientos_lista;

GO

Create View dbo.v_utilitarios_contab_asientos_lista  As 
  
Select Top 100 Percent a.Moneda as moneda, m.Simbolo as monedaSimbolo, 
a.MonedaOriginal as monedaOriginal, mo.Simbolo as monedaOriginalSimbolo, 
a.Numero as numero, a.Mes as mes, a.Ano as ano, a.Fecha as fecha, a.Tipo as tipo, 
a.FactorDeCambio as tasa, 
a.MesFiscal as mesFiscal, a.AnoFiscal as anoFiscal, 

Sum(d.Debe) as sumOfDebe, Sum(d.Haber) as sumOfHaber, (Sum(d.Debe) - Sum(d.Haber)) as diferencia, Count(*) as count, 

a.Cia as cia, c.Abreviatura as companiaAbreviatura 

From Asientos a 
Inner Join Monedas m On a.Moneda = m.Moneda 
Inner Join Monedas mo On a.MonedaOriginal = mo.Moneda 
Inner Join Companias c On a.Cia = c.Numero 
Left Outer Join dAsientos d On a.NumeroAutomatico = d.NumeroAutomatico 

Group by a.Moneda, m.Simbolo, 
a.MonedaOriginal, mo.Simbolo, 
a.Numero, a.Mes, a.Ano, a.Fecha, a.Tipo, 
a.FactorDeCambio, 
a.MesFiscal, a.AnoFiscal, 
a.Cia, c.Abreviatura

Order by a.Numero

Go


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.455', GetDate()) 