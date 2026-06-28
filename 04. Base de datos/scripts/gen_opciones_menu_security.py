#!/usr/bin/env python3
"""Genera seed SQL con TODAS las opciones de menu desde opciones_menu.txt.

Preserva la jerarquia COMPLETA del arbol (sin tope de niveles):
    MODULO -> [SECCION] -> (submenu...) -> item(hoja con ruta)
La profundidad se deduce de la INDENTACION (columna del glifo del arbol),
no de contar los caracteres de caja. Las hojas (lineas con "Acciones:")
llevan ruta_frontend; los nodos intermedios son submenus sin ruta.
"""

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
    "ALMACEN": "ALMACEN", "COMPRAS": "COMPRAS", "APROVISIONAMIENTO": "APROV",
    "COMERCIALIZACION": "COMERC", "FINANZAS": "FINANZAS", "CONTABILIDAD": "CONTA",
    "ACTIVOS_FIJOS": "ACTIVOS", "RRHH": "RRHH", "PRODUCCION": "PRODUCCION",
    "PRESUPUESTO": "PRESUP", "FLOTA": "FLOTA", "MANTENIMIENTO": "MANT",
    "AUDITORIA": "AUDIT", "CAMPO": "CAMPO", "COMEDOR": "COMEDOR", "SIG": "SIG",
    "OPERACIONES": "OPER", "HORECA": "HORECA", "SEGURIDAD": "SEG", "ASISTENCIA": "ASIST",
}

PARENT_PREFIX = {
    "ALMACEN": "ALMACEN", "COMPRAS": "COMPRAS", "APROVISIONAMIENTO": "APROV",
    "COMERCIALIZACION": "COMERC", "FINANZAS": "FINANZAS", "CONTABILIDAD": "CONTABILIDAD",
    "ACTIVOS_FIJOS": "ACTIVOS", "RRHH": "RRHH", "PRODUCCION": "PRODUCCION",
    "PRESUPUESTO": "PRESUP", "FLOTA": "FLOTA", "MANTENIMIENTO": "MANT",
    "AUDITORIA": "AUDIT", "CAMPO": "CAMPO", "COMEDOR": "COMEDOR", "SIG": "SIG",
    "OPERACIONES": "OPER", "HORECA": "HORECA", "SEGURIDAD": "SEGURIDAD", "ASISTENCIA": "ASISTENCIA",
}

SECTION_ORDER = {"TABLAS": 1, "OPERACIONES": 2, "CONSULTAS": 3, "REPORTES": 4, "PROCESOS": 5}
SECTION_KEY = {"TABLAS": "TABLAS", "OPERACIONES": "OPERACIONES", "CONSULTAS": "CONSULTAS",
               "REPORTES": "REPORTES", "PROCESOS": "PROCESOS"}
SECTION_LABEL = {"TABLAS": "Tablas", "OPERACIONES": "Operaciones", "CONSULTAS": "Consultas",
                 "REPORTES": "Reportes", "PROCESOS": "Procesos"}
SECTION_ROUTE = {"TABLAS": "tablas", "OPERACIONES": "operaciones", "CONSULTAS": "consultas",
                 "REPORTES": "reportes", "PROCESOS": "procesos"}

MOD_ROUTE = {
    "ALMACEN": "almacen", "COMPRAS": "compras", "APROVISIONAMIENTO": "aprovisionamiento",
    "COMERCIALIZACION": "comercializacion", "FINANZAS": "finanzas", "CONTABILIDAD": "contabilidad",
    "ACTIVOS_FIJOS": "activos-fijos", "RRHH": "rrhh", "PRODUCCION": "produccion",
    "PRESUPUESTO": "presupuesto", "FLOTA": "flota", "MANTENIMIENTO": "mantenimiento",
    "AUDITORIA": "auditoria", "CAMPO": "campo", "COMEDOR": "comedor", "SIG": "sig",
    "OPERACIONES": "operaciones", "HORECA": "horeca", "SEGURIDAD": "configuracion",
    "ASISTENCIA": "asistencia",
}

SKIP_NAMES = {"m_", "m_ap021proveedores"}

NODE_RE = re.compile(r"^([ \t│]*)([├└])─?\s*(.*)$")  # prefix + (├|└) + ─ + label


def esc(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def slugify(text: str, max_len: int = 50) -> str:
    text = re.sub(r"^\([^)]+\)\s*", "", text.strip())
    text = unicodedata.normalize("NFKD", text)
    text = text.encode("ascii", "ignore").decode("ascii")
    text = re.sub(r"[^a-zA-Z0-9]+", "-", text).strip("-").lower()
    if not text:
        text = "opcion"
    return text[:max_len].strip("-")


def section_codigo(mod: str, section: str) -> str:
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
    """Devuelve nodos en orden documental. Cada nodo:
    {modulo, section, codigo, nombre, parent_codigo|None, ruta|None, orden, depth, is_section}
    """
    nodes: list[dict] = []
    used_codes: set[str] = set()
    used_routes: set[str] = set()
    orden_por_padre: dict[str, int] = {}

    current_mod: str | None = None
    current_section: str | None = None
    section_node: dict | None = None
    # stack de (indent, node) — incluye el nodo seccion como raiz (indent -1)
    stack: list[tuple[int, dict]] = []

    def next_orden(parent_codigo: str | None) -> int:
        key = parent_codigo or "__root__"
        orden_por_padre[key] = orden_por_padre.get(key, 0) + 1
        return orden_por_padre[key]

    for raw in lines:
        line = raw.rstrip("\n")

        if line.startswith("MODULO:"):
            name = line.split(":", 1)[1].strip()
            current_mod = MODULE_MAP.get(name, name).replace(" ", "_").upper()
            current_section = None
            section_node = None
            stack = []
            continue

        sec_match = re.match(r"^\[(.+)\]$", line.strip())
        if sec_match and current_mod:
            current_section = sec_match.group(1).strip().upper()
            cod = section_codigo(current_mod, current_section)
            used_codes.add(cod)
            label = SECTION_LABEL.get(current_section, current_section.title())
            section_node = {
                "modulo": current_mod, "section": current_section, "codigo": cod,
                "nombre": label, "parent_codigo": None, "ruta": None,
                "orden": SECTION_ORDER.get(current_section, 99), "depth": 0,
                "is_section": True, "path_slugs": [],
            }
            nodes.append(section_node)
            stack = [(-1, section_node)]
            continue

        if not current_mod or not current_section or section_node is None:
            continue

        if "Path:" in line:
            # ruta RELATIVA del componente Angular ya desarrollado para esta opcion
            if stack and not stack[-1][1].get("is_section"):
                val = line.split("Path:", 1)[1].strip().strip("/")
                if val:
                    stack[-1][1]["path_rel"] = val
            continue

        if "Acciones:" in line:
            # marca como hoja al ultimo nodo apilado y le asigna ruta
            if stack and not stack[-1][1].get("is_section"):
                leaf = stack[-1][1]
                leaf["is_leaf"] = True
                route_mod = MOD_ROUTE.get(current_mod, slugify(current_mod))
                route_sec = SECTION_ROUTE.get(current_section, slugify(current_section))
                path = "/".join(leaf["path_slugs"])
                ruta = f"/sigre/{route_mod}/{route_sec}/{path}"
                base_ruta = ruta
                n = 2
                while ruta in used_routes:
                    ruta = f"{base_ruta}-{n}"
                    n += 1
                used_routes.add(ruta)
                leaf["ruta"] = ruta
            continue

        m = NODE_RE.match(line)
        if not m:
            continue
        prefix, _glyph, label = m.groups()
        label = label.strip()
        if not label or label in SKIP_NAMES:
            continue
        indent = len(prefix)

        while stack and stack[-1][0] >= indent:
            stack.pop()
        if not stack:
            stack = [(-1, section_node)]
        parent = stack[-1][1]

        cod = make_codigo(current_mod, current_section, label, used_codes)
        node = {
            "modulo": current_mod, "section": current_section, "codigo": cod,
            "nombre": label, "parent_codigo": parent["codigo"], "ruta": None,
            "orden": next_orden(parent["codigo"]), "depth": len(stack),
            "is_section": False, "is_leaf": False,
            "path_slugs": parent.get("path_slugs", []) + [slugify(label)],
        }
        nodes.append(node)
        stack.append((indent, node))

    return nodes


def render_sql(nodes: list[dict]) -> str:
    L: list[str] = [
        "-- SEED: Catalogo completo auth.opcion_menu desde opciones_menu.txt",
        "-- Generado por 04. Base de datos/scripts/gen_opciones_menu_security.py",
        "-- Jerarquia COMPLETA: MODULO -> [SECCION] -> submenu(s) -> item(hoja con ruta).",
        "-- Idempotente (ON CONFLICT). Reset previo de flag_estado para ocultar opciones obsoletas.",
        "BEGIN;",
        "",
        "-- 0) Modulos ERP (19 menu) + ASISTENCIA",
        "INSERT INTO auth.modulo (codigo, nombre, flag_estado)",
        "VALUES",
        "    ('ALMACEN', 'Almacen', '1'),",
        "    ('COMPRAS', 'Compras', '1'),",
        "    ('APROVISIONAMIENTO', 'Aprovisionamiento', '1'),",
        "    ('COMERCIALIZACION', 'Comercializacion', '1'),",
        "    ('FINANZAS', 'Finanzas', '1'),",
        "    ('CONTABILIDAD', 'Contabilidad', '1'),",
        "    ('ACTIVOS_FIJOS', 'Activos fijos', '1'),",
        "    ('RRHH', 'RR.HH', '1'),",
        "    ('PRODUCCION', 'Produccion', '1'),",
        "    ('PRESUPUESTO', 'Presupuesto', '1'),",
        "    ('FLOTA', 'Flota', '1'),",
        "    ('MANTENIMIENTO', 'Mantenimiento', '1'),",
        "    ('AUDITORIA', 'Auditoria', '1'),",
        "    ('CAMPO', 'Campo', '1'),",
        "    ('COMEDOR', 'Comedor', '1'),",
        "    ('SIG', 'SIG', '1'),",
        "    ('OPERACIONES', 'Operaciones', '1'),",
        "    ('HORECA', 'Hoteles, Restaurantes y Catering', '1'),",
        "    ('SEGURIDAD', 'Seguridad', '1'),",
        "    ('ASISTENCIA', 'Asistencia', '1')",
        "ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, flag_estado = EXCLUDED.flag_estado;",
        "",
        "-- Reset autoritativo: todo a inactivo; las opciones vigentes se reactivan abajo.",
        "UPDATE auth.opcion_menu SET flag_estado = '0';",
        "",
    ]

    max_depth = max((n["depth"] for n in nodes), default=0)

    for depth in range(0, max_depth + 1):
        bucket = [n for n in nodes if n["depth"] == depth]
        if not bucket:
            continue
        if depth == 0:
            L.append(f"-- Nivel {depth}: secciones (opcion_padre_id = NULL)")
            L.append("WITH d AS (")
            L.append("    SELECT * FROM (VALUES")
            vals = [
                f"        ({esc(n['modulo'])}, {esc(n['codigo'])}, {esc(n['nombre'])}, {n['orden']})"
                for n in bucket
            ]
            L.append(",\n".join(vals))
            L.append("    ) AS t(modulo_codigo, codigo, nombre, orden)")
            L.append(")")
            L.append("INSERT INTO auth.opcion_menu (modulo_id, codigo, nombre, ruta_frontend, path_url, opcion_padre_id, orden, flag_estado)")
            L.append("SELECT m.id, d.codigo, d.nombre, NULL, NULL, NULL, d.orden, '1'")
            L.append("FROM d JOIN auth.modulo m ON m.codigo = d.modulo_codigo")
            L.append("ON CONFLICT (codigo) DO UPDATE SET")
            L.append("    modulo_id = EXCLUDED.modulo_id, nombre = EXCLUDED.nombre,")
            L.append("    ruta_frontend = NULL, path_url = NULL, opcion_padre_id = NULL, orden = EXCLUDED.orden, flag_estado = '1';")
            L.append("")
        else:
            L.append(f"-- Nivel {depth}: hijos")
            L.append("WITH d AS (")
            L.append("    SELECT * FROM (VALUES")
            vals = []
            for n in bucket:
                ruta = esc(n["ruta"]) if n["ruta"] else "NULL"
                path = esc(n["path_rel"]) if n.get("path_rel") else "NULL"
                vals.append(
                    f"        ({esc(n['parent_codigo'])}, {esc(n['codigo'])}, "
                    f"{esc(n['nombre'])}, {ruta}, {path}, {n['orden']})"
                )
            L.append(",\n".join(vals))
            L.append("    ) AS t(parent_codigo, codigo, nombre, ruta, path_url, orden)")
            L.append(")")
            L.append("INSERT INTO auth.opcion_menu (modulo_id, codigo, nombre, ruta_frontend, path_url, opcion_padre_id, orden, flag_estado)")
            L.append("SELECT p.modulo_id, d.codigo, d.nombre, d.ruta, d.path_url, p.id, d.orden, '1'")
            L.append("FROM d JOIN auth.opcion_menu p ON p.codigo = d.parent_codigo")
            L.append("ON CONFLICT (codigo) DO UPDATE SET")
            L.append("    modulo_id = EXCLUDED.modulo_id, nombre = EXCLUDED.nombre,")
            L.append("    ruta_frontend = EXCLUDED.ruta_frontend, path_url = EXCLUDED.path_url,")
            L.append("    opcion_padre_id = EXCLUDED.opcion_padre_id,")
            L.append("    orden = EXCLUDED.orden, flag_estado = '1';")
            L.append("")

    L.extend([
        "-- Rol ADMIN: todas las opciones activas",
        "INSERT INTO auth.rol_opcion_menu (rol_id, opcion_menu_id, flag_estado)",
        "SELECT r.id, om.id, '1'",
        "FROM auth.rol r",
        "JOIN master.empresa e ON e.id = r.empresa_id AND e.flag_estado = '1'",
        "CROSS JOIN auth.opcion_menu om",
        "WHERE r.codigo = 'ADMIN' AND r.flag_estado = '1' AND om.flag_estado = '1'",
        "ON CONFLICT (rol_id, opcion_menu_id) DO UPDATE SET flag_estado = '1';",
        "",
        "-- Acciones ADMIN en hojas (items con ruta). CONSULTAS/REPORTES => solo consultar.",
        "INSERT INTO auth.rol_opcion_menu_accion (rol_opcion_menu_id, accion_id, permitido, flag_estado)",
        "SELECT rom.id, a.id, TRUE, '1'",
        "FROM auth.rol_opcion_menu rom",
        "JOIN auth.rol r ON r.id = rom.rol_id AND r.codigo = 'ADMIN' AND r.flag_estado = '1'",
        "JOIN auth.opcion_menu om ON om.id = rom.opcion_menu_id AND om.ruta_frontend IS NOT NULL",
        "JOIN auth.accion a ON a.flag_estado = '1'",
        "WHERE rom.flag_estado = '1'",
        "  AND (",
        "    ((om.codigo LIKE '%\\_CONSULTAS\\_%' ESCAPE '\\' OR om.codigo LIKE '%\\_REPORTES\\_%' ESCAPE '\\')",
        "      AND a.codigo = 'CONSULTAR')",
        "    OR (om.codigo NOT LIKE '%\\_CONSULTAS\\_%' ESCAPE '\\'",
        "      AND om.codigo NOT LIKE '%\\_REPORTES\\_%' ESCAPE '\\'",
        "      AND a.codigo IN ('INSERTAR','MODIFICAR','ELIMINAR','CONSULTAR','ANULAR','CERRAR','PROCESAR','HOMOLOGAR','IMPORTAR','EXPORTAR'))",
        "  )",
        "ON CONFLICT (rol_opcion_menu_id, accion_id) DO UPDATE SET permitido = TRUE, flag_estado = '1';",
        "",
        "COMMIT;",
    ])
    return "\n".join(L) + "\n"


def main() -> None:
    lines = TXT_PATH.read_text(encoding="utf-8").splitlines()
    nodes = parse_tree(lines)
    sql = render_sql(nodes)
    OUT_PATH.write_text(sql, encoding="utf-8")
    mods = sorted({n["modulo"] for n in nodes})
    secciones = sum(1 for n in nodes if n.get("is_section"))
    hojas = sum(1 for n in nodes if n.get("is_leaf"))
    grupos = sum(1 for n in nodes if not n.get("is_section") and not n.get("is_leaf"))
    con_path = sum(1 for n in nodes if n.get("path_rel"))
    maxd = max((n["depth"] for n in nodes), default=0)
    print(f"Generado: {OUT_PATH}")
    print(f"Items con path_url (conciliados a componente): {con_path}")
    print(f"Modulos: {len(mods)} -> {', '.join(mods)}")
    print(f"Secciones: {secciones}, Submenus(grupos): {grupos}, Items(hojas): {hojas}, Total filas: {len(nodes)}")
    print(f"Profundidad maxima (sin contar modulo): {maxd}")


if __name__ == "__main__":
    main()
