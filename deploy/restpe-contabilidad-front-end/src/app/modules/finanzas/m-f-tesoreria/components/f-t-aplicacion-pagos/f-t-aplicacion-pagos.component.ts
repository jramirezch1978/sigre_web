import { Component, OnInit, inject, computed, effect } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { AplicacionPagosFacade } from 'src/app/modules/finanzas/application/facades/aplicacion-pagos.facade';
import { AplicacionPagosEntity } from 'src/app/modules/finanzas/domain/models/aplicacion-pagos.entity';
import { OpcionPago } from 'src/app/modules/finanzas/domain/repositories/iaplicacion-pagos.repository';
import { AplicacionPagosSyncEffects } from 'src/app/modules/finanzas/effects/aplicacion-pagos-sync.effect';
import { AplicacionPagosFeedbackEffects } from 'src/app/modules/finanzas/effects/aplicacion-pagos-feedback.effect';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

/**
 * Cartera de Pagos (Tesorería) — conectado al backend real.
 * Lista documentos por pagar (`/api/finanzas/cuentas-pagar`), permite seleccionar varios
 * y registrar un pago consolidado en caja/bancos (`POST /api/finanzas/caja-bancos`, P),
 * con ejecutar (`/{id}/ejecutar`) y anular (`/{id}/anular`).
 * La UI mock anterior (planillas/trabajadores) se removió del template (recuperable por git).
 */
@Component({
  selector: 'app-f-t-aplicacion-pagos',
  templateUrl: './f-t-aplicacion-pagos.component.html',
  styleUrls: ['./f-t-aplicacion-pagos.component.scss'],
  standalone: false,
})
export class FTAplicacionPagosComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsLeft = faChevronsLeft;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  readonly facade = inject(AplicacionPagosFacade);
  readonly loaderActivo = computed(() => this.facade.isLoading());
  private readonly _sync = inject(AplicacionPagosSyncEffects);
  private readonly _feedback = inject(AplicacionPagosFeedbackEffects);

  panelLateralVisible = true;
  busqueda = '';

  // Cabecera del pago
  form!: FormGroup;
  bancos: OpcionPago[] = [];
  conceptos: OpcionPago[] = [];

  // Grilla de documentos por pagar
  private gridApi!: GridApi;
  rowData: AplicacionPagosEntity[] = [];
  cantidadSeleccionadas = 0;

  /** Id del último movimiento de pago creado (para ejecutar/anular). */
  ultimoPagoId: number | null = null;

  localeText = {
    page: 'Página', to: 'a', of: 'de', next: 'Siguiente', last: 'Último', first: 'Primero',
    previous: 'Anterior', loadingOoo: 'Cargando...', noRowsToShow: 'No hay documentos por pagar',
  };

  colDefs: ColDef[] = [
    { headerCheckboxSelection: true, checkboxSelection: (p: any) => p.data && p.data.ap_estado === 'Pendiente',
      width: 40, headerName: '', pinned: 'left' },
    { field: 'ap_tipoDoc', headerName: 'Tipo doc.', width: 110, filter: true },
    { field: 'ap_serieNumDoc', headerName: 'N° documento', width: 140, filter: true },
    { field: 'ap_proveedor', headerName: 'Proveedor', flex: 1, minWidth: 180, filter: true },
    { field: 'ap_fechaPago', headerName: 'Vencimiento', width: 120,
      valueFormatter: (p: any) => p.value ? String(p.value).slice(0, 10) : '' },
    { field: 'ap_moneda', headerName: 'Moneda', width: 90, filter: true },
    { field: 'ap_montoTotal', headerName: 'Total', width: 110, headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'end' },
      valueFormatter: (p: any) => (p.value != null ? Number(p.value).toFixed(2) : '-') },
    { field: 'ap_saldo', headerName: 'Saldo', width: 110, headerClass: 'derechaencabezado',
      cellStyle: { display: 'flex', justifyContent: 'end' },
      valueFormatter: (p: any) => (p.value != null ? Number(p.value).toFixed(2) : '-') },
    { field: 'ap_estado', headerName: 'Estado', width: 110, headerClass: 'centrarencabezado',
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (p: any) => {
        if (p.value === 'Pendiente') { return `<span class="badge-table bg-[#F5F5F5] text-[#1F1F1F]">Pendiente</span>`; }
        if (p.value === 'Pagada') { return `<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Pagada</span>`; }
        if (p.value === 'Anulada') { return `<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulada</span>`; }
        return p.value;
      } },
  ];

  constructor(private fb: FormBuilder, private modalController: ModalController, private toast: ToastService) {
    this.form = this.fb.group({
      bancoCntaId: [null, Validators.required],
      conceptoFinancieroId: [null, Validators.required],
      fechaEmision: [new Date().toISOString().slice(0, 10), Validators.required],
      observacion: [''],
    });

    effect(() => {
      this.rowData = [...this.facade.registros()];
      this.aplicarBuscador();
    });
  }

  ngOnInit(): void {
    this.facade.cargarDatos();
    this.facade.listarBancos().subscribe({ next: (b) => (this.bancos = b), error: () => (this.bancos = []) });
    this.facade.listarConceptos().subscribe({ next: (c) => (this.conceptos = c), error: () => (this.conceptos = []) });
  }

  /** Ionic cachea la página; recarga los documentos por pagar en CADA entrada
   *  (refleja lo que se pagó/anuló o lo que entró como nuevo por pagar). */
  ionViewWillEnter(): void {
    this.facade.cargarDatos();
  }

  // ── Grilla + buscador ───────────────────────────────────────────────────────
  onGridReady(e: GridReadyEvent): void { this.gridApi = e.api; this.aplicarBuscador(); }

  onBuscar(): void { this.aplicarBuscador(); }

  private aplicarBuscador(): void {
    const t = (this.busqueda ?? '').trim().toLowerCase();
    const filtradas = !t ? this.rowData : this.rowData.filter((d) =>
      `${d.ap_serieNumDoc ?? ''} ${d.ap_proveedor ?? ''} ${d.ap_tipoDoc ?? ''} ${d.ap_estado ?? ''}`
        .toLowerCase().includes(t));
    this.gridApi?.setGridOption('rowData', filtradas);
  }

  exportarExcel(): void {
    this.gridApi?.exportDataAsExcel({ fileName: 'cartera-pagos.xlsx', sheetName: 'Cartera de pagos' });
  }

  onBtReset(): void { this.facade.cargarDatos(); }

  togglePanelLateral(): void { this.panelLateralVisible = !this.panelLateralVisible; }

  onSelectionChanged(): void {
    const seleccionados = this.gridApi?.getSelectedNodes().map((n) => n.data) ?? [];
    this.rowData.forEach((r) => (r.ap_seleccionado = seleccionados.some((s) => s?.id === r.id)));
    this.cantidadSeleccionadas = this.rowData.filter((r) => r.ap_seleccionado).length;
  }

  get totalSeleccionado(): number {
    return this.rowData.filter((r) => r.ap_seleccionado)
      .reduce((s, d) => s + Number(d.ap_saldo ?? d.ap_montoTotal ?? 0), 0);
  }

  // ── Acciones ────────────────────────────────────────────────────────────────
  registrarPago(): void {
    if (this.form.invalid) { this.toast.warning('Completa: cuenta bancaria, concepto y fecha.'); return; }
    const docs = this.rowData.filter((r) => r.ap_seleccionado && r.ap_estado === 'Pendiente');
    if (docs.length === 0) { this.toast.warning('Selecciona al menos un documento por pagar (Pendiente).'); return; }
    const f = this.form.getRawValue();
    // La moneda del pago es la de la cuenta bancaria elegida (el backend la exige para el asiento).
    const monedaId = this.bancos.find((b) => b.id === Number(f.bancoCntaId))?.monedaId ?? null;
    this.facade.pagarDocumentos({
      bancoCntaId: Number(f.bancoCntaId),
      conceptoFinancieroId: Number(f.conceptoFinancieroId),
      fechaEmision: f.fechaEmision,
      observacion: f.observacion ?? '',
      monedaId,
      documentos: docs,
    }).subscribe({
      next: (id) => {
        this.ultimoPagoId = id;
        this.toast.success('Pago registrado. Puedes ejecutarlo para afectar saldos y generar el asiento.');
        this.gridApi?.deselectAll();
        this.facade.cargarDatos();
      },
      error: (e) => this.toast.danger(e?.message || 'No se pudo registrar el pago.'),
    });
  }

  async ejecutarPago(): Promise<void> {
    if (this.ultimoPagoId == null) { this.toast.warning('Primero registra un pago.'); return; }
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent, cssClass: 'promo',
      componentProps: {
        titlemodal: 'Ejecutar pago',
        title: '¿Ejecutar el pago?',
        message: 'Se afectarán los saldos de la cuenta bancaria y se generará el asiento contable. No se puede deshacer.',
        btnOkTxt: 'Ejecutar', btnCancelTxt: 'Cancelar',
      },
    });
    await modal.present();
    const { data } = await modal.onWillDismiss();
    if (data !== true) { return; }
    this.facade.ejecutarPago(this.ultimoPagoId).subscribe({
      next: () => { this.toast.success('Pago ejecutado.'); this.ultimoPagoId = null; this.facade.cargarDatos(); },
      error: (e) => this.toast.danger(e?.message || 'No se pudo ejecutar el pago.'),
    });
  }

  anularPago(): void {
    if (this.ultimoPagoId == null) { this.toast.warning('No hay un pago registrado para anular.'); return; }
    this.facade.anularPago(this.ultimoPagoId).subscribe({
      next: () => { this.toast.success('Pago anulado.'); this.ultimoPagoId = null; this.facade.cargarDatos(); },
      error: (e) => this.toast.danger(e?.message || 'No se pudo anular el pago.'),
    });
  }
}
