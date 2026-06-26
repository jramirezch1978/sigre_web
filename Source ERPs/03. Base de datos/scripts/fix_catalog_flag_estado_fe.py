#!/usr/bin/env python3
"""Actualiza componentes FE de catálogos SIGRE: estado -> flag_estado ('1'/'0')."""
from pathlib import Path

BASE = Path(__file__).resolve().parents[2] / ".." / "restpe-contabilidad-front-end" / "src" / "app" / "modules" / "rrhh" / "parametros" / "components"
BASE = BASE.resolve()
DIRS = [
    "p-tipo-sangre", "p-pension-rtps", "p-regimen-pensionario", "p-tipo-trabajador",
    "p-tipo-trabajador-rtps", "p-ocupacion-rtps", "p-motivo-cese", "p-seccion",
    "p-tipo-via", "p-tipo-zona", "p-tipo-vivienda",
]

OLD_ESTADO = (
    "  estado = [{ value: 'activo', label: 'Activo' }, { value: 'inactivo', label: 'Inactivo' }];\n"
    "  defaultEstado = this.estado[0].value;"
)
NEW_ESTADO = (
    "  flagEstadoOptions = [{ value: '1', label: 'Activo' }, { value: '0', label: 'Inactivo' }];\n"
    "  defaultFlagEstado = '1';"
)

for name in DIRS:
    ts = BASE / name / f"{name}.component.ts"
    html = BASE / name / f"{name}.component.html"
    text = ts.read_text(encoding="utf-8")
    text = text.replace(OLD_ESTADO, NEW_ESTADO)
    text = text.replace("estado: [this.defaultEstado]", "flag_estado: [this.defaultFlagEstado]")
    text = text.replace(", estado: event.data.", ", flag_estado: event.data.")
    text = text.replace("estado: this.defaultEstado", "flag_estado: this.defaultFlagEstado")
    text = text.replace("get('estado')", "get('flag_estado')")
    text = text.replace("const estadoValue", "const flagEstadoValue")
    text = text.replace("!estadoValue", "!flagEstadoValue")
    text = text.replace("_estado)", "_estado_value)")
    text = text.replace("flagEstadoValue === 'Activo'", "flagEstadoValue === '1'")
    text = text.replace("estadoValue !== this.filaSeleccionada?", "flagEstadoValue !== this.filaSeleccionada?")
    text = text.replace("estadoValue === 'Activo'", "flagEstadoValue === '1'")
    ts.write_text(text, encoding="utf-8")

    h = html.read_text(encoding="utf-8")
    h = h.replace('formControlName="estado"', 'formControlName="flag_estado"')
    h = h.replace('*ngFor="let e of estado"', '*ngFor="let e of flagEstadoOptions"')
    html.write_text(h, encoding="utf-8")
    print(f"updated {name}")
