# Plan de Trabajo en Paralelo — ms-produccion

## Objetivo

Dividir el desarrollo pendiente de ms-produccion entre **2 personas** sin generar conflictos de archivos, minimizando la coordinación necesaria.

## Cobertura vs Documentación Existente

De los 20 documentos en `05. Documentacion/markdown/Contratos/ms-produccion/`, 3 ya están implementados y 17 son pendientes:

| Documento | Estado | Responsable |
|---|---|---|
| `HU_OT_TIPO.md` + `CONTRATO_OT_TIPO.md` | ✅ Ya existente en el código | — |
| `HU_OT_ADMINISTRACION.md` + `CONTRATO_OT_ADMINISTRACION.md` | ✅ Ya existente en el código | — |
| `HU_LABOR.md` + `CONTRATO_LABOR.md` | ✅ Ya existente en el código | — |
| `HU_RECETA.md` + `CONTRATO_API_RECETA.md` | ✅ Implementado | Persona A |
| `HU_ARTICULO_DOC_TECNICA.md` + `CONTRATO_ARTICULO_DOC_TECNICA.md` | ✅ Implementado | Persona A |
| `HU_PROGRAMACION_PRODUCCION.md` + `CONTRATO_PROGRAMACION_PRODUCCION.md` | ✅ Implementado | Persona A |
| `HU_ORDEN_TRABAJO.md` + `CONTRATO_API_ORDEN_TRABAJO.md` | 📋 Pendiente → Persona B |
| `HU_PARTE_PRODUCCION.md` + `CONTRATO_API_PARTE_PRODUCCION.md` | 📋 Pendiente → Persona B |
| `HU_CONTROL_CALIDAD.md` + `CONTRATO_CONTROL_CALIDAD.md` | 📋 Pendiente → Persona B |
| `HU_COSTEO_PRODUCCION.md` + `CONTRATO_COSTEO_PRODUCCION.md` | 📋 Pendiente → Persona B |

## Principio de División

**Persona A (Planificación)**: Entidades que no dependen de nada nuevo — pueden avanzar solas.
**Persona B (Ejecución)**: Entidades que dependen solo de maestros ya implementados (ot_tipo, ot_admin, labor).

```
Persona A:  receta ──→ programacion_produccion
            articulo_doc_tecnica (independiente)

Persona B:  orden_trabajo ──→ parte_produccion ──→ control_calidad
                                                     costeo_produccion
```

## Mapa de Dependencias

```
                                ┌──────────────────────┐
              ┌─────────────────┤ Persona A (upstream) │
              │                 └──────────────────────┘
              │                      │
              ▼                      ▼
        ┌──────────┐          ┌──────────────────┐
        │ receta   │          │ articulo_doc_     │
        │ receta_  │          │ tecnica           │
        │ labor    │          │ articulo_doc_     │
        │ receta_  │          │ tecnica_caract_det│
        │ labor_   │          └──────────────────┘
        │ consumible│
        │ ficha_   │
        │ tecnica  │
        └────┬─────┘
             │
             ▼
    ┌────────────────┐
    │ programacion_   │ ← requiere DTO de receta y OT
    │ produccion      │
    └────────────────┘

┌─────────────────────────┐
│ Persona B (downstream)  │
└─────────────────────────┘
         │
         ▼
   ┌─────────────┐
   │ orden_trabajo│
   │ operacion    │
   │ operaciones_ │
   │ det          │
   └──────┬──────┘
          │
          ▼
   ┌──────────────┐
   │ parte_        │
   │ produccion    │
   │ parte_insumo  │
   │ parte_        │
   │ producido     │
   └──────┬───────┘
          │
    ┌─────┴────────────┐
    ▼                  ▼
┌──────────┐    ┌──────────────┐
│ control_  │    │ costeo_      │
│ calidad   │    │ produccion   │
└──────────┘    └──────────────┘
```

## División Detallada

### Persona A — "Planificación" (6 entidades, ~40 archivos)

| Paso | Entidad(s) | Archivos a crear | Depende de | Documento HU |
|---|---|---|---|---|
| 1 | `receta` | RecetaController, RecetaRequest/Response, RecetaEntity, RecetaMapper, RecetaRepository, RecetaService/Impl | `core.articulo` (existente), `labor` (existente) | `HU_RECETA.md` + `CONTRATO_API_RECETA.md` |
| 2 | `receta_labor` | RecetaLaborController (sub-resource), RecetaLaborRequest/Response, RecetaLaborEntity, RecetaLaborMapper, RecetaLaborRepository, RecetaLaborService/Impl | `receta` (paso 1), `labor` (existente) | (incluido en HU_RECETA) |
| 3 | `receta_labor_consumible` | ConsumibleController, ConsumibleRequest/Response, ConsumibleEntity, ConsumibleMapper, ConsumibleRepository, ConsumibleService/Impl | `receta` (paso 1) | (incluido en HU_RECETA) |
| 4 | `ficha_tecnica` | FichaTecnicaController, FichaTecnicaRequest/Response, FichaTecnicaEntity, FichaTecnicaMapper, FichaTecnicaRepository, FichaTecnicaService/Impl | `receta` (paso 1) | (incluido en HU_RECETA) |
| 5 | `articulo_doc_tecnica` + `articulo_doc_tecnica_caract_det` | DocTecnicaController, CaractDetController, Requests/Responses, Entities, Mappers, Repositories, Services | `core.articulo` (existente) | `HU_ARTICULO_DOC_TECNICA.md` + `CONTRATO_ARTICULO_DOC_TECNICA.md` |
| 6 | `programacion_produccion` | ProgramacionController, ProgramacionRequest/Response, ProgramacionEntity, ProgramacionMapper, ProgramacionRepository, ProgramacionService/Impl | `receta` (A), `orden_trabajo` (B) | `HU_PROGRAMACION_PRODUCCION.md` + `CONTRATO_PROGRAMACION_PRODUCCION.md` |

**Total archivos A**: ~40 (6 entidades × 6-7 capas + sub-recursos)

---

### Persona B — "Ejecución" (7 entidades, ~44 archivos)

| Paso | Entidad(s) | Archivos a crear | Depende de | Documento HU |
|---|---|---|---|---|
| 1 | `orden_trabajo` + `operacion` + `operaciones_det` | OTController, OperacionController (sub), DTOs, Entities, Mappers, Repositories, Services | `ot_tipo`, `ot_admin`, `labor` (existentes), `auth.sucursal` via JDBC | `HU_ORDEN_TRABAJO.md` + `CONTRATO_API_ORDEN_TRABAJO.md` |
| 2 | `parte_produccion` + `parte_insumo` + `parte_producido` | ParteController, InsumoController (sub), ProducidoController (sub), DTOs, Entities, Mappers, Repositories, Services | `orden_trabajo` (paso 1), `almacen.vale_mov` via JDBC | `HU_PARTE_PRODUCCION.md` + `CONTRATO_API_PARTE_PRODUCCION.md` |
| 3 | `control_calidad` | ControlCalidadController, ControlCalidadRequest/Response, ControlCalidadEntity, ControlCalidadMapper, ControlCalidadRepository, ControlCalidadService/Impl | `orden_trabajo` (paso 1) | `HU_CONTROL_CALIDAD.md` + `CONTRATO_CONTROL_CALIDAD.md` |
| 4 | `costeo_produccion` | CosteoController, CosteoRequest/Response, CosteoEntity, CosteoMapper, CosteoRepository, CosteoService/Impl | `orden_trabajo` (paso 1), `parte_produccion` (paso 2) | `HU_COSTEO_PRODUCCION.md` + `CONTRATO_COSTEO_PRODUCCION.md` |

**Total archivos B**: ~44 (7 entidades × 6-7 capas + sub-recursos)

---

## Punto de Acuerdo: programacion_produccion

`programacion_produccion` depende tanto de `receta` (Persona A) como de `orden_trabajo` (Persona B). Para evitar bloqueos:

1. Ambas personas **definen los DTOs antes de empezar**:
   - `RecetaResponse` (id, codigo, nombre) — lo mínimo que necesita programación
   - `OrdenTrabajoResponse` (id, codigo) — lo mínimo que necesita programación
2. Cada persona implementa su parte ignorando programación
3. Al final, Persona A implementa `programacion_produccion` usando los DTOs ya existentes de ambos lados

## Archivos que NADIE toca

| Archivo | Razón |
|---|---|
| `pom.xml` | Sin nuevas dependencias externas |
| `application.yml` | Sin cambios de configuración |
| `Dockerfile` | Sin cambios |
| `ProduccionSecurityConfig.java` | Sin cambios |
| `ProduccionJwtAuthenticationFilter.java` | Sin cambios |
| `TokensSessionVerifier.java` | Sin cambios |
| Directorios `event/`, `feign/`, `enums/` | Se implementan en fase posterior |
| Tests existentes | No deben romperse |

## Resumen de Carga

| Métrica | Persona A | Persona B |
|---|---|---|
| Entidades | 6 (receta, receta_labor, receta_labor_consumible, ficha_tecnica, doc_tecnica + caract_det, programacion) | 7 (orden_trabajo, operacion, operaciones_det, parte, parte_insumo, parte_producido, control_calidad, costeo) |
| Archivos nuevos | ~40 | ~44 |
| Orden | Secuencial interno (paso 1→6) | Secuencial interno (paso 1→4) |
| Dependencia externa | Ninguna | Ninguna (solo maestros existentes) |
| Bloqueos | Programación espera a OT de B | Ninguno |

## Convenio de Interfaces

Para evitar conflictos silenciosos:

- **DTOs compartidos** (RecetaResponse, OrdenTrabajoResponse): definir en un archivo compartido acordado al inicio
- **Nombres de endpoints**: mantener el patrón `/api/produccion/{recurso}` ya establecido
- **Prefix de errores**: usar la nomenclatura documentada (`PRD-RC-*`, `PRD-OT-*`, etc.)
- **Patrón de código**: idéntico al existente (ApiResponse, @Timed, @Transactional, baja lógica)
