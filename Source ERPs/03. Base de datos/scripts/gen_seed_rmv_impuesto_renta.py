#!/usr/bin/env python3
"""Genera seeds SIGRE RMV_X_TIPO_TRABAJ y RRHH_IMPUESTO_RENTA."""
import json
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "data"
SEED = Path(__file__).resolve().parent.parent / "ddl" / "seed"


def sql_str(value):
    if value is None:
        return "NULL"
    text = str(value).strip()
    if not text:
        return "NULL"
    return "'" + text.replace("'", "''") + "'"


def sql_date(value):
    if value is None or str(value).strip() == "":
        return "NULL"
    return "'" + str(value)[:10] + "'"


def sql_num(value):
    if value is None or str(value).strip() == "":
        return "NULL"
    return str(value)


def sql_flag(value, default="1"):
    if value is None or str(value).strip() == "":
        value = default
    return "'" + str(value).replace("'", "''") + "'"


def gen_rmv_seed():
    with open(DATA / "RMV_X_TIPO_TRABAJ.json", encoding="utf-8") as handle:
        rows = json.load(handle)["RMV_X_TIPO_TRABAJ"]

    lines = [
        "-- RMV por tipo trabajador SIGRE (RMV_X_TIPO_TRABAJ.json)",
        f"-- Registros: {len(rows)}",
        "BEGIN;",
        "INSERT INTO rrhh.remuneracion_minima_vital (tipo_trabajador_id, rmv, fecha_desde, flag_estado)",
        "SELECT tt.id, v.rmv, v.fecha_desde::date, '1'",
        "FROM (VALUES",
    ]
    values = []
    for row in rows:
        values.append(
            f"({sql_str(row['TIPO_TRABAJADOR'])}, {sql_num(row['RMV'])}, {sql_date(row['FECHA_DESDE'])})"
        )
    lines.append(",\n".join(values))
    lines.extend([
        ") AS v(tipo_codigo, rmv, fecha_desde)",
        "JOIN rrhh.tipo_trabajador tt ON tt.codigo = v.tipo_codigo",
        "ON CONFLICT (tipo_trabajador_id, rmv, fecha_desde) DO UPDATE SET",
        "    flag_estado = EXCLUDED.flag_estado,",
        "    fec_modificacion = NOW();",
        "COMMIT;",
    ])
    (SEED / "09-seed-rmv-tipo-trabaj-sigre.sql").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"remuneracion_minima_vital: {len(rows)} filas")


def gen_impuesto_renta_seed():
    with open(DATA / "RRHH_IMPUESTO_RENTA.json", encoding="utf-8") as handle:
        rows = json.load(handle)["RRHH_IMPUESTO_RENTA"]

    lines = [
        "-- Tramos quinta categoría SIGRE (RRHH_IMPUESTO_RENTA.json)",
        f"-- Registros: {len(rows)}",
        "BEGIN;",
        "INSERT INTO rrhh.impuesto_renta_tramos (",
        "    secuencia, tasa, tope_ini, tope_fin, fecha_vig_ini, fecha_vig_fin, cod_usr, flag_replicacion, flag_estado",
        ")",
        "VALUES",
    ]
    values = []
    for row in rows:
        values.append(
            f"({sql_num(row['SECUENCIA'])}, {sql_num(row['TASA'])}, {sql_num(row['TOPE_INI'])}, "
            f"{sql_num(row['TOPE_FIN'])}, {sql_date(row['FECHA_VIG_INI'])}, {sql_date(row['FECHA_VIG_FIN'])}, "
            f"{sql_str(row.get('COD_USR'))}, {sql_flag(row.get('FLAG_REPLICACION'), '1')}, '1')"
        )
    lines.append(",\n".join(values))
    lines.extend([
        "ON CONFLICT (fecha_vig_ini, secuencia) DO UPDATE SET",
        "    tasa = EXCLUDED.tasa,",
        "    tope_ini = EXCLUDED.tope_ini,",
        "    tope_fin = EXCLUDED.tope_fin,",
        "    fecha_vig_fin = EXCLUDED.fecha_vig_fin,",
        "    cod_usr = EXCLUDED.cod_usr,",
        "    flag_replicacion = EXCLUDED.flag_replicacion,",
        "    flag_estado = EXCLUDED.flag_estado,",
        "    fec_modificacion = NOW();",
        "COMMIT;",
    ])
    (SEED / "10-seed-impuesto-renta-tramos-sigre.sql").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"impuesto_renta_tramos: {len(rows)} filas")


if __name__ == "__main__":
    gen_rmv_seed()
    gen_impuesto_renta_seed()
