import { Component, OnInit, ViewChild, inject, effect, computed } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { DetalleItem, ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GridExportService } from 'src/app/core/infrastructure/export/grid-export.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { FileUploadComponent } from 'src/app/ui/file-upload/file-upload.component';
import { NotaCreditoFacade } from 'src/app/modules/compras/application/facades/nota-credito.facade';
import { NotaCreditoFeedbackEffects } from 'src/app/modules/compras/effects/nota-credito-feedback.effect';
import { NotaCreditoSyncEffects } from 'src/app/modules/compras/effects/nota-credito-sync.effect';
import { NotaCreditoEntity } from 'src/app/modules/compras/domain/models/nota-credito.entity';
import { ProveedorFacade } from 'src/app/modules/compras/application/facades/proveedor.facade';
import { FacturaProveedorFacade } from 'src/app/modules/compras/application/facades/factura-proveedor.facade';
import { FacturaProveedorEntity } from 'src/app/modules/compras/domain/models/factura-proveedor.entity';
import { ApiClientService } from 'src/app/core/infrastructure/http/api-client.service';
import { catchError, of } from 'rxjs';

type INotaCredito = NotaCreditoEntity;

// Font Awesome Icons
import { faBook, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-compras-operaciones-notas-credito',
  templateUrl: './compras-operaciones-notas-credito.component.html',
  styleUrls: ['./compras-operaciones-notas-credito.component.scss'],
  standalone: false,
})
export class ComprasOperacionesNotasCreditoComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearchRegular;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;
  fasSearch = faSearchSolid;

  // Clean Architecture - Facade
  private readonly notaCreditoFacade = inject(NotaCreditoFacade);
  private readonly feedbackEffects = inject(NotaCreditoFeedbackEffects);
  private readonly syncEffects = inject(NotaCreditoSyncEffects);
  private readonly proveedorFacade = inject(ProveedorFacade);
  private readonly facturaProveedorFacade = inject(FacturaProveedorFacade);
  private readonly api = inject(ApiClientService);
  private readonly gridExport = inject(GridExportService);

  // Catálogos reales para el registro de la nota
  conceptosFinancieros: { id: number; nombre: string }[] = [];
  tiposImpuestoCatalogo: { id: number; nombre: string; tasa: number }[] = [];
  centrosCosto: { id: number; nombre: string }[] = [];
  /** Proveedor resuelto vía búsqueda por RUC (directo del API). */
  proveedorResuelto: { id?: number; razonSocial?: string; nroDocumento?: string } | null = null;

  // Señales expuestas desde el store
  readonly isLoadingObtener = computed(() => this.notaCreditoFacade.loadingObtener());
  readonly isLoadingGuardar = computed(() => this.notaCreditoFacade.loadingGuardar());
  readonly isLoadingEliminar = computed(() => this.notaCreditoFacade.loadingEliminar());



  //RANGO DE FECHAS

  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  //FECHAS ÚNICAS (SINGLE)
  fechaEmisionNota: Date | undefined;
  fechaRegistroNota: Date | undefined;
  habilitareditarnotacredito: boolean = false;
  habilitareditarnotadebito: boolean = false;

  estadoSeleccionado: string = '';
  tipoSeleccionado: string = 'registro';
  /** Fuente completa de notas (sin filtrar por fecha). */
  private notasFuente: any[] = [];
  mostrartabla = true;
  desactivarcampos: boolean = false;
  private gridApi!: GridApi;
  private gridApiProductos!: GridApi;
  NotaCreditoForm!: FormGroup;
  documentoSoporte: string = '';
  filaSeleccionada: INotaCredito | null = null;
  esNuevoRegistro: boolean = true;

  @ViewChild(FileUploadComponent) fileUploadComponent!: FileUploadComponent;

  // Control de visibilidad de campos
  mostrarFacturaAfectada: boolean = false;
  mostrarCuentaYTotal: boolean = false;
  proveedorSeleccionado: any = null;

  countries = ALL_COUNTRIES;
  tiposIdentificacion: any[] = [];

  tipoFs = [
    { value: 'registro', nombre: 'De registro' },
    { value: 'emision', nombre: 'De emisión' },
  ]

  // Dataset único: Documento fiscal -> Razón social -> Facturas (cada una con productos distintos)
  proveedores: Array<{ nombre: string; ruc: string; dni: string; facturas: Array<{ id: string; productos: any[] }> }> = [];

  // Array formateado para autocomplete de proveedores
  proveedoresAutocomplete: Array<{ id: string; nombre: string }> = [];

  facturasDisponibles: string[] = [];
  facturasProveedorActual: Array<{ id: string; productos: any[] }> = [];
  todasLasFacturas: FacturaProveedorEntity[] = [];

  // Arrays para autocompletes
  facturasAutocomplete: any[] = [];
  cuentasContables = [
    { id: '42111', nombre: '42111 - Facturas por pagar' },
    { id: '42112', nombre: '42112 - Facturas por pagar - Anticipos' },
    { id: '42121', nombre: '42121 - Letras por pagar' },
    { id: '42131', nombre: '42131 - Otras cuentas por pagar' },
    { id: '46111', nombre: '46111 - Cuentas por pagar diversas' },
    { id: '46911', nombre: '46911 - Otras cuentas por pagar' }
  ];

  // Arrays para los selects
  tiposDocumento = [
    { value: 'DNI', label: 'DNI' },
    { value: 'RUC', label: 'RUC' }
  ];

  monedas = [
    { value: 'Soles', label: 'Soles' },
    { value: 'Dólares', label: 'Dólares' },
  ];

  tiposAjuste = [
    { value: 'Nota de crédito', label: 'Nota de crédito' },
    { value: 'Nota de débito', label: 'Nota de débito' }
  ];

  motivosAjuste = [
    { value: 'Error en facturación', label: 'Error en facturación' },
    { value: 'Devolución de mercadería', label: 'Devolución de mercadería' },
    { value: 'Descuento comercial', label: 'Descuento comercial' },
    { value: 'Bonificación', label: 'Bonificación' },
    { value: 'Anulación de operación', label: 'Anulación de operación' },
    { value: 'Otro motivo', label: 'Otro motivo' }
  ];

  colDefs: ColDef[] = [
    { field: 'nota_credito_codigo', headerName: 'Código', flex: 1, minWidth: 90 },
    { field: 'nota_credito_tipo', headerName: 'Tipo', flex: 0.8, minWidth: 80, filter: true },
    { field: 'nota_credito_serie', headerName: 'Serie', flex: 0.7, minWidth: 70 },
    { field: 'nota_credito_numero', headerName: 'Número', flex: 0.9, minWidth: 90 },
    { field: 'nota_credito_responsable', headerName: 'Responsable', flex: 1.5, minWidth: 120 },
    { field: 'nota_credito_fecha_emision', headerName: 'Fecha de emisión', flex: 1, minWidth: 120,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    { field: 'nota_credito_fecha_registro', headerName: 'Fecha de registro', flex: 1, minWidth: 120,
      valueFormatter: (params) => {
        if (params.value) {
          const date = new Date(params.value + 'T00:00:00');
          return date.toLocaleDateString('es-PE');
        }
        return '';
      }
     },
    { field: 'nota_credito_proveedor', headerName: 'Proveedor', flex: 2, minWidth: 150, filter: true, },
    { field: 'nota_credito_factura_afectada', headerName: 'Factura afectada', flex: 1.2, minWidth: 110 },
    {
      headerClass: 'centrarencabezado',
      field: 'nota_credito_estado',
      headerName: 'Estado',
      flex: 1,
      filter: true,
      minWidth: 100,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let badgeClass = '';

        switch (estado) {
          case 'Aplicado':
            badgeClass = 'bg-green-100 text-green-600';
            break;
          // case 'Registrada':
          //   badgeClass = 'bg-[#FFF0BF] text-[#F2A626]';
          //   break;
          // case 'Anulada':
          //   badgeClass = 'bg-red-100 text-red-600';
          //   break;
          default:
            badgeClass = 'bg-[#F5F5F5] text-[#363636]';
        }

        return `
        <div class="badge-table ${badgeClass}"> 
        <span class="">${estado}</span>
        </div>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    }
  ];

  rowData: INotaCredito[] = [];

  private readonly columnasExport = [
    { header: 'Código', field: 'nota_credito_codigo' },
    { header: 'Tipo', field: 'nota_credito_tipo' },
    { header: 'Serie', field: 'nota_credito_serie' },
    { header: 'Número', field: 'nota_credito_numero' },
    { header: 'Responsable', field: 'nota_credito_responsable' },
    { header: 'Fecha de emisión', field: 'nota_credito_fecha_emision' },
    { header: 'Proveedor', field: 'nota_credito_proveedor' },
    { header: 'Factura afectada', field: 'nota_credito_factura_afectada' },
    { header: 'Estado', field: 'nota_credito_estado' },
  ];

  async exportarExcel(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.rowData) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toastService.warning('No hay notas para exportar');
      return;
    }
    await this.gridExport.exportarExcel(
      `notas-credito-debito-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
      'Notas',
    );
  }

  async exportarPdf(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.rowData) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toastService.warning('No hay notas para exportar');
      return;
    }
    await this.gridExport.exportarPdf(
      'Notas de crédito / débito',
      `notas-credito-debito-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
    );
  }

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    }
  };

  // Configuración del grid de detalle de la nota (líneas financieras)
  colDefsProductos: ColDef[] = [
    { headerName: '', checkboxSelection: true, headerCheckboxSelection: true, width: 40, pinned: 'left', lockPosition: true },
    {
      field: 'conceptoFinancieroNombre', headerName: 'Concepto financiero', flex: 1.3, minWidth: 150,
      editable: true, cellStyle: { cursor: 'pointer' },
      cellEditor: 'agRichSelectCellEditor',
      cellEditorParams: () => ({
        values: this.conceptosFinancieros.map((c) => c.nombre),
        searchType: 'matchAny',
        filterList: true,
        allowTyping: true,
      }),
    },
    { field: 'descripcion', headerName: 'Descripción', flex: 1.5, minWidth: 180, editable: true },
    { field: 'cantidad', headerName: 'Cantidad', width: 100, editable: true, type: 'numericColumn' },
    {
      field: 'precioUnitario', headerName: 'Precio unit.', width: 110, editable: true, type: 'numericColumn',
      valueFormatter: (p) => (p.value != null ? Number(p.value).toFixed(2) : ''),
    },
    {
      field: 'impuestos', headerName: 'Impuesto', flex: 1, minWidth: 120, editable: true,
      cellEditor: 'agRichSelectCellEditor',
      cellEditorParams: () => ({
        values: this.tiposImpuestoCatalogo.map((t) => t.nombre),
        searchType: 'matchAny',
        filterList: true,
        allowTyping: true,
      }),
    },
    {
      field: 'monto', headerName: 'Monto', width: 120, type: 'numericColumn',
      headerClass: 'derechaencabezado',
      valueFormatter: (params) => {
        if (params.value !== null && params.value !== undefined) {
          return new Intl.NumberFormat('es-PE', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2,
          }).format(Number(params.value));
        }
        return '';
      },
      cellStyle: { justifyContent: 'end' },
    },
  ];

  rowDataProductos: any[] = [];

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

  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private formValidationService: FormValidationService,
    private countryService: CountryService,
    private toastService: ToastService
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    // Inicializar fecha de registro con la fecha actual
    this.fechaRegistroNota = today;

    // Sincronizar rowData con el store via effect
    effect(() => {
      const notas = this.notaCreditoFacade.notas();
      this.notasFuente = [...notas];
      this.aplicarFiltroFechas();
    });

    // Sincronizar proveedores desde el store via effect
    effect(() => {
      const proveedoresStore = this.proveedorFacade.proveedores();
      this.proveedores = proveedoresStore.map(p => ({
        nombre: p.proveedor_razon_social,
        ruc: p.proveedor_identificacion_fiscal?.length === 11 ? p.proveedor_identificacion_fiscal : '',
        dni: p.proveedor_identificacion_fiscal?.length === 8 ? p.proveedor_identificacion_fiscal : '',
        facturas: []
      }));
      this.proveedoresAutocomplete = this.proveedores.map(p => ({
        id: p.ruc || p.dni,
        nombre: p.nombre
      }));
    });

    // Sincronizar facturas desde el store via effect
    effect(() => {
      this.todasLasFacturas = this.facturaProveedorFacade.facturas();
    });
  }

  ngOnInit() {
    this.docpais();
    this.NotaCreditoForm = this.formBuilder.group({
      proveedor: [''],
      fechaEmisionNota: [''],
      fechaReg: [this.fechaHoyISO()],
      moneda: ['Soles'],
      centroCostoId: [''],
      facturaafectada: [''],
      tipoAjuste: ['nota-credito'],
      estado: 'Pendiente',
      subtotal: [''],
      motivoAjuste: ['Error en facturación'],
      descripcionDetallada: [''],
      serieNumero: [''],
      serie: [''],
      numero: [''],
      cuentaContable: [''],
      porcentajeAjuste: [''],
      montoAjuste: [''],
      inputproveedor: [''],
      documentoproveedor: [this.tiposIdentificacion[0]?.value],
      documentoproveedorinput: [''],
      impuesto: [''],
      totalAjuste: [''],
      archivo: ['']
    });
    this.NotaCreditoForm.get('fechaReg')?.disable();
    this.NotaCreditoForm.get('estado')?.disable();

    // Inicializar FormValidationService
    this.formValidationService.inicializarFormulario(this.NotaCreditoForm);
    this.formValidationService.resetearEstado();

    // Suscribirse a cAambios en el campo de proveedor
    this.NotaCreditoForm.get('inputproveedor')?.valueChanges.subscribe(nombreProveedor => {
      this.actualizarFacturasDisponibles(nombreProveedor);
    });

    // Verificar valor inicial de tipoAjuste
    const tipoAjusteInicial = this.NotaCreditoForm.get('tipoAjuste')?.value;
    if (tipoAjusteInicial === 'nota-credito') {
      this.habilitareditarnotacredito = true;
      this.habilitareditarnotadebito = false;
    } else if (tipoAjusteInicial === 'nota-debito') {
      this.habilitareditarnotacredito = false;
      this.habilitareditarnotadebito = true;
    }

    // Suscribirse a cambios en el tipo de ajuste
    this.NotaCreditoForm.get('tipoAjuste')?.valueChanges.subscribe(tipoAjuste => {
      if (tipoAjuste === 'nota-credito') {
        this.habilitareditarnotacredito = true;
        this.habilitareditarnotadebito = false;
      } else if (tipoAjuste === 'nota-debito') {
        this.habilitareditarnotacredito = false;
        this.habilitareditarnotadebito = true;
      }
      // Actualizar las columnas del grid
      this.actualizarColumnasGrid();
    });

    // Cargar notas desde el store (JSON via repositorio)
    this.cargarNotasDesdeStore();

    // NOTA: No se precarga la lista completa de proveedores (patrón N+1 que congela
    // la pantalla). El proveedor se resuelve por RUC bajo demanda en buscarproveedor().

    // Cargar facturas para el autocomplete de "Factura asociada"
    this.facturaProveedorFacade.cargarFacturas();

    // Cargar catálogos reales (conceptos financieros e impuestos) para el detalle
    this.cargarCatalogosNota();
  }

  /**
   * Carga los catálogos reales para el detalle de la nota:
   * conceptos financieros (ms-finanzas) e impuestos (ms-core-maestros).
   */
  private cargarCatalogosNota(): void {
    this.api
      .get<any>('/finanzas/conceptos-financieros', { page: 0, size: 200 })
      .pipe(catchError(() => of(null)))
      .subscribe((response) => {
        const lista = Array.isArray(response) ? response : response?.content ?? [];
        this.conceptosFinancieros = lista
          .filter((c: any) => c?.flagEstado !== '0')
          .map((c: any) => ({ id: Number(c.id), nombre: c.nombre ?? c.codigo ?? `Concepto ${c.id}` }));
      });

    this.api
      .get<any[]>('/core/impuestos')
      .pipe(catchError(() => of([])))
      .subscribe((response) => {
        const lista = Array.isArray(response) ? response : [];
        this.tiposImpuestoCatalogo = lista
          .filter((t: any) => t?.flagEstado !== '0')
          .map((t: any) => ({
            id: Number(t.id),
            nombre: t.descImpuesto ?? t.tipoImpuesto ?? `Impuesto ${t.id}`,
            tasa: Number(t.tasaImpuesto ?? 0),
          }));
      });

    // Centros de costo: GET /contabilidad/centros-costo (lista paginada)
    this.api
      .get<any>('/contabilidad/centros-costo', { page: 0, size: 1000 })
      .pipe(catchError(() => of(null)))
      .subscribe((response) => {
        const lista = Array.isArray(response) ? response : response?.content ?? response?.data ?? [];
        this.centrosCosto = lista
          .filter((c: any) => c?.flagEstado !== '0' && c?.activo !== false)
          .map((c: any) => {
            const nombre = c.descCencos ?? c.nombre ?? c.centro_costo_nombre ?? c.descripcion ?? c.cencos ?? '';
            return {
              id: Number(c.id),
              nombre: String(nombre) || `Centro ${c.id}`,
            };
          });
      });
  }

  /** Resuelve el id del centro de costo a partir del nombre mostrado en la grilla. */
  private resolverCentroCostoId(valor: unknown): number | null {
    if (valor == null || valor === '') {
      return null;
    }
    const texto = String(valor).trim().toLowerCase();
    const porNombre = this.centrosCosto.find((c) => c.nombre.trim().toLowerCase() === texto);
    if (porNombre) {
      return porNombre.id;
    }
    const num = Number(valor);
    return Number.isNaN(num) ? null : num;
  }

  /** Resuelve el id del concepto financiero a partir del nombre de la línea. */
  private resolverConceptoFinancieroId(nombre: unknown): number {
    const texto = String(nombre ?? '').trim().toLowerCase();
    const encontrado = this.conceptosFinancieros.find((c) => c.nombre.trim().toLowerCase() === texto);
    return encontrado?.id ?? this.conceptosFinancieros[0]?.id ?? 0;
  }

  /** Resuelve el id del tipo de impuesto a partir del texto de la línea. */
  private resolverTipoImpuestoId(impuestos: unknown): number {
    const texto = String(impuestos ?? '').trim().toLowerCase();
    if (texto) {
      const encontrado = this.tiposImpuestoCatalogo.find(
        (t) => texto.includes(t.nombre.trim().toLowerCase()) || (t.tasa > 0 && texto.includes(String(t.tasa)))
      );
      if (encontrado) {
        return encontrado.id;
      }
    }
    return this.tiposImpuestoCatalogo[0]?.id ?? 1;
  }

  /** Tasa numérica (0-1) del impuesto seleccionado en una línea. */
  private calcularTasaImpuesto(impuestos: unknown): number {
    const texto = String(impuestos ?? '').trim().toLowerCase();
    if (!texto) return 0;
    const cat = this.tiposImpuestoCatalogo.find(
      (t) => texto.includes(t.nombre.trim().toLowerCase()) || (t.tasa > 0 && texto.includes(String(t.tasa)))
    );
    if (cat) {
      return cat.tasa > 1 ? cat.tasa / 100 : cat.tasa;
    }
    return 0;
  }

  /** Agrega una línea vacía al detalle de la nota. */
  agregarLineaDetalle() {
    const nueva = {
      conceptoFinancieroNombre: this.conceptosFinancieros[0]?.nombre ?? '',
      descripcion: '',
      cantidad: 1,
      precioUnitario: 0,
      centros_costo_id: 1,
      impuestos: this.tiposImpuestoCatalogo[0]?.nombre ?? '',
      monto: 0,
      articuloId: null,
    };
    this.rowDataProductos = [...this.rowDataProductos.filter((r) => r && typeof r === 'object'), nueva];
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.rowDataProductos);
    }
    this.recalcularTotalAjuste();
  }

  /** Recalcula monto de la línea editada y el total del ajuste. */
  onCellValueChangedProductos(event: any) {
    const row = event?.data;
    if (!row) return;
    const cantidad = Number(row.cantidad) || 0;
    const precio = Number(row.precioUnitario) || 0;
    row.monto = +(cantidad * precio).toFixed(2);
    if (this.gridApiProductos) {
      this.gridApiProductos.applyTransaction({ update: [row] });
    }
    this.recalcularTotalAjuste();
  }

  /** Suma los montos del detalle y actualiza el campo Total del ajuste. */
  private recalcularTotalAjuste() {
    const total = this.rowDataProductos
      .filter((r) => r && typeof r === 'object')
      .reduce((acc, r: any) => acc + (Number(r.monto) || 0), 0);
    this.NotaCreditoForm.patchValue({ totalAjuste: +total.toFixed(2) });
    this.mostrarCuentaYTotal = true;
  }

  private fechaHoyISO(): string {
    const hoy = new Date();
    return `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, '0')}-${String(hoy.getDate()).padStart(2, '0')}`;
  }

  cargarNotasDesdeStore(): void {
    this.notaCreditoFacade.cargarNotas();
  }

  docpais() {
    const country = this.countries.find(
      c => c.codigo === this.countryService.getCountryCode()
    );
    this.tiposIdentificacion = [];
    this.countries.find(c => {
      if (c.codigo === country?.codigo) {
        c.personalidadfiscal?.find(tip => {
          this.tiposIdentificacion.push({ value: tip.value, label: tip.nombre, numero: tip.numero })
        })
      }
    })
  }

  actualizarColumnasGrid() {
    // Las columnas del detalle son las mismas para nota de crédito y débito.
    // Se conserva el método por compatibilidad con las suscripciones existentes.
  }

  private prepararFacturasParaProveedor(proveedor: any) {
    // Filtrar facturas del store por nombre de proveedor
    const facturasFiltradas = this.todasLasFacturas.filter(
      f => f.factura_proveedor_proveedor === proveedor.nombre
    );
    this.facturasProveedorActual = facturasFiltradas.map(f => ({
      id: f.factura_proveedor_nro_comprobante,
      productos: []
    }));
    this.facturasDisponibles = this.facturasProveedorActual.map(f => f.id);
    this.facturasAutocomplete = facturasFiltradas.map(f => ({
      id: f.factura_proveedor_nro_comprobante,
      nombre: f.factura_proveedor_nro_comprobante
    }));
    this.mostrarFacturaAfectada = true;
    this.NotaCreditoForm.patchValue({ facturaafectada: '', serie: '', numero: '' });
    this.rowDataProductos = [];
    
    console.log('  Facturas preparadas para proveedor:', {
      proveedor: proveedor.nombre,
      facturasCount: this.facturasProveedorActual.length,
      facturas: this.facturasAutocomplete,
      facturasCompletas: this.facturasProveedorActual
    });
  }

  actualizarFacturasDisponibles(nombreProveedor: string) {
    if (!nombreProveedor) {
      this.facturasDisponibles = [];
      this.facturasAutocomplete = [];
      this.NotaCreditoForm.patchValue({ facturaafectada: '' });
      this.mostrarFacturaAfectada = false;
      this.mostrarCuentaYTotal = false;
      return;
    }

    const proveedorEncontrado = this.proveedores.find(p => p.nombre === nombreProveedor);

    if (proveedorEncontrado) {
      this.prepararFacturasParaProveedor(proveedorEncontrado);
    } else {
      this.facturasDisponibles = [];
      this.facturasAutocomplete = [];
      this.mostrarFacturaAfectada = false;
    }

    // Limpiar la factura seleccionada si no está en la nueva lista
    const facturaActual = this.NotaCreditoForm.get('facturaafectada')?.value;
    if (facturaActual && !this.facturasDisponibles.includes(facturaActual)) {
      this.NotaCreditoForm.patchValue({ facturaafectada: '' });
    }
    this.mostrarCuentaYTotal = false;
  }

  onProveedorSelected(proveedor: any) {
    console.log('Proveedor seleccionado:', proveedor);
    this.proveedorSeleccionado = proveedor;
    this.NotaCreditoForm.patchValue({ inputproveedor: proveedor.nombre });
    this.NotaCreditoForm.patchValue({ proveedor: proveedor.nombre });
    this.actualizarFacturasDisponibles(proveedor.nombre);
  }

  onFacturaSelected(factura: any) {
    console.log('  Factura seleccionada evento:', factura);
    
    // Buscar la factura en el array de facturas disponibles
    const seleccion = this.facturasProveedorActual.find(f => f.id === factura.id || f.id === factura.nombre);
    
    console.log('🔎 Búsqueda de factura:', {
      facturaEvento: factura,
      facturaEncontrada: seleccion,
      facturasDisponibles: this.facturasProveedorActual,
      productosEncontrados: seleccion?.productos?.length || 0
    });

    const facturaId = seleccion?.id || factura?.nombre || factura?.id || '';
    const productos = seleccion?.productos || [];

    this.NotaCreditoForm.patchValue({
      facturaafectada: facturaId,
      serie: '',
      numero: ''
    });
    
    this.rowDataProductos = productos;
    
    console.log('  Productos cargados en grid:', {
      facturaId,
      productosCount: productos.length,
      productos
    });

    // Mostrar cuenta contable y total de ajuste
    this.mostrarCuentaYTotal = true;
  }

  // Selección desde el autocomplete de "Factura asociada" (lista de ejemplo)
  onFacturaAsociadaSelected(factura: any) {
    console.log('Factura asociada seleccionada:', factura);
    this.onFacturaSelected(factura);
  }

  onCuentaContableSelected(cuenta: any) {
    console.log('Cuenta contable seleccionada:', cuenta);
    this.NotaCreditoForm.patchValue({ cuentaContable: cuenta.id });
  }

  onchangedocs(event: any) {
    console.log('Tipo de identificación seleccionado:', event.detail.value);
  }

  buscarProveedor() {
    const tipoDoc = this.NotaCreditoForm.get('documentoproveedor')?.value;
    const numDoc = this.NotaCreditoForm.get('documentoproveedorinput')?.value;

    if (!numDoc) {
      return;
    }

    // Buscar proveedor por RUC
    if (tipoDoc === 'RUC') {
      const proveedorEncontrado = this.proveedores.find(p => p.ruc === numDoc);
      if (proveedorEncontrado) {
        this.NotaCreditoForm.patchValue({
          inputproveedor: proveedorEncontrado.nombre
        });
        this.actualizarFacturasDisponibles(proveedorEncontrado.nombre);
      }
    }
  }

  mostrarTabla(valor: boolean) {
    this.mostrartabla = valor;
  }

  /** Filtro rápido de la lista: busca el texto en todas las columnas visibles. */
  onBuscarLista(event: any): void {
    const valor = (event?.detail?.value ?? event?.target?.value ?? '').toString();
    this.gridApi?.setGridOption('quickFilterText', valor);
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    // Restaurar selección si había una fila seleccionada antes de ocultar la tabla
    if (this.filaSeleccionada) {
      const codigoSeleccionado = this.filaSeleccionada.nota_credito_codigo;
      setTimeout(() => {
        this.gridApi.forEachNode(node => {
          if (node.data?.nota_credito_codigo === codigoSeleccionado) {
            node.setSelected(true);
            this.gridApi.ensureNodeVisible(node, 'middle');
          }
        });
      }, 0);
    }
  }

  onGridReadyProductos(params: GridReadyEvent) {
    this.gridApiProductos = params.api;
  }

  async onCellClicked(event: any) {
    if (!event.data) return;

    const nuevaSeleccion = event.data;

    // Si es la misma fila, no hacer nada
    if (this.filaSeleccionada && this.filaSeleccionada.nota_credito_codigo === nuevaSeleccion.nota_credito_codigo) {
      return;
    }

    // Guardar elemento con foco
    const elementoConFoco = document.activeElement as HTMLElement;

    // Validar cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      // Usuario canceló, deseleccionar y volver a seleccionar la anterior
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          if (this.filaSeleccionada) {
            this.gridApi.forEachNode((node) => {
              if (node.data && node.data.nota_credito_codigo === this.filaSeleccionada!.nota_credito_codigo) {
                node.setSelected(true);
              }
            });
          }
        }
        // Restaurar foco
        if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
          elementoConFoco.focus();
        }
      }, 0);
      return;
    }

    // Usuario confirmó, cargar nueva selección
    const data: INotaCredito = nuevaSeleccion;
    console.log('Nota de crédito seleccionada:', data);

    this.filaSeleccionada = data;
    this.esNuevoRegistro = false;

    // Parsear fechas — soporta yyyy-MM-dd y dd/MM/yyyy
    const parsearFecha = (fechaStr: string): Date => {
      if (!fechaStr) return new Date();
      if (fechaStr.includes('-')) {
        const p = fechaStr.split('-');
        return new Date(parseInt(p[0]), parseInt(p[1]) - 1, parseInt(p[2]));
      }
      const p = fechaStr.split('/');
      return new Date(parseInt(p[2]), parseInt(p[1]) - 1, parseInt(p[0]));
    };

    // Cargar datos en el formulario
    this.NotaCreditoForm.patchValue({
      serieNumero: `${data.nota_credito_serie}-${data.nota_credito_numero}`,
      serie: data.nota_credito_serie || '',
      numero: data.nota_credito_numero || '',
      inputproveedor: data.nota_credito_proveedor,
      facturaafectada: data.nota_credito_factura_afectada,
      estado: data.nota_credito_estado,
      cuentaContable: data.nota_credito_cuenta_contable,
      proveedor: data.nota_credito_proveedor,
      fechaEmisionNota: data.nota_credito_fecha_emision,
      fechaReg: data.nota_credito_fecha_registro,
      tipoAjuste: data.nota_credito_tipo === 'Crédito' ? 'Nota de crédito' : 'Nota de débito',
      moneda: data.nota_credito_moneda || 'Soles',
      motivoAjuste: data.nota_credito_motivo_ajuste || '',
      descripcionDetallada: data.nota_credito_descripcion_detallada || '',
      totalAjuste: data.nota_credito_total_ajuste || '',
      documentoproveedorinput: data.nota_credito_nro_documento || ''
    });
    this.deshabilitarCampos(this.filaSeleccionada);
    // Actualizar fechas para los calendarios
    this.fechaEmisionNota = parsearFecha(data.nota_credito_fecha_emision);
    this.fechaRegistroNota = parsearFecha(data.nota_credito_fecha_registro);

    // Cargar detalle en la tabla secundaria
    this.rowDataProductos = data.nota_credito_detalle || [];
    if (this.gridApiProductos) {
      this.gridApiProductos.setGridOption('rowData', this.rowDataProductos);
    }
    // Reflejar en el combo el centro de costo guardado (tomado de la primera línea).
    const centroGuardadoNota = (this.rowDataProductos as any[]).find((l: any) => l.centros_costo_id != null)?.centros_costo_id;
    if (centroGuardadoNota != null) {
      this.NotaCreditoForm.patchValue({ centroCostoId: Number(centroGuardadoNota) });
    }
    this.mostrarCuentaYTotal = true;
    this.mostrarFacturaAfectada = true;

    // Simular que hay un archivo cargado
    this.simularArchivoCargado();

    // Resetear servicio después de cargar datos
    this.formValidationService.resetearEstado();
  }
  deshabilitarCampos(event?: any) {
    if (event.estado === 'Aplicado') {
      this.desactivarcampos = true;
      this.NotaCreditoForm.get('fechaEmisionNota')?.disable();
      this.NotaCreditoForm.get('cuentaContable')?.disable();
      this.NotaCreditoForm.get('facturaafectada')?.disable();
      this.NotaCreditoForm.get('motivoAjuste')?.disable();
      this.NotaCreditoForm.get('descripcionDetallada')?.disable();
      this.NotaCreditoForm.get('tipoAjuste')?.disable();
      this.NotaCreditoForm.get('moneda')?.disable();
      this.NotaCreditoForm.get('proveedor')?.disable();
      this.NotaCreditoForm.get('serie')?.disable();
      this.NotaCreditoForm.get('numero')?.disable();
    }
    else {
      this.desactivarcampos = false;
      this.NotaCreditoForm.get('fechaEmisionNota')?.enable();
      this.NotaCreditoForm.get('cuentaContable')?.enable();
      this.NotaCreditoForm.get('descripcionDetallada')?.enable();
      this.NotaCreditoForm.get('facturaafectada')?.enable();
      this.NotaCreditoForm.get('motivoAjuste')?.enable();
      this.NotaCreditoForm.get('moneda')?.enable();
      this.NotaCreditoForm.get('tipoAjuste')?.enable();
      this.NotaCreditoForm.get('proveedor')?.enable();
      this.NotaCreditoForm.get('serie')?.enable();
      this.NotaCreditoForm.get('numero')?.enable();
    }


  }

  onFileSelected(file: File) {
    this.documentoSoporte = file.name;
    console.log('Archivo seleccionado:', file.name);
    // Aquí puedes agregar lógica adicional como subir el archivo al servidor
  }

  onFileError(errorMessage: string) {
    console.error('Error al seleccionar archivo:', errorMessage);
    // Aquí puedes mostrar un toast o mensaje de error al usuario
  }

  onBtReset() {
    this.cargarNotasDesdeStore();
  }
  removeFile() {
    this.documentoSoporte = '';
    console.log('Archivo removido');
  }

  simularArchivoCargado() {
    // Crear un archivo simulado
    const blob = new Blob(['contenido simulado'], { type: 'application/pdf' });
    const archivoSimulado = new File([blob], `${this.filaSeleccionada?.nota_credito_codigo || 'documento'}.pdf`, { type: 'application/pdf' });
    
    // Establecer el archivo en el componente file-upload
    if (this.fileUploadComponent) {
      this.fileUploadComponent.selectedFile = archivoSimulado;
      this.fileUploadComponent.fileName = archivoSimulado.name;
      this.documentoSoporte = archivoSimulado.name;
    }
  }
  formularioreset() {
    this.NotaCreditoForm.setValue({
      proveedor: '',
      fechaEmisionNota: '',
      fechaReg: [this.fechaHoyISO()],
      moneda: 'Soles',
      facturaafectada: '',
      tipoAjuste: 'nota-credito',
      subtotal: '',
      motivoAjuste: 'Error en facturación',
      descripcionDetallada: '',
      serieNumero: '',
      serie: '',
      numero: '',
      cuentaContable: '',
      porcentajeAjuste: '',
      montoAjuste: '',
      inputproveedor: '',
      documentoproveedor: 'RUC',
      documentoproveedorinput: '',
      impuesto: '',
      totalAjuste: '',
      archivo: '',
      estado: ['Pendiente'],
    });
    this.NotaCreditoForm.get('fechaReg')?.disable();
    this.NotaCreditoForm.get('estado')?.disable();
  }
  async nuevoAjuste() {
    // Validar cambios sin guardar
    const confirmar = await this.formValidationService.validarCambios();

    if (!confirmar) {
      return; // Usuario canceló
    }

    // Resetear el formulario
    this.formularioreset();
    this.gridApi.deselectAll();
    // Limpiar archivo adjunto
    this.documentoSoporte = '';
    if (this.fileUploadComponent) {
      this.fileUploadComponent.removeFile();
    }
    this.rowDataProductos = [];
    this.proveedorResuelto = null;
    // Resetear estado
    // this.filaSeleccionada = null;
    this.esNuevoRegistro = true;
    this.filaSeleccionada = null;

    // Resetear servicio de validación
    this.formValidationService.resetearEstado();
  }

  anularNota() {
    console.log('Anulando nota...');
  }

  aplicarAjuste() {
    if (this.NotaCreditoForm.invalid) {
      this.toastService.warning('Por favor, completa los campos obligatorios.');
      return;
    }

    const formValue = this.NotaCreditoForm.getRawValue();

    // Resolver proveedorId (obligatorio para el endpoint /finanzas/cuentas-pagar/notas)
    const proveedorId = this.proveedorResuelto?.id;
    if (!proveedorId) {
      this.toastService.warning('Busca y selecciona un proveedor por su número de documento antes de registrar.');
      return;
    }

    // Construir el detalle real a partir de la grilla editable
    const lineasValidas = this.rowDataProductos.filter(
      (r: any) => r && typeof r === 'object' && (Number(r.cantidad) > 0 || Number(r.monto) > 0)
    );
    if (!lineasValidas.length) {
      this.toastService.warning('Agrega al menos una línea de detalle a la nota.');
      return;
    }

    const facturaAfectada = String(formValue.facturaafectada ?? '').trim();
    const referenciaCab = String(formValue.descripcionDetallada ?? formValue.motivoAjuste ?? '').trim();

    const detalle = lineasValidas.map((linea: any, indice: number) => {
      const cantidad = Number(linea.cantidad) || 0;
      const precioUnitario = Number(linea.precioUnitario) || 0;
      const monto = Number(linea.monto) || +(cantidad * precioUnitario).toFixed(2);
      return {
        item: indice + 1,
        conceptoFinancieroId: this.resolverConceptoFinancieroId(linea.conceptoFinancieroNombre),
        descripcion: String(linea.descripcion ?? linea.conceptoFinancieroNombre ?? '').trim() || 'Ajuste de nota',
        articuloId: linea.articuloId ?? null,
        cantidad,
        precioUnitario,
        monto,
        centros_costo_id: this.resolverCentroCostoId(formValue.centroCostoId ?? linea.centros_costo_id),
        tiposImpuestoId: this.resolverTipoImpuestoId(linea.impuestos),
        nroRef: facturaAfectada || null,
        itemRef: indice + 1,
        referencia: referenciaCab || null,
      };
    });

    // Formatear fecha a DD/MM/YYYY (el repositorio normaliza a ISO)
    const formatearFecha = (fecha: any): string => {
      if (!fecha) return '';
      if (fecha instanceof Date) return fecha.toLocaleDateString('es-PE');
      return String(fecha);
    };

    // Mapear valor del form al tipo de la entidad
    const mapearTipo = (tipoAjuste: string): string => {
      if (tipoAjuste === 'nota-credito') return 'Crédito';
      if (tipoAjuste === 'nota-debito') return 'Débito';
      return tipoAjuste;
    };

    const total = detalle.reduce((acc, d) => acc + (Number(d.monto) || 0), 0);

    const nota: NotaCreditoEntity = {
      nota_credito_codigo: this.esNuevoRegistro
        ? `NV-${new Date().getFullYear()}-NC-${String(this.rowData.length + 1).padStart(3, '0')}`
        : this.filaSeleccionada!.nota_credito_codigo,
      nota_credito_tipo: mapearTipo(formValue.tipoAjuste),
      nota_credito_serie: formValue.serie,
      nota_credito_numero: formValue.numero,
      nota_credito_responsable: this.filaSeleccionada?.nota_credito_responsable || 'Usuario actual',
      nota_credito_fecha_emision: formatearFecha(this.fechaEmisionNota || formValue.fechaEmisionNota),
      nota_credito_fecha_registro: formValue.fechaReg || this.fechaHoyISO(),
      nota_credito_proveedor: formValue.proveedor || formValue.inputproveedor,
      nota_credito_factura_afectada: facturaAfectada,
      nota_credito_cuenta_contable: formValue.cuentaContable,
      nota_credito_estado: formValue.estado || 'Pendiente',
      nota_credito_moneda: formValue.moneda,
      nota_credito_motivo_ajuste: formValue.motivoAjuste,
      nota_credito_descripcion_detallada: formValue.descripcionDetallada,
      nota_credito_total_ajuste: total > 0 ? total : (formValue.totalAjuste ? Number(formValue.totalAjuste) : undefined),
      nota_credito_detalle: detalle as any,
    };
    nota['nota_credito_proveedor_id'] = proveedorId;
    nota['nota_credito_nro_documento'] = String(formValue.documentoproveedorinput ?? this.proveedorResuelto?.nroDocumento ?? '');

    if (this.esNuevoRegistro) {
      this.notaCreditoFacade.guardarNota(nota);
    } else {
      this.notaCreditoFacade.actualizarNota(nota);
    }

    this.formValidationService.resetearEstado();
  }
  public async abrirModalAnular() {
    if (!this.filaSeleccionada) {
      this.toastService.warning('Selecciona una nota para anular');
      return;
    }

    const detallesEjemplo: DetalleItem[] = [
      { label: 'Nota:', value: `${this.filaSeleccionada.nota_credito_serie ?? ''}-${this.filaSeleccionada.nota_credito_numero ?? ''}` },
      { label: 'Tipo:', value: this.filaSeleccionada.nota_credito_tipo ?? '' },
      { label: 'Proveedor:', value: this.filaSeleccionada.nota_credito_proveedor ?? '' },
      { label: 'Estado:', value: this.filaSeleccionada.nota_credito_estado ?? '' },
    ];

    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Anular nota',
        subtitulomodal: 'Detalle de la nota',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        tituloTextarea: 'Motivo de anulación:',
        placeholderTextarea: 'Describe el motivo de la anulación.',
        mostrarBotonEliminar: true,
        motivoObligatorio: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger'
      }
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();
    if (data && data.action === 'confirmar') {
      const codigo = this.filaSeleccionada?.nota_credito_codigo;
      if (!codigo) {
        this.toastService.danger('No se pudo identificar la nota a anular');
        return;
      }
      this.notaCreditoFacade.eliminarNota(String(codigo));
      this.toastService.success('Nota anulada correctamente');
      this.formularioreset();
      this.filaSeleccionada = null;
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }
    }
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    this.aplicarFiltroFechas();
  }

  /** Campo de fecha sobre el que aplica el filtro de rango, según el select. */
  private fechaFiltroField(): string {
    return this.tipoSeleccionado === 'emision'
      ? 'nota_credito_fecha_emision'
      : 'nota_credito_fecha_registro';
  }

  /** Aplica el filtro de rango de fechas sobre la fuente y refresca el grid. */
  aplicarFiltroFechas(): void {
    this.rowData = this.gridExport.filtrarPorRango(
      this.notasFuente,
      (n: any) => n?.[this.fechaFiltroField()],
      this.startDate,
      this.endDate,
    );
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /** Cambió el tipo de fecha (registro/emisión): re-aplica el filtro. */
  onTipoFechaChange(): void {
    this.aplicarFiltroFechas();
  }

  // Para modo SINGLE - Manejo de fechas seleccionadas
  onFechaEmisionNotaSelected(date: Date) {
    console.log('Fecha emisión nota:', date);
    this.fechaEmisionNota = date;
    this.NotaCreditoForm.patchValue({ fechaEmisionNota: date });
  }

  onFechaRegistroNotaSelected(date: Date) {
    console.log('Fecha registro nota:', date);
    this.fechaRegistroNota = date;
    this.NotaCreditoForm.patchValue({ fechaRegistroNota: date });
  }

  buscarproveedor() {
    const numeroDoc = String(this.NotaCreditoForm!.get('documentoproveedorinput')?.value || '').trim();

    if (!numeroDoc) {
      this.toastService.warning('Por favor, ingresa un número de documento');
      return;
    }

    // Resolver el proveedor directamente del API por número de documento (sin N+1).
    this.api
      .get<any>('/core/relaciones-comerciales', { nroDocumento: numeroDoc, page: 0, size: 20 })
      .pipe(catchError(() => of(null)))
      .subscribe((response) => {
        const lista = Array.isArray(response) ? response : response?.content ?? [];
        const encontrado =
          lista.find((p: any) => String(p?.nroDocumento ?? '').trim() === numeroDoc) ?? lista[0];

        if (encontrado) {
          this.aplicarProveedorEncontrado(encontrado, numeroDoc);
        } else {
          this.proveedorResuelto = null;
          this.proveedorSeleccionado = null;
          this.facturasProveedorActual = [];
          this.facturasAutocomplete = [];
          this.facturasDisponibles = [];
          this.NotaCreditoForm.patchValue({
            inputproveedor: '',
            proveedor: '',
            facturaafectada: '',
            serie: '',
            numero: '',
          });
          this.rowDataProductos = [];
          this.mostrarFacturaAfectada = true;
          this.mostrarCuentaYTotal = false;
          this.toastService.warning('Proveedor no encontrado con el número ingresado');
        }
      });
  }

  /** Aplica al formulario el proveedor resuelto del API y prepara sus facturas. */
  private aplicarProveedorEncontrado(prov: any, numeroDoc: string) {
    const razonSocial = prov?.razonSocial ?? prov?.nombreComercial ?? '';
    this.proveedorResuelto = {
      id: Number(prov?.id) || undefined,
      razonSocial,
      nroDocumento: String(prov?.nroDocumento ?? numeroDoc),
    };
    this.proveedorSeleccionado = { nombre: razonSocial, ruc: numeroDoc, dni: '', facturas: [] };

    this.NotaCreditoForm.patchValue({
      documentoproveedor: 'RUC',
      inputproveedor: razonSocial,
      proveedor: razonSocial,
      facturaafectada: '',
      serie: '',
      numero: '',
    });

    // Filtrar facturas del store por razón social para el autocomplete de factura afectada.
    this.prepararFacturasParaProveedor({ nombre: razonSocial });
    this.mostrarCuentaYTotal = false;
    this.toastService.success(`Proveedor "${razonSocial}" encontrado`);
  }
  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150, },
      { headerName: 'Usuario', field: 'usuario', width: 120, },
      {
        headerName: 'Acción', field: 'accion', width: 150,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
      {
        headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
    ];

    // Datos de ejemplo
    const rowData = [
      { fechaHora: '21/11/2025 09:00', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Registro inicial de nota de crédito'},
      { fechaHora: '21/11/2025 09:05', usuario: 'Carlos Zapata', accion: 'Actualización', detalleCambio: 'Modificación de cantidad de productos en nota de crédito'},
      { fechaHora: '19/11/2025 08:45', usuario: 'Carlos Zapata', accion: 'Creación', detalleCambio: 'Agregado de 5 artículos a nota de crédito' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones de notas de crédito y débito',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

}
