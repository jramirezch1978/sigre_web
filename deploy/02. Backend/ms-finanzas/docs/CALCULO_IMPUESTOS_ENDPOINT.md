# Endpoint de Cálculo de Impuestos — ms-finanzas

> **Propósito**: Endpoint puro (sin BD, sin efectos secundarios) que el frontend usa para
> obtener el desglose de impuestos de los ítems de una CXP o CXC **antes** de registrar
> el documento. El backend recibe datos, calcula, devuelve resultados.
>
> **NO persiste nada.** La persistencia de los impuestos ya la manejan los CRUD existentes
> (`CntasPagarService`, `CuentaCobrarService`) usando la tabla N:M `cntas_pagar_det_imp` / `cntas_cobrar_det_imp`.
>
> **No tiene modalidades de venta** (salón, rápido, delivery, reserva). Es un cálculo
> para registro contable (CXP/CXC), no para POS.

---

## Tabla de Contenidos

1. [Endpoint](#1-endpoint)
2. [Determinación del País](#2-determinación-del-país)
3. [Modificaciones a core.tipos_impuesto](#3-modificaciones-a-coretipos_impuesto)
4. [Request — CalcularImpuestosRequest](#4-request--calcularimpuestosrequest)
5. [Response — CalcularImpuestosResponse](#5-response--calcularimpuestosresponse)
6. [Motor de Cálculo](#6-motor-de-cálculo)
7. [Códigos de Error](#7-códigos-de-error)
8. [Guía de Integración para Frontend](#8-guía-de-integración-para-frontend)

---

## 1. Endpoint

```
POST /api/finanzas/calcular-impuestos
```

- **Content-Type**: `application/json`
- **Autenticación**: Requiere token JWT (igual que el resto de endpoints).
  De él se extrae la `sucursalId` para determinar el país.
- **No persiste nada**: 100% stateless, solo cálculos en memoria.
- **Idempotente**: Misma entrada → misma salida (no hay efectos secundarios).

---

## 2. Determinación del País

El país NO se envía en el request. El backend lo determina automáticamente a partir
de la sucursal del usuario logueado:

```
1. TenantContext.getSucursalId() → ID de la sucursal actual
2. GET /api/core/sucursales/{id} → SucursalResponse.paisId
3. GET /api/core/geografia/paises/{id} → PaisResponse.codigo ("PE", "CL", ...)
```

El endpoint reporta error si:
- La sucursal no existe o está inactiva
- La sucursal no tiene `paisId` asignado
- El país no está soportado para el cálculo de impuestos

> **Nota técnica**: El `CoreMaestrosClient` en ms-finanzas necesita un método que
> devuelva `SucursalResponse` con `paisId` (hoy `obtenerSucursalPorId()` devuelve
> `UsuarioResponse` incorrectamente). Se agregará el método correcto.

### Países soportados

| Código | País | Comportamiento |
|---|---|---|
| `"PE"` | Perú | Clasificación por código tributario (1000=IGV, 2000=ISC). Soporta detracción. |
| `"CL"` | Chile | Clasificación mixta. Rounding entero para Factura. |
| `"DEFAULT"` | Otros | Misma lógica que Perú (clasificación por código). |

---

## 3. Modificaciones a `core.tipos_impuesto`

Para que el motor de cálculo sepa **cómo** aplicar cada impuesto, se necesita agregar
el campo `tipo_calculo` a la tabla. Hoy solo tiene `tasa_impuesto` (un número) pero
no diferencia entre porcentaje, monto fijo, etc.

### 3.1 DDL

```sql
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'core' AND table_name = 'tipos_impuesto' AND column_name = 'tipo_calculo'
    ) THEN
        ALTER TABLE core.tipos_impuesto ADD COLUMN tipo_calculo INTEGER NOT NULL DEFAULT 1;
    END IF;
END $$;
```

> `DEFAULT 1` asegura que los registros existentes tomen `PORCENTAJE` automáticamente.
> El `IF NOT EXISTS` permite que el DDL sea idempotente (mismo patrón que el resto del proyecto).

### 3.2 Tipos de cálculo

| Tipo | Código | Fórmula | Ejemplo |
|---|---|---|---|
| `PORCENTAJE` | `1` | `importe = base × tasa / 100` | IGV 18%, ISC 13% |
| `MONTO_FIJO` | `2` | `importe = cantidad × tasa` | ICBPER (bolsa plástica S/0.10 × und) |
| `BASE_AFFECTING` | `3` | Modifica la base antes de IGV (Chile) | ILA 5% |

### 3.3 Seed — valores actualizados

```sql
UPDATE core.tipos_impuesto SET tipo_calculo = 1 WHERE tipo_impuesto IN ('IGV18','IGV10','IGV1A','IGVNT','IGVnT','IGVNC','IGVND','IGV2','ISC','RECON','IPERC','IRLC','IR4TA','IR5TA', ...);
UPDATE core.tipos_impuesto SET tipo_calculo = 2 WHERE tipo_impuesto IN ('ICBPER');
```

### 3.4 Entidad Java (`TiposImpuesto`)

```java
@Column(name = "tipo_calculo", nullable = false)
private Integer tipoCalculo = 1;
```

> El default en Java (`= 1`) es un safety net. Con `NOT NULL DEFAULT 1` en BD,
> ningún registro puede quedar null, incluso durante la migración.

### 3.5 Impacto en el endpoint

El campo `tipoCalculo` ya existe en `ImpuestoItem` del request (ver 4.3).
El frontend lo envía y el backend lo usa para elegir la fórmula de cálculo.

---

## 4. Request — `CalcularImpuestosRequest`

### 3.1 Campos de cabecera

| Campo | Tipo | Requerido | Default | Descripción |
|---|---|---|---|---|
| `descuentoGlobal` | `number` | No | `0` | Descuento sobre el total. Si `dsctoGlobalTipo="%"`, es un porcentaje (ej: `10` = 10%) |
| `dsctoGlobalConIgv` | `boolean` | No | `true` | Solo aplica si `dsctoGlobalTipo="$"`. `true` = el monto incluye impuestos, `false` = es base imponible |
| `dsctoGlobalTipo` | `string` | No | `"$"` | `"$"` = descuento como monto fijo, `"%"` = descuento como porcentaje del total |
| `items` | `array<ItemCalculo>` | Sí | — | Lista de ítems a calcular (ver 3.2) |

> El `pais` NO se envía. El backend lo deduce de la sucursal del token JWT.
>
> Cada ítem define si su `valorUnitario` es con o sin impuestos mediante el flag
> `valorConIgv`. No existe flag global — permite mezclar items con
> distinto tratamiento en un mismo documento.

### 3.2 `ItemCalculo` — por cada ítem

| Campo | Tipo | Requerido | Default | Descripción |
|---|---|---|---|---|
| `item` | `integer` | Sí | — | Número de ítem (para correlación en la respuesta) |
| `valorUnitario` | `number` | Sí | — | Precio/valor del producto |
| `cantidad` | `number` | Sí | — | Cantidad de unidades |
| `valorConIgv` | `boolean` | No | `true` | `true` = `valorUnitario` YA incluye impuestos (se extrae base). `false` = `valorUnitario` es base imponible (se añaden impuestos) |
| `descuento` | `number` | No | `0` | Descuento específico de este ítem. Si `dsctoTipo="%"`, es un porcentaje |
| `dsctoTipo` | `string` | No | `"$"` | `"$"` = descuento como monto fijo, `"%"` = descuento como porcentaje del total del ítem |
| `impuestos` | `array<ImpuestoItem>` | No | `[]` | Impuestos que aplican. Si está vacío → el ítem es **inafecto** (impuestos en cero) |
| `detraccion` | `DetraccionItem` | No | `null` | Configuración de detracción para este ítem (ver 3.4). Solo aplica si país = Perú. |

### 3.3 `ImpuestoItem` — impuesto aplicable a un ítem

| Campo | Tipo | Requerido | Default | Descripción |
|---|---|---|---|---|
| `tipoImpuestoId` | `number` | Sí | — | ID del impuesto en `core.tipos_impuesto`. La tasa, nombre y flag fiscalizado se resuelven automáticamente desde `GET /api/core/impuestos/{id}` |
| `tipoCalculo` | `integer` | No | `1` (LO ENVÍA EL FRONTEND) | `1` = porcentaje, `2` = monto fijo, `3` = base-affecting. Mientras la columna `tipo_calculo` no exista en BD, el frontend DEBE enviar este campo para impuestos que no sean PORCENTAJE (ej: ISC = 3) |

> **⚠️ Importante**: Mientras la columna `tipo_calculo` no esté agregada a `core.tipos_impuesto`,
> el frontend DEBE enviar `tipoCalculo` explícitamente en cada impuesto. Si no se envía,
> el backend asume `1` (PORCENTAJE), lo cual es INCORRECTO para ISC (debería ser `3`).
>
> Una vez que `tipo_calculo` exista en BD, el frontend puede dejar de enviarlo y el backend lo resolverá automáticamente.

El backend resuelve automáticamente al recibir el request:
- `tasa` → de `core.tipos_impuesto.tasa_impuesto`
- `esFiscalizado` → de `core.tipos_impuesto.flag_igv` (`'1'` = true)
- `nombre` → de `core.tipos_impuesto.desc_impuesto`
- `tipoCalculo` → del request si se envió, o de `core.tipos_impuesto.tipo_calculo` si existe, o `1` (PORCENTAJE)

La resolución se hace una sola vez por tipo de impuesto único (con caché), no hay N+1 por ítem.

### 3.4 `DetraccionItem` — detracción por ítem (solo Perú)

| Campo | Tipo | Requerido | Descripción |
|---|---|---|---|
| `porcentaje` | `number` | Sí | Porcentaje de detracción (ej: `10.00` = 10%) |
| `montoMinimo` | `number` | Sí | Monto mínimo para que aplique detracción. Si el precio del ítem es menor, no aplica. |
| `codigoServicio` | `string` | No | Código de servicio/bien para detracción |

---

## 4. Response — `CalcularImpuestosResponse`

### 4.1 Estructura general

| Campo | Tipo | Descripción |
|---|---|---|
| `pais` | `string` | Código del país determinado por el backend (`"PE"`, `"CL"`, `"DEFAULT"`) |
| `items` | `array<ItemCalculoResponse>` | Resultado por cada ítem (ver 4.2) |
| `consolidado` | `ConsolidadoResponse` | Totales consolidados (ver 4.3) |
| `detraccion` | `DetraccionCalculada` | Detracción calculada (solo si aplica y país = Perú) (ver 4.4) |

### 4.2 `ItemCalculoResponse` — resultado por ítem

| Campo | Tipo | Descripción |
|---|---|---|
| `item` | `integer` | Número de ítem (correlación con request) |
| `baseImponible` | `number` | Base imponible del ítem (sin impuestos) |
| `montoTotal` | `number` | Monto total del ítem (con impuestos) |
| `esGravado` | `boolean` | `true` si el ítem es gravado |
| `esInafecto` | `boolean` | `true` si el ítem es inafecto |
| `impuestos` | `array<ImpuestoCalculado>` | Impuestos calculados para este ítem |
| `descuentos` | `array<ImpuestoCalculado>` | Descuentos por ítem (impuestos a restar, si aplica) |

### 4.3 `ConsolidadoResponse` — totales

| Campo | Tipo | Descripción |
|---|---|---|
| `impuestos` | `array<ImpuestoCalculado>` | Impuestos consolidados (sumados por tipo) |
| `subtotal` | `number` | Total sin impuestos |
| `totalIgv` | `number` | Suma de impuestos fiscalizados (IGV/IVA) |
| `totalConImpuestos` | `number` | Subtotal + total impuestos |
| `descuentoGlobalSinImpuestos` | `number` | Base del descuento global (sin impuestos). Si `dsctoGlobalConIgv=true`, se calcula proporcionalmente. Si es `false`, es el mismo `descuentoGlobal` |
| `descuentoGlobalConImpuestos` | `number` | Monto total del descuento global (incluye impuestos). Si `dsctoGlobalConIgv=false`, se calcula proporcionalmente. Si es `true`, es el mismo `descuentoGlobal` |

### 4.4 `DetraccionCalculada` — detracción (solo Perú)

| Campo | Tipo | Descripción |
|---|---|---|
| `aplica` | `boolean` | `true` si la detracción aplica |
| `porcentaje` | `number` | Porcentaje aplicado |
| `monto` | `number` | Monto de detracción calculado |
| `codigoServicio` | `string` | Código de servicio/bien |

### 4.5 `ImpuestoCalculado` — estructura común de impuesto

| Campo | Tipo | Descripción |
|---|---|---|
| `tipoImpuestoId` | `number` | ID del impuesto en `core.tipos_impuesto` |
| `nombre` | `string` | Nombre descriptivo |
| `tasa` | `number` | Tasa aplicada |
| `importe` | `number` | Monto calculado |
| `esFiscalizado` | `boolean` | `true` si es IGV/IVA |

---

## 5. Arquitectura del Motor de Cálculo

### 5.1 Capas

```
┌──────────────────────────────────────────────────────────┐
│                    CALCULOIMPuestosController            │  ← Capa HTTP
│  POST /api/finanzas/calcular-impuestos                   │    @Valid, @RequestBody
│  → ApiResponse<CalcularImpuestosResponse>                │    sin lógica de negocio
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│                 CalculoImpuestosServiceImpl               │  ← Capa de orquestación
│  ┌────────────────────────────────────────────────────┐  │    con Spring, Feign
│  │ 1. resolverPais()     → Feign → ms-core-maestros  │  │
│  │ 2. resolverImpuestos()→ Feign → ms-core-maestros  │  │
│  │ 3. Validar cortafuegos                             │  │
│  │ 4. Convertir % a $                                 │  │
│  │ 5. Llamar engine                                   │  │
│  │ 6. Consolidar                                      │  │
│  │ 7. Calcular detracción                             │  │
│  └────────────────────────────────────────────────────┘  │
└───────────────────────┬──────────────────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────────────────┐
│              ENGINE (service/impl/tax/)                   │  ← Capa pura
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐  │    sin Spring
│  │ Clasificador  │  │ Calculador   │  │ Calculador    │  │    sin BD
│  │ Impuestos     │→ │ Item         │  │ Descuento     │  │    sin Feign
│  └──────────────┘  └──────┬───────┘  └───────────────┘  │
│                           │                               │
│                           ▼                               │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │ Consolidador │← │ Calculador   │  │ Calculador    │  │
│  │ Impuestos    │  │ Item (N)     │  │ Detracción    │  │
│  └──────────────┘  └──────────────┘  └───────────────┘  │
└──────────────────────────────────────────────────────────┘
```

### 5.2 Flujo completo paso a paso

```
REQUEST (JSON)
  │
  ▼
┌─────────────────────────────────────────────────────────────┐
│ Controller: @Valid CalcularImpuestosRequest                  │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ Service: calcular(CalcularImpuestosRequest)                  │
│                                                              │
│  1. resolverPais()                                           │
│     TenantContext.getSucursalId() → 1L                       │
│     coreMaestrosClient.obtenerSucursalPorId(1L) → paisId=1  │
│     coreMaestrosClient.obtenerPaisPorId(1L) → codigo="PE"   │
│     → "PE"                                                   │
│                                                              │
│  2. resolverImpuestos(items)                                 │
│     Collect all unique tipoImpuestoId from all items         │
│     For each unique ID:                                      │
│       coreMaestrosClient.obtenerImpuestoPorId(id)            │
│       → tasa=18.00, flagIgv="1", desc="IGV", tipoCalculo=1  │
│     → Map<Long, ImpuestoItemRequest> (cache por ID único)   │
│                                                              │
│  3. Enrich items with resolved tax data                      │
│     For each tax in each item:                               │
│       tax.tasa = resolved.tasa                               │
│       tax.esFiscalizado = resolved.flagIgv == "1"            │
│       tax.nombre = resolved.descImpuesto                     │
│       tax.tipoCalculo ??= resolved.tipoCalculo ?? 1          │
│                                                              │
│  4. [CORTAPUEGO] validarUnicoFiscalizado()                   │
│     If 2+ different tipoImpuestoId with esFiscalizado=true   │
│       → 422 MULTIPLES_FISCALIZADOS                           │
│                                                              │
│  5. [CORTAPUEGO] validarEstructuraUniforme()                 │
│     If descuentoGlobal > 0:                                  │
│       All items with impuestos must have SAME set of IDs     │
│       → 422 ESTRUCTURA_IMPUESTOS_DIVERGENTE                  │
│                                                              │
│  6. Convert % discounts to amounts                           │
│     If item.dsctoTipo="%":                                   │
│       item.descuento = item.valorUnitario × item.cantidad    │
│                      × item.descuento / 100                  │
│                                                              │
│     If request.dsctoGlobalTipo="%":                          │
│       descuentoGlobal = totalConImpuestos                    │
│                       × descuentoGlobal / 100                │
│                                                              │
│  7. For each item → CalculadorItem.calcular(item, pais)      │
│     (see 5.4 for algorithm)                                  │
│                                                              │
│  8. Apply per-item discount (if any)                         │
│     → CalculadorDescuento.calcularDescuentoItem(...)         │
│                                                              │
│  9. ConsolidadorImpuestos.consolidar(itemsCalc, dscto, flag) │
│     → sum impuestos by tipoImpuestoId                        │
│     → calculate subtotal, totalIgv, totalConImpuestos        │
│     → calculate dsctoGlobalSin/CON impuestos (proportion)    │
│                                                              │
│ 10. CalculadorDetraccion.calcular(reqItems, itemsCalc, total)│
│     (Peru only)                                              │
│     → max % among items with montoItem >= montoMinimo        │
│     → monto = totalConImpuestos × maxPorcentaje / 100        │
│                                                              │
│ 11. Build CalcularImpuestosResponse                          │
│     → pais, items[], consolidado, detraccion                 │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
RESPONSE (JSON)
```

### 5.3 Diagrama de clases del Engine

```
┌───────────────────────────────────────────────────────────────────┐
│                    engine (pure POJOs)                             │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │                  ClasificadorImpuestos                    │    │
│  │  ┌──────────────────────────────────────────────────┐    │    │
│  │  │ + clasificar(impuestos, paisCodigo) → Clasificacion│    │    │
│  │  │                                                   │    │    │
│  │  │  Clasificacion {                                  │    │    │
│  │  │    tasaIgv: BigDecimal     (tipoCalc=1 + fiscaliz)│    │    │
│  │  │    tasaBaseAffecting: Bd  (tipoCalc=3)            │    │    │
│  │  │    tasaOtros: BigDecimal   (tipoCalc=1 + no fisc) │    │    │
│  │  │    igvList, baseAffectingList, otrosList,         │    │    │
│  │  │    montoFijoList: List<ImpuestoItemRequest>       │    │    │
│  │  │  }                                                │    │    │
│  │  └──────────────────────────────────────────────────┘    │    │
│  └──────────────────────────────────────────────────────────┘    │
│                               │                                  │
│                               ▼                                  │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │                    CalculadorItem                         │    │
│  │  + calcular(item, paisCodigo) → ItemCalculoResponse      │    │
│  │                                                           │    │
│  │  ┌─────────────────┐  ┌────────────────────────────┐     │    │
│  │  │ valorConIgv=true │  │ valorConIgv=false         │     │    │
│  │  │ (extract base)   │  │ (add taxes on base)       │     │    │
│  │  └────────┬────────┘  └───────────┬────────────────┘     │    │
│  │           ▼                       ▼                       │    │
│  │  base=precio/(1+∑)         IGV=(base×(1+ISC))×tasa      │    │
│  │  IGV=(base+ISC)×tasa       ISC=base×tasa                │    │
│  └──────────────────────────────────────────────────────────┘    │
│                               │                                  │
│                               ▼                                  │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │                CalculadorDescuento                        │    │
│  │  + calcularDescuentoItem(dscto, impOriginales,           │    │
│  │       impRequest, valorConIgv, cant, pais)               │    │
│  │                                                           │    │
│  │  Crea un "mini-ítem" con el monto del descuento y         │    │
│  │  llama a CalculadorItem.calcular() sobre él.              │    │
│  │  Devuelve los impuestos del mini-ítem como "descuentos".  │    │
│  └──────────────────────────────────────────────────────────┘    │
│                               │                                  │
│                               ▼                                  │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │                CalculadorDetraccion                       │    │
│  │  + calcular(requestItems, itemsCalc, totalConImpuestos)   │    │
│  │                                                           │    │
│  │  Por cada item con detraccion:                            │    │
│  │    Si montoItem (calculado) >= montoMinimo →              │    │
│  │      tomar el % máximo                                    │    │
│  │    monto = totalConImpuestos × max% / 100                 │    │
│  └──────────────────────────────────────────────────────────┘    │
│                               │                                  │
│                               ▼                                  │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │                ConsolidadorImpuestos                      │    │
│  │  + consolidar(items, descuentoGlobal, dsctoConIgv)       │    │
│  │                                                           │    │
│  │  Suma impuestos por tipoImpuestoId                        │    │
│  │  Calcula: subtotal, totalIgv, totalConImpuestos           │    │
│  │  Calcula dscto proporcional (sin/con impuestos)           │    │
│  └──────────────────────────────────────────────────────────┘    │
└───────────────────────────────────────────────────────────────────┘
```

### 5.4 Principios del Engine

- **Pureza**: Sin Spring, sin BD, sin Feign, sin efectos secundarios. Solo reciben datos y devuelven resultados.
- **BigDecimal**: scale=4 interno, scale=10 para cálculos intermedios (evitar pérdida de precisión), scale=0 para Chile.
- **RoundingMode**: `HALF_UP` en todos los casos.
- **Sin estado**: Todos los métodos son estáticos. No hay estado mutable entre llamadas.
- **Testabilidad**: 45 tests unitarios TDD que prueban cada clase de forma aislada.

### 5.5 Clasificación de impuestos

### 5.3 Clasificación de impuestos

```
Todos los países:
  IGV/IVA:        tipoCalculo = 1  AND  esFiscalizado = true
  OTROS:          tipoCalculo = 1  AND  esFiscalizado = false
  MONTO_FIJO:     tipoCalculo = 2  (ICBPER, no afecta base)
  BASE_AFFECTING: tipoCalculo = 3  (ISC/ILA, modifica base antes de IGV)
```

### 5.4 Cálculo por impuesto según tipo

Cada impuesto se calcula según su `tipoCalculo`:

```
tipoCalculo = 1 (PORCENTAJE):
  importe = base × (tasa / 100)
  (IGV, ISC, etc.)

tipoCalculo = 2 (MONTO_FIJO):
  importe = cantidad × tasa
  (ICBPER — bolsa plástica. No afecta base imponible ni IGV)

tipoCalculo = 3 (BASE_AFFECTING):
  importe = base × (tasa / 100)
  Pero modifica la base antes de calcular IGV
  (solo Chile Factura)
```

### 5.5 Cálculo por ítem

#### Árbol de decisión

```
impuestos[] vacío o null?
  → Ítem inafecto: impuestos en cero, base imponible = precioTotal
  → No se calculan impuestos

impuestos[] tiene elementos?
  → ítem gravado: calcular según valorConIgv
```

#### valorConIgv = true → extraer base

El `valorUnitario` **incluye** los impuestos.
Hay que extraer la base imponible y separar cada impuesto.

```
precioTotal = valorUnitario × cantidad

Clasificar impuestos del ítem → tasaIGV, tasaISC, tasaOtros

Base con ISC = precioTotal / (1 + (tasaIGV + tasaOtros) / 100)
Base sin ISC = Base con ISC / (1 + tasaISC / 100)

Cálculo:
  ISC:       importe = Base sin ISC × (tasaISC / 100)
  IGV/Otros: importe = Base con ISC × (tasa / 100)
```

**Nota**: El ISC se calcula sobre la base pura. El IGV se calcula sobre (base + ISC).

#### valorConIgv = false → calcular encima

El `valorUnitario` es la **base imponible**.
Se calculan los impuestos sobre él.

```
precioTotal = valorUnitario × cantidad

Clasificar impuestos del ítem → tasaIGV, tasaISC, tasaOtros

Base con ISC = precioTotal × (1 + tasaISC / 100)
Total con impuestos = Base con ISC × (1 + (tasaIGV + tasaOtros) / 100)

Cálculo:
  ISC:       importe = precioTotal × (tasaISC / 100)
  IGV/Otros: importe = Base con ISC × (tasa / 100)
```

#### Chile Factura — Rounding entero

Para Chile en Factura, los base-affecting (`tipoCalculo=3`) se calculan primero
y modifican la base del IGV. Todo se redondea con `Math.round(valor)`.

```
Ejemplo: Precio 1000, IVA 19%, ILA(base-affecting) 5%

Base sin ILA = 1000 / 1.05 = 952.38
Base sin IVA = round(952.38 / 1.19, 0) = 800

ILA: round(800 × 0.05, 0) = 40
IVA: round(952.38 × 0.19, 0) = 181
```

**Nota**: Los impuestos `MONTO_FIJO` (ICBPER) no entran en la base imponible
ni afectan el cálculo del IGV. Se suman al total como cargo adicional.

### 5.6 Descuento por ítem

El descuento por ítem se calcula como un "mini-ítem": se aplica la misma fórmula
sobre el monto del descuento, usando el mismo `valorConIgv` del ítem.

```
Si valorConIgv = false:
  Se calculan impuestos ENCIMA del descuento

Si valorConIgv = true:
  Se EXTRAEN impuestos del descuento

Los descuentos se consolidan y se RESTAN de los impuestos del ítem.
Si un impuesto queda negativo → se fija en 0.
```

### 5.7 Descuento global

El `descuentoGlobal` puede ser con o sin impuestos, según el flag `dsctoGlobalConIgv`.

| Flag | `descuentoGlobal` es | `descuentoGlobalSinImpuestos` | `descuentoGlobalConImpuestos` |
|---|---|---|---|
| `true` (default) | Monto total (incluye IGV, ISC, etc.) | Se extrae la base proporcionalmente | Es el mismo `descuentoGlobal` |
| `false` | Base imponible (sin impuestos) | Es el mismo `descuentoGlobal` | Se calcula el total proporcionalmente |

La proporción se calcula como: `proporcion = subtotal / totalConImpuestos`

```
Si dsctoGlobalConIgv = true:
  conImpuestos = descuentoGlobal
  sinImpuestos = descuentoGlobal × proporcion

Si dsctoGlobalConIgv = false:
  sinImpuestos = descuentoGlobal
  conImpuestos = descuentoGlobal / proporcion
```

> **⚠️ Limitación**: El cálculo actual es **informativo** — devuelve los valores agregados
> del descuento (`sinImpuestos` y `conImpuestos`) sin redistribuir el descuento a cada
> tipo de impuesto individual. Si los items tienen distintas estructuras de impuestos,
> el prorrateo proporcional no es fiscalmente exacto para cada tipo.
>
> Para una redistribución correcta, todos los items deberían compartir la misma
> estructura de impuestos. Esto es una mejora futura si se requiere.

### 5.8 Detracción (solo Perú)

```
Reglas:
  - Solo aplica si al menos un ítem tiene detraccion configurada
  - Cada ítem requiere: porcentaje > 0, montoMinimo > 0
  - Solo aplica si precioItem >= montoMinimo

Cálculo:
  1. De todos los ítems aplicables, tomar el porcentaje MÁXIMO
  2. Monto detracción = totalVenta × (porcentajeMáximo / 100)
  3. Código de servicio:
     a. Del ítem con el porcentaje máximo que tenga código
     b. Si no, de cualquier ítem que tenga código
```

### 5.9 Consolidación

```
1. Sumar montos de cada tipo de impuesto (agrupado por tipoImpuestoId)
2. subtotal = suma de bases imponibles de todos los items
3. totalIgv = suma de montos donde esFiscalizado = true
4. totalConImpuestos = subtotal + suma de todos los impuestos
```

---

## 6. Códigos de Error

| HTTP | Código | Descripción |
|---|---|---|---|
| 400 | `VALIDATION_ERROR` | Error de validación de campos requeridos |
| 400 | `VALIDATION_ERROR` | No se enviaron ítems para calcular |
| 404 | `IMPUESTO_NO_ENCONTRADO` | El `tipoImpuestoId` enviado no existe en `core.tipos_impuesto` |
| 400 | `SUCURSAL_SIN_PAIS` | La sucursal no tiene un país asignado |
| 400 | `SUCURSAL_NO_ENCONTRADA` | No se pudo determinar la sucursal del usuario |
| 422 | `MULTIPLES_FISCALIZADOS` | El documento tiene más de un impuesto fiscalizado (ej: IGV 18% + IGV 10.5%) |
| 422 | `ERROR_EN_CALCULO` | Error interno durante el cálculo (no debería ocurrir con datos válidos) |
| 503 | `ERROR_COMUNICACION_CORE` | Error al consultar datos de sucursal/país/impuesto en ms-core-maestros |

---

## 7. Guía de Integración para Frontend

### 7.1 Flujo típico

```
1. Usuario completa datos del documento en el formulario
   (proveedor, tipo doc, serie, número, items con precios)
2. Usuario selecciona los impuestos que aplican a cada ítem
3. Frontend calcula flags básicos (preciosSinImpuestos, productosInafectos)
   y arma CalcularImpuestosRequest
4. Frontend llama a POST /api/finanzas/calcular-impuestos
5. Backend devuelve el desglose completo (base por ítem, impuestos, consolidado)
6. Frontend muestra al usuario la previsualización
7. Usuario confirma → Frontend arma CntasPagarRequest con los importes
   ya calculados en el campo impuestos de cada detalle
8. Frontend llama a POST /api/finanzas/cuentas-pagar (CRUD existente)
```

### 7.2 Reglas para armar el request

Cada ítem indica si su `valorUnitario` es con o sin impuestos:

| Situación | `valorConIgv` |
|---|---|
| El valor del producto YA incluye IGV (ej: factura proveedor) | `true` (default) |
| El valor es base imponible (se le añade IGV después) | `false` |

**Inafectos**: si un ítem no paga impuestos, se envía con `impuestos: []`.
El backend lo trata automáticamente como inafecto y su `valorUnitario` se toma como base imponible.

### 7.3 Mapeo de la respuesta al DTO de persistencia

Los campos `impuestos` del response usan `tipoImpuestoId` e `importe`.
Eso se mapea directamente a `DetImpuestoRequest` del `CntasPagarDetRequest`:

```json
{
  "item": 1,
  "conceptoFinancieroId": 5,
  "descripcion": "Servicio de consultoría",
  "cantidad": 1,
  "precioUnitario": 1180.00,
  "monto": 1180.00,
  "centrosCostoId": 3,
  "impuestos": [
    {
      "tiposImpuestoId": 1,
      "importe": 180.00
    }
  ],
  "creditoFiscalId": 1,
  "fechaMov": "2026-06-10",
  "tipoMov": "COMPRA"
}
```

El `monto` puede ser el `montoTotal` del response (si va con impuestos)
o la `baseImponible` (si va sin impuestos), según cómo lo maneje el formulario.

### 7.4 Recomendaciones

- **Llamar al endpoint siempre antes de registrar**: El backend es la fuente de verdad
  para la lógica tributaria. No dupliques el cálculo en el frontend.
- **No modificar los importe devueltos**: Son los montos fiscalmente correctos.
- **Para detracción**: Si un producto está sujeto a detracción, incluir el objeto
  `detraccion` en el ítem. El endpoint decide si aplica según el monto mínimo.

---

## 8. Ejemplos

### 8.1 Perú — Precios con impuestos

**Request** — 2 ítems gravados con IGV 18%, valores incluyen impuestos:

```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 118.00,
      "cantidad": 2,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 2,
      "valorUnitario": 59.00,
      "cantidad": 1,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    }
  ]
}
```

**Response**:

```json
{
  "pais": "PE",
  "items": [
    {
      "item": 1,
      "baseImponible": 200.00,
      "montoTotal": 236.00,
      "esGravado": true,
      "esInafecto": false,
      "impuestos": [
        {
          "tipoImpuestoId": 21,
          "nombre": "IGV",
          "tasa": 18.00,
          "importe": 36.00,
          "esFiscalizado": true
        }
      ]
    },
    {
      "item": 2,
      "baseImponible": 50.00,
      "montoTotal": 59.00,
      "esGravado": true,
      "esInafecto": false,
      "impuestos": [
        {
          "tipoImpuestoId": 21,
          "nombre": "IGV",
          "tasa": 18.00,
          "importe": 9.00,
          "esFiscalizado": true
        }
      ]
    }
  ],
  "consolidado": {
    "impuestos": [
      {
        "tipoImpuestoId": 21,
        "nombre": "IGV",
        "tasa": 18.00,
        "importe": 45.00,
        "esFiscalizado": true
      }
    ],
    "subtotal": 250.00,
    "totalIgv": 45.00,
    "totalConImpuestos": 295.00,
    "descuentoGlobalSinImpuestos": 0,
    "descuentoGlobalConImpuestos": 0
  }
}
```

Cálculo: El backend resuelve `tipoImpuestoId=21` → `tasa_impuesto=18.00`, `flag_igv='1'` (fiscalizado), `desc_impuesto="IMPTO.GENERAL VENTAS 18 %"`, tipoCalculo=1 (PORCENTAJE). Item 1 → `118 / 1.18 = 100` base × 2 = 200. IGV = `200 × 0.18 = 36`. Item 2 → `59 / 1.18 = 50` base. IGV = `50 × 0.18 = 9`.

### 8.2 Perú — Con IGV + ISC (base-affecting)

Usando `IGV18` (id=21, 18%, fiscalizado) e `ISC` (id=32, 13%, base-affecting).

**Request** — Un item con IGV 18% + ISC 13%, precio incluye impuestos:

```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 250.00,
      "cantidad": 2,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ]
    }
  ]
}
```

**Cálculo**:
- `precioTotal = 250 × 2 = 500`
- El backend resuelve: IGV18 → tasa=18%, fiscalizado=true, tipoCalculo=1. ISC → tasa=13%, fiscalizado=false, tipoCalculo=3 (BASE_AFFECTING)
- `sumPercent = 18` (solo IGV, ISC no entra porque es base-affecting)
- `baseConISC = 500 / (1 + 18/100) = 500 / 1.18 = 423.7288`
- `baseSinISC = 423.7288 / (1 + 13/100) = 423.7288 / 1.13 = 375.00`
- `IGV = 423.7288 × 18/100 = 76.2712`
- `ISC = 375.00 × 13/100 = 48.75`
- `baseImponible = 375.00`
- `montoTotal = 375 + 48.75 + 76.2712 = 500.00`

### 8.3 Perú — Con detracción

Usando `IGV18` (id=21) con detracción al 10%.

```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 1180.00,
      "cantidad": 1,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ],
      "detraccion": {
        "porcentaje": 10.00,
        "montoMinimo": 700.00,
        "codigoServicio": "001"
      }
    }
  ]
}
```

**Cálculo**: Detracción = 1180 × 10% = 118 (porque 1180 >= 700).

Response destacado:

```json
{
  "pais": "PE",
  "detraccion": {
    "aplica": true,
    "porcentaje": 10.00,
    "monto": 118.00,
    "codigoServicio": "001"
  }
}
```

### 8.4 Comprobante real — 3 items con IGV18, ISC, inafecto y detracción

Usando datos reales de `core.tipos_impuesto`:

| ID | código | tasa | flag_igv | tipo cálculo |
|---|---|---|---|---|
| 21 | IGV18 | 18.00 | 1 (fiscalizado) | 1 (PORCENTAJE) |
| 32 | ISC | 13.00 | 0 | 3 (BASE_AFFECTING) |
| — | inafecto | — | — | sin impuestos |

```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 500.00,
      "cantidad": 10,
      "valorConIgv": false,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ]
    },
    {
      "item": 2,
      "valorUnitario": 200.00,
      "cantidad": 5,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 3,
      "valorUnitario": 80.00,
      "cantidad": 3,
      "impuestos": []
    }
  ]
}
```

**Cálculo paso a paso**:

**Item 1** (10 und × 500 = 5000 base, precios sin impuestos):
- `base = 5000`
- `baseConISC = 5000 × 1.13 = 5650`
- `ISC = 5000 × 0.13 = 650`
- `IGV = 5650 × 0.18 = 1017`
- `montoTotal = 5000 + 650 + 1017 = 6667`

**Item 2** (5 und × 200 = 1000, precios con impuestos):
- `precioTotal = 1000`
- `base = 1000 / 1.18 = 847.4576`
- `IGV = 847.4576 × 0.18 = 152.5424`
- `montoTotal = 1000`

**Item 3** (3 und × 80 = 240, inafecto):
- `base = 240`, `montoTotal = 240`, sin impuestos

**Consolidado**:
- `subtotal = 5000 + 847.4576 + 240 = 6087.4576`
- `totalIgv = 1017 + 152.5424 = 1169.5424`
- `totalConImpuestos = 6087.4576 + 1169.5424 + 650 = 7907.00`

### 8.5 Monto fijo (ICBPER) + IGV

Usando `IGV18` (id=21) + un impuesto de tipo MONTO_FIJO (id=99, tasa=0.10, tipoCalculo=2).

> Nota: ICBPER no existe en el seed actual de `core.tipos_impuesto`. Es un impuesto
> de monto fijo por unidad (S/0.10 por bolsa plástica). Se incluye este ejemplo
> para cuando se agregue.

```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 118.00,
      "cantidad": 10,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 99, "tipoCalculo": 2 }
      ]
    }
  ]
}
```

**Cálculo**:
- `precioTotal = 118 × 10 = 1180`
- IGV18: tasa=18%, fiscalizado=true, tipoCalculo=1 → `base = 1180 / 1.18 = 1000`, `IGV = 180`
- ICBPER: tipoCalculo=2 (MONTO_FIJO) → `importe = 10 × 0.10 = 1` (no afecta base)
- `baseImponible = 1000`, `montoTotal = 1000 + 180 + 1 = 1181`

---

> **Historial del Documento**
>
> | Versión | Fecha | Cambios |
> |---|---|---|
> | 2.0 | 2026-06-10 | Ejemplos complejos con datos reales de core.tipos_impuesto. ISC como base-affecting. Ejercicios multi-item. |
> | 1.1 | 2026-06-10 | Correcciones: país se deduce del token, sin modalidad, sin campo `pais` en request, defaults para configs |
> | 1.0 | 2026-06-10 | Versión inicial |
