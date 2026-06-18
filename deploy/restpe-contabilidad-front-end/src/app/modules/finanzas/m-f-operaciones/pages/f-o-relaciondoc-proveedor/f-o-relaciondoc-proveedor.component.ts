import { Component, OnInit, ChangeDetectorRef, inject, Signal, signal, computed } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalDetalleDocComponent } from '../../modals/modal-detalle-doc/modal-detalle-doc.component';
import { ModalDetalleDocEditComponent } from '../../modals/modal-detalle-doc-edit/modal-detalle-doc-edit.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { RelacionDocProveedorFacade } from 'src/app/modules/finanzas/application/facades/relaciondoc-proveedor.facade';
import { RelacionDocProveedorFeedbackEffects } from 'src/app/modules/finanzas/effects/relaciondoc-proveedor-feedback.effect';
import { RelacionDocProveedorEntity, RelacionDocProveedorMap } from 'src/app/modules/finanzas/domain/models/relaciondoc-proveedor.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faArrowsRotate, faDownload, faFileAlt, faFileLines, faMoneyBill, faPrint, faRotateRight } from '@fortawesome/pro-solid-svg-icons';


interface IDocumento {
  rdoc_org_hierarchy: string[];
  rdoc_tipo_doc: string;
  rdoc_nro_doc: string;
  rdoc_cantidad_doc?: number;
  rdoc_fecha_emision: string | Date;
  rdoc_fecha_vencimiento: string | Date;
  rdoc_moneda: string;
  rdoc_monto_total: number;
  rdoc_monto_pagado: number;
  rdoc_monto_pendiente: number;
  rdoc_nro_asiento: string;
  rdoc_sucursal: string;
  rdoc_centro_costo: string;
  rdoc_usuario: string;
  rdoc_estado: string;
  rdoc_is_tipo?: boolean;
  rdoc_is_proveedor?: boolean;
}
@Component({
  selector: 'app-f-o-relaciondoc-proveedor',
  templateUrl: './f-o-relaciondoc-proveedor.component.html',
  styleUrls: ['./f-o-relaciondoc-proveedor.component.scss'],
  standalone: false,
})
export class FORelaciondocProveedorComponent implements OnInit {
  // ── Clean Architecture ───────────────────────────────────────────────────
  readonly relacionDocFacade = inject(RelacionDocProveedorFacade);
  private readonly _feedbackEffects = inject(RelacionDocProveedorFeedbackEffects);
  readonly isLoading: Signal<boolean> = this.relacionDocFacade.isLoading;
  readonly buscando = signal(false);
  readonly loaderActivo = computed(() => this.isLoading() || this.buscando());

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasArrowsRotate = faArrowsRotate;
  fasDownload = faDownload;
  fasFileAlt = faFileAlt;
  fasFileLines = faFileLines;
  fasMoneyBill = faMoneyBill;
  fasPrint = faPrint;
  fasRotateRight = faRotateRight;


  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  //RANGO DE FECHAS
  startDateEmision: Date | undefined;
  endDateEmision: Date | undefined;
  startDateVencimiento: Date | undefined;
  endDateVencimiento: Date | undefined;
  minDate: Date;
  maxDate: Date;

  private gridApi!: GridApi;

  // Variables para el flujo de generación de reporte
  docBuscados: boolean = false;
  proveedorseleccionado: any = null;
  monedaSeleccionada: string = '';
  estadoSeleccionado: string = '';
  tipoSeleccionado: string[] = [];
  sucursalSeleccionada: string = '';
  centroCSeleccionado: string = '';
  totalDoc: number = 0;
  saldoP: string = '0.00';
  conciliados: number = 0;
  proveedores: any[] = [
    { id: 1, nombre: 'ABARROTES ANDINOS S.A.' },
    { id: 2, nombre: 'AHORRA MAS GO S.A.' },
    { id: 3, nombre: 'CASTAGNINO PRODUCTS S.A.' },
    { id: 4, nombre: 'DISTRIBUIDORA ABC S.A.C.' },
  ];
  context: any;

  // Configuración para Tree Data
  treeData = true;
  groupDefaultExpanded = 2;
  getDataPath = (data: RelacionDocProveedorEntity) => data.rdoc_org_hierarchy;

  autoGroupColumnDef: ColDef = {
    headerName: 'Tipo de documento',
    flex: 1,
    minWidth: 200,
    cellRendererParams: {
      suppressCount: true,
      innerRenderer: (params: any) => {
        // Solo mostrar el nombre para nodos padres (grupos)
        if (params.node.group) {
          return params.value || '';
        }
        // Para nodos hoja (documentos), devolver cadena vacía para ocultar
        return '';
      },
    },
  };

  // Función para aplicar clases CSS a las filas (respaldo, el estilo principal va por ag-row-level-N en SCSS)
  rowClassRules = {};

  localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar',
  };
  columnTypes = {};

  tipoDoc = [
    { id: 'factura', nombre: 'Factura' },
    { id: 'notaC', nombre: 'Nota de crédito' },
    { id: 'notaD', nombre: 'Nota de débito' },
    { id: 'letra', nombre: 'Letra' },
    { id: 'otros', nombre: 'Otros' },
  ];

  sucursales = [
    { id: 'todas', nombre: 'Todas las sucursales' },
    { id: 'La Molina, Lima', nombre: 'La Molina, Lima' },
    { id: 'San Isidro, Lima', nombre: 'San Isidro, Lima' },
    { id: 'San Borja, Lima', nombre: 'San Borja, Lima' },
    { id: 'Santa Isabel, Piura', nombre: 'Santa Isabel, Piura' },
  ];

  centrosCosto = [
    { id: 'RRHH', nombre: 'Recursos Humanos' },
    { id: 'oficina', nombre: 'Oficina Administrativa' },
    { id: 'marketing', nombre: 'Marketing' },
    { id: 'operaciones', nombre: 'Operaciones' },
    { id: 'producción', nombre: 'Área de Producción' },
    { id: 'centrosoporte', nombre: 'Centro de Soporte' },
  ];

  monedaSelect = [
    { id: 'Todas', nombre: 'Todas las monedas' },
    { id: 'Soles', nombre: 'Soles' },
    { id: 'Dólares', nombre: 'Dólares' },
  ];

  estadoSelect = [
    { id: 'Todas', nombre: 'Todos los estados' },
    { id: 'Pendiente', nombre: 'Pendiente' },
    { id: 'Pagado', nombre: 'Pagado' },
    { id: 'Compensado', nombre: 'Compensado' },
    { id: 'Anulado', nombre: 'Anulado' },
  ];

  facturasPorProveedor: RelacionDocProveedorMap = {};

  rowData: RelacionDocProveedorEntity[] = [];

  colDefs: ColDef[] = [
    // { field: 'rdoc_tipo_doc', headerName: 'Tipo de documento', width: 150 },
    {
      field: 'rdoc_nro_doc',
      headerName: 'N° de documento',
      width: 150,
      cellRenderer: (params: any) => {
        if (params.data?.rdoc_is_proveedor) {
          const ruc = params.data?.rdoc_nro_doc || '';
          const docCount = this.countDocumentsByProvider(params.data);
          const docText = docCount ? ` (${docCount} docs.)` : '';
          return `<span>${ruc}</span><span class="text-primary font-bold">${docText}</span>`;
        } else if (params.data?.rdoc_is_tipo) {
          const docCount = this.countDocumentsByProvider(params.data);
          const docText = docCount ? ` (${docCount} docs.)` : '';
          return `<span class="font-semibold">${docText}</span>`;
        } else {
          return params.value;
        }
        // Para documentos detalle, usar el renderer por defecto
        return undefined;
      },
      cellRendererSelector: (params: any) => {
        if (params.data?.rdoc_is_tipo || params.data?.rdoc_is_proveedor) {
          return undefined;
        }
        // Para otros estados, usar el renderer por defecto
        return {
          component: VistaCellRenderComponent,
        };
      },
    },
    {
      field: 'rdoc_fecha_emision',
      headerName: 'Fecha de emisión',
      width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      },
    },
    {
      field: 'rdoc_fecha_vencimiento',
      headerName: 'Fecha de vencimiento',
      width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      },
    },
    { field: 'rdoc_moneda', headerName: 'Moneda', width: 80 },
    {
      field: 'rdoc_monto_total',
      headerName: 'Monto total',
      width: 80,
      headerClass: 'derechaencabezado',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      },
      valueFormatter: (params: any) => {
        return `S/ ${params.value}`;
      },
    },
    {
      field: 'rdoc_monto_pagado',
      headerName: 'Monto pagado',
      width: 100,
      headerClass: 'derechaencabezado',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      },
      valueFormatter: (params: any) => {
        return `S/ ${params.value}`;
      },
    },
    {
      field: 'rdoc_monto_pendiente',
      headerName: 'Monto pendiente',
      width: 100,
      headerClass: 'derechaencabezado',
      cellStyle: {
        textAlign: 'right',
        display: 'flex',
        justifyContent: 'right',
        alignItems: 'center',
      },
      valueFormatter: (params: any) => {
        return `S/ ${params.value}`;
      },
    },
    {
      field: 'rdoc_nro_asiento',
      headerName: 'N° de asiento',
      width: 130,
      cellRendererSelector: (params: any) => {
        if (params.data?.rdoc_is_tipo || params.data?.rdoc_is_proveedor) {
          return undefined;
        }
        // Para otros estados, usar el renderer por defecto
        return {
          component: VistaCellRenderComponent,
        };
      },
    },
    { field: 'rdoc_sucursal', headerName: 'Sucursal', width: 80 },
    { field: 'rdoc_centro_costo', headerName: 'Centro de costos', width: 120 },
    { field: 'rdoc_usuario', headerName: 'Usuario de registro', width: 120 },
    {
      field: 'rdoc_estado',
      headerName: 'Estado',
      width: 80,
      headerClass: 'centrarencabezado',
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
      cellRenderer: (params: any) => {
        if (params.value === 'Compensado') {
          return '<span class="badge-table bg-[#D6E6FF] text-primary">Compensado</span>';
        } else if (params.value === 'Pagado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85 !w-16">Pendiente</span>';
        } else if (params.value === 'Anulado') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulado</span>';
        }
        return params.value;
      },
    },
  ];

  countDocumentsByProvider(rowData: any): number {
    // Si es un proveedor: contar TODOS los documentos hijo
    if (rowData.rdoc_is_proveedor) {
      const providerName = rowData.rdoc_org_hierarchy[0];
      let count = 0;

      this.rowData.forEach((row: any) => {
        if (
          row.rdoc_org_hierarchy &&
          row.rdoc_org_hierarchy[0] === providerName &&
          !row.rdoc_is_tipo &&
          !row.rdoc_is_proveedor &&
          row.rdoc_org_hierarchy.length === 3
        ) {
          count++;
        }
      });

      return count;
    }

    // Si es un tipo: contar SOLO los documentos hijo de ese tipo
    if (rowData.rdoc_is_tipo) {
      const providerName = rowData.rdoc_org_hierarchy[0];
      const tipoName = rowData.rdoc_org_hierarchy[1];
      let count = 0;

      this.rowData.forEach((row: any) => {
        if (
          row.rdoc_org_hierarchy &&
          row.rdoc_org_hierarchy[0] === providerName &&
          row.rdoc_org_hierarchy[1] === tipoName &&
          !row.rdoc_is_tipo &&
          !row.rdoc_is_proveedor &&
          row.rdoc_org_hierarchy.length === 3
        ) {
          count++;
        }
      });

      return count;
    }

    return 0;
  }

  constructor(
    private modalController: ModalController,
    private toastService: ToastService,
    private countryService: CountryService,
    private cdr: ChangeDetectorRef
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(
      today.getFullYear() - 1,
      today.getMonth(),
      today.getDate()
    );
  }

  ngOnInit() {
    this.relacionDocFacade.cargarDatos();
    // Sincronizar facturasPorProveedor desde el store cuando cargue
    // (usando el signal en los métodos buscarDoc y filtrarFacturasPorReporte)
    this.sucursalSeleccionada = '';
    this.centroCSeleccionado = '';
    this.rowData = [];

    // Inicializar ambas fechas (emisión y vencimiento) con rango amplio
    const today = new Date();
    const startOfYear = new Date(today.getFullYear(), 0, 1); // 1 de enero
    const endOfYear = new Date(today.getFullYear(), 11, 31); // 31 de diciembre

    this.onFechaEmision({ start: startOfYear, end: endOfYear });
    this.onFechaVencimiento({ start: startOfYear, end: endOfYear });

    // Preseleccionar primer proveedor
    if (this.proveedores && this.proveedores.length > 0) {
      this.proveedorseleccionado = this.proveedores[0].id;
    }

    // Preseleccionar primer tipo de documento
    if (this.tipoDoc && this.tipoDoc.length > 0) {
      this.tipoSeleccionado = [this.tipoDoc[0].id];
    }

    // Inicializar otros filtros con valores por defecto
    this.monedaSeleccionada = 'Todas';
    this.estadoSeleccionado = 'Todas';
    this.sucursalSeleccionada = 'todas';
    if (this.centrosCosto && this.centrosCosto.length > 0) {
      this.centroCSeleccionado = this.centrosCosto[0].id;
    }

    this.context = { componentParent: this };
  }

  onBtReset() {
    this.relacionDocFacade.cargarDatos();
  }

  cargarProveedoresDesdeStorage() {
    const datosGuardados = localStorage.getItem('proveedor');
    if (datosGuardados) {
      try {
        const proveedoresData = JSON.parse(datosGuardados);
        if (Array.isArray(proveedoresData) && proveedoresData.length > 0) {
          this.proveedores = proveedoresData
            .map((p: any, index: number) => ({
              id: p.id || index + 1,
              nombre: p.razonSocial || p.nombre || p.razon_social || '',
            }))
            .filter((p: any) => p.nombre);
        }
      } catch (e) {
        console.error('Error al parsear proveedores:', e);
      }
    }

    // Si no hay proveedores, cargar datos de ejemplo
    if (this.proveedores.length === 0) {
      this.proveedores = [
        { id: 1, nombre: 'ABARROTES ANDINOS S.A.' },
        { id: 2, nombre: 'AHORRA MAS GO S.A.' },
        { id: 3, nombre: 'CASTAGNINO PRODUCTS S.A.' },
      ];
    }
  }

  getFechaHoy(): string {
    return new Date().toISOString().substring(0, 10);
  }

  onCentroCSeleccionado(centroC: any) {
    this.centroCSeleccionado = centroC || '';
  }
  onproveedorSeleccionado(proveedor: any) {
    this.proveedorseleccionado = proveedor || '';
  }
  ontipoDocSeleccionado(tipo: any) {
    this.tipoSeleccionado = tipo || '';
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  buscarDoc() {
    this.buscando.set(true);
    this.facturasPorProveedor = this.relacionDocFacade.facturasPorProveedor();
    setTimeout(() => {
      this.docBuscados = true;

    // Cargar todos los datos sin filtrar
    let todosLosDatos: any[] = [];

    // Obtener todos los datos de todos los proveedores
    Object.keys(this.facturasPorProveedor).forEach((key) => {
      todosLosDatos = todosLosDatos.concat(this.facturasPorProveedor[key]);
    });

    console.log('Mostrando todos los datos:', todosLosDatos);
    this.rowData = todosLosDatos;

    // Calcular totales
    const facturasFiltradas = todosLosDatos.filter(
      (f: any) => !f.rdoc_is_tipo && !f.rdoc_is_proveedor
    );
    this.totalDoc = facturasFiltradas.length;

    let totalPendiente = 0;
    facturasFiltradas.forEach((f: any) => {
      totalPendiente += f.rdoc_monto_pendiente || 0;
    });
    this.saldoP = totalPendiente.toFixed(2);

    const conciliados = facturasFiltradas.filter(
      (f: any) => f.rdoc_estado === 'Compensado' || f.rdoc_estado === 'Pagado'
    ).length;
    this.conciliados =
      this.totalDoc > 0 ? Math.round((conciliados / this.totalDoc) * 100) : 0;

    this.buscando.set(false);
    }, 400);
  }

  filtrarFacturasPorReporte() {
    this.facturasPorProveedor = this.relacionDocFacade.facturasPorProveedor();
    let facturas: RelacionDocProveedorEntity[] = [];

    // Obtener las facturas del proveedor seleccionado
    if (this.proveedorseleccionado) {
      // Si es un objeto, extraer el ID; si es un string, usarlo directamente
      const proveedorId =
        typeof this.proveedorseleccionado === 'object'
          ? this.proveedorseleccionado.id
          : this.proveedorseleccionado;

      const key = String(proveedorId);
      const facturasProveedor = this.facturasPorProveedor[key] ?? [];
      facturas = facturas.concat(facturasProveedor);
      console.log(
        `Cargando facturas para proveedor ${key}:`,
        facturasProveedor
      );
    }

    console.log('Facturas cargadas:', facturas);

    // Filtrar solo los datos (no los nodos del árbol)
    let facturasFilters = facturas.filter(
      (f: any) => !f.rdoc_is_tipo && !f.rdoc_is_proveedor
    );

    console.log('Facturas antes de filtrar fechas:', facturasFilters);

    // Filtrar por rango de fecha de emisión
    if (this.startDateEmision && this.endDateEmision) {
      facturasFilters = facturasFilters.filter((f: any) => {
        if (!f.rdoc_fecha_emision) return true; // Si no tiene fecha, no filtrar
        const fechaEmision = new Date(f.rdoc_fecha_emision);
        return (
          fechaEmision >= this.startDateEmision! &&
          fechaEmision <= this.endDateEmision!
        );
      });
    }

    console.log(
      'Facturas después de filtrar fechas de emisión:',
      facturasFilters
    );

    // Filtrar por rango de fecha de vencimiento
    if (this.startDateVencimiento && this.endDateVencimiento) {
      facturasFilters = facturasFilters.filter((f: any) => {
        if (!f.rdoc_fecha_vencimiento) return true; // Si no tiene fecha, no filtrar
        const fechaVencimiento = new Date(f.rdoc_fecha_vencimiento);
        return (
          fechaVencimiento >= this.startDateVencimiento! &&
          fechaVencimiento <= this.endDateVencimiento!
        );
      });
    }

    console.log(
      'Facturas después de filtrar fechas de vencimiento:',
      facturasFilters
    );

    // Filtrar por moneda seleccionada (si no es "Todas")
    if (this.monedaSeleccionada && this.monedaSeleccionada !== 'Todas') {
      facturasFilters = facturasFilters.filter((f: any) => {
        return f.rdoc_moneda === this.monedaSeleccionada;
      });
    }

    console.log('Facturas después de filtrar monedas:', facturasFilters);

    // Filtrar por estado seleccionado (si no es "Todas")
    if (this.estadoSeleccionado && this.estadoSeleccionado !== 'Todas') {
      facturasFilters = facturasFilters.filter((f: any) => {
        return f.rdoc_estado === this.estadoSeleccionado;
      });
    }

    console.log('Facturas después de filtrar estados:', facturasFilters);

    // Reconstruir el árbol con los datos filtrados
    // Pasar todas las facturas (con estructura completa) y los detalles filtrados
    this.reconstruirArbolConFiltros(facturas, facturasFilters);
  }

  reconstruirArbolConFiltros(
    facturasCompletas: any[],
    facturasFiltradas: any[]
  ) {
    let datosArbol: any[] = [];

    console.log('Facturas completadas:', facturasCompletas);
    console.log('Facturas filtradas:', facturasFiltradas);

    // Obtener los proveedores únicos de las facturas filtradas
    const proveedoresUnicos = new Set<string>();
    for (const factura of facturasFiltradas) {
      if (factura.rdoc_org_hierarchy && factura.rdoc_org_hierarchy[0]) {
        proveedoresUnicos.add(factura.rdoc_org_hierarchy[0]);
      }
    }

    console.log(
      'Proveedores únicos encontrados:',
      Array.from(proveedoresUnicos)
    );

    // Para cada proveedor, agregar la fila del proveedor y los tipos que tienen datos
    for (const factura of facturasCompletas) {
      if (
        factura.rdoc_is_proveedor &&
        proveedoresUnicos.has(factura.rdoc_org_hierarchy[0])
      ) {
        datosArbol.push(factura);

        // Agregar tipos y sus documentos filtrados
        const tiposDelProveedor = facturasCompletas.filter(
          (f: any) => f.rdoc_is_tipo && f.rdoc_org_hierarchy[0] === factura.rdoc_org_hierarchy[0]
        );

        for (const tipo of tiposDelProveedor) {
          // Encontrar documentos de este tipo en las facturas filtradas
          const docsDelTipo = facturasFiltradas.filter(
            (f: any) =>
              f.rdoc_org_hierarchy[1] === tipo.rdoc_org_hierarchy[1] &&
              f.rdoc_org_hierarchy[0] === tipo.rdoc_org_hierarchy[0]
          );

          if (docsDelTipo.length > 0) {
            datosArbol.push(tipo);
            datosArbol.push(...docsDelTipo);
            console.log(
              `Tipo ${tipo.rdoc_nro_doc}: ${docsDelTipo.length} documentos agregados`
            );
          }
        }
      }
    }

    console.log('Datos del árbol final:', datosArbol);
    this.rowData = datosArbol;

    // Calcular totales
    this.totalDoc = facturasFiltradas.length;

    let totalPendiente = 0;
    facturasFiltradas.forEach((f: any) => {
      totalPendiente += f.rdoc_monto_pendiente || 0;
    });
    this.saldoP = totalPendiente.toFixed(2);

    // Calcular porcentaje de conciliados
    const conciliados = facturasFiltradas.filter(
      (f: any) => f.rdoc_estado === 'Compensado' || f.rdoc_estado === 'Pagado'
    ).length;
    this.conciliados =
      this.totalDoc > 0 ? Math.round((conciliados / this.totalDoc) * 100) : 0;

    console.log('Totales calculados:', {
      totalDoc: this.totalDoc,
      saldoP: this.saldoP,
      conciliados: this.conciliados,
    });
  }

  onFechaEmision(range: { start: Date; end: Date }) {
    this.startDateEmision = range.start;
    this.endDateEmision = range.end;
  }

  onFechaVencimiento(range: { start: Date; end: Date }) {
    this.startDateVencimiento = range.start;
    this.endDateVencimiento = range.end;
  }
  formatearFecha(fecha: string): string {
    if (!fecha) return '-';

    const [año, mes, dia] = fecha.split('-');
    return `${dia}/${mes}/${año}`;
  }
  parsearFecha(fechaStr: string): Date {
    const partes = fechaStr.split('-');
    return new Date(
      parseInt(partes[0]),
      parseInt(partes[1]) - 1,
      parseInt(partes[2])
    );
  }

  async abrirModal(value: any, rowData: any) {
    console.log('Abriendo modal para:', value, rowData);

    // Determinar si es documento o asiento basándose en el valor
    const esDocumento = value.includes('F') || value.includes('NC');
    const esAsiento = value.includes('MN') || value.includes('ASC');

    if (esDocumento) {
      await this.abrirModalDocumento(value, rowData);
    } else if (esAsiento) {
      await this.abrirModalAsiento(value, rowData);
    }
  }

  async abrirModalDocumento(numeroDocumento: string, rowData: any) {
    const detalle = {
      razonS: 'Constructora ABC S.A.C.',
      estado: rowData.rdoc_estado,
      proveedor: 'Constructora ABC',
      moneda: rowData.rdoc_moneda,
      fechaE: this.formatearFecha(rowData.rdoc_fecha_emision),
      montoT: `S/ ${rowData.rdoc_monto_total}`,
      fechaV: rowData.rdoc_fecha_vencimiento,
      montoP: `S/ ${rowData.rdoc_monto_pagado}`,
      centroC: rowData.rdoc_centro_costo || 'Administración',
      montoPend: `S/ ${rowData.rdoc_monto_pendiente}`,
      sucursal: rowData.rdoc_sucursal,
    };

    const modal = await this.modalController.create({
      component: ModalDetalleDocEditComponent,
      cssClass: 'promo2',
      componentProps: {
        tituloModal: `Información del documento ${numeroDocumento}`,
        detalle: detalle,
        textoBotonPrimario: 'Guardar cambios',
        textoBotonSecundario: 'Cancelar',
        modoEdicion: true,
      },
    });

    await modal.present();
    const { data } = await modal.onDidDismiss();

    if (data) {
      if (data.accion === 'primaria') {
        setTimeout(() => {
          this.toastService.success(`¡Cambios guardados exitosamente!`);
        }, 100);
      }
    }
  }

  async abrirModalAsiento(numeroAsiento: string, rowData: any) {
    const detalleAsiento = [
      { label: 'Fecha de registro', value: '12/12/2025' },
      { label: 'Fecha contable', value: '12/12/2025' },
      { label: 'Total', value: 'S/380.00' },
      { label: 'Duplicado', value: 'No' },
    ];
    const detalleEditable = {
      label: 'Glosa',
      value:
        'Provisión de servicios de internet - Local San Isidro (Mes 11/2025).',
    };

    const colDefs: ColDef[] = [
      { field: 'cuentaContable', headerName: 'Cuenta', width: 80 },
      {
        field: 'descripcion',
        headerName: 'Descripción',
        minWidth: 150,
        flex: 1,
      },
      {
        field: 'debe',
        headerName: 'Debe(S/)',
        width: 80,
        headerClass: 'derechaencabezado',
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'right',
          alignItems: 'center',
        },
        valueFormatter: (params) => {
          if (
            params.value !== null &&
            params.value !== undefined &&
            params.value !== ''
          ) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);

            // Si es negativo, mostrar entre paréntesis
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return `S/ ${formattedValue}`;
          }
          return '-';
        },
      },
      {
        field: 'haber',
        headerName: 'Haber(S/)',
        width: 80,
        headerClass: 'derechaencabezado',
        cellStyle: {
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'right',
          alignItems: 'center',
        },
        valueFormatter: (params) => {
          if (
            params.value !== null &&
            params.value !== undefined &&
            params.value !== ''
          ) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);

            // Si es negativo, mostrar entre paréntesis
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return `S/${formattedValue}`;
          }
          return '-';
        },
      },
      { field: 'centroC', headerName: 'Centro de costo', width: 100 },
      { field: 'docRef', headerName: 'Documento referencial', width: 100 },
      { field: 'tercero', headerName: 'Tercero', width: 80 },
    ];

    const rowDatas = [
      {
        cuentaContable: '631109',
        descripcion: 'Servicios de internet',
        debe: 380.0,
        haber: '',
        centroC: 'CC-S01',
        docRef: 'F001-000123',
        tercero: 'Claro Perú',
      },
      {
        cuentaContable: '421101',
        descripcion: 'Proveedores Nacionales / Cuentas por Pagar Comerciales',
        debe: '',
        haber: 380.0,
        centroC: 'CC-S01',
        docRef: 'F001-000123',
        tercero: 'Claro Perú',
      },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento ${numeroAsiento}`,
        subtitulomodal: '',
        textareaWidth: 'w-2/3',
        detalles: detalleAsiento,
        detalleEdit: detalleEditable,
        textoBotonSecundario: 'Revertir asiento',
        textoBotonConfirmar: 'Guardar cambios',
        colorBotonConfirmar: 'primary',
        mostrarTabla: true,
        widthModal: '740px',
        mostrarTextarea: false,
        mostrarTotal: true,
        itemstotal: [
          { label: 'Total debe (S/)', value: '380.00' },
          { label: 'Total haber (S/)', value: '112.94' },
        ],
        mostrarBotonEliminar: true,
        mostrarBotonSecundario: true,
        colDefs: colDefs,
        rowData: rowDatas,
      },
    });

    await modal.present();
    const { data } = await modal.onDidDismiss();

    if (data) {
      if (data.action === 'confirmar') {
        setTimeout(() => {
          this.toastService.success('¡Cambios guardados exitosamente!');
        }, 100);
      } else if (data.action === 'secundario') {
        this.revertirAsiento(numeroAsiento, rowData);
      }
    }
  }

  async revertirAsiento(numeroAsiento: string, rowData: any) {
    const detalleAsiento = [
      { label: 'Fecha de registro', value: '12/12/2025' },
      { label: 'Fecha contable', value: '12/12/2025' },
      {
        label: 'Glosa',
        value:
          'Provisión de servicios de internet - Local San Isidro (Mes 11/2025).',
      },
      { label: 'Total', value: 'S/380.00' },
      { label: 'Duplicado', value: 'No' },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Reversión de Asiento ${numeroAsiento}`,
        subtitulomodal: 'Detalle del asiento',
        tituloTextarea: 'Motivo de reversión',
        detalles: detalleAsiento,
        textoBotonConfirmar: 'Revertir',
        colorBotonConfirmar: 'primary',
        mostrarTabla: false,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        motivoObligatorio: true,
      },
    });

    await modal.present();
    const { data } = await modal.onDidDismiss();

    if (data) {
      if (data.action === 'confirmar') {
        setTimeout(() => {
          this.toastService.success(
            `¡Asiento revertido exitosamente!`,
            `Nuevo asiento: RA-${numeroAsiento}`
          );
        }, 100);
      }
    }
  }
}
