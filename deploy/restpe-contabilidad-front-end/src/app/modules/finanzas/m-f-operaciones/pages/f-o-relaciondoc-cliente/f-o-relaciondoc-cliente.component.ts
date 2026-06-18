import { ChangeDetectorRef, Component, OnInit, inject, Signal, signal, computed } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalDetalleDocEditComponent } from '../../modals/modal-detalle-doc-edit/modal-detalle-doc-edit.component';
import { RelacionDocClienteFacade } from 'src/app/modules/finanzas/application/facades/relaciondoc-cliente.facade';
import { RelacionDocClienteFeedbackEffects } from 'src/app/modules/finanzas/effects/relaciondoc-cliente-feedback.effect';
import { RelacionDocClienteEntity, RelacionDocClienteMap } from 'src/app/modules/finanzas/domain/models/relaciondoc-cliente.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faArrowsRotate, faDollar, faDownload, faFileLines, faMoneyBill, faPercent, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-f-o-relaciondoc-cliente',
  templateUrl: './f-o-relaciondoc-cliente.component.html',
  styleUrls: ['./f-o-relaciondoc-cliente.component.scss'],
  standalone: false,
})
export class FORelaciondocClienteComponent  implements OnInit {
  // ── Clean Architecture ────────────────────────────────────────────
  readonly relacionDocFacade = inject(RelacionDocClienteFacade);
  private readonly _feedbackEffects = inject(RelacionDocClienteFeedbackEffects);
  readonly isLoading: Signal<boolean> = this.relacionDocFacade.isLoading;
  readonly buscando = signal(false);
  readonly loaderActivo = computed(() => this.isLoading() || this.buscando());

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasArrowsRotate = faArrowsRotate;
  fasDollar = faDollar;
  fasDownload = faDownload;
  fasFileLines = faFileLines;
  fasMoneyBill = faMoneyBill;
  fasPercent = faPercent;
  fasRotateRight = faRotateRight;


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
  clienteseleccionado: any = null;
  monedaSeleccionada: string = '';
  estadoSeleccionado: string = '';
  tipoSeleccionado: string[] = [];
  sucursalSeleccionada: string = '';
  centroCSeleccionado: string = '';
  totalDoc: number = 0;
  saldoP: string = '0.00';
  conciliados: number = 0;
  promedioDias: string = '0';
  totalNota: string = '0.00';
  carteraVencida: string = '0.00';
  totalImportePorCobrar: string = '0.00';
  clientes: any[] = [
    { id: 1, nombre: 'Restaurantes La Bella Italia S.A.C.' },
  ];
  context: any;

  // Configuración para Tree Data
  rowGroupPanelShow: "always" | "onlyWhenGrouping" | "never" = 'always';
  treeData = true;
  groupDefaultExpanded = 2; // 0 = todo colapsado, -1 = todo expandido, 2 = expandir hasta nivel 2
  getDataPath = (data: RelacionDocClienteEntity) => data.rcli_org_hierarchy;

  autoGroupColumnDef: ColDef = {
    headerName: 'Tipo de comprobante',
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
    }
  };

  // Función para aplicar clases CSS a las filas
  getRowClass = (params: any) => {
    if (params.data && params.data.rcli_is_tipo) {
      return 'row-main-category';
    } else if (params.data && params.data.rcli_is_cliente) {
      return 'row-total';
    }
    return '';
  };

  localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar'
  };
  columnTypes = {};

  tipoDoc=[
    { id: 'factura', nombre: 'Factura'},
    { id: 'notaC', nombre: 'Nota de crédito'},
    { id: 'notaD', nombre: 'Nota de débito'},
    { id: 'letra', nombre: 'Letra'},
    { id: 'otros', nombre: 'Otros' },
  ]
  
  sucursales = [
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
    { id: 'centrosoporte', nombre: 'Centro de Soporte' }
  ];

  monedaSelect=[
    { id: 'Soles', nombre: 'Soles' },
    { id: 'Dólares', nombre: 'Dólares' },
  ]

  estadoSelect = [
    { id: 'Pendiente', nombre: 'Pendiente' },
    { id: 'Pagado', nombre: 'Pagado' },
    { id: 'Parcial', nombre: 'Parcial' },
    { id: 'Vencido', nombre: 'Vencido' },
  ];

  facturasPorcliente: RelacionDocClienteMap = {};

  rowData: RelacionDocClienteEntity[] = [];

  colDefs: ColDef[] = [
    

    { field: 'rcli_nro_doc', headerName: 'N° de comprobante', width: 150, 
      cellRenderer: (params: any) => {
        if (params.data?.rcli_is_cliente) {
          const ruc = params.data?.rcli_nro_doc || '';
          const docCount = this.countDocumentsByProvider(params.data);
          const docText = docCount ? ` (${docCount} docs.)` : '';
          return `<span>${ruc}</span><span class="text-primary font-bold">${docText}</span>`;
        } else if (params.data?.rcli_is_tipo) {
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
        if (params.data?.rcli_is_tipo || params.data?.rcli_is_cliente) {
          return undefined;
        }
        // Para otros estados, usar el renderer por defecto
        return {
            component: VistaCellRenderComponent,
          };
      },
     },
    { field: 'rcli_fecha_emision', headerName: 'Fecha de emisión', width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    { field: 'rcli_fecha_vencimiento', headerName: 'Fecha de vencimiento', width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    { field: 'rcli_moneda', headerName: 'Moneda', width: 80 },
    { field: 'rcli_monto_total', headerName: 'Monto total', width: 80, headerClass: 'derechaencabezado', 
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',},
      valueFormatter: (params: any) => {
        if (params.value !== null && params.value !== undefined) {
          const formatted = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
          return `S/ ${formatted}`;
        }
        return 'S/ 0.00';
      }
    },
    { field: 'rcli_monto_pagado', headerName: 'Monto cobrado', width: 100, headerClass: 'derechaencabezado', 
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',},
      valueFormatter: (params: any) => {
        if (params.value !== null && params.value !== undefined) {
          const formatted = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
          return `S/ ${formatted}`;
        }
        return 'S/ 0.00';
      }
    },
    { field: 'rcli_monto_pendiente', headerName: 'Monto pendiente', width: 115, headerClass: 'derechaencabezado', 
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',},
      valueFormatter: (params: any) => {
        if (params.value !== null && params.value !== undefined) {
          const formatted = new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(params.value);
          return `S/ ${formatted}`;
        }
        return 'S/ 0.00';
      }
    },
    { field: 'rcli_nro_asiento', headerName: 'N° de asiento', width: 130, 
      cellRendererSelector: (params: any) => {
        if (params.data?.rcli_is_tipo || params.data?.rcli_is_cliente) {
          return undefined;
        }
        // No mostrar asiento para estados Pendiente o Vencido
        if (params.data?.rcli_estado === 'Pendiente' || params.data?.rcli_estado === 'Vencido') {
          return undefined;
        }
        // Para otros estados, usar el renderer por defecto
        return {
            component: VistaCellRenderComponent,
          };
      },
      valueGetter: (params: any) => {
        // Retornar guion para estados Pendiente o Vencido
        if (params.data?.rcli_estado === 'Pendiente' || params.data?.rcli_estado === 'Vencido') {
          return '-';
        }
        return params.data?.rcli_nro_asiento || '';
      }
     },
    { field: 'rcli_sucursal', headerName: 'Sucursal', width: 80, },
    { field: 'rcli_centro_costo', headerName: 'Centro de costos', width: 120, },
    { field: 'rcli_usuario', headerName: 'Usuario de registro', width: 120, },
    { field: 'rcli_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center', },
      cellRenderer: (params: any) => {
        if (params.value === 'Pagado') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagado</span>';
        } else if (params.value === 'Parcial') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">Parcial</span>';
        } else if (params.value === 'Pendiente') {
          return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
        } else if (params.value === 'Vencido') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Vencido</span>';
        }
        return params.value;
      },
    }
  ];

  countDocumentsByProvider(rowData: any): number {
    // Si es un cliente: contar TODOS los documentos hijo
    if (rowData. rcli_is_cliente) {
      const providerName = rowData.rcli_org_hierarchy[0];
      let count = 0;
      
      this.rowData.forEach((row: any) => {
        if (row.rcli_org_hierarchy && row.rcli_org_hierarchy[0] === providerName && 
            !row.rcli_is_tipo && !row. rcli_is_cliente && row.rcli_org_hierarchy.length === 3) {
          count++;
        }
      });
      
      return count;
    }
    
    // Si es un tipo: contar SOLO los documentos hijo de ese tipo
    if (rowData.rcli_is_tipo) {
      const providerName = rowData.rcli_org_hierarchy[0];
      const tipoName = rowData.rcli_org_hierarchy[1];
      let count = 0;
      
      this.rowData.forEach((row: any) => {
        if (row.rcli_org_hierarchy && 
            row.rcli_org_hierarchy[0] === providerName && 
            row.rcli_org_hierarchy[1] === tipoName && 
            !row.rcli_is_tipo && !row. rcli_is_cliente && 
            row.rcli_org_hierarchy.length === 3) {
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
    private cdr: ChangeDetectorRef
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  ngOnInit() {
    this.relacionDocFacade.cargarDatos();

    this.sucursalSeleccionada = '';
    this.centroCSeleccionado = '';
    this.rowData = [];

    // Inicializar fechas vacías
    this.startDateEmision = undefined;
    this.endDateEmision = undefined;
    this.startDateVencimiento = undefined;
    this.endDateVencimiento = undefined;

    // Dejar filtros vacíos por defecto
    this.clienteseleccionado = null;
    this.tipoSeleccionado = [];
    this.monedaSeleccionada = '';
    this.estadoSeleccionado = '';
    this.sucursalSeleccionada = '';
    this.centroCSeleccionado = '';

    this.context = { componentParent: this };
  }

  // Método para verificar si el botón buscar debe estar habilitado
  get isBuscarHabilitado(): boolean {
    return (
      this.clienteseleccionado !== null && this.clienteseleccionado !== '' ||
      (this.tipoSeleccionado && this.tipoSeleccionado.length > 0) ||
      this.monedaSeleccionada !== '' ||
      this.estadoSeleccionado !== '' ||
      this.sucursalSeleccionada !== '' ||
      this.centroCSeleccionado !== '' ||
      (this.startDateEmision !== undefined && this.endDateEmision !== undefined) ||
      (this.startDateVencimiento !== undefined && this.endDateVencimiento !== undefined)
    );
  }


  onBtReset() {
    this.buscando.set(true);
    setTimeout(() => {
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
      }
      this.buscando.set(false);
    }, 400);
  }

  cargarclientesDesdeStorage() {
    const datosGuardados = localStorage.getItem('cliente');
    if (datosGuardados) {
      try {
        const clientesData = JSON.parse(datosGuardados);
        if (Array.isArray(clientesData) && clientesData.length > 0) {
          this.clientes = clientesData.map((p: any, index: number) => ({
            id: p.id || index + 1,
            nombre: p.razonSocial || p.nombre || p.razon_social || ''
          })).filter((p: any) => p.nombre);
        }
      } catch (e) {
        console.error('Error al parsear clientes:', e);
      }
    }

    // Si no hay clientes, cargar datos de ejemplo
    if (this.clientes.length === 0) {
      this.clientes = [
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
  onclienteSeleccionado(cliente: any) {
    this.clienteseleccionado = cliente || '';
  }
  ontipoDocSeleccionado(tipo: any) {
    this.tipoSeleccionado = tipo || '';
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  buscarDoc() {
    this.buscando.set(true);
    this.facturasPorcliente = this.relacionDocFacade.facturasPorCliente();
    setTimeout(() => {
      this.docBuscados = true;

      // Cargar todos los datos sin filtrar
      let todosLosDatos: RelacionDocClienteEntity[] = [];

      // Obtener todos los datos de todos los clientes
      Object.keys(this.facturasPorcliente).forEach(key => {
        todosLosDatos = todosLosDatos.concat(this.facturasPorcliente[key]);
      });

      console.log('Mostrando todos los datos:', todosLosDatos);
      this.rowData = todosLosDatos;

      // Calcular totales
      const facturasFiltradas = todosLosDatos.filter((f: any) => !f.rcli_is_tipo && !f.rcli_is_cliente);
      this.totalDoc = facturasFiltradas.length;

      let totalPendiente = 0;
      facturasFiltradas.forEach((f: any) => {
        totalPendiente += f.rcli_monto_pendiente || 0;
      });
      this.saldoP = totalPendiente.toFixed(2);

      const conciliados = facturasFiltradas.filter((f: any) => f.rcli_estado === 'Pagado' || f.rcli_estado === 'Parcial').length;
      this.conciliados = this.totalDoc > 0 ? Math.round((conciliados / this.totalDoc) * 100) : 0;

      this.buscando.set(false);
    }, 400);
  }

  filtrarFacturasPorReporte() {
    this.facturasPorcliente = this.relacionDocFacade.facturasPorCliente();
    let facturas: RelacionDocClienteEntity[] = [];

    // Obtener las facturas del cliente seleccionado
    if (this.clienteseleccionado) {
      // Si es un objeto, extraer el ID; si es un string, usarlo directamente
      const clienteId = typeof this.clienteseleccionado === 'object'
        ? this.clienteseleccionado.id
        : this.clienteseleccionado;

      const key = String(clienteId);
      const facturascliente = this.facturasPorcliente[key] ?? [];
      facturas = facturas.concat(facturascliente);
      console.log(`Cargando facturas para cliente ${key}:`, facturascliente);
    }

    console.log('Facturas cargadas:', facturas);

    // Filtrar solo los datos (no los nodos del árbol)
    let facturasFilters = facturas.filter((f: any) => !f.rcli_is_tipo && !f.rcli_is_cliente);

    console.log('Facturas antes de filtrar fechas:', facturasFilters);

    // Filtrar por rango de fecha de emisión
    if (this.startDateEmision && this.endDateEmision) {
      facturasFilters = facturasFilters.filter((f: any) => {
        if (!f.rcli_fecha_emision) return true;
        const fechaEmision = new Date(f.rcli_fecha_emision);
        return fechaEmision >= this.startDateEmision! && fechaEmision <= this.endDateEmision!;
      });
    }

    console.log('Facturas después de filtrar fechas de emisión:', facturasFilters);

    // Filtrar por rango de fecha de vencimiento
    if (this.startDateVencimiento && this.endDateVencimiento) {
      facturasFilters = facturasFilters.filter((f: any) => {
        if (!f.rcli_fecha_vencimiento) return true;
        const fechaVencimiento = new Date(f.rcli_fecha_vencimiento);
        return fechaVencimiento >= this.startDateVencimiento! && fechaVencimiento <= this.endDateVencimiento!;
      });
    }

    console.log('Facturas después de filtrar fechas de vencimiento:', facturasFilters);

    // Filtrar por moneda seleccionada (si no es "Todas")
    if (this.monedaSeleccionada && this.monedaSeleccionada !== 'Todas') {
      facturasFilters = facturasFilters.filter((f: any) => {
        return f.rcli_moneda === this.monedaSeleccionada;
      });
    }

    console.log('Facturas después de filtrar monedas:', facturasFilters);

    // Filtrar por estado seleccionado (si no es "Todas")
    if (this.estadoSeleccionado && this.estadoSeleccionado !== 'Todas') {
      facturasFilters = facturasFilters.filter((f: any) => {
        return f.rcli_estado === this.estadoSeleccionado;
      });
    }

    console.log('Facturas después de filtrar estados:', facturasFilters);

    // Reconstruir el árbol con los datos filtrados
    // Pasar todas las facturas (con estructura completa) y los detalles filtrados
    this.reconstruirArbolConFiltros(facturas, facturasFilters);
  }

  reconstruirArbolConFiltros(facturasCompletas: any[], facturasFiltradas: any[]) {
    let datosArbol: any[] = [];

    console.log('Facturas completadas:', facturasCompletas);
    console.log('Facturas filtradas:', facturasFiltradas);

    // Obtener los clientes únicos de las facturas filtradas
    const clientesUnicos = new Set<string>();
    for (const factura of facturasFiltradas) {
      if (factura.rcli_org_hierarchy && factura.rcli_org_hierarchy[0]) {
        clientesUnicos.add(factura.rcli_org_hierarchy[0]);
      }
    }

    console.log('clientes únicos encontrados:', Array.from(clientesUnicos));

    // Para cada cliente, agregar la fila del cliente y los tipos que tienen datos
    for (const factura of facturasCompletas) {
      if (factura.rcli_is_cliente && clientesUnicos.has(factura.rcli_org_hierarchy[0])) {
        datosArbol.push(factura);
        
        // Agregar tipos y sus documentos filtrados
        const tiposDelcliente = facturasCompletas.filter((f: any) => 
          f.rcli_is_tipo && f.rcli_org_hierarchy[0] === factura.rcli_org_hierarchy[0]
        );

        for (const tipo of tiposDelcliente) {
          // Encontrar documentos de este tipo en las facturas filtradas
          const docsDelTipo = facturasFiltradas.filter((f: any) =>
            f.rcli_org_hierarchy[1] === tipo.rcli_org_hierarchy[1] && f.rcli_org_hierarchy[0] === tipo.rcli_org_hierarchy[0]
          );

          if (docsDelTipo.length > 0) {
            datosArbol.push(tipo);
            datosArbol.push(...docsDelTipo);
            console.log(`Tipo ${tipo.rcli_nro_doc}: ${docsDelTipo.length} documentos agregados`);
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
      totalPendiente += f.rcli_monto_pendiente || 0;
    });
    this.saldoP = totalPendiente.toFixed(2);

    // Calcular porcentaje de conciliados
    const conciliados = facturasFiltradas.filter((f: any) => f.rcli_estado === 'Pagado' || f.rcli_estado === 'Parcial').length;
    this.conciliados = this.totalDoc > 0 ? Math.round((conciliados / this.totalDoc) * 100) : 0;

    console.log('Totales calculados:', { totalDoc: this.totalDoc, saldoP: this.saldoP, conciliados: this.conciliados });
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
      parseInt(partes[2]),
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
          estado: rowData.rcli_estado,
          cliente: 'Constructora ABC',
          moneda: rowData.rcli_moneda,
          fechaE: this.formatearFecha(rowData.rcli_fecha_emision),
          montoT: `S/ ${rowData.rcli_monto_total}`,
          fechaV: rowData.rcli_fecha_vencimiento,
          montoP: `S/ ${rowData.rcli_monto_pagado}`,
          centroC: rowData.rcli_centro_costo || 'Administración',
          montoPend: `S/ ${rowData.rcli_monto_pendiente}`,
          sucursal: rowData.rcli_sucursal,
        };

        const modal = await this.modalController.create({
          component: ModalDetalleDocEditComponent,
          cssClass: 'promo2',
          componentProps: {
            tituloModal: `Documento ${numeroDocumento}`,
            detalle: detalle,
            textoBotonSecundario: 'Cancelar',
            modoEdicion: false,
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
    
      const detalleAsiento=[
        { label: 'Fecha de registro', value: '12/12/2025'},
        { label: 'Fecha contable', value: '12/12/2025'},
        { label: 'Glosa', value: 'Provisión de servicios de internet - Local San Isidro (Mes 11/2025).'},
        { label: 'Total', value: 'S/380.00'},
        { label: 'Duplicado', value: 'No'},
      ]
  
      const colDefs: ColDef[] = [
        {  field: 'cuentaContable',  headerName: 'Cuenta',  width: 80 },
        {  field: 'descripcion',  headerName: 'Descripción',  minWidth: 150, flex: 1 ,},
        { field: 'debe', headerName: 'Debe(S/)',  width: 80, headerClass: 'derechaencabezado', 
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',},
          valueFormatter: (params) => {
            if (params.value !== null && params.value !== undefined && params.value !== '') {
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
        { field: 'haber', headerName: 'Haber(S/)', width: 80, headerClass: 'derechaencabezado', 
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center',},
          valueFormatter: (params) => {
            if (params.value !== null && params.value !== undefined && params.value !== '') {
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
        {  field: 'centroC',  headerName: 'Centro de costo',  width: 100 },
        {  field: 'docRef',  headerName: 'Doc. referencial',  width: 100 },
        {  field: 'tercero',  headerName: 'Tercero',  width: 80 },
  
      ];

      const rowDatas = [
        {
          cuentaContable: '631109',
          descripcion: 'Servicios de internet',
          debe: 380.00,
          haber: '',
          centroC: 'CC-S01',
          docRef: 'F001-000123',
          tercero: 'Claro Perú',
        },
        {
          cuentaContable: '421101',
          descripcion: 'Proveedores Nacionales / Cuentas por Pagar Comerciales',
          debe: '',
          haber: 380.00,
          centroC: 'CC-S01',
          docRef: 'F001-000123',
          tercero: 'Claro Perú',
        }
      ]
    
      const modal = await this.modalController.create({
        component: ModalDetalleComponent,
        cssClass: 'promo',
        componentProps: {
          tituloModal: `Asiento ${numeroAsiento}`,
          subtitulomodal: '',
          detalles: detalleAsiento,
          textoBotonConfirmar: 'Cancelar',
          colorBotonConfirmar: 'medium',
          widthModal: '740px',
          mostrarTabla: true,
          mostrarTextarea: false,
          mostrarTotal: true,
           itemstotal: [
          { label: 'Total debe (S/)', value: '380.00' },
          { label: 'Total haber (S/)', value: '112.94' },
        ],
          mostrarBotonEliminar: false,
          mostrarBotonSecundario: false,
          colDefs: colDefs,
          rowData: rowDatas,
        }
      });
  
      await modal.present();
    }

  
}