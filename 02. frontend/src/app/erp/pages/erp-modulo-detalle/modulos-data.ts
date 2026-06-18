export interface SeccionModulo {
  titulo: string;
  opciones: string[];
}

export interface ModuloCompleto {
  codigo: string;
  nombre: string;
  icono: string;
  color: string;
  slogan: string;
  descripcion: string;
  secciones: SeccionModulo[];
  diagramaMermaid: string;
  beneficios: string[];
}

export const MODULOS_INFO: ModuloCompleto[] = [
  {
    codigo: 'ALMACEN',
    nombre: 'Almacén',
    icono: 'assets/imagenes/modulos/almacen.svg',
    color: '#2E7D32',
    slogan: 'Control total de inventarios en tiempo real',
    descripcion: 'Gestión integral de almacenes, inventarios y logística interna. Permite el control de múltiples almacenes, movimientos de entrada/salida, kardex valorizado, tomas de inventario y trazabilidad completa de productos.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Maestro de almacenes', 'Tipos de movimiento', 'Motivos de traslado', 'Unidades de conversión', 'Posiciones por almacén', 'Ubicación de artículos', 'Parámetros del sistema', 'Numeradores'] },
      { titulo: 'Operaciones', opciones: ['Movimiento de almacén', 'Orden de traslado', 'Aprobación de traslado', 'Guías de remisión', 'Despacho simplificado', 'Toma de inventario por conteo', 'Ingreso de lotes', 'Devoluciones y préstamos', 'Solicitud de pedido'] },
      { titulo: 'Consultas', opciones: ['Kardex / Movimiento de inventario', 'Consulta de productos', 'Stock por almacén', 'Movimientos en tránsito', 'Órdenes de compra pendientes'] },
      { titulo: 'Reportes', opciones: ['Stock a la fecha', 'Valorización de inventario', 'Historial de movimientos', 'Stock mínimo', 'Diagnóstico de almacenes', 'Productos vendidos por periodo'] },
      { titulo: 'Procesos', opciones: ['Recálculo de precios promedio', 'Cuadre de stock', 'Actualización automática', 'Cierre de periodo'] },
    ],
    diagramaMermaid: `graph LR
    A[Recepción] --> B[Almacenamiento]
    B --> C[Picking / Despacho]
    C --> D[Guía de Remisión]
    B --> E[Toma de Inventario]
    E --> F[Ajustes]
    F --> B
    B --> G[Kardex Valorizado]`,
    beneficios: ['Trazabilidad completa de cada unidad', 'Múltiples almacenes y posiciones', 'Integración automática con Compras y Producción', 'Kardex valorizado en tiempo real'],
  },
  {
    codigo: 'COMPRAS',
    nombre: 'Compras',
    icono: 'assets/imagenes/modulos/compras.svg',
    color: '#1565C0',
    slogan: 'Adquisiciones inteligentes y controladas',
    descripcion: 'Ciclo completo de compras: desde el requerimiento hasta la recepción y registro contable. Control de proveedores, aprobaciones multinivel, órdenes de compra y servicio con trazabilidad total.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Gestión de proveedores', 'Condiciones de pago', 'Categorías de compra', 'Monedas y tipo de cambio'] },
      { titulo: 'Operaciones', opciones: ['Aprovisionamiento', 'Generar orden de compra', 'Aprobar orden de compra', 'Generar orden de servicio', 'Aprobar orden de servicio', 'Registro de comprobantes', 'Notas de crédito/débito', 'Facturas de gastos'] },
      { titulo: 'Reportes', opciones: ['Reporte de compras', 'Compras en tránsito', 'Compras por ingresar', 'Análisis de proveedores', 'Compras por categoría', 'Gestión de compras', 'Compras sugeridas'] },
    ],
    diagramaMermaid: `graph LR
    A[Requerimiento] --> B[Cotización]
    B --> C[Orden de Compra]
    C --> D{Aprobación}
    D -->|Aprobado| E[Recepción]
    D -->|Rechazado| B
    E --> F[Registro Contable]
    F --> G[Pago]`,
    beneficios: ['Flujo de aprobaciones multinivel', 'Control presupuestal integrado', 'Evaluación automática de proveedores', 'Trazabilidad desde requerimiento hasta pago'],
  },
  {
    codigo: 'COMERCIALIZACION',
    nombre: 'Comercialización',
    icono: 'assets/imagenes/modulos/ventas.svg',
    color: '#E65100',
    slogan: 'Impulsa tus ventas con gestión comercial integral',
    descripcion: 'Gestión comercial completa: órdenes de venta, facturación electrónica, exportaciones, control de embarques, comisiones de vendedores y análisis de rentabilidad por canal.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Incoterms', 'Factores de embarque', 'Artículos de venta', 'Canales de distribución', 'Zonas comerciales', 'Vendedores y cuotas', 'Comisiones', 'Puntos de venta', 'Precios referenciales'] },
      { titulo: 'Operaciones', opciones: ['Orden de venta', 'Aprobación de órdenes', 'Embarque y lotes', 'Facturación de exportación', 'Facturación simplificada (POS)', 'Notas de crédito/débito', 'Planilla de cobranza', 'Liquidación semanal'] },
      { titulo: 'Reportes', opciones: ['Reporte tributario por periodo', 'Reporte de ventas', 'Panel de reenvío electrónico', 'Estados de documentos SUNAT', 'Análisis de rentabilidad'] },
    ],
    diagramaMermaid: `graph LR
    A[Orden de Venta] --> B{Aprobación}
    B -->|Aprobado| C[Despacho]
    C --> D[Facturación]
    D --> E[Envío SUNAT]
    E --> F[Cobranza]
    D --> G[Nota de Crédito]`,
    beneficios: ['Facturación electrónica SUNAT integrada', 'Multi-canal: exportación, local, POS', 'Comisiones automáticas por vendedor', 'Control de embarques y logística'],
  },
  {
    codigo: 'FINANZAS',
    nombre: 'Finanzas',
    icono: 'assets/imagenes/modulos/finanzas.svg',
    color: '#6A1B9A',
    slogan: 'Visibilidad financiera y control de tesorería',
    descripcion: 'Tesorería integral: flujo de caja, cuentas por pagar y cobrar, conciliaciones bancarias, pagos masivos, adelantos, fondos fijos y proyección financiera.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Documentos financieros', 'Conceptos financieros', 'Grupos y códigos de flujos de caja'] },
      { titulo: 'Operaciones', opciones: ['Canje de documentos', 'Documentos por proveedor', 'Aplicación de pagos', 'Letras de cambio', 'Registro de facturas otros ingresos', 'Documentos por cliente'] },
      { titulo: 'Consultas', opciones: ['Saldos de caja y bancos', 'Flujo de caja', 'Documentos financieros'] },
      { titulo: 'Adelantos', opciones: ['Órdenes de giro', 'Aprobación de giro', 'Rendición de gastos', 'Aprobación de rendición', 'Cierre de liquidación'] },
      { titulo: 'Tesorería', opciones: ['Carteras de cobro', 'Cartera de pagos', 'Pagos masivos', 'Anulación/reversión de pagos', 'Movimiento entre cuentas', 'Programación de pagos', 'Pago a ente tributario', 'Detracciones/Retenciones', 'Fondo fijo', 'Caja chica', 'Egresos menores', 'Proyección ingresos/egresos', 'Ingresos del día'] },
      { titulo: 'Conciliaciones', opciones: ['Cruce de extracto bancario', 'Cruce de pasarela', 'Conciliaciones bancarias'] },
      { titulo: 'Reportes', opciones: ['Cuentas por pagar', 'Tesorería', 'Documentos y clientes', 'Obligaciones por vencer', 'Reportes financieros'] },
    ],
    diagramaMermaid: `graph TD
    A[Documentos por Pagar] --> B[Programación de Pagos]
    B --> C{Aprobación}
    C -->|Aprobado| D[Ejecución de Pago]
    D --> E[Conciliación Bancaria]
    F[Documentos por Cobrar] --> G[Cartera de Cobros]
    G --> H[Ingreso de Cobro]
    H --> E`,
    beneficios: ['Flujo de caja proyectado en tiempo real', 'Conciliación bancaria automatizada', 'Pagos masivos con archivos bancarios', 'Control de adelantos y rendiciones'],
  },
  {
    codigo: 'CONTABILIDAD',
    nombre: 'Contabilidad',
    icono: 'assets/imagenes/modulos/contabilidad.svg',
    color: '#00695C',
    slogan: 'Contabilidad precisa y reportes al instante',
    descripcion: 'Plan contable dinámico, asientos manuales y automáticos, libros electrónicos SUNAT, reportes financieros, centros de costo y procesos de cierre contable mensual y anual.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Plan contable', 'Centros de costo', 'Monedas y tipo de cambio', 'Libros contables', 'Matriz contable de operaciones', 'Detracciones/Retenciones', 'Impuestos', 'Cuentas vs subcategorías', 'Valor tributario (UIT)'] },
      { titulo: 'Operaciones', opciones: ['Asientos manuales', 'Asientos automáticos', 'Ajustes y reclasificación', 'Seguimientos contables', 'Clonación de asientos'] },
      { titulo: 'Consultas', opciones: ['Saldos de cuentas corrientes', 'Centros de costo', 'Documentos pendientes de cuenta corriente'] },
      { titulo: 'Reportes', opciones: ['Maestros contables', 'Reportes de validación', 'Libros y asientos', 'Reportes financieros', 'Análisis de cuenta contable'] },
      { titulo: 'Procesos', opciones: ['Consistencia de asientos', 'Ajustes contables', 'Clonación de asientos', 'Cierre contable mensual', 'Cierre del ejercicio'] },
    ],
    diagramaMermaid: `graph TD
    A[Documentos Fuente] --> B[Asiento Automático]
    C[Registro Manual] --> D[Asiento Manual]
    B --> E[Libro Diario]
    D --> E
    E --> F[Mayor General]
    F --> G[Balance de Comprobación]
    G --> H[Estados Financieros]
    G --> I[Libros Electrónicos SUNAT]`,
    beneficios: ['Libros electrónicos PLE-SUNAT automáticos', 'Multi-moneda con diferencia de cambio automática', 'Centros de costo ilimitados', 'Cierre contable controlado por periodos'],
  },
  {
    codigo: 'ACTIVOS_FIJOS',
    nombre: 'Activos Fijos',
    icono: 'assets/imagenes/modulos/activos-fijos.svg',
    color: '#BF360C',
    slogan: 'Patrimonio bajo control total',
    descripcion: 'Control patrimonial completo: registro, clasificación, depreciación tributaria y financiera, traslados, bajas, pólizas de seguro y generación automática de asientos contables.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Clasificación de activos', 'Matrices contables', 'Ubicación de activos', 'Aseguradoras', 'Seguros', 'Parámetros de operaciones', 'Numeración de activos', 'Numeración de traslados'] },
      { titulo: 'Operaciones', opciones: ['Registro de activos', 'Registro de traslado', 'Aprobación de traslado', 'Recepción de traslados', 'Operaciones especiales', 'Pólizas de seguro', 'Asignación de ratios', 'Baja de activos'] },
      { titulo: 'Reportes', opciones: ['Resumen de activo fijo', 'Depreciación anual por activo', 'Resumen por rangos'] },
      { titulo: 'Procesos', opciones: ['Cálculo de depreciación', 'Asientos de depreciación', 'Asientos de revaluación', 'Asientos de indexación', 'Devengo de aseguradoras', 'Asientos de siniestro'] },
    ],
    diagramaMermaid: `graph LR
    A[Alta de Activo] --> B[Asignación]
    B --> C[Depreciación Mensual]
    C --> D[Asiento Contable]
    B --> E[Traslado]
    E --> F{Aprobación}
    F -->|Aprobado| G[Recepción]
    B --> H[Baja / Venta]`,
    beneficios: ['Depreciación tributaria y financiera simultánea', 'Control de ubicación y responsable', 'Pólizas de seguro vinculadas', 'Generación automática de asientos'],
  },
  {
    codigo: 'RRHH',
    nombre: 'RR.HH.',
    icono: 'assets/imagenes/modulos/rrhh.svg',
    color: '#283593',
    slogan: 'Gestión de talento humano y nómina integrada',
    descripcion: 'Gestión completa del ciclo de vida del trabajador: desde el ingreso hasta la liquidación. Incluye planillas, asistencia, vacaciones, AFP, impuesto a la renta, boletas electrónicas y reportes regulatorios.',
    secciones: [
      { titulo: 'Maestros de personal', opciones: ['Mantenimiento de personal', 'Categorías salariales', 'Cargos y ocupaciones', 'Áreas y secciones', 'Administradoras AFP', 'Tipo de trabajador', 'Profesiones y especialidades'] },
      { titulo: 'Asistencia y jornadas', opciones: ['Calendario de feriados', 'Control de asistencia', 'Horas extras', 'Permisos', 'Vacaciones y licencias', 'Aprobación de vacaciones'] },
      { titulo: 'Procesos de nómina', opciones: ['Conceptos de cálculo', 'Cálculo de planillas', 'Aprobación de planilla', 'Liquidación de beneficios', 'Participación por utilidades', 'Gratificaciones', 'CTS'] },
      { titulo: 'Reportes', opciones: ['Boletas de pago', 'Planilla detallada', 'PLAME-SUNAT', 'AFP Net', 'Distribución de costos', 'Indicadores de rotación'] },
      { titulo: 'Parámetros', opciones: ['Impuesto a la renta 5ta', 'Remuneración mínima', 'Parámetros de procesos', 'Frecuencia de pago', 'Tipo de contrato'] },
    ],
    diagramaMermaid: `graph TD
    A[Ingreso Trabajador] --> B[Configuración Planilla]
    B --> C[Asistencia Mensual]
    C --> D[Cálculo de Planilla]
    D --> E{Aprobación}
    E -->|Aprobado| F[Boletas de Pago]
    F --> G[Asiento Contable]
    E -->|Aprobado| H[Archivos AFP/SUNAT]
    I[Cese] --> J[Liquidación]
    J --> G`,
    beneficios: ['PLAME y T-Registro automatizados', 'Multi-frecuencia: semanal, quincenal, mensual', 'Cálculo automático de CTS, gratificación, vacaciones', 'Integración contable directa'],
  },
  {
    codigo: 'PRODUCCION',
    nombre: 'Producción',
    icono: 'assets/imagenes/modulos/produccion.svg',
    color: '#F57F17',
    slogan: 'Producción eficiente con costeo preciso',
    descripcion: 'Control de procesos productivos, centros de beneficio, partes de producción, costeo por proceso y asignación de gastos indirectos de fabricación. Incluye control de calidad y energía.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Plantas de producción', 'Centros de beneficio', 'Procesos de producción', 'Plantillas de costo', 'Objetos de medición', 'Atributos de medición', 'Estados del producto', 'Tareas de producción'] },
      { titulo: 'Operaciones', opciones: ['Parte de producción diario', 'Control de asistencia productiva', 'Incidencias', 'Formatos de medición', 'Órdenes de trabajo', 'Ingreso de energía', 'Costos de producción'] },
      { titulo: 'Procesos', opciones: ['Asignación de gastos indirectos', 'Costeo por centro de beneficio', 'Transferencia de costos', 'Cierre de producción'] },
    ],
    diagramaMermaid: `graph LR
    A[Materia Prima] --> B[Orden de Producción]
    B --> C[Proceso Productivo]
    C --> D[Control de Calidad]
    D --> E[Producto Terminado]
    F[Mano de Obra] --> C
    G[GIF] --> C
    E --> H[Almacén PT]`,
    beneficios: ['Costeo por proceso y centro de beneficio', 'Control de calidad integrado', 'Asignación de GIF automatizada', 'Trazabilidad de lote completa'],
  },
  {
    codigo: 'PRESUPUESTO',
    nombre: 'Presupuesto',
    icono: 'assets/imagenes/modulos/presupuesto.svg',
    color: '#2E7D32',
    slogan: 'Planificación y control presupuestario',
    descripcion: 'Formulación presupuestal por centros de costo y partidas. Control de ejecución, variaciones, solicitudes de modificación con aprobaciones y reportes de avance.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Cuentas presupuestales', 'Plantillas presupuestales', 'Grupos de partidas', 'Roles presupuestarios', 'Parámetros'] },
      { titulo: 'Operaciones', opciones: ['Presupuesto de ingresos', 'Presupuesto de producción', 'Presupuesto inicial por partida', 'Variaciones presupuestales', 'Solicitud de variación', 'Aprobación de variaciones'] },
      { titulo: 'Reportes', opciones: ['Variación mensual', 'Ejecución vs presupuesto', 'Gráficas de variación', 'Detalle presupuestal'] },
    ],
    diagramaMermaid: `graph TD
    A[Formulación] --> B[Presupuesto Aprobado]
    B --> C[Ejecución]
    C --> D{¿Desviación?}
    D -->|Sí| E[Solicitud Variación]
    E --> F{Aprobación}
    F -->|Aprobado| G[Variación Aplicada]
    D -->|No| H[Seguimiento]`,
    beneficios: ['Control por centro de costo y partida', 'Alertas automáticas de desviación', 'Flujo de aprobación de variaciones', 'Integración con contabilidad'],
  },
  {
    codigo: 'FLOTA',
    nombre: 'Flota',
    icono: 'assets/imagenes/modulos/flota.svg',
    color: '#1565C0',
    slogan: 'Gestión eficiente de vehículos y embarcaciones',
    descripcion: 'Administración de flota vehicular y/o pesquera: control de combustible, mantenimiento preventivo, documentos, tripulación y costeo operativo por unidad.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Naves / Vehículos', 'Capitanías de puerto', 'Puertos', 'Plantillas presupuestales por nave', 'Tripulación'] },
      { titulo: 'Operaciones', opciones: ['Zarpe y arribo', 'Control de combustible', 'Captura de pesca', 'Planilla de flota', 'Resumen de planilla', 'Documentos de nave'] },
      { titulo: 'Reportes', opciones: ['Presupuesto de flota', 'Variaciones mensuales', 'Costos por unidad', 'Historial de mantenimiento'] },
    ],
    diagramaMermaid: `graph LR
    A[Zarpe] --> B[Operación]
    B --> C[Captura/Transporte]
    C --> D[Arribo]
    D --> E[Descarga]
    E --> F[Liquidación]
    B --> G[Combustible]
    B --> H[Mantenimiento]`,
    beneficios: ['Costeo por viaje/embarcación', 'Control de combustible en tiempo real', 'Mantenimiento preventivo programado', 'Integración con planillas de tripulación'],
  },
  {
    codigo: 'MANTENIMIENTO',
    nombre: 'Mantenimiento',
    icono: 'assets/imagenes/modulos/mantenimiento.svg',
    color: '#E65100',
    slogan: 'Disponibilidad máxima de equipos e infraestructura',
    descripcion: 'Planificación y ejecución de mantenimiento preventivo y correctivo. Gestión de órdenes de trabajo, repuestos, historial de equipos y análisis de costos.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Equipos e infraestructura', 'Repuestos', 'Técnicos y especialistas', 'Frecuencias de mantenimiento'] },
      { titulo: 'Operaciones', opciones: ['Órdenes de trabajo', 'Mantenimiento preventivo', 'Mantenimiento correctivo', 'Registro de mediciones', 'Paradas programadas'] },
      { titulo: 'Reportes', opciones: ['Historial de equipos', 'Costos de mantenimiento', 'Disponibilidad de equipos', 'Indicadores MTBF/MTTR'] },
    ],
    diagramaMermaid: `graph TD
    A[Plan Preventivo] --> B[Orden de Trabajo]
    C[Falla Detectada] --> B
    B --> D[Ejecución]
    D --> E[Registro de Actividades]
    E --> F[Cierre de OT]
    F --> G[Historial del Equipo]`,
    beneficios: ['Programa preventivo automatizado', 'Indicadores MTBF y MTTR', 'Control de costos por equipo', 'Historial completo de intervenciones'],
  },
  {
    codigo: 'AUDITORIA',
    nombre: 'Auditoría',
    icono: 'assets/imagenes/modulos/auditoria.svg',
    color: '#880E4F',
    slogan: 'Transparencia y cumplimiento garantizados',
    descripcion: 'Trazabilidad de todas las operaciones del sistema. Registro de hallazgos, acciones correctivas, control interno y reportes de cumplimiento.',
    secciones: [
      { titulo: 'Operaciones', opciones: ['Log de operaciones', 'Hallazgos de auditoría', 'Acciones correctivas', 'Seguimiento de observaciones'] },
      { titulo: 'Reportes', opciones: ['Trazabilidad de cambios', 'Reportes de cumplimiento', 'Estadísticas de acceso', 'Alertas de seguridad'] },
    ],
    diagramaMermaid: `graph LR
    A[Operación del Sistema] --> B[Log Automático]
    B --> C[Análisis]
    C --> D{¿Hallazgo?}
    D -->|Sí| E[Acción Correctiva]
    E --> F[Seguimiento]
    F --> G[Cierre]
    D -->|No| H[Archivo]`,
    beneficios: ['Registro automático de toda operación', 'Alertas de acciones inusuales', 'Trazabilidad completa por usuario', 'Cumplimiento normativo demostrable'],
  },
  {
    codigo: 'CAMPO',
    nombre: 'Campo',
    icono: 'assets/imagenes/modulos/campo.svg',
    color: '#2E7D32',
    slogan: 'Agricultura inteligente y trazable',
    descripcion: 'Gestión de operaciones agrícolas: planificación de siembras, control de labores de campo, cosecha, insumos y costeo por hectárea cultivada.',
    secciones: [
      { titulo: 'Operaciones', opciones: ['Labores de campo', 'Control de cultivos', 'Registro de cosecha', 'Aplicación de insumos', 'Planificación de siembra', 'Supervisión y pesado'] },
      { titulo: 'Reportes', opciones: ['Producción por hectárea', 'Costos por campo', 'Rendimiento de cultivos', 'Consumo de insumos'] },
    ],
    diagramaMermaid: `graph LR
    A[Planificación] --> B[Siembra]
    B --> C[Labores de Campo]
    C --> D[Cosecha]
    D --> E[Pesado y Clasificación]
    E --> F[Ingreso a Almacén]
    C --> G[Costeo por Hectárea]`,
    beneficios: ['Costeo por hectárea y cultivo', 'Control de rendimientos', 'Trazabilidad campo-almacén', 'Integración con producción'],
  },
  {
    codigo: 'COMEDOR',
    nombre: 'Comedor',
    icono: 'assets/imagenes/modulos/comedor.svg',
    color: '#F57F17',
    slogan: 'Alimentación eficiente para tu equipo',
    descripcion: 'Administración de servicios de alimentación: gestión de menús, control de raciones, costos de alimentación por trabajador y centro de costo.',
    secciones: [
      { titulo: 'Operaciones', opciones: ['Gestión de menús', 'Control de raciones', 'Registro de consumos', 'Planificación semanal'] },
      { titulo: 'Reportes', opciones: ['Costo por trabajador', 'Costo por centro de costo', 'Consumo diario', 'Análisis nutricional'] },
    ],
    diagramaMermaid: `graph LR
    A[Planificación Menú] --> B[Compra Insumos]
    B --> C[Preparación]
    C --> D[Servicio]
    D --> E[Registro Consumo]
    E --> F[Costeo por CC]`,
    beneficios: ['Costo de alimentación por trabajador', 'Distribución por centro de costo', 'Control de raciones diarias', 'Integración con compras y almacén'],
  },
  {
    codigo: 'SIG',
    nombre: 'SIG',
    icono: 'assets/imagenes/modulos/sig.svg',
    color: '#00695C',
    slogan: 'Información gerencial para decisiones acertadas',
    descripcion: 'Sistema de Información Gerencial: dashboards ejecutivos, indicadores clave de rendimiento (KPI), reportes consolidados multi-empresa y análisis de tendencias.',
    secciones: [
      { titulo: 'Dashboards', opciones: ['Panel ejecutivo', 'Indicadores financieros', 'Indicadores operativos', 'Indicadores de RRHH'] },
      { titulo: 'Reportes', opciones: ['Consolidados multi-empresa', 'Análisis de tendencias', 'Comparativos por periodo', 'Alertas gerenciales'] },
    ],
    diagramaMermaid: `graph TD
    A[Módulos Operativos] --> B[Data Warehouse]
    B --> C[Procesamiento KPI]
    C --> D[Dashboards]
    C --> E[Alertas]
    C --> F[Reportes Ejecutivos]`,
    beneficios: ['KPIs en tiempo real', 'Visión consolidada multi-empresa', 'Alertas automáticas por desviación', 'Reportes ejecutivos personalizados'],
  },
  {
    codigo: 'OPERACIONES',
    nombre: 'Operaciones',
    icono: 'assets/imagenes/modulos/operaciones.svg',
    color: '#283593',
    slogan: 'Coordinación operativa transversal',
    descripcion: 'Gestión de órdenes de trabajo transversales, coordinación entre módulos y seguimiento de procesos operativos que involucran múltiples áreas.',
    secciones: [
      { titulo: 'Operaciones', opciones: ['Órdenes de trabajo', 'Coordinación operativa', 'Seguimiento de procesos', 'Control de avance'] },
      { titulo: 'Reportes', opciones: ['Estado de órdenes', 'Eficiencia operativa', 'Indicadores de cumplimiento'] },
    ],
    diagramaMermaid: `graph LR
    A[Solicitud] --> B[Orden de Trabajo]
    B --> C[Asignación]
    C --> D[Ejecución]
    D --> E[Supervisión]
    E --> F[Cierre]`,
    beneficios: ['Visibilidad transversal de procesos', 'Coordinación multi-área', 'Seguimiento en tiempo real', 'Indicadores de eficiencia'],
  },
  {
    codigo: 'HORECA',
    nombre: 'HORECA',
    icono: 'assets/imagenes/modulos/horeca.svg',
    color: '#AD1457',
    slogan: 'Hospitalidad, gastronomía y eventos integrados',
    descripcion: 'Gestión hotelera, de restaurantes y catering: reservas, alojamiento de huéspedes, maestro de habitaciones, servicios de restaurante, eventos y facturación de servicios.',
    secciones: [
      { titulo: 'Tablas maestras', opciones: ['Maestro de cuartos/habitaciones', 'Tipos de habitación', 'Tarifas y temporadas', 'Servicios adicionales'] },
      { titulo: 'Operaciones', opciones: ['Reservas', 'Check-in', 'Alojamiento de huéspedes', 'Servicios de habitación', 'Check-out', 'Facturación hotelera', 'Eventos y catering'] },
      { titulo: 'Reportes', opciones: ['Ocupación por periodo', 'Ingresos por tipo', 'Estado de habitaciones', 'Historial de huéspedes'] },
    ],
    diagramaMermaid: `graph LR
    A[Reserva] --> B[Check-in]
    B --> C[Alojamiento]
    C --> D[Servicios]
    D --> E[Check-out]
    E --> F[Facturación]
    G[Evento/Catering] --> F`,
    beneficios: ['Gestión de disponibilidad en tiempo real', 'Tarifas dinámicas por temporada', 'Historial completo de huéspedes', 'Integración con facturación y cobranza'],
  },
  {
    codigo: 'SEGURIDAD',
    nombre: 'Configuración',
    icono: 'assets/imagenes/modulos/configuracion.svg',
    color: '#37474F',
    slogan: 'Administración centralizada y segura',
    descripcion: 'Módulo de administración del sistema: gestión de usuarios, roles, permisos granulares, empresas, sucursales, monedas, ejercicios contables y parámetros generales.',
    secciones: [
      { titulo: 'Localización', opciones: ['Retenciones', 'Monedas', 'Ejercicios y periodos', 'Cuentas bancarias', 'Canales de pago', 'Condiciones de pago', 'Usuarios'] },
      { titulo: 'Ajustes', opciones: ['Datos generales de la cuenta', 'Plantillas de notificación'] },
      { titulo: 'Compañías', opciones: ['Compañías, sucursales y transacciones'] },
    ],
    diagramaMermaid: `graph TD
    A[Super Admin] --> B[Empresas]
    B --> C[Sucursales]
    C --> D[Usuarios]
    D --> E[Roles]
    E --> F[Permisos por Opción]
    F --> G[Acciones Permitidas]`,
    beneficios: ['Permisos granulares por opción y acción', 'Multi-empresa / multi-sucursal', 'Auditoría de accesos', 'Configuración centralizada'],
  },
];
