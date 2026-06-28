import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import {
  EdicionErpDto,
  ErpLandingCatalogService,
  PlanSuscripcionDto,
} from '../../services/erp-landing-catalog.service';
import { AuthService } from '../../../auth/services/auth.service';
import { EDICIONES_CONTENIDO } from './ediciones-contenido';
import { iconoModulo } from '../../shared/modulos-iconos';

interface ModuloInfo {
  codigo: string;
  nombre: string;
  descripcion: string;
  icono: string;
  color: string;
  funciones: string[];
}

interface CategoriaModulos {
  nombre: string;
  modulos: ModuloInfo[];
}

interface PlanSuscripcion {
  codigo: string;
  nombre: string;
  precio: number;
  descripcion: string;
  caracteristicas: string[];
  color: string;
  destacado: boolean;
  maxUsuarios: number | null;
}

interface EdicionERP {
  codigo: string;
  nombre: string;
  descripcion: string;
  icono: string;
  perfil: string;
  idealPara: string;
  modulosDestacados: string[];
  modulosOpcionales: string[];
  funcionalidades: string[];
  notaTecnica: string;
  modulosApi: string[];
}

@Component({
  selector: 'app-erp-landing',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './erp-landing.component.html',
  styleUrls: ['./erp-landing.component.scss'],
})
export class ErpLandingComponent implements OnInit {

  private readonly router = inject(Router);
  private readonly landingCatalog = inject(ErpLandingCatalogService);
  private readonly authService = inject(AuthService);

  currentYear = new Date().getFullYear();
  showDropdown = '';
  catalogoCargando = true;

  planes: PlanSuscripcion[] = [];
  ediciones: EdicionERP[] = [];

  /** Recargo mensual por usuario que excede el límite incluido en la tarifa */
  readonly recargoUsuarioExtra = 2;

  modulos: ModuloInfo[] = [
    {
      codigo: 'ALMACEN',
      nombre: 'Almacén',
      descripcion: 'Gestión integral de inventarios, kardex, movimientos entre almacenes, control de stock y trazabilidad de productos.',
      icono: 'assets/imagenes/modulos/almacen.png',
      color: '#2E7D32',
      funciones: ['Maestro de almacenes', 'Kardex y movimientos', 'Tipos de movimiento', 'Control de stock mínimo', 'Despacho y recepción', 'Devoluciones', 'Tomas de inventario', 'Reposición automática', 'Guías de remisión', 'Valorización de inventario'],
    },
    {
      codigo: 'COMPRAS',
      nombre: 'Compras',
      descripcion: 'Ciclo completo de adquisiciones: desde el aprovisionamiento hasta la recepción, con control de proveedores y aprobaciones.',
      icono: 'assets/imagenes/modulos/compras.png',
      color: '#1565C0',
      funciones: ['Gestión de proveedores', 'Órdenes de compra', 'Aprobación de órdenes', 'Órdenes de servicio', 'Registro de comprobantes', 'Notas de crédito/débito', 'Condiciones de pago', 'Reportes de compras', 'Análisis de proveedores', 'Compras sugeridas'],
    },
    {
      codigo: 'APROVISIONAMIENTO',
      nombre: 'Aprovisionamiento',
      descripcion: 'Abastecimiento de materia prima: recepción, pesaje, liquidación de compra, proyección y generación de órdenes de compra/servicio.',
      icono: 'assets/imagenes/modulos/aprovisionamiento.svg',
      color: '#388E3C',
      funciones: ['Proyección de aprovisionamiento', 'Recepción y pesaje de MP', 'Liquidación de compra', 'Guías de recepción', 'Generación de OC/OS', 'Control de calidad MP', 'Reportes de acopio y pesca', 'Planillas de compra'],
    },
    {
      codigo: 'COMERCIALIZACION',
      nombre: 'Comercialización',
      descripcion: 'Gestión comercial de ventas, facturación electrónica, regalías y seguimiento de documentos tributarios.',
      icono: 'assets/imagenes/modulos/ventas.png',
      color: '#E65100',
      funciones: ['Facturación de regalías', 'Reportes tributarios', 'Panel de reenvío', 'Estados de documentos', 'Facturación electrónica', 'Gestión de clientes', 'Análisis de ventas', 'Documentos SUNAT'],
    },
    {
      codigo: 'FINANZAS',
      nombre: 'Finanzas',
      descripcion: 'Tesorería, flujo de caja, cuentas por pagar/cobrar, conciliaciones bancarias y gestión de pagos masivos.',
      icono: 'assets/imagenes/modulos/finanzas.png',
      color: '#6A1B9A',
      funciones: ['Cuentas por pagar', 'Cuentas por cobrar', 'Flujo de caja', 'Conciliaciones bancarias', 'Pagos masivos', 'Adelantos y rendiciones', 'Letras de cambio', 'Fondo fijo', 'Caja chica', 'Programación de pagos'],
    },
    {
      codigo: 'CONTABILIDAD',
      nombre: 'Contabilidad',
      descripcion: 'Plan contable, asientos manuales y automáticos, libros electrónicos, reportes financieros y cierre contable.',
      icono: 'assets/imagenes/modulos/contabilidad.png',
      color: '#00695C',
      funciones: ['Plan contable', 'Centros de costo', 'Asientos manuales', 'Asientos automáticos', 'Libros contables', 'Reportes financieros', 'Tipo de cambio', 'Detracciones/Retenciones', 'Cierre contable', 'Análisis de cuentas'],
    },
    {
      codigo: 'ACTIVOS_FIJOS',
      nombre: 'Activos Fijos',
      descripcion: 'Control patrimonial: registro, depreciación, traslados, revaluación y baja de activos fijos.',
      icono: 'assets/imagenes/modulos/activos-fijos.png',
      color: '#BF360C',
      funciones: ['Registro de activos', 'Cálculo de depreciación', 'Traslados de activos', 'Revaluación', 'Baja de activos', 'Pólizas de seguro', 'Clasificación', 'Ubicación de activos', 'Asientos de depreciación', 'Reportes de activos'],
    },
    {
      codigo: 'RRHH',
      nombre: 'RR.HH.',
      descripcion: 'Gestión de personal, nómina, asistencia, vacaciones, liquidaciones y reportes laborales.',
      icono: 'assets/imagenes/modulos/rrhh.png',
      color: '#283593',
      funciones: ['Maestro de personal', 'Cálculo de planillas', 'Asistencia y horas extra', 'Vacaciones y licencias', 'Liquidaciones', 'Calendarios laborales', 'Categorías y cargos', 'Provisión de gastos', 'Boletas de pago', 'Dashboard de RRHH'],
    },
    {
      codigo: 'PRODUCCION',
      nombre: 'Producción',
      descripcion: 'Control de procesos productivos, costeo de fabricación y asignación de gastos indirectos.',
      icono: 'assets/imagenes/modulos/produccion.png',
      color: '#F57F17',
      funciones: ['Órdenes de producción', 'Gastos indirectos', 'Costeo de fabricación', 'Control de procesos', 'Fórmulas de producción', 'Control de calidad'],
    },
    {
      codigo: 'PRESUPUESTO',
      nombre: 'Presupuesto',
      descripcion: 'Planificación y control presupuestario por centros de costo, proyectos y periodos.',
      icono: 'assets/imagenes/modulos/presupuesto.png',
      color: '#2E7D32',
      funciones: ['Formulación presupuestal', 'Control de ejecución', 'Modificaciones presupuestales', 'Reportes de avance', 'Presupuesto por proyecto', 'Alertas de desviación'],
    },
    {
      codigo: 'FLOTA',
      nombre: 'Flota',
      descripcion: 'Administración de vehículos, control de combustible, mantenimiento preventivo y asignación de rutas.',
      icono: 'assets/imagenes/modulos/flota.png',
      color: '#1565C0',
      funciones: ['Maestro de vehículos', 'Control de combustible', 'Mantenimiento preventivo', 'Asignación de conductores', 'Rutas y recorridos', 'Costos operativos', 'Documentos de vehículos', 'Planilla de flota'],
    },
    {
      codigo: 'MANTENIMIENTO',
      nombre: 'Mantenimiento',
      descripcion: 'Planificación de mantenimiento preventivo y correctivo de equipos e infraestructura.',
      icono: 'assets/imagenes/modulos/mantenimiento.png',
      color: '#E65100',
      funciones: ['Órdenes de trabajo', 'Mantenimiento preventivo', 'Mantenimiento correctivo', 'Gestión de repuestos', 'Historial de equipos', 'Programación de paradas', 'Costos de mantenimiento'],
    },
    {
      codigo: 'AUDITORIA',
      nombre: 'Auditoría',
      descripcion: 'Trazabilidad de operaciones, control interno, hallazgos y seguimiento de acciones correctivas.',
      icono: 'assets/imagenes/modulos/auditoria.png',
      color: '#880E4F',
      funciones: ['Log de operaciones', 'Hallazgos de auditoría', 'Acciones correctivas', 'Control interno', 'Reportes de cumplimiento', 'Trazabilidad de cambios'],
    },
    {
      codigo: 'CAMPO',
      nombre: 'Campo',
      descripcion: 'Gestión de operaciones agrícolas: cultivos, cosecha, labores de campo y control de producción.',
      icono: 'assets/imagenes/modulos/campo.png',
      color: '#2E7D32',
      funciones: ['Labores de campo', 'Control de cultivos', 'Registro de cosecha', 'Insumos agrícolas', 'Planificación de siembra', 'Reportes de producción agrícola'],
    },
    {
      codigo: 'COMEDOR',
      nombre: 'Comedor',
      descripcion: 'Administración de servicios de alimentación, menús, raciones y control de costos del comedor.',
      icono: 'assets/imagenes/modulos/comedor.png',
      color: '#F57F17',
      funciones: ['Gestión de menús', 'Control de raciones', 'Costos de alimentación', 'Registro de consumos', 'Proveedores de alimentos', 'Reportes nutricionales'],
    },
    {
      codigo: 'SIG',
      nombre: 'SIG',
      descripcion: 'Sistema de Información Gerencial: indicadores clave, dashboards ejecutivos y reportes consolidados.',
      icono: 'assets/imagenes/modulos/sig.png',
      color: '#00695C',
      funciones: ['Dashboards ejecutivos', 'Indicadores KPI', 'Reportes consolidados', 'Análisis de tendencias', 'Alertas gerenciales', 'Cuadros de mando'],
    },
    {
      codigo: 'OPERACIONES',
      nombre: 'Operaciones',
      descripcion: 'Gestión de órdenes de trabajo, coordinación operativa y seguimiento de procesos transversales.',
      icono: 'assets/imagenes/modulos/operaciones.png',
      color: '#283593',
      funciones: ['Órdenes de trabajo', 'Coordinación operativa', 'Seguimiento de procesos', 'Control de calidad', 'Reportes operativos'],
    },
    {
      codigo: 'HOTELERIA',
      nombre: 'Hotelería',
      descripcion: 'PMS hotelero: habitaciones, tarifas, reservas, recepción (check-in/out, folio) y housekeeping.',
      icono: 'assets/imagenes/modulos/hoteleria.svg',
      color: '#AD1457',
      funciones: [
        'Habitaciones, tipos y tarifas por temporada',
        'Reservas de habitaciones y disponibilidad',
        'Recepción: check-in / check-out y folio del huésped',
        'Asignación de habitaciones',
        'Housekeeping: limpieza, lavandería, objetos perdidos y mantenimiento',
        'Ocupación',
      ],
    },
    {
      codigo: 'RESTAURANTE',
      nombre: 'Restaurante y Bar',
      descripcion: 'POS de restaurante y bar: carta, mesas, comandas, pedidos, cocina (KDS), room service y propinas.',
      icono: 'assets/imagenes/modulos/restaurante.svg',
      color: '#D81B60',
      funciones: [
        'Carta y menú, mesas y áreas, recetas',
        'Reservas de mesas',
        'Comandas, pedidos y cocina (monitor KDS)',
        'Atención de bar y room service',
        'Propinas y caja / cierre de turno',
        'Ventas de restaurante',
      ],
    },
    {
      codigo: 'CATERING',
      nombre: 'Catering y Eventos',
      descripcion: 'Banquetes y eventos: salones, cotización, planificación de menús y montaje/logística.',
      icono: 'assets/imagenes/modulos/catering.svg',
      color: '#8E24AA',
      funciones: [
        'Salones de eventos',
        'Cotización de eventos',
        'Planificación de menús',
        'Montaje y logística',
        'Rentabilidad por evento',
      ],
    },
    {
      codigo: 'SALUD',
      nombre: 'Salud',
      descripcion: 'Clínicas, hospitales y consultorios: admisión, citas, atención clínica, historia clínica electrónica, hospitalización y quirófano.',
      icono: 'assets/imagenes/modulos/salud.svg',
      color: '#0288D1',
      funciones: [
        'Maestro de pacientes, especialidades y médicos',
        'Admisión, triaje, citas y agenda',
        'Atención médica e historia clínica electrónica',
        'Órdenes médicas y emergencia',
        'Hospitalización (camas), quirófano y alta/epicrisis',
        'Aseguradoras, convenios y tarifario de servicios',
      ],
    },
    {
      codigo: 'FARMACIA',
      nombre: 'Farmacia',
      descripcion: 'Dispensación de medicamentos, recetas, petitorio y control de lotes/vencimientos e inventario de farmacia.',
      icono: 'assets/imagenes/modulos/farmacia.svg',
      color: '#00897B',
      funciones: ['Maestro de medicamentos', 'Petitorio / formulario', 'Lotes y vencimientos', 'Dispensación', 'Recetas', 'Reposición de stock'],
    },
    {
      codigo: 'LABORATORIO',
      nombre: 'Laboratorio',
      descripcion: 'Apoyo al diagnóstico: órdenes de laboratorio, toma de muestras, resultados e imágenes/informes.',
      icono: 'assets/imagenes/modulos/laboratorio.svg',
      color: '#5E35B1',
      funciones: ['Exámenes y pruebas', 'Valores de referencia', 'Órdenes de laboratorio', 'Toma de muestras', 'Resultados', 'Imágenes e informes'],
    },
    {
      codigo: 'SEGURIDAD',
      nombre: 'Configuración',
      descripcion: 'Administración del sistema: usuarios, roles, permisos, empresas, sucursales y parámetros generales.',
      icono: 'assets/imagenes/modulos/configuracion.png',
      color: '#37474F',
      funciones: ['Gestión de usuarios', 'Roles y permisos', 'Empresas y sucursales', 'Monedas y ejercicios', 'Cuentas bancarias', 'Condiciones de pago', 'Retenciones', 'Datos de la cuenta'],
    },
  ];

  categoriasModulos: CategoriaModulos[] = [];

  ngOnInit(): void {
    this.modulos = this.modulos.map(m => ({ ...m, icono: iconoModulo(m.codigo) }));
    this.buildCategorias();
    this.landingCatalog.obtenerCatalogo().subscribe({
      next: (catalogo) => {
        this.ediciones = catalogo.ediciones.map(e => this.mapEdicion(e));
        this.planes = catalogo.planes.map(p => this.mapPlan(p));
        this.catalogoCargando = false;
      },
      error: () => {
        this.ediciones = this.getEdicionesFallback();
        this.planes = this.getPlanesFallback();
        this.catalogoCargando = false;
      },
    });
  }

  irALogin(): void {
    void this.authService.invalidateSession().then(() => {
      void this.router.navigateByUrl('/auth/signin');
    });
  }

  irARegistro(): void {
    void this.router.navigateByUrl('/sigre/registro');
  }

  abrirDetalle(modulo: ModuloInfo): void {
    this.showDropdown = '';
    void this.router.navigateByUrl(`/sigre/modulo/${modulo.codigo.toLowerCase()}`);
  }

  scrollToPrecios(): void {
    this.showDropdown = '';
    document.getElementById('precios')?.scrollIntoView({ behavior: 'smooth' });
  }

  scrollToEdiciones(): void {
    this.showDropdown = '';
    document.getElementById('ediciones')?.scrollIntoView({ behavior: 'smooth' });
  }

  scrollToContacto(): void {
    document.getElementById('contacto')?.scrollIntoView({ behavior: 'smooth' });
  }

  readonly whatsappUrl = this.buildWhatsAppUrl();

  private buildWhatsAppUrl(): string {
    const phone = '51960329223';
    const message = encodeURIComponent(
      'Hola, me gustaría conocer las funciones de SIGRE ERP y comentarles mi interés en el sistema para mi empresa.',
    );
    return `https://wa.me/${phone}?text=${message}`;
  }

  precioUsuarioAdicional(plan: PlanSuscripcion): number {
    return plan.precio + this.recargoUsuarioExtra;
  }

  private buildCategorias(): void {
    const map: Record<string, string[]> = {
      'FINANZAS': ['CONTABILIDAD', 'FINANZAS', 'PRESUPUESTO', 'ACTIVOS_FIJOS'],
      'OPERACIONES': ['ALMACEN', 'COMPRAS', 'APROVISIONAMIENTO', 'COMERCIALIZACION', 'PRODUCCION'],
      'RECURSOS HUMANOS': ['RRHH', 'COMEDOR'],
      'GESTIÓN DE ACTIVOS': ['FLOTA', 'MANTENIMIENTO'],
      'SECTORES': ['HORECA', 'CAMPO'],
      'PRODUCTIVIDAD': ['SIG', 'AUDITORIA', 'OPERACIONES', 'SEGURIDAD'],
    };

    this.categoriasModulos = Object.entries(map).map(([nombre, codigos]) => ({
      nombre,
      modulos: codigos
        .map(c => this.modulos.find(m => m.codigo === c))
        .filter((m): m is ModuloInfo => !!m),
    }));
  }

  /** Logo/ícono por edición (PNG en assets). Si no existe el archivo, el <img> se oculta. */
  private iconoEdicion(codigo: string): string {
    const mapa: Record<string, string> = {
      MYPE: 'mype',
      SMALL_BUSINESS: 'small-business',
      PROFESSIONAL: 'professional',
      ENTERPRISE: 'enterprise',
      HORECA: 'horeca',
      HEALTH: 'health_care',
    };
    const archivo = mapa[codigo];
    return archivo ? `assets/imagenes/ediciones/${archivo}.png` : '';
  }

  private mapEdicion(edicion: EdicionErpDto): EdicionERP {
    const contenido = EDICIONES_CONTENIDO[edicion.codigo];
    const modulosApi = (edicion.modulos ?? []).map(m => m.nombre);
    return {
      codigo: edicion.codigo,
      nombre: edicion.nombre,
      descripcion: edicion.descripcion,
      icono: this.iconoEdicion(edicion.codigo),
      perfil: contenido?.perfil ?? '',
      idealPara: contenido?.idealPara ?? edicion.descripcion,
      modulosDestacados: contenido?.modulosDestacados ?? modulosApi,
      modulosOpcionales: contenido?.modulosOpcionales ?? [],
      funcionalidades: contenido?.funcionalidades ?? [],
      notaTecnica: contenido?.notaTecnica ?? '',
      modulosApi,
    };
  }

  private mapPlan(plan: PlanSuscripcionDto): PlanSuscripcion {
    return {
      codigo: plan.codigo,
      nombre: plan.nombre,
      precio: Number(plan.precio),
      descripcion: plan.descripcion,
      caracteristicas: plan.caracteristicas ?? [],
      color: plan.color ?? '#714b67',
      destacado: !!plan.destacado,
      maxUsuarios: plan.maxUsuarios,
    };
  }

  private getEdicionesFallback(): EdicionERP[] {
    const base = [
      {
        codigo: 'MYPE',
        nombre: 'SIGRE Mype',
        descripcion: 'Venta, compra e inventario con facturación y control básico de series y numeradores.',
      },
      {
        codigo: 'SMALL_BUSINESS',
        nombre: 'SIGRE Small Business',
        descripcion: 'Mype ampliado con finanzas completas, planilla, RR.HH. y control de asistencia.',
      },
      {
        codigo: 'PROFESSIONAL',
        nombre: 'SIGRE Professional',
        descripcion: 'Operaciones con OT, mantenimiento, producción y aprovisionamiento avanzado.',
      },
      {
        codigo: 'ENTERPRISE',
        nombre: 'SIGRE Enterprise',
        descripcion: 'Suite completa multi-empresa con módulos sectoriales según su giro de negocio.',
      },
      {
        codigo: 'HORECA',
        nombre: 'SIGRE HORECA',
        descripcion: 'Edición sectorial para hoteles, restaurantes y catering: operación, comedor y servicio.',
      },
      {
        codigo: 'HEALTH',
        nombre: 'SIGRE Healthcare',
        descripcion: 'Edición sectorial para clínicas, hospitales y consultorios: insumos, facturación y personal.',
      },
    ];
    return base.map(e => this.mapEdicion({
      id: 0,
      codigo: e.codigo,
      nombre: e.nombre,
      descripcion: e.descripcion,
      orden: 0,
      activo: true,
      modulos: [],
    }));
  }

  private getPlanesFallback(): PlanSuscripcion[] {
    return [
      {
        codigo: 'DEMO',
        nombre: 'Demo gratuito',
        precio: 0,
        descripcion: 'Acceso completo al SIGRE por 15 días',
        caracteristicas: ['Todo el SIGRE', 'Máximo 5 usuarios', '15 días de acceso', 'Sin tarjeta de crédito'],
        color: '#00bcd4',
        destacado: false,
        maxUsuarios: 5,
      },
      {
        codigo: 'STANDARD',
        nombre: 'Mype',
        precio: 8,
        descripcion: 'Edición SIGRE Mype — SIGRE Online',
        caracteristicas: ['Hasta 5 usuarios incluidos', 'Almacén, Compras y Comercialización', 'Finanzas: series y numeradores de venta', 'Seguridad y permisos', 'SIGRE Online', 'Soporte por email'],
        color: '#f5a623',
        destacado: false,
        maxUsuarios: 5,
      },
      {
        codigo: 'SMALL_BUSINESS',
        nombre: 'Small Business',
        precio: 12,
        descripcion: 'Edición SIGRE Small Business — SIGRE Online',
        caracteristicas: ['Hasta 10 usuarios incluidos', 'Todo SIGRE Mype', 'Finanzas completo (tesorería y CxC/CxP)', 'RR.HH. y planilla', 'Control de asistencia', 'Soporte por email'],
        color: '#26a69a',
        destacado: false,
        maxUsuarios: 10,
      },
      {
        codigo: 'PERSONALIZADO',
        nombre: 'Professional',
        precio: 16,
        descripcion: 'Edición SIGRE Professional — SIGRE Online / On-premise',
        caracteristicas: ['Hasta 20 usuarios incluidos', 'Todo Small Business', 'Operaciones (OT) y Mantenimiento', 'Producción y aprovisionamiento', 'Multi-sucursal', 'Soporte prioritario'],
        color: '#714b67',
        destacado: true,
        maxUsuarios: 20,
      },
      {
        codigo: 'ENTERPRISE',
        nombre: 'Enterprise',
        precio: 20,
        descripcion: 'Edición SIGRE Enterprise — acceso completo',
        caracteristicas: ['Hasta 40 usuarios incluidos', 'Todos los módulos SIGRE', 'Contabilidad, Presupuesto y Activos fijos', 'Flota, HORECA, Campo según giro', 'API e integraciones', 'Soporte 24/7 dedicado'],
        color: '#e11d48',
        destacado: false,
        maxUsuarios: 40,
      },
    ];
  }

}
