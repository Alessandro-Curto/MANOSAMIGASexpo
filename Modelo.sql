USE [master]
GO
/****** Object:  Database [ManosAmigas]    Script Date: 27/05/2025 16:36:05 ******/
CREATE DATABASE [ManosAmigas]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ManosAmigas', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ManosAmigas.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ManosAmigas_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ManosAmigas_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ManosAmigas] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ManosAmigas].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ManosAmigas] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ManosAmigas] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ManosAmigas] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ManosAmigas] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ManosAmigas] SET ARITHABORT OFF 
GO
ALTER DATABASE [ManosAmigas] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ManosAmigas] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ManosAmigas] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ManosAmigas] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ManosAmigas] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ManosAmigas] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ManosAmigas] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ManosAmigas] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ManosAmigas] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ManosAmigas] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ManosAmigas] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ManosAmigas] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ManosAmigas] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ManosAmigas] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ManosAmigas] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ManosAmigas] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ManosAmigas] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ManosAmigas] SET RECOVERY FULL 
GO
ALTER DATABASE [ManosAmigas] SET  MULTI_USER 
GO
ALTER DATABASE [ManosAmigas] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ManosAmigas] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ManosAmigas] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ManosAmigas] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ManosAmigas] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ManosAmigas] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ManosAmigas', N'ON'
GO
ALTER DATABASE [ManosAmigas] SET QUERY_STORE = ON
GO
ALTER DATABASE [ManosAmigas] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ManosAmigas]
GO
/****** Object:  Table [dbo].[Voluntarios]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Voluntarios](
	[id_voluntario] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[telefono] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_voluntario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Asignaciones]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Asignaciones](
	[id_asignacion] [int] IDENTITY(1,1) NOT NULL,
	[id_voluntario] [int] NOT NULL,
	[id_evento] [int] NOT NULL,
	[fecha_asignacion] [datetime] NULL,
	[asistio] [bit] NULL,
	[horas_trabajadas] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_asignacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [uq_voluntario_evento] UNIQUE NONCLUSTERED 
(
	[id_voluntario] ASC,
	[id_evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_horas_voluntarios]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Vista para reporte de horas trabajadas por voluntario
CREATE VIEW [dbo].[vw_horas_voluntarios] AS
SELECT 
    v.id_voluntario,
    v.nombre,
    v.email,
    COUNT(a.id_asignacion) AS eventos_asignados,
    SUM(CASE WHEN a.asistio = 1 THEN 1 ELSE 0 END) AS eventos_asistidos,
    SUM(a.horas_trabajadas) AS total_horas
FROM 
    Voluntarios v
LEFT JOIN 
    Asignaciones a ON v.id_voluntario = a.id_voluntario
GROUP BY 
    v.id_voluntario, v.nombre, v.email;
GO
/****** Object:  Table [dbo].[Eventos]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Eventos](
	[id_evento] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](100) NOT NULL,
	[descripcion] [nvarchar](255) NULL,
	[fecha_inicio] [datetime] NOT NULL,
	[fecha_fin] [datetime] NOT NULL,
	[ubicacion] [nvarchar](100) NOT NULL,
	[cupo_maximo] [int] NOT NULL,
	[id_interes_requerido] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_cupos_eventos]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Vista para reporte de cupos disponibles por evento
CREATE VIEW [dbo].[vw_cupos_eventos] AS
SELECT 
    e.id_evento,
    e.nombre,
    e.fecha_inicio,
    e.ubicacion,
    e.cupo_maximo,
    e.cupo_maximo - COUNT(a.id_asignacion) AS cupos_disponibles
FROM 
    Eventos e
LEFT JOIN 
    Asignaciones a ON e.id_evento = a.id_evento
GROUP BY 
    e.id_evento, e.nombre, e.fecha_inicio, e.ubicacion, e.cupo_maximo;
GO
/****** Object:  Table [dbo].[VoluntarioIntereses]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VoluntarioIntereses](
	[id_voluntario] [int] NOT NULL,
	[id_interes] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_voluntario] ASC,
	[id_interes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VoluntarioDisponibilidad]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VoluntarioDisponibilidad](
	[id_voluntario] [int] NOT NULL,
	[id_dia] [int] NOT NULL,
	[turno] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_voluntario] ASC,
	[id_dia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_voluntarios_disponibles_evento]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_voluntarios_disponibles_evento] AS
SELECT 
    e.id_evento,
    e.nombre AS evento,
    v.id_voluntario,
    v.nombre AS voluntario,
    v.email,
    v.telefono
FROM 
    Eventos e
CROSS JOIN 
    Voluntarios v
WHERE 
    v.id_voluntario NOT IN (
        SELECT id_voluntario 
        FROM Asignaciones 
        WHERE id_evento = e.id_evento
    )
    AND EXISTS (
        SELECT 1 
        FROM VoluntarioIntereses vi
        WHERE vi.id_voluntario = v.id_voluntario
        AND vi.id_interes = e.id_interes_requerido
    )
    AND EXISTS (
        SELECT 1 
        FROM VoluntarioDisponibilidad vd
        WHERE vd.id_voluntario = v.id_voluntario
        AND vd.id_dia = DATEPART(WEEKDAY, e.fecha_inicio)
    )
    AND e.fecha_inicio > GETDATE();
GO
/****** Object:  Table [dbo].[DiasDisponibilidad]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiasDisponibilidad](
	[id_dia] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_dia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HistorialHoras]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistorialHoras](
	[id_historial] [int] IDENTITY(1,1) NOT NULL,
	[id_asignacion] [int] NOT NULL,
	[horas_antes] [int] NOT NULL,
	[horas_despues] [int] NOT NULL,
	[fecha_cambio] [datetime] NULL,
	[usuario_cambio] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_historial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Intereses]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Intereses](
	[id_interes] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_interes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notificaciones]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notificaciones](
	[id_notificacion] [int] IDENTITY(1,1) NOT NULL,
	[id_evento] [int] NOT NULL,
	[asunto] [nvarchar](100) NOT NULL,
	[cuerpo] [nvarchar](max) NOT NULL,
	[fecha_programada] [datetime] NOT NULL,
	[fecha_envio] [datetime] NULL,
	[estado] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_notificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificacionVoluntarios]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificacionVoluntarios](
	[id_notificacion] [int] NOT NULL,
	[id_voluntario] [int] NOT NULL,
	[enviado] [bit] NULL,
	[fecha_envio] [datetime] NULL,
	[error] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_notificacion] ASC,
	[id_voluntario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[id_rol] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [nvarchar](20) NOT NULL,
	[descripcion] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[id_usuario] [int] IDENTITY(1,1) NOT NULL,
	[id_voluntario] [int] NULL,
	[email] [nvarchar](100) NOT NULL,
	[contrasena_hash] [varbinary](64) NOT NULL,
	[id_rol] [int] NOT NULL,
	[fecha_registro] [datetime] NULL,
	[ultimo_login] [datetime] NULL,
	[activo] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [idx_asignacion_evento]    Script Date: 27/05/2025 16:36:06 ******/
CREATE NONCLUSTERED INDEX [idx_asignacion_evento] ON [dbo].[Asignaciones]
(
	[id_evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_asignacion_voluntario]    Script Date: 27/05/2025 16:36:06 ******/
CREATE NONCLUSTERED INDEX [idx_asignacion_voluntario] ON [dbo].[Asignaciones]
(
	[id_voluntario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_evento_fechas]    Script Date: 27/05/2025 16:36:06 ******/
CREATE NONCLUSTERED INDEX [idx_evento_fechas] ON [dbo].[Eventos]
(
	[fecha_inicio] ASC,
	[fecha_fin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_usuario_rol]    Script Date: 27/05/2025 16:36:06 ******/
CREATE NONCLUSTERED INDEX [idx_usuario_rol] ON [dbo].[Usuarios]
(
	[id_rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_voluntario_email]    Script Date: 27/05/2025 16:36:06 ******/
CREATE NONCLUSTERED INDEX [idx_voluntario_email] ON [dbo].[Voluntarios]
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Asignaciones] ADD  DEFAULT (getdate()) FOR [fecha_asignacion]
GO
ALTER TABLE [dbo].[Asignaciones] ADD  DEFAULT ((0)) FOR [asistio]
GO
ALTER TABLE [dbo].[Asignaciones] ADD  DEFAULT ((0)) FOR [horas_trabajadas]
GO
ALTER TABLE [dbo].[HistorialHoras] ADD  DEFAULT (getdate()) FOR [fecha_cambio]
GO
ALTER TABLE [dbo].[Notificaciones] ADD  DEFAULT ('Pendiente') FOR [estado]
GO
ALTER TABLE [dbo].[NotificacionVoluntarios] ADD  DEFAULT ((0)) FOR [enviado]
GO
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT (getdate()) FOR [fecha_registro]
GO
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[Asignaciones]  WITH CHECK ADD FOREIGN KEY([id_evento])
REFERENCES [dbo].[Eventos] ([id_evento])
GO
ALTER TABLE [dbo].[Asignaciones]  WITH CHECK ADD FOREIGN KEY([id_voluntario])
REFERENCES [dbo].[Voluntarios] ([id_voluntario])
GO
ALTER TABLE [dbo].[Eventos]  WITH CHECK ADD FOREIGN KEY([id_interes_requerido])
REFERENCES [dbo].[Intereses] ([id_interes])
GO
ALTER TABLE [dbo].[HistorialHoras]  WITH CHECK ADD FOREIGN KEY([id_asignacion])
REFERENCES [dbo].[Asignaciones] ([id_asignacion])
GO
ALTER TABLE [dbo].[Notificaciones]  WITH CHECK ADD FOREIGN KEY([id_evento])
REFERENCES [dbo].[Eventos] ([id_evento])
GO
ALTER TABLE [dbo].[NotificacionVoluntarios]  WITH CHECK ADD FOREIGN KEY([id_notificacion])
REFERENCES [dbo].[Notificaciones] ([id_notificacion])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NotificacionVoluntarios]  WITH CHECK ADD FOREIGN KEY([id_voluntario])
REFERENCES [dbo].[Voluntarios] ([id_voluntario])
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD FOREIGN KEY([id_rol])
REFERENCES [dbo].[Roles] ([id_rol])
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD FOREIGN KEY([id_voluntario])
REFERENCES [dbo].[Voluntarios] ([id_voluntario])
GO
ALTER TABLE [dbo].[VoluntarioDisponibilidad]  WITH CHECK ADD FOREIGN KEY([id_dia])
REFERENCES [dbo].[DiasDisponibilidad] ([id_dia])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VoluntarioDisponibilidad]  WITH CHECK ADD FOREIGN KEY([id_voluntario])
REFERENCES [dbo].[Voluntarios] ([id_voluntario])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VoluntarioIntereses]  WITH CHECK ADD FOREIGN KEY([id_interes])
REFERENCES [dbo].[Intereses] ([id_interes])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VoluntarioIntereses]  WITH CHECK ADD FOREIGN KEY([id_voluntario])
REFERENCES [dbo].[Voluntarios] ([id_voluntario])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Asignaciones]  WITH CHECK ADD CHECK  (([horas_trabajadas]>=(0)))
GO
ALTER TABLE [dbo].[Eventos]  WITH CHECK ADD  CONSTRAINT [chk_fechas] CHECK  (([fecha_fin]>[fecha_inicio]))
GO
ALTER TABLE [dbo].[Eventos] CHECK CONSTRAINT [chk_fechas]
GO
ALTER TABLE [dbo].[Eventos]  WITH CHECK ADD CHECK  (([cupo_maximo]>(0)))
GO
ALTER TABLE [dbo].[Notificaciones]  WITH CHECK ADD CHECK  (([estado]='Error' OR [estado]='Enviado' OR [estado]='Pendiente'))
GO
ALTER TABLE [dbo].[Usuarios]  WITH CHECK ADD  CONSTRAINT [chk_email_usuario] CHECK  (([email] like '%@%.%'))
GO
ALTER TABLE [dbo].[Usuarios] CHECK CONSTRAINT [chk_email_usuario]
GO
ALTER TABLE [dbo].[VoluntarioDisponibilidad]  WITH CHECK ADD CHECK  (([turno]='Completo' OR [turno]='Tarde' OR [turno]='Mañana'))
GO
ALTER TABLE [dbo].[Voluntarios]  WITH CHECK ADD  CONSTRAINT [chk_email] CHECK  (([email] like '%@%.%'))
GO
ALTER TABLE [dbo].[Voluntarios] CHECK CONSTRAINT [chk_email]
GO
ALTER TABLE [dbo].[Voluntarios]  WITH CHECK ADD  CONSTRAINT [chk_telefono] CHECK  (([telefono] like '+[0-9]%' OR [telefono] IS NULL))
GO
ALTER TABLE [dbo].[Voluntarios] CHECK CONSTRAINT [chk_telefono]
GO
/****** Object:  StoredProcedure [dbo].[sp_asignar_voluntario_evento]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS ÚTILES
-- =============================================

-- Procedimiento para asignar voluntario a evento con validaciones
CREATE PROCEDURE [dbo].[sp_asignar_voluntario_evento]
    @id_voluntario INT,
    @id_evento INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Verificar si el voluntario existe
        IF NOT EXISTS (SELECT 1 FROM Voluntarios WHERE id_voluntario = @id_voluntario)
            RAISERROR('El voluntario especificado no existe', 16, 1);
            
        -- Verificar si el evento existe
        IF NOT EXISTS (SELECT 1 FROM Eventos WHERE id_evento = @id_evento)
            RAISERROR('El evento especificado no existe', 16, 1);
            
        -- Verificar si ya está asignado
        IF EXISTS (SELECT 1 FROM Asignaciones WHERE id_voluntario = @id_voluntario AND id_evento = @id_evento)
            RAISERROR('El voluntario ya está asignado a este evento', 16, 1);
            
        -- Verificar cupos disponibles (el trigger también lo hace, pero es buena práctica verificarlo aquí)
        DECLARE @cupo_disponible INT;
        SELECT @cupo_disponible = e.cupo_maximo - COUNT(a.id_asignacion)
        FROM Eventos e
        LEFT JOIN Asignaciones a ON e.id_evento = a.id_evento
        WHERE e.id_evento = @id_evento
        GROUP BY e.cupo_maximo;
        
        IF @cupo_disponible <= 0
            RAISERROR('No hay cupos disponibles para este evento', 16, 1);
            
        -- Verificar interés del voluntario
        DECLARE @id_interes_evento INT;
        SELECT @id_interes_evento = id_interes_requerido FROM Eventos WHERE id_evento = @id_evento;
        
        IF @id_interes_evento IS NOT NULL 
            AND NOT EXISTS (
                SELECT 1 
                FROM VoluntarioIntereses 
                WHERE id_voluntario = @id_voluntario 
                AND id_interes = @id_interes_evento)
            RAISERROR('El voluntario no tiene el interés requerido para este evento', 16, 1);
            
        -- Verificar disponibilidad
        DECLARE @dia_evento INT;
        SELECT @dia_evento = DATEPART(WEEKDAY, fecha_inicio) FROM Eventos WHERE id_evento = @id_evento;
        
        IF NOT EXISTS (
            SELECT 1 
            FROM VoluntarioDisponibilidad 
            WHERE id_voluntario = @id_voluntario 
            AND id_dia = @dia_evento)
            RAISERROR('El voluntario no está disponible en la fecha del evento', 16, 1);
            
        -- Asignar voluntario
        INSERT INTO Asignaciones (id_voluntario, id_evento)
        VALUES (@id_voluntario, @id_evento);
        
        COMMIT TRANSACTION;
        SELECT 'Asignación realizada con éxito' AS resultado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SELECT 
            ERROR_MESSAGE() AS error,
            ERROR_NUMBER() AS error_number,
            ERROR_SEVERITY() AS severity;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_eventos_proximos]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Procedimiento para generar reporte de eventos próximos
CREATE   PROCEDURE [dbo].[sp_eventos_proximos]
    @dias INT = 7
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        e.id_evento,
        e.nombre,
        e.descripcion,
        e.fecha_inicio,
        e.fecha_fin,
        e.ubicacion,
        e.cupo_maximo,
        e.cupo_maximo - COUNT(a.id_asignacion) AS cupos_disponibles,
        i.nombre AS interes_requerido
    FROM 
        Eventos e
    LEFT JOIN 
        Asignaciones a ON e.id_evento = a.id_evento
    LEFT JOIN
        Intereses i ON e.id_interes_requerido = i.id_interes
    WHERE 
        e.fecha_inicio BETWEEN GETDATE() AND DATEADD(DAY, @dias, GETDATE())
    GROUP BY 
        e.id_evento, e.nombre, e.descripcion, e.fecha_inicio, e.fecha_fin, 
        e.ubicacion, e.cupo_maximo, i.nombre
    ORDER BY 
        e.fecha_inicio;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_registrar_asistencia]    Script Date: 27/05/2025 16:36:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Procedimiento para registrar asistencia
CREATE PROCEDURE [dbo].[sp_registrar_asistencia]
    @id_asignacion INT,
    @asistio BIT,
    @horas_trabajadas INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Verificar si la asignación existe
        IF NOT EXISTS (SELECT 1 FROM Asignaciones WHERE id_asignacion = @id_asignacion)
            RAISERROR('La asignación especificada no existe', 16, 1);
            
        -- Verificar horas trabajadas
        IF @asistio = 1 AND @horas_trabajadas <= 0
            RAISERROR('Debe especificar horas trabajadas si el voluntario asistió', 16, 1);
            
        -- Actualizar asistencia
        UPDATE Asignaciones
        SET 
            asistio = @asistio,
            horas_trabajadas = CASE WHEN @asistio = 1 THEN @horas_trabajadas ELSE 0 END
        WHERE id_asignacion = @id_asignacion;
        
        COMMIT TRANSACTION;
        SELECT 'Asistencia registrada con éxito' AS resultado;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SELECT 
            ERROR_MESSAGE() AS error,
            ERROR_NUMBER() AS error_number,
            ERROR_SEVERITY() AS severity;
    END CATCH
END;
GO
USE [master]
GO
ALTER DATABASE [ManosAmigas] SET  READ_WRITE 
GO


USE ManosAmigas
GO

SELECT*FROM Eventos
SELECT*FROM Voluntarios
SELECT*FROM Notificaciones
SELECT*FROM NotificacionVoluntarios

USE ManosAmigas;
GO

-- Este comando altera la tabla y cambia el tamaño de la columna 'error'
ALTER TABLE NotificacionVoluntarios
ALTER COLUMN error NVARCHAR(MAX); -- Usamos MAX para permitir textos muy largos
GO

ALTER TABLE Asignaciones
ADD estado_asignacion NVARCHAR(20) NOT NULL
CONSTRAINT DF_Asignaciones_Estado DEFAULT 'Confirmado';


SELECT*FROM Asignaciones
ALTER TABLE asignaciones RENAME COLUMN estado TO estado_asignacion;


USE ManosAmigas
GO
ALTER TABLE Eventos
ADD CONSTRAINT uq_evento_unico UNIQUE (nombre, descripcion, fecha, ubicacion, capacidad, supervisor_id);

USE ManosAmigas
GO


INSERT INTO Voluntarios (nombre, email, telefono)
VALUES ('Alessandro Curto', 'alessandro.curto.m@uni.pe', '+51987654321');

SELECT*FROM Voluntarios

USE ManosAmigas
GO
select *
from Eventos
SELECT 1 FROM VoluntarioIntereses
WHERE id_voluntario = 1 AND id_interes = 1
select *
from VoluntarioIntereses
SELECT COUNT(1) cont FROM Voluntarios WHERE id_voluntario = 1

select *
from Voluntarios

select * from VoluntarioIntereses
select *
from Asignaciones

select *
from Usuarios

select *
from Eventos

select *
from DiasDisponibilidad

select * 
from Roles

select count(1) cont from Usuarios where id_usuario=2
SELECT r.nombre FROM Usuarios u
JOIN Roles r ON r.id_rol = u.id_rol
WHERE u.id_usuario = 2

SELECT fecha_inicio FROM Eventos WHERE id_evento = 1

SELECT r.nombre FROM Usuarios u
JOIN Roles r ON r.id_rol = u.id_rol
WHERE u.id_usuario = 2

select * from Asignaciones

select * from VoluntarioDisponibilidad

select * from DiasDisponibilidad

select * from Intereses

---Permite valores null en la columna asistio
ALTER TABLE Asignaciones
ALTER COLUMN asistio BIT NULL;

SELECT e.cupo_maximo - COUNT(a.id_asignacion) cup_disponible
FROM Eventos e LEFT JOIN Asignaciones a ON e.id_evento = a.id_evento
WHERE e.id_evento =2
GROUP BY e.cupo_maximo

---Agregar la columna estado_asignacion en la tabla Asignaciones
---1. Agregar la columna si no existe aún
ALTER TABLE Asignaciones
ADD estado_asignacion NVARCHAR(20);

-- 2. Corregir valores NULL o vacíos (asignar un valor por defecto temporal)
UPDATE Asignaciones
SET estado_asignacion = 'Confirmado'
WHERE estado_asignacion IS NULL OR LTRIM(RTRIM(estado_asignacion)) = ''; --se usa esta porsiaca :v

-- 3. Agregar restricción CHECK para validar los valores permitidos
ALTER TABLE Asignaciones
ADD CONSTRAINT chk_estado_asignacion
CHECK (estado_asignacion IN ('Pendiente', 'Confirmado', 'Rechazado'));

-- 4.Agregar valor por defecto
ALTER TABLE Asignaciones
ADD CONSTRAINT df_estado_asignacion
DEFAULT 'Confirmado' FOR estado_asignacion;

SELECT id_voluntario FROM Usuarios WHERE id_usuario = 2

--- PRUEBAS REQUERIMIENTO 3 (INSERTAR DATOS)
---Insertar evento ya ocurrido
-- Insertar un evento que ya ocurrió (5 días atrás)
INSERT INTO Eventos (nombre,descripcion,fecha_inicio,fecha_fin,ubicacion,cupo_maximo,id_interes_requerido)
VALUES (
    'Jornada de Limpieza',
    'Actividad comunitaria para limpiar áreas verdes.',
    DATEADD(DAY, -5, GETDATE()),                        -- hace 5 días
    DATEADD(HOUR, -119, GETDATE()), 
    'Parque Central',
    5, -- cupo máximo
    1  -- ID de interés requerido, por ejemplo: 1 = Medio Ambiente
);
---Añadir interés 5 a los voluntarios con id_voluntario = 8,9 y 10
INSERT INTO VoluntarioIntereses (id_voluntario, id_interes) VALUES (9, 5);
INSERT INTO VoluntarioIntereses (id_voluntario, id_interes) VALUES (10, 5);
INSERT INTO VoluntarioIntereses (id_voluntario, id_interes) VALUES (8, 5);

--Añadir disponibilidad los días miercoles a los voluntarios 8 y 10 para que puedan ser inscritos al evento id_evento=5
INSERT INTO VoluntarioDisponibilidad (id_voluntario, id_dia) VALUES (8, 3);
INSERT INTO VoluntarioDisponibilidad (id_voluntario, id_dia) VALUES (10, 3);
--Ver que día cae el evento
SELECT DATEPART(WEEKDAY, fecha_inicio) AS dia_evento
FROM Eventos
WHERE id_evento = 4;
--Añadir disponibilidad para la prueba de registro de autoinscripcion
INSERT INTO VoluntarioDisponibilidad (id_voluntario, id_dia) VALUES (2, 7);

---PRUEBAS REQUERIMIENTO 4
---Insertar evento ya ocurrido
INSERT INTO Eventos (
    nombre, descripcion, fecha_inicio, fecha_fin, ubicacion, cupo_maximo, id_interes_requerido
)
VALUES (
    'Campaña de vacunación rural',
    'Apoyo logístico y de orientación para jornada médica',
    DATEADD(DAY, -4, GETDATE()),
    DATEADD(HOUR, -95, GETDATE()),
    'Centro Médico Santa Rosa',
    5,
    3
);

INSERT INTO VoluntarioIntereses (id_voluntario, id_interes)
VALUES (5, 3), (7, 3);

SELECT DATEPART(WEEKDAY, fecha_inicio) AS dia_evento
FROM Eventos
WHERE id_evento = 12;

INSERT INTO VoluntarioDisponibilidad (id_voluntario, id_dia)
VALUES (6, 1), (7, 1);

INSERT INTO Asignaciones (id_voluntario, id_evento, fecha_asignacion, estado_asignacion)
VALUES 
(5, 12, GETDATE(), 'Confirmado'),
(6, 12, GETDATE(), 'Confirmado'),
(7, 12, GETDATE(), 'Confirmado');

UPDATE Asignaciones SET asistio = 1, horas_trabajadas = 5 WHERE id_asignacion = 25;
UPDATE Asignaciones SET asistio = 1, horas_trabajadas = 3 WHERE id_asignacion = 26;
---Para mantener asistio y horas_trabajadas como NULL
UPDATE Asignaciones
SET asistio = NULL,
    horas_trabajadas = NULL
WHERE id_evento = 12 AND id_voluntario = 7;
USE [ManosAmigas]
GO

-- Limpiar tablas existentes (opcional, solo para pruebas)
-- DELETE FROM NotificacionVoluntarios
-- DELETE FROM Notificaciones
-- DELETE FROM Asignaciones
-- DELETE FROM VoluntarioIntereses
-- DELETE FROM VoluntarioDisponibilidad
-- DELETE FROM Usuarios
-- DELETE FROM Voluntarios
-- DELETE FROM Eventos
-- DELETE FROM Intereses
-- DELETE FROM DiasDisponibilidad
-- DELETE FROM Roles
-- DELETE FROM HistorialHoras
GO

-- Insertar roles del sistema
INSERT INTO [dbo].[Roles] ([nombre], [descripcion])
VALUES 
('Administrador', 'Acceso completo al sistema'),
('Coordinador', 'Gestiona eventos y voluntarios'),
('Voluntario', 'Usuario estándar voluntario')
GO

-- Insertar días de disponibilidad
INSERT INTO [dbo].[DiasDisponibilidad] ([nombre])
VALUES 
('Lunes'),
('Martes'),
('Miércoles'),
('Jueves'),
('Viernes'),
('Sábado'),
('Domingo')
GO

-- Insertar intereses/categorías de voluntariado
INSERT INTO [dbo].[Intereses] ([nombre])
VALUES 
('Educación'),
('Salud'),
('Medio Ambiente'),
('Construcción'),
('Alimentación'),
('Animales'),
('Adultos Mayores'),
('Niños'),
('Emergencias')
GO

-- Insertar voluntarios peruanos 
INSERT INTO [dbo].[Voluntarios] ([nombre], [email], [telefono])
VALUES
('María Fernández López', 'maria.fernandez@gmail.com', '+51987654321'),
('Carlos Gutiérrez Rojas', 'carlos.gutierrez@hotmail.com', '+51912345678'),
('Lucía Mendoza Vargas', 'lucia.mendoza@yahoo.com', '+51923456789'),
('Jorge Torres Sánchez', 'jorge.torres@gmail.com', '+51934567890'),
('Ana Castro Díaz', 'ana.castro@outlook.com', '+51945678901'),
('Pedro Ruiz Flores', 'pedro.ruiz@gmail.com', '+51956789012'),
('Sofía Herrera Quispe', 'sofia.herrera@hotmail.com', '+51967890123'),
('Miguel Chávez García', 'miguel.chavez@yahoo.com', '+51978901234'),
('Elena Paredes Mendoza', 'elena.paredes@gmail.com', '+51989012345'),
('Juan Ramos Salazar', 'juan.ramos@outlook.com', '+51990123456')
GO

-- Insertar disponibilidad de voluntarios
INSERT INTO [dbo].[VoluntarioDisponibilidad] ([id_voluntario], [id_dia], [turno])
VALUES
(1, 6, 'Mañana'),   -- María disponible sábados mañana
(1, 7, 'Completo'),  -- María disponible domingos completo
(2, 3, 'Tarde'),     -- Carlos disponible miércoles tarde
(2, 5, 'Completo'),  -- Carlos disponible viernes completo
(3, 2, 'Mañana'),    -- Lucía disponible martes mañana
(3, 4, 'Tarde'),     -- Lucía disponible jueves tarde
(4, 6, 'Completo'),  -- Jorge disponible sábados completo
(5, 1, 'Mañana'),    -- Ana disponible lunes mañana
(5, 3, 'Tarde'),     -- Ana disponible miércoles tarde
(6, 7, 'Completo'),  -- Pedro disponible domingos completo
(7, 4, 'Completo'),  -- Sofía disponible jueves completo
(8, 2, 'Tarde'),     -- Miguel disponible martes tarde
(8, 5, 'Mañana'),    -- Miguel disponible viernes mañana
(9, 6, 'Tarde'),     -- Elena disponible sábados tarde
(10, 1, 'Completo')  -- Juan disponible lunes completo
GO

-- Insertar intereses de voluntarios
INSERT INTO [dbo].[VoluntarioIntereses] ([id_voluntario], [id_interes])
VALUES
(1, 1), (1, 2), (1, 8),    -- María: Educación, Salud, Niños
(2, 3), (2, 4), (2, 9),     -- Carlos: Medio Ambiente, Construcción, Emergencias
(3, 1), (3, 8),             -- Lucía: Educación, Niños
(4, 2), (4, 7),             -- Jorge: Salud, Adultos Mayores
(5, 5), (5, 6),             -- Ana: Alimentación, Animales
(6, 3), (6, 4), (6, 9),     -- Pedro: Medio Ambiente, Construcción, Emergencias
(7, 1), (7, 5), (7, 8),     -- Sofía: Educación, Alimentación, Niños
(8, 2), (8, 7),             -- Miguel: Salud, Adultos Mayores
(9, 3), (9, 6),             -- Elena: Medio Ambiente, Animales
(10, 4), (10, 9)            -- Juan: Construcción, Emergencias
GO

-- Insertar eventos típicos de una ONG en Perú
INSERT INTO [dbo].[Eventos] ([nombre], [descripcion], [fecha_inicio], [fecha_fin], [ubicacion], [cupo_maximo], [id_interes_requerido])
VALUES
('Reforestación en Lomas de Lima', 'Plantación de árboles nativos en las Lomas de Lúcumo', '2025-07-12 08:00', '2025-07-12 13:00', 'Lomas de Lúcumo, Pachacamac', 5, 3),
('Taller de lectura para niños', 'Actividades de promoción de lectura en colegio de Villa El Salvador', '2025-07-19 09:00', '2025-07-19 12:00', 'Colegio Fe y Alegría 45, VES', 6, 1),
('Campaña médica en Carabayllo', 'Atención médica gratuita para adultos mayores', '2025-07-26 08:00', '2025-07-26 17:00', 'Local comunal de Carabayllo', 4, 2),
('Construcción de viviendas emergentes', 'Ayuda en construcción de viviendas para damnificados por lluvias', '2025-08-02 07:30', '2025-08-02 15:00', 'Asentamiento Humano Los Olivos', 5, 4),
('Reparto de alimentos en comedor popular', 'Apoyo en preparación y reparto de alimentos', '2025-07-15 10:00', '2025-07-15 14:00', 'Comedor María Auxiliadora, San Juan de Lurigancho', 3, 5),
('Rescate de animales en riesgo', 'Jornada de rescate y atención veterinaria para animales en abandono', '2025-08-09 09:00', '2025-08-09 16:00', 'Refugio Patitas Felices, Chorrillos', 4, 6),
('Acompañamiento a adultos mayores', 'Visita y actividades recreativas con adultos mayores', '2025-07-20 10:00', '2025-07-20 13:00', 'Hogar San Vicente de Paúl, Lima', 5, 7),
('Apoyo escolar en verano', 'Refuerzo escolar para niños de primaria', '2025-07-22 14:00', '2025-07-22 17:00', 'Biblioteca Municipal de Miraflores', 6, 8),
('Simulacro de emergencias', 'Capacitación y simulacro de sismo para comunidad', '2025-08-16 09:00', '2025-08-16 13:00', 'Parque Zonal Huáscar, Villa el Salvador', 8, 9)
GO

-- Insertar asignaciones de voluntarios a eventos
INSERT INTO [dbo].[Asignaciones] ([id_voluntario], [id_evento], [fecha_asignacion], [asistio], [horas_trabajadas])
VALUES
(2, 1, '2025-06-20 10:00', NULL, NULL),  -- Carlos en Reforestación
(6, 1, '2025-06-21 11:30', NULL, NULL),  -- Pedro en Reforestación
(9, 1, '2025-06-22 09:15', NULL, NULL),  -- Elena en Reforestación
(1, 2, '2025-06-18 14:20', NULL, NULL),   -- María en Taller de lectura
(3, 2, '2025-06-19 10:45', NULL, NULL),   -- Lucía en Taller de lectura
(7, 2, '2025-06-20 16:30', NULL, NULL),   -- Sofía en Taller de lectura
(4, 3, '2025-06-25 12:00', NULL, NULL),   -- Jorge en Campaña médica
(8, 3, '2025-06-26 09:45', NULL, NULL),   -- Miguel en Campaña médica
(10, 4, '2025-06-28 08:00', NULL, NULL),  -- Juan en Construcción
(5, 5, '2025-07-01 10:30', NULL, NULL),   -- Ana en Reparto de alimentos
(7, 5, '2025-07-02 11:15', NULL, NULL),   -- Sofía en Reparto de alimentos
(5, 6, '2025-07-10 09:00', NULL, NULL),   -- Ana en Rescate de animales
(9, 6, '2025-07-11 10:45', NULL, NULL),   -- Elena en Rescate de animales
(4, 7, '2025-07-05 14:30', NULL, NULL),   -- Jorge en Acompañamiento
(8, 7, '2025-07-06 11:20', NULL, NULL),   -- Miguel en Acompañamiento
(1, 8, '2025-07-08 13:15', NULL, NULL),   -- María en Apoyo escolar
(3, 8, '2025-07-09 10:00', NULL, NULL),   -- Lucía en Apoyo escolar
(7, 8, '2025-07-10 09:30', NULL, NULL),   -- Sofía en Apoyo escolar
(2, 9, '2025-07-15 08:45', NULL, NULL),   -- Carlos en Simulacro
(6, 9, '2025-07-16 10:15', NULL, NULL),   -- Pedro en Simulacro
(10, 9, '2025-07-17 11:00', NULL, NULL)   -- Juan en Simulacro
GO

-- Insertar usuarios del sistema
INSERT INTO [dbo].[Usuarios] ([id_voluntario], [email], [contrasena_hash], [id_rol], [fecha_registro], [ultimo_login], [activo])
VALUES
(NULL, 'admin@manosamigas.pe', CONVERT(VARBINARY(64), 'Admin123'), 1, '2025-01-10', '2025-06-27', 1),
(1, 'maria.fernandez@gmail.com', CONVERT(VARBINARY(64), 'Voluntario1'), 3, '2025-02-15', '2025-06-26', 1),
(2, 'carlos.gutierrez@hotmail.com', CONVERT(VARBINARY(64), 'Voluntario2'), 3, '2025-02-16', '2025-06-25', 1),
(3, 'lucia.mendoza@yahoo.com', CONVERT(VARBINARY(64), 'Voluntario3'), 3, '2025-02-17', '2025-06-24', 1),
(4, 'jorge.torres@gmail.com', CONVERT(VARBINARY(64), 'Voluntario4'), 2, '2025-02-18', '2025-06-23', 1),
(5, 'ana.castro@outlook.com', CONVERT(VARBINARY(64), 'Voluntario5'), 3, '2025-02-19', '2025-06-22', 1),
(6, 'pedro.ruiz@gmail.com', CONVERT(VARBINARY(64), 'Voluntario6'), 3, '2025-02-20', '2025-06-21', 1),
(7, 'sofia.herrera@hotmail.com', CONVERT(VARBINARY(64), 'Voluntario7'), 3, '2025-02-21', '2025-06-20', 1),
(8, 'miguel.chavez@yahoo.com', CONVERT(VARBINARY(64), 'Voluntario8'), 3, '2025-02-22', '2025-06-19', 1),
(9, 'elena.paredes@gmail.com', CONVERT(VARBINARY(64), 'Voluntario9'), 3, '2025-02-23', '2025-06-18', 1),
(10, 'juan.ramos@outlook.com', CONVERT(VARBINARY(64), 'Voluntario10'), 2, '2025-02-24', '2025-06-17', 1)
GO

-- Insertar notificaciones
INSERT INTO [dbo].[Notificaciones] ([id_evento], [asunto], [cuerpo], [fecha_programada], [fecha_envio], [estado])
VALUES
(1, 'Confirmación: Reforestación en Lomas de Lima', 'Estimado voluntario, confirmamos tu participación en la actividad de reforestación este sábado 12 de julio. Por favor llegar a las 7:45 am al punto de encuentro.', '2025-07-05 09:00', '2025-07-05 09:05', 'Enviado'),
(2, 'Recordatorio: Taller de lectura para niños', 'Hola voluntario, te recordamos el taller de lectura del próximo sábado 19 de julio. No olvides traer tu entusiasmo y libros para compartir.', '2025-07-12 10:00', '2025-07-12 10:02', 'Enviado'),
(3, 'Preparativos Campaña médica', 'Voluntarios de salud: Por favor revisar los materiales que necesitaremos para la campaña médica del 26 de julio. Adjuntamos lista de requerimientos.', '2025-07-15 15:00', NULL, 'Pendiente'),
(4, 'Inducción construcción de viviendas', 'Voluntarios asignados a construcción: Habrá una sesión informativa el jueves 30 de julio a las 6 pm sobre los protocolos de seguridad.', '2025-07-25 14:00', NULL, 'Pendiente')
GO

-- Insertar relación notificaciones-voluntarios
INSERT INTO [dbo].[NotificacionVoluntarios] ([id_notificacion], [id_voluntario], [enviado], [fecha_envio], [error])
VALUES
(1, 2, 1, '2025-07-05 09:05', NULL),
(1, 6, 1, '2025-07-05 09:05', NULL),
(1, 9, 1, '2025-07-05 09:05', NULL),
(2, 1, 1, '2025-07-12 10:02', NULL),
(2, 3, 1, '2025-07-12 10:02', NULL),
(2, 7, 1, '2025-07-12 10:02', NULL),
(3, 4, 0, NULL, NULL),
(3, 8, 0, NULL, NULL),
(4, 10, 0, NULL, NULL)
GO

-- Insertar historial de horas (ejemplo para algunas asignaciones completadas)
INSERT INTO [dbo].[HistorialHoras] ([id_asignacion], [horas_antes], [horas_despues], [fecha_cambio], [usuario_cambio])
VALUES
(1, 0, 5, '2025-07-12 18:00', 'admin@manosamigas.pe'),
(2, 0, 5, '2025-07-12 18:00', 'admin@manosamigas.pe'),
(3, 0, 5, '2025-07-12 18:00', 'admin@manosamigas.pe'),
(4, 0, 3, '2025-07-19 13:30', 'jorge.torres@gmail.com'),
(5, 0, 3, '2025-07-19 13:30', 'jorge.torres@gmail.com'),
(6, 0, 3, '2025-07-19 13:30', 'jorge.torres@gmail.com')
GO

-- Actualizar algunas asignaciones como completadas
UPDATE [dbo].[Asignaciones] 
SET [asistio] = 1, [horas_trabajadas] = 5 
WHERE [id_asignacion] IN (1, 2, 3)

UPDATE [dbo].[Asignaciones] 
SET [asistio] = 1, [horas_trabajadas] = 3 
WHERE [id_asignacion] IN (4, 5, 6)
GO

SELECT*FROM Notificaciones


