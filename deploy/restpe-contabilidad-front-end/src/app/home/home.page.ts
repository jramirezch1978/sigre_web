import { Component } from '@angular/core';
import type { ColDef, ICellRendererParams, GridReadyEvent, GridApi, CellClickedEvent, RowClickedEvent } from 'ag-grid-community';
import { themeBalham } from 'ag-grid-community';
import { Talonario, TalonariosService } from '../services/serviciotabla';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Subscription } from 'rxjs';
import { SegmentChangeEventDetail } from '@ionic/angular';
import { IonSegmentCustomEvent } from '@ionic/core';

// Font Awesome Icons
import { faCalendar, faQuestionCircle } from '@fortawesome/pro-regular-svg-icons';
import { faAnglesUp, faSortDown, faXmark } from '@fortawesome/pro-solid-svg-icons';

// Font Awesome Icons

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  standalone: false,
})
export class HomePage {
  // Font Awesome Icons
  farCalendar = faCalendar;
  farQuestionCircle = faQuestionCircle;
  fasAnglesUp = faAnglesUp;
  fasSortDown = faSortDown;
  fasXmark = faXmark;



  // ---- TABS
  tab = 'talonarios';

  // ---- AG GRID
  gridApi!: GridApi<Talonario>;
  baseTheme = themeBalham;
  get theme() { return this.baseTheme; }
  getRowId = (p: any) => p.data.id;

rowDataColIzq: Talonario[] = [];

  // Formulario derecho
  form!: FormGroup;

    // Suscripciones
  private sub = new Subscription();

  colDefsColIzq: ColDef<Talonario>[] = [
    { field: 'talonario',        width: 202, minWidth: 105, headerClass: 'font-normal px-1' },
    { field: 'prefijo',          width: 52,  minWidth: 40,  headerClass: 'font-normal px-1' },
    { field: 'número desde',     width: 72,  minWidth: 40,  headerClass: 'font-normal px-1' },
    { field: 'número hasta',     width: 72,  minWidth: 40,  headerClass: 'font-normal px-1' },
    { field: 'próximo número',   width: 72,  minWidth: 40,  headerClass: 'font-normal px-1', flex: 1 , resizable: true },

    {
      headerName: '',
      colId: 'acciones',
      pinned: 'right',
      width: 30, minWidth: 30, maxWidth: 30,
      resizable: false, suppressSizeToFit: true,
      suppressHeaderMenuButton: true,
      suppressHeaderContextMenu: true,
      cellStyle: { padding: '0', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      // renderer solo visual (ajusta a tu preferencia)
      cellRenderer: () => `
        <button type="button" class="flex justify-center items-center text-red-500" title="Eliminar">
            <svg viewBox="0 0 16 16" width="16" height="16" aria-hidden="true">
          <path d="M3.7 3.7l8.6 8.6m0-8.6L3.7 12.3"
                stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
        </svg>
        </button>
      `,
    },
  ];

  constructor(
    private talonariosSvc: TalonariosService,
    private fb: FormBuilder
  ) {}

   ngOnInit() {
    // Data izquierda
    this.sub.add(
      this.talonariosSvc.getAll$().subscribe(list => {
        this.rowDataColIzq = list;
      })
    );

    // Form derecho
    this.form = this.fb.group({
      talonario: [''],
      prefijo: [''],
      numeroDesde: [''],
      numeroHasta: [''],
      proximoNumero: [''],
      porDefecto: [false],
      metodoNumeracion: ['Automática'],
      facturaVenta: [false],
      notaDebito: [false],
      notaCredito: [false],
      tipoComprobante: ['x'],
      ordenPago: [false],
      recibo: [false],
      remito: [false],
      facturaElectronica: [false],
    });

    // Sincroniza selección -> formulario
    this.sub.add(
      this.talonariosSvc.getSelected$().subscribe(sel => {
        if (sel) this.form.patchValue(sel, { emitEvent: false });
      })
    );
  }
  
  ngOnDestroy() { this.sub.unsubscribe(); }

  onGridReady(e: GridReadyEvent<Talonario>) {
    this.gridApi = e.api;
    // Fuerza a tomar defs y ajusta al contenedor
    this.gridApi.setGridOption?.('columnDefs', this.colDefsColIzq);
    this.gridApi.sizeColumnsToFit?.();
  }

   // Click sobre una fila => seleccionar
  onRowClicked(e: RowClickedEvent<Talonario>) {
    // Si el click fue en el botón de acciones, ignorar
    if (e.event && (e.event.target as HTMLElement)?.closest('button')) return;
    if (e.data) {
      this.talonariosSvc.selectById(e.data.id);
    }
  }

  onTabChange(ev: CustomEvent) {
    this.tab = ev.detail.value as string;
    if (this.tab === 'talonarios') {
      // Espera al paint de la pestaña y ajusta columnas
      requestAnimationFrame(() => {
        this.gridApi?.setGridOption?.('columnDefs', this.colDefsColIzq);
        this.gridApi?.sizeColumnsToFit?.();
      });
    }
  }

   // Botón Guardar
  guardar() {
    const sel = this.talonariosSvc.selectedValue;
    if (!sel) return;
    this.talonariosSvc.update(sel.id, this.form.value);
  }

  // Botón Nuevo talonario (resetea form)
  nuevoTalonario() {
    this.form.reset({
      talonario: '',
      prefijo: '',
      numeroDesde: '',
      numeroHasta: '',
      proximoNumero: '',
      porDefecto: false,
      metodoNumeracion: 'Automática',
      facturaVenta: false,
      notaDebito: false,
      notaCredito: false,
      tipoComprobante: 'x',
      ordenPago: false,
      recibo: false,
      remito: false,
      facturaElectronica: false,
    });
  }

}
