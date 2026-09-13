# Proyecto 1 - Sales Analytics — End-to-End Data Pipeline
Pipeline completo de análisis de ventas que integra **Python, SQL Server y Power BI** para transformar datos de Excel en un modelo analítico y un dashboard interactivo orientado a la toma de decisiones.

Proyecto de portafolio orientado a **análisis e ingeniería de datos**, construido para demostrar un flujo completo desde la fuente de datos hasta un dashboard ejecutivo en Power BI.

El proyecto integra **Python, SQL Server y Power BI** en un proceso reproducible de extracción, transformación, validación, carga y análisis.

<p align="center">
  <img width="1917" height="1197" alt="Dashboard de Ventas y Gastos" src="" />
</p>

## Descripción del proyecto

El objetivo es transformar datos operativos de **ventas y gastos** en información estructurada y utilizable para análisis de negocio.

El flujo implementado es:

**Excel → Python ETL → SQL Server → Power BI**
### Vistas del reporte

El pipeline automatiza la lectura de los datos, aplica reglas de calidad, carga la información en SQL Server y deja los datos preparados para consultas analíticas y visualización.
El dashboard está compuesto por **6 páginas**, incluyendo una página dedicada a tooltips.

## Objetivos

- Automatizar la preparación y carga de datos.
- Variables de configuración separadas mediante `.env`.
- Exclusión de credenciales y archivos locales mediante `.gitignore`.
- Validaciones de calidad antes de la carga.
- Separación entre código Python, scripts SQL, datos y reportes.
- Uso de consultas SQL reutilizables para análisis.
- Construir un dashboard interactivo para el seguimiento de ventas y gastos.
- Estructura de repositorio orientada a reproducibilidad y mantenimiento.
El objetivo es demostrar un flujo **End-to-End de Data Analytics / Business Intelligence**, cubriendo desde la ingesta y validación de datos hasta el modelado, análisis y visualización final.


## Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| **Python** | Automatización del pipeline ETL |
| **Pandas** | Lectura, transformación y validación de datos |
| **SQLAlchemy** | Conexión entre Python y SQL Server |
| **pyodbc** | Driver de conexión con SQL Server |
| **SQL Server** | Almacenamiento y consulta de datos |
| **T-SQL** | Creación, validación y análisis de datos |
| **Power BI** | Modelado, KPIs y visualización |
| **Excel** | Fuente de datos del proceso |

## Flujo de datos

### 1. Extract — Extracción

El pipeline obtiene la información desde el archivo Excel ubicado en `Data/Dataset - Prueba.xlsx`.

Las fuentes principales corresponden a los datos de **ventas** y **gastos**.

### 2. Transform & Validate — Transformación y validación

El script `Source/etl_pipeline.py` transforma los datos y ejecuta controles de calidad.

### 3. Load — Carga

Los datos validados se cargan en **SQL Server** utilizando SQLAlchemy y pyodbc.
El reporte también incorpora **navegación entre páginas mediante bookmarks**, tooltips personalizados y seguridad a nivel de filas (**RLS**).

El proceso trabaja con las tablas principales:

- `dbo.Fact_Ventas`
- `dbo.Fact_Gastos`

### 4. Analyze — Análisis

Los scripts T-SQL permiten analizar diferentes dimensiones del negocio.

### 5. Visualize — Visualización

El resultado se utiliza en **Power BI** para construir un dashboard interactivo con indicadores y visualizaciones orientadas al análisis de ventas y gastos.

## Modelo y base de datos

La solución utiliza **SQL Server** como capa de almacenamiento y análisis intermedio. La estructura SQL conserva las tablas utilizadas por el modelo actual del proyecto:

##  Tecnologías

- **Python:** Pandas, SQLAlchemy, pyodbc
- **SQL Server:** T-SQL, modelado relacional y consultas analíticas
- **Power BI:** Power Query, DAX, modelo semántico, esquema de estrella y visualización
- **Git/GitHub:** control de versiones y documentación del proyecto

## Capa SQL
Los scripts están separados por responsabilidad:

- **01_create_tables.sql** — creación de las tablas necesarias.
- **02_load_validation.sql** — consultas de validación de la carga.
- **03_analysis_queries.sql** — consultas analíticas mediante T-SQL.
Las consultas analíticas incluyen agregaciones, CTEs y funciones de ventana para explorar ventas y desempeño comercial.

### Modelo semántico en Power BI

El modelo utiliza una estructura orientada a análisis con una dimensión de fechas compartida:

```text
SQL/01_create_tables.sql
                 Dim_Fecha
                    │
          ┌─────────┴─────────┐
          │                   │
     Fact_Ventas          Fact_Gastos
          │
          │
       Usuarios
```

### Elementos del reporte
Elementos principales del modelo:

Desde la raíz del proyecto:
- `Dim_Fecha` como dimensión de fechas central.
- `Fact_Ventas` para las transacciones comerciales.
- `Fact_Gastos` como nombre utilizado dentro del modelo de Power BI para la tabla física `Dim_Gastos`.
- `Usuarios` para el análisis y control de acceso por vendedor/supervisor.
- Tabla `_Measures` para centralizar las medidas DAX.

## Métricas principales

### Medidas
Entre las medidas implementadas se encuentran:

- Ventas Totales
- Unidades Vendidas
- Meta de Unidades
- Cumplimiento de Meta
- Brecha de Meta
- Ventas del Período Anterior
- Variación de Ventas
- Gastos Totales
- Utilidad
- Margen
- % Gastos sobre Ventas
- Precio Promedio
- Venta Promedio por Vendedor
- Total de Vendedores
- Top Vendedor

## Seguridad y navegación

- **RLS (Row-Level Security):** acceso dinámico según usuario, vendedor, supervisor y directora de ventas.
- **Bookmarks:** navegación entre las diferentes vistas del dashboard.
- **Drillthrough:** análisis detallado por vendedor.
- **Tooltips personalizados:** información contextual adicional en los visuales.
- **Modelo de fechas compartido:** evita depender de tablas de fecha automáticas independientes.

## Resultado

Desde una perspectiva de negocio, la solución facilita la identificación de tendencias, oportunidades y áreas que requieren atención, reduciendo la dependencia de análisis manuales y proporcionando una vista centralizada para la toma de decisiones.
El proyecto está preparado para un entorno local de SQL Server y requiere un driver ODBC compatible con SQL Server.

## Enfoque de portafolio
El proyecto busca demostrar competencias prácticas en:
**ETL → Data Quality → SQL → Data Modeling → DAX → Power BI → BI & Decision Support**

## Autor
**Fausto Xavier De León Pichardo**
**Data Engineering · Data Analytics · SQL · Python · Power BI · ETL · Data Quality**
Estudiante de Ingeniería en Sistemas de Computación, orientado al desarrollo de proyectos en **Data Analytics, Data Engineering y Business Intelligence**.

- GitHub: [FaustoDeLeon05](https://github.com/FaustoDeLeon05)
- LinkedIn: [Fausto X. De León Pichardo](https://www.linkedin.com/in/fausto-xavier-de-leon-pichardo-bi2026/)

## Licencia
Este proyecto está disponible bajo la licencia **MIT**.
