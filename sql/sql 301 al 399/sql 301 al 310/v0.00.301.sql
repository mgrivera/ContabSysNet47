/*    Lunes, 09 de Enero de 2.012  -   v0.00.301.sql 

	Para copiar los roles y permissions a la 'intrinsic database' 
	
	NOTA IMPORTANTE: este script debe ser ejecutado en el 'intrinsic db', y no en la base de datos
	externa (ej: dbContabRisk); lo más seguro es que la aplicación tenga otro número en otra base 
	de datos, lo cual quiere decir que hay que reemplazar el AppID que aparece abajo, por el que 
	corresponda. 
	
	Si actualizar la versión en el external db. 
*/


/****** Object:  Table [dbo].[aspnet_Roles]    Script Date: 01/09/2012 12:02:43 ******/

INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleId], [RoleName], [LoweredRoleName], [Description]) VALUES (N'47bcf69c-48cb-4c12-b794-a0e09417f5f9', N'71aa112e-0c5b-44c4-8d25-5cf116ac16ac', N'Administradores', N'administradores', NULL)
INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleId], [RoleName], [LoweredRoleName], [Description]) VALUES (N'47bcf69c-48cb-4c12-b794-a0e09417f5f9', N'0e442cd8-85d9-490a-8cc8-fb7c54574c56', N'Bancos_Adm', N'bancos_adm', NULL)
INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleId], [RoleName], [LoweredRoleName], [Description]) VALUES (N'47bcf69c-48cb-4c12-b794-a0e09417f5f9', N'77159d51-9ffa-477f-9032-7c7df18e6e6d', N'Bancos_Consultar', N'bancos_consultar', NULL)
INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleId], [RoleName], [LoweredRoleName], [Description]) VALUES (N'47bcf69c-48cb-4c12-b794-a0e09417f5f9', N'b77532d5-9486-4563-9f87-0330cddfd803', N'Bancos_User', N'bancos_user', NULL)
INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleId], [RoleName], [LoweredRoleName], [Description]) VALUES (N'47bcf69c-48cb-4c12-b794-a0e09417f5f9', N'0508b61c-fb7a-4e2f-9a81-930c03d0ac0d', N'CCCH_Adm', N'ccch_adm', NULL)
INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleId], [RoleName], [LoweredRoleName], [Description]) VALUES (N'47bcf69c-48cb-4c12-b794-a0e09417f5f9', N'31159856-1008-40f1-a24f-855635c1f5de', N'CCCH_Consultar', N'ccch_consultar', NULL)
INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleId], [RoleName], [LoweredRoleName], [Description]) VALUES (N'47bcf69c-48cb-4c12-b794-a0e09417f5f9', N'dfdc4840-483f-4e76-891c-9a64c9bed1a0', N'CCCH_User', N'ccch_user', NULL)
INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleId], [RoleName], [LoweredRoleName], [Description]) VALUES (N'47bcf69c-48cb-4c12-b794-a0e09417f5f9', N'b7de072c-99b7-478d-a305-bc44c9c44750', N'Contab_Adm', N'contab_adm', NULL)
INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleId], [RoleName], [LoweredRoleName], [Description]) VALUES (N'47bcf69c-48cb-4c12-b794-a0e09417f5f9', N'76fa4a8a-6e0f-4cc3-b878-8d629b3000d1', N'Contab_Consultar', N'contab_consultar', NULL)
INSERT [dbo].[aspnet_Roles] ([ApplicationId], [RoleId], [RoleName], [LoweredRoleName], [Description]) VALUES (N'47bcf69c-48cb-4c12-b794-a0e09417f5f9', N'18d4434d-3bd5-49a9-a990-df8573840997', N'Contab_User', N'contab_user', NULL)



INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Administradores', N'LightSwitchApplication:Bancos_Catalogos_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Administradores', N'LightSwitchApplication:Bancos_MovimientosBancarios_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Administradores', N'LightSwitchApplication:Bancos_Proveedores_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Administradores', N'LightSwitchApplication:CCCH_AbrirReposiciones_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Administradores', N'LightSwitchApplication:CCCH_Catalogos_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Administradores', N'LightSwitchApplication:CCCH_ConsultarReposiciones_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Administradores', N'LightSwitchApplication:CCCH_ProcesosVarios_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Administradores', N'LightSwitchApplication:Contabilidad_AsientosContables_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Administradores', N'LightSwitchApplication:Contabilidad_Catalogos_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Administradores', N'LightSwitchApplication:General_Companias')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Bancos_Adm', N'LightSwitchApplication:Bancos_Catalogos_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Bancos_Adm', N'LightSwitchApplication:Bancos_MovimientosBancarios_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Bancos_Adm', N'LightSwitchApplication:Bancos_Proveedores_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Bancos_User', N'LightSwitchApplication:Bancos_MovimientosBancarios_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'CCCH_Adm', N'LightSwitchApplication:CCCH_AbrirReposiciones_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'CCCH_Adm', N'LightSwitchApplication:CCCH_Catalogos_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'CCCH_Adm', N'LightSwitchApplication:CCCH_ConsultarReposiciones_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'CCCH_Adm', N'LightSwitchApplication:CCCH_ProcesosVarios_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'CCCH_Consultar', N'LightSwitchApplication:CCCH_ConsultarReposiciones_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'CCCH_User', N'LightSwitchApplication:CCCH_AbrirReposiciones_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Contab_Adm', N'LightSwitchApplication:Contabilidad_AsientosContables_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Contab_Adm', N'LightSwitchApplication:Contabilidad_Catalogos_Perm')
INSERT [dbo].[RolePermissions] ([RoleName], [PermissionId]) VALUES (N'Contab_User', N'LightSwitchApplication:Contabilidad_AsientosContables_Perm')



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.301', GetDate()) 