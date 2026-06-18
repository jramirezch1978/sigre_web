# Ejercicios de Prueba — Endpoint de Cálculo de Impuestos

> Endpoint: `POST /api/finanzas/calcular-impuestos`
>
> Usar con autenticación JWT (sucursal con país Perú, id de impuestos según `core.tipos_impuesto`).
>
> **Flags opcionales con default:**
> - `descuentoGlobal` → default `0`
> - `dsctoGlobalConIgv` → default `true` (solo aplica si `dsctoGlobalTipo="$"`)
> - `dsctoGlobalTipo` → default `"$"` (`"$"` = monto fijo, `"%"` = porcentaje del total)
> - `valorConIgv` por item → default `true`
> - `dsctoTipo` por item → default `"$"` (`"$"` = monto fijo, `"%"` = porcentaje del total del ítem)
> - `tipoCalculo` por impuesto → **OBLIGATORIO** mientras no exista en BD. ISC = `3`
>
> **Validaciones del backend:**
> - Un documento NO puede tener dos impuestos fiscalizados distintos (ej: IGV 18% + IGV 10.5%).
>   Si se intenta, responde HTTP 422 con código `MULTIPLES_FISCALIZADOS`.

---

## Impuestos para pruebas

| ID | Código | Descripción | Tasa | flag_igv | tipoCalculo (default) |
|---|---|---|---|---|---|
| 21 | IGV18 | IMPTO.GENERAL VENTAS 18 % | 18.00 | 1 (fiscalizado) | 1 (PORCENTAJE) |
| 42 | IGV1A | IMPTO. GENERAL VENTAS 10.5% | 10.50 | 1 (fiscalizado) | 1 (PORCENTAJE) |
| 32 | ISC | IMPUESTO SELECTIVO AL CONSUMO | 13.00 | 0 | 3 (BASE_AFFECTING) |
| 31 | 10ADS | 10% ADICIONAL DE SERVICIOS | 10.00 | 0 | 1 (PORCENTAJE) |

> **⚠️ `tipoCalculo` es OBLIGATORIO mientras no exista en BD.**  
> El backend asume `1` (PORCENTAJE) si no se envía, lo cual es INCORRECTO para ISC.
> Siempre enviar: `{ "tipoImpuestoId": 32, "tipoCalculo": 3 }`.
> Una vez que la columna `tipo_calculo` exista en `core.tipos_impuesto`, el frontend puede omitirlo.

---

## Ejercicio 1: Factura de construcción — 6 items, mixto con/sin IGV, cantidades reales

Materiales de construcción con IGV 18%, algunos items inafectos (ej: terreno), flete con ISC.

**Request:**
```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 45.50,
      "cantidad": 200,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 2,
      "valorUnitario": 120.00,
      "cantidad": 50,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ]
    },
    {
      "item": 3,
      "valorUnitario": 3200.00,
      "cantidad": 1,
      "impuestos": []
    },
    {
      "item": 4,
      "valorUnitario": 8.75,
      "cantidad": 500,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 5,
      "valorUnitario": 2500.00,
      "cantidad": 3,
      "valorConIgv": false,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 6,
      "valorUnitario": 980.00,
      "cantidad": 2,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ]
    }
  ]
}
```

**Cálculos esperados:**

| Item | Detalle | Base | IGV | ISC | Total |
|---|---|---|---|---|---|
| 1 | 200 × 45.50 = 9100 (con IGV) | 7711.86 | 1388.14 | — | 9100.00 |
| 2 | 50 × 120 = 6000 (con IGV) | 4491.98 | 917.36 | 590.66 | 6000.00 |
| 3 | Terreno (inafecto) | 3200.00 | — | — | 3200.00 |
| 4 | 500 × 8.75 = 4375 (con IGV) | 3707.63 | 667.37 | — | 4375.00 |
| 5 | 3 × 2500 = 7500 (base) | 7500.00 | 1350.00 | — | 8850.00 |
| 6 | 2 × 980 = 1960 (con IGV) | 1467.43 | 299.75 | 192.82 | 1960.00 |

**Item 1**: `9100 / 1.18 = 7711.86`, IGV = `7711.86 × 0.18 = 1388.14`
**Item 2**: `baseConISC = 6000 / 1.18 = 5084.75`, `baseSinISC = 5084.75 / 1.13 = 4491.98`, IGV = `5084.75 × 0.18 = 915.25`, ISC = `4491.98 × 0.13 = 584.07`. 
**Item 5**: base = 7500, ISC = no tiene, IGV = `7500 × 0.18 = 1350`, total = 8850.
**Item 6**: `baseConISC = 1960 / 1.18 = 1661.02`, `baseSinISC = 1661.02 / 1.13 = 1469.93`, IGV = `1661.02 × 0.18 = 298.98`, ISC = `1469.93 × 0.13 = 191.09`.
**Consolidado**: subtotal ≈ 28078.90, IGV ≈ 4619.10, ISC ≈ 775.16, total ≈ 33485.00

---

## Ejercicio 2: Factura de servicio técnico — 5 items con ISC + RECON + 10ADS + descuento por item

Servicios técnicos con recargos. IDs: IGV18 (21), ISC (32), RECON (31), 10ADS (31).

**Request:**
```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 3500.00,
      "cantidad": 1,
      "valorConIgv": false,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ]
    },
    {
      "item": 2,
      "valorUnitario": 890.00,
      "cantidad": 4,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 3,
      "valorUnitario": 250.00,
      "cantidad": 15,
      "descuento": 750.00,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 4,
      "valorUnitario": 1200.00,
      "cantidad": 2,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 5,
      "valorUnitario": 600.00,
      "cantidad": 1,
      "impuestos": []
    }
  ]
}
```

**Cálculos:**

**Item 1** (3500, base imponible):
- ISC = 3500 × 0.13 = 455
- baseConISC = 3500 × 1.13 = 3955
- IGV = 3955 × 0.18 = 711.90
- total = 3500 + 455 + 711.90 = 4666.90

**Item 2** (4 × 890 = 3560, con impuestos):
- Todos los impuestos son PORCENTAJE con esFiscalizado=false excepto IGV
- `sumPercentNoIGV = 3 + 10 = 13` (RECON + 10ADS)
- `sumPercentFiscalizado = 18` (IGV)
- `base = 3560 / (1 + 0.18 + 0.13) = 3560 / 1.31 = 2717.56`
- IGV = 2717.56 × 0.18 = 489.16
- RECON = 2717.56 × 0.03 = 81.53
- 10ADS = 2717.56 × 0.10 = 271.76
- total = 3560

**Item 3** (15 × 250 = 3750, con impuestos, descuento 750):
- Sin descuento: base = 3750 / 1.18 = 3177.97, IGV = 572.03
- Descuento: `descuento / 1.18 = 635.59`, IGV descuento = 114.42
- Con descuento: base = 3177.97 - 635.59 = 2542.38, IGV = 572.03 - 114.42 = 457.62
- total con descuento = 3750 - 750 = 3100

**Item 4** (2 × 1200 = 2400, con impuestos):
- `sumPercent = 18 + 3 = 21`
- base = 2400 / 1.21 = 1983.47
- IGV = 1983.47 × 0.18 = 357.02
- RECON = 1983.47 × 0.03 = 59.50
- total = 2400

**Item 5** (inafecto):
- base = 600, total = 600

**Consolidado aprox:**
- subtotal = 3500 + 2542.38 (item3 con dsct) + 2717.56 + 1983.47 + 600 = 11343.42
- totalIgv = 711.90 + 489.16 + 457.62 + 357.02 = 2015.70
- ISC = 455
- RECON = 81.53 + 59.50 = 142.03
- 10ADS = 271.76
- totalConImpuestos = 11343.42 + 2015.70 + 455 + 142.03 + 271.76 + 600 = 14826.90

---

## Ejercicio 3: Factura de importación — 4 items, cantidades grandes, ISC + detracción

Productos importados con ISC (base-affecting) y detracción al 10%.

**Request:**
```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 12.50,
      "cantidad": 10000,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ],
      "detraccion": {
        "porcentaje": 10.00,
        "montoMinimo": 700.00,
        "codigoServicio": "020"
      }
    },
    {
      "item": 2,
      "valorUnitario": 8.40,
      "cantidad": 5000,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 3,
      "valorUnitario": 350.00,
      "cantidad": 25,
      "valorConIgv": false,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 4,
      "valorUnitario": 5.00,
      "cantidad": 200,
      "impuestos": []
    }
  ]
}
```

**Cálculos:**

**Item 1** (10000 × 12.50 = 125000, con impuestos):
- `baseConISC = 125000 / 1.18 = 105932.20`
- `baseSinISC = 105932.20 / 1.13 = 93745.31`
- IGV = 105932.20 × 0.18 = 19067.80
- ISC = 93745.31 × 0.13 = 12186.89
- total = 125000

**Item 2** (5000 × 8.40 = 42000, con impuestos):
- base = 42000 / 1.18 = 35593.22
- IGV = 35593.22 × 0.18 = 6406.78
- total = 42000

**Item 3** (25 × 350 = 8750, base imponible):
- IGV = 8750 × 0.18 = 1575
- total = 8750 + 1575 = 10325

**Item 4** (200 × 5 = 1000, inafecto):
- base = 1000, total = 1000

**Detracción** (solo item 1 tiene, monto 125000 >= 700):
- porcentaje máximo = 10%
- monto detracción = (125000 + 42000 + 10325 + 1000) × 0.10 = 17832.50

---

## Ejercicio 4: Factura de supermercado — 8 items, mix completo

Productos de consumo masivo con diferentes tratamientos impositivos.

**Request:**
```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 5.60,
      "cantidad": 48,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 2,
      "valorUnitario": 12.00,
      "cantidad": 24,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ]
    },
    {
      "item": 3,
      "valorUnitario": 3.50,
      "cantidad": 100,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 4,
      "valorUnitario": 25.00,
      "cantidad": 31,
      "valorConIgv": false,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 5,
      "valorUnitario": 2.20,
      "cantidad": 200,
      "impuestos": []
    },
    {
      "item": 6,
      "valorUnitario": 150.00,
      "cantidad": 5,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 7,
      "valorUnitario": 85.00,
      "cantidad": 12,
      "descuento": 200.00,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 8,
      "valorUnitario": 0.50,
      "cantidad": 500,
      "impuestos": []
    }
  ]
}
```

**Cálculos:**

**Item 1** (48 × 5.60 = 268.80, con IGV):
- base = 268.80 / 1.18 = 227.80, IGV = 42.00, total = 268.80

**Item 2** (24 × 12 = 288, con IGV+ISC):
- baseConISC = 288 / 1.18 = 244.07, baseSinISC = 244.07 / 1.13 = 215.99
- IGV = 244.07 × 0.18 = 43.93, ISC = 215.99 × 0.13 = 28.08
- total = 288

**Item 3** (100 × 3.50 = 350, con IGV):
- base = 350 / 1.18 = 296.61, IGV = 53.39
- total = 350

**Item 4** (31 × 25 = 750, base, IGV 18%):
- IGV = 750 × 0.18 = 135
- total = 750 + 75 = 825

**Item 5** (200 × 2.20 = 440, inafecto):
- base = 440, total = 440

**Item 6** (5 × 150 = 750, con IGV+RECON):
- sumPercent = 18 + 3 = 21
- base = 750 / 1.21 = 619.83
- IGV = 619.83 × 0.18 = 111.57
- RECON = 619.83 × 0.03 = 18.59
- total = 750

**Item 7** (12 × 85 = 1020, con IGV, descuento 200):
- Base sin dsct = 1020 / 1.18 = 864.42, IGV sin dsct = 155.59
- Dsct: monto = 200, base dsct = 200 / 1.18 = 169.49, IGV dsct = 31.51
- Base final = 864.42 - 169.49 = 694.92, IGV final = 155.59 - 31.51 = 125.08
- total = 1020 - 200 = 820

**Item 8** (500 × 0.50 = 250, inafecto):
- base = 250, total = 250

**Consolidado aprox:**
- subtotal = 227.80 + 215.99 + 296.61 + 750 + 440 + 619.83 + 694.92 + 250 = 3495.15
- totalIgv = 42.00 + 43.93 + 53.39 + 75 + 111.57 + 125.08 = 449.97
- ISC = 28.08
- RECON = 18.59
- totalConImpuestos = 3495.15 + 449.97 + 28.08 + 18.59 = 3991.79

---

## Ejercicio 5: Factura de equipo pesado — 5 items, IGV 18% con descuento global fuerte

Maquinaria y accesorios con IGV 18%, ISC, descuento global fuerte y detracción.

**Request:**
```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 45000.00,
      "cantidad": 1,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ],
      "detraccion": {
        "porcentaje": 12.00,
        "montoMinimo": 1000.00,
        "codigoServicio": "022"
      }
    },
    {
      "item": 2,
      "valorUnitario": 12500.00,
      "cantidad": 2,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ]
    },
    {
      "item": 3,
      "valorUnitario": 2310.00,
      "cantidad": 5,
      "valorConIgv": false,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 4,
      "valorUnitario": 8750.00,
      "cantidad": 1,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 5,
      "valorUnitario": 15000.00,
      "cantidad": 1,
      "impuestos": []
    }
  ]
}
```

**Cálculos esperados:**

**Item 1** (45000 × 1 = 45000, con IGV 18%):
- base = 45000 / 1.18 = 38135.59
- IGV = 38135.59 × 0.18 = 6864.42
- total = 45000

**Item 2** (12500 × 2 = 25000, con IGV 18% + ISC):
- baseConISC = 25000 / 1.18 = 21186.44
- baseSinISC = 21186.44 / 1.13 = 18749.06
- IGV = 21186.44 × 0.18 = 3813.56
- ISC = 18749.06 × 0.13 = 2437.38
- total = 25000

**Item 3** (2310 × 5 = 11500, base, IGV 18%):
- IGV = 11500 × 0.18 = 2070
- total = 11500 + 2070 = 13570

**Item 4** (8750 × 1 = 8750, con IGV 18% + 10ADS):
- sumPercent = 18 + 10 = 28
- base = 8750 / 1.28 = 6835.94
- IGV = 6835.94 × 0.18 = 1230.47
- 10ADS = 6835.94 × 0.10 = 683.59
- total = 8750

**Item 5** (15000 × 1 = 15000, inafecto):
- base = 15000, total = 15000

**Detracción**: solo item 1, monto 45000 >= 1000 → aplica 12%
- Si descuento global afecta: total con descuento = 45000 + 25000 + 12650 + 8750 + 15000 - 5000 = 101400
- Detracción = 101400 × 0.12 = 12168

---

## Ejercicio 6: Factura de servicios profesionales — 7 items con descuentos por item + detracción

Servicios variados con diferentes impuestos, algunos con descuento por item.

**Request:**
```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 5500.00,
      "cantidad": 1,
      "descuento": 500.00,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 2,
      "valorUnitario": 3200.00,
      "cantidad": 3,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 3,
      "valorUnitario": 1800.00,
      "cantidad": 2,
      "descuento": 310.00,
      "valorConIgv": false,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 4,
      "valorUnitario": 4200.00,
      "cantidad": 1,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ],
      "detraccion": {
        "porcentaje": 10.00,
        "montoMinimo": 700.00,
        "codigoServicio": "001"
      }
    },
    {
      "item": 5,
      "valorUnitario": 950.00,
      "cantidad": 4,
      "impuestos": []
    },
    {
      "item": 6,
      "valorUnitario": 600.00,
      "cantidad": 2,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ]
    },
    {
      "item": 7,
      "valorUnitario": 2800.00,
      "cantidad": 1,
      "impuestos": [
        { "tipoImpuestoId": 31 }
      ]
    }
  ]
}
```

---

## Ejercicio 7: Factura de manufactura — materia prima + insumos, 20000+ unidades

Producción industrial con cantidades masivas y múltiples impuestos.

**Request:**
```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 0.85,
      "cantidad": 25000,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 2,
      "valorUnitario": 2.40,
      "cantidad": 15000,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ]
    },
    {
      "item": 3,
      "valorUnitario": 45.00,
      "cantidad": 500,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 4,
      "valorUnitario": 120.00,
      "cantidad": 200,
      "descuento": 1000.00,
      "valorConIgv": false,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 5,
      "valorUnitario": 8.00,
      "cantidad": 8000,
      "impuestos": []
    },
    {
      "item": 6,
      "valorUnitario": 350.00,
      "cantidad": 31,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 },
        { "tipoImpuestoId": 31 }
      ]
    }
  ]
}
```

---

## Ejercicio 8: Factura de restaurant de cadena — 10 items, mix completo

Proveedor de alimentos y bebidas con items variados.

**Request:**
```json
{
  "items": [
    {
      "item": 1,
      "valorUnitario": 32.50,
      "cantidad": 60,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 2,
      "valorUnitario": 18.00,
      "cantidad": 120,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 }
      ]
    },
    {
      "item": 3,
      "valorUnitario": 45.00,
      "cantidad": 40,
      "descuento": 310.00,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 4,
      "valorUnitario": 7.50,
      "cantidad": 200,
      "impuestos": []
    },
    {
      "item": 5,
      "valorUnitario": 120.00,
      "cantidad": 15,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 6,
      "valorUnitario": 25.00,
      "cantidad": 80,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    },
    {
      "item": 7,
      "valorUnitario": 60.00,
      "cantidad": 24,
      "valorConIgv": false,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 8,
      "valorUnitario": 3.20,
      "cantidad": 400,
      "impuestos": []
    },
    {
      "item": 9,
      "valorUnitario": 280.00,
      "cantidad": 5,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 32, "tipoCalculo": 3 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 10,
      "valorUnitario": 15.00,
      "cantidad": 100,
      "impuestos": [
        { "tipoImpuestoId": 21 }
      ]
    }
  ]
}
```

---

## Ejercicio 9: Descuento global con estructura uniforme — 4 items todos con IGV + 10ADS

Items con la MISMA estructura de impuestos [21, 31] + descuento global. Prueba que el prorrateo funciona.

**Request:**
```json
{
  "dsctoGlobalTipo": "$",
  "descuentoGlobal": 1000.00,
  "dsctoGlobalConIgv": true,
  "items": [
    {
      "item": 1,
      "valorUnitario": 2500.00,
      "cantidad": 2,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 2,
      "valorUnitario": 1800.00,
      "cantidad": 3,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 3,
      "valorUnitario": 4200.00,
      "cantidad": 1,
      "descuento": 300.00,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    },
    {
      "item": 4,
      "valorUnitario": 950.00,
      "cantidad": 4,
      "impuestos": [
        { "tipoImpuestoId": 21 },
        { "tipoImpuestoId": 31 }
      ]
    }
  ]
}
```

**Cálculo esperado:**

Item 1 (2 × 2500 = 5000, con impuestos):
- sumPercent = 18 + 10 = 28
- base = 5000 / 1.28 = 3906.25
- IGV = 3906.25 × 0.18 = 703.13
- 10ADS = 3906.25 × 0.10 = 390.62
- total = 5000

Item 2 (3 × 1800 = 5400, con impuestos):
- base = 5400 / 1.28 = 4218.75
- IGV = 4218.75 × 0.18 = 759.38
- 10ADS = 4218.75 × 0.10 = 421.87
- total = 5400

Item 3 (1 × 4200 = 4200, con impuestos, descuento item 300):
- Sin dsct: base = 4200 / 1.28 = 3281.25, IGV = 590.63, 10ADS = 328.12
- Dsct: monto=300, base=300/1.28=234.38, IGV dsct=42.19, 10ADS dsct=23.44
- Con dsct: base=3046.87, IGV=548.44, 10ADS=304.68
- total = 4200 - 300 = 3900

Item 4 (4 × 950 = 3800, con impuestos):
- base = 3800 / 1.28 = 2968.75
- IGV = 2968.75 × 0.18 = 534.38
- 10ADS = 2968.75 × 0.10 = 296.87
- total = 3800

Consolidado antes de descuento:
- subtotal = 3906.25 + 4218.75 + 3046.87 + 2968.75 = 14140.62
- totalConImpuestos = 5000 + 5400 + 3900 + 3800 = 18100
- proporcion = 14140.62 / 18100 = 0.7812
- descuentoGlobalSinImpuestos = 1000 × 0.7812 = 781.20
- descuentoGlobalConImpuestos = 1000

---

## Resumen de IDs de impuestos

| ID | Código | Tipo cálculo | Descripción |
|---|---|---|---|
| 21 | IGV18 | 1 (PORCENTAJE) fiscalizado | 18% |
| 42 | IGV1A | 1 (PORCENTAJE) fiscalizado | 10.5% |
| 32 | ISC | 3 (BASE_AFFECTING) | 13% |
| 31 | 10ADS | 1 (PORCENTAJE) no fiscalizado | 10% |

---

> **Historial**
>
> | Versión | Fecha | Cambios |
> |---|---|---|
> | 2.0 | 2026-06-10 | Ejemplos complejos: 8 facturas realistas con 5-10 items, cantidades masivas, descuentos, detracción, múltiples impuestos simultáneos |
