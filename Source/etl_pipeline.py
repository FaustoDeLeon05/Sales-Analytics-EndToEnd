"""End-to-end ETL pipeline for the GlobalSalesDB project.

Flow: Extract -> Transform -> Validate -> Load.
Configuration is supplied through environment variables so the project does
not depend on a specific local Windows path or SQL Server hostname.
"""

from __future__ import annotations

import os
from pathlib import Path

import pandas as pd
import sqlalchemy as sa
from sqlalchemy import text


PROJECT_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_EXCEL_PATH = PROJECT_ROOT / "Data" / "Dataset - Prueba.xlsx"

SALES_REQUIRED_COLUMNS = [
    "Fecha",
    "Pais Destino",
    "Ciudad de envio",
    "Zona seguimiento",
    "latitud",
    "longitud",
    "Vendedor",
    "Categoria Venta",
    "Articulo Venta",
    "Cantidad vendida",
    "Meta Cantidad",
    "Precio unitario",
    "Total Ventas",
]

EXPENSE_REQUIRED_COLUMNS = [
    "Fecha",
    "Oficina",
    "Concepto Gasto",
    "Total Gastos",
]


class DataQualityError(ValueError):
    """Raised when source data does not meet the pipeline quality rules."""


def get_config() -> dict[str, str | Path]:
    """Read runtime configuration from environment variables."""
    return {
        "excel_path": Path(os.getenv("EXCEL_PATH", DEFAULT_EXCEL_PATH)),
        "sql_server": os.getenv("SQL_SERVER"),
        "sql_database": os.getenv("SQL_DATABASE", "GlobalSalesDB"),
        "odbc_driver": os.getenv("ODBC_DRIVER", "ODBC Driver 17 for SQL Server"),
    }


def build_engine(config: dict[str, str | Path]) -> sa.Engine:
    """Build a SQL Server engine using Windows authentication."""
    server = config["sql_server"]
    if not server:
        raise RuntimeError(
            "SQL_SERVER no está configurado. Define la variable de entorno "
            "SQL_SERVER con el nombre de tu instancia de SQL Server."
        )

    connection_url = sa.URL.create(
        "mssql+pyodbc",
        host=str(server),
        database=str(config["sql_database"]),
        query={
            "driver": str(config["odbc_driver"]),
            "trusted_connection": "yes",
        },
    )
    return sa.create_engine(connection_url, future=True)


def require_columns(df: pd.DataFrame, required: list[str], dataset_name: str) -> None:
    """Ensure the source contains every required column."""
    missing = sorted(set(required) - set(df.columns))
    if missing:
        raise DataQualityError(
            f"{dataset_name}: faltan columnas requeridas: {', '.join(missing)}"
        )


def transform_sales(df: pd.DataFrame) -> pd.DataFrame:
    """Normalize and validate the sales dataset."""
    df = df.copy()
    require_columns(df, SALES_REQUIRED_COLUMNS, "Ventas")

    df["Fecha"] = pd.to_datetime(df["Fecha"], errors="coerce")
    numeric_columns = [
        "latitud",
        "longitud",
        "Cantidad vendida",
        "Meta Cantidad",
        "Precio unitario",
        "Total Ventas",
    ]
    for column in numeric_columns:
        df[column] = pd.to_numeric(df[column], errors="coerce")

    required_values = [
        "Fecha",
        "Pais Destino",
        "Ciudad de envio",
        "Vendedor",
        "Categoria Venta",
        "Articulo Venta",
        "Cantidad vendida",
        "Precio unitario",
        "Total Ventas",
    ]
    null_counts = df[required_values].isna().sum()
    null_errors = null_counts[null_counts > 0]
    if not null_errors.empty:
        raise DataQualityError(f"Ventas: valores nulos detectados: {null_errors.to_dict()}")

    if df.duplicated().any():
        duplicates = int(df.duplicated().sum())
        raise DataQualityError(f"Ventas: se detectaron {duplicates} filas duplicadas.")

    if (df["Cantidad vendida"] <= 0).any():
        raise DataQualityError("Ventas: 'Cantidad vendida' debe ser mayor que 0.")

    if (df["Precio unitario"] < 0).any():
        raise DataQualityError("Ventas: 'Precio unitario' no puede ser negativo.")

    expected_total = df["Cantidad vendida"] * df["Precio unitario"]
    total_mismatch = ~expected_total.round(2).eq(df["Total Ventas"].round(2))
    if total_mismatch.any():
        raise DataQualityError(
            f"Ventas: {int(total_mismatch.sum())} filas no cumplen "
            "Total Ventas = Cantidad vendida * Precio unitario."
        )

    return df


def transform_expenses(df: pd.DataFrame) -> pd.DataFrame:
    """Normalize and validate the expenses dataset."""
    df = df.copy()
    require_columns(df, EXPENSE_REQUIRED_COLUMNS, "Gastos")

    df["Fecha"] = pd.to_datetime(df["Fecha"], errors="coerce")
    df["Total Gastos"] = pd.to_numeric(df["Total Gastos"], errors="coerce")

    required_values = ["Fecha", "Oficina", "Concepto Gasto", "Total Gastos"]
    null_counts = df[required_values].isna().sum()
    null_errors = null_counts[null_counts > 0]
    if not null_errors.empty:
        raise DataQualityError(f"Gastos: valores nulos detectados: {null_errors.to_dict()}")

    if df.duplicated().any():
        duplicates = int(df.duplicated().sum())
        raise DataQualityError(f"Gastos: se detectaron {duplicates} filas duplicadas.")

    if (df["Total Gastos"] < 0).any():
        raise DataQualityError("Gastos: 'Total Gastos' no puede ser negativo.")

    return df


def load_dataframe(
    df: pd.DataFrame,
    table_name: str,
    engine: sa.Engine,
) -> int:
    """Replace table data without dropping the controlled SQL schema."""
    with engine.begin() as connection:
        connection.execute(text(f"TRUNCATE TABLE dbo.[{table_name}]"))
        df.to_sql(
            table_name,
            con=connection,
            schema="dbo",
            if_exists="append",
            index=False,
            chunksize=500,
            method="multi",
        )
    return len(df)


def main() -> None:
    config = get_config()
    excel_path = Path(config["excel_path"])

    if not excel_path.exists():
        raise FileNotFoundError(f"No se encontró el archivo Excel: {excel_path}")

    print("[1/4] Extract: leyendo Excel...")
    sales = pd.read_excel(excel_path, sheet_name="Ventas")
    expenses = pd.read_excel(excel_path, sheet_name="Gastos")
    print(f"    Ventas: {len(sales):,} filas | Gastos: {len(expenses):,} filas")

    print("[2/4] Transform: normalizando tipos y reglas de negocio...")
    sales = transform_sales(sales)
    expenses = transform_expenses(expenses)

    print("[3/4] Validate: validaciones de calidad completadas correctamente.")
    print(f"    Ventas: {sales.shape[0]:,} filas x {sales.shape[1]} columnas")
    print(f"    Gastos: {expenses.shape[0]:,} filas x {expenses.shape[1]} columnas")

    print("[4/4] Load: cargando SQL Server...")
    engine = build_engine(config)
    try:
        loaded_sales = load_dataframe(sales, "Fact_Ventas", engine)
        loaded_expenses = load_dataframe(expenses, "Dim_Gastos", engine)
    finally:
        engine.dispose()

    print("ETL completado correctamente.")
    print(f"    Fact_Ventas: {loaded_sales:,} filas cargadas")
    print(f"    Dim_Gastos: {loaded_expenses:,} filas cargadas")


if __name__ == "__main__":
    main()
