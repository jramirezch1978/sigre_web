# Módulo Agropecuario (Campo + Pecuario) — Diseño funcional

Pecuario **no es un módulo aparte**: es una extensión de **Campo**, así que las ventanas usan el mismo prefijo PowerBuilder que ya existe para Campo (`w_cam###`, confirmado en `ws_objects/Campo`) en vez de un prefijo propio. Las tablas sí mantienen su propio prefijo `PC_*` (Pecuario) para distinguirlas claramente de las tablas agrícolas (`CAMPO_*`) dentro del mismo esquema — solo cambia la numeración de ventanas, no las tablas.

## 1. Regla de numeración de ventanas (confirmada por el usuario)

Dentro de cada módulo, el número de ventana se asigna **por tipo de opción de menú**, no por área funcional:

| Rango | Tipo de opción |
|---|---|
| 000–299 | Tablas (catálogos/parametrización — se configuran una vez, rara vez cambian) |
| 300–499 | Operaciones (registro transaccional del día a día) |
| 500–699 | Consultas (búsqueda/visualización, no modifican datos) |
| 700–899 | Reportes (impresión/exportación) |
| 900–999 | Procesos (batch, sin interacción de usuario) |

Campo (caña) ya ocupa: `001–060` y `200–201` (Tablas), `301–390` y `412–434` (Operaciones), `700–715` y `752–758` (Reportes). Pecuario usa bloques limpios, sin colisión, dentro de cada rango:

| Tipo | Bloque asignado a Pecuario |
|---|---|
| Tablas | `CAM100`–`CAM106` |
| Operaciones | `CAM440`–`CAM454` |
| Consultas | `CAM500`–`CAM505` |
| Reportes | `CAM800`–`CAM806` |
| Procesos | `CAM900`–`CAM905` |

**Criterio de clasificación** (mismo que ya usa Activo Fijo en `README_ACTIVO_FIJO.md`): el maestro de cada *especimen individual* (ahí "Maestro de Activo Fijo", acá `PC_ANIMAL`) va en **Operaciones**, no en Tablas — porque es un registro vivo que crece todos los días, a diferencia de un catálogo de parametrización.

## 2. Objetivo y alcance

Llevar el control operativo, sanitario, reproductivo y productivo del hato ganadero de Agro Industrial San Martín (vacas y toros), y dejar la trazabilidad necesaria para SENASA (DTA) y una base de datos lista para integrarse a Contabilidad como activo biológico (NIC 41).

No reemplaza ni modifica el módulo Campo existente (caña): es un árbol de tablas nuevo (`PC_*`) y opciones de menú nuevas (usando los bloques de la tabla anterior) que solo comparten el concepto de `cod_origen` (fundo/sucursal) y el mismo prefijo de ventana con el resto de Campo.

## 3. Estructura de menú completa

| Menú Principal | Código | Ventana / Proceso | Tabla | Descripción |
|---|---|---|---|---|
| **TABLAS** | CAM100 | Razas | `PC_RAZA` | Razas bovinas (Holstein, Brown Swiss, Gyr, etc.) |
| TABLAS | CAM101 | Categorías | `PC_CATEGORIA` | Etapas del animal (ternero, vaquillona, novilla, vaca en producción/seca/descarte, toro) — viene precargada |
| TABLAS | CAM102 | Potreros | `PC_POTRERO` | Potreros de pastoreo por fundo, con capacidad de carga |
| TABLAS | CAM103 | Sementales | `PC_SEMENTAL` | Catálogo de sementales/pajillas para inseminación artificial |
| TABLAS | CAM104 | Productos sanitarios | `PC_PRODUCTO_SANITARIO` | Vacunas, desparasitantes, medicamentos, con período de retiro |
| TABLAS | CAM105 | Enfermedades | `PC_ENFERMEDAD` | Catálogo de enfermedades/diagnósticos |
| TABLAS | CAM106 | Dietas | `PC_DIETA` + `PC_DIETA_COMPONENTE` | Raciones por categoría, con insumos referenciados a `ARTICULO` (Almacén) |
| **OPERACIONES** | CAM440 | Maestro de animal | `PC_ANIMAL` | Alta y mantenimiento del hato (identificación, genealogía, categoría, ubicación) |
| OPERACIONES | CAM441 | Registro de celo | `PC_CELO` | Detección de celo (visual, podómetro/collar, hormonal) |
| OPERACIONES | CAM442 | Registro de servicio | `PC_SERVICIO` | Monta natural o inseminación artificial |
| OPERACIONES | CAM443 | Diagnóstico de preñez | `PC_DIAGNOSTICO_PRENEZ` | Confirmación/descarte de preñez (tacto rectal o ecografía) |
| OPERACIONES | CAM444 | Registro de parto | `PC_PARTO` | Parto, alta automática de la cría |
| OPERACIONES | CAM445 | Lactancia | `PC_LACTANCIA` | Apertura automática al parto; cierre (secado) manual |
| OPERACIONES | CAM446 | Ordeño diario | `PC_ORDENO` | Litros por turno (mañana/tarde/noche) |
| OPERACIONES | CAM447 | Control lechero | `PC_CONTROL_LECHERO` | Muestreo periódico de calidad (grasa, proteína, CCS) |
| OPERACIONES | CAM448 | Condición corporal | `PC_CONDICION_CORPORAL` | Evaluación BCS (escala 1-5) |
| OPERACIONES | CAM449 | Consumo de alimento | `PC_ALIMENTACION_CONSUMO` | Consumo diario de dieta por potrero/lote |
| OPERACIONES | CAM450 | Eventos sanitarios | `PC_SANIDAD_EVENTO` | Vacunas, desparasitaciones, tratamientos, diagnósticos |
| OPERACIONES | CAM451 | Muestras de laboratorio | `PC_LABORATORIO` + `PC_LABORATORIO_DET` | Toma de muestra y carga de resultados (sangre, leche, fecal, semen, tejido) |
| OPERACIONES | CAM452 | Movimiento de potrero | `PC_MOVIMIENTO_POTRERO` | Traslado/rotación de potreros |
| OPERACIONES | CAM453 | Documento de Tránsito Animal | `PC_DTA` + `PC_DTA_DETALLE` | Emisión de DTA para venta o traslado (SENASA) |
| OPERACIONES | CAM454 | Baja de animal | `PC_BAJA` | Venta, muerte o descarte; desactiva el animal (trigger) |
| **CONSULTAS** | CAM500 | Ficha del animal | — | Vista 360°: datos generales + genealogía + historial reproductivo + producción + sanidad |
| CONSULTAS | CAM501 | Historial reproductivo | — | Por animal o por rango de fechas (celos, servicios, diagnósticos, partos) |
| CONSULTAS | CAM502 | Producción de leche | — | Por animal, por potrero o por período |
| CONSULTAS | CAM503 | Calendario sanitario | — | Próximos refuerzos y fin de período de retiro vigente |
| CONSULTAS | CAM504 | Trazabilidad SENASA | — | DTA por animal |
| CONSULTAS | CAM505 | Resultados de laboratorio | — | Pendientes y con resultado, por animal o por tipo de muestra |
| **REPORTES** | CAM800 | Resumen del hato | — | Inventario de animales por categoría, potrero y estado reproductivo |
| REPORTES | CAM801 | Indicadores reproductivos | — | Intervalo entre partos, días abiertos, tasa de preñez, % distocias |
| REPORTES | CAM802 | Producción de leche | — | Mensual, consolidado y por vaca |
| REPORTES | CAM803 | Control lechero | — | Calidad de leche (grasa/proteína/CCS) por período |
| REPORTES | CAM804 | Costos de alimentación | — | Por potrero/categoría, cruzando `PC_ALIMENTACION_CONSUMO` con costo de `ARTICULO` |
| REPORTES | CAM805 | Sanitario | — | Vacunas aplicadas, próximos vencimientos, período de retiro vigente |
| REPORTES | CAM806 | Bajas del período | — | Ventas, muertes y descartes |
| **PROCESOS** | CAM900 | Recategorización automática | — | Recalcula `PC_ANIMAL.cod_categoria` según edad y estado reproductivo |
| PROCESOS | CAM901 | Actualización de estado reproductivo | — | Recalcula `PC_ANIMAL.flag_estado_repro` según el último evento (celo/servicio/diagnóstico/parto) |
| PROCESOS | CAM902 | Cierre automático de lactancia | — | Marca `fec_secado` cuando se alcanza la fecha proyectada |
| PROCESOS | CAM903 | Recálculo de litros de lactancia | — | Recalcula `PC_LACTANCIA.litros_totales` sumando `PC_ORDENO` |
| PROCESOS | CAM904 | Revaluación NIC 41 | — | Ajuste periódico a valor razonable del activo biológico (ver sección 12) |
| PROCESOS | CAM905 | Cálculo de vencimientos sanitarios | — | Recalcula `fec_prox_refuerzo` y `fec_fin_retiro` en `PC_SANIDAD_EVENTO` |

## 4. Catálogos maestros (CAM100–CAM106)

Estas tablas se configuran una sola vez (o rara vez) antes de operar: `PC_RAZA`, `PC_CATEGORIA` (viene precargada con ternero/vaquillona/novilla/vaca en producción-seca-descarte/toro), `PC_POTRERO`, `PC_SEMENTAL`, `PC_PRODUCTO_SANITARIO`, `PC_ENFERMEDAD`, `PC_DIETA` + `PC_DIETA_COMPONENTE`.

## 5. Maestro de animal — CAM440 (`PC_ANIMAL`)

Ventana tabular tipo maestro (similar a un maestro de artículo, pero clasificada como Operación porque el registro crece todos los días). Cada fila es un animal individual identificado por su arete/chapa (`cod_animal`). Captura: raza, sexo, fecha de nacimiento, genealogía (padre/madre, propios o por IA), categoría actual, potrero actual, procedencia (nacido en el predio vs. comprado), peso de nacimiento y peso actual.

El campo `flag_estado_repro` (vacía / servida / preñada / recién parida) se mantiene desnormalizado en el maestro para que la ficha del animal (CAM500, la pantalla que más va a usar el vaquero/mayordomo a diario) no tenga que hacer joins contra `PC_SERVICIO`/`PC_PARTO` cada vez — se actualiza por el proceso batch CAM901 cuando ocurre un evento reproductivo.

La recategorización (ternero → vaquillona → novilla → vaca) es el proceso batch CAM900, que evalúa edad y estado reproductivo contra `PC_CATEGORIA.edad_min_meses/edad_max_meses`, en vez de que el usuario la cambie manualmente.

## 6. Reproducción (CAM441–CAM444)

Flujo secuencial: **celo (CAM441) → servicio (CAM442) → diagnóstico de preñez (CAM443) → parto (CAM444)**.

- `PC_CELO`: registro de detección de celo (visual, podómetro/collar, hormonal). Es el disparador para decidir un servicio.
- `PC_SERVICIO`: monta natural (con toro propio, `cod_animal_toro`) o inseminación artificial (con `cod_semental` del catálogo). Calcula `fec_prob_parto` = `fec_servicio` + 283 días.
- `PC_DIAGNOSTICO_PRENEZ`: confirma o descarta el servicio (tacto rectal o ecografía, a los 30-60-90 días). Si el resultado es "vacía", el animal vuelve a flag_estado_repro = 0 y reinicia el ciclo.
- `PC_PARTO`: cierra el ciclo. Registra tipo de parto (eutócico/distócico), asistencia, retención de placenta, y **da de alta a la cría como un nuevo `PC_ANIMAL`** (vínculo `cod_animal_cria`) — este es el punto de entrada natural de un animal nacido en el predio al sistema.

Los indicadores (intervalo entre partos, días abiertos, tasa de preñez por servicio, % distocias) no necesitan tablas adicionales: se calculan en el reporte CAM801.

## 7. Producción de leche (CAM445–CAM447)

- `PC_LACTANCIA` (CAM445): se abre automáticamente al registrar un parto de una hembra (un registro por lactancia, no por vaca). Se cierra (`fec_secado`) por el proceso batch CAM902 cuando se alcanza la fecha proyectada (~60 días antes del próximo parto esperado), o manualmente si el usuario decide secar antes.
- `PC_ORDENO` (CAM446): el detalle diario, hasta 3 turnos (mañana/tarde/noche). Es la tabla de mayor volumen del módulo — pensar en un proceso de carga rápida (grilla por potrero/establo con foco en litros, no formulario campo por campo).
- `PC_CONTROL_LECHERO` (CAM447): muestreo periódico (no diario) de calidad — % grasa, % proteína, células somáticas (CCS). Sirve para detectar mastitis subclínica antes de que sea evidente en el ordeño.

`PC_LACTANCIA.litros_totales` se recalcula con el proceso batch CAM903 (columna denormalizada por performance de reporte, igual criterio que `flag_estado_repro`).

## 8. Nutrición y alimentación (CAM448–CAM449)

- `PC_CONDICION_CORPORAL` (CAM448): historial de evaluaciones de condición corporal (BCS, escala 1-5) por animal — indicador rápido de si la dieta está funcionando, sin depender de pesajes.
- `PC_ALIMENTACION_CONSUMO` (CAM449): registra consumo diario **por potrero/lote**, no por animal individual (no es práctico pesar la comida de cada vaca) — se carga `cabezas_lote` (cuántos animales comieron esa dieta ese día) y el sistema puede sacar un costo por cabeza dividiendo (reporte CAM804). La dieta (`PC_DIETA`) y sus componentes (`PC_DIETA_COMPONENTE`) están parametrizados contra `ARTICULO`, así que este consumo puede generar una salida de almacén (egreso de forraje/concentrado) igual que cualquier otro consumo interno — este es el punto de integración natural con Almacén.

## 9. Sanidad (CAM450)

`PC_SANIDAD_EVENTO` es una tabla única para vacunas, desparasitaciones, tratamientos y diagnósticos (discriminada por `flag_tipo_evento`), en vez de 4 tablas separadas — simplifica el calendario sanitario (consulta CAM503, ordenada por `fec_prox_refuerzo`, recalculado por el proceso batch CAM905) y el control de período de retiro (`fec_fin_retiro`), que debe cruzarse contra `PC_ORDENO.flag_descarte` para no vender leche de un animal en tratamiento.

## 10. Resultados de laboratorio (CAM451)

Parte que faltaba en el primer diseño: los eventos sanitarios (`PC_SANIDAD_EVENTO`) registran que "se hizo" un diagnóstico o análisis, pero no el **detalle del resultado del laboratorio** (valores, unidades, rango de referencia, interpretación) — necesario tanto para exámenes veterinarios (serología de brucelosis/IBR-BVD, coprológico/huevos por gramo, perfil metabólico) como para control de calidad de semen de los sementales propios.

- `PC_LABORATORIO`: cabecera de la muestra — animal (opcional, nullable: una muestra de semen de `PC_SEMENTAL` o de forraje/agua no siempre es de un animal puntual), tipo de muestra (`flag_tipo_muestra`: Sangre/Leche/Fecal/Semen/Tejido/Otro), laboratorio externo, veterinario que tomó la muestra, fecha de toma y de resultado, estado (pendiente/con resultado). Enlace opcional a `PC_SANIDAD_EVENTO` cuando el examen es parte de un evento sanitario ya registrado.
- `PC_LABORATORIO_DET`: detalle — un examen de laboratorio suele traer varios parámetros en un solo resultado (ej. un perfil metabólico trae calcio, magnesio, glucosa), así que es una tabla de líneas: parámetro/analito, valor (texto, para poder guardar tanto "Positivo/Negativo" como valores numéricos), unidad de medida, rango de referencia mínimo/máximo, e interpretación (Normal/Alterado).

Este resultado es el que finalmente confirma o descarta lo que `PC_DIAGNOSTICO_PRENEZ` o `PC_SANIDAD_EVENTO` ya adelantaron de forma operativa (ej. tacto rectal vs. confirmación por laboratorio de progesterona). Consulta asociada: CAM505.

## 11. Movimientos, trazabilidad y bajas (CAM452–CAM454)

- `PC_MOVIMIENTO_POTRERO` (CAM452): histórico de rotación de potreros (pastoreo rotativo).
- `PC_DTA` + `PC_DTA_DETALLE` (CAM453): Documento de Tránsito Animal exigido por SENASA para vender o trasladar animales fuera del predio. Un DTA agrupa uno o varios animales (`PC_DTA_DETALLE`). Consulta de trazabilidad: CAM504.
- `PC_BAJA` (CAM454): cierre del ciclo de vida del animal (venta, muerte, descarte). Un trigger (`TRG_PC_BAJA_AI`) desactiva automáticamente el animal en `PC_ANIMAL` al insertar la baja. Si la baja es por venta, referencia el DTA correspondiente. Reporte: CAM806.

## 12. Integración con otros módulos

- **Almacén** (`ARTICULO`): insumos de dieta (`PC_DIETA_COMPONENTE`) y su consumo (`PC_ALIMENTACION_CONSUMO`); también productos sanitarios podrían modelarse como artículos de almacén en vez de un catálogo aparte, a decidir según si Sanidad ya maneja stock de vacunas en Almacén.
- **RRHH**: `cod_veterinario`/`cod_tecnico` en `PC_SANIDAD_EVENTO`, `PC_PARTO`, `PC_SERVICIO`, `PC_LABORATORIO` podrían ser FK a la tabla de empleados en vez de `CHAR(6)` libre, si el veterinario/inseminador es personal de planilla.
- **Contabilidad**: ver sección siguiente — activo biológico bajo NIC 41.

## 13. Contabilización — Activo biológico (NIC 41)

*(Sección preliminar; se ampliará con el detalle exacto de matriz contable / centros de costo / pre-asientos que ya existe en Activo Fijo — ver `README_ACTIVO_FIJO.md` y `README_CONTABILIDAD.md`.)*

Puntos clave ya confirmados en el sistema actual:

- El módulo de Activo Fijo **ya tiene el patrón de integración que necesitamos replicar**: una "Matriz Contable" por clase de activo (`AF_MATRIZ_CONTABLE`, define cuentas de activo, depreciación acumulada y gasto por combinación de tipo de activo + centro de costos), un cálculo periódico (`USP_AFI_DEPREC_ACUMULADA`) que distribuye por centro de costos, y una capa de "pre-asientos" (`CNTBL_PRE_ASIENTO`/`CNTBL_PRE_ASIENTO_DET`) que después se transfiere/consolida al libro diario oficial (`CNTBL_ASIENTO`/`CNTBL_ASIENTO_DET`). Actualmente esa generación automática de asientos está **deshabilitada** en Activo Fijo (transferencia manual) — es una decisión de negocio a confirmar si Pecuario la replica igual (con auto-post apagado) o se activa desde el inicio para este módulo nuevo.
- Bajo NIC 41, el ganado **no se deprecia** — se revalúa periódicamente a valor razonable menos costos de venta, y la variación va a resultados (no a una cuenta de depreciación acumulada). Esto significa que la "Matriz Contable" de Pecuario necesita conceptos distintos a los de Activo Fijo: en vez de (activo / depreciación acumulada / gasto por depreciación), sería algo como (activo biológico / ingreso o gasto por cambio en valor razonable).
- Hechos económicos que necesitan generar movimiento contable, análogos a los "conceptos" que ya usa Activo Fijo para sus matrices:
  1. **Alta** (nacimiento o compra, CAM440) — reconocimiento inicial del activo biológico.
  2. **Revaluación periódica** (proceso CAM904, mensual o anual) — ajuste a valor razonable, con contrapartida a resultados.
  3. **Baja por venta** (CAM454) — retiro del activo + reconocimiento de ingreso por venta.
  4. **Baja por muerte/descarte** (CAM454) — retiro del activo con pérdida.
  5. (Opcional) **Costeo de leche producida** — la leche es inventario (NIC 2), no activo biológico; en la cosecha (ordeño, CAM446) se reconoce como producto agrícola a valor razonable en el punto de cosecha.

## 14. Próximos pasos

1. Validar el diseño de tablas y la numeración de ventanas con el gerente de San Martín.
2. Confirmar con el contador el tratamiento contable exacto (cuentas, periodicidad de revaluación, si se activa auto-post o se deja manual como Activo Fijo).
3. Definir si se necesita un catálogo de **establos/corrales** además de `PC_POTRERO`, y si `PC_ANIMAL` lleva `cod_centro_costo` directo (pendiente de confirmación del usuario).
