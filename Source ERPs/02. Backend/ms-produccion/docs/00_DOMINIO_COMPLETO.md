# ms-produccion — Explicación Funcional

> Puerto: `9009` | Esquema BD: `produccion`
> Este documento explica **qué hace cada módulo**, **cómo funciona** y **cómo se relacionan** entre sí.
> No es un listado técnico de endpoints — para eso están los contratos API y el código.

---

## 1. El Problema de Fondo

Un restaurante necesita saber **qué ingredientes entran en cada plato**, **cuánto cuesta producirlo**, **cómo se prepara paso a paso**, y **cuánto se produce vs cuánto se vende**. Todo esto es el dominio de **producción**.

El ms-produccion cubre desde la **definición** (recetas, labores) hasta la **ejecución** (órdenes de trabajo, partes diarios) y el **cierre** (control de calidad, costeo).

---

## 2. La Receta — El Corazón del Sistema

### ¿Qué es?

Una receta es la **definición estandarizada de cómo se produce un plato**. No es solo una lista de ingredientes — es un documento completo que incluye:

- **Qué artículo se produce** (ej: "Lomo Saltado" → FK a `core.articulo`)
- **Qué ingredientes consume directamente** (`receta_labor_consumible` con cantidad)
- **En qué orden se ejecutan los pasos** (secuencia de labores, cada una con sus insumos de `labor_insumo`)
- **Ficha técnica**: calorías, alérgenos, tiempo de preparación, instrucciones de emplatado
- **Costos estimados**: mano de obra + indirectos + insumos
- **Rendimiento**: cuántas porciones produce, % de merma esperada

### ¿Cómo se estructura?

```
RECETA (cabecera - el "qué")
  ├── articulo_producido ej: Lomo Saltado (producto terminado)
  ├── tipo: PLATO | BEBIDA | POSTRE | PREPARACION_BASE
  ├── versión: 1, 2, 3... (histórico)
  │
  ├── RECETA_LABOR (pasos - el "cómo")
  │     ├── paso 1: "Cortar verduras" → LABOR: "Corte fino"
  │     │     ├── LABOR_INSUMO: cebolla, tomate, ajo (articulos del almacén)
  │     │     └── LABOR_PRODUCCION: verduras picadas (intermedio)
  │     ├── paso 2: "Saltear" → LABOR: "Salteado wok"
  │     │     ├── LABOR_INSUMO: aceite, sal, verduras picadas + carne
  │     │     └── LABOR_PRODUCCION: salteado listo
  │     └── paso 3: "Emplatar" → LABOR: "Emplatado"
  │           └── LABOR_INSUMO: salteado listo, arroz, guarnición
  │
  ├── RECETA_LABOR_CONSUMIBLE (ingredientes directos con cantidad)
  │     └── articulo: "cebolla" × 200g, "tomate" × 150g...
  │
  └── FICHA_TECNICA (datos complementarios)
        ├── nutricional: calorías, proteínas, carbohidratos, grasas
        ├── preparación: tiempo, temperatura de servicio, instrucciones
        └── alérgenos: gluten, lactosa, frutos secos...
```

### ¿Dónde están los ingredientes y sus cantidades?

Hay **tres niveles** donde aparecen ingredientes:

| Nivel | Tabla | ¿Tiene cantidad? | Propósito |
|-------|-------|:----------------:|-----------|
| **Catálogo de labor** | `labor_insumo` | No | Define qué artículos PUEDE consumir una labor (reusable) |
| **Receta** | `receta_labor_consumible` | Sí | Define CUÁNTO consume esta receta específica de cada ingrediente |
| **Ejecución** | `parte_produccion_insumo` | Sí | Registra lo que realmente se consumió al producir |

**Ejemplo concreto:**
- `labor_insumo`: la labor "Corte fino" PUEDE consumir `cebolla, tomate, ajo` (catálogo, sin cantidades)
- `receta_labor_consumible`: la receta "Lomo Saltado" consume `200g cebolla, 150g tomate, 10g ajo` (cantidades reales de la receta estandarizada)
- `parte_produccion_insumo`: cuando se ejecuta, se registró que realmente se consumieron `210g cebolla, 155g tomate, 12g ajo` (merma real)

### Estados de una receta

- **Activa** (`flag_estado = '1'`): se puede usar en programaciones y OTs
- **Inactiva** (`flag_estado = '0'`): no se modifica ni usa
- No se puede desactivar si tiene programaciones activas asociadas
- Se puede versionar: crear copia con versión+1, la anterior queda inactiva

### ¿Para qué sirve?

Para **estandarizar** la producción. Sin recetas, cada cocinero prepara el plato como le parece, con ingredientes y cantidades distintas. Con recetas:
- El costo estimado del plato se conoce antes de producir
- Se sabe qué insumos comprar (derivado de la programación × receta)
- La calidad es consistente (todos siguen los mismos pasos)
- Se puede calcular la merma esperada vs real

---

## 3. La Labor — El Bloque de Construcción

### ¿Qué es?

Una **labor** es una **operación productiva atómica y reutilizable**. No pertenece a una receta específica — es un catálogo maestro de operaciones.

### Ejemplos de labores

| Código | Nombre | Insumos | Produce |
|--------|--------|---------|---------|
| `CORTE` | Corte fino | Verduras, carnes | Insumos picados |
| `COCCION` | Cocción en olla | Insumos picados, aceite, sal | Preparación cocida |
| `HORNEADO` | Horneado | Masa cruda | Pan horneado |
| `FRITURA` | Fritura profunda | Papas crudas, aceite | Papas fritas |
| `EMPLATADO` | Emplatado | Plato, guarnición | Plato servido |

### ¿Cómo se usa?

Una receta define una **secuencia ordenada de labores** (`receta_labor`). Cuando se ejecuta la receta, se ejecutan las labores en orden. La labor como catálogo referencia artículos del almacén **sin cantidad** (es un catálogo reusable). Las cantidades se definen en `receta_labor_consumible` (a nivel receta) y se ejecutan en `parte_produccion_insumo` (a nivel real).

---

## 4. El Ejecutor — Quién Hace el Trabajo

### ¿Qué es?

Un **ejecutor** es la **persona, equipo o rol** que ejecuta una labor. Se asigna a labores mediante `labor_ejecutor` con datos de costeo: cuánto cuesta esa persona/equipo por unidad de tiempo, moneda, factor de conversión.

### Estructura de `labor_ejecutor`

| Campo | Descripción |
|-------|-------------|
| `ejecutor_id` | FK al maestro de ejecutores |
| `unidad_medida_alt_id` | Unidad alternativa para medir (ej: horas, kg procesados) |
| `moneda_id` | Moneda del costo (SOL, USD) |
| `factor_conversion` | Factor de conversión de unidad |
| `nro_personas` | Cuántas personas componen este equipo |
| `ratio_estimado` | Rendimiento estimado |
| `costo_unitario` | Cuánto cuesta por unidad |
| `flag_costo_fijo` | Si el costo es fijo (no varía con volumen) |

### ¿Dónde se usa?

- En la **labor** (`labor_ejecutor`): define qué ejecutores pueden hacer esa labor y a qué costo
- En la **operación de OT** (`operacion.ejecutor_id`): define qué ejecutor específico hizo el trabajo

**Ejemplo:** La labor "Corte fino" puede ser ejecutada por el equipo "Cocina A" (3 personas, S/25.50/hora). Cuando se crea una OT con una operación de corte, se asigna "Cocina A" como ejecutor.

---

## 5. OT Tipo y OT Administración — Organización

### OT Tipo

Es un **clasificador** de órdenes de trabajo. Ejemplos: `PRODUCCION`, `MANTENIMIENTO`, `LIMPIEZA`, `REPARACION`. Determina **qué tipo de trabajo** se va a hacer.

### OT Administración

Define **quién es responsable** del trabajo. Es un área organizativa. Ejemplos: "Cocina Central", "Pastelería", "Panadería". A cada administración se le asignan **usuarios responsables**.

Cada administración tiene un `tipo_costo` (ej: `DIRECTO`, `INDIRECTO`) que se usa después en el costeo.

---

## 6. La Orden de Trabajo — La Ejecución

### ¿Qué es?

Una **orden de trabajo (OT)** es la **autorización formal para producir**. Es el vínculo entre la **planificación** (lo que se quiere hacer) y la **ejecución** (lo que realmente se hace).

### ¿Qué contiene?

- **Código único** auto-generado: `OT-2026-0001`
- **Tipo**: qué clase de trabajo (PRODUCCION, etc.)
- **Administración**: quién es responsable + usuarios asignados
- **Ejecutor**: quién ejecuta el trabajo
- **Sucursal**: dónde se produce
- **Fechas**: inicio y fin planificados
- **Estado**: Activa (`'1'`) → Cerrada (`'2'`) / Anulada (`'0'`)

### Estados y transiciones

```
Creada (flag=1) → Cerrada (flag=2)  [trabajo completado]
Creada (flag=1) → Anulada (flag=0)  [trabajo cancelado]
```

- Una OT activa se puede modificar
- Una OT cerrada o anulada **no se modifica ni reactiva**
- Para anular se requiere que **no tenga vales de almacén ni OCs vinculadas**

### Diferencia entre OT y Operación

Es importante: una OT puede tener **múltiples operaciones**. Por ejemplo:
- OT "Producir 100 Lomo Saltados"
  - Operación "Día 1": Corte de insumos
  - Operación "Día 2": Cocción y emplatado
  - Operación "Día 3": Control de calidad

Cada operación tiene su **detalle de materiales** requeridos: qué artículos, en qué cantidad, para qué labor.

---

## 7. Programación de Producción — La Recurrencia

### ¿Qué es?

Mientras una OT es un trabajo puntual, la **programación** define **producción recurrente**: todos los días/semanas/meses se produce la misma cantidad del mismo plato.

### ¿Qué contiene?

- **Receta**: qué producir
- **Frecuencia**: DIARIA, SEMANAL, QUINCENAL, MENSUAL, ANUAL
- **Cantidad**: cuánto por período (ej: 50 porciones/día)
- **Turno**: MAÑANA, TARDE, NOCHE
- **Sucursal**: dónde
- **OT asociada**: opcional (la programación puede generar OTs automáticas)

### Flujo típico

1. Se define una programación: "Producir 50 Lomo Saltados diario en Cocina Central"
2. Diariamente se genera/consume una OT vinculada
3. Al final del día se registra el parte de producción (cuánto se consumió y produjo realmente)

---

## 8. Las Operaciones — El Detalle de la Ejecución

### ¿Qué es?

Una **operación** es un **bloque de trabajo dentro de una OT**. Sirve para descomponer la ejecución en partes manejables (ej: por día, por turno, por estación de cocina).

### ¿Qué contiene?

- **OT padre**: a qué orden pertenece
- **Labor**: qué labor se ejecuta
- **Ejecutor**: quién lo ejecuta
- **Fechas**: inicio estimado, inicio real, fin real
- **Planificación**: días para inicio, duración proyectada, días de holgura
- **Costos**: cantidad proyectada, cantidad real, costo unitario, costo proyectado
- **Detalles** (`operaciones_det`): lista de materiales requeridos con artículo y cantidad

### El detalle de materiales (`operaciones_det`)

Esta tabla es importante porque **proyecta qué insumos se van a necesitar**. Sólo contiene `articulo_id` + `cantidad_requerida` — los campos `labor_id` y `unidad_medida_id` **se eliminaron del DDL** porque pasaron a nivel de la operación (la operación ya tiene su propia labor y UM).

```sql
-- Para producir 100 Lomo Saltados, el detalle podría ser:
-- operación "Día 1" → detalle: artículo "cebolla", cantidad 5kg
-- operación "Día 1" → detalle: artículo "tomate", cantidad 3kg
```

Estos detalles son los que eventualmente pueden generar **órdenes de compra**: si no hay suficiente stock, compras emite una OC cubriendo el faltante.

### Relación con compras y almacén

- `compras.orden_compra_det.operaciones_det_id` → vincula la compra al requerimiento
- `almacen.vale_mov_det.operaciones_det_id` → vincula el consumo real al requerimiento

---

## 9. Partes de Producción — El Registro Diario

### ¿Qué es?

El **parte de producción** es el **registro de lo que realmente pasó** en un día/turno de producción. Es la contraparte real de lo planificado.

### ¿Qué contiene?

- **Cabecera**: OT asociada, fecha, turnoId (opcional), flag_estado (activar/desactivar)
- **Insumos consumidos** (`parte_produccion_insumo`): qué artículos se usaron, en qué unidad de medida, cuánto, y su vale de movimiento (descuento de almacén)
- **Productos obtenidos** (`parte_produccion_producido`): qué se produjo, cuánto

### ¿Por qué es importante?

Porque **compara lo planificado vs lo real**:

| Concepto | Planificado (según receta) | Real (parte) | Diferencia |
|----------|---------------------------|--------------|------------|
| Insumo "cebolla" | 5 kg diarios | 5.5 kg | +0.5 kg (merma) |
| Producido "Lomo Saltado" | 50 porciones | 48 porciones | -2 (error, desperdicio) |

Estas diferencias se ajustan día a día hasta completar la OT. Al final sabés exactamente cuánto insumo se necesitó para cada producto.

### Integración con almacén

Cuando se registra un parte, la `cantidad_consumida` de cada insumo debería generar un **vale de movimiento** en `ms-almacen` que descuente automáticamente del stock. **Esto está planificado pero no implementado aún.**

---

## 10. Control de Calidad — La Inspección

### ¿Qué es?

Registra una **inspección de calidad** sobre el producto obtenido. Por cada OT se pueden hacer múltiples controles.

### ¿Qué contiene?

- **OT asociada** (opcional)
- **Inspector**: quién revisó
- **Fecha**: cuándo
- **Resultado**: `APROBADO` | `RECHAZADO` | `OBSERVADO`
- **Observaciones**: notas sobre la inspección

### ¿Cómo se usa?

No tiene estado funcional (`flag_estado`). El resultado mismo funciona como estado. Es un registro simple de evento: "se inspeccionó y salió aprobado/rechazado".

---

## 11. Costeo de Producción — El Cierre Contable

### ¿Qué es?

Un **proceso batch mensual** que calcula cuánto costó realmente producir. NO es un CRUD normal — es un **cálculo automático** que se ejecuta al final del período.

### ¿Cómo funciona?

1. Se selecciona **año + mes** (ej: mayo 2026)
2. El sistema busca OTs con partes de producción en ese período
3. Por cada OT calcula:

   - `costo_materia_prima` = suma de (cantidad_consumida × costo_unitario del artículo)
   - `costo_mano_obra` = prorrateado desde configuración
   - `costo_indirecto` = prorrateado desde configuración
   - `costo_total` = materia_prima + mano_obra + indirecto
   - `rendimiento_real` = suma de cantidad producida
   - `costo_unitario` = costo_total / rendimiento_real
   - `porcentaje_merma_real` = comparación insumos vs producidos

4. **Idempotente**: si se re-ejecuta el mismo período, actualiza en lugar de duplicar

5. **Integración con almacén (post-proceso):** el costeo mensual **no** genera asientos en contabilidad. Tras el batch, **ms-almacen** actualiza el costo unitario de **todos los ingresos de producción del mes** de cada artículo afectado. Luego, **ms-almacen** emite los eventos contables estándar de movimiento (`movimiento.confirmado`) que consume **ms-contabilidad**.

### ¿Por qué es importante?

Porque te dice **cuánto costó realmente** producir cada plato vs el costo estimado de la receta. Si la receta dice que Lomo Saltado cuesta S/18.00 pero el costeo real da S/22.00, tenés un problema de precios o de eficiencia.

---

## 12. Documentación Técnica — Las Fichas

### ¿Qué es?

Un repositorio de **documentos técnicos asociados a artículos**: fichas técnicas, fichas de seguridad, especificaciones, certificados de calidad. No es producción en sí, pero es información necesaria para producir bien.

### ¿Qué contiene?

- **Artículo asociado**: a qué producto pertenece
- **Tipo de documento** (`core.doc_tipo`): FICHA_TECNICA, FICHA_SEGURIDAD, ESPECIFICACION, etc.
- **Nombre**: identificador del documento
- **URL o blob**: enlace al archivo externo o contenido binario almacenado (BYTEA, indicado con `tieneDocumentoBlob`)
- **Características**: lista de propiedades con valor y unidad de medida (ej: "Peso neto: 250g")

---

## 13. El Flujo Completo — Cómo Encaja Todo

### Flujo Restaurante (atención al público)

El más simple. Se vende un plato en caja/comanda → el sistema sabe qué receta corresponde → descuenta insumos del almacén según la receta. No se generan OTs ni programaciones porque la demanda es inmediata e impredecible.

```
Comanda: "1 Lomo Saltado"
  → receta_id: 5
  → descuenta del almacén: 200g lomo, 50g cebolla, 30g tomate...
  → factura en FS_FACTURA_SIMPL
```

### Flujo Entidad Productiva (panadería, fábrica de alimentos)

Acá hay planificación. Se sabe que mañana se necesitan 100 panes, entonces se programa y se ejecuta.

```
1. [DEFINICIÓN]
   Receta: "Pan francés" → Labor "Amasar" (insumos: harina, agua, sal, levadura)
                           → Labor "Hornear" (insumos: masa cruda)
                           → Ficha técnica: 200 cal, sin alérgenos
   
2. [PLANIFICACIÓN]
   Programación Producción: "Producir 100 panes diario, turno mañana"
   
3. [ORDENAR]
   OT-2026-0001: tipo=PRODUCCION, admin=Cocina Central, fecha=01/06
   
4. [EJECUTAR]
   Operación "Día 1":
     - detalle: labor "Amasar", artículos harina×50kg, agua×20L...
   Parte Producción "Día 1":
     - insumos reales: harina×48kg (menos de lo planificado)
     - producidos reales: pan×98 (2 perdidos)
   
5. [INSPECCIONAR]
   Control Calidad OT-2026-0001: APROBADO (pan cumple especificaciones)
   
6. [COSTEAR]
   Costeo Mayo: OT-2026-0001 → costo_total = S/120.50 → costo_unitario = S/1.23
   Comparado con costo estimado de receta: S/1.15 → hay una desviación de S/0.08 por pan
```

---

## 14. Resumen Visual de Responsabilidades

```
RECETA (el qué + el cómo)
├── Artículo producido         → core.articulo
├── Labores (secuencia pasos)  → receta_labor → labor
├── Ingredientes directos      → receta_labor_consumible (con cantidad)
├── Ficha técnica              → ficha_tecnica
└── Foto embebida              → ficha_tecnica.foto_blob (BYTEA, booleano en JSON)

LABOR (el bloque reusable)
├── Insumos que consume        → labor_insumo → core.articulo (sin cantidad, catálogo)
├── Artículos que produce      → labor_produccion → core.articulo
└── Ejecutores (quién + costo) → labor_ejecutor → ejecutor

EJECUTOR (quién hace el trabajo)
├── Costo por unidad, moneda, N° personas
├── Flag interno/externo, centro de costo contable
└── Asignado a labores vía labor_ejecutor (costo, ratio, moneda)

PROGRAMACIÓN (la recurrencia)
└── Receta × frecuencia × cantidad × turno → programacion_produccion

OT (la orden)
├── Tipo                       → ot_tipo
├── Administración + usuarios  → ot_administracion + ot_admin_uder
├── Fechas y sucursal
├── Operaciones (sub-división con planificación y costos)
│     ├── nro_operación, labor, ejecutor
│     ├── Fechas estimadas/real, duración, holgura
│     ├── Cantidades proyectada/real, costos unitario/proyectado
│     └── Detalle materiales → operaciones_det (solo articulo + cantidad)
└── Partes de producción (diarios)
      ├── Insumos reales con UM → parte_produccion_insumo → almacen.vale_mov
      └── Producidos reales     → parte_produccion_producido

CIERRE
├── Control calidad           → control_calidad
└── Costeo mensual            → costeo_produccion (batch, idempotente)
```

---

## 15. Conceptos Clave para No Perderse

| Concepto | Explicación |
|----------|-------------|
| **Receta ≠ Lista de ingredientes** | La receta define pasos (labores), y las labores a su vez tienen insumos. Pero la receta también tiene sus propios ingredientes directos (`receta_labor_consumible`) con cantidades. |
| **Labor ≠ Paso de receta** | La labor es un catálogo reusable; el paso de receta es "usar la labor X en la secuencia Y". |
| **Labor_insumo ≠ Receta_labor_consumible** | `labor_insumo` es catálogo (sin cantidad, reusable); `receta_labor_consumible` es específico (con cantidad, por receta). |
| **OT ≠ Parte** | La OT es la orden general; el parte es el reporte diario dentro de esa OT. |
| **Costeo ≠ CRUD** | El costeo no se ingresa a mano — es un cálculo batch automático mensual. |
| **Ejecutor ≠ Usuario del sistema** | El ejecutor es un rol/equipo de producción con datos de costeo, no un usuario de login. |
| **Versiones** | Una receta puede tener múltiples versiones. Cada versión es un documento completo e independiente. |
| **Baja lógica** | Casi todas las tablas usan `flag_estado = '0'` para "eliminar". Nunca se borran registros físicos (excepto tablas pivote). |
| **Blobs en JSON** | Las fotos de ficha técnica y documentos adjuntos se almacenan como BYTEA en BD. En JSON viaja un booleano `tieneFotoBlob`/`tieneDocumentoBlob` indicando si existen; el binario se sirve por endpoint aparte. |
