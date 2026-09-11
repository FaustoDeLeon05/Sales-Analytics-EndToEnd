USE GlobalSalesDB;
GO

/*
    Data-quality checks after ETL load.
    These checks are intentionally read-only.
*/

-- Row counts
SELECT 'Fact_Ventas' AS Tabla, COUNT(*) AS Filas
FROM dbo.Fact_Ventas
UNION ALL
SELECT 'Dim_Gastos', COUNT(*)
FROM dbo.Dim_Gastos;
GO

-- Null checks in critical sales columns
SELECT
    SUM(CASE WHEN [Fecha] IS NULL THEN 1 ELSE 0 END) AS Fecha_Nulos,
    SUM(CASE WHEN [Pais Destino] IS NULL THEN 1 ELSE 0 END) AS Pais_Nulos,
    SUM(CASE WHEN [Vendedor] IS NULL THEN 1 ELSE 0 END) AS Vendedor_Nulos,
    SUM(CASE WHEN [Cantidad vendida] IS NULL THEN 1 ELSE 0 END) AS Cantidad_Nulos,
    SUM(CASE WHEN [Precio unitario] IS NULL THEN 1 ELSE 0 END) AS Precio_Nulos,
    SUM(CASE WHEN [Total Ventas] IS NULL THEN 1 ELSE 0 END) AS Total_Nulos
FROM dbo.Fact_Ventas;
GO

-- Business-rule validation: sales total must equal quantity * unit price.
SELECT
    COUNT(*) AS Filas_Inconsistentes
FROM dbo.Fact_Ventas
WHERE ROUND([Cantidad vendida] * [Precio unitario], 2)
      <> ROUND([Total Ventas], 2);
GO

-- Invalid numeric values
SELECT
    SUM(CASE WHEN [Cantidad vendida] <= 0 THEN 1 ELSE 0 END) AS Cantidades_Invalidas,
    SUM(CASE WHEN [Precio unitario] < 0 THEN 1 ELSE 0 END) AS Precios_Invalidos
FROM dbo.Fact_Ventas;
GO

SELECT
    SUM(CASE WHEN [Total Gastos] < 0 THEN 1 ELSE 0 END) AS Gastos_Invalidos
FROM dbo.Dim_Gastos;
GO
