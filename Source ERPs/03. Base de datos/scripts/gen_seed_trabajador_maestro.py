#!/usr/bin/env python3
"""Genera seed rrhh.trabajador desde los últimos N registros de MAESTRO.json (SIGRE)."""
import json
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "data"
SEED = Path(__file__).resolve().parent.parent / "ddl" / "seed"
MAESTRO_PATH = DATA / "MAESTRO.json"
ADMIN_AFP_PATH = DATA / "ADMIN_AFP.json"
OUT_PATH = SEED / "04-seed-trabajador-maestro-sigre.sql"
EMP_PER_SUCURSAL = 10
JOR_PER_SUCURSAL = 10
ONP_PER_GROUP = 5
AFP_PER_GROUP = 5
SUCURSAL_PIURA = "PI"
SUCURSAL_LIMA = "LM"
TIPO_EMP = "EMP"
TIPO_JOR = "JOR"

AFP_BY_COD = {}

# Código LDN (0 + departamento) según ubigeo COD_DPTO y localidades frecuentes en MAESTRO.
DEPARTAMENTO_LDN = {
    "01": "041",
    "02": "043",
    "03": "083",
    "04": "054",
    "05": "066",
    "06": "076",
    "07": "084",
    "08": "067",
    "09": "062",
    "10": "056",
    "11": "064",
    "12": "044",
    "13": "074",
    "14": "065",
    "15": "082",
    "16": "053",
    "17": "063",
    "18": "01",
    "19": "073",
    "20": "051",
    "21": "042",
    "22": "052",
    "23": "072",
    "24": "061",
    "25": "01",
}

DIRECCION_LDN_KEYWORDS = (
    ("CALLAO", "01"),
    ("BELLAVISTA", "01"),
    ("LIMA", "01"),
    ("MIRAFLORES", "01"),
    ("SAN MARTIN DE PORRES", "01"),
    ("SMP", "01"),
    ("CHIMBOTE", "043"),
    ("NEPEÑA", "043"),
    ("COISHCO", "043"),
    ("TRUJILLO", "044"),
    ("PIURA", "073"),
    ("SULLANA", "073"),
    ("PAITA", "073"),
    ("TALARA", "073"),
    ("CATACAO", "073"),
    ("AREQUIPA", "054"),
    ("CUSCO", "084"),
    ("ICA", "056"),
    ("CHINCHA", "056"),
    ("PUNO", "051"),
    ("TACNA", "052"),
    ("TUMBES", "072"),
)
ESTADO_CIVIL_SIGRE = {
    "01": "SOLTERO",
    "02": "CASADO",
    "03": "DIVORCIADO",
    "04": "VIUDO",
}


def load_afp_map():
    with open(ADMIN_AFP_PATH, encoding="utf-8") as handle:
        for row in json.load(handle)["ADMIN_AFP"]:
            AFP_BY_COD[row["COD_AFP"]] = row["DESC_AFP"]


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


def sql_flag(value, default="0"):
    text = str(value if value is not None else default).strip()
    return sql_str(text or default)


def sql_numeric(value, default="0"):
    if value is None or str(value).strip() == "":
        return default
    return str(value)


def parse_iso_date(value):
    if value is None or str(value).strip() == "":
        return None
    return str(value)[:10]


def join_names(nombre1, nombre2):
    parts = [str(nombre1 or "").strip(), str(nombre2 or "").strip()]
    return " ".join(part for part in parts if part)


def map_tipo_doc_codigo(tipo_doc_sigre):
    if tipo_doc_sigre in (None, ""):
        return "1"
    code = str(tipo_doc_sigre).strip()
    if code == "01":
        return "1"
    if code.startswith("0") and len(code) == 2:
        return code[1]
    return code


def fk(table, codigo):
    if codigo is None or str(codigo).strip() == "":
        return "NULL"
    return f"(SELECT id FROM {table} WHERE codigo = {sql_str(str(codigo).strip())} LIMIT 1)"


def fk_banco(cod_banco):
    if cod_banco is None or str(cod_banco).strip() == "":
        return "NULL"
    return f"(SELECT id FROM finanzas.banco WHERE cod_banco = {sql_str(str(cod_banco).strip())} LIMIT 1)"


def fk_moneda(sigre_moneda):
    if sigre_moneda is None or str(sigre_moneda).strip() == "":
        return "NULL"
    text = str(sigre_moneda).strip()
    if text in ("S/.",):
        return "core.fn_moneda_default_pen_id()"
    return (
        f"(SELECT id FROM core.moneda WHERE codigo = {sql_str(text)} "
        f"OR sigla_moneda = {sql_str(text)} LIMIT 1)"
    )


def fk_centro_costo(cencos):
    if cencos is None or str(cencos).strip() == "":
        return "NULL"
    return (
        f"(SELECT id FROM contabilidad.centros_costo "
        f"WHERE trim(cencos) = {sql_str(str(cencos).strip())} LIMIT 1)"
    )


def fk_sucursal(codigo):
    return f"(SELECT id FROM auth.sucursal WHERE codigo = {sql_str(str(codigo).strip())} LIMIT 1)"


def fk_seccion(cod_area, cod_seccion):
    if not str(cod_area or "").strip() or not str(cod_seccion or "").strip():
        return "NULL"
    return (
        "(SELECT s.id FROM rrhh.seccion s JOIN rrhh.area a ON a.id = s.area_id "
        f"WHERE a.codigo = {sql_str(str(cod_area).strip())} AND s.codigo = {sql_str(str(cod_seccion).strip())} LIMIT 1)"
    )


def fk_distrito(record):
    dpto = str(record.get("COD_DPTO") or "").strip()
    prov = str(record.get("COD_PROV") or "").strip()
    dist = str(record.get("COD_DISTR") or "").strip()
    if not (dpto and prov and dist):
        return "NULL"
    ubigeo = f"{dpto.zfill(2)}{prov.zfill(2)}{dist.zfill(2)}"
    return f"(SELECT id FROM core.distrito WHERE codigo = {sql_str(ubigeo)} LIMIT 1)"


def map_estado_civil_subquery(cod_estado_civil):
    codigo = ESTADO_CIVIL_SIGRE.get(str(cod_estado_civil or "").strip())
    if not codigo:
        return "NULL"
    return f"(SELECT id FROM rrhh.estado_civil WHERE codigo = {sql_str(codigo)} LIMIT 1)"


def map_admin_afp_subquery(cod_afp):
    nombre = AFP_BY_COD.get(str(cod_afp or "").strip())
    if not nombre:
        return "NULL"
    return f"(SELECT id FROM rrhh.admin_afp WHERE nombre = {sql_str(nombre)} LIMIT 1)"


def map_regimen_laboral(record):
    cod = str(record.get("FLAG_REG_LABORAL") or record.get("REGIMEN_LABORAL") or "").strip()
    if cod in ("1", "2", "3"):
        return fk("rrhh.regimen_laboral", cod)
    return "NULL"


def normalize_phone_digits(value):
    if value is None:
        return None
    digits = "".join(char for char in str(value) if char.isdigit())
    return digits or None


def is_mobile_phone(digits):
    return bool(digits) and len(digits) == 9 and digits[0] == "9"


def normalize_codigo_tel_ciudad(value):
    text = str(value or "").strip()
    if not text:
        return None
    digits = "".join(char for char in text if char.isdigit())
    if not digits or digits == "51":
        return None
    if len(digits) == 1:
        return f"0{digits}"
    if len(digits) == 2:
        return digits if digits.startswith("0") else f"0{digits}"
    if len(digits) == 3:
        return digits
    return digits[:3]


def infer_codigo_tel_ciudad(record):
    codigo = normalize_codigo_tel_ciudad(record.get("TEL_COD_CIUDAD"))
    if codigo:
        return codigo

    dpto = str(record.get("COD_DPTO") or "").strip()
    if dpto:
        codigo = DEPARTAMENTO_LDN.get(dpto.zfill(2))
        if codigo:
            return codigo

    direccion = str(record.get("DIRECCION") or "").upper()
    for keyword, ldn in DIRECCION_LDN_KEYWORDS:
        if keyword in direccion:
            return ldn

    return None


def map_telefonos(record):
    phones = []
    for field in ("TELEFONO1", "TELEFONO2"):
        digits = normalize_phone_digits(record.get(field))
        if digits:
            phones.append(digits)

    celulares = [phone for phone in phones if is_mobile_phone(phone)]
    fijos = [phone for phone in phones if not is_mobile_phone(phone)]

    telefono_fijo = fijos[0] if fijos else None
    celular1 = celulares[0] if len(celulares) > 0 else None
    celular2 = celulares[1] if len(celulares) > 1 else None

    codigo_tel_ciudad = None
    if telefono_fijo or record.get("TEL_COD_CIUDAD") or record.get("DIRECCION") or record.get("COD_DPTO"):
        codigo_tel_ciudad = infer_codigo_tel_ciudad(record)

    return telefono_fijo, celular1, celular2, codigo_tel_ciudad


def seed_fecha_cese():
    """Datos iniciales SIGRE: trabajadores vigentes sin fecha de cese."""
    return "NULL"


def seed_motivo_cese_id():
    return "NULL"


def is_onp(record):
    cod = record.get("COD_AFP")
    return cod is None or str(cod).strip() == ""


PREFERRED_AFP_CODES = ("IN", "HO", "PR", "RI", "HA")


def pick_workers(pool, excluded, count, onp_count, afp_count):
    """Elige count trabajadores: onp_count ONP + afp_count con COD_AFP distintos."""
    available = [row for row in pool if str(row.get("COD_TRABAJADOR") or "") not in excluded]
    onp_rows = sorted(
        (row for row in available if is_onp(row)),
        key=lambda row: str(row.get("COD_TRABAJADOR") or ""),
    )
    afp_rows = sorted(
        (row for row in available if not is_onp(row)),
        key=lambda row: str(row.get("COD_TRABAJADOR") or ""),
    )

    if len(onp_rows) < onp_count:
        raise SystemExit(
            f"Solo hay {len(onp_rows)} trabajadores ONP disponibles; se requieren {onp_count}."
        )
    if len(afp_rows) < afp_count:
        raise SystemExit(
            f"Solo hay {len(afp_rows)} trabajadores AFP disponibles; se requieren {afp_count}."
        )

    selected = [dict(row) for row in onp_rows[:onp_count]]
    remaining_afp = [
        row
        for row in afp_rows
        if str(row.get("COD_TRABAJADOR") or "") not in {str(r.get("COD_TRABAJADOR") or "") for r in selected}
    ]

    for code in PREFERRED_AFP_CODES[:afp_count]:
        match = next(
            (row for row in remaining_afp if str(row.get("COD_AFP") or "").strip() == code),
            None,
        )
        if match is None:
            if not remaining_afp:
                raise SystemExit(f"No hay trabajadores AFP disponibles para asignar código {code}.")
            match = remaining_afp[0]
        copy = dict(match)
        copy["COD_AFP"] = code
        selected.append(copy)
        cod_trab = str(copy.get("COD_TRABAJADOR") or "")
        remaining_afp = [row for row in remaining_afp if str(row.get("COD_TRABAJADOR") or "") != cod_trab]

    if len(selected) != count:
        raise SystemExit(f"Grupo incompleto: {len(selected)} de {count} trabajadores.")

    return selected


def tag_sucursal(records, sucursal_codigo):
    tagged = []
    for record in records:
        copy = dict(record)
        copy["_SUCURSAL_CODIGO"] = sucursal_codigo
        tagged.append(copy)
    return tagged


def is_vigente(record):
    """Vigente para planilla: sin cese, activo y con cálculo de planilla."""
    if record.get("FEC_CESE") is not None:
        return False
    if str(record.get("FLAG_ESTADO") or "").strip() != "1":
        return False
    return str(record.get("FLAG_CAL_PLNLLA") or "").strip() == "1"


def seed_flag_estado(record):
    return sql_flag(record.get("FLAG_ESTADO"), "1")


def build_row(record):
    numero_documento = record.get("DNI") or record.get("NRO_DOC_IDENT_RTPS")
    tipo_doc_codigo = map_tipo_doc_codigo(record.get("TIPO_DOC_IDENT_RTPS"))
    sexo_codigo = str(record.get("FLAG_SEXO") or "").strip() or None
    sexo_sql = fk("rrhh.sexo", sexo_codigo) if sexo_codigo else "NULL"
    telefono_fijo, celular1, celular2, codigo_tel_ciudad = map_telefonos(record)

    columns = [
        sql_str(record.get("COD_TRABAJADOR")),
        sql_str(join_names(record.get("NOMBRE1"), record.get("NOMBRE2"))),
        sql_str(record.get("NOMBRE1")),
        sql_str(record.get("NOMBRE2")),
        sql_str(record.get("APEL_PATERNO")),
        sql_str(record.get("APEL_MATERNO")),
        f"(SELECT id FROM core.tipo_doc_identidad WHERE codigo = {sql_str(tipo_doc_codigo)} LIMIT 1)",
        sql_str(numero_documento),
        sql_date(record.get("FEC_NACIMIENTO")),
        sexo_sql,
        map_estado_civil_subquery(record.get("COD_ESTADO_CIVIL")),
        sql_str(record.get("DIRECCION")),
        sql_str(telefono_fijo),
        sql_str(celular1),
        sql_str(celular2),
        sql_str(codigo_tel_ciudad),
        sql_str(record.get("EMAIL")),
        sql_flag(record.get("FLAG_DISCAPACIDAD")),
        sql_flag(record.get("FLAG_DOMICILIADO"), "1"),
        sql_flag(record.get("FLAG_COMISION_AFP")),
        sql_flag(record.get("FLAG_PENSIONISTA")),
        sql_flag(record.get("FLAG_AFILIADO_EPS")),
        sql_flag(record.get("FLAG_ESSALUD_VIDA")),
        sql_flag(record.get("FLAG_SCTR_PENSION")),
        sql_flag(record.get("FLAG_SCTR_SALUD")),
        sql_flag(record.get("FLAG_QUINTA_EXONERADO")),
        fk_distrito(record),
        fk("rrhh.tipo_via", record.get("COD_VIA")),
        sql_str(record.get("NOMBRE_VIA")),
        sql_str(record.get("NUMERO_VIA")),
        fk("rrhh.tipo_zona", record.get("COD_ZONA")),
        sql_str(record.get("NOMBRE_ZONA")),
        fk("rrhh.tipo_vivienda", record.get("COD_VIVIENDA")),
        sql_str(record.get("INTERIOR")),
        sql_str(record.get("REFERENCIA")),
        sql_str(record.get("NRO_CNTA_AHORRO")),
        sql_str(record.get("NRO_CNTA_CTS")),
        fk_banco(record.get("COD_BANCO")),
        fk_banco(record.get("COD_BANCO_CTS")),
        fk_moneda(record.get("COD_MONEDA")),
        fk_moneda(record.get("MONEDA_CTS")),
        map_admin_afp_subquery(record.get("COD_AFP")),
        sql_str(record.get("NRO_AFP_TRABAJ")),
        fk("rrhh.pension_rtps", record.get("COD_PENSION_RTPS")),
        fk("rrhh.regimen_pensionario", record.get("COD_REG_PENSION")),
        sql_date(record.get("FEC_INI_AFIL_AFP")),
        sql_date(record.get("FEC_FIN_AFIL_AFP")),
        map_regimen_laboral(record),
        fk("rrhh.tipo_trabajador", record.get("TIPO_TRABAJADOR")),
        fk("rrhh.tipo_trabajador_rtps", record.get("COD_TIP_TRAB")),
        fk("rrhh.ocupacion_rtps", record.get("COD_OCUPACION_RTPS")),
        fk_seccion(record.get("COD_AREA"), record.get("COD_SECCION")),
        fk_centro_costo(record.get("CENCOS")),
        fk_sucursal(record.get("_SUCURSAL_CODIGO")),
        sql_str(record.get("NRO_BREVETE")),
        sql_str(record.get("NRO_IPSS")),
        sql_str(record.get("COD_ORIGEN")),
        "NULL",
        sql_numeric(record.get("PORC_JUDICIAL"), "0"),
        sql_numeric(record.get("PORC_JUD_UTIL"), "0"),
        sql_flag(record.get("FLAG_CAT_TRAB"), "1"),
        sql_flag(record.get("FLAG_DSCTO_COMEDOR"), "0"),
        sql_date(record.get("FEC_INGRESO")),
        seed_fecha_cese(),
        seed_motivo_cese_id(),
        seed_flag_estado(record),
    ]
    return "(\n        " + ",\n        ".join(columns) + "\n    )"


INSERT_COLUMNS = [
    "codigo_trabajador", "nombres", "nombre1", "nombre2", "apellido_paterno", "apellido_materno",
    "tipo_doc_identidad_id", "numero_documento", "fecha_nacimiento", "sexo_id", "estado_civil_id",
    "direccion", "telefono_fijo", "celular1", "celular2", "codigo_tel_ciudad", "email",
    "flag_discapacidad", "flag_domiciliado", "flag_comision_afp", "flag_pensionista",
    "flag_afiliado_eps", "flag_essalud_vida", "flag_sctr_pension", "flag_sctr_salud", "flag_quinta_exonerado",
    "distrito_id", "tipo_via_id", "nombre_via", "numero_via", "tipo_zona_id", "nombre_zona", "tipo_vivienda_id",
    "interior", "referencia", "cuenta_bancaria_sueldo", "cuenta_cts", "banco_sueldo_id", "banco_cts_id",
    "moneda_sueldo_id", "moneda_cts_id", "admin_afp_id", "cuspp", "pension_rtps_id", "regimen_pensionario_id",
    "fec_ini_afil_afp", "fec_fin_afil_afp", "regimen_laboral_id", "tipo_trabajador_id", "tipo_trabajador_rtps_id",
    "ocupacion_rtps_id", "seccion_id", "centro_costo_id", "sucursal_id", "nro_brevete", "autogenerado_essalud",
    "procedencia", "comentario",
    "porc_judicial", "porc_jud_util", "flag_cat_trab", "flag_dscto_comedor",
    "fecha_ingreso", "fecha_cese", "motivo_cese_id", "flag_estado",
]

UPDATE_COLUMNS = [c for c in INSERT_COLUMNS if c not in ("codigo_trabajador",)]


def load_seed_records():
    """20 EMP + 20 JOR: Piura/Lima, 5 ONP + 5 AFP por grupo de 10."""
    with open(MAESTRO_PATH, encoding="utf-8") as handle:
        all_records = json.load(handle)["MAESTRO"]

    empleados = sorted(
        (record for record in all_records if record.get("TIPO_TRABAJADOR") == TIPO_EMP and is_vigente(record)),
        key=lambda row: str(row.get("COD_TRABAJADOR") or ""),
    )
    jornaleros = sorted(
        (record for record in all_records if record.get("TIPO_TRABAJADOR") == TIPO_JOR and is_vigente(record)),
        key=lambda row: str(row.get("COD_TRABAJADOR") or ""),
    )

    excluded = set()
    emp_piura = tag_sucursal(
        pick_workers(empleados, excluded, EMP_PER_SUCURSAL, ONP_PER_GROUP, AFP_PER_GROUP),
        SUCURSAL_PIURA,
    )
    excluded.update(str(row.get("COD_TRABAJADOR") or "") for row in emp_piura)

    emp_lima = tag_sucursal(
        pick_workers(empleados, excluded, EMP_PER_SUCURSAL, ONP_PER_GROUP, AFP_PER_GROUP),
        SUCURSAL_LIMA,
    )
    excluded.update(str(row.get("COD_TRABAJADOR") or "") for row in emp_lima)

    jor_piura = tag_sucursal(
        pick_workers(jornaleros, excluded, JOR_PER_SUCURSAL, ONP_PER_GROUP, AFP_PER_GROUP),
        SUCURSAL_PIURA,
    )
    excluded.update(str(row.get("COD_TRABAJADOR") or "") for row in jor_piura)

    jor_lima = tag_sucursal(
        pick_workers(jornaleros, excluded, JOR_PER_SUCURSAL, ONP_PER_GROUP, AFP_PER_GROUP),
        SUCURSAL_LIMA,
    )

    return emp_piura + emp_lima + jor_piura + jor_lima


def summarize_group(label, records):
    onp = [str(r.get("COD_TRABAJADOR")) for r in records if is_onp(r)]
    afp = [
        f"{r.get('COD_TRABAJADOR')}({r.get('COD_AFP')})"
        for r in records
        if not is_onp(r)
    ]
    return f"-- {label}: ONP={', '.join(onp)} | AFP={', '.join(afp)}"


def generate():
    load_afp_map()
    records = load_seed_records()
    emp_piura = [r for r in records if r.get("TIPO_TRABAJADOR") == TIPO_EMP and r.get("_SUCURSAL_CODIGO") == SUCURSAL_PIURA]
    emp_lima = [r for r in records if r.get("TIPO_TRABAJADOR") == TIPO_EMP and r.get("_SUCURSAL_CODIGO") == SUCURSAL_LIMA]
    jor_piura = [r for r in records if r.get("TIPO_TRABAJADOR") == TIPO_JOR and r.get("_SUCURSAL_CODIGO") == SUCURSAL_PIURA]
    jor_lima = [r for r in records if r.get("TIPO_TRABAJADOR") == TIPO_JOR and r.get("_SUCURSAL_CODIGO") == SUCURSAL_LIMA]

    values_sql = ",\n".join(build_row(record) for record in records)

    lines = [
        "-- Trabajadores SIGRE desde MAESTRO.json (20 EMP + 20 JOR muestra planilla)",
        "-- Filtro: FEC_CESE NULL, FLAG_ESTADO='1', FLAG_CAL_PLNLLA='1'",
        "-- Sucursal PI=Piura, LM=Lima; cada grupo de 10: 5 ONP (COD_AFP NULL) + 5 AFP distintas",
        summarize_group(f"EMP Piura ({SUCURSAL_PIURA})", emp_piura),
        summarize_group(f"EMP Lima ({SUCURSAL_LIMA})", emp_lima),
        summarize_group(f"JOR Piura ({SUCURSAL_PIURA})", jor_piura),
        summarize_group(f"JOR Lima ({SUCURSAL_LIMA})", jor_lima),
        "BEGIN;",
        "",
        "INSERT INTO rrhh.trabajador (",
        ",\n".join(f"    {col}" for col in INSERT_COLUMNS),
        ")",
        "VALUES",
        values_sql,
        "ON CONFLICT (codigo_trabajador) DO UPDATE SET",
        ",\n".join(f"    {col} = EXCLUDED.{col}" for col in UPDATE_COLUMNS) + ",",
        "    fec_modificacion = NOW();",
        "",
        "COMMIT;",
        "",
    ]
    OUT_PATH.write_text("\n".join(lines), encoding="utf-8")
    print(f"Generado {OUT_PATH} ({len(records)} trabajadores)")


if __name__ == "__main__":
    generate()
