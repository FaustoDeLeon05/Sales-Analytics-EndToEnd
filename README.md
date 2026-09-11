# Sales Analytics — End-to-End Data Pipeline

Proyecto de portafolio orientado a **análisis e ingeniería de datos**, construido para demostrar un flujo completo desde la fuente de datos hasta un dashboard ejecutivo en Power BI.

El proyecto integra **Python, SQL Server y Power BI** en un proceso reproducible de extracción, transformación, validación, carga y análisis.

<p align="center">
  <img width="1917" height="1197" alt="Dashboard de Ventas y Gastos" src="https://github.com/user-attachments/assets/93bbf681-8d82-446c-a5a7-ce7f978b8b72" />
</p>

## 📌 Descripción del proyecto

El objetivo es transformar datos operativos de **ventas y gastos** en información estructurada y utilizable para análisis de negocio.

El flujo implementado es:

**Excel → Python ETL → SQL Server → Power BI**

El pipeline automatiza la lectura de los datos, aplica reglas de calidad, carga la información en SQL Server y deja los datos preparados para consultas analíticas y visualización.

## 🎯 Objetivos

- Automatizar la preparación y carga de datos.
- Aplicar validaciones de calidad antes de insertar información en la base de datos.
- Centralizar los datos en SQL Server.
- Crear consultas SQL orientadas al análisis comercial.
- Construir un dashboard interactivo para el seguimiento de ventas y gastos.
- Documentar un flujo End-to-End reproducible como proyecto de portafolio.

## 🛠️ Tecnologías utilizadas

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

## 🔄 Flujo de datos

### 1. Extract — Extracción

El pipeline obtiene la información desde el archivo Excel ubicado en `Data/Dataset - Prueba.xlsx`.

Las fuentes principales corresponden a los datos de **ventas** y **gastos**.

### 2. Transform & Validate — Transformación y validación

El script `Source/etl_pipeline.py` transforma los datos y ejecuta controles de calidad, incluyendo:

- Validación de columnas requeridas.
- Conversión y validación de fechas.
- Validación de campos numéricos.
- Detección de valores nulos críticos.
- Detección de registros duplicados.
- Validación de cantidades positivas.
- Validación de precios y gastos no negativos.
- Comprobación de la regla de negocio `Total Ventas = Cantidad vendida × Precio unitario`.

### 3. Load — Carga

Los datos validados se cargan en **SQL Server** utilizando SQLAlchemy y pyodbc.

El proceso trabaja con las tablas principales:

- `dbo.Fact_Ventas`
- `dbo.Dim_Gastos`

### 4. Analyze — Análisis

Los scripts T-SQL permiten analizar diferentes dimensiones del negocio, entre ellas:

- Ventas por país de destino.
- Productos con mayor facturación.
- Ranking de productos por categoría.
- Evolución mensual de ventas.
- Rendimiento por vendedor.
- Gastos por oficina y concepto.
- Ranking mensual de vendedores.

### 5. Visualize — Visualización

El resultado se utiliza en **Power BI** para construir un dashboard interactivo con indicadores y visualizaciones orientadas al análisis de ventas y gastos.

## 🗄️ Modelo y base de datos

La solución utiliza **SQL Server** como capa de almacenamiento y análisis intermedio.

La estructura SQL conserva las tablas utilizadas por el modelo actual del proyecto:

```text
GlobalSalesDB
│
├── Fact_Ventas
│   ├── Fecha
│   ├── País / destino
│   ├── Ciudad de envío
│   ├── Zona de seguimiento
│   ├── Vendedor
│   ├── Categoría de venta
│   ├── Artículo de venta
│   ├── Cantidad vendida
│   ├── Meta de cantidad
│   ├── Precio unitario
│   └── Total Ventas
│
└── Dim_Gastos
    ├── Fecha
    ├── Oficina
    ├── Concepto de gasto
    └── Total Gastos
```

## 📁 Estructura del repositorio

```text
Sales-Analytics-EndToEnd/
│
├── Data/
│   └── Dataset - Prueba.xlsx
│
├── Reports/
│   └── Dashboard.pbix
│
├── SQL/
│   ├── 01_create_tables.sql
│   ├── 02_load_validation.sql
│   └── 03_analysis_queries.sql
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

## ⚙️ Configuración y ejecución

### Requisitos

Antes de ejecutar el proyecto se requiere:

- Python 3.x
- SQL Server
- ODBC Driver para SQL Server
- Power BI Desktop para visualizar el dashboard

### 1. Clonar el repositorio

```bash
git clone https://github.com/FaustoDeLeon05/Sales-Analytics-EndToEnd.git
cd Sales-Analytics-EndToEnd
```

### 2. Crear un entorno virtual

```bash
python -m venv .venv
```

Activación en Windows:

```bash
.venv\Scripts\activate
```

### 3. Instalar dependencias

```bash
pip install -r requirements.txt
```

### 4. Configurar la conexión

Crear un archivo `.env` a partir de `.env.example` y configurar la instancia local de SQL Server.

Ejemplo:

```env
EXCEL_PATH=Data/Dataset - Prueba.xlsx
SQL_SERVER=YOUR_SQL_SERVER_INSTANCE
SQL_DATABASE=GlobalSalesDB
ODBC_DRIVER=ODBC Driver 17 for SQL Server
```

> El archivo `.env` no debe subirse al repositorio. Las credenciales y configuraciones locales deben mantenerse fuera del control de versiones.

### 5. Crear las tablas

Ejecutar en SQL Server Management Studio:

```text
SQL/01_create_tables.sql
```

### 6. Ejecutar el pipeline ETL

Desde la raíz del proyecto:

```bash
python Source/etl_pipeline.py
```

### 7. Validar los datos

Ejecutar:

```text
SQL/02_load_validation.sql
```

### 8. Ejecutar consultas analíticas

Ejecutar:

```text
SQL/03_analysis_queries.sql
```

### 9. Abrir el dashboard

Abrir `Reports/Dashboard.pbix` con Power BI Desktop y actualizar las fuentes de datos según la configuración local de SQL Server.

## 📊 Resultado

El proyecto transforma datos operativos de ventas y gastos en información estructurada para apoyar el seguimiento del desempeño comercial. El dashboard permite analizar la evolución de las ventas, el rendimiento de vendedores y productos, los resultados por mercado y el comportamiento de los gastos mediante filtros y slicers interactivos.

Desde una perspectiva de negocio, la solución facilita la identificación de tendencias, oportunidades y áreas que requieren atención, reduciendo la dependencia de análisis manuales y proporcionando una vista centralizada para la toma de decisiones.

## 🔐 Buenas prácticas aplicadas

- Variables de configuración separadas mediante `.env`.
- Exclusión de credenciales y archivos locales mediante `.gitignore`.
- Validaciones de calidad antes de la carga.
- Separación entre código Python, scripts SQL, datos y reportes.
- Uso de consultas SQL reutilizables para análisis.
- Estructura de repositorio orientada a reproducibilidad y mantenimiento.

## 🚀 Enfoque de portafolio

Este proyecto representa la primera pieza de una serie de proyectos **End-to-End** desarrollados para demostrar competencias prácticas en:

**Data Engineering · Data Analytics · SQL · Python · Power BI · ETL · Data Quality**

Los siguientes proyectos ampliarán el portafolio hacia análisis deportivos, un proyecto de analítica para un **BPO / Contact Center** y desarrollo de un sitio profesional mediante GitHub Pages.

## 👤 Autor

**Fausto Xavier De León Pichardo**

Estudiante de Ingeniería en Sistemas de Computación, orientado al desarrollo de proyectos en **Data Analytics, Data Engineering y Business Intelligence**.

**LinkedIn: https://www.linkedin.com/in/fausto-xavier-de-leon-pichardo-bi2026/**
