# Proyecto 1 - Sales Analytics End-to-End
Pipeline completo de análisis de ventas que integra **Python, SQL Server y Power BI** para transformar datos de Excel en un modelo analítico y un dashboard interactivo orientado a la toma de decisiones.

## 📊 Dashboard

<p align="center">
  <img width="1917" height="1197" alt="Dashboard de Ventas y Gastos" src="https://github.com/user-attachments/assets/93bbf681-8d82-446c-a5a7-ce7f978b8b72" />
</p>

### Vistas del reporte

El dashboard está compuesto por **6 páginas**, incluyendo una página dedicada a tooltips:

| Página | Propósito |
|---|---|
| **Executive Overview** | Resumen ejecutivo de ventas, unidades, cumplimiento de metas y variación. |
| **Sales Performance** | Evolución de ventas, categorías, artículos y mercados. |
| **Expenses Analysis** | Análisis de gastos, utilidad, margen y relación ventas vs. gastos. |
| **Geographic Analysis** | Análisis geográfico del desempeño comercial. |
| **Seller Analysis** | Evaluación del rendimiento de vendedores y análisis individual mediante drillthrough. |
| **Tooltip 1** | Vista auxiliar para mostrar información contextual al interactuar con los visuales. |

El reporte también incorpora **navegación entre páginas mediante bookmarks**, tooltips personalizados y seguridad a nivel de filas (**RLS**).

## 🔄 Arquitectura del proyecto

```text
Excel
  ↓
Extract — Python / Pandas
  ↓
Transform — limpieza y tipificación
  ↓
Validate — reglas de calidad de datos
  ↓
Load — SQL Server
  ↓
Model — esquema de estrella en Power BI
  ↓
Analyze — DAX + visualizaciones
  ↓
Dashboard — Business Intelligence
```

## 🛠️ Tecnologías

- **Python:** Pandas, SQLAlchemy, pyodbc
- **SQL Server:** T-SQL, modelado relacional y consultas analíticas
- **Power BI:** Power Query, DAX, modelo semántico, esquema de estrella y visualización
- **Git/GitHub:** control de versiones y documentación del proyecto

## 📁 Estructura del repositorio

```text
Sales-Analytics-EndToEnd/
│
├── Data/
│   └── Dataset - Prueba.xlsx
│
├── Reports/
│   └── Dashboard Sales.pbix
│
├── SQL/
│   ├── 01_create_tables.sql
│   ├── 02_load_validation.sql
│   ├── 03_analysis_queries.sql
│   └── 04_backup.sql
│
├── Source/
│   └── etl_pipeline.py
│
├── .env.example
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```

## ⚙️ Proceso ETL

### 1. Extract

El pipeline obtiene los datos desde un archivo Excel con dos hojas:

- `Ventas`
- `Gastos`

La ruta del archivo se configura mediante una variable de entorno, evitando depender de una ruta local específica.

### 2. Transform

Python/Pandas realiza la normalización de tipos y prepara los datos para su carga, incluyendo:

- Conversión de fechas.
- Conversión de columnas numéricas.
- Validación de columnas requeridas.
- Validación de valores nulos.
- Detección de duplicados.
- Validación de cantidades y precios.
- Comprobación de la consistencia entre cantidad, precio unitario y total de ventas.

### 3. Validate

El pipeline detiene la carga cuando los datos no cumplen las reglas de calidad definidas. Esto evita cargar información inconsistente en SQL Server.

### 4. Load

Los datasets validados se cargan en `GlobalSalesDB` mediante **SQLAlchemy + pyodbc**.

Tablas utilizadas por el modelo:

- `Fact_Ventas`
- `Dim_Gastos`

> `Dim_Gastos` se mantiene con ese nombre a nivel físico para conservar la compatibilidad con el modelo existente de Power BI.

## 🗄️ Capa SQL

Los scripts están separados por responsabilidad:

- **01_create_tables.sql** — creación de las tablas necesarias.
- **02_load_validation.sql** — consultas de validación de la carga.
- **03_analysis_queries.sql** — consultas analíticas mediante T-SQL.
- **04_backup.sql** — respaldo de la base de datos.

Las consultas analíticas incluyen agregaciones, CTEs y funciones de ventana para explorar ventas y desempeño comercial.

## 📐 Modelo semántico en Power BI

El modelo utiliza una estructura orientada a análisis con una dimensión de fechas compartida:

```text
                 Dim_Fecha
                    │
          ┌─────────┴─────────┐
          │                   │
     Fact_Ventas          Fact_Gastos
          │
          │
       Usuarios
```

Elementos principales del modelo:

- `Dim_Fecha` como dimensión de fechas central.
- `Fact_Ventas` para las transacciones comerciales.
- `Fact_Gastos` como nombre utilizado dentro del modelo de Power BI para la tabla física `Dim_Gastos`.
- `Usuarios` para el análisis y control de acceso por vendedor/supervisor.
- Tabla `_Measures` para centralizar las medidas DAX.

## 📈 Métricas principales

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

## 🔐 Seguridad y navegación

El reporte incorpora funcionalidades de Power BI orientadas a una experiencia más cercana a un entorno empresarial:

- **RLS (Row-Level Security):** acceso dinámico según usuario, vendedor, supervisor y directora de ventas.
- **Bookmarks:** navegación entre las diferentes vistas del dashboard.
- **Drillthrough:** análisis detallado por vendedor.
- **Tooltips personalizados:** información contextual adicional en los visuales.
- **Modelo de fechas compartido:** evita depender de tablas de fecha automáticas independientes.

**OLS (Object-Level Security) no forma parte del alcance de este proyecto**, ya que el modelo no requiere restringir objetos individuales del modelo semántico.

## 🚀 Configuración

El pipeline utiliza variables de entorno para la configuración de SQL Server.

1. Instalar las dependencias:

```bash
pip install -r requirements.txt
```

2. Crear las variables de entorno tomando `.env.example` como referencia:

```text
EXCEL_PATH=...
SQL_SERVER=...
SQL_DATABASE=GlobalSalesDB
ODBC_DRIVER=ODBC Driver 17 for SQL Server
```

3. Ejecutar el pipeline:

```bash
python Source/etl_pipeline.py
```

> El proyecto está preparado para un entorno local de SQL Server y requiere un driver ODBC compatible con SQL Server.

## 🎯 Objetivo del proyecto

El objetivo es demostrar un flujo **End-to-End de Data Analytics / Business Intelligence**, cubriendo desde la ingesta y validación de datos hasta el modelado, análisis y visualización final.

El proyecto busca demostrar competencias prácticas en:

**ETL → Data Quality → SQL → Data Modeling → DAX → Power BI → BI & Decision Support**

## 👤 Autor

**Fausto X. De León Pichardo**

Data Analytics | Business Intelligence | Power BI

- GitHub: [FaustoDeLeon05](https://github.com/FaustoDeLeon05)
- LinkedIn: [Fausto X. De León Pichardo](https://www.linkedin.com/in/fausto-xavier-de-leon-pichardo-b42874269/)

## 📄 Licencia

Este proyecto está disponible bajo la licencia **MIT**.
