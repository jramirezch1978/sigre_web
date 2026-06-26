#!/usr/bin/env python3
"""Genera seed rrhh.fechas_proceso desde RRHH_PARAM_ORG.json (SIGRE)."""
import json
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "data"
SEED = Path(__file__).resolve().parent.parent / "ddl" / "seed"
JSON_PATH = DATA / "RRHH_PARAM_ORG.json"
OUT_PATH = SEED / "06-seed-fechas-proceso-sigre.sql"
BATCH_SIZE = 100

INSERT_COLUMNS = [
    "origen",
    "fec_proceso",
    "fec_inicio",
    "fec_final",
    "flag_replicacion",
    "cod_relacion",
    "tipo_trabajador_id",
    "porc_aplica_ctacte",
    "flag_calc_vacaciones",
    "flag_calc_cts",
    "flag_calc_gratificacion",
    "flag_bonificacion_pesca",
    "tipo_planilla_id",
    "flag_estado",
]

UPDATE_COLUMNS = [
    "porc_aplica_ctacte",
    "flag_replicacion",
    "flag_calc_vacaciones",
    "flag_calc_cts",
    "flag_calc_gratificacion",
    "flag_bonificacion_pesca",
    "flag_estado",
]


def sql_str(value) -> str:
    if value is None:
        return "NULL"
    escaped = str(value).replace("'", "''")
    return f"'{escaped}'"


def sql_date(value) -> str:
    if not value:
        return "NULL"
    return f"'{str(value)[:10]}'"


def sql_flag(value, default="0") -> str:
    if value is None:
        return f"'{default}'"
    return f"'{str(value).strip()}'"


def sql_numeric(value) -> str:
    if value is None:
        return "NULL"
    return str(value)


def sql_int(value) -> str:
    if value is None:
        return "NULL"
    return str(int(value))


def fk_tipo_trabajador(codigo: str) -> str:
    return f"(SELECT id FROM rrhh.tipo_trabajador WHERE codigo = {sql_str(codigo)} LIMIT 1)"


def fk_tipo_planilla(codigo: str) -> str:
    return f"(SELECT id FROM rrhh.tipo_planilla WHERE codigo = {sql_str(codigo)} LIMIT 1)"


def build_row(record: dict) -> str:
    columns = [
        sql_str(record.get("ORIGEN")),
        sql_date(record.get("FEC_PROCESO")),
        sql_date(record.get("FEC_INICIO")),
        sql_date(record.get("FEC_FINAL")),
        sql_flag(record.get("FLAG_REPLICACION"), "1"),
        sql_str(record.get("COD_RELACION")),
        fk_tipo_trabajador(record.get("TIPO_TRABAJADOR")),
        sql_numeric(record.get("PORC_APLICA_CTACTE")),
        sql_flag(record.get("FLAG_CALC_VACACIONES")),
        sql_flag(record.get("FLAG_CALC_CTS")),
        sql_flag(record.get("FLAG_CALC_GRATIFICACION")),
        sql_flag(record.get("FLAG_BONIFICACION_PESCA")),
        fk_tipo_planilla(record.get("TIPO_PLANILLA")),
        "'1'",
    ]
    return "(\n        " + ",\n        ".join(columns) + "\n    )"


def load_records():
    with open(JSON_PATH, encoding="utf-8") as handle:
        return json.load(handle)["RRHH_PARAM_ORG"]


def generate():
    records = load_records()
    lines = [
        "-- Fechas de proceso SIGRE (RRHH_PARAM_ORG.json)",
        "-- Regenerar: python scripts/gen_seed_fechas_proceso.py",
        f"-- Registros: {len(records)}",
        "BEGIN;",
        "",
        "INSERT INTO rrhh.tipo_planilla (codigo, nombre, flag_estado)",
        "VALUES ('B', 'Bonificación', '1')",
        "ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, flag_estado = EXCLUDED.flag_estado;",
        "",
    ]

    for start in range(0, len(records), BATCH_SIZE):
        batch = records[start : start + BATCH_SIZE]
        values_sql = ",\n".join(build_row(record) for record in batch)
        lines.extend([
            "INSERT INTO rrhh.fechas_proceso (",
            ",\n".join(f"    {col}" for col in INSERT_COLUMNS),
            ")",
            "VALUES",
            values_sql,
            "ON CONFLICT ON CONSTRAINT uq_fechas_proceso_natural DO UPDATE SET",
            ",\n".join(f"    {col} = EXCLUDED.{col}" for col in UPDATE_COLUMNS) + ",",
            "    fec_modificacion = NOW();",
            "",
        ])

    lines.extend(["COMMIT;", ""])
    OUT_PATH.write_text("\n".join(lines), encoding="utf-8")
    print(f"Generado {OUT_PATH} ({len(records)} fechas de proceso)")


if __name__ == "__main__":
    generate()
