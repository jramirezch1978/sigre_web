# Reglas de Negocio — ms-rrhh

**Leyenda:** ✅ implementado · ⚠️ parcial (controller existe, validaciones incompletas) · ❌ no implementado

---

## Códigos por Dominio

| Prefijo | Entidad | Estado | Notas |
|---------|---------|:------:|-------|
| `RH-AR-*` | Área | ✅ | |
| `RH-CG-*` | Cargo | ✅ | |
| `RH-TU-*` | Turno | ✅ | |
| `RH-AF-*` | Admin AFP | ✅ | |
| `RH-CP-*` | Concepto Planilla | ✅ | |
| `RH-TN-*` | Tipo Novedad RRHH | ✅ | |
| `RH-GD-*` | Gan/Desc Fijo | ✅ | |
| `RH-GV-*` | Gan/Desc Variable | ✅ | |
| `RH-TR-*` | Trabajador | ✅ | |
| `RH-CL-*` | Contrato Laboral | ✅ | |
| `RH-HT-*` | Horario Trabajador | ✅ | |
| `RH-AS-*` | Asistencia | ✅ | |
| `RH-PL-*` | Permiso/Licencia | ✅ | 14 endpoints completos |
| `RH-VC-*` | Vacación | ✅ | 15 endpoints, flujo completo |
| `RH-CA-*` | Cálculo Planilla | ✅ | 8 endpoints (procesar, aprobar, rechazar, cerrar, revertir) |
| `RH-BP-*` | Boleta Pago | ❌ | funcionalidad descartada |
| `RH-GR-*` | Gratificación | ✅ | |
| `RH-CT-*` | CTS | ✅ | |
| `RH-LQ-*` | Liquidación | ✅ | |
| `RH-QC-*` | Quinta Categoría | ✅ | |
| `RH-NV-*` | Novedad RRHH | ✅ | |
| `RH-SA-*` | Sanción/Amonestación | ✅ | |
| `RH-CP-*` | Concepto Planilla | ✅ | ⚠️ código `RH-CP-*` duplicado con Capacitación |
| `RH-CA-*` (Capacitación) | Capacitación | ✅ | ⚠️ mismo prefijo que Cálculo Planilla |
| `RH-ED-*` | Evaluación Desempeño | ✅ | controller implementado (5 endpoints) |
| `RH-CC-*` | Cuenta Corriente | ✅ | |
| `RH-PR-*` | Préstamo | ✅ | |
| `RH-SB-*` | Control Subsidio | ✅ | controller implementado (5 endpoints) |
| `RH-TS-*` | Tipo Sanción | ✅ | |
| `RH-TL-*` | Tipo Suspensión Laboral | ✅ | |

---

## Reglas Transversales

| Regla | Estado | Notas |
|-------|:------:|-------|
| Baja lógica (`flagEstado = "0"`) | ✅ | Ninguna entidad se elimina físicamente |
| Código único por tenant | ✅ | Verificado case-insensitive |
| Validación externa vía Feign | ✅ | `core.entidad_contribuyente`, `core.tipo_doc_identidad`, `auth.sucursal` |
| Paginación estándar | ✅ | `page`, `size`, `sort` con `PageData` wrapper |
| Auditoría automática | ✅ | `created_by`/`fec_creacion` en INSERT, `updated_by`/`fec_modificacion` en UPDATE |
| JWT obligatorio | ✅ | Todos los endpoints requieren token definitivo de `ms-auth-security` |

---

## Reglas por Dominio

### Área (RH-AR) — ✅
| Código | Regla |
|--------|-------|
| RH-AR-001 | Nombre obligatorio |
| RH-AR-002 | No desactivar con trabajadores activos |
| RH-AR-003 | No eliminar con hijos activos |
| RH-AR-004 | Auto-referencia padre (jerarquía) |

### Cargo (RH-CG) — ✅
| Código | Regla |
|--------|-------|
| RH-CG-001 | Nombre obligatorio |
| RH-CG-002 | No desactivar con trabajadores activos |
| RH-CG-003 | Sueldo mínimo ≤ máximo |

### Turno (RH-TU) — ✅
| Código | Regla |
|--------|-------|
| RH-TU-001 | Nombre obligatorio |
| RH-TU-002 | Al menos un día asignado |
| RH-TU-003 | Hora entrada requiere hora salida |
| RH-TU-004 | No desactivar con horarios activos |

### Admin AFP (RH-AF) — ✅
| Código | Regla |
|--------|-------|
| RH-AF-001 | Nombre obligatorio |
| RH-AF-002 | Comisión + prima + aporte deben sumar |
| RH-AF-003 | No desactivar con trabajadores activos |

### Concepto Planilla (RH-CP) — ✅
| Código | Regla |
|--------|-------|
| RH-CP-001 | Código único |
| RH-CP-002 | Tipo debe ser INGRESO / DESCUENTO / APORTE |
| RH-CP-003 | No desactivar en uso |
| RH-CP-004 | Nombre obligatorio |
| RH-CP-005 | No encontrado |

### Tipo Novedad RRHH (RH-TN) — ✅
| Código | Regla |
|--------|-------|
| RH-TN-001 | Código obligatorio |
| RH-TN-002 | Código duplicado |
| RH-TN-003 | Nombre obligatorio |
| RH-TN-004 | No desactivar en uso |
| RH-TN-005 | No encontrado |

### Gan/Desc Fijo (RH-GD) — ✅
| Código | Regla |
|--------|-------|
| RH-GD-001 | Datos obligatorios: trabajador, concepto, importe o porcentaje |
| RH-GD-002 | Trabajador inexistente |
| RH-GD-003 | Concepto inexistente |
| RH-GD-004 | Duplicado: mismo trabajador + concepto activo |
| RH-GD-005 | No encontrado |

### Gan/Desc Variable (RH-GV) — ✅
| Código | Regla |
|--------|-------|
| RH-GV-001 | Datos obligatorios: trabajador, concepto, fecha movimiento, importe |
| RH-GV-002 | Trabajador inexistente |
| RH-GV-003 | Concepto inexistente |
| RH-GV-004 | Tipo planilla inválido |
| RH-GV-005 | No encontrado |

### Trabajador (RH-TR) — ✅
| Código | Regla |
|--------|-------|
| RH-TR-001 | Datos obligatorios: codigoTrabajador, nombres, tipoDocIdentidadId, numeroDocumento |
| RH-TR-002 | FK inexistente: entidad contribuyente, AFP, área, cargo o sucursal |
| RH-TR-003 | Duplicidad de codigoTrabajador |
| RH-TR-004 | Duplicidad de numeroDocumento |
| RH-TR-005 | Edad fuera de rango (18-100 años) |
| RH-TR-006 | AFP obligatoria si sistema pensionario es AFP |
| RH-TR-007 | FK de catálogo inválida |
| RH-TR-008 | Email inválido |
| RH-TR-009 | Fecha de cese anterior a fecha de ingreso |
| RH-TR-010 | No modificar trabajador inactivo sin reactivar |

### Contrato Laboral (RH-CL) — ✅
| Código | Regla |
|--------|-------|
| RH-CL-001 | Datos obligatorios: tipoContratoId, fechaInicio |
| RH-CL-002 | FK tipoContratoId inválida o inactiva |
| RH-CL-003 | Ya existe contrato activo para este trabajador |
| RH-CL-004 | Fecha fin no puede ser anterior a fecha inicio |

### Horario Trabajador (RH-HT) — ✅
| Código | Regla |
|--------|-------|
| RH-HT-001 | Datos obligatorios: turnoId, fechaDesde |
| RH-HT-002 | Turno inexistente o inactivo |
| RH-HT-003 | Ya existe horario activo para este trabajador |
| RH-HT-004 | Solapamiento de fechas |

### Asistencia (RH-AS) — ✅
| Código | Regla |
|--------|-------|
| RH-AS-001 | Trabajador debe existir y estar activo |
| RH-AS-002 | No duplicar registro para mismo trabajador y fecha |
| RH-AS-003 | Hora salida debe ser posterior a hora entrada |
| RH-AS-004 | No modificar/anular registro cerrado |
| RH-AS-005 | No encontrado |

### Permiso/Licencia (RH-PL) — ✅
| Código | Regla |
|--------|-------|
| RH-PL-001 | Datos incompletos |
| RH-PL-002 | Trabajador inexistente |
| RH-PL-003 | Fechas inválidas |
| RH-PL-004 | Conflicto con otro permiso |
| RH-PL-005 | Ya aprobado/rechazado |

### Cálculo Planilla (RH-CA) — ✅
| Código | Regla |
|--------|-------|
| RH-CA-001 | Año y mes obligatorios |
| RH-CA-002 | Tipo planilla obligatorio y FK válida |
| RH-CA-003 | Periodo ya cerrado |
| RH-CA-004 | Sin trabajadores activos |
| RH-CA-005 | Transición de estado inválida |
| RH-CA-006 | Sin permisos para revertir |

### Boleta Pago (RH-BP) — ✅
| Código | Regla |
|--------|-------|
| RH-BP-001 | No encontrado |
| RH-BP-002 | Cálculo no aprobado para emisión |
| RH-BP-003 | Boleta ya emitida |
| RH-BP-004 | Sin boletas para emitir |

### Gratificación (RH-GR) — ✅
| Código | Regla |
|--------|-------|
| RH-GR-001 | Año obligatorio |
| RH-GR-002 | Periodo inválido (solo JULIO/DICIEMBRE) |
| RH-GR-003 | Sin trabajadores con derecho en período |
| RH-GR-004 | Registro no encontrado |

### CTS (RH-CT) — ✅
| Código | Regla |
|--------|-------|
| RH-CT-001 | Año obligatorio |
| RH-CT-002 | Periodo inválido (solo MAYO/NOVIEMBRE) |
| RH-CT-003 | Sin trabajadores con derecho en período |
| RH-CT-004 | Registro no encontrado |

### Liquidación (RH-LQ) — ✅
| Código | Regla |
|--------|-------|
| RH-LQ-001 | Trabajador obligatorio |
| RH-LQ-002 | Trabajador sin fecha de cese |
| RH-LQ-003 | Liquidación duplicada para mismo trabajador y cese |
| RH-LQ-004 | No encontrado |
| RH-LQ-005 | Solo aprobar en estado Pendiente |
| RH-LQ-006 | Solo anular en estado Pendiente |

### Quinta Categoría (RH-QC) — ✅
| Código | Regla |
|--------|-------|
| RH-QC-001 | Trabajador obligatorio |
| RH-QC-002 | Año y mes obligatorios |
| RH-QC-003 | Cálculo ya existe para período |
| RH-QC-004 | No encontrado |

### Novedad RRHH (RH-NV) — ✅
| Código | Regla |
|--------|-------|
| RH-NV-001 | Trabajador obligatorio |
| RH-NV-002 | Tipo novedad obligatorio |
| RH-NV-003 | Fechas obligatorias y coherentes |
| RH-NV-004 | Fecha proceso obligatoria en detalle |
| RH-NV-005 | No encontrado |

### Sanción/Amonestación (RH-SA) — ✅
| Código | Regla |
|--------|-------|
| RH-SA-001 | Datos incompletos |
| RH-SA-002 | Trabajador inexistente |
| RH-SA-003 | Tipo sanción inexistente |
| RH-SA-004 | Fecha futura no permitida |
| RH-SA-005 | No encontrado |

### Capacitación (RH-CA) — ✅
| Código | Regla |
|--------|-------|
| RH-CA-001 | Nombre obligatorio |
| RH-CA-002 | Fechas inválidas |
| RH-CA-003 | No desactivar con participantes |
| RH-CA-004 | No encontrado |
| RH-CA-005 | Participante duplicado |

### Cuenta Corriente (RH-CC) — ✅
| Código | Regla |
|--------|-------|
| RH-CC-001 | Datos incompletos |
| RH-CC-002 | Cuenta duplicada por trabajador |
| RH-CC-003 | No cerrar con saldo |
| RH-CC-004 | Movimiento sin cuenta activa |

### Préstamo (RH-PR) — ✅
| Código | Regla |
|--------|-------|
| RH-PR-001 | Datos incompletos |
| RH-PR-002 | Trabajador inexistente |
| RH-PR-003 | Monto/cuotas inválidos |
| RH-PR-004 | Modificar con cuotas descontadas |

### Tipo Sanción (RH-TS) — ✅
| Código | Regla |
|--------|-------|
| RH-TS-001 | Nombre obligatorio |
| RH-TS-002 | Código único |
| RH-TS-003 | No desactivar en uso |

### Tipo Suspensión Laboral (RH-TL) — ✅
| Código | Regla |
|--------|-------|
| RH-TL-001 | Nombre obligatorio |
| RH-TL-002 | Código único |
| RH-TL-003 | FK tipo_subsidio inválida |

### Vacación (RH-VC) — ✅ (15 endpoints, flujo completo)

| Código | Regla |
|--------|-------|
| RH-VC-001 | Trabajador debe existir y estar activo |
| RH-VC-002 | Fecha fin debe ser >= fecha inicio |
| RH-VC-003 | Días solicitados no deben exceder días pendientes |
| RH-VC-004 | No modificar en estado Aprobado o Anulado |
| RH-VC-005 | No duplicar período vacacional por trabajador y año |

### Evaluación Desempeño (RH-ED) — ✅ (5 endpoints)

| Código | Regla |
|--------|-------|
| RH-ED-001 | Trabajador obligatorio |
| RH-ED-002 | Período (anio, semestre) obligatorio |
| RH-ED-003 | Calificación fuera de rango |
| RH-ED-004 | No encontrado |

### Control Subsidio (RH-SB) — ✅ (5 endpoints)

| Código | Regla |
|--------|-------|
| RH-SB-001 | Trabajador obligatorio |
| RH-SB-002 | Tipo subsidio obligatorio |
| RH-SB-003 | Fechas inválidas |
| RH-SB-004 | No encontrado |

---

## Flujos de Estado Detallados

### Permiso/Licencia
```
Solicitado (flag=1) → Aprobado (flag=2) [jefe directo aprueba]
Solicitado (flag=1) → Rechazado (flag=0) [jefe directo rechaza]
```

### Liquidación
```
Pendiente (1) → Aprobada (2)
Pendiente (1) → Anulada (0)
```

---

## Flujo Batch — Gratificación
1. Seleccionar `anio` + `periodo_gratificacion_id` (JULIO/DICIEMBRE)
2. Sistema busca trabajadores activos con 1+ meses en período
3. Por cada trabajador calcula:
   - `remuneracion_computable` = sueldo + asignación familiar + promedio bonos
   - `monto_gratificacion` = (remuneracion_computable / 6) × meses_laborados
   - `bonificacion_extraordinaria` = 9% de monto_gratificacion (Ley 30334)
   - `total` = monto_gratificacion + bonificacion_extraordinaria

## Flujo Batch — CTS
1. Seleccionar `anio` + `periodo_cts_id` (MAYO/NOVIEMBRE)
2. Sistema busca trabajadores activos en el período
3. Por cada trabajador calcula:
   - `remuneracion_computable` = sueldo + 1/6 gratificación + asignación familiar
   - `meses_computables` = meses laborados en el semestre
   - `dias_computables` = días adicionales
   - `monto_cts` = (remuneracion_computable / 12) × meses_computables + (remuneracion_computable / 360) × dias_computables

## Flujo Batch — Cálculo de Planilla
1. Seleccionar `anio`, `mes`, `tipo_planilla_id`
2. Por cada trabajador activo:
   - Aplicar conceptos fijos (`gan_desct_fijo`)
   - Aplicar conceptos variables (`gan_desct_variable`) del período
   - Calcular aportes (Essalud, SENATI, SCTR)
   - Generar líneas de `calculo_det`
3. Totalizar y actualizar cabecera `calculo`
4. Persistir **únicamente** en `calculo` (cabecera) y `calculo_det` (detalle). No se crean registros en otras tablas.
