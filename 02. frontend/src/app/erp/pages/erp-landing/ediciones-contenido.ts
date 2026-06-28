export interface EdicionContenido {
  perfil: string;
  idealPara: string;
  modulosDestacados: string[];
  funcionalidades: string[];
  modulosOpcionales?: string[];
  notaTecnica?: string;
}

export const EDICIONES_CONTENIDO: Record<string, EdicionContenido> = {
  MYPE: {
    perfil: 'Operación comercial esencial',
    idealPara: 'Microempresas, bodegas, distribuidores y negocios que venden y compran con control básico.',
    modulosDestacados: ['Almacén', 'Compras', 'Comercialización', 'Finanzas (básico)', 'Seguridad'],
    funcionalidades: [
      'Inventarios, kardex, vales y traslados entre almacenes.',
      'Órdenes de compra, recepciones y registro de proveedores.',
      'Pedidos, cotizaciones, guías y facturación de venta.',
      'Numeradores de comprobantes, series por usuario y correlativos de venta.',
      'Usuarios, roles, permisos y auditoría (incluido en todas las ediciones).',
    ],
    notaTecnica: 'Finanzas en Mype cubre parametrización de series, numeradores de comprobantes de venta y asignación por usuario; no incluye tesorería ni flujo de caja completo.',
  },
  SMALL_BUSINESS: {
    perfil: 'Gestión administrativa y de personal',
    idealPara: 'Pequeñas empresas con equipo formal, control de caja y necesidad de gestionar planilla y asistencia.',
    modulosDestacados: ['Todo SIGRE Mype', 'Finanzas (completo)', 'RR.HH.', 'Asistencia', 'Seguridad'],
    funcionalidades: [
      'Tesorería, cuentas por cobrar/pagar, caja y conciliaciones.',
      'Maestro de trabajadores, contratos, planilla y beneficios.',
      'Control de asistencia, jornadas, permisos, vacaciones y horas extra.',
      'Calendarios laborales e integración con marcación.',
      'Reportes de inasistencias y validaciones de personal.',
    ],
    notaTecnica: 'Incluye el alcance comercial de Mype más finanzas operativas completas y el subsistema de asistencia conectado al ERP.',
  },
  PROFESSIONAL: {
    perfil: 'Operaciones industriales y de servicio',
    idealPara: 'Empresas manufactureras, talleres, plantas y organizaciones con OT, mantenimiento y cadena de abastecimiento.',
    modulosDestacados: ['Todo Small Business', 'Operaciones (OT)', 'Mantenimiento', 'Producción', 'Aprovisionamiento'],
    funcionalidades: [
      'Órdenes de trabajo, programación y seguimiento operativo.',
      'Planes de mantenimiento preventivo y correctivo de activos.',
      'Órdenes de producción, BOM, consumos y costos de fabricación.',
      'Aprovisionamiento avanzado: requisiciones, OC automáticas y abastecimiento por demanda.',
      'Multi-sucursal con trazabilidad entre almacén, compras y operaciones.',
    ],
    notaTecnica: 'Aprovisionamiento habilita el flujo completo de requisición → orden de compra → recepción vinculado a OT y producción.',
  },
  ENTERPRISE: {
    perfil: 'Suite integral multi-industria',
    idealPara: 'Corporaciones, holdings y grupos empresariales con procesos contables, sectoriales y multi-empresa.',
    modulosDestacados: ['Todos los módulos SIGRE', 'Contabilidad', 'Presupuesto', 'Activos fijos', 'SIG', 'Auditoría'],
    modulosOpcionales: ['Flota', 'HORECA', 'Campo', 'Comedor'],
    funcionalidades: [
      'Contabilidad general, libros electrónicos y cierre contable.',
      'Presupuesto corporativo y control por centros de costo.',
      'Activos fijos, depreciación y revaluación.',
      'Sistema integrado de gestión (SIG) y auditoría interna.',
      'API de integración, personalización avanzada y soporte dedicado.',
    ],
    notaTecnica: 'Flota, HORECA, Campo y Comedor se activan según el giro de negocio durante la implementación; el resto de módulos viene incluido de forma estándar.',
  },
  HORECA: {
    perfil: 'Sector hotelería, restaurantes y catering',
    idealPara: 'Hoteles, restaurantes, cafeterías y servicios de catering que gestionan habitaciones, consumos, comedor y personal.',
    modulosDestacados: ['Almacén', 'Compras', 'Comercialización', 'Finanzas', 'RR.HH.', 'Asistencia', 'HORECA', 'Comedor', 'Seguridad'],
    funcionalidades: [
      'Gestión hotelera: maestro de cuartos, alojamiento de huéspedes y servicios.',
      'Restaurante y catering: comandas, raciones, menús y control de consumos.',
      'Comedor: gestión de menús, raciones y costos de alimentación.',
      'Compras e inventario de insumos perecibles con control de almacén.',
      'Planilla, asistencia y facturación de venta integradas.',
    ],
    notaTecnica: 'Edición sectorial: incluye el módulo HORECA y Comedor sobre la base administrativa (almacén, compras, comercialización, finanzas, RR.HH. y asistencia).',
  },
  HEALTH: {
    perfil: 'Sector salud',
    idealPara: 'Clínicas, hospitales, policlínicos y consultorios que gestionan insumos, farmacia, facturación y personal asistencial.',
    modulosDestacados: ['Almacén', 'Compras', 'Comercialización', 'Finanzas', 'RR.HH.', 'Asistencia', 'Contabilidad', 'Activos fijos', 'Seguridad'],
    funcionalidades: [
      'Almacén de insumos médicos y farmacia con kardex y control de lotes.',
      'Compras y abastecimiento de medicamentos e insumos.',
      'Facturación de servicios y comercialización.',
      'Activos fijos: equipamiento médico, depreciación y mantenimiento de inventario.',
      'Planilla, asistencia del personal asistencial y contabilidad.',
    ],
    notaTecnica: 'Edición sectorial salud sobre la base administrativa-contable; los flujos clínicos específicos se parametrizan en la implementación.',
  },
};
