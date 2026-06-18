# ms-rrhh — Explicación Funcional

> Puerto: `9010` | Esquema BD: `rrhh` | 42 tablas · **276 endpoints** implementados (38 controllers) · 41 contratos API (~294 endpoints documentados)
> Auditoría: 02/06/2026 — implementación completada. 276 endpoints, 38/38 módulos equiparados a contrato.
> Este documento explica **qué hace cada submódulo**, **cómo funciona** y **cómo se relacionan** entre sí,
> cubriendo la totalidad del dominio de Recursos Humanos del ERP Restaurant.pe.

---

## 1. El Problema de Fondo

RRHH en un restaurante no es solo pagar sueldos. Hay que gestionar:

| Macroproceso | ¿Qué cubre? |
|---|---|
| **Maestros de Personal** | Fichas de empleados, contratos, áreas, cargos, turnos, regímenes laborales, AFP |
| **Asistencia y Jornadas** | Marcación diaria, horas extra, permisos, vacaciones, licencias, calendarios |
| **Nómina y Planilla** | Cálculo mensual de ingresos, descuentos, aportes, boletas de pago |
| **Beneficios Sociales** | Gratificación (jul/dic), CTS (may/nov), liquidación al cese, quinta categoría |
| **Gestión de Personal** | Capacitaciones, evaluaciones de desempeño, sanciones, novedades |
| **Financiero** | Cuentas corrientes de trabajadores, préstamos, gan/desc fijo y variable |
| **Reclutamiento y Onboarding** | Postulaciones, selección, contratación digital |
| **Reportes y Analítica** | Dashboards, archivos regulatorios (PLAME, AFPNet, T-Registro) |
| **Configuración General** | Parámetros, numeración automática, grupos de cálculo, provisión de gasto |
| **Localización LATAM** | Reglas locales de beneficios sociales, impuestos, formatos electrónicos |

El `ms-rrhh` cubre desde la **definición** (maestros) hasta la **ejecución** (planilla, beneficios) y el **cierre contable** (asientos de provisión).

---

## 2. Macroprocesos y Entidades

### 2.1 Maestros de Personal (MP)

| Entidad | Tabla | Propósito |
|---------|-------|-----------|
| **Trabajador** | `trabajador` | Ficha central con datos personales, laborales, bancarios y previsionales |
| **Contrato** | `contrato` | Histórico de contratos — solo 1 activo a la vez |
| **Horario Trabajador** | `horario_trabajador` | Asignación de turnos con vigencia |
| **Área** | `area` | Estructura jerárquica del organigrama |
| **Cargo** | `cargo` | Catálogo de puestos con rango salarial |
| **Turno** | `turno` | Definición de horarios laborales |
| **Tipo Contrato** | `tipo_contrato` | INDEFINIDO, PLAZO_FIJO, TEMPORAL, PRACTICAS, FORMACION |
| **Admin AFP** | `admin_afp` | Administradoras de fondo de pensiones con tasas |
| **Régimen Laboral** | `regimen_laboral` | 728, MYPE, CAS, PRACTICAS con factores de cálculo |
| **Sexo** | `sexo` | Catálogo M/F |
| **Estado Civil** | `estado_civil` | S, C, D, V |
| **Tipo Doc Identidad** | `core.tipo_doc_identidad` | DNI, CE, PASAPORTE, etc. |

### 2.2 Asistencia y Jornadas (AJ)

| Entidad | Tabla | Propósito |
|---------|-------|-----------|
| **Asistencia** | `asistencia` | Marcación diaria entrada/salida con HE |
| **Permiso/Licencia** | `permiso_licencia` | Solicitudes con aprobación |
| **Vacación** | `vacacion` | Control de días: derecho, gozados, pendientes |
| **Program Vacación** | `program_vacacion` | Distribución mensual de días |
| **Tipo Mov Asistencia** | `tipo_mov_asistencia` | ENTRADA, SALIDA, REFRIGERIO |

### 2.3 Nómina y Planilla (PN)

| Entidad | Tabla | Propósito |
|---------|-------|-----------|
| **Cálculo Planilla** | `calculo` | Proceso batch mensual |
| **Cálculo Det** | `calculo_det` | Líneas por trabajador y concepto |
| **Concepto Planilla** | `concepto_planilla` | Catálogo de INGRESO/DESCUENTO/APORTE |
| **Gan/Desc Fijo** | `gan_desct_fijo` | Asignaciones mensuales recurrentes |
| **Gan/Desc Variable** | `gan_desct_variable` | Bonos, comisiones, HE periódicas |
| **Boleta Pago** | — (vista) | Consulta/PDF/emisión agrupando `calculo` + `calculo_det` por trabajador |
| **Tipo Planilla** | `tipo_planilla` | NORMAL, GRATIFICACION, CTS, VACACIONES |
| **Tipo Concepto Cálculo** | `tipo_concepto_calculo` | INGRESO, DESCUENTO, APORTE |

### 2.4 Beneficios Sociales (BS)

| Entidad | Tabla | Propósito |
|---------|-------|-----------|
| **Gratificación** | `gratificacion` | Cálculo semestral julio/diciembre |
| **CTS** | `cts` | Cálculo semestral mayo/noviembre |
| **Liquidación** | `liquidacion` | Beneficios al cese del trabajador |
| **Quinta Categoría** | `quinta_categoria` | Retención mensual IR |
| **Control Subsidio** | `control_subsidio` | Subsidios Essalud/SCTR |
| **Periodo Gratificación** | `periodo_gratificacion` | JULIO, DICIEMBRE |
| **Periodo CTS** | `periodo_cts` | MAYO, NOVIEMBRE |

### 2.5 Gestión de Personal (GP)

| Entidad | Tabla | Propósito |
|---------|-------|-----------|
| **Novedad RRHH** | `novedad_rrhh` | Incidencias: descansos médicos, CITT, etc. |
| **Novedad RRHH Det** | `novedad_rrhh_det` | Detalle por período de la novedad |
| **Tipo Novedad RRHH** | `tipo_novedad_rrhh` | Catálogo de tipos de novedad |
| **Sanción/Amonestación** | `sancion_amonestacion` | Registro disciplinario |
| **Tipo Sanción** | `tipo_sancion` | LLAMADO_ATENCION, AMONESTACION, SUSPENSION |
| **Capacitación** | `capacitacion` | Cursos y talleres |
| **Capacitación Trabajador** | `capacitacion_trabajador` | Participantes y resultados |
| **Evaluación Desempeño** | `evaluacion_desempeno` | Evaluaciones 90°/180°/360° |

### 2.6 Financiero (FN)

| Entidad | Tabla | Propósito |
|---------|-------|-----------|
| **Cuenta Corriente** | `cnta_crrte` | Saldos por trabajador (adelantos, deudas) |
| **Cta Cte Det** | `cnta_crrte_det` | Movimientos: crédito, débito, abono |
| **Tipo Mov Cta Cte** | `tipo_movimiento_cnta_crrte` | CREDITO, DEBITO, ABONO, AJUSTE |
| **Préstamo** | `prestamo` | Préstamos y cuotas |

### 2.7 Reclutamiento y Onboarding (RO)

| Proceso | Cobertura |
|---------|-----------|
| **Reclutamiento y Selección** | Postulaciones, filtros, entrevistas, evaluaciones, decisiones |
| **Contratación** | Plantillas de contratos con cláusulas locales, firma digital |
| **Onboarding Digital** | Asignación de capacitaciones, uniformes, validación de cumplimiento |

### 2.8 Configuración General (CONF)

| Proceso | Cobertura |
|---------|-----------|
| **Grupos de Cálculo** | Agrupación por sede, CECO, canal, cargo y salario |
| **Numeración Automática** | Correlativos para documentos del módulo |
| **Parámetros** | RMV por país, reglas de impuestos y contribuciones |
| **Provisión de Gasto** | Configuración de asientos contables de planilla |

### 2.9 Localización LATAM (LOC)

| Proceso | Cobertura |
|---------|-----------|
| **Beneficios Sociales** | Reglas locales por país |
| **Impuestos y Aportes** | Parámetros fiscales por país |
| **Archivos Electrónicos** | PLAME, AFPNet, T-Registro, formatos SUNAT |

---

## 3. Flujo Principal — Cálculo de Planilla Mensual

> **Leyenda:** ✅ implementado · ⚠️ parcial · ❌ no implementado · 📄 solo documentado (HU/contrato)

```
1. [MAESTROS] ✅
   Área → Cargo → Turno → Admin AFP
   Concepto Planilla → Tipo Novedad → Tipo Planilla
   Régimen Laboral → Tipo Contrato → Catálogos (sexo, estado civil, etc.)

2. [REGISTRO] ✅
   Trabajador ← Contrato ← Horario/Turno

3. [PRE-PLANILLA] ⚠️
    Asistencia → horas trabajadas, tardanzas, HE               ✅ 12 endpoints, flujo completo
   Permiso/Licencia → 14 endpoints completos                   ✅
   Gan/Desc Fijo → asignaciones mensuales                      ✅
   Gan/Desc Variable → bonos, comisiones, descuentos           ⚠️ falta POST /importar
   Novedad RRHH → incidencias del período                      ✅
   Prestamo → cuotas a descontar                               ✅
   Cta Cte → saldos/deudas                                     ✅

4. [CÁLCULO] ⚠️
   Cálculo Planilla (proceso batch mensual)
     → Ingresos: sueldo, bonos, HE, comisiones, asignación familiar   ✅ (básico)
     → Descuentos: AFP/ONP, IR quinta, préstamos, faltas, Cta Cte     ⚠️ solo AFP
     → Aportes: Essalud, SENATI, SCTR                                  ❌ no implementados
     → Resultado persistido en `calculo` + `calculo_det`               ✅
     → Boleta de pago: vista/PDF desde `calculo_det`                   ❌ no implementada emisión
      → Flujo aprobación: BORRADOR → APROBADO → CERRADO                ✅ 8 endpoints, flujo completo (procesar/aprobar/rechazar/cerrar/revertir)
     → Columna `estado` en DDL                                         🔴 no existe en `07-rrhh.sql`

5. [BENEFICIOS LEGALES] ✅
   Gratificación (Jul/Dic) → batch semestral                    ✅
   CTS (May/Nov) → batch semestral                              ✅
    Vacaciones → por período solicitado                          ✅ 15 endpoints, flujo completo
   Liquidación → al cese del trabajador                         ✅
   Quinta Categoría → retención mensual IR                      ✅

6. [CIERRE CONTABLE] ❌
   Provisión de gasto → asiento contable                        ❌ pendiente (RabbitMQ)
   Cuenta por Pagar → finanzas                                  ❌ pendiente (FK diferida existe)
```

---

## 4. Estados por Entidad — Con problemas detectados

| Entidad | Campo | Estados | Issue |
|---------|:-----:|---------|-------|
| Maestros (Area, Cargo, Turno, etc.) | `flag_estado` | `1` Activo / `0` Inactivo | ✅ |
| Trabajador | `flag_estado` | `1` Activo / `0` Cesado | ✅ |
| Contrato | `flag_estado` | `1` Vigente / `0` Extinto | ✅ |
| Horario Trabajador | `flag_estado` | `1` Activo / `0` Inactivo | ✅ |
| Asistencia | `flag_estado` | `1` Activo / `0` Anulado / `C` Cerrado / `P` Pendiente | ⚠️ multi-estado documentado pero sin lógica de transiciones en código |
| Permiso/Licencia | `flag_estado` | `1` Solicitado / `2` Aprobado / `3` Observado / `4` Anulado / `5` Cerrado / `6` Procesado / `7` En Planilla / `8` En Boleta / `0` Rechazado | ✅ máquina de estados implementada (8 estados) |
| Vacación (goce) | `flag_estado` | `0` Anulado / `1` Registrado / `2` Pendiente / `3` Aprobado / `4` Rechazado / `5` Cerrado (`CK_VACACION_ESTADO`) | ✅ máquina de estados en `VacacionServiceImpl` |
| Program Vacación | `flag_estado` | `1` Activo / `0` Anulado | ✅ |
| Cálculo Planilla | `estado` (texto) | BORRADOR / APROBADO / RECHAZADO / CERRADO | 🔴 columna `estado` NO EXISTE en DDL |
| Liquidación | `flag_estado` | `1` Pendiente / `2` Aprobada / `0` Anulada | ✅ |
| Préstamo | `flag_estado` | `1` Activo / `0` Pagado/Cancelado | ✅ |
| Cuenta Corriente | `flag_estado` | `1` Abierta / `0` Cerrada | ✅ |
| Novedad RRHH | `flag_estado` | `1` Activo / `0` Inactivo | ✅ |
| Sanción | `flag_estado` | `1` Activo / `0` Anulado | ✅ |
| Capacitación | `flag_estado` | `1` Activo / `0` Inactivo | ✅ |
| Gratificación / CTS | Sin flag | No aplica (registro batch) | ✅ |
| Gan/Desc Fijo | `flag_estado` | `1` Activo / `0` Inactivo | ✅ |

---

## 5. Conceptos Clave

| Concepto | Explicación |
|----------|-------------|
| **Planilla ≠ Beneficios** | El cálculo mensual (planilla) y los beneficios legales (gratif/CTS/vac) son procesos separados. La planilla se calcula mes a mes; los beneficios son semestrales/anuales. |
| **Gan/Desc Fijo ≠ Variable** | Fijo: se aplica todos los meses (ej: asignación familiar). Variable: se aplica en períodos específicos (ej: bonos, horas extra). |
| **Novedad ≠ Permiso** | La novedad es más amplia: puede ser un permiso, una incapacidad, una licencia sin goce, etc. Los tipos se definen en `tipo_novedad_rrhh`. |
| **Boleta ≠ Plantilla** | La boleta es el resultado del cálculo; es un documento digital que se envía al trabajador. No es una plantilla de diseño. |
| **Cálculo batch** | No se ingresa manualmente, se ejecuta un proceso que calcula todo el período de una sola vez. |
| **Gratificación ≠ Bono** | La gratificación es un beneficio legal obligatorio (Ley 27735). No es un bono discrecional. |
| **CTS** | Depósito semestral en entidad financiera. El sistema calcula el monto, el depósito lo hace tesorería. |
| **Liquidación** | Al cese del trabajador se calculan todos los beneficios truncas en un solo proceso. |
| **Quinta Categoría** | Retención mensual del Impuesto a la Renta sobre rentas de quinta categoría. Se calcula acumulada mes a mes. |
| **Subsidio** | Monto que Essalud paga al trabajador durante una incapacidad temporal. El sistema controla los períodos. |
| **Cta Corriente** | Funciona como una cuenta de haber: se cargan adelantos, descuentos, ajustes. El saldo puede ser deudor o acreedor. |

---

## 6. Mapa de Dependencias entre Entidades

```
                         ┌──────────────┐
                         │  Trabajador   │
                         └──────┬───────┘
                                │
          ┌─────────────────────┼──────────────────────┐
          ▼                     ▼                      ▼
   ┌──────────────┐    ┌──────────────┐     ┌────────────────┐
   │   Contrato   │    │Horario Trab. │     │  Asistencia    │
   └──────────────┘    └──────────────┘     └────────┬───────┘
                                                      │
   ┌──────────────┐    ┌──────────────┐     ┌────────┴───────┐
   │ Novedad RRHH │    │Permiso/Licen.│     │   Vacación     │
   └──────────────┘    └──────────────┘     └────────────────┘

   ┌──────────────┐    ┌──────────────┐     ┌────────────────┐
   │ Gan/Desc Fijo│    │Gan/Desc Var. │     │  Cálculo       │
   └──────────────┘    └──────────────┘     ───────┬─────────┘
                                                      │
                ┌─────────────────────────────────────┼──────────┐
                ▼                     ▼                ▼          ▼
        ┌──────────────┐     ┌──────────────┐  ┌──────────┐ ┌──────────┐
        │Boleta Pago   │     │ Gratificación│  │   CTS    │ │Liquidac. │
        └──────────────┘     └──────────────┘  └──────────┘ └──────────┘

   ┌──────────────┐    ┌──────────────┐     ┌────────────────┐
   │ Cuenta Cte   │    │  Préstamo    │     │Quinta Categoría│
   └──────────────┘    └──────────────┘     └────────────────┘

   ┌──────────────┐    ┌──────────────┐     ┌────────────────┐
   │ Capacitación │    │Sanción/Amon. │     │Evaluación Des. │
   └──────────────┘    └──────────────┘     └────────────────┘
```

---

## 7. Resumen Visual de Responsabilidades — Estado Real

> **Leyenda:** ✅ completo

```
MAESTROS DE PERSONAL                     Estado      Brechas
├── Trabajador      → Ficha central       ✅
├── Contrato        → Sub-recurso         ✅
├── Horario         → Sub-recurso         ✅
├── Área            → Organigrama          ✅
├── Cargo           → Catálogo             ✅
├── Turno           → Horarios             ✅
├── Admin AFP       → Pensiones            ✅
├── Régimen Laboral → Factores legales     ✅
├── Tipo Contrato   → Catálogo             ✅
├── Sexo / Est. Civil / Tpo Doc            ✅
└── Catálogos (20)  → GET /activos ✅     ✅  todos completos

ASISTENCIA Y JORNADAS
├── Marcación       → Entrada/salida       ✅ 12 endpoints, flujo completo
├── Permiso/Licencia→ 14 endpoints          ✅ completo
├── Vacaciones      → 15 endpoints          ✅  flujo completo (observar, anular, cerrar, bandeja, saldos, procesar)
└── Horas Extra     → Cálculo básico        ⚠️  solo en contrato, sin lógica específica

NÓMINA Y PLANILLA
├── Ingresos        → Sueldo + bonos        ⚠️  solo concepto fijo C001
├── Descuentos      → AFP/ONP               ⚠️  solo AFP, sin ONP/IR quinta/préstamos/faltas/Cta Cte
├── Aportes         → Essalud/SENATI/SCTR   ❌  no implementados
├── Boleta Pago     → 5 endpoints           ❌  no se genera automáticamente, sin PDF/descarga
├── Flujo batch     → BORRADOR→CERRADO      ✅  8 endpoints, flujo completo
└── Columna estado  → DDL                   🔴 no existe en `07-rrhh.sql`

BENEFICIOS LEGALES
├── Gratificación   → 3 endpoints            ✅
├── CTS             → 3 endpoints            ✅
├── Liquidación     → 5 endpoints            ✅
├── Quinta Categ.   → 3 endpoints            ✅
└── Subsidio        → 5 endpoints            ✅

FINANCIERO
├── Cuenta Cte.     → 10 endpoints           ✅
├── Préstamo        → 5 endpoints            ✅
├── Gan/Desc Fijo   → 5 endpoints            ✅
└── Gan/Desc Var.   → 6 endpoints            ✅  incluye POST /importar

GESTIÓN DE PERSONAL
├── Capacitación    → 9 endpoints            ✅  incluye PUT /participantes/{id}
├── Evaluación      → 5 endpoints            ✅
├── Sanción         → 5 endpoints            ✅
├── Novedad         → 8 endpoints            ✅

RECLUTAMIENTO Y ONBOARDING                 ❌  solo documentado, sin código
CONFIGURACIÓN GENERAL                      ❌  solo documentado, sin código
LOCALIZACIÓN LATAM                         ❌  solo documentado, sin código
CIERRE CONTABLE (RabbitMQ)                 ❌  solo planificado
```

---

## 8. Referencia a la Documentación Detallada

Cada entidad tiene su HU (`HU_*.md`) y su contrato API (`CONTRATO_*.md`) en:
`05. Documentacion/markdown/Contratos/ms-rrhh/`

| Entidad | Archivos |
|---------|----------|
| Area | `HU_AREA.md` / `CONTRATO_AREA.md` |
| Cargo | `HU_CARGO.md` / `CONTRATO_CARGO.md` |
| Turno | `HU_TURNO.md` / `CONTRATO_TURNO.md` |
| Admin AFP | `HU_ADMIN_AFP.md` / `CONTRATO_ADMIN_AFP.md` |
| Concepto Planilla | `HU_CONCEPTO_PLANILLA.md` / `CONTRATO_CONCEPTO_PLANILLA.md` |
| Tipo Novedad | `HU_TIPO_NOVEDAD.md` / `CONTRATO_TIPO_NOVEDAD.md` |
| Trabajador | `HU_TRABAJADOR.md` / `CONTRATO_TRABAJADOR.md` |
| Contrato Laboral | `HU_CONTRATO_LABORAL.md` / `CONTRATO_CONTRATO_LABORAL.md` |
| Horario Trabajador | `HU_HORARIO_TRABAJADOR.md` / `CONTRATO_HORARIO_TRABAJADOR.md` |
| Asistencia | `HU_ASISTENCIA.md` / `CONTRATO_ASISTENCIA.md` |
| Permiso/Licencia | `HU_PERMISO_LICENCIA.md` / `CONTRATO_PERMISO_LICENCIA.md` |
| Vacación | `HU_VACACION.md` / `CONTRATO_VACACION.md` |
| Cálculo Planilla | `HU_CALCULO_PLANILLA.md` / `CONTRATO_CALCULO_PLANILLA.md` |
| Gan/Desc Fijo | `HU_GANANCIA_DESCUENTO_FIJO.md` / `CONTRATO_GANANCIA_DESCUENTO_FIJO.md` |
| Gan/Desc Variable | `HU_GANANCIA_DESCUENTO_VARIABLE.md` / `CONTRATO_GANANCIA_DESCUENTO_VARIABLE.md` |
| Boleta Pago | `HU_BOLETA_PAGO.md` / `CONTRATO_BOLETA_PAGO.md` |
| Gratificación | `HU_GRATIFICACION.md` / `CONTRATO_GRATIFICACION.md` |
| CTS | `HU_CTS.md` / `CONTRATO_CTS.md` |
| Liquidación | `HU_LIQUIDACION.md` / `CONTRATO_LIQUIDACION.md` |
| Quinta Categoría | `HU_QUINTA_CATEGORIA.md` / `CONTRATO_QUINTA_CATEGORIA.md` |
| Préstamo | `HU_PRESTAMO.md` / `CONTRATO_PRESTAMO.md` |
| Cuenta Corriente | `HU_CUENTA_CORRIENTE.md` / `CONTRATO_CUENTA_CORRIENTE.md` |
| Novedad RRHH | `HU_NOVEDAD_RRHH.md` / `CONTRATO_NOVEDAD_RRHH.md` |
| Sanción/Amonestación | `HU_SANCION_AMONESTACION.md` / `CONTRATO_SANCION_AMONESTACION.md` |
| Capacitación | `HU_CAPACITACION.md` / `CONTRATO_CAPACITACION.md` |
| Evaluación Desempeño | `HU_EVALUACION_DESEMPENO.md` / `CONTRATO_EVALUACION_DESEMPENO.md` |
| Control Subsidio | `HU_CONTROL_SUBSIDIO.md` / `CONTRATO_CONTROL_SUBSIDIO.md` |
| Sexo | `HU_SEXO.md` / `CONTRATO_SEXO.md` |
| Estado Civil | `HU_ESTADO_CIVIL.md` / `CONTRATO_ESTADO_CIVIL.md` |
| Régimen Laboral | `HU_REGIMEN_LABORAL.md` / `CONTRATO_REGIMEN_LABORAL.md` |
| Tipo Contrato | `HU_TIPO_CONTRATO.md` / `CONTRATO_TIPO_CONTRATO.md` |
| Tipo Doc Identidad | `HU_TIPO_DOC_IDENTIDAD.md` / `CONTRATO_TIPO_DOC_IDENTIDAD.md` |
| Tipo Mov Asistencia | `HU_TIPO_MOV_ASISTENCIA.md` / `CONTRATO_TIPO_MOV_ASISTENCIA.md` |
| Tipo Subsidio | `HU_TIPO_SUBSIDIO.md` / `CONTRATO_TIPO_SUBSIDIO.md` |
| Tipo Suspensión Laboral | `HU_TIPO_SUSPENSION_LABORAL.md` / `CONTRATO_TIPO_SUSPENSION_LABORAL.md` |
| Tipo Sanción | `HU_TIPO_SANCION.md` / `CONTRATO_TIPO_SANCION.md` |
| Tipo Planilla | `HU_TIPO_PLANILLA.md` / `CONTRATO_TIPO_PLANILLA.md` |
| Tipo Concepto Cálculo | `HU_TIPO_CONCEPTO_CALCULO.md` / `CONTRATO_TIPO_CONCEPTO_CALCULO.md` |
| Tipo Mov Cta Cte | `HU_TIPO_MOVIMIENTO_CNTA_CRRTE.md` / `CONTRATO_TIPO_MOVIMIENTO_CNTA_CRRTE.md` |
| Periodo Gratificación | `HU_PERIODO_GRATIFICACION.md` / `CONTRATO_PERIODO_GRATIFICACION.md` |
| Periodo CTS | `HU_PERIODO_CTS.md` / `CONTRATO_PERIODO_CTS.md` |
