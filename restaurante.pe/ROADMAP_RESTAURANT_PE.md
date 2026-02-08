# Roadmap — Proyecto Restaurant.pe

**Documento:** Mapa de ruta para el desarrollo del ERP Restaurant.pe  
**Alcance:** 9 módulos, multipaís, multiempresa, multisucursal  
**Stack:** Backend Java/Spring Boot · Frontend Angular 20 · Base de datos PostgreSQL  
**Plazo objetivo:** 5 meses (20 semanas)  

---

## 1. Visión y objetivo del roadmap

El roadmap ordena el desarrollo siguiendo la misma lógica de dependencias del ERP SIGRE:

1. **Maestros primero:** Todos los maestros de todos los módulos se construyen en la primera fase. Sin datos maestros, ningún proceso puede operar.
2. **Compras + Almacén + Ventas:** Son el motor operativo del ERP. Compras genera documentos de adquisición, Almacén recibe mercadería y controla stock (inseparables). Ventas se desarrolla en paralelo: gestiona mesas, órdenes, comandas, facturación electrónica y cierre de caja. Ventas genera CxC para Finanzas y descarga stock de Almacén.
3. **Finanzas + Activos Fijos:** Finanzas necesita que Compras genere documentos por pagar (CxP) y que Ventas genere documentos por cobrar (CxC). Activos Fijos se alimenta de las compras de activos y requiere la estructura financiera.
4. **RRHH en paralelo con Contabilidad:** RRHH necesita la infraestructura financiera lista (cuentas bancarias, formas de pago). Contabilidad necesita que todos los módulos generen pre-asientos. Ambos son independientes entre sí y se desarrollan en paralelo.
5. **Producción** se desarrolla junto con RRHH/Contabilidad, ya que solo necesita Almacén (que ya está listo).
6. **Plazo total:** Máximo **5 meses** (20 semanas).

```mermaid
flowchart LR
    A["Fase 1\nFundación + Maestros"] --> B["Fase 2\nCompras + Almacén + Ventas"]
    B --> C["Fase 3\nFinanzas + Activos Fijos"]
    C --> D["Fase 4\nProducción + Contabilidad"]
    C --> E["Fase 4.1 (paralelo)\nRRHH"]
```

---

## 2. Equipo de desarrollo

### 2.1 Composición total: 21 personas

Para cumplir con el plazo de 5 meses se requieren **3 equipos funcionales** trabajando en paralelo desde la Fase 2, más un equipo transversal.

| Rol | Cant. | Dedicación | Responsabilidad |
|-----|:-----:|:----------:|-----------------|
| **Tech Lead / Arquitecto** | 1 | 100% todo el proyecto | Arquitectura de microservicios, revisiones de código, decisiones técnicas, integración entre equipos |
| **Scrum Master / PM** | 1 | 100% todo el proyecto | Gestión de sprints, seguimiento de hitos, gestión de impedimentos |
| **Analista Funcional / BA** | 2 | 100% todo el proyecto | Refinamiento de HUs, validación funcional, criterios de aceptación, pruebas UAT |
| **DevOps** | 1 | 100% todo el proyecto | Jenkins (build + test + SonarQube), entornos, Docker, despliegues manuales, monitoreo |
| **DBA** | 1 | 100% Fases 1–2, 50% Fases 3–4 | Modelo de datos, migraciones Flyway, performance, índices, backup/restore, streaming replication |
| **Backend Senior (Java/Spring Boot)** | 8 | 100% asignados a equipos | Desarrollo de microservicios, APIs REST, lógica de negocio |
| **Frontend (Angular 20)** | 5 | 100% asignados a equipos | Pantallas, componentes, integración con APIs, UX |
| **QA / Tester** | 2 | 100% desde Fase 2 | Pruebas funcionales, regresión, automatización (Cypress E2E), tests de integración (Testcontainers), tests de contrato (Spring Cloud Contract), performance testing semanal |

### 2.2 Distribución por equipo

```mermaid
flowchart TB
    subgraph Equipo_Infra["Equipo Infra (Fase 1 — luego se disuelve)"]
        I1[1 Tech Lead]
        I2[1 Backend Sr]
        I3[1 Frontend]
        I4[1 DevOps]
        I5[1 DBA]
    end
    subgraph Equipo_A["Equipo A: Compras + Almacén (F2) → Producción (F4)"]
        A1[3 Backend Sr]
        A2[2 Frontend]
        A3[1 QA]
    end
    subgraph Equipo_B["Equipo B: Finanzas + Activos (F3) → Contabilidad (F4)"]
        B1[3 Backend Sr]
        B2[2 Frontend]
        B3[1 QA]
    end
    subgraph Equipo_C["Equipo C: RRHH (F4, paralelo a Contabilidad)"]
        C1[2 Backend Sr]
        C2[1 Frontend]
    end
    subgraph Transversal["Transversal (todo el proyecto)"]
        T1[1 Tech Lead]
        T2[1 Scrum Master]
        T3[2 Analistas Funcionales]
    end
```

> **Nota:** En la Fase 1 todo el equipo trabaja junto en fundación y maestros. En la Fase 2, el Equipo A (Compras+Almacén) toma el liderazgo mientras B apoya. En la Fase 3, el Equipo B lidera Finanzas+Activos. En la Fase 4, Equipo A (Producción) y B (Contabilidad) trabajan juntos. En paralelo, la Fase 4.1 corre con el Equipo C (RRHH) de forma independiente.

---

## 3. Diagrama de dependencias entre módulos

El orden de las fases respeta las dependencias funcionales del ERP. Contabilidad es el receptor final de todos los módulos operativos.

```mermaid
flowchart TB
    subgraph Fundación
        AUTH[Autenticación y permisos]
        EMP[Multiempresa / Sucursales]
        CONF[Configuraciones base]
    end
    subgraph Core
        ALM[Almacén]
        COM[Compras]
        VEN[Ventas]
    end
    subgraph Finanzas
        TES[Tesorería]
        CxC[Cuentas por cobrar]
        CxP[Cuentas por pagar]
    end
    subgraph Contabilidad
        CNT[Contabilidad]
    end
    subgraph Extensión
        RRHH[RRHH]
        AF[Activos fijos]
        PROD[Producción]
    end
    AUTH --> ALM
    AUTH --> COM
    EMP --> ALM
    EMP --> COM
    CONF --> ALM
    ALM --> COM
    ALM --> CNT
    COM --> CxP
    COM --> CNT
    TES --> CNT
    CxC --> CNT
    CxP --> CNT
    RRHH --> CNT
    AF --> CNT
    PROD --> CNT
    ALM --> PROD
    RRHH <--> PROD
    AUTH --> VEN
    EMP --> VEN
    CONF --> VEN
    VEN --> CxC
    VEN --> CNT
    ALM -->|stock| VEN
```

> **Nota:** Fundación (Auth, Multiempresa, Configuraciones) es transversal a todos los módulos. Contabilidad recibe pre-asientos de todos los módulos operativos.

---

## 4. Fases del proyecto (4 fases, 20 semanas)

```mermaid
flowchart TB
    subgraph Fase1["Fase 1: Fundación + TODOS los Maestros (S1–S5)"]
        direction LR
        F1A[Infraestructura y Auth]
        F1B[Todos los maestros de todos los módulos]
    end
    subgraph Fase2["Fase 2: Compras + Almacén (S6–S11)"]
        direction LR
        F2A["Eq. A+B: Compras (OC, OS, aprobaciones, recepción)"]
        F2B["Eq. A+B: Almacén (movimientos, kardex, stock)"]
    end
    subgraph Fase3["Fase 3: Finanzas + Activos Fijos (S11–S16)"]
        direction LR
        F3A["Eq. B: Finanzas (CxP, CxC, Tesorería)"]
        F3B["Eq. A: Activos Fijos (depreciación, seguros)"]
    end
    subgraph Fase4["Fase 4: Producción + Contabilidad (S15–S20)"]
        direction LR
        F4A["Eq. A: Producción (recetas, órdenes, costeo)"]
        F4B["Eq. B: Contabilidad (asientos, cierres, EEFF)"]
        F4C[Integración + QA + Piloto]
    end
    subgraph Fase41["Fase 4.1 (paralelo): RRHH (S15–S20)"]
        direction LR
        F41A["Eq. C: RRHH (planilla, asistencia, liquidaciones)"]
    end
    Fase1 --> Fase2
    Fase2 --> Fase3
    Fase3 --> Fase4
    Fase3 --> Fase41
```

---

## 5. Timeline global — Gantt detallado (20 semanas)

```mermaid
gantt
    title Roadmap Restaurant.pe — 20 semanas (5 meses)
    dateFormat YYYY-MM-DD
    axisFormat %d/%m

    section Fase 1 — Fundación + TODOS los Maestros
    Infraestructura (Eureka, Gateway, Config, Auth)          :f1a, 2026-03-02, 2w
    Maestros Core (empresa, sucursal, país, moneda, TC)      :f1b, 2026-03-02, 2w
    Maestros Relaciones Comerciales (prov/cli unificado)     :f1c, 2026-03-16, 2w
    Maestros Artículos (categorías, unidades, naturaleza)    :f1d, 2026-03-16, 2w
    Maestros Almacén + Compras + Finanzas + Contab + RRHH    :f1e, 2026-03-30, 1w
    Maestros Activos Fijos + Producción + Auditoría          :f1f, 2026-03-30, 1w
    Frontend Shell + Login + Menú dinámico + CRUDs           :f1fe, 2026-03-02, 5w
    Hito M1 — Maestros listos                                :milestone, m1, 2026-04-06, 0d

    section Fase 2 — Compras + Almacén + Ventas
    Compras: OC + OS + aprobaciones multinivel               :f2a1, 2026-04-06, 3w
    Compras: Recepción + integración almacén                 :f2a2, after f2a1, 1w
    Almacén: Movimientos + kardex + valorización             :f2a3, 2026-04-06, 3w
    Almacén: Inventario físico + ajustes + devoluciones      :f2a4, after f2a3, 1w
    Ventas: Mesas + órdenes + comandas + POS                 :f2v1, 2026-04-06, 3w
    Ventas: Documentos + facturación electrónica + cierre    :f2v2, after f2v1, 3w
    Reportes Compras + Almacén + Ventas                      :f2a5, after f2a2, 2w
    Hito M2 — Compras + Almacén + Ventas operativos          :milestone, m2, 2026-05-18, 0d

    section Fase 3 — Finanzas + Activos Fijos
    Finanzas: CxP (facturas, pagos, NC/ND)                   :f3a1, 2026-05-11, 2w
    Finanzas: CxC (cobros, aplicación, letras)               :f3a2, 2026-05-11, 2w
    Finanzas: Tesorería + conciliaciones bancarias            :f3a3, after f3a1, 2w
    Finanzas: Adelantos + fondo fijo + caja chica             :f3a4, after f3a3, 1w
    Activos: Registro + depreciación + revaluación            :f3b1, 2026-05-11, 2w
    Activos: Seguros + pólizas + bajas + traslados            :f3b2, after f3b1, 2w
    Reportes Finanzas + Activos Fijos                         :f3a5, after f3a4, 1w
    Hito M3 — Finanzas + Activos operativos                   :milestone, m3, 2026-06-22, 0d

    section Fase 4 — Producción + Contabilidad
    Eq.A Producción: Recetas + órdenes + costeo                :f4a1, 2026-06-15, 3w
    Eq.A Producción: Consumo almacén + reportes                :f4a2, after f4a1, 1w
    Eq.B Contabilidad: Asientos manuales + automáticos         :f4b1, 2026-06-15, 2w
    Eq.B Contabilidad: Pre-asientos desde todos los módulos    :f4b2, after f4b1, 1w
    Eq.B Contabilidad: Cierres mensual + anual + EEFF          :f4b3, after f4b2, 2w
    Eq.B Contabilidad: Libros electrónicos (PLE/SIRE)          :f4b4, after f4b3, 1w
    Integración contable de TODOS los módulos                  :f4int, 2026-07-13, 1w
    QA integral + pruebas end-to-end                           :f4qa, after f4int, 1w
    Piloto con usuarios reales                                 :f4pilot, after f4qa, 1w
    Hito M4 — ERP completo en producción                       :milestone, m4, 2026-08-03, 0d

    section Fase 4.1 — RRHH (en paralelo)
    Eq.C RRHH: Ficha trabajador + contratos                   :f41c1, 2026-06-15, 2w
    Eq.C RRHH: Asistencia (POS/App/GPS)                       :f41c2, after f41c1, 1w
    Eq.C RRHH: Planilla + CTS + gratificaciones               :f41c3, after f41c2, 2w
    Eq.C RRHH: Liquidaciones + propinas + regulatorios         :f41c4, after f41c3, 1w
    Eq.C RRHH: Reportes + archivos (PLAME)                    :f41c5, after f41c4, 1w
    Hito M4.1 — RRHH operativo                                :milestone, m41, 2026-08-03, 0d
```

---

## 6. Detalle por fase

### Fase 1: Fundación + TODOS los Maestros (Semanas 1–5)

**Duración:** 5 semanas  
**Equipo:** Todo el equipo (21 personas)  
**Objetivo:** Infraestructura lista y TODOS los maestros de TODOS los módulos construidos (backend + frontend).

#### Semanas 1–2: Infraestructura y maestros organizacionales

| Responsable | Tarea |
|-------------|-------|
| Tech Lead + DevOps | Eureka Server, Config Server, API Gateway, Redis, MinIO (storage dev). Jenkins (build + test automático) con SonarQube + JaCoCo (quality gates: cobertura ≥70%, 0 bugs). Despliegues manuales con Docker. ELK Stack base (Elasticsearch + Logstash + Kibana). Prometheus + Grafana (dashboards infra). Zipkin (tracing distribuido) |
| Backend 1–2 | ms-auth-security: login, JWT, usuarios, roles dinámicos, permisos, opciones de menú |
| Backend 3–4 | ms-core-maestros: empresa, sucursal, país, departamento, provincia, distrito, moneda, tipo de cambio |
| Backend 5–6 | ms-core-maestros: impuestos, retenciones, detracciones, parámetros del sistema, ejercicios/períodos |
| DBA | BD Master (auth + master), BD Template (10 schemas de negocio), migraciones Flyway multi-tenant, BD empresa demo, backup automático (pg_dump diario + WAL archiving), scripts de restore por tenant |
| Frontend 1–2 | Angular shell, layout principal, login, selección empresa/sucursal |
| Frontend 3 | Componentes reutilizables (tablas, formularios, filtros, paginación) |
| Analistas | Validación de campos y reglas de negocio de cada maestro |

#### Semanas 3–4: Maestros de negocio

| Responsable | Tarea |
|-------------|-------|
| Backend 1–2 | ms-core-maestros: relacion_comercial (unificado prov/cli), tipo_documento_identidad, contactos, cuentas bancarias |
| Backend 3–4 | ms-core-maestros: artículo, categoría (4 niveles), unidad_medida, conversión, naturaleza_contable, artículo_proveedor, artículo_almacén |
| Backend 5 | ms-core-maestros: condición_pago, forma_pago, secuencias de documentos |
| Backend 6 | ms-almacen: almacén (maestro), tipo_movimiento |
| Backend 7 | ms-contabilidad: cuenta_contable (plan contable jerárquico), centro_costo, libro_contable, matriz_contable |
| Backend 8 | ms-rrhh: área, cargo, concepto_planilla, AFP · ms-activos-fijos: clase_activo, ubicación_física, aseguradora |
| Frontend 1–5 | CRUD de todos los maestros (pantallas de mantenimiento) |
| DBA | Migraciones Flyway multi-tenant, seed data en template (países, monedas, impuestos) |

#### Semana 5: Maestros restantes + validación cruzada

| Responsable | Tarea |
|-------------|-------|
| Backend todos | ms-finanzas: cuenta_bancaria, caja, concepto_financiero, flujo_caja_concepto |
| Backend todos | ms-produccion: receta (estructura), receta_detalle |
| Backend todos | ms-auditoria: log_auditoria, log_acceso |
| Frontend todos | Menú dinámico funcional, CRUDs completos, validaciones |
| QA | Pruebas de todos los maestros, validación de datos, permisos |
| Analistas | UAT de maestros con reglas de negocio |
| Backend (migración) | Desarrollar scripts ETL (Python + cx_Oracle + Pandas) para migración de maestros desde SIGRE (Oracle 11gR2, 2,770 tablas): PROVEEDOR→relacion_comercial, ARTICULO→articulo, ARTICULO_CATEG→categoria, UNIDAD→unidad_medida, MONEDA→moneda, BANCO→banco, MARCA→marca, DOC_TIPO→tipo_documento_tributario. Endpoints de importación masiva (CSV/Excel). **Mapeo detallado:** [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md) sección 14 |

**Criterio de salida (Hito M1):** Todos los maestros con CRUD funcional en backend y frontend (incluyendo tablas adicionales: banco, marca, tipo_documento_tributario, catalogo_sunat). Menú dinámico cargando por roles. Auth + multiempresa operativo. Infraestructura de observabilidad operativa (ELK + Prometheus/Grafana + Zipkin). Jenkins operativo con quality gates SonarQube pasando (cobertura ≥70%). Despliegues manuales documentados. Redis y MinIO configurados. ETL de maestros SIGRE validado.

---

### Fase 2: Compras + Almacén + Ventas (Semanas 6–11)

**Duración:** 6 semanas  
**Equipos:** A lidera Compras + Almacén, B lidera Ventas (en paralelo)  
**Referencia SIGRE:** Estos son los módulos con mayor volumen transaccional. En SIGRE, Compras y Almacén comparten más de 1,500 objetos de código fuente (211+150 tablas referenciadas en ws_objects). Ventas se desarrolla en paralelo por su independencia funcional. Incluye tablas derivadas de SIGRE: guía de remisión (obligatoria SUNAT), comprador, aprobador configurado, punto de venta, reservación, carta del restaurante.

#### Equipo A: Compras (5 Backend + 3 Frontend + 1 QA)

| Semana | Backend | Frontend |
|:------:|---------|----------|
| S6–S8 | OC: emisión, detalle, estados, numeración automática por sucursal | Pantalla OC con búsqueda proveedor/artículos |
| S6–S8 | OS: emisión, detalle, vinculación a proveedor de servicio | Pantalla OS |
| S8 | Workflow aprobación multinivel (configurable por monto/tipo) | Bandeja de aprobaciones |
| S9 | Recepción: vinculación con OC, generación automática mov. almacén | Pantalla recepción con validación contra OC |
| S10 | Devoluciones a proveedores, solicitudes de reposición | Pantallas devolución y reposición |
| S10–S11 | Reportes: OC pendientes, compras por proveedor, por período | Reportes con filtros y export Excel/PDF |

#### Equipo A: Almacén (3 Backend + 2 Frontend + 1 QA)

| Semana | Backend | Frontend |
|:------:|---------|----------|
| S6–S8 | Movimientos ingreso/salida/traslado, confirmación, validación stock | Pantalla de movimientos con detalle |
| S8–S9 | Kardex valorizado (promedio ponderado), cálculo stock, precio promedio | Consulta de kardex y stock |
| S9 | Inventario físico: toma, comparación con stock sistema, ajustes | Pantalla inventario físico |
| S10 | Traslados entre almacenes, stock en tránsito | Pantalla traslados |
| S10–S11 | Reportes: stock actual, movimientos por período, valorización | Reportes con filtros y export |

#### Equipo B: Ventas (4 Backend + 3 Frontend + 1 QA)

| Semana | Backend | Frontend |
|:------:|---------|----------|
| S6–S7 | Zonas, mesas, turnos, apertura/cierre de caja | Pantalla de gestión de mesas y turnos |
| S7–S8 | Órdenes de venta, comandas, estados, WebSocket/STOMP para notificación en tiempo real a cocina/bar | POS: pantalla de toma de pedidos, pantalla cocina con recepción en tiempo real |
| S8–S9 | Documentos de venta (boleta/factura), detalle, numeración automática | Pantalla emisión documentos, selección forma de pago |
| S9–S10 | Notas de crédito/débito, anulaciones, propinas, descuentos/promociones | Pantallas de NC/ND, configuración descuentos |
| S10 | Facturación electrónica (SUNAT): generación XML, envío OSE, CDR | Monitoreo de envío y estado SUNAT |
| S10–S11 | Cierre de caja (cuadre), reportes: ventas por día/turno/mesero, ticket promedio | Dashboard de ventas, reporte de cierre |

**Criterio de salida (Hito M2):** Flujo completo Proveedor → OC → Aprobación → Recepción → Movimiento Almacén → Stock → Kardex operativo. Flujo de venta: Mesa → Orden → Comanda (con WebSocket a cocina en tiempo real) → Documento → Facturación electrónica → Cierre de caja. Devoluciones y ajustes funcionales. Quality gate SonarQube pasando (cobertura ≥70%, 0 bugs/vulnerabilidades).

---

### Fase 3: Finanzas + Activos Fijos (Semanas 11–16)

**Duración:** 6 semanas  
**Equipos:** B lidera Finanzas, A lidera Activos Fijos  
**Referencia SIGRE:** Finanzas es el módulo más complejo después de Compras/Almacén (244 tablas referenciadas en ws_objects). Involucra CxP, CxC, Tesorería, conciliaciones y adelantos. Incluye tablas derivadas de SIGRE: detracción, retención IGV (obligatorias por normativa SUNAT), flujo de caja. Activos Fijos gestiona depreciación, seguros y control patrimonial (41 tablas referenciadas).

#### Equipo B: Finanzas (4 Backend + 2 Frontend + 1 QA)

| Semana | Backend | Frontend |
|:------:|---------|----------|
| S11–S12 | CxP: registro facturas (desde OC y directas), estados, NC/ND | Pantalla CxP con vinculación a OC |
| S11–S12 | CxC: registro cobros, aplicación a documentos, letras | Pantalla CxC |
| S13–S14 | Tesorería: movimientos bancarios, transferencias, programación pagos | Pantalla tesorería |
| S14 | Conciliación bancaria + conciliación con pasarelas (Niubiz, Yape, Plin) | Pantalla conciliación |
| S15 | Adelantos/OG, fondo fijo por PdV, caja chica, liquidaciones | Pantallas adelantos y cajas |
| S16 | Reportes: estado cuenta proveedor/cliente, flujo caja, antigüedad saldos | Reportes con filtros y export |

#### Equipo A: Activos Fijos (3 Backend + 2 Frontend)

| Semana | Backend | Frontend |
|:------:|---------|----------|
| S11–S12 | Registro de activos, vinculación a compra/factura, datos técnicos | Pantalla ficha activo completa |
| S13–S14 | Depreciación mensual automática, revaluación, cálculo valor neto | Pantalla depreciación + ejecución masiva |
| S14–S15 | Seguros/pólizas, traslados con workflow, bajas | Pantallas seguros y traslados |
| S16 | Reportes: depreciación acumulada, activos por ubicación, seguros vigentes | Reportes |

**Criterio de salida (Hito M3):** Ciclo CxP (factura → programación → pago) y CxC (documento → cobro → aplicación) operativos. Conciliación bancaria funcional. Activos con depreciación mensual calculada.

---

### Fase 4: Producción + Contabilidad (Semanas 15–20)

**Duración:** 6 semanas (con overlap de 1 semana sobre Fase 3)  
**Equipos:** A (Producción) y B (Contabilidad)  
**Referencia SIGRE:** Contabilidad es el receptor final de pre-asientos de todos los módulos (251 tablas referenciadas en ws_objects). Incluye distribución contable (prorrateo de gastos entre centros de costo). Producción (263 tablas referenciadas) se adapta al contexto gastronómico: plantillas de producción → recetas, con ficha técnica (alérgenos, valores nutricionales).

#### Equipo A: Producción (3 Backend + 2 Frontend)

| Semana | Backend | Frontend |
|:------:|---------|----------|
| S15–S16 | Recetas (detalle insumos con merma), versiones de receta | Pantalla receta con drag & drop insumos |
| S17 | Órdenes de producción, consumo automático de almacén | Pantalla orden de producción |
| S18 | Costeo por receta (materia prima + mano de obra + indirectos) | Pantalla costeo consolidado |
| S18 | Reportes: costos, consumos, rendimiento por receta | Reportes |

#### Equipo B: Contabilidad (3 Backend + 2 Frontend + 1 QA)

| Semana | Backend | Frontend |
|:------:|---------|----------|
| S15–S16 | Asientos manuales + asientos automáticos desde matrices contables | Pantalla asiento contable |
| S17 | Motor de pre-asientos: recepción desde Compras, Almacén, Finanzas, Activos | Motor de procesamiento |
| S17–S18 | Pre-asientos desde RRHH (planilla) y Producción (costos) | Integración asincrónica |
| S18–S19 | Cierres: mensual (bloqueo período), anual (traslado resultados) | Pantalla cierre contable |
| S19 | EEFF: Balance General, Estado de Resultados, Flujo de Efectivo, Patrimonio | Pantalla EEFF con export |
| S19 | Libros electrónicos (PLE/SIRE u equivalente por país) | Generación archivos |

#### Integración y cierre (Equipos A + B, Semanas 18–20)

| Semana | Actividad |
|:------:|-----------|
| S18–S19 | Integración contable de TODOS los módulos (verificar que todos generen pre-asientos correctos) |
| S19 | QA integral: pruebas end-to-end con Cypress (flujos completos: compra → almacén → CxP → pago → asiento contable). Tests de contrato entre microservicios (Spring Cloud Contract). Performance testing |
| S19 | DevOps/DBA: Configurar streaming replication (PostgreSQL Standby). Prueba de Disaster Recovery. Dashboards de monitoreo finales (Grafana: negocio + BD + RabbitMQ). Configurar alertas de producción |
| S20 | Piloto con usuarios reales, corrección de bugs críticos |
| S20 | Documentación operativa, runbook de DR y entrega |

**Criterio de salida (Hito M4):** Cierre contable ejecutado. Producción con costeo. Integración de pre-asientos de todos los módulos. Backup automático y streaming replication configurados. Prueba de DR exitosa. Monitoreo y alertas operativos. Quality gates SonarQube pasando (cobertura ≥70%, 0 bugs). Al menos un piloto exitoso.

---

### Fase 4.1 (en paralelo): RRHH (Semanas 15–20)

**Duración:** 6 semanas (corre en paralelo con la Fase 4)  
**Equipo:** C (RRHH) — equipo independiente  
**Referencia SIGRE:** RRHH es el módulo más grande del SIGRE (364 tablas referenciadas en ws_objects, 180 tablas en BD). Incluye tablas derivadas de SIGRE: gratificación (julio/diciembre), CTS, retención de quinta categoría, evaluación de desempeño — todas obligatorias por legislación laboral peruana. Necesita la infraestructura financiera (cuentas bancarias, formas de pago) que ya estará lista desde Fase 3.

> **Justificación del paralelismo:** RRHH gestiona personas y planilla; Contabilidad gestiona asientos y cierres. Son independientes entre sí. La integración (pre-asientos de planilla → Contabilidad) se cierra en las últimas semanas de la Fase 4.

#### Equipo C: RRHH (2 Backend + 1 Frontend)

| Semana | Backend | Frontend |
|:------:|---------|----------|
| S15–S16 | Ficha trabajador completa, contratos, renovaciones, historial | Pantalla ficha empleado |
| S16 | Asistencia: marcaciones POS/App/biométrico, reglas tardanza/falta | Pantalla asistencia y marcación |
| S17–S18 | Planilla: cálculo sueldo, horas extra, CTS, gratificaciones, AFP, EsSalud | Pantalla cálculo planilla |
| S18 | Liquidaciones, beneficios sociales, propinas, recargo al consumo | Pantalla liquidaciones |
| S19 | PLAME, archivos regulatorios, boletas de pago electrónicas | Generación archivos y boletas |
| S19–S20 | Reportes: planilla, asistencia, headcount, rotación, KPIs | Reportes |

**Criterio de salida (Hito M4.1):** Planilla calculada y pagada. Liquidaciones procesadas. Archivos regulatorios generados. RRHH operativo.

---

## 7. Hitos principales

| # | Hito | Semana | Fecha estimada | Descripción |
|---|------|:------:|:--------------:|-------------|
| M1 | Maestros listos | S5 | Fin mes 1 | Todos los CRUD de maestros funcionales, auth + menú dinámico |
| M2 | Compras + Almacén operativos | S11 | Fin mes 2.5 | Flujo OC → Aprobación → Recepción → Stock → Kardex cerrado |
| M3 | Finanzas + Activos operativos | S16 | Fin mes 4 | CxP/CxC, tesorería, conciliación, depreciación de activos |
| M4 | Producción + Contabilidad operativos | S20 | Fin mes 5 | Contabilidad con cierres y EEFF, producción con costeo, piloto exitoso |
| M4.1 | RRHH operativo | S20 | Fin mes 5 | Planilla calculada y pagada, liquidaciones, archivos regulatorios |

```mermaid
timeline
    title Hitos Restaurant.pe (20 semanas)
    Semana 5  : M1 Maestros listos
    Semana 11 : M2 Compras + Almacen operativos
    Semana 16 : M3 Finanzas + Activos operativos
    Semana 20 : M4 Produccion + Contabilidad operativos
             : M4.1 RRHH operativo (paralelo)
```

---

## 8. Arquitectura de microservicios

### 8.1 Visión general

El backend se construye como un ecosistema de **microservicios** independientes, cada uno con su propia responsabilidad, comunicados a través de un **API Gateway** y registrados en un **Eureka Server** (service discovery).

```mermaid
flowchart TB
    subgraph Cliente
        ANG[Angular 20 - SPA]
    end
    subgraph Infraestructura
        GW[API Gateway - Spring Cloud Gateway]
        EU[Eureka Server - Service Discovery]
        CFG[Config Server - Spring Cloud Config]
    end
    subgraph Microservicios
        MS_AUTH[ms-auth-security]
        MS_CORE[ms-core-maestros]
        MS_ALM[ms-almacen]
        MS_COM[ms-compras]
        MS_FIN[ms-finanzas]
        MS_CNT[ms-contabilidad]
        MS_RRHH[ms-rrhh]
        MS_AF[ms-activos-fijos]
        MS_PROD[ms-produccion]
        MS_VEN[ms-ventas]
        MS_AUD[ms-auditoria]
        MS_RPT[ms-reportes]
        MS_NOTIF[ms-notificaciones]
    end
    subgraph BD["PostgreSQL 16 — Database-per-Tenant"]
        DB_MASTER[(BD Master\nrestaurant_pe_master\nauth + tenant registry)]
        DB_TENANT[(BD por Empresa\nrestaurant_pe_emp_N\n10 schemas de negocio)]
    end
    subgraph Bus["Bus de eventos"]
        MQ[[RabbitMQ]]
    end
    ANG --> GW
    GW --> EU
    GW --> MS_AUTH
    GW --> MS_CORE
    GW --> MS_ALM
    GW --> MS_COM
    GW --> MS_FIN
    GW --> MS_CNT
    GW --> MS_RRHH
    GW --> MS_AF
    GW --> MS_PROD
    GW --> MS_VEN
    GW --> MS_AUD
    GW --> MS_RPT
    GW --> MS_NOTIF
    MS_AUTH --> DB_MASTER
    MS_CORE --> DB_TENANT
    MS_ALM --> DB_TENANT
    MS_COM --> DB_TENANT
    MS_FIN --> DB_TENANT
    MS_CNT --> DB_TENANT
    MS_RRHH --> DB_TENANT
    MS_AF --> DB_TENANT
    MS_PROD --> DB_TENANT
    MS_VEN --> DB_TENANT
    MS_AUD --> DB_TENANT
    MS_AUTH -.->|"provee tenants\n/internal/tenants"| MS_CORE
    MS_AUTH -.->|provee tenants| MS_ALM
    MS_AUTH --> EU
    MS_CORE --> EU
    MS_ALM --> EU
    MS_COM --> EU
    MS_FIN --> EU
    MS_CNT --> EU
    MS_RRHH --> EU
    MS_AF --> EU
    MS_PROD --> EU
    MS_VEN --> EU
    MS_AUD --> EU
    MS_RPT --> EU
    MS_NOTIF --> EU
    CFG --> MS_AUTH
    CFG --> MS_CORE
    CFG --> MS_ALM
    MS_ALM -->|evento| MQ
    MS_COM -->|evento| MQ
    MS_VEN -->|evento| MQ
    MQ -->|pre-asiento| MS_CNT
    MQ -->|log| MS_AUD
```

### 8.2 Catálogo de microservicios (16 servicios)

| # | Microservicio | Puerto base | Responsabilidad | Fase |
|---|--------------|:-----------:|----------------|:----:|
| 1 | **eureka-server** | 8761 | Service discovery. Todos los servicios se registran aquí | 1 |
| 2 | **config-server** | 8888 | Configuración centralizada (perfiles dev/qa/prod, por país) | 1 |
| 3 | **api-gateway** | 8080 | Punto de entrada único. Ruteo, rate limiting, CORS, balanceo | 1 |
| 4 | **ms-auth-security** | 9001 | Autenticación (JWT), usuarios, roles, permisos, opciones de menú, auditoría de acceso. **Único servicio conectado a BD Master.** Provee connection strings de tenants a los demás ms | 1 |
| 5 | **ms-core-maestros** | 9002 | Maestros compartidos: empresas, sucursales, países, monedas, tipo de cambio, impuestos, relaciones comerciales (proveedores/clientes), artículos, categorías, unidades de medida. Conecta a BD por empresa vía `TenantRoutingDataSource` | 1 |
| 6 | **ms-almacen** | 9003 | Almacenes, tipos de movimiento, movimientos de inventario, kardex, valorización, stock, devoluciones, traslados | 2 |
| 7 | **ms-compras** | 9004 | Condiciones de pago, OC, OS, aprobaciones, recepción, planificación de abastecimiento | 2 |
| 8 | **ms-finanzas** | 9005 | Tesorería, CxC, CxP, adelantos, cuentas bancarias, conciliaciones, flujo de caja, programación de pagos | 3 |
| 9 | **ms-contabilidad** | 9006 | Plan contable, centros de costo, asientos, pre-asientos, matrices contables, cierres, libros electrónicos, EEFF | 4 |
| 10 | **ms-rrhh** | 9007 | Trabajadores, contratos, asistencia, nómina, beneficios, liquidaciones, reclutamiento, talento, archivos regulatorios | 4.1 |
| 11 | **ms-activos-fijos** | 9008 | Registro de activos, depreciación, revaluación, seguros, bajas, traslados | 3 |
| 12 | **ms-produccion** | 9009 | Recetas, órdenes de producción, costeo por receta, consumo de inventario | 4 |
| 13 | **ms-ventas** | 9010 | Integración con POS, documentos de venta, notas de crédito/débito, cierre de caja, propinas, descuentos, mesas/comandas, facturación electrónica | 2 |
| 14 | **ms-auditoria** | 9011 | Registro centralizado de auditoría: quién, cuándo, qué, desde dónde (todos los servicios envían eventos) | 1 |
| 15 | **ms-reportes** | 9012 | Motor de reportes (JasperReports o similar), exportación PDF/Excel, reportes compartidos entre módulos | 2 |
| 16 | **ms-notificaciones** | 9013 | Envío de correos, alertas del sistema, recordatorios, notificaciones push | 2 |

### 8.3 Servicios de infraestructura (además de los microservicios)

| Servicio | Puerto | Uso | Fase |
|----------|:------:|-----|:----:|
| **PostgreSQL 16** | 5432 | Base de datos (Master + Template + Tenants) | 1 |
| **RabbitMQ** | 5672 / 15672 | Mensajería asincrónica (pre-asientos, auditoría, notificaciones, tenant sync) | 1 |
| **Redis 7** | 6379 | Caché (sesiones, menú, config, stock), rate limiting en Gateway | 1 |
| **MinIO** (dev) / **S3** (prod) | 9000 | Almacenamiento de archivos aislado por tenant (logos, fotos, documentos, regulatorios) | 1 |
| **Elasticsearch** | 9200 | Indexación y búsqueda de logs centralizados | 1–2 |
| **Logstash** | 5044 | Recolección y transformación de logs (JSON → Elasticsearch) | 1–2 |
| **Kibana** | 5601 | Visualización y análisis de logs | 1–2 |
| **Prometheus** | 9090 | Recolección de métricas de todos los microservicios (Spring Actuator) | 1–2 |
| **Grafana** | 3000 | Dashboards de monitoreo (infra, JVM, gateway, negocio, BD, RabbitMQ) + alertas | 1–2 |
| **Zipkin / Jaeger** | 9411 | Tracing distribuido entre microservicios | 2 |

### 8.4 Comunicación entre microservicios

```mermaid
flowchart LR
    subgraph Sincrónica
        A[REST / OpenFeign] --> B[Para consultas directas entre servicios]
    end
    subgraph Asincrónica
        C[Eventos / RabbitMQ o Kafka] --> D[Para pre-asientos contables, auditoría, notificaciones]
    end
```

| Tipo | Uso | Ejemplo |
|------|-----|---------|
| **REST + OpenFeign** | Consultas sincrónicas entre servicios | ms-compras consulta a ms-core-maestros para validar proveedor |
| **Eventos (mensajería)** | Operaciones que disparan acciones en otros servicios | ms-almacen emite evento "movimiento_creado" → ms-contabilidad genera pre-asiento |
| **API Gateway** | Toda comunicación del frontend pasa por aquí | Angular llama a `/api/almacen/stock` → Gateway rutea a ms-almacen |

---

## 9. Control de acceso: roles, permisos y menú dinámico

### 9.1 Modelo de seguridad

El sistema de acceso se basa en **roles creados a demanda por el usuario administrador**. Cada usuario tiene **un solo rol por empresa** (vía la tabla `usuario_empresa`), y de manera extraordinaria puede tener opciones de menú asignadas individualmente.

> **Nota:** Con Database-per-Tenant, las tablas de seguridad residen en la BD Master (`restaurant_pe_master.auth`). Un usuario puede tener acceso a **múltiples empresas**, cada una con un rol diferente.

```mermaid
flowchart TB
    subgraph Entidades
        USR[Usuario]
        UE[Usuario-Empresa]
        ROL[Rol]
        MENU[Opción de menú]
        MOD[Módulo]
        TENANT[Tenant / Empresa]
    end
    USR -->|1:N accede a N empresas| UE
    TENANT -->|1:N tiene N usuarios| UE
    UE -->|N:1 un rol por empresa| ROL
    ROL -->|N:M un rol tiene muchas opciones| MENU
    MENU -->|N:1 una opción pertenece a un módulo| MOD
    USR -.->|N:M extraordinario / individual por empresa| MENU
```

> **Cardinalidades:** Un usuario puede tener acceso a **muchas empresas** (vía `usuario_empresa`). En cada empresa tiene **un solo rol**. Un rol tiene **una o muchas** opciones de menú. Una opción puede estar en **muchos** roles. Una opción pertenece a **un solo** módulo. De manera **extraordinaria**, un usuario puede tener opciones de menú individuales por empresa.

### 9.2 Reglas de negocio del control de acceso

1. **Roles dinámicos:** Los roles NO son fijos en código. El usuario administrador crea, modifica y elimina roles a demanda (ej.: "Jefe de almacén Lima", "Contador corporativo", "Cajero sucursal X").
2. **Un usuario = un rol por empresa:** Cada usuario tiene asignado **un solo rol por empresa** (vía `usuario_empresa`). Un usuario puede tener roles diferentes en empresas diferentes. Al hacer login y seleccionar empresa, se carga el rol correspondiente.
3. **Opciones de menú por rol:** Cada rol tiene asociadas **una o muchas** opciones de menú. Una opción de menú puede estar asignada a **uno o muchos** roles. Al seleccionar empresa, el frontend carga **únicamente** las opciones del rol del usuario en esa empresa.
4. **Asignación individual (extraordinaria):** De manera excepcional, un usuario puede tener asociadas **una o muchas opciones de menú de forma individual por empresa**, sin que estén en su rol. Esto cubre casos como: un usuario que necesita acceso puntual a una pantalla que no corresponde a su rol.
5. **Menú cargado por módulo:** El frontend organiza las opciones de menú agrupadas por módulo. Solo se muestran los módulos que tengan al menos una opción permitida (ya sea por rol o por asignación individual).
6. **Permisos por acción:** Cada opción de menú puede tener permisos granulares: ver, crear, editar, eliminar, aprobar, imprimir, exportar.
7. **Scope multiempresa (Database-per-Tenant):** Los permisos aplican dentro del contexto de la empresa seleccionada. El header `X-Empresa-Id` dirige cada request a la BD correcta. Las tablas de negocio **no tienen `empresa_id`** — cada BD es de una sola empresa.

### 9.3 Flujo de carga del menú dinámico (con selección de empresa)

El flujo se divide en **dos pasos**: primero autenticación y luego selección de empresa.

```mermaid
sequenceDiagram
    participant U as Usuario
    participant FE as Angular 20
    participant GW as API Gateway
    participant AUTH as ms-auth-security
    participant MASTER as BD Master

    rect rgb(240, 248, 255)
        Note over U,MASTER: PASO 1 — Autenticación
        U->>FE: Inicia sesión (usuario + contraseña)
        FE->>GW: POST /api/auth/login
        GW->>AUTH: Validar credenciales
        AUTH->>MASTER: Verificar usuario (auth.usuario)
        MASTER-->>AUTH: Usuario válido + lista de empresas
        AUTH-->>FE: Token temporal + lista de empresas
    end

    rect rgb(255, 248, 240)
        Note over U,MASTER: PASO 2 — Selección de empresa
        U->>FE: Selecciona empresa
        FE->>GW: POST /api/auth/seleccionar-empresa {empresaId}
        GW->>AUTH: Forward
        AUTH->>MASTER: Obtener rol + permisos + opciones de menú (para esa empresa)
        MASTER-->>AUTH: Rol, permisos, opciones del rol, opciones individuales
        AUTH->>AUTH: Generar JWT definitivo (con empresaId)
        AUTH-->>GW: JWT + estructura de menú por módulo
        GW-->>FE: Response
        FE->>FE: Renderizar menú dinámico (solo opciones permitidas)
    end

    Note over U,MASTER: Peticiones de negocio
    U->>FE: Navega a opción de menú
    FE->>GW: GET /api/almacen/stock (JWT + X-Empresa-Id)
    GW->>AUTH: Validar JWT + verificar permiso
    AUTH-->>GW: Autorizado
    GW->>FE: Respuesta del microservicio
```

> Si el usuario solo tiene acceso a **una empresa**, el paso 2 se ejecuta automáticamente.

### 9.4 Estructura de datos de seguridad (esquema `auth` en BD Master)

> **Importante:** Todas las tablas de seguridad residen en `restaurant_pe_master.auth`, ya que son transversales a todas las empresas. Un usuario puede tener acceso a múltiples empresas, cada una con un rol diferente.

| Tabla | Campos principales | Descripción |
|-------|-------------------|-------------|
| `usuario` | id, username, password_hash, email, nombre, activo | Usuarios del sistema (sin `rol_id` directo) |
| `usuario_empresa` | id, usuario_id, **empresa_id** (FK a master.tenant), **rol_id** (FK), sucursal_default_id, activo | Relación usuario ↔ empresa. **Un usuario tiene un rol por empresa** |
| `rol` | id, codigo, nombre, descripcion, activo | Roles creados a demanda. Un rol agrupa opciones de menú |
| `modulo` | id, codigo, nombre, icono, orden | Módulos del ERP (Almacén, Compras, etc.) |
| `opcion_menu` | id, modulo_id, padre_id, codigo, nombre, ruta_frontend, icono, orden, activo | Opciones del menú (jerárquicas). Una opción pertenece a **un solo módulo** |
| `accion` | id, codigo, nombre | Acciones posibles (ver, crear, editar, eliminar, aprobar, imprimir, exportar) |
| `permiso` | id, opcion_menu_id, accion_id | Permiso = opción de menú + acción |
| `rol_opcion_menu` | rol_id, opcion_menu_id | Opciones de menú asignadas al rol (N:M) |
| `rol_permiso` | rol_id, permiso_id | Permisos granulares (acciones) asignados al rol |
| `usuario_opcion_menu` | usuario_id, empresa_id, opcion_menu_id | Opciones de menú individuales **por empresa** (N:M extraordinario) |
| `usuario_permiso` | usuario_id, empresa_id, permiso_id | Permisos granulares individuales por empresa |
| `sesion` | id, usuario_id, empresa_id, token, ip, fecha_inicio, fecha_fin, activa | Control de sesiones (con empresa seleccionada) |

**Tabla de tenants** (esquema `master` en BD Master):

| Tabla | Campos principales | Descripción |
|-------|-------------------|-------------|
| `tenant` | id, codigo, nombre, db_name, db_host, db_port, db_username, db_password (AES), activo, fecha_creacion | Registro de empresas y sus connection strings |

---

## 10. Base de datos — PostgreSQL (Database-per-Tenant)

### 10.1 Estrategia de multitenancy

El sistema utiliza el patrón **Database-per-Tenant** de PostgreSQL, aprovechando la función nativa `CREATE DATABASE ... TEMPLATE`. Cada empresa (tenant) tiene su **propia base de datos**, lo que garantiza aislamiento total.

```mermaid
flowchart TB
    subgraph PostgreSQL["PostgreSQL 16 Server"]
        subgraph Master["restaurant_pe_master"]
            direction LR
            M_AUTH["schema: auth\n(usuarios, roles, permisos)"]
            M_TENANT["schema: master\n(registro de tenants)"]
        end
        subgraph Template["restaurant_pe_template"]
            direction LR
            T1["core"] ~~~ T2["almacen"] ~~~ T3["compras"] ~~~ T4["ventas"] ~~~ T5["finanzas"]
            T6["contabilidad"] ~~~ T7["rrhh"] ~~~ T8["activos"] ~~~ T9["produccion"] ~~~ T10["auditoria"]
        end
        subgraph Emp1["restaurant_pe_emp_1 (Lima SAC)"]
            E1["Clon exacto del template"]
        end
        subgraph Emp2["restaurant_pe_emp_2 (Bogotá SAS)"]
            E2["Clon exacto del template"]
        end
        Template -.->|TEMPLATE| Emp1
        Template -.->|TEMPLATE| Emp2
    end
```

| Base de datos | Propósito | Quién conecta |
|---------------|-----------|---------------|
| `restaurant_pe_master` | BD administrativa: auth (usuarios, roles, permisos, menú) + registro de tenants (connection strings) | Solo **ms-auth-security** |
| `restaurant_pe_template` | Modelo/plantilla — nunca se usa en producción | Solo Flyway (migraciones) |
| `restaurant_pe_emp_{id}` | BD de cada empresa (clon del template, 10 schemas de negocio) | **Todos los ms de negocio** vía `TenantRoutingDataSource` |

### 10.2 Esquemas por BD

**BD Master** (`restaurant_pe_master`):

| Esquema | Microservicio | Tablas principales |
|---------|---------------|--------------------|
| `auth` | ms-auth-security | usuario, usuario_empresa, rol, permiso, opcion_menu, sesion, log_acceso |
| `master` | ms-auth-security | tenant (registro de empresas con connection strings) |

**BD por Empresa** (`restaurant_pe_emp_{id}`) — cada empresa tiene estos 10 esquemas:

| Esquema | Microservicio | Tablas principales | Tablas SIGRE |
|---------|---------------|--------------------|:------------:|
| `core` | ms-core-maestros | empresa, sucursal, pais, moneda, tipo_cambio, relacion_comercial, articulo, categoria, unidad_medida, impuesto, condicion_pago, forma_pago, config_* | +banco, marca, tipo_doc_tributario, catalogo_sunat |
| `almacen` | ms-almacen | almacen, tipo_movimiento, movimiento_almacen, kardex, stock, inventario_fisico, reserva_stock | +guia_remision, guia_remision_detalle |
| `compras` | ms-compras | solicitud_compra, cotizacion, orden_compra, orden_servicio, recepcion, aprobacion, evaluacion_proveedor, contrato_marco | +comprador, aprobador_configurado |
| `ventas` | ms-ventas | documento_venta, mesa, zona, orden_venta, comanda, turno, cierre_caja, facturacion_electronica | +punto_venta, reservacion, carta |
| `finanzas` | ms-finanzas | cuenta_bancaria, documento_pagar, documento_cobrar, pago, cobro, conciliacion, adelanto, fondo_fijo | +detraccion, retencion, flujo_caja |
| `contabilidad` | ms-contabilidad | cuenta_contable, centro_costo, asiento, pre_asiento, matriz_contable, cierre_contable | +distribucion_contable |
| `rrhh` | ms-rrhh | trabajador, contrato, planilla, asistencia, vacacion, liquidacion, prestamo, permiso_licencia | +gratificacion, cts, quinta_categoria, evaluacion_desempeno |
| `activos` | ms-activos-fijos | activo_fijo, clase_activo, depreciacion, poliza_seguro, traslado, mantenimiento | — |
| `produccion` | ms-produccion | receta, orden_produccion, costeo_produccion, programacion_produccion, control_calidad | +ficha_tecnica |
| `auditoria` | ms-auditoria | log_auditoria | — |

> **Total:** 152 tablas (131 base + 21 derivadas del análisis SIGRE). Mapeo detallado SIGRE→Restaurant.pe en [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md), secciones 13-16.

### 10.3 Provisión de connection strings

**ms-auth-security** es el único servicio que conecta directamente a `restaurant_pe_master`. Los demás microservicios obtienen las conexiones de tenant a través de un endpoint interno:

1. Al **arrancar**, cada ms de negocio llama a `GET /internal/tenants/active` de ms-auth-security
2. Crea un **pool HikariCP por cada tenant** y los registra en `TenantRoutingDataSource`
3. Cada request lleva header `X-Empresa-Id` → el `TenantFilter` setea el contexto → el `TenantRoutingDataSource` selecciona el pool correcto
4. Cuando se **crea una nueva empresa**, ms-auth publica un evento `tenant.created` vía RabbitMQ → los demás ms agregan el pool dinámicamente (sin reinicio)

### 10.4 Convenciones de la base de datos

- **Naming:** `snake_case` para tablas y columnas.
- **Claves primarias:** `id BIGSERIAL PRIMARY KEY` (autoincremental).
- **Multiempresa:** **No se usa `empresa_id`** en tablas de negocio (cada BD es de una sola empresa).
- **Multisucursal:** `sucursal_id` donde aplique (tablas operativas).
- **Auditoría mínima por registro:** `creado_por`, `creado_en`, `modificado_por`, `modificado_en` en todas las tablas.
- **Soft delete:** `activo BOOLEAN DEFAULT true` (nunca DELETE físico).
- **Migraciones:** Flyway con `MultiTenantMigrationRunner` (ejecuta contra template + todos los tenants).
- **Numeración:** Tabla `secuencia_documento` local en cada BD de empresa (sin `empresa_id`, atómica con `UPDATE ... RETURNING`).

### 10.5 Ventajas del enfoque Database-per-Tenant

| Aspecto | Beneficio |
|---------|-----------|
| **Aislamiento total** | Imposible ver datos de otra empresa por diseño |
| **Sin `empresa_id`** | Queries más limpios, menos índices, menos riesgo de error |
| **Backup independiente** | Backup/restore por empresa sin afectar las demás |
| **Escalabilidad** | Mover una BD a otro servidor si crece mucho |
| **Borrado de empresa** | `DROP DATABASE restaurant_pe_emp_X` y listo |
| **Compliance (GDPR)** | Datos de cada empresa totalmente aislados |
| **Clonación instantánea** | `CREATE DATABASE ... TEMPLATE` en segundos |

---

## 11. Maestros detallados

A continuación se detallan **todas las tablas maestras** del sistema, agrupadas por esquema/microservicio.

> **NOTA IMPORTANTE (Database-per-Tenant):** Todas las tablas listadas a continuación residen en la **BD por Empresa** (`restaurant_pe_emp_{id}`). Como cada BD es de una sola empresa, estas tablas **NO tienen columna `empresa_id`**. Las tablas de seguridad (`usuario`, `rol`, etc.) residen en la BD Master (`restaurant_pe_master.auth`) y sí mantienen la referencia a empresa a través de `usuario_empresa.empresa_id`.

### 11.1 Esquema `core` — Maestros compartidos (ms-core-maestros)

Estos maestros residen en cada BD de empresa y son consumidos por todos los demás microservicios.

#### 11.1.1 Empresa y estructura organizacional

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **empresa** | id, ruc_nit, razon_social, nombre_comercial, pais_id, moneda_base_id, logo_url, direccion, telefono, email, regimen_tributario, activo | Empresa o razón social (multiempresa) |
| **sucursal** | id, codigo, nombre, direccion, telefono, pais_id, ciudad, departamento, ubigeo, tipo (PROPIA/FRANQUICIA), activo | Sucursal, local o punto de operación |
| **almacen** | id, sucursal_id, codigo, nombre, tipo (FISICO/VIRTUAL/TRANSITO), direccion, responsable_id, activo | Almacenes por sucursal (un local puede tener varios almacenes) |

#### 11.1.2 Geografía y localización

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **pais** | id, codigo_iso, nombre, moneda_default_id, formato_ruc, nombre_ruc (RUC/NIT/RNC/RFC), activo | Países soportados |
| **departamento** | id, pais_id, codigo, nombre | División política nivel 1 |
| **provincia** | id, departamento_id, codigo, nombre | División política nivel 2 |
| **distrito** | id, provincia_id, codigo, ubigeo, nombre | División política nivel 3 |

#### 11.1.3 Monedas y tipo de cambio

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **moneda** | id, codigo_iso (PEN, USD, COP, CLP, DOP), nombre, simbolo, decimales, activo | Catálogo de monedas |
| **tipo_cambio** | id, moneda_origen_id, moneda_destino_id, fecha, tasa_compra, tasa_venta, fuente | Tipo de cambio diario |

#### 11.1.4 Relaciones comerciales (maestro unificado proveedor/cliente)

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **relacion_comercial** | id, tipo_documento_identidad, numero_documento, razon_social, nombre_comercial, direccion, telefono, email, contacto_nombre, contacto_telefono, contacto_email, pais_id, departamento_id, provincia_id, distrito_id, es_proveedor, es_cliente, es_empleado, es_otro, condicion_pago_default_id, moneda_default_id, observaciones, activo | **Maestro unificado.** Una misma entidad puede ser proveedor Y cliente. El campo booleano define su naturaleza. Equivalente al "Código de Relación" de SIGRE |
| **tipo_documento_identidad** | id, pais_id, codigo, nombre, longitud, validacion_regex | Tipos: RUC, DNI, NIT, Cédula, Pasaporte, RNC, RFC, etc. |
| **contacto_relacion** | id, relacion_comercial_id, nombre, cargo, telefono, email, es_principal | Contactos adicionales de la relación comercial |
| **cuenta_bancaria_relacion** | id, relacion_comercial_id, banco, numero_cuenta, cci, moneda_id, tipo_cuenta, es_principal | Cuentas bancarias del proveedor/cliente |

#### 11.1.5 Artículos y clasificación

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **categoria** | id, codigo, nombre, padre_id, nivel (1=Cat, 2=SubCat, 3=Familia, 4=Línea), activo | Clasificación jerárquica de artículos (hasta 4 niveles) |
| **unidad_medida** | id, codigo, nombre, abreviatura, activo | Unidades: KG, LT, UND, CJ, BLS, etc. |
| **conversion_unidad** | id, unidad_origen_id, unidad_destino_id, factor, articulo_id (nullable) | Factor de conversión entre unidades (global o por artículo) |
| **articulo** | id, codigo, nombre, descripcion, categoria_id, unidad_medida_id, unidad_compra_id, factor_compra, marca, modelo, codigo_barras, peso_neto, peso_bruto, volumen, es_inventariable, es_comprable, es_vendible, es_producible, es_servicio, imagen_url, stock_minimo, stock_maximo, punto_reorden, precio_ultima_compra, precio_promedio, precio_venta, naturaleza_contable_id, cuenta_contable_inventario, cuenta_contable_costo, cuenta_contable_gasto, impuesto_id, activo | Maestro central de artículos (productos, insumos, servicios) |
| **articulo_proveedor** | id, articulo_id, relacion_comercial_id, codigo_proveedor, precio_referencia, moneda_id, tiempo_entrega_dias, es_preferido | Relación artículo-proveedor con precio y tiempos |
| **articulo_almacen** | id, articulo_id, almacen_id, ubicacion, stock_minimo, stock_maximo, punto_reorden | Configuración de stock por artículo y almacén |
| **naturaleza_contable** | id, codigo, nombre, descripcion, cuenta_inventario, cuenta_costo, cuenta_gasto, cuenta_ingreso, activo | Naturaleza contable (clase de artículo con cuentas asociadas) |

#### 11.1.6 Impuestos y retenciones

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **impuesto** | id, pais_id, codigo, nombre, tipo (IGV/IVA/ITBIS/ISV), porcentaje, cuenta_contable, vigente_desde, vigente_hasta, activo | Impuestos por país con vigencia |
| **retencion** | id, pais_id, codigo, nombre, tipo (RENTA/IVA/ISR), porcentaje, monto_minimo, cuenta_contable, activo | Retenciones fiscales por país |
| **detraccion** | id, pais_id, codigo, nombre, porcentaje, bien_servicio, cuenta_contable, activo | Detracciones (Perú - SPOT) |

#### 11.1.7 Secuencias de documentos (numeración automática)

> Con Database-per-Tenant, la numeración **no necesita `empresa_id`** ya que la BD es de una sola empresa. Cada microservicio que emite documentos tiene su propia tabla `secuencia_documento` en su esquema.

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **secuencia_documento** | id, sucursal_id, tipo_documento, serie, anio, ultimo_numero, formato, longitud, reinicio (ANUAL/MENSUAL/NUNCA), activo | Numeración automática por sucursal, tipo, serie y año. **Sin `empresa_id`** — la BD ya es de una empresa. Usa `UPDATE ... RETURNING` para atomicidad sin gaps |

```sql
-- Función atómica para obtener el siguiente número (sin gaps)
CREATE OR REPLACE FUNCTION {schema}.siguiente_numero(
    p_sucursal_id BIGINT, p_tipo_doc VARCHAR,
    p_serie VARCHAR, p_anio INT
) RETURNS BIGINT AS $$
DECLARE v_numero BIGINT;
BEGIN
    UPDATE {schema}.secuencia_documento
    SET ultimo_numero = ultimo_numero + 1
    WHERE sucursal_id = p_sucursal_id
      AND tipo_documento = p_tipo_doc
      AND serie = p_serie AND anio = p_anio
    RETURNING ultimo_numero INTO v_numero;

    IF v_numero IS NULL THEN
        INSERT INTO {schema}.secuencia_documento
            (sucursal_id, tipo_documento, serie, anio, ultimo_numero)
        VALUES (p_sucursal_id, p_tipo_doc, p_serie, p_anio, 1)
        RETURNING ultimo_numero INTO v_numero;
    END IF;
    RETURN v_numero;
END;
$$ LANGUAGE plpgsql;
```

> La función se ejecuta dentro de la misma transacción del documento. Si la transacción falla, el número se revierte automáticamente — **sin gaps**.

#### 11.1.8 Configuración jerárquica (4 niveles)

El sistema maneja configuraciones en **4 niveles jerárquicos** con herencia y sobreescritura. El valor más específico siempre prevalece: **Usuario > Sucursal > País > Empresa (global)**.

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **config_clave** | id, modulo, clave, nombre, descripcion, tipo_dato (TEXT/NUMBER/BOOLEAN/JSON/DATE), valor_default, es_obligatorio, es_visible_usuario, grupo, orden, activo | Catálogo maestro de todas las claves de configuración posibles. Define qué se puede configurar, su tipo de dato y valor por defecto |
| **config_empresa** | id, config_clave_id, valor, observaciones | Configuración **global** a nivel de empresa. Aplica a todas las sucursales, países y usuarios de la empresa. Ej.: razón social, logo, moneda base, política de aprobaciones |
| **config_pais** | id, pais_id, config_clave_id, valor, observaciones | Configuración por **país**. Sobreescribe la configuración global de la empresa para un país específico. Ej.: tipo de impuesto (IGV/IVA/ITBIS), formato de RUC/NIT, libros contables requeridos, regulaciones laborales |
| **config_sucursal** | id, sucursal_id, config_clave_id, valor, observaciones | Configuración por **sucursal**. Sobreescribe la configuración del país y empresa. Ej.: almacén por defecto, impresora por defecto, turno de operación, caja por defecto |
| **config_usuario** | id, usuario_id, config_clave_id, valor, observaciones | Configuración por **usuario**. Sobreescribe todas las anteriores. Ej.: idioma, tema visual, formato fecha, sucursal preferida, reporte por defecto, atajos personalizados |

> **Resolución de configuración:** Cuando el sistema necesita un valor de configuración, busca en orden: `config_usuario` → `config_sucursal` → `config_pais` → `config_empresa` → `config_clave.valor_default`. El primer valor encontrado es el que aplica.

```mermaid
flowchart TB
    subgraph Jerarquía["Jerarquía de configuración (precedencia ↑)"]
        direction BT
        CE["config_empresa\n(global para toda la empresa)"]
        CP["config_pais\n(sobreescribe empresa por país)"]
        CS["config_sucursal\n(sobreescribe país por sucursal)"]
        CU["config_usuario\n(sobreescribe todo por usuario)"]
        CE --> CP --> CS --> CU
    end
```

#### 11.1.9 Tablas auxiliares generales

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **ejercicio_periodo** | id, anio, mes, estado (ABIERTO/CERRADO/EN_CIERRE), fecha_cierre | Ejercicios y períodos contables |
| **condicion_pago** | id, codigo, nombre, dias, tipo (CONTADO/CREDITO), numero_cuotas, activo | Condiciones de pago/cobro |
| **forma_pago** | id, codigo, nombre, tipo (EFECTIVO/TRANSFERENCIA/CHEQUE/TARJETA/YAPE/PLIN/NIUBIZ/OTRO), requiere_referencia, activo | Formas/medios de pago |

#### 11.1.10 Tablas derivadas del análisis SIGRE

| Tabla | Campos | Origen SIGRE | Descripción |
|-------|--------|:------------:|-------------|
| **banco** | id, codigo, nombre, nombre_corto, swift_code, activo | `BANCO` | Maestro de bancos. Referenciado en ~10 módulos SIGRE |
| **marca** | id, codigo, nombre, activo | `MARCA` | Marcas de artículos/insumos |
| **tipo_documento_tributario** | id, codigo, nombre, codigo_sunat, requiere_serie, activo | `DOC_TIPO` | Catálogo: 01=Factura, 03=Boleta, 07=NC, 08=ND, 09=Guía. Referenciado en ~16 módulos SIGRE |
| **catalogo_sunat** | id, tipo, codigo, descripcion, activo | `SUNAT_*` (15 tablas) | Catálogos tributarios SUNAT consolidados (Tabla 10, 12, CUBSO, Ubigeo, etc.) |

---

### 11.2 Esquema `almacen` — Maestros y transaccionales

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **tipo_movimiento** | id, codigo, nombre, naturaleza (INGRESO/SALIDA), afecta_costo, requiere_referencia, tipo_referencia (OC/OS/TRASLADO/AJUSTE/PRODUCCION/VENTA/DEVOLUCION), cuenta_contable_debe, cuenta_contable_haber, activo | Tipos de movimiento de almacén configurables |
| **movimiento_almacen** | id, sucursal_id, almacen_id, tipo_movimiento_id, numero, fecha, estado (BORRADOR/CONFIRMADO/ANULADO), referencia_tipo, referencia_id, referencia_numero, almacen_destino_id (para traslados), observaciones, total_valorizado | Cabecera de movimiento de inventario |
| **movimiento_detalle** | id, movimiento_almacen_id, articulo_id, cantidad, unidad_medida_id, costo_unitario, costo_total, lote, fecha_vencimiento, ubicacion | Detalle del movimiento (cada artículo) |
| **kardex** | id, almacen_id, articulo_id, fecha, tipo_movimiento_id, movimiento_id, cantidad_entrada, cantidad_salida, costo_unitario, costo_total, saldo_cantidad, saldo_valorizado, metodo_costeo (PROMEDIO/PEPS/UEPS) | Kardex valorizado por artículo y almacén |
| **stock** | id, almacen_id, articulo_id, cantidad_disponible, cantidad_reservada, cantidad_transito, costo_promedio, costo_ultima_compra, fecha_ultima_entrada, fecha_ultima_salida | Saldo de stock en tiempo real |
| **inventario_fisico** | id, almacen_id, fecha, estado (EN_PROCESO/FINALIZADO/AJUSTADO), responsable_id | Cabecera de toma de inventario |
| **inventario_fisico_detalle** | id, inventario_fisico_id, articulo_id, stock_sistema, stock_fisico, diferencia, costo_unitario, costo_diferencia, ajuste_aplicado | Detalle con diferencias por artículo |
| **guia_remision** *(SIGRE)* | id, sucursal_id, serie, numero, fecha_emision, fecha_traslado, motivo_traslado, destinatario_id, direccion_partida, direccion_llegada, transportista, placa_vehiculo, conductor_nombre, movimiento_almacen_id, estado | Guía de remisión (obligatoria SUNAT). Origen: `GUIA` |
| **guia_remision_detalle** *(SIGRE)* | id, guia_id, articulo_id, descripcion, cantidad, unidad_medida_id, peso_bruto_kg | Detalle de guía. Origen: `GUIA_VALE` |

---

### 11.3 Esquema `compras` — Maestros y transaccionales

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **orden_compra** | id, sucursal_id, numero, fecha, proveedor_id, condicion_pago_id, moneda_id, tipo_cambio, almacen_destino_id, estado (BORRADOR/PENDIENTE_APROBACION/APROBADA/PARCIAL/COMPLETADA/ANULADA), subtotal, impuesto_total, total, observaciones, fecha_entrega_estimada | Cabecera de orden de compra |
| **orden_compra_detalle** | id, orden_compra_id, articulo_id, descripcion, cantidad, unidad_medida_id, precio_unitario, descuento_porcentaje, descuento_monto, impuesto_id, impuesto_monto, subtotal, total, cantidad_recibida, cantidad_pendiente | Detalle de OC |
| **orden_servicio** | id, sucursal_id, numero, fecha, proveedor_id, condicion_pago_id, moneda_id, tipo_cambio, estado, subtotal, impuesto_total, total, descripcion_servicio, fecha_inicio, fecha_fin, observaciones | Cabecera de orden de servicio |
| **orden_servicio_detalle** | id, orden_servicio_id, descripcion, cantidad, unidad_medida_id, precio_unitario, descuento_porcentaje, impuesto_id, impuesto_monto, subtotal, total | Detalle de OS |
| **aprobacion** | id, documento_tipo (OC/OS), documento_id, nivel, aprobador_id, estado (PENDIENTE/APROBADO/RECHAZADO), fecha, comentario | Workflow de aprobación multinivel |
| **recepcion** | id, sucursal_id, numero, fecha, orden_compra_id, proveedor_id, almacen_id, estado (BORRADOR/CONFIRMADA/ANULADA), guia_remision, observaciones | Recepción de mercadería vinculada a OC |
| **recepcion_detalle** | id, recepcion_id, orden_compra_detalle_id, articulo_id, cantidad_recibida, cantidad_rechazada, motivo_rechazo, costo_unitario | Detalle de recepción |
| **comprador** *(SIGRE)* | id, trabajador_id, nombre, activo | Compradores asignados. Origen: `COMPRADOR` |
| **comprador_categoria** *(SIGRE)* | id, comprador_id, categoria_id | Categorías asignadas por comprador. Origen: `COMPRADOR_ARTICULO` |
| **aprobador_configurado** *(SIGRE)* | id, tipo_documento, nivel, aprobador_id, monto_minimo, monto_maximo, moneda_id, activo | Configuración de aprobadores por monto. Origen: `APROBADORES_OC` + `LOGISTICA_APROBADOR` |

---

### 11.4 Esquema `finanzas` — Maestros y transaccionales

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **cuenta_bancaria** | id, banco, numero_cuenta, cci, moneda_id, tipo_cuenta (CORRIENTE/AHORRO/MAESTRA), cuenta_contable_id, saldo_actual, activo | Cuentas bancarias de la empresa |
| **caja** | id, sucursal_id, codigo, nombre, tipo (PRINCIPAL/CHICA/PDV), moneda_id, saldo_actual, fondo_fijo, responsable_id, activo | Cajas de la empresa (por sucursal y PdV) |
| **documento_pagar** | id, proveedor_id, tipo_documento, serie, numero, fecha_emision, fecha_vencimiento, moneda_id, tipo_cambio, subtotal, impuesto, total, saldo_pendiente, estado (PENDIENTE/PARCIAL/PAGADO/ANULADO), orden_compra_id, orden_servicio_id, concepto_financiero_id | Facturas y documentos por pagar |
| **documento_cobrar** | id, cliente_id, tipo_documento, serie, numero, fecha_emision, fecha_vencimiento, moneda_id, tipo_cambio, subtotal, impuesto, total, saldo_pendiente, estado, concepto_financiero_id | Facturas y documentos por cobrar |
| **pago** | id, documento_pagar_id, fecha, monto, moneda_id, tipo_cambio, forma_pago_id, cuenta_bancaria_id, caja_id, referencia, estado (CONFIRMADO/ANULADO) | Registro de pagos a proveedores |
| **cobro** | id, documento_cobrar_id, fecha, monto, moneda_id, tipo_cambio, forma_pago_id, cuenta_bancaria_id, caja_id, referencia, estado | Registro de cobros a clientes |
| **movimiento_bancario** | id, cuenta_bancaria_id, fecha, tipo (INGRESO/EGRESO), concepto, referencia, monto, saldo, conciliado, conciliacion_id | Movimientos de cuenta bancaria |
| **conciliacion** | id, cuenta_bancaria_id, periodo_anio, periodo_mes, estado (EN_PROCESO/FINALIZADA), saldo_banco, saldo_sistema, diferencia, fecha_conciliacion | Conciliación bancaria |
| **concepto_financiero** | id, codigo, nombre, grupo, tipo (INGRESO/EGRESO), cuenta_contable_id, flujo_caja_id, activo | Conceptos financieros para clasificar operaciones |
| **flujo_caja_concepto** | id, codigo, nombre, grupo_id, tipo (INGRESO/EGRESO), orden, activo | Estructura de flujo de caja |
| **adelanto** | id, numero, fecha, solicitante_id, monto, moneda_id, motivo, estado (SOLICITADO/APROBADO/LIQUIDADO/CERRADO/RECHAZADO), aprobador_id, fecha_aprobacion | Adelantos / órdenes de giro |
| **adelanto_liquidacion** | id, adelanto_id, fecha, monto_gastado, monto_devuelto, estado (PENDIENTE/APROBADO/CERRADO) | Liquidación de adelantos |
| **detraccion** *(SIGRE)* | id, documento_pagar_id, tipo_bien_servicio, porcentaje, monto_detraccion, numero_constancia, fecha_pago, cuenta_detracciones, estado | Detracciones SUNAT. Origen: `DETRACCION` + `DETR_*` |
| **retencion** *(SIGRE)* | id, documento_pagar_id, porcentaje, monto_retencion, numero_comprobante_retencion, fecha_emision, estado | Retenciones IGV. Origen: `RETENCION_IGV_CRT` |
| **flujo_caja** *(SIGRE)* | id, sucursal_id, anio, mes, tipo (REAL/PROYECTADO), ingresos_operativos, egresos_operativos, flujo_operativo, saldo_inicial, saldo_final | Flujo de caja. Origen: `FLUJO_CAJA` + `FLUJO_CAJA_PROY` |

---

### 11.5 Esquema `contabilidad` — Maestros y transaccionales

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **cuenta_contable** | id, codigo, nombre, nivel, tipo (ACTIVO/PASIVO/PATRIMONIO/INGRESO/GASTO/COSTO), naturaleza (DEUDORA/ACREEDORA), padre_id, acepta_movimiento, moneda_id, cuenta_sunat, activo | Plan de cuentas contable jerárquico |
| **centro_costo** | id, codigo, nombre, nivel, padre_id, tipo (ADMINISTRATIVO/OPERATIVO/VENTAS/PRODUCCION), responsable_id, activo | Centros de costo jerárquicos |
| **asiento** | id, libro_id, numero, fecha, periodo_anio, periodo_mes, glosa, tipo (MANUAL/AUTOMATICO/APERTURA/CIERRE), origen_modulo, origen_documento_tipo, origen_documento_id, estado (BORRADOR/CONFIRMADO/ANULADO), total_debe, total_haber | Cabecera de asiento contable |
| **asiento_detalle** | id, asiento_id, cuenta_contable_id, centro_costo_id, relacion_comercial_id, debe, haber, moneda_id, tipo_cambio, debe_me, haber_me, glosa_detalle, documento_tipo, documento_serie, documento_numero, documento_fecha | Líneas del asiento |
| **pre_asiento** | id, modulo_origen, tipo_operacion, documento_tipo, documento_id, fecha, estado (PENDIENTE/PROCESADO/ERROR), datos_json, error_mensaje | Pre-asientos generados por otros módulos, pendientes de convertir en asientos |
| **matriz_contable** | id, modulo, tipo_operacion, descripcion, cuenta_debe_id, cuenta_haber_id, centro_costo_id, activo | Reglas para generación automática de asientos |
| **libro_contable** | id, codigo, nombre, tipo (DIARIO/MAYOR/CAJA/COMPRAS/VENTAS), activo | Libros contables |
| **distribucion_contable** *(SIGRE)* | id, modulo_origen, documento_id, centro_costo_origen_id, centro_costo_destino_id, porcentaje, monto, anio, mes, estado | Distribución de gastos entre centros de costo. Origen: `DISTRIBUCION_CNTBLE` |

---

### 11.6 Esquema `rrhh` — Maestros y transaccionales

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **trabajador** | id, relacion_comercial_id, codigo, fecha_ingreso, fecha_cese, estado (ACTIVO/CESADO/SUSPENDIDO/VACACIONES), sucursal_id, area_id, cargo_id, centro_costo_id, tipo_trabajador, regimen_laboral, regimen_pensionario, afp_id, eps_id, cuenta_bancaria_sueldo, tipo_contrato, remuneracion_basica, moneda_id, foto_url | Ficha del trabajador |
| **area** | id, codigo, nombre, padre_id, nivel, responsable_id, activo | Áreas organizacionales (jerárquicas) |
| **cargo** | id, codigo, nombre, area_id, nivel, banda_salarial_min, banda_salarial_max, activo | Cargos / puestos |
| **contrato** | id, trabajador_id, tipo, fecha_inicio, fecha_fin, renovacion_numero, remuneracion, moneda_id, estado (VIGENTE/VENCIDO/RENOVADO/TERMINADO), documento_url | Contratos laborales |
| **concepto_planilla** | id, codigo, nombre, tipo (INGRESO/DESCUENTO/APORTE_EMPLEADOR), naturaleza (FIJO/VARIABLE), afecto_renta, afecto_essalud, afecto_pension, cuenta_contable_id, activo | Conceptos de planilla (sueldo, bonos, AFP, etc.) |
| **planilla** | id, periodo_anio, periodo_mes, tipo (MENSUAL/QUINCENAL/SEMANAL/GRATIFICACION/CTS/LIQUIDACION/UTILIDADES), estado (BORRADOR/CALCULADA/APROBADA/PAGADA/CERRADA), fecha_calculo, fecha_pago | Cabecera de planilla |
| **planilla_detalle** | id, planilla_id, trabajador_id, concepto_id, monto, dias, horas, base_calculo, porcentaje | Detalle por trabajador y concepto |
| **asistencia** | id, trabajador_id, fecha, hora_entrada, hora_salida, tipo_marcacion (POS/APP/BIOMETRICO/MANUAL), latitud, longitud, dispositivo, estado (PRESENTE/TARDANZA/FALTA/PERMISO/VACACION) | Registro de asistencia |
| **vacacion** | id, trabajador_id, periodo_desde, periodo_hasta, dias_derecho, dias_gozados, dias_pendientes, estado | Control de vacaciones |
| **liquidacion** | id, trabajador_id, fecha, tipo (RENUNCIA/DESPIDO/MUTUO_ACUERDO/JUBILACION), estado, monto_total, detalle_json | Liquidación de beneficios sociales |
| **afp** | id, pais_id, codigo, nombre, comision_porcentaje, prima_seguro, aporte_obligatorio, activo | Administradoras de fondos de pensiones |
| **gratificacion** *(SIGRE)* | id, trabajador_id, anio, tipo (JULIO/DICIEMBRE), remuneracion_computable, meses_laborados, monto_gratificacion, bonificacion_extraordinaria, total, estado | Gratificaciones legales. Origen: `GRATIFICACION` |
| **cts** *(SIGRE)* | id, trabajador_id, anio, periodo (MAYO/NOVIEMBRE), remuneracion_computable, meses_computables, monto_cts, entidad_financiera, numero_cuenta_cts, fecha_deposito, estado | CTS obligatoria. Origen: `CNTA_CRRTE_CTS` |
| **quinta_categoria** *(SIGRE)* | id, trabajador_id, anio, mes, renta_bruta_acumulada, renta_bruta_proyectada, deduccion_7uit, renta_neta, impuesto_anual_proyectado, retencion_mensual, retencion_acumulada | Retención IR 5ta categoría. Origen: `QUINTA_CATEGORIA` |
| **evaluacion_desempeno** *(SIGRE)* | id, trabajador_id, evaluador_id, anio, periodo, puntaje_total, clasificacion, observaciones, estado | Evaluación de desempeño. Origen: `RH_EVALUACION_PERSONAL` |

---

### 11.7 Esquema `activos` — Maestros y transaccionales

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **clase_activo** | id, codigo, nombre, padre_id, nivel (CLASE/SUBCLASE), vida_util_anios, tasa_depreciacion, metodo_depreciacion (LINEAL/DECRECIENTE/UNIDADES), cuenta_activo, cuenta_depreciacion_acum, cuenta_gasto_depreciacion, activo | Clasificación de activos con cuentas contables |
| **ubicacion_fisica** | id, sucursal_id, codigo, nombre, tipo (EDIFICIO/PISO/OFICINA/ALMACEN/COCINA/SALON), padre_id, activo | Ubicaciones físicas jerárquicas |
| **activo_fijo** | id, codigo, nombre, descripcion, clase_activo_id, ubicacion_id, responsable_id, sucursal_id, centro_costo_id, fecha_adquisicion, fecha_alta, proveedor_id, orden_compra_id, factura_numero, valor_adquisicion, moneda_id, valor_residual, vida_util_restante, depreciacion_acumulada, valor_neto, estado (ACTIVO/BAJA/EN_TRASLADO/REVALUADO), marca, modelo, serie, placa, foto_url | Ficha del activo fijo |
| **depreciacion** | id, activo_fijo_id, periodo_anio, periodo_mes, valor_inicio_periodo, tasa, monto_depreciacion, depreciacion_acumulada, valor_neto, asiento_id | Cálculo mensual de depreciación |
| **aseguradora** | id, nombre, ruc, contacto, telefono, email, activo | Compañías aseguradoras |
| **poliza_seguro** | id, activo_fijo_id, aseguradora_id, numero_poliza, tipo_seguro, fecha_inicio, fecha_fin, prima_total, prima_mensual, deducible, cobertura_monto, estado (VIGENTE/VENCIDA/SINIESTRADA) | Pólizas de seguro de activos |
| **traslado_activo** | id, activo_fijo_id, ubicacion_origen_id, ubicacion_destino_id, fecha_solicitud, fecha_aprobacion, estado (SOLICITADO/APROBADO/EJECUTADO/RECHAZADO), aprobador_id, motivo | Traslados con workflow |

---

### 11.8 Esquema `produccion` — Maestros y transaccionales

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **receta** | id, codigo, nombre, articulo_producto_id, categoria_id, rendimiento_cantidad, rendimiento_unidad_id, costo_estandar, tiempo_preparacion_min, instrucciones, version, estado (ACTIVA/INACTIVA/BORRADOR), activo | Receta = lista de materiales (BOM gastronómico) |
| **receta_detalle** | id, receta_id, articulo_insumo_id, cantidad, unidad_medida_id, costo_unitario_estandar, merma_porcentaje, es_opcional, observaciones | Ingredientes de la receta con merma |
| **orden_produccion** | id, sucursal_id, numero, fecha, receta_id, cantidad_a_producir, cantidad_producida, estado (PLANIFICADA/EN_PROCESO/COMPLETADA/CANCELADA), almacen_consumo_id, almacen_destino_id, costo_total, observaciones | Orden de producción |
| **orden_produccion_detalle** | id, orden_produccion_id, articulo_id, cantidad_requerida, cantidad_consumida, costo_unitario, costo_total, almacen_id | Consumo real de insumos |
| **costeo_produccion** | id, orden_produccion_id, costo_materia_prima, costo_mano_obra, costo_indirecto, costo_total, costo_unitario, fecha_costeo | Costeo consolidado por orden |
| **ficha_tecnica** *(SIGRE)* | id, receta_id, alergenos, calorias, proteinas_g, carbohidratos_g, grasas_g, tipo_dieta, foto_presentacion_url, instrucciones_emplatado, tiempo_preparacion_min, tiempo_coccion_min, temperatura_servicio | Ficha técnica del plato. Nuevo para Restaurant.pe (normativa sanitaria) |

---

### 11.9 Esquema `auditoria`

| Tabla | Campos | Descripción |
|-------|--------|-------------|
| **log_auditoria** | id, usuario_id, modulo, entidad, entidad_id, accion (CREAR/EDITAR/ELIMINAR/APROBAR/ANULAR/IMPRIMIR), datos_anteriores_json, datos_nuevos_json, ip, user_agent, fecha | Log detallado de todas las acciones |
| **log_acceso** | id, usuario_id, tipo (LOGIN/LOGOUT/LOGIN_FALLIDO), ip, user_agent, fecha | Control de accesos al sistema |

---

### 11.10 Diagrama resumen de relaciones entre maestros principales

> **Nota:** Este diagrama distingue entre las entidades de la **BD Master** (seguridad, tenants) y las entidades de la **BD por Empresa** (negocio). Con Database-per-Tenant, las tablas de negocio no tienen `empresa_id`.

```mermaid
erDiagram
    %% ==========================================
    %% BD MASTER (restaurant_pe_master)
    %% ==========================================

    TENANT {
        bigint id PK
        varchar codigo UK
        varchar nombre
        varchar db_name UK
    }

    USUARIO ||--o{ USUARIO_EMPRESA : "accede a"
    TENANT ||--o{ USUARIO_EMPRESA : "tiene usuarios"
    USUARIO_EMPRESA }o--|| ROL : "tiene un rol por empresa"
    ROL }o--o{ OPCION_MENU : "tiene muchas / está en muchos"
    OPCION_MENU }o--|| MODULO : "pertenece a uno"
    ROL ||--o{ ROL_PERMISO : tiene
    ROL_PERMISO }o--|| PERMISO : es
    PERMISO }o--|| OPCION_MENU : sobre
    USUARIO }o--o{ OPCION_MENU : "individual extraordinario"

    %% ==========================================
    %% BD EMPRESA (restaurant_pe_emp_N)
    %% Sin empresa_id en las tablas
    %% ==========================================

    EMPRESA ||--o{ SUCURSAL : tiene
    SUCURSAL }o--|| PAIS : pertenece
    SUCURSAL ||--o{ ALMACEN : tiene
    RELACION_COMERCIAL }o--o{ ARTICULO_PROVEEDOR : suministra
    ARTICULO }o--|| CATEGORIA : pertenece
    ARTICULO }o--|| UNIDAD_MEDIDA : usa
    ARTICULO }o--o| NATURALEZA_CONTABLE : tiene
    ALMACEN ||--o{ STOCK : contiene
    STOCK }o--|| ARTICULO : de
    ALMACEN ||--o{ MOVIMIENTO_ALMACEN : registra
    MOVIMIENTO_ALMACEN }o--|| TIPO_MOVIMIENTO : es
    MOVIMIENTO_ALMACEN ||--o{ MOVIMIENTO_DETALLE : contiene
    MOVIMIENTO_DETALLE }o--|| ARTICULO : de
    RELACION_COMERCIAL ||--o{ ORDEN_COMPRA : recibe
    ORDEN_COMPRA ||--o{ ORDEN_COMPRA_DETALLE : contiene
    ORDEN_COMPRA ||--o{ RECEPCION : genera
    RECEPCION ||--o{ MOVIMIENTO_ALMACEN : genera
    RELACION_COMERCIAL ||--o{ DOCUMENTO_PAGAR : genera
    RELACION_COMERCIAL ||--o{ DOCUMENTO_COBRAR : genera
    DOCUMENTO_PAGAR ||--o{ PAGO : recibe
    DOCUMENTO_COBRAR ||--o{ COBRO : recibe
    CUENTA_CONTABLE ||--o{ ASIENTO_DETALLE : en
    ASIENTO ||--o{ ASIENTO_DETALLE : contiene
    TRABAJADOR }o--|| CARGO : ocupa
    TRABAJADOR }o--|| AREA : pertenece
    PLANILLA ||--o{ PLANILLA_DETALLE : contiene
    PLANILLA_DETALLE }o--|| TRABAJADOR : de
    ACTIVO_FIJO }o--|| CLASE_ACTIVO : es
    ACTIVO_FIJO ||--o{ DEPRECIACION : calcula
    RECETA ||--o{ RECETA_DETALLE : contiene
    RECETA_DETALLE }o--|| ARTICULO : usa
    ORDEN_PRODUCCION }o--|| RECETA : ejecuta
    SECUENCIA_DOCUMENTO }o--|| SUCURSAL : "por sucursal"
    CONFIG_CLAVE ||--o{ CONFIG_EMPRESA : configura
    CONFIG_CLAVE ||--o{ CONFIG_PAIS : configura
    CONFIG_CLAVE ||--o{ CONFIG_SUCURSAL : configura
    CONFIG_CLAVE ||--o{ CONFIG_USUARIO : configura
    PAIS ||--o{ CONFIG_PAIS : tiene
    SUCURSAL ||--o{ CONFIG_SUCURSAL : tiene
```

---

## 12. Riesgos y mitigaciones

| Riesgo | Mitigación |
|--------|------------|
| Alcance demasiado grande por fase | Priorizar HUs por fase; dejar "nice to have" para siguientes releases |
| Integración contable retrasada | Definir modelo de pre-asientos y matrices en Fase 1; implementar procesamiento en Fase 4 |
| Multipaís complejiza plazos | Arrancar con un país (ej. Perú); añadir países en iteraciones posteriores |
| Dependencia de POS actual | Mantener contratos claros con el equipo POS; definir APIs de ventas/cobro desde Fase 1 |
| Comunicación entre microservicios frágil | Definir contratos de API (OpenAPI) desde Fase 1; usar versionado de API |
| Base de datos crece sin control | Aplicar migraciones versionadas (Flyway) desde el primer día; revisiones de esquema por sprint |
| Complejidad Database-per-Tenant | `MultiTenantMigrationRunner` automatiza migraciones. Evento `tenant.created` sincroniza pools. ms-auth centraliza registro |
| Redis como punto único de fallo (caché + rate limiting) | Redis Sentinel o Redis Cluster en producción; fallback a BD directa en caso de caída |
| Fallo de Elasticsearch/ELK impide análisis de logs | Logs también van a stdout (Docker logs como fallback); Elasticsearch con réplicas |
| Pérdida de datos mayor al RPO (1 hora) | WAL archiving continuo + streaming replication (PostgreSQL Standby) |
| Migración de datos SIGRE retrasada | Pipeline ETL definido (Python + cx_Oracle + Pandas); mapeo validado: 2,770 tablas Oracle → 152 tablas PostgreSQL ([`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md) sección 14); plan por fases con rollback; endpoints de importación masiva |
| WebSocket desconexiones en redes inestables | Reconexión automática con backoff exponencial (5s, 10s, 20s, max 60s); SockJS como fallback |
| Backups no validados o corruptos | Restore de prueba semanal, conteo de registros diario, alerta automática si backup falla |
| Plazo agresivo de 5 meses | Equipos paralelos, sprints de 1 semana, demos semanales, decisiones rápidas |

---

## 13. Próximos pasos recomendados

1. **Validar y ajustar** este roadmap con negocio y equipo técnico (prioridades, plazos, recursos).
2. **Refinar estimaciones** por módulo (story points o semanas por equipo) al priorizar las HUs.
3. **Detallar la arquitectura** de cada microservicio (paquetes, capas, contratos de API) en documentos técnicos por servicio.
4. **Fijar hitos** en fechas concretas y revisar el roadmap cada mes.
5. **Definir estándares de API** (OpenAPI/Swagger), patrones de error, paginación y versionado.
6. **Configurar Jenkins** desde la Semana 1: build automático, tests (JUnit + Testcontainers), análisis de calidad (SonarQube + JaCoCo con quality gates obligatorios). Despliegues manuales con Docker. Automatización de despliegues (CD) como mejora futura opcional.
7. **Configurar stack de observabilidad** desde Semana 1: ELK Stack (logs JSON), Prometheus + Grafana (dashboards de infra, JVM, gateway, negocio, BD, RabbitMQ), Zipkin/Jaeger (tracing distribuido).
8. **Configurar Redis** desde Semana 1 para caché de sesiones, menú, configuraciones y rate limiting en API Gateway.
9. **Configurar MinIO** (dev) / **S3** (prod) para gestión de archivos aislados por tenant (logos, fotos, documentos, regulatorios).
10. **Definir y automatizar pipeline de migración** de datos desde SIGRE Oracle 11gR2 (ETL Python + cx_Oracle + Pandas) alineado con las fases del roadmap: maestros (F1: PROVEEDOR, ARTICULO, MONEDA, BANCO → 30 tablas core), stock (F2: VALE_MOV, ARTICULO_ALMACEN → 11 tablas almacen), CxP/CxC (F3: CNTAS_PAGAR, CNTAS_COBRAR → 17 tablas finanzas), contabilidad (F4: CNTBL_CNTA, CNTBL_ASIENTO → 8 tablas). Mapeo detallado en [`DISENO_BASE_DATOS.md`](./DISENO_BASE_DATOS.md) secciones 14-16.
11. **Configurar backup automático** (pg_dump diario + WAL archiving) y **streaming replication** (PostgreSQL Standby) antes de Fase 3.
12. **Implementar WebSocket/STOMP** para comandas en tiempo real a cocina/bar, alertas de stock y notificaciones push desde Fase 2.
13. **Planificar primera prueba de DR** antes del piloto (Semana 19): simular failover a Standby, verificar RPO ≤1h y RTO ≤4h.
14. **Configurar tests de contrato** (Spring Cloud Contract) desde Fase 2 para validar comunicación entre microservicios.

---

*Roadmap para el proyecto Restaurant.pe. Stack: Backend Java/Spring Boot (microservicios con API Gateway y Eureka), Frontend Angular 20, Base de datos PostgreSQL 16 con estrategia Database-per-Tenant (152 tablas en 11 esquemas, consolidadas desde las 2,770 tablas del ERP SIGRE en Oracle 11gR2). Infraestructura: Redis (caché/rate limiting), RabbitMQ (eventos), ELK (logs), Prometheus/Grafana (monitoreo), Zipkin (tracing), MinIO/S3 (archivos). Integración continua con Jenkins + SonarQube + JaCoCo (despliegues manuales). Plazo: 5 meses, 21 personas, 3 equipos en paralelo. Migración ETL desde SIGRE con mapeo detallado tabla por tabla (ver DISENO_BASE_DATOS.md secciones 13-16). Incluye arquitectura de microservicios, modelo de seguridad centralizado en BD Master, roles dinámicos por empresa, menú por permisos, numeración atómica sin gaps, WebSocket/STOMP para tiempo real, testing (JUnit/Testcontainers/Cypress/SonarQube), backup/restore por tenant, streaming replication y plan de Disaster Recovery.*
