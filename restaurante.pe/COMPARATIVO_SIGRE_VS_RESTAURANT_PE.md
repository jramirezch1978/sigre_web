# COMPARATIVO FUNCIONAL: SIGRE (PowerBuilder) vs Restaurant.pe (Nuevo ERP)

> **Fecha de generación:** 2026-02-06  
> **Propósito:** Análisis comparativo detallado de las funciones, procesos y opciones de menú del ERP legado SIGRE vs las funcionalidades planificadas para Restaurant.pe  
> **Fuente SIGRE:** Código fuente PowerBuilder en `ws_objects/`  
> **Fuente Restaurant.pe:** 204 Historias de Usuario (HUs) documentadas  

---

## RESUMEN EJECUTIVO

El ERP SIGRE en PowerBuilder contiene **10,512 objetos** distribuidos en **45 módulos**, representando más de 15 años de desarrollo y conocimiento de negocio. Restaurant.pe planifica implementar **9 módulos** con **204 HUs** documentadas que cubren las funcionalidades esenciales del ERP adaptadas al sector gastronómico.

### Tabla Resumen de Comparación

| Módulo | SIGRE (Opciones de menú) | SIGRE (Ventanas) | Restaurant.pe (HUs) | Cobertura |
|--------|:---:|:---:|:---:|:---:|
| **Almacén** | ~120 | 179 | 28 | Funciones core cubiertas |
| **Compras** | ~120 + ~75 (Aprovision) | 201 + 104 | 17 | Core cubierto, omite especializaciones |
| **Ventas / Comercialización** | ~100 | 187 | 2 (19 func.) | POS existente, ERP mínimo |
| **Finanzas** | ~130 | 185 | 41 | Amplia cobertura |
| **Contabilidad** | ~140 | 294 | 35 | Buena cobertura core |
| **Activos Fijos** | ~30 | 35 | 27 | Cobertura casi completa |
| **RRHH** | ~200+ | 309 | 42 | Buena cobertura, modernizado |
| **Producción** | ~120 | 215 | 42 func. (sin HUs formales) | En definición |
| **Presupuesto** | ~120 | 167 | 0 | No planificado |
| **Seguridad** | ~24 | 27 | (implícito) | Cross-cutting |
| **Flota** | ~80 | 136 | 0 | No aplica (pesca) |

---

## 1. MÓDULO DE ALMACÉN

### 1.1 SIGRE - Funcionalidades del Módulo Almacén

El módulo `ws_objects/Almacen/` contiene **179 ventanas**, **26 funciones**, **17 menús** y **2 objetos de usuario**.

#### Menú Tablas (Maestros y Configuración)
| Código | Función SIGRE | Equivalente Restaurant.pe |
|--------|---------------|--------------------------|
| AL001 | Tipos de Almacén | HU-ALM-TAB-ALM-001 (Lista de Almacenes) |
| AL002 | Unidades de Medida | HU-ALM-TAB-CAT-001 (implícito) |
| AL003 | Grupos de Artículos | HU-ALM-TAB-CAT-001 (Jerarquía de clasificación) |
| AL004 | Clases de Artículos | HU-ALM-TAB-MCA-001 (Naturaleza contable/inventario) |
| AL005 | Categorías y Sub-Categorías | HU-ALM-TAB-CAT-001 (Categorías > Sub > Familias) |
| AL006 | Maestro de Artículos | HU-ALM-TAB-PRO-002 (Definición de productos) |
| AL008 | Tipos de Movimiento | HU-ALM-TAB-ALM-002 (Tipos de movimientos) |
| AL009 | Numeradores | (implícito en configuración) |
| AL010 | Almacenes (maestro) | HU-ALM-TAB-ALM-001 |
| AL011-016 | Ubicaciones, Sectores, Zonas | (No planificado explícitamente) |
| AL020 | Parámetros del sistema | (Módulo Configuraciones) |

#### Menú Operaciones
| Código | Función SIGRE | Equivalente Restaurant.pe |
|--------|---------------|--------------------------|
| AL300 | Ingreso de Mercadería (OC) | HU-ALM-OP-TRA-001 (Almacenamiento desde OC) |
| AL301 | Salida de Mercadería | HU-ALM-OP-TRA-002 (Despacho de productos) |
| AL302 | Traslado entre Almacenes | HU-ALM-OP-TRA-003 (Requerimiento de traslado) |
| AL303 | Ajuste de Inventario (+/-) | HU-ALM-OP-AJU-001 (Inventario físico vs sistema) |
| AL304 | Toma de Inventario Físico | HU-ALM-OP-AJU-001 |
| AL305 | Devolución a Proveedores | HU-ALM-OP-DEV-001 (Devoluciones de compras) |
| AL306 | Ingreso por Devolución de Clientes | (No planificado) |
| AL307 | Préstamos de Mercadería | HU-ALM-CON-PRE-001 (Consulta de préstamos) |
| AL308 | Confirmación Recepción Traslado | HU-ALM-OP-TR-004 |
| AL310 | Reserva de Stock | (No planificado explícitamente) |
| AL311 | Movimientos Proyectados | (No planificado) |
| AL312 | Guías de Remisión | (No planificado, existe en Ventas SIGRE) |
| AL315 | Requerimiento de Materiales | HU-ALM-OP-SOL-001 (Solicitud de reposición) |

#### Menú Consultas
| Código | Función SIGRE | Equivalente Restaurant.pe |
|--------|---------------|--------------------------|
| AL500 | Consulta de Stock por Artículo | HU-ALM-CON-ART-001 (Consulta completa del producto) |
| AL501 | Kardex por Artículo/Almacén | HU-ALM-CON-KDX-001 (Stock con movimientos) |
| AL502 | Movimientos Proyectados | (No planificado) |
| AL503 | Saldos de Almacén | HU-ALM-REP-ALM-001 (Stock actual) |
| AL504 | OC Pendientes | HU-ALM-CON-OC-001 |
| AL505 | Consulta de Devoluciones | HU-ALM-CON-DEV-001 |

#### Menú Reportes
| Código | Función SIGRE | Equivalente Restaurant.pe |
|--------|---------------|--------------------------|
| AL700 | Stock Actual | HU-ALM-REP-ALM-001 |
| AL701 | Kardex Detallado | HU-ALM-REP-ALM-002 |
| AL702 | Stock Valorizado | HU-ALM-REP-ALMFIN-001 (Valorización económica) |
| AL703-705 | Stock por Categoría/Grupo/Clase | HU-ALM-REP-ALM-001 (filtros) |
| AL706 | Inventario Físico vs Sistema | HU-ALM-REP-ALM-005 (Resultados de toma) |
| AL707 | Artículos Bajo Mínimo | HU-ALM-REP-ALM-003 |
| AL708 | Rotación de Inventario | HU-ALM-REP-ALM-004 (Rendimiento y rotación) |
| AL710 | Productos Vendidos por Período | HU-ALM-REP-ALMFIN-002 |
| AL720 | Listado de Guías de Remisión | (No planificado) |
| AL730 | Cuadre Almacén vs Contabilidad | (Implícito en integración) |
| AL740 | Kardex en Tránsito | (No planificado) |

#### Menú Procesos
| Código | Función SIGRE | Equivalente Restaurant.pe |
|--------|---------------|--------------------------|
| AL900 | Cierre Mensual de Almacén | (Implícito) |
| AL901 | Recálculo de Saldos | HU-ALM-PR-CS-001 (Reproceso de saldos) |
| AL902 | Actualización Precio Última Compra | HU-ALM-PR-RP-001 |
| AL903 | Recálculo Precio Promedio | HU-ALM-PRO-PP-001 |
| AL905 | Generación de Guías de Transporte | (No planificado) |
| AL910 | Mermas y Pérdidas | HU-ALM-OP-AJU-002 |

### 1.2 Análisis Comparativo - Almacén

| Aspecto | SIGRE | Restaurant.pe | Diferencia |
|---------|-------|---------------|------------|
| **Maestros** | 16 pantallas de configuración | 6 HUs (simplificado) | SIGRE más granular (ubicaciones, sectores, zonas) |
| **Movimientos** | 15 tipos de operaciones | 8 operaciones core | R.pe cubre el 80% del flujo operativo |
| **Kardex** | Múltiples variantes (tránsito, proyectado) | Kardex estándar | SIGRE más especializado |
| **Valorización** | PEPS, UEPS, Promedio, por lote | PEPS/UEPS/Promedio | Equivalente |
| **Guías Remisión** | Integrado en Almacén | No incluido | Gap en R.pe |
| **Reservas de Stock** | Módulo completo | No planificado | Gap en R.pe |
| **Movimientos Proyectados** | Módulo completo | No planificado | Gap en R.pe |

**Conclusión:** Restaurant.pe cubre las funciones **core** del almacén (ingresos, salidas, traslados, inventario, kardex, valorización). No incluye funciones avanzadas de SIGRE como movimientos proyectados, reservas de stock ni guías de remisión integradas.

---

## 2. MÓDULO DE COMPRAS

### 2.1 SIGRE - Funcionalidades del Módulo Compras + Aprovision

El módulo `ws_objects/Compras/` contiene **201 ventanas** y el módulo `ws_objects/Aprovision/` contiene **104 ventanas**.

#### Tablas y Configuración (SIGRE: ~40 opciones)
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| CM001-CM003: Tipos, Ficha y Calificación de Proveedores | HU-COM-001 (Gestión de Proveedores) |
| CM005: Formas de Pago | HU-COM-002 (Condición de Pago) |
| CM007-CM011: Clases, Unidades, Categorías, Artículos, Grupos | (Compartido con Almacén) |
| CM014-CM018: Numeradores varios | (Implícito en configuración) |
| CM004: Compradores | (No planificado como maestro separado) |
| CM006: Criterios de Evaluación | (No planificado) |
| CM020: Servicios | (Implícito en OS) |
| CM021: Autorizadores de OC/OS | (Implícito en workflow de aprobación) |
| CM025: CUBSO del Estado | (No aplica sector restaurantes) |
| CM026-CM032: Marcas, Modelos, Colores, Tallas | (No aplica) |

#### Operaciones (SIGRE: ~30 opciones)
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| CM301-CM304: Solicitudes de Compra/Servicio + Aprobación | HU-COM-APR-007 (Planificación) |
| CM306-CM308: Cotizaciones de Bienes (Gen/Act/Eval) | (No planificado) |
| CM309-CM310, CM337: Cotizaciones de Servicios | (No planificado) |
| CM311: Orden de Compra (edición general) | HU-COM-003 (Generar OC) |
| CM312: OC Automática | (No planificado) |
| CM313: Aprobación de OC y OS | HU-COM-004 + HU-COM-006 (Aprobación OC/OS) |
| CM314: Orden de Servicio | HU-COM-005 (Generar OS) |
| CM305: Programa de Compras | HU-COM-APR-007 (Planificación) |
| CM331: Variación en Cantidad OC | (No planificado) |
| CM338: Autorización IQPF | (No aplica) |
| CM339-CM340: Conformidad de OS | (No planificado) |

#### Consultas y Reportes (SIGRE: ~50 opciones)
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| CM501: Cuadro Comparativo Cotizaciones | (No planificado) |
| CM502-CM503: Compras por Art/Prov y viceversa | HU-COM-RC-011, HU-COM-RC-013 |
| CM704: Compras por Categoría | HU-COM-RC-012 |
| CM705: Atención de OC al detalle | HU-COM-RC-008 |
| CM714: Reposición de Stock | HU-COM-RC-014 (Sugerencia óptima) |
| CM718: Compras Sugeridas | HU-COM-RC-014 |
| CM750-CM755: Requerimientos Pendientes | HU-COM-RC-009 (Pendientes de recepción) |
| CM760: OC Pendientes de atención | HU-COM-RC-009 |
| CM766: Gestión de compras al detalle | HU-COM-RC-008 (Lista procesadas) |
| CM780: ABC de Compras | HU-COM-RC-011 (Análisis por proveedores) |
| CM786: Plan Anual de Compras | (No planificado) |

#### Integración con Cuentas por Pagar (SIGRE → Restaurant.pe)
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| Registro de Facturas (Finanzas FI304) | HU-FIN-OPE-001 (Ingreso facturas desde compras) |
| Notas de Crédito/Débito (FI320) | HU-COM-OPE-003 (Documentos que reducen deuda) |
| Facturas no asociadas | HU-FIN-OP-CP-001 |

### 2.2 Análisis Comparativo - Compras

| Aspecto | SIGRE | Restaurant.pe | Diferencia |
|---------|-------|---------------|------------|
| **Cotizaciones** | Ciclo completo (3 fases) | No planificado | Gap significativo |
| **OC/OS** | Manual + automática + variaciones | Manual con workflow | SIGRE más completo |
| **Programa de Compras** | Módulo completo con seguimiento | Planificación básica | R.pe simplificado |
| **Proveedores** | 40+ campos con BASC | CRUD con validación fiscal | R.pe más moderno (RUC/NIT/RNC) |
| **Reportes** | 50+ reportes especializados | 7 reportes core | SIGRE mucho más amplio |
| **Conformidad OS** | Workflow con actas | No planificado | Gap en R.pe |
| **IQPF/BASC** | Módulos especializados | No aplica | Sectorial |
| **Aprovisionamiento** | Módulo completo para MP | No aplica | Sectorial (pesca/agro) |

**Conclusión:** Restaurant.pe cubre el flujo **esencial** de compras (proveedores → OC/OS → aprobación → recepción → facturación). No incluye cotizaciones, programa de compras con seguimiento, ni conformidad de OS. El módulo de Aprovision es específico del sector industrial y no aplica.

---

## 3. MÓDULO DE VENTAS / COMERCIALIZACIÓN

### 3.1 SIGRE - Funcionalidades del Módulo Comercialización

El módulo `ws_objects/Comercializacion/` contiene **187 ventanas**, **35 funciones** y **28 menús**.

#### Tablas y Configuración (~30 opciones)
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| VE001-VE009: INCOTERM, Factores/Formas de Embarque | No aplica (exportaciones) |
| VE010: Maestro de Artículos de Venta | (Ya existe en POS) |
| VE011-VE012: Canal de Distribución, Zona Comercial | (No planificado como maestro) |
| VE013: Plantilla de Orden de Venta | (No planificado) |
| VE014-VE020: Vendedores, Zonas, Cuotas, Comisiones | (No planificado como módulo ERP) |
| VE017: Precios de Artículos de Venta | (Existe en POS) |
| VE018: Puntos de Venta | (Existe en POS) |
| VE023: Parámetros Facturación Simplificada | (Existe en POS) |
| VE026: Líneas de Crédito | (No planificado) |

#### Operaciones (~20 opciones)
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| VE300: Orden de Venta | (POS existente) |
| VE317: Aprobación de OV | (No planificado ERP) |
| VE310: Registro Cuentas por Cobrar | Vinculado a Finanzas |
| VE308: Notas de Crédito/Débito | Vinculado a Finanzas |
| VE311: POS Rápido | (Existe en POS actual) |
| VE318-VE319: POS con Proformas/Tickets | (Existe en POS actual) |
| VE320-VE322: Facturación Electrónica SUNAT | (Existe en POS actual) |
| VE314: Planilla de Cobranza | HU-FIN-OP-CC-001 (Aplicación de pagos) |
| VE315: Exportaciones | No aplica sector restaurantes |
| VE323: Vales de Descuento | (POS existente) |

#### Reportes (~60+ opciones)
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| VE721-VE723: Registro de Ventas (SUNAT) | HU (sin código) - Reporte Tributario |
| VE707: ABC de Clientes | (No planificado ERP) |
| VE702-VE704: Ventas por Artículo/Grupo/Mes | (POS existente) |
| VE744-VE745: Margen de Contribución | (No planificado) |
| VE746-VE748: Pendientes por Cobrar | HU-FIN-REP-CC-001 (Estado cuenta cliente) |
| VE709, VE771: Ventas por Vendedor | (No planificado ERP) |
| VE701, VE738: Cuadro de Embarque, Gastos Exportación | No aplica |
| VE901: Facturación Masiva | (No planificado) |
| VE905: Procesamiento Factura Simplificada | (POS existente) |
| Regalías por Franquicias | HU (sin código) - Facturación de regalías |

### 3.2 Análisis Comparativo - Ventas

| Aspecto | SIGRE | Restaurant.pe | Diferencia |
|---------|-------|---------------|------------|
| **POS** | POS integrado (VE311, VE318-319) | POS existente (maduro) | R.pe más avanzado en POS |
| **Órdenes de Venta** | Ciclo completo con aprobación | No planificado como ERP | Gap (pero no crítico para restaurantes) |
| **Facturación Electrónica** | SUNAT integrado | Ya implementado en POS | Equivalente |
| **CxC y Cobranzas** | Integrado en Comercialización | Movido a Finanzas | Diseño diferente, funcionalidad equivalente |
| **Exportaciones** | Módulo completo | No aplica | Sectorial |
| **Vendedores/Comisiones** | Módulo completo | No planificado | Gap para franquicias |
| **ABC Clientes/Margen** | Análisis avanzado | No planificado | Gap analítico |
| **Regalías** | No existe | Planificado | Innovación R.pe |

**Conclusión:** El POS de Restaurant.pe es su producto **principal** y ya está maduro. Las funcionalidades ERP de ventas de SIGRE (OV con aprobación, vendedores, comisiones, exportaciones) son mayormente innecesarias para el sector gastronómico. La integración con CxC se maneja desde Finanzas en R.pe.

---

## 4. MÓDULO DE FINANZAS

### 4.1 SIGRE - Funcionalidades del Módulo Finanzas

El módulo `ws_objects/finanzas/` contiene **185 ventanas**, **104 funciones** y **15 objetos de usuario** — el módulo más grande en lógica de negocio.

#### Tablas y Configuración (SIGRE: ~40 opciones)
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| FI004-FI006: Concepto Financiero / Matrices | HU-FIN-TAB-002 (Conceptos financieros) |
| FI008-FI009: Flujo de Caja (Grupos/Conceptos) | HU-FIN-TAB-003 (Grupos y códigos de flujos) |
| FI010-FI011: Bancos y Cuentas | HU-FIN-TAB-004 (Cuentas bancarias) |
| FI022: Formas de Pago | HU-FIN-TAB-006 (Condiciones de pago/cobro) |
| FI030-FI033: Documentos (Tipos/Grupos/Num) | HU-FIN-TAB-001 (Documentos financieros) |
| FI036: Medios de Pago | HU-FIN-TAB-005 (Canales pago y cobro) |
| FI012-FI013: Autorizadores de Adelantos | (Implícito en workflow) |
| FI015: Parámetros del Sistema | (Módulo Configuraciones) |
| FI024-FI025: Detracciones (SUNAT) | (Implícito en CON-003) |
| FI026-FI027: Deuda Financiera | (No planificado explícitamente) |
| FI001: Punto de Venta | (POS existente) |
| FI002: Tipos de Impuesto | (Módulo Configuraciones) |

#### Cuentas por Cobrar
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| FI337: Canje/Renovación de Letras CxC | HU-FIN-OP-CC-002 (Letras de cambio) |
| FI338: Documentos Cobrar Directo | HU-FIN-OP-CC-003 (Facturas no de ventas) |
| FI355: Cambio Fecha Presentación | (No planificado) |
| FI357: Cheques Diferidos | (No planificado) |
| FI507: CxC por Vencimiento (consulta) | HU-FIN-TES-TES-002 (Control vencimiento) |

#### Cuentas por Pagar
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| FI304: Registro CxP | HU-FIN-OPE-001 (Ingreso facturas) |
| FI320: Nota Débito/Crédito CxP | HU-COM-OPE-003 (Documentos que reducen deuda) |
| FI353: Provisión Simplificada | (No planificado) |
| FI325: Aprobación Prov. Simplificada | (No planificado) |
| FI329: Documentos Pagar Directo | HU-FIN-OP-CP-001 (Facturas no asociadas) |
| FI366: DPD Masivos | (No planificado) |
| FI305: Canje/Renovación Letras CxP | HU-FIN-OP-CP-002 (Reprogramación) |
| FI358: CxP Sin Control Almacén | (No planificado) |

#### Adelantos / Órdenes de Giro
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| FI307: Generación Solicitud de Giro | HU-FIN-ADL-001 (Generación) |
| FI308: Aprobación | HU-FIN-ADL-002 (Aprobación) |
| FI323: Liquidación (OG/FF) | HU-FIN-ADL-003 (Liquidación) |
| FI324: Cierre Liquidación | HU-FIN-ADL-004 (Cierre) |
| FI333: Devolución (OG) | (Implícito en liquidación) |

#### Tesorería
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| FI343: Liquidación Caja | HU-FIN-TES-TES-011 (Ingresos POS) |
| FI310: Cartera de Pagos | HU-FIN-TES-TES-001 (Documentos pendientes) |
| FI326: Aplicación de Documentos | HU-FIN-OP-CC-001 (Aplicación de pagos) |
| FI312: Transferencias Bancarias | HU-FIN-TES-TES-006 (Movimiento entre cuentas) |
| FI331: Cheques Masivos | HU-FIN-TES-TES-003 (Cancelación varios docs) |
| FI356: Programación de Pagos | HU-FIN-TES-TES-007 |
| (No existe) | HU-FIN-TES-TES-008 (Fondo fijo por PdV) |
| (No existe) | HU-FIN-TES-TES-009 (Caja chica) |
| (No existe) | HU-FIN-TES-TES-010 (Proyección ingresos/egresos) |
| (No existe) | HU-FIN-TES-TES-012 (Pago ente tributario) |
| (No existe) | HU-FIN-TES-TES-013 (Pago detracción) |

#### Conciliaciones
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| FI347-FI349: Conciliación Bancaria | HU-FIN-CON-CON-001 (Extracto vs sistema) |
| (No existe) | HU-FIN-CON-CON-002 (Pasarela de pago) |
| (No existe) | HU-FIN-CON-CON-003 (Ventas ecommerce) |
| (No existe) | HU-FIN-CON-CON-004 (Estado conciliaciones) |

#### Reportes (SIGRE: ~50 reportes)
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| FI700: Libro Bancos | HU-FIN-REP-TS-001 (Movimientos bancos/caja) |
| FI713-FI714: Flujo Caja Ejecutado/Proyectado | HU-FIN-CON-FC-002 (Estado actual/proyectado) |
| FI715: Pendientes por Pagar | HU-FIN-REP-CP-001 + HU-FIN-REP-CP-002 |
| FI748: Detalle CxP por Proveedor | HU-FIN-OP-CP-005 (Relación facturas proveedor) |
| FI749: Registro de Compras | (Contabilidad en R.pe) |
| FI745: Detracciones | (Contabilidad en R.pe) |
| FI753: Analítico Cuenta Corriente | HU-FIN-REP-CC-001 (Estado cuenta cliente) |

### 4.2 Análisis Comparativo - Finanzas

| Aspecto | SIGRE | Restaurant.pe | Diferencia |
|---------|-------|---------------|------------|
| **CxP Básico** | 10 pantallas | 5 HUs | Core equivalente |
| **CxC Básico** | 5 pantallas | 4 HUs | Core equivalente |
| **Adelantos/OG** | 5 pantallas | 4 HUs | **Equivalente 1:1** |
| **Tesorería** | 7 pantallas | 13 HUs | **R.pe más completo** (fondo fijo, caja chica, PdV) |
| **Conciliaciones** | Solo bancaria | 4 tipos (banco, pasarela, ecommerce, estado) | **R.pe más moderno** |
| **Deuda Financiera** | 2 pantallas | No planificado | Gap menor |
| **Warrants** | 1 pantalla | No aplica | Sectorial |
| **SUNAT (Detracciones)** | 4 pantallas | Planificado en Contabilidad | Reubicado |
| **Rendición de Gastos** | Implícito en OG | HU-FIN-OPE-004 (workflow específico) | R.pe más explícito |

**Conclusión:** Restaurant.pe **supera** a SIGRE en tesorería moderna (fondo fijo por PdV, caja chica, conciliaciones con pasarelas digitales como Niubiz/Yape/Plin). SIGRE tiene más opciones legacy (cheques, warrants) que ya no son tan relevantes.

---

## 5. MÓDULO DE CONTABILIDAD

### 5.1 SIGRE - Funcionalidades del Módulo Contabilidad

El módulo `ws_objects/Contabilidad/` contiene **294 ventanas** — el módulo más grande en pantallas.

#### Plan de Cuentas y Maestros
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| CN002: Plan de Cuentas | HU-CON-001 (Plan contable) |
| CN008/CN018: Centro de Costos | HU-CON-001 bis (Maestro CECO) |
| CN009: Tipo de Cambio | HU-CON-031 (TC diario) |
| CN014: Plantillas Matrices Contables | HU-CON-002 (Matriz contable) |
| CN021: Sub-Categorías / Plan de Cuentas | HU-CON-005 (Subcategorías con cuentas) |
| CN044: Matrices Almacenes | HU-CON-031 (Matrices de almacenes) |
| CN054: UIT | (Módulo Configuraciones) |
| CN056: Cuentas vs SUNAT | (Implícito) |
| CN034: Cierre Contable x Mes | HU-CON-029 (Cierre mensual) |

#### Operaciones
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| CN202: Ingreso/Modificación Asientos | HU-CON-006 + HU-CON-007 |
| CN201: Modificación Masiva | (No planificado) |
| CN204: Crédito Fiscal | (Implícito) |
| CN805: Certificados de Retenciones | (No planificado explícitamente) |
| CN231: Anexos de Cuentas | (No planificado) |

#### Reportes Financieros / EEFF
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| CN712: Balance de Comprobación | HU-CON-015 |
| CN770: Balance General | HU-CON-020 (Estado de Situación Financiera) |
| CN771: Ganancias y Pérdidas por Función | HU-CON-021 (Estado de Resultados) |
| CN772: G&P por Naturaleza | HU-CON-021 (variante) |
| CN730: Libro Mayor | HU-CON-017 |
| CN718/CN724: Diario General | HU-CON-018 |
| (No existe) | HU-CON-022 (Estado de Flujos de Efectivo) |
| (No existe) | HU-CON-023 (Estado Cambios en Patrimonio) |
| CN713: Balance General (alternativo) | HU-CON-020 |
| CN714: Balance Mensualizado | (Variante avanzada) |

#### Procesos
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| CN944: Pre-Asientos de Almacén | (Implícito en integración) |
| CN964: Pre-Asientos de OS | (Implícito) |
| CN965: Devengados RRHH | (Implícito) |
| CN903: Ajustes por Conversión | HU-CON-026 (Ajustes automáticos) |
| CN981: Ajuste Diferencia de Cambio | HU-CON-026 |
| CN984: Ajuste por Redondeo | HU-CON-026 |
| CN945: Clonación de Asientos | HU-CON-027 |
| CN901: Importación Pre-Asientos → Asientos | HU-CON-028 (Importación de asientos) |
| CN970: Cierre Anual | HU-CON-030 |
| CN971: Apertura del Ejercicio | HU-CON-030 (parte del cierre anual) |
| CN773: Libros Electrónicos SUNAT | HU-CON-024 |
| CN907: Mayorización de Cuentas | (Implícito) |
| CN962: Mayorización de CECO | (Implícito) |

### 5.2 Análisis Comparativo - Contabilidad

| Aspecto | SIGRE | Restaurant.pe | Diferencia |
|---------|-------|---------------|------------|
| **Plan de Cuentas** | Con mapeo SUNAT | Con jerarquía | Equivalente |
| **Asientos** | Individual + masivo | Individual + modificación + workflow | R.pe con workflow aprobación |
| **EEFF** | Balance, G&P (func/nat) | Balance, Resultados, Flujos, Patrimonio | **R.pe más completo (4 EEFF)** |
| **Libros Electrónicos** | PLE/SIRE SUNAT | PLE/SIRE multipaís | R.pe más amplio (DIAN, SII) |
| **Ajustes** | 4 tipos | 3 tipos agrupados | Equivalente |
| **Cierre** | Anual + apertura | Mensual + anual | Equivalente |
| **GxC (Gastos por Campo)** | 28 ventanas | No aplica | Sectorial (azucarera) |
| **Consistencia** | 5 reportes de validación | HU-CON-012 a HU-CON-014 | Equivalente |
| **Validación pre-asientos** | Integrado | HU-CON-013, HU-CON-025 | Equivalente |
| **Autorización modificaciones** | No tiene workflow | HU-CON-033 | **Innovación R.pe** |
| **Pre-asientos detallados** | Integrado | HU-CON-032 | Equivalente |

**Conclusión:** Restaurant.pe **mejora** la contabilidad de SIGRE con: workflow de autorización de modificaciones (HU-CON-033), Estados Financieros completos (4 EEFF vs 2 en SIGRE), soporte multipaís para libros electrónicos, y eliminación de funciones sectoriales innecesarias (GxC, talleres).

---

## 6. MÓDULO DE ACTIVOS FIJOS

### 6.1 Comparación Directa

| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| Clases de Activos | HU-AF-TAB-003 (Estructura jerárquica) |
| Sub-Clases | HU-AF-TAB-003 |
| Ubicaciones Físicas | HU-AF-TAB-005 |
| Tipos de Seguros | HU-AF-TAB-002 |
| Aseguradoras | HU-AF-TAB-001 |
| Parámetros Generales | HU-AF-TAB-006 |
| Numeración de Activos | HU-AF-TAB-007 |
| Cuentas por Tipo | HU-AF-TAB-004 |
| Registro de Activo Fijo | HU-AF-OPE-001 |
| Traslado de Activos | HU-AF-OPE-002 + HU-AF-OPE-003 (con workflow) |
| Revaluación | HU-AF-OPE-007 |
| Mejoras/Re-potenciamiento | HU-AF-OPE-004 |
| Seguros de Activos | HU-AF-OPE-005 |
| Baja de Activos | HU-AF-OPE-006 |
| Venta de Activos | HU-AF-OPE-006 (incluido en baja) |
| Depreciación Mensual | HU-AF-PRO-001 |
| Asientos de Depreciación | HU-AF-PRO-002 |
| Asientos de Revaluación | HU-AF-PRO-003 |
| (No existe) | HU-AF-PRO-004 (Ajustes por inflación NIC 29) |
| (No existe) | HU-AF-PRO-005 (Devengamiento primas seguros) |
| (No existe) | HU-AF-PRO-006 (Workflow de siniestros) |
| (No existe) | HU-AF-001, HU-AF-002 (Tipos operaciones/incidencias) |
| (No existe) | HU-AF-TAB-008 (Numeración docs traslado) |
| (No existe) | HU-AF-OPE-008 (Config tasas/métodos deprec.) |
| Listado General | HU-AF-REP-001 |
| Detalle Depreciación | HU-AF-REP-002 |
| Reportes Consolidados | HU-AF-REP-003 |

### 6.2 Análisis Comparativo - Activos Fijos

| Aspecto | SIGRE | Restaurant.pe | Diferencia |
|---------|-------|---------------|------------|
| **Maestros** | 8 pantallas | 10 HUs | **R.pe más completo** |
| **Operaciones** | 5 pantallas | 8 HUs | **R.pe más completo** |
| **Depreciación** | Cálculo + asiento | Cálculo + asiento + config tasas | **R.pe más flexible** |
| **Seguros** | Registro básico | Pólizas + devengamiento + siniestros | **R.pe mucho más completo** |
| **Ajuste Inflación** | No existe | HU-AF-PRO-004 (NIC 29) | **Innovación R.pe** |
| **Workflow Traslados** | Aprobación simple | Aprobación masiva/individual | **R.pe mejorado** |
| **Reportes** | 3 reportes | 3 HUs (equivalentes) | Equivalente |

**Conclusión:** Restaurant.pe **supera significativamente** a SIGRE en Activos Fijos. Incluye NIC 29 (ajuste por inflación), gestión integral de seguros con siniestros, workflow de aprobación mejorado y configuración flexible de métodos de depreciación.

---

## 7. MÓDULO DE RECURSOS HUMANOS

### 7.1 SIGRE - Funcionalidades del Módulo RRHH

El módulo `ws_objects/Rrhh/` contiene **309 ventanas**, **19 funciones**, **10 objetos de usuario** y **939 DataWindows** — el módulo más grande en reportes.

### 7.2 Comparación por Sub-proceso

#### Maestros y Configuración
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| RH030: Datos Generales del Trabajador | HU-RRHH-MP-FE-001 (Ficha empleado) |
| RH012: Tipos de Trabajadores | HU-RRHH-MP-CL-001 (Categorías laborales) |
| RH017: Cargos/Ocupaciones | HU-RRHH-MP-CL-002 (Catálogo cargos y bandas) |
| RH032: Áreas y Secciones | HU-RRHH-MP-EO-001 (Áreas y jerarquías) |
| RH033: Administradoras AFP | HU-RRHH-MP-AS-001 (Afiliación fondos) |
| RH001: Calendario Feriados | HU-RRHH-AJ-CL-001 (Feriados y turnos) |
| RH100: Remuneración Mínima | HU-RRHH-CONF-PAR-002 |
| RH036: Impuestos Renta 5ta | HU-RRHH-CONF-PAR-003 (Reglas impuestos) |
| RH010: Parámetros de Control | HU-RRHH-CONF-PAR-001 (Frecuencia y calendarios) |
| RH031: Conceptos de Planillas | HU-RRHH-PN-CP-001 (Conceptos fijos) |
| (No existe) | HU-RRHH-CONF-PG-001 (Provisiones gastos planilla) |
| (No existe) | HU-RRHH-CONF-GC-001 (Agrupación trabajadores) |
| (No existe) | HU-RRHH-CONF-NUM-001 (Numeración docs RRHH) |
| RH029: Activar/Desactivar trabajador | HU-RRHH-MP-FE-002 (Contratos, cambios) |

#### Asistencia y Control
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| RH123: Control de Inasistencias | HU-RRHH-AJ-AS-001 (Marcaciones POS/Bio/App GPS) |
| RH079: Tarjetas de Proximidad | HU-RRHH-AJ-AS-001 (Biométrico) |
| (No existe) | HU-RRHH-AJ-HR-001 (Horas extra automáticas) |
| RH234-RH236: Boletas de Permiso + Aprobación | HU-RRHH-AJ-PM-001 (Flujo digital permisos) |
| RH202: Vacaciones por Trabajador | HU-RRHH-AJ-VL-001 (Vacaciones/licencias/subsidios) |

#### Cálculo de Nómina
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| RH110: Ganancias/Descuentos Fijos | HU-RRHH-PN-CP-001 (Conceptos fijos) |
| RH125/RH201: Variables (individual/masivo) | HU-RRHH-PN-CP-002 (Carga masiva variables) |
| RH411: Cálculo de Planilla | (Implícito - proceso core) |
| RH410: Adelanto de Quincena | (Implícito en conceptos) |
| RH101: Cuenta Corriente | HU-RRHH-NOM-CC-001 (Adelantos y préstamos) |
| RH112: Montos 5ta Categoría | HU-RRHH-NOM-AR-001 (Impuestos y contribuciones) |
| RH115: Descuentos Judiciales | (Implícito en conceptos) |
| (No existe) | HU-RRHH-PN-CP-003 (Distribución de propinas) |
| (No existe) | HU-RRH-NOM-CP-007 (Recargo al consumo) |

#### Beneficios Legales
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| RH420-RH422: CTS (cálculo/acumulado/intereses) | HU-RRH-NOM-PE-001 (Procesos masivos) |
| RH440-RH441: Gratificaciones | HU-RRH-NOM-PE-001 |
| RH415: Liquidaciones | HU-RRHH-NOM-LIQ-001 |
| RH514/RH900: Asientos Contables Planilla | HU-RRHH-NOM-PROV-001 |

#### Reportes y Compliance
| Función SIGRE | Equivalente Restaurant.pe |
|---------------|--------------------------|
| RH334/RH735: Boletas de Pago | HU-RRH-RA-ES-001 (Boletas/recibos) |
| RH905: Envío Boletas por Email | HU-RRH-RA-ES-001 |
| RH335/RH385: Planilla Calculada | HU-RRH-RA-ES-001 |
| RH705-RH715: PLAME/RTPS (12 reportes) | HU-RRH-RA-AR-001 (Archivos regulatorios) |
| RH723-RH724: AFPNet | HU-RRH-RA-AR-001 |
| RH462: Telecrédito | (Implícito en pagos) |
| (No existe) | HU-RRH-RA-AV-001 (KPIs rotación/ausentismo) |
| (No existe) | HU-RRH-RA-DB-001 (Dashboard indicadores) |
| (No existe) | HU-RRH-RA-ES-002 (Distribución costos CECO) |

#### Reclutamiento y Talento (NO EXISTE en SIGRE)
| Restaurant.pe |
|---------------|
| HU-RRHH-RO-RS-001 (Reclutamiento y selección) |
| HU-RRHH-RO-CT-001 (Contratos con firma digital) |
| HU-RRHH-OD-CT-002 (Onboarding) |
| HU-RRH-TD-ED-001 (Evaluaciones 90°/180°/360°) |
| HU-RRH-TD-CAP-001 (Gestión de cursos) |
| HU-RRH-TD-CL-001 (Encuestas clima laboral) |
| HU-RRH-TD-PC-001 (Planes de carrera) |

### 7.3 Análisis Comparativo - RRHH

| Aspecto | SIGRE | Restaurant.pe | Diferencia |
|---------|-------|---------------|------------|
| **Ficha Empleado** | Completa (Perú) | Completa (multipaís) | R.pe más amplio |
| **Asistencia** | Tarjetas proximidad + manual | POS/Biométrico/App/GPS | **R.pe mucho más moderno** |
| **Nómina** | Cálculo completo Perú | Multipaís + propinas/recargo | **R.pe innovador para restaurantes** |
| **CTS/Gratificaciones** | Módulos especializados | Procesos masivos genéricos | SIGRE más detallado Perú |
| **Liquidaciones** | Módulo completo | HU completa | Equivalente |
| **PLAME/RTPS** | 12 reportes individuales | Generación por país | R.pe más flexible |
| **Reclutamiento** | **No existe** | 3 HUs completas | **Innovación total R.pe** |
| **Talento** | Compensación Variable (10 pantallas) | Evaluaciones + cursos + clima + carrera | **R.pe mucho más moderno** |
| **Propinas/Recargo** | **No existe** | 2 HUs dedicadas | **Innovación sector gastronómico** |
| **Dashboard KPIs** | **No existe** | HU dedicada | **Innovación R.pe** |
| **Firma Digital** | **No existe** | DocuSign/Adobe Sign | **Innovación R.pe** |

**Conclusión:** Restaurant.pe **moderniza radicalmente** el RRHH de SIGRE. Agrega reclutamiento completo, gestión de talento (evaluaciones 360°, capacitación, clima laboral, carrera), asistencia por app con GPS, distribución de propinas, firma digital, dashboards de KPIs, y soporte multipaís. SIGRE es más detallado en compliance peruano específico (CTS, gratificaciones, PLAME).

---

## 8. MÓDULO DE PRODUCCIÓN

### 8.1 SIGRE - Funcionalidades del Módulo Producción

El módulo `ws_objects/Produccion/` contiene **215 ventanas**, **25 funciones** y **11 objetos de usuario**, orientado a producción industrial (pesquera/agroindustrial).

#### Procesos SIGRE vs Restaurant.pe
| Proceso SIGRE | Restaurant.pe |
|---------------|---------------|
| Partes de Piso (producción diaria) | Producción por recetas |
| Destajo (pago por pieza) | No aplica (restaurantes) |
| Jornal (pago diario campo) | No aplica |
| Envasado/Enlatado/Empaque | Preparación de platos |
| Control de Calidad MP | Control de calidad ingredientes |
| Energía y Consumos | No aplica directamente |
| Órdenes de Trabajo Producción | Órdenes de producción |
| Costeo por Centro de Costo | Costeo por receta |
| Consolidación de Costos | Costeo de producción |
| Programas de Producción | Planificación de menú |
| Certificados de Calidad | No aplica |
| Etiquetado | No aplica (industrial) |

### 8.2 Análisis Comparativo - Producción

| Aspecto | SIGRE | Restaurant.pe | Diferencia |
|---------|-------|---------------|------------|
| **Enfoque** | Industrial (pesca/agro) | Gastronómico (recetas/platos) | **Completamente diferente** |
| **Recetas** | Fórmulas/BOM industrial | Recetas culinarias | Conceptualmente similar |
| **Costeo** | Por OT/centro de costo | Por receta/plato | Adaptado al sector |
| **Control Calidad** | MP industrial | Ingredientes/frescura | Adaptado |
| **Destajo/Jornal** | Módulo completo | No aplica | Sectorial |
| **Energía** | Consumo/distribución | No aplica | Sectorial |

**Conclusión:** Aunque los conceptos son similares (programación, producción, costeo, calidad), la implementación es completamente diferente. El knowhow transferible es el **modelo conceptual**: BOM→Recetas, OT→Orden de producción, Costeo por CC→Costeo por receta.

---

## 9. MÓDULOS EXCLUSIVOS DE SIGRE (No aplican a Restaurant.pe)

| Módulo SIGRE | Objetos | Propósito | ¿Aplica a Restaurant.pe? |
|-------------|:-------:|-----------|:------------------------:|
| **Aprovision** | 215 | Aprovisionamiento de materia prima (pesca) | No |
| **Flota** | 305 | Gestión de flota pesquera | No |
| **Presupuesto** | 597 | Presupuesto y control | Parcial (como extensión futura) |
| **Operaciones_ot** | ~200 | Órdenes de trabajo industriales | No (concepto adaptado) |
| **Mantenimiento** | ~150 | Mantenimiento de maquinaria | No |
| **Control_Calidad** | ~50 | Control de calidad industrial | No (concepto adaptado) |
| **Importacion** | ~100 | Comercio exterior | No |
| **GxC (Gastos por Campo)** | 28 ventanas | Costos agrícolas | No |

---

## 10. FUNCIONALIDADES EXCLUSIVAS DE RESTAURANT.PE (No existen en SIGRE)

| Funcionalidad | Módulo | Importancia |
|--------------|--------|:-----------:|
| **Multipaís** (Perú, Colombia, Chile, RD, México) | Transversal | Alta |
| **Conciliación con pasarelas digitales** (Niubiz, Yape, Plin) | Finanzas | Alta |
| **Conciliación ventas ecommerce** | Finanzas | Alta |
| **Distribución de propinas** | RRHH | Alta (sector gastronómico) |
| **Distribución recargo al consumo** | RRHH | Alta (sector gastronómico) |
| **Reclutamiento y selección** | RRHH | Media |
| **Evaluaciones 360°** | RRHH | Media |
| **Gestión de cursos/capacitación** | RRHH | Media |
| **Encuestas de clima laboral** | RRHH | Media |
| **Planes de carrera y sucesión** | RRHH | Media |
| **Firma digital de contratos** | RRHH | Media |
| **Marcación por POS/App con GPS** | RRHH | Alta |
| **Dashboard KPIs RRHH** | RRHH | Media |
| **Ajuste por inflación NIC 29** | Activos Fijos | Media |
| **Workflow de siniestros** | Activos Fijos | Baja |
| **Devengamiento de seguros** | Activos Fijos | Media |
| **Facturación de regalías a franquicias** | Ventas | Alta |
| **Estado de Flujos de Efectivo** (EEFF) | Contabilidad | Media |
| **Estado Cambios en Patrimonio** (EEFF) | Contabilidad | Media |
| **Workflow autorización modificación asientos** | Contabilidad | Media |
| **Fondo fijo por punto de venta** | Finanzas | Alta |
| **Pago directo a ente tributario** | Finanzas | Media |

---

## 11. MAPA DE TRANSFERENCIA DE CONOCIMIENTO

### Conocimiento directamente transferible de SIGRE → Restaurant.pe

```
┌─────────────────────────────────────────────────────────────────────┐
│                    TRANSFERENCIA DIRECTA (Alta)                     │
├─────────────────────────────────────────────────────────────────────┤
│  Almacén: Modelo de kardex, valorización, tipos de movimiento      │
│  Compras: Flujo OC → Recepción → Facturación → CxP               │
│  Finanzas: Tesorería, CxC, CxP, conciliación bancaria             │
│  Contabilidad: Plan contable, asientos, mayorización, cierre       │
│  RRHH: Cálculo de planilla, CTS, gratificaciones, PLAME           │
│  Activos Fijos: Registro, depreciación, traslados                  │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│              TRANSFERENCIA CONCEPTUAL (Media)                       │
├─────────────────────────────────────────────────────────────────────┤
│  Producción: BOM → Recetas, OT → Orden de producción              │
│  Presupuesto: Modelo de control presupuestal (futuro)              │
│  Seguridad: RBAC → Roles y permisos (ya implementado)             │
│  Auditoría: Logs de cambios → Audit trail (cross-cutting)         │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────┐
│              NO TRANSFERIBLE (Sectorial)                            │
├─────────────────────────────────────────────────────────────────────┤
│  Aprovision: Específico pesca                                      │
│  Flota: Específico pesca                                           │
│  GxC: Específico azucarera                                         │
│  Importación/Exportación: No aplica restaurantes                   │
│  Destajo/Jornal: Específico industrial                             │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 12. CONCLUSIONES

### 12.1 Fortalezas del enfoque Restaurant.pe
1. **Modernización tecnológica**: Reemplaza un ERP de 15+ años con arquitectura moderna
2. **Foco sectorial**: Elimina funciones industriales innecesarias y agrega las propias del sector gastronómico (propinas, recargo al consumo, franquicias)
3. **Multipaís nativo**: SIGRE es Perú-only; R.pe soporta 5 países
4. **Digital-first**: Conciliación con pasarelas de pago, firma digital, app con GPS, dashboards
5. **Gestión de talento**: SIGRE no tiene reclutamiento ni evaluaciones; R.pe incluye módulo completo
6. **Normas internacionales**: NIC 29, 4 estados financieros completos, libros electrónicos multipaís

### 12.2 Knowhow de SIGRE aprovechable
1. **Lógica de negocio probada**: 104 funciones de Finanzas, 939 DataWindows de RRHH representan reglas de negocio validadas en producción
2. **Compliance peruano maduro**: PLAME, detracciones, retenciones, PLE/SIRE
3. **Modelo de datos robusto**: Estructura de tablas, relaciones y numeradores consolidada
4. **Flujos de aprobación**: Patrones de workflow probados en OC, OS, OV, adelantos
5. **Integración contable**: Modelo de pre-asientos → asientos bien diseñado

### 12.3 Gaps identificados en Restaurant.pe
1. **Cotizaciones**: No incluido (evaluación necesaria para compras grandes)
2. **Presupuesto**: No planificado como módulo (útil para cadenas de restaurantes)
3. **Vendedores/Comisiones**: No planificado (relevante para franquicias)
4. **Guías de Remisión**: No incluido en almacén
5. **Reservas de Stock**: No planificado
6. **Líneas de Crédito**: No planificado para clientes B2B

### 12.4 Números finales

| Métrica | SIGRE | Restaurant.pe |
|---------|:-----:|:-------------:|
| **Módulos** | 45 | 9 |
| **Objetos totales** | 10,512 | ~204 HUs |
| **Opciones de menú** | ~1,000+ | ~280 funcionalidades |
| **Funciones de negocio** | ~300 | (por definir) |
| **Años de desarrollo** | 15+ | En diseño |
| **Países soportados** | 1 (Perú) | 5 |
| **Sectores** | Industrial (pesca/agro/azúcar) | Gastronomía |

> **Resumen:** Restaurant.pe no es una réplica de SIGRE, sino una **reimaginación** del ERP para el sector gastronómico, que toma el conocimiento conceptual y las reglas de negocio validadas de SIGRE, las moderniza tecnológicamente, las adapta al sector y las extiende con funcionalidades que SIGRE nunca tuvo (multipaís, digital payments, talento humano, franquicias).
