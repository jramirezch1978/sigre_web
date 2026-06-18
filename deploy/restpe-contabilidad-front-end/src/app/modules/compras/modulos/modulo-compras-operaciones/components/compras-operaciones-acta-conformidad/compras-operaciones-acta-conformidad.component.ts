import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormControl, FormGroup } from '@angular/forms';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { catchError, of } from 'rxjs';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ApiClientService } from 'src/app/core/infrastructure/http/api-client.service';
import { ActaConformidadFacade } from '../../../../application/facades/acta-conformidad.facade';
import {
  ActaConformidadEntity,
  ActaConformidadLineaEntity,
  OrdenServicioPendienteConformidadEntity,
} from '../../../../domain/models/acta-conformidad.entity';

import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-compras-operaciones-acta-conformidad',
  templateUrl: './compras-operaciones-acta-conformidad.component.html',
  styleUrls: ['./compras-operaciones-acta-conformidad.component.scss'],
  standalone: false,
})
export class ComprasOperacionesActaConformidadComponent implements OnInit {
  farSearch = faSearch;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  private readonly facade = inject(ActaConformidadFacade);
  private readonly api = inject(ApiClientService);
  private readonly fb = inject(FormBuilder);
  private readonly toast = inject(ToastService);

  readonly pendientes = this.facade.pendientes;
  readonly actas = this.facade.actas;
  readonly loading = this.facade.loading;
  readonly procesando = this.facade.procesando;

  vista: 'pendientes' | 'actas' = 'pendientes';
  form!: FormGroup;
  gridApi!: GridApi;
  lineasGridApi!: GridApi;

  modoRegistro = true;
  osSeleccionada: OrdenServicioPendienteConformidadEntity | null = null;
  actaSeleccionada: ActaConformidadEntity | null = null;
  lineas: ActaConformidadLineaEntity[] = [];

  localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay registros para mostrar',
  };

  pendientesColDefs: ColDef[] = [
    { field: 'nroOs', headerName: 'N° OS', flex: 1, minWidth: 100, filter: true },
    { field: 'proveedorRazonSocial', headerName: 'Proveedor', flex: 1.6, minWidth: 150, filter: true },
    { field: 'fecRegistro', headerName: 'Fec. Registro', flex: 1, minWidth: 110 },
    {
      field: 'montoTotal',
      headerName: 'Monto',
      flex: 0.9,
      minWidth: 90,
      cellClass: 'text-right',
      valueFormatter: (p) => (p.value != null ? Number(p.value).toFixed(2) : '–'),
    },
  ];

  actasColDefs: ColDef[] = [
    { field: 'id', headerName: 'N° Acta', flex: 0.7, minWidth: 80, filter: true },
    { field: 'acta_orden_servicio_id', headerName: 'OS', flex: 0.7, minWidth: 70 },
    { field: 'acta_fecha', headerName: 'Fecha', flex: 1, minWidth: 100 },
    {
      field: 'acta_monto_total',
      headerName: 'Monto',
      flex: 0.9,
      minWidth: 90,
      cellClass: 'text-right',
      valueFormatter: (p) => (p.value != null ? Number(p.value).toFixed(2) : '–'),
    },
    {
      field: 'acta_estado',
      headerName: 'Estado',
      flex: 0.9,
      minWidth: 100,
      cellRenderer: (params: any) => {
        const estado = params.value;
        let clase = 'text-green-600 bg-green-100';
        if (estado === 'Anulada') clase = 'text-red-600 bg-red-100';
        else if (estado === 'Registrada') clase = 'text-amber-600 bg-amber-100';
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${clase}">${estado}</span>`;
      },
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center' },
    },
  ];

  lineasColDefs: ColDef[] = [
    { field: 'secuencia', headerName: '#', width: 60, cellClass: 'text-center' },
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
      field: 'precioUnitario',
      headerName: 'Precio Unit.',
      flex: 0.8,
      minWidth: 90,
      editable: true,
      cellClass: 'text-right',
      cellStyle: { cursor: 'pointer' },
      valueParser: (p) => Number(p.newValue) || 0,
    },
    {
      field: 'subtotal',
      headerName: 'Subtotal',
      flex: 0.8,
      minWidth: 90,
      cellClass: 'text-right',
      valueGetter: (p) => (Number(p.data?.cantidad) || 0) * (Number(p.data?.precioUnitario) || 0),
      valueFormatter: (p) => (p.value != null ? Number(p.value).toFixed(2) : '0.00'),
    },
    {
      headerName: '',
      colId: 'acciones',
      width: 50,
      cellRenderer: () => `<span class="text-red-500 cursor-pointer" title="Quitar">✕</span>`,
      cellStyle: { display: 'flex', justifyContent: 'center', alignItems: 'center', cursor: 'pointer' },
    },
  ];

  constructor() {
    effect(() => {
      const data = this.vista === 'pendientes' ? this.pendientes() : this.actas();
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', data);
      }
    });

    effect(() => {
      const msg = this.facade.mensajeExito();
      if (msg && this.form) {
        this.toast.success(msg);
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
      nroOs: new FormControl(''),
      proveedor: new FormControl(''),
      fecha: new FormControl(this.fechaHoyISO()),
      observacion: new FormControl(''),
    });

    this.facade.cargarPendientes();
    this.facade.cargarActas();
  }

  cambiarVista(vista: 'pendientes' | 'actas'): void {
    this.vista = vista;
    const data = vista === 'pendientes' ? this.pendientes() : this.actas();
    if (this.gridApi) {
      this.gridApi.setGridOption('columnDefs', vista === 'pendientes' ? this.pendientesColDefs : this.actasColDefs);
      this.gridApi.setGridOption('rowData', data);
    }
  }

  onGridReady(params: GridReadyEvent): void {
    this.gridApi = params.api;
    this.gridApi.setGridOption('rowData', this.pendientes());
  }

  onLineasGridReady(params: GridReadyEvent): void {
    this.lineasGridApi = params.api;
    this.refrescarLineas();
  }

  onGridCellClicked(event: any): void {
    if (!event.data) {
      return;
    }
    if (this.vista === 'pendientes') {
      this.seleccionarPendiente(event.data as OrdenServicioPendienteConformidadEntity);
    } else {
      this.seleccionarActa(event.data as ActaConformidadEntity);
    }
  }

  private seleccionarPendiente(os: OrdenServicioPendienteConformidadEntity): void {
    this.modoRegistro = true;
    this.osSeleccionada = os;
    this.actaSeleccionada = null;
    this.form.patchValue({
      nroOs: os.nroOs,
      proveedor: os.proveedorRazonSocial,
      fecha: this.fechaHoyISO(),
      observacion: '',
    });
    this.lineas = [];
    this.prefillLineasDesdeOs(os.ordenServicioId);
    this.refrescarLineas();
  }

  private seleccionarActa(acta: ActaConformidadEntity): void {
    this.modoRegistro = false;
    this.actaSeleccionada = acta;
    this.osSeleccionada = null;
    this.form.patchValue({
      nroOs: String(acta.acta_orden_servicio_id),
      proveedor: acta.acta_proveedor || '',
      fecha: (acta.acta_fecha || '').substring(0, 10),
      observacion: acta.acta_observacion || '',
    });
    this.lineas = (acta.acta_lineas ?? []).map((l, i) => ({ ...l, secuencia: i + 1 }));
    this.refrescarLineas();
  }

  /** Mejor esfuerzo: precarga las líneas del acta desde el detalle de la OS. */
  private prefillLineasDesdeOs(ordenServicioId: number): void {
    if (!ordenServicioId) {
      return;
    }
    this.api
      .get<any>(`/compras/ordenes-servicio/${ordenServicioId}`)
      .pipe(catchError(() => of(null)))
      .subscribe((dto) => {
        if (!dto) {
          return;
        }
        const detalles = dto.detalles ?? dto.lineas ?? dto.det ?? [];
        if (!Array.isArray(detalles) || !detalles.length) {
          return;
        }
        this.lineas = detalles.map((d: any, i: number) => ({
          secuencia: i + 1,
          descripcion: d.descripcion ?? d.servicio ?? d.detalle ?? `Línea ${i + 1}`,
          cantidad: Number(d.cantidad ?? d.cant ?? 1),
          precioUnitario: Number(d.precioUnitario ?? d.precioUni ?? d.precio ?? 0),
        }));
        this.refrescarLineas();
      });
  }

  agregarLinea(): void {
    this.lineas = [
      ...this.lineas,
      { secuencia: this.lineas.length + 1, descripcion: '', cantidad: 1, precioUnitario: 0 },
    ];
    this.refrescarLineas();
  }

  onLineasCellClicked(event: any): void {
    if (event.colDef?.colId === 'acciones' && event.data) {
      this.lineas = this.lineas.filter((l) => l !== event.data);
      this.lineas.forEach((l, i) => (l.secuencia = i + 1));
      this.refrescarLineas();
    }
  }

  private refrescarLineas(): void {
    if (this.lineasGridApi) {
      this.lineasGridApi.setGridOption('rowData', this.lineas);
    }
  }

  registrarActa(): void {
    if (!this.osSeleccionada) {
      this.toast.warning('Selecciona una OS pendiente de conformidad.');
      return;
    }
    if (!this.lineas.length) {
      this.toast.warning('Agrega al menos una línea de conformidad.');
      return;
    }
    const v = this.form.getRawValue();
    const acta: ActaConformidadEntity = {
      acta_orden_servicio_id: this.osSeleccionada.ordenServicioId,
      acta_nro_os: this.osSeleccionada.nroOs,
      acta_proveedor: this.osSeleccionada.proveedorRazonSocial,
      acta_proveedor_id: this.osSeleccionada.proveedorId,
      acta_fecha: v.fecha,
      acta_observacion: v.observacion,
      acta_aprobado: false,
      acta_estado: 'Registrada',
      acta_lineas: this.lineas.map((l, i) => ({
        secuencia: i + 1,
        descripcion: l.descripcion,
        cantidad: Number(l.cantidad) || 0,
        precioUnitario: Number(l.precioUnitario) || 0,
      })),
    };
    this.facade.crearActa(acta, () => this.limpiar());
  }

  aprobarActa(): void {
    if (!this.actaSeleccionada?.id) {
      this.toast.warning('Selecciona un acta registrada para aprobar.');
      return;
    }
    this.facade.aprobarActa(String(this.actaSeleccionada.id));
  }

  anularActa(): void {
    if (!this.actaSeleccionada?.id) {
      this.toast.warning('Selecciona un acta para anular.');
      return;
    }
    this.facade.anularActa(String(this.actaSeleccionada.id));
  }

  descargarPdf(): void {
    if (!this.actaSeleccionada?.id) {
      this.toast.warning('Selecciona un acta para descargar el PDF.');
      return;
    }
    this.facade.descargarPdf(String(this.actaSeleccionada.id));
  }

  limpiar(): void {
    this.modoRegistro = true;
    this.osSeleccionada = null;
    this.actaSeleccionada = null;
    this.lineas = [];
    this.form.reset({ fecha: this.fechaHoyISO() });
    this.refrescarLineas();
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  refrescar(): void {
    if (this.vista === 'pendientes') {
      this.facade.cargarPendientes();
    } else {
      this.facade.cargarActas();
    }
  }

  private fechaHoyISO(): string {
    const hoy = new Date();
    return `${hoy.getFullYear()}-${String(hoy.getMonth() + 1).padStart(2, '0')}-${String(hoy.getDate()).padStart(2, '0')}`;
  }
}
