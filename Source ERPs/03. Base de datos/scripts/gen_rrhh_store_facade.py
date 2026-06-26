#!/usr/bin/env python3
"""Parchea state, store, facade y repository para catálogos RRHH."""
from pathlib import Path

FE = Path(__file__).resolve().parents[3] / "restpe-contabilidad-front-end" / "src" / "app" / "modules" / "rrhh"

CATALOGS = [
    ("TipoSangre", "tipo_sangre"),
    ("PensionRtps", "pension_rtps"),
    ("RegimenPensionario", "regimen_pensionario"),
    ("TipoTrabajador", "tipo_trabajador"),
    ("TipoTrabajadorRtps", "tipo_trabajador_rtps"),
    ("OcupacionRtps", "ocupacion_rtps"),
    ("Seccion", "seccion"),
    ("MotivoCese", "motivo_cese"),
    ("TipoVia", "tipo_via"),
    ("TipoZona", "tipo_zona"),
    ("TipoVivienda", "tipo_vivienda"),
]

APIS = {
    "TipoSangre": "tipos-sangre",
    "PensionRtps": "pensiones-rtps",
    "RegimenPensionario": "regimenes-pensionario",
    "TipoTrabajador": "tipos-trabajador",
    "TipoTrabajadorRtps": "tipos-trabajador-rtps",
    "OcupacionRtps": "ocupaciones-rtps",
    "Seccion": "secciones",
    "MotivoCese": "motivos-cese",
    "TipoVia": "tipos-via",
    "TipoZona": "tipos-zona",
    "TipoVivienda": "tipos-vivienda",
}


def kebab(name: str) -> str:
    import re
    return re.sub(r"(?<!^)(?=[A-Z])", "-", name).lower()


def prop(name: str) -> str:
    return name[0].lower() + name[1:]


def patch_state():
    path = FE / "store" / "rr-hh.state.ts"
    text = path.read_text(encoding="utf-8")
    if "tipoSangre:" in text:
        print("state skip")
        return
    for e, _ in reversed(CATALOGS):
        k = kebab(e)
        text = text.replace(
            "import { TipoContratoEntity }",
            f"import {{ {e}Entity }} from '../domain/models/{k}.entity';\nimport {{ TipoContratoEntity }}",
        )
        text = text.replace(
            "  tipoContrato: TipoContratoEntity[];",
            f"  {prop(e)}: {e}Entity[];\n  loading{e}: boolean;\n  error{e}: string | null;\n  tipoContrato: TipoContratoEntity[];",
        )
        text = text.replace(
            "  tipoContrato: [],",
            f"  {prop(e)}: [],\n  loading{e}: false,\n  error{e}: null,\n  tipoContrato: [],",
        )
    path.write_text(text, encoding="utf-8")
    print("state ok")


def patch_store():
    path = FE / "store" / "rr-hh.store.ts"
    text = path.read_text(encoding="utf-8")
    if "setTipoSangre" in text:
        print("store skip")
        return
    for e, _ in reversed(CATALOGS):
        k = kebab(e)
        text = text.replace(
            "import { TipoContratoEntity }",
            f"import {{ {e}Entity }} from '../domain/models/{k}.entity';\nimport {{ TipoContratoEntity }}",
        )
        text = text.replace(
            "  readonly tipoContrato = computed",
            f"  readonly {prop(e)} = computed(() => this.state().{prop(e)});\n"
            f"  readonly loading{e} = computed(() => this.state().loading{e});\n"
            f"  readonly error{e} = computed(() => this.state().error{e});\n\n"
            f"  readonly tipoContrato = computed",
        )
        methods = f"""
  setLoading{e}(loading: boolean): void {{
    this.state.update(s => ({{ ...s, loading{e}: loading }}));
  }}

  set{e}(data: {e}Entity[]): void {{
    this.state.update(s => ({{ ...s, {prop(e)}: data, loading{e}: false, error{e}: null }}));
  }}

  clear{e}(): void {{
    this.state.update(s => ({{ ...s, {prop(e)}: [], error{e}: null }}));
  }}

  setError{e}(error: string): void {{
    this.state.update(s => ({{ ...s, error{e}: error, loading{e}: false }}));
  }}
"""
        text = text.replace("  setLoadingTipoContrato(loading: boolean): void {", methods + "\n  setLoadingTipoContrato(loading: boolean): void {")
    path.write_text(text, encoding="utf-8")
    print("store ok")


def patch_facade():
    path = FE / "application" / "facades" / "rr-hh.facade.ts"
    text = path.read_text(encoding="utf-8")
    if "cargarTipoSangre" in text:
        print("facade skip")
        return
    for e, _ in reversed(CATALOGS):
        k = kebab(e)
        text = text.replace(
            "import { ObtenerTipoContratoUseCase }",
            f"import {{ Obtener{e}UseCase }} from '../usecases/obtener-{k}.usecase';\nimport {{ ObtenerTipoContratoUseCase }}",
        )
        text = text.replace(
            "  private readonly obtenerTipoContratoUseCase = inject(ObtenerTipoContratoUseCase);",
            f"  private readonly obtener{e}UseCase = inject(Obtener{e}UseCase);\n  private readonly obtenerTipoContratoUseCase = inject(ObtenerTipoContratoUseCase);",
        )
        text = text.replace(
            "  readonly tipoContrato = this.store.tipoContrato;",
            f"  readonly {prop(e)} = this.store.{prop(e)};\n"
            f"  readonly loading{e} = this.store.loading{e};\n"
            f"  readonly error{e} = this.store.error{e};\n\n"
            f"  readonly tipoContrato = this.store.tipoContrato;",
        )
        block = f"""
  cargar{e}(): void {{
    this.store.setLoading{e}(true);
    this.obtener{e}UseCase.execute().subscribe({{
      next: (data) => this.store.set{e}(data),
      error: (err) => this.store.setError{e}(err?.message ?? 'Error al cargar {prop(e)}'),
    }});
  }}

  guardar{e}(data: {{ codigo: string; nombre: string }}, id?: number): Observable<ApiResponse<unknown>> {{
    return id ? this.crud.actualizar{e}(id, data) : this.crud.crear{e}(data);
  }}

  cambiarEstado{e}(id: number, activo: boolean): Observable<ApiResponse<unknown>> {{
    return activo ? this.crud.activar{e}(id) : this.crud.desactivar{e}(id);
  }}
"""
        text = text.replace(
            "  guardarTipoContrato(data: { codigo: string; nombre: string }, id?: number): Observable<ApiResponse<unknown>> {",
            block + "\n  guardarTipoContrato(data: { codigo: string; nombre: string }, id?: number): Observable<ApiResponse<unknown>> {",
        )
    path.write_text(text, encoding="utf-8")
    print("facade ok")


def patch_repository():
    iface = FE / "domain" / "repositories" / "ireportes.repository.ts"
    impl = FE / "infrastructure" / "repository" / "reportes.repository.impl.ts"
    itext = iface.read_text(encoding="utf-8")
    rtext = impl.read_text(encoding="utf-8")
    if "obtenerTipoSangre" in itext:
        print("repository skip")
        return
    for e, grid in reversed(CATALOGS):
        k = kebab(e)
        itext = itext.replace(
            "import { TipoContratoEntity }",
            f"import {{ {e}Entity }} from '../models/{k}.entity';\nimport {{ TipoContratoEntity }}",
        )
        itext = itext.replace(
            "  abstract obtenerTipoContrato(): Observable<TipoContratoEntity[]>;",
            f"  abstract obtener{e}(): Observable<{e}Entity[]>;\n  abstract obtenerTipoContrato(): Observable<TipoContratoEntity[]>;",
        )
        rtext = rtext.replace(
            "import { TipoContratoEntity }",
            f"import {{ {e}Entity }} from '../../domain/models/{k}.entity';\nimport {{ TipoContratoEntity }}",
        )
        method = f"""
  obtener{e}(): Observable<{e}Entity[]> {{
    return this.http
      .get<ApiResponse<PaginatedResponse<{{ id?: number; codigo?: string; nombre?: string; flagEstado?: string }}>>>(
        `${{this.baseUrl}}/rrhh/{APIS[e]}?size=1000&sort=nombre,asc`,
      )
      .pipe(
        map(response => (response.data?.content ?? []).map(item => ({{
          id: item.id,
          {grid}_codigo: item.codigo ?? String(item.id),
          {grid}_nombre: item.nombre ?? '',
          {grid}_estado: item.flagEstado === '1' ? 'Activo' : 'Inactivo',
          {grid}_estado_value: item.flagEstado === '1' ? 'activo' : 'inactivo',
        }}))),
        catchError(() => of([])),
      );
  }}
"""
        rtext = rtext.replace(
            "  obtenerTipoContrato(): Observable<TipoContratoEntity[]> {",
            method + "\n  obtenerTipoContrato(): Observable<TipoContratoEntity[]> {",
        )
    iface.write_text(itext, encoding="utf-8")
    impl.write_text(rtext, encoding="utf-8")
    print("repository ok")


if __name__ == "__main__":
    patch_state()
    patch_store()
    patch_facade()
    patch_repository()
