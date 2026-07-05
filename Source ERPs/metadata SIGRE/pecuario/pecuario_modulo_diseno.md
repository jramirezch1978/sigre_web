# Módulo Pecuario — Diseño funcional

Ubicado dentro del módulo **Campo** (mismo bucket de menú que el módulo agrícola de caña), como un sub-módulo independiente en tablas y ventanas, pero compartiendo menú/parametrización general de fundo (`cod_origen`). Sigue la convención de codificación de ventanas usada en Almacén (`AL001`, `AL002`...) con el prefijo **`PC###`** (Pecuario).

## 1. Objetivo y alcance

Llevar el control operativo, sanitario, reproductivo y productivo del hato ganadero de Agro Industrial San Martín (vacas y toros), y dejar la trazabilidad necesaria para SENASA (DTA) y una base de datos lista para integrarse a Contabilidad como activo biológico (NIC 41).

No reemplaza ni modifica el módulo Campo existente (caña): es un árbol de tablas y ventanas nuevo (`PC_*`), que solo comparte el concepto de `cod_origen` (fundo/sucursal) con el resto del sistema.

## 2. Catálogos maestros (previos a operar)

| Ventana (borrador) | Tabla | Contenido |
|---|---|---|
| PC001 | `PC_RAZA` | Razas bovinas (Holstein, Brown Swiss, Gyr, etc.) |
| PC002 | `PC_CATEGORIA` | Etapas del animal (ternero, vaquillona, novilla, vaca en producción/seca/descarte, toro) — viene precargada |
| PC003 | `PC_POTRERO` | Potreros de pastoreo por fundo, con capacidad de carga |
| PC004 | `PC_SEMENTAL` | Catálogo de sementales/pajillas para inseminación artificial |
| PC005 | `PC_PRODUCTO_SANITARIO` | Vacunas, desparasitantes, medicamentos, con período de retiro |
| PC006 | `PC_ENFERMEDAD` | Enfermedades/diagnósticos |
| PC007 | `PC_DIETA` + `PC_DIETA_COMPONENTE` | Raciones por categoría, con insumos referenciados a `ARTICULO` (Almacén) |

Estas tablas se configuran una sola vez (o rara vez) antes de operar.

## 3. Maestro de animal — PC010 (`PC_ANIMAL`)

Ventana tabular tipo maestro (similar a un maestro de artículo). Cada fila es un animal individual identificado por su arete/chapa (`cod_animal`). Captura: raza, sexo, fecha de nacimiento, genealogía (padre/madre, propios o por IA), categoría actual, potrero actual, procedencia (nacido en el predio vs. comprado), peso de nacimiento y peso actual.

El campo `flag_estado_repro` (vacía / servida / preñada / recién parida) se mantiene desnormalizado en el maestro para que el listado principal (la pantalla que más va a usar el vaquero/mayordomo a diario) no tenga que hacer joins contra `PC_SERVICIO`/`PC_PARTO` cada vez — se actualiza por trigger o por proceso batch cuando ocurre un evento reproductivo.

La recategorización (ternero → vaquillona → novilla → vaca) puede ser un proceso batch mensual que evalúa edad y estado reproductivo contra `PC_CATEGORIA.edad_min_meses/edad_max_meses`, en vez de que el usuario la cambie manualmente.

## 4. Reproducción (PC020–PC023)

Flujo secuencial: **celo → servicio → diagnóstico de preñez → parto**.

- `PC_CELO`: registro de detección de celo (visual, podómetro/collar, hormonal). Es el disparador para decidir un servicio.
- `PC_SERVICIO`: monta natural (con toro propio, `cod_animal_toro`) o inseminación artificial (con `cod_semental` del catálogo). Calcula `fec_prob_parto` = `fec_servicio` + 283 días.
- `PC_DIAGNOSTICO_PRENEZ`: confirma o descarta el servicio (tacto rectal o ecografía, a los 30-60-90 días). Si el resultado es "vacía", el animal vuelve a flag_estado_repro = 0 y reinicia el ciclo.
- `PC_PARTO`: cierra el ciclo. Registra tipo de parto (eutócico/distócico), asistencia, retención de placenta, y **da de alta a la cría como un nuevo `PC_ANIMAL`** (vínculo `cod_animal_cria`) — este es el punto de entrada natural de un animal nacido en el predio al sistema.

Indicadores que se pueden sacar de aquí sin tablas adicionales: intervalo entre partos, días abiertos, tasa de preñez por servicio, distocias %.

## 5. Producción de leche (PC030–PC032)

- `PC_LACTANCIA`: se abre automáticamente al registrar un parto de una hembra (un registro por lactancia, no por vaca). Se cierra (`fec_secado`) cuando el usuario marca el secado, generalmente ~60 días antes del próximo parto esperado.
- `PC_ORDENO`: el detalle diario, hasta 3 turnos (mañana/tarde/noche). Es la tabla de mayor volumen del módulo — pensar en un proceso de carga rápida (grilla por potrero/establo con foco en litros, no formulario campo por campo).
- `PC_CONTROL_LECHERO`: muestreo periódico (no diario) de calidad — % grasa, % proteína, células somáticas (CCS). Sirve para detectar mastitis subclínica antes de que sea evidente en el ordeño.

`PC_LACTANCIA.litros_totales` se recalcula sumando `PC_ORDENO` (columna denormalizada por performance de reporte, igual criterio que `flag_estado_repro`).

## 6. Alimentación (PC040)

`PC_ALIMENTACION_CONSUMO` registra consumo diario **por potrero/lote**, no por animal individual (no es práctico pesar la comida de cada vaca) — se carga `cabezas_lote` (cuántos animales comieron esa dieta ese día) y el sistema puede sacar un costo por cabeza dividiendo. La dieta (`PC_DIETA`) y sus componentes (`PC_DIETA_COMPONENTE`) están parametrizados contra `ARTICULO`, así que este consumo puede generar una salida de almacén (egreso de forraje/concentrado) igual que cualquier otro consumo interno — este es el punto de integración natural con Almacén.

## 7. Sanidad (PC050)

`PC_SANIDAD_EVENTO` es una tabla única para vacunas, desparasitaciones, tratamientos y diagnósticos (discriminada por `flag_tipo_evento`), en vez de 4 tablas separadas — simplifica el calendario sanitario (una sola consulta "próximos eventos" ordenada por `fec_prox_refuerzo`) y el control de período de retiro (`fec_fin_retiro`), que debe cruzarse contra `PC_ORDENO.flag_descarte` para no vender leche de un animal en tratamiento.

## 8. Movimientos, trazabilidad y bajas (PC060–PC063)

- `PC_MOVIMIENTO_POTRERO`: histórico de rotación de potreros (pastoreo rotativo).
- `PC_DTA` + `PC_DTA_DETALLE`: Documento de Tránsito Animal exigido por SENASA para vender o trasladar animales fuera del predio. Un DTA agrupa uno o varios animales (`PC_DTA_DETALLE`).
- `PC_BAJA`: cierre del ciclo de vida del animal (venta, muerte, descarte). Un trigger (`TRG_PC_BAJA_AI`) desactiva automáticamente el animal en `PC_ANIMAL` al insertar la baja. Si la baja es por venta, referencia el DTA correspondiente.

## 9. Integración con otros módulos

- **Almacén** (`ARTICULO`): insumos de dieta (`PC_DIETA_COMPONENTE`) y su consumo (`PC_ALIMENTACION_CONSUMO`); también productos sanitarios podrían modelarse como artículos de almacén en vez de un catálogo aparte, a decidir según si Sanidad ya maneja stock de vacunas en Almacén.
- **RRHH**: `cod_veterinario`/`cod_tecnico` en `PC_SANIDAD_EVENTO`, `PC_PARTO`, `PC_SERVICIO` podrían ser FK a la tabla de empleados en vez de `CHAR(6)` libre, si el veterinario/inseminador es personal de planilla.
- **Contabilidad**: ver sección siguiente — activo biológico bajo NIC 41.

## 10. Contabilización — Activo biológico (NIC 41)

*(Sección preliminar; se ampliará con el detalle exacto de matriz contable / centros de costo / pre-asientos que ya existe en Activo Fijo — ver `README_ACTIVO_FIJO.md` y `README_CONTABILIDAD.md`.)*

Puntos clave ya confirmados en el sistema actual:

- El módulo de Activo Fijo **ya tiene el patrón de integración que necesitamos replicar**: una "Matriz Contable" por clase de activo (define cuentas de activo, depreciación acumulada y gasto), un cálculo periódico que distribuye por centro de costos, y una capa de "pre-asientos" que después se transfiere/consolida al libro diario. Actualmente esa generación automática de asientos está **deshabilitada** en Activo Fijo (transferencia manual) — es una decisión de negocio a confirmar si Pecuario la replica igual (con auto-post apagado) o se activa desde el inicio para este módulo nuevo.
- Bajo NIC 41, el ganado **no se deprecia** — se revalúa periódicamente a valor razonable menos costos de venta, y la variación va a resultados (no a una cuenta de depreciación acumulada). Esto significa que la "Matriz Contable" de Pecuario necesita conceptos distintos a los de Activo Fijo: en vez de (activo / depreciación acumulada / gasto por depreciación), sería algo como (activo biológico / ingreso o gasto por cambio en valor razonable).
- Hechos económicos que necesitan generar movimiento contable, análogos a los "conceptos" que ya usa Activo Fijo para sus matrices:
  1. **Alta** (nacimiento o compra) — reconocimiento inicial del activo biológico.
  2. **Revaluación periódica** (mensual o anual) — ajuste a valor razonable, con contrapartida a resultados.
  3. **Baja por venta** — retiro del activo + reconocimiento de ingreso por venta.
  4. **Baja por muerte/descarte** — retiro del activo con pérdida.
  5. (Opcional) **Costeo de leche producida** — la leche es inventario (NIC 2), no activo biológico; en la cosecha (ordeño) se reconoce como producto agrícola a valor razonable en el punto de cosecha.

## 11. Próximos pasos

1. Diseñar las ventanas PowerBuilder PC001...PC0XX (código + nombre, igual convención que AL###).
2. Validar el diseño de tablas con el gerente de San Martín.
3. Confirmar con el contador el tratamiento contable exacto (cuentas, periodicidad de revaluación, si se activa auto-post o se deja manual como Activo Fijo).
4. Definir si se necesita un catálogo de **establos/corrales** además de `PC_POTRERO`, y si `PC_ANIMAL` lleva `cod_centro_costo` directo (ver preguntas abiertas más abajo).
