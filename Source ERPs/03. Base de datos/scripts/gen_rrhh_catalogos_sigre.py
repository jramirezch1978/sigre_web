#!/usr/bin/env python3
"""Genera DDL, seed, backend Java y frontend Angular para catálogos RRHH SIGRE."""
from __future__ import annotations

import json
import re
import textwrap
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "data"
DDL = ROOT / "ddl" / "tenant" / "07-rrhh.sql"
SEED = ROOT / "ddl" / "seed" / "05-seed-catalogos-trabajador-sigre.sql"
BACKEND = Path(__file__).resolve().parents[2] / "02. Backend" / "ms-rrhh" / "src" / "main" / "java" / "pe" / "restaurant" / "rrhh"
FRONTEND = Path(__file__).resolve().parents[3] / "restpe-contabilidad-front-end" / "src" / "app" / "modules" / "rrhh"

AUDIT = """
    created_by          BIGINT,
    fec_creacion        TIMESTAMPTZ     DEFAULT NOW(),
    updated_by          BIGINT,
    fec_modificacion    TIMESTAMPTZ,"""

CATALOGS = [
    {
        "table": "tipo_sangre", "entity": "TipoSangre", "api": "tipos-sangre", "route": "tipo-sangre",
        "menu": "Tipos de sangre", "prefix": "ts", "grid": "tipo_sangre", "err": "RH-TS",
        "json_file": "TIPO_SANGRE.json", "json_key": "TIPO_SANGRE",
        "codigo": "COD_TIPO_SANGRE", "nombre": "DESC_SANGRE",
    },
    {
        "table": "pension_rtps", "entity": "PensionRtps", "api": "pensiones-rtps", "route": "pension-rtps",
        "menu": "Pensiones RTPS (PLAME)", "prefix": "pr", "grid": "pension_rtps", "err": "RH-PR",
        "json_file": "RRHH_PENSIONES_RTPS.json", "json_key": "RRHH_PENSIONES_RTPS",
        "codigo": "COD_PENSION_RTPS", "nombre": "DESC_PENSION_RTPS",
    },
    {
        "table": "regimen_pensionario", "entity": "RegimenPensionario", "api": "regimenes-pensionario",
        "route": "regimen-pensionario", "menu": "Régimen pensionario RTPS", "prefix": "rp", "grid": "regimen_pensionario",
        "err": "RH-RP", "json_file": "RRHH_REGIMEN_PENSIONARIO_RTPS.json", "json_key": "RRHH_REGIMEN_PENSIONARIO_RTPS",
        "codigo": "COD_REG_PENSION", "nombre": "DESCRIPCION",
    },
    {
        "table": "tipo_trabajador", "entity": "TipoTrabajador", "api": "tipos-trabajador", "route": "tipo-trabajador",
        "menu": "Tipos de trabajador (sistema)", "prefix": "tt", "grid": "tipo_trabajador", "err": "RH-TT",
        "json_file": "TIPO_TRABAJADOR.json", "json_key": "TIPO_TRABAJADOR",
        "codigo": "TIPO_TRABAJADOR", "nombre": "DESC_TIPO_TRA", "complex": True,
    },
    {
        "table": "tipo_trabajador_rtps", "entity": "TipoTrabajadorRtps", "api": "tipos-trabajador-rtps",
        "route": "tipo-trabajador-rtps", "menu": "Tipos de trabajador RTPS (PLAME)", "prefix": "ttr",
        "grid": "tipo_trabajador_rtps", "err": "RH-TTR",
        "json_file": "RRHH_TIPO_TRABAJADORES_RTPS.json", "json_key": "RRHH_TIPO_TRABAJADORES_RTPS",
        "codigo": "COD_TIP_TRAB", "nombre": "DESCRIPCION", "extra_entity": [("flagPensionista", "flag_pensionista", "String", 1)],
    },
    {
        "table": "ocupacion_rtps", "entity": "OcupacionRtps", "api": "ocupaciones-rtps", "route": "ocupacion-rtps",
        "menu": "Ocupaciones RTPS", "prefix": "or", "grid": "ocupacion_rtps", "err": "RH-OR",
        "json_file": "RRHH_OCUPACION_RTPS.json", "json_key": "RRHH_OCUPACION_RTPS",
        "codigo": "COD_OCUPACION_RTPS", "nombre": "DESC_OCUPACION",
    },
    {
        "table": "seccion", "entity": "Seccion", "api": "secciones", "route": "seccion",
        "menu": "Secciones", "prefix": "se", "grid": "seccion", "err": "RH-SE",
        "json_file": "SECCION.json", "json_key": "SECCION",
        "codigo": "COD_SECCION", "nombre": "DESC_SECCION", "seccion": True,
    },
    {
        "table": "motivo_cese", "entity": "MotivoCese", "api": "motivos-cese", "route": "motivo-cese",
        "menu": "Motivos de cese", "prefix": "mc", "grid": "motivo_cese", "err": "RH-MC",
        "json_file": "MOTIVO_CESE.json", "json_key": "MOTIVO_CESE",
        "codigo": "COD_MOTIV_CESE", "nombre": "DESC_MOTIV_CESE",
    },
    {
        "table": "tipo_via", "entity": "TipoVia", "api": "tipos-via", "route": "tipo-via",
        "menu": "Tipos de vía (RTPS)", "prefix": "tv", "grid": "tipo_via", "err": "RH-TV",
        "json_file": "RRHH_VIAS_RTPS.json", "json_key": "RRHH_VIAS_RTPS",
        "codigo": "COD_VIA", "nombre": "DESC_VIA",
    },
    {
        "table": "tipo_zona", "entity": "TipoZona", "api": "tipos-zona", "route": "tipo-zona",
        "menu": "Tipos de zona (RTPS)", "prefix": "tz", "grid": "tipo_zona", "err": "RH-TZ",
        "json_file": "RRHH_ZONAS_RTPS.json", "json_key": "RRHH_ZONAS_RTPS",
        "codigo": "COD_ZONA", "nombre": "DESC_ZONA",
    },
    {
        "table": "tipo_vivienda", "entity": "TipoVivienda", "api": "tipos-vivienda", "route": "tipo-vivienda",
        "menu": "Tipos de vivienda", "prefix": "tvi", "grid": "tipo_vivienda", "err": "RH-TVI",
        "json_file": "VIVIENDA.json", "json_key": "VIVIENDA",
        "codigo": "COD_VIVIENDA", "nombre": "DESC_VIVIENDA",
    },
]


def sql_str(value):
    if value is None:
        return "NULL"
    text = str(value).strip()
    if not text:
        return "NULL"
    return "'" + text.replace("'", "''") + "'"


def sql_numeric(value, default="0"):
    if value is None or str(value).strip() == "":
        return default
    return str(value)


def snake(name: str) -> str:
    s1 = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", name)
    return re.sub("([a-z0-9])([A-Z])", r"\1_\2", s1).lower()


def gen_ddl_block() -> str:
    lines = [
        "",
        "-- ============================================================",
        "-- Catálogos SIGRE para maestro de trabajadores (idempotente)",
        "-- ============================================================",
        "",
        "ALTER TABLE rrhh.area ADD COLUMN IF NOT EXISTS codigo VARCHAR(10);",
        "CREATE UNIQUE INDEX IF NOT EXISTS UQ_AREA_CODIGO ON rrhh.area (codigo) WHERE codigo IS NOT NULL;",
        "",
    ]
    simple_tpl = """CREATE TABLE IF NOT EXISTS rrhh.{table} (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',{audit}
    CONSTRAINT PK_{pk} PRIMARY KEY (id),
    CONSTRAINT UQ_{pk}_CODIGO UNIQUE (codigo)
);
"""
    for cat in CATALOGS:
        pk = cat["table"].upper()
        if cat.get("complex"):
            lines.append("""CREATE TABLE IF NOT EXISTS rrhh.tipo_trabajador (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    flag_emision_boleta VARCHAR(1),
    libro_planilla INTEGER,
    dias_trab_hab_fijo INTEGER,
    factor_costo_hr NUMERIC(10, 4),
    flag_sector_agrario VARCHAR(1),
    periodo_boleta VARCHAR(1),
    flag_ingreso_boleta VARCHAR(1),
    flag_replicacion VARCHAR(1) NOT NULL DEFAULT '1',
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',""" + AUDIT + """
    CONSTRAINT PK_TIPO_TRABAJADOR PRIMARY KEY (id),
    CONSTRAINT UQ_TIPO_TRABAJADOR_CODIGO UNIQUE (codigo)
);
""")
            continue
        if cat.get("seccion"):
            lines.append("""CREATE TABLE IF NOT EXISTS rrhh.seccion (
    id BIGSERIAL NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    area_id BIGINT NOT NULL,
    porc_sctr_onp NUMERIC(4, 2) NOT NULL DEFAULT 0,""" + AUDIT + """
    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
    CONSTRAINT PK_SECCION PRIMARY KEY (id),
    CONSTRAINT UQ_SECCION_AREA_CODIGO UNIQUE (area_id, codigo)
);
DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='fk_seccion_area')
    THEN ALTER TABLE rrhh.seccion ADD CONSTRAINT fk_seccion_area FOREIGN KEY (area_id) REFERENCES rrhh.area(id);
END IF; END $$;
ALTER TABLE rrhh.seccion ADD COLUMN IF NOT EXISTS porc_sctr_onp NUMERIC(4, 2) DEFAULT 0;
UPDATE rrhh.seccion SET porc_sctr_onp = 0 WHERE porc_sctr_onp IS NULL;
ALTER TABLE rrhh.seccion ALTER COLUMN porc_sctr_onp SET NOT NULL;
ALTER TABLE rrhh.seccion ALTER COLUMN porc_sctr_onp SET DEFAULT 0;
""")
            continue
        extra_cols = ""
        if cat.get("extra_entity"):
            for _, col, typ, length in cat["extra_entity"]:
                if typ == "String":
                    extra_cols += f"\n    {col} VARCHAR({length}),"
        lines.append(simple_tpl.format(table=cat["table"], pk=pk, audit=AUDIT + extra_cols))

    lines.append(gen_trabajador_alter())
    return "\n".join(lines)


def gen_trabajador_alter() -> str:
    cols = [
        ("nombre1", "VARCHAR(60)"),
        ("nombre2", "VARCHAR(60)"),
        ("alergias", "VARCHAR(300)"),
        ("tipo_sangre_id", "BIGINT"),
        ("foto_blob", "BYTEA"),
        ("dni_blob", "BYTEA"),
        ("nro_brevete", "VARCHAR(30)"),
        ("autogenerado_essalud", "VARCHAR(30)"),
        ("celular1", "VARCHAR(40)"),
        ("celular2", "VARCHAR(40)"),
        ("codigo_tel_ciudad", "VARCHAR(10)"),
        ("flag_discapacidad", "VARCHAR(1) NOT NULL DEFAULT '0'"),
        ("flag_domiciliado", "VARCHAR(1) NOT NULL DEFAULT '1'"),
        ("flag_comision_afp", "VARCHAR(1) NOT NULL DEFAULT '0'"),
        ("flag_pensionista", "VARCHAR(1) NOT NULL DEFAULT '0'"),
        ("flag_afiliado_eps", "VARCHAR(1) NOT NULL DEFAULT '0'"),
        ("flag_essalud_vida", "VARCHAR(1) NOT NULL DEFAULT '0'"),
        ("flag_sctr_pension", "VARCHAR(1) NOT NULL DEFAULT '0'"),
        ("flag_sctr_salud", "VARCHAR(1) NOT NULL DEFAULT '0'"),
        ("flag_quinta_exonerado", "VARCHAR(1) NOT NULL DEFAULT '0'"),
        ("distrito_id", "BIGINT"),
        ("tipo_via_id", "BIGINT"),
        ("nombre_via", "VARCHAR(200)"),
        ("numero_via", "VARCHAR(20)"),
        ("tipo_zona_id", "BIGINT"),
        ("nombre_zona", "VARCHAR(200)"),
        ("tipo_vivienda_id", "BIGINT"),
        ("interior", "VARCHAR(50)"),
        ("referencia", "VARCHAR(300)"),
        ("banco_sueldo_id", "BIGINT"),
        ("banco_cts_id", "BIGINT"),
        ("moneda_sueldo_id", "BIGINT"),
        ("moneda_cts_id", "BIGINT"),
        ("pension_rtps_id", "BIGINT"),
        ("regimen_pensionario_id", "BIGINT"),
        ("fec_ini_afil_afp", "DATE"),
        ("fec_fin_afil_afp", "DATE"),
        ("tipo_trabajador_id", "BIGINT"),
        ("tipo_trabajador_rtps_id", "BIGINT"),
        ("ocupacion_rtps_id", "BIGINT"),
        ("seccion_id", "BIGINT"),
        ("centro_costo_id", "BIGINT"),
        ("motivo_cese_id", "BIGINT"),
        ("comentario", "VARCHAR(500)"),
        ("procedencia", "VARCHAR(10)"),
    ]
    lines = [
        "",
        "DO $$ BEGIN",
        "    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='rrhh' AND table_name='trabajador' AND column_name='telefono')",
        "       AND NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='rrhh' AND table_name='trabajador' AND column_name='telefono_fijo')",
        "    THEN ALTER TABLE rrhh.trabajador RENAME COLUMN telefono TO telefono_fijo;",
        "    END IF;",
        "END $$;",
        "ALTER TABLE rrhh.trabajador ADD COLUMN IF NOT EXISTS telefono_fijo VARCHAR(40);",
    ]
    for col, typ in cols:
        lines.append(f"ALTER TABLE rrhh.trabajador ADD COLUMN IF NOT EXISTS {col} {typ};")
    fks = [
        ("fk_trab_tipo_sangre", "tipo_sangre_id", "rrhh.tipo_sangre(id)"),
        ("fk_trab_distrito", "distrito_id", "core.distrito(id)"),
        ("fk_trab_tipo_via", "tipo_via_id", "rrhh.tipo_via(id)"),
        ("fk_trab_tipo_zona", "tipo_zona_id", "rrhh.tipo_zona(id)"),
        ("fk_trab_tipo_vivienda", "tipo_vivienda_id", "rrhh.tipo_vivienda(id)"),
        ("fk_trab_banco_sueldo", "banco_sueldo_id", "finanzas.banco(id)"),
        ("fk_trab_banco_cts", "banco_cts_id", "finanzas.banco(id)"),
        ("fk_trab_moneda_sueldo", "moneda_sueldo_id", "core.moneda(id)"),
        ("fk_trab_moneda_cts", "moneda_cts_id", "core.moneda(id)"),
        ("fk_trab_pension_rtps", "pension_rtps_id", "rrhh.pension_rtps(id)"),
        ("fk_trab_regimen_pensionario", "regimen_pensionario_id", "rrhh.regimen_pensionario(id)"),
        ("fk_trab_tipo_trabajador", "tipo_trabajador_id", "rrhh.tipo_trabajador(id)"),
        ("fk_trab_tipo_trabajador_rtps", "tipo_trabajador_rtps_id", "rrhh.tipo_trabajador_rtps(id)"),
        ("fk_trab_ocupacion_rtps", "ocupacion_rtps_id", "rrhh.ocupacion_rtps(id)"),
        ("fk_trab_seccion", "seccion_id", "rrhh.seccion(id)"),
        ("fk_trab_centro_costo", "centro_costo_id", "contabilidad.centros_costo(id)"),
        ("fk_trab_motivo_cese", "motivo_cese_id", "rrhh.motivo_cese(id)"),
    ]
    for name, col, ref in fks:
        lines.append(
            f"DO $$ BEGIN IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname='{name}') "
            f"THEN ALTER TABLE rrhh.trabajador ADD CONSTRAINT {name} "
            f"FOREIGN KEY ({col}) REFERENCES {ref}; END IF; END $$;"
        )
    return "\n".join(lines)


def load_json(cat: dict) -> list:
    path = DATA / cat["json_file"]
    if not path.exists():
        return []
    with open(path, encoding="utf-8") as handle:
        data = json.load(handle)
    rows = data.get(cat["json_key"], [])
    return rows if isinstance(rows, list) else []


def gen_seed() -> str:
    lines = [
        "-- Catálogos SIGRE para maestro trabajador (regenerar: python scripts/gen_rrhh_catalogos_sigre.py --seed-only)",
        "BEGIN;",
        "",
        "-- Régimen laboral SIGRE (1=General, 2=Público, 3=Agrícola)",
        "INSERT INTO rrhh.regimen_laboral (codigo, nombre, factor_gratificacion, factor_vacacion, factor_cts, flag_estado)",
        "VALUES",
        "    ('1', 'Régimen general', 1, 1, 1, '1'),",
        "    ('2', 'Régimen público', 1, 1, 1, '1'),",
        "    ('3', 'Régimen agrícola', 1, 1, 1, '1')",
        "ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, flag_estado = EXCLUDED.flag_estado;",
        "",
    ]
    # Area codigos
    area_rows = load_json({"json_file": "AREA.json", "json_key": "AREA"})
    if area_rows:
        lines.append("-- Áreas SIGRE (codigo)")
        for row in area_rows:
            cod = str(row.get("COD_AREA", "")).strip()
            nom = str(row.get("DESC_AREA", "")).strip()
            if not cod or not nom:
                continue
            lines.append(
                f"UPDATE rrhh.area SET codigo = {sql_str(cod)} WHERE nombre ILIKE {sql_str(nom)} AND codigo IS NULL;"
            )
        lines.append(
            "INSERT INTO rrhh.area (codigo, nombre, flag_estado)\nSELECT v.codigo, v.nombre, v.flag_estado FROM (VALUES\n    "
            + ",\n    ".join(
                f"({sql_str(str(r['COD_AREA']).strip())}, {sql_str(str(r['DESC_AREA']).strip())}, '1')"
                for r in area_rows
                if str(r.get("COD_AREA", "")).strip() and str(r.get("DESC_AREA", "")).strip()
            )
            + "\n) AS v(codigo, nombre, flag_estado)\n"
            "WHERE NOT EXISTS (SELECT 1 FROM rrhh.area a WHERE a.codigo = v.codigo);"
        )
        lines.append("")

    for cat in CATALOGS:
        rows = load_json(cat)
        if not rows:
            continue
        if cat.get("seccion"):
            lines.append(f"-- {cat['table']}")
            for row in rows:
                cod_area = str(row.get("COD_AREA", "")).strip()
                cod = str(row.get(cat["codigo"], "")).strip()
                nom = str(row.get(cat["nombre"], "")).strip()
                flag = str(row.get("FLAG_ESTADO", "1") or "1").strip()
                if not cod or not nom or not cod_area:
                    continue
                lines.append(
                    "INSERT INTO rrhh.seccion (codigo, nombre, area_id, porc_sctr_onp, flag_estado) "
                    f"SELECT {sql_str(cod)}, {sql_str(nom)}, "
                    f"(SELECT id FROM rrhh.area WHERE codigo = {sql_str(cod_area)} LIMIT 1), "
                    f"{sql_numeric(row.get('PORC_SCTR_ONP'), '0')}, {sql_str(flag)} "
                    f"WHERE EXISTS (SELECT 1 FROM rrhh.area WHERE codigo = {sql_str(cod_area)}) "
                    "ON CONFLICT (area_id, codigo) DO UPDATE SET nombre = EXCLUDED.nombre, "
                    "porc_sctr_onp = EXCLUDED.porc_sctr_onp, flag_estado = EXCLUDED.flag_estado;"
                )
            lines.append("")
            continue
        if cat.get("complex"):
            lines.append(f"-- {cat['table']}")
            for row in rows:
                cod = str(row.get(cat["codigo"], "")).strip()
                nom = str(row.get(cat["nombre"], "")).strip()
                if not cod or not nom:
                    continue
                flag = str(row.get("FLAG_ESTADO", "1") or "1").strip()
                lines.append(
                    "INSERT INTO rrhh.tipo_trabajador (codigo, nombre, flag_emision_boleta, libro_planilla, "
                    "dias_trab_hab_fijo, factor_costo_hr, flag_sector_agrario, periodo_boleta, flag_ingreso_boleta, "
                    "flag_replicacion, flag_estado) VALUES ("
                    f"{sql_str(cod)}, {sql_str(nom)}, {sql_str(row.get('FLAG_EMISION_BOLETA'))}, "
                    f"{row.get('LIBRO_PLANILLA') if row.get('LIBRO_PLANILLA') is not None else 'NULL'}, "
                    f"{row.get('DIAS_TRAB_HAB_FIJO') if row.get('DIAS_TRAB_HAB_FIJO') is not None else 'NULL'}, "
                    f"{row.get('FACTOR_COSTO_HR') if row.get('FACTOR_COSTO_HR') is not None else 'NULL'}, "
                    f"{sql_str(row.get('FLAG_SECTOR_AGRARIO'))}, {sql_str(row.get('PERIODO_BOLETA'))}, "
                    f"{sql_str(row.get('FLAG_INGRESO_BOLETA'))}, "
                    f"{sql_str(row.get('FLAG_REPLICACION') or '1')}, {sql_str(flag)}) "
                    "ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, flag_estado = EXCLUDED.flag_estado;"
                )
            lines.append("")
            continue

        table = cat["table"]
        lines.append(f"-- {table}")
        values = []
        for row in rows:
            cod = str(row.get(cat["codigo"], "")).strip()
            nom = str(row.get(cat["nombre"], "")).strip()
            if not cod or not nom:
                continue
            flag = str(row.get("FLAG_ESTADO", "1") or "1").strip()
            if cat.get("extra_entity"):
                extra = sql_str(row.get("FLAG_PENSIONISTA"))
                values.append(f"    ({sql_str(cod)}, {sql_str(nom)}, {extra}, {sql_str(flag)})")
            else:
                values.append(f"    ({sql_str(cod)}, {sql_str(nom)}, {sql_str(flag)})")
        if values:
            if cat.get("extra_entity"):
                lines.append(
                    f"INSERT INTO rrhh.{table} (codigo, nombre, flag_pensionista, flag_estado) VALUES\n"
                    + ",\n".join(values)
                    + "\nON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, "
                    "flag_pensionista = EXCLUDED.flag_pensionista, flag_estado = EXCLUDED.flag_estado;"
                )
            else:
                lines.append(
                    f"INSERT INTO rrhh.{table} (codigo, nombre, flag_estado) VALUES\n"
                    + ",\n".join(values)
                    + "\nON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, flag_estado = EXCLUDED.flag_estado;"
                )
        lines.append("")

    lines.extend(["COMMIT;", ""])
    return "\n".join(lines)


def write_backend(cat: dict) -> None:
    entity = cat["entity"]
    pkg = "pe.restaurant.rrhh"
    table = cat["table"]
    err = cat["err"]
    api = cat["api"]
    extra_fields = cat.get("extra_entity", [])
    extra_entity_java = ""
    extra_response = ""
    extra_create = ""
    extra_update = ""
    for field, col, typ, length in extra_fields:
        extra_entity_java += f'    @Column(name = "{col}", length = {length})\n    private String {field};\n'
        extra_response += f"    private String {field};\n"
        extra_create += f"    @Size(max = {length})\n    private String {field};\n"
        extra_update += f"    @Size(max = {length})\n    private String {field};\n"

    seccion_entity = ""
    if cat.get("seccion"):
        seccion_entity = """
    @Column(name = "area_id", nullable = false)
    private Long areaId;

    @Column(name = "porc_sctr_onp", nullable = false, precision = 4, scale = 2)
    private java.math.BigDecimal porcSctrOnp = java.math.BigDecimal.ZERO;
"""

    entity_java = f"""package {pkg}.entity;

import jakarta.persistence.*;
import lombok.*;
import pe.restaurant.common.entity.BaseEntity;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "{table}", schema = "rrhh")
public class {entity} extends BaseEntity {{
    @Column(name = "codigo", length = 20, nullable = false, unique = true)
    private String codigo;
    @Column(name = "nombre", length = 200, nullable = false)
    private String nombre;
{seccion_entity}{extra_entity_java}}}
"""
    write_file(BACKEND / "entity" / f"{entity}.java", entity_java)

    repo_java = f"""package {pkg}.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import {pkg}.entity.{entity};
import java.util.List;
import java.util.Optional;

public interface {entity}Repository extends JpaRepository<{entity}, Long>, JpaSpecificationExecutor<{entity}> {{
    Optional<{entity}> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<{entity}> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}}
"""
    write_file(BACKEND / "repository" / f"{entity}Repository.java", repo_java)

    const_java = f"""package {pkg}.constants;

public final class {entity}Constants {{
    private {entity}Constants() {{ throw new UnsupportedOperationException(); }}
    public static final String ERROR_CODIGO_DUPLICADO = "{err}-001";
    public static final String ERROR_NO_ENCONTRADO = "{err}-002";
    public static final String MSG_CODIGO_DUPLICADO = "Ya existe un registro con ese código.";
    public static final String MSG_NO_ENCONTRADO = "{entity} no encontrado.";
    public static final String MSG_CREADO = "{entity} creado correctamente.";
    public static final String MSG_OBTENIDOS = "{entity} obtenidos correctamente.";
    public static final String MSG_DESACTIVADO = "{entity} desactivado correctamente.";
    public static final String MSG_ACTIVADO = "{entity} activado correctamente.";
}}
"""
    write_file(BACKEND / "constants" / f"{entity}Constants.java", const_java)

    spec_java = f"""package {pkg}.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import {pkg}.entity.{entity};
import java.util.ArrayList;
import java.util.List;

public final class {entity}Specification {{
    private {entity}Specification() {{ throw new UnsupportedOperationException(); }}

    public static Specification<{entity}> filtros(String codigo, String nombre, String flagEstado) {{
        return (root, query, cb) -> {{
            List<Predicate> predicates = new ArrayList<>();
            if (codigo != null && !codigo.isEmpty())
                predicates.add(cb.like(cb.lower(root.get("codigo")), "%" + codigo.toLowerCase() + "%"));
            if (nombre != null && !nombre.isEmpty())
                predicates.add(cb.like(cb.lower(root.get("nombre")), "%" + nombre.toLowerCase() + "%"));
            if (flagEstado != null && !flagEstado.isEmpty())
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            return cb.and(predicates.toArray(new Predicate[0]));
        }};
    }}
}}
"""
    write_file(BACKEND / "specification" / f"{entity}Specification.java", spec_java)

    area_create = "    @NotNull private Long areaId;\n" if cat.get("seccion") else ""
    area_update = area_create
    area_response = "    private Long areaId;\n    private String areaNombre;\n" if cat.get("seccion") else ""
    create_req = f"""package {pkg}.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class {entity}CreateRequest {{
    @NotBlank @Size(max = 20) private String codigo;
    @NotBlank @Size(max = 200) private String nombre;
{area_create}{extra_create}}}
"""
    update_req = f"""package {pkg}.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class {entity}UpdateRequest {{
    @NotBlank @Size(max = 200) private String nombre;
{area_update}{extra_update}}}
"""
    response = f"""package {pkg}.dto.response;

import lombok.Data;
import java.time.OffsetDateTime;

@Data
public class {entity}Response {{
    private Long id;
    private String codigo;
    private String nombre;
{area_response}{extra_response}    private String flagEstado;
    private Long createdBy;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private OffsetDateTime fecModificacion;
}}
"""
    write_file(BACKEND / "dto" / "request" / f"{entity}CreateRequest.java", create_req)
    write_file(BACKEND / "dto" / "request" / f"{entity}UpdateRequest.java", update_req)
    write_file(BACKEND / "dto" / "response" / f"{entity}Response.java", response)

    mapper_java = f"""package {pkg}.mapper;

import org.mapstruct.*;
import {pkg}.dto.request.{entity}CreateRequest;
import {pkg}.dto.request.{entity}UpdateRequest;
import {pkg}.dto.response.{entity}Response;
import {pkg}.entity.{entity};
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface {entity}Mapper {{
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffset")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffset")
    {entity}Response toResponse({entity} entity);
    List<{entity}Response> toResponseList(List<{entity}> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    {entity} toEntity({entity}CreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget {entity} entity, {entity}UpdateRequest request);

    @Named("instantToOffset")
    default OffsetDateTime instantToOffset(Instant instant) {{
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }}
}}
"""
    write_file(BACKEND / "mapper" / f"{entity}Mapper.java", mapper_java)

    service_iface = f"""package {pkg}.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import {pkg}.dto.request.{entity}CreateRequest;
import {pkg}.dto.request.{entity}UpdateRequest;
import {pkg}.dto.response.{entity}Response;
import java.util.List;

public interface {entity}Service {{
    Page<{entity}Response> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    {entity}Response obtenerPorId(Long id);
    {entity}Response crear({entity}CreateRequest request);
    {entity}Response actualizar(Long id, {entity}UpdateRequest request);
    {entity}Response desactivar(Long id);
    {entity}Response activar(Long id);
    List<{entity}Response> listarActivos();
}}
"""
    write_file(BACKEND / "service" / f"{entity}Service.java", service_iface)

    service_impl = f"""package {pkg}.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import {pkg}.constants.{entity}Constants;
import {pkg}.dto.request.{entity}CreateRequest;
import {pkg}.dto.request.{entity}UpdateRequest;
import {pkg}.dto.response.{entity}Response;
import {pkg}.entity.{entity};
import {pkg}.mapper.{entity}Mapper;
import {pkg}.repository.{entity}Repository;
import {pkg}.specification.{entity}Specification;
import {pkg}.service.{entity}Service;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class {entity}ServiceImpl implements {entity}Service {{
    private final {entity}Repository repository;
    private final {entity}Mapper mapper;

    @Override @Timed("rrhh.{table}.listar")
    public Page<{entity}Response> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {{
        return repository.findAll({entity}Specification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }}

    @Override public {entity}Response obtenerPorId(Long id) {{
        return mapper.toResponse(buscarOrThrow(id));
    }}

    @Override @Transactional @Timed("rrhh.{table}.crear")
    public {entity}Response crear({entity}CreateRequest request) {{
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {{
            throw new BusinessException({entity}Constants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, {entity}Constants.ERROR_CODIGO_DUPLICADO);
        }}
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }}

    @Override @Transactional @Timed("rrhh.{table}.actualizar")
    public {entity}Response actualizar(Long id, {entity}UpdateRequest request) {{
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }}

    @Override @Transactional public {entity}Response desactivar(Long id) {{
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }}

    @Override @Transactional public {entity}Response activar(Long id) {{
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }}

    @Override public java.util.List<{entity}Response> listarActivos() {{
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }}

    private {entity} buscarOrThrow(Long id) {{
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                {entity}Constants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, {entity}Constants.ERROR_NO_ENCONTRADO));
    }}
}}
"""
    write_file(BACKEND / "service" / "impl" / f"{entity}ServiceImpl.java", service_impl)

    plural = entity + "s" if not entity.endswith("s") else entity
    controller = f"""package {pkg}.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import {pkg}.constants.{entity}Constants;
import {pkg}.dto.request.{entity}CreateRequest;
import {pkg}.dto.request.{entity}UpdateRequest;
import {pkg}.dto.response.{entity}Response;
import pe.restaurant.rrhh.dto.response.PageData;
import {pkg}.service.{entity}Service;
import java.util.List;

@Tag(name = "{entity}", description = "Catálogo {table}")
@RestController
@RequestMapping("/api/rrhh/{api}")
@RequiredArgsConstructor
public class {entity}Controller {{
    private final {entity}Service service;

    @GetMapping
    public ResponseEntity<ApiResponse<PageData<{entity}Response>>> listar(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {{
        var page = service.listar(codigo, nombre, flagEstado, pageable);
        return ResponseEntity.ok(ApiResponse.ok(PageData.of(page, page.getContent()), {entity}Constants.MSG_OBTENIDOS));
    }}

    @GetMapping("/{{id}}")
    public ResponseEntity<ApiResponse<{entity}Response>> obtenerPorId(@PathVariable Long id) {{
        return ResponseEntity.ok(ApiResponse.ok(service.obtenerPorId(id)));
    }}

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<ApiResponse<{entity}Response>> crear(@Valid @RequestBody {entity}CreateRequest request) {{
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.ok(service.crear(request), {entity}Constants.MSG_CREADO));
    }}

    @PutMapping("/{{id}}")
    public ResponseEntity<ApiResponse<{entity}Response>> actualizar(@PathVariable Long id, @Valid @RequestBody {entity}UpdateRequest request) {{
        return ResponseEntity.ok(ApiResponse.ok(service.actualizar(id, request)));
    }}

    @PatchMapping("/{{id}}/desactivar")
    public ApiResponse<{entity}Response> desactivar(@PathVariable Long id) {{
        return ApiResponse.ok(service.desactivar(id), {entity}Constants.MSG_DESACTIVADO);
    }}

    @PatchMapping("/{{id}}/activar")
    public ApiResponse<{entity}Response> activar(@PathVariable Long id) {{
        return ApiResponse.ok(service.activar(id), {entity}Constants.MSG_ACTIVADO);
    }}

    @GetMapping("/activos")
    public ResponseEntity<ApiResponse<List<{entity}Response>>> listarActivos() {{
        return ResponseEntity.ok(ApiResponse.ok(service.listarActivos()));
    }}
}}
"""
    write_file(BACKEND / "controller" / f"{entity}Controller.java", controller)


def write_file(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def gen_frontend(cat: dict) -> None:
    entity = cat["entity"]
    grid = cat["grid"]
    route = cat["route"]
    menu = cat["menu"]
    prefix = cat["prefix"]
    kebab_entity = re.sub(r"(?<!^)(?=[A-Z])", "-", entity).lower()

    comp_dir = FRONTEND / "parametros" / "components" / f"p-{route}"
    comp_dir.mkdir(parents=True, exist_ok=True)
    selector = f"app-p-{route}"

    ts = comp_dir / f"p-{route}.component.ts"
    html = comp_dir / f"p-{route}.component.html"
    spec = comp_dir / f"p-{route}.component.spec.ts"
    model = FRONTEND / "domain" / "models" / f"{kebab_entity}.entity.ts"
    usecase = FRONTEND / "application" / "usecases" / f"obtener-{kebab_entity}.usecase.ts"

    entity_iface = f"""export interface {entity}Entity {{
  id?: number;
  {grid}_codigo: string;
  {grid}_nombre: string;
  {grid}_estado: string;
  {grid}_estado_value: string;
}}
"""
    write_file(model, entity_iface)

    usecase_ts = f"""import {{ Injectable, inject }} from '@angular/core';
import {{ Observable }} from 'rxjs';
import {{ IReportesRepository }} from '../../domain/repositories/ireportes.repository';
import {{ {entity}Entity }} from '../../domain/models/{kebab_entity}.entity';

@Injectable()
export class Obtener{entity}UseCase {{
  private readonly reportesRepository = inject(IReportesRepository);

  execute(): Observable<{entity}Entity[]> {{
    return this.reportesRepository.obtener{entity}();
  }}
}}
"""
    write_file(usecase, usecase_ts)

    component_ts = textwrap.dedent(f"""
    import {{ Component, OnInit, OnDestroy, inject }} from '@angular/core';
    import {{ FormBuilder, FormGroup }} from '@angular/forms';
    import {{ ModalController }} from '@ionic/angular';
    import {{ ColDef, GridApi, GridReadyEvent }} from 'ag-grid-enterprise';
    import {{ ModalVerActualizacionesComponent }} from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
    import {{ ToastService }} from 'src/app/ui/services/toast.service';
    import {{ FormValidationService }} from 'src/app/ui/services/form-validation.service';
    import {{ CanComponentDeactivate }} from 'src/app/auth/guards/can-deactivate.guard';
    import {{ RrHhFacade }} from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
    import {{ {entity}Entity }} from 'src/app/modules/rrhh/domain/models/{kebab_entity}.entity';
    import {{ faBook, faSearch }} from '@fortawesome/pro-regular-svg-icons';
    import {{ faAngleDown, faCirclePlus, faDownload, faRotateRight }} from '@fortawesome/pro-solid-svg-icons';

    @Component({{
      selector: '{selector}',
      templateUrl: './p-{route}.component.html',
      styleUrls: ['./p-{route}.component.scss'],
      standalone: false,
    }})
    export class P{entity}Component implements OnInit, OnDestroy, CanComponentDeactivate {{
      private readonly rrHhFacade = inject(RrHhFacade);
      readonly isLoading = this.rrHhFacade.loading{entity};
      isResetting = false;
      farBook = faBook;
      farSearch = faSearch;
      fasAngleDown = faAngleDown;
      fasCirclePlus = faCirclePlus;
      fasDownload = faDownload;
      fasRotateRight = faRotateRight;
      private gridApi!: GridApi;
      formulario!: FormGroup;
      filaSeleccionada: {entity}Entity | null = null;
      flagEstadoOptions = [{{ value: '1', label: 'Activo' }}, {{ value: '0', label: 'Inactivo' }}];
      defaultFlagEstado = '1';
      columnDefs: ColDef[] = [
        {{ headerName: 'Código', field: '{grid}_codigo', width: 100, sortable: true, filter: true }},
        {{ headerName: 'Nombre', field: '{grid}_nombre', flex: 1, sortable: true, filter: true }},
        {{ headerName: 'Estado', field: '{grid}_estado', width: 100, sortable: true, filter: true,
          cellRenderer: (params: {{ value?: string }}) => {{
            if (params.value === 'Activo') return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activo</span>';
            if (params.value === 'Inactivo') return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactivo</span>';
            return params.value ?? '';
          }},
        }},
      ];
      rowData: {entity}Entity[] = [];
      localeText = {{ page: 'Página', to: 'a', of: 'de', next: 'Siguiente', last: 'Último', first: 'Primero', previous: 'Anterior', loadingOoo: 'Cargando...', noRowsToShow: 'No hay datos para mostrar' }};

      constructor(private modalController: ModalController, private toastService: ToastService, private fb: FormBuilder, private formValidationService: FormValidationService) {{}}

      ngOnInit() {{
        this.formulario = this.fb.group({{ nombre: [null], flag_estado: [this.defaultFlagEstado] }});
        this.formValidationService.inicializarFormulario(this.formulario);
        this.formValidationService.resetearEstado();
        this.rrHhFacade.cargar{entity}();
        const timer = setInterval(() => {{
          if (!this.isLoading()) {{ this.rowData = this.rrHhFacade.{entity[0].lower() + entity[1:]}(); clearInterval(timer); }}
        }}, 100);
      }}

      onGridReady(params: GridReadyEvent) {{ this.gridApi = params.api; }}
      onBtReset() {{
        this.isResetting = true;
        this.rrHhFacade.cargar{entity}();
        const timer = setInterval(() => {{
          if (!this.isLoading()) {{ this.rowData = this.rrHhFacade.{entity[0].lower() + entity[1:]}(); this.isResetting = false; clearInterval(timer); }}
        }}, 100);
      }}

      async onCellClicked(event: {{ data: {entity}Entity }}) {{
        const confirmar = await this.formValidationService.validarCambios();
        if (!confirmar) {{ this.gridApi?.deselectAll(); return; }}
        this.filaSeleccionada = event.data;
        this.formulario.patchValue({{ nombre: event.data.{grid}_nombre, flag_estado: event.data.{grid}_estado_value }});
        this.formValidationService.resetearEstado();
      }}

      async nuevoRegistro() {{
        if (!(await this.formValidationService.validarCambios())) return;
        this.filaSeleccionada = null;
        this.formulario.reset({{ flag_estado: this.defaultFlagEstado }});
        this.formValidationService.resetearEstado();
        this.gridApi?.deselectAll();
      }}

      btnguardar() {{
        const nombre = this.formulario.get('nombre')?.value;
        const flagEstadoValue = this.formulario.get('flag_estado')?.value;
        if (!nombre || String(nombre).trim() === '' || !flagEstadoValue) {{
          this.toastService.warning('Por favor, completa todos los campos requeridos');
          return;
        }}
        const codigo = this.filaSeleccionada?.{grid}_codigo || this.generarCodigo();
        const body = {{ codigo, nombre: String(nombre).trim() }};
        const idEdicion = this.filaSeleccionada?.id ? Number(this.filaSeleccionada.id) : undefined;
        this.rrHhFacade.guardar{entity}(body, idEdicion).subscribe({{
          next: () => {{
            const finalizar = () => {{
              this.toastService.success(this.filaSeleccionada ? 'Registro actualizado' : 'Registro creado');
              this.formValidationService.resetearEstado();
              this.rrHhFacade.cargar{entity}();
              this.formulario.reset({{ flag_estado: this.defaultFlagEstado }});
              this.filaSeleccionada = null;
              this.gridApi?.deselectAll();
            }};
            if (idEdicion && flagEstadoValue !== this.filaSeleccionada?.{grid}_estado_value) {{
              this.rrHhFacade.cambiarEstado{entity}(idEdicion, flagEstadoValue === '1').subscribe({{ next: () => finalizar(), error: () => this.toastService.danger('Error al cambiar estado') }});
            }} else finalizar();
          }},
          error: () => this.toastService.danger('Error al guardar'),
        }});
      }}

      generarCodigo(): string {{
        const prefix = '{prefix.upper()}-';
        if (!this.rowData.length) return `${{prefix}}001`;
        const max = this.rowData.reduce((acc, curr) => {{
          const c = curr.{grid}_codigo;
          if (c?.startsWith(prefix)) {{ const n = parseInt(c.replace(prefix, ''), 10); return !isNaN(n) && n > acc ? n : acc; }}
          return acc;
        }}, 0);
        return `${{prefix}}${{(max + 1).toString().padStart(3, '0')}}`;
      }}

      async canDeactivate(): Promise<boolean> {{ return this.formValidationService.canDeactivate(); }}
      ngOnDestroy() {{ this.formValidationService.limpiarFormulario(); }}

      async modalverActualizaciones() {{
        const modal = await this.modalController.create({{
          component: ModalVerActualizacionesComponent,
          cssClass: 'promo',
          componentProps: {{ titulo: 'Historial de actualizaciones', rowData: [], colDefs: [], defaultColDef: {{}}, anchoModal: '700px' }},
        }});
        await modal.present();
      }}
    }}
    """).strip()
    write_file(ts, component_ts)

    component_html = textwrap.dedent(f"""
    <div class="contenedor-principal">
      <div class="panel-izquierdo">
        <div class="cont-title"><span>Lista de {menu}</span></div>
        <div class="contenedor-filtros">
          <div class="buscador"><fa-icon [icon]="farSearch"></fa-icon>
            <ion-input fill="outline" placeholder="Buscar por código" style="--padding-start:30px"></ion-input>
          </div>
          <div class="filtros-absolutos">
            <ion-button class="w-fit" (click)="nuevoRegistro()" [disabled]="!filaSeleccionada">
              <fa-icon [icon]="fasCirclePlus"></fa-icon><span>Nuevo registro</span>
            </ion-button>
          </div>
        </div>
        <div class="contenedor-primera-tabla" [appLoader]="isLoading()">
          <fa-icon [icon]="fasRotateRight" (click)="onBtReset()" class="btn-refresh"></fa-icon>
          <ag-grid-angular style="width: 100%; height: 100%;" [rowData]="rowData" [columnDefs]="columnDefs"
            [pagination]="true" [rowHeight]="20" [localeText]="localeText" [headerHeight]="24" [paginationPageSize]="20"
            [rowSelection]="'single'" (gridReady)="onGridReady($event)" (cellClicked)="onCellClicked($event)" />
        </div>
      </div>
      <div class="panel-derecho" [appLoader]="isLoading() && !isResetting">
        <div class="cont-title"><span>{{{{ filaSeleccionada ? filaSeleccionada.{grid}_codigo : 'Nuevo registro' }}}}</span></div>
        <form [formGroup]="formulario" class="contenedor-formulario">
          <div class="contenido-formulario">
            <span class="label">Nombre <span class="text-danger">*</span></span>
            <ion-input fill="outline" class="w-[163px]" formControlName="nombre"></ion-input>
          </div>
          <div class="contenido-formulario">
            <span class="label">Estado <span class="text-danger">*</span></span>
            <ion-select fill="outline" class="!w-[70px]" interface="popover" formControlName="flag_estado">
              <ion-select-option *ngFor="let e of flagEstadoOptions" [value]="e.value">{{{{ e.label }}}}</ion-select-option>
            </ion-select>
          </div>
        </form>
        <div class="contenedor-btn">
          <ion-button class="w-[70px]" (click)="btnguardar()">{{{{ filaSeleccionada ? 'Guardar' : 'Registrar' }}}}</ion-button>
          <ion-button fill="outline" color="medium" class="w-[70px]" (click)="nuevoRegistro()"><span>Cancelar</span></ion-button>
        </div>
      </div>
    </div>
    """).strip()
    write_file(html, component_html)
    write_file(spec, f"describe('P{entity}Component', () => {{ it('should create', () => {{ expect(true).toBeTrue(); }}); }});")


def append_ddl_if_missing():
    marker = "-- Catálogos SIGRE para maestro de trabajadores (idempotente)"
    content = DDL.read_text(encoding="utf-8")
    if marker in content:
        print("DDL ya presente en 07-rrhh.sql")
        return
    block = gen_ddl_block()
    DDL.write_text(content.rstrip() + block + "\n", encoding="utf-8")
    print(f"DDL append a {DDL}")


def main():
    append_ddl_if_missing()
    seed_sql = gen_seed()
    SEED.write_text(seed_sql, encoding="utf-8")
    print(f"Seed generado: {SEED}")
    for cat in CATALOGS:
        write_backend(cat)
        gen_frontend(cat)
        print(f"  OK {cat['entity']}")
    print("Generación completada.")


if __name__ == "__main__":
    main()
