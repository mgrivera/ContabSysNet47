/*    
	  Martes, 9 de Abril de 2.025  -   v0.00.466.sql 
	  
	  Agregamos la tabla ProductosFacturas

*/

-- **********************************************************
-- ProductosFacturas
-- **********************************************************

/****** Object:  Table [dbo].[ProductosFacturas]    Script Date: 4/10/2025 5:17:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProductosFacturas](
	[Codigo] [nvarchar](20) NOT NULL,
	[Nombre] [nvarchar](30) NOT NULL,
	[Descripcion] [nvarchar](50) NOT NULL,
	[Precio_NoImponible] [decimal](12, 2) NULL,
	[Precio_Imponible] [decimal](12, 2) NULL,
	[Cia] [int] NULL,
 CONSTRAINT [PK_ProductosFacturas] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProductosFacturas]  WITH CHECK ADD  CONSTRAINT [FK_ProductosFacturas_Companias] FOREIGN KEY([Cia])
REFERENCES [dbo].[Companias] ([Numero])
GO

ALTER TABLE [dbo].[ProductosFacturas] CHECK CONSTRAINT [FK_ProductosFacturas_Companias]
GO


Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.466', GetDate()) 