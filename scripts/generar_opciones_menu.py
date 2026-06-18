#!/usr/bin/env python3
"""
Genera opciones_menu.txt a partir de los objetos m_master de PowerBuilder en ws_objects.
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WS = ROOT / "ws_objects"
OUT = ROOT / "opciones_menu.txt"

# Modulos SIGRE principales (excluye duplicados web/nps/consola)
MODULE_FILES: dict[str, Path] = {
    "ALMACEN": WS / "Almacen/almacen_m.pbl.src/m_master.srm",
    "COMPRAS": WS / "Compras/compras_m.pbl.src/m_master.srm",
    "VENTAS": WS / "Comercializacion/comercializacion_m.pbl.src/m_master.srm",
    "FINANZAS": WS / "finanzas/finanzas_m.pbl.src/m_master.srm",
    "CONTABILIDAD": WS / "Contabilidad/Contabilidad_m.PBL.src/m_master.srm",
    "ACTIVOS FIJOS": WS / "Activo_Fijo/activo_m.pbl.src/m_master.srm",
    "RR.HH": WS / "Rrhh/rrhh_m.pbl.src/m_master.srm",
    "PRODUCCION": WS / "Produccion/produccion_m.pbl.src/m_master.srm",
    "PRESUPUESTO": WS / "Presupuesto/presupuesto_m.pbl.src/m_master.srm",
    "FLOTA": WS / "Flota/flota_m.pbl.src/m_master.srm",
    "MANTENIMIENTO": WS / "Mantenimiento/mantenimiento_m.pbl.src/m_master.srm",
    "AUDITORIA": WS / "Auditoria/auditoria_m.pbl.src/m_master.srm",
    "CAMPO": WS / "Campo/campo_m.pbl.src/m_master.srm",
    "COMEDOR": WS / "Comedor/comedor_m.pbl.src/m_master.srm",
    "SIG": WS / "sig/sig_m.pbl.src/m_master.srm",
    "SEGURIDAD": WS / "Seguridad/seguridad_m.pbl.src/m_master.srm",
    "HORECA": WS / "Horeca/horeca_m.pbl.src/m_master.srm",
    "OPERACIONES": WS / "Operaciones_ot/operaciones_ot_m.pbl.src/m_master.srm",
    "APROVISION": WS / "Aprovision/aprovision_m.pbl.src/m_master.srm",
    "ASISTENCIA": WS / "asistencia/asistencia_m.pbl.src/m_master.srm",
    "BASC": WS / "Basc/basc_m.pbl.src/m_master.srm",
}

SECTIONS = ("m_tablas", "m_operaciones", "m_consultas", "m_reportes", "m_procesos")
SECTION_LABELS = {
    "m_tablas": "TABLAS",
    "m_operaciones": "OPERACIONES",
    "m_consultas": "CONSULTAS",
    "m_reportes": "REPORTES",
    "m_procesos": "PROCESOS",
}

# Acciones estandar por tipo de menu de ventana (toolbar visible)
MENU_ACTIONS: dict[str, list[str]] = {}
DEFAULT_TABLAS = [
    "insertar", "modificar", "eliminar", "consultar", "anular", "cerrar",
    "procesar", "homologar", "importar", "exportar",
]
DEFAULT_OPER = ["insertar", "modificar", "eliminar", "consultar", "anular", "cerrar", "procesar"]
DEFAULT_PROC = ["consultar", "procesar", "anular", "cerrar"]

ACTION_LABELS = {
    "m_insertar": "insertar",
    "m_modificar": "modificar",
    "m_eliminar": "eliminar",
    "m_abrirlista": "consultar",
    "m_leerdata": "consultar",
    "m_anular": "anular",
    "m_cerrar": "cerrar",
    "m_grabar": "procesar",
    "m_cancelar": "cerrar",
    "m_duplicar": "insertar",
    "m_queryset": "consultar",
    "m_filter": "consultar",
    "m_filtroavanzado": "consultar",
    "m_sort": "consultar",
    "m_print1": "exportar",
    "m_grabarenexcel": "exportar",
    "m_saveas": "exportar",
    "m_homologar": "homologar",
    "m_importar": "importar",
    "m_exportar": "exportar",
    "m_procesar": "procesar",
}


@dataclass
class MenuNode:
    name: str
    type_id: str
    children: list[MenuNode] = field(default_factory=list)
    window: str | None = None
    section: str | None = None


def clean_label(text: str) -> str | None:
    text = text.strip()
    if not text or text == "-":
        return None
    text = re.sub(r"^\[[A-Z0-9]+\]\s*", "", text)
    text = text.replace("&", "")
    text = re.sub(r"~t.*$", "", text)  # quitar atajos ~tCtrl+...
    return text.strip() or None


def parse_menu_actions_from_srm(path: Path) -> list[str]:
    content = path.read_text(encoding="utf-8", errors="replace")
    actions: list[str] = []
    for m in re.finditer(
        r"type (m_\w+) from m_master`m_\w+ within m_\w+\s+end type\s+"
        r"(?:.*?)on \1\.create\s+call super::create\s+(.*?)\nend on",
        content,
        re.DOTALL,
    ):
        item = m.group(1)
        body = m.group(2)
        label = ACTION_LABELS.get(item)
        if not label:
            continue
        visible = "toolbaritemvisible = true" in body or "enabled = true" in body
        if visible and label not in actions:
            actions.append(label)
    return actions


def index_menu_files() -> None:
    for srm in WS.rglob("m_*.srm"):
        if "m_master" in srm.name and srm.name != "m_master.srm":
            continue
        if "`" in srm.read_text(encoding="utf-8", errors="replace")[:200]:
            pass
        name = srm.stem
        if name in MENU_ACTIONS:
            continue
        actions = parse_menu_actions_from_srm(srm)
        if actions:
            MENU_ACTIONS[name] = actions


def infer_actions(section: str, menuname: str | None) -> list[str]:
    if section in ("m_consultas", "m_reportes"):
        return ["consultar"]
    if section == "m_tablas":
        if menuname == "m_abc_param":
            return ["insertar", "modificar", "eliminar", "consultar", "anular", "cerrar", "procesar", "exportar"]
        return DEFAULT_TABLAS[:]
    if section == "m_operaciones":
        if menuname and menuname in MENU_ACTIONS and len(MENU_ACTIONS[menuname]) >= 5:
            return MENU_ACTIONS[menuname][:]
        return DEFAULT_OPER[:]
    if section == "m_procesos":
        if menuname and menuname in MENU_ACTIONS and len(MENU_ACTIONS[menuname]) >= 2:
            return MENU_ACTIONS[menuname][:]
        return DEFAULT_PROC[:]
    return ["consultar"]


def window_menuname(window: str, module_dir: Path) -> str | None:
    if not window:
        return None
    for wdir in module_dir.parent.glob("*_w.pbl.src"):
        wfile = wdir / f"{window}.srw"
        if not wfile.exists():
            continue
        content = wfile.read_text(encoding="utf-8", errors="replace")
        m = re.search(r'string menuname = "([^"]+)"', content)
        if m:
            return m.group(1)
    return None


def parse_m_master(path: Path) -> dict[str, MenuNode]:
    content = path.read_text(encoding="utf-8", errors="replace")
    nodes: dict[str, MenuNode] = {}

    # Padres directos (sin herencia backtick)
    parent_of: dict[str, str] = {}
    for m in re.finditer(r"^type (\w+) from menu within (\w+)\s*$", content, re.MULTILINE):
        child, parent = m.group(1), m.group(2)
        if "`" in child:
            continue
        parent_of[child] = parent

    # Texto y ventana por tipo
    texts: dict[str, str] = {}
    windows: dict[str, str] = {}
    for m in re.finditer(r"^type (\w+) from menu within (\w+)\s*$", content, re.MULTILINE):
        tid = m.group(1)
        start = m.end()
        chunk = content[start : start + 4000]
        tm = re.search(r'on ' + re.escape(tid) + r"\.create[\s\S]*?this\.text = \"([^\"]*)\"", chunk)
        if tm:
            texts[tid] = tm.group(1)
        wm = re.search(r"event clicked;\s*OpenSheet\s*\(\s*(w_\w+)", chunk, re.IGNORECASE)
        if wm:
            windows[tid] = wm.group(1)

    # Orden de hijos
    child_order: dict[str, list[str]] = {}
    for m in re.finditer(r"^on (\w+)\.create\s*$", content, re.MULTILINE):
        parent = m.group(1)
        start = m.end()
        end = content.find("\nend on", start)
        block = content[start:end]
        order = re.findall(r"this\.Item\[UpperBound\(this\.Item\)\+1\]=this\.(\w+)", block)
        if order:
            child_order[parent] = order

    def build(tid: str, section: str | None) -> MenuNode | None:
        raw = texts.get(tid, tid)
        label = clean_label(raw)
        if label is None:
            return None
        sec = section or (tid if tid in SECTIONS else None)
        node = MenuNode(name=label, type_id=tid, window=windows.get(tid), section=sec)
        nodes[tid] = node
        for cid in child_order.get(tid, []):
            child = build(cid, sec if tid in SECTIONS else section)
            if child:
                node.children.append(child)
        return node

    sections: dict[str, MenuNode] = {}
    for sec in SECTIONS:
        root = build(sec, sec)
        if root and root.children:
            sections[sec] = root
    return sections


def render_actions(actions: list[str], indent: str) -> list[str]:
    return [f"{indent}└─ Acciones: {', '.join(actions)}"]


def render_nodes(nodes: list[MenuNode], depth: int, section: str, module_dir: Path, lines: list[str]) -> None:
    visible = [n for n in nodes if n.name]
    for i, node in enumerate(visible):
        is_last = i == len(visible) - 1
        branch = "└─" if is_last else "├─"
        pad = "  " * depth
        if node.children:
            lines.append(f"{pad}{branch} {node.name}")
            render_nodes(node.children, depth + 1, section, module_dir, lines)
        else:
            lines.append(f"{pad}{branch} {node.name}")
            menuname = None
            if node.window:
                menuname = window_menuname(node.window, module_dir)
            actions = infer_actions(section, menuname)
            action_pad = pad + ("   " if is_last else "│  ")
            lines.extend(render_actions(actions, action_pad))


def render_module(name: str, path: Path, lines: list[str]) -> None:
    if not path.exists():
        lines.append(f"(archivo no encontrado: {path})")
        return
    sections = parse_m_master(path)
    lines.append("=" * 60)
    lines.append(f"MODULO: {name}")
    lines.append("=" * 60)
    for sec in SECTIONS:
        root = sections.get(sec)
        if not root or not root.children:
            continue
        lines.append(f"[{SECTION_LABELS[sec]}]")
        render_nodes(root.children, 0, sec, path.parent, lines)
        lines.append("")


def main() -> None:
    index_menu_files()
    lines = [
        "OPCIONES DE MENU - SIGRE",
        "Fuente canonica: ws_objects/*/m_master.srm (PowerBuilder)",
        f"Generado: {date.today().isoformat()}",
        "",
        "Notas:",
        "- Estructura en arbol: menu > submenu > opcion > acciones.",
        "- [TABLAS], [OPERACIONES] y [PROCESOS]: acciones segun menu de ventana (m_*).",
        "- [CONSULTAS] y [REPORTES]: solo accion consultar.",
        "- Separadores (-) y opciones sin texto se omiten.",
        "",
    ]
    for mod_name, mod_path in MODULE_FILES.items():
        render_module(mod_name, mod_path, lines)
    OUT.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")
    print(f"Generado: {OUT} ({OUT.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
