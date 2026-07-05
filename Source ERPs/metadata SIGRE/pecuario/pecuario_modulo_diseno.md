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

Campo (caña) ya ocupa: `001–060` y `200–201` (Tablas), `301–390` y `412–434` (Operaciones), `700–715` y `752–758` (Reportes). **No se numera simplemente continuando después del último código usado**: se rellena el primer hueco contiguo lo bastante grande dentro de cada rango (ej. entre `CAM060` y `CAM200` hay un hueco de 139 números libres — ahí es donde va Pecuario, no después de `CAM201`):

| Tipo | Hueco usado (tamaño) | Bloque asignado a Pecuario |
|---|---|---|
| Tablas | `061`–`199` (139 libres) | `CAM061`–`CAM067` (7) |
| Operaciones | `391`–`411` (21 libres) | `CAM391`–`CAM405` (15) |
| Consultas | `500`–`699` (todo libre) | `CAM500`–`CAM505` (6) |
| Reportes | `716`–`751` (36 libres) | `CAM716`–`CAM722` (7) |
| Procesos | `900`–`999` (todo libre) | `CAM900`–`CAM905` (6) |

**Criterio de clasificación** (mismo que ya usa Activo Fijo en `README_ACTIVO_FIJO.md`): el maestro de cada *especimen individual* (ahí "Maestro de Activo Fijo", acá `PC_ANIMAL`) va en **Operaciones**, no en Tablas — porque es un registro vivo que crece todos los días, a diferencia de un catálogo de parametrización.

## 2. Objetivo y alcance

Llevar el control operativo, sanitario, reproductivo y productivo del hato ganadero de Agro Industrial San Martín (vacas y toros), y dejar la trazabilidad necesaria para SENASA (DTA) y una base de datos lista para integrarse a Contabilidad como activo biológico (NIC 41).

No reemplaza ni modifica el módulo Campo existente (caña): es un árbol de tablas nuevo (`PC_*`) y opciones de menú nuevas (usando los bloques de la tabla anterior) que solo comparten el concepto de `cod_origen` (fundo/sucursal) y el mismo prefijo de ventana con el resto de Campo.

## 3. Estructura de menú completa

| Menú Principal | Código | Ventana / Proceso | Tabla | Descripción |
|---|---|---|---|---|
| **TABLAS** | CAM061 | Razas | `PC_RAZA` | Razas bovinas (Holstein, Brown Swiss, Gyr, etc.) |
| TABLAS | CAM062 | Categorías | `PC_CATEGORIA` | Etapas del animal (ternero, vaquillona, novilla, vaca en producción/seca/descarte, toro) — viene precargada |
| TABLAS | CAM063 | Potreros | `PC_POTRERO` | Potreros de pastoreo por fundo, con capacidad de carga |
| TABLAS | CAM064 | Sementales | `PC_SEMENTAL` | Catálogo de sementales/pajillas para inseminación artificial |
| TABLAS | CAM065 | Productos sanitarios | `PC_PRODUCTO_SANITARIO` | Vacunas, desparasitantes, medicamentos, con período de retiro |
| TABLAS | CAM066 | Enfermedades | `PC_ENFERMEDAD` | Catálogo de enfermedades/diagnósticos |
| TABLAS | CAM067 | Dietas | `PC_DIETA` + `PC_DIETA_COMPONENTE` | Raciones por categoría, con insumos referenciados a `ARTICULO` (Almacén) |
| **OPERACIONES** | CAM391 | Maestro de animal | `PC_ANIMAL` | Alta y mantenimiento del hato (identificación, genealogía, categoría, ubicación) |
| OPERACIONES | CAM392 | Registro de celo | `PC_CELO` | Detección de celo (visual, podómetro/collar, hormonal) |
| OPERACIONES | CAM393 | Registro de servicio | `PC_SERVICIO` | Monta natural o inseminación artificial |
| OPERACIONES | CAM394 | Diagnóstico de preñez | `PC_DIAGNOSTICO_PRENEZ` | Confirmación/descarte de preñez (tacto rectal o ecografía) |
| OPERACIONES | CAM395 | Registro de parto | `PC_PARTO` | Parto, alta automática de la cría |
| OPERACIONES | CAM396 | Lactancia | `PC_LACTANCIA` | Apertura automática al parto; cierre (secado) manual |
| OPERACIONES | CAM397 | Ordeño diario | `PC_ORDENO` | Litros por turno (mañana/tarde/noche) |
| OPERACIONES | CAM398 | Control lechero | `PC_CONTROL_LECHERO` | Muestreo periódico de calidad (grasa, proteína, CCS) |
| OPERACIONES | CAM399 | Condición corporal | `PC_CONDICION_CORPORAL` | Evaluación BCS (escala 1-5) |
| OPERACIONES | CAM400 | Consumo de alimento | `PC_ALIMENTACION_CONSUMO` | Consumo diario de dieta por potrero/lote |
| OPERACIONES | CAM401 | Eventos sanitarios | `PC_SANIDAD_EVENTO` | Vacunas, desparasitaciones, tratamientos, diagnósticos |
| OPERACIONES | CAM402 | Muestras de laboratorio | `PC_LABORATORIO` + `PC_LABORATORIO_DET` | Toma de muestra y carga de resultados (sangre, leche, fecal, semen, tejido) |
| OPERACIONES | CAM403 | Movimiento de potrero | `PC_MOVIMIENTO_POTRERO` | Traslado/rotación de potreros |
| OPERACIONES | CAM404 | Documento de Tránsito Animal | `PC_DTA` + `PC_DTA_DETALLE` | Emisión de DTA para venta o traslado (SENASA) |
| OPERACIONES | CAM405 | Baja de animal | `PC_BAJA` | Venta, muerte o descarte; desactiva el animal (trigger) |
| **CONSULTAS** | CAM500 | Ficha del animal | — | Vista 360°: datos generales + genealogía + historial reproductivo + producción + sanidad |
| CONSULTAS | CAM501 | Historial reproductivo | — | Por animal o por rango de fechas (celos, servicios, diagnósticos, partos) |
| CONSULTAS | CAM502 | Producción de leche | — | Por animal, por potrero o por período |
| CONSULTAS | CAM503 | Calendario sanitario | — | Próximos refuerzos y fin de período de retiro vigente |
| CONSULTAS | CAM504 | Trazabilidad SENASA | — | DTA por animal |
| CONSULTAS | CAM505 | Resultados de laboratorio | — | Pendientes y con resultado, por animal o por tipo de muestra |
| **REPORTES** | CAM716 | Resumen del hato | — | Inventario de animales por categoría, potrero y estado reproductivo |
| REPORTES | CAM717 | Indicadores reproductivos | — | Intervalo entre partos, días abiertos, tasa de preñez, % distocias |
| REPORTES | CAM718 | Producción de leche | — | Mensual, consolidado y por vaca |
| REPORTES | CAM719 | Control lechero | — | Calidad de leche (grasa/proteína/CCS) por período |
| REPORTES | CAM720 | Costos de alimentación | — | Por potrero/categoría, cruzando `PC_ALIMENTACION_CONSUMO` con costo de `ARTICULO` |
| REPORTES | CAM721 | Sanitario | — | Vacunas aplicadas, próximos vencimientos, período de retiro vigente |
| REPORTES | CAM722 | Bajas del período | — | Ventas, muertes y descartes |
| **PROCESOS** | CAM900 | Recategorización automática | — | Recalcula `PC_ANIMAL.cod_categoria` según edad y estado reproductivo |
| PROCESOS | CAM901 | Actualización de estado reproductivo | — | Recalcula `PC_ANIMAL.flag_estado_repro` según el último evento (celo/servicio/diagnóstico/parto) |
| PROCESOS | CAM902 | Cierre automático de lactancia | — | Marca `fec_secado` cuando se alcanza la fecha proyectada |
| PROCESOS | CAM903 | Recálculo de litros de lactancia | — | Recalcula `PC_LACTANCIA.litros_totales` sumando `PC_ORDENO` |
| PROCESOS | CAM904 | Revaluación NIC 41 | — | Ajuste periódico a valor razonable del activo biológico (ver sección 12) |
| PROCESOS | CAM905 | Cálculo de vencimientos sanitarios | — | Recalcula `fec_prox_refuerzo` y `fec_fin_retiro` en `PC_SANIDAD_EVENTO` |

## 4. Catálogos maestros (CAM061–CAM067)

Estas tablas se configuran una sola vez (o rara vez) antes de operar: `PC_RAZA`, `PC_CATEGORIA` (viene precargada con ternero/vaquillona/novilla/vaca en producción-seca-descarte/toro), `PC_POTRERO`, `PC_SEMENTAL`, `PC_PRODUCTO_SANITARIO`, `PC_ENFERMEDAD`, `PC_DIETA` + `PC_DIETA_COMPONENTE`.

## 5. Maestro de animal — CAM391 (`PC_ANIMAL`)

Ventana tabular tipo maestro (similar a un maestro de artículo, pero clasificada como Operación porque el registro crece todos los días). Cada fila es un animal individual identificado por su arete/chapa (`cod_animal`). Captura: raza, sexo, fecha de nacimiento, genealogía (padre/madre, propios o por IA), categoría actual, potrero actual, procedencia (nacido en el predio vs. comprado), peso de nacimiento y peso actual.

El campo `flag_estado_repro` (vacía / servida / preñada / recién parida) se mantiene desnormalizado en el maestro para que la ficha del animal (CAM500, la pantalla que más va a usar el vaquero/mayordomo a diario) no tenga que hacer joins contra `PC_SERVICIO`/`PC_PARTO` cada vez — se actualiza por el proceso batch CAM901 cuando ocurre un evento reproductivo.

La recategorización (ternero → vaquillona → novilla → vaca) es el proceso batch CAM900, que evalúa edad y estado reproductivo contra `PC_CATEGORIA.edad_min_meses/edad_max_meses`, en vez de que el usuario la cambie manualmente.

## 6. Reproducción (CAM392–CAM395)

Flujo secuencial: **celo (CAM392) → servicio (CAM393) → diagnóstico de preñez (CAM394) → parto (CAM395)**.

- `PC_CELO`: registro de detección de celo (visual, podómetro/collar, hormonal). Es el disparador para decidir un servicio.
- `PC_SERVICIO`: monta natural (con toro propio, `cod_animal_toro`) o inseminación artificial (con `cod_semental` del catálogo). Calcula `fec_prob_parto` = `fec_servicio` + 283 días.
- `PC_DIAGNOSTICO_PRENEZ`: confirma o descarta el servicio (tacto rectal o ecografía, a los 30-60-90 días). Si el resultado es "vacía", el animal vuelve a flag_estado_repro = 0 y reinicia el ciclo.
- `PC_PARTO`: cierra el ciclo. Registra tipo de parto (eutócico/distócico), asistencia, retención de placenta, y **da de alta a la cría como un nuevo `PC_ANIMAL`** (vínculo `cod_animal_cria`) — este es el punto de entrada natural de un animal nacido en el predio al sistema.

Los indicadores (intervalo entre partos, días abiertos, tasa de preñez por servicio, % distocias) no necesitan tablas adicionales: se calculan en el reporte CAM717.

## 7. Producción de leche (CAM396–CAM398)

- `PC_LACTANCIA` (CAM396): se abre automáticamente al registrar un parto de una hembra (un registro por lactancia, no por vaca). Se cierra (`fec_secado`) por el proceso batch CAM902 cuando se alcanza la fecha proyectada (~60 días antes del próximo parto esperado), o manualmente si el usuario decide secar antes.
- `PC_ORDENO` (CAM397): el detalle diario, hasta 3 turnos (mañana/tarde/noche). Es la tabla de mayor volumen del módulo — pensar en un proceso de carga rápida (grilla por potrero/establo con foco en litros, no formulario campo por campo).
- `PC_CONTROL_LECHERO` (CAM398): muestreo periódico (no diario) de calidad — % grasa, % proteína, células somáticas (CCS). Sirve para detectar mastitis subclínica antes de que sea evidente en el ordeño.

`PC_LACTANCIA.litros_totales` se recalcula con el proceso batch CAM903 (columna denormalizada por performance de reporte, igual criterio que `flag_estado_repro`).

## 8. Nutrición y alimentación (CAM399–CAM400)

- `PC_CONDICION_CORPORAL` (CAM399): historial de evaluaciones de condición corporal (BCS, escala 1-5) por animal — indicador rápido de si la dieta está funcionando, sin depender de pesajes.
- `PC_ALIMENTACION_CONSUMO` (CAM400): registra consumo diario **por potrero/lote**, no por animal individual (no es práctico pesar la comida de cada vaca) — se carga `cabezas_lote` (cuántos animales comieron esa dieta ese día) y el sistema puede sacar un costo por cabeza dividiendo (reporte CAM720). La dieta (`PC_DIETA`) y sus componentes (`PC_DIETA_COMPONENTE`) están parametrizados contra `ARTICULO`, así que este consumo puede generar una salida de almacén (egreso de forraje/concentrado) igual que cualquier otro consumo interno — este es el punto de integración natural con Almacén.

## 9. Sanidad (CAM401)

`PC_SANIDAD_EVENTO` es una tabla única para vacunas, desparasitaciones, tratamientos y diagnósticos (discriminada por `flag_tipo_evento`), en vez de 4 tablas separadas — simplifica el calendario sanitario (consulta CAM503, ordenada por `fec_prox_refuerzo`, recalculado por el proceso batch CAM905) y el control de período de retiro (`fec_fin_retiro`), que debe cruzarse contra `PC_ORDENO.flag_descarte` para no vender leche de un animal en tratamiento.

## 10. Resultados de laboratorio (CAM402)

Parte que faltaba en el primer diseño: los eventos sanitarios (`PC_SANIDAD_EVENTO`) registran que "se hizo" un diagnóstico o análisis, pero no el **detalle del resultado del laboratorio** (valores, unidades, rango de referencia, interpretación) — necesario tanto para exámenes veterinarios (serología de brucelosis/IBR-BVD, coprológico/huevos por gramo, perfil metabólico) como para control de calidad de semen de los sementales propios.

- `PC_LABORATORIO`: cabecera de la muestra — animal (opcional, nullable: una muestra de semen de `PC_SEMENTAL` o de forraje/agua no siempre es de un animal puntual), tipo de muestra (`flag_tipo_muestra`: Sangre/Leche/Fecal/Semen/Tejido/Otro), laboratorio externo, veterinario que tomó la muestra, fecha de toma y de resultado, estado (pendiente/con resultado). Enlace opcional a `PC_SANIDAD_EVENTO` cuando el examen es parte de un evento sanitario ya registrado.
- `PC_LABORATORIO_DET`: detalle — un examen de laboratorio suele traer varios parámetros en un solo resultado (ej. un perfil metabólico trae calcio, magnesio, glucosa), así que es una tabla de líneas: parámetro/analito, valor (texto, para poder guardar tanto "Positivo/Negativo" como valores numéricos), unidad de medida, rango de referencia mínimo/máximo, e interpretación (Normal/Alterado).

Este resultado es el que finalmente confirma o descarta lo que `PC_DIAGNOSTICO_PRENEZ` o `PC_SANIDAD_EVENTO` ya adelantaron de forma operativa (ej. tacto rectal vs. confirmación por laboratorio de progesterona). Consulta asociada: CAM505.

## 11. Movimientos, trazabilidad y bajas (CAM403–CAM405)

- `PC_MOVIMIENTO_POTRERO` (CAM403): histórico de rotación de potreros (pastoreo rotativo).
- `PC_DTA` + `PC_DTA_DETALLE` (CAM404): Documento de Tránsito Animal exigido por SENASA para vender o trasladar animales fuera del predio. Un DTA agrupa uno o varios animales (`PC_DTA_DETALLE`). Consulta de trazabilidad: CAM504.
- `PC_BAJA` (CAM405): cierre del ciclo de vida del animal (venta, muerte, descarte). Un trigger (`TRG_PC_BAJA_AI`) desactiva automáticamente el animal en `PC_ANIMAL` al insertar la baja. Si la baja es por venta, referencia el DTA correspondiente. Reporte: CAM722.

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
  1. **Alta** (nacimiento o compra, CAM391) — reconocimiento inicial del activo biológico.
  2. **Revaluación periódica** (proceso CAM904, mensual o anual) — ajuste a valor razonable, con contrapartida a resultados.
  3. **Baja por venta** (CAM405) — retiro del activo + reconocimiento de ingreso por venta.
  4. **Baja por muerte/descarte** (CAM405) — retiro del activo con pérdida.
  5. (Opcional) **Costeo de leche producida** — la leche es inventario (NIC 2), no activo biológico; en la cosecha (ordeño, CAM397) se reconoce como producto agrícola a valor razonable en el punto de cosecha.

## 14. Diccionario de datos

Detalle columna por columna de cada tabla (fuente de verdad: `pecuario_ddl_san_martin.sql`, que además trae todo esto como `comment on column`). "Null" = admite nulo.

### Catálogos

#### `PC_RAZA` — Razas bovinas
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_raza` | CHAR(4) | PK | Código de raza |
| `nom_raza` | VARCHAR2(60) | No | Nombre de la raza |
| `flag_tipo` | CHAR(1) | No | L=Lechera, C=Carne, M=Doble propósito |
| `flag_estado` | CHAR(1) | No | 1=Activo, 0=Inactivo |

#### `PC_POTRERO` — Potreros de pastoreo
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen` | CHAR(2) | PK | Fundo/sucursal |
| `cod_potrero` | CHAR(6) | PK | Código de potrero |
| `nom_potrero` | VARCHAR2(80) | No | Nombre del potrero |
| `area_has` | NUMBER(8,2) | Sí | Área en hectáreas |
| `tipo_pasto` | VARCHAR2(60) | Sí | Tipo de pasto sembrado |
| `capacidad_cab` | NUMBER(6) | Sí | Capacidad de carga en cabezas |
| `flag_estado` | CHAR(1) | No | 1=Activo, 0=Inactivo |

#### `PC_CATEGORIA` — Etapas del animal
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_categoria` | CHAR(3) | PK | TER, VAQ, NOV, VPR, VSC, VDE, TOR, TDE |
| `nom_categoria` | VARCHAR2(60) | No | Nombre de la categoría |
| `flag_sexo` | CHAR(1) | Sí | M/H, null si aplica a ambos |
| `edad_min_meses` | NUMBER(4) | Sí | Edad mínima en meses |
| `edad_max_meses` | NUMBER(4) | Sí | Edad máxima en meses |
| `flag_estado` | CHAR(1) | No | 1=Activo, 0=Inactivo |

#### `PC_SEMENTAL` — Catálogo de sementales/pajillas (IA)
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_semental` | CHAR(10) | PK | Código del semental/pajilla |
| `nom_semental` | VARCHAR2(80) | No | Nombre del semental |
| `cod_raza` | CHAR(4) | No | FK → `PC_RAZA` |
| `proveedor` | VARCHAR2(100) | Sí | Central de inseminación / proveedor |
| `registro_genet` | VARCHAR2(40) | Sí | Registro genealógico / código de catálogo |
| `flag_estado` | CHAR(1) | No | 1=Activo, 0=Inactivo |

#### `PC_PRODUCTO_SANITARIO` — Vacunas, medicamentos, insumos veterinarios
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_prod_san` | CHAR(10) | PK | Código de producto sanitario |
| `nom_producto` | VARCHAR2(100) | No | Nombre del producto |
| `flag_tipo` | CHAR(1) | No | V=Vacuna, D=Desparasitante, M=Medicamento, S=Suplemento |
| `dias_refuerzo` | NUMBER(4) | Sí | Días hasta la próxima dosis de refuerzo |
| `periodo_retiro` | NUMBER(3) | Sí | Días de retiro de leche/carne tras aplicar |
| `unidad_medida` | CHAR(3) | Sí | Unidad de medida de la dosis |
| `flag_estado` | CHAR(1) | No | 1=Activo, 0=Inactivo |

#### `PC_ENFERMEDAD` — Enfermedades/diagnósticos
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_enfermedad` | CHAR(6) | PK | Código de enfermedad |
| `nom_enfermedad` | VARCHAR2(100) | No | Nombre de la enfermedad |
| `flag_reproductiva` | CHAR(1) | Sí | 1 si afecta el ciclo reproductivo |
| `flag_estado` | CHAR(1) | No | 1=Activo, 0=Inactivo |

#### `PC_DIETA` / `PC_DIETA_COMPONENTE` — Raciones por categoría
| Tabla | Columna | Tipo | Null | Descripción |
|---|---|---|---|---|
| `PC_DIETA` | `cod_dieta` | CHAR(6) | PK | Código de dieta |
| `PC_DIETA` | `nom_dieta` | VARCHAR2(80) | No | Nombre de la dieta |
| `PC_DIETA` | `cod_categoria` | CHAR(3) | No | FK → `PC_CATEGORIA` |
| `PC_DIETA` | `costo_kg_prom` | NUMBER(10,4) | Sí | Costo promedio por kg |
| `PC_DIETA` | `flag_estado` | CHAR(1) | No | 1=Activo, 0=Inactivo |
| `PC_DIETA_COMPONENTE` | `cod_dieta` | CHAR(6) | PK | FK → `PC_DIETA` |
| `PC_DIETA_COMPONENTE` | `item` | NUMBER(3) | PK | Correlativo |
| `PC_DIETA_COMPONENTE` | `cod_art` | CHAR(12) | No | FK → `ARTICULO` (Almacén) |
| `PC_DIETA_COMPONENTE` | `cantidad_kg` | NUMBER(8,3) | No | Cantidad en kg por animal/día |
| `PC_DIETA_COMPONENTE` | `flag_estado` | CHAR(1) | No | 1=Activo, 0=Inactivo |

### Maestro de animal

#### `PC_ANIMAL` — Ganado individual
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen` | CHAR(2) | PK | Fundo/sucursal |
| `cod_animal` | CHAR(12) | PK | Arete/chapa oficial |
| `nom_animal` | VARCHAR2(60) | Sí | Apodo, opcional |
| `cod_raza` | CHAR(4) | No | FK → `PC_RAZA` |
| `flag_sexo` | CHAR(1) | No | M=Macho, H=Hembra |
| `fec_nacimiento` | DATE | No | Fecha de nacimiento |
| `cod_animal_padre` | CHAR(12) | Sí | FK genealogía (auto-referencia) — padre, si es del hato |
| `cod_animal_madre` | CHAR(12) | Sí | FK genealogía (auto-referencia) — madre, si es del hato |
| `cod_semental_padre` | CHAR(10) | Sí | FK → `PC_SEMENTAL`, si el padre fue por IA |
| `color` | VARCHAR2(40) | Sí | Color/marcas distintivas |
| `cod_categoria` | CHAR(3) | No | FK → `PC_CATEGORIA`, recalculada por el proceso CAM900 |
| `cod_potrero` | CHAR(6) | No | FK → `PC_POTRERO`, ubicación actual |
| `flag_estado_repro` | CHAR(1) | Sí | 0=vacía, 1=servida, 2=preñada, 3=recién parida; recalculado por CAM901 |
| `peso_nacimiento` | NUMBER(6,2) | Sí | Peso al nacer, kg |
| `peso_actual` | NUMBER(6,2) | Sí | Último peso registrado, kg |
| `fec_ult_pesaje` | DATE | Sí | Fecha del último pesaje |
| `cod_procedencia` | CHAR(1) | No | P=Nacido en el predio, C=Comprado |
| `fec_ingreso` | DATE | No | Fecha de alta al hato |
| `precio_compra` | NUMBER(12,2) | Sí | Precio de compra, para costeo/NIC 41 |
| `flag_estado` | CHAR(1) | No | 1=Activo en el hato, 0=de baja |
| `cod_usr` | CHAR(6) | Sí | Usuario que registró |
| `fec_registro` | DATE | No | Fecha de registro en el sistema |

### Reproducción

#### `PC_CELO`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen` | CHAR(2) | PK | Fundo/sucursal |
| `cod_animal` | CHAR(12) | PK | FK → `PC_ANIMAL` |
| `fec_celo` | DATE | PK | Fecha de detección |
| `hora_deteccion` | DATE | Sí | Hora exacta |
| `metodo_deteccion` | CHAR(1) | Sí | V=Visual, P=Podómetro/collar, H=Hormonal |
| `flag_servido` | CHAR(1) | Sí | 1 si este celo derivó en un servicio |
| `cod_usr` / `fec_registro` | CHAR(6) / DATE | Sí / No | Auditoría |

#### `PC_SERVICIO`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_animal` | CHAR(2), CHAR(12) | PK | Hembra servida |
| `nro_servicio` | NUMBER(3) | PK | Correlativo por animal |
| `fec_servicio` | DATE | No | Fecha del servicio |
| `flag_tipo_servicio` | CHAR(1) | No | N=Monta natural, I=Inseminación artificial |
| `cod_animal_toro` | CHAR(12) | Sí | FK → `PC_ANIMAL`, si monta natural |
| `cod_semental` | CHAR(10) | Sí | FK → `PC_SEMENTAL`, si IA |
| `cod_tecnico` | CHAR(6) | Sí | Responsable de la inseminación |
| `fec_prob_parto` | DATE | Sí | `fec_servicio` + 283 días |
| `flag_estado` | CHAR(1) | No | 1=Vigente, 0=Anulado (repitió celo) |
| `cod_usr` / `fec_registro` | CHAR(6) / DATE | Sí / No | Auditoría |

#### `PC_DIAGNOSTICO_PRENEZ`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_animal`, `nro_servicio` | — | PK/FK | FK → `PC_SERVICIO` |
| `fec_diagnostico` | DATE | PK | Fecha del diagnóstico |
| `metodo` | CHAR(1) | Sí | T=Tacto rectal, E=Ecografía |
| `resultado` | CHAR(1) | No | P=Preñada, V=Vacía |
| `dias_gestacion` | NUMBER(3) | Sí | Días de gestación calculados |
| `cod_veterinario` | CHAR(6) | Sí | Veterinario responsable |
| `cod_usr` / `fec_registro` | CHAR(6) / DATE | Sí / No | Auditoría |

#### `PC_PARTO`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_animal` | — | PK | Madre |
| `fec_parto` | DATE | PK | Fecha del parto |
| `nro_servicio` | NUMBER(3) | Sí | FK → `PC_SERVICIO` que originó el parto |
| `flag_tipo_parto` | CHAR(1) | Sí | E=Eutócico, D=Distócico |
| `flag_asistido` | CHAR(1) | Sí | 1=Parto asistido |
| `cod_animal_cria` | CHAR(12) | Sí | FK → `PC_ANIMAL`, la cría recién nacida |
| `sexo_cria` | CHAR(1) | Sí | Sexo de la cría |
| `peso_cria` | NUMBER(6,2) | Sí | Peso al nacer, kg |
| `flag_cria_viva` | CHAR(1) | Sí | 1=Viva, 0=Nació muerta |
| `flag_retencion_placenta` | CHAR(1) | Sí | 1=Hubo retención |
| `observaciones` | VARCHAR2(500) | Sí | Observaciones del parto |
| `cod_veterinario` / `cod_usr` / `fec_registro` | — | Sí / Sí / No | Auditoría |

### Producción de leche

#### `PC_LACTANCIA`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_animal` | — | PK | Vaca |
| `nro_lactancia` | NUMBER(2) | PK | Correlativo (1ra, 2da…) |
| `fec_parto` | DATE | No | FK → `PC_PARTO` que abrió la lactancia |
| `fec_secado` | DATE | Sí | Cierre de la lactancia |
| `dias_lactancia` | NUMBER(4) | Sí | Calculado al secar |
| `litros_totales` | NUMBER(10,2) | Sí | Recalculado desde `PC_ORDENO` (proceso CAM903) |
| `flag_estado` | CHAR(1) | No | 1=En curso, 0=Cerrada |
| `cod_usr` / `fec_registro` | — | Sí / No | Auditoría |

#### `PC_ORDENO`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_animal` | — | PK | Vaca ordeñada |
| `fec_ordeno` | DATE | PK | Fecha del ordeño |
| `nro_turno` | NUMBER(1) | PK | 1=Mañana, 2=Tarde, 3=Noche |
| `litros` | NUMBER(6,2) | No | Litros obtenidos |
| `flag_descarte` | CHAR(1) | Sí | 1 si la leche no se vende (retiro por medicamento) |
| `cod_usr` / `fec_registro` | — | Sí / No | Auditoría |

#### `PC_CONTROL_LECHERO`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_animal` | — | PK | Vaca controlada |
| `fec_control` | DATE | PK | Fecha del muestreo |
| `porc_grasa` | NUMBER(4,2) | Sí | % de grasa |
| `porc_proteina` | NUMBER(4,2) | Sí | % de proteína |
| `celulas_somaticas` | NUMBER(10) | Sí | CCS/SCC, células/ml |
| `litros_dia_proy` | NUMBER(6,2) | Sí | Litros/día proyectados |
| `cod_usr` / `fec_registro` | — | Sí / No | Auditoría |

### Nutrición

#### `PC_CONDICION_CORPORAL`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_animal` | — | PK | Animal evaluado |
| `fec_evaluacion` | DATE | PK | Fecha de evaluación |
| `puntaje_bcs` | NUMBER(2,1) | No | Escala 1.0–5.0 |
| `cod_usr` / `fec_registro` | — | Sí / No | Auditoría |

#### `PC_ALIMENTACION_CONSUMO`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_potrero` | — | PK/FK | Potrero/lote |
| `fec_consumo` | DATE | PK | Fecha del consumo |
| `cod_dieta` | CHAR(6) | PK/FK | Dieta aplicada |
| `cabezas_lote` | NUMBER(5) | No | Animales que comieron esa dieta ese día |
| `cod_art` | CHAR(12) | PK/FK | FK → `ARTICULO`, insumo consumido |
| `cantidad_kg` | NUMBER(10,3) | No | Cantidad total consumida, kg |
| `costo_total` | NUMBER(12,2) | Sí | Costo total, para costeo (reporte CAM720) |
| `cod_usr` / `fec_registro` | — | Sí / No | Auditoría |

### Sanidad

#### `PC_SANIDAD_EVENTO`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_animal` | — | PK | Animal atendido |
| `nro_evento` | NUMBER(5) | PK | Correlativo por animal |
| `fec_evento` | DATE | No | Fecha del evento |
| `flag_tipo_evento` | CHAR(1) | No | V=Vacuna, D=Desparasitación, T=Tratamiento, X=Diagnóstico |
| `cod_prod_san` | CHAR(10) | Sí | FK → `PC_PRODUCTO_SANITARIO` |
| `dosis` | NUMBER(8,3) | Sí | Dosis aplicada |
| `cod_enfermedad` | CHAR(6) | Sí | FK → `PC_ENFERMEDAD` |
| `cod_veterinario` | CHAR(6) | Sí | Veterinario responsable |
| `costo` | NUMBER(10,2) | Sí | Costo del evento |
| `fec_prox_refuerzo` | DATE | Sí | Calculado por CAM905 según `dias_refuerzo` del producto |
| `fec_fin_retiro` | DATE | Sí | Calculado por CAM905 según `periodo_retiro` del producto |
| `observaciones` | VARCHAR2(500) | Sí | Observaciones |
| `cod_usr` / `fec_registro` | — | Sí / No | Auditoría |

### Resultados de laboratorio

#### `PC_LABORATORIO`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `nro_muestra` | CHAR(12) | PK | Número de muestra |
| `cod_origen` | CHAR(2) | No | Fundo/sucursal |
| `cod_animal` | CHAR(12) | Sí | FK → `PC_ANIMAL` (nulo si no aplica a un animal puntual) |
| `cod_semental` | CHAR(10) | Sí | FK → `PC_SEMENTAL`, si es control de calidad de semen |
| `fec_muestra` | DATE | No | Fecha de toma |
| `flag_tipo_muestra` | CHAR(1) | No | S=Sangre, L=Leche, F=Fecal, M=Semen, T=Tejido, O=Otro |
| `laboratorio` | VARCHAR2(100) | Sí | Laboratorio externo |
| `cod_veterinario` | CHAR(6) | Sí | Quien tomó la muestra |
| `nro_evento` | NUMBER(5) | Sí | FK opcional → `PC_SANIDAD_EVENTO` |
| `fec_resultado` | DATE | Sí | Fecha de entrega del resultado |
| `flag_estado` | CHAR(1) | No | 0=Anulada, 1=Pendiente, 2=Con resultado |
| `observaciones` | VARCHAR2(500) | Sí | Observaciones |
| `cod_usr` / `fec_registro` | — | Sí / No | Auditoría |

#### `PC_LABORATORIO_DET`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `nro_muestra` | CHAR(12) | PK/FK | Muestra a la que pertenece |
| `item` | NUMBER(3) | PK | Correlativo |
| `parametro` | VARCHAR2(100) | No | Nombre del analito (ej. "Brucelosis - ELISA") |
| `valor_resultado` | VARCHAR2(60) | Sí | Texto (admite cualitativo o numérico) |
| `unidad_medida` | VARCHAR2(20) | Sí | Unidad, si es numérico |
| `valor_ref_min` / `valor_ref_max` | NUMBER(12,4) | Sí | Rango de referencia |
| `flag_interpretacion` | CHAR(1) | Sí | N=Normal, A=Alterado |

### Movimientos, trazabilidad y bajas

#### `PC_MOVIMIENTO_POTRERO`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_animal` | — | PK | Animal movido |
| `fec_movimiento` | DATE | PK | Fecha del movimiento |
| `cod_potrero_origen` | CHAR(6) | Sí | FK → `PC_POTRERO` |
| `cod_potrero_destino` | CHAR(6) | No | FK → `PC_POTRERO` |
| `motivo` | VARCHAR2(200) | Sí | Motivo del movimiento |
| `cod_usr` / `fec_registro` | — | Sí / No | Auditoría |

#### `PC_DTA` / `PC_DTA_DETALLE`
| Tabla | Columna | Tipo | Null | Descripción |
|---|---|---|---|---|
| `PC_DTA` | `nro_dta` | CHAR(15) | PK | Número de DTA |
| `PC_DTA` | `fec_emision` | DATE | No | Fecha de emisión |
| `PC_DTA` | `cod_origen_fundo` | CHAR(2) | No | Fundo de origen |
| `PC_DTA` | `cod_destino_fundo` | CHAR(2) | Sí | Fundo de destino, si traslado interno |
| `PC_DTA` | `razon_social_destino` | VARCHAR2(150) | Sí | Razón social del destino, si venta |
| `PC_DTA` | `motivo` | CHAR(1) | No | V=Venta, T=Traslado interno, F=Feria/exposición |
| `PC_DTA` | `flag_estado` | CHAR(1) | No | 1=Activo, 0=Anulado |
| `PC_DTA_DETALLE` | `nro_dta` | CHAR(15) | PK/FK | DTA al que pertenece |
| `PC_DTA_DETALLE` | `item` | NUMBER(4) | PK | Correlativo |
| `PC_DTA_DETALLE` | `cod_origen`, `cod_animal` | — | FK | Animal incluido en el traslado |

#### `PC_BAJA`
| Columna | Tipo | Null | Descripción |
|---|---|---|---|
| `cod_origen`, `cod_animal` | — | PK/FK | Animal dado de baja |
| `fec_baja` | DATE | No | Fecha de la baja |
| `flag_motivo` | CHAR(1) | No | V=Venta, M=Muerte, D=Descarte |
| `causa_muerte` | VARCHAR2(200) | Sí | Si `flag_motivo`=M |
| `precio_venta` | NUMBER(12,2) | Sí | Si `flag_motivo`=V |
| `nro_dta` | CHAR(15) | Sí | FK → `PC_DTA`, si implicó traslado |
| `observaciones` | VARCHAR2(300) | Sí | Observaciones de la baja |
| `cod_usr` / `fec_registro` | — | Sí / No | Auditoría |

## 15. Data inicial y de prueba (incluida en el script SQL)

**Catálogos de referencia** (datos reales, para producción — se insertan siempre):
- `PC_CATEGORIA`: las 8 categorías del ciclo de vida (TER, VAQ, NOV, VPR, VSC, VDE, TOR, TDE).
- `PC_RAZA`: 7 razas comunes en Perú (Holstein, Jersey, Brown Swiss, Gyr, Brahman, Angus, Cruzado).
- `PC_PRODUCTO_SANITARIO`: calendario sanitario base (aftosa, brucelosis, carbunco/clostridiales, rabia, IBR-BVD, leptospirosis, desparasitantes interno/externo, antibiótico intramamario, antiinflamatorio, sales minerales), con `dias_refuerzo` y `periodo_retiro` ya cargados.
- `PC_ENFERMEDAD`: 12 enfermedades comunes (mastitis, hipocalcemia, cetosis, cojera, neumonía/diarrea de terneros, brucelosis, IBR/BVD, leptospirosis, metritis, retención de placenta, distocia).

**Data de prueba (demo, sección 9 del script — no usar en producción)**: un escenario encadenado con `cod_origen = '01'`, pensado para poder probar cada pantalla de punta a punta sin tener que cargar todo a mano:

| Animal | Categoría | Historia que ilustra |
|---|---|---|
| `ANI000000001` "Paloma" | Vaca en producción | Ciclo reproductivo completo (servicio natural → diagnóstico → parto), lactancia abierta con 3 días de ordeño y un control lechero |
| `ANI000000002` "Luna" | Vaca en producción | Ciclo reproductivo en curso (celo → servicio por IA con el semental del catálogo → diagnóstico positivo, sin parto todavía) |
| `ANI000000003` "Bravo" | Toro reproductor | Padre por monta natural de la cría de Paloma |
| `ANI000000004` (cría de Paloma) | Ternero(a) | Alta automática vía `PC_PARTO.cod_animal_cria`, con genealogía completa (padre y madre) |
| `ANI000000005` "Estrella" | Vaca de descarte | Ciclo de vida completo: diagnóstico de mastitis → muestra de laboratorio con resultado alterado → movimiento de potrero (aislamiento) → venta con DTA → baja |

También incluye: 2 potreros, 1 semental, 1 dieta con su componente (referencia a `ARTICULO` — **ajustar el `cod_art` placeholder antes de ejecutar esa parte**), y una muestra de calidad de semen del semental.

## 16. Próximos pasos

1. Validar el diseño de tablas y la numeración de ventanas con el gerente de San Martín.
2. Confirmar con el contador el tratamiento contable exacto (cuentas, periodicidad de revaluación, si se activa auto-post o se deja manual como Activo Fijo).
3. Definir si se necesita un catálogo de **establos/corrales** además de `PC_POTRERO`, y si `PC_ANIMAL` lleva `cod_centro_costo` directo (pendiente de confirmación del usuario).
