import { Component, OnInit, inject } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ToastService } from 'src/app/ui/services/toast.service';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faCirclePlus, faRotateRight, faDownload, faAngleDown } from '@fortawesome/pro-solid-svg-icons';

import { FormaPago, FormaPagoService } from './forma-pago.service';

@Component({
  selector: 'app-a-l-formas-pago',
  templateUrl: './a-l-formas-pago.component.html',
  styleUrls: ['./a-l-formas-pago.component.scss'],
  standalone: false,
})
export class ALFormasPagoComponent implements OnInit {

  private readonly service = inject(FormaPagoService);
  private readonly fb = inject(FormBuilder);
  private readonly toast = inject(ToastService);

  // Font Awesome Icons
  farSearch = faSearch;
  fasCirclePlus = faCirclePlus;
  fasRotateRight = faRotateRight;
  fasDownload = faDownload;
  fasAngleDown = faAngleDown;

  private gridApi!: GridApi;
  form!: FormGroup;
  rowData: FormaPago[] = [];
  private todas: FormaPago[] = [];
  busqueda = '';
  filaSeleccionada: FormaPago | null = null;
  modoCreacion = true;
  cargando = false;

  readonly tipos = ['CONTADO', 'CREDITO'];
  readonly estados = ['Activo', 'Inactivo'];

  colDefs: ColDef[] = [
    { field: 'codigo', headerName: 'Código', width: 110, sortable: true, filter: true },
    { field: 'nombre', headerName: 'Nombre', flex: 1, minWidth: 220, sortable: true, filter: true },
    { field: 'tipo', headerName: 'Tipo', width: 120, sortable: true, filter: true },
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
      codigo: ['', [Validators.required, Validators.maxLength(20)]],
      nombre: ['', [Validators.required, Validators.maxLength(120)]],
      tipo: ['CONTADO', [Validators.required, Validators.maxLength(30)]],
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
      error: (e) => { this.toast.danger(e?.message || 'Error al cargar formas de pago'); this.cargando = false; },
    });
  }

  onGridReady(e: GridReadyEvent): void {
    this.gridApi = e.api;
    this.gridApi.setGridOption('rowData', this.rowData);
  }

  /** Filtra la lista por código, nombre o tipo (búsqueda en cliente). */
  onBuscar(): void {
    this.aplicarFiltro();
  }

  /** Exporta la grilla a Excel (.xlsx). */
  exportarExcel(): void {
    this.gridApi?.exportDataAsExcel({ fileName: 'formas-pago.xlsx', sheetName: 'Formas de pago' });
  }

  private aplicarFiltro(): void {
    const t = (this.busqueda ?? '').trim().toLowerCase();
    this.rowData = t
      ? this.todas.filter((f) =>
          `${f.codigo} ${f.nombre} ${f.tipo}`.toLowerCase().includes(t))
      : [...this.todas];
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  onCellClicked(e: any): void {
    const d = e.data as FormaPago;
    if (!d) { return; }
    this.filaSeleccionada = d;
    this.modoCreacion = false;
    this.form.patchValue({
      codigo: d.codigo,
      nombre: d.nombre,
      tipo: d.tipo,
      estado: d.flagEstado === '0' ? 'Inactivo' : 'Activo',
    });
  }

  nuevo(): void {
    this.modoCreacion = true;
    this.filaSeleccionada = null;
    this.form.reset({ codigo: '', nombre: '', tipo: 'CONTADO', estado: 'Activo' });
  }

  guardar(): void {
    if (this.form.invalid) {
      this.toast.warning('Completa código, nombre y tipo');
      return;
    }
    const v = this.form.getRawValue();
    const body: FormaPago = {
      codigo: (v.codigo || '').trim(),
      nombre: (v.nombre || '').trim(),
      tipo: v.tipo,
      flagEstado: v.estado === 'Inactivo' ? '0' : '1',
    };
    const obs = this.modoCreacion
      ? this.service.crear(body)
      : this.service.actualizar(this.filaSeleccionada!.id!, body);
    obs.subscribe({
      next: () => {
        this.toast.success(this.modoCreacion ? 'Forma de pago creada' : 'Forma de pago actualizada');
        this.nuevo();
        this.cargar();
      },
      error: (e) => this.toast.danger(e?.message || 'Error al guardar la forma de pago'),
    });
  }

  eliminar(): void {
    if (!this.filaSeleccionada?.id) {
      this.toast.warning('Selecciona una forma de pago para eliminar');
      return;
    }
    this.service.eliminar(this.filaSeleccionada.id).subscribe({
      next: () => { this.toast.success('Forma de pago eliminada'); this.nuevo(); this.cargar(); },
      error: (e) => this.toast.danger(e?.message || 'Error al eliminar la forma de pago'),
    });
  }
}
