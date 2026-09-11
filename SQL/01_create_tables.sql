USE GlobalSalesDB;
GO

/*
    Project: Sales Analytics End-to-End
    Purpose: Controlled relational schema for the ETL pipeline.

    The current Power BI model uses the existing table names:
      - Fact_Ventas
      - Dim_Gastos

    Dim_Gastos is intentionally preserved in this first refactor to avoid
    breaking the existing Power BI model. The fact/dimension naming can be
    migrated after the semantic model is audited.
*/

IF OBJECT_ID('dbo.Fact_Ventas', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Fact_Ventas
    (
        [Fecha] DATE NOT NULL,
        [Pais Destino] NVARCHAR(100) NOT NULL,
        [Ciudad de envio] NVARCHAR(100) NOT NULL,
        [Zona seguimiento] NVARCHAR(150) NULL,
        [latitud] DECIMAL(10, 6) NULL,
        [longitud] DECIMAL(10, 6) NULL,
        [Vendedor] NVARCHAR(100) NOT NULL,
        [Categoria Venta] NVARCHAR(100) NOT NULL,
        [Articulo Venta] NVARCHAR(150) NOT NULL,
        [Cantidad vendida] INT NOT NULL,
        [Meta Cantidad] INT NULL,
        [Precio unitario] DECIMAL(18, 2) NOT NULL,
        [Total Ventas] DECIMAL(18, 2) NOT NULL
    );
END;
GO

IF OBJECT_ID('dbo.Dim_Gastos', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Dim_Gastos
    (
        [Fecha] DATE NOT NULL,
        [Oficina] NVARCHAR(100) NOT NULL,
        [Concepto Gasto] NVARCHAR(150) NOT NULL,
        [Total Gastos] DECIMAL(18, 2) NOT NULL
    );
END;
GO

-- Basic indexes used by the analytical queries.
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Fact_Ventas_Fecha'
      AND object_id = OBJECT_ID('dbo.Fact_Ventas')
)
BEGIN
    CREATE INDEX IX_Fact_Ventas_Fecha
        ON dbo.Fact_Ventas ([Fecha]);
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Dim_Gastos_Fecha'
      AND object_id = OBJECT_ID('dbo.Dim_Gastos')
)
BEGIN
    CREATE INDEX IX_Dim_Gastos_Fecha
        ON dbo.Dim_Gastos ([Fecha]);
END;
GO



/*
USE master;
GO


    Optional local backup.
    Update the destination path for the SQL Server environment where the
    backup is executed. This script is intentionally separate from analysis.


BACKUP DATABASE GlobalSalesDB
TO DISK = 'C:\SQL Backups\GlobalSalesDB.bak'
WITH FORMAT;
GO
*/
