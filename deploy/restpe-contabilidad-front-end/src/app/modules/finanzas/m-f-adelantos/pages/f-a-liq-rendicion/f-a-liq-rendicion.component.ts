import { Component, OnInit, inject, computed, effect } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalController } from '@ionic/angular';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { LiqRendicionFacade } from 'src/app/modules/finanzas/application/facades/liq-rendicion.facade';
import { LiqRendicionEntity, LiqRendicionDetalleLinea } from 'src/app/modules/finanzas/domain/models/liq-rendicion.entity';
import { OpcionCatalogo } from 'src/app/modules/finanzas/domain/repositories/iliq-rendicion.repository';
import { LiqRendicionSyncEffects } from 'src/app/modules/finanzas/effects/liq-rendicion-sync.effect';
import { LiqRendicionFeedbackEffects } from 'src/app/modules/finanzas/effects/liq-rendicion-feedback.effect';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

/**
 * Liquidación / Rendición de gastos — conectado al backend real (ms-finanzas
 * `/api/finanzas/liquidaciones`). Master-detail: cabecera (solicitud de giro aprobada +
 * concepto financiero + importe + tasa de cambio) y líneas de detalle (concepto + cuenta
 * por pagar + importe). El backend manda; la UI mock anterior (beneficiario/tipo de gasto/
 * centro de costo/saldos/gastos) se removió del template (recuperable por git).
 */
@Component({
  selector: 'app-f-a-liq-rendicion',
  templateUrl: './f-a-liq-rendicion.component.html',
  styleUrls: ['./f-a-liq-rendicion.component.scss'],
  standalone: false,
})
export class FALiqRendicionComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  // FACADE + EFFECTS
  readonly facade = inject(LiqRendicionFacade);
  readonly loaderActivo = computed(() => this.facade.isLoading());
  private readonly _sync = inject(LiqRendicionSyncEffects);
  private readonly _feedback = inject(LiqRendicionFeedbackEffects);

  panelLateralVisible = true;
  filaSeleccionada: LiqRendicionEntity | null = null;
  busqueda = '';

  // Catálogos reales
  solicitudes: OpcionCatalogo[] = [];
  conceptos: OpcionCatalogo[] = [];
  cuentasPagar: OpcionCatalogo[] = [];
  monedas: OpcionCatalogo[] = [];

  // FORM cabecera
  form!: FormGroup;

  // GRID lista
  private gridApi!: GridApi;
  rowData: LiqRendicionEntity[] = [];

  // Detalle (líneas)
  rowDataDetalle: LiqRendicionDetalleLinea[] = [];
  private gridApiDetalle!: GridApi;
  detalleSeleccionado: LiqRendicionDetalleLinea | null = null;
  nuevoDetalle: { conceptoFinancieroId: number | null; cntasPagarId: number | null; importe: number | null } = {
    conceptoFinancieroId: null, cntasPagarId: null, importe: null,
  };

  localeText = {
    page: 'Página', to: 'a', of: 'de', next: 'Siguiente', last: 'Último', first: 'Primero',
    previous: 'Anterior', loadingOoo: 'Cargando...', noRowsToShow: 'No hay datos para mostrar',
  };

  colDefs: ColDef[] = [
    { field: 'lr_num_liquidacion', headerName: 'N° liquidación', width: 130 },
    { field: 'lr_fecha_desembolso', headerName: 'Fecha', width: 120,
      valueFormatter: (p: any) => p.value ? String(p.value).slice(0, 10) : '' },
    { field: 'lr_importe_neto', headerName: 'Importe neto', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'end' },
      valueFormatter: (p: any) => (p.value != null && p.value !== '') ? Number(p.value).toFixed(2) : '-' },
    { field: 'lr_saldo', headerName: 'Saldo', width: 110, headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'end' },
      valueFormatter: (p: any) => (p.value != null && p.value !== '') ? Number(p.value).toFixed(2) : '-' },
    { field: 'lr_moneda', headerName: 'Moneda', width: 100, filter: true,
      // El backend no rellena monedaCodigo → resolvemos el nombre por id con el catálogo.
      valueGetter: (p: any) => this.monedas.find(m => m.id === p.data?.lr_moneda_id)?.nombre ?? (p.data?.lr_moneda || '—') },
    { headerClass: 'centrarencabezado', field: 'lr_estado', headerName: 'Estado', width: 110, filter: true,
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (p: any) => {
        if (p.value === 'Pendiente') { return `<span class="badge-table bg-[#F5F5F5] text-[#1F1F1F]">Pendiente</span>`; }
        if (p.value === 'Anulada') { return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulada</span>`; }
        if (p.value === 'Cerrada') { return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Cerrada</span>`; }
        return p.value;
      } },
  ];

  colDefsDetalle: ColDef[] = [
    { headerName: 'Item', valueGetter: (p: any) => (p.node?.rowIndex ?? 0) + 1, width: 60 },
    { field: 'conceptoNombre', headerName: 'Concepto financiero', flex: 1, minWidth: 180 },
    { field: 'cuentaPagarLabel', headerName: 'Cuenta por pagar', flex: 1, minWidth: 160 },
    { field: 'importe', headerName: 'Importe', width: 110, headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'end' },
      valueFormatter: (p: any) => (p.value != null && p.value !== '') ? Number(p.value).toFixed(2) : '-' },
  ];

  constructor(
    private fb: FormBuilder,
    private modalController: ModalController,
    private toast: ToastService,
  ) {
    this.form = this.fb.group({
      fechaLiquidacion: [new Date().toISOString().slice(0, 10), Validators.required],
      solicitudGiroId: [null, Validators.required],
      conceptoFinancieroId: [null, Validators.required],
      monedaId: [null],
      tasaCambio: [1, [Validators.required, Validators.min(0.0001)]],
      observacion: [''],
      estado: [{ value: 'Pendiente', disabled: true }],
    });

    // Sync store → rowData + grid (aplicando buscador)
    effect(() => {
      this.rowData = [...this.facade.liquidaciones()];
      this.aplicarBuscador();
    });
  }

  ngOnInit(): void {
    this.facade.cargarDatos();
    this.facade.listarSolicitudesAprobadas().subscribe({ next: (s) => (this.solicitudes = s), error: () => (this.solicitudes = []) });
    this.facade.listarConceptos().subscribe({ next: (c) => (this.conceptos = c), error: () => (this.conceptos = []) });
    this.facade.listarCuentasPagar().subscribe({ next: (c) => (this.cuentasPagar = c), error: () => (this.cuentasPagar = []) });
    this.facade.listarMonedas().subscribe({ next: (m) => (this.monedas = m), error: () => (this.monedas = []) });
  }

  /** Ionic cachea la página; este hook corre en CADA entrada. Recarga la lista y el
   *  catálogo de solicitudes aprobadas (para ver las recién aprobadas en Aprobación). */
  ionViewWillEnter(): void {
    this.facade.cargarDatos();
    this.facade.listarSolicitudesAprobadas().subscribe({ next: (s) => (this.solicitudes = s), error: () => (this.solicitudes = []) });
  }

  // ── Grilla principal + buscador ─────────────────────────────────────────────
  onGridReady(e: GridReadyEvent): void { this.gridApi = e.api; this.aplicarBuscador(); }

  onBuscar(): void { this.aplicarBuscador(); }

  private aplicarBuscador(): void {
    const t = (this.busqueda ?? '').trim().toLowerCase();
    const filtradas = !t ? this.rowData : this.rowData.filter((l) =>
      `${l.lr_num_liquidacion ?? ''} ${l.lr_importe_neto ?? ''} ${l.lr_estado ?? ''}`.toLowerCase().includes(t));
    this.gridApi?.setGridOption('rowData', filtradas);
  }

  exportarExcel(): void {
    this.gridApi?.exportDataAsExcel({ fileName: 'liquidaciones.xlsx', sheetName: 'Liquidaciones' });
  }

  onBtReset(): void { this.facade.cargarDatos(); }

  togglePanelLateral(): void { this.panelLateralVisible = !this.panelLateralVisible; }

  // ── Selección de una liquidación (editar) ───────────────────────────────────
  onCellClicked(event: any): void {
    const row = event?.data as LiqRendicionEntity;
    if (!row?.id) { return; }
    this.gridApi?.deselectAll();
    event.node?.setSelected(true);
    // El listado NO trae las líneas de detalle → se pide el detalle completo por id.
    this.facade.obtenerPorId(row.id).subscribe({
      next: (data) => this.cargarEnFormulario(data),
      error: () => this.cargarEnFormulario(row),
    });
  }

  /** Carga una liquidación (cabecera + detalle) en el formulario y la grilla de detalle. */
  private cargarEnFormulario(data: LiqRendicionEntity): void {
    this.filaSeleccionada = data;
    this.form.patchValue({
      fechaLiquidacion: (data.lr_fecha_desembolso || '').slice(0, 10) || new Date().toISOString().slice(0, 10),
      solicitudGiroId: data.lr_solicitud_giro_id ?? null,
      conceptoFinancieroId: data.lr_concepto_financiero_id ?? null,
      monedaId: data.lr_moneda_id ?? null,
      tasaCambio: data.lr_tasa_cambio ?? 1,
      observacion: data.lr_observacion ?? '',
      estado: data.lr_estado,
    });
    this.rowDataDetalle = (data.lr_detalles ?? []).map((d) => ({
      ...d,
      conceptoNombre: this.conceptos.find(c => c.id === d.conceptoFinancieroId)?.nombre ?? (d.conceptoFinancieroId != null ? `#${d.conceptoFinancieroId}` : ''),
      cuentaPagarLabel: this.cuentasPagar.find(c => c.id === d.cntasPagarId)?.nombre ?? (d.cntasPagarId != null ? `#${d.cntasPagarId}` : ''),
    }));
    this.gridApiDetalle?.setGridOption('rowData', this.rowDataDetalle);
  }

  // ── Detalle (líneas) ────────────────────────────────────────────────────────
  onGridReadyDetalle(e: GridReadyEvent): void { this.gridApiDetalle = e.api; this.gridApiDetalle.setGridOption('rowData', this.rowDataDetalle); }

  onCellClickedDetalle(event: any): void { this.detalleSeleccionado = event?.data ?? null; }

  agregarDetalle(): void {
    const { conceptoFinancieroId, cntasPagarId, importe } = this.nuevoDetalle;
    if (!conceptoFinancieroId) { this.toast.warning('Selecciona un concepto financiero para la línea'); return; }
    if (!cntasPagarId) { this.toast.warning('Selecciona una cuenta por pagar para la línea'); return; }
    if (importe == null || Number(importe) <= 0) { this.toast.warning('Ingresa un importe mayor a 0'); return; }
    this.rowDataDetalle = [...this.rowDataDetalle, {
      conceptoFinancieroId: Number(conceptoFinancieroId),
      cntasPagarId: Number(cntasPagarId),
      importe: Number(importe),
      conceptoNombre: this.conceptos.find(c => c.id === conceptoFinancieroId)?.nombre ?? `#${conceptoFinancieroId}`,
      cuentaPagarLabel: this.cuentasPagar.find(c => c.id === cntasPagarId)?.nombre ?? `#${cntasPagarId}`,
    }];
    this.gridApiDetalle?.setGridOption('rowData', this.rowDataDetalle);
    this.nuevoDetalle = { conceptoFinancieroId: null, cntasPagarId: null, importe: null };
  }

  quitarDetalle(): void {
    if (!this.detalleSeleccionado) { this.toast.warning('Selecciona una línea para quitar'); return; }
    this.rowDataDetalle = this.rowDataDetalle.filter((d) => d !== this.detalleSeleccionado);
    this.gridApiDetalle?.setGridOption('rowData', this.rowDataDetalle);
    this.detalleSeleccionado = null;
  }

  get totalDetalle(): number {
    return this.rowDataDetalle.reduce((s, d) => s + (Number(d.importe) || 0), 0);
  }

  // ── Acciones ────────────────────────────────────────────────────────────────
  guardar(): void {
    if (this.form.invalid) { this.toast.warning('Completa: solicitud de giro, concepto, fecha y tasa de cambio'); return; }
    if (this.rowDataDetalle.length === 0) { this.toast.warning('Agrega al menos una línea de detalle'); return; }
    const f = this.form.getRawValue();
    const importeNeto = this.totalDetalle;
    const esEdicion = !!this.filaSeleccionada?.id;
    const entity: LiqRendicionEntity = {
      id: this.filaSeleccionada?.id,
      lr_num_liquidacion: this.filaSeleccionada?.lr_num_liquidacion ?? '',
      lr_fecha_desembolso: f.fechaLiquidacion,
      lr_monto_gastado: importeNeto,
      lr_moneda: this.filaSeleccionada?.lr_moneda ?? '',
      lr_estado: this.filaSeleccionada?.lr_estado ?? 'Pendiente',
      lr_solicitud_giro_id: Number(f.solicitudGiroId),
      lr_concepto_financiero_id: Number(f.conceptoFinancieroId),
      lr_importe_neto: importeNeto,
      lr_tasa_cambio: Number(f.tasaCambio),
      lr_moneda_id: f.monedaId != null ? Number(f.monedaId) : undefined,
      lr_observacion: f.observacion ?? '',
      lr_detalles: this.rowDataDetalle.map((d, i) => ({ ...d, item: i + 1 })),
    };
    if (esEdicion) {
      this.facade.actualizar(entity);
    } else {
      this.facade.guardar(entity, false);
    }
    this.nuevaLiquidacion();
    setTimeout(() => this.facade.cargarDatos(), 300);
  }

  anular(): void {
    if (!this.filaSeleccionada?.id) { this.toast.warning('Selecciona una liquidación para anular'); return; }
    this.facade.anular(this.filaSeleccionada.id).subscribe({
      next: () => { this.toast.success('Liquidación anulada'); this.filaSeleccionada = null; this.facade.cargarDatos(); },
      error: (e) => this.toast.danger(e?.message || 'No se pudo anular la liquidación'),
    });
  }

  nuevaLiquidacion(): void {
    this.filaSeleccionada = null;
    this.detalleSeleccionado = null;
    this.rowDataDetalle = [];
    this.gridApiDetalle?.setGridOption('rowData', []);
    this.nuevoDetalle = { conceptoFinancieroId: null, cntasPagarId: null, importe: null };
    this.form.reset({ fechaLiquidacion: new Date().toISOString().slice(0, 10), tasaCambio: 1, estado: 'Pendiente' });
    this.gridApi?.deselectAll();
  }

  async modalverActualizaciones(): Promise<void> {
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150 },
      { headerName: 'Usuario', field: 'usuario', width: 120 },
      { headerName: 'Acción', field: 'accion', width: 150, wrapText: true, autoHeight: true, cellStyle: { textAlign: 'left' } },
      { headerName: 'Detalle del cambio', field: 'detalleCambio', flex: 1, wrapText: true, autoHeight: true, cellStyle: { textAlign: 'left' } },
    ];
    const rowData = [
      { fechaHora: '—', usuario: '—', accion: 'Creación', detalleCambio: 'Registro de liquidación' },
    ];
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Liquidación ${this.filaSeleccionada?.lr_num_liquidacion ?? ''}`,
        mostrarTabla: true, colDefs, rowData, ocultarBotonConfirmar: true, textoBotonCancelar: 'Cerrar',
      },
    });
    await modal.present();
  }
}
