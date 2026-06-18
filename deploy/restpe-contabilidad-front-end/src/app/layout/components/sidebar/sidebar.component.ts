import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CountryService } from '../../../ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';

// Font Awesome Icons
import { faAngleDown, faAngleUp } from '@fortawesome/pro-solid-svg-icons';
import { IconProp } from '@fortawesome/fontawesome-svg-core';

type SubMenuItem = {
  label: string;
  link: string;
  subSubMenu?: SubMenuItem[];
};

type MenuItem = {
  key: string;
  label: string;
  icon: IconProp;
  link: string;
  exact: boolean;
  subMenu?: SubMenuItem[];
};

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.scss'],
  standalone: false,
})
export class SidebarComponent implements OnInit {
  // Font Awesome Icons
  fasAngleDown = faAngleDown;
  fasAngleUp = faAngleUp;

  modoadministrador = true;
  pais=this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  calculodeplanilla= this.pais === 'EC' ? 'Cálculo de roles' : 'Cálculo de planillas';
  valortributario= this.countries.find(country => country.codigo === this.pais)?.valortributario || 'UIT';
  registrarliquidacion= this.pais === 'GT' ? 'Registrar Finiquito' : 'Registrar Liquidación';
  selectitem = true;
  selectpantalla: string = 'configuracion';
  titulodetracciones= this.pais === 'CO' || this.pais=== 'EC' ? 'Retenciones' : 'Detracciones';
  cambiartitulo= this.pais === 'GT' ? 'Parametros de impuestos' : 'Parámetros de impuestos y aportes laborales';
  titulopagodetracciones= this.pais === 'GT' || this.pais === 'CO' || this.pais === 'EC' ? 'Pago de Retenciones' : 'Pago de Detracciones';
  hoveredItem: string | null = null;
  selectedSubSubItem: string | null = null;
  selectedSubItem: string | null = null; // Formato: 'menuLabel|subItemLabel'
  selectedMenuItem: string | null = null;

  constructor(private router: Router, private countryService: CountryService) {}

  ngOnInit() {
    // Detectar la ruta actual y establecer los items seleccionados
    
    this.detectCurrentRoute();

    // Suscribirse a los cambios de ruta
    this.router.events.subscribe(() => {
      this.detectCurrentRoute();
    });
  }

  activeMenu: string | null = null;

  openMenu(label: string) {
    this.activeMenu = label;
  }

  closeMenu() {
    this.activeMenu = null;
  }

  detectCurrentRoute() {
    const currentUrl = this.router.url;

    // Buscar en el menú el item que coincide con la ruta actual
    for (const menuItem of this.menu) {
      if (menuItem.subMenu) {
        for (const subItem of menuItem.subMenu) {
          if (subItem.subSubMenu) {
            for (const subSubItem of subItem.subSubMenu) {
              if (currentUrl.includes(subSubItem.link)) {
                this.selectedMenuItem = menuItem.label;
                this.selectedSubItem = `${menuItem.label}|${subItem.label}`;
                this.selectedSubSubItem = subSubItem.label;
                return;
              }
            }
          }
        }
      }
    }
  }

  selectTab(tab: string) {
    this.selectpantalla = tab;
    this.router.navigate([`/${tab}`]);
  }

  onMouseEnter(key: string) {
    this.hoveredItem = key;
  }

  onMouseLeave() {
    this.hoveredItem = null;
  }

  menu: MenuItem[] = [
    {
      key: 'dashboard',
      label: 'Almacén',
      icon: ['far', 'warehouse'],
      link: '/almacen',
      exact: true,
      subMenu: [
        {
          label: 'Tablas',
          link: '/almacen/tablas',
          subSubMenu: [
            { label: 'Almacén', link: '/almacen/tablas/tablas-almacenes' },
            { label: "Motivo de traslado", link: '/almacen/tablas/motivo-traslado'},
            {
              label: 'Tipos de movimiento por almacenes',
              link: '/almacen/tablas/almacenes-movimiento',
            },
            {
              label: 'Clases de productos',
              link: '/almacen/tablas/clasificacion-articulos',
            },
            {
              label: 'Maestro de productos',
              link: '/almacen/tablas/maestro-productos',
            },
          ],
        },
        {
          label: 'Operaciones',
          link: '/almacen/operaciones',
          subSubMenu: [
            {
              label: 'Requerimientos de traslado entre almacenes',
              link: '/almacen/operaciones/req-traslado',
            },
            { label: 'Despacho de productos', link: '/almacen/operaciones/despacho' },
            { label: 'Recepción de mercadería', link: '/almacen/operaciones/recepcion' },
            {
              label: 'Almacenamiento de mercadería',
              link: '/almacen/operaciones/almacenamiento',
            },
            {
              label: 'Registro y gestión de devoluciones',
              link: '/almacen/operaciones/devoluciones',
            },
            {
              label: 'Reposición de stock',
              link: '/almacen/operaciones/reposicion-stock',
            },
            {
              label: 'Comparación de inventario',
              link: '/almacen/operaciones/comparacion-inventario',
            },
            {
              label: 'Registro de Pérdidas/Mermas',
              link: '/almacen/operaciones/registro-perdidas',
            },
          ],
        },

        {
          label: 'Consultas',
          link: '/almacen/consultas',
          subSubMenu: [
            {
              label: 'Kardex / Movimiento de inventario',
              link: '/almacen/consultas/kardex-movimientos',
            },
            {
              label: 'Órdenes de compra',
              link: '/almacen/consultas/ordenes-compra',
            },
            {
              label: 'Consulta de productos',
              link: '/almacen/consultas/consulta-articulos',
            },
            { label: 'Préstamos de mercadería', link: '/almacen/consultas/prestamos' },
            { label: 'Devoluciones a Proveedores', link: '/almacen/consultas/devoluciones' },
          ],
        },
        {
          label: 'Reportes',
          link: '/almacen/reportes',
          subSubMenu: [
            {
              label: 'Stock a la fecha',
              link: '/almacen/consultas/stock-fecha',
            },
            {
              label: 'Historial de movimiento',
              link: '/almacen/consultas/historial-movimiento',
            },
            { label: 'Valorización', link: '/almacen/consultas/valorizacion' },
            {
              label: 'Productos vendidos por periodo',
              link: '/almacen/consultas/productos-vendidos-por-periodo',
            },
            { label: 'Stock mínimo', link: '/almacen/consultas/stock-minimo' },
            {
              label: 'Diagnostico de almacenes',
              link: '/almacen/consultas/diagnostico-almacenes',
            },
            {
              label: 'Reportes de tomas de inventario',
              link: '/almacen/consultas/reporte-tomas-inventario',
            },
          ],
        },
        {
          label: 'Procesos',
          link: '/almacen/procesos',
          subSubMenu: [
            {
              label: 'Recálculo de precios promedio',
              link: '/almacen/procesos/recalcular',
            },
            {
              label: 'Cuadres de stock',
              link: '/almacen/procesos/cuadre-stock',
            },
            {
              label: 'Actualización automática',
              link: '/almacen/procesos/actualizacion',
            },
          ],
        },
      ],
    },
    {
      key: 'clientes',
      label: 'Compras',
      icon: ['far', 'cart-shopping'],
      link: '/compras',
      exact: true,
      subMenu: [
        {
          label: 'Tablas',
          link: '/compras/tablas',
          subSubMenu: [
            {
              label: 'Proveedores',
              link: '/compras/tabla/gestion-proveedores',
            },
            {
              label: 'Condiciones de pago',
              link: '/compras/tabla/condiciones-pago',
            },
          ],
        },
        {
          label: 'Operaciones',
          link: '/compras/operaciones',
          subSubMenu: [
            {
              label: 'Aprovisionamiento',
              link: '/compras/operaciones/aprovisionamiento',
            },
            {
              label: 'Generar orden de compra',
              link: '/compras/operaciones/ordenes-compra',
            },
            {
              label: 'Aprobar orden de compra',
              link: '/compras/operaciones/aprobar-compra',
            },
            {
              label: 'Generar orden de servicio',
              link: '/compras/operaciones/ordenes-servicio',
            },
            {
              label: 'Aprobar orden de servicio',
              link: '/compras/operaciones/aprobar-servicio',
            },
            {
              label: 'Registro de comprobantes',
              link: '/compras/operaciones/facturas-proveedores',
            },
            {
              label: 'Notas de crédito / débito',
              link: '/compras/operaciones/notas-credito-debito',
            },
            {
              label: 'Facturas que pertenecen a gastos',
              link: '/compras/operaciones/no-compras',
            },
          ],
        },
        {
          label: 'Cotizaciones',
          link: '/compras/cotizaciones',
          subSubMenu: [
            {
              label: 'Registrar cotización',
              link: '/compras/cotizaciones/registrar',
            },
          ],
        },
        {
          label: 'Reportes',
          link: '/compras/reportes/reporte-de-compras',
          subSubMenu: [
            {
              label: 'Reportes de compras',
              link: '/compras/reportes/reporte-de-compras',
            },
            {
              label: 'Reporte de compras en tránsito',
              link: '/compras/reportes/compras-transito',
            },
            {
              label: 'Reporte de compras por ingresar',
              link: '/compras/reportes/compras-por-ingresar',
            },
            {
              label: 'Reporte de análisis de proveedores',
              link: '/compras/reportes/analisis-proveedores',
            },
            {
              label: 'Reporte de compras por categorías',
              link: '/compras/reportes/compras-categoria',
            },
            {
              label: 'Reporte de Gestión de compras',
              link: '/compras/reportes/gestion-compras',
            },
            {
              label: 'Reporte de compras sugeridas',
              link: '/compras/reportes/compras-sugeridas',
            },
          ],
        },
      ],
    },
    {
      key: 'tesoreria',
      label: 'Ventas',
      icon: ['far', 'money-bill'],
      link: '/tesoreria',
      exact: true,
      subMenu: [
        // {
        //   label: 'Tablas',
        //   link: '/ventas/pedidos',
        //   subSubMenu: [
        //     { label: 'Clientes', link: '/ventas/tabla/clientes' },
        //     {
        //       label: 'Vendedores Meseros y cajeros',
        //       link: '/ventas/tabla/productos',
        //     },
        //     {
        //       label: 'Lista de precios de venta',
        //       link: '/ventas/tabla/servicios',
        //     },
        //   ],
        // },
        {
          label: 'Operaciones',
          link: '/ventas/operaciones',
          subSubMenu: [
            { label: 'Facturación de regalías', link: '/ventas/facturacion-de-regalias' },
          ],
        },
        // {
        //   label: 'Consultas',
        //   link: '/ventas/clientes',
        //   subSubMenu: [
        //     { label: 'Facturacion', link: '/ventas/consultas/clientes' },
        //     // {
        //     //   label: 'Cuentas por cobrar vencidas',
        //     //   link: '/ventas/consultas/productos',
        //     // },
        //   ],
        // },
        {
          label: 'Reportes',
          link: '/ventas/reportes',
          subSubMenu: [
            { label: 'Reporte tributario por periodo', link: '/ventas/reportes/reporte-tributario-por-periodo' },
            { label: 'Reporte de ventas', link: '/ventas/reportes/reporte-de-ventas' },
            { label: 'Panel de reenvío', link: '/ventas/reportes/panel-reenvio' },
            { label: 'Panel de estados de documentos', link: '/ventas/reportes/panel-estados-doc' },
            // {
            //   label: 'Venta Financiero',
            //   link: '/ventas/reportes/ventas-vendedor',
            // },
            // { label: 'Tributario', link: '/ventas/reportes/analisis-ventas' },
          ],
        },
      ],
    },
    {
      key: 'proveed',
      label: 'Finanzas',
      icon: ['fas', 'chart-line'],
      link: '/finanzas',
      exact: true,
      subMenu: [
        {
          label: 'Tablas',
          link: '/finanzas',
          subSubMenu: [
            { label: 'Documentos', link: '/finanzas/tabla/tipos-documento' },
            {
              label: 'Conceptos Financieros',
              link: '/finanzas/tabla/conceptos-financieros',
            },
            {
              label: 'Grupos y Códigos de Flujos de caja',
              link: '/finanzas/tabla/gestion-grupos',
            },
          ],
        },
        {
          label: 'Operaciones',
          link: '/finanzas/operaciones',
          subSubMenu: [
            {
              label: 'Canje de documentos',
              link: '/finanzas/operaciones/canje-reprogramacion',
            },
            {
              label: 'Relación de documentos por proveedor',
              link: '/finanzas/operaciones/documentos-proveedor',
            },
            {
              label: 'Aplicación de documentos',
              link: '/finanzas/operaciones/pagos-recibidos',
            },
            {
              label: 'Registro de Letras de Cambio Emitidas a Clientes como Forma de Pago',
              link: '/finanzas/operaciones/letras-cambio',
            },
            {
              label: 'Registro de facturas que pertenecen a otros ingresos',
              link: '/finanzas/operaciones/registro-facturas',
            },
            {
              label: 'Relación de documentos por cliente',
              link: '/finanzas/operaciones/documentos-cliente',
            },
          ],
        },
        {
          label: 'Consultas',
          link: '/finanzas/presupuestos',
          subSubMenu: [
            {
              label: 'Consultas de saldos de caja y bancos',
              link: '/finanzas/consultas/consultas-saldos-caja-bancos',
            },
            {
              label: 'Consulta de flujo de caja',
              link: '/finanzas/consultas/consultas-flujo-caja',
            },
            {
              label: 'Documentos por finanzas',
              link: '/finanzas/consultas/documento-finanzas',
            },
          ],
        },
        {
          label: 'Adelantos',
          link: '/finanzas/adelantos',
          subSubMenu: [
            {
              label: 'Generación de órdenes de giro',
              link: '/finanzas/adelantos/ordenes-giro',
            },
            {
              label: 'Aprobación de órdenes de giro',
              link: '/finanzas/adelantos/aprobar-giro',
            },
            {
              label: 'Rendición de gastos',
              link: '/finanzas/adelantos/rendicion-gastos',
            },
            {
              label: 'Aprobación de rendición de gastos',
              link: '/finanzas/adelantos/aprobar-rendicion-gastos',
            },
            {
              label: 'Cierre de liquidación de adelantos',
              link: '/finanzas/adelantos/cerrar-liq-adelantos',
            },
          ],
        },
        {
          label: 'Tesorería',
          link: '/finanzas/reportes',
          subSubMenu: [
            // { 
            //   label: 'Carteras de pagos eliminado', 
            //   link: '/finanzas/tesoreria/carteras-pagos-prueba' 
            // },
            { 
              label: 'Carteras de cobros', 
              link: '/finanzas/tesoreria/carteras-cobros' 
            },
            { 
              // Aplicacion de pagos
              label: 'Cartera de pagos', 
              link: '/finanzas/tesoreria/cartera-pagos' 
            },
            { 
              label: 'Pagos masivos', 
              link: '/finanzas/tesoreria/pagos-masivos' 
            },
            
            { 
              label: 'Anulación o reversión de pagos', 
              link: '/finanzas/tesoreria/anulacion-o-reversion-de-pagos' 
            },
            {
              label: 'Movimiento entre cuentas bancarias y cajas',
              link: '/finanzas/tesoreria/mov-cuentas-banc-y-cajas',
            },
            {
              label: 'Programación de Pagos por Vencimiento',
              link: '/finanzas/tesoreria/program-pagos-por-realizar-por-venc',
            },
            {
              label: 'Ejecución de pagos a ente tributario',
              link: '/finanzas/tesoreria/ejecucion-pago',
            },
            {
              label: this.titulopagodetracciones,
              link: '/finanzas/tesoreria/pago-detraccion',},
            {
              label: 'Asignación de Fondo Fijo de Caja',  
              link: '/finanzas/tesoreria/asignacion-fondo-fijo-caja',
            },
            {
              label: 'Asignación de caja chica',
              link: '/finanzas/tesoreria/asignacion-caja-chica',
            },
            {
              label: 'Registro de egresos menores',
              link: '/finanzas/tesoreria/registro-egreso-menor',
            },
            {
              label: 'Proyección de los ingresos y egresos',
              link: '/finanzas/tesoreria/proyeccion-ingresos-egresos',
            },
            {
              label: 'Registro de ingresos del día',
              link: '/finanzas/tesoreria/registro-ingreso-de-dia',
            },
          ],
        },
        {
          label: 'Conciliaciones',
          link: '/finanzas/conciliaciones',
          subSubMenu: [
            { label: 'Cruce de extracto bancario', link: '/finanzas/conciliaciones/cruce-extracto'},
            { label: 'Cruce de informacion en pasarela', link: '/finanzas/conciliaciones/cruce-pasarela'},
            { label: 'Conciliaciones bancarias', link: '/finanzas/conciliaciones/conciliaciones' },
          ],
        },
        {
          label: 'Reportes',
          link: '/finanzas/reportes',
          subSubMenu: [
            { label: 'Cuentas por pagar', link: '/finanzas/reportes/cuentas-por-pagar' },
            { label: 'Tesorería', link: '/finanzas/reportes/tesoreria' },
            { label: 'Documentos y clientes', link: '/finanzas/reportes/documentos-clientes',},
            { label: 'Obligaciones por vencer', link: '/finanzas/reportes/obligaciones-por-vencer' },
            { label: 'Finanzas', link: '/finanzas/reportes/finanzas' },
          ],
        },
      ],
    },
    {
      key: 'invent',
      label: 'Contabilidad',
      icon: ['far', 'calculator'],
      link: '/contabilidad',
      exact: true,
      subMenu: [
        {
          label: 'Tablas',
          link: '/contabilidad',
          subSubMenu: [
            {
              label: 'Plan contable',
              link: '/contabilidad/tabla/plan-contable',
            },
            {
              label: 'Plan de centros de costo',
              link: '/contabilidad/tabla/plan-centro-costo',
            },
            { label: 'Contabilidad', link: '/contabilidad/tabla/contabilidad' },
            ...(this.pais !== 'GT' ? [{ label: this.titulodetracciones, link: '/contabilidad/tabla/detracciones' }] : []),
            { label: 'Impuestos', link: '/contabilidad/tabla/impuestos' },
            {
              label: 'Plan de cuentas vs Subcategorias',
              link: '/contabilidad/tabla/cuentas-vs-subcategorias',
            },
            ...(this.pais !== 'EC' ? [{
              label: 'Tipo de cambio',
              link: '/contabilidad/tabla/tipo-de-cambio',
            }] : []),
            ...(this.pais !== 'GT' && this.pais !== 'EC' ? [{ label: 'Registro de ' + this.valortributario, link: '/contabilidad/tabla/registro-uit' }] : []),
          ],
        },
        {
          label: 'Reportes',
          link: '/contabilidad',
          subSubMenu: [
            {
              label: 'Reportes de Maestros Contables',
              link: '/contabilidad/reportes/maestro-contable',
            },
            {
              label: 'Reportes de validación',
              link: '/contabilidad/reportes/validacion',
            },
            {
              label: 'Reportes de libros contables',
              link: '/contabilidad/reportes/libros-y-asientos',
            },
            {
              label: 'Reportes financieros',
              link: '/contabilidad/reportes/reportes-financieros',
            },
            {
              label: 'Análisis de Cuenta Contable',
              link: '/contabilidad/reportes/reportes-analisis-cuenta-contable',
            },
          ],
        },
        {
          label: 'Operaciones',
          link: '/contabilidad',
          subSubMenu: [
            {
              label: 'Gestión de asientos manual',
              link: '/contabilidad/operaciones/gestion-asientos-manual',
            },
            {
              label: 'Gestión de asientos contables automáticos',
              link: '/contabilidad/operaciones/gestion-asientos-automatico',
            },
            {
              label: 'Ajustes y Reclasificación contable',
              link: '/contabilidad/operaciones/ajustes-reclasificacion',
            },
          ],
        },
        {
          label: 'Procesos',
          link: '/contabilidad/procesos',
          subSubMenu: [
            // {
            //   label: 'Generar libros electrónicos',
            //   link: '/contabilidad/procesos/generar-libros',
            // },
            {
              label: 'Consistencia de asientos',
              link: '/contabilidad/procesos/consistencia-asientos',
            },
            {
              label: 'Procesos de ajustes contables',
              link: '/contabilidad/procesos/procesos-ajustes',
            },
            {
              label: 'Clonación de asientos contables',
              link: '/contabilidad/procesos/clonacion-asientos',
            },
            {
              label: 'Procesos de cierre contable',
              link: '/contabilidad/procesos/procesos-cierre-contable',
            },
          ],
        },
        {
          label: 'Consultas',
          link: '/contabilidad',
          subSubMenu: [
            {
              label: 'Saldos de cuentas corriente',
              link: '/contabilidad/operaciones/saldos-cuentas-corriente',
            },
            {
              label: 'Consulta de centros de costos',
              link: '/contabilidad/operaciones/consulta-centro-costos',
            },
          ],
        },
      ],
    },
    {
      key: 'conta',
      label: 'Activos fijos',
      icon: ['fas', 'building'],
      link: '/activos',
      exact: true,
      subMenu: [
        {
          label: 'Tablas',
          link: '/activos',
          subSubMenu: [
            {
              label: 'Maestro de activos fijos',
              link: '/activos/operaciones/registroactivos',
            },
            { label: 'Operaciones', link: '/activos/tabla/operaciones' },
            { label: 'Incidencias', link: '/activos/tabla/incidencias' },
            {
              label: 'Aseguradoras',
              link: '/activos/tabla/aseguradores',
            },
            { label: 'Seguros', link: '/activos/tabla/seguros' },
            {
              label: 'Clasificación de Activos',
              link: '/activos/tabla/clasifactivos',
            },
            {
              label: 'Matrices contables',
              link: '/activos/tabla/matrizcontable',
            },
            {
              label: 'Ubicación de Activos',
              link: '/activos/tabla/ubicacionactivos',
            },
            {
              label: 'Parámetros de operaciones',
              link: '/activos/tabla/paramoperaciones',
            },
            {
              label: 'Configuración de numeración de activos',
              link: '/activos/tabla/numactivos',
            },
            {
              label: 'Configuración de numeración de traslados',
              link: '/activos/tabla/numtraslados',
            },
          ],
        },
        {
          label: 'Operaciones',
          link: '/contabilidad/libro-diario',
          subSubMenu: [
            {
              label: 'Registro de Traslado',
              link: '/activos/operaciones/registrotraslado',
            },
            {
              label: 'Aprobación de Traslado',
              link: '/activos/operaciones/aprobaciontraslado',
            },
            {
              label: 'Recepción de Traslados de Activos Fijos',
              link: '/activos/operaciones/recep-traslados',
            },
            {
              label: 'Operaciones Especiales',
              link: '/activos/operaciones/operacionesactivos',
            },
            {
              label: 'Pólizas de Seguro',
              link: '/activos/operaciones/polizasseguro',
            },
            // {
            //   label: 'Revaluaciones',
            //   link: '/activos/operaciones/revaluaciones',
            // },
            {
              label: 'Asignación de ratios de depreciación',
              link: '/activos/operaciones/asignacionratios',
            },
            {
              label: 'Proceso de baja de activos',
              link: '/activos/operaciones/venta-activos',
            },
          ],
        },
        {
          label: 'Reportes',
          link: '/contabilidad/estados',
          subSubMenu: [
            {
              label: 'Resumen Activo Fijo',
              link: '/activos/reporte/resumen-activofijo',
            },
            {
              label: 'Depreciación Anual por Activo',
              link: '/activos/reporte/depreciacion-anual',
            },
            {
              label: 'Resumen de Activo Fijo Por Rangos',
              link: '/activos/reporte/resumen-rangos',
            },
          ],
        },
        {
          label: 'Procesos',
          link: '/contabilidad/estados',
          subSubMenu: [
            {
              label: 'Calculo de Depreciación',
              link: '/activos/procesos/calculo-depreciacion',
            },
            {
              label: 'Generación de Asientos de Depreciación',
              link: '/activos/procesos/generacion-asientos-depreciacion',
            },
            {
              label: 'Generación de Asientos de Revaluación',
              link: '/activos/procesos/generacion-asientos-revaluacion',
            },
            {
              label: 'Generación de Asientos de Indexación',
              link: '/activos/procesos/generacion-asientos-indexacion',
            },
            {
              label: 'Generación de Devengo Mensual de Aseguradores',
              link: '/activos/procesos/generacion-devengo-aseguradores',
            },
            {
              label: 'Generación de Asientos de Siniestro y Recupero',
              link: '/activos/procesos/generacion-asientos-siniestro',
            },
          ],
        },
      ],
    },
    {
      key: 'rrhh',
      label: 'RR.HH',
      icon: ['far', 'users'],
      link: '/rrhh',
      exact: true,
      subMenu: [
        {
          label: 'Consultas y Validaciones',
          link: '/rrhh/consultas-validaciones',
          subSubMenu: [
            {
              label: 'Inasistencias',
              link: '/rrhh/consultas-validaciones/inasistencias',
            },
            {
              label: this.pais === 'EC' ? 'Rol de Pagos' : 'Reportes de planilla',
              link: '/rrhh/consultas-validaciones/reportes-de-planilla',
            },
            { label: 'Análisis de inconsistencias en nómina', link: '/rrhh/consultas-validaciones/analisis-inconsistencia-nomina' },
          ],
        },
        {
          label: 'Maestros de Personal',
          link: '/rrhh/maestro-personal',
          subSubMenu: [
            { label: 'Datos personales y contacto', link: '/rrhh/maestro-personal/datos-contacto' },
            { label: 'Definición de categorías laborales', link: '/rrhh/maestro-personal/categorias-laborales' },
            { label: 'Definición de cargo', link: '/rrhh/maestro-personal/definicion-cargos' },
            { label: 'Definición de áreas y jerarquías', link: '/rrhh/maestro-personal/definicion-areas-jerarquias' },
            { label: 'Configuración de planilla por trabajador', link: '/rrhh/maestro-personal/configuracion-planilla' }
          ],
        },
        {
          label: 'Asistencia y Jornadas',
          link: '/rrhh/asistencias-jornadas',
          subSubMenu: [
            { label: 'Calendarios laborales', link: '/rrhh/asistencias-jornadas/calendarios-laborales' },
            { label: 'Asistencias y horas extra', link: '/rrhh/asistencias-jornadas/asistencias-HE' },
            { label: 'Permisos', link: '/rrhh/asistencias-jornadas/permisos' },
            { label: 'Aprobación de permisos', link: '/rrhh/asistencias-jornadas/aprobacion-permisos' },
            { label: 'Vacaciones y licencias', link: '/rrhh/asistencias-jornadas/vacaciones-licencias' },
            { label: 'Aprobar vacaciones y licencias', link: '/rrhh/asistencias-jornadas/aprobar-vacaciones-licencias' },
          ],
        },
        {
          label: 'Procesos de Nómina',
          link: '/rrhh/procesos-de-nomina/calculo-planillas',
          subSubMenu: [
            { label: 'Conceptos', link: '/rrhh/procesos-de-nomina/conceptos' },
            { label: this.calculodeplanilla, link: '/rrhh/procesos-de-nomina/calculo-planillas' },
            { label: 'Aprobar planilla', link: '/rrhh/procesos-de-nomina/aprobar-planilla' },
            { label: this.registrarliquidacion, link: '/rrhh/procesos-de-nomina/registrar-liquidacion' },
            { label: 'Aprobar liquidación', link: '/rrhh/procesos-de-nomina/aprobar-liquidacion' },
            { label: 'Procesos especiales', link: '/rrhh/procesos-de-nomina/procesos-especiales' },
            { label: 'Provisión de Gasto', link: '/rrhh/procesos-de-nomina/provision-gasto' },
          ],
        },
        {
          label: 'Reportes y Analítica',
          link: '/rrhh/reportes-y-analitica',
          subSubMenu: [
            { label: 'Emisión de Boletas y Planillas', link: '/rrhh/reportes-y-analitica/emision-boletas' },
            { label: 'Distribución de Costos por Centros de Costo y Canal', link: '/rrhh/reportes-y-analitica/distribucion-costos' },
            { label: 'Indicadores de Rotación y Ausentismo', link: '/rrhh/reportes-y-analitica/indicadores-rotacion' },
            { label: 'Generación de archivos regulatorios laborales y tributarios', link: '/rrhh/reportes-y-analitica/generacion-archivos' },
            {label: 'Dashboard de RR.HH', link: '/rrhh/reportes-y-analitica/dashboard-rrhh'},
          ],
        },
        {
          label: 'Parametros generales',
          link: '/rrhh/parametros',
          subSubMenu: [
            { label: 'Configuración de Frecuencia y Calendarios de Pago', link: '/rrhh/parametros/frecuencia-calendarios' },
            { label: 'Registro de Remuneración Mínima por País y Vigencia', link: '/rrhh/parametros/pais-vigencia' },
            // { label: this.cambiartitulo, link: '/rrhh/parametros/parametros-impuestos' },
            { label: 'Generación de Numeración Automática para Documentos del Módulo de RR.HH.', link: '/rrhh/parametros/generacion-numeracion' },
            { label: 'Agrupación de Trabajadores por Sede, Centro de Costo, Canal, Cargo y Salario', link: '/rrhh/parametros/agrupacion-sede' },
            { label: 'Configuración de Provisiones de Gastos de Planillas', link: '/rrhh/parametros/configuracion-provisiones' },
            { label: 'Tipo de contrato', link: '/rrhh/parametros/tipo-contrato' },

          ],
        },
      ],
    },
    {
      key: 'sueldos',
      label: 'Producción',
      icon: ['far', 'box'],
      link: '/produccion',
      exact: true,
      subMenu: [
        {
          label: 'Procesos',
          link: '/produccion/procesos',
          subSubMenu: [
            { 
              label: 'Asignación de gastos indirectos de fabricación', 
              link: '/produccion/procesos/asignacion-gastos-indirectos' 
            },
          ],
        },
      ],
    },
    {
      key: 'config',
      label: 'Configuración',
      icon: ['fas', 'cog'],
      link: '/configuracion',
      exact: true,
      subMenu: [
        {
          label: 'Localización',
          link: '/configuracion/localizacion',
          subSubMenu: [
            {
              label: 'Retenciones',
              link: '/configuracion/localizacion/retenciones',
            },
            {
              label: 'Monedas',
              link: '/configuracion/localizacion/monedas',
            },
            {
              label: 'Ejercicios y Periodos',
              link: '/configuracion/localizacion/ejercicios-periodos', 
            },
            {
              label: 'Cuentas bancarias',
              link: '/configuracion/localizacion/cuenta-bancaria',
            },
            { 
              label: 'Canales de pago y cobro', 
              link: '/configuracion/localizacion/canal-pago-cobro' 
            },
            {
              label: 'Condiciones de pago y cobro',
              link: '/configuracion/localizacion/condiciones-pago-cobro',
            },
            {
              label: 'Formas de pago',
              link: '/configuracion/localizacion/formas-pago',
            },
            {
              label: 'Medios de pago',
              link: '/configuracion/localizacion/medios-pago',
            },
            {
              label: 'Usuarios',
              link: '/configuracion/localizacion/usuarios',
            },
          ],
        },
         {
          label: 'Ajustes',
          link: '/configuracion/ajustes',
          subSubMenu: [
            {
              label: 'Datos Generales de la cuenta',
              link: '/configuracion/ajustes/datos-generales',
            },
            {
              label: 'Plantillas de Notificación para Asignación de Activos',
              link: '/configuracion/ajustes/notificacion-asignacion-activos',
            }
          ],
        },
        {
          label: 'Compañias',
          link: '/configuracion/companias',
          subSubMenu: [
            {
              label: 'Compañias, Sucursales Y Transacciones',
              link: '/configuracion/companias/sucursales-transacciones',
            },
          ],
        },
      ],
    },
  ];
  cambiardemodulo(item: any, parentLabel: string, menuLabel: string) {
    this.selectedSubSubItem = item.label;
    this.selectedSubItem = `${menuLabel}|${parentLabel}`;
    this.selectedMenuItem = menuLabel;
    this.hoveredItem = null; // Cerrar el dropdown
    this.router.navigate([item.link]);
  }
}
