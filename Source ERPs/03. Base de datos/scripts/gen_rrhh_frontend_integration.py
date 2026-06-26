#!/usr/bin/env python3
"""Parchea store, facade, crud, repository, routing, module y sidebar para catálogos RRHH."""
from pathlib import Path

FRONTEND = Path(__file__).resolve().parents[3] / "restpe-contabilidad-front-end" / "src" / "app"

CATALOGS = [
    ("TipoSangre", "tipo-sangre", "tipos-sangre", "Tipos de sangre"),
    ("PensionRtps", "pension-rtps", "pensiones-rtps", "Pensiones RTPS (PLAME)"),
    ("RegimenPensionario", "regimen-pensionario", "regimenes-pensionario", "Régimen pensionario RTPS"),
    ("TipoTrabajador", "tipo-trabajador", "tipos-trabajador", "Tipos de trabajador (sistema)"),
    ("TipoTrabajadorRtps", "tipo-trabajador-rtps", "tipos-trabajador-rtps", "Tipos de trabajador RTPS (PLAME)"),
    ("OcupacionRtps", "ocupacion-rtps", "ocupaciones-rtps", "Ocupaciones RTPS"),
    ("Seccion", "seccion", "secciones", "Secciones"),
    ("MotivoCese", "motivo-cese", "motivos-cese", "Motivos de cese"),
    ("TipoVia", "tipo-via", "tipos-via", "Tipos de vía (RTPS)"),
    ("TipoZona", "tipo-zona", "tipos-zona", "Tipos de zona (RTPS)"),
    ("TipoVivienda", "tipo-vivienda", "tipos-vivienda", "Tipos de vivienda"),
]


def snake(name: str) -> str:
    import re
    s1 = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", name)
    return re.sub("([a-z0-9])([A-Z])", r"\1_\2", s1).lower()


def kebab(name: str) -> str:
    import re
    return re.sub(r"(?<!^)(?=[A-Z])", "-", name).lower()


def patch_file(path: Path, marker: str, block: str) -> None:
    text = path.read_text(encoding="utf-8")
    if marker in text:
        print(f"  skip {path.name} (ya parcheado)")
        return
    path.write_text(text.rstrip() + "\n" + block + "\n", encoding="utf-8")
    print(f"  patched {path.name}")


def patch_sidebar():
    path = FRONTEND / "layout" / "components" / "sidebar" / "sidebar.component.ts"
    text = path.read_text(encoding="utf-8")
    marker = "tipo-doc-identidad"
    if "tipo-sangre" in text:
        print("  skip sidebar")
        return
    entries = "\n".join(
        f"            {{ label: '{label}', link: '/rrhh/parametros/{route}' }},"
        for _, route, _, label in CATALOGS
    )
    insert = f"""
            {{ label: 'Tipo de documento de identidad (RTPS)', link: '/rrhh/parametros/tipo-doc-identidad' }},
{entries}
"""
    text = text.replace(
        "            { label: 'Tipos de documento de identidad (RTPS)', link: '/rrhh/parametros/tipo-doc-identidad' },\n",
        insert,
    )
    path.write_text(text, encoding="utf-8")
    print("  patched sidebar")


def patch_routing():
    path = FRONTEND / "modules" / "rrhh" / "apartado-rr-hh-routing.module.ts"
    text = path.read_text(encoding="utf-8")
    if "tipo-sangre" in text:
        print("  skip routing")
        return
    imports = "\n".join(
        f"import {{ P{entity}Component }} from './parametros/components/p-{route}/p-{route}.component';"
        for entity, route, _, _ in CATALOGS
    )
    routes = "\n".join(
        f"""  {{
    path: 'parametros/{route}',
    component: P{entity}Component,
    canDeactivate: [CanDeactivateGuard],
  }},"""
        for entity, route, _, _ in CATALOGS
    )
    text = text.replace(
        "import { PTipoDocIdentidadComponent }",
        imports + "\nimport { PTipoDocIdentidadComponent }",
    )
    text = text.replace(
        "  {\n    path: 'parametros/tipo-doc-identidad',",
        routes + "\n  {\n    path: 'parametros/tipo-doc-identidad',",
    )
    path.write_text(text, encoding="utf-8")
    print("  patched routing")


def patch_module():
    path = FRONTEND / "modules" / "rrhh" / "apartado-rr-hh.module.ts"
    text = path.read_text(encoding="utf-8")
    if "PTipoSangreComponent" in text:
        print("  skip module")
        return
    imports = "\n".join(
        f"import {{ P{entity}Component }} from './parametros/components/p-{route}/p-{route}.component';"
        for entity, route, _, _ in CATALOGS
    )
    decls = ",\n    ".join(f"P{entity}Component" for entity, _, _, _ in CATALOGS)
    providers = ",\n    ".join(f"Obtener{entity}UseCase" for entity, _, _, _ in CATALOGS)
    text = text.replace(
        "import { PTipoDocIdentidadComponent }",
        imports + "\nimport { PTipoDocIdentidadComponent }",
    )
    text = text.replace(
        "import { ObtenerTipoDocIdentidadUseCase }",
        "\n".join(
            f"import {{ Obtener{entity}UseCase }} from './application/usecases/obtener-{kebab(entity)}.usecase';"
            for entity, _, _, _ in CATALOGS
        )
        + "\nimport { ObtenerTipoDocIdentidadUseCase }",
    )
    text = text.replace(
        "PTipoDocIdentidadComponent,",
        decls + ",\n    PTipoDocIdentidadComponent,",
    )
    text = text.replace(
        "ObtenerTipoDocIdentidadUseCase,",
        providers + ",\n    ObtenerTipoDocIdentidadUseCase,",
    )
    path.write_text(text, encoding="utf-8")
    print("  patched module")


def patch_crud():
    path = FRONTEND / "modules" / "rrhh" / "infrastructure" / "services" / "rr-hh-crud.service.ts"
    text = path.read_text(encoding="utf-8")
    if "crearTipoSangre" in text:
        print("  skip crud")
        return
    blocks = []
    for entity, _, api, _ in CATALOGS:
        blocks.append(f"""
  crear{entity}(body: {{ codigo: string; nombre: string }}): Observable<ApiResponse<unknown>> {{
    return this.http.post<ApiResponse<unknown>>(`${{this.base}}/rrhh/{api}`, body);
  }}
  actualizar{entity}(id: number, body: {{ codigo: string; nombre: string }}): Observable<ApiResponse<unknown>> {{
    return this.http.put<ApiResponse<unknown>>(`${{this.base}}/rrhh/{api}/${{id}}`, body);
  }}
  activar{entity}(id: number): Observable<ApiResponse<unknown>> {{
    return this.http.patch<ApiResponse<unknown>>(`${{this.base}}/rrhh/{api}/${{id}}/activar`, {{}});
  }}
  desactivar{entity}(id: number): Observable<ApiResponse<unknown>> {{
    return this.http.patch<ApiResponse<unknown>>(`${{this.base}}/rrhh/{api}/${{id}}/desactivar`, {{}});
  }}""")
    text = text.rstrip() + "\n" + "\n".join(blocks) + "\n}\n"
    if text.endswith("\n}\n}\n"):
        text = text[:-3] + "\n}\n"
    path.write_text(text, encoding="utf-8")
    print("  patched crud")


def main():
    patch_sidebar()
    patch_routing()
    patch_module()
    patch_crud()
    print("Integración frontend parcial completada. Revisar store/facade/repository manualmente si faltan.")


if __name__ == "__main__":
    main()
