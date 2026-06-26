#!/usr/bin/env python3
"""Genera seeds SIGRE para grupo_conceptos_planilla y concepto_planilla."""
import json
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "data"
SEED = Path(__file__).resolve().parent.parent / "ddl" / "seed"


def sql_str(value):
    if value is None:
        return "NULL"
    return "'" + str(value).replace("'", "''") + "'"


def sql_num(value, default=0):
    if value is None:
        return str(default)
    return str(value)


def sql_flag(value, default='0'):
    if value is None or str(value).strip() == '':
        value = default
    return "'" + str(value).replace("'", "''") + "'"


def gen_grupo_seed():
    with open(DATA / "GRUPO_CALC_CONCEPTO.json", encoding="utf-8") as f:
        rows = json.load(f)["GRUPO_CALC_CONCEPTO"]

    lines = [
        "-- Catálogo SIGRE GRUPO_CALC_CONCEPTO (GRUPO_CALC_CONCEPTO.json)",
        "INSERT INTO rrhh.grupo_conceptos_planilla (codigo, nombre, concepto_codigo, flag_replicacion, flag_estado)",
        "VALUES",
    ]
    values = []
    for r in rows:
        values.append(
            f"({sql_str(r['GRUPO_CALC'])}, {sql_str(r['DESCRIPCION'])}, "
            f"{sql_str(r.get('CONCEP'))}, {sql_flag(r.get('FLAG_REPLICACION'), '1')}, '1')"
        )
    lines.append(",\n".join(values))
    lines.append(
        "ON CONFLICT (codigo) DO UPDATE SET\n"
        "    nombre = EXCLUDED.nombre,\n"
        "    concepto_codigo = EXCLUDED.concepto_codigo,\n"
        "    flag_replicacion = EXCLUDED.flag_replicacion,\n"
        "    flag_estado = EXCLUDED.flag_estado;"
    )
    (SEED / "01-seed-grupo-conceptos-planilla-sigre.sql").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"grupo: {len(rows)} filas")


def gen_concepto_seed():
    with open(DATA / "CONCEPTO.json", encoding="utf-8") as f:
        rows = json.load(f)["CONCEPTO"]

    lines = [
        "-- Catálogo SIGRE CONCEPTO (CONCEPTO.json)",
        "INSERT INTO rrhh.concepto_planilla (",
        "    codigo, nombre, descripcion_breve, factor_pago, importe_tope_min, importe_tope_max,",
        "    numero_horas, grupo_conceptos_planilla_id, flag_replicacion, concepto_rtps, flag_subsidio,",
        "    flag_reporte_quinta, numero_orden, flag_estado",
        ")",
        "SELECT v.codigo, v.nombre, v.descripcion_breve, v.factor_pago, v.importe_tope_min, v.importe_tope_max,",
        "       v.numero_horas, g.id, v.flag_replicacion, v.concepto_rtps, v.flag_subsidio,",
        "       v.flag_reporte_quinta, v.numero_orden, v.flag_estado",
        "FROM (VALUES",
    ]
    values = []
    for r in rows:
        nro_horas = r.get("NRO_HORAS")
        nro_horas_sql = str(nro_horas) if nro_horas is not None else "NULL"
        values.append(
            f"({sql_str(r['CONCEP'])}, {sql_str(r['DESC_CONCEP'])}, {sql_str(r.get('DESC_BREVE'))}, "
            f"{sql_num(r.get('FACT_PAGO'), 1)}, {sql_num(r.get('IMP_TOPE_MIN'), 0)}, {sql_num(r.get('IMP_TOPE_MAX'), 0)}, "
            f"{nro_horas_sql}, {sql_str(r['GRUPO_CALC'])}, {sql_flag(r.get('FLAG_REPLICACION'), '1')}, "
            f"{sql_str(r.get('CONCEP_RTPS'))}, {sql_flag(r.get('FLAG_SUBSIDIO'), '0')}, "
            f"{sql_flag(r.get('FLAG_REP_QUINTA'), '0')}, {sql_str(r.get('NRO_ORDEN'))}, "
            f"{sql_flag(r.get('FLAG_ESTADO'), '1')})"
        )
    lines.append(",\n".join(values))
    lines.append(
        ") AS v(codigo, nombre, descripcion_breve, factor_pago, importe_tope_min, importe_tope_max,"
    )
    lines.append(
        "         numero_horas, grupo_calc, flag_replicacion, concepto_rtps, flag_subsidio,"
    )
    lines.append(
        "         flag_reporte_quinta, numero_orden, flag_estado)"
    )
    lines.append(
        "JOIN rrhh.grupo_conceptos_planilla g ON g.codigo = v.grupo_calc"
    )
    lines.append(
        "ON CONFLICT (codigo) DO UPDATE SET"
    )
    lines.append("    nombre = EXCLUDED.nombre,")
    lines.append("    descripcion_breve = EXCLUDED.descripcion_breve,")
    lines.append("    factor_pago = EXCLUDED.factor_pago,")
    lines.append("    importe_tope_min = EXCLUDED.importe_tope_min,")
    lines.append("    importe_tope_max = EXCLUDED.importe_tope_max,")
    lines.append("    numero_horas = EXCLUDED.numero_horas,")
    lines.append("    grupo_conceptos_planilla_id = EXCLUDED.grupo_conceptos_planilla_id,")
    lines.append("    flag_replicacion = EXCLUDED.flag_replicacion,")
    lines.append("    concepto_rtps = EXCLUDED.concepto_rtps,")
    lines.append("    flag_subsidio = EXCLUDED.flag_subsidio,")
    lines.append("    flag_reporte_quinta = EXCLUDED.flag_reporte_quinta,")
    lines.append("    numero_orden = EXCLUDED.numero_orden,")
    lines.append("    flag_estado = EXCLUDED.flag_estado;")
    lines.append("")
    lines.append("UPDATE rrhh.concepto_planilla cp")
    lines.append("SET grupo_conceptos_planilla_id = g.id")
    lines.append("FROM rrhh.grupo_conceptos_planilla g")
    lines.append("WHERE cp.grupo_conceptos_planilla_id IS NULL AND g.codigo = '10';")
    lines.append("")
    lines.append("ALTER TABLE rrhh.concepto_planilla ALTER COLUMN grupo_conceptos_planilla_id SET NOT NULL;")
    (SEED / "02-concepto-planilla-sigre.sql").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"concepto: {len(rows)} filas")


if __name__ == "__main__":
    gen_grupo_seed()
    gen_concepto_seed()
