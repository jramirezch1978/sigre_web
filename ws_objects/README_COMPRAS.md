# MÓDULO COMPRAS - ESTRUCTURA DE MENÚS

## Sistema ERP PowerBuilder 2017

| Opción Menú Principal | Opción Menú Desplegable | Opción Submenú 1 | Opción Submenú 2 | Opción Submenú 3 | Descripción del Proceso |
|----------------------|------------------------|-------------------|-------------------|-------------------|------------------------|
| **TABLAS** | **Maestro de Proveedores/Clientes** | Tipos de Proveedores | | | Clasificación de proveedores por categorías y características |
| TABLAS | Maestro de Proveedores/Clientes | Ficha de Proveedores/Clientes | | | Registro maestro de proveedores con datos completos |
| TABLAS | Maestro de Proveedores/Clientes | Proveedores calificados | | | Lista de proveedores calificados por categoría |
| TABLAS | Maestro de Proveedores/Clientes | Grupo Proveedores | | | Agrupación de proveedores para clasificación |
| TABLAS | Maestro de Proveedores/Clientes | Tipo de Cambio | | | Configuración de tipos de cambio |
| TABLAS | Maestro de Proveedores/Clientes | Formas de pago | | | Definición de modalidades de pago a proveedores |
| TABLAS | Maestro de Proveedores/Clientes | Criterios de evaluacion | | | Criterios para evaluación y calificación de proveedores |
| TABLAS | **Catalogacion / Clasificación** | Clases | | | Clasificación de artículos por clases |
| TABLAS | Catalogacion / Clasificación | Unidades | | | Unidades de medida para artículos |
| TABLAS | Catalogacion / Clasificación | Categorias - Sub Categorias | | | Jerarquía de categorías y subcategorías |
| TABLAS | Catalogacion / Clasificación | Maestro de Articulos | | | Registro maestro de artículos para compras |
| TABLAS | Catalogacion / Clasificación | Grupos - Super Grupos | | | Agrupación jerárquica de artículos |
| TABLAS | Catalogacion / Clasificación | Articulos vs CUBSO del Estado | | | Equivalencias con códigos CUBSO del estado |
| TABLAS | **Otros Maestros** | Maestro de Marcas de Articulo | | | Registro de marcas de artículos |
| TABLAS | Otros Maestros | Maestro de Modelos de Articulos | | | Catálogo de modelos de artículos |
| TABLAS | Otros Maestros | Maestro de Tipos de Carroceria | | | Tipos de carrocería para vehículos |
| TABLAS | Otros Maestros | Maestro de Clases y Categorias de vehiculos | | | Clasificación de vehículos |
| TABLAS | Otros Maestros | Maestro de Lineas y Sublineas de calzados | | | Líneas y sublíneas para calzados |
| TABLAS | Otros Maestros | Maestro de Colores | | | Catálogo de colores para artículos |
| TABLAS | Otros Maestros | Maestro de Tallas de Artículos | | | Catálogo de tallas disponibles |
| TABLAS | Otros Maestros | Maestro de Unidades (SUNAT Tabla 06) | | | Unidades según tabla SUNAT |
| TABLAS | Otros Maestros | Maestro de Servicios | | | Registro de servicios contratables |
| TABLAS | **Misceláneos** | Compradores | | | Registro de compradores responsables |
| TABLAS | Misceláneos | Autorizadores de OC/OS | | | Usuarios autorizados para aprobar órdenes |
| TABLAS | Misceláneos | Artículos/Servicios por Comprador | | | Asignación de responsabilidades por comprador |
| TABLAS | Misceláneos | Articulos restringidos | | | Lista de artículos con restricciones de compra |
| TABLAS | Misceláneos | Actualizar Prec Ult Compra | | | Actualización de precios de última compra |
| TABLAS | Misceláneos | Reprogramacion OC | | | Reprogramación de órdenes de compra |
| TABLAS | **Fondos de Compra** | Listado de Fondos Válidos | | | Configuración de fondos disponibles para compras |
| TABLAS | Fondos de Compra | Listado de Fondos x OT ADM | | | Fondos asignados por orden de trabajo administrativa |
| TABLAS | Fondos de Compra | Estados de atencion de requerimientos | | | Estados de atención de solicitudes de compra |
| **OPERACIONES** | **Cotizaciones** | **Bienes** | Generacion | | Generación de cotizaciones para bienes |
| OPERACIONES | Cotizaciones | Bienes | Actualizacion | | Actualización de cotizaciones de bienes |
| OPERACIONES | Cotizaciones | Bienes | Evaluacion | | Evaluación de cotizaciones de bienes |
| OPERACIONES | Cotizaciones | **Servicios** | Generacion | | Generación de cotizaciones para servicios |
| OPERACIONES | Cotizaciones | Servicios | Actualizacion | | Actualización de cotizaciones de servicios |
| OPERACIONES | Cotizaciones | Servicios | Evaluacion | | Evaluación de cotizaciones de servicios |
| OPERACIONES | **Orden de Compra** | Edicion General | | | Edición general de órdenes de compra |
| OPERACIONES | Orden de Compra | Generacion Automática | | | Generación automática desde requerimientos |
| OPERACIONES | Orden de Compra | Variacion en Cantidad OC | | | Modificación de cantidades en órdenes |
| OPERACIONES | Orden de Compra | Asignacion de OS para valorizar OC | | | Asignación de órdenes de servicio |
| OPERACIONES | Orden de Compra | Cambiar el Almacen de una OC | | | Modificación de almacén destino |
| OPERACIONES | **Orden de Servicios** | Generación | | | Generación de órdenes de servicio |
| OPERACIONES | Orden de Servicios | Acta de Conformidad de OS | | | Registro de conformidad de servicios |
| OPERACIONES | Orden de Servicios | Aprobación de Acta de conformidad | | | Aprobación de actas de conformidad |
| OPERACIONES | **Aprobaciones** | Aprobación de OC y OS | | | Proceso de aprobación de órdenes |
| OPERACIONES | Aprobaciones | Programa de Compras | | | Gestión de programa de compras |
| OPERACIONES | **Items a no atenderse** | Mov. Proyectados | | | Movimientos proyectados no atendidos |
| OPERACIONES | Items a no atenderse | Programa de compras | | | Items del programa no atendidos |
| OPERACIONES | Items a no atenderse | Orden de Compra | | | Items de OC no atendidos |
| OPERACIONES | Items a no atenderse | Orden de Servicio | | | Items de OS no atendidos |
| OPERACIONES | Items a no atenderse | No Modificar Mov Proyectados | | | Bloqueo de modificaciones |
| OPERACIONES | Items a no atenderse | Autorización IQPF | | | Autorizaciones especiales IQPF |
| **CONSULTAS** | | Cuadro Comparativo Cotizaciones | | | Comparación de cotizaciones recibidas |
| CONSULTAS | | Compras por articulo/Proveedor | | | Consulta histórica por artículo |
| CONSULTAS | | Compras por proveedor/articulo | | | Consulta histórica por proveedor |
| CONSULTAS | | Precios de compra Promediados por Mes | | | Promedios de precios por período |
| CONSULTAS | | Articulos con cotizacion vigente | | | Artículos con cotizaciones activas |
| CONSULTAS | | Proveedores | | | Consultas de información de proveedores |
| **REPORTES** | **Gestión de compras** | Atencion x Orden de Trabajo | | | Atención de requerimientos por OT |
| REPORTES | Gestión de compras | Programa de Compras | | | Reporte de programa de compras |
| REPORTES | Gestión de compras | Gestion de compras por usuario | | | Gestión por usuario comprador |
| REPORTES | Gestión de compras | Catalogo de Compras | | | Catálogo general de compras |
| REPORTES | Gestión de compras | Gestion de compras al detalle | | | Detalle de gestión de compras |
| REPORTES | Gestión de compras | Documentos de compra | | | Documentos emitidos de compra |
| REPORTES | Gestión de compras | Req. Totales x OT | | | Requerimientos totales por OT |
| REPORTES | Gestión de compras | Plan Anual de Compras | | | Planificación anual de compras |
| REPORTES | Gestión de compras | Compras Anual por Prov y Articulo | | | Análisis anual por proveedor |
| REPORTES | **ABC de compras** | ABC Resumen de compras | | | Análisis ABC resumido |
| REPORTES | ABC de compras | ABC de compras x proveedor | | | Análisis ABC por proveedor |
| REPORTES | ABC de compras | ABC de compra x articulo/servicio | | | Análisis ABC por artículo |
| REPORTES | ABC de compras | ABC de compra x usuario | | | Análisis ABC por usuario |
| REPORTES | **Análisis Operativo** | Compras por categoria | | | Análisis por categoría de artículos |
| REPORTES | Análisis Operativo | Atencion de O/Compra al detalle | | | Detalle de atención de órdenes |
| REPORTES | Análisis Operativo | OC pendientes de atencion de proveedor | | | Órdenes pendientes por proveedor |
| REPORTES | Análisis Operativo | OS pendientes de atención de proveedor | | | Servicios pendientes por proveedor |
| REPORTES | Análisis Operativo | Valorizacion saldos almacen x centro costo | | | Valorización por centro de costo |
| REPORTES | Análisis Operativo | Descuento de Orden de Servicio | | | Análisis de descuentos en OS |
| REPORTES | Análisis Operativo | Descuento de Orden de Compra | | | Análisis de descuentos en OC |
| REPORTES | Análisis Operativo | OC Seguimiento | | | Seguimiento de órdenes de compra |
| REPORTES | Análisis Operativo | Ingresos al Almacen | | | Ingresos recibidos en almacén |
| REPORTES | Análisis Operativo | Atención Programa de Compras | | | Atención del programa de compras |
| REPORTES | **Maestros** | Maestro de Artículos | | | Listado maestro de artículos |
| REPORTES | Maestros | Maestro de Proveedores / Clientes | | | Listado maestro de proveedores |
| REPORTES | Maestros | Listado de Codigos de Barra | | | Códigos de barra de artículos |
| REPORTES | Maestros | Proveedores calificados | | | Listado de proveedores calificados |
| REPORTES | Maestros | Precios Pactados | | | Precios acordados con proveedores |
| REPORTES | Maestros | Aprobadores de documentos de compra | | | Listado de aprobadores |
| REPORTES | **Reposición de Stock** | Artículo de reposición de Stock | | | Artículos para reposición |
| REPORTES | Reposición de Stock | Compras Sugeridas (Rep stock) | | | Sugerencias de compra por stock |
| REPORTES | **Servicios Vinculados** | Reporte de Costos x OC | | | Costos asociados a órdenes |
| REPORTES | **Compras Críticas** | Por Artículo (General) | | | Análisis de compras críticas |
| REPORTES | Compras Críticas | Por Almacén | | | Compras críticas por almacén |
| REPORTES | **Miscelaneos de compra** | Referencia de ordenes de compra | | | Referencias de órdenes |
| REPORTES | Miscelaneos de compra | Ordenes de compra libres | | | Órdenes sin restricciones |
| REPORTES | Miscelaneos de compra | Articulos x OT | | | Artículos por orden de trabajo |
| REPORTES | Miscelaneos de compra | Stock Valorizado Comparativo | | | Comparativo de stock valorizado |
| REPORTES | Miscelaneos de compra | Orden de Servicio Por Orden de Trabajo | | | OS vinculadas a OT |
| REPORTES | Miscelaneos de compra | Compra de Materiales | | | Reporte de compra de materiales |
| REPORTES | **Servicios** | Listado de Servicios | | | Catálogo de servicios |
| REPORTES | Servicios | Ordenes de servicio | | | Reporte de órdenes de servicio |
| REPORTES | Servicios | Orden de servicio y referencias | | | OS con sus referencias |
| REPORTES | Servicios | Orden de servicios por centro de costo | | | OS por centro de costo |
| REPORTES | **Documentos** | Solicitud de Servicios | | | Reporte de solicitudes de servicios |
| REPORTES | Documentos | Ordenes de Compra - RESUMEN | | | Resumen de órdenes de compra |
| REPORTES | Documentos | Ordenes de Compra - DETALLE | | | Detalle de órdenes de compra |
| REPORTES | Documentos | Ordenes de Servicio - RESUMEN | | | Resumen de órdenes de servicio |
| REPORTES | Documentos | Ordenes de Servicio - DETALLE | | | Detalle de órdenes de servicio |
| REPORTES | **Requerimientos pendientes** | Requerimiento de Articulos Pendientes | | | Artículos pendientes de compra |
| REPORTES | Requerimientos pendientes | Req Art Pendiente Compras por Comprador | | | Pendientes por comprador |
| REPORTES | Requerimientos pendientes | Req Art Pendiente Compras | | | Artículos pendientes general |
| REPORTES | Requerimientos pendientes | Requerimiento de Servicios Pendientes | | | Servicios pendientes de contratación |
| REPORTES | Requerimientos pendientes | Requerimientos pendientes de compra | | | Requerimientos generales pendientes |
| REPORTES | Requerimientos pendientes | OT Aprobaciones | | | Órdenes de trabajo por aprobar |
| REPORTES | Requerimientos pendientes | Atencion de Req Articulos | | | Atención de requerimientos |
| REPORTES | Requerimientos pendientes | Atencion de Req. de Materiales Por OT | | | Atención por orden de trabajo |
| REPORTES | Requerimientos pendientes | Saldos Reservados | | | Saldos reservados para compras |
| REPORTES | Requerimientos pendientes | Req Articulos Exceso | | | Requerimientos en exceso |
| REPORTES | Requerimientos pendientes | Atención Mat x OT | | | Atención de materiales por OT |
| REPORTES | Requerimientos pendientes | Vencimiento de Precios Pactados | | | Precios pactados próximos a vencer |
| REPORTES | Requerimientos pendientes | Relación de Artículos IQPF | | | Artículos relacionados con IQPF |
| REPORTES | **BASC** | **Formato de Visita** | Programa de Visitas a Clientes | | Programación de visitas BASC |
| REPORTES | BASC | Formato de Visita | Listado de Clientes y Proveedores | | Listado para visitas BASC |
| **PROCESOS** | | Cambio de Moneda en OC | | | Proceso de cambio de moneda |
| PROCESOS | | Vencimiento de Mov Reservados | | | Proceso de vencimientos |
| PROCESOS | **Regenerar Montos Totales** | Orden de Compra | | | Recálculo de totales en OC |
| PROCESOS | Regenerar Montos Totales | Orden de Servicio | | | Recálculo de totales en OS |
| PROCESOS | | Actualizar Flag OC y OV | | | Actualización de banderas |
| PROCESOS | | Actualizar PROVEEDOR_ARTICULO | | | Actualización de relaciones |
| PROCESOS | | Relacion de AMP con OC | | | Relación de movimientos proyectados |
| PROCESOS | | Reservación Automática | | | Proceso de reserva automática |
| PROCESOS | **Importar Datos** | Importar Maestro de Articulos | | | Importación masiva de artículos |
| PROCESOS | Importar Datos | Importar Fotos de Artículos | | | Importación de imágenes |

## Notas Importantes:

- El módulo maneja tanto compras de materiales como contratación de servicios
- Incluye funcionalidades avanzadas como análisis ABC y gestión BASC
- Maneja fondos de compra y autorizaciones por niveles

## Flujo Principal del Proceso:

1. **Configuración Inicial**: Registrar proveedores, artículos y condiciones
2. **Solicitudes**: Generar solicitudes de compra o servicios
3. **Cotizaciones**: Solicitar y evaluar cotizaciones
4. **Órdenes**: Emitir órdenes de compra o servicio
5. **Seguimiento**: Monitorear cumplimiento y recepciones
6. **Evaluación**: Evaluar desempeño de proveedores

## Integración con Otros Módulos:

El módulo se integra con:
- **Almacén**: Recepción de materiales comprados
- **Finanzas**: Gestión de pagos a proveedores
- **Contabilidad**: Registro contable de compras
- **Presupuesto**: Control presupuestal de compras
- **Producción**: Abastecimiento de materiales

## Alimentación a Contabilidad:

**Mecanismo de Integración Contable:**
El módulo de compras alimenta a contabilidad principalmente a través del **módulo de finanzas**, generando automáticamente documentos por pagar que luego se contabilizan mediante matrices financieras.

**Proceso de Integración:**

**1. Órdenes de Compra:**
- No generan asientos contables directos
- Crean compromisos presupuestales
- Se registran en tablas de movimientos proyectados (`articulo_mov_proy`)

**2. Recepción de Materiales:**
- Al recepcionar en almacén, se afectan las cuentas de inventario
- Se utiliza el documento de "Guía de Recepción de Materias Primas" (GRMP)
- El tipo de documento se configura en `logparam.doc_mov_almacen`

**3. Facturas de Proveedores:**
- Se registran en el módulo de **finanzas** como documentos por pagar
- Cada factura lleva asociado un concepto financiero
- El concepto determina la matriz contable a utilizar

**4. Generación Automática via Finanzas:**
- Se utiliza la función `f_generacion_ctas_cxc_cxp()` para generar asientos
- La función lee los documentos por pagar y aplica las matrices contables
- Se crean pre-asientos que se transfieren a contabilidad

**Tipos de Documentos que se Contabilizan:**
- **Facturas de Compra**: Registro de la compra y cuenta por pagar
- **Notas de Crédito**: Devoluciones y descuentos de proveedores
- **Órdenes de Servicio**: Servicios contratados a terceros
- **Gastos Diversos**: Servicios públicos, alquileres, etc.

**Cuentas Contables Afectadas:**
- **60xx**: Compras de mercaderías y suministros
- **42xx**: Cuentas por pagar comerciales (proveedores)
- **40111**: IGV por pagar
- **42171**: Renta 4ta/5ta categoría retenida
- **20xx**: Mercaderías (cuando se recepciona)

**Validaciones de Integración:**
- Verificación de que el proveedor tenga configurada matriz contable
- Validación de conceptos financieros asociados
- Control de tipos de documento para generación automática (parámetros en `ap_param`)
- Verificación de centros de costos para distribución contable
