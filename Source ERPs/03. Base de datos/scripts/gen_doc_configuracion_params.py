#!/usr/bin/env python3
"""Genera tablas markdown de parámetros SIGRE -> rrhh.configuracion para el análisis."""
import json
from decimal import Decimal
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "data"
OUT = Path(__file__).resolve().parent.parent.parent / "05. Documentacion" / "markdown" / "_gen_configuracion_params.md"

SKIP_COLUMNS = {"RECKEY", "FLAG_REPLICACION"}

EMP_RRHHPARAM = {
    "TIPO_TRAB_EMPLEADO", "TIPO_TRAB_TRIPULANTE", "TIPO_TRAB_OBRERO", "TOPE_ANO_SEG_INV",
    "GRC_GNN_FIJA", "GRC_SOBRET_GRD", "GRC_PAGO_DIAS", "GRC_DSC_LEY",
    "CNC_TOTAL_ING", "CNC_TOTAL_DSCT", "CNC_TOTAL_PGD", "CNC_TOTAL_APORT",
    "DIAS_RACION_COCIDA", "DIAS_MES_EMPLEADO", "DIAS_MES_OBRERO",
    "COD_CBSSP", "CNC_DSCTO_COMEDOR", "IMP_DSCTO_COMEDOR", "TURNO_DIA", "DOC_REG_AUTOMATICO",
}

EMP_CCONCEP = {
    "DIAS_INASIS_DSCCONT", "GAN_FIJ_CALC_VACAC", "PROM_REMUN_VACAC", "CONCEP_GAN_FIJ",
    "GRP_DOMINICAL", "ENFERM_PATRON_PIRM20", "SUBSIDIO_ENFERMEDAD", "MATERNIDAD",
    "GAN_FIJ_REINTEGRO", "CONCEP_CALC_REINTEGRO", "REINTEGRO_2530_POR_DIA",
    "SNP", "AFP_JUBILACION", "AFP_INVALIDEZ", "AFP_COMISION", "CONCEP_CALCULO_AFP", "GRP_CALC_CBSSP",
    "QUINTA_CAT_PROYECTA", "QUINTA_CAT_IMPRECISA", "GRATI_MEDIO_ANO", "GRATI_FIN_ANO",
    "DESCT_FIJO", "CONCEP_TARDANZA", "DSCTO_TARDANZA", "CALC_JUDIC", "DSCTO_ESSALUD_VIDA", "CNTA_CNTE",
    "CONCEP_SCTR_IPSS", "CONCEP_SCTR_ONP", "CONCEP_AFECTO_SENATI", "CNC_CRED_EPS", "CONCEP_ESSALUD",
    "CNC_ESSALUD_675", "AFECTO_PAGO_CTS_URGENCIA", "HORA_PERMISO_PART", "DESCTO_PERM_PART",
    "ADELANTO_QUINCENA",
}


def infer_data_type(value):
    if value is None:
        return "TEXT"
    if isinstance(value, bool):
        return "BOOLEAN"
    if isinstance(value, int):
        return "INTEGER"
    if isinstance(value, float):
        return "DECIMAL"
    if isinstance(value, str):
        stripped = value.strip()
        if not stripped:
            return "TEXT"
        try:
            int(stripped)
            return "INTEGER"
        except ValueError:
            pass
        try:
            Decimal(stripped)
            return "DECIMAL"
        except Exception:
            return "TEXT"
    return "TEXT"


def format_sigre_value(value):
    if value is None:
        return "NULL"
    if isinstance(value, str):
        text = value.strip()
        return text if text else "NULL"
    return str(value)


def format_config_value(data_type, value):
    if value is None:
        return "NULL", "NULL", "NULL"
    if data_type == "INTEGER":
        if isinstance(value, str):
            return "NULL", str(int(value.strip())), "NULL"
        return "NULL", str(int(value)), "NULL"
    if data_type == "DECIMAL":
        return "NULL", "NULL", str(value)
    text = str(value).strip() if isinstance(value, str) else str(value)
    return text if text else "NULL", "NULL", "NULL"


def table_rows(source, payload, highlight=None):
    lines = []
    for column, value in payload.items():
        if column.upper() in SKIP_COLUMNS:
            continue
        param = column.upper()
        data_type = infer_data_type(value)
        sigre_val = format_sigre_value(value)
        text_val, int_val, dec_val = format_config_value(data_type, value)
        mark = " **EMP**" if highlight and param in highlight else ""
        lines.append(
            f"| `{param}` | `{source}` | `{param}` | {data_type} | {sigre_val} | {text_val} | {int_val} | {dec_val} |{mark}"
        )
    return lines


def main():
    with open(DATA / "RRHHPARAM.json", encoding="utf-8") as handle:
        rrhhparam = json.load(handle)["RRHHPARAM"][0]
    with open(DATA / "RRHHPARAM_CCONCEP.json", encoding="utf-8") as handle:
        rrhhparam_cconcep = json.load(handle)["RRHHPARAM_CCONCEP"][0]

    header = (
        "| Columna SIGRE | `source` | `parameter` | `data_type` | Valor SIGRE | `value_text` | `value_int` | `value_dec` | Motor EMP |\n"
        "|---------------|----------|-------------|-------------|-------------|--------------|-------------|-------------|-------------|"
    )

    sections = [
        "## Apéndice generado — no editar a mano",
        "",
        "Regenerar: `python 03. Base de datos/scripts/gen_doc_configuracion_params.py`",
        "",
        "### RRHHPARAM completo",
        "",
        header,
        *table_rows("RRHHPARAM", rrhhparam, EMP_RRHHPARAM),
        "",
        "### RRHHPARAM_CCONCEP completo",
        "",
        header,
        *table_rows("RRHHPARAM_CCONCEP", rrhhparam_cconcep, EMP_CCONCEP),
    ]

    OUT.write_text("\n".join(sections) + "\n", encoding="utf-8")
    print(f"Generado: {OUT}")


if __name__ == "__main__":
    main()
