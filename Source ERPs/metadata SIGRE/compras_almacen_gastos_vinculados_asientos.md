# SIGRE — Gastos vinculados a Orden de Compra (OS→OC) y su contabilización

> Referencia técnica de una investigación puntual sobre el esquema legado (Cantabria). No es un documento de diseño para un módulo nuevo — es documentación de cómo YA funciona SIGRE, para no tener que re-investigar cada vez que el tema vuelva a salir (p.ej. al migrar/replicar este flujo para otro tenant).

## 1. El problema de negocio

Cuando se compra mercadería (Orden de Compra) y además hay costos vinculados a esa compra facturados por separado (flete, seguro, etc., vía una Orden de Servicio distinta), esos costos deben terminar capitalizados al costo del inventario — no como gasto del período (NIC 2, párrafo 11: "otros costos directamente atribuibles a la adquisición").

El flete/seguro casi siempre se factura **después** de que la mercadería ya ingresó a almacén, así que no se puede simplemente inflar el precio del ingreso original.

## 2. Mecanismo real en SIGRE (único, sin duplicados)

Verificado por búsqueda exhaustiva en `procedures_cantabria.sql`: no existe ningún otro procedimiento que haga este mismo trabajo. Las tablas `OC_DET_OS_DET` y `AM_OS_DET` (ver abajo) solo aparecen en los procedimientos listados aquí.

### Tabla puente: `OC_DET_OS_DET`
Vincula una línea de artículo de OC (`articulo_mov_proy`) con un ítem de gasto de OS (`orden_servicio_det`):
```
OC_DET_OS_DET (org_amp, nro_amp, org_os, nro_os, item_os, importe, matriz_cntbl, flag_replicacion)
```
Definición: `01. documentacion/metadata SIGRE/schema_export.json:27136-27157`.

### Paso A — Vinculación + prorrateo: `w_cm332_asignacion_os_oc.srw`
Ruta de menú: **Operaciones → Compras → Orden de Compra → [CM332] Asignacion de OS para valorizar OC** (`Compras/compras_m.pbl.src/m_master.srm:4113-4143`).

- `ue_insert` (líneas 210-233): inserta filas en `OC_DET_OS_DET` vía el selector genérico `w_abc_seleccion_md`.
- Menú "Prorratear Costo" → `ue_prorrateo` (líneas 51-94) → `USP_CMP_PRORRATEA_OS` (`procedures_cantabria.sql:61300-61366`).

**Fórmula de prorrateo** (por valor): `ratio = importe_gasto_OS / Σ(cantidad × precio_unit de las líneas de OC vinculadas)`; cada línea de `OC_DET_OS_DET.importe` se actualiza a `ratio × cant_proyect × precio_unit` de esa línea.

### Paso B — Generación del ajuste en Almacén: `w_cm333_gen_ajuste_valor.srw`
**No tiene entrada de menú** — verificado con grep global sobre `ws_objects`, no aparece en ningún `.srm`. Se abre solo desde código/otro flujo no localizado, o es un ítem removido del menú en algún momento. Pendiente de confirmar si esto es intencional.

- `ue_generar` (líneas 51-93) → `USP_CMP_GEN_MOV_AJUSTE` (`procedures_cantabria.sql:60410-60609`):
  1. Valida que la línea de OC no haya sido procesada ya (`am_os_det`).
  2. Valida que exista un ingreso previo a almacén para esa línea (si no, error "no tiene movimientos de almacen").
  3. Inserta cabecera `vale_mov` (`tipo_mov = oper_ajuste_valor`, glosa "AJUSTE VALORIZACION AUTOMATICO") y detalle `articulo_mov` con **`cant_procesada = 0`** y `precio_unit` = el importe prorrateado (convertido a soles).
  4. Inserta en `am_os_det` (trazabilidad / anti-reproceso).
  5. Llama `usp_alm_act_valor_x_art_alm` → recalcula costo promedio ponderado del artículo **por almacén**.
- `ue_anular` (líneas 232-272) → `USP_CMP_ANULAR_MOV_AJUSTE` (`procedures_cantabria.sql:58547-58611`): reversión simétrica (`flag_estado='0'`, borra `am_os_det`, recalcula de nuevo).

Es un proceso **manual/batch**, no automático al grabar OC ni OS.

## 3. Procedimientos investigados y descartados (NO hacen esto)

| Procedimiento | Qué hace realmente |
|---|---|
| `USP_ALM_PREC_OC_NI_ART` (AL514, `procedures_cantabria.sql:16926`) | Corrige descuadre de precio entre OC y Nota de Ingreso sobre el **mismo** movimiento — no gastos vinculados |
| `USP_ALM_REG_PREC_OC_NI` (batch de lo anterior, `:17831`) | Versión batch por rango de fechas del mismo mecanismo AL514 |
| `USP_ALM_AJUSTE_VALORIZ` (`:12814`) | Helper genérico de recálculo de costo cuando se modifica manualmente el precio de un ingreso |
| `USP_CMP_ACT_PREC_NI` (`:58442`) | Sincroniza precio de `articulo_mov` con `articulo_mov_proy` de la OC + conversión moneda |
| `USP_CMP_ACT_MONTO_OC` (`:58278`) | Recalcula impuestos y monto total/facturado de cabecera de OC |
| `USP_CMP_COMPARA_OS_PE` (`:59083`) | Compara ejecutado de OS contra `presupuesto_ejec` — control presupuestal, no capitalización |

## 4. Motor de contabilización (cómo se generan los asientos reales)

Todo es data-driven, sin cuentas hardcodeadas en el código:

```
articulo_mov_tipo.flag_contabiliza='1'  →  usf_alm_matriz_contable(tipo_mov, cencos, cnta_prsp, sub_categ)
   → resuelve un código "matriz" vía tipo_mov_matriz / tipo_mov_matriz_subcat
   → matriz_cntbl_finan_det(matriz) da (cnta_ctbl, flag_debhab) — una o más filas D/H
```

- **Movimientos de almacén** (ingresos, salidas, ajustes de valorización): `USP_CNT_ASIENTO_ALMACEN` (`:68897-69344`), proceso batch mensual.
  - **Hallazgo clave**: para movimientos normales el importe contabilizado es `cant_procesada × precio_unit`; para movimientos con `flag_ajuste_valorizacion='1'` (los ajustes de CM333) el importe es **`precio_unit` directamente** (línea 69293-69343) — el código tiene una rama especial precisamente porque estos movimientos siempre traen `cant_procesada = 0`.
  - Si la matriz del movimiento no define explícitamente un lado (DEBE o HABER), ese lado cae a la cuenta por defecto de `articulo_sub_categ` (`cnta_ctbl_haber` / `cnta_cntbl`) — que para un ingreso normal es la cuenta de "Variación de mercaderías" (clase 6, p.ej. 61xxx).
- **Liquidación de Orden de Servicio**: `USP_CNT_GENERA_ASIENTO_OS` (`:90831-90900`), también batch mensual.
  - **Hallazgo clave**: la cuenta NO está fija a ningún código — cada línea (`orden_servicio_det.confin`) apunta a un `concepto_financiero`, y es `concepto_financiero.matriz_cntbl` el que determina la cuenta. Esto es 100% configurable por línea de OS.

## 5. Análisis contable — el asiento correcto (NIC 2 + restricción del esquema por función)

**Restricción del negocio (San Martín/Cantabria)**: usan un esquema de cuentas por función (clase 9), donde las clases 6 (60-69, incl. 61/62/63) son siempre cuentas "de paso" que se destinan a la clase 9. Por eso **no se puede** usar una cuenta clase 6 como destino de una reclasificación posterior (el saldo podría ya haberse barrido al 9x antes de que corra el ajuste).

### Flujo de asientos correcto

```
1) Ingreso a almacén, sin factura de mercadería aún (oper_ing_oc):
   60111 Compras ................................ 1,000.00
           a 42104 Fact. por recibir (mercadería) ......... 1,000.00

2) Destino a almacén (cierre de período):
   20111 Mercaderías ............................. 1,000.00
           a 61112 Variación de mercaderías ................ 1,000.00
   → costo_prom = S/10.00/und, 100 und en stock

3) Liquidación de la OS (factura de flete llega después), usando un
   concepto_financiero DEDICADO "Gastos vinculados a Orden de Compra"
   (NO el concepto genérico de flete/seguro, que sí iría a 63):
   42107 Fact. por recibir - Servicios vinc. a OC ...   100.00
   40111 IGV - Cuenta propia ....................        18.00
           a 42121 Fact. por pagar (prov. transporte) ......   118.00
   → nunca toca clase 6; cuenta puente de balance (clase 4)

4) Vinculación OC↔OS + prorrateo (CM332) — SIN asiento, solo llena OC_DET_OS_DET.

5) Ajuste de valorización (CM333, USP_CMP_GEN_MOV_AJUSTE):
   20111 Mercaderías .............................   100.00
           a 42107 Fact. por recibir - Servicios vinc. a OC ...   100.00
   → limpia 42107 a cero, capitaliza al inventario.
   → nuevo costo_prom = (1,000+100)/100 = S/11.00/und

6) Salida de almacén, DESPUÉS del ajuste (costo ya inflado):
   69... Costo de ventas ..........................   costo_prom actual (S/11.00) × cantidad
           a 20111 Mercaderías ............................. ídem
```

### Implementación en SIGRE (config, no desarrollo)

1. Crear en `concepto_financiero` un concepto nuevo, p.ej. "Gastos vinculados a Orden de Compra", distinto del genérico de flete/seguro.
2. Asignar ese `confin` en las líneas de `orden_servicio_det` que se sepa (o se re-etiquete al vincular vía CM332) que van a capitalizarse.
3. Configurar en `tipo_mov_matriz`/`matriz_cntbl_finan_det` la matriz del `tipo_mov = oper_ajuste_valor` con **ambos lados explícitos**: DEBE=20xxx (o dejar el fallback de subcategoría, que ya resuelve bien), HABER=42107 **explícito** (no dejar caer al fallback de subcategoría, porque ese cae a un 61xxx — clase 6, mismo problema que se quiere evitar).

### Riesgo pendiente / no resuelto por el sistema

Si hay salidas de almacén **antes** de que corra el ajuste (CM333), esas unidades salen con el costo viejo (sin el flete capitalizado) — el ajuste solo corrige el costo promedio prospectivo de las unidades que quedan en stock. El COGS ya contabilizado de las unidades vendidas antes del ajuste no se corrige automáticamente; requeriría un asiento manual adicional de reclasificación a costo de ventas si se quiere exactitud retroactiva. Conviene correr CM333 lo antes posible tras recibir la factura del servicio vinculado.
