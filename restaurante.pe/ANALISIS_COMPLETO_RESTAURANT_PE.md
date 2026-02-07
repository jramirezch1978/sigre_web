# Análisis Completo del Proyecto Restaurant.pe - Sistema ERP

> **Documento generado automáticamente** a partir del análisis de 204 Historias de Usuario (HUs)
> **Total de documentación analizada:** 204 documentos (1316 KB de texto)
> **Módulos identificados:** 8

---

## 1. Resumen Ejecutivo

**Restaurant.pe** es un sistema ERP (Enterprise Resource Planning) integral diseñado específicamente para la industria gastronómica y de restaurantes, con capacidad de operación **multipaís** (Perú, Colombia, Chile, República Dominicana, entre otros), **multiempresa** (varias razones sociales) y **multisucursal**.

El sistema busca centralizar y automatizar todos los procesos operativos, financieros, contables y de gestión humana de cadenas de restaurantes y franquicias, reemplazando sistemas fragmentados por una plataforma unificada.

### Características Transversales Identificadas

A lo largo de todas las HUs se identifican las siguientes características que son **transversales** a todo el sistema:

| Característica | Descripción |
|---|---|
| **Multipaís** | Soporte para diferentes normativas fiscales, tributarias y laborales por país |
| **Multiempresa** | Múltiples razones sociales operando en el mismo sistema |
| **Multisucursal** | Gestión por locales/sucursales con consolidación corporativa |
| **Multimoneda** | Operaciones en diferentes monedas con tipo de cambio |
| **Auditoría completa** | Log de auditoría contable en todas las operaciones (usuario, fecha, hora, IP, acción) |
| **Integración contable** | Todos los módulos generan pre-asientos o asientos contables |
| **Control de permisos** | Roles y perfiles de usuario granulares |
| **Exportación** | Exportación a Excel/PDF en todos los reportes y listados |
| **Carga masiva** | Importación de datos vía Excel con validaciones |

### Estado General del Proyecto

Se identificaron **278 funcionalidades** distribuidas en los siguientes estados:

| Estado | Cantidad | Porcentaje |
|---|---|---|
| Por construir | 141 | 50.7% |
| Completo | 74 | 26.6% |
| Parcialmente | 31 | 11.2% |
| Sin estado | 18 | 6.5% |
| Datos Generales | 1 | 0.4% |
| Compañía | 1 | 0.4% |
| Sucursales | 1 | 0.4% |
| Transacciones entre empresas | 1 | 0.4% |
| Impuestos | 1 | 0.4% |
| Retenciones | 1 | 0.4% |
| Monedas | 1 | 0.4% |
| Tipo de Cambio | 1 | 0.4% |
| Ejercicios y Periodos | 1 | 0.4% |
| Usuarios | 1 | 0.4% |
| Restaurant.pe (POS) | 1 | 0.4% |
| Bitácora de Integración | 1 | 0.4% |
| Recordatorios | 1 | 0.4% |
| Alertas del Sistema | 1 | 0.4% |
| **Total** | **278** | **100%** |

### Distribución por Módulo

| Módulo | Funcionalidades | HUs Documentadas | Completo | Parcial | Por Construir |
|---|---|---|---|---|---|
| Almacén | 27 | 28 | 20 | 4 | 3 |
| Compras | 17 | 17 | 12 | 4 | 1 |
| Ventas | 19 | 2 | 17 | 1 | 1 |
| Finanzas | 45 | 41 | 12 | 5 | 25 |
| Contabilidad | 37 | 35 | 1 | 2 | 30 |
| Activos Fijos | 28 | 27 | 0 | 0 | 27 |
| Recursos Humanos | - | 42 | - | - | - |
| Producción | 42 | 0 | 11 | 7 | 23 |
| Configuraciones | 21 | 12 | 0 | 0 | 0 |

---

## 2. Análisis Detallado por Módulo

### 2.1. Módulo de Almacén

> **Gestión integral de inventarios, stock, movimientos y valorización de productos**
> 
> HUs documentadas: **28** | Carpeta: `01_Almacen/`

#### Listado de Historias de Usuario

| # | Archivo | Título | Descripción resumida |
|---|---|---|---|
| 1 | `HU-ALM-CON-ART-001.txt` | ﻿HU-ALM-CON-ART-001 - Consulta de Información Completa del Producto e Imagen Ref | Como usuario del sistema Restaurant.pe, quiero consultar toda la información registrada de un producto, incluyendo sus d... |
| 2 | `HU-ALM-CON-DEV-001.txt` | ﻿HU-ALM-CON-DEV-001 - Consulta del Detalle de Devoluciones Realizadas a Proveedo | Como usuario del sistema Restaurant.pe, quiero visualizar el detalle de todas las devoluciones realizadas a proveedores,... |
| 3 | `HU-ALM-CON-KDX-001.txt` | ﻿HU-ALM-CON-KDX-001 - Consulta de Stock por Producto y Almacén con Movimiento en | Como usuario del sistema Restaurant.pe, quiero consultar el stock actual de los productos por almacén, así como los movi... |
| 4 | `HU-ALM-CON-OC-001.txt` | ﻿HU-ALM-CON-OC-001 - Consulta de Órdenes de Compra Pendientes - v1.0 | Como usuario del sistema Restaurant.pe, quiero consultar todas las órdenes de compra pendientes de recepción o facturaci... |
| 5 | `HU-ALM-CON-PRE-001.txt` | ﻿HU-ALM-CON-PRE-001 - Consulta de Mercadería Entregada a Sucursal o Almacén para | Como usuario del sistema Restaurant.pe, quiero consultar toda la mercadería que ha sido entregada temporalmente a una su... |
| 6 | `HU-ALM-OP-AJU-001.txt` | ﻿HU-ALM-OP-AJU-001 - Comparación de Inventario Físico vs Sistema y Registro de A | Como usuario del sistema Restaurant.pe, quiero realizar la comparación entre el inventario físico y el inventario regist... |
| 7 | `HU-ALM-OP-AJU-002.txt` | ﻿HU-ALM-OP-AJU-002 - Registro de Pérdidas por Causas Inevitables en el Almacenam | Como usuario del sistema Restaurant.pe, quiero registrar las pérdidas de productos ocasionadas por causas inevitables du... |
| 8 | `HU-ALM-OP-DEV-001.txt` | ﻿HU-ALM-OP-DEV-001 - Registro y Gestión de Devoluciones de Compras a Proveedores | Como usuario del sistema Restaurant.pe, quiero registrar y gestionar las devoluciones de productos comprados a proveedor... |
| 9 | `HU-ALM-OP-SOL-001.txt` | ﻿HU-ALM-OP-SOL-001 - Solicitud de Requerimiento de Reposición de Stock por Nivel | Como usuario del sistema Restaurant.pe, quiero que el sistema genere una solicitud de requerimiento de reposición de sto... |
| 10 | `HU-ALM-OP-TR-004.txt` | ﻿HU-ALM-OP-TR-004 - Confirmación de Recepción de Transferencia de Mercadería ent | Como encargado de almacén receptor, quiero confirmar la recepción de mercadería proveniente de otra sede, almacén o cent... |
| 11 | `HU-ALM-OP-TRA-001.txt` | ﻿HU-ALM-OP-TRA-001 - Almacenamiento de Mercaderías Provenientes de Órdenes de Co | Como usuario del sistema Restaurant.pe, quiero registrar el almacenamiento de las mercaderías que provienen de órdenes d... |
| 12 | `HU-ALM-OP-TRA-002.txt` | ﻿HU-ALM-OP-TRA-002 - Despacho de Productos Vendidos a Cliente o Entregados a Áre | Como usuario del sistema Restaurant.pe, quiero registrar el despacho de productos vendidos a un cliente o la entrega de ... |
| 13 | `HU-ALM-OP-TRA-003.txt` | ﻿HU-ALM-OP-TRA-003 - Generación de Requerimiento de Traslado entre Almacenes con | Como usuario del sistema Restaurant.pe, quiero generar un requerimiento de traslado de productos entre almacenes, valida... |
| 14 | `HU-ALM-PR-CS-001.txt` | ﻿HU-ALM-PR-CS-001 - Reproceso y Actualización de Saldos de Inventario - v1.0 | Como analista de inventarios, quiero reprocesar y actualizar los saldos de inventario de los productos, tomando en cuent... |
| 15 | `HU-ALM-PR-RP-001.txt` | ﻿HU-ALM-PR-RP-001 - Actualización Automática del Precio de Última Compra - v1.0 | Como analista de inventarios o responsable de compras, quiero que el sistema actualice de manera automática el precio de... |
| 16 | `HU-ALM-PRO-PP-001.txt` | ﻿HU-ALM-PRO-PP-001 - Recálculo de Precios Promedio - v1.0 | Como usuario del módulo de Almacén de Restaurant.pe, quiero recalcular los precios promedio de los artículos en función ... |
| 17 | `HU-ALM-REP-ALM-001.txt` | ﻿HU-ALM-REP-ALM-001 - Reporte de Stock Actual de Productos - v1.0 | Como usuario del sistema Restaurant.pe, quiero visualizar el stock actual de todos los productos almacenados en los dife... |
| 18 | `HU-ALM-REP-ALM-002.txt` | ﻿HU-ALM-REP-ALM-002 - Generación de Movimientos de Artículos en Kardex - v1.0 | Como usuario del sistema Restaurant.pe, quiero generar y visualizar los movimientos de los artículos en el Kardex, para ... |
| 19 | `HU-ALM-REP-ALM-003.txt` | ﻿HU-ALM-REP-ALM-003 - Identificación de Artículos con Stock Igual o Inferior al  | Como usuario del sistema Restaurant.pe, quiero generar un reporte que identifique los artículos cuyo stock actual esté i... |
| 20 | `HU-ALM-REP-ALM-004.txt` | ﻿HU-ALM-REP-ALM-004 - Visualización de Rendimiento, Rotación y Condiciones de lo | Como usuario del sistema Restaurant.pe, quiero visualizar un reporte consolidado que muestre el rendimiento, la rotación... |
| 21 | `HU-ALM-REP-ALM-005.txt` | ﻿HU-ALM-REP-ALM-005 - Análisis de Resultados de Toma de Inventario - v1.0 | Como usuario del sistema Restaurant.pe, quiero analizar los resultados de las tomas de inventario realizadas, comparando... |
| 22 | `HU-ALM-REP-ALMFIN-001.txt` | ﻿HU-ALM-REP-ALMFIN-001 - Reporte de Valorización Económica del Stock por Almacén | Como usuario del sistema Restaurant.pe, quiero obtener un reporte que muestre el valor económico del stock existente en ... |
| 23 | `HU-ALM-REP-ALMFIN-002.txt` | ﻿HU-ALM-REP-ALMFIN-002 - Detalle de los Productos Vendidos en un Período Determi | Como usuario del sistema Restaurant.pe, quiero obtener un reporte detallado de los productos vendidos durante un período... |
| 24 | `HU-ALM-TAB-ALM-001.txt` | ﻿HU-ALM-TAB-ALM-001 - Lista de Almacenes en Donde se Almacenan los Productos - v | Como usuario del sistema Restaurant.pe, quiero visualizar una lista de todos los almacenes registrados en el sistema, co... |
| 25 | `HU-ALM-TAB-ALM-002.txt` | ﻿HU-ALM-TAB-ALM-002 - Definición de Tipos de Movimientos de Almacén - v1.0 | Como usuario del sistema Restaurant.pe, quiero definir y configurar los tipos de movimientos que pueden realizarse por c... |
| 26 | `HU-ALM-TAB-CAT-001.txt` | ﻿HU-ALM-TAB-CAT-001 - Definición y Mantenimiento de la Estructura Jerárquica de  | Como usuario del sistema Restaurant.pe, quiero definir, editar y mantener la estructura jerárquica de clasificación de l... |
| 27 | `HU-ALM-TAB-PRO-002.txt` | ﻿HU-ALM-TAB-PRO-002 – Definición y Configuración de Productos por Naturaleza, Su | Como usuario del sistema Restaurant.pe, quiero registrar y configurar correctamente los productos definiendo: Su natural... |
| 28 | `HU-ALM-TAB-PRO-002_1.txt` | ﻿HU-ALM-TAB-MCA-001 - Definición de la Naturaleza Contable, de Inventario o de G | Como usuario del sistema Restaurant.pe, quiero definir la naturaleza de los artículos (contable, de inventario o de gest... |

#### Detalle de cada HU

##### ﻿HU-ALM-CON-ART-001 - Consulta de Información Completa del Producto e Imagen Referencial - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero consultar toda la información registrada de un producto, incluyendo sus datos generales, clasificaciones, configuraciones contables, parámetros de inventario y su imagen referencial, para verificar su registro y asegurar la correcta gestión de artículos en el sistema.

**Navegación:** Ruta: Menú Principal > Almacén > Consultas > Artículos > Consulta de Información de Producto

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Consultar cualquier producto registrado mediante código, descripción, código de barras o categoría.
- Mostrar toda la información registrada del producto, incluyendo:
- Datos generales (código, descripción, unidad de medida, estado, tipo).
- Clasificación (categoría, subcategoría, clase de artículo).
- Datos contables (cuentas contables asociadas, naturaleza del artículo, impuestos aplicables).
- Datos de inventario (stock actual, punto de reposición, almacén principal).
- Datos comerciales (proveedor habitual, precio de compra, precio de venta).
- Mostrar la imagen referencial del producto si se encuentra registrada.
- Permitir descargar o visualizar en pantalla la ficha del producto.

**Integraciones:** Integración con Catálogo de Artículos: para obtener la información estructurada del producto. Integración con Almacén: para mostrar el stock y almacenes asociados. Integración con Compras y Ventas: para mostrar proveedores y precios relacionados. Integración con Contabilidad: para validar cuentas co...

---

##### ﻿HU-ALM-CON-DEV-001 - Consulta del Detalle de Devoluciones Realizadas a Proveedores - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero visualizar el detalle de todas las devoluciones realizadas a proveedores, incluyendo los productos devueltos, las cantidades, las fechas y los motivos de la devolución, para llevar un control preciso de los movimientos de salida del almacén y las incidencias con los proveedores.

**Navegación:** Ruta: Menú Principal > Almacén > Consultas > Devoluciones > Consulta de Devoluciones a Proveedores

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Consultar todas las devoluciones registradas en el sistema a los proveedores.
- Mostrar la información de cada devolución: número de documento, proveedor, fecha, productos, cantidades, monto total y motivo.
- Filtrar las devoluciones por rango de fechas, proveedor, artículo, motivo de devolución o estado del documento.
- Visualizar el documento de devolución asociado (guía o nota de crédito).
- Permitir ver el detalle de cada devolución, incluyendo los artículos y los motivos individuales.
- Permitir exportar la información en formato Excel o PDF.
- Mostrar los usuarios responsables de registrar y autorizar la devolución.
- Identificar si la devolución fue total o parcial respecto a la orden de compra.
- Generar un resumen de motivos para análisis estadístico (por ejemplo: fallas, vencimiento, error de despacho).

**Integraciones:** Integración con Cuentas por Pagar: para reflejar los ajustes por devoluciones que impacten saldos o notas de crédito. Integración con Compras: para identificar si la devolución proviene de una orden o factura específica. Integración con Kardex / Inventario: para actualizar automáticamente las existe...

---

##### ﻿HU-ALM-CON-KDX-001 - Consulta de Stock por Producto y Almacén con Movimiento en Rango Seleccionado - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero consultar el stock actual de los productos por almacén, así como los movimientos de entrada y salida ocurridos en un rango de fechas determinado, para tener una visión completa y actualizada de la disponibilidad y rotación del inventario.

**Navegación:** Ruta: Menú Principal > Almacén > Consultas > Kardex / Movimiento de Inventario > Consulta de Stock y Movimientos

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Seleccionar el almacén desde el cual se desea consultar el stock.
- Seleccionar uno o varios productos por código, descripción o categoría.
- Definir un rango de fechas para visualizar los movimientos de entrada y salida.
- Mostrar en pantalla el stock inicial, movimientos de entrada, movimientos de salida y stock final dentro del rango indicado.
- Permitir visualizar el detalle de cada movimiento, incluyendo tipo de documento (compra, traslado, ajuste, venta, devolución, etc.), número de documento, fecha, cantidad y valor unitario.
- Permitir consultar el costo promedio y total valorizado del inventario.
- Generar reportes por producto, almacén o rango de fechas.
- Exportar los resultados en Excel o PDF.
- Mostrar los movimientos con su usuario responsable y fecha de registro.

**Integraciones:** Integración con Inventario y Kardex: para obtener los saldos y movimientos actualizados por producto y almacén. Integración con Compras, Ventas y Traslados: para identificar el origen de los movimientos registrados. Integración con Contabilidad: para reflejar el valor del inventario y su impacto en ...

---

##### ﻿HU-ALM-CON-OC-001 - Consulta de Órdenes de Compra Pendientes - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero consultar todas las órdenes de compra pendientes de recepción o facturación, para realizar seguimiento al cumplimiento de los proveedores y asegurar la adecuada planificación de abastecimiento y control del inventario.

**Navegación:** Ruta: Menú Principal > Almacén > Consultas > Órdenes de Compra > Consulta de Órdenes de Compra Pendientes

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Visualizar todas las órdenes de compra con estado “Pendiente”, “Parcialmente Recibida” o “Por Facturar”.
- Filtrar las órdenes por proveedor, fecha de emisión, número de orden, estado, almacén, país o sucursal.
- Mostrar el detalle de los ítems pendientes, incluyendo cantidades solicitadas, recibidas y faltantes.
- Permitir consultar el historial de movimientos asociados (recepciones parciales, devoluciones, cancelaciones).
- Indicar el usuario que generó la orden y la fecha de emisión.
- Mostrar las condiciones de entrega y pago configuradas en la orden.
- Permitir exportar la información a Excel y PDF.
- Registrar en el log de auditoría contable y operativa toda consulta o exportación (usuario, fecha, hora, filtros aplicados).
- Integrarse con el módulo de Compras para actualizar el estado de las órdenes conforme se realicen recepciones o facturaciones.

**Integraciones:** Integración con Compras: para obtener el estado actualizado de las órdenes y las recepciones de productos. Integración con Almacén: para validar las cantidades ingresadas en las recepciones. Integración con Finanzas: para identificar órdenes pendientes de facturación y compromisos financieros asocia...

---

##### ﻿HU-ALM-CON-PRE-001 - Consulta de Mercadería Entregada a Sucursal o Almacén para Uso Temporal - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero consultar toda la mercadería que ha sido entregada temporalmente a una sucursal o almacén para uso o consumo interno, con el fin de realizar seguimiento a los préstamos de inventario y asegurar su correcta devolución o consumo autorizado.

**Navegación:** Ruta: Menú Principal > Almacén > Consultas > Préstamos > Consulta de Mercadería Entregada Temporalmente

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Consultar todas las entregas de mercadería registradas como uso temporal.
- Mostrar información como fecha de entrega, almacén origen, sucursal o almacén destino, productos entregados, cantidades y estado del préstamo.
- Filtrar la información por sucursal, almacén, producto, fecha de entrega, estado del préstamo o usuario responsable.
- Identificar si el préstamo ha sido devuelto total o parcialmente.
- Mostrar el usuario que registró la entrega y la fecha de registro.
- Permitir la visualización del documento de préstamo y su estado actual.
- Permitir exportar los resultados en formato Excel o PDF.
- Mostrar el saldo pendiente de devolución para cada producto entregado temporalmente.
- Registrar en el log de auditoría contable y operativa cada consulta o exportación realizada (usuario, fecha, hora, filtros aplicados).

**Integraciones:** Integración con Movimientos de Almacén: para reflejar las salidas y devoluciones asociadas al préstamo. Integración con Kardex / Inventario: para actualizar los saldos en tiempo real según el movimiento temporal. Integración con Contabilidad: para registrar el efecto en cuentas de control o en centr...

---

##### ﻿HU-ALM-OP-AJU-001 - Comparación de Inventario Físico vs Sistema y Registro de Ajustes de Diferencias - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero realizar la comparación entre el inventario físico y el inventario registrado en el sistema, de manera que pueda identificar diferencias en cantidades y valores, y registrar los ajustes necesarios para mantener la integridad y exactitud del control de inventarios.

**Navegación:** Ruta: Menú Principal > Almacén > Operaciones > Ajustes > Comparación de Inventario Físico vs Sistema

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar un nuevo proceso de comparación de inventario, indicando el almacén y la fecha del conteo físico.
- Importar o ingresar manualmente los resultados del conteo físico por producto (código, descripción, cantidad contada).
- Obtener automáticamente del sistema el stock teórico de cada producto.
- Calcular y mostrar la diferencia entre stock físico y stock del sistema, tanto en cantidad como en valor.
- Generar un reporte comparativo que muestre productos con sobrantes o faltantes.
- Permitir al usuario validar y aprobar ajustes antes de su aplicación.
- Registrar automáticamente los ajustes de inventario (entrada o salida) necesarios para igualar ambos inventarios.
- Generar el asiento contable correspondiente a las diferencias detectadas (cuando aplique).
- Permitir la anulación o reversión de ajustes erróneos.

**Integraciones:** Integración con Inventario y Kardex: para actualizar existencias físicas y reflejar los movimientos de ajuste. Integración con Contabilidad: para registrar automáticamente los asientos contables por diferencias detectadas. Integración con Auditoría: para mantener trazabilidad de cada conteo y ajuste...

---

##### ﻿HU-ALM-OP-AJU-002 - Registro de Pérdidas por Causas Inevitables en el Almacenamiento - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero registrar las pérdidas de productos ocasionadas por causas inevitables durante el almacenamiento, tales como deterioro natural, vencimiento o daños no atribuibles a errores operativos, de modo que estas mermas queden documentadas, afecten el inventario y generen los asientos contables correspondientes.

**Navegación:** Ruta: Menú Principal > Almacén > Operaciones > Ajustes > Registro de Pérdidas por Causas Inevitables

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar una nueva pérdida inevitable, indicando fecha, almacén y motivo de la pérdida.
- Seleccionar los productos afectados mediante búsqueda o código de artículo.
- Ingresar la cantidad perdida, unidad de medida y valor unitario.
- Clasificar el tipo de pérdida (vencimiento, deterioro, evaporación, rotura, etc.).
- Asociar el motivo detallado o causa específica de la pérdida mediante texto libre o lista desplegable.
- Registrar la autorización del responsable o jefe de almacén.
- Generar automáticamente el ajuste de inventario tipo salida, afectando las existencias del almacén correspondiente.
- Calcular el valor total de la pérdida y reflejarlo en los reportes contables y de inventario.
- Generar el asiento contable automático de la pérdida, afectando las cuentas de gasto o pérdida por merma.

**Integraciones:** Integración con Inventario y Kardex: para actualizar automáticamente las existencias y reflejar las salidas por pérdida. Integración con Contabilidad: para registrar los asientos contables correspondientes a las pérdidas registradas. Integración con Auditoría: para conservar trazabilidad completa de...

---

##### ﻿HU-ALM-OP-DEV-001 - Registro y Gestión de Devoluciones de Compras a Proveedores - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero registrar y gestionar las devoluciones de productos comprados a proveedores, permitiendo identificar los artículos devueltos, los motivos de la devolución y la afectación correspondiente al inventario, para mantener actualizada la información de stock, costos y cuentas por pagar.

**Navegación:** Ruta: Menú Principal > Almacén > Operaciones > Devoluciones > Devoluciones de Compras a Proveedores

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar una nueva devolución de compra, asociándola a una factura o guía de ingreso previa.
- Seleccionar el proveedor, el documento de compra y el almacén desde el cual se realiza la devolución.
- Mostrar el detalle de los productos comprados, permitiendo seleccionar cuáles se devuelven y en qué cantidad.
- Registrar el motivo de la devolución (por ejemplo: producto defectuoso, exceso recibido, error en facturación).
- Generar automáticamente el documento de salida de inventario correspondiente a los productos devueltos.
- Permitir la generación de un comprobante de devolución (nota de crédito o documento equivalente) para efectos contables y fiscales.
- Actualizar el Kardex y los saldos de inventario afectados.
- Disminuir automáticamente el saldo pendiente del documento por pagar asociado.
- Validar que no se devuelva más cantidad de la registrada en la compra original.

**Integraciones:** Integración con Compras: para identificar los documentos y productos sujetos a devolución. Integración con Cuentas por Pagar: para aplicar automáticamente las notas de crédito y actualizar el saldo del proveedor. Integración con Contabilidad: para registrar el asiento contable correspondiente a la d...

---

##### ﻿HU-ALM-OP-SOL-001 - Solicitud de Requerimiento de Reposición de Stock por Nivel Mínimo - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero que el sistema genere una solicitud de requerimiento de reposición de stock cuando el nivel de existencias de un producto alcance su punto mínimo, para asegurar la continuidad operativa del restaurante y evitar quiebres de inventario en los almacenes o puntos de consumo.

**Navegación:** Ruta: Menú Principal > Almacén > Operaciones > Solicitudes > Requerimiento de Reposición de Stock

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Detectar automáticamente los productos cuyo stock actual se encuentre igual o por debajo del nivel mínimo configurado.
- Generar una solicitud de requerimiento de reposición de forma automática o manual desde el listado de productos.
- Mostrar el almacén, producto, stock actual, stock mínimo y cantidad sugerida de reposición.
- Permitir que el usuario modifique la cantidad sugerida antes de enviar la solicitud.
- Enviar automáticamente la solicitud al almacén central o área de compras, según configuración de la empresa.
- Permitir agregar observaciones o justificaciones para la solicitud.
- Asignar un número correlativo y estado a cada solicitud
- Estados:
- Pendiente. Pendiente atención por el proveedor

**Integraciones:** Integración con Inventarios: para detectar niveles mínimos de stock y actualizar cantidades una vez atendida la reposición. Integración con Compras: para generar automáticamente órdenes de compra en caso de no tener stock disponible en almacén central. Integración con Centros de Costo (CECO): para r...

---

##### ﻿HU-ALM-OP-TR-004 - Confirmación de Recepción de Transferencia de Mercadería entre Sedes, Almacenes o Centros de Distribución - v1.0

**Descripción:** Como encargado de almacén receptor, quiero confirmar la recepción de mercadería proveniente de otra sede, almacén o centro de distribución de la misma empresa, verificando las cantidades y el estado de los productos, para garantizar la trazabilidad y exactitud del inventario intersede.

**Navegación:** Ruta: Menú Principal > Almacén > Operaciones > Traslados > Confirmación de Recepción

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Visualizar todas las transferencias pendientes de recepción dirigidas al almacén o sede actual.
- Mostrar el detalle de los artículos transferidos, incluyendo código, descripción, cantidad enviada, unidad de medida y lote/serie (si aplica).
- Registrar la confirmación de recepción total o parcial.
- Permitir indicar diferencias (faltantes, sobrantes, deteriorados) y su motivo.
- Generar automáticamente un documento de recepción asociado a la transferencia.
- Actualizar el stock del almacén receptor en tiempo real al confirmar la recepción.
- Cambiar el estado de la transferencia a “Recibida” o “Recibida Parcial”.
- Mantener trazabilidad del flujo logístico (fecha de envío, recepción, usuario responsable, hora).
- Permitir la impresión o exportación del comprobante de recepción.

**Integraciones:** Integración con:             * Módulo de Inventarios: para actualizar stock en origen y destino.              * Módulo de Logística / Compras: para trazabilidad de movimientos internos.              * Kardex: para reflejar el movimiento interalmacén.              * Módulo de Auditoría: para registra...

---

##### ﻿HU-ALM-OP-TRA-001 - Almacenamiento de Mercaderías Provenientes de Órdenes de Compra con Validación de Entregas del Proveedor - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero registrar el almacenamiento de las mercaderías que provienen de órdenes de compra, validando que lo entregado por el proveedor coincida con lo solicitado y lo facturado, para asegurar la correcta recepción de bienes, evitar diferencias de inventario y garantizar la trazabilidad entre compras, almacén y contabilidad.

**Navegación:** Ruta: Menú Principal > Almacén > Operaciones > Traslados > Recepción de Mercaderías de Orden de Compra

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Seleccionar una orden de compra aprobada y pendiente de recepción.
- La persona responsable de la recepción de mercadería debe (Almacen o Compras) deben cargar al sistema el XML o PDF de la factura recibida, para la posterior revisión de Contabilidad.
- Mostrar el detalle de los artículos solicitados, cantidades, precios y condiciones de entrega.
- Registrar la cantidad efectivamente entregada por el proveedor.
- Validar automáticamente que lo entregado coincida con lo solicitado y lo facturado.
- Alertar al usuario si existe diferencia entre lo pedido, entregado o facturado. Deberá salir una ventana emergente que existe diferencia entre la Orden de Compra, factura o conteo físico; también deberá enviarse un E-mail al jefe de almacén, jefe de compras, Administrador; para que se revise y corrija.
- Permitir el registro parcial de entregas cuando existan pendientes por recibir.
- Actualizar el stock del almacén receptor al confirmar el almacenamiento.
- Generar automáticamente el documento de entrada de almacén vinculado a la orden de compra y factura del proveedor.

**Integraciones:** Integración con Compras: para obtener los datos de la orden de compra y validar los artículos y cantidades autorizadas. Integración con Finanzas / Cuentas por Pagar: para enlazar las facturas de proveedores con las recepciones y evitar pagos por productos no entregados. Integración con Contabilidad:...

---

##### ﻿HU-ALM-OP-TRA-002 - Despacho de Productos Vendidos a Cliente o Entregados a Áreas Internas para Consumo - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero registrar el despacho de productos vendidos a un cliente o la entrega de insumos a un área interna para su consumo, con el fin de mantener actualizado el inventario, garantizar la trazabilidad de las salidas de almacén y asegurar que las entregas se realicen conforme a los documentos de venta o solicitudes internas autorizadas.

**Navegación:** Ruta: Menú Principal > Almacén > Operaciones > Traslados > Despacho de Productos / Consumo Interno

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar el tipo de despacho: por venta a cliente o por entrega a área interna.
- Seleccionar el documento fuente (factura, boleta, pedido interno o solicitud de materiales).
- Mostrar el detalle de los artículos con cantidades y ubicaciones en almacén.
- Validar que los artículos existan en stock y en cantidad suficiente.
- Registrar la cantidad despachada por artículo.
- Generar un documento de salida de almacén vinculado al documento de origen.
- Permitir registrar observaciones o incidencias durante el despacho (faltantes, sobrantes, sustituciones).
- En caso de entregas internas, permitir seleccionar el área o departamento solicitante.
- Actualizar automáticamente el Kardex valorizado y el saldo de inventario.

**Integraciones:** Integración con Ventas: para obtener las facturas o pedidos de venta y registrar la salida de los productos vendidos. Integración con Producción: para registrar la entrega de insumos o materiales a las áreas de consumo interno. Integración con Finanzas: para reflejar el impacto contable de las salid...

---

##### ﻿HU-ALM-OP-TRA-003 - Generación de Requerimiento de Traslado entre Almacenes con Validación de Disponibilidad y Afectación a Centros de Costo - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero generar un requerimiento de traslado de productos entre almacenes, validando la disponibilidad de los artículos antes de registrar la transferencia como operación efectiva, de manera que se garantice la correcta planificación de los movimientos internos de inventario y se afecten únicamente los Centros de Costo (CECO) sin impacto contable directo.

**Navegación:** Ruta: Menú Principal > Almacén > Operaciones > Traslados > Generar Requerimiento de Traslado

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar un nuevo requerimiento de traslado interno indicando el almacén de origen y el almacén destino.
- Seleccionar los productos a trasladar y las cantidades requeridas.
- Validar en línea la disponibilidad de stock en el almacén origen antes de confirmar el requerimiento.
- Mostrar una alerta o bloqueo si el producto no tiene disponibilidad suficiente.
- Permitir registrar una justificación o motivo del traslado (por ejemplo: reposición de stock, redistribución, transferencia temporal).
- Registrar el Centro de Costo (CECO) afectado por el movimiento, sin generar asiento contable.
- Asignar un número correlativo al requerimiento.
- Permitir definir prioridad del traslado (alta, media, baja).
- Generar un documento en estado “Pendiente de Ejecución” hasta que el traslado sea confirmado.

**Integraciones:** Integración con Inventarios: para validar la disponibilidad y actualizar las existencias una vez confirmada la transferencia. Integración con Centros de Costo (CECO): para registrar la afectación presupuestaria del movimiento sin impacto contable. Integración con Tesorería / Finanzas (opcional): par...

---

##### ﻿HU-ALM-PR-CS-001 - Reproceso y Actualización de Saldos de Inventario - v1.0

**Descripción:** Como analista de inventarios, quiero reprocesar y actualizar los saldos de inventario de los productos, tomando en cuenta todos los movimientos registrados hasta una fecha determinada, para asegurar que las existencias físicas y lógicas estén alineadas y corregir posibles diferencias ocasionadas por anulaciones, reprocesos o registros inconsistentes.

**Navegación:** Ruta: Menú Principal > Almacén > Procesos > Cuadres de Stock > Reprocesar Saldos de Inventario

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Seleccionar una fecha de corte hasta la cual se considerarán los movimientos de inventario.
- Procesar todos los movimientos registrados (entradas, salidas, traslados, ajustes, devoluciones, anulaciones).
- Calcular automáticamente el saldo final por producto y almacén considerando el orden cronológico de los movimientos.
- Comparar los saldos recalculados con los saldos actuales del sistema.
- Mostrar un resumen de diferencias detectadas por producto y almacén.
- Permitir al usuario aprobar y aplicar la actualización de saldos.
- Generar un log de reproceso, registrando fecha, usuario, almacén y resultados.
- Permitir la reversión del reproceso en caso de error.
- Actualizar los reportes de inventario, kardex y stock consolidado con los nuevos saldos.

**Integraciones:** Integración con:                * Módulo de Inventarios: para recalcular y actualizar los saldos físicos y lógicos.                 * Módulo de Kardex: para regenerar movimientos históricos de inventario.                 * Módulo de Compras y Ventas: para validar coherencia de entradas y salidas.   ...

---

##### ﻿HU-ALM-PR-RP-001 - Actualización Automática del Precio de Última Compra - v1.0

**Descripción:** Como analista de inventarios o responsable de compras, quiero que el sistema actualice de manera automática el precio de compra en la ficha del producto, utilizando el precio unitario de la última factura registrada, para asegurar que la información de costos esté siempre actualizada y refleje el valor real de adquisición más reciente.

**Navegación:** Ruta: Menú Principal > Almacén > Procesos > Regeneración de Precio de Última Compra

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Identificar la última factura de compra registrada para cada producto.
- Tomar el precio unitario registrado en esa factura como referencia.
- Actualizar automáticamente el precio de compra en la ficha maestra del producto.
- Registrar en el historial del producto el precio anterior, el nuevo precio y la fecha de actualización.
- Permitir la ejecución manual o programada (por lote o diaria).
- Filtrar por proveedor, familia, categoría o almacén los productos a actualizar.
- Validar que la factura esté aprobada y contabilizada antes de considerar su precio.
- Mostrar un resumen previo con los productos y precios a modificar antes de aplicar la actualización.
- Permitir anular o revertir la actualización si se detecta algún error.

**Integraciones:** Integración con:             * Módulo de Compras: para obtener los precios unitarios de las facturas aprobadas.              * Módulo de Inventario: para actualizar el precio de compra en el maestro de artículos.              * Módulo de Contabilidad: para validar que la factura de compra esté conta...

---

##### ﻿HU-ALM-PRO-PP-001 - Recálculo de Precios Promedio - v1.0

**Descripción:** Como usuario del módulo de Almacén de Restaurant.pe, quiero recalcular los precios promedio de los artículos en función de los movimientos de inventario registrados, para asegurar que los costos reflejados en la contabilidad, kardex y reportes financieros sean correctos y estén alineados con las normas contables y el flujo real de inventarios.

**Navegación:** Ruta: Menú Principal > Almacén > Procesos > Precios Promedio > Recálculo de Precios Promedio

**Criterios de Aceptación clave:**

- El sistema debe permitir seleccionar:
- Almacén
- Rango de fechas o periodo contable
- Artículos específicos o todos los artículos
- El sistema debe mostrar el precio promedio actual y el precio recalculado antes de confirmar el proceso.
- Debe validar que existan movimientos en el periodo seleccionado.
- El sistema debe considerar para el cálculo:
- Ingresos por compras
- Ingresos por transferencias
- Ajustes de inventario

**Integraciones:** * Contabilidad:                                         * Genera diferencias contables por ajuste del costo promedio.                                         * Recalcula valorizaciones para estados financieros.                                            * Compras:                                    ...

---

##### ﻿HU-ALM-REP-ALM-001 - Reporte de Stock Actual de Productos - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero visualizar el stock actual de todos los productos almacenados en los diferentes almacenes y suc y ursales, para conocer la disponibilidad de inventario en tiempo real y facilitar la toma de decisiones sobre compras, traslados y reposiciones.

**Navegación:** Ruta: Menú Principal > Almacén > Reportes > Reporte de Stock Actual de Productos

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Mostrar el stock actual de todos los productos registrados en el sistema.
- Desglosar el inventario por almacén, categoría, producto y unidad de medida.
- Consultar el stock en tiempo real según los movimientos registrados (entradas, salidas, devoluciones, transferencias).
- Filtrar la información por categoría, almacén, producto, familia, proveedor, o estado de stock (disponible / reservado / comprometido).
- Mostrar indicadores como stock mínimo, stock máximo y punto de reposición.
- Identificar los productos con stock por debajo del mínimo mediante resaltado visual.
- Permitir exportar el reporte en formato Excel o PDF.
- Mostrar totales generales y subtotales por categoría o almacén.
- Integrarse con el módulo de Compras para generar alertas o sugerencias de reposición.

**Integraciones:** Integración con Kardex / Movimiento de Inventario: para obtener el stock actualizado en tiempo real. Integración con Compras: para emitir alertas automáticas de reabastecimiento. Integración con Ventas: para descontar automáticamente las existencias comprometidas. Integración con Finanzas: para refl...

---

##### ﻿HU-ALM-REP-ALM-002 - Generación de Movimientos de Artículos en Kardex - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero generar y visualizar los movimientos de los artículos en el Kardex, para mantener un control detallado de las entradas, salidas y transferencias de inventario, garantizando la trazabilidad de cada producto en los diferentes almacenes.

**Navegación:** Ruta: Menú Principal > Almacén > Reportes > Generación de Movimientos de Artículos en Kardex

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Generar un reporte detallado con todos los movimientos registrados en el Kardex por producto, almacén o rango de fechas.
- Mostrar los movimientos clasificados por tipo: entradas, salidas, transferencias, ajustes y devoluciones.
- Identificar el documento origen del movimiento (orden de compra, factura, traslado, ajuste, devolución, etc.).
- Calcular automáticamente las existencias iniciales, movimientos y saldos finales de cada artículo.
- Mostrar los valores de costo unitario y costo total por cada movimiento.
- Filtrar por almacén, categoría, producto, tipo de movimiento, rango de fechas o usuario que realizó la operación.
- Exportar el reporte en formato Excel o PDF.
- Generar gráficos de movimiento por período (diario, semanal, mensual).[a][b][c]
- Registrar toda consulta, exportación o generación de reporte en el log de auditoría contable (usuario, fecha, hora, acción).

**Integraciones:** Integración con Compras: para registrar entradas por recepciones de órdenes de compra. Integración con Ventas: para registrar salidas por ventas y despachos. Integración con Traslados: para registrar movimientos entre almacenes. Integración con Ajustes: para reflejar ajustes de inventario por difere...

---

##### ﻿HU-ALM-REP-ALM-003 - Identificación de Artículos con Stock Igual o Inferior al Nivel Mínimo - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero generar un reporte que identifique los artículos cuyo stock actual esté igual o por debajo del nivel mínimo configurado en el maestro de artículos, para tomar decisiones oportunas de reposición de inventario y evitar quiebres de stock que afecten la operación del negocio.

**Navegación:** Ruta: Menú Principal > Almacén > Reportes > Artículos con Stock Bajo o Igual al Nivel Mínimo

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Generar un listado de todos los artículos cuyo stock actual sea igual o menor al nivel mínimo definido en el maestro de artículos.
- Mostrar el nivel mínimo, stock actual y diferencia entre ambos valores.
- Filtrar por almacén, categoría, proveedor, país o sucursal.
- Permitir ordenar los resultados por nivel de criticidad, categoría o rotación del artículo.
- Visualizar alertas destacadas (por color o ícono) para los artículos con stock crítico (por debajo del 50% del nivel mínimo).
- Exportar el reporte a Excel o PDF.
- Generar notificaciones automáticas al área de compras o planificación cuando se detecten artículos con stock por debajo del mínimo.
- Actualizar la información en tiempo real con base en los movimientos registrados en el módulo de Kardex / Inventario.
- Registrar en el log de auditoría cada consulta o exportación (usuario, fecha, hora, acción).

**Integraciones:** Integración con Maestro de Artículos: para obtener los valores mínimos definidos por producto. Integración con Kardex / Inventario: para actualizar los niveles de stock en tiempo real. Integración con Compras: para facilitar la generación automática de solicitudes o pedidos de reposición. Integració...

---

##### ﻿HU-ALM-REP-ALM-004 - Visualización de Rendimiento, Rotación y Condiciones de los Almacenes - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero visualizar un reporte consolidado que muestre el rendimiento, la rotación de inventarios y las condiciones operativas de los distintos almacenes de la empresa, con el fin de evaluar su eficiencia logística, detectar posibles ineficiencias y optimizar la gestión de almacenamiento.

**Navegación:** Ruta: Menú Principal > Almacén > Reportes > Rendimiento y Rotación de Almacenes

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Generar un reporte consolidado con información de rendimiento, rotación y condiciones de cada almacén.
- Calcular automáticamente indicadores clave como:
- Rotación de inventario = (Costo de ventas / Promedio de inventario).
- Días promedio de inventario = (Inventario promedio / Costo de ventas diario).
- Nivel de ocupación del almacén.
- Valor del inventario almacenado.
- Porcentaje de productos con baja rotación.
- Permitir filtrar por almacén, categoría de producto, rango de fechas o tipo de producto.
- Mostrar los resultados con indicadores visuales (gráficos o semáforos) para una lectura rápida.

**Integraciones:** Integración con Kardex / Inventario: para obtener los movimientos y niveles de stock por almacén. Integración con Compras y Ventas: para calcular la rotación y el costo de ventas. Integración con Finanzas: para calcular el valor del inventario y los costos asociados. Integración con Mantenimiento o ...

---

##### ﻿HU-ALM-REP-ALM-005 - Análisis de Resultados de Toma de Inventario - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero analizar los resultados de las tomas de inventario realizadas, comparando las cantidades físicas registradas con las existencias del sistema, con el fin de detectar diferencias, validar ajustes y mejorar la precisión del control de inventarios.

**Navegación:** Ruta: Menú Principal > Almacén > Reportes > Resultados de Toma de Inventario

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Generar un reporte de comparación entre inventario físico y stock del sistema.
- Calcular automáticamente la diferencia en cantidad y valor por cada producto.
- Identificar los productos con sobrantes, faltantes o coincidencias exactas.
- Mostrar información agrupada por almacén, categoría, producto o usuario responsable de la toma.
- Permitir aplicar filtros por fecha de toma, almacén o tipo de discrepancia.
- Registrar observaciones o comentarios de validación por parte del usuario.
- Permitir exportar el reporte en formatos Excel y PDF.
- Mostrar el valor monetario de las diferencias, según el método de valorización vigente (PEPS, UEPS, Promedio Ponderado, etc.).
- Mantener un registro en el log de auditoría contable de todas las consultas, exportaciones o modificaciones realizadas.

**Integraciones:** Integración con Inventario / Kardex: para obtener los saldos actuales del sistema. Integración con Ajustes de Inventario: para generar automáticamente los movimientos de corrección cuando se aprueban las diferencias. Integración con Finanzas: para reflejar el impacto contable de los ajustes en el va...

---

##### ﻿HU-ALM-REP-ALMFIN-001 - Reporte de Valorización Económica del Stock por Almacén - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero obtener un reporte que muestre el valor económico del stock existente en cada almacén o de manera consolidada, aplicando el método de valorización definido, para analizar el valor contable de los inventarios y tomar decisiones financieras precisas sobre costos y rentabilidad.

**Navegación:** Ruta: Menú Principal > Almacén > Reportes > Reporte de Valorización Económica del Stock

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Generar un reporte con el valor económico del inventario existente por producto, categoría y almacén.
- Calcular el valor total del stock utilizando el método de valorización configurado para la empresa (PEPS/FIFO, UEPS/LIFO, Promedio Ponderado, Costo Estándar).
- Mostrar el costo unitario, cantidad disponible y valor total del stock.
- Permitir visualizar los resultados por almacén individual o de forma consolidada[a][b].
- Filtrar la información por categoría, almacén, producto, fecha o método de valorización.
- Exportar el reporte en formato Excel o PDF.
- Mostrar indicadores financieros como valor total del inventario, variación de costos y margen sobre ventas[c][d].
- Registrar todas las consultas y exportaciones en el log de auditoría contable.
- Reflejar los datos en tiempo real según los movimientos del Kardex.

**Integraciones:** Integración con Kardex / Movimiento de Inventario: para obtener cantidades y costos actualizados. Integración con Contabilidad: para reflejar el valor de los inventarios en las cuentas contables correspondientes. Integración con Finanzas: para reportar el valor total del inventario en los estados fi...

---

##### ﻿HU-ALM-REP-ALMFIN-002 - Detalle de los Productos Vendidos en un Período Determinado - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero obtener un reporte detallado de los productos vendidos durante un período específico, para analizar las tendencias de ventas, rotación de inventario y su impacto financiero, facilitando la toma de decisiones estratégicas sobre compras, precios y abastecimiento.

**Navegación:** Ruta: Menú Principal > Almacén > Reportes > Detalle de Productos Vendidos por Período

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Generar un reporte con el detalle de los productos vendidos en un rango de fechas definido por el usuario.
- Mostrar la información agrupada por producto, categoría, almacén o sucursal.
- Calcular automáticamente las cantidades vendidas, el costo unitario, el costo total y el margen de utilidad.
- Filtrar la información por fecha, producto, categoría, almacén, punto de venta, cliente o tipo de documento.
- Permitir exportar el reporte en formato Excel o PDF.
- Mostrar indicadores de rotación de producto, ingresos totales y margen bruto por período.
- Reflejar datos en tiempo real basados en las transacciones registradas en los módulos de Ventas y Almacén.
- Permitir comparar resultados entre diferentes períodos o sucursales.
- Registrar todas las consultas y exportaciones en el log de auditoría contable (usuario, fecha, hora, acción).

**Integraciones:** Integración con Ventas: para obtener los registros de facturación y documentos emitidos. Integración con Kardex / Inventario: para reflejar las salidas de stock asociadas a cada venta. Integración con Finanzas: para determinar el impacto financiero de las ventas y los márgenes. Integración con Conta...

---

##### ﻿HU-ALM-TAB-ALM-001 - Lista de Almacenes en Donde se Almacenan los Productos - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero visualizar una lista de todos los almacenes registrados en el sistema, con su información principal y estado operativo, para conocer en qué lugares físicos o virtuales se almacenan los productos, y gestionar de manera eficiente el control de inventarios y movimientos de mercancías.

**Navegación:** Ruta: Menú Principal > Almacén > Tablas > Almacén > Lista de Almacenes

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Visualizar el listado completo de almacenes registrados en el sistema, tanto activos como inactivos.
- Mostrar la información principal de cada almacén, como su código, nombre, tipo, ubicación y estado.
- Permitir filtrar por nombre, tipo de almacén, estado, sucursal o país.
- Permitir consultar el detalle del almacén (dirección, responsable, capacidad, etc.).
- Mostrar únicamente la información correspondiente a la razón social y país activos del usuario (campos de solo lectura).
- Permitir crear, editar o inactivar almacenes según permisos de usuario.
- Registrar todas las operaciones (alta, baja, modificación o consulta) en el log de auditoría contable (Usuario, Fecha, Hora, IP, Acción).
- Integrar la información del almacén con los módulos de Compras, Ventas y Contabilidad.

**Integraciones:** Integración con Compras: Para registrar los ingresos de productos en los almacenes según las órdenes de compra. Integración con Ventas: Para descontar existencias al procesar ventas desde el punto de venta o sucursales. Integración con Logística: Para gestionar transferencias entre almacenes y contr...

---

##### ﻿HU-ALM-TAB-ALM-002 - Definición de Tipos de Movimientos de Almacén - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero definir y configurar los tipos de movimientos que pueden realizarse por cada almacén (entradas, salidas o traslados de artículos), de manera que pueda controlar correctamente el flujo de inventarios y mantener la trazabilidad de los movimientos en cada ubicación.

**Navegación:** Ruta: Menú Principal > Almacén > Tablas > Almacén > Tipos de Movimientos por Almacén

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar los tipos de movimientos que afectan las existencias de los productos (entradas, salidas, traslados).
- Asociar cada tipo de movimiento a un almacén específico.
- Clasificar los movimientos según su naturaleza: Entrada, Salida o Traslado.
- Definir si el movimiento afecta el inventario físico, el valor contable o ambos.
- Permitir activar o inactivar tipos de movimientos según políticas de la empresa.
- Evitar la eliminación de tipos de movimiento que ya tengan registros asociados.
- Permitir editar la descripción y configuración de los movimientos mientras no existan transacciones asociadas.
- Registrar en el log de auditoría contable toda acción de creación, modificación, activación o inactivación (usuario, fecha, hora, IP).
- Validar que los tipos de movimiento definidos se encuentren disponibles para los procesos de Compras, Ventas, Producción o Transferencias.

**Integraciones:** Integración con Compras: para registrar automáticamente las entradas de productos a almacén por recepción de órdenes. Integración con Ventas: para descontar las existencias al registrar salidas por ventas o devoluciones. Integración con Producción: para controlar los movimientos internos de consumo ...

---

##### ﻿HU-ALM-TAB-CAT-001 - Definición y Mantenimiento de la Estructura Jerárquica de Clasificación de Artículos - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero definir, editar y mantener la estructura jerárquica de clasificación de los artículos (categorías, subcategorías, familias, líneas), para organizar de forma lógica los productos dentro del sistema y facilitar su gestión en los procesos de compras, almacén, ventas y contabilidad.

**Navegación:** Ruta: Menú Principal > Almacén > Tablas > Categorías > Estructura Jerárquica de Clasificación de Artículos

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Crear niveles jerárquicos de clasificación (por ejemplo: Categoría → Subcategoría → Familia → Línea).
- Definir una descripción y código único para cada nivel.
- Asociar cada artículo a una categoría y subcategoría correspondiente.
- Editar o eliminar clasificaciones siempre que no estén vinculadas a artículos activos.
- Marcar las clasificaciones como activas o inactivas.
- Mostrar la estructura jerárquica en formato árbol, con la posibilidad de expandir o colapsar niveles.
- Validar que no se creen duplicados de nombres o códigos dentro del mismo nivel jerárquico.
- Permitir importar o exportar la estructura jerárquica (Excel/PDF).
- Registrar todas las acciones (alta, modificación, baja, activación, inactivación) en el log de auditoría contable (usuario, fecha, hora, acción).

**Integraciones:** Integración con Compras: para asociar automáticamente categorías a los artículos registrados en órdenes o facturas. Integración con Ventas: para agrupar los productos en reportes de ventas por categoría o subcategoría. Integración con Contabilidad: para determinar la cuenta contable asociada según l...

---

##### ﻿HU-ALM-TAB-PRO-002 – Definición y Configuración de Productos por Naturaleza, Sucursal e Impuestos

**Descripción:** Como usuario del sistema Restaurant.pe, quiero registrar y configurar correctamente los productos definiendo: Su naturaleza (contable, inventario o gestión) Su sucursal de uso, Su centro de costo, Sus cuentas contables asociadas, sus impuestos según el país Para que el sistema registre de forma correcta los movimientos contables, de inventario y tributarios, cumpliendo con la normativa vigente (SUNAT u otras según país), y evitando errores en los libros contables, kardex y reportes financieros. ...

**Navegación:** Ruta: Menú Principal → Almacén / Compras → Tablas → Maestro de Productos → Configuración de Naturaleza e Impuestos ________________

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- ✔ Registrar productos (bienes tangibles y servicios).
- ✔ Asignar una naturaleza única al producto:
- Contable → Impacta directamente en cuentas contables.
- Inventario → Controla stock físico.
- Gestión → Uso administrativo, sin impacto contable directo.
- ✔ Asignar el producto a:
- Una o más sucursales
- Un centro de costo por defecto
- ✔ Asociar las cuentas contables correctas, dependiendo de su naturaleza:

**Integraciones:** ✔ Contabilidad: Genera automáticamente asientos contables según la naturaleza del producto. ✔ Impuestos / SUNAT / Multipaís: Aplica automáticamente el IGV (o impuesto correspondiente) según el país y la vigencia. ✔ Compras: El producto puede utilizarse en: * Orden de compra * Recepción de mercadería...

---

##### ﻿HU-ALM-TAB-MCA-001 - Definición de la Naturaleza Contable, de Inventario o de Gestión y Configuración de Impuestos por Artículo y País - v1.0

**Descripción:** Como usuario del sistema Restaurant.pe, quiero definir la naturaleza de los artículos (contable, de inventario o de gestión) y configurar los impuestos aplicables según el país, para que el sistema registre correctamente los movimientos contables, fiscales y de gestión asociados a cada tipo de artículo, cumpliendo con las normativas tributarias locales.

**Navegación:** Ruta: Menú Principal > Almacén > Tablas > Maestro de Clases de Artículos > Naturaleza y Configuración de Impuestos

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar diferentes clases de artículos y definir su naturaleza:
- Contable (impacta en cuentas contables).
- Inventario (controla existencia física).
- Gestión (uso administrativo sin impacto contable directo).
- Asociar a cada clase de artículo las cuentas contables correspondientes (inventario, costo, ingreso, gasto, ajustes, etc.).
- Configurar impuestos por artículo y por país, según las legislaciones fiscales locales (IGV, IVA, ITBIS, ISV, etc.).
- Permitir definir si los impuestos son afectos o exonerados, así como su porcentaje de aplicación.
- Validar que cada artículo pertenezca a una única clase definida.
- Permitir la edición o inactivación de una clase de artículo, siempre que no existan movimientos asociados.

**Integraciones:** Integración con Contabilidad: para registrar los asientos automáticos de compras, ventas, ajustes y consumos según la naturaleza contable del artículo. Integración con Impuestos / Fiscal: para aplicar las tasas impositivas correctas según país y tipo de artículo. Integración con Compras y Ventas: pa...

---


### 2.2. Módulo de Compras

> **Gestión de proveedores, órdenes de compra/servicio, aprovisionamiento y reportes**
> 
> HUs documentadas: **17** | Carpeta: `02_Compras/`

#### Listado de Historias de Usuario

| # | Archivo | Título | Descripción resumida |
|---|---|---|---|
| 1 | `HU-COM-001.txt` | ﻿HU-COM-001 - Gestión de Proveedores - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero registrar, consultar, modificar e inactivar proveedores, para... |
| 2 | `HU-COM-002.txt` | ﻿HU-COM-002 - Condición de Pago - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero registrar, modificar, consultar e inactivar las condiciones d... |
| 3 | `HU-COM-003.txt` | ﻿HU-COM-003 - Generar Orden de Compra - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero registrar y generar órdenes de compra de bienes o servicios, ... |
| 4 | `HU-COM-004.txt` | ﻿HU-COM-004 - Aprobación de Orden de Compra - v1.0 | Como usuario con rol autorizado en el sistema contable de Restaurant.pe, quiero aprobar o rechazar órdenes de compra gen... |
| 5 | `HU-COM-005.txt` | ﻿HU-COM-005 - Generar Orden de Servicio - v1.0 | 2. La numeración de la orden de servicio debe ser correlativa y automática teniendo un formato de año + correlativo (OS-... |
| 6 | `HU-COM-006.txt` | ﻿HU-COM-006 - Aprobación de Orden de Servicio - v1.0 | Como usuario con rol autorizado en el sistema contable de Restaurant.pe, quiero aprobar, rechazar o devolver órdenes de ... |
| 7 | `HU-COM-APR-007.txt` | ﻿HU-COM-APR-007 - Planificación de Abastecimiento - v1.0 | Como usuario responsable de compras en Restaurant.pe, quiero planificar el abastecimiento de insumos, materias primas y ... |
| 8 | `HU-COM-RC-008.txt` | ﻿HU-COM-RC-008 - Lista de Compras Procesadas - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero consultar y descargar la lista de compras procesadas dentro d... |
| 9 | `HU-COM-RC-009.txt` | ﻿HU-COM-RC-009 - Resumen de Compras que están Pendientes de Recepción - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero visualizar un reporte consolidado de las órdenes de compra y ... |
| 10 | `HU-COM-RC-010.txt` | ﻿HU-COM-RC-010 - Reporte de Compras Recibidas sin Almacenar los Productos - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte que muestre todas las compras que han sido... |
| 11 | `HU-COM-RC-011.txt` | ﻿HU-COM-RC-011 - Análisis de las Compras Realizadas por Proveedores - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte analítico de las compras realizadas por ca... |
| 12 | `HU-COM-RC-012.txt` | ﻿HU-COM-RC-012 - Reporte de Compras por Categoría de Productos - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte que muestre las compras realizadas clasifi... |
| 13 | `HU-COM-RC-013.txt` | ﻿HU-COM-RC-013 - Detalle y Análisis de Compras Realizadas por Período, Proveedor | Como usuario del sistema contable de Restaurant.pe, quiero acceder a un reporte analítico y detallado de las compras rea... |
| 14 | `HU-COM-RC-014.txt` | ﻿HU-COM-RC-014 - Generación de Sugerencia de Cantidad Óptima y Proveedor Sugerid | Como usuario del sistema contable de Restaurant.pe, quiero que el sistema genere un reporte analítico con sugerencias au... |
| 15 | `HU-FIN-OP-CP-001.txt` | ﻿HU-FIN-OP-CP-001 - Registro de Facturas por Pagar que no corresponden a Compras | Como usuario del sistema contable de Restaurant.pe, quiero registrar facturas por pagar que no se originan en procesos d... |
| 16 | `HU-FIN-OPE-001.txt` | ﻿HU-FIN-OPE-001 - Ingreso de Facturas de Proveedores provenientes del Módulo de  | Como usuario del área contable o financiera, quiero que las facturas emitidas por los proveedores y registradas en el mó... |
| 17 | `HU-FIN-OPE-003.txt` | ﻿HU-COM-OPE-003 - Registro de documento que reduce o ajusta la deuda - v1.0 | Como usuario del módulo de Finanzas, quiero registrar documentos que reduzcan o ajusten la deuda con proveedores (por ej... |

#### Detalle de cada HU

##### ﻿HU-COM-001 - Gestión de Proveedores - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero registrar, consultar, modificar e inactivar proveedores, para poder mantener un maestro único de proveedores actualizado, que sirva de base para las compras, cuentas por pagar e integración contable.

**Navegación:** Ruta: Menú Principal > Compras > Tablas > Proveedores

**Criterios de Aceptación clave:**

- El sistema debe permitir alta, modificación, consulta e inactivación de proveedores.
- El sistema debe validar que el Número de Identificación Fiscal (RUC/NIT/RNC/NIF) sea único en el país para proveedores nacionales. En caso de proveedores extranjeros, el sistema debe permitir registrar su número de identificación fiscal respetando el formato propio de su país[a][b][c], validando únicamente que no se repita dentro del mismo país de origen registrado. (Anexo 1)
- El sistema debe impedir la eliminación de proveedores con movimientos asociados (compras, facturas, pagos), permitiendo sólo su inactivación.
- Todos los cambios deben registrarse en el log de auditoría contable (usuario, fecha, hora, acción).
- El formulario debe mostrar cómo informativos (solo lectura) los campos: Razón Social activa y País.
- El listado debe permitir búsqueda y filtros por Razón Social, Identificación Fiscal, Estado y País.

---

##### ﻿HU-COM-002 - Condición de Pago - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero registrar, modificar, consultar e inactivar las condiciones de pago de los proveedores, para que estas puedan ser utilizadas en el registro de compras y en la gestión de cuentas por pagar.

**Navegación:** Ruta: Menú Principal > Compras > Tablas > Condiciones de Pago

**Criterios de Aceptación clave:**

- El sistema debe permitir crear, modificar, consultar e inactivar condiciones de pago.
- Cada condición de pago debe estar identificada de manera única por un código interno [a][b][c][d]y un nombre.
- El sistema debe validar que no existan condiciones de pago duplicadas (por código o nombre).
- No se podrán eliminar condiciones de pago que estén asociadas a proveedores o documentos de compra; sólo podrán inactivarse.
- El sistema debe registrar toda acción en el log de auditoría contable (usuario, fecha, hora, acción).
- El listado de condiciones de pago debe permitir filtros por código, nombre y estado (activo/inactivo).

---

##### ﻿HU-COM-003 - Generar Orden de Compra - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero registrar y generar órdenes de compra de bienes o servicios, para formalizar el requerimiento de adquisiciones a proveedores y asegurar la integración con inventarios, finanzas y contabilidad.

**Navegación:** Ruta: Menú Principal > Compras > Operaciones > Órdenes de Compra > Generar Orden de Compra

**Criterios de Aceptación clave:**

- El sistema debe permitir crear órdenes de compra con datos obligatorios: proveedor, fecha, condiciones de pago, artículos,  cantidades, moneda, fecha de entrega.
- La numeración de la orden de compra debe ser correlativa y automática por razón social y sucursal.
- El sistema debe validar que el proveedor seleccionado esté activo en el maestro de proveedores.
- Los artículos seleccionados deben provenir del maestro de artículos y estar clasificados.
- Debe ser posible registrar órdenes de compra en moneda local o extranjera, con conversión a tipo de cambio.
- No se podrá modificar una orden de compra con estado aprobada o cerrada.

---

##### ﻿HU-COM-004 - Aprobación de Orden de Compra - v1.0

**Descripción:** Como usuario con rol autorizado en el sistema contable de Restaurant.pe, quiero aprobar o rechazar órdenes de compra generadas, para asegurar el control de adquisiciones, cumplir con los flujos de autorización y garantizar la integración con inventarios, finanzas y contabilidad.

**Navegación:** Ruta: Menú Principal > Compras > Operaciones > Órdenes de Compra > Aprobación de Orden de Compra

**Criterios de Aceptación clave:**

- El sistema debe mostrar las órdenes de compra con estado Pendiente de Aprobación.
- El usuario debe poder aprobar, rechazar o retornar la orden de compra.
- Las órdenes aprobadas cambian de estado a Aprobada, y quedan disponibles para su recepción e integración contable.
- Las órdenes rechazadas cambian de estado a Rechazada y no podrán usarse en procesos posteriores.
- Las órdenes devueltas cambian de estado a Retornada, quedando disponibles para correcciones.
- El sistema debe permitir definir un flujo de aprobación parametrizable ([a][b]por montos, sucursales o categorías de compra).

---

##### ﻿HU-COM-005 - Generar Orden de Servicio - v1.0

**Descripción:** 2. La numeración de la orden de servicio debe ser correlativa y automática teniendo un formato de año + correlativo (OS-YYYY-CORRELATIVO) Ejemplo: OS-2025-000001                       3. El proveedor seleccionado debe estar activo en el maestro de proveedores.        4. La orden de servicio debe poder registrarse en moneda local o extranjera, aplicando tipo de cambio si corresponde.        5. El sistema debe permitir registrar servicios múltiples dentro de la misma orden.        6. No se podrá m...

**Navegación:** Ruta: Menú Principal > Compras > Operaciones > Órdenes de Servicio > Generar Orden de Servicio

**Criterios de Aceptación clave:**

- El sistema debe permitir crear órdenes de servicio con datos obligatorios: proveedor, fecha, descripción del servicio, condiciones de pago y monto.
- La numeración de la orden de servicio debe ser correlativa y automática teniendo un formato de año + correlativo (OS-YYYY-CORRELATIVO) Ejemplo: OS-2025-000001
- El proveedor seleccionado debe estar activo en el maestro de proveedores.
- La orden de servicio debe poder registrarse en moneda local o extranjera, aplicando tipo de cambio si corresponde.
- El sistema debe permitir registrar servicios múltiples dentro de la misma orden.
- No se podrá modificar una orden de servicio con estado aprobada o cerrada.

---

##### ﻿HU-COM-006 - Aprobación de Orden de Servicio - v1.0

**Descripción:** Como usuario con rol autorizado en el sistema contable de Restaurant.pe, quiero aprobar, rechazar o devolver órdenes de servicio generadas, para asegurar el cumplimiento de los flujos de autorización y garantizar que solo las órdenes aprobadas se integren con finanzas y contabilidad.

**Navegación:** Ruta: Menú Principal > Compras > Operaciones > Órdenes de Servicio > Aprobación de Orden de Servicio

**Criterios de Aceptación clave:**

- El sistema debe mostrar solo las órdenes de servicio con estado Pendiente de Aprobación.
- El usuario debe poder aprobar, rechazar o devolver una orden de servicio.
- Las órdenes aprobadas cambian su estado a Aprobada y quedan disponibles para integración contable y financiera.
- Las órdenes rechazadas cambian a Rechazada y no podrán usarse en procesos posteriores.
- Las órdenes devueltas cambian a Devuelta, quedando editables para corrección.
- El sistema debe permitir configurar un flujo de aprobación parametrizable (por monto, sucursal, centro de costo o tipo de servicio).[a]

---

##### ﻿HU-COM-APR-007 - Planificación de Abastecimiento - v1.0

**Descripción:** Como usuario responsable de compras en Restaurant.pe, quiero planificar el abastecimiento de insumos, materias primas y servicios, con base en la demanda proyectada, niveles de inventario y programación de producción, para asegurar el suministro oportuno y eficiente en todas las sucursales de la razón social.

**Navegación:** Ruta: Menú Principal > Compras > Operaciones > Aprovisionamiento > Planificación de Abastecimiento

**Criterios de Aceptación clave:**

- El sistema debe permitir crear planes de abastecimiento con base en:
- Consumo histórico.
- Proyecciones de ventas o producción.
- Niveles mínimos y máximos de inventario.
- El plan debe generarse por razón social, sucursal y almacén.
- El sistema debe sugerir cantidades a abastecer considerando el stock actual y los pedidos pendientes.
- El usuario podrá ajustar manualmente las cantidades sugeridas antes de confirmar el plan.
- El sistema debe permitir guardar versiones del plan y marcarlo como “en revisión” o “validado”.
- Desde un plan validado, el usuario debe poder generar solicitudes de aprovisionamiento [a]u órdenes de compra automáticas.

---

##### ﻿HU-COM-RC-008 - Lista de Compras Procesadas - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero consultar y descargar la lista de compras procesadas dentro de un periodo determinado, para analizar el comportamiento de las adquisiciones, validar su integración contable y generar reportes de gestión consolidados por proveedor, sucursal o centro de costo.

**Navegación:** Ruta: Menú Principal > Compras > Reportes > Lista de Compras Procesadas

**Criterios de Aceptación clave:**

- El sistema debe mostrar todas las compras procesadas (órdenes de compra y órdenes de servicio aprobadas y registradas).
- El reporte debe poder filtrarse por fecha, proveedor, sucursal, tipo de documento, usuario, y estado contable.
- Debe incluir tanto compras locales como importadas, diferenciando tipo de moneda y tipo de cambio aplicado.
- El sistema debe permitir exportar el reporte en formatos Excel y PDF.
- Cada registro debe mostrar la trazabilidad completa: orden de compra → recepción → factura → registro contable.
- Las columnas deben poder ordenarse y agruparse dinámicamente por el usuario.

**Integraciones:** * Permitir acceso al detalle del documento (clic en número de orden → abre vista de detalle con información de proveedor, ítems, facturas y asientos contables).                    * Desde el reporte, debe ser posible revisar el asiento contable asociado (si aplica).

---

##### ﻿HU-COM-RC-009 - Resumen de Compras que están Pendientes de Recepción - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero visualizar un reporte consolidado de las órdenes de compra y órdenes de servicio que se encuentran pendientes de recepción, para monitorear los compromisos de entrega de proveedores y gestionar el cumplimiento oportuno de las adquisiciones.

**Navegación:** Ruta: Menú Principal > Compras > Reportes > Resumen de Compras Pendientes de Recepción

**Criterios de Aceptación clave:**

- El reporte debe mostrar todas las órdenes de compra y órdenes de servicio cuyo estado sea Pendiente de Recepción o Recepción Parcial.
- El sistema debe permitir filtrar la información por proveedor, fecha de emisión, sucursal, almacén, comprador y estado de recepción.
- Debe diferenciar las órdenes parcialmente recepcionadas de las no recepcionadas.
- El sistema debe calcular los días transcurridos desde la emisión de la orden hasta la fecha actual.
- Las columnas deben incluir información sobre cantidades solicitadas, recepcionadas y pendientes.
- El reporte debe poder exportarse en Excel y PDF, y descargarse por rango de fechas.

**Integraciones:** * Integración con Órdenes de Compra / Servicio (módulo Compras).                    * Integración con Recepción de Mercaderías o Servicios (módulo Almacén / Logística).                    * Permitir consulta cruzada con Kardex de Inventario cuando corresponda a bienes.                    * Mostrar e...

---

##### ﻿HU-COM-RC-010 - Reporte de Compras Recibidas sin Almacenar los Productos - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte que muestre todas las compras que han sido recepcionadas pero cuyos productos aún no han sido ingresados formalmente al almacén, para detectar discrepancias entre recepción y almacenamiento, y garantizar la trazabilidad del inventario y el control contable.

**Navegación:** Ruta: Menú Principal > Compras > Reportes > Reporte de Compras Recibidas sin Almacenar los Productos

**Criterios de Aceptación clave:**

- El reporte debe mostrar todas las órdenes de compra recepcionadas en el módulo de Compras pero sin movimiento de ingreso en el módulo de Almacén.
- El sistema debe permitir filtrar por fecha de recepción, proveedor, sucursal, almacén, tipo de documento y usuario receptor.
- Cada registro debe mostrar el número de orden de compra, fecha de recepción, proveedor, total recepcionado y el estado del ingreso al almacén (Pendiente / Incompleto).
- Debe permitir identificar diferencias entre cantidad recepcionada y cantidad almacenada por ítem.
- El reporte debe poder exportarse en Excel y PDF, conservando el formato estándar.
- El usuario podrá acceder al detalle de la orden y al movimiento de recepción, si existiese.

**Integraciones:** * Integración con:                       * Módulo de Compras: para obtener órdenes y recepciones aprobadas.                       * Módulo de Almacén: para verificar los movimientos de ingreso.                       * Contabilidad: para identificar si las compras fueron registradas contablemente.   ...

---

##### ﻿HU-COM-RC-011 - Análisis de las Compras Realizadas por Proveedores - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte analítico de las compras realizadas por cada proveedor dentro de un periodo determinado, para evaluar el volumen de compras, la frecuencia, los montos, y la participación de cada proveedor en el total de adquisiciones, facilitando la toma de decisiones de negociación y control presupuestal.

**Navegación:** Ruta: Menú Principal > Compras > Reportes > Análisis de Compras por Proveedores

**Criterios de Aceptación clave:**

- El sistema debe mostrar un reporte consolidado por proveedor, con totales de compras realizadas en el periodo seleccionado.
- El usuario debe poder filtrar la información por rango de fechas, proveedor, tipo de documento, sucursal, centro de costo y moneda.
- El reporte debe permitir visualizar totales por proveedor, número de órdenes, monto total, impuestos, y cantidad de ítems adquiridos.
- El sistema debe calcular automáticamente el porcentaje de participación de cada proveedor en el total de compras del periodo.
- Debe incluir gráficos comparativos (barras o pastel) que muestren la distribución de compras por proveedor.
- Desde el reporte debe poder accederse al detalle de las compras individuales del proveedor (drill down).

**Integraciones:** * Integración con Módulo de Compras: para obtener datos de órdenes y facturas aprobadas.                    * Integración con Contabilidad: para mostrar el estado contable y los montos registrados.                    * Integración con Finanzas: para reflejar pagos efectuados y saldos pendientes con ...

---

##### ﻿HU-COM-RC-012 - Reporte de Compras por Categoría de Productos - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte que muestre las compras realizadas clasificadas por categoría de productos, para analizar el comportamiento del gasto por tipo de insumo, materia prima, producto terminado o servicio, y facilitar la toma de decisiones de abastecimiento y control de costos.

**Navegación:** Ruta: Menú Principal > Compras > Reportes > Reporte de Compras por Categoría de Productos

**Criterios de Aceptación clave:**

- El sistema debe mostrar un reporte consolidado que agrupe las compras por categoría de producto (por ejemplo: carnes, bebidas, limpieza, empaque, etc.).
- Debe permitir filtrar por rango de fechas, proveedor, sucursal, almacén, categoría, subcategoría, tipo de documento y moneda.
- Cada registro debe mostrar el monto total de compras, la cantidad de productos adquiridos y el porcentaje de participación de cada categoría en el total.
- El reporte debe incluir gráficos comparativos (barras o pastel) que representen la distribución de compras por categoría.
- Desde el reporte debe ser posible acceder al detalle de las compras asociadas a cada categoría (drill down).
- El sistema debe permitir exportar el reporte en formatos Excel, PDF y versión gráfica
- La versión gráfica no es un archivo; es una vista dentro del sistema, pero también debe poder exportarse como imagen o PDF.
- Gráfico principal:
- Barras: Compras por categoría en monto total.
- Torta/Pie: Participación porcentual.

**Integraciones:** * Integración con Módulo de Compras: para obtener los registros de órdenes y facturas aprobadas.                          * Integración con Módulo de Almacén: para validar las categorías de productos y su clasificación.                          * Integración con Contabilidad: para consolidar los gas...

---

##### ﻿HU-COM-RC-013 - Detalle y Análisis de Compras Realizadas por Período, Proveedor, Producto o Condición de Pago - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero acceder a un reporte analítico y detallado de las compras realizadas, que me permita filtrarlas por período, proveedor, producto o condición de pago, para analizar el comportamiento de las adquisiciones, evaluar condiciones comerciales y apoyar la toma de decisiones estratégicas de compra.

**Navegación:** Ruta: Menú Principal > Compras > Reportes > Detalle y Análisis de Compras Realizadas

**Criterios de Aceptación clave:**

- El reporte debe permitir seleccionar uno o varios criterios de análisis:
- Período (mensual, trimestral, anual)
- Proveedor
- Producto
- Condición de Pago
- Debe mostrar el detalle de las órdenes y facturas de compra con información completa de fecha, proveedor, producto, cantidad, monto y estado.
- El sistema debe calcular los totales y promedios por cada criterio seleccionado.
- Debe incluir indicadores de:
- Total de compras en el período.
- Promedio de monto por proveedor.

**Integraciones:** * Integración con Compras: para obtener datos de órdenes, facturas y condiciones de pago.                                * Integración con Contabilidad: para identificar el estado contable y financiero de las compras.                                * Integración con Finanzas: para validar pagos efec...

---

##### ﻿HU-COM-RC-014 - Generación de Sugerencia de Cantidad Óptima y Proveedor Sugerido - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero que el sistema genere un reporte analítico con sugerencias automáticas de la cantidad óptima de compra y el proveedor más conveniente, basado en el historial de compras, consumos y precios, para optimizar el abastecimiento y mejorar la eficiencia en la gestión de compras.

**Navegación:** Ruta: Menú Principal > Compras > Reportes > Generación de Sugerencia de Cantidad Óptima y Proveedor Sugerido

**Criterios de Aceptación clave:**

- El sistema debe analizar el historial de compras y consumos de cada producto (últimos 3, 6 o 12 meses).
- Debe considerar parámetros como:
- Promedio de consumo diario o semanal.
- Stock actual en almacén.
- Punto de reposición configurado.
- Tiempo promedio de entrega del proveedor.
- Precio promedio histórico y descuentos.
- La cantidad óptima sugerida debe calcularse en base a:
- Cantidad Óptima = (Consumo promedio x Plazo de reposición) + Stock de seguridad
- El sistema debe sugerir el proveedor recomendado según:

**Integraciones:** * Integración con Compras: para registrar automáticamente la orden de compra basada en la sugerencia.                                * Integración con Almacén: para obtener el stock actual y punto de reposición de cada producto.                                * Integración con Proveedores: para obte...

---

##### ﻿HU-FIN-OP-CP-001 - Registro de Facturas por Pagar que no corresponden a Compras - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero registrar facturas por pagar que no se originan en procesos de compras o recepción de artículos (por ejemplo, servicios, arrendamientos, asesorías, licencias, suministros no inventariables), para garantizar el correcto reconocimiento contable y financiero de las obligaciones con terceros, así como su integración automática al módulo de contabilidad y tesorería.

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Cuentas por Pagar > Registro de Facturas No Asociadas a Compras

**Criterios de Aceptación clave:**

- El sistema debe permitir el registro de facturas que no estén vinculadas a órdenes o documentos del módulo de Compras.
- Debe validar los siguientes campos obligatorios:
- N° de Factura
- Proveedor
- Fecha de Emisión
- Fecha de Vencimiento
- Monto Total
- Moneda
- Tipo de Gasto
- Centro de Costo

**Integraciones:** Integración con Contabilidad: Genera automáticamente el asiento contable al aprobar la factura. Integración con Tesorería: Permite enlazar las facturas registradas para su programación de pagos. Integración con Proveedores: Obtiene los datos del proveedor, moneda y condiciones de pago registradas en...

---

##### ﻿HU-FIN-OPE-001 - Ingreso de Facturas de Proveedores provenientes del Módulo de Compras - v1.0

**Descripción:** Como usuario del área contable o financiera, quiero que las facturas emitidas por los proveedores y registradas en el módulo de Almacén sean ingresadas automáticamente o validadas manualmente en el módulo de Compras, para generar las cuentas por pagar correspondientes, integradas al flujo de pagos y a la contabilidad general, asegurando que toda factura recepcionada esté correctamente asociada a su orden de compra y registro contable.

**Navegación:** Ruta: Menú Principal → Compras → Operaciones → Cuentas por Pagar → Ingreso de Facturas de Proveedores

**Criterios de Aceptación clave:**

- El sistema debe permitir importar automáticamente facturas de proveedores registradas en el módulo de Almacén, tanto de manera manual como electrónica (XML, API, PDF etc.).
- Cada factura debe estar vinculada a una Orden de Compra previamente aprobada.
- Debe validarse que los productos, cantidades y montos coincidan con lo recepcionado en almacén y lo facturado por el proveedor.
- Si la factura no coincide con la orden de compra o recepción, el sistema debe generar una alerta de discrepancia. Debe existir la opción de observar el ingreso realizado por Almacén o Compras para que éstos subsanen el error y proceder con el adecuado registro.
- El sistema debe permitir ingresar manualmente facturas no originadas en compras (servicios, gastos administrativos, arrendamientos, etc.), marcándose como “factura directa”.
- Cada factura debe registrar: proveedor, número de documento, tipo de comprobante, fecha de emisión, fecha de vencimiento, moneda, monto total, impuestos (si existen) y condición de pago.

---

##### ﻿HU-COM-OPE-003 - Registro de documento que reduce o ajusta la deuda - v1.0

**Descripción:** Como usuario del módulo de Finanzas, quiero registrar documentos que reduzcan o ajusten la deuda con proveedores (por ejemplo: notas de crédito, notas de débito, devoluciones, descuentos comerciales o ajustes contables), para actualizar correctamente el saldo de las facturas afectadas, reflejar el efecto en Cuentas por Pagar y generar los asientos contables correspondientes, manteniendo trazabilidad y cumplimiento fiscal.

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Cuentas por Pagar > Registro de Ajustes / Notas de Crédito / Notas de Débito

**Criterios de Aceptación clave:**

- El sistema debe permitir crear, editar (mientras esté en estado Pendiente), aplicar y anular documentos de ajuste.
- Todo documento de ajuste debe estar vinculado obligatoriamente a una factura u obligación con saldo pendiente (salvo ajustes generales que se definan como “no vinculados”).
- No se podrá aplicar un ajuste cuyo monto supere el saldo pendiente del documento afectado.
- El sistema debe validar la moneda y aplicar conversión según tipo de cambio si procede; no se permitirán inconsistencias de moneda entre documento y ajuste sin registro de diferencia cambiaria.
- Al aplicar el ajuste, debe generarse automáticamente el asiento contable correspondiente y actualizarse el registro en Cuentas por Pagar.
- Las facturas ya canceladas o con estado que impida ajustes deben quedar bloqueadas para aplicación de ajustes.

---


### 2.3. Módulo de Ventas

> **Facturación, pedidos, caja, clientes y reportes de ventas**
> 
> HUs documentadas: **2** | Carpeta: `03_Ventas/`

#### Listado de Historias de Usuario

| # | Archivo | Título | Descripción resumida |
|---|---|---|---|
| 1 | `Facturacion de Regalias por porcentaje establecido a franquicias.txt` | ﻿Historia de Usuario |  |
| 2 | `Generacion de Reporte Tributario por periodo (IGV, Retenciones y otros.txt` | ﻿Historia de Usuario |  |

#### Detalle de cada HU

##### ﻿Historia de Usuario

**Criterios de Aceptación clave:**

- El sistema debe calcular automáticamente la regalía en base al porcentaje configurado y el monto de ventas.
- No debe permitir generar facturas de regalía si no existen ventas registradas en el periodo seleccionado.
- No debe permitir duplicidad de facturas para la misma franquicia en el mismo periodo.
- La factura debe generarse en formatos PDF y XML (según normativa local) y quedar disponible para descarga y envío por correo electrónico.[b]
- Toda acción de creación, modificación, anulación o envío debe registrarse en el log de auditoría (usuario, fecha, hora, acción).
- La integración debe realizarse automáticamente con:
- Contabilidad: generación de asiento contable.
- Finanzas: registro en cuentas por cobrar.
- Reportes de Ventas: consolidado de regalías cobradas.
- Reglas de Negocio

---

##### ﻿Historia de Usuario

**Criterios de Aceptación clave:**

- El reporte debe consolidar automáticamente base imponible, impuestos generados, retenciones y percepciones en función de las facturas registradas en el periodo.
- El usuario debe poder visualizar en pantalla el reporte antes de exportarlo.
- El reporte debe permitir filtrar por:
- Periodo
- Tipo de impuesto
- Sucursal / Consolidado
- El sistema debe exportar el reporte en formatos:
- PDF para consulta interna
- Excel para análisis
- XML o TXT según exigencia de cada país para carga en sistemas tributarios oficiales

---


### 2.4. Módulo de Finanzas

> **Tesorería, cuentas por pagar/cobrar, conciliaciones, adelantos y flujo de caja**
> 
> HUs documentadas: **41** | Carpeta: `04_Finanzas/`

#### Listado de Historias de Usuario

| # | Archivo | Título | Descripción resumida |
|---|---|---|---|
| 1 | `HU-FIN-ADL-001.txt` | ﻿HU-FIN-ADL-001 - Generación de Órdenes de Giro - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero generar órdenes de giro a partir de las Ordenes de compras qu... |
| 2 | `HU-FIN-ADL-002.txt` | ﻿HU-FIN-ADL-002 - Aprobación de Ordenes de Giro - v1.0 | Como usuario autorizado del sistema contable de Restaurant.pe, quiero aprobar o rechazar las solicitudes de adelantos ge... |
| 3 | `HU-FIN-ADL-003.txt` | ﻿HU-FIN-ADL-003 - Liquidación de Órdenes de Giro[a] - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero registrar la liquidación de las solicitudes de adelantos prev... |
| 4 | `HU-FIN-ADL-004.txt` | ﻿HU-FIN-ADL-004 - Cierre de Liquidación de Órdenes de Giro - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero realizar el cierre contable y financiero de las liquidaciones... |
| 5 | `HU-FIN-CON-CB-001.txt` | ﻿HU-FIN-CON-CB-001 - Información de los Saldos de Todas las entidades financiera | Como usuario del sistema contable de Restaurant.pe, quiero consultar la información consolidada de los saldos disponible... |
| 6 | `HU-FIN-CON-CON-001.txt` | ﻿HU-FIN-CON-CON-001 - Cruce de Información del Extracto Bancario con la Informac | Como usuario del sistema contable de Restaurant.pe, quiero que el sistema realice el cruce automático y manual entre los... |
| 7 | `HU-FIN-CON-CON-002.txt` | ﻿HU-FIN-CON-CON-002 - Cruce de Información de la Pasarela de Pago con la Cobranz | Como usuario del sistema contable de Restaurant.pe, quiero que el sistema realice el cruce automático entre la informaci... |
| 8 | `HU-FIN-CON-CON-003.txt` | ﻿HU-FIN-CON-CON-003 - Conciliación de Ventas Realizadas por Canal Ecommerce cont | Como usuario del sistema contable de Restaurant.pe, quiero que el sistema realice la conciliación entre las ventas proce... |
| 9 | `HU-FIN-CON-CON-004.txt` | ﻿HU-FIN-CON-CON-004 - Estado de Conciliaciones Bancarias por Cuenta - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero consultar un reporte consolidado del estado de las conciliaci... |
| 10 | `HU-FIN-CON-DF-001.txt` | ﻿HU-FIN-CON-DF-001 - Visualización de Todos los Documentos Generados en Finanzas | Como usuario del sistema contable de Restaurant.pe, quiero visualizar todos los documentos generados en el módulo de fin... |
| 11 | `HU-FIN-CON-FC-002.txt` | ﻿HU-FIN-CON-FC-002 - Estado Actual y Proyectado de Caja y Bancos - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero consultar el estado actual y proyectado de las cajas y cuenta... |
| 12 | `HU-FIN-OP-CC-001.txt` | ﻿HU-FIN-OP-CC-001 - Aplicación de Pagos Recibidos a Documentos de Venta, Letras  | Como usuario del sistema contable de Restaurant.pe, quiero aplicar los pagos recibidos de clientes a los documentos de v... |
| 13 | `HU-FIN-OP-CC-002.txt` | ﻿HU-FIN-OP-CC-002 - Registro de Letras de Cambio Emitidas a Clientes como Forma  | Como usuario del sistema contable de Restaurant.pe, quiero registrar las letras de cambio emitidas a los clientes como f... |
| 14 | `HU-FIN-OP-CC-003.txt` | ﻿HU-FIN-OP-CC-003 - Registro de Facturas que No Provienen de Ventas Directas - v | Como usuario del sistema contable de Restaurant.pe, quiero registrar facturas que no provienen de ventas directas (como ... |
| 15 | `HU-FIN-OP-CC-004.txt` | ﻿HU-FIN-OP-CC-004 - Relación de Facturas y Documentos por Cliente - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero consultar la relación detallada de todas las facturas y docum... |
| 16 | `HU-FIN-OP-CP-002.txt` | ﻿HU-FIN-OP-CP-002 - Reprogramación del Vencimiento del Documento por Pagar y Apl | Como usuario del sistema contable de Restaurant.pe, quiero poder reprogramar la fecha o pasar a cuotas de vencimiento un... |
| 17 | `HU-FIN-OP-CP-003.txt` | ﻿HU-FIN-OP-CP-003 - Automatización de Registros de Transacciones Periódicas (Luz | Como usuario del sistema contable de Restaurant.pe, quiero que el sistema registre automáticamente las transacciones rec... |
| 18 | `HU-FIN-OP-CP-004.txt` | ﻿HU-FIN-OP-CP-004 - Consulta y Edición de Registros por Proveedor con Visualizac | Como usuario del sistema contable de Restaurant.pe, quiero consultar los registros de cuentas por pagar agrupados por pr... |
| 19 | `HU-FIN-OP-CP-005.txt` | ﻿HU-FIN-OP-CP-005 - Relación de Facturas y Documentos por Proveedor - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero obtener una relación detallada de todas las facturas y docume... |
| 20 | `HU-FIN-REP-CC-001.txt` | ﻿HU-FIN-REP-CC-001 - Estado de Documentos y Clientes / Estado de Cuenta del Clie | Como usuario del sistema contable de Restaurant.pe, quiero consultar un reporte del estado de cuenta de los clientes, qu... |
| 21 | `HU-FIN-REP-CP-001.txt` | ﻿HU-FIN-REP-CP-001 - Detalle de Facturas de Proveedores Registradas en Cuentas p | Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte detallado de las facturas registradas en e... |
| 22 | `HU-FIN-REP-CP-002.txt` | ﻿HU-FIN-REP-CP-002 - Reporte de las Obligaciones por Vencer - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte que muestre todas las obligaciones pendien... |
| 23 | `HU-FIN-REP-FN-001.txt` | ﻿HU-FIN-REP-FN-001 - Reporte de Documentos Ingresados Directamente en Finanzas - | Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte que muestre todos los documentos registrad... |
| 24 | `HU-FIN-REP-TS-001.txt` | ﻿HU-FIN-REP-TS-001 - Reporte Integral de Movimientos en Bancos y Caja - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte integral de todos los movimientos realizad... |
| 25 | `HU-FIN-TAB-001.txt` | ﻿HU-FIN-TAB-001 - Documentos Financieros que se Usan en el Módulo de Finanzas -  | 4. Debe permitir asociar cada documento a una cuenta contable predeterminada (ej. Bancos, Caja, Cuentas por Pagar, etc.)... |
| 26 | `HU-FIN-TAB-002.txt` | ﻿HU-FIN-TAB-002 - Detalle de Cada Movimiento para Identificar de Qué Proviene o  | 5. El listado debe mostrar todos los conceptos registrados con filtros por tipo, estado y categoría.              6. Cad... |
| 27 | `HU-FIN-TAB-003.txt` | ﻿HU-FIN-TAB-003 - Estructura que Permite Agrupar los Conceptos Financieros - v1. | Como usuario financiero del sistema Restaurant.pe, quiero definir una estructura jerárquica de agrupación de conceptos f... |
| 28 | `HU-FIN-TES-TES-001.txt` | ﻿HU-FIN-TES-TES-001 - Lista de Documentos por Pagar Pendientes, con Opción de Pr | Como usuario del sistema contable de Restaurant.pe, quiero visualizar una lista consolidada de todos los documentos por ... |
| 29 | `HU-FIN-TES-TES-002.txt` | ﻿HU-FIN-TES-TES-002 - Lista de Cuentas por Cliente y Control del Vencimiento: Re | Como usuario del sistema contable de Restaurant.pe, quiero acceder a una lista de cuentas por cliente que me permita con... |
| 30 | `HU-FIN-TES-TES-003.txt` | ﻿HU-FIN-TES-TES-003 - Cancelación de Varios Documentos de Uno o Varios Proveedor | Como usuario del sistema contable de Restaurant.pe, quiero poder realizar la cancelación simultánea de varios documentos... |
| 31 | `HU-FIN-TES-TES-004.txt` | ﻿HU-FIN-TES-TES-004 - Registro de Pagos y Anticipos Efectuados a Proveedores - v | Como usuario del sistema contable de Restaurant.pe, quiero registrar los pagos y anticipos efectuados a proveedores, de ... |
| 32 | `HU-FIN-TES-TES-005.txt` | ﻿HU-FIN-TES-TES-005 - Anulación o Reversión de Pagos Mal Registrados o Duplicado | Como usuario del sistema contable de Restaurant.pe, quiero poder anular o revertir pagos que hayan sido registrados de m... |
| 33 | `HU-FIN-TES-TES-006.txt` | ﻿HU-FIN-TES-TES-006 - Movimiento entre Cuentas Bancarias y Cajas - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero registrar los movimientos de transferencia de fondos entre cu... |
| 34 | `HU-FIN-TES-TES-007.txt` | ﻿HU-FIN-TES-TES-007 - Programación de Pagos por Realizar por Vencimientos - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero programar los pagos de documentos por vencer o vencidos, de m... |
| 35 | `HU-FIN-TES-TES-008.txt` | ﻿HU-FIN-TES-TES--008 - Asignación de Fondo Fijo de Caja por Punto de Venta - v1. | Como usuario del sistema contable de Restaurant.pe, quiero registrar y controlar el dinero asignado como fondo fijo a ca... |
| 36 | `HU-FIN-TES-TES-009.txt` | ﻿HU-FIN-TES-TES-009 - Administración de Fondo Fijo y Caja Chica : Registro de Eg | Como usuario del sistema contable de Restaurant.pe, quiero administrar los fondos fijos y cajas chicas de cada sucursal,... |
| 37 | `HU-FIN-TES-TES-010.txt` | ﻿HU-FIN-TES-TES-010 - Proyección de Ingresos y Egresos - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero generar proyecciones automáticas de ingresos y egresos futuro... |
| 38 | `HU-FIN-TES-TES-011.txt` | ﻿HU-FIN-TES-TES-011 - Registro en Tesorería de los Ingresos del Día Procesados p | Como usuario del sistema contable de Restaurant.pe, quiero que el sistema registre automáticamente en Tesorería los ingr... |
| 39 | `HU-FIN-TES-TES-012.txt` | ﻿HU-FIN-TES-TES-012 - Ejecución de Pago al Ente Tributario desde Bancos - v1.0 | Como usuario del sistema contable de Restaurant.pe, quiero que el sistema me permita ejecutar los pagos al ente tributar... |
| 40 | `HU-FIN-TES-TES-013.txt` | ﻿HU-FIN-TES-TES-013 – Pago de Detracción - v1 | Como analista o tesorero, quiero registrar y ejecutar el pago de detracciones correspondientes a facturas o servicios su... |
| 41 | `httpsdocs.google.comdocumentd1PW6fo77kwZDtN8jSvx1MYbGzm8Ncw-x9tg.txt` | ﻿HU-FIN-OPE-004 – Aprobación de Liquidación de Rendición de Gastos | Como usuario aprobador del módulo de Finanzas, quiero revisar, Observar, aprobar  o rechazar las liquidaciones de rendic... |

#### Detalle de cada HU

##### ﻿HU-FIN-ADL-001 - Generación de Órdenes de Giro - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero generar órdenes de giro a partir de las Ordenes de compras que tengan como forma de pago “Adelanto”; para esto el sistema debe mostrar la lista de las Ordenes compras con este tipo de forma de pago, con el fin de formalizar y autorizar el pago correspondiente desde las cuentas bancarias registradas de la empresa, garantizando la trazabilidad financiera y contable del proceso.

**Navegación:** Ruta: Menú Principal > Finanzas > Adelantos > Solicitud de Adelantos > Generación de Órdenes de Giro

**Criterios de Aceptación clave:**

- El sistema debe permitir generar una Orden de Giro únicamente a partir de Ordenes de Compra aprobadas con la modalidad de pago “Anticipo”.
- Al ingresar, el sistema mostrará los datos generales de la Orden de Compra: número, fecha, beneficiario, tipo de adelanto, porcentaje, monto, moneda y centro de costo asociado.
- El sistema debe mostrar un formulario con los siguientes campos obligatorios:
- Número de Orden de Compra (autogenerado, correlativo por Razón Social y año fiscal). Ejemplo de formato OC-2025-0001
- Fecha de emisión (editable).
- Beneficiario (proveedor o colaborador).
- Banco y Cuenta Bancaria (listas desplegables con validación de cuentas activas).
- Monto del Giro (validado que no supere el monto solicitado).
- Moneda (seleccionable según las monedas configuradas por país).
- Forma de Pago (Transferencia, Cheque, Efectivo, Otro).

**Integraciones:** * Integración con Contabilidad: Registro automático del asiento contable del adelanto, con impacto directo en cuentas por pagar o anticipos al personal.                       * Integración con Finanzas – Tesorería: El proceso de Orden de Giro debe impactar directamente en Tesorería, reservando el mo...

---

##### ﻿HU-FIN-ADL-002 - Aprobación de Ordenes de Giro - v1.0

**Descripción:** Como usuario autorizado del sistema contable de Restaurant.pe, quiero aprobar o rechazar las solicitudes de adelantos generadas por colaboradores o áreas solicitantes, con el fin de garantizar el control, validación y autorización previa antes de la generación de una Orden de Giro o desembolso.

**Navegación:** Ruta: Menú Principal > Finanzas > Adelantos > Solicitud de Adelantos > Aprobación

**Criterios de Aceptación clave:**

- El sistema debe mostrar un listado con todas las solicitudes de Ordenes de Giro [a][b]pendientes de aprobación, con sus principales datos (número, solicitante, tipo, monto, fecha y estado).
- El usuario podrá seleccionar una solicitud y visualizar su detalle completo antes de aprobar o rechazar.
- Debe existir un botón “Aprobar” y otro “Rechazar”, habilitados solo para usuarios con perfil autorizado.
- Al aprobar, el sistema debe cambiar el estado de la solicitud a “Aprobada” y registrar automáticamente la fecha, hora, usuario aprobador y observaciones.
- Al rechazar, el sistema debe cambiar el estado a “Rechazada” y exigir el ingreso de una observación obligatoria.
- El sistema debe permitir la aprobación masiva de solicitudes seleccionadas, siempre que cumplan con los criterios establecidos.
- El sistema debe impedir la aprobación de solicitudes que no estén completas o que excedan el límite máximo permitido por política.
- Toda acción de aprobación o rechazo debe registrarse en el log de auditoría contable, incluyendo Usuario, Fecha, Hora, IP, Acción y Observación.
- La información de Razón Social y País debe mostrarse en modo solo lectura.
- El sistema debe permitir exportar el listado de solicitudes en formato Excel o PDF.

**Integraciones:** * Integración con Contabilidad: Al aprobar una solicitud, se genera una reserva contable temporal del monto a desembolsar.                 * Integración con Finanzas – Tesorería: Actualiza el flujo de caja proyectado, marcando el monto como compromiso financiero.                 * Integración con RR...

---

##### ﻿HU-FIN-ADL-003 - Liquidación de Órdenes de Giro[a] - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero registrar la liquidación de las solicitudes de adelantos previamente aprobadas y desembolsadas, para rendir cuentas sobre el uso del dinero asignado, registrar los gastos asociados, calcular saldos pendientes o devoluciones, y mantener la contabilidad actualizada de los movimientos financieros y presupuestales.

**Navegación:** Ruta: Menú Principal > Finanzas > Adelantos > Solicitud de Adelantos > Liquidación

**Criterios de Aceptación clave:**

- El sistema debe mostrar todas las solicitudes de adelantos con estado “Desembolsado” o “En Proceso de Liquidación”.[c]
- El usuario podrá seleccionar una solicitud y visualizar el detalle de la misma (monto aprobado, monto desembolsado, beneficiario, centro de costo, etc.).
- El sistema debe permitir ingresar los gastos efectuados vinculados a la solicitud, detallando: tipo de gasto, fecha, documento de respaldo (boleta, factura, recibo), número de documento, proveedor, monto, moneda y descripción.
- El sistema debe calcular automáticamente:
- Total Gastado.
- Saldo a Devolver (si el gasto < monto del adelanto).
- Saldo a Regularizar (si el gasto > monto del adelanto).
- Debe permitir adjuntar comprobantes digitalizados en formato PDF o imagen (una o varias por gasto).
- El usuario podrá guardar la liquidación en estado “Borrador” o “Enviada para Revisi[d][e][f]ón”
- Los usuarios con perfil Aprobador Financiero podrán revisar la liquidación y aprobarla, cambiando su estado a “Liquidada”.

**Integraciones:** * Integración con Contabilidad: Genera automáticamente los asientos contables de cierre del adelanto, reconociendo gastos y regularizaciones.                       * Integración con Tesorería: Actualiza los saldos de caja y flujo de efectivo (devoluciones o pagos complementarios).                   ...

---

##### ﻿HU-FIN-ADL-004 - Cierre de Liquidación de Órdenes de Giro - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero realizar el cierre contable y financiero de las liquidaciones de adelantos aprobadas, con el fin de consolidar la información de gastos, devoluciones o saldos pendientes, y reflejar su impacto definitivo en las cuentas contables, asegurando el cumplimiento de los procesos de control interno y las normas contables aplicables.

**Navegación:** Ruta: Menú Principal > Finanzas > Adelantos > Solicitud de Adelantos > Cierre de Liquidación

**Criterios de Aceptación clave:**

- El sistema debe mostrar todas las liquidaciones con estado “Aprobada” o “Pendiente de Cierre”.
- El usuario podrá seleccionar una liquidación y visualizar su detalle completo antes de realizar el cierre (solicitud, gastos, documentos adjuntos, asientos contables previos).
- Solo los usuarios con rol Contador General o Administrador Financiero podrán ejecutar el cierre.
- El sistema debe validar que la liquidación esté aprobada y sin observaciones pendientes antes de permitir el cierre.
- Al confirmar el cierre, el sistema debe:
- Cambiar el estado a “Cerrada”.
- Generar el asiento contable de cierre del adelanto, aplicando las cuentas configuradas de gasto, devolución o diferencia.
- Bloquear cualquier modificación posterior de los datos de la liquidación.
- Actualizar automáticamente los saldos en las cuentas de anticipos, gastos y bancos.
- Si la liquidación presenta saldo a devolver, el sistema debe registrar el movimiento correspondiente en Tesorería para control de devolución.

**Integraciones:** * Integración con Contabilidad: Genera el asiento contable de cierre del adelanto y actualiza las cuentas de gasto, anticipos y bancos.                       * Integración con Tesorería: Registra los movimientos por devolución o pago complementario derivados del cierre.                       * Integ...

---

##### ﻿HU-FIN-CON-CB-001 - Información de los Saldos de Todas las entidades financieras - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero consultar la información consolidada de los saldos disponibles en todas las cuentas bancarias y cajas de la empresa, para tener una visión clara y actualizada de la liquidez y disponibilidad de fondos por cada sucursal y cuenta.

**Navegación:** Ruta: Menú Principal > Finanzas > Consultas > Consulta de Saldos de Caja y Bancos > Información de Saldos

**Criterios de Aceptación clave:**

- El sistema debe mostrar un resumen consolidado de los saldos actuales de todas las cuentas bancarias y cajas asociadas a la razón social activa.
- Debe permitir filtrar por tipo de cuenta (banco o caja), sucursal, moneda, país o banco.
- Cada registro debe incluir información como: nombre del banco, número de cuenta, tipo de moneda, saldo contable, saldo disponible y fecha de última actualización.
- El usuario podrá consultar el detalle del movimiento más reciente asociado a cada cuenta o caja.
- Debe permitir exportar la información en formatos Excel y PDF.
- El sistema debe mostrar el total general consolidado en moneda local y en moneda corporativa (USD) para entornos multipaís.
- Solo se mostrará información correspondiente a la razón social y país activo del usuario (campos de solo lectura).
- Toda consulta o exportación debe quedar registrada en el log de auditoría contable (Usuario, Fecha, Hora, IP, Acción, Cuenta).[a]

**Integraciones:** Integración con Tesorería: Permite obtener los movimientos diarios de ingresos y egresos por caja y cuenta bancaria. Integración con Contabilidad: Valida la coherencia entre los saldos contables y los registros financieros. Integración con Conciliaciones: Muestra el estado de conciliación por cuenta...

---

##### ﻿HU-FIN-CON-CON-001 - Cruce de Información del Extracto Bancario con la Información del Sistema (Pagos, Cobranzas, Transferencias, Gastos y Comisiones Bancarias) - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero que el sistema realice el cruce automático y manual entre los movimientos del extracto bancario y los registros internos de pagos, cobranzas, transferencias y comisiones, para garantizar la conciliación bancaria efectiva y la detección de diferencias entre el banco y el sistema.

**Navegación:** Ruta: Menú Principal > Finanzas > Conciliaciones > Cruce de Extracto Bancario con Información del Sistema

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Importar el extracto bancario en formatos comunes (.TXT, .CSV, .XLS, .XML) según el banco y país.
- Identificar automáticamente los movimientos del extracto (depósitos, pagos, transferencias, comisiones).
- Realizar el cruce automático entre los movimientos bancarios y las operaciones registradas en el sistema (pagos a proveedores, cobranzas de clientes, gastos, transferencias internas, comisiones).
- Permitir el cruce manual cuando no se encuentre coincidencia automática.
- Mostrar las coincidencias totales, parciales y pendientes de conciliación.
- Permitir marcar movimientos como pendientes de revisión o conciliados parcialmente.
- Registrar en el log de auditoría contable toda acción realizada (usuario, fecha, hora, tipo de movimiento, monto, estado).
- Calcular automáticamente la diferencia entre el saldo del sistema y el saldo del banco.
- Generar el asiento contable de ajuste cuando se registren gastos o comisiones bancarias no contabilizadas.

**Integraciones:** Integración con Tesorería: Para cruzar los registros de pagos, cobranzas y transferencias realizados desde el sistema. Integración con Bancos: Para importar los extractos bancarios en línea o por archivo plano. Integración con Contabilidad: Para generar los asientos de ajustes contables derivados de...

---

##### ﻿HU-FIN-CON-CON-002 - Cruce de Información de la Pasarela de Pago con la Cobranza Realizada y Control de Comisiones - v1.0[a]

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero que el sistema realice el cruce automático entre la información de las pasarelas de pago y las cobranzas registradas por ese medio, incluyendo el control de las comisiones cobradas por el proveedor del servicio, para garantizar la conciliación correcta de ingresos y egresos asociados a las transacciones electrónicas.

**Navegación:** Ruta: Menú Principal > Finanzas > Conciliaciones > Cruce de Pasarela de Pago con Cobranza y Control de Comisiones

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Importar automáticamente o de forma manual los archivos o reportes de las pasarelas de pago (ej. VisaNet, Niubiz, MercadoPago, PayU, Stripe, etc.).
- Leer los movimientos de ventas procesadas, cobranzas recibidas y comisiones descontadas.
- Cruzar la información de la pasarela con los registros internos de ventas y cobranzas provenientes del módulo de Ventas o Tesorería.
- Identificar diferencias entre el monto cobrado por la pasarela y el monto registrado en el sistema.
- Registrar automáticamente las comisiones bancarias o de pasarela en cuentas contables configurables (Gastos por Comisiones / IVA sobre Comisiones).
- Permitir la conciliación automática y manual, en caso de diferencias por fechas o redondeos.
- Mostrar el estado de conciliación por transacción, lote o fecha.
- Generar un reporte de conciliación por pasarela de pago, con detalle de ingresos, comisiones y diferencias.
- Registrar todas las acciones en el log de auditoría contable (usuario, fecha, hora, monto, pasarela, estado).

**Integraciones:** Integración con Ventas: Para validar las transacciones cobradas y registradas por pasarela. Integración con Tesorería: Para reflejar los ingresos netos y vincularlos con las cuentas bancarias asociadas. Integración con Contabilidad: Para generar los asientos contables de comisiones y ajustes. Integr...

---

##### ﻿HU-FIN-CON-CON-003 - Conciliación de Ventas Realizadas por Canal Ecommerce contra Liquidación Recibida - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero que el sistema realice la conciliación entre las ventas procesadas por el canal ecommerce y las liquidaciones efectivamente recibidas por los medios de pago o plataformas asociadas, para garantizar la correspondencia entre los ingresos registrados y los depósitos recibidos en las cuentas bancarias.

**Navegación:** Ruta: Menú Principal > Finanzas > Conciliaciones > Conciliación de Ventas Ecommerce vs Liquidación Recibida

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Importar o integrar automáticamente los reportes de ventas del canal ecommerce (propio o de terceros: web, app, marketplace, delivery apps).
- Importar las liquidaciones o abonos reportados por las pasarelas o plataformas financieras (ej. Niubiz, MercadoPago, PayU, Stripe, etc.).
- Identificar y cruzar las transacciones según criterios configurables: número de pedido, fecha, monto, cliente o ID de transacción.
- Mostrar las coincidencias totales, parciales o pendientes de conciliación.
- Detectar diferencias por comisiones, redondeos, devoluciones o descuentos aplicados por la plataforma.
- Registrar automáticamente las comisiones y ajustes como gastos contables.
- Permitir la conciliación automática y manual, según el grado de correspondencia entre registros.
- Generar un reporte de conciliación por periodo, canal y plataforma.
- Mostrar el estado de cada transacción (Conciliada, Parcial, Pendiente, Diferencia Detectada).

**Integraciones:** Integración con Ventas: Para obtener los registros de ventas procesadas por canal ecommerce. Integración con Tesorería: Para reflejar los montos efectivamente liquidados y conciliados. Integración con Bancos: Para verificar el ingreso real en cuentas bancarias de las liquidaciones. Integración con C...

---

##### ﻿HU-FIN-CON-CON-004 - Estado de Conciliaciones Bancarias por Cuenta - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero consultar un reporte consolidado del estado de las conciliaciones bancarias por cuenta, que muestre los movimientos conciliados, pendientes y las diferencias detectadas, para tener una visión clara del avance y consistencia de los saldos bancarios frente al sistema contable.

**Navegación:** Ruta: Menú Principal > Finanzas > Conciliaciones > Estado de Conciliaciones Bancarias por Cuenta

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Seleccionar una o varias cuentas bancarias para visualizar el estado de conciliación.
- Mostrar el saldo contable, el saldo bancario y la diferencia pendiente de conciliación.
- Listar los movimientos conciliados, no conciliados y en revisión.
- Permitir aplicar filtros por rango de fechas, tipo de movimiento, banco o estado de conciliación.
- Identificar automáticamente partidas duplicadas, diferencias por montos o fechas, y registros omitidos.
- Permitir drill down (detalle) para revisar los movimientos asociados a cada estado.
- Exportar el reporte en Excel o PDF, con firma digital o sello de auditoría.
- Registrar toda consulta o exportación en el log de auditoría contable (usuario, fecha, hora, cuenta, acción).
- Solo mostrar información correspondiente a la razón social, país y sucursal activa del usuario.

**Integraciones:** Integración con Tesorería: Para obtener los movimientos bancarios registrados en pagos, transferencias y cobros. Integración con Contabilidad: Para validar los saldos contables y generar asientos de ajuste por diferencias. Integración con Bancos: Para importar los extractos bancarios y comparar los ...

---

##### ﻿HU-FIN-CON-DF-001 - Visualización de Todos los Documentos Generados en Finanzas (Pagos y Cobros) - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero visualizar todos los documentos generados en el módulo de finanzas, incluyendo pagos, cobros y operaciones relacionadas, para contar con una herramienta centralizada de consulta y auditoría que permita validar el registro y estado de cada transacción financiera.

**Navegación:** Ruta: Menú Principal > Finanzas > Consultas > Documentos por Finanzas > Visualización de Documentos Generados

**Criterios de Aceptación clave:**

- El sistema debe mostrar un listado consolidado de todos los documentos generados en Finanzas, incluyendo:
- Pagos a proveedores.
- Cobros a clientes.
- Transferencias entre cuentas.
- Reversiones o anulaciones de operaciones.
- Registros automáticos provenientes de otros módulos (Compras, Ventas, Tesorería, Conciliaciones).
- Cada documento debe mostrar información como: número, tipo, fecha, módulo de origen, usuario responsable, monto, estado y cuenta asociada.
- El usuario podrá filtrar por tipo de documento, módulo, fecha, sucursal, moneda o estado.
- Debe permitir visualizar el detalle del documento, incluyendo su asiento contable vinculado.
- Debe incluir las opciones de exportar el listado en formato Excel y PDF.

**Integraciones:** Integración con Tesorería: Para mostrar los pagos, cobros y transferencias registrados. Integración con Contabilidad: Para visualizar los asientos contables relacionados y su estado (vigente o reversado). Integración con Cuentas por Pagar y por Cobrar: Para vincular los documentos de pago y cobro co...

---

##### ﻿HU-FIN-CON-FC-002 - Estado Actual y Proyectado de Caja y Bancos - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero consultar el estado actual y proyectado de las cajas y cuentas bancarias, considerando los ingresos y egresos registrados y programados, para anticipar la disponibilidad de fondos y planificar de forma eficiente la gestión de tesorería.

**Navegación:** Ruta: Menú Principal > Finanzas > Consultas > Consulta de Flujo de Caja > Estado Actual y Proyectado de Caja y Bancos

**Criterios de Aceptación clave:**

- El sistema debe mostrar el saldo actual de cada caja y cuenta bancaria, así como una proyección de saldos futuros basada en:
- Ingresos programados (ventas, cobros, préstamos, etc.)
- Egresos programados (pagos, impuestos, nómina, proveedores, etc.)
- Fechas de vencimiento de documentos por cobrar y por pagar.
- El usuario podrá definir el periodo de proyección (diario, semanal, quincenal o mensual).
- Debe permitir filtrar por tipo de cuenta, banco, sucursal, moneda o país.
- El sistema debe calcular automáticamente el saldo proyectado por fecha, considerando los movimientos confirmados y programados.
- Debe mostrar el flujo neto proyectado (ingresos menos egresos) y resaltar los periodos con saldo negativo.
- El usuario podrá exportar el reporte en formato Excel o PDF.
- Toda consulta, modificación de parámetros o exportación debe registrarse en el log de auditoría contable (Usuario, Fecha, Hora, IP, Acción, Cuenta).[a][b]

**Integraciones:** Integración con Tesorería: Para obtener los ingresos y egresos programados y registrar automáticamente los movimientos proyectados. Integración con Contabilidad: Para validar los saldos contables actuales y los asientos de cierre. Integración con Cuentas por Pagar y por Cobrar: Para incluir document...

---

##### ﻿HU-FIN-OP-CC-001 - Aplicación de Pagos Recibidos a Documentos de Venta, Letras u Otros Documentos - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero aplicar los pagos recibidos de clientes a los documentos de venta, letras u otros comprobantes pendientes de cobro, para mantener actualizadas las cuentas por cobrar y reflejar correctamente los ingresos percibidos y los saldos pendientes de cada cliente.

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Cuentas por Cobrar > Aplicación de Pagos Recibidos

**Criterios de Aceptación clave:**

- El sistema debe permitir seleccionar un cliente y mostrar todos los documentos pendientes de cobro (facturas, letras, notas de débito u otros).
- El usuario podrá ingresar uno o varios pagos recibidos (efectivo, transferencia, cheque, tarjeta, etc.) y aplicarlos parcial o totalmente a los documentos seleccionados.
- El sistema debe mostrar el monto total recibido, el monto aplicado y el saldo pendiente del cliente.
- Debe validar que el monto aplicado no exceda el monto del pago disponible.
- En caso de pagos parciales, el sistema deberá mantener el documento con saldo pendiente hasta su cancelación total.
- Cada aplicación de pago generará automáticamente el asiento contable correspondiente:
- Débito: Cuentas por Cobrar
- Crédito: Caja o Banco
- El sistema debe permitir visualizar el asiento contable asociado al pago aplicado.
- Si existe una diferencia por redondeo o tipo de cambio, el sistema deberá registrar automáticamente un ajuste contable (ganancia o pérdida por tipo de cambio).

**Integraciones:** Integración con Contabilidad: Genera automáticamente los asientos contables al aplicar el pago y refleja los movimientos en cuentas por cobrar y bancos. Integración con Tesorería: Permite vincular el pago aplicado con el movimiento bancario o de caja correspondiente. Integración con Ventas: Vincula ...

---

##### ﻿HU-FIN-OP-CC-002 - Registro de Letras de Cambio Emitidas a Clientes como Forma de Pago - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero registrar las letras de cambio emitidas a los clientes como forma de pago de sus documentos de venta, para mantener un control detallado de las cuentas por cobrar documentadas y facilitar el seguimiento de su cobro, vencimiento y contabilización.

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Cuentas por Cobrar > Registro de Letras de Cambio

**Criterios de Aceptación clave:**

- El sistema debe permitir registrar una o más letras de cambio emitidas a un cliente, vinculadas a uno o varios documentos de venta (facturas, notas de débito u otros).
- Debe validar que el monto total de las letras coincida con el saldo pendiente de los documentos de venta seleccionados.
- El sistema debe permitir definir los siguientes datos:
- Fecha de emisión y vencimiento de la letra.
- Monto total y moneda.
- Tasa de interés (si aplica).
- Número de cuotas o fracciones (si corresponde).
- Banco y número de cuenta (opcional).
- Estado inicial de la letra (Emitida / En gestión / Protestada /Anulada).
- Debe generarse automáticamente el asiento contable de emisión:

**Integraciones:** Integración con Contabilidad: Genera y actualiza automáticamente los asientos contables por emisión, cancelación o protesto de la letra. Integración con Ventas: Permite vincular las letras con los documentos de venta (facturas o notas de débito). Integración con Tesorería: En caso de cobro o descuen...

---

##### ﻿HU-FIN-OP-CC-003 - Registro de Facturas que No Provienen de Ventas Directas - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero registrar facturas que no provienen de ventas directas (como servicios prestados, alquileres, intereses u otros ingresos eventuales), para mantener un control completo de todas las cuentas por cobrar y reflejar correctamente los ingresos en la contabilidad.

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Cuentas por Cobrar > Registro de Facturas No Provenientes de Ventas Directas

**Criterios de Aceptación clave:**

- El sistema debe permitir registrar manualmente facturas emitidas a clientes por conceptos distintos a las ventas directas (servicios, alquiler, penalidades, intereses, etc.).
- Debe permitir seleccionar el cliente, concepto de la factura, moneda, tipo de cambio (si aplica) y centro de costo.
- El usuario podrá asociar cada registro a una cuenta contable de ingreso según el tipo de concepto.
- El sistema debe generar automáticamente el asiento contable correspondiente:
- Débito: Cuentas por Cobrar – Clientes
- Crédito: Cuenta de Ingresos (según concepto seleccionado)
- Debe permitir adjuntar un documento digital (PDF, XML u otro) como respaldo de la factura.
- El sistema validará que el número de factura no esté duplicado dentro de la misma razón social y cliente.
- Debe mostrar automáticamente la razón social y país del usuario en sesión (solo lectura).
- El usuario podrá consultar, editar o anular facturas registradas, según su perfil de permisos.

**Integraciones:** Integración con Contabilidad: Genera y actualiza automáticamente los asientos contables por la emisión o anulación de la factura. Integración con Tesorería: Permite asociar el registro con futuros cobros o conciliaciones bancarias. Integración con Reportes Financieros: Actualiza la cartera de cuenta...

---

##### ﻿HU-FIN-OP-CC-004 - Relación de Facturas y Documentos por Cliente - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero consultar la relación detallada de todas las facturas y documentos emitidos por cliente, para analizar su estado, vencimientos y saldos pendientes, con el fin de mejorar el control de la cartera y la gestión de cobranza.

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Cuentas por Cobrar > Relación de Facturas y Documentos por Cliente

**Criterios de Aceptación clave:**

- El sistema debe permitir consultar todas las facturas, notas de crédito, notas de débito, letras u otros documentos relacionados con un cliente específico.
- Debe mostrar para cada documento: número, tipo, fecha de emisión, fecha de vencimiento, monto total, monto cobrado y saldo pendiente.
- El usuario podrá filtrar la información por cliente, rango de fechas, tipo de documento, estado, sucursal o moneda.
- El sistema debe permitir visualizar el asiento contable asociado a cada documento.
- Debe incluir opciones para exportar la relación en formatos Excel y PDF.
- El sistema debe mostrar totales agrupados por cliente y tipo de documento.
- Sólo se mostrarán datos correspondientes a la Razón Social y País activos en la sesión del usuario (sólo lectura).
- Toda acción de consulta, exportación o visualización de asiento contable debe registrarse en el log de auditoría contable (Usuario, Fecha, Hora, IP, Acción).

**Integraciones:** Integración con Contabilidad: Permite visualizar los asientos contables asociados a cada documento y su impacto en cuentas por cobrar. Integración con Ventas: Muestra la trazabilidad entre documentos de venta y cobranzas realizadas. Integración con Tesorería: Permite vincular los pagos aplicados a l...

---

##### ﻿HU-FIN-OP-CP-002 - Reprogramación del Vencimiento del Documento por Pagar y Aplicación de Canje CxC vs CxP - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero poder reprogramar la fecha o pasar a cuotas de vencimiento un documento por pagar y/o aplicar un canje entre cuentas por cobrar (CxC) y cuentas por pagar (CxP) de un mismo tercero, para mantener actualizados los plazos de pago, reflejar compensaciones financieras y asegurar la integridad contable en las operaciones con proveedores y clientes vinculados.

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Cuentas por Pagar > Reprogramación y Canje CxC vs CxP

**Criterios de Aceptación clave:**

- El sistema debe permitir reprogramar la fecha de vencimiento de facturas por pagar seleccionadas que se encuentren en estado “Aprobada” o “Pendiente de Pago”.
- Al ejecutar la reprogramación, el usuario deberá registrar la nueva fecha de vencimiento, el motivo de la modificación y el documento de sustento (por ejemplo, acuerdo o correo autorizado).
- Toda reprogramación debe registrarse en el log de auditoría contable indicando: Usuario, Fecha, Hora, Acción, IP, Documento, Fecha Anterior y Nueva Fecha.
- El sistema debe permitir aplicar un canje entre CxC y CxP cuando un tercero (cliente/proveedor) tenga documentos pendientes en ambos módulos, siempre que la moneda y la razón social sean las mismas.
- Debe verificarse que los montos coincidan total o parcialmente. En caso de canje parcial, el sistema debe ajustar los saldos pendientes en ambos documentos.
- El canje debe generar automáticamente los asientos contables:
- Débito: Cuentas por Pagar
- Crédito: Cuentas por Cobrar
- Una vez aplicado el canje, los documentos involucrados deben quedar con estado “Compensado” y no podrán ser modificados ni eliminados.
- El sistema debe permitir visualizar el historial de reprogramaciones y canjes asociados a cada proveedor o cliente.

**Integraciones:** Integración con Cuentas por Cobrar: Permite identificar los documentos pendientes del mismo tercero para aplicar el canje. Integración con Contabilidad: Genera automáticamente los asientos contables por reprogramación o compensación. Integración con Tesorería: Actualiza el calendario de pagos según ...

---

##### ﻿HU-FIN-OP-CP-003 - Automatización de Registros de Transacciones Periódicas (Luz, Agua, Internet, Alquiler) - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero que el sistema registre automáticamente las transacciones recurrentes de gastos fijos, como servicios públicos (luz, agua, internet) y alquileres, para evitar la carga manual repetitiva, garantizar la oportunidad de registro contable y mantener actualizadas las cuentas por pagar mensuales.

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Cuentas por Pagar > Programación Automática de Transacciones Periódicas

**Criterios de Aceptación clave:**

- El sistema debe permitir configurar plantillas de transacciones automáticas para cada tipo de gasto periódico, indicando:
- Proveedor
- Tipo de Gasto
- Cuenta Contable
- Periodicidad (Mensual, Bimensual, Trimestral, Anual)
- Día de Ejecución (por ejemplo, el día 1 o 5 de cada mes)
- Monto Fijo o Variable
- Moneda
- Centro de Costo
- Sucursal o Local

**Integraciones:** Integración con Contabilidad: Genera los asientos contables automáticos de gasto y cuenta por pagar según la configuración. Integración con Tesorería: Actualiza el calendario de pagos futuros con base en las fechas de ejecución programadas. Integración con Proveedores: Recupera automáticamente los d...

---

##### ﻿HU-FIN-OP-CP-004 - Consulta y Edición de Registros por Proveedor con Visualización del Asiento Contable - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero consultar los registros de cuentas por pagar agrupados por proveedor, con la posibilidad de editar ciertos datos grabados y visualizar el asiento contable asociado, para verificar la información registrada, corregir errores y mantener la integridad de los estados financieros.

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Cuentas por Pagar > Consulta de Registros por Proveedor

**Criterios de Aceptación clave:**

- El sistema debe permitir la consulta de todos los documentos registrados en cuentas por pagar, filtrados por proveedor, tipo de documento, fecha o estado.
- Debe mostrar un listado con los campos más relevantes: N° de Documento, Tipo, Fecha de Emisión, Fecha de Vencimiento, Monto, Moneda, Estado, y Asiento Contable Asociado.
- El usuario podrá hacer clic en un documento para ver el detalle del registro, incluyendo las líneas del asiento contable (cuentas debitadas y acreditadas).
- Las ediciones permitidas estarán limitadas a los siguientes campos:
- Fecha de vencimiento (documento)
- Centro de costo (documento)
- Descripción / Glosa (asiento)
- Observaciones (asiento)
- Solo los usuarios con rol Analista Contable o superior podrán editar los campos mencionados.
- Si se realiza una modificación, el sistema debe actualizar el asiento contable si el cambio afecta la imputación o centro de costo, generando un nuevo asiento con referencia al anterior.

**Integraciones:** Integración con Contabilidad: Permite visualizar el asiento contable vinculado a cada registro y actualizarlo automáticamente si se realizan modificaciones. Integración con Tesorería: Refleja en tiempo real los documentos pagados o pendientes de pago. Integración con Proveedores: Sincroniza la infor...

---

##### ﻿HU-FIN-OP-CP-005 - Relación de Facturas y Documentos por Proveedor - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero obtener una relación detallada de todas las facturas y documentos asociados a cada proveedor (notas de crédito, débito, retenciones, pagos, entre otros), para analizar el estado de cuenta, verificar saldos pendientes y facilitar la conciliación de cuentas por pagar.

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Cuentas por Pagar > Relación de Facturas y Documentos por Proveedor

**Criterios de Aceptación clave:**

- El sistema debe permitir consultar, por proveedor, todos los documentos registrados en cuentas por pagar:
- Facturas
- Notas de Crédito
- Notas de Débito
- Retenciones
- Pagos realizados o pendientes
- Canjes CxC vs CxP
- El usuario podrá filtrar la información por rango de fechas, tipo de documento, estado, sucursal y moneda.
- El sistema debe mostrar la información agrupada por proveedor, con subtotales por tipo de documento y saldo general del proveedor.
- El listado debe incluir totales por columna (Monto Total, Pagado, Pendiente, Retenido).

**Integraciones:** Integración con Contabilidad: Permite acceder al asiento contable de cada documento registrado. Integración con Tesorería: Muestra pagos asociados a cada factura o documento. Integración con Proveedores: Sincroniza la información del maestro de proveedores (nombre, identificación, condiciones de pag...

---

##### ﻿HU-FIN-REP-CC-001 - Estado de Documentos y Clientes / Estado de Cuenta del Cliente - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero consultar un reporte del estado de cuenta de los clientes, que detalle todos los documentos emitidos, pagos recibidos, notas de crédito, letras de cambio y saldos pendientes, para conocer la situación financiera actual de cada cliente y gestionar eficientemente las cobranzas.

**Navegación:** Ruta: Menú Principal > Finanzas > Reportes > Reporte de Cuentas por Cobrar > Estado de Documentos y Clientes / Estado de Cuenta del Cliente

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Seleccionar uno o varios clientes para generar su estado de cuenta.
- Mostrar todos los documentos emitidos (facturas, boletas, letras, notas de crédito y débito).
- Incluir los pagos registrados, anticipos aplicados y saldos pendientes.
- Calcular automáticamente el saldo actual y vencido del cliente.
- Permitir filtrar por cliente, rango de fechas, tipo de documento, estado del documento (pendiente, pagado, vencido, anulado) y moneda.
- Visualizar el detalle de cada documento, incluyendo su asiento contable asociado.
- Mostrar totales por moneda, cliente y sucursal.
- Exportar el reporte en Excel o PDF.
- Registrar toda consulta, exportación o actualización en el log de auditoría contable (Usuario, Fecha, Hora, IP, Cliente, Acción).

**Integraciones:** Integración con Cuentas por Cobrar: Para obtener los documentos emitidos y pagos registrados por cliente. Integración con Ventas: Para vincular facturas y boletas emitidas desde el módulo de ventas. Integración con Tesorería: Para reflejar pagos, anticipos y notas de crédito aplicadas a las cuentas ...

---

##### ﻿HU-FIN-REP-CP-001 - Detalle de Facturas de Proveedores Registradas en Cuentas por Pagar - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte detallado de las facturas registradas en el submódulo de Cuentas por Pagar, para visualizar la información de los documentos pendientes, cancelados o vencidos por proveedor, con el fin de controlar los compromisos financieros y planificar los pagos de manera eficiente.

**Navegación:** Ruta: Menú Principal > Finanzas > Reportes > Reporte de Cuentas por Pagar > Detalle de Facturas de Proveedores

**Criterios de Aceptación clave:**

- El sistema debe mostrar todas las facturas registradas en cuentas por pagar, diferenciando su estado (pendiente, pagada, vencida o anulada).
- Cada registro debe incluir la información completa del documento: proveedor, número de factura, fecha de emisión, fecha de vencimiento, monto, moneda, estado, saldo pendiente y cuenta contable asociada.
- Debe permitir filtrar por proveedor, rango de fechas, estado, sucursal, país, moneda y centro de costo.
- El usuario podrá visualizar el asiento contable vinculado a cada factura.
- Debe incluir un totalizador por proveedor y un total general consolidado.
- El reporte debe poder exportarse en Excel y PDF.
- Sólo se mostrarán los datos correspondientes a la razón social y país activos en la sesión del usuario (campos de solo lectura).
- Toda consulta o exportación debe registrarse en el log de auditoría contable (Usuario, Fecha, Hora, IP, Acción, Proveedor, Documento).

**Integraciones:** Integración con Cuentas por Pagar: Para obtener los registros actualizados de facturas y su estado de pago. Integración con Tesorería: Para reflejar los pagos efectuados y actualizar los saldos pendientes. Integración con Contabilidad: Para mostrar los asientos contables vinculados y validar la cons...

---

##### ﻿HU-FIN-REP-CP-002 - Reporte de las Obligaciones por Vencer - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte que muestre todas las obligaciones pendientes de pago que se encuentran próximas a su fecha de vencimiento, con el fin de planificar la gestión de pagos, prever flujos de caja y cumplir oportunamente con los compromisos financieros del restaurante.

**Navegación:** Ruta: Menú Principal > Finanzas > Reportes > Reporte de Cuentas por Pagar > Reporte de las Obligaciones por Vencer

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Mostrar todas las obligaciones registradas en cuentas por pagar con vencimiento dentro del rango de fechas seleccionado.
- Clasificar los documentos por proveedor, tipo de documento, fecha de emisión, fecha de vencimiento, monto y estado.
- Permitir filtrar por proveedor, rango de fechas de vencimiento, tipo de documento, sucursal, país, moneda o estado del documento.
- Calcular y mostrar el número de días restantes para el vencimiento.
- Incluir información del asiento contable asociado a cada obligación.
- Mostrar totales y subtotales por proveedor y por moneda.
- Permitir exportar el reporte en Excel o PDF.
- Registrar toda consulta, exportación o actualización en el log de auditoría contable (Usuario, Fecha, Hora, IP, Proveedor, Acción).
- Solo se mostrará la información correspondiente a la razón social y país activos del usuario (campos de solo lectura).

**Integraciones:** Integración con Cuentas por Pagar: Para extraer la información de todas las obligaciones pendientes y próximas a vencer. Integración con Tesorería: Para planificar los pagos de acuerdo con las fechas de vencimiento y disponibilidad de fondos. Integración con Contabilidad: Para validar los saldos y l...

---

##### ﻿HU-FIN-REP-FN-001 - Reporte de Documentos Ingresados Directamente en Finanzas - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte que muestre todos los documentos registrados directamente en el módulo de Finanzas y que no provienen de otros módulos (como Compras, Ventas o Tesorería), con el fin de controlar y auditar los movimientos financieros ingresados de forma manual, garantizando su trazabilidad y validez contable.

**Navegación:** Ruta: Menú Principal > Finanzas > Reportes > Reporte de Finanzas > Documentos Ingresados Directamente en Finanzas

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Mostrar todos los documentos financieros registrados directamente en el módulo de Finanzas y que no estén vinculados a otros módulos.
- Incluir información del documento como tipo, número, fecha, monto, moneda, cuenta contable, proveedor/cliente asociado y usuario que lo registró.
- Permitir filtrar por tipo de documento, fecha de registro, usuario, sucursal, país o estado del documento.
- Mostrar el asiento contable relacionado con cada documento.
- Identificar el origen del documento (directo, integrado, automático).
- Permitir exportar el reporte en Excel y PDF.
- Registrar toda consulta, exportación o actualización en el log de auditoría contable (Usuario, Fecha, Hora, IP, Documento, Acción).
- Mostrar únicamente los datos correspondientes a la razón social y país activos del usuario (campos de solo lectura).

**Integraciones:** Integración con Contabilidad: Para mostrar el asiento contable generado y validar que el registro esté correctamente contabilizado. Integración con Auditoría Contable: Para rastrear quién registró el documento, cuándo y qué modificaciones realizó. Integración con Reportes Financieros: Para incluir l...

---

##### ﻿HU-FIN-REP-TS-001 - Reporte Integral de Movimientos en Bancos y Caja - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero generar un reporte integral de todos los movimientos realizados en las cuentas bancarias y cajas, que incluya ingresos, egresos, transferencias y conciliaciones, con el fin de obtener una visión consolidada del flujo de dinero y facilitar el control financiero diario.

**Navegación:** Ruta: Menú Principal > Finanzas > Reportes > Reporte de Tesorería > Reporte Integral de Movimientos en Bancos y Caja

**Criterios de Aceptación clave:**

- El sistema debe mostrar todos los movimientos registrados en bancos y cajas dentro del rango de fechas seleccionado.
- Cada registro debe incluir la información del tipo de movimiento (ingreso, egreso, transferencia, pago, cobranza, comisión bancaria, ajuste, etc.), así como los datos del documento asociado (número, fecha, referencia contable, usuario, sucursal y cuenta involucrada).
- Debe permitir filtrar por tipo de cuenta (banco o caja entidad bancaria), cuenta específica, rango de fechas, tipo de movimiento, sucursal, usuario, moneda y país.
- El usuario podrá ver el asiento contable relacionado con cada movimiento.
- Debe permitir exportar el reporte en Excel y PDF.
- Sólo se mostrarán los datos correspondientes a la razón social y país activos en la sesión del usuario (campos de solo lectura).
- Toda consulta, exportación o actualización debe registrarse en el log de auditoría contable (Usuario, Fecha, Hora, IP, Cuenta, Documento).

**Integraciones:** Integración con Tesorería: Para obtener todos los movimientos de ingresos, egresos, transferencias y conciliaciones. Integración con Cuentas por Pagar y Cuentas por Cobrar: Para reflejar los pagos y cobros registrados desde dichos subprocesos. Integración con Contabilidad: Para mostrar los asientos ...

---

##### ﻿HU-FIN-TAB-001 - Documentos Financieros que se Usan en el Módulo de Finanzas - v1.0

**Descripción:** 4. Debe permitir asociar cada documento a una cuenta contable predeterminada (ej. Bancos, Caja, Cuentas por Pagar, etc.).              5. El listado debe mostrar todos los documentos registrados con opciones de búsqueda y filtros por estado, tipo o uso.              6. El sistema debe permitir exportar el listado a Excel o PDF.              7. Las acciones de alta, modificación o baja deben registrarse en el log de auditoría contable (usuario, fecha, hora, acción).              8. Solo los usuar...

**Navegación:** Ruta: Menú Principal > Finanzas > Tablas > Documentos Financieros

**Criterios de Aceptación clave:**

- El sistema debe permitir registrar, modificar, consultar y desactivar tipos de documentos financieros.
- Cada documento debe tener asignados los siguientes campos obligatorios:
- Código del documento (alfanumérico, único).
- Nombre del documento.
- Tipo de documento (Ingreso / Egreso / Transferencia / Otros).
- Naturaleza contable (Débito / Crédito).
- Uso (Pagos / Cobranzas / Tesorería / Conciliación  / Otros).
- Requiere número de referencia bancaria (Sí / No).
- Requiere número de comprobante (Sí / No).
- Estado (Activo / Inactivo).

**Integraciones:** * Integración con Contabilidad: los documentos financieros deben vincularse automáticamente a las cuentas contables definidas.                             * Integración con Tesorería: los documentos estarán disponibles al registrar pagos, cobranzas o transferencias.                             * Int...

---

##### ﻿HU-FIN-TAB-002 - Detalle de Cada Movimiento para Identificar de Qué Proviene o Hacia Dónde Va el Dinero - v1.0

**Descripción:** 5. El listado debe mostrar todos los conceptos registrados con filtros por tipo, estado y categoría.              6. Cada movimiento financiero deberá asociarse obligatoriamente a un concepto definido en esta tabla.              7. El sistema debe permitir vincular un concepto con múltiples tipos de documentos financieros (ej. un “Pago a Proveedor” puede usar cheque o transferencia).              8. Los conceptos deben ser reutilizables en los módulos de Finanzas, Contabilidad, Compras, Ventas y...

**Navegación:** Ruta: Menú Principal > Finanzas > Tablas > Conceptos Financieros

**Criterios de Aceptación clave:**

- El sistema debe permitir registrar, modificar, consultar y desactivar conceptos financieros.
- Cada concepto debe incluir información que identifique si representa un origen de fondos (ingreso) o un uso de fondos (egreso).
- Los campos mínimos a registrar son:
- Código del Concepto (único)
- Nombre del movimiento (obligatorio)
- Tipo de Movimiento (Ingreso / Egreso / Transferencia / Ajuste)
- Categoría (Operativo, Financiero, Extraordinario, Otros)
- Naturaleza Contable (Débito / Crédito)
- Cuenta Contable Asociada (selector del plan contable)
- Origen o Destino (Proveedor / Cliente / Empleado / Entidad Bancaria / Otro)

**Integraciones:** * Integración con Contabilidad: los conceptos determinan las cuentas contables automáticas en los asientos generados.                             * Integración con Tesorería: los conceptos alimentan el detalle de los movimientos en caja y bancos.                             * Integración con Compras...

---

##### ﻿HU-FIN-TAB-003 - Estructura que Permite Agrupar los Conceptos Financieros - v1.0

**Descripción:** Como usuario financiero del sistema Restaurant.pe, quiero definir una estructura jerárquica de agrupación de conceptos financieros, que me permita clasificar los movimientos de ingresos y egresos en grupos y subgrupos de flujo de caja, para generar reportes financieros analíticos y consolidados que faciliten la toma de decisiones estratégicas.

**Navegación:** Ruta: Menú Principal > Finanzas > Tablas > Grupos y Códigos de Flujos de Caja

**Criterios de Aceptación clave:**

- El sistema debe permitir crear, editar, consultar y desactivar grupos de flujos de caja.
- Cada grupo podrá tener subgrupos, generando una estructura jerárquica (Ej. “Ingresos Operativos > Ventas Nacionales > Efectivo”).
- Los campos mínimos del formulario son:
- Código del Grupo (único)
- Descripción del Grupo (obligatorio)
- Tipo de Flujo (Ingreso / Egreso)
- Nivel Jerárquico (1 = Principal, 2 = Subgrupo, 3 = Detalle)
- Grupo Padre (opcional, si aplica)
- Naturaleza Contable (Débito / Crédito)
- Estado (Activo / Inactivo)

**Integraciones:** * Integración con Conceptos Financieros (HU-FIN-TAB-002): permite asociar cada concepto al grupo de flujo de caja correspondiente.                             * Integración con Contabilidad: los grupos alimentan reportes contables y estados financieros (flujo de caja directo e indirecto).           ...

---

##### ﻿HU-FIN-TES-TES-001 - Lista de Documentos por Pagar Pendientes, con Opción de Programar, eliminar ó Transferir - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero visualizar una lista consolidada de todos los documentos por pagar pendientes, con la posibilidad de programar pagos, eliminar o transferir documentos, para gestionar eficientemente las obligaciones financieras y optimizar el flujo de caja.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Lista de Documentos por Pagar Pendientes

**Criterios de Aceptación clave:**

- El sistema debe mostrar una lista completa de documentos pendientes de pago (facturas, letras, notas de débito, etc.) generados desde el módulo de Cuentas por Pagar.
- Cada registro debe incluir información del proveedor, tipo de documento, número, fecha de emisión, vencimiento, monto total, monto pendiente, moneda y estado.
- El usuario podrá realizar las siguientes acciones desde la lista:
- Programar Pago: Definir la fecha y medio de pago (transferencia, cheque, efectivo).
- Pagar Documento: Registrar el pago inmediato, generando el asiento contable correspondiente.
- Eliminar Documento: Quitar documentos erróneos o duplicados, siempre que no tengan pagos asociados.
- Transferir Documento: Mover el documento a otra sucursal o razón social (si aplica y el usuario tiene permisos).
- El sistema debe generar automáticamente los asientos contables al realizar el pago:
- Débito: Cuentas por Pagar – Proveedor
- Crédito: Caja o Banco

**Integraciones:** Integración con Cuentas por Pagar: Permite obtener automáticamente los documentos pendientes generados en dicho módulo. Integración con Contabilidad: Genera los asientos contables por programación, ejecución o eliminación del pago. Integración con Bancos y Caja: Registra el movimiento financiero del...

---

##### ﻿HU-FIN-TES-TES-002 - Lista de Cuentas por Cliente y Control del Vencimiento: Registrar, Aplicar Pagos, Anticipos y Notas de Crédito - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero acceder a una lista de cuentas por cliente que me permita controlar los vencimientos, registrar pagos, aplicar anticipos y notas de crédito, para gestionar de manera eficiente la cartera de cobranza y mantener la contabilidad actualizada.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Lista de Cuentas por Cliente y Control del Vencimiento

**Criterios de Aceptación clave:**

- El sistema debe mostrar una lista de todas las cuentas por cobrar por cliente, incluyendo facturas, letras, notas de débito y otros documentos emitidos.
- Debe permitir filtrar la información por cliente, rango de fechas, estado del documento, moneda, sucursal y rango de vencimiento.
- El usuario podrá realizar las siguientes acciones:
- Registrar Pago: Registrar un pago recibido (efectivo, cheque, transferencia, tarjeta, etc.) y aplicarlo a los documentos seleccionados.
- Aplicar Anticipo: Utilizar anticipos previamente registrados para cancelar o reducir el saldo de un documento.
- Aplicar Nota de Crédito: Aplicar una nota de crédito para disminuir el saldo pendiente del cliente.
- Consultar Detalle de Documento: Ver información contable y comercial de cada documento.
- El sistema debe mostrar el monto total de la deuda del cliente, el total cobrado, el saldo pendiente y el monto vencido.
- Debe generar automáticamente los asientos contables al registrar o aplicar pagos, anticipos o notas de crédito:
- Débito: Caja o Banco / Cuentas por Cobrar – Anticipos

**Integraciones:** Integración con Contabilidad: Genera automáticamente los asientos contables de pagos, anticipos y notas de crédito aplicadas. Integración con Ventas: Relaciona los pagos y notas de crédito con los documentos de venta emitidos. Integración con Tesorería: Actualiza los saldos de caja y bancos al regis...

---

##### ﻿HU-FIN-TES-TES-003 - Cancelación de Varios Documentos de Uno o Varios Proveedores - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero poder realizar la cancelación simultánea de varios documentos pendientes de uno o varios proveedores, utilizando un solo proceso de pago, para optimizar el tiempo de gestión de tesorería y asegurar la correcta actualización contable y financiera.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Cancelación de Varios Documentos

**Criterios de Aceptación clave:**

- El sistema debe permitir seleccionar múltiples documentos pendientes de pago (facturas, letras, notas de débito, etc.) desde la lista de Cuentas por Pagar.
- Debe permitir agrupar documentos por proveedor o realizar cancelaciones cruzadas para varios proveedores, siempre que el medio de pago sea el mismo (transferencia, cheque, efectivo, etc.).
- El usuario podrá realizar las siguientes acciones:
- Seleccionar Documentos Pendientes: Filtros por proveedor, rango de fechas, tipo de documento, moneda o estado.
- Definir Medio de Pago: Caja, banco, transferencia, cheque o efectivo.
- Ejecutar Cancelación: Registrar el pago y generar los asientos contables correspondientes.
- Generar Comprobante de Pago Consolidado: Documento que detalle todos los pagos realizados y los documentos cancelados.
- Consultar Asiento Contable: Ver el asiento generado por la operación consolidada.
- El sistema debe generar automáticamente los asientos contables al confirmar la cancelación:
- Débito: Cuentas por Pagar – Proveedor(es)

**Integraciones:** Integración con Cuentas por Pagar: Permite obtener la lista de documentos pendientes y actualizarlos como “Pagados” tras la cancelación. Integración con Contabilidad: Genera automáticamente los asientos contables de pago consolidado. Integración con Bancos y Caja: Registra los movimientos financiero...

---

##### ﻿HU-FIN-TES-TES-004 - Registro de Pagos y Anticipos Efectuados a Proveedores - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero registrar los pagos y anticipos efectuados a proveedores, de forma manual o automática, para mantener un control exacto de los desembolsos y su correcta imputación contable, garantizando la trazabilidad y conciliación de las operaciones de tesorería.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Registro de Pagos y Anticipos a Proveedores

**Criterios de Aceptación clave:**

- El sistema debe permitir registrar manualmente o de forma automática (desde programación de pagos) los pagos y anticipos realizados a proveedores.
- Debe ofrecer opciones para seleccionar el proveedor, el tipo de documento a cancelar o anticipar, la cuenta contable de pago y el medio de pago (efectivo, transferencia, cheque, tarjeta, etc.).
- El usuario podrá realizar las siguientes acciones:
- Registrar Pago: Asociar el pago a uno o varios documentos pendientes del proveedor.
- Registrar Anticipo: Registrar un pago sin documento asociado, que podrá aplicarse posteriormente a facturas del mismo proveedor.
- Aplicar Anticipo: Aplicar el anticipo a documentos por pagar futuros.
- Consultar Asiento Contable: Visualizar el asiento generado por el pago o anticipo.
- Anular o Revertir Pago: Permitir la anulación de un pago siempre que no esté conciliado o aplicado.
- El sistema debe generar automáticamente los asientos contables correspondientes:
- Pago de Documento:

**Integraciones:** Integración con Cuentas por Pagar: Actualiza los documentos cancelados y registra los anticipos como saldo a favor del proveedor. Integración con Contabilidad: Genera automáticamente los asientos contables asociados al pago o anticipo. Integración con Bancos y Caja: Registra el movimiento financiero...

---

##### ﻿HU-FIN-TES-TES-005 - Anulación o Reversión de Pagos Mal Registrados o Duplicados - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero poder anular o revertir pagos que hayan sido registrados de manera incorrecta o duplicada, para mantener la integridad de la información contable y financiera, evitando inconsistencias en las cuentas por pagar, los saldos bancarios y los reportes financieros.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Anulación o Reversión de Pagos

**Criterios de Aceptación clave:**

- El sistema debe permitir seleccionar un pago registrado y realizar su anulación o reversión, dependiendo del estado del mismo.
- Anulación: Aplica cuando el pago fue registrado por error y aún no está conciliado ni aplicado a documentos.
- Reversión: Aplica cuando el pago ya fue contabilizado o aplicado, y requiere un asiento contable inverso.
- El usuario podrá realizar las siguientes acciones:
- Buscar y seleccionar el pago a anular o revertir.
- Visualizar el detalle del pago (proveedor, documentos afectados, monto, fecha, cuenta contable, asiento asociado).
- Confirmar la acción mediante una ventana de validación con justificación obligatoria.
- Generar automáticamente el asiento contable de reversión cuando aplique.
- Consultar el historial de anulaciones o reversiones realizadas.
- El sistema debe generar automáticamente los asientos contables correspondientes:

**Integraciones:** Integración con Cuentas por Pagar: Restablece el estado de los documentos afectados por el pago anulado o revertido. Integración con Contabilidad: Genera los asientos contables inversos o elimina los registros asociados al pago anulado. Integración con Bancos y Caja: Actualiza automáticamente los sa...

---

##### ﻿HU-FIN-TES-TES-006 - Movimiento entre Cuentas Bancarias y Cajas - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero registrar los movimientos de transferencia de fondos entre cuentas bancarias y cajas, ya sea dentro de la misma razón social o entre sucursales, para mantener actualizado el control de tesorería y reflejar correctamente los saldos disponibles en la contabilidad.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Movimiento entre Cuentas Bancarias y Cajas

**Criterios de Aceptación clave:**

- El sistema debe permitir registrar movimientos de transferencia de fondos entre:
- Cuentas bancarias de la misma razón social.
- Cajas de distintas sucursales.
- Cuentas bancarias y cajas (ida o vuelta).
- El usuario podrá realizar las siguientes acciones:
- Registrar Movimiento: Definir cuenta de origen, cuenta de destino, monto, moneda, tipo de cambio (si aplica), fecha y medio de transferencia.
- Adjuntar Comprobante: Permitir cargar documentos de respaldo (voucher, transferencia, comprobante interno).
- Consultar Asiento Contable: Visualizar el asiento generado por el movimiento.
- Anular Movimiento: Permitir anular una transacción errónea, si no ha sido conciliada.
- El sistema debe generar automáticamente los asientos contables:

**Integraciones:** Integración con Contabilidad: Genera y registra automáticamente los asientos contables de movimiento interno. Integración con Bancos y Caja: Actualiza los saldos disponibles de cada cuenta. Integración con Reportes Financieros: Refleja las transferencias en los flujos de efectivo y conciliaciones ba...

---

##### ﻿HU-FIN-TES-TES-007 - Programación de Pagos por Realizar por Vencimientos - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero programar los pagos de documentos por vencer o vencidos, de manera que el sistema me permita planificar y ejecutar los desembolsos conforme a las fechas de vencimiento, priorizando las obligaciones más urgentes y asegurando una adecuada gestión del flujo de caja.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Programación de Pagos por Vencimientos

**Criterios de Aceptación clave:**

- El sistema debe mostrar un listado de documentos por pagar (facturas, letras, notas de débito, etc.) con sus respectivas fechas de vencimiento, proveedor y monto.
- El usuario podrá realizar las siguientes acciones:
- Programar Pago: Seleccionar documentos por pagar y asignar fecha, cuenta bancaria o caja desde la cual se realizará el desembolso.
- Priorizar Pagos: Definir criterios de prioridad (por vencimiento, monto o proveedor).
- Editar Programación: Modificar la fecha o cuenta asignada antes de la ejecución del pago.
- Cancelar Programación: Anular una programación pendiente si aún no ha sido ejecutada.
- Visualizar Asiento Contable: Consultar el asiento generado una vez se efectúe el pago.
- El sistema debe permitir filtrar los documentos por:
- Fecha de emisión o vencimiento
- Proveedor

**Integraciones:** Integración con Cuentas por Pagar: Para obtener los documentos pendientes y su estado de vencimiento. Integración con Tesorería - Pagos: Para ejecutar los pagos programados desde las cuentas seleccionadas. Integración con Contabilidad: Para registrar automáticamente los asientos contables de pago un...

---

##### ﻿HU-FIN-TES-TES--008 - Asignación de Fondo Fijo de Caja por Punto de Venta - v1. Título

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero registrar y controlar el dinero asignado como fondo fijo a cada punto de venta, con el propósito de disponer de efectivo para dar cambio a los clientes, garantizando que dicho fondo no sea utilizado para gastos menores ni otras operaciones ajenas a la atención diaria.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Fondo Fijo de Caja por Punto de Venta

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar Fondos Fijos de Caja por punto de venta o sucursal.
- Asignar un monto inicial en moneda local o extranjera.
- Definir el responsable de la caja (usuario o cajero asignado).
- Bloquear el uso del fondo fijo para gastos menores, retiros o pagos no autorizados.
- Consultar el historial de asignaciones, ajustes y reposiciones.
- Generar asientos contables automáticos por la asignación y devolución del fondo.
- El sistema debe permitir controlar:
- Fecha de asignación del fondo.
- Monto autorizado.

**Integraciones:** Integración con Tesorería - Cajas: Para vincular la asignación del fondo con las cajas operativas. Integración con Contabilidad: Para registrar los asientos contables automáticos de asignación y reintegro del fondo fijo. Integración con Recursos Humanos: Para identificar al cajero o responsable desi...

---

##### ﻿HU-FIN-TES-TES-009 - Administración de Fondo Fijo y Caja Chica : Registro de Egresos Menores y Reposición de Caja Chica

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero administrar los fondos fijos y cajas chicas de cada sucursal, registrando los egresos menores y gestionando sus reposiciones de manera controlada, para garantizar la correcta rendición de gastos y mantener actualizados los saldos disponibles de fondo fijo y caja chica.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Administración de Caja Chica

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar egresos menores realizados con cargo a la caja chica .
- Adjuntar comprobantes o facturas de respaldo digitalizados.
- Controlar el saldo disponible del fondo fijo y el monto autorizado por sucursal o punto de venta.
- Solicitar la reposición de caja chica cuando el saldo se encuentre por debajo del mínimo establecido.
- Registrar la reposición del fondo una vez aprobada y efectuada por Tesorería.
- Generar los asientos contables automáticos de cada movimiento (egreso y reposición).
- Restringir el uso del fondo fijo exclusivamente a gastos operativos menores y autorizados.
- Consultar el historial de egresos, reposiciones y cierres por cada caja o responsable.
- El sistema debe validar:

**Integraciones:** Integración con Contabilidad: Para generar los asientos automáticos de egresos, reposiciones y cierres de caja chica. Integración con Tesorería - Bancos: Para reflejar las reposiciones de fondos desde cuentas bancarias. Integración con Recursos Humanos: Para identificar al responsable de caja y vali...

---

##### ﻿HU-FIN-TES-TES-010 - Proyección de Ingresos y Egresos - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero generar proyecciones automáticas de ingresos y egresos futuros basadas en la información registrada de ventas, cuentas por cobrar, cuentas por pagar y pagos programados, para anticipar la disponibilidad de efectivo y facilitar la planificación financiera del restaurante.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Proyección de Ingresos y Egresos

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Generar proyecciones automáticas tomando como base:
- Ventas registradas y pendientes de cobro (Cuentas por Cobrar).
- Facturas, letras y documentos por pagar (Cuentas por Pagar).
- Pagos programados en Tesorería.
- Gastos recurrentes (servicios, alquileres, nómina).
- Configurar el horizonte de proyección, por ejemplo: semanal, quincenal, mensual o trimestral.
- Visualizar las proyecciones en formato tabular y gráfico (flujo de caja proyectado).
- Filtrar información por sucursal, tipo de documento, categoría de ingreso/egreso o moneda.
- Registrar ajustes manuales a la proyección (por eventos extraordinarios).

**Integraciones:** Integración con Cuentas por Pagar: Para incluir facturas y pagos pendientes como egresos proyectados. Integración con Cuentas por Cobrar: Para incluir ingresos proyectados por cobranzas pendientes. Integración con Tesorería: Para cruzar con pagos programados y flujos de caja reales. Integración con ...

---

##### ﻿HU-FIN-TES-TES-011 - Registro en Tesorería de los Ingresos del Día Procesados por Ventas - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero que el sistema registre automáticamente en Tesorería los ingresos diarios generados por las ventas procesadas en los puntos de venta, para reflejar con precisión la entrada de efectivo y otros medios de pago en las cuentas correspondientes y facilitar el control de los flujos de caja diarios.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Registro de Ingresos del Día por Ventas

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar automáticamente los ingresos diarios provenientes del módulo de Ventas, según los medios de pago procesados (efectivo, tarjeta, transferencia, otros).
- Permitir el registro manual o ajuste de ingresos cuando existan diferencias o ingresos no procesados automáticamente.
- Mostrar el detalle de las ventas consolidadas por día, turno, sucursal y tipo de pago.
- Validar que el registro de ingresos corresponde a una fecha de cierre de caja previamente aprobada.
- Generar de forma automática el asiento contable correspondiente en Tesorería y Contabilidad.
- Permitir la asignación del ingreso a cuentas bancarias o cajas específicas.
- Registrar cualquier modificación o eliminación en el log de auditoría contable (Usuario, Fecha, Hora, Acción, Sucursal, Monto, Medio de Pago).
- Permitir la conciliación posterior de estos ingresos con los depósitos reales registrados en bancos.
- El sistema debe mostrar los ingresos del día agrupados por medio de pago y canal de venta (salón, delivery, take away).

**Integraciones:** Integración con Ventas: Para obtener el detalle de los ingresos diarios procesados por los puntos de venta. Integración con Cuentas por Cobrar: Para reflejar los cobros asociados a documentos pendientes. Integración con Bancos: Para facilitar la conciliación entre ingresos registrados y depósitos ef...

---

##### ﻿HU-FIN-TES-TES-012 - Ejecución de Pago al Ente Tributario desde Bancos - v1.0

**Descripción:** Como usuario del sistema contable de Restaurant.pe, quiero que el sistema me permita ejecutar los pagos al ente tributario directamente desde las cuentas bancarias registradas, para asegurar el cumplimiento de las obligaciones fiscales de manera oportuna, controlada y trazable dentro del módulo de Tesorería.

**Navegación:** Ruta: Menú Principal > Finanzas > Tesorería > Pagos Bancarios > Pago al Ente Tributario

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar las obligaciones tributarias pendientes de pago, provenientes del módulo de Contabilidad o de Compras (ej. IGV, IVA, Retenciones, detracciones, Renta, ISS, etc.).
- Mostrar la lista de entes tributarios según el país y razón social activa (SUNAT, DIAN, SII, SENIAT, DGII, DGI, etc.).
- Seleccionar la cuenta bancaria desde la cual se ejecutará el pago.
- Permitir ingresar o validar los datos del comprobante de pago (número de operación, fecha, monto, tipo de impuesto, periodo).
- Generar el asiento contable automático correspondiente (Bancos contra Tributos por Pagar).
- Adjuntar el comprobante bancario digital (voucher, PDF o XML).
- Validar que el pago no esté duplicado y que la cuenta bancaria tenga saldo suficiente.
- Registrar cada acción (registro, edición, anulación, ejecución) en el log de auditoría contable con detalle de usuario, fecha, hora, monto, banco y tipo de tributo.
- Permitir consultar el historial de pagos tributarios por fecha, tipo de tributo, banco y estado.

**Integraciones:** Integración con Contabilidad: Para generar los asientos automáticos del pago de tributos. Integración con Bancos: Para ejecutar la transacción bancaria y validar el saldo disponible. Integración con Cuentas por Pagar: Para registrar el cumplimiento de las obligaciones tributarias como canceladas. In...

---

##### ﻿HU-FIN-TES-TES-013 – Pago de Detracción - v1

**Descripción:** Como analista o tesorero, quiero registrar y ejecutar el pago de detracciones correspondientes a facturas o servicios sujetos al régimen de detracciones, desde el módulo de Finanzas, para cumplir con las obligaciones tributarias y mantener actualizada la información de pagos y constancias en el sistema.

**Navegación:** Ruta: Menú Principal → Finanzas → Tesorería → Pago de Detracciones

**Criterios de Aceptación clave:**

- El sistema debe listar todos los documentos tipo DE (Detracciones) pendientes de pago, que estén asociados a documentos de compra registrados en el módulo de Compras.
- Permitir seleccionar una o varias detracciones para pago individual o masivo.
- Permitir elegir la cuenta de origen (financiera o caja) desde la cual se efectuará el pago.
- Calcular automáticamente el importe total a pagar según las detracciones seleccionadas.
- Al seleccionar generar el archivo TXT, las detracciones seleccionadas pasarán al estado “Pendiente de Constancia”, bloqueando su edición o duplicación.
- Luego de cargar el txt al portal de SUNAT y este nos dé los números de constancia de cada documento pagado, en el ERP los documentos tipo DE con estado Pendiente de Constancia podrán ser seleccionados para registrar manualmente el número de constancia emitido por SUNAT o permitir cargar la constancia de pago en formato TXT y que el sistema reconozca y asigne los números de constancia de pago de cada factura y la fecha de pago. Una vez completado este registro, el usuario procederá a ejecutar el pago dentro del sistema, actualizando el estado a Pagada.
- Generar el asiento contable automático al confirmar el pago, afectando las cuentas de detracciones por pagar y la cuenta bancaria.
- Permitir exportar el comprobante de pago interno en PDF, Excel o TXT.
- Mantener trazabilidad completa de la operación (usuario, fecha, monto, cuenta de origen, constancia).

**Integraciones:** * Integración con Cuentas por Pagar:  Actualiza el estado de documentos asociados a “Detracción Pagada”.     * Integración con Contabilidad:  Genera asiento contable automático con la estructura definida para detracciones.     * Integración con Reportes Financieros:  Incluye la operación en los repo...

---

##### ﻿HU-FIN-OPE-004 – Aprobación de Liquidación de Rendición de Gastos

**Descripción:** Como usuario aprobador del módulo de Finanzas, quiero revisar, Observar, aprobar  o rechazar las liquidaciones de rendición de gastos registradas por colaboradores o proveedores (boletas, facturas, recibos, tickets), para asegurar que los comprobantes cumplen las normas internas y tributarias, verificar que los montos son correctos, y permitir la regularización del adelanto entregado, manteniendo trazabilidad y control financiero. ________________

**Navegación:** Ruta: Menú Principal > Finanzas > Operaciones > Rendición de gastos > Lista de liquidaciones > Seleccionar > Aprobar / Rechazar / Observar ________________

**Criterios de Aceptación clave:**

- 1. General
- El sistema debe permitir visualizar todas las liquidaciones en estado Pendiente, Observada, Aprobada y Rechazada.
- Solo usuarios con rol de aprobador podrán emitir un “Visto Bueno”.
- 2. Validación de Cabecera
- El sistema debe permitir revisar la información registrada:
- Fecha de desembolso
- Tipo de beneficiario (Proveedor / Colaborador)
- Documento del beneficiario (DNI, RUC, etc.)
- Beneficiario
- Centro de costo

---


### 2.5. Módulo de Contabilidad

> **Plan contable, asientos, libros electrónicos, reportes financieros y cierres**
> 
> HUs documentadas: **35** | Carpeta: `05_Contabilidad/`

#### Listado de Historias de Usuario

| # | Archivo | Título | Descripción resumida |
|---|---|---|---|
| 1 | `HU-CON-001.txt` | ﻿HU-CON-001 - Gestión de Plan Contable (Catálogo de Cuentas) - v1.0 | Como Contador de la Razón Social activa, quiero crear, modificar, consultar e importar el plan contable (catálogo de cue... |
| 2 | `HU-CON-001_1.txt` | ﻿HU-CON-001 - Maestro de Centros de Costo - v1.0 | El sistema debe permitir la creación, edición, consulta y desactivación de centros de costo, con el objetivo de asignar ... |
| 3 | `HU-CON-003.txt` | ﻿HU-CON-002 - Matriz Contable - v1.0 | El sistema debe permitir configurar reglas de integración contable con los diferentes módulos del sistema (Compras, Vent... |
| 4 | `HU-CON-004-.txt` | ﻿HU-CON-003 - Tipos de Detracción - v1.0 | El sistema debe permitir el registro, mantenimiento y consulta de los tipos de detracción, incluyendo su porcentaje apli... |
| 5 | `HU-CON-005.txt` | ﻿HU-CON-005 - Relacionar Subcategorías de Productos con Cuentas Contables - v1.0 | El sistema debe permitir establecer la relación automática entre subcategorías de producto y cuentas contables (gasto/co... |
| 6 | `HU-CON-006.txt` | ﻿HU-CON-006 - Registro de Asientos (Creación Manual) - v1.0 | El sistema debe permitir la creación, edición, consulta e inactivación de asientos contables manuales, registrando una c... |
| 7 | `HU-CON-008.txt` | ﻿HU-CON-008 — Ajustes y Reclasificación Contable | El sistema debe permitir registrar ajustes contables manuales, tales como provisiones, reclasificaciones y ajustes menor... |
| 8 | `HU-CON-008_1.txt` | ﻿HU-CON-008 - Ajustes y Reclasificación Contable - v1.0 | El sistema debe permitir realizar ajustes y reclasificaciones contables para mantener la integridad, exactitud y coheren... |
| 9 | `HU-CON-016-.txt` | ﻿HU-CON-016 - Análisis de Cuenta Contable | Como usuario del área contable, quiero consultar el análisis detallado de una cuenta contable en un periodo determinado,... |
| 10 | `httpsdocs.google.comdocumentd11MhXOFwOYmHEJJ7-7bCNpPbWDPuD22zPSh.txt` | ﻿HU-CON-012 - Reportes de Validación / Consistencia de Asientos Contables - v1.0 | El sistema debe permitir generar reportes de validación y consistencia contable que verifiquen el cuadre de los asientos... |
| 11 | `httpsdocs.google.comdocumentd11iWGAW0_1gmCixtzrPYEx10n6x4h2uVi8G.txt` | ﻿HU-CON-009 - Consulta de Saldos de Cuenta Corriente - v1.0 | El sistema debe permitir consultar los saldos y movimientos de las cuentas corrientes, tanto de cuentas por cobrar (CxC)... |
| 12 | `httpsdocs.google.comdocumentd17G_ptSzOW1jmXsyugoWmhztNEFsC4-SSpo.txt` | ﻿HU-CON-025 - Procesos / Validar Consistencia de Asientos Contables - v1.0 | El sistema debe permitir la validación automática de la consistencia de los asientos contables, verificando que el total... |
| 13 | `httpsdocs.google.comdocumentd18QTOIAfnzc-S3sswCoC7cyZIF1E5KwuY93.txt` | ﻿HU-CON-010 - Consulta de Centros de Costo por Trabajador - v1.0 | El sistema debe permitir consultar la imputación de costos a nivel de trabajadores o áreas, vinculada con los centros de... |
| 14 | `httpsdocs.google.comdocumentd19GUok37xrdosAsqtDJhf3Vwn00tfSW0SU8.txt` | ﻿HU-CON-018 - Reportes de Validación / Libro Diario - v1.0 | El sistema debe permitir la generación del reporte de Libro Diario, que contenga todos los asientos contables registrado... |
| 15 | `httpsdocs.google.comdocumentd1Dy4cyMTdTR7xhEW6dM_59CNOLp2prTmj5a.txt` | ﻿HU-CON-027 - Procesos / Clonación de Asientos Contables - v1.0 | El sistema debe permitir la clonación de asientos contables existentes, con el objetivo de agilizar el registro de trans... |
| 16 | `httpsdocs.google.comdocumentd1E6VDSW1pYoVO99dH1VemCYtYvWib_NElOl.txt` | ﻿HU-CON-028 - Procesos / Importación de Asientos Contables - v1.0 | El sistema debe permitir la importación masiva de asientos contables desde un archivo externo (por ejemplo, formato Exce... |
| 17 | `httpsdocs.google.comdocumentd1F-Wg8HJV63R8DA7u3EP3CP5zqk53KevA6K.txt` | ﻿HU-CON-015 - Reportes de Validación / Balance de Comprobación - v1.0 | El sistema debe permitir generar un reporte de Balance de Comprobación, mostrando por cada cuenta contable sus saldos in... |
| 18 | `httpsdocs.google.comdocumentd1NmMxf0sjvxCGXgfSnmh9LFl61amzySjHl6.txt` | ﻿HU-CON-021 - Reportes de Validación / Estado de Resultados - v1.0 | El sistema debe permitir la generación del reporte de Estado de Resultados, mostrando de manera estructurada los ingreso... |
| 19 | `httpsdocs.google.comdocumentd1P-E0QB2EHtN2GoKxty_qlC-YrIBKzhcKPW.txt` | ﻿HU-CON-024 - Procesos / Generar Libros Electrónicos - v1.0 | El sistema debe permitir la generación automática de libros contables electrónicos, de acuerdo con los formatos oficiale... |
| 20 | `httpsdocs.google.comdocumentd1PB00NqavHH7OxYni0sCfksaW_2-fGJLwlD.txt` | ﻿HU-CON-030 - Procesos / Ejecutar Cierre Contable Anual - v1.0 | El sistema debe permitir la ejecución del cierre contable anual, consolidando los resultados financieros del ejercicio y... |
| 21 | `httpsdocs.google.comdocumentd1TMiKCzXMHcHwFQOyr3QtlFJwjG__C4qeRC.txt` | ﻿HU-CON-020 - Reportes de Validación / Estado de Situación Financiera (Balance G | El sistema debe permitir la generación del reporte de Estado de Situación Financiera (Balance General), mostrando los ac... |
| 22 | `httpsdocs.google.comdocumentd1VLj1diG4Hbb2mNBNNhPuhftmEO_lPkh0_2.txt` | ﻿HU-CON-026 - Procesos / Registro de Ajustes Contables - v1.0 | El sistema debe permitir el registro, control y contabilización de ajustes contables, tales como  ajustes por diferencia... |
| 23 | `httpsdocs.google.comdocumentd1VcCYUUuOEK7r1vA34kvdHlva_XlV5CMXA7.txt` | ﻿HU-CON-023 - Reportes de Validación / Estado de Cambios en el Patrimonio Neto - | El sistema debe permitir la generación del reporte de Estado de Cambios en el Patrimonio Neto, mostrando las variaciones... |
| 24 | `httpsdocs.google.comdocumentd1WxSzSWHMzHIT2wY7Ef7gXNV_BACLGc3a_7.txt` | ﻿HU-CON-013 - Reportes de Validación / Consistencia de Preasientos Contables - v | El sistema debe permitir generar reportes de validación y consistencia de preasientos contables antes de su confirmación... |
| 25 | `httpsdocs.google.comdocumentd1XvurfDkThzXOS_tFuBSSHhz5-GjNoZhzZw.txt` | ﻿HU-CON-022 - Reportes de Validación / Estado de Flujos de Efectivo - v1.0 | El sistema debe permitir la generación del reporte de Estado de Flujos de Efectivo, que muestre de forma estructurada lo... |
| 26 | `httpsdocs.google.comdocumentd1exmsw1oaxG6X3z7xRFnb_8g4xVIVYGC1s-.txt` | ﻿HU-CON-011 - Reportes Diversos de Maestros Contables - v1.0 | El sistema debe permitir generar y consultar reportes diversos de los maestros contables, tales como el Plan de Cuentas,... |
| 27 | `httpsdocs.google.comdocumentd1f10fS1O_xpqHjMcHU6tn_e8AiZ7dHpEzu7.txt` | ﻿HU-CON-032 – Reporte Detallado de Pre Asientos – v1.0 | El sistema debe permitir la generación de un Reporte Detallado de Pre Asientos Contables, el cual muestre toda la inform... |
| 28 | `httpsdocs.google.comdocumentd1kCX19w_jrcSxnrRyLeXPbendDrCYMhZQef.txt` | ﻿HU-CON-031 – Matrices de Almacenes – v1.0 | El sistema debe permitir registrar, consultar, modificar y desactivar Matrices Contables de Almacén, las cuales permiten... |
| 29 | `httpsdocs.google.comdocumentd1kNuqHp3aHKVaGMRsqQRCr4AZionfDBkt9Z.txt` | ﻿HU-CON-016 - Reportes de Validación / Reportes Varios de Asientos Contables - v | El sistema debe permitir la generación de reportes de los asientos contables registrados en el sistema, aplicando filtro... |
| 30 | `httpsdocs.google.comdocumentd1n4KYAiSiya7huEKtmdoOz2SWHkWR8n0Vsx.txt` | ﻿HU-CON-007 - Modificación de Asiento Contable Automático - v1.0 | El sistema debe permitir la modificación controlada de asientos contables generados automáticamente (integraciones, proc... |
| 31 | `httpsdocs.google.comdocumentd1pb9AIQOMnORPqpsATNItKuDqwwKixlu4HA.txt` | ﻿HU-CON-029 - Procesos / Ejecutar Cierre Contable Mensual - v1.0 | El sistema debe permitir ejecutar el cierre contable mensual de manera controlada, asegurando que todos los movimientos ... |
| 32 | `httpsdocs.google.comdocumentd1r_1g-P7YM2oJtH3_Fa40cIpQtk8DBgxz90.txt` | ﻿HU-CON-033 – Autorización de Modificaciones de Asientos – v1.0 | El sistema debe permitir ejecutar un proceso de autorización para validar que un pre asiento contable está correcto y cu... |
| 33 | `httpsdocs.google.comdocumentd1sOqoWkmTjizUfSuR5JXwb5XDGAXdWNa0t8.txt` | ﻿HU-CON-019 - Reportes de Validación / Reportes Contables según formatos DIAN y  | El sistema debe permitir la generación de reportes contables oficiales en los formatos exigidos por las entidades tribut... |
| 34 | `httpsdocs.google.comdocumentd1vNu13oJpPlefiYxvEmxfvYspcRObua-eW-.txt` | ﻿HU-CON-014 - Reportes de Validación / Asientos Descuadrados - v1.0 | El sistema debe permitir generar reportes de validación de asientos contables descuadrados, mostrando aquellos registros... |
| 35 | `httpsdocs.google.comdocumentd1zohbDi4M7a1VLjAiiTIzVrcYtekDuTViiy.txt` | ﻿HU-CON-017 - Reportes de Validación / Libro Mayor - v1.0 | El sistema debe permitir la generación del reporte del Libro Mayor, conforme a los registros contables ingresados en el ... |

#### Detalle de cada HU

##### ﻿HU-CON-001 - Gestión de Plan Contable (Catálogo de Cuentas) - v1.0

**Descripción:** Como Contador de la Razón Social activa, quiero crear, modificar, consultar e importar el plan contable (catálogo de cuentas) para asegurar la consistencia contable y tributaria del país de operación, y habilitar la imputación correcta de asientos en todos los módulos integrados (Compras, Ventas, Almacén, RR. HH., Activos Fijos y Finanzas). Notas de contexto multipaís: El sistema opera una Razón Social por sesión. Cada Razón Social se asocia a un país (Perú, Colombia, Chile, Ecuador, R. Dominica...

**Criterios de Aceptación clave:**

- CA-1 – Crear cuenta válida
- Dado que estoy en Contabilidad > Plan Contable
- Y presiono "Nueva cuenta"
- Cuando ingreso Código válido según máscara, Nombre, Naturaleza, Tipo, Nivel y demás obligatorios
- Entonces el sistema guarda la cuenta, la muestra en el listado y registra la auditoría.
- CA-2 – Validar jerarquía
- Dado una cuenta de Nivel>1
- Cuando selecciono una Cuenta Padre inactiva o inexistente
- Entonces el sistema impide guardar y muestra un mensaje: "La cuenta padre debe existir y estar activa".
- CA-3 – Impedir eliminación con uso

---

##### ﻿HU-CON-001 - Maestro de Centros de Costo - v1.0

**Descripción:** El sistema debe permitir la creación, edición, consulta y desactivación de centros de costo, con el objetivo de asignar gastos e ingresos a áreas, proyectos, sucursales o unidades operativas de la razón social activa. Esta funcionalidad soporta la contabilidad analítica, permitiendo generar reportes financieros segmentados por centro de costo, y facilitar la toma de decisiones sobre rentabilidad por línea de negocio o punto de venta. ________________   3. Actor(es)    * Usuario Contable: Encarga...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- El sistema permite crear un nuevo centro de costo ingresando los campos obligatorios.
- Se guarda el registro y se muestra un mensaje de confirmación.
- Los campos Razón Social y País son informativos y no editables.
- El sistema los muestra automáticamente según la sesión activa.
- No se permite crear dos centros de costo con el mismo código dentro de la misma razón social.
- El sistema muestra un mensaje de validación.
- Se pueden modificar los datos descriptivos de un centro de costo existente.
- El sistema actualiza la información y registra el cambio en el log contable.

---

##### ﻿HU-CON-002 - Matriz Contable - v1.0

**Descripción:** El sistema debe permitir configurar reglas de integración contable con los diferentes módulos del sistema (Compras, Ventas, Almacenes, Planillas, Activos Fijos, etc.), definiendo la forma en que cada transacción genera asientos contables automáticos. La Matriz Contable actuará como un puente entre los módulos operativos y la contabilidad general, asegurando la correcta imputación de cuentas contables, centros de costo y naturaleza de los movimientos (cargo/abono), según la configuración establec...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- El sistema permite crear, editar y eliminar reglas de integración contable.
- Las reglas quedan registradas y activas según configuración.
- Los módulos operativos disponibles se muestran en una lista desplegable.
- El usuario selecciona el módulo para configurar su integración.
- No se pueden duplicar combinaciones de módulo + tipo de documento + operación.
- El sistema muestra un mensaje de validación.
- Se pueden definir múltiples cuentas contables según naturaleza de operación (débito/crédito).
- El sistema permite asociarlas correctamente.

---

##### ﻿HU-CON-003 - Tipos de Detracción - v1.0

**Descripción:** El sistema debe permitir el registro, mantenimiento y consulta de los tipos de detracción, incluyendo su porcentaje aplicable, vigencia y código SUNAT (cuando aplique). Esta funcionalidad será utilizada para parametrizar las operaciones de compras y ventas que requieren detracción según la normativa vigente del país (por ejemplo, Perú). El catálogo de Tipos de Detracción se integrará con los módulos de Compras, Ventas y Tesorería, para aplicar automáticamente la Detracción en los comprobantes y ...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- El sistema permite crear, editar, consultar e inactivar tipos de detracción.
- Los registros se actualizan correctamente y se guardan en la base de datos.
- No se permite crear dos detracciones con el mismo código SUNAT.
- El sistema muestra un mensaje de validación.
- Los campos RUC y País son informativos y no editables.
- Se cargan automáticamente según la sesión activa.
- Se puede definir la vigencia (fecha inicio y fin) de cada tipo de detracción.
- El sistema valida que no se crucen rangos de vigencia para el mismo tipo.

---

##### ﻿HU-CON-005 - Relacionar Subcategorías de Productos con Cuentas Contables - v1.0

**Descripción:** El sistema debe permitir establecer la relación automática entre subcategorías de producto y cuentas contables (gasto/costo, ingreso y otras asociadas), de modo que al registrar transacciones en Compras, Ventas y Almacén, se generen asientos contables automáticos conforme al plan de cuentas de la Razón Social activa. Esta parametrización se administrará desde Contabilidad y utilizará la tabla existente ARTICULO_SUB_CATEG; únicamente se expondrán en esta pantalla los campos pertinentes al ámbito ...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- La pantalla muestra solo columnas relevantes para Contabilidad.
- Se ocultan campos propios de Compras u otros módulos.
- Es posible asignar cuentas contables por subcategoría.
- El sistema valida existencia y vigencia de cuentas en el plan.
- No se permite guardar una subcategoría sin al menos una cuenta principal asociada (según política de la empresa).
- Mensaje de validación y bloqueo de guardado.
- Se pueden definir cuentas diferenciadas para Débito y Crédito (cuando aplique).
- La UI exige naturaleza compatible con la cuenta.

---

##### ﻿HU-CON-006 - Registro de Asientos (Creación Manual) - v1.0

**Descripción:** El sistema debe permitir la creación, edición, consulta e inactivación de asientos contables manuales, registrando una cabecera y un detalle de partidas con sus importes en debe/haber,  moneda, tasa de cambio, glosa y referencias. La pantalla será un único formulario maestro–detalle que valide el balance de los importes ( debe= haber) y la coherencia por moneda. La información se almacenará en las tablas CNTBL_ASIENTO (cabecera), CNTBL_ASIENTO_DET (detalle) y CNTBL_ASIENTO_DET_AUX (atributos aux...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- La pantalla permite crear/editar/consultar/inactivar asientos.
- Asiento guardado con su cabecera y partidas.
- Balance obligatorio del asiento.
- Sumas de debe = haber en moneda base y alternativa.
- Validación de periodo abierto y libro permitido.
- Bloqueo si el periodo o libro no están disponibles.
- Las cuentas contables deben existir y estar activas.
- Bloqueo y mensaje si no cumplen.

---

##### ﻿HU-CON-008 — Ajustes y Reclasificación Contable

**Descripción:** El sistema debe permitir registrar ajustes contables manuales, tales como provisiones, reclasificaciones y ajustes menores. Todos los asientos se crean ingresando manualmente cada partida contable, seleccionando la cuenta, naturaleza (débito/haber), importe, glosa y centro de costo cuando corresponda. La funcionalidad opera exclusivamente de manera manual. Todos los movimientos registrados deben mantener balance entre débito y crédito, conservar trazabilidad y cumplir las validaciones contables ...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir registrar reclasificaciones entre cuentas compatibles (activo, pasivo, gasto, ingreso).
- El usuario ingresa manualmente todas las partidas contables
- Permitir registrar provisiones contables
- Se registran partidas de gasto y pasivo ingresadas por el usuario
- Permitir registrar ajustes menores
- El usuario ingresa líneas de corrección según necesidad
- Validar balance del asiento (Debe = Haber)
- El sistema bloquea grabación si Débito ≠ Haber

---

##### ﻿HU-CON-008 - Ajustes y Reclasificación Contable - v1.0

**Descripción:** El sistema debe permitir realizar ajustes y reclasificaciones contables para mantener la integridad, exactitud y coherencia de los saldos, ya sea por provisiones, reclasificaciones, Ajustes menores (AJUSTES MANUALES), Esta funcionalidad deberá operar sobre los asientos contables existentes o generar nuevos asientos automáticos con las partidas de ajuste correspondientes, manteniendo trazabilidad total y control de auditoría. Los ajustes podrán realizarse de forma manual o automática, dependiendo...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir reclasificar saldos entre cuentas contables de naturaleza compatible (activo, pasivo, gasto, ingreso).
- Se generan asientos automáticos con la glosa “Reclasificación de saldos”.
- Permitir ajustes por redondeo en las diferencias menores entre débitos y créditos.
- El sistema crea automáticamente las partidas de ajuste.
- Permitir ajustes por tipo de cambio, recalculando importes alternos según la tasa vigente.
- El sistema genera un asiento con las diferencias en moneda local.
- Validar que los asientos generados estén balanceados ( debe = Haber).
- El sistema bloquea grabación si hay desequilibrio.

---

##### ﻿HU-CON-016 - Análisis de Cuenta Contable

**Descripción:** Como usuario del área contable, quiero consultar el análisis detallado de una cuenta contable en un periodo determinado, para validar saldos, revisar movimientos y realizar conciliaciones contables. ________________   3.Reglas de Negocio 1. El análisis de cuenta se alimenta exclusivamente de asientos contables publicados.  2. El sistema debe calcular automáticamente:     * Saldo inicial     * Total Debe     * Total Haber     * Saldo final        3. Los asientos anulados no deben afectar los sald...

**Criterios de Aceptación clave:**

- El sistema muestra correctamente el saldo inicial según el periodo seleccionado
- Los movimientos coinciden con los asientos contables registrados
- Los totales Debe, Haber y Saldo final son correctos
- Los filtros funcionan correctamente
- La exportación respeta los filtros aplicados

---

##### ﻿HU-CON-012 - Reportes de Validación / Consistencia de Asientos Contables - v1.0

**Descripción:** El sistema debe permitir generar reportes de validación y consistencia contable que verifiquen el cuadre de los asientos contables (débitos vs créditos) y detecten posibles inconsistencias. Estos reportes permitirán identificar asientos desbalanceados, cuentas no asignadas, diferencias por tipo de cambio o importes negativos, garantizando la integridad de la información contable antes del cierre mensual o del proceso de generación de estados financieros. La funcionalidad debe proporcionar una vi...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable (año/mes) y rango de fechas para el análisis.
- Se listan los asientos registrados en el rango definido.
- Mostrar el total de débitos, créditos y diferencia por asiento contable.
- Se resaltan los asientos desbalanceados.
- Permitir aplicar filtros por origen, libro, usuario o estado del asiento.
- El resultado se ajusta según los filtros aplicados.
- Identificar asientos con diferencias por tipo de cambio o por redondeo.
- Se genera columna de observación automática.

---

##### ﻿HU-CON-009 - Consulta de Saldos de Cuenta Corriente - v1.0

**Descripción:** El sistema debe permitir consultar los saldos y movimientos de las cuentas corrientes, tanto de cuentas por cobrar (CxC) como de cuentas por pagar (CxP), vinculadas con la contabilidad. La funcionalidad mostrará la información consolidada por tercero (cliente/proveedor), documento, cuenta contable, y periodo contable, ofreciendo opciones de filtro, agrupación y exportación. La consulta debe incluir los movimientos contables registrados en los libros auxiliares y su correspondencia con los asient...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar el tipo de cuenta corriente: CxC o CxP.
- Muestra los saldos correspondientes al tipo elegido.
- Filtrar por razón social, cuenta contable, tercero, documento o periodo.
- Se muestran solo los registros que cumplan los filtros aplicados.
- Mostrar saldo inicial, movimientos (débitos y créditos) y saldo final por cuenta/tercero/documento.
- Totales coherentes con el libro mayor.
- Permitir visualizar detalle de movimientos contables (número de asiento, fecha, glosa, importe).
- Acceso mediante doble clic o botón “Ver detalle”.

---

##### ﻿HU-CON-025 - Procesos / Validar Consistencia de Asientos Contables - v1.0

**Descripción:** El sistema debe permitir la validación automática de la consistencia de los asientos contables, verificando que el total de débitos sea igual al total de créditos (Débito = Crédito) en cada asiento registrado. Asimismo, el proceso debe identificar y reportar asientos descuadrados, incompletos o con inconsistencias estructurales, tales como:    * Cuentas contables inactivas o inexistentes.     * Falta de centro de costo cuando es obligatorio.     * Diferencias monetarias en el caso de asientos mu...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable o rango de fechas para la validación.
- El proceso se ejecuta sobre los asientos del periodo seleccionado.
- Validar que en cada asiento el total de débitos sea igual al total de créditos.
- Muestra lista de asientos descuadrados con detalle de diferencia.
- Verificar que todas las cuentas contables existan y estén activas.
- Identifica y marca asientos con cuentas inactivas o inexistentes.
- Validar centros de costo obligatorios en asientos que lo requieran.
- Genera alerta si faltan centros de costo en cuentas de gastos o ingresos.

---

##### ﻿HU-CON-010 - Consulta de Centros de Costo por Trabajador - v1.0

**Descripción:** El sistema debe permitir consultar la imputación de costos a nivel de trabajadores o áreas, vinculada con los centros de costo definidos en la contabilidad. Esta funcionalidad permitirá visualizar la asignación de gastos por trabajador, área o proyecto, según los registros contables y de planillas, facilitando el análisis de costos laborales y la contabilidad analítica. La consulta mostrará la relación entre el trabajador, su centro de costo asociado, los montos imputados, y los asientos contabl...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable, centro de costo, trabajador o área.
- La consulta muestra los registros filtrados según los parámetros elegidos.
- Mostrar asientos contables o movimientos de planilla asociados a cada trabajador.
- Se visualizan las imputaciones con su monto, glosa y fecha.
- Calcular y mostrar el total de costos imputados por trabajador o centro de costo.
- Se presentan totales por agrupación seleccionada.
- Permitir agrupación y resumen por centro de costo, trabajador o área.
- Reporte dinámico con totales.

---

##### ﻿HU-CON-018 - Reportes de Validación / Libro Diario - v1.0

**Descripción:** El sistema debe permitir la generación del reporte de Libro Diario, que contenga todos los asientos contables registrados en el sistema durante un periodo determinado, ordenados cronológicamente y conforme a la normativa contable vigente. Este reporte es de carácter oficial y obligatorio, y constituye una herramienta esencial para la validación contable, auditorías y presentación de estados financieros. Debe permitir aplicar filtros por periodo contable, rango de fechas, tipo de libro, centro de...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable (año/mes) o rango de fechas.
- El sistema muestra los asientos registrados en el rango elegido.
- Mostrar los asientos ordenados cronológicamente por fecha contable y número de asiento.
- El reporte conserva el orden contable.
- Incluir columnas de fecha, tipo de libro, número de asiento, glosa, cuenta contable, debe y haber.
- Estructura fiel al formato de Libro Diario.
- Permitir filtrar por centro de costo, tipo de comprobante, usuario y estado del asiento.
- Resultados personalizados según filtros aplicados.

---

##### ﻿HU-CON-027 - Procesos / Clonación de Asientos Contables - v1.0

**Descripción:** El sistema debe permitir la clonación de asientos contables existentes, con el objetivo de agilizar el registro de transacciones recurrentes o similares a otras ya contabilizadas. La funcionalidad permitirá seleccionar un asiento contable registrado previamente, copiar su estructura (cuentas, centros de costo, montos, glosa, tipo de documento, moneda, etc.) y generar un nuevo asiento editable que conserve las mismas características del original, pero con la posibilidad de modificar datos como fe...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar un asiento contable existente para clonar.
- Se muestra una lista de asientos registrados disponibles.
- Copiar todos los detalles del asiento original (cuentas, montos, glosa, centro de costo, moneda, etc.).
- El nuevo asiento hereda los valores del original.
- Asignar un nuevo número de asiento al registro clonado.
- Se genera un código único distinto al original.
- Permitir modificar datos del asiento clonado antes de contabilizar (fecha, montos, glosa).
- El usuario puede personalizar el nuevo asiento.

---

##### ﻿HU-CON-028 - Procesos / Importación de Asientos Contables - v1.0

**Descripción:** El sistema debe permitir la importación masiva de asientos contables desde un archivo externo (por ejemplo, formato Excel o CSV), con el fin de agilizar el registro de grandes volúmenes de información contable provenientes de otros sistemas o módulos operativos. El archivo de importación debe incluir información esencial como fecha contable, tipo de comprobante, número de documento, cuentas contables, descripción, montos en debe y haber, centro de costo, moneda y glosa general. El sistema deberá...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir la carga de un archivo Excel o CSV según una plantilla predefinida.
- El sistema muestra vista previa de los datos.
- Validar que todas las cuentas contables y centros de costo existan y estén activos.
- Los registros inválidos se marcan con observaciones.
- Verificar que Débito = Crédito por cada asiento importado.
- No se permite importar asientos descuadrados.
- Validar el periodo contable y la fecha de cada asiento.
- Se alerta si el periodo está cerrado o inválido.

---

##### ﻿HU-CON-015 - Reportes de Validación / Balance de Comprobación - v1.0

**Descripción:** El sistema debe permitir generar un reporte de Balance de Comprobación, mostrando por cada cuenta contable sus saldos iniciales, movimientos del periodo (débitos y créditos) y saldos finales, tanto en moneda local como extranjera, según la configuración de la empresa. Este reporte tiene como finalidad verificar el cuadre contable de los registros registrados en los diferentes libros contables, asegurando que la información esté completa y balanceada antes de la generación de los estados financie...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable (año/mes) o rango de fechas.
- Se muestran las cuentas con movimientos en el periodo.
- Mostrar columnas de saldo inicial, débitos, créditos, saldo final y diferencia.
- Los totales deben cuadrar entre débitos y créditos.
- Incluir filtros por nivel de cuenta contable (1 a 5).
- Permite agrupar los resultados según la estructura del plan contable.
- Permitir filtrar por centro de costo o segmento analítico.
- Muestra los saldos asociados al centro seleccionado.

---

##### ﻿HU-CON-021 - Reportes de Validación / Estado de Resultados - v1.0

**Descripción:** El sistema debe permitir la generación del reporte de Estado de Resultados, mostrando de manera estructurada los ingresos, costos, gastos operativos y resultados netos de la empresa en un periodo determinado. Este reporte debe calcular automáticamente el resultado neto del ejercicio (utilidad o pérdida) y permitir comparaciones entre periodos contables, mostrando la evolución de la rentabilidad de la empresa. El reporte debe obtener la información de los asientos contables registrados y validado...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable o rango de fechas.
- El reporte muestra los resultados acumulados del periodo.
- Mostrar las cuentas agrupadas por categoría contable (Ingresos, Costos, Gastos, etc.).
- Estructura jerárquica conforme al plan contable.
- Calcular automáticamente la utilidad o pérdida neta del periodo.
- Resultado mostrado al final del reporte.
- Permitir comparar dos periodos contables (actual vs anterior).
- Mostrar columnas comparativas de saldos. Agregar periodos en columnas.

---

##### ﻿HU-CON-024 - Procesos / Generar Libros Electrónicos - v1.0

**Descripción:** El sistema debe permitir la generación automática de libros contables electrónicos, de acuerdo con los formatos oficiales exigidos por las autoridades tributarias de cada país (por ejemplo, SUNAT en Perú, DIAN en Colombia, SII en Chile, entre otros). Los libros a generar incluyen:    * Registro de Ventas e Ingresos     * Registro de Compras     * Libro Diario     * Libro Mayor     * Registro de Asientos Auxiliares y Cuentas Corrientes  El sistema debe extraer la información directamente de los a...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar el tipo de libro electrónico a generar (ventas, compras, diario, mayor, auxiliares).
- El sistema muestra los formatos disponibles según la normativa del país.
- Permitir definir el periodo contable (año y mes).
- Los registros corresponden al periodo seleccionado.
- Validar que los asientos contables estén contabilizados y cerrados.
- No se incluyen asientos en borrador o anulados.
- Mostrar un resumen de validación previa antes de generar el archivo (errores, advertencias).
- El usuario puede corregir inconsistencias antes de generar.

---

##### ﻿HU-CON-030 - Procesos / Ejecutar Cierre Contable Anual - v1.0

**Descripción:** El sistema debe permitir la ejecución del cierre contable anual, consolidando los resultados financieros del ejercicio y trasladando automáticamente los saldos de las cuentas de ingresos y gastos hacia la cuenta de resultados del ejercicio (utilidad o pérdida), conforme a las normas contables y fiscales vigentes. El proceso debe generar automáticamente los asientos de cierre, calculando el resultado neto (ingresos - gastos), y preparar los estados financieros finales (Balance General, Estado de ...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar el ejercicio contable a cerrar.
- Se muestran los ejercicios disponibles en estado “Abierto”.
- Validar que todos los periodos mensuales estén cerrados.
- No se permite el cierre anual si algún mes está pendiente.
- Generar automáticamente los asientos de cierre trasladando ingresos y gastos al resultado del ejercicio.
- El sistema crea los asientos de cierre con referencia automática.
- Calcular y registrar el resultado neto (utilidad o pérdida) del ejercicio.
- Se genera asiento resumen con saldo final en la cuenta de resultados.

---

##### ﻿HU-CON-020 - Reportes de Validación / Estado de Situación Financiera (Balance General) - v1.0

**Descripción:** El sistema debe permitir la generación del reporte de Estado de Situación Financiera (Balance General), mostrando los activos, pasivos y patrimonio de la empresa a una fecha determinada o comparando periodos contables. El reporte debe obtener la información directamente de los asientos contables registrados y validados, y estructurarse conforme al plan contable y las normas internacionales de información financiera (NIIF) o normas locales aplicables (como PCGE – Perú, PUC – Colombia, etc.). El s...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable o rango de fechas.
- El reporte muestra los saldos acumulados al cierre del periodo seleccionado.
- Agrupar las cuentas por tipo contable (Activo, Pasivo y Patrimonio).
- Estructura jerárquica del plan contable.
- Calcular los saldos finales por cuenta y subtotales por grupo contable.
- Cuadre automático del balance.
- Permitir comparar dos periodos contables (ej. actual vs anterior).
- Mostrar columnas comparativas de saldos con detalle en el nombre de la columna. Ejemplo: Febrero 2025

---

##### ﻿HU-CON-026 - Procesos / Registro de Ajustes Contables - v1.0

**Descripción:** El sistema debe permitir el registro, control y contabilización de ajustes contables, tales como  ajustes por diferencia de cambio, ajustes por redondeo  (AJUSTES AUTOMÁTICOS)   con el fin de asegurar la correcta presentación de los estados financieros antes del cierre contable. El proceso debe permitir al usuario crear asientos de ajuste manuales o automáticos, indicando el tipo de ajuste, periodo, cuentas afectadas y su justificación. Además, el sistema debe garantizar que todo ajuste cumpla c...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir registrar un nuevo asiento de ajuste contable.
- El sistema crea un asiento identificado como “Ajuste Contable”.
- Validar que el asiento cumpla con Débito = Crédito.
- No se permite guardar ajustes descuadrados.
- Permitir registrar distintos tipos de ajustes (Tipo de cambio, etc.).
- Los ajustes se clasifican según tipo para su control.
- Registrar fecha contable y periodo del ajuste.
- Los ajustes se contabilizan en el periodo correspondiente.

---

##### ﻿HU-CON-023 - Reportes de Validación / Estado de Cambios en el Patrimonio Neto - v1.0

**Descripción:** El sistema debe permitir la generación del reporte de Estado de Cambios en el Patrimonio Neto, mostrando las variaciones en las cuentas patrimoniales (capital social, resultados acumulados, reservas, utilidades del ejercicio, aportes y otros componentes del patrimonio) durante un periodo contable determinado. El reporte debe obtener la información de los asientos contables validados y cerrados, y reflejar las operaciones que impactan directamente en el patrimonio neto, como resultados del ejerci...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable o rango de fechas.
- El sistema muestra las variaciones del patrimonio en el periodo seleccionado.
- Mostrar las cuentas agrupadas por tipo patrimonial (Capital, Reservas, Resultados, Aportes, etc.).
- Estructura jerárquica según plan contable.
- Calcular automáticamente las variaciones entre periodos (saldo inicial, movimientos y saldo final).
- Muestra el cambio total del patrimonio neto.
- Mostrar el saldo inicial y final de cada cuenta patrimonial.
- Estructura clara y conciliada.

---

##### ﻿HU-CON-013 - Reportes de Validación / Consistencia de Preasientos Contables - v1.0

**Descripción:** El sistema debe permitir generar reportes de validación y consistencia de preasientos contables antes de su confirmación definitiva. Estos reportes tienen como objetivo detectar inconsistencias, desbalances, cuentas no configuradas o centros de costo faltantes, asegurando que los preasientos cumplan con las reglas contables básicas antes de ser transformados en asientos contables finales. El reporte debe presentar información agrupada por origen, número de preasiento, periodo contable y estado d...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable, rango de fechas, origen y usuario.
- Se muestran los preasientos generados dentro de los filtros.
- Mostrar el estado de validación de cada preasiento (Correcto / Observado / Pendiente).
- Clasificación visible en columna de resultados.
- Calcular automáticamente el cuadre entre débitos y créditos.
- Se resaltan los preasientos con diferencia mayor a ±0.01.
- Mostrar observaciones automáticas (cuenta no configurada, CECO vacío, diferencia por tipo de cambio, etc.).
- Cada observación se detalla por línea.

---

##### ﻿HU-CON-022 - Reportes de Validación / Estado de Flujos de Efectivo - v1.0

**Descripción:** El sistema debe permitir la generación del reporte de Estado de Flujos de Efectivo, que muestre de forma estructurada los ingresos y egresos de efectivo clasificados en actividades operativas, de inversión y de financiamiento, con el objetivo de analizar la liquidez y la capacidad de la empresa para generar efectivo durante un periodo determinado. El reporte debe obtener su información de los asientos contables validados y cerrados, vinculados a las cuentas bancarias y de caja. Además, debe perm...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable o rango de fechas.
- El reporte muestra los flujos de efectivo del periodo seleccionado.
- Clasificar los movimientos por actividad: Operativa, Inversión y Financiamiento.
- Se muestran subtotales y totales por tipo de actividad.
- Calcular automáticamente el flujo neto de efectivo del periodo.
- Muestra el saldo final y la variación del efectivo.
- Permitir comparar dos periodos contables (actual vs anterior).
- Mostrar columnas comparativas de flujos. Colocar los periodos de comparación en las columnas.

---

##### ﻿HU-CON-011 - Reportes Diversos de Maestros Contables - v1.0

**Descripción:** El sistema debe permitir generar y consultar reportes diversos de los maestros contables, tales como el Plan de Cuentas, Centros de Costo, Impuestos, Tipos de Detracciones, y Configuraciones Contables. Estos reportes deben ofrecer opciones de búsqueda, filtrado, exportación y agrupación, brindando a los usuarios contables una visión consolidada y auditable de la información maestra del sistema. La funcionalidad debe permitir emitir los reportes en pantalla, Excel o PDF, incluyendo los datos prin...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar el tipo de reporte maestro a generar.
- Muestra los campos específicos según el maestro seleccionado.
- Permitir aplicar filtros personalizados (estado, rango de fechas, código, descripción, cuenta contable, etc.).
- Los resultados se ajustan a los filtros aplicados.
- Mostrar resultados en una vista tipo tabla, con paginación, ordenamiento y totales.
- Los registros se listan claramente y pueden ordenarse por columna.
- Permitir exportar reportes en formatos Excel (.xlsx) y PDF (.pdf).
- El archivo se descarga correctamente con los datos visibles.

---

##### ﻿HU-CON-032 – Reporte Detallado de Pre Asientos – v1.0

**Descripción:** El sistema debe permitir la generación de un Reporte Detallado de Pre Asientos Contables, el cual muestre toda la información relevante de los pre asientos generados automática o masivamente por otros módulos o procesos (Compras, Ventas, Almacén, RRHH, Activos Fijos, Importaciones de Pre Asientos). El reporte debe permitir visualizar el detalle del pre asiento antes de ser confirmado y convertido en asiento contable final, con el fin de que los usuarios puedan realizar validaciones, verificacion...

**Criterios de Aceptación clave:**

- Criterio
- Resultado esperado
- Permitir aplicar filtros avanzados
- El usuario puede filtrar por fecha, módulo origen, tipo de documento, número de pre asiento, estado y usuario creador.
- El reporte debe mostrar encabezado y detalle del pre asiento
- Se debe mostrar información contable completa de cada ítem.
- Validar que el reporte muestre diferencias en Debe/Haber
- Se deben resaltar pre asientos descuadrados.
- Permitir exportar a Excel y PDF
- El usuario puede descargar el reporte.

---

##### ﻿HU-CON-031 – Matrices de Almacenes – v1.0

**Descripción:** El sistema debe permitir registrar, consultar, modificar y desactivar Matrices Contables de Almacén, las cuales permiten relacionar parámetros clave de los movimientos de inventarios con las cuentas contables correspondientes. Cada matriz contable debe relacionar los siguientes tres parámetros operativos del almacén: 1. Tipo de movimiento de almacén (Ingreso, Salida, Transferencia, Ajuste, etc.).  2. Subcategoría del artículo (insumos, bebidas, suministros, activos, etc.).  3. Grupo contable (cl...

**Criterios de Aceptación clave:**

- Criterio
- Resultado esperado
- Mostrar listado de matrices contables existentes
- La vista lista todas las matrices con filtros por movimiento, subcategoría y estado.
- Permitir crear nuevas matrices contables
- El usuario registra los 3 parámetros y las cuentas contables asociadas.
- Validar que no existan duplicados de combinación (Movimiento + Subcategoría + Grupo Contable)
- El sistema impide duplicidad mostrando mensaje de advertencia.
- Permitir editar matrices existentes
- Se pueden modificar cuentas contables asociadas sin alterar la llave principal.

---

##### ﻿HU-CON-016 - Reportes de Validación / Reportes Varios de Asientos Contables - v1.0

**Descripción:** El sistema debe permitir la generación de reportes de los asientos contables registrados en el sistema, aplicando filtros personalizables tales como rango de fechas, tipo de comprobante, cuenta contable, centro de costo, usuario y estado del asiento. El objetivo de esta funcionalidad es ofrecer al área contable una herramienta flexible de consulta y validación que facilite el análisis de movimientos, la verificación de integridad contable y la preparación de información para auditorías o cierres...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar rango de fechas y periodo contable.
- Se muestran los asientos registrados en ese periodo.
- Permitir filtrar por tipo de comprobante (Diario, Compras, Ventas, Ajustes, etc.).
- El reporte se ajusta al tipo seleccionado.
- Incluir filtro por cuenta contable.
- Muestra solo los asientos que incluyen dicha cuenta.
- Incluir filtro por centro de costo.
- Muestra los asientos asociados al centro de costo seleccionado.

---

##### ﻿HU-CON-007 - Modificación de Asiento Contable Automático - v1.0

**Descripción:** El sistema debe permitir la modificación controlada de asientos contables generados automáticamente (integraciones, procesos masivos o importación de pre-asientos), manteniendo trazabilidad, balance y auditoría. La edición se realiza en una vista maestro–detalle sobre las tablas existentes de diario, con restricciones y flujos de aprobación opcionales según políticas de la Razón Social. Toda modificación debe quedar registrada con motivo del cambio, usuario, timestamp, y antes/después de los val...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- La pantalla permite buscar y abrir asientos con FLAG_GEN_AUT='1' o con origen de procesos/importaciones.
- Listado con filtros por periodo, libro, origen, estado, usuario.
- Los campos clave (Origen, Año, Mes, Libro, N° Asiento) son no editables.
- Se muestran solo lectura.
- La edición exige Motivo del cambio y, si está activado, Aprobación.
- Registro en bitácora y posible workflow.
- El asiento debe balancear (Débito = Haber) en moneda local y alternativa.
- Validación obligatoria al guardar.

---

##### ﻿HU-CON-029 - Procesos / Ejecutar Cierre Contable Mensual - v1.0

**Descripción:** El sistema debe permitir ejecutar el cierre contable mensual de manera controlada, asegurando que todos los movimientos contables de un periodo determinado estén completos, validados y correctamente registrados antes de su consolidación. El cierre contable implica bloquear la modificación, eliminación o incorporación de nuevos registros contables pertenecientes al periodo cerrado, así como generar automáticamente los reportes de comprobación y resultados correspondientes al mes. El proceso debe ...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar el periodo contable a cerrar.
- Se muestra una lista de periodos abiertos disponibles.
- Validar que todos los asientos estén contabilizados y cuadrados (Débito = Crédito).
- El sistema bloquea el cierre si detecta inconsistencias.
- Verificar que no existan asientos pendientes o importaciones incompletas.
- Se genera reporte de pendientes antes de cerrar.
- Generar automáticamente reportes de comprobación y resultados.
- El sistema guarda los reportes en el repositorio del cierre.

---

##### ﻿HU-CON-033 – Autorización de Modificaciones de Asientos – v1.0

**Descripción:** El sistema debe permitir ejecutar un proceso de autorización para validar que un pre asiento contable está correcto y cumple todas las reglas contables, de negocio y de consistencia para poder ser importado o convertido en un asiento contable definitivo. El proceso revisa información clave del pre asiento (cuadratura, cuentas válidas, centros de costo, glosas, documentos origen, montos, moneda, tipo de cambio, entre otros). Una vez aprobado, el pre asiento queda marcado como “Autorizado para Con...

**Criterios de Aceptación clave:**

- Criterio
- Resultado esperado
- El proceso debe validar la cuadratura del pre asiento
- Si Debe ≠ Haber, no se permite autorizar.
- Validar cuentas contables activas
- No se autoriza si existen cuentas inactivas o no permitidas.
- Validar centros de costo obligatorios
- Si una cuenta requiere centro de costo y no lo tiene, el sistema debe bloquear la autorización.
- Validar integridad documental
- Verifica documentos origen (compras, ventas, almacén).

---

##### ﻿HU-CON-019 - Reportes de Validación / Reportes Contables según formatos DIAN y SUNAT - v1.0

**Descripción:** El sistema debe permitir la generación de reportes contables oficiales en los formatos exigidos por las entidades tributarias de los países en los que opera el sistema, principalmente:    * SUNAT (Perú): Libros Electrónicos (PLE) SIRE – formatos 5.1, 5.2, 6.1, 6.2, 8.1, 8.2, 14.1, entre otros.     * DIAN (Colombia): Reportes de información exógena y formatos de medios magnéticos.  Estos reportes deben generarse a partir de los asientos contables registrados en el sistema, cumpliendo con las estr...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar país, razón social y periodo contable.
- El sistema determina el conjunto de formatos disponibles según el país.
- Mostrar una lista de formatos oficiales disponibles (ej. 5.1, 5.2, 6.1, 6.2 para SUNAT; formatos XML para DIAN).
- El usuario elige el formato requerido.
- Generar los archivos en formato y estructura oficial según especificación del organismo fiscal.
- El sistema crea los archivos con los nombres, columnas y delimitadores correctos.
- Incluir validaciones de obligatoriedad según la normativa de cada país.
- Se muestran mensajes de advertencia si faltan datos requeridos.

---

##### ﻿HU-CON-014 - Reportes de Validación / Asientos Descuadrados - v1.0

**Descripción:** El sistema debe permitir generar reportes de validación de asientos contables descuadrados, mostrando aquellos registros donde la suma de los débitos difiera de la suma de los créditos. El objetivo es identificar de manera preventiva los asientos con inconsistencias para su revisión y corrección antes del cierre contable o la generación de reportes financieros. El reporte debe permitir filtrar por periodo contable, origen, libro contable, usuario y fecha de registro, mostrando para cada asiento ...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable (año/mes) y rango de fechas para la validación.
- Se muestran los asientos registrados dentro del periodo filtrado.
- Calcular y mostrar automáticamente diferencias entre debe y haber.
- Se listan únicamente los asientos con diferencias mayores a ±0.01.
- Permitir aplicar filtros por origen, libro contable, usuario y estado del asiento.
- El reporte se ajusta según los filtros aplicados.
- Mostrar columnas de: origen, año, mes, libro, número de asiento, total debe, total haber, diferencia, usuario y fecha contable.
- Los datos se presentan en formato tabular.

---

##### ﻿HU-CON-017 - Reportes de Validación / Libro Mayor - v1.0

**Descripción:** El sistema debe permitir la generación del reporte del Libro Mayor, conforme a los registros contables ingresados en el sistema, agrupando los movimientos por cuenta contable, con detalle de débitos, créditos y saldo acumulado. Este reporte es una herramienta fundamental de validación contable, que permite revisar la evolución de los saldos de cada cuenta durante un periodo determinado, conforme a las normas contables y tributarias aplicables en cada país. El sistema debe permitir filtrar por pe...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir seleccionar periodo contable (año/mes) o rango de fechas.
- El sistema muestra los movimientos registrados en ese periodo.
- Mostrar los movimientos agrupados por cuenta contable.
- Cada cuenta muestra sus débitos, créditos y saldo acumulado.
- Incluir columnas de fecha, glosa, número de asiento, debe, haber y saldo.
- Estructura de reporte tipo libro mayor tradicional.
- Permitir filtrar por centro de costo y moneda.
- El reporte muestra solo los movimientos que cumplen los filtros.

---


### 2.6. Módulo de Activos Fijos

> **Registro, depreciación, traslados, seguros y revaluación de activos**
> 
> HUs documentadas: **27** | Carpeta: `06_Activos_Fijos/`

#### Listado de Historias de Usuario

| # | Archivo | Título | Descripción resumida |
|---|---|---|---|
| 1 | `HU-AF-001.txt` | ﻿HU-AF-001 - | Como Administrador Contable del Sistema, quiero definir, registrar y mantener actualizada la tabla maestra de tipos de o... |
| 2 | `HU-AF-002.txt` | ﻿HU-AF-002 - Catalogación de Tipos de Incidencias que Pueden Afectar a los Activ | Como Administrador Contable o Gestor de Activos, quiero registrar y mantener una tabla maestra de tipos de incidencias q... |
| 3 | `HU-AF-OPE-001.txt` | ﻿HU-AF-OPE-001 - Registro Principal de Activos Fijos con Gestión Integral - v1.1 | Como Administrador Contable de Activos Fijos, quiero registrar, consultar y mantener la información integral de cada act... |
| 4 | `HU-AF-OPE-002.txt` | ﻿HU-AF-OPE-002 - Gestión de Movimientos Físicos de Activos entre Ubicaciones - v | Como Administrador o Responsable de Activos Fijos, quiero gestionar el proceso completo de traslado físico de activos en... |
| 5 | `HU-AF-OPE-003.txt` | ﻿HU-AF-OPE-003 - Workflow de Autorización para Traslados Pendientes - v1.1 | Como Supervisor o Administrador Contable de Activos Fijos, quiero revisar, aprobar o rechazar solicitudes de traslado de... |
| 6 | `HU-AF-OPE-004.txt` | ﻿HU-AF-OPE-004 - Registro de Operaciones Especiales sobre Activos - v1.1 | Como Administrador Contable de Activos Fijos, quiero registrar y controlar las operaciones especiales que afectan el val... |
| 7 | `HU-AF-OPE-005.txt` | ﻿HU-AF-OPE-005 - Gestión de Seguros Asociados a Activos Fijos - v1.1 | Como Administrador de Activos Fijos o Analista Contable, quiero registrar, controlar y mantener actualizada la informaci... |
| 8 | `HU-AF-OPE-006.txt` | ﻿HU-AF-OPE-006 Proceso de Baja de Activos por Venta, Siniestro y Obsolescencia c | Como Administrador Contable de Activos Fijos, quiero realizar el proceso completo de baja de activos fijos, ya sea por v... |
| 9 | `HU-AF-OPE-007.txt` | ﻿HU-AF-OPE-007 - Proceso de Revaluación Técnica y Comercial de Activos - v1.1 | Como Administrador Contable o Valuador Técnico de Activos Fijos, quiero registrar y ejecutar procesos de revaluación téc... |
| 10 | `HU-AF-OPE-008.txt` | ﻿HU-AF-OPE-008 - Configuración de Tasas y Métodos de Depreciación por Activo - v | Como Administrador Contable o Analista de Activos Fijos, quiero configurar las tasas y métodos de depreciación contable ... |
| 11 | `HU-AF-PRO-001.txt` | ﻿HU-AF-PRO-001 - Proceso Masivo de Cálculo Mensual/Anual de Depreciación - v1.1 | Como Administrador Contable o Analista de Activos Fijos, quiero ejecutar el proceso masivo de cálculo de depreciación me... |
| 12 | `HU-AF-PRO-002.txt` | ﻿HU-AF-PRO-002 - Creación Automática de Asientos Contables por Depreciación - v1 | Como Contador General o Administrador Contable, quiero generar automáticamente los asientos contables de depreciación a ... |
| 13 | `HU-AF-PRO-003.txt` | ﻿HU-AF-PRO-003 - Contabilización Automática de Procesos de Revaluación - v1.1 | Como Contador General o Administrador de Activos Fijos, quiero generar automáticamente los asientos contables derivados ... |
| 14 | `HU-AF-PRO-004.txt` | ﻿HU-AF-PRO-004 - Contabilización de Ajustes por Inflación - v1.1 | Como Contador General o Administrador Contable de Activos Fijos, quiero ejecutar el proceso de contabilización de ajuste... |
| 15 | `HU-AF-PRO-005.txt` | ﻿HU-AF-PRO-005 - Proceso Automatizado de Devengamiento Mensual de Primas de Segu | Como Contador General o Responsable de Activos Fijos, quiero ejecutar un proceso automatizado que calcule y registre men... |
| 16 | `HU-AF-PRO-006.txt` | ﻿HU-AF-PRO-006 - Workflow Completo para Registrar Siniestros y Gestionar Recuper | Como Administrador de Activos Fijos o Contador General, quiero registrar, gestionar y contabilizar los siniestros ocurri... |
| 17 | `HU-AF-REP-001.txt` | ﻿HU-AF-REP-001 - Listado General de Activos con Valores y Depreciación Acumulada | Como Administrador Contable o Auditor de Activos Fijos, quiero consultar y exportar un listado general con la informació... |
| 18 | `HU-AF-REP-002.txt` | ﻿HU-AF-REP-002 - Detalle de Cálculos de Depreciación Anual por Cada Activo - v1. | Como Contador General o Auditor de Activos Fijos, quiero consultar un reporte analítico con el detalle de los cálculos d... |
| 19 | `HU-AF-REP-003.txt` | ﻿HU-AF-REP-003 - Reportes Consolidados Filtrados por Criterios Específicos - v1. | Como Gerente Contable, Auditor o Analista Financiero, quiero generar reportes consolidados de activos aplicando filtros ... |
| 20 | `HU-AF-TAB-001-.txt` | ﻿HU-AF-TAB-001- Maestro de Compañías Aseguradoras para Gestión de Pólizas - v1.1 | 4. Al intentar desactivar una aseguradora con pólizas vigentes, el sistema solicita confirmación.        5. El módulo de... |
| 21 | `HU-AF-TAB-002.txt` | ﻿HU-AF-TAB-002 - Clasificación de Tipos de Seguros Aplicables a Activos - v1.1 | Como Analista de Activos Fijos, quiero registrar, consultar, modificar y administrar las clasificaciones de tipos de seg... |
| 22 | `HU-AF-TAB-003-E.txt` | ﻿HU-AF-TAB-003-Estructura Jerárquica para Categorización de Activos - v1.1 | Como Administrador Contable de Activos Fijos, quiero definir y mantener una estructura jerárquica de clasificación de ac... |
| 23 | `HU-AF-TAB-004.txt` | ﻿HU-AF-TAB-004 - Configuración de Cuentas Contables por Tipo de Activo - v1.1 | Como Analista Contable de Activos Fijos, quiero configurar las cuentas contables asociadas a cada subclase de activo fij... |
| 24 | `HU-AF-TAB-005.txt` | ﻿HU-AF-TAB-005 - Maestro de Ubicaciones Físicas de Activos - v1.1 | Como Administrador de Activos Fijos, quiero registrar, mantener y consultar una estructura jerárquica de ubicaciones fís... |
| 25 | `HU-AF-TAB-006.txt` | ﻿HU-AF-TAB-006 - Configuración Global de Parámetros del Módulo - v1.1 | 9. Los parámetros globales no pueden eliminarse; solo editarse o inactivarse.  10. El sistema debe alertar al usuario cu... |
| 26 | `HU-AF-TAB-007.txt` | ﻿HU-AF-TAB-007 - Configuración de Secuencias Numéricas para Códigos de Activos - | Como Administrador de Activos Fijos, quiero configurar secuencias numéricas automáticas para la generación de códigos ún... |
| 27 | `HU-AF-TAB-008.txt` | ﻿HU-AF-TAB-008 - Numeración Automática para Documentos de Traslado - v1.1 | Como Administrador de Activos Fijos, quiero configurar la numeración automática y consecutiva de los documentos de trasl... |

#### Detalle de cada HU

##### ﻿HU-AF-001 -

**Descripción:** Como Administrador Contable del Sistema, quiero definir, registrar y mantener actualizada la tabla maestra de tipos de operaciones sobre activos fijos, para que el sistema identifique correctamente los diferentes tipos de transacciones (depreciaciones, revaluaciones, bajas, transferencias, mejoras, etc.) y las relacione con sus parámetros contables y de cálculo, garantizando la trazabilidad y consistencia de los movimientos en el módulo de Activos Fijos. 3. Navegabilidad: Menú principal: Activos...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- CA-AF-001
- Crear nuevo tipo de operación con todos los campos obligatorios completos.
- Registro creado exitosamente y visible en listado.
- CA-AF-002
- Intentar crear un código duplicado.
- Sistema muestra mensaje de error y no guarda el registro.
- CA-AF-003
- Eliminar operación en uso.

---

##### ﻿HU-AF-002 - Catalogación de Tipos de Incidencias que Pueden Afectar a los Activos - v1.0

**Descripción:** Como Administrador Contable o Gestor de Activos, quiero registrar y mantener una tabla maestra de tipos de incidencias que pueden afectar los activos, para que el sistema clasifique y trace los eventos que impacten su estado físico, valor contable o ubicación (por ejemplo: robos, daños, siniestros, obsolescencia), garantizando la trazabilidad y el control histórico para fines de auditoría y reportes de gestión. 3. Navegabilidad: Menú principal: Activos Fijos → Tablas → Incidencias de los Activos...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- CA-AF-007
- Registrar nueva incidencia con todos los campos obligatorios completos.
- Registro creado y visible en el listado.
- CA-AF-008
- Intentar crear un código duplicado.
- Sistema muestra un mensaje de error y no guarda el registro.
- CA-AF-009
- Eliminar incidencia en uso.

---

##### ﻿HU-AF-OPE-001 - Registro Principal de Activos Fijos con Gestión Integral - v1.1

**Descripción:** Como Administrador Contable de Activos Fijos, quiero registrar, consultar y mantener la información integral de cada activo fijo, para gestionar su ciclo de vida completo desde la adquisición hasta su baja, incluyendo sus datos generales, ubicación, depreciación, traslados, incidencias y adaptaciones, asegurando la trazabilidad contable, física y operativa del activo dentro del sistema Restaurant.pe. 6. Alcance Esta funcionalidad constituye la ventana principal del Módulo de Activos Fijos, estru...

**Criterios de Aceptación clave:**

- El usuario puede registrar un nuevo activo completo con todos los campos obligatorios.
- El sistema genera el código automáticamente según la secuencia configurada.
- Las pestañas permiten navegación fluida y guardado por secciones.
- Las modificaciones de valor o depreciación quedan registradas en el log.
- Los reportes de ficha técnica incluyen toda la información del activo.
- El sistema bloquea operaciones de depreciación o traslado sobre activos dados de baja.

---

##### ﻿HU-AF-OPE-002 - Gestión de Movimientos Físicos de Activos entre Ubicaciones - v1.1

**Descripción:** Como Administrador o Responsable de Activos Fijos, quiero gestionar el proceso completo de traslado físico de activos entre ubicaciones, centros de costo o sucursales,para controlar las solicitudes, autorizaciones, ejecuciones y registros contables asociados, asegurando la trazabilidad total del movimiento y la integridad de la información contable y física del activo dentro del sistema Restaurant.pe. 6. Alcance Esta funcionalidad permite ejecutar el ciclo completo del traslado interno de activo...

**Criterios de Aceptación clave:**

- El usuario puede registrar una nueva solicitud con todos los campos obligatorios.
- Solo usuarios autorizados pueden aprobar un traslado.
- La ejecución actualiza automáticamente la ubicación del activo.
- El número de documento se genera automáticamente conforme a la secuencia configurada.
- El flujo de estados se cumple en orden: Solicitud → Aprobado → Ejecutado → Cerrado.
- Los registros se reflejan en el historial de movimientos del activo.

---

##### ﻿HU-AF-OPE-003 - Workflow de Autorización para Traslados Pendientes - v1.1

**Descripción:** Como Supervisor o Administrador Contable de Activos Fijos, quiero revisar, aprobar o rechazar solicitudes de traslado de activos fijos, para controlar de forma centralizada el flujo de aprobación, validar los traslados pendientes y asegurar que cada movimiento cuente con autorización formal, garantizando la trazabilidad y cumplimiento de los controles internos en el sistema Restaurant.pe. 6. Alcance La funcionalidad permite a los usuarios con perfil autorizado acceder a una interfaz de workflow ...

**Criterios de Aceptación clave:**

- El usuario puede filtrar solicitudes por fecha, origen o responsable.
- Se permite aprobar o rechazar solicitudes de forma individual o masiva.
- El sistema exige comentarios obligatorios para rechazos.
- Las solicitudes aprobadas cambian de estado y generan notificación.
- Las acciones quedan registradas correctamente en el Log Contable.
- La interfaz refleja cambios de estado en tiempo real.

---

##### ﻿HU-AF-OPE-004 - Registro de Operaciones Especiales sobre Activos - v1.1

**Descripción:** Como Administrador Contable de Activos Fijos, quiero registrar y controlar las operaciones especiales que afectan el valor contable o la clasificación de los activos, para mantener actualizada la base depreciable, reflejar correctamente los cambios en valor y estructura de los activos, y garantizar la trazabilidad de las operaciones contables extraordinarias, conforme a la NIC 16 – Propiedades, Planta y Equipo. 6. Alcance La funcionalidad permite gestionar operaciones no recurrentes o especiales...

**Criterios de Aceptación clave:**

- El usuario puede registrar una operación especial con todos los campos obligatorios.
- El sistema valida el tipo de operación y actualiza automáticamente los valores del activo.
- La contabilización genera asiento contable automático.
- No se permiten operaciones con fecha fuera del periodo contable abierto.
- Las mejoras capitalizables ajustan la vida útil y el valor neto.
- Las revaluaciones registran correctamente el incremento o disminución contable.

---

##### ﻿HU-AF-OPE-005 - Gestión de Seguros Asociados a Activos Fijos - v1.1

**Descripción:** Como Administrador de Activos Fijos o Analista Contable, quiero registrar, controlar y mantener actualizada la información de las pólizas de seguros asociadas a los activos fijos, para garantizar la cobertura, seguimiento y control financiero de los activos asegurados, incluyendo vigencias, sumas aseguradas, deducibles, primas, beneficiarios y alertas de vencimiento o renovación automática, con trazabilidad contable y fiscal dentro del sistema Restaurant.pe. 6. Alcance Esta funcionalidad permite...

**Criterios de Aceptación clave:**

- El usuario puede registrar una nueva póliza con todos los campos obligatorios.
- Las fechas de vigencia se validan correctamente.
- El sistema genera alertas de vencimiento a los responsables.
- Las pólizas pueden renovarse automáticamente con nuevo periodo.
- Los movimientos contables (prima y deducible) se reflejan en el módulo contable.
- Toda modificación queda registrada en el log de auditoría.

---

##### ﻿HU-AF-OPE-006 Proceso de Baja de Activos por Venta, Siniestro y Obsolescencia con Cálculo de Resultados

**Descripción:** Como Administrador Contable de Activos Fijos, quiero realizar el proceso completo de baja de activos fijos, ya sea por venta, siniestro u obsolescencia, para dar de baja los activos, calcular automáticamente la depreciación acumulada, determinar la ganancia o pérdida según corresponda, generar los asientos contables y registrar la documentación legal asociada, conforme a la NIC 16 – Propiedades, Planta y Equipo y a las normativas fiscales locales. ________________   2. Alcance La funcionalidad a...

**Criterios de Aceptación clave:**

- El usuario puede registrar una baja por venta, siniestro u obsolescencia
- El sistema calcula la depreciación y valor neto
- Se calcula automáticamente la ganancia o pérdida
- Se generan los asientos correctos
- El activo cambia su estado según el tipo de baja
- Se adjunta documentación obligatoria
- El proceso queda en el Log Contable
- Duración máxima ≤ 5 segundos

---

##### ﻿HU-AF-OPE-007 - Proceso de Revaluación Técnica y Comercial de Activos - v1.1

**Descripción:** Como Administrador Contable o Valuador Técnico de Activos Fijos, quiero registrar y ejecutar procesos de revaluación técnica o comercial sobre activos fijos, para actualizar su valor contable según tasaciones técnicas o índices oficiales, recalcular la base depreciable, generar los asientos contables correspondientes y mantener el historial de revaluaciones con fines de auditoría y control patrimonial, conforme a la NIC 16 – Propiedades, Planta y Equipo y regulaciones tributarias locales. 6. Alc...

**Criterios de Aceptación clave:**

- El usuario puede iniciar una revaluación seleccionando un activo existente.
- El sistema calcula automáticamente el nuevo valor y base de depreciación.
- Los asientos contables se generan correctamente según el tipo de operación (incremento/disminución).
- Los documentos soporte pueden adjuntarse y consultarse.
- Los valores se actualizan correctamente en el maestro de activos.
- Las operaciones quedan registradas en el log contable.

---

##### ﻿HU-AF-OPE-008 - Configuración de Tasas y Métodos de Depreciación por Activo - v1.1

**Descripción:** Como Administrador Contable o Analista de Activos Fijos, quiero configurar las tasas y métodos de depreciación contable y tributaria por activo o por subclase, para asegurar que el cálculo de depreciación se realice de manera correcta, conforme a las normativas contables, tributarias y políticas internas, permitiendo ajustar la base depreciable, definir fechas de inicio, valores residuales y distribuir el gasto entre centros de costo asociados. ________________   6. Alcance Esta funcionalidad pe...

**Criterios de Aceptación clave:**

- El usuario puede crear o editar configuraciones por activo con tasas y métodos válidos.
- El sistema valida automáticamente la tasa máxima y la normativa aplicable.
- Las fechas de inicio no pueden ser anteriores a la fecha de adquisición.
- Los porcentajes de distribución entre centros de costo deben sumar 100%.
- Los cálculos simulados coinciden con los métodos seleccionados (lineal/decreciente).
- El registro queda guardado en el Log Contable con trazabilidad completa.

---

##### ﻿HU-AF-PRO-001 - Proceso Masivo de Cálculo Mensual/Anual de Depreciación - v1.1

**Descripción:** Como Administrador Contable o Analista de Activos Fijos, quiero ejecutar el proceso masivo de cálculo de depreciación mensual o anual, para actualizar los valores contables y tributarios de todos los activos fijos, distribuir automáticamente los gastos por centro de costos, y garantizar el registro exacto y trazable de la depreciación acumulada, validando periodos, matrices contables y parámetros antes de su contabilización final. ________________   6. Alcance Esta funcionalidad constituye el en...

**Criterios de Aceptación clave:**

- El sistema valida correctamente la configuración de cada activo antes de iniciar el cálculo.
- Se ejecuta el cálculo de depreciación mensual o anual para todos los activos vigentes.
- La distribución por centro de costo se aplica conforme a los porcentajes configurados.
- Los resultados se generan en tablas temporales antes de contabilizar.
- El usuario puede visualizar una barra de progreso y resumen del proceso.
- Los errores y advertencias se registran en el log contable.

---

##### ﻿HU-AF-PRO-002 - Creación Automática de Asientos Contables por Depreciación - v1.1

**Descripción:** Como Contador General o Administrador Contable, quiero generar automáticamente los asientos contables de depreciación a partir de los resultados del cálculo mensual o anual, para registrar en la contabilidad los gastos y depreciaciones acumuladas correspondientes, con validaciones contables, distribución por centros de costo y trazabilidad de los procesos ejecutados, asegurando la integridad entre los módulos de Activos Fijos y Contabilidad General. ________________   6. Alcance Esta funcionalid...

**Criterios de Aceptación clave:**

- El sistema genera correctamente los asientos contables desde los resultados de depreciación.
- Se validan todas las matrices contables antes de ejecutar.
- Los montos de débito y crédito se generan balanceados.
- Los asientos incluyen referencias cruzadas hacia el activo y el centro de costo.
- Se registra un log detallado con fecha, usuario, activos y montos procesados.
- Los resultados se visualizan en formato pre-asiento antes de su contabilización.

---

##### ﻿HU-AF-PRO-003 - Contabilización Automática de Procesos de Revaluación - v1.1

**Descripción:** Como Contador General o Administrador de Activos Fijos, quiero generar automáticamente los asientos contables derivados de procesos de revaluación técnica o comercial de activos, para reflejar correctamente en la contabilidad los incrementos o decrementos de valor, los ajustes en depreciación acumulada y los efectos de superávit o pérdida por revaluación, garantizando la integridad contable y cumplimiento con la NIC 16 y la normativa tributaria aplicable. ________________   6. Alcance Esta funci...

**Criterios de Aceptación clave:**

- El sistema solo contabiliza revaluaciones con estado “Aprobado”.
- Los asientos generados incluyen las cuentas contables correctas según la Matriz Contable.
- Se reflejan los movimientos de:
- Incremento de valor del activo.
- Ajuste de depreciación acumulada.
- Superávit o pérdida por revaluación.
- Efectos tributarios diferidos.
- Los montos cuadran entre débito y crédito.
- El sistema genera y registra correctamente el log de ejecución.
- Los asientos pueden visualizarse y exportarse antes de contabilizar.

---

##### ﻿HU-AF-PRO-004 - Contabilización de Ajustes por Inflación - v1.1

**Descripción:** Como Contador General o Administrador Contable de Activos Fijos, quiero ejecutar el proceso de contabilización de ajustes por inflación aplicando índices oficiales, para actualizar los valores contables de los activos fijos y reflejar en los estados financieros el mantenimiento del poder adquisitivo del capital invertido, generando los asientos contables automáticos de indexación conforme a las normas contables locales e internacionales (NIC 29 y NIC 16). ________________   6. Alcance Esta funci...

**Criterios de Aceptación clave:**

- El sistema valida la existencia y vigencia del índice de inflación.
- Se generan correctamente los ajustes por inflación para los activos vigentes.
- Los asientos contables incluyen las cuentas correctas y cuadran entre débito y crédito.
- El log de proceso registra todos los detalles (usuario, fecha, índice, activos procesados, montos).
- Los resultados pueden visualizarse, exportarse y auditarse antes de contabilizar.
- El proceso no permite ejecución sobre periodos cerrados.

---

##### ﻿HU-AF-PRO-005 - Proceso Automatizado de Devengamiento Mensual de Primas de Seguros de Activos Fijos - v1.1

**Descripción:** Como Contador General o Responsable de Activos Fijos, quiero ejecutar un proceso automatizado que calcule y registre mensualmente el devengamiento de las primas de seguros de los activos fijos, para reconocer proporcionalmente el gasto en cada periodo de vigencia de las pólizas, distribuirlo por centro de costo y asegurar la correcta imputación contable de los pagos anticipados, manteniendo trazabilidad, validaciones y alertas sobre vencimientos próximos. ________________   6. Alcance Esta funci...

**Criterios de Aceptación clave:**

- El sistema solo procesa pólizas vigentes y con cobertura activa.
- El cálculo del devengo mensual es exacto según prima total y periodo de vigencia.
- Los asientos contables se generan correctamente, balanceados y con cuentas asignadas.
- Se registran logs completos con detalle de pólizas procesadas, montos y usuario.
- El proceso puede ejecutarse de forma automática o manual.
- Los resultados pueden visualizarse y exportarse a Excel o PDF.

---

##### ﻿HU-AF-PRO-006 - Workflow Completo para Registrar Siniestros y Gestionar Recuperos de Seguros de Activos Fijos - v1.1

**Descripción:** Como Administrador de Activos Fijos o Contador General, quiero registrar, gestionar y contabilizar los siniestros ocurridos sobre los activos fijos asegurados, para mantener un control integral del proceso de pérdida, evaluación, reclamo, indemnización y recupero, garantizando la trazabilidad contable, la actualización de los valores del activo afectado y la correcta imputación de las indemnizaciones recibidas. ________________   6. Alcance Esta funcionalidad implementa un workflow completo e in...

**Criterios de Aceptación clave:**

- El usuario puede registrar un siniestro con todos los datos obligatorios.
- El sistema permite asociar varios activos a un mismo incidente.
- Se generan automáticamente los formularios de reclamo con datos de la póliza y aseguradora.
- El flujo de estados (Reportado → Evaluación → Aprobado → Recuperado) se actualiza correctamente.
- Los asientos contables por pérdida y recupero se generan y contabilizan correctamente.
- El sistema alerta por pólizas vencidas o sin cobertura vigente.

---

##### ﻿HU-AF-REP-001 - Listado General de Activos con Valores y Depreciación Acumulada - v1.1

**Descripción:** Como Administrador Contable o Auditor de Activos Fijos, quiero consultar y exportar un listado general con la información completa de todos los activos fijos, para obtener una visión global del inventario físico y contable, incluyendo sus valores de adquisición, depreciación acumulada, valor neto, ubicaciones y estados, con el fin de realizar conciliaciones, auditorías y reportes financieros confiables en el sistema Restaurant.pe. 6. Alcance La funcionalidad permite generar un reporte maestro de...

**Criterios de Aceptación clave:**

- El usuario puede filtrar y generar el reporte correctamente por fecha, clase, origen y ubicación.
- El reporte muestra valores de adquisición, depreciación acumulada y valor neto por activo.
- La depreciación acumulada refleja el cálculo al periodo seleccionado.
- El reporte puede exportarse sin errores a Excel y PDF (formato auditoría).
- Los totales generales por moneda se muestran al final del reporte.
- Las acciones de generación y exportación quedan registradas en el Log Contable.

---

##### ﻿HU-AF-REP-002 - Detalle de Cálculos de Depreciación Anual por Cada Activo - v1.1

**Descripción:** Como Contador General o Auditor de Activos Fijos, quiero consultar un reporte analítico con el detalle de los cálculos de depreciación anual y mensual de cada activo, para verificar la exactitud de las tasas aplicadas, valores depreciados, saldos acumulados y proyecciones, permitiendo así respaldar la información contable y tributaria ante auditorías o declaraciones fiscales. ________________   6. Alcance Esta funcionalidad permite la generación de un reporte detallado por activo, donde se visua...

**Criterios de Aceptación clave:**

- El usuario puede generar el reporte por año o rango de meses.
- El sistema muestra para cada activo: valor original, tasa aplicada, meses depreciados, depreciación mensual/anual y acumulada.
- Los cálculos son consistentes con las tasas configuradas.
- Las diferencias contables y tributarias se visualizan correctamente.
- El reporte puede exportarse a Excel y PDF sin errores.
- Toda generación y exportación queda registrada en el Log Contable.

---

##### ﻿HU-AF-REP-003 - Reportes Consolidados Filtrados por Criterios Específicos - v1.1

**Descripción:** Como Gerente Contable, Auditor o Analista Financiero, quiero generar reportes consolidados de activos aplicando filtros múltiples y rangos personalizados, para analizar información segmentada por código, fecha, ubicación, responsable o valor, permitiendo realizar reportería gerencial dinámica y personalizada, con resultados exportables y adecuados a procesos de control, planificación y auditoría. ________________   6. Alcance Esta funcionalidad proporciona una plataforma de generación flexible d...

**Criterios de Aceptación clave:**

- El usuario puede generar reportes aplicando múltiples filtros combinados (rango de códigos, fechas, valores, ubicaciones, responsables).
- Los resultados muestran datos consistentes con el maestro de activos y la contabilidad.
- Los totales y subtotales se muestran correctamente por agrupación.
- El reporte puede exportarse a Excel y PDF sin errores.
- Los filtros guardados pueden reutilizarse.
- Toda generación y exportación se registra en el Log Contable.

---

##### ﻿HU-AF-TAB-001- Maestro de Compañías Aseguradoras para Gestión de Pólizas - v1.1

**Descripción:** 4. Al intentar desactivar una aseguradora con pólizas vigentes, el sistema solicita confirmación.        5. El módulo de Pólizas muestra la aseguradora recién creada en el listado de selección.        6. Los reportes y exportaciones reflejan la información actualizada.        7. No es posible eliminar registros.        8. El tiempo de respuesta de búsqueda es menor a 3 segundos.  ________________

**Criterios de Aceptación clave:**

- El sistema permite crear una nueva aseguradora completando todos los campos obligatorios.
- Se valida duplicidad de RUC/NIT y Razón Social por país.
- Las modificaciones quedan registradas en el log contable con usuario, fecha y descripción de cambio.
- Al intentar desactivar una aseguradora con pólizas vigentes, el sistema solicita confirmación.
- El módulo de Pólizas muestra la aseguradora recién creada en el listado de selección.
- Los reportes y exportaciones reflejan la información actualizada.

---

##### ﻿HU-AF-TAB-002 - Clasificación de Tipos de Seguros Aplicables a Activos - v1.1

**Descripción:** Como Analista de Activos Fijos, quiero registrar, consultar, modificar y administrar las clasificaciones de tipos de seguros aplicables a los activos, para definir los diferentes tipos de cobertura (todo riesgo, incendio, robo, responsabilidad civil, etc.) y sus parámetros de cobertura y condiciones, que servirán como base para la configuración de pólizas y el cálculo automático de primas dentro del sistema. 6. Alcance Esta funcionalidad permitirá la gestión centralizada del catálogo maestro de ...

**Criterios de Aceptación clave:**

- El usuario puede crear un tipo de seguro con todos los campos obligatorios.
- El sistema valida duplicidad de nombre o código.
- Los porcentajes de cobertura deben estar en el rango permitido (0–100).
- Los tipos de seguro creados aparecen disponibles en el módulo de Pólizas.
- Al desactivar un tipo de seguro con pólizas activas, el sistema muestra advertencia.
- Todas las acciones quedan registradas en el Log Contable.

---

##### ﻿HU-AF-TAB-003-Estructura Jerárquica para Categorización de Activos - v1.1

**Descripción:** Como Administrador Contable de Activos Fijos, quiero definir y mantener una estructura jerárquica de clasificación de activos en dos niveles (Clase y Subclase), para establecer una taxonomía contable y operativa uniforme que determine las cuentas contables, parámetros de depreciación, y políticas de gestión diferenciadas según el tipo de activo, con el fin de garantizar la consistencia en la contabilización, reportería y control patrimonial del sistema Restaurant.pe. 6. Alcance Esta funcionalida...

**Criterios de Aceptación clave:**

- El usuario puede crear una nueva Clase de activo con todos los campos obligatorios.
- El sistema permite agregar una o más subclases asociadas a una Clase activa.
- Se valida la unicidad de códigos y nombres de clase/subclase.
- Al desactivar una Clase, las Subclases asociadas pasan automáticamente a inactivas.
- No se pueden modificar parámetros contables si existen activos asignados a la clase/subclase.
- Los cambios quedan registrados en el Log Contable.

---

##### ﻿HU-AF-TAB-004 - Configuración de Cuentas Contables por Tipo de Activo - v1.1

**Descripción:** Como Analista Contable de Activos Fijos, quiero configurar las cuentas contables asociadas a cada subclase de activo fijo, para definir la matriz contable que permitirá la contabilización automática de las operaciones de alta, depreciación, baja, y venta de activos, garantizando la integración directa con el módulo contable y la correcta imputación a centros de costo. 6. Alcance La funcionalidad permite registrar y mantener la matriz contable de cuentas asociadas a cada subclase de activo fijo, ...

**Criterios de Aceptación clave:**

- El usuario puede registrar una matriz contable completa para una subclase activa.
- El sistema valida la existencia de todas las cuentas asociadas.
- Solo puede existir una configuración contable activa por subclase.
- La modificación o desactivación genera registro en el log contable.
- Si se intenta registrar un activo sin matriz configurada, el sistema lo bloquea.
- La integración con el módulo contable genera los asientos correctamente.

---

##### ﻿HU-AF-TAB-005 - Maestro de Ubicaciones Físicas de Activos - v1.1

**Descripción:** Como Administrador de Activos Fijos, quiero registrar, mantener y consultar una estructura jerárquica de ubicaciones físicas (edificios, pisos, oficinas, almacenes, áreas de trabajo), para garantizar el control físico, la trazabilidad de los traslados internos y la ejecución eficiente de inventarios periódicos, asegurando la identificación única de cada punto de ubicación donde se encuentren los activos del grupo empresarial. 6. Alcance Esta funcionalidad permite la creación y mantenimiento de u...

**Criterios de Aceptación clave:**

- El usuario puede crear una ubicación principal y agregar subniveles (detalle).
- Se valida que no existan códigos o nombres duplicados.
- Si una ubicación principal se desactiva, sus dependencias también se inactivan.
- Solo se pueden asignar activos a ubicaciones activas.
- Toda modificación o desactivación se registra en el log contable.
- El sistema permite filtrar y exportar la estructura completa a Excel o PDF.

---

##### ﻿HU-AF-TAB-006 - Configuración Global de Parámetros del Módulo - v1.1

**Descripción:** 9. Los parámetros globales no pueden eliminarse; solo editarse o inactivarse.  10. El sistema debe alertar al usuario cuando existan dependencias (por ejemplo: cambio de libro con depreciaciones en curso).  11. Integraciones Módulo / Servicio 	Descripción 	Módulo Contable General 	Para integración automática de asientos de depreciación, alta y baja. 	Módulo de Compras 	Para alta de activos desde facturas o órdenes de compra. 	Módulo de Inventarios / Traslados 	Para trazabilidad física de activos...

**Criterios de Aceptación clave:**

- El usuario puede registrar una configuración global completa para una razón social.
- El sistema valida que solo exista una configuración activa por empresa.
- Los cambios en cuentas contables o libros quedan registrados en el log.
- El sistema alerta si los cambios impactan procesos abiertos (depreciaciones en curso).
- Los parámetros globales se aplican automáticamente en los procesos operativos.
- Los reportes de configuración pueden exportarse en Excel y PDF.

---

##### ﻿HU-AF-TAB-007 - Configuración de Secuencias Numéricas para Códigos de Activos - v1.1

**Descripción:** Como Administrador de Activos Fijos, quiero configurar secuencias numéricas automáticas para la generación de códigos únicos de activos fijos, para garantizar la trazabilidad, unicidad y orden lógico de los activos dentro de cada razón social y sucursal, estableciendo prefijos, longitudes, incrementos y rangos controlados que permitan identificar fácilmente el origen, tipo y procedencia del activo dentro del sistema Restaurant.pe. 6. Alcance Esta funcionalidad permite definir las reglas automáti...

**Criterios de Aceptación clave:**

- El usuario puede crear una secuencia numérica nueva con prefijo, longitud y rango definidos.
- El sistema valida la unicidad del código configurado por sucursal.
- Al registrar un nuevo activo, se genera automáticamente un código conforme a la configuración.
- El incremento del número actual se realiza correctamente sin saltos ni duplicados.
- Si se alcanza el rango máximo, el sistema notifica y bloquea el registro.
- Las modificaciones y reinicios se registran en el log contable.

---

##### ﻿HU-AF-TAB-008 - Numeración Automática para Documentos de Traslado - v1.1

**Descripción:** Como Administrador de Activos Fijos, quiero configurar la numeración automática y consecutiva de los documentos de traslado interno de activos, para garantizar la trazabilidad, secuencia lógica y control por periodo de los movimientos físicos de los activos entre ubicaciones, centros de costo o sucursales, asegurando integridad contable y cumplimiento con los procedimientos de auditoría interna. 6. Alcance La funcionalidad permitirá la configuración, control y administración de las secuencias nu...

**Criterios de Aceptación clave:**

- El usuario puede crear una nueva configuración de numeración con todos los campos obligatorios.
- El sistema genera automáticamente el número consecutivo al crear un documento de traslado.
- No se permite duplicar configuraciones por tipo de documento y periodo.
- El número correlativo incrementa correctamente y respeta los rangos definidos.
- Al alcanzar el rango máximo, el sistema bloquea nuevos números y notifica al usuario.
- Los reinicios automáticos funcionan correctamente según la configuración (mensual/anual).

---


### 2.7. Módulo de Recursos Humanos

> **Gestión de personal, nómina, asistencia, reclutamiento y talento**
> 
> HUs documentadas: **42** | Carpeta: `07_RRHH/`

#### Listado de Historias de Usuario

| # | Archivo | Título | Descripción resumida |
|---|---|---|---|
| 1 | `HU-RRH-CV-IN-001.txt` | ﻿HU-RRH-CV-IN-001 – Detección y Corrección de Inconsistencias en Inasistencias | Como analista de RR.HH. o responsable de nómina, quiero que el sistema detecte y permita corregir inconsistencias en los... |
| 2 | `HU-RRH-CV-RP-001.txt` | ﻿HU-RRH-CV-RP-001 – Consulta de Netos a Pagar, Adelantos y Saldos de Cuenta Corr | Como analista de nómina o responsable de RR.HH., quiero consultar los valores netos a pagar, adelantos y saldos de cuent... |
| 3 | `HU-RRH-CV-VA-001.txt` | ﻿HU-RRH-CV-VA-001 – Validación Automática de Inconsistencias en Nómina | Como analista de nómina o responsable de RR.HH., quiero que el sistema detecte automáticamente inconsistencias en los cá... |
| 4 | `HU-RRH-NOM-CP-007.txt` | ﻿HU-RRH-NOM-CP-007 - Distribución del Recargo al Consumo - v1.0 | Como usuario del módulo de RR.HH. de Restaurant.pe, quiero que el sistema distribuya automáticamente el recargo al consu... |
| 5 | `HU-RRH-NOM-PE-001.txt` | ﻿HU-RRH-NOM-PE-001 – Ejecución de Procesos Masivos de Beneficios Legales | Como analista de nómina o especialista de RR.HH., quiero que el sistema ejecute procesos masivos de cálculo y pago de be... |
| 6 | `HU-RRH-RA-AR-001.txt` | ﻿HU-RRH-RA-AR-001 – Generación de Archivos Regulatorios Laborales y Tributarios | Como especialista de planillas o responsable de cumplimiento legal, quiero generar archivos electrónicos en los formatos... |
| 7 | `HU-RRH-RA-AR-001_1.txt` | ﻿HU-RRH-TD-ED-001 – Evaluaciones 90°/180°/360° – v1.0 | Como Analista de Talento y Desarrollo, quiero crear, administrar y ejecutar evaluaciones de desempeño en formato 90°, 18... |
| 8 | `HU-RRH-RA-AV-001.txt` | ﻿HU-RRH-RA-AV-001 – Indicadores de Rotación, Ausentismo y Dotación por Área/Sucu | Como analista de recursos humanos o gerente de operaciones, quiero que el sistema genere indicadores de rotación de pers... |
| 9 | `HU-RRH-RA-DB-001.txt` | ﻿HU-RRH-RA-DB-001 – Dashboard de Indicadores Clave de RR.HH. por Sede | Como gerente de recursos humanos o director financiero, quiero visualizar en un dashboard un resumen de indicadores clav... |
| 10 | `HU-RRH-RA-ES-001.txt` | ﻿HU-RRH-RA-ES-001 – Emisión de Boletas/Recibos y Planillas por Periodo, Sede o E | Como analista de nómina o responsable de RR.HH., quiero emitir boletas o recibos individuales y planillas completas de c... |
| 11 | `HU-RRH-RA-ES-002.txt` | ﻿HU-RRH-RA-ES-002 – Distribución de Costos por Centro de Costo, Canal y Unidad d | Como analista de recursos humanos o responsable financiero, quiero que el sistema distribuya automáticamente los costos ... |
| 12 | `HU-RRH-TD-CAP-001.txt` | ﻿HU-RRH-TD-CAP-001 – Gestión de Cursos – v1.0 | Como Analista de Talento y Desarrollo, quiero gestionar el registro, programación, ejecución y seguimiento de cursos de ... |
| 13 | `HU-RRH-TD-CL-001.txt` | ﻿HU-RRH-TD-CL-001 – Encuestas y Feedback – v1.0 | Como Analista de Talento y Desarrollo, quiero crear, aplicar y analizar encuestas de clima laboral y feedback continuo, ... |
| 14 | `HU-RRH-TD-PC-001.txt` | ﻿HU-RRH-TD-PC-001 – Trayectoria y Sucesión – v1.0 | Como Analista de Talento y Desarrollo, quiero gestionar los planes de trayectoria y sucesión de los colaboradores, para ... |
| 15 | `HU-RRHH-AJ-AS-001.txt` | ﻿HU-RRHH-AJ-AS-001 - Registro de Marcaciones desde POS, Biométrico o App Móvil c | Como responsable de Recursos Humanos, quiero que el sistema registre las marcaciones de entrada y salida de los trabajad... |
| 16 | `HU-RRHH-AJ-CL-001.txt` | ﻿HU-RRHH-AJ-CL-001 - Configuración de Feriados y Turnos Rotativos por Sede o Can | Como responsable de Recursos Humanos, quiero configurar los feriados nacionales y locales, así como los turnos rotativos... |
| 17 | `HU-RRHH-AJ-HR-001.txt` | ﻿HU-RRHH-AJ-HR-001 - Cálculo Automático de Horas Extra y Recargos - v1.0 | Como analista de nómina, quiero que el sistema calcule automáticamente las horas extra y los recargos aplicables (25%, 3... |
| 18 | `HU-RRHH-AJ-PM-001.txt` | ﻿HU-RRHH-AJ-PM-001 - Flujo Digital de Permisos Remunerados/No Remunerados con En | Como responsable de Recursos Humanos, quiero que el sistema gestione digitalmente las solicitudes, aprobaciones y regist... |
| 19 | `HU-RRHH-AJ-VL-001.txt` | ﻿HU-RRHH-AJ-VL-001 - Registro y Consulta de Vacaciones, Licencias y Subsidios (S | Como analista de RR.HH., quiero registrar y consultar las vacaciones, licencias y subsidios de los trabajadores, con opc... |
| 20 | `HU-RRHH-CONF-GC-001.txt` | ﻿HU-RRHH-CONF-GC-001 - Agrupación de Trabajadores por Sede, Centro de Costo, Can | Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero poder agrupar a los trabajadores según su sede, cen... |
| 21 | `HU-RRHH-CONF-NUM-001.txt` | ﻿HU-RRHH-CONF-NUM-001 - Generación de Numeración Automática para Documentos del  | Como usuario administrador del módulo de Recursos Humanos de Restaurant.pe, quiero configurar y generar la numeración au... |
| 22 | `HU-RRHH-CONF-PAR-002.txt` | ﻿HU-RRHH-CONF-PAR-002 - Registro de Remuneración Mínima por País y Vigencia - v1 | Como usuario administrador del módulo de Recursos Humanos de Restaurant.pe, quiero registrar y mantener actualizada la r... |
| 23 | `HU-RRHH-CONF-PAR-003.txt` | ﻿HU-RRHH-CONF-PAR-003 - Definición de Reglas de Impuestos y Contribuciones Labor | Como usuario administrador del módulo de Recursos Humanos de Restaurant.pe, quiero definir las reglas de cálculo de los ... |
| 24 | `HU-RRHH-CONF-PG-001.txt` | ﻿HU-RRHH-CONF-PG-001 - Configuración de Provisiones de Gastos de Planillas - v1. | Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero configurar las provisiones de gastos de planillas c... |
| 25 | `HU-RRHH-MP-AS-001.txt` | ﻿HU-RRHH-MP-AS-001 - Afiliación a Fondos de Pensiones, Salud y Riesgos Laborales | Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero registrar y administrar la afiliación de los trabaj... |
| 26 | `HU-RRHH-MP-CL-001.txt` | ﻿HU-RRHH-MP-CL-001 - Definición de Categorías Laborales (Indefinido, Temporal, E | Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero definir y mantener las categorías laborales de los ... |
| 27 | `HU-RRHH-MP-CL-002.txt` | ﻿HU-RRHH-MP-CL-002 - Catálogo de Cargos, MOF (manual de organización y funciones | Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero registrar, mantener y consultar el catálogo de carg... |
| 28 | `HU-RRHH-MP-EO-001.txt` | ﻿HU-RRHH-MP-EO-001 - Definición de Áreas y Jerarquías por Local/Sucursal/Cadena  | Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero definir y mantener la estructura organizacional por... |
| 29 | `HU-RRHH-MP-FE-001.txt` | ﻿HU-RRHH-MP-FE-001 - Registro de Datos Generales y Documentación del Empleado -  | Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero registrar y mantener actualizada la información per... |
| 30 | `HU-RRHH-MP-FE-002.txt` | ﻿HU-RRHH-MP-FE-002 - Gestión de Contratos, Renovaciones, Cambios de Puesto, Remu | Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero registrar, actualizar y consultar la información re... |
| 31 | `HU-RRHH-NOM-AR-001.txt` | ﻿HU-RRHH-NOM-AR-001 - Cálculo de impuestos al trabajo y contribuciones sociales | Como analista de nómina, quiero que el sistema calcule automáticamente los impuestos al trabajo, así como las contribuci... |
| 32 | `HU-RRHH-NOM-CC-001.txt` | ﻿HU-RRHH-NOM-CC-001 - Gestión de adelantos, préstamos y amortizaciones por traba | Como analista de nómina, quiero registrar, controlar y gestionar los adelantos y préstamos otorgados a los trabajadores,... |
| 33 | `HU-RRHH-NOM-LIQ-001.txt` | ﻿HU-RRHH-NOM-LIQ-001 - Liquidación de vacaciones, indemnizaciones y beneficios l | Como analista de recursos humanos, quiero que el sistema calcule y registre automáticamente la liquidación de vacaciones... |
| 34 | `HU-RRHH-NOM-PROV-001.txt` | ﻿HU-RRHH-NOM-PROV-001 - Generación de asientos contables por provisión de gastos | Como analista contable o de nómina, quiero que el sistema genere automáticamente los asientos contables de provisión de ... |
| 35 | `HU-RRHH-NOM-PROV-002-A.txt` | ﻿HU-RRHH-NOM-PROV-002-Aprobar o Devolver Liquidación | Como usuario aprobador del área de Recursos Humanos o Administración, quiero aprobar o devolver una liquidación laboral ... |
| 36 | `HU-RRHH-OD-CT-002.txt` | ﻿HU-RRHH-OD-CT-002 - Asignación de Capacitaciones, Uniformes/Equipos y Validació | Como responsable de Recursos Humanos o supervisor de área, quiero poder asignar las capacitaciones, uniformes y equipos ... |
| 37 | `HU-RRHH-PN-CP-001.txt` | ﻿HU-RRHH-PN-CP-001 - Configuración y Cálculo de Conceptos Fijos (Sueldo Base, As | Como analista de nómina, quiero configurar y calcular los conceptos fijos que forman parte de la planilla, como sueldos ... |
| 38 | `HU-RRHH-PN-CP-002.txt` | ﻿HU-RRHH-PN-CP-002 - Carga Masiva o Automática de Variables (Horas Extra, Bonos, | Como analista de nómina, quiero poder realizar la carga masiva o automática de variables que influyen en el cálculo de p... |
| 39 | `HU-RRHH-PN-CP-003.txt` | ﻿HU-RRHH-PN-CP-003 - Distribución de Propinas Automática Integrada a Nómina - v1 | Como analista de nómina, quiero que el sistema distribuya automáticamente las propinas generadas por los empleados según... |
| 40 | `HU-RRHH-RO-CT-001.txt` | ﻿HU-RRHH-RO-CT-001 - Gestión de Plantillas con Cláusulas Locales, Firma Digital  | Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero contar con plantillas de contratos que incluyan clá... |
| 41 | `HU-RRHH-RO-RS-001.txt` | ﻿HU-RRHH-RO-RS-001 - Registro y Gestión de Postulaciones, Filtros, Entrevistas,  | Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero registrar y gestionar todas las etapas del proceso ... |
| 42 | `httpsdocs.google.comdocumentd1lJGOE3y2PqJ0GvCISDszMvoIJ9jsId2p3I.txt` | ﻿HU-RRHH-CONF-PAR-001 - Configuración de Frecuencia y Calendarios de Pago Multip | Como usuario administrador del módulo de Recursos Humanos de Restaurant.pe, quiero configurar la frecuencia de pago  y l... |

#### Detalle de cada HU

##### ﻿HU-RRH-CV-IN-001 – Detección y Corrección de Inconsistencias en Inasistencias

**Descripción:** Como analista de RR.HH. o responsable de nómina, quiero que el sistema detecte y permita corregir inconsistencias en los registros de inasistencias, tales como fechas duplicadas, faltas no justificadas o registros superpuestos, de modo que las variables de nómina se actualicen automáticamente y reflejen la situación laboral real del trabajador. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Consultas y Validaciones > Inasistencias > Detección y Corrección de Inconsistencias ________________

**Criterios de Aceptación clave:**

- El sistema debe detectar inconsistencias por trabajador y periodo, tales como:
- Fechas duplicadas de inasistencia.
- Cruces con registros de permisos o vacaciones.
- Días no laborables o feriados registrados como faltas.
- Debe permitir filtrar por sede, centro de costo, fecha, trabajador o tipo de inconsistencia.
- El usuario podrá visualizar el detalle del error y realizar la corrección directamente en el formulario.
- Al guardar los cambios, el sistema debe actualizar automáticamente las variables de nómina relacionadas (descuentos, días trabajados, etc.).
- Registrar toda modificación en el log de auditoría contable y laboral (usuario, fecha, hora, tipo de corrección).
- Permitir exportar un reporte con el resumen de inconsistencias detectadas y acciones correctivas aplicadas.
- Solo usuarios con rol de Administrador o Analista de RR.HH. podrán editar registros.

**Integraciones:** * Integración con Nómina: Actualiza automáticamente los días trabajados, descuentos y ausencias que afectan el cálculo de sueldo.           * Integración con Asistencias: Verifica marcaciones biométricas o POS antes de determinar inconsistencias.           * Integración con Calendarios Laborales: Cr...

---

##### ﻿HU-RRH-CV-RP-001 – Consulta de Netos a Pagar, Adelantos y Saldos de Cuenta Corriente por Trabajador

**Descripción:** Como analista de nómina o responsable de RR.HH., quiero consultar los valores netos a pagar, adelantos y saldos de cuenta corriente de cada trabajador, de modo que pueda verificar la consistencia de la información antes de realizar el pago de planilla, garantizando la exactitud financiera y trazabilidad de los movimientos individuales. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Consultas y Validaciones > Reportes de Planilla > Netos a Pagar y Saldos ________________

**Criterios de Aceptación clave:**

- El sistema debe mostrar una vista consolidada por trabajador, con los campos: salario bruto, descuentos, neto a pagar, adelantos y saldo de cuenta corriente.
- Permitir filtrar la información por: periodo de planilla, sede, centro de costo, tipo de contrato o trabajador.
- Visualizar totales y subtotales por grupo de cálculo o centro de costo.
- Posibilidad de exportar los resultados a Excel o PDF con el mismo formato visual.
- Integración automática con los módulos de Cuentas Corrientes de Trabajador y Cálculo de Planillas para obtener los datos en tiempo real.
- Mostrar alertas visuales en caso de saldo negativo o diferencias inusuales.
- Solo usuarios con permisos de RR.HH. o Contabilidad podrán acceder al reporte.
- Cada consulta generada debe quedar registrada en el log de auditoría con usuario, fecha y filtros aplicados.
- ________________

**Integraciones:** * Integración con Nómina: Trae información de cálculos de sueldos y descuentos aplicados.     * Integración con Cuentas Corrientes: Consulta los adelantos y amortizaciones por trabajador.     * Integración con Tesorería (Finanzas): Permite validar pagos realizados y estados.     * Integración con Au...

---

##### ﻿HU-RRH-CV-VA-001 – Validación Automática de Inconsistencias en Nómina

**Descripción:** Como analista de nómina o responsable de RR.HH., quiero que el sistema detecte automáticamente inconsistencias en los cálculos de planilla, tales como duplicados, montos que superan topes legales, aportes fuera de rango y errores aritméticos, de modo que pueda corregirlos antes del cierre o pago de la nómina, asegurando la integridad y confiabilidad de la información financiera y laboral. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Consultas y Validaciones > Validaciones Automáticas > Análisis de Inconsistencias ________________

**Criterios de Aceptación clave:**

- El sistema debe ejecutar validaciones automáticas sobre los registros de nómina antes del cierre del periodo.
- Detectar:
- Registros duplicados por trabajador, periodo o concepto.
- Topes excedidos en descuentos, aportes o beneficios según normativa local.
- Aportes fuera de rango permitido para fondos de pensiones, salud o impuestos.
- Errores de cálculo entre el total de ingresos, descuentos y neto.
- Mostrar los resultados en una tabla resumen, agrupados por tipo de error y severidad.
- Permitir filtrar y ordenar los resultados por sede, trabajador, tipo de error o periodo.
- Mostrar un estado de validación (Aprobado / Observado / Corregido) con color de semáforo.
- Incluir opción de exportar reporte en Excel o PDF.

**Integraciones:** * Integración con Módulo de Nómina: Obtiene datos de los cálculos y conceptos aplicados.           * Integración con Parámetros del Módulo: Consulta límites legales, topes y rangos por país.           * Integración con Auditoría: Registra las validaciones y correcciones realizadas.           * Integ...

---

##### ﻿HU-RRH-NOM-CP-007 - Distribución del Recargo al Consumo - v1.0

**Descripción:** Como usuario del módulo de RR.HH. de Restaurant.pe, quiero que el sistema distribuya automáticamente el recargo al consumo recaudado durante un periodo específico, aplicando las reglas de distribución definidas por la empresa y/o país, para asegurar el cálculo correcto de compensaciones, beneficios e importes a entregar al personal operativo.

**Navegación:** Ruta: Menú Principal > RR.HH. > Procesos de Nómina > Cálculo de Planillas > Distribución de Recargo al Consumo

**Criterios de Aceptación clave:**

- El sistema debe permitir seleccionar un periodo de nómina (semanal, quincenal o mensual) para realizar la distribución del recargo al consumo.
- Debe mostrar el monto total recaudado por recargo al consumo para el periodo seleccionado.
- El usuario debe poder consultar y aplicar reglas de distribución configuradas previamente, tales como:
- Proporción por horas trabajadas.
- Proporción por días trabajados.
- Tabla porcentual por puesto/rol.
- Monto fijo por categoría.
- Combinación de criterios.
- Se debe permitir parametrizar:
- Fecha de vigencia.

**Integraciones:** * Integración con Ventas: Obtiene el total recaudado por recargo al consumo por periodo.                             * Integración con Configuración de RR.HH.: Obtiene las reglas de distribución parametrizadas por país, empresa o sucursal.                             * Integración con Planillas: Reg...

---

##### ﻿HU-RRH-NOM-PE-001 – Ejecución de Procesos Masivos de Beneficios Legales

**Descripción:** Como analista de nómina o especialista de RR.HH., quiero que el sistema ejecute procesos masivos de cálculo y pago de beneficios laborales (como gratificaciones, aguinaldos, prima vacacional, bonificaciones legales u otros) conforme al marco legal vigente del país, para automatizar la generación, validación y contabilización de dichos beneficios de forma eficiente y precisa. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Procesos de Nómina > Procesos Especiales > Ejecución de Beneficios Legales ________________

**Criterios de Aceptación clave:**

- El sistema debe permitir seleccionar el tipo de beneficio legal (gratificación, prima, aguinaldo, etc.) y el periodo de aplicación.
- Debe considerar los parámetros legales definidos para el país (días, topes, porcentajes, condiciones especiales).
- Permitir ejecutar el cálculo por sede, grupo de trabajadores, empresa o país.
- El sistema debe calcular los montos individuales en base al salario, tiempo de servicio y condiciones contractuales.
- Validar duplicidades o cálculos previos para el mismo periodo antes de procesar.
- Generar automáticamente los asientos contables asociados al gasto y la provisión.
- Permitir revisión y ajuste manual antes de confirmar la ejecución final.
- Emitir reportes consolidados y detallados por trabajador, centro de costo o empresa.
- Registrar en el log de auditoría cada ejecución (usuario, fecha, tipo de beneficio, número de registros procesados).
- ________________

**Integraciones:** * Integración con Planillas: Actualiza los valores de beneficios dentro de la planilla activa.     * Integración con Contabilidad: Genera automáticamente los asientos contables por gasto y provisión.     * Integración con Finanzas: Permite visualizar los montos comprometidos por beneficios a pagar. ...

---

##### ﻿HU-RRH-RA-AR-001 – Generación de Archivos Regulatorios Laborales y Tributarios

**Descripción:** Como especialista de planillas o responsable de cumplimiento legal, quiero generar archivos electrónicos en los formatos requeridos por las autoridades laborales y tributarias de cada país, para cumplir con las obligaciones legales y evitar sanciones. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Reportes y Analítica > Archivos Regulatorios > Generación de Archivos ________________

**Criterios de Aceptación clave:**

- El sistema debe permitir seleccionar el tipo de archivo regulatorio a generar (por ejemplo, AFPNet, PLAME, T-Registro, IMSS, SAT, etc.).
- Debe parametrizar los formatos por país, entidad y estructura de columnas, según normativa vigente.
- Debe integrarse con el módulo de Planillas y Maestros de Personal para obtener los datos necesarios.
- El usuario podrá definir el periodo (mensual, trimestral, anual) y empresa o razón social.
- Los archivos deben generarse en los formatos requeridos (TXT, CSV, XML, XLSX, JSON).
- Debe incluir un validador previo que identifique errores en los datos (campos vacíos, tipos incorrectos, formatos inválidos).
- El sistema debe permitir descargar el archivo validado y registrar la fecha de generación y el usuario responsable.
- Permitir guardar configuraciones de formato personalizadas por país y tipo de reporte.
- El sistema debe mantener un historial de archivos generados, con filtros por fecha, usuario, tipo y estado (pendiente, validado, enviado).
- Opción de firma digital o sello electrónico, si la legislación lo requiere.

**Integraciones:** * Módulo de Planillas: Para obtener datos de remuneraciones, aportes y deducciones.     * Módulo de Maestros de Personal: Para obtener datos personales, documentos y afiliaciones.     * Módulo de Empresas: Para datos tributarios y de registro.     * API de Entidades Gubernamentales (cuando aplique):...

---

##### ﻿HU-RRH-TD-ED-001 – Evaluaciones 90°/180°/360° – v1.0

**Descripción:** Como Analista de Talento y Desarrollo, quiero crear, administrar y ejecutar evaluaciones de desempeño en formato 90°, 180° y 360°, para obtener una visión integral del desempeño de los colaboradores en una o varias razones sociales, considerando diferentes niveles de evaluación (autoevaluación, jefatura, pares, subordinados y clientes internos). ________________

**Criterios de Aceptación clave:**

- Criterio
- Descripción / Condición de aceptación
- Creación de evaluación
- Permitir crear evaluación con nombre, tipo (90°, 180°, 360°), periodo, fechas, estado y objetivo.
- Asignación de participantes
- Asignar evaluadores y evaluados de forma individual o masiva.
- Configuración del instrumento
- Definir competencias, ponderaciones, escalas y pesos por categoría.
- Ejecución
- Habilitar formularios en línea para cada evaluador.

---

##### ﻿HU-RRH-RA-AV-001 – Indicadores de Rotación, Ausentismo y Dotación por Área/Sucursal

**Descripción:** Como analista de recursos humanos o gerente de operaciones, quiero que el sistema genere indicadores de rotación de personal, ausentismo y dotación, desagregados por área, sede o sucursal, para analizar tendencias laborales, detectar riesgos operativos y optimizar la planificación del personal. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Reportes y Analítica > Avanzados > Indicadores de Rotación y Ausentismo ________________

**Criterios de Aceptación clave:**

- El sistema debe calcular automáticamente los indicadores de rotación, ausentismo y dotación por área o sucursal.
- Los indicadores deben calcularse según fórmulas estándar:
- Rotación: (N° de bajas / Promedio de empleados activos) × 100
- Ausentismo: (Horas no trabajadas / Horas programadas) × 100
- Dotación: Total de trabajadores activos por área/sucursal.
- Debe permitir filtrar por periodo, empresa, sede, área, centro de costo y tipo de trabajador.
- El usuario podrá comparar resultados por periodos (mensual, trimestral, anual).
- Debe ser posible exportar los resultados a Excel y PDF.
- El sistema debe guardar el histórico de indicadores calculados por periodo.
- Permitir definir umbrales de alerta (por ejemplo, rotación > 15%) para generar notificaciones preventivas.

**Integraciones:** * Módulo de Asistencia: Fuente de datos para ausentismo.           * Módulo de Maestros de Personal: Proporciona datos de trabajadores y estructura organizativa.           * Módulo de Planillas: Fuente para dotación y rotación (altas/bajas).           * Módulo de Reportes BI: Integración opcional pa...

---

##### ﻿HU-RRH-RA-DB-001 – Dashboard de Indicadores Clave de RR.HH. por Sede

**Descripción:** Como gerente de recursos humanos o director financiero, quiero visualizar en un dashboard un resumen de indicadores clave de desempeño laboral —costo laboral sobre ventas, porcentaje de propinas, horas extras, rotación, ausentismo y headcount por sede—, para evaluar la eficiencia operativa y controlar los costos laborales en tiempo real. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Reportes y Analítica > Dashboards > Indicadores Clave por Sede ________________

**Criterios de Aceptación clave:**

- El dashboard debe mostrar los siguientes indicadores principales por sede y periodo:
- Costo laboral / venta (%): Total de gastos laborales dividido entre ventas netas (sin IGV ni RC) debe poder verse por total venta de empresa o CECO.
- % de propinas: Total de propinas respecto al total de ventas por local.
- Horas extra (HHEE): Total de horas extra acumuladas por sede, CECO, cargo o tipo de personal.
- Rotación (%): (Bajas / Promedio de trabajadores activos) × 100.
- Ausentismo (%): (Horas no trabajadas / Horas programadas) × 100. Esto puede hacerse desde la funcionalidad horarios que ya funciona.
- Headcount: Total de empleados activos por sede, CECO, cargo o tipo de personal..
- Permitir filtrar por empresa, sede, CECO, cargo, tipo de personal, periodo (mensual / trimestral / anual / personalizado) y canal (salón, bar, delivery).
- El usuario podrá comparar indicadores entre sedes o periodos.
- El dashboard debe incluir gráficos interactivos y tarjetas resumen.

**Integraciones:** * Módulo de Ventas: Fuente de ventas totales y propinas.           * Módulo de RR.HH. – Planillas: Fuente para costo laboral, headcount y HHEE.           * Módulo de RR.HH. – Asistencia: Fuente para ausentismo.           * Módulo de Estructura Organizacional: Fuente para sedes y canales.           *...

---

##### ﻿HU-RRH-RA-ES-001 – Emisión de Boletas/Recibos y Planillas por Periodo, Sede o Empresa

**Descripción:** Como analista de nómina o responsable de RR.HH., quiero emitir boletas o recibos individuales y planillas completas de cada periodo de pago, filtrando por sede, empresa o grupo de trabajadores, de forma que pueda entregar comprobantes de pago legales y consolidados, cumpliendo con las normas laborales y fiscales vigentes. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Reportes y Analítica > Estándar > Emisión de Boletas y Planillas ________________

**Criterios de Aceptación clave:**

- El sistema debe permitir emitir boletas/recibos individuales en formato PDF por trabajador.
- Debe permitir generar planillas consolidadas agrupadas por empresa, sede o centro de costo.
- Las boletas deben mostrar:
- Datos del trabajador, puesto, periodo y fecha de emisión.
- Detalle de ingresos, descuentos, aportes y neto a pagar.
- Las planillas deben incluir:
- Totales por concepto y por trabajador.
- Totales consolidados por centro de costo, sede y empresa.
- Debe permitir filtros por: empresa, sede, grupo de cálculo, tipo de planilla, periodo.
- Incluir opciones para exportar en PDF, Excel o XML.

**Integraciones:** * Módulo de Nómina: Obtiene la información de ingresos, descuentos y netos.                 * Módulo de Seguridad: Controla permisos y acceso a las boletas.                 * Módulo de Contabilidad: Enlaza las planillas con asientos contables asociados.                 * Módulo de Empresa / Sedes: O...

---

##### ﻿HU-RRH-RA-ES-002 – Distribución de Costos por Centro de Costo, Canal y Unidad de Negocio

**Descripción:** Como analista de recursos humanos o responsable financiero, quiero que el sistema distribuya automáticamente los costos de planilla por centro de costo, canal operativo (cocina, salón, delivery) y unidad de negocio, de acuerdo con los criterios configurados, para reflejar con precisión la carga laboral en los reportes de costos y rentabilidad. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Reportes y Analítica > Estándar > Distribución de Costos por Centro de Costo y Canal ________________

**Criterios de Aceptación clave:**

- El sistema debe distribuir automáticamente los costos de planilla según los centros de costo asignados a cada trabajador.
- Debe permitir configurar reglas de distribución por porcentaje o valor fijo entre canales (cocina, salón, delivery).
- Cada trabajador debe estar asociado a uno o más centros de costo o unidades de negocio.
- El sistema debe generar un reporte consolidado con los montos asignados por área, canal y unidad de negocio.
- Los reportes deben poder filtrarse por periodo, sede, centro de costo, canal o tipo de trabajador.
- Permitir exportación en Excel y PDF.
- Cada proceso de distribución debe quedar registrado en el log de auditoría (fecha, usuario, periodo, tipo de distribución).
- Las reglas aplicadas deben ser versionadas y parametrizables por empresa y país.
- En caso de ajustes manuales, el sistema debe permitir recalcular la distribución y dejar trazabilidad.
- Debe existir integración con contabilidad para registrar los asientos correspondientes por centro de costo.

**Integraciones:** * Módulo de Contabilidad: Para generar asientos contables por centro de costo y canal.     * Módulo de Nómina: Fuente de datos para los costos de personal (sueldos, beneficios, aportes).     * Módulo de Estructura Organizacional: Proporciona los centros de costo y unidades de negocio definidos.     ...

---

##### ﻿HU-RRH-TD-CAP-001 – Gestión de Cursos – v1.0

**Descripción:** Como Analista de Talento y Desarrollo, quiero gestionar el registro, programación, ejecución y seguimiento de cursos de capacitación, para mantener actualizadas las competencias del personal y cumplir con los planes de desarrollo establecidos por la empresa. ________________

**Criterios de Aceptación clave:**

- Criterio
- Descripción / Condición de aceptación
- Creación de curso
- Permitir registrar un curso con nombre, tipo, modalidad, fecha, instructor y costo.
- Asignación de participantes
- Permitir asignar participantes manualmente o por área/cargo/sucursal.
- Control de asistencia
- Registrar asistencia en cada sesión del curso.
- Evaluación del curso
- Permitir registrar notas o niveles de aprobación para los participantes.

---

##### ﻿HU-RRH-TD-CL-001 – Encuestas y Feedback – v1.0

**Descripción:** Como Analista de Talento y Desarrollo, quiero crear, aplicar y analizar encuestas de clima laboral y feedback continuo, para evaluar la percepción de los colaboradores respecto al ambiente de trabajo, liderazgo, comunicación y bienestar, permitiendo tomar acciones de mejora y fortalecer la cultura organizacional. ________________

**Criterios de Aceptación clave:**

- Criterio
- Descripción / Condición de aceptación
- Creación de encuesta
- Permitir crear una encuesta con título, tipo (clima, satisfacción, feedback), periodo y estado.
- Configuración de preguntas
- Permitir agregar preguntas con distintos tipos de respuesta (escala, múltiple, texto).
- Asignación de participantes
- Seleccionar colaboradores manual o masivamente por área, cargo o sucursal.
- Envío de encuestas
- Enviar encuestas por correo o notificación interna con enlace seguro.

---

##### ﻿HU-RRH-TD-PC-001 – Trayectoria y Sucesión – v1.0

**Descripción:** Como Analista de Talento y Desarrollo, quiero gestionar los planes de trayectoria y sucesión de los colaboradores, para identificar, preparar y monitorear el desarrollo de talento interno que permita cubrir posiciones críticas dentro de la organización, asegurando la continuidad operativa y el crecimiento profesional. ________________

**Criterios de Aceptación clave:**

- Criterio
- Descripción / Condición de aceptación
- Creación de plan de trayectoria
- Permitir registrar una trayectoria para un colaborador, indicando cargo actual, meta profesional y ruta sugerida.
- Plan de sucesión por puesto
- Permitir crear un plan de sucesión asociado a un cargo clave, con posibles reemplazos y nivel de preparación.
- Asociación de competencias
- Vincular competencias y habilidades requeridas por cada cargo o trayectoria.
- Integración con evaluaciones
- Mostrar resultados de desempeño, potencial y cursos completados del colaborador.

---

##### ﻿HU-RRHH-AJ-AS-001 - Registro de Marcaciones desde POS, Biométrico o App Móvil con Geolocalización - v1.0

**Descripción:** Como responsable de Recursos Humanos, quiero que el sistema registre las marcaciones de entrada y salida de los trabajadores desde diferentes dispositivos (POS, biométrico o aplicación móvil), con soporte para geolocalización y control de tolerancias, para garantizar una gestión precisa, segura y automatizada de la asistencia.

**Navegación:** Ruta: Menú Principal > RR.HH. > Asistencia y Jornadas > Asistencias > Registro de Marcaciones

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar automáticamente marcaciones de entrada, salida, refrigerio y retorno.
- Capturar marcaciones desde diferentes dispositivos: POS (punto de venta), equipos biométricos o aplicación móvil.
- Soportar geolocalización GPS para validar ubicación en el momento de la marcación móvil.
- Definir tolerancias de entrada y salida configurables por sede, cargo o turno.
- Validar marcaciones duplicadas o fuera de horario.
- Permitir sincronización automática de marcaciones en tiempo real o diferido (offline > online).
- Identificar tipo de dispositivo y origen de la marcación.
- Mostrar alertas o notificaciones de marcaciones fuera de rango o no registradas.
- Permitir ajustes manuales por personal autorizado (con trazabilidad).

**Integraciones:** Integración con:             * Control de Asistencia: para consolidar marcaciones y generar reportes automáticos.              * Módulo de Nómina: para calcular horas efectivas, extras y ausencias.              * Calendarios Laborales: para aplicar feriados y turnos definidos por sede.              ...

---

##### ﻿HU-RRHH-AJ-CL-001 - Configuración de Feriados y Turnos Rotativos por Sede o Canal - v1.0

**Descripción:** Como responsable de Recursos Humanos, quiero configurar los feriados nacionales y locales, así como los turnos rotativos de trabajo, con reglas específicas por sede o canal operativo, para asegurar una correcta gestión de asistencia, cálculo de horas trabajadas y cumplimiento normativo en cada ubicación.

**Navegación:** Ruta: Menú Principal > RR.HH. > Asistencia y Jornadas > Calendarios Laborales > Configuración de Feriados y Turnos

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar feriados nacionales y locales, diferenciando por país, región, sede o canal.
- Configurar turnos fijos y rotativos, indicando hora de inicio, fin y descanso.
- Asociar reglas específicas por sede o canal (por ejemplo, salón, delivery, cocina).
- Definir turnos nocturnos y su impacto en recargos y sobretiempo.
- Permitir copiar y reutilizar configuraciones de turnos o calendarios entre sedes.
- Marcar feriados como remunerados, no laborables o compensables.
- Establecer reglas de rotación automática (por día, semana o ciclo).
- Visualizar un calendario interactivo por sede o canal con los turnos y feriados aplicados.
- Exportar el calendario configurado en formato Excel o PDF.

**Integraciones:** Integración con:             * Módulo de Asistencia: para aplicar automáticamente feriados y turnos en los marcajes.              * Módulo de Nómina: para calcular correctamente días laborados, feriados y recargos.              * Ficha de Empleado: para asociar el calendario correspondiente a cada t...

---

##### ﻿HU-RRHH-AJ-HR-001 - Cálculo Automático de Horas Extra y Recargos - v1.0

**Descripción:** Como analista de nómina, quiero que el sistema calcule automáticamente las horas extra y los recargos aplicables (25%, 35%, nocturnidad, domingos y feriados), considerando las normativas laborales de cada país, para garantizar el cumplimiento legal y la correcta liquidación de remuneraciones.

**Navegación:** Ruta: Menú Principal > RR.HH > Asistencia y Jornadas > Horas Extras y Recargos

**Criterios de Aceptación clave:**

- El sistema debe:
- Identificar automáticamente las horas trabajadas fuera del horario habitual registrado en el calendario laboral.
- Calcular las horas extra con 25% de recargo (primeras horas adicionales) y 35% de recargo (horas posteriores), conforme a la normativa local.
- Detectar y aplicar recargos nocturnos según el rango horario definido (por ejemplo, entre 22:00 y 06:00 horas).
- Calcular recargos dominicales y feriados, tomando en cuenta los feriados nacionales/locales configurados.
- Considerar los turnos rotativos o especiales definidos en el calendario laboral de cada sede.
- Permitir parametrizar los porcentajes de recargo por país o grupo de trabajadores.
- Mostrar en el resumen de asistencia las horas normales, extras y con recargo.
- Validar que las horas extra hayan sido autorizadas antes de su liquidación.
- Integrar los valores calculados con el módulo de planillas para su pago.

**Integraciones:** Integración con:             * Módulo de Asistencia: para obtener las marcaciones diarias y los horarios reales trabajados.              * Módulo de Planillas: para aplicar los montos calculados en el pago de remuneraciones.              * Módulo de Configuración General: para importar feriados y pa...

---

##### ﻿HU-RRHH-AJ-PM-001 - Flujo Digital de Permisos Remunerados/No Remunerados con Envío a Nómina - v1.0

**Descripción:** Como responsable de Recursos Humanos, quiero que el sistema gestione digitalmente las solicitudes, aprobaciones y registros de permisos remunerados y no remunerados, integrando automáticamente la información con el módulo de nómina, para garantizar un control eficiente del ausentismo y su correcta repercusión en el cálculo de planillas.

**Navegación:** Ruta: Menú Principal > RR.HH > Asistencia y Jornadas > Permisos > Flujo Digital de Permisos

**Criterios de Aceptación clave:**

- El sistema debe:
- Permitir a los trabajadores solicitar permisos desde el portal o aplicación móvil, especificando tipo (remunerado / no remunerado), motivo, fecha de inicio y fin.
- Enviar automáticamente la solicitud al jefe directo o responsable asignado para su aprobación o rechazo.
- Notificar al solicitante sobre el estado del permiso (pendiente, aprobado, rechazado).
- Registrar el permiso aprobado en el histórico de asistencias del trabajador.
- Enviar automáticamente a nómina los permisos no remunerados o parciales para su deducción proporcional.
- Permitir la configuración de políticas de permisos (máximo de días, tipos válidos, niveles de aprobación).
- Soportar flujos de aprobación multinivel según jerarquía definida en la estructura organizacional.
- Generar un comprobante digital de cada permiso aprobado o rechazado.
- Permitir la anulación o modificación de permisos antes del inicio del período solicitado.

**Integraciones:** Integración con:             * Módulo de Asistencia: para reflejar automáticamente los días u horas de permiso en el control de jornada.              * Módulo de Nómina: para aplicar los descuentos o pagos según el tipo de permiso.              * Módulo de Estructura Organizacional: para identificar...

---

##### ﻿HU-RRHH-AJ-VL-001 - Registro y Consulta de Vacaciones, Licencias y Subsidios (Soporte de Carga Masiva) - v1.0

**Descripción:** Como analista de RR.HH., quiero registrar y consultar las vacaciones, licencias y subsidios de los trabajadores, con opción de carga masiva, para mantener actualizado el historial de ausencias y asegurar la correcta aplicación de políticas laborales y cálculo en planillas.

**Navegación:** Ruta: Menú Principal > RR.HH > Asistencia y Jornadas > Vacaciones y Licencias

**Criterios de Aceptación clave:**

- El sistema debe:
- Permitir el registro individual o masivo de vacaciones, licencias (remuneradas / no remuneradas) y subsidios (maternidad, enfermedad, etc.).
- Validar que el trabajador tenga saldo disponible de vacaciones antes de registrar un nuevo período.
- Generar automáticamente el saldo actualizado de vacaciones después de cada registro.
- Soporta importación masiva desde archivo Excel o CSV, validando formato y consistencia de datos.
- Permitir la edición, aprobación o anulación de registros según permisos del usuario.
- Mostrar en vista de calendario o lista todos los registros de vacaciones, licencias y subsidios.
- Integrarse con el módulo de asistencia, reflejando las ausencias correspondientes.
- Integrarse con nómina, enviando los días de ausencia, goce o subsidio para el cálculo de pagos y descuentos.
- Permitir definir tipos de licencia y subsidio parametrizables por país.

**Integraciones:** Integración con:             * Módulo de Asistencia: actualización automática de ausencias.              * Módulo de Nómina: transferencia de días de vacaciones o licencias para cálculo de pagos/descuentos.              * Módulo de Estructura Organizacional: identificación de jerarquías para aprobac...

---

##### ﻿HU-RRHH-CONF-GC-001 - Agrupación de Trabajadores por Sede, Centro de Costo, Canal, Cargo y Salario - v1.0

**Descripción:** Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero poder agrupar a los trabajadores según su sede, centro de costo, canal de atención (salón, bar, delivery), cargo y rango salarial, para facilitar los procesos de cálculo de planillas, análisis de costos laborales y generación de reportes de gestión.

**Navegación:** Ruta: Menú Principal > RR.HH. > Configuración > Grupos de Cálculo

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Crear y mantener grupos de cálculo de trabajadores.
- Definir los criterios de agrupación:
- Sede o local.
- Centro de costo (CECO).
- Canal de atención (salón, bar, delivery, cocina, etc.).
- Cargo o puesto.
- Rango salarial o categoría de remuneración.
- Asignar trabajadores de forma manual o automática según los criterios definidos.
- Visualizar la cantidad total de trabajadores incluidos en cada grupo.

**Integraciones:** Integración con los módulos de:                   * Nómina: para el cálculo automático de planillas por grupo definido.                    * Finanzas: para registrar los costos laborales por centro de costo.                    * Presupuestos: para proyectar gastos de personal por canal o sede.      ...

---

##### ﻿HU-RRHH-CONF-NUM-001 - Generación de Numeración Automática para Documentos del Módulo de RR.HH. - v1.0

**Descripción:** Como usuario administrador del módulo de Recursos Humanos de Restaurant.pe, quiero configurar y generar la numeración automática para los registros y documentos del módulo (trabajadores, solicitudes, boletas/recibos, contratos y planillas), de manera que se mantenga un control ordenado, correlativo y sin duplicidades en la identificación de cada documento o registro generado por el sistema.

**Navegación:** Ruta: Menú Principal > RR.HH. > Configuración > Numeradores Automáticos

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Definir numeraciones automáticas para los siguientes documentos:
- Registro de trabajadores. Puede ser un código de trabajador asignado según correlativo, código alfanumérico, el uso de su DNI o cualquier otro que la empresa defina.
- Solicitudes (de vacaciones, licencias, adelantos, etc.).
- Boletas o recibos de pago.
- Contratos laborales.
- Planillas de pago.
- Establecer prefijos personalizables por tipo de documento y por sede (Ejemplo: “RRHH-CT-2025-0001”).
- Configurar el formato de numeración (alfanumérico, con ceros a la izquierda, separadores, etc.).
- Controlar la secuencia correlativa de manera automática sin permitir duplicados.

**Integraciones:** Integración con los módulos de:                   * Nómina: para numerar automáticamente las planillas y boletas generadas.                    * Gestión de Personal: para asignar identificadores únicos a los trabajadores registrados.                    * Gestión Documental: para vincular los números...

---

##### ﻿HU-RRHH-CONF-PAR-002 - Registro de Remuneración Mínima por País y Vigencia - v1.0

**Descripción:** Como usuario administrador del módulo de Recursos Humanos de Restaurant.pe, quiero registrar y mantener actualizada la remuneración mínima legal por país y su periodo de vigencia, para que el sistema pueda validar automáticamente el cumplimiento de las normas laborales y evitar errores en el cálculo de sueldos, beneficios sociales, tributos y otros.

**Navegación:** Ruta: Menú Principal > RR.HH. > Configuración > Parámetros del Módulo > Remuneración Mínima Legal

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar el monto de la remuneración mínima según país.
- Definir la fecha de inicio y fin de vigencia de cada valor.
- Mantener un histórico de cambios en los valores de remuneración mínima.
- Aplicar validaciones automáticas durante el registro o modificación de sueldos, evitando que el salario base de un empleado esté por debajo del valor vigente.
- Mostrar alertas cuando la remuneración mínima esté próxima a vencer.
- Permitir registrar remuneraciones mínimas diferentes por categoría ocupacional o tipo de contrato, si aplica según el país.
- Registrar toda creación, modificación o eliminación de registros en el log de auditoría contable (usuario, fecha, hora, acción).
- Mostrar las remuneraciones mínimas en moneda local y su equivalente en moneda corporativa (USD) para entornos multipaís.

**Integraciones:** Integración con Nómina: para validar el cumplimiento de la remuneración mínima durante el cálculo de sueldos. Integración con Empleados: para alertar sobre empleados con remuneraciones por debajo del mínimo vigente. Integración con Contabilidad: para generar reportes de cumplimiento laboral. Integra...

---

##### ﻿HU-RRHH-CONF-PAR-003 - Definición de Reglas de Impuestos y Contribuciones Laborales - v1.0

**Descripción:** Como usuario administrador del módulo de Recursos Humanos de Restaurant.pe, quiero definir las reglas de cálculo de los impuestos sobre la renta del trabajo (ISR/IRPF o equivalente) y las contribuciones obligatorias a seguridad social, fondos de pensiones y salud, para garantizar que el sistema calcule automáticamente las retenciones y aportes conforme a la legislación laboral y tributaria de cada país.

**Navegación:** Ruta: Menú Principal > RR.HH. > Configuración > Parámetros del Módulo > Reglas de Impuestos y Contribuciones Laborales

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar y parametrizar las tablas o tramos de impuesto a la renta del trabajo (ISR, IRPF, o equivalente) por país.
- Definir los porcentajes de contribuciones a la seguridad social, fondos de pensiones, salud y otras cargas patronales.
- Establecer topes máximos y mínimos de aportes, según lo dispuesto por cada legislación local.
- Indicar si cada concepto es a cargo del empleado o del empleador.
- Permitir la configuración de fórmulas automáticas de cálculo según tramos, bases imponibles y deducciones aplicables.
- Definir vigencias por periodo fiscal o año tributario.
- Registrar toda creación, modificación o eliminación en el log de auditoría contable (usuario, fecha, hora, acción).
- Validar que las reglas estén completas antes de ejecutar el proceso de nómina.
- Mostrar alertas con ventanas emergentes cuando una tabla o regla esté por vencer o requiera actualización.

**Integraciones:** Integración con Nómina: para aplicar automáticamente las reglas configuradas al momento del cálculo de sueldos y deducciones. Integración con Contabilidad: para generar los asientos contables de retenciones y aportes patronales. Integración con Finanzas: para programar los pagos de impuestos y contr...

---

##### ﻿HU-RRHH-CONF-PG-001 - Configuración de Provisiones de Gastos de Planillas - v1.0

**Descripción:** Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero configurar las provisiones de gastos de planillas como vacaciones, gratificaciones, CTS, y bonificaciones por desempeño, para que el sistema calcule automáticamente las obligaciones laborales y registre las provisiones contables correspondientes de acuerdo con la normativa vigente de cada país.

**Navegación:** Ruta: Menú Principal > RR.HH. > Configuración > Provisión de Gasto

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar los tipos de provisiones aplicables: vacaciones, gratificaciones, CTS, Utilidades. bonificaciones por desempeño, indemnizaciones, etc.
- Definir los parámetros de cálculo (porcentaje, fórmula, base de cálculo, periodicidad).
- Asociar cada provisión con las cuentas contables correspondientes (gasto, pasivo, centro de costo).
- Configurar reglas específicas por país, según la normativa laboral vigente.
- Para Perú considerar el régimen a  la cual pertenece la empresa para el calculo de las provisiones.
- Determinar si la provisión aplica a todos los trabajadores o solo a determinados grupos (por sede, centro de costo o tipo de contrato).
- Calcular automáticamente las provisiones al generar la planilla mensual.
- Permitir la edición de fórmulas o tasas sin afectar los cálculos históricos ya registrados.
- Registrar las provisiones en la contabilidad del sistema de forma automática.

**Integraciones:** Integración con los módulos de:             * Nómina: para el cálculo automático de provisiones mensuales en base al salario bruto y beneficios del trabajador.              * Contabilidad: para generar asientos contables automáticos de provisiones por gasto y pasivo.              * Finanzas: para la...

---

##### ﻿HU-RRHH-MP-AS-001 - Afiliación a Fondos de Pensiones, Salud y Riesgos Laborales (Parametrizable por País) - v1.0

**Descripción:** Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero registrar y administrar la afiliación de los trabajadores a fondos de pensiones, seguros de salud y riesgos laborales, considerando las normas y entidades aplicables según el país, para garantizar el cumplimiento legal y la correcta aplicación de descuentos y aportes en planilla.

**Navegación:** Ruta: Menú Principal > RR.HH. > Maestros de Personal > Administradoras y Seguros > Afiliación a Fondos de Pensiones, Salud y Riesgos Laborales

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar la afiliación de cada trabajador a un fondo de pensiones (AFP, ONP, ISSS, IVSS, IESS, etc.) según el país.
- Asociar la entidad de salud correspondiente (ESSALUD, EPS, ARL, Seguro Social, etc.).
- Configurar y parametrizar las tasas de aporte, retención y cobertura de cada entidad.
- Registrar la fecha de afiliación y el número de cuenta o código de asegurado.
- Soportar múltiples tipos de seguros y fondos (públicos y privados).
- Validar que el trabajador tenga como mínimo una afiliación activa por cada tipo de fondo obligatorio.
- Permitir actualizar las tasas de aporte de manera centralizada y por país.
- Registrar automáticamente los cambios de afiliación en el historial laboral del empleado.
- Exportar la información a formatos requeridos por entidades fiscalizadoras o ministerios laborales.

**Integraciones:** Integración con:             * Nómina: para aplicar automáticamente las tasas de aporte según el fondo registrado.              * Contabilidad: para generar los asientos contables de aportes y retenciones.              * Tesorería: para emitir los pagos a las entidades administradoras.              ...

---

##### ﻿HU-RRHH-MP-CL-001 - Definición de Categorías Laborales (Indefinido, Temporal, Eventual, Prácticas, Servicios Profesionales) - v1.0

**Descripción:** Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero definir y mantener las categorías laborales de los trabajadores, como indefinido, temporal, eventual, prácticas o servicios profesionales, para clasificar adecuadamente cada vínculo laboral y facilitar su tratamiento en procesos de nómina, contratos y reportes legales.

**Navegación:** Ruta: Menú Principal > RR.HH. > Maestros de Personal > Clasificación > Categorías Laborales

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar nuevas categorías laborales con su descripción, código y condiciones aplicables.
- Mantener categorías predefinidas como: Indefinido, Temporal, Eventual, Prácticas, Servicios Profesionales (Honorarios).
- Editar o eliminar categorías, respetando las restricciones de integridad si ya están asociadas a empleados.
- Asociar a cada categoría sus parámetros específicos: tipo de contrato, beneficios aplicables, y consideraciones tributarias o de seguridad social.
- Definir la vigencia de cada categoría y su aplicabilidad por país.
- Controlar que cada empleado esté asociado a una única categoría laboral activa.
- Permitir filtrar o agrupar empleados por categoría desde reportes o listados.
- Integrarse con la generación automática de contratos, aplicando la categoría correspondiente.
- Registrar en bitácora toda modificación o eliminación realizada sobre una categoría.

**Integraciones:** Integración con los módulos de:             * Contratos: para definir el tipo de contrato predeterminado según categoría.              * Nómina: para aplicar beneficios, aportes y retenciones según la categoría laboral.              * Contabilidad: para asignar cuentas contables de gastos según el t...

---

##### ﻿HU-RRHH-MP-CL-002 - Catálogo de Cargos, MOF (manual de organización y funciones) y Bandas Salariales - v1.0

**Descripción:** Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero registrar, mantener y consultar el catálogo de cargos y MOF disponibles en la organización, junto con sus respectivas bandas salariales, para garantizar una estructura organizacional estandarizada y equitativa, facilitando la gestión de remuneraciones, presupuestos y contrataciones.

**Navegación:** Ruta: Menú Principal > RR.HH. > Maestros de Personal > Clasificación > Catálogo de Cargos, MOF y Bandas Salariales

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar cargos nuevos con su nombre, descripción, nivel jerárquico y responsabilidades.
- Definir bandas salariales (mínimo, promedio, máximo) por cargo y por sede o país.
- Registrar MOF (Manual de Organización y Funciones) para cada cargo existente.
- Asociar cada cargo a un área funcional, centro de costo y categoría laboral.
- Mantener información de vigencia y estado (activo/inactivo) para cada cargo.
- Validar que las bandas salariales cumplan con el salario mínimo legal vigente por país.
- Editar, desactivar o eliminar cargos, siempre que no estén asociados a empleados activos.
- Consultar el listado de cargos filtrando por sede, país, estado o rango salarial.
- Exportar el catálogo de cargos y MOF a Excel o PDF.

**Integraciones:** Integración con los módulos de:             * Ficha de Empleado: para asignar el cargo y validar que la remuneración esté dentro de la banda salarial definida.              * Nómina: para aplicar automáticamente los parámetros salariales y beneficios asociados al cargo.              * Presupuesto de...

---

##### ﻿HU-RRHH-MP-EO-001 - Definición de Áreas y Jerarquías por Local/Sucursal/Cadena (Soporte Multiempresa) - v1.0

**Descripción:** Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero definir y mantener la estructura organizacional por empresa, local, sucursal o cadena, estableciendo jerarquías entre áreas, departamentos y cargos, para facilitar la gestión administrativa, control de personal y procesos de aprobación de documentos.

**Navegación:** Ruta: Menú Principal > RR.HH. > Maestros de Personal > Estructura Organizacional > Definición de Áreas y Jerarquías

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Crear, editar y eliminar áreas organizacionales (ej. Administración, Cocina, Atención, Logística).
- Establecer la jerarquía entre áreas (superiores e inferiores) y sus dependencias internas.
- Asociar responsables o jefes por área.
- Definir la estructura organizacional por empresa, local, sucursal o cadena.
- Soportar configuración multiempresa y multimoneda.
- Mostrar la jerarquía de forma gráfica tipo organigrama.
- Controlar que cada área pertenezca a una empresa y sede válidas.
- Permitir registrar niveles jerárquicos ( Gerencia, Supervisión, Operativo).
- Vincular cada área con un centro de costo y su cuenta contable.

**Integraciones:** Integración con los módulos de:             * Ficha de Empleado: para asociar cada trabajador a un área o nivel jerárquico.              * Nómina: para imputar costos de personal según el área o centro de costo.              * Contabilidad: para vincular las áreas con cuentas contables por gasto o c...

---

##### ﻿HU-RRHH-MP-FE-001 - Registro de Datos Generales y Documentación del Empleado - v1.0

**Descripción:** Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero registrar y mantener actualizada la información personal, familiar, de domicilio y contacto de los empleados, así como sus documentos digitalizados, para contar con un expediente laboral completo, accesible y seguro que sirva como base para los procesos de nómina, beneficios, y gestión del talento.

**Navegación:** Ruta: Menú Principal > RR.HH. > Maestros de Personal > Ficha de Empleado

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar los datos generales del empleado (nombres, apellidos, tipo y número de documento, fecha de nacimiento, sexo, estado civil, nacionalidad).
- Registrar información de contacto (teléfono, correo electrónico, dirección de domicilio, país, ciudad, distrito).
- Registrar datos familiares (nombre del cónyuge, hijos, dependientes, personas de contacto en caso de emergencia).
- Adjuntar documentos digitalizados como:
- Documento de identidad.
- Contrato laboral.
- Certificados de estudios o capacitaciones.
- Ficha médica o de aptitud.
- Otros documentos relevantes.

**Integraciones:** Integración con los módulos de:                   * Nómina: para el cálculo de remuneraciones, beneficios y descuentos según la información registrada.                    * Finanzas: para la imputación contable de los costos laborales por centro de costo.                    * Gestión Documental: par...

---

##### ﻿HU-RRHH-MP-FE-002 - Gestión de Contratos, Renovaciones, Cambios de Puesto, Remuneraciones, Ascensos y Sanciones - v1.0

**Descripción:** Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero registrar, actualizar y consultar la información relacionada con los contratos, renovaciones, cambios de puesto, remuneraciones, ascensos y sanciones de los empleados, para mantener un historial laboral completo y actualizado que sirva de base para la gestión del talento, el control legal y el cálculo de nómina.

**Navegación:** Ruta: Menú Principal > RR.HH. > Maestros de Personal > Ficha de Empleado > Historial Laboral

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar contratos laborales nuevos con sus datos esenciales: tipo de contrato, fecha de inicio y fin, jornada[a], modalidad, cargo y remuneración.
- Renovar contratos existentes, conservando el historial de versiones anteriores.
- Registrar cambios de puesto[b], sede o centro de costo, indicando la fecha de vigencia y motivo del cambio.
- Actualizar remuneraciones y beneficios asociados al puesto, con registro de la fecha y aprobación correspondiente.
- Registrar ascensos o promociones internas, vinculando el nuevo cargo con la estructura organizacional.
- Registrar sanciones disciplinarias con detalle del motivo, tipo de sanción, duración y documentación adjunta.
- Adjuntar documentos digitalizados relacionados con cada evento (contratos, adendas, cartas, memorandos, resoluciones).
- Consultar el historial laboral del empleado, con línea de tiempo de eventos registrados.
- Controlar los vencimientos de contratos, generando alertas automáticas de renovación o baja.

**Integraciones:** Integración con los módulos de:             * Nómina: para actualizar automáticamente los cálculos de remuneración y beneficios según los cambios de puesto, salario o contrato.              * Contabilidad: para reflejar los ajustes en los gastos laborales y provisiones.              * Gestión Docume...

---

##### ﻿HU-RRHH-NOM-AR-001 - Cálculo de impuestos al trabajo y contribuciones sociales

**Descripción:** Como analista de nómina, quiero que el sistema calcule automáticamente los impuestos al trabajo, así como las contribuciones a la seguridad social, fondos de pensiones y seguro de salud, de acuerdo con las normativas locales de cada país, para asegurar el cumplimiento tributario y la exactitud en las planillas. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Procesos de Nómina > Aportes y Retenciones > Cálculo de Contribuciones ________________

**Criterios de Aceptación clave:**

- El sistema debe calcular los impuestos y contribuciones laborales según la normativa vigente por país.
- Debe permitir configurar tasas de aportes y retenciones diferenciadas por tipo de contrato, régimen o categoría laboral.
- Las contribuciones patronales y las retenciones del trabajador deben mostrarse de manera desglosada.
- Los valores deben integrarse automáticamente al cálculo de la planilla mensual.
- Debe permitir actualizar las tasas o fórmulas sin intervención del área técnica (parámetros administrables).
- Los cálculos deben considerar topes máximos y mínimos de aportación establecidos por ley.
- Debe generar un reporte detallado de aportes por trabajador, centro de costo y tipo de fondo.
- Toda modificación de parámetros debe registrarse en el log de auditoría (usuario, fecha, cambio).
- Los resultados deben estar disponibles tanto en moneda local como corporativa.
- ________________

**Integraciones:** * Integración con Nómina: Los aportes calculados se aplican automáticamente al procesamiento mensual de planillas.     * Integración con Contabilidad: Los aportes y retenciones generan asientos contables según cuentas definidas por empresa.     * Integración con Entidades Externas: Exportación de ar...

---

##### ﻿HU-RRHH-NOM-CC-001 - Gestión de adelantos, préstamos y amortizaciones por trabajador

**Descripción:** Como analista de nómina, quiero registrar, controlar y gestionar los adelantos y préstamos otorgados a los trabajadores, así como sus amortizaciones automáticas en planilla, aplicando políticas internas y topes establecidos por la empresa, para garantizar un control financiero adecuado y transparente. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Procesos de Nómina > Cuentas Corrientes > Gestión de Adelantos y Préstamos ________________

**Criterios de Aceptación clave:**

- El sistema debe permitir registrar adelantos y préstamos vinculados a un trabajador activo.
- Debe validar los topes máximos configurados por política (porcentaje del sueldo o monto fijo).
- Las amortizaciones deben calcularse automáticamente según número de cuotas y frecuencia de pago.
- Debe permitir registrar pagos anticipados o cancelaciones totales.
- Las amortizaciones se integran automáticamente al cálculo de planillas del periodo correspondiente.
- El usuario podrá consultar el histórico de préstamos, saldos y cuotas pendientes.
- El sistema debe permitir generar reportes por trabajador, sede o periodo.
- Toda operación debe registrarse en el log de auditoría (usuario, fecha, acción, monto).
- Solo usuarios con permisos contables o de nómina podrán editar o anular registros.
- ________________

**Integraciones:** * Integración con Nómina: Las cuotas pendientes se descuentan automáticamente en la planilla activa.     * Integración con Contabilidad: Los préstamos se registran en cuentas contables de empleados.     * Integración con Seguridad y Auditoría: Se registra cada modificación o eliminación con trazabil...

---

##### ﻿HU-RRHH-NOM-LIQ-001 - Liquidación de vacaciones, indemnizaciones y beneficios legales

**Descripción:** Como analista de recursos humanos, quiero que el sistema calcule y registre automáticamente la liquidación de vacaciones no gozadas, indemnizaciones y demás beneficios legales al cese o desvinculación del trabajador, de acuerdo con las leyes laborales de cada país, para garantizar el cumplimiento normativo y evitar errores en los pagos finales. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Procesos de Nómina > Liquidaciones > Cálculo de Liquidación de Beneficios ________________

**Criterios de Aceptación clave:**

- El sistema debe permitir seleccionar al trabajador a liquidar y generar automáticamente los conceptos aplicables según el tipo de cese (renuncia, despido, jubilación, fallecimiento, etc.).
- Debe incluir el cálculo de:
- Vacaciones pendientes y proporcionales.
- Indemnización por despido, según ley vigente del país.
- Gratificaciones, bonificaciones o CTS pendientes (según país).
- Retenciones legales o descuentos por préstamos, anticipos, u otros.
- Debe permitir parametrizar las tasas, topes y fórmulas de cálculo por país.
- El sistema debe generar el comprobante de liquidación en formato PDF y XML.
- Debe generar los
- El sistema debe permitir registrar aprobaciones digitales del cálculo antes del pago.

**Integraciones:** * Integración con Nómina: El monto liquidado debe excluirse de futuros procesos de pago.           * Integración con Contabilidad: Generación automática de asientos contables por concepto.           * Integración con Bancos: Posibilidad de generar orden de pago automática.           * Integración co...

---

##### ﻿HU-RRHH-NOM-PROV-001 - Generación de asientos contables por provisión de gastos de planilla

**Descripción:** Como analista contable o de nómina, quiero que el sistema genere automáticamente los asientos contables de provisión de gastos de planilla (gratificaciones, CTS, vacaciones, bonificaciones y otros conceptos remunerativos) según las configuraciones contables de cada empresa, para garantizar la correcta imputación de costos y provisiones en el sistema financiero-contable. ________________

**Navegación:** Ruta: Menú Principal > RR.HH > Procesos de Nómina > Provisión de Gasto > Generación de Asientos Contables ________________

**Criterios de Aceptación clave:**

- El sistema debe permitir seleccionar el periodo de nómina y la empresa para la cual se generará la provisión.
- Debe calcular automáticamente las provisiones de los siguientes conceptos:
- Gratificaciones
- CTS u otros fondos equivalentes
- Vacaciones acumuladas
- Bonificaciones extraordinarias u otros conceptos remunerativos configurados.
- Los asientos contables deben generarse en base a las cuentas contables definidas en el módulo de Parámetros de RR.HH o Contabilidad.
- El sistema debe permitir visualizar el asiento antes de su confirmación (modo “previsualización”).
- Una vez confirmados, los asientos deben registrarse automáticamente en el módulo de Contabilidad General, con número de asiento y fecha contable.
- Debe incluir soporte multiempresa y multipaís, adaptando las reglas contables y conceptos según país.

**Integraciones:** * Integración con Contabilidad: Los asientos generados deben enviarse automáticamente al libro diario general.           * Integración con CECO / Contabilidad Analítica: Las provisiones deben distribuirse por centro de costo o unidad organizativa.           * Integración con Nómina: Los valores de p...

---

##### ﻿HU-RRHH-NOM-PROV-002-Aprobar o Devolver Liquidación

**Descripción:** Como usuario aprobador del área de Recursos Humanos o Administración, quiero aprobar o devolver una liquidación laboral previamente calculada, con la finalidad de validar la información antes del pago y asegurar el control del proceso interno. ________________

**Criterios de Aceptación clave:**

- El sistema debe permitir visualizar liquidaciones únicamente en estado “En revisión”.
- El usuario debe poder visualizar el detalle completo de la liquidación en modo solo lectura.
- El sistema debe permitir aprobar o devolver la liquidación.
- Al aprobar la liquidación:
- El estado debe cambiar a “Aprobada”.
- La liquidación debe quedar bloqueada para edición.
- El sistema debe mostrar un mensaje de confirmación.
- Al devolver la liquidación:
- El estado debe cambiar a “Devuelta”.
- El sistema debe solicitar obligatoriamente el motivo de la devolución.

---

##### ﻿HU-RRHH-OD-CT-002 - Asignación de Capacitaciones, Uniformes/Equipos y Validación de Cumplimiento - v1.0

**Descripción:** Como responsable de Recursos Humanos o supervisor de área, quiero poder asignar las capacitaciones, uniformes y equipos requeridos a cada nuevo colaborador, así como registrar y validar el cumplimiento de dichas asignaciones, para asegurar que el proceso de incorporación sea completo, ordenado y conforme a los estándares de la empresa.

**Navegación:** Ruta: Menú Principal > RR.HH. > Onboarding Digital > Contratación > Asignación y Validación de Cumplimiento

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar las asignaciones de recursos y capacitaciones por colaborador, cargo o grupo.
- Definir listas preconfiguradas de elementos obligatorios (capacitaciones, uniformes, equipos) según tipo de puesto o área.
- Asignar capacitaciones internas o externas con fecha límite y responsable del seguimiento.
- Registrar la entrega de uniformes y equipos con detalle de cantidad, estado y número de serie (si aplica).
- Marcar los ítems entregados como pendientes, entregados o devueltos.
- Validar el cumplimiento de las capacitaciones mediante checklists o certificados adjuntos.
- Permitir adjuntar documentos de respaldo (fotos, firmas, comprobantes).
- Generar un estado de cumplimiento general del colaborador (porcentaje o semáforo).
- Notificar al responsable del área o RR.HH. sobre los elementos pendientes de entrega o capacitación no completada.

**Integraciones:** Integración con:             * Ficha de Empleado: para vincular automáticamente las asignaciones según cargo o área.              * Módulo de Capacitación: para validar capacitaciones completadas y registrar certificados.              * Inventario de RR.HH. / Activos: para controlar entrega y devolu...

---

##### ﻿HU-RRHH-PN-CP-001 - Configuración y Cálculo de Conceptos Fijos (Sueldo Base, Asignaciones, Descuentos Recurrentes) - v1.0

**Descripción:** Como analista de nómina, quiero configurar y calcular los conceptos fijos que forman parte de la planilla, como sueldos base, asignaciones y descuentos recurrentes, para garantizar que los pagos a los colaboradores se realicen correctamente y de manera automatizada según las políticas definidas.

**Navegación:** Ruta: Menú Principal > RR.HH > Procesos de Nómina > Cálculo de Planillas > Conceptos Fijos

**Criterios de Aceptación clave:**

- El sistema debe:
- Permitir definir, editar y eliminar conceptos fijos como sueldo base, asignaciones (alimentación, transporte, etc.) y descuentos (préstamos, aportes voluntarios, retenciones).
- Asociar cada concepto fijo a trabajadores, grupos de cálculo, cargos o centros de costo.
- Soportar vigencias por periodo, con fechas de inicio y fin de aplicación.
- Integrar los conceptos fijos automáticamente al proceso de cálculo de planilla mensual, quincenal o semanal según configuración.
- Permitir definir fórmulas o valores fijos por tipo de concepto (porcentaje, monto, proporcionalidad).
- Validar que los conceptos estén correctamente clasificados como ingreso, descuento o aporte patronal (EsSalud, AFP, ONP, etc.)
- Mostrar el detalle del cálculo por trabajador antes de confirmar la planilla.
- Permitir actualización masiva de conceptos mediante archivo Excel o interfaz de importación.
- Registrar las modificaciones en una bitácora de auditoría (fecha, usuario, acción).

**Integraciones:** Integración con:             * Módulo de Maestros de Personal: para obtener datos del trabajador y su grupo de cálculo.              * Módulo de Contabilidad: para generar asientos automáticos de devengos y descuentos.              * Módulo de Planillas: para reflejar los conceptos fijos en el cálcu...

---

##### ﻿HU-RRHH-PN-CP-002 - Carga Masiva o Automática de Variables (Horas Extra, Bonos, Comisiones, Metas) - v1.0

**Descripción:** Como analista de nómina, quiero poder realizar la carga masiva o automática de variables que influyen en el cálculo de planilla, como horas extras, bonos, comisiones o cumplimiento de metas, para asegurar que el proceso de cálculo sea más ágil, preciso y consistente con la información proveniente de otros sistemas o áreas.

**Navegación:** Ruta: Menú Principal > RR.HH > Procesos de Nómina > Cálculo de Planillas > Carga de Variables

**Criterios de Aceptación clave:**

- Permitir la importación masiva desde archivos Excel, CSV o integraciones automáticas (POS, ERP, biométrico).
- Validar estructura y tipos de datos antes de guardar.
- Asociar las variables automáticamente al trabajador y periodo correspondiente.
- Mostrar errores y permitir corrección manual.
- Registrar usuario, fecha, fuente y tipo de variable cargada.
- Integrar la información con el cálculo de planilla.
- Permitir automatización programada (por fecha o frecuencia).
- Registrar en log contable todas las cargas y modificaciones.

**Integraciones:** Integración con:          * Módulo de Asistencia: para importar horas extras.           * Módulo de Ventas / POS: para obtener comisiones y bonos por desempeño.           * Módulo de RR.HH - Evaluaciones: para metas cumplidas.           * Módulo de Contabilidad: para registrar importes variables en ...

---

##### ﻿HU-RRHH-PN-CP-003 - Distribución de Propinas Automática Integrada a Nómina - v1.0

**Descripción:** Como analista de nómina, quiero que el sistema distribuya automáticamente las propinas generadas por los empleados según reglas configurables (porcentaje, ventas por turno o rol), para que el proceso de cálculo de planilla incorpore correctamente las propinas conforme a la normativa laboral vigente de cada país.

**Navegación:** Ruta: Menú Principal → RR.HH → Procesos de Nómina → Cálculo de Planillas → Distribución de Propinas

**Criterios de Aceptación clave:**

- Permitir la definición de reglas de distribución (porcentaje fijo, ventas por turno, participación por rol o combinación).
- Calcular automáticamente el monto de propina asignado a cada trabajador.
- Validar que las reglas cumplan la legislación local del país.
- Permitir ajustes manuales supervisados con trazabilidad.
- Integrar automáticamente las propinas en el cálculo de planilla y reportes de remuneración.
- Registrar logs de auditoría: usuario, fecha, regla aplicada y monto distribuido.
- Mostrar reportes resumidos y detallados por periodo, sede y trabajador.
- Exportar resultados en formato Excel o PDF.

**Integraciones:** Módulo Integrado 	Funcionalidad 	Ventas / POS 	Importación automática del total de propinas registradas por turno. 	RR.HH – Cálculo de Planillas 	Incorporación automática de montos de propinas en la planilla del periodo. 	Contabilidad 	Generación de asientos contables por propinas distribuidas. 	Aud...

---

##### ﻿HU-RRHH-RO-CT-001 - Gestión de Plantillas con Cláusulas Locales, Firma Digital y Trazabilidad (Auditoría) - v1.0

**Descripción:** Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero contar con plantillas de contratos que incluyan cláusulas locales configurables, permitan la firma digital de las partes y registren toda la trazabilidad del proceso, para estandarizar la formalización de vínculos laborales y cumplir con las normativas legales de cada país.

**Navegación:** Ruta: Menú Principal > RR.HH. > Reclutamiento y Onboarding > Contratación > Plantillas de Contrato

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Crear y mantener plantillas de contratos laborales según tipo (indefinido, temporal, prácticas, honorarios, etc.).
- Configurar cláusulas locales y personalizables por país, empresa, sede o cargo.
- Insertar campos dinámicos (nombre del empleado, salario, cargo, fechas, tipo de jornada, etc.) para autocompletar al generar el contrato.
- Asociar cada plantilla a una categoría de contrato o grupo de cálculo.
- Generar contratos individuales desde la ficha del empleado o desde la etapa de contratación.
- Permitir firma digital del contrato por ambas partes (empleado y representante de la empresa), cumpliendo con la normativa local de cada país.
- Integrarse con proveedores de firma digital (DocuSign, Adobe Sign u otro configurable).
- Mantener registro de auditoría detallado: usuario, acción (creación, modificación, aprobación, firma), fecha y hora.
- Almacenar los documentos firmados digitalmente en repositorio seguro con control de acceso.

**Integraciones:** Integración con:             * Ficha de Empleado: para generar el contrato directamente desde el registro del trabajador.              * Firma Digital: conexión con proveedores certificados para firma electrónica legal.              * Correo Electrónico: para envío de notificaciones automáticas.    ...

---

##### ﻿HU-RRHH-RO-RS-001 - Registro y Gestión de Postulaciones, Filtros, Entrevistas, Evaluaciones y Decisiones (Integrable con Portales) - v1.0

**Descripción:** Como usuario del módulo de Recursos Humanos de Restaurant.pe, quiero registrar y gestionar todas las etapas del proceso de reclutamiento —desde la postulación hasta la decisión final— integrando la información con portales externos de empleo, para optimizar la selección de personal y asegurar la trazabilidad del proceso de contratación.

**Navegación:** Ruta: Menú Principal > RR.HH. > Reclutamiento y Onboarding > Reclutamiento y Selección > Registro y Gestión de Postulaciones

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Registrar postulaciones manualmente o recibirlas automáticamente desde portales de empleo integrados (ej. Computrabajo, Indeed, LinkedIn).
- Asignar cada postulación a una vacante activa definida en el sistema.
- Definir filtros automáticos por perfil, nivel de estudios, experiencia, habilidades o país.
- Registrar entrevistas (fecha, hora, entrevistador, modalidad).
- Evaluar candidatos mediante formularios configurables (competencias técnicas, blandas, pruebas psicométricas).
- Generar una calificación global del candidato y registrar la decisión final (Aprobado, Rechazado, En Espera).
- Adjuntar documentos como CV, certificados, resultados de pruebas, y grabaciones de entrevistas.
- Notificar automáticamente al candidato por correo sobre su avance o resultado.
- Controlar el estado del proceso por cada vacante (Abierta, En proceso, Cerrada, Cubierta).

**Integraciones:** Integración con:             * Portales de Empleo: para recepción automática de postulaciones y actualización de estado.              * Ficha de Empleado: para crear automáticamente la ficha al contratar un candidato aprobado.              * Correo Electrónico: para enviar notificaciones automáticas...

---

##### ﻿HU-RRHH-CONF-PAR-001 - Configuración de Frecuencia y Calendarios de Pago Multipaís - v1.03

**Descripción:** Como usuario administrador del módulo de Recursos Humanos de Restaurant.pe, quiero configurar la frecuencia de pago  y las fechas de corte de nómina, para garantizar que los procesos de cálculo y pago de sueldos se ejecuten correctamente según la normativa y costumbres laborales de cada país..[a][b]

**Navegación:** Ruta: Menú Principal > RR.HH. > Configuración > Parámetros del Módulo > Frecuencia y Calendarios de Pago

**Criterios de Aceptación clave:**

- El sistema debe permitir:
- Configurar la frecuencia de pago por sede o grupo de empleados (semanal, quincenal, mensual u otra personalizada).
- Definir las fechas de inicio y fin de periodo, así como la fecha de pago correspondiente.
- Establecer fechas de corte para el cierre de horas trabajadas, comisiones o variables antes del cálculo de nómina.
- Asignar frecuencias diferentes por país, respetando las normas laborales locales.
- Mostrar alertas o bloqueos cuando las fechas de corte se superpongan o interfieran con otro proceso de nómina.
- Permitir copiar configuraciones de un país o sede a otra.
- Validar que los empleados estén correctamente asociados a una frecuencia de pago antes de ejecutar la nómina.
- Registrar toda modificación, creación o eliminación de configuraciones en el log de auditoría contable (usuario, fecha, hora, acción).

**Integraciones:** Integración con Nómina: para que los cálculos de sueldos, horas extras y descuentos se ejecuten según las fechas configuradas.  Integración con Contabilidad: para programar los pagos de planillas y provisiones según los periodos definidos.  Integración con RR.HH. - Empleados: para validar la frecuen...

---


### 2.9. Módulo de Configuraciones

> **Parámetros del sistema, multicompañía, localización e integraciones**
> 
> HUs documentadas: **12** | Carpeta: `09_Configuraciones/`

#### Listado de Historias de Usuario

| # | Archivo | Título | Descripción resumida |
|---|---|---|---|
| 1 | `Base de Datos de Retenciones.txt` | ﻿Base de Datos de Retenciones | Como Administrador Contable / Contador de la Empresa, quiero configurar y administrar una base de datos de retenciones f... |
| 2 | `Ejercicios y Periodos Contables (Configuracion por Compania).txt` | ﻿Ejercicios y Períodos Contables (Configuración por Compañía) | Como Administrador Contable / Administrador del Sistema, quiero configurar el año fiscal y sus períodos mensuales para l... |
| 3 | `Gestion de Multicompanias.txt` | ﻿Gestión de Multicompañías | Como Administrador Global / Administrador de la Cuenta, quiero visualizar todas las compañías registradas y acceder a la... |
| 4 | `H.U- CON -Tipo de cambio.txt` | ﻿HU-CON-031 – Registro y Configuración del Tipo de Cambio Diario | El sistema debe permitir el registro, actualización y control diario del tipo de cambio de compra y venta, utilizado par... |
| 5 | `HU-CON-005.txt` | ﻿HU-CON-005 - Impuestos - v1.0 | El sistema debe permitir registrar, editar y mantener impuestos, estableciendo sus porcentajes, vigencia y cuentas conta... |
| 6 | `HU-CON-007.txt` | ﻿HU-CON-007 – Gestión de Monedas | El sistema debe permitir la creación, configuración, activación e inactivación de las monedas que serán utilizadas en lo... |
| 7 | `HU-FIN-TAB-004.txt` | ﻿HU-FIN-TAB-004 - Registro y Edición de las Cuentas Bancarias Usadas - v1.0 | Como usuario financiero del sistema Restaurant.pe, quiero registrar, mantener y editar las cuentas bancarias utilizadas ... |
| 8 | `HU-FIN-TAB-005.txt` | ﻿HU-FIN-TAB-005 - Canales de Pago y Cobro (Efectivo, Transferencias, Niubiz, etc | Como usuario financiero o contable del sistema Restaurant.pe, quiero registrar, consultar, editar y mantener actualizada... |
| 9 | `HU-FIN-TAB-006.txt` | ﻿HU-FIN-TAB-006 - Condiciones de Pago/Cobro (Contado, Crédito, Cuotas, etc.) - v | Como usuario del área contable o financiera de Restaurant.pe, quiero registrar y administrar las condiciones de pago y c... |
| 10 | `HU-RRH-LOC-BS-001.txt` | ﻿HU-RRH-LOC-BS-001 – Reglas Locales – v1.0 | Como Administrador de Recursos Humanos, quiero definir, configurar y mantener las reglas locales de beneficios sociales ... |
| 11 | `HU-RRH-LOC-IA-001.txt` | ﻿HU-RRH-LOC-IA-001 – Parámetros por País – v1.0 | Como Administrador de RR.HH., quiero definir y mantener los parámetros legales, tributarios y de aportes sociales por pa... |
| 12 | `HU-RRH-LOC-RE-001.txt` | ﻿HU-RRH-LOC-RE-001 – Formatos y Archivos – v1.0 | Como Administrador de Nómina o Especialista de RR.HH., quiero configurar, generar y validar los formatos electrónicos y ... |

#### Detalle de cada HU

##### ﻿Base de Datos de Retenciones

**Descripción:** Como Administrador Contable / Contador de la Empresa, quiero configurar y administrar una base de datos de retenciones fiscales genéricas, precargadas según el país de operación, para que el sistema pueda aplicar automáticamente las retenciones correctas en compras, pagos y planillas, garantizando cumplimiento fiscal, correcta contabilización y escalabilidad para distintos países de LATAM. ________________   2. Contexto y Alcance Funcional * La funcionalidad opera exclusivamente a nivel de Compa...

**Criterios de Aceptación clave:**

- Se carga automáticamente el catálogo por país al crear la compañía.
- El usuario puede editar, activar/desactivar o crear retenciones.
- El listado varía según el país de la compañía activa.
- Las retenciones se aplican correctamente en documentos.
- La contabilidad se genera correctamente.
- La solución es multipaís y escalable.
- ________________
- Flujos
- Guiarse de:
- FLUJOS DE RETENCIONES

---

##### ﻿Ejercicios y Períodos Contables (Configuración por Compañía)

**Descripción:** Como Administrador Contable / Administrador del Sistema, quiero configurar el año fiscal y sus períodos mensuales para la compañía en la que he iniciado sesión, para controlar aperturas, cierres y bloqueos de módulos contables por período, asegurando orden contable y cumplimiento fiscal. 2. Contexto y Alcance Funcional * La configuración aplica únicamente a la compañía activa en la sesión. * La cuenta puede tener múltiples compañías, pero:    * Cada compañía define sus propios ejercicios y perío...

**Criterios de Aceptación clave:**

- El usuario visualiza el año fiscal de la compañía activa.
- Puede crear y editar períodos dentro del año fiscal.
- Puede cerrar módulos por período.
- Al cambiar de compañía, se muestran otros ejercicios.
- La interfaz y comportamiento replican Odoo.
- Consideraciones Técnicas
- Persistencia estricta por company_id.
- Estados de período: open, closed.
- Bloqueo transversal por módulo y período.
- Control por permisos de rol.

---

##### ﻿Gestión de Multicompañías

**Descripción:** Como Administrador Global / Administrador de la Cuenta, quiero visualizar todas las compañías registradas y acceder a la configuración de cada una, para administrar su información general, sus sucursales y las reglas de transacciones entre empresas dentro de la misma cuenta (suscripción). 2. Contexto y Alcance Funcional * La funcionalidad opera dentro de una Cuenta (Suscripción) que puede contener múltiples compañías. * Se dispone de un panel de previsualización de compañías. * Cada compañía tie...

**Criterios de Aceptación clave:**

- El usuario visualiza todas las compañías en un panel.
- Puede acceder a la configuración individual de cada compañía.
- Puede editar la información general de la compañía.
- Puede gestionar sucursales con los mismos campos base.
- Puede configurar reglas de transacciones entre empresas.
- El sistema exige definir año y mes de inicio contable al crear una compañía.
- El sistema solo genera periodos contables desde el mes de inicio configurado.
- No es posible registrar transacciones en meses anteriores.
- El balance del primer mes válido parte de los asientos de apertura.
- El campo queda bloqueado (solo lectura) luego del primer registro contable.

---

##### ﻿HU-CON-031 – Registro y Configuración del Tipo de Cambio Diario

**Descripción:** El sistema debe permitir el registro, actualización y control diario del tipo de cambio de compra y venta, utilizado para la conversión de operaciones en moneda extranjera. El cliente debe ingresar cada día la tasa oficial vigente, y el sistema aplicará este valor automáticamente en documentos, asientos y procesos contables. Asimismo, el sistema debe mantener un historial completo y no editable de cada versión del tipo de cambio registrada, Solo se puede crear un nuevo tipo de cambio si no exist...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir registrar el tipo de cambio de compra y venta por fecha
- El sistema guarda el TC del día
- Validar que no exista otro registro activo con la misma fecha y moneda.
- Se bloquea registro duplicado
- Permitir actualizar el tipo de cambio del día actual
- Se genera un registro histórico
- No permitir modificar TC de fechas cerradas
- Mensaje de validación

---

##### ﻿HU-CON-005 - Impuestos - v1.0

**Descripción:** El sistema debe permitir registrar, editar y mantener impuestos, estableciendo sus porcentajes, vigencia y cuentas contables asociadas, para garantizar su aplicación automática en las transacciones (compras, ventas, activos fijos, nómina y otros). Esta funcionalidad busca asegurar que los impuestos sean gestionados de forma parametrizada y centralizada, alineada con la normativa tributaria del país donde opera la Razón Social activa. Cada impuesto registrado podrá asociarse a cuentas contables d...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- El sistema permite crear, editar, consultar e inactivar impuestos.
- Los registros se almacenan y actualizan correctamente.
- No se permite registrar dos impuestos con el mismo código o descripción dentro de la misma razón social.
- El sistema muestra un mensaje de validación.
- Los campos Razón Social y País son informativos.
- Se completan automáticamente según la sesión activa.
- Se pueden asociar cuentas contables de débito y crédito.
- El sistema valida que las cuentas están activas en el plan contable.

---

##### ﻿HU-CON-007 – Gestión de Monedas

**Descripción:** El sistema debe permitir la creación, configuración, activación e inactivación de las monedas que serán utilizadas en los distintos procesos contables y operativos del sistema. La gestión de monedas es un catálogo maestro, transversal a todos los módulos, y constituye la base para el registro de operaciones en moneda local y moneda extranjera. La funcionalidad no incluye el registro de tipos de cambio, los cuales se gestionan en una historia de usuario independiente. El sistema debe garantizar: ...

**Criterios de Aceptación clave:**

- Criterio
- Resultado Esperado
- Permitir registrar monedas con código único
- Moneda creada correctamente
- Permitir definir una moneda base o funcional
- Solo una moneda base activa
- No permitir duplicidad de código de moneda
- Mensaje de validación
- Permitir activar e inactivar monedas
- Cambio de estado exitoso

---

##### ﻿HU-FIN-TAB-004 - Registro y Edición de las Cuentas Bancarias Usadas - v1.0

**Descripción:** Como usuario financiero del sistema Restaurant.pe, quiero registrar, mantener y editar las cuentas bancarias utilizadas por la razón social activa, de manera que pueda gestionar correctamente los movimientos bancarios, conciliaciones y reportes de flujo de efectivo, garantizando que cada transacción esté vinculada a una cuenta bancaria válida y correctamente configurada.

**Navegación:** Ruta: Menú Principal > Finanzas > Tablas > Cuentas Bancarias

**Criterios de Aceptación clave:**

- El sistema debe permitir registrar, editar, consultar y desactivar cuentas bancarias.
- Cada registro debe contener los siguientes campos obligatorios:
- Banco (selector de tabla maestra de bancos ya predefinida por país) o permitirá crear un nuevo banco de ser necesario (Agregar nombre de banco).
- Tipo de Cuenta (Corriente / Ahorros / Línea de Crédito / Otros)
- Moneda (Soles / Dólares / Moneda local del país)
- Número de Cuenta (validado según formato bancario local)
- Número de Cuenta Interbancaria (CCI o equivalente, si aplica)
- Descripción / Alias de la cuenta
- Titular de la cuenta (informativo)
- Código Contable Asociado (cuenta contable del plan contable)

**Integraciones:** * Integración con Tesorería: las cuentas estarán disponibles para registrar movimientos de ingreso, egreso y conciliación bancaria.                                * Integración con Contabilidad: las cuentas bancarias se vinculan automáticamente a las cuentas contables de bancos del plan contable.   ...

---

##### ﻿HU-FIN-TAB-005 - Canales de Pago y Cobro (Efectivo, Transferencias, Niubiz, etc.) - v1.0

**Descripción:** Como usuario financiero o contable del sistema Restaurant.pe, quiero registrar, consultar, editar y mantener actualizada la tabla maestra de canales de pago y cobro (efectivo, transferencias, POS, pasarelas digitales como Niubiz, Yape, Plin, etc.), para que todas las transacciones financieras del sistema (ventas, compras, pagos y cobranzas) se encuentren correctamente clasificadas y asociadas a sus cuentas contables y medios operativos.

**Navegación:** Ruta: Menú Principal → Finanzas → Tablas → Medios de Pago → Canales de Pago y Cobro

**Criterios de Aceptación clave:**

- El sistema debe permitir crear, editar, consultar, activar e inactivar canales de pago y cobro.
- Cada canal deberá estar vinculado a un tipo de operación (Cobro / Pago).
- Los canales predefinidos deben incluir, al menos:
- Efectivo
- Transferencia Bancaria
- Tarjeta de Crédito / Débito (POS)
- Pasarelas Digitales (Niubiz, Yape, Plin, PayU, etc.)
- Cheques
- Otros canales definidos por el usuario.
- Cada canal deberá estar asociado a una cuenta contable del plan de cuentas.

---

##### ﻿HU-FIN-TAB-006 - Condiciones de Pago/Cobro (Contado, Crédito, Cuotas, etc.) - v1.0

**Descripción:** Como usuario del área contable o financiera de Restaurant.pe, quiero registrar y administrar las condiciones de pago y cobro que se aplican a las operaciones financieras y comerciales (ventas, compras, pagos, cobranzas), de manera que pueda controlar los plazos, modalidades y esquemas de financiamiento o cobro (contado, crédito, cuotas, mixto), asegurando la correcta integración con los módulos de cuentas por pagar y por cobrar.

**Navegación:** Ruta: Menú Principal → Finanzas → Tablas → Formas de Pago → Condiciones de Pago/Cobro

**Criterios de Aceptación clave:**

- El sistema debe permitir crear, editar, consultar, activar e inactivar condiciones de pago y cobro.
- Cada condición debe indicar si aplica a pagos, cobros o ambos.
- Debe poder definirse si la condición es Contado, Crédito o Por cuotas.
- En caso de crédito o cuotas, se deben especificar días de crédito, cantidad de cuotas, periodicidad y porcentaje por cuota (si aplica).
- Las condiciones deben poder asociarse a tipos de documento (facturas, notas de crédito, recibos, etc.) y a tipos de transacción (venta, compra, pago, cobro).
- No se permitirá la creación de condiciones duplicadas (mismo nombre y configuración).

---

##### ﻿HU-RRH-LOC-BS-001 – Reglas Locales – v1.0

**Descripción:** Como Administrador de Recursos Humanos, quiero definir, configurar y mantener las reglas locales de beneficios sociales por país, para asegurar que el sistema de nómina aplique correctamente las disposiciones legales vigentes sobre beneficios laborales, vacaciones, gratificaciones, indemnizaciones y otros conceptos específicos de cada país donde opera Restaurant.pe y segun el tipo de empresa al que corresponda (Micro Empresa, Pequeña Empresa y Regimen General). ________________

**Criterios de Aceptación clave:**

- Criterio
- Descripción / Condición de aceptación
- Creación de regla
- Permitir crear una nueva regla asociada a un país, tipo de beneficio y período de vigencia.
- Definición de fórmula
- Permitir ingresar fórmulas de cálculo en un editor lógico (ej. beneficio = sueldo base * 0.0833).
- Vigencia controlada
- No se deben solapar vigencias activas del mismo tipo y país.
- Aplicación automática
- Las reglas deben aplicarse automáticamente en los procesos de cálculo de nómina y beneficios.

---

##### ﻿HU-RRH-LOC-IA-001 – Parámetros por País – v1.0

**Descripción:** Como Administrador de RR.HH., quiero definir y mantener los parámetros legales, tributarios y de aportes sociales por país, para garantizar que el cálculo de nómina, descuentos y contribuciones se realice de acuerdo con las normativas laborales y fiscales vigentes en cada país donde opera Restaurant.pe. ________________

**Criterios de Aceptación clave:**

- Criterio
- Descripción / Condición de aceptación
- Creación de parámetro
- Permitir crear un parámetro indicando país, tipo (impuesto/aporte), nombre, porcentaje o monto y fechas de vigencia.
- Edición controlada
- Solo usuarios con rol Administrador RRHH o Contador General podrán modificar valores.
- Vigencia activa
- El sistema debe validar que no existan dos parámetros activos del mismo tipo para el mismo país y periodo.
- Aplicación automática
- Los parámetros deben reflejarse automáticamente en los cálculos de nómina y aportes.

---

##### ﻿HU-RRH-LOC-RE-001 – Formatos y Archivos – v1.0

**Descripción:** Como Administrador de Nómina o Especialista de RR.HH., quiero configurar, generar y validar los formatos electrónicos y archivos requeridos por las entidades laborales y tributarias de cada país, para cumplir con las normativas de regulación electrónica, presentación de planillas, aportes, declaraciones y reportes exigidos por los organismos oficiales (SUNAT, DIAN, SII, IESS, CCSS, etc.). ________________

**Criterios de Aceptación clave:**

- Criterio
- Descripción / Condición de aceptación
- Registro de formato
- Permitir crear un nuevo formato con nombre, país, organismo emisor y tipo de archivo.
- Configuración de estructura
- Definir campos, longitud, tipo de dato y posición según especificación técnica del organismo.
- Mapeo de datos

---


## 3. Mapa de Integraciones entre Módulos

El sistema Restaurant.pe opera como un ERP integrado donde los módulos se comunican entre sí:

```
                    ┌─────────────────┐
                    │  CONFIGURACIONES │
                    │  (Multicompañía, │
                    │   Localización)  │
                    └────────┬─────────┘
                             │
    ┌────────────┬───────────┼───────────┬────────────┐
    │            │           │           │            │
┌───▼───┐   ┌───▼───┐  ┌────▼───┐  ┌───▼───┐  ┌────▼────┐
│COMPRAS│──▶│ALMACÉN│◀─│ VENTAS │  │ RRHH  │  │PRODUCCIÓN│
└───┬───┘   └───┬───┘  └────┬───┘  └───┬───┘  └────┬────┘
    │           │           │           │            │
    └─────┬─────┴─────┬─────┘           │            │
          │           │                 │            │
     ┌────▼────┐ ┌───▼────┐            │            │
     │FINANZAS │ │ACTIVOS │            │            │
     │CxP/CxC  │ │ FIJOS  │            │            │
     └────┬────┘ └───┬────┘            │            │
          │          │                  │            │
          └────┬─────┴──────────────────┘────────────┘
               │
        ┌──────▼──────┐
        │CONTABILIDAD │
        │(Asientos,   │
        │ Libros, EEFF)│
        └─────────────┘
```

### Flujos principales de integración:

1. **Compras → Almacén:** Las órdenes de compra generan recepciones de mercadería en almacén
2. **Compras → Finanzas (CxP):** Las facturas de proveedores generan documentos por pagar
3. **Ventas → Almacén:** Las ventas descuentan stock automáticamente
4. **Ventas → Finanzas (CxC):** Las facturas de venta generan documentos por cobrar
5. **Finanzas → Contabilidad:** Los pagos, cobros y movimientos generan asientos contables
6. **Almacén → Contabilidad:** Los movimientos de inventario generan asientos de kardex
7. **RRHH → Contabilidad:** La nómina genera asientos de provisiones y gastos
8. **Activos Fijos → Contabilidad:** La depreciación genera asientos automáticos
9. **Producción → Almacén:** Consume materias primas y genera productos terminados
10. **Producción → Contabilidad:** Los costos de producción generan asientos

---

## 4. Análisis Crítico y Observaciones

### 4.1. Fortalezas del diseño

1. **Documentación estructurada:** Todas las HUs siguen un formato estándar con título, descripción, criterios de aceptación, campos, integraciones y consideraciones técnicas
2. **Visión integral:** El sistema cubre todos los procesos de un restaurante/cadena: desde la compra de insumos hasta los estados financieros
3. **Multipaís desde el diseño:** Se contempla desde el inicio la operación en múltiples países con normativas diferentes
4. **Trazabilidad completa:** Log de auditoría contable en todas las operaciones
5. **Integración contable nativa:** Todos los módulos generan asientos contables, asegurando consistencia financiera

### 4.2. Áreas de atención

1. **Módulo de Ventas poco documentado:** Solo 2 HUs con URL (Facturación de Regalías y Reporte Tributario), mientras que las demás funcionalidades de ventas no tienen HU asociada, probablemente porque ya están implementadas en el POS actual
2. **Módulo de Producción sin HUs formales:** 42 funcionalidades identificadas pero solo 1 con HU documentada (Gastos Indirectos de Fabricación), indicando que es un módulo en etapa temprana de definición
3. **Dependencia secuencial:** Módulos como Contabilidad y Activos Fijos dependen de que Finanzas y Almacén estén completos
4. **Complejidad de localización:** El soporte multipaís implica configurar impuestos, retenciones, detracciones, formatos SUNAT/DIAN y libros electrónicos por cada país
5. **6 HUs inaccesibles:** Documentos con permisos restringidos que no pudieron ser descargados

### 4.3. Patrones recurrentes en las HUs

Todas las HUs comparten un patrón de diseño consistente:

- **CRUD completo:** Crear, leer, actualizar y desactivar (nunca eliminar datos con movimientos)
- **Campos informativos:** Razón Social y País siempre de solo lectura, heredados del contexto del usuario
- **Auditoría obligatoria:** Usuario, fecha, hora, IP y acción en cada operación
- **Exportación estándar:** Excel y PDF en todos los listados y reportes
- **Validaciones de integridad:** No permitir eliminar registros con movimientos asociados
- **Perfiles de acceso:** Control granular de permisos por rol de usuario

---

## 5. Conclusión

Restaurant.pe es un **ERP completo para la industria gastronómica** que abarca 9 módulos funcionales con más de 270 funcionalidades identificadas. El sistema está diseñado para operar en un entorno **multipaís, multiempresa y multisucursal**, lo que lo hace adecuado para cadenas de restaurantes y franquicias internacionales.

El proyecto se encuentra en un estado mixto de desarrollo:

- **74 funcionalidades completas** (27%): Base operativa funcional
- **31 funcionalidades parciales** (11%): Requieren mejoras o complementos
- **141 funcionalidades por construir** (51%): Desarrollo pendiente

Los módulos con mayor madurez son **Almacén**, **Compras** y **Ventas**, mientras que **Contabilidad**, **Activos Fijos** y **RRHH** están mayormente por construir, representando la mayor carga de desarrollo futuro.

La documentación de HUs es sólida y bien estructurada, proporcionando una base clara para el desarrollo, con criterios de aceptación específicos, campos definidos e integraciones documentadas.
