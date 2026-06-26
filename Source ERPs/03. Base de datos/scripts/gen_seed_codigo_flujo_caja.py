#!/usr/bin/env python3
"""Genera bloque seed para actividad_flujo_caja, grupo_codigo_flujo_caja y codigo_flujo_caja."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ACTIVIDAD_JSON = ROOT / "data" / "FIN_ACTIVIDAD_FLUJO.json"
GRUPO_JSON = ROOT / "data" / "GRUPO_COD_FLUJO_CAJA.json"
CODIGO_JSON = ROOT / "data" / "CODIGO_FLUJO_CAJA.json"
SEED_PATH = ROOT / "ddl" / "seed" / "01-carga-inicial-maestros.sql"
OUT_PATH = ROOT / "ddl" / "seed" / "_gen_codigo_flujo_caja.sql"
TX_MARKER = "-- TX 4d: finanzas.actividad_flujo_caja + grupo_codigo_flujo_caja + codigo_flujo_caja"
TX_END_MARKER = "-- ============================================================"


def esc(value: str | None) -> str:
    if value is None:
        return "NULL"
    return "'" + str(value).replace("'", "''").strip() + "'"


def date_esc(iso: str | None) -> str:
    if not iso:
        return "CURRENT_DATE"
    return f"'{iso[:10]}'"


def build_actividad_section(actividades: list[dict]) -> list[str]:
    sorted_rows = sorted(actividades, key=lambda r: (r.get("ORDEN") or 0, r["COD_ACTIVIDAD"]))
    actividad_ids = {r["COD_ACTIVIDAD"].strip(): idx for idx, r in enumerate(sorted_rows, start=1)}

    lines = [
        "-- ACTIVIDAD FLUJO CAJA (" + str(len(sorted_rows)) + " registros)",
        "INSERT INTO finanzas.actividad_flujo_caja",
        "(id, codigo, nombre, orden, flag_tipo_flujo, flag_estado) VALUES",
    ]
    values = []
    for row in sorted_rows:
        aid = actividad_ids[row["COD_ACTIVIDAD"].strip()]
        codigo = row["COD_ACTIVIDAD"].strip()
        nombre = (row.get("DESC_ACTIVIDAD") or codigo).strip()
        orden = int(row.get("ORDEN") or 0)
        flag_tipo_flujo = esc(row.get("FLAG_TIPO_FLUJO") or "E")
        flag_estado = esc(row.get("FLAG_ESTADO") or "1")
        values.append(f"    ({aid}, {esc(codigo)}, {esc(nombre)}, {orden}, {flag_tipo_flujo}, {flag_estado})")

    lines.append(",\n".join(values))
    lines.extend(
        [
            "ON CONFLICT (codigo) DO UPDATE SET",
            "    nombre = EXCLUDED.nombre,",
            "    orden = EXCLUDED.orden,",
            "    flag_tipo_flujo = EXCLUDED.flag_tipo_flujo,",
            "    flag_estado = EXCLUDED.flag_estado;",
            "",
            "SELECT setval(",
            "    pg_get_serial_sequence('finanzas.actividad_flujo_caja', 'id'),",
            "    (SELECT COALESCE(MAX(id), 1) FROM finanzas.actividad_flujo_caja)",
            ");",
            "",
        ]
    )
    return lines, actividad_ids


def build_grupo_section(grupos: list[dict], actividad_ids: dict[str, int]) -> list[str]:
    grupos_sorted = sorted(grupos, key=lambda g: (g.get("ORDEN") or 0, g["GRP_FLUJO_CAJA"]))
    grupo_ids = {g["GRP_FLUJO_CAJA"].strip(): idx for idx, g in enumerate(grupos_sorted, start=1)}

    refs = {g.get("COD_ACTIVIDAD", "").strip() for g in grupos if g.get("COD_ACTIVIDAD")}
    missing = sorted(refs - actividad_ids.keys())
    if missing:
        raise SystemExit(f"Actividades referenciadas en GRUPO_COD_FLUJO_CAJA sin definir en FIN_ACTIVIDAD_FLUJO: {missing}")

    lines = [
        "-- GRUPO CODIGO FLUJO CAJA (" + str(len(grupos_sorted)) + " registros)",
        "INSERT INTO finanzas.grupo_codigo_flujo_caja",
        "(id, codigo, nombre, flag_reporte, factor, orden, actividad_flujo_caja_id, flag_replicacion, fec_registro, flag_estado) VALUES",
    ]

    grp_lines = []
    for row in grupos_sorted:
        gid = grupo_ids[row["GRP_FLUJO_CAJA"].strip()]
        codigo = row["GRP_FLUJO_CAJA"].strip()
        nombre = (row.get("DESCRIPCION") or codigo).strip()
        flag_reporte = esc(row.get("FLAG_REPORTE"))
        factor = esc(row.get("FACTOR"))
        orden = int(row.get("ORDEN") or 0)
        actividad_id = actividad_ids[row["COD_ACTIVIDAD"].strip()]
        flag_replicacion = esc(row.get("FLAG_REPLICACION") or "1")
        fec_registro = date_esc(row.get("FEC_REGISTRO")) + "::date"
        flag_estado = esc(row.get("FLAG_ESTADO") or "1")
        grp_lines.append(
            f"    ({gid}, {esc(codigo)}, {esc(nombre)}, {flag_reporte}, {factor}, {orden}, "
            f"{actividad_id}, {flag_replicacion}, {fec_registro}, {flag_estado})"
        )

    lines.append(",\n".join(grp_lines))
    lines.extend(
        [
            "ON CONFLICT (codigo) DO UPDATE SET",
            "    nombre = EXCLUDED.nombre,",
            "    flag_reporte = EXCLUDED.flag_reporte,",
            "    factor = EXCLUDED.factor,",
            "    orden = EXCLUDED.orden,",
            "    actividad_flujo_caja_id = EXCLUDED.actividad_flujo_caja_id,",
            "    flag_replicacion = EXCLUDED.flag_replicacion,",
            "    fec_registro = EXCLUDED.fec_registro,",
            "    flag_estado = EXCLUDED.flag_estado;",
            "",
            "SELECT setval(",
            "    pg_get_serial_sequence('finanzas.grupo_codigo_flujo_caja', 'id'),",
            "    (SELECT COALESCE(MAX(id), 1) FROM finanzas.grupo_codigo_flujo_caja)",
            ");",
            "",
        ]
    )
    return lines, grupo_ids


def build_codigo_section(codigos: list[dict], grupo_ids: dict[str, int]) -> list[str]:
    missing = sorted({r["GRP_FLUJO_CAJA"].strip() for r in codigos} - grupo_ids.keys())
    if missing:
        raise SystemExit(f"Grupos referenciados en CODIGO_FLUJO_CAJA sin definir en GRUPO_COD_FLUJO_CAJA: {missing}")

    lines = [
        "INSERT INTO finanzas.codigo_flujo_caja (",
        "    codigo, grupo_codigo_flujo_caja_id, nombre, tipo, factor, factor_flujo_caja,",
        "    orden, flag_replicacion, fec_registro, cod_usr, flag_estado",
        ")",
        "SELECT",
        "    v.codigo,",
        "    v.grupo_codigo_flujo_caja_id,",
        "    v.nombre,",
        "    v.tipo,",
        "    v.factor::numeric,",
        "    v.factor_flujo_caja,",
        "    v.orden,",
        "    v.flag_replicacion,",
        "    v.fec_registro,",
        "    v.cod_usr,",
        "    v.flag_estado",
        "FROM (VALUES",
    ]

    val_lines = []
    for row in codigos:
        codigo = row["COD_FLUJO_CAJA"].strip()
        grupo_id = grupo_ids[row["GRP_FLUJO_CAJA"].strip()]
        nombre = (row.get("DESCRIPCION") or codigo).strip()
        tipo = "INGRESO" if codigo.upper().startswith("ING") else "EGRESO"
        factor = "NULL::numeric" if row.get("FACTOR") is None else str(row["FACTOR"])
        factor_flujo = int(row.get("FACTOR_FLUJO_CAJA") or 0)
        orden = int(row.get("ORDEN") or 0)
        flag_replicacion = esc(row.get("FLAG_REPLICACION") or "1")
        fec_registro = date_esc(row.get("FEC_REGISTRO")) + "::date"
        cod_usr = esc(row.get("COD_USR") or "")
        flag_estado = esc(row.get("FLAG_ESTADO") or "1")
        val_lines.append(
            "    ("
            f"{esc(codigo)}, {grupo_id}, {esc(nombre)}, {esc(tipo)}, {factor}, "
            f"{factor_flujo}, {orden}, {flag_replicacion}, {fec_registro}, {cod_usr}, {flag_estado}"
            ")"
        )

    lines.append(",\n".join(val_lines))
    lines.extend(
        [
            ") AS v(codigo, grupo_codigo_flujo_caja_id, nombre, tipo, factor, factor_flujo_caja, "
            "orden, flag_replicacion, fec_registro, cod_usr, flag_estado)",
            "ON CONFLICT (codigo) DO UPDATE SET",
            "    grupo_codigo_flujo_caja_id = EXCLUDED.grupo_codigo_flujo_caja_id,",
            "    nombre = EXCLUDED.nombre,",
            "    tipo = EXCLUDED.tipo,",
            "    factor = EXCLUDED.factor,",
            "    factor_flujo_caja = EXCLUDED.factor_flujo_caja,",
            "    orden = EXCLUDED.orden,",
            "    flag_replicacion = EXCLUDED.flag_replicacion,",
            "    fec_registro = EXCLUDED.fec_registro,",
            "    cod_usr = EXCLUDED.cod_usr,",
            "    flag_estado = EXCLUDED.flag_estado;",
            "",
            "SELECT setval(",
            "    pg_get_serial_sequence('finanzas.codigo_flujo_caja', 'id'),",
            "    (SELECT COALESCE(MAX(id), 1) FROM finanzas.codigo_flujo_caja)",
            ");",
            "",
        ]
    )
    return lines


def generate_block() -> str:
    actividades = json.loads(ACTIVIDAD_JSON.read_text(encoding="utf-8"))["FIN_ACTIVIDAD_FLUJO"]
    grupos = json.loads(GRUPO_JSON.read_text(encoding="utf-8"))["GRUPO_COD_FLUJO_CAJA"]
    codigos = json.loads(CODIGO_JSON.read_text(encoding="utf-8"))["CODIGO_FLUJO_CAJA"]

    actividad_section, actividad_ids = build_actividad_section(actividades)
    grupo_section, grupo_ids = build_grupo_section(grupos, actividad_ids)
    codigo_section = build_codigo_section(codigos, grupo_ids)

    out = [
        TX_MARKER,
        "-- Fuente: data/FIN_ACTIVIDAD_FLUJO.json + data/GRUPO_COD_FLUJO_CAJA.json + data/CODIGO_FLUJO_CAJA.json",
        "-- Regenerar: python scripts/gen_seed_codigo_flujo_caja.py",
        TX_END_MARKER,
        "BEGIN;",
        "",
        "DELETE FROM finanzas.codigo_flujo_caja;",
        "DELETE FROM finanzas.grupo_codigo_flujo_caja;",
        "",
        *actividad_section,
        *grupo_section,
        *codigo_section,
        "COMMIT;",
        "",
    ]
    return "\n".join(out)


def patch_seed_file(block: str) -> None:
    content = SEED_PATH.read_text(encoding="utf-8")
    start = content.find(TX_MARKER)
    if start == -1:
        legacy = "-- TX 4d: finanzas.grupo_codigo_flujo_caja + codigo_flujo_caja"
        start = content.find(legacy)
    if start == -1:
        raise SystemExit("No se encontró bloque TX 4d en 01-carga-inicial-maestros.sql")

    next_tx = content.find("\n-- ============================================================\n-- TX ", start + 10)
    if next_tx == -1:
        end_commit = content.find("COMMIT;", start)
        if end_commit == -1:
            raise SystemExit("No se encontró fin del bloque TX 4d")
        end = content.find("\n", end_commit) + 1
    else:
        end = next_tx

    new_content = content[:start] + block + content[end:]
    SEED_PATH.write_text(new_content, encoding="utf-8", newline="\n")


def main() -> None:
    block = generate_block()
    OUT_PATH.write_text(block + "\n", encoding="utf-8", newline="\n")
    patch_seed_file(block)
    actividades = json.loads(ACTIVIDAD_JSON.read_text(encoding="utf-8"))["FIN_ACTIVIDAD_FLUJO"]
    grupos = json.loads(GRUPO_JSON.read_text(encoding="utf-8"))["GRUPO_COD_FLUJO_CAJA"]
    codigos = json.loads(CODIGO_JSON.read_text(encoding="utf-8"))["CODIGO_FLUJO_CAJA"]
    print(f"Generado: {OUT_PATH}")
    print(f"Actualizado: {SEED_PATH}")
    print(f"  {len(actividades)} actividades, {len(grupos)} grupos, {len(codigos)} codigos")


if __name__ == "__main__":
    main()
