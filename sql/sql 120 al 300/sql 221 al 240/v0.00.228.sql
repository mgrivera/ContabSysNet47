/*    Miércoles, 3 de diciembre de 2.008  -   v0.00.228.sql 

	Agregamos la tabla Roles_FuncionesAplicacion

*/ 


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles_FuncionesAplicacion](
	[RoleName] [nvarchar](50) NOT NULL,
	[FunctionName] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_Roles_FuncionesAplicacion] PRIMARY KEY CLUSTERED 
(
	[RoleName] ASC,
	[FunctionName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.228', GetDate()) 