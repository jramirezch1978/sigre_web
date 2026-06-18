import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import {
  EdicionErpDto,
  ErpLandingCatalogService,
  PlanSuscripcionDto,
} from '../../services/erp-landing-catalog.service';

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
}

interface EdicionERP {
  codigo: string;
  nombre: string;
  descripcion: string;
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

  currentYear = new Date().getFullYear();
  showDropdown = '';
  catalogoCargando = true;

  planes: PlanSuscripcion[] = [];
  ediciones: EdicionERP[] = [];

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
      codigo: 'HORECA',
      nombre: 'HORECA',
      descripcion: 'Hoteles, restaurantes y catering: reservas, alojamiento, huéspedes, servicios de restaurante y eventos.',
      icono: 'assets/imagenes/modulos/horeca.png',
      color: '#AD1457',
      funciones: ['Maestro de cuartos', 'Alojamiento de huéspedes', 'Reservas', 'Check-in / Check-out', 'Servicios de restaurante', 'Catering y eventos', 'Tarifas y temporadas', 'Facturación hotelera'],
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
    void this.router.navigateByUrl('/auth/signin');
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

  scrollToContacto(): void {
    document.getElementById('contacto')?.scrollIntoView({ behavior: 'smooth' });
  }

  private buildCategorias(): void {
    const map: Record<string, string[]> = {
      'FINANZAS': ['CONTABILIDAD', 'FINANZAS', 'PRESUPUESTO', 'ACTIVOS_FIJOS'],
      'OPERACIONES': ['ALMACEN', 'COMPRAS', 'COMERCIALIZACION', 'PRODUCCION'],
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

  private mapEdicion(edicion: EdicionErpDto): EdicionERP {
    return {
      codigo: edicion.codigo,
      nombre: edicion.nombre,
      descripcion: edicion.descripcion,
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
    };
  }

  private getEdicionesFallback(): EdicionERP[] {
    return [
      { codigo: 'MYPE', nombre: 'SIGRE Mype', descripcion: 'Para microempresas y emprendedores' },
      { codigo: 'SMALL_BUSINESS', nombre: 'SIGRE Small Business', descripcion: 'Para pequeñas empresas en crecimiento' },
      { codigo: 'PROFESSIONAL', nombre: 'SIGRE Professional', descripcion: 'Para medianas empresas con operaciones completas' },
      { codigo: 'ENTERPRISE', nombre: 'SIGRE Enterprise', descripcion: 'Para grandes corporaciones con todos los módulos' },
    ];
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
      },
      {
        codigo: 'STANDARD',
        nombre: 'Estándar',
        precio: 8,
        descripcion: 'Edición SIGRE Mype — SIGRE Online',
        caracteristicas: ['Edición SIGRE Mype', 'SIGRE Online', 'Módulos incluidos en Mype', 'Soporte por email', 'Actualizaciones incluidas'],
        color: '#f5a623',
        destacado: false,
      },
      {
        codigo: 'PERSONALIZADO',
        nombre: 'Personalizado',
        precio: 12,
        descripcion: 'Edición SIGRE Professional — SIGRE Online / On-premise',
        caracteristicas: ['Edición SIGRE Professional', 'SIGRE Online / On-premise', 'Multi-sucursal', 'Módulos operativos completos', 'Soporte prioritario'],
        color: '#714b67',
        destacado: true,
      },
      {
        codigo: 'ENTERPRISE',
        nombre: 'Enterprise',
        precio: 20,
        descripcion: 'Edición SIGRE Enterprise — acceso completo',
        caracteristicas: ['Edición SIGRE Enterprise', 'Todos los módulos', 'Multi-empresa ilimitado', 'API de integración', 'Personalización avanzada', 'Soporte 24/7 dedicado'],
        color: '#e11d48',
        destacado: false,
      },
    ];
  }

}
