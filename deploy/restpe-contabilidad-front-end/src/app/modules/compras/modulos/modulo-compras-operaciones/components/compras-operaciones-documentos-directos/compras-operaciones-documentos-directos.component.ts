import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent, IRichCellEditorParams } from 'ag-grid-community';
import { catchError, of } from 'rxjs';
import { ToastService } from 'src/app/ui/services/toast.service';
import { GridExportService } from 'src/app/core/infrastructure/export/grid-export.service';
import { ApiClientService } from 'src/app/core/infrastructure/http/api-client.service';
import { DocumentoDirectoFacade } from '../../../../application/facades/documento-directo.facade';
import {
  DocumentoDirectoEntity,
  DocumentoDirectoDetalleEntity,
} from '../../../../domain/models/documento-directo.entity';

import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import {
  faAngleDown,
  faCirclePlus,
  faDownload,
  faRotateRight,
} from '@fortawesome/pro-solid-svg-icons';

interface OpcionCatalogo {
  id: number;
  nombre: string;
}

@Component({
  selector: 'app-compras-operaciones-documentos-directos',
  templateUrl: './compras-operaciones-documentos-directos.component.html',
  styleUrls: ['./compras-operaciones-documentos-directos.component.scss'],
  standalone: false,
})
export class ComprasOperacionesDocumentosDirectosComponent implements OnInit {
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  private readonly facade = inject(DocumentoDirectoFacade);
  private readonly api = inject(ApiClientService);
  private readonly fb = inject(FormBuilder);
  private readonly toast = inject(ToastService);
  private readonly gridExport = inject(GridExportService);

  private readonly columnasExport = [
    { header: 'Código', field: 'dpd_codigo' },
    { header: 'Tipo', field: 'dpd_tipo_documento' },
    { header: 'Comprobante', field: 'dpd_nro_documento' },
    { header: 'Proveedor', field: 'dpd_proveedor' },
    { header: 'Emisión', field: 'dpd_fecha_emision' },
    { header: 'Vencimiento', field: 'dpd_fecha_vencimiento' },
    { header: 'Moneda', field: 'dpd_moneda' },
    { header: 'Total', field: 'dpd_total' },
    { header: 'Estado', field: 'dpd_estado' },
  ];

  async exportarExcel(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.documentos()) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toast.warning('No hay documentos para exportar');
      return;
    }
    await this.gridExport.exportarExcel(
      `documentos-directos-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
      'Documentos directos',
    );
  }

  async exportarPdf(): Promise<void> {
    const filas = this.gridExport.obtenerFilas(this.gridApi, this.documentos()) as Array<Record<string, unknown>>;
    if (!filas.length) {
      this.toast.warning('No hay documentos para exportar');
      return;
    }
    await this.gridExport.exportarPdf(
      'Documentos por Pagar Directo',
      `documentos-directos-${this.gridExport.fechaHoy()}`,
      this.columnasExport,
      filas,
    );
  }

  readonly documentos = this.facade.documentos;
  readonly loadingObtener = this.facade.loadingObtener;
  readonly loadingGuardar = this.facade.loadingGuardar;

  form!: FormGroup;
  gridApi!: GridApi;
  detalleGridApi!: GridApi;

  modoCreacion = true;
  filaSeleccionada: DocumentoDirectoEntity | null = null;
  proveedorSeleccionadoId: number | null = null;
  detalle: DocumentoDirectoDetalleEntity[] = [];

  conceptosFinancieros: OpcionCatalogo[] = [];
  tiposImpuestoCatalogo: { id: number; nombre: string; tasa: number }[] = [];
  monedas: { codigo: string; nombre: string }[] = [];

  tiposComprobante = [
    { value: 'Factura', label: 'Factura' },
    { value: 'Boleta', label: 'Boleta' },
    { value: 'Recibo', label: 'Recibo por honorarios' },
  ];

  localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay documentos para mostrar',
  };

  colDefs: ColDef[] = [
    { field: 'dpd_codigo', headerName: 'Código', flex: 0.7, minWidth: 80, filter: true },
    { field: 'dpd_tipo_documento', headerName: 'Tipo', flex: 1, minWidth: 90, filter: true },
    { field: 'dpd_nro_documento', headerName: 'Comprobante', flex: 1, minWidth: 110, filter: true },
    { field: 'dpd_proveedor', headerName: 'Proveedor', flex: 1.6, minWidth: 150, filter: true },
    { field: 'dpd_fecha_emision', headerName: 'Emisión', flex: 1, minWidth: 100 },
    {
      field: 'dpd_total',
      headerName: 'Total',
      flex: 0.9,
      minWidth: 90,
      cellClass: 'text-right',
      valueFormatter: (p) => (p.value != null ? Number(p.value).toFixed(2) : '–'),
    },
    {
      field: 'dpd_estado',
      headerName: 'Estado',
      flex: 0.9,
      minWidth: 100,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const clase = estado === 'Anulado' ? 'text-red-600 bg-red-100' : 'text-green-600 bg-green-100';
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${clase}">${estado}</span>`;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
  ];

  detalleColDefs: ColDef[] = [
    { field: 'descripcion', headerName: 'Descripción', flex: 2, minWidth: 150, editable: true, cellStyle: { cursor: 'pointer' } },
    {
      field: 'cantidad',
      headerName: 'Cantidad',
      flex: 0.7,
      minWidth: 80,
      editable: true,
      cellClass: 'text-center',
      cellStyle: { cursor: 'pointer' },
      valueParser: (p) => Number(p.newValue) || 0,
    },
    {
      field: 'precioUni',
      headerName: 'Precio Unit.',
      flex: 0.8,
      minWidth: 90,
      editable: true,
      cellClass: 'text-right',
      cellStyle: { cursor: 'pointer' },
      valueParser: (p) => Number(p.newValue) || 0,
    },
    {
      field: 'conceptoFinancieroNombre',
      headerName: 'Concepto financiero',
      flex: 1.3,
      minWidth: 150,
      editable: true,
      cellStyle: { cursor: 'pointer' },
      cellEditor: 'agRichSelectCellEditor',
      cellEditorParams: () =>
        ({
          values: this.conceptosFinancieros.map((c) => c.nombre),
          searchType: 'matchAny',
          filterList: true,
          highlightMatch: true,
        } as IRichCellEditorParams),
    },
    {
      field: 'centros_costo_id',
      headerName: 'Centro de costo (ID)',
      flex: 0.8,
      minWidth: 110,
      editable: true,
      cellClass: 'text-center',
      cellStyle: { cursor: 'pointer' },
      valueParser: (p) => Number(p.newValue) || 1,
    },
    {
      field: 'impuestos',
      headerName: 'Impuesto',
      flex: 1,
      minWidth: 100,
      editable: true,
      cellStyle: { cursor: 'pointer' },
      cellEditor: 'agRichSelectCellEditor',
      cellEditorParams: () =>
        ({
          values: this.tiposImpuestoCatalogo.map((t) => t.nombre),
          searchType: 'matchAny',
          filterList: true,
          highlightMatch: true,
        } as IRichCellEditorParams),
    },
    {
      field: 'subtotal',
      headerName: 'Monto',
      flex: 0.8,
      minWidth: 90,
      cellClass: 'text-right',
      valueGetter: (p) => (Number(p.data?.cantidad) || 0) * (Number(p.data?.precioUni) || 0),
      valueFormatter: (p) => (p.value != null ? Number(p.value).toFixed(2) : '0.00'),
    },
    {
      headerName: '',
      colId: 'acciones',
      width: 50,
      cellRenderer: () =>
        `<span class="text-red-500 cursor-pointer" title="Quitar línea"><i class="fa-solid fa-trash-can"></i>✕</span>`,
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center', cursor: 'pointer' },
    },
  ];

  constructor() {
    effect(() => {
      const docs = this.documentos();
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', docs);
      }
    });

    effect(() => {
      const msg = this.facade.mensajeExito();
      if (msg && this.form) {
        this.toast.success(msg);
        this.resetearFormulario();
      }
    });

    effect(() => {
      const err = this.facade.error();
      if (err) {
        this.toast.danger(err);
      }
    });
  }

  ngOnInit(): void {
    this.form = this.fb.group({
      search: new FormControl(''),
      tipoComprobante: new FormControl('Factura'),
      ruc: new FormControl(''),
      proveedor: new FormControl(''),
      serie: new FormControl(''),
      numero: new FormControl(''),
      fechaEmision: new FormControl(this.fechaHoyISO()),
      fechaVencimiento: new FormControl(''),
      moneda: new FormControl('PEN'),
      total: new FormControl(0),
    });

    this.cargarCatalogos();
    this.facade.cargarDocumentos();
  }

  private cargarCatalogos(): void {
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
      .get<any>('/core/impuestos')
      .pipe(catchError(() => of([])))
      .subscribe((response) => {
        const lista = Array.isArray(response) ? response : [];
        this.tiposImpuestoCatalogo = lista
          .filter((t: any) => t?.flagEstado !== '0')
          .map((t: any) => ({
            id: Number(t.id),
            nombre: t.nombre ?? t.codigo ?? `Impuesto ${t.id}`,
            tasa: Number(t.tasa ?? t.porcentaje ?? 0),
          }));
      });

    this.api
      .get<any>('/core/monedas')
      .pipe(catchError(() => of([])))
      .subscribe((response) => {
        const lista = Array.isArray(response) ? response : response?.content ?? [];
        this.monedas = lista.map((m: any) => ({ codigo: m.codigo ?? 'PEN', nombre: m.nombre ?? m.codigo ?? 'Soles' }));
      });
  }

  /** Filtro rápido de la lista: busca el texto en todas las columnas visibles. */
  onBuscarLista(event: any): void {
    const valor = (event?.detail?.value ?? event?.target?.value ?? '').toString();
    this.gridApi?.setGridOption('quickFilterText', valor);
  }

  onGridReady(params: GridReadyEvent): void {
    this.gridApi = params.api;
    this.gridApi.setGridOption('rowData', this.documentos());
  }

  onDetalleGridReady(params: GridReadyEvent): void {
    this.detalleGridApi = params.api;
    this.refrescarDetalle();
  }

  buscarProveedor(): void {
    const ruc = String(this.form.get('ruc')?.value ?? '').trim();
    if (!ruc) {
      this.toast.warning('Ingresa el RUC/documento del proveedor para buscar.');
      return;
    }
    this.api
      .get<any>('/core/relaciones-comerciales', { nroDocumento: ruc, page: 0, size: 10 })
      .pipe(catchError(() => of(null)))
      .subscribe((response) => {
        const lista = Array.isArray(response) ? response : response?.content ?? [];
        const encontrado = lista.find((p: any) => String(p.nroDocumento ?? '').trim() === ruc) ?? lista[0];
        if (!encontrado) {
          this.toast.warning('No se encontró un proveedor con ese documento.');
          this.proveedorSeleccionadoId = null;
          return;
        }
        this.proveedorSeleccionadoId = Number(encontrado.id);
        this.form.patchValue({ proveedor: encontrado.razonSocial ?? '' });
        this.toast.success('Proveedor encontrado.');
      });
  }

  agregarLinea(): void {
    this.detalle = [
      ...this.detalle,
      {
        item: this.detalle.length + 1,
        descripcion: '',
        cantidad: 1,
        precioUni: 0,
        subtotal: 0,
        conceptoFinancieroNombre: this.conceptosFinancieros[0]?.nombre ?? '',
        centros_costo_id: 1,
        impuestos: this.tiposImpuestoCatalogo[0]?.nombre ?? '',
      },
    ];
    this.refrescarDetalle();
  }

  onDetalleCellClicked(event: any): void {
    if (event.colDef?.colId === 'acciones' && event.data) {
      this.detalle = this.detalle.filter((d) => d !== event.data);
      this.detalle.forEach((d, i) => (d.item = i + 1));
      this.refrescarDetalle();
    }
  }

  onDetalleCellValueChanged(): void {
    this.recalcularTotal();
  }

  private refrescarDetalle(): void {
    if (this.detalleGridApi) {
      this.detalleGridApi.setGridOption('rowData', this.detalle);
    }
    this.recalcularTotal();
  }

  private recalcularTotal(): void {
    const total = this.detalle.reduce(
      (acc, d) => acc + (Number(d.cantidad) || 0) * (Number(d.precioUni) || 0),
      0
    );
    this.form.patchValue({ total: Number(total.toFixed(2)) }, { emitEvent: false });
  }

  async onCellClicked(event: any): Promise<void> {
    if (!event.data) {
      return;
    }
    this.modoCreacion = false;
    this.filaSeleccionada = event.data as DocumentoDirectoEntity;
    this.cargarDocumentoEnFormulario(this.filaSeleccionada);
  }

  private cargarDocumentoEnFormulario(doc: DocumentoDirectoEntity): void {
    this.proveedorSeleccionadoId = doc.dpd_proveedor_id ?? null;
    this.form.patchValue({
      tipoComprobante: doc.dpd_tipo_documento || 'Factura',
      ruc: '',
      proveedor: doc.dpd_proveedor || '',
      serie: doc.dpd_serie || '',
      numero: doc.dpd_numero || '',
      fechaEmision: (doc.dpd_fecha_emision || '').substring(0, 10),
      fechaVencimiento: (doc.dpd_fecha_vencimiento || '').substring(0, 10),
      moneda: doc.dpd_moneda || 'PEN',
      total: doc.dpd_total || 0,
    });
    this.detalle = (doc.dpd_detalle ?? []).map((d, i) => ({ ...d, item: i + 1 }));
    this.refrescarDetalle();
  }

  nuevoDocumento(): void {
    this.resetearFormulario();
  }

  private resetearFormulario(): void {
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.proveedorSeleccionadoId = null;
    this.detalle = [];
    this.form.reset({
      tipoComprobante: 'Factura',
      moneda: 'PEN',
      fechaEmision: this.fechaHoyISO(),
      total: 0,
    });
    this.refrescarDetalle();
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  guardar(): void {
    const v = this.form.getRawValue();

    if (!this.proveedorSeleccionadoId && !v.proveedor) {
      this.toast.warning('Selecciona un proveedor (usa el botón Buscar por RUC).');
      return;
    }
    if (!this.detalle.length) {
      this.toast.warning('Agrega al menos una línea de detalle.');
      return;
    }

    // Fecha de vencimiento no puede ser anterior a la de emisión
    if (v.fechaVencimiento && v.fechaEmision && v.fechaVencimiento < v.fechaEmision) {
      this.toast.warning('La fecha de vencimiento no puede ser anterior a la fecha de emisión.');
      return;
    }

    // Evitar comprobantes duplicados (mismo proveedor + serie-número)
    const nroDocumento = [v.serie, v.numero].filter((x: string) => !!x).join('-');
    if (nroDocumento) {
      const duplicado = this.documentos().some((doc) =>
        doc.dpd_codigo !== this.filaSeleccionada?.dpd_codigo &&
        String(doc.dpd_nro_documento ?? '').trim().toLowerCase() === nroDocumento.trim().toLowerCase() &&
        String(doc.dpd_proveedor ?? '').trim().toLowerCase() === String(v.proveedor ?? '').trim().toLowerCase()
      );
      if (duplicado) {
        this.toast.warning(`Ya existe un documento ${nroDocumento} para este proveedor.`);
        return;
      }
    }

    const detalle: DocumentoDirectoDetalleEntity[] = this.detalle.map((d, i) => ({
      item: i + 1,
      descripcion: d.descripcion || 'Detalle directo',
      cantidad: Number(d.cantidad) || 1,
      precioUni: Number(d.precioUni) || 0,
      subtotal: (Number(d.cantidad) || 0) * (Number(d.precioUni) || 0),
      monto: (Number(d.cantidad) || 0) * (Number(d.precioUni) || 0),
      conceptoFinancieroNombre: d.conceptoFinancieroNombre,
      conceptoFinancieroId: this.resolverConceptoFinancieroId(d.conceptoFinancieroNombre),
      centros_costo_id: Number(d.centros_costo_id) || 1,
      tiposImpuestoId: this.resolverTipoImpuestoId(d.impuestos),
      impuestos: d.impuestos,
    }));

    const documento: DocumentoDirectoEntity = {
      id: this.filaSeleccionada?.id,
      dpd_codigo: this.filaSeleccionada?.dpd_codigo ?? '',
      dpd_tipo_documento: v.tipoComprobante,
      dpd_serie: v.serie || '',
      dpd_numero: v.numero || '',
      dpd_proveedor: v.proveedor || '',
      dpd_proveedor_id: this.proveedorSeleccionadoId ?? undefined,
      dpd_nro_documento: [v.serie, v.numero].filter((x: string) => !!x).join('-'),
      dpd_fecha_emision: v.fechaEmision,
      dpd_fecha_vencimiento: v.fechaVencimiento || undefined,
      dpd_moneda: v.moneda,
      dpd_total: Number(v.total) || detalle.reduce((a, d) => a + (d.monto ?? 0), 0),
      dpd_estado: 'Registrado',
      dpd_detalle: detalle,
    };

    this.facade.guardarDocumento(documento);
  }

  anular(): void {
    if (!this.filaSeleccionada?.dpd_codigo) {
      this.toast.warning('Selecciona un documento de la lista para anular.');
      return;
    }
    this.facade.anularDocumento(this.filaSeleccionada.dpd_codigo);
  }

  refrescar(): void {
    this.facade.cargarDocumentos();
  }

  private resolverConceptoFinancieroId(nombre: unknown): number {
    const texto = String(nombre ?? '').trim().toLowerCase();
    const encontrado = this.conceptosFinancieros.find((c) => c.nombre.trim().toLowerCase() === texto);
    return encontrado?.id ?? this.conceptosFinancieros[0]?.id ?? 0;
  }

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

  private fechaHoyISO(): string {
    const hoy = new Date();
    return `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, '0')}-${String(hoy.getDate()).padStart(2, '0')}`;
  }
}
