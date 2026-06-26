#!/usr/bin/env python3
"""Analiza tablas involucradas en usp_rh_cal_calcula_planilla vs DDL PostgreSQL."""
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent.parent.parent  # restaurante.pe
SIGRE = ROOT / "metadata SIGRE" / "schema_SIGRE"
DDL = ROOT / "restpe-contabilidad-back-end" / "03. Base de datos" / "ddl" / "tenant"

MAPPING = {
    "maestro": ("rrhh.trabajador", "ok"),
    "calculo": ("rrhh.calculo_det", "partial", "SIGRE calculo = detalle por trab/concepto/fecha; no es rrhh.calculo cabecera"),
    "rrhh_param_org": ("rrhh.fechas_proceso", "ok"),
    "rrhhparam": ("rrhh.configuracion (source=RRHHPARAM)", "ok"),
    "rrhhparam_cconcep": ("rrhh.configuracion (source=RRHHPARAM_CCONCEP)", "ok"),
    "calendario": ("core.tipo_cambio", "partial", "vta_dol_prom por fecha"),
    "calendario_feriado": ("core.calendario_feriado", "ok"),
    "fl_param": ("FALTA rrhh.parametros_flota", "missing", "conceptos CTS/grati/vac flota"),
    "grupo_calculo": ("rrhh.grupo_conceptos_planilla", "partial", "estructura distinta; falta concepto_gen"),
    "grupo_calculo_det": ("FALTA rrhh.grupo_conceptos_planilla_det", "missing", "mapeo concepto_calc por grupo"),
    "concepto": ("rrhh.concepto_planilla", "partial", "SIGRE usa codigo concep; falta columnas calculo"),
    "seccion": ("rrhh.seccion", "ok"),
    "admin_afp": ("rrhh.admin_afp", "ok"),
    "asistencia": ("rrhh.asistencia", "excluded", "solo JOR/DES; EMP sueldo no la usa"),
    "asistparam": ("FALTA rrhh.parametros_asistencia", "excluded", "solo JOR/DES; tardanzas EMP usan inasistencia + rrhhparam_cconcep"),
    "inasistencia": ("rrhh.inasistencia", "partial", "falta flag_vacac_adelantadas, fec_movim"),
    "gan_desct_fijo": ("rrhh.gan_desct_fijo", "ok"),
    "gan_desct_variable": ("rrhh.gan_desct_variable", "ok"),
    "cnta_crrte": ("rrhh.cnta_crrte", "ok"),
    "cnta_crrte_detalle": ("rrhh.cnta_crrte_det", "ok"),
    "quinta_categoria": ("rrhh.quinta_categoria", "ok", "esquema SIGRE fec_proceso + rem_*"),
    "tipo_trabajador": ("rrhh.tipo_trabajador", "ok"),
    "uit": ("core.uit", "ok"),
    "rrhh_impuesto_renta": ("rrhh.impuesto_renta_tramos", "ok"),
    "historico_calculo": ("rrhh.calculo + rrhh.calculo_det", "ok", "sin tabla historica; usar boletas previas"),
    "calculo_judicial": ("rrhh.calculo_judicial", "ok"),
    "judicial": ("rrhh.retencion_judicial", "ok"),
    "adelanto_quincena": ("rrhh.adelanto_quincena", "ok"),
    "gratificacion_det": ("FALTA rrhh.gratificacion_det", "missing", "detalle gratificacion"),
    "rmv_x_tipo_trabaj": ("rrhh.remuneracion_minima_vital", "ok"),
    "fl_asistencia": ("FALTA rrhh.asistencia_flota", "missing", "asistencia tripulantes"),
    "fl_dias_motorista": ("FALTA rrhh.dias_motorista", "missing", "dias motorista por mes"),
    "fl_participacion_pesca": ("FALTA rrhh.participacion_pesca", "missing", "participacion pesca tripulantes"),
    "grupo_calc_x_seccion": ("rrhh.grupo_conceptos_seccion", "ok"),
    "historico_distrib_cntble": ("contabilidad.distribucion_contable", "partial", "integracion contable"),
    "matriz_transf_cntbl_cencos": ("FALTA contabilidad.matriz_transf_cencos_rrhh", "missing"),
    "cntbl_cnta": ("contabilidad.plan_contable_det", "partial"),
    "cntbl_pre_asiento_det": ("contabilidad.cntbl_preasiento_det", "partial", "asientos automaticos"),
    "prod_param": ("FALTA core.parametros_produccion", "missing"),
    "semanas": ("N/A", "excluded", "no requerido; essalud_vida sin calendario semanal"),
    "tg_pd_destajo": ("FALTA rrhh.tarifa_destajo", "missing", "destajo pesca"),
    "utlparam": ("rrhh.configuracion (source=UTLPARAM)", "ok"),
    "origen": ("auth.sucursal / core", "partial", "cod_origen CH/LM"),
    "permiso": ("rrhh.permiso_licencia_det", "partial"),
    "vacaciones": ("rrhh.vacacion", "partial"),
    "control_subsidio": ("rrhh.control_subsidio", "partial"),
}


def load_pg_tables() -> set[str]:
    tables: set[str] = set()
    for name in ["07-rrhh.sql", "01-core.sql", "06-contabilidad.sql", "05-finanzas.sql"]:
        text = (DDL / name).read_text(encoding="utf-8", errors="replace")
        for m in re.finditer(r"CREATE TABLE (?:IF NOT EXISTS )?([a-z_]+\.[a-z_0-9]+)", text, re.I):
            tables.add(m.group(1).lower())
    return tables


def load_sigre_tables() -> set[str]:
    text = (SIGRE / "tablas_cantabria.sql").read_text(encoding="utf-8", errors="replace")
    return {m.group(1).lower() for m in re.finditer(r"create table cantabria\.(\w+)", text, re.I)}


def load_call_tree_bodies() -> dict[str, str]:
    proc_text = (SIGRE / "procedures_cantabria.sql").read_text(encoding="utf-8", errors="replace")
    func_text = (SIGRE / "funciones_cantabria.sql").read_text(encoding="utf-8", errors="replace")
    combined = proc_text + "\n" + func_text
    pattern = re.compile(r"create or replace (?:procedure|function)\s+cantabria\.(\w+)\s*\(", re.I)
    positions = sorted([(m.group(1).lower(), m.start()) for m in pattern.finditer(combined)], key=lambda x: x[1])
    idx = {n: p for n, p in positions}
    source_map = {n: (func_text if n.startswith("usf_") else proc_text) for n, _ in positions}

    def get_body(name: str) -> str:
        if name not in idx:
            return ""
        start = idx[name]
        src = source_map[name]
        sub = src[start : start + 800_000]
        m = re.search(rf"\bend\s+{re.escape(name)}\s*;", sub, re.I)
        return sub[: m.end()] if m else sub[:30_000]

    queue = ["usp_rh_cal_calcula_planilla"]
    seen: set[str] = set()
    bodies: dict[str, str] = {}
    while queue:
        name = queue.pop(0)
        if name in seen:
            continue
        seen.add(name)
        body = get_body(name)
        if body:
            bodies[name] = body
            for called in re.findall(r"\b(usp_rh_cal_[a-z0-9_]+|usf_rh_cal_[a-z0-9_]+)\b", body, re.I):
                c = called.lower()
                if c not in seen:
                    queue.append(c)
    return bodies


def main() -> None:
    sigre_tables = load_sigre_tables()
    pg_tables = load_pg_tables()
    bodies = load_call_tree_bodies()
    pkg = (SIGRE / "package_body_cantabria.sql").read_text(encoding="utf-8", errors="replace")
    pkg_m = re.search(r"package body cantabria\.usp_sigre_rrhh\b(.*)\nend usp_sigre_rrhh", pkg, re.I | re.S)
    all_sql = "\n".join(bodies.values()) + (pkg_m.group(1) if pkg_m else "")

    used = {t for t in sigre_tables if re.search(rf"\b{re.escape(t)}\b", all_sql, re.I)}

    print("=== ARBOL DE PROCEDIMIENTOS ===")
    print(f"Procedimientos/funciones en arbol: {len(bodies)}")
    for n in sorted(bodies):
        print(f"  - {n}")

    print("\n=== PAQUETE USP_SIGRE_RRHH (constantes y helpers) ===")
    helpers = sorted(set(re.findall(r"USP_SIGRE_RRHH\.(\w+)", all_sql, re.I)))
    for h in helpers[:30]:
        print(f"  - {h}")
    if len(helpers) > 30:
        print(f"  ... y {len(helpers)-30} mas")

    print(f"\n=== TABLAS SIGRE REFERENCIADAS: {len(used)} ===")

    ok, partial, missing, unmapped = [], [], [], []
    for t in sorted(used):
        if t in MAPPING:
            target, status, *note = MAPPING[t]
            note_s = note[0] if note else ""
            entry = (t, target, note_s)
            if status == "ok":
                ok.append(entry)
            elif status == "partial":
                partial.append(entry)
            else:
                missing.append(entry)
        else:
            auto = f"rrhh.{t}"
            if auto in pg_tables:
                ok.append((t, auto, "auto"))
            else:
                unmapped.append((t, "REVISAR"))

    print(f"\nOK ({len(ok)}):")
    for t, target, note in ok:
        print(f"  {t:30} -> {target}")

    print(f"\nPARCIAL ({len(partial)}):")
    for t, target, note in partial:
        print(f"  {t:30} -> {target} | {note}")

    print(f"\nFALTANTES ({len(missing)}):")
    for t, target, note in missing:
        print(f"  {t:30} -> {target} | {note}")

    if unmapped:
        print(f"\nSIN MAPEO EXPLICITO ({len(unmapped)}):")
        for t, _ in unmapped:
            print(f"  {t}")

    print("\n=== RESUMEN ===")
    print(f"Tablas SIGRE usadas: {len(used)}")
    print(f"  OK: {len(ok)} | Parcial: {len(partial)} | Faltantes: {len(missing)} | Sin mapeo: {len(unmapped)}")
    print(f"Procedimientos a portar: {len(bodies)} + paquete USP_SIGRE_RRHH + PKG_CONFIG")


if __name__ == "__main__":
    main()
