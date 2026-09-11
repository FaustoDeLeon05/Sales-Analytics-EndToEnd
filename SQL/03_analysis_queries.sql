USE GlobalSalesDB;
GO

/* ==========================================================
   ANALYTICAL QUERIES
   ========================================================== */

-- 1. Revenue and units by destination country.
SELECT
    [Pais Destino],
    SUM([Cantidad vendida]) AS Total_Unidades_Vendidas,
    SUM([Total Ventas]) AS Ingresos_Totales
FROM dbo.Fact_Ventas
GROUP BY [Pais Destino]
ORDER BY Ingresos_Totales DESC;
GO

-- 2. Top 10 products by revenue.
SELECT TOP 10
    [Categoria Venta],
    [Articulo Venta],
    SUM([Cantidad vendida]) AS Unidades_Totales,
    SUM([Total Ventas]) AS Ingreso_Total
FROM dbo.Fact_Ventas
GROUP BY [Categoria Venta], [Articulo Venta]
ORDER BY Ingreso_Total DESC;
GO

-- 3. Revenue ranking within each sales category.
WITH ProductSales AS
(
    SELECT
        [Categoria Venta],
        [Articulo Venta],
        SUM([Total Ventas]) AS Ingreso_Total
    FROM dbo.Fact_Ventas
    GROUP BY [Categoria Venta], [Articulo Venta]
),
RankedProducts AS
(
    SELECT
        [Categoria Venta],
        [Articulo Venta],
        Ingreso_Total,
        DENSE_RANK() OVER
        (
            PARTITION BY [Categoria Venta]
            ORDER BY Ingreso_Total DESC
        ) AS Ranking_Categoria
    FROM ProductSales
)
SELECT
    [Categoria Venta],
    [Articulo Venta],
    Ingreso_Total,
    Ranking_Categoria
FROM RankedProducts
WHERE Ranking_Categoria <= 3
ORDER BY [Categoria Venta], Ranking_Categoria;
GO

-- 4. Monthly sales trend.
SELECT
    YEAR([Fecha]) AS Anio,
    MONTH([Fecha]) AS Mes,
    SUM([Cantidad vendida]) AS Unidades_Vendidas,
    SUM([Total Ventas]) AS Ingresos_Totales
FROM dbo.Fact_Ventas
GROUP BY YEAR([Fecha]), MONTH([Fecha])
ORDER BY Anio, Mes;
GO

-- 5. Sales performance by seller.
SELECT
    [Vendedor],
    COUNT(*) AS Transacciones,
    SUM([Cantidad vendida]) AS Unidades_Vendidas,
    SUM([Total Ventas]) AS Ingresos_Totales,
    AVG([Total Ventas]) AS Ticket_Promedio
FROM dbo.Fact_Ventas
GROUP BY [Vendedor]
ORDER BY Ingresos_Totales DESC;
GO

-- 6. Operating expenses by office and concept.
SELECT
    [Oficina],
    [Concepto Gasto],
    SUM([Total Gastos]) AS Gasto_Acumulado
FROM dbo.Dim_Gastos
GROUP BY [Oficina], [Concepto Gasto]
ORDER BY Gasto_Acumulado DESC;
GO

-- 7. Monthly revenue ranking by seller using a window function.
WITH MonthlySellerSales AS
(
    SELECT
        YEAR([Fecha]) AS Anio,
        MONTH([Fecha]) AS Mes,
        [Vendedor],
        SUM([Total Ventas]) AS Ingresos_Totales
    FROM dbo.Fact_Ventas
    GROUP BY YEAR([Fecha]), MONTH([Fecha]), [Vendedor]
)
SELECT
    Anio,
    Mes,
    [Vendedor],
    Ingresos_Totales,
    RANK() OVER
    (
        PARTITION BY Anio, Mes
        ORDER BY Ingresos_Totales DESC
    ) AS Ranking_Mensual
FROM MonthlySellerSales
ORDER BY Anio, Mes, Ranking_Mensual;
GO
