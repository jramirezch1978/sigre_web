# Solicitud de Cambio DDL — rrhh.calculo.estado

**Solicitante:** Dev Backend (ms-rrhh)  
**Destinatario:** Arquitecto de Base de Datos  
**Prioridad:** Media  
**Dependencia:** Flujo de aprobación de cálculo de planilla

---

## Cambio solicitado

Agregar columna `estado` en la tabla `rrhh.calculo` para implementar el flujo de
aprobación del cálculo de planilla (BORRADOR → APROBADO → CERRADO).

```sql
ALTER TABLE rrhh.calculo
  ADD COLUMN IF NOT EXISTS estado VARCHAR(20) NOT NULL DEFAULT 'BORRADOR';
```

> **Nota:** El `DEFAULT 'BORRADOR'` es importante para no romper los registros
> existentes que se crearon antes de esta columna.

---

## Mapeo de estados

Actualmente se manejan como String en la aplicación (`CalculoServiceImpl.java`).
A futuro se puede migrar a tabla `rrhh.estado_calculo` con FK si el arquitecto
lo considera necesario.

| Código     | Significado         | Transiciones válidas                         |
|------------|---------------------|----------------------------------------------|
| `BORRADOR` | Cálculo ejecutado   | → `APROBADO` · → `RECHAZADO` · → `BORRADOR` |
| `APROBADO` | Aprobado por supervisor | → `CERRADO`                              |
| `RECHAZADO`| Rechazado, requiere corrección | → `BORRADOR`                     |
| `CERRADO`  | Cerrado definitivo  | → `BORRADOR` (revertir, permisos especiales) |

### Transiciones

```
BORRADOR  ──aprobar──▶  APROBADO  ──cerrar──▶  CERRADO
    │                                                │
    ├──rechazar──▶  RECHAZADO                        │
    └──re-ejecutar──▶  BORRADOR  ◀──revertir─────────┘
```

---

## Código impactado

| Archivo | Cambio |
|---------|--------|
| `entity/Calculo.java` | Agregar campo `private String estado;` con `@Column(name = "estado")` |
| `service/impl/CalculoServiceImpl.java` | Validar transiciones con `Set<String>` · Setear `"BORRADOR"` en `procesar()` |
| `dto/response/CalculoResponse.java` | Agregar campo `private String estado;` |
| `dto/response/CalculoDetalleResponse.java` | Agregar campo `private String estado;` |
| `mapper/CalculoMapper.java` | Mapear `c.getEstado()` en ambos métodos |

---

## Historial

| Fecha | Acción |
|-------|--------|
| 30/05/2026 | Solicitud creada — pendiente de ejecución por arquitecto BD |
| 30/05/2026 | **Auditoría confirma:** la columna `estado` NO existe en `07-rrhh.sql` (CREATE TABLE ni migración). Cualquier INSERT a `calculo` desde la aplicación falla. Se sube prioridad a 🔴 Crítica. |
| 02/06/2026 | **Re-auditoría:** la columna `estado` sigue sin existir en el DDL. El controller `CalculoController` expone 5 endpoints (procesar, GET list, GET/{id}, DELETE, aprobar). Faltan rechazar/cerrar/revertir. Esto bloquea el flujo de aprobación completo. |
