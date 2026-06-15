#!/usr/bin/env python3
"""Genera bloque seed para grupo_concepto_financiero y concepto_financiero."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GRUPO_JSON = ROOT / "data" / "COFIN_GRUPO.json"
CONCEPTO_JSON = ROOT / "data" / "CONCEPTO_FINANCIERO.json"
SEED_PATH = ROOT / "ddl" / "seed" / "02-carga-concepto-matriz-financiera.sql"
OUT_PATH = ROOT / "ddl" / "seed" / "_gen_concepto_financiero.sql"
CHUNK_SIZE = 200
START_MARKER = "-- CONCEPTO FINANCIERO (grupo + conceptos desde JSON SIGRE)"
END_MARKER = "-- GRUPOS DE MATRIZ CONTABLE"


def esc(value: str | None) -> str:
    if value is None:
        return "NULL"
    return "'" + str(value).replace("'", "''").strip() + "'"


def chunk_lines(lines: list[str], size: int) -> list[list[str]]:
    return [lines[i : i + size] for i in range(0, len(lines), size)]


def build_grupo_section(grupos: list[dict]) -> list[str]:
    grupos_sorted = sorted(grupos, key=lambda g: g["GRUPO"].strip())
    grupo_ids = {g["GRUPO"].strip(): idx for idx, g in enumerate(grupos_sorted, start=1)}

    out = [
        "-- GRUPO CONCEPTO FINANCIERO (118 registros)",
        "INSERT INTO finanzas.grupo_concepto_financiero",
        "(id, codigo, nombre, flag_replicacion, flag_estado) VALUES",
    ]

    lines = []
    for row in grupos_sorted:
        gid = grupo_ids[row["GRUPO"].strip()]
        codigo = row["GRUPO"].strip()
        nombre = (row.get("DESCRIPCION") or codigo).strip()
        flag_replicacion = esc(row.get("FLAG_REPLICACION") or "1")
        lines.append(f"    ({gid}, {esc(codigo)}, {esc(nombre)}, {flag_replicacion}, '1')")

    out.append(",\n".join(lines))
    out.extend(
        [
            "ON CONFLICT (codigo) DO UPDATE SET",
            "    nombre = EXCLUDED.nombre,",
            "    flag_replicacion = EXCLUDED.flag_replicacion,",
            "    flag_estado = EXCLUDED.flag_estado;",
            "",
            "SELECT setval(",
            "    pg_get_serial_sequence('finanzas.grupo_concepto_financiero', 'id'),",
            "    (SELECT COALESCE(MAX(id), 1) FROM finanzas.grupo_concepto_financiero)",
            ");",
            "",
        ]
    )
    return out, grupo_ids


def build_concepto_sections(conceptos: list[dict], grupo_ids: dict[str, int]) -> list[str]:
    out: list[str] = []
    value_lines = []

    for row in sorted(conceptos, key=lambda r: r["CONFIN"].strip()):
        codigo = row["CONFIN"].strip()
        nombre = (row.get("DESCRIPCION") or codigo).strip()
        if len(nombre) > 150:
            nombre = nombre[:150]
        flag_estado = esc(row.get("FLAG_ESTADO") or "1")
        grupo = row.get("GRUPO")
        grupo_id = "NULL"
        if grupo:
            grupo_id = str(grupo_ids[grupo.strip()])
        value_lines.append(f"    ({esc(codigo)}, {esc(nombre)}, {flag_estado}, {grupo_id})")

    chunks = chunk_lines(value_lines, CHUNK_SIZE)
    out.append(f"-- CONCEPTO FINANCIERO ({len(conceptos)} registros)")
    for idx, chunk in enumerate(chunks):
        out.append(
            "INSERT INTO finanzas.concepto_financiero "
            "(codigo, nombre, flag_estado, matriz_contable_id, grupo_concepto_financiero_id)"
        )
        out.append("SELECT v.codigo, v.nombre, v.flag_estado, mc.id, v.grupo_concepto_financiero_id")
        out.append("FROM (VALUES")
        out.append(",\n".join(chunk))
        out.append(") AS v(codigo, nombre, flag_estado, grupo_concepto_financiero_id)")
        out.append("JOIN contabilidad.matriz_contable mc ON mc.codigo = v.codigo")
        out.append(
            "ON CONFLICT (codigo) DO UPDATE SET "
            "nombre = EXCLUDED.nombre, "
            "flag_estado = EXCLUDED.flag_estado, "
            "matriz_contable_id = EXCLUDED.matriz_contable_id, "
            "grupo_concepto_financiero_id = EXCLUDED.grupo_concepto_financiero_id;"
        )
        if idx < len(chunks) - 1:
            out.append("")
    return out


def generate_block() -> str:
    grupos = json.loads(GRUPO_JSON.read_text(encoding="utf-8"))["COFIN_GRUPO"]
    conceptos = json.loads(CONCEPTO_JSON.read_text(encoding="utf-8"))["CONCEPTO_FINANCIERO"]

    refs = {r["GRUPO"].strip() for r in conceptos if r.get("GRUPO")}
    grupo_codes = {g["GRUPO"].strip() for g in grupos}
    missing = sorted(refs - grupo_codes)
    if missing:
        raise SystemExit(f"Grupos referenciados en CONCEPTO_FINANCIERO sin definir en COFIN_GRUPO: {missing}")

    grupo_section, grupo_ids = build_grupo_section(grupos)
    concepto_section = build_concepto_sections(conceptos, grupo_ids)

    lines = [
        START_MARKER,
        "-- Fuente: data/COFIN_GRUPO.json + data/CONCEPTO_FINANCIERO.json",
        "-- Regenerar: python scripts/gen_seed_concepto_financiero.py",
        "",
        *grupo_section,
        *concepto_section,
        "",
    ]
    return "\n".join(lines)


def remove_legacy_concepto_blocks(content: str) -> str:
    legacy_marker = "-- CONCEPTO FINANCIERO (631 registros)"
    end_marker = END_MARKER
    while True:
        first = content.find(legacy_marker)
        if first == -1:
            break
        second = content.find(legacy_marker, first + 1)
        if second == -1:
            break
        end = content.find(end_marker, second)
        if end == -1:
            break
        content = content[:second] + content[end:]
    return content


def patch_seed_file(block: str) -> None:
    content = SEED_PATH.read_text(encoding="utf-8")
    content = remove_legacy_concepto_blocks(content)
    start = content.find(START_MARKER)
    end = content.find(END_MARKER)
    if start == -1:
        begin_idx = content.find("BEGIN;")
        if begin_idx == -1:
            raise SystemExit("No se encontró BEGIN; en el seed.")
        insert_at = content.find("\n", begin_idx) + 1
        new_content = content[:insert_at] + "\n" + block + "\n" + content[insert_at:]
    elif end == -1:
        raise SystemExit(f"No se encontró marcador fin: {END_MARKER}")
    else:
        new_content = content[:start] + block + content[end:]
    SEED_PATH.write_text(new_content, encoding="utf-8", newline="\n")


def main() -> None:
    block = generate_block()
    OUT_PATH.write_text(block + "\n", encoding="utf-8", newline="\n")
    patch_seed_file(block)
    print(f"Generado: {OUT_PATH}")
    print(f"Actualizado: {SEED_PATH}")


if __name__ == "__main__":
    main()
