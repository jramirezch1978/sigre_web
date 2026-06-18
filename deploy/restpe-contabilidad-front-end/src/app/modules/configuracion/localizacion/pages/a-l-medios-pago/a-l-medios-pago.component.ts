import { Component, OnInit, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ToastService } from 'src/app/ui/services/toast.service';

// Font Awesome Icons
import { faSearch, faFileExcel } from '@fortawesome/pro-regular-svg-icons';
import { faCirclePlus, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

import { MedioPago, MedioPagoService } from './medio-pago.service';

@Component({
  selector: 'app-a-l-medios-pago',
  templateUrl: './a-l-medios-pago.component.html',
  styleUrls: ['./a-l-medios-pago.component.scss'],
  standalone: false,
})
export class ALMediosPagoComponent implements OnInit {

  private readonly service = inject(MedioPagoService);
  private readonly fb = inject(FormBuilder);
  private readonly toast = inject(ToastService);

  // Font Awesome Icons
  farSearch = faSearch;
  farFileExcel = faFileExcel;
  fasCirclePlus = faCirclePlus;
  fasRotateRight = faRotateRight;

  private gridApi!: GridApi;
  form!: FormGroup;
  rowData: MedioPago[] = [];
  private todas: MedioPago[] = [];
  busqueda = '';
  filaSeleccionada: MedioPago | null = null;
  modoCreacion = true;
  cargando = false;

  readonly estados = ['Activo', 'Inactivo'];

  colDefs: ColDef[] = [
    { field: 'codigo', headerName: 'Código', width: 110, sortable: true, filter: true },
    { field: 'nombre', headerName: 'Medio de pago', flex: 1, minWidth: 260, sortable: true, filter: true },
    {
      field: 'descripcion', headerName: 'Descripción', flex: 1, minWidth: 200, sortable: true, filter: true,
      valueFormatter: (p: any) => (p.value && String(p.value).trim()) ? p.value : '—',
    },
    {
      headerName: 'Estado', width: 100, sortable: true, headerClass: 'centrarencabezado',
      cellRenderer: (p: any) => {
        const activo = p.data?.flagEstado !== '0';
        const cls = activo ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FEE2E2] text-[#DC2626]';
        return `<span class="badge-table ${cls}">${activo ? 'Activo' : 'Inactivo'}</span>`;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
  ];

  localeText = {
    page: 'Página', of: 'de', to: 'a', next: 'Siguiente', last: 'Último',
    first: 'Primero', previous: 'Anterior', noRowsToShow: 'No hay datos para mostrar',
    loadingOoo: 'Cargando...',
  };

  ngOnInit(): void {
    this.form = this.fb.group({
      codigo: ['', [Validators.required, Validators.maxLength(30)]],
      nombre: ['', [Validators.required, Validators.maxLength(500)]],
      descripcion: ['', [Validators.maxLength(500)]],
      estado: ['Activo'],
    });
    this.cargar();
  }

  cargar(): void {
    this.cargando = true;
    this.service.listar().subscribe({
      next: (data) => {
        this.todas = data;
        this.aplicarFiltro();
        this.cargando = false;
      },
      error: (e) => { this.toast.danger(e?.message || 'Error al cargar los medios de pago'); this.cargando = false; },
    });
  }

  onGridReady(e: GridReadyEvent): void {
    this.gridApi = e.api;
    this.gridApi.setGridOption('rowData', this.rowData);
  }

  /** Filtra la lista por código o nombre (búsqueda en cliente). */
  onBuscar(): void {
    this.aplicarFiltro();
  }

  private aplicarFiltro(): void {
    const t = (this.busqueda ?? '').trim().toLowerCase();
    this.rowData = t
      ? this.todas.filter((m) => `${m.codigo} ${m.nombre} ${m.descripcion ?? ''}`.toLowerCase().includes(t))
      : [...this.todas];
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  onCellClicked(e: any): void {
    const d = e.data as MedioPago;
    if (!d) { return; }
    this.filaSeleccionada = d;
    this.modoCreacion = false;
    this.form.patchValue({
      codigo: d.codigo,
      nombre: d.nombre,
      descripcion: d.descripcion ?? '',
      estado: d.flagEstado === '0' ? 'Inactivo' : 'Activo',
    });
  }

  nuevo(): void {
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.form.reset({ codigo: '', nombre: '', descripcion: '', estado: 'Activo' });
  }

  guardar(): void {
    if (this.form.invalid) {
      this.toast.warning('Completa código y nombre');
      return;
    }
    const v = this.form.getRawValue();
    const body: MedioPago = {
      codigo: (v.codigo || '').trim(),
      nombre: (v.nombre || '').trim(),
      descripcion: (v.descripcion || '').trim(),
      flagEstado: v.estado === 'Inactivo' ? '0' : '1',
    };
    const obs = this.modoCreacion
      ? this.service.crear(body)
      : this.service.actualizar(this.filaSeleccionada!.id!, body);
    obs.subscribe({
      next: () => {
        this.toast.success(this.modoCreacion ? 'Medio de pago creado' : 'Medio de pago actualizado');
        this.nuevo();
        this.cargar();
      },
      error: (e) => this.toast.danger(e?.message || 'Error al guardar el medio de pago'),
    });
  }

  /** Borrado lógico: el backend no expone DELETE físico para el catálogo SUNAT. */
  desactivar(): void {
    if (!this.filaSeleccionada?.id) { return; }
    this.service.desactivar(this.filaSeleccionada.id).subscribe({
      next: () => { this.toast.success('Medio de pago desactivado'); this.nuevo(); this.cargar(); },
      error: (e) => this.toast.danger(e?.message || 'Error al desactivar el medio de pago'),
    });
  }

  activar(): void {
    if (!this.filaSeleccionada?.id) { return; }
    this.service.activar(this.filaSeleccionada.id).subscribe({
      next: () => { this.toast.success('Medio de pago activado'); this.nuevo(); this.cargar(); },
      error: (e) => this.toast.danger(e?.message || 'Error al activar el medio de pago'),
    });
  }

  exportarExcel(): void {
    this.gridApi?.exportDataAsExcel({ fileName: 'medios-de-pago.xlsx', sheetName: 'Medios de pago' });
  }
}
