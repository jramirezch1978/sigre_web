#!/usr/bin/env python3
"""Genera seed config.configuracion desde RRHHPARAM, RRHHPARAM_CCONCEP y UTLPARAM.json."""
import json
from decimal import Decimal
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "data"
SEED = Path(__file__).resolve().parent.parent / "ddl" / "seed"

SKIP_COLUMNS = {"RECKEY", "FLAG_REPLICACION"}


def sql_str(value):
    if value is None:
        return "NULL"
    text = str(value).strip()
    if not text:
        return "NULL"
    return "'" + text.replace("'", "''") + "'"


def infer_data_type(value):
    if value is None:
        return "TEXT"
    if isinstance(value, bool):
        return "BOOLEAN"
    if isinstance(value, int):
        return "INTEGER"
    if isinstance(value, float):
        return "DECIMAL"
    if isinstance(value, str):
        stripped = value.strip()
        if not stripped:
            return "TEXT"
        try:
            int(stripped)
            return "INTEGER"
        except ValueError:
            pass
        try:
            Decimal(stripped)
            return "DECIMAL"
        except Exception:
            return "TEXT"
    return "TEXT"


def value_columns(data_type, value):
    text_val = "NULL"
    int_val = "NULL"
    dec_val = "NULL"
    bool_val = "NULL"

    if value is None:
        return text_val, int_val, dec_val, bool_val

    if data_type == "BOOLEAN":
        bool_val = "TRUE" if value else "FALSE"
    elif data_type == "INTEGER":
        int_val = str(int(value))
    elif data_type == "DECIMAL":
        dec_val = str(value)
    else:
        text_val = sql_str(value)

    return text_val, int_val, dec_val, bool_val


def build_rows(source, payload):
    rows = []
    for column, value in payload.items():
        if column.upper() in SKIP_COLUMNS:
            continue
        data_type = infer_data_type(value)
        text_val, int_val, dec_val, bool_val = value_columns(data_type, value)
        rows.append(
            f"({sql_str(source)}, {sql_str(column.upper())}, {sql_str(data_type)}, "
            f"{text_val}, {int_val}, {dec_val}, {bool_val}, TRUE, TRUE)"
        )
    return rows


def main():
    with open(DATA / "RRHHPARAM.json", encoding="utf-8") as handle:
        rrhhparam = json.load(handle)["RRHHPARAM"][0]
    with open(DATA / "RRHHPARAM_CCONCEP.json", encoding="utf-8") as handle:
        rrhhparam_cconcep = json.load(handle)["RRHHPARAM_CCONCEP"][0]
    with open(DATA / "UTLPARAM.json", encoding="utf-8") as handle:
        utlparam = json.load(handle)["UTLPARAM"][0]

    rows = (
        build_rows("RRHHPARAM", rrhhparam)
        + build_rows("RRHHPARAM_CCONCEP", rrhhparam_cconcep)
        + build_rows("UTLPARAM", utlparam)
    )

    lines = [
        "-- Parámetros RRHH SIGRE consolidados en config.configuracion",
        "-- Fuentes: RRHHPARAM.json + RRHHPARAM_CCONCEP.json + UTLPARAM.json (reckey=1)",
        f"-- Registros: {len(rows)}",
        "BEGIN;",
        "INSERT INTO config.configuracion (",
        "    modulo, parametro, tipo_dato, valor_texto, valor_entero, valor_decimal, valor_bool, editable, activo",
        ")",
        "VALUES",
        ",\n".join(rows),
        "ON CONFLICT (modulo, parametro) DO UPDATE SET",
        "    tipo_dato = EXCLUDED.tipo_dato,",
        "    valor_texto = EXCLUDED.valor_texto,",
        "    valor_entero = EXCLUDED.valor_entero,",
        "    valor_decimal = EXCLUDED.valor_decimal,",
        "    valor_bool = EXCLUDED.valor_bool,",
        "    editable = EXCLUDED.editable,",
        "    activo = EXCLUDED.activo,",
        "    modificado_en = NOW();",
        "COMMIT;",
    ]

    output = SEED / "11-seed-configuracion-rrhh-sigre.sql"
    output.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"configuracion: {len(rows)} filas -> {output.name}")


if __name__ == "__main__":
    main()
