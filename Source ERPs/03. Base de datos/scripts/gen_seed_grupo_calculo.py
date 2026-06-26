#!/usr/bin/env python3
"""Genera seeds SIGRE GRUPO_CALCULO y GRUPO_CALCULO_DET."""
import json
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "data"
SEED = Path(__file__).resolve().parent.parent / "ddl" / "seed"


def sql_str(value):
    if value is None:
        return "NULL"
    text = str(value).strip()
    if text == "":
        return "NULL"
    return "'" + text.replace("'", "''") + "'"


def sql_flag(value, default="1"):
    if value is None or str(value).strip() == "":
        value = default
    return "'" + str(value).replace("'", "''") + "'"


def gen_grupo_calculo_seed():
    with open(DATA / "GRUPO_CALCULO.json", encoding="utf-8") as f:
        rows = json.load(f)["GRUPO_CALCULO"]

    lines = [
        "-- Catálogo SIGRE GRUPO_CALCULO (GRUPO_CALCULO.json)",
        "INSERT INTO rrhh.grupo_calculo (",
        "    codigo, nombre, concepto_gen_id, concepto_reg_lab_id, flag_seccion, flag_replicacion, flag_estado",
        ")",
        "SELECT v.codigo, v.nombre, cg.id, cr.id, v.flag_seccion, v.flag_replicacion, '1'",
        "FROM (VALUES",
    ]
    values = []
    for r in rows:
        values.append(
            f"({sql_str(r['GRUPO_CALCULO'])}, {sql_str(r.get('DESC_GRUPO'))}, "
            f"{sql_str(r.get('CONCEPTO_GEN'))}, {sql_str(r.get('CONCEPTO_REG_LAB'))}, "
            f"{sql_flag(r.get('FLAG_SECCION'), '0')}, {sql_flag(r.get('FLAG_REPLICACION'), '1')})"
        )
    lines.append(",\n".join(values))
    lines.extend([
        ") AS v(codigo, nombre, concepto_gen_cod, concepto_reg_lab_cod, flag_seccion, flag_replicacion)",
        "LEFT JOIN rrhh.concepto_planilla cg ON cg.codigo = v.concepto_gen_cod",
        "LEFT JOIN rrhh.concepto_planilla cr ON cr.codigo = v.concepto_reg_lab_cod",
        "ON CONFLICT (codigo) DO UPDATE SET",
        "    nombre = EXCLUDED.nombre,",
        "    concepto_gen_id = EXCLUDED.concepto_gen_id,",
        "    concepto_reg_lab_id = EXCLUDED.concepto_reg_lab_id,",
        "    flag_seccion = EXCLUDED.flag_seccion,",
        "    flag_replicacion = EXCLUDED.flag_replicacion,",
        "    flag_estado = EXCLUDED.flag_estado;",
    ])
    (SEED / "07-seed-grupo-calculo-sigre.sql").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"grupo_calculo: {len(rows)} filas")


def gen_grupo_calculo_det_seed():
    with open(DATA / "GRUPO_CALCULO_DET.json", encoding="utf-8") as f:
        rows = json.load(f)["GRUPO_CALCULO_DET"]

    lines = [
        "-- Matriz SIGRE GRUPO_CALCULO_DET (GRUPO_CALCULO_DET.json)",
        "INSERT INTO rrhh.grupo_calculo_det (grupo_calculo_id, concepto_planilla_id, flag_replicacion, flag_estado)",
        "SELECT g.id, c.id, v.flag_replicacion, '1'",
        "FROM (VALUES",
    ]
    values = []
    for r in rows:
        values.append(
            f"({sql_str(r['GRUPO_CALCULO'])}, {sql_str(r['CONCEPTO_CALC'])}, "
            f"{sql_flag(r.get('FLAG_REPLICACION'), '1')})"
        )
    lines.append(",\n".join(values))
    lines.extend([
        ") AS v(grupo_codigo, concepto_codigo, flag_replicacion)",
        "JOIN rrhh.grupo_calculo g ON g.codigo = v.grupo_codigo",
        "JOIN rrhh.concepto_planilla c ON c.codigo = v.concepto_codigo",
        "ON CONFLICT (grupo_calculo_id, concepto_planilla_id) DO UPDATE SET",
        "    flag_replicacion = EXCLUDED.flag_replicacion,",
        "    flag_estado = EXCLUDED.flag_estado;",
    ])
    (SEED / "08-seed-grupo-calculo-det-sigre.sql").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"grupo_calculo_det: {len(rows)} filas")


if __name__ == "__main__":
    gen_grupo_calculo_seed()
    gen_grupo_calculo_det_seed()
