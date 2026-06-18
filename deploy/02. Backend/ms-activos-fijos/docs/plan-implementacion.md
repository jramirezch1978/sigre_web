# Plan de implementación — `ms-activos-fijos`

**Fecha:** 14/05/2026

## Alcance del plan (obligatorio)

**Este plan solo cubre trabajo realizado y entregado dentro de:**

`02. Backend/ms-activos-fijos/`

Incluye: código Java, recursos `src/main/resources`, tests bajo `src/test`, `pom.xml`, `Dockerfile`, documentación y Postman **dentro de esa carpeta**.  
**No** forma parte de este plan modificar otros microservicios (`ms-contabilidad`, `ms-compras`, `ms-worker`, etc.); las integraciones se describen como **consumo desde este servicio** (clientes Feign, DTOs, configuración) asumiendo contratos ya expuestos por los demás equipos o por documentación externa de referencia.

**Remoto (GitHub / GitLab):** la ejecución de este plan se limita a cambios **locales** bajo `02. Backend/ms-activos-fijos/`. **No** incluye `git commit`, `git push`, merge requests ni ninguna otra acción sobre el repositorio remoto, salvo instrucción explícita aparte de este documento.

---

## Referencia funcional (lectura fuera de esta carpeta)

La definición de negocio y rutas objetivo puede consultarse en:

- `05. Documentacion/markdown/ALCANCE_MS-ACTIVOS-FIJOS.md` — alcance del proyecto (incluido / excluido).
- `05. Documentacion/orquestacion/ORQUESTACION_MS-ACTIVOS-FIJOS.md` — secuencias de API.
- `05. Documentacion/HUs por modulo/06_Activos_Fijos/` — historias de usuario originales.

Esa lectura **no** implica cambios de código fuera de `ms-activos-fijos`.

---

## Resumen

Ocho actividades agrupan el backlog del microservicio con el estilo de issue (título `ms-activos-fijos - N`, fuente, alcance, criterio de cierre), priorizando lo que **este** código debe exponer y consumir.

---

## Actividades (`ms-activos-fijos - N`)

### ms-activos-fijos - 1 — Fundamentos: catálogos, maestro de activo y ciclo de vida

**Fuente:** ORQUESTACION_MS-ACTIVOS-FIJOS §3.1–3.2, §3.9; HU-AF-001, HU-AF-OPE-001, HU-AF-TAB-007; Anexos A.1, A.2, A.9.

**Alcance:** CRUD y listados (clases, subclases, ubicaciones); tipos de operación (HU-AF-001) con integridad referencial; maestro de activo (alta/consulta/actualización/baja), numeración, datos de adquisición y FKs; base para accesorios/asignaciones si se amplía sin romper API.

**Criterio de cierre:** flujo POST→GET→PUT→PATCH desactivar con JWT definitivo; pruebas API de catálogos + maestro; OpenAPI alineada a rutas documentadas.

---

### ms-activos-fijos - 2 — Matriz contable por subclase y validación con plan de cuentas

**Fuente:** HU-AF-TAB-004; HU-CON-001, HU-CON-003 (integración módulos).

**Alcance:** Parametrización de cuentas (alta, depreciación, baja, venta, CC según HU); persistencia en activos; validación de cuentas contra tenant (consulta a ms-contabilidad o regla de proyecto acordada).

**Criterio de cierre:** CRUD matriz consultable; error de negocio ante cuenta inválida/inactiva; DDL y entidades alineados.

---

### ms-activos-fijos - 3 — Trazabilidad operativa: mantenimiento, historial y documentos

**Fuente:** ORQUESTACION_MS-ACTIVOS-FIJOS §3.3, §3.11; Anexos A.3, A.11.

**Alcance:** Operaciones de mantenimiento/reparación; historial por activo; documentos adjuntos (metadatos y referencia a almacenamiento si aplica); coherencia de activoId en todos los artefactos.

**Criterio de cierre:** al menos dos eventos distintos y consulta de historial consistente; operaciones y documentos enlazados al mismo maestro.

---

### ms-activos-fijos - 4 — Seguros: pólizas, vínculo a activos y devengo mensual de primas

**Fuente:** §3.4, §3.12; HU-AF-TAB-001, HU-AF-OPE-006, HU-AF-PRO-005; Anexo A.4.

**Alcance:** Aseguradoras, pólizas, vínculo póliza–activo; proceso de devengo mensual (batch o servicio invocable por worker) con control por periodo; preparación de asiento devengo (consumo en actividad 7).

**Criterio de cierre:** flujo aseguradora→póliza→vínculo; ejecución de devengo en datos de prueba con trazabilidad a póliza/periodo.

---

### ms-activos-fijos - 5 — Depreciación: motor, masivo, periodos y procesos programados

**Fuente:** HU-AF-PRO-001, HU-AF-OPE-008; §3.5, §3.10; ARQUITECTURA_RESTAURANT_PE.md (ms-worker).

**Alcance:** Cálculo mensual/masivo por método (lineal, acelerada, unidades con datos reales); residual, periodos no futuros, idempotencia; distribución por CC si aplica; jobs en ms-worker (o equivalente) para depreciación programada y re-ejecución segura.

**Criterio de cierre:** resultados cuadran con planilla de referencia; job en entorno de prueba con logs inicio/fin; sin duplicar cálculo del mismo activo-periodo.

---

### ms-activos-fijos - 6 — Movimientos del activo: traslados, adaptaciones, valuación y venta/baja

**Fuente:** §3.6–3.8; HU-AF-OPE-007, HU-AF-PRO-003; HUs de traslado, adaptación y venta en 06_Activos_Fijos.

**Alcance:** Traslados con workflow hasta actualizar ubicación/CC del maestro; adaptaciones/mejoras (cabecera/detalle) y efecto en base depreciable; valuación/revaluación y recálculo; registro de venta/disposición y bloqueo de depreciación futura; baja del maestro.

**Criterio de cierre:** flujos solicitud→confirmación en traslado; adaptación y revaluación reflejadas en siguiente depreciación; venta impide nuevo cálculo en periodos posteriores.

---

### ms-activos-fijos - 7 — Integraciones ERP: `ms-contabilidad` (asientos) y `ms-compras` (origen alta)

**Fuente:** HU-AF-PRO-002, matriz (actividad 2); arquitectura (alta desde compra/factura); criterio tipo ms-ventas - 7.

**Alcance:** Feign/eventos: pre-asientos o asientos por depreciación, revaluación, baja/venta, devengo de seguro; referencias cruzadas (activo, periodo, documento); alta o completado de activo desde OC/recepción/factura con validación de importes e IDs de compra.

**Criterio de cierre:** pruebas activos–contabilidad y compras–activos integradas; trazas correlacionadas; importes cuadran con origen AF o compra.

---

### ms-activos-fijos - 8 — Reportes, evidencias y calidad de entrega

**Fuente:** HU-AF-REP-001, HU-AF-REP-002, HU-AF-REP-003; ORQUESTACION_MS-ACTIVOS-FIJOS (token); estándar repo (ApiResponse, PageData, AF-*).

**Alcance:** Consultas o ms-reportes (depreciación detalle, libro de activos, export acordado); colección Postman (flujos 3.1–3.12 resumidos); tests y smoke checklist; cobertura mínima en servicios críticos.

**Criterio de cierre:** totales de reporte = motor depreciación en datos de prueba; Postman versionado bajo ms-activos-fijos/postman/; pipeline o suite local verde en escenarios smoke.

---

## Mapeo rápido → actividad

| Act. | Enfoque dentro de `ms-activos-fijos` |
|------|----------------------------------------|
| 1 | Controllers/servicios maestro y catálogos |
| 2 | Matriz contable + migraciones locales |
| 3 | Historial, documentos, operaciones + migraciones |
| 4 | Seguros y devengo en esquema `activos` |
| 5 | Motor `AfCalculoCntbl` / depreciación |
| 6 | Traslado, adaptación, valuación, venta |
| 7 | `client/*`, Feign, orquestación saliente |
| 8 | Postman, tests, `docs/` |

---

## Prioridad sugerida

**1 → 2 → 5 → 7**, luego **6** y **4**, **3** en paralelo, **8** continuo.

---

## Nota final

Cualquier issue derivada de este plan debe poder cerrarse con **diff únicamente bajo** `02. Backend/ms-activos-fijos/`. Si hace falta DDL compartido fuera de las migraciones de este MS (por ejemplo en `03. Base de datos`), acordar otro plan o issue de plataforma; aquí no está incluido salvo ampliación explícita de alcance.

---

## Estado de implementación (cierre técnico en código)

| Act. | Criterio del plan | Estado en `ms-activos-fijos` |
|------|-------------------|------------------------------|
| **1** | Catálogos, maestro, tipos operación, numeración, accesorios | **Cerrado:** catálogos y maestro; `AfTipoOperacionController` (HU-AF-001); `AfNumeracionController` (TAB-007/008); `AfAccesorioController`; traslado con `numero_documento` auto. |
| **2** | Matriz + validación cuentas | **Cerrado:** `AfMatrizSubClase*` + validación `contabilidad.plan_contable_det`. |
| **3** | Historial, documentos, operaciones | **Cerrado:** CRUD + historial automático; `af_operaciones.af_tipo_operacion_id` (FK opcional a catálogo). |
| **4** | Seguros y devengo | **Cerrado:** pólizas/vínculo/devengo; `registrarDevengoMasivo`; job `POST /jobs/devengo-prima-masivo`. |
| **5** | Depreciación + jobs | **Cerrado:** motor mensual/masivo; `POST /jobs/depreciacion-masiva` (invocable por ms-worker); CC en asiento vía matriz al contabilizar. |
| **6** | Traslados, adaptación, valuación, venta | **Cerrado:** workflow traslado; capitalización; valuación/venta con reglas documentadas. |
| **7** | Integración ERP | **Cerrado:** Feign contabilidad/compras; OC + recepción; asientos depreciación/devengo/venta/valuación/**alta/adaptación/baja**; contabilización **automática** (`contabilizar-automatico`); cuentas seguro en matriz. |
| **8** | Reportes y calidad | **Cerrado:** `AfReporteController` (REP-001 libro, REP-002 anual, REP-003 consolidado); tests totales= motor; Postman ampliado. |

### Migraciones Flyway (tenant `activos`)

| Versión | Contenido |
|---------|-----------|
| `V202602141400__…` | Matriz, historial, documento, prima devengo |
| `V202605141010__…` | UOP en maestro |
| `V202605161200__…` | Integración ERP (`cntbl_asiento_id`, refs OC) |
| `V202605161400__…` | Tipos operación, numeración, `af_tipo_operacion_id` en operaciones |
| `V202605161500__…` | `recepcion_compra_id` en maestro |
| `V202605161600__…` | Cuentas matriz seguro/alta/capitalización; `cntbl_asiento_id` en maestro y adaptación |
| `V202605171700__…` | Factura proveedor en maestro; `af_maestro_cc_distrib`; `cntbl_asiento_id` en traslado |

### APIs nuevas (resumen)

| Ruta base | Uso |
|-----------|-----|
| `/api/activos/tipos-operacion` | Catálogo HU-AF-001 |
| `/api/activos/numeracion/{tipo}` | Config y siguiente código |
| `/api/activos/accesorios` | Accesorios por maestro |
| `/api/activos/reportes/*` | REP-001/002/003 |
| `/api/activos/jobs/*` | Depreciación/devengo masivo (worker) |
| `/api/activos/integracion/*` | Contabilidad + compras (OC, recepción y factura) |
| `/api/activos/maestro/{id}/distribucion-cc` | Reparto % CC por activo (depreciación) |
| `/api/activos/reportes/libro-activos/export` | Export CSV/XLSX/PDF REP-001 |

<!-- PDF REP-001: GET …/libro-activos/export?formato=pdf — libro de activos a fecha corte; OpenPDF en AfReporteExportServiceImpl; ver ORQUESTACION §12 -->

### Verificación local

```bat
cd c:\RESTAURANTPE\PROYECTOS\restpe-contabilidad-back-end\02. Backend
mvn test -pl ms-activos-fijos
```

IT de factory (opcional, BD tenant):

```bat
mvn test -pl ms-activos-fijos -Dtest=ActivosTestDataFactorySmokeIT -Dactivos.it=true
```

### Documentación de contratos API

Índice marco: `05. Documentacion/markdown/Contratos/ms-activos-fijos/CONTRATO_API_ACTIVOS_FIJOS.md`.

### Extensiones cerradas (mayo 2026)

| Funcionalidad | Estado |
|---------------|--------|
| Alta desde factura (línea OC con `cantFacturada` > 0) | `POST …/compras/maestro-desde-factura` |
| Export REP-001 CSV/XLSX/PDF (12 cols HU §8) | `GET …/reportes/libro-activos/export?formato=` — codigo, descripcion, clase/subclase, ubicacion, fechas, montos, moneda, estado, CC |
| Distribución % multi-CC en depreciación | `GET/PUT …/maestro/{id}/distribucion-cc` |
| Asiento contable por traslado | `POST …/contabilidad/traslado/{id}`; auto `INTEGRACION_CONTABILIDAD_TRASLADO_AUTO` |
| Cron jobs | `ms-worker` → `ActivosFijosScheduledJob` |

Detalle integración: `docs/dependencias-integracion-saliente.md`.
