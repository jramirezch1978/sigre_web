#!/usr/bin/env python3
"""Genera seed SQL con todas las opciones de menu desde opciones_menu.txt."""

from __future__ import annotations

import hashlib
import re
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TXT_PATH = ROOT / "opciones_menu.txt"
OUT_PATH = ROOT / "04. Base de datos" / "ddl" / "seed" / "03-opciones-menu-completas-security.sql"

MODULE_MAP = {
    "VENTAS": "COMERCIALIZACION",
    "RR.HH": "RRHH",
    "ACTIVOS FIJOS": "ACTIVOS_FIJOS",
}

MOD_PREFIX = {
    "ALMACEN": "ALMACEN",
    "COMPRAS": "COMPRAS",
    "APROVISIONAMIENTO": "APROV",
    "COMERCIALIZACION": "COMERC",
    "FINANZAS": "FINANZAS",
    "CONTABILIDAD": "CONTA",
    "ACTIVOS_FIJOS": "ACTIVOS",
    "RRHH": "RRHH",
    "PRODUCCION": "PRODUCCION",
    "PRESUPUESTO": "PRESUP",
    "FLOTA": "FLOTA",
    "MANTENIMIENTO": "MANT",
    "AUDITORIA": "AUDIT",
    "CAMPO": "CAMPO",
    "COMEDOR": "COMEDOR",
    "SIG": "SIG",
    "OPERACIONES": "OPER",
    "HORECA": "HORECA",
    "SEGURIDAD": "SEG",
    "ASISTENCIA": "ASIST",
}

PARENT_PREFIX = {
    "ALMACEN": "ALMACEN",
    "COMPRAS": "COMPRAS",
    "APROVISIONAMIENTO": "APROV",
    "COMERCIALIZACION": "COMERC",
    "FINANZAS": "FINANZAS",
    "CONTABILIDAD": "CONTABILIDAD",
    "ACTIVOS_FIJOS": "ACTIVOS",
    "RRHH": "RRHH",
    "PRODUCCION": "PRODUCCION",
    "PRESUPUESTO": "PRESUP",
    "FLOTA": "FLOTA",
    "MANTENIMIENTO": "MANT",
    "AUDITORIA": "AUDIT",
    "CAMPO": "CAMPO",
    "COMEDOR": "COMEDOR",
    "SIG": "SIG",
    "OPERACIONES": "OPER",
    "HORECA": "HORECA",
    "SEGURIDAD": "SEGURIDAD",
    "ASISTENCIA": "ASISTENCIA",
}

SECTION_ORDER = {
    "TABLAS": 1,
    "OPERACIONES": 2,
    "CONSULTAS": 3,
    "REPORTES": 4,
    "PROCESOS": 5,
}

SECTION_KEY = {
    "TABLAS": "TABLAS",
    "OPERACIONES": "OPERACIONES",
    "CONSULTAS": "CONSULTAS",
    "REPORTES": "REPORTES",
    "PROCESOS": "PROCESOS",
}

MOD_ROUTE = {
    "ALMACEN": "almacen",
    "COMPRAS": "compras",
    "APROVISIONAMIENTO": "aprovisionamiento",
    "COMERCIALIZACION": "comercializacion",
    "FINANZAS": "finanzas",
    "CONTABILIDAD": "contabilidad",
    "ACTIVOS_FIJOS": "activos-fijos",
    "RRHH": "rrhh",
    "PRODUCCION": "produccion",
    "PRESUPUESTO": "presupuesto",
    "FLOTA": "flota",
    "MANTENIMIENTO": "mantenimiento",
    "AUDITORIA": "auditoria",
    "CAMPO": "campo",
    "COMEDOR": "comedor",
    "SIG": "sig",
    "OPERACIONES": "operaciones",
    "HORECA": "horeca",
    "SEGURIDAD": "configuracion",
    "ASISTENCIA": "asistencia",
}

SECTION_ROUTE = {
    "TABLAS": "tablas",
    "OPERACIONES": "operaciones",
    "CONSULTAS": "consultas",
    "REPORTES": "reportes",
    "PROCESOS": "procesos",
}

SKIP_NAMES = {"m_", "m_ap021proveedores"}


def esc(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def slugify(text: str, max_len: int = 40) -> str:
    text = re.sub(r"^\([^)]+\)\s*", "", text.strip())
    text = unicodedata.normalize("NFKD", text)
    text = text.encode("ascii", "ignore").decode("ascii")
    text = re.sub(r"[^a-zA-Z0-9]+", "-", text).strip("-").lower()
    if not text:
        text = "opcion"
    return text[:max_len].strip("-")


def parent_codigo(mod: str, section: str) -> str:
    sec = SECTION_KEY.get(section, slugify(section, 12).upper().replace("-", "_"))
    prefix = PARENT_PREFIX.get(mod, mod[:12])
    return f"{prefix}_{sec}"


def make_codigo(mod: str, section: str, name: str, used: set[str]) -> str:
    prefix = MOD_PREFIX.get(mod, mod[:6])
    sec = SECTION_KEY.get(section, slugify(section, 12).upper().replace("-", "_"))
    base = f"{prefix}_{sec}_{slugify(name, 24).upper().replace('-', '_')}"
    base = re.sub(r"_+", "_", base).strip("_")
    if len(base) > 78:
        digest = hashlib.md5(name.encode()).hexdigest()[:8].upper()
        base = f"{prefix}_{sec}_{digest}"
    codigo = base
    n = 2
    while codigo in used:
        codigo = f"{base[:70]}_{n}"
        n += 1
    used.add(codigo)
    return codigo


def parse_tree(lines: list[str]) -> list[dict]:
    items: list[dict] = []
    current_mod: str | None = None
    current_section: str | None = None
    stack: list[tuple[int, str]] = []
    used_codes: set[str] = set()

    for raw in lines:
        line = raw.rstrip("\n")
        if line.startswith("MODULO:"):
            current_mod = MODULE_MAP.get(line.split(":", 1)[1].strip(), line.split(":", 1)[1].strip())
            current_mod = current_mod.replace(" ", "_").upper()
            current_section = None
            stack = []
            continue

        sec_match = re.match(r"^\[(.+)\]$", line.strip())
        if sec_match and current_mod:
            current_section = sec_match.group(1).strip().upper()
            stack = []
            continue

        if "Acciones:" in line and current_mod and current_section:
            actions = [
                a.strip().upper()
                for a in line.split("Acciones:", 1)[1].split(",")
                if a.strip()
            ]
            leaf_name = stack[-1][1] if stack else "Opcion"
            if leaf_name.strip() in SKIP_NAMES:
                continue
            parent_code = parent_codigo(current_mod, current_section)
            codigo = make_codigo(current_mod, current_section, leaf_name, used_codes)
            route_mod = MOD_ROUTE.get(current_mod, slugify(current_mod))
            route_sec = SECTION_ROUTE.get(current_section, slugify(current_section))
            route = f"/sigre/{route_mod}/{route_sec}/{slugify(leaf_name, 50)}"
            items.append(
                {
                    "modulo": current_mod,
                    "section": current_section,
                    "parent_codigo": parent_code,
                    "codigo": codigo,
                    "nombre": leaf_name.strip(),
                    "ruta": route,
                    "acciones": actions,
                }
            )
            continue

        tree_match = re.match(r"^([├└│\s─]+)(.+)$", line)
        if tree_match and current_section:
            prefix, label = tree_match.groups()
            label = label.strip()
            if not label or label.startswith("Acciones:"):
                continue
            depth = prefix.count("├") + prefix.count("└")
            while stack and stack[-1][0] >= depth:
                stack.pop()
            stack.append((depth, label))

    return items


def group_parents(items: list[dict]) -> list[dict]:
    seen: dict[tuple[str, str], dict] = {}
    for item in items:
        key = (item["modulo"], item["section"])
        if key not in seen:
            sec_label = item["section"].title()
            if item["section"] in SECTION_KEY:
                labels = {
                    "TABLAS": "Tablas",
                    "OPERACIONES": "Operaciones",
                    "CONSULTAS": "Consultas",
                    "REPORTES": "Reportes",
                    "PROCESOS": "Procesos",
                }
                sec_label = labels[item["section"]]
            seen[key] = {
                "modulo": item["modulo"],
                "section": item["section"],
                "codigo": item["parent_codigo"],
                "nombre": sec_label,
                "orden": SECTION_ORDER.get(item["section"], 99),
            }
    return list(seen.values())


def render_patch(parents: list[dict], items: list[dict]) -> str:
    lines = [
        "-- SEED: Catálogo completo auth.opcion_menu desde opciones_menu.txt",
        "-- Generado por scripts/gen_opciones_menu_security.py",
        "-- Incluye 18 módulos ERP + SEGURIDAD (19 en menú PB). ASISTENCIA es módulo aparte en auth.modulo.",
        "BEGIN;",
        "",
        "-- 0) Confirmar 18 módulos ERP + Seguridad + Asistencia",
        "INSERT INTO auth.modulo (codigo, nombre, flag_estado)",
        "VALUES",
        "    ('ALMACEN', 'Almacén', '1'),",
        "    ('COMPRAS', 'Compras', '1'),",
        "    ('APROVISIONAMIENTO', 'Aprovisionamiento', '1'),",
        "    ('COMERCIALIZACION', 'Comercialización', '1'),",
        "    ('FINANZAS', 'Finanzas', '1'),",
        "    ('CONTABILIDAD', 'Contabilidad', '1'),",
        "    ('ACTIVOS_FIJOS', 'Activos fijos', '1'),",
        "    ('RRHH', 'RR.HH', '1'),",
        "    ('PRODUCCION', 'Producción', '1'),",
        "    ('PRESUPUESTO', 'Presupuesto', '1'),",
        "    ('FLOTA', 'Flota', '1'),",
        "    ('MANTENIMIENTO', 'Mantenimiento', '1'),",
        "    ('AUDITORIA', 'Auditoría', '1'),",
        "    ('CAMPO', 'Campo', '1'),",
        "    ('COMEDOR', 'Comedor', '1'),",
        "    ('SIG', 'SIG', '1'),",
        "    ('OPERACIONES', 'Operaciones', '1'),",
        "    ('HORECA', 'Hoteles, Restaurantes y Catering', '1'),",
        "    ('SEGURIDAD', 'Seguridad', '1'),",
        "    ('ASISTENCIA', 'Asistencia', '1')",
        "ON CONFLICT (codigo) DO UPDATE SET",
        "    nombre = EXCLUDED.nombre,",
        "    flag_estado = EXCLUDED.flag_estado;",
        "",
        "-- 1) Secciones padre por módulo",
        "WITH parent_data AS (",
        "    SELECT * FROM (VALUES",
    ]

    parent_values = []
    for p in sorted(parents, key=lambda x: (x["modulo"], x["orden"])):
        parent_values.append(
            f"        ({esc(p['modulo'])}, {esc(p['codigo'])}, {esc(p['nombre'])}, {p['orden']})"
        )
    lines.append(",\n".join(parent_values))
    lines.extend(
        [
            "    ) AS t(modulo_codigo, codigo, nombre, orden)",
            ")",
            "INSERT INTO auth.opcion_menu (modulo_id, codigo, nombre, ruta_frontend, opcion_padre_id, orden, flag_estado)",
            "SELECT m.id, p.codigo, p.nombre, NULL, NULL, p.orden, '1'",
            "FROM parent_data p",
            "JOIN auth.modulo m ON m.codigo = p.modulo_codigo",
            "ON CONFLICT (codigo) DO UPDATE SET",
            "    modulo_id = EXCLUDED.modulo_id,",
            "    nombre = EXCLUDED.nombre,",
            "    orden = EXCLUDED.orden,",
            "    flag_estado = '1';",
            "",
            "-- 2) Opciones finales (hojas)",
            "WITH child_data AS (",
            "    SELECT * FROM (VALUES",
        ]
    )

    child_values = []
    orden_por_padre: dict[str, int] = {}
    for item in items:
        parent = item["parent_codigo"]
        orden_por_padre[parent] = orden_por_padre.get(parent, 0) + 1
        child_values.append(
            "        ("
            + f"{esc(parent)}, {esc(item['codigo'])}, {esc(item['nombre'])}, {esc(item['ruta'])}, {orden_por_padre[parent]}"
            + ")"
        )

    # Split child values in chunks for readability - PostgreSQL handles large VALUES
    lines.append(",\n".join(child_values))
    lines.extend(
        [
            "    ) AS t(parent_codigo, codigo, nombre, ruta, orden)",
            ")",
            "INSERT INTO auth.opcion_menu (modulo_id, codigo, nombre, ruta_frontend, opcion_padre_id, orden, flag_estado)",
            "SELECT p.modulo_id, c.codigo, c.nombre, c.ruta, p.id, c.orden, '1'",
            "FROM child_data c",
            "JOIN auth.opcion_menu p ON p.codigo = c.parent_codigo",
            "ON CONFLICT (codigo) DO UPDATE SET",
            "    modulo_id = EXCLUDED.modulo_id,",
            "    nombre = EXCLUDED.nombre,",
            "    ruta_frontend = EXCLUDED.ruta_frontend,",
            "    opcion_padre_id = EXCLUDED.opcion_padre_id,",
            "    orden = EXCLUDED.orden,",
            "    flag_estado = '1';",
            "",
            "-- 3) Rol ADMIN: todas las opciones activas",
            "INSERT INTO auth.rol_opcion_menu (rol_id, opcion_menu_id, flag_estado)",
            "SELECT r.id, om.id, '1'",
            "FROM auth.rol r",
            "JOIN master.empresa e ON e.id = r.empresa_id AND e.flag_estado = '1'",
            "CROSS JOIN auth.opcion_menu om",
            "WHERE r.codigo = 'ADMIN'",
            "  AND r.flag_estado = '1'",
            "  AND om.flag_estado = '1'",
            "ON CONFLICT (rol_id, opcion_menu_id) DO UPDATE SET flag_estado = '1';",
            "",
            "-- 4) Acciones ADMIN en hojas según sección padre",
            "INSERT INTO auth.rol_opcion_menu_accion (rol_opcion_menu_id, accion_id, permitido, flag_estado)",
            "SELECT rom.id, a.id, TRUE, '1'",
            "FROM auth.rol_opcion_menu rom",
            "JOIN auth.rol r ON r.id = rom.rol_id AND r.codigo = 'ADMIN' AND r.flag_estado = '1'",
            "JOIN auth.opcion_menu om ON om.id = rom.opcion_menu_id AND om.opcion_padre_id IS NOT NULL",
            "JOIN auth.opcion_menu parent ON parent.id = om.opcion_padre_id",
            "JOIN auth.accion a ON a.flag_estado = '1'",
            "WHERE rom.flag_estado = '1'",
            "  AND (",
            "    (parent.codigo LIKE '%\\_CONSULTAS' ESCAPE '\\' OR parent.codigo LIKE '%\\_REPORTES' ESCAPE '\\')",
            "    AND a.codigo = 'CONSULTAR'",
            "  OR (",
            "    parent.codigo NOT LIKE '%\\_CONSULTAS' ESCAPE '\\'",
            "    AND parent.codigo NOT LIKE '%\\_REPORTES' ESCAPE '\\'",
            "    AND a.codigo IN ('INSERTAR','MODIFICAR','ELIMINAR','CONSULTAR','ANULAR','CERRAR','PROCESAR','HOMOLOGAR','IMPORTAR','EXPORTAR')",
            "  ))",
            "ON CONFLICT (rol_opcion_menu_id, accion_id) DO UPDATE SET permitido = TRUE, flag_estado = '1';",
            "",
            "COMMIT;",
        ]
    )
    return "\n".join(lines) + "\n"


def main() -> None:
    lines = TXT_PATH.read_text(encoding="utf-8").splitlines()
    items = parse_tree(lines)
    parents = group_parents(items)
    sql = render_patch(parents, items)
    OUT_PATH.write_text(sql, encoding="utf-8")
    mods = sorted({i["modulo"] for i in items})
    print(f"Generado: {OUT_PATH}")
    print(f"Modulos: {len(mods)} -> {', '.join(mods)}")
    print(f"Padres: {len(parents)}, Hojas: {len(items)}")


if __name__ == "__main__":
    main()
