import { Component, OnInit, inject } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalAsignacionDistribucionComponent } from '../../modals/modal-asignacion-distribucion/modal-asignacion-distribucion.component';
import { ModalDetalleCalculoComponent } from '../../../procesos-de-nomina/modals/modal-detalle-calculo/modal-detalle-calculo.component';

import { RrHhFacade } from '../../../application/facades/rr-hh.facade';
import { DistribucionCostosEntity } from '../../../domain/models/distribucion-costos.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload } from '@fortawesome/pro-solid-svg-icons';




@Component({
  selector: 'app-r-a-distribucion-costos',
  templateUrl: './r-a-distribucion-costos.component.html',
  styleUrls: ['./r-a-distribucion-costos.component.scss'],
  standalone: false,

})
export class RADistribucionCostosComponent implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;




  periodoMes: number | null = null;
  periodoAnio: number | null = null;
  reporteGenerado: boolean = false;

  sucursalesSeleccionadas: string[] = [];
  centroSeleccionados: string[] = [];
  canalSeleccionado: string[] = [];
  // Propiedades para campos de modal
  campoId: string = '';
  campoNombre: string = '';
  campoTipo: string = '';
  campoEstado: string = '';
  tipoDistribucionSeleccionado: string = 'porcentaje';

  private readonly rrHhFacade = inject(RrHhFacade);
  readonly isLoading = this.rrHhFacade.loadingDistribucionCostos;

  context: any;
  private gridApiDetalle!: GridApi;

  canales = [
    { id: 'delivery', nombre: 'Delivery' },
    { id: 'salon', nombre: 'Salón' },
  ];
  sucursales = [
    { id: 'La Molina, Lima', nombre: 'La Molina, Lima', direccion: 'Av. La Molina 1234', estado: 'Activa' },
    { id: 'San Isidro, Lima', nombre: 'San Isidro, Lima', direccion: 'Av. La Molina 1234', estado: 'Inactiva' },
    { id: 'San Borja, Lima', nombre: 'San Borja, Lima', direccion: 'Av. La Molina 1234', estado: 'Activa' },
    { id: 'Santa Isabel, Piura', nombre: 'Santa Isabel, Piura', direccion: 'Av. La Molina 1234', estado: 'Activa' },
  ];
  centros = [
    { id: 'cocina', nombre: 'Cocina', tipo: 'Administrativo', estado: 'Activa' },
    { id: 'terraza', nombre: 'Terraza', tipo: 'Administrativo', estado: 'Inactiva' },
    { id: 'administraion', nombre: 'Administración', tipo: 'Administrativo', estado: 'Activa' },
    { id: 'limpieza', nombre: 'Limpieza', tipo: 'Operativo', estado: 'Activa' },
  ];

  tiposDistribucion = [
    {value: 'porcentaje', label: 'Porcentaje'},
    {value: 'fijo', label: 'Valor fijo'},
    {value: 'horas', label: 'Horas trabajadas'},
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
    noRowsToShow: 'No hay datos para mostrar'
  };

  rowDataDetalle: DistribucionCostosEntity[] = [
    { distribucion_costos_periodo: '202602', distribucion_costos_trabajador: 'Juan Proma Sandoval García', distribucion_costos_sucursal: 'La Molina, Lima', distribucion_costos_centro_costo: 'Administración', distribucion_costos_canal: 'Cocina', distribucion_costos_tipo_distribucion: 'Porcentaje', distribucion_costos_aplicado: 92, distribucion_costos_monto_asig: 5140.00},
    { distribucion_costos_periodo: '202602', distribucion_costos_trabajador: 'Juan Proma Sandoval García', distribucion_costos_sucursal: 'La Molina, Lima', distribucion_costos_centro_costo: 'Administración', distribucion_costos_canal: 'Salón', distribucion_costos_tipo_distribucion: 'Porcentaje', distribucion_costos_aplicado: 20, distribucion_costos_monto_asig: 5126.00},
    { distribucion_costos_periodo: '202602', distribucion_costos_trabajador: 'Juan Proma Sandoval García', distribucion_costos_sucursal: 'La Molina, Lima', distribucion_costos_centro_costo: 'Administración', distribucion_costos_canal: 'Delivery', distribucion_costos_tipo_distribucion: 'Porcentaje', distribucion_costos_aplicado: 23, distribucion_costos_monto_asig: 5120.00},
    { distribucion_costos_periodo: '202602', distribucion_costos_trabajador: 'Juan Proma Sandoval García', distribucion_costos_sucursal: 'La Molina, Lima', distribucion_costos_centro_costo: 'Administración', distribucion_costos_canal: 'Cocina', distribucion_costos_tipo_distribucion: 'Porcentaje', distribucion_costos_aplicado: 92, distribucion_costos_monto_asig: 5640.00},
    { distribucion_costos_periodo: '202602', distribucion_costos_trabajador: 'Juan Proma Sandoval García', distribucion_costos_sucursal: 'La Molina, Lima', distribucion_costos_centro_costo: 'Administración', distribucion_costos_canal: 'Delivery', distribucion_costos_tipo_distribucion: 'Porcentaje', distribucion_costos_aplicado: 23, distribucion_costos_monto_asig: 5120.00},
    { distribucion_costos_periodo: '202602', distribucion_costos_trabajador: 'Juan Proma Sandoval García', distribucion_costos_sucursal: 'La Molina, Lima', distribucion_costos_centro_costo: 'Administración', distribucion_costos_canal: 'Salón', distribucion_costos_tipo_distribucion: 'Porcentaje', distribucion_costos_aplicado: 20, distribucion_costos_monto_asig: 5120.00 }
  ];

  colDefsDetalle: ColDef[] = [
    { field: 'distribucion_costos_periodo', headerName: 'Periodo', width: 70 },
    { field: 'distribucion_costos_trabajador', headerName: 'Trabajador', flex: 1, minWidth: 150, },
    { field: 'distribucion_costos_sucursal', headerName: 'Sucursal', width: 120, },
    { field: 'distribucion_costos_centro_costo', headerName: 'Centro de costo', width: 150, },
    { field: 'distribucion_costos_canal', headerName: 'Canal', width: 130, },
    { field: 'distribucion_costos_tipo_distribucion', headerName: 'Tipo distribución', width: 130, },
    {
      field: 'distribucion_costos_aplicado', headerName: '% Aplicado', headerClass:'derechaencabezado', width: 130,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      valueFormatter: (params) => params.value ? `${params.value}%` : ''
    },
    {
      field: 'distribucion_costos_monto_asig', headerName: 'Monto Asignado', headerClass: 'derechaencabezado', width: 130,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right' },
      valueFormatter: (params: any) => {
        if (params.value) {
          return `S/ ${Number(params.value).toLocaleString('es-PE', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
        }
        return '-';
      }
    },

  ];



  constructor(
    private modalController: ModalController,
    private toastService: ToastService,
  ) { }

  ngOnInit() {
    // Dejar período como null para mostrar placeholder hasta que el usuario seleccione
    this.periodoMes = null;
    this.periodoAnio = null;

    // Inicializar contexto para grid
    this.context = {
      componentParent: this
    };

    // Inicializar arrays vacíos
    this.sucursalesSeleccionadas = [];
    this.centroSeleccionados = [];
  }



  onPeriodoContableChange(event: { month: number, year: number }) {
    console.log('Periodo contable:', event);
    this.periodoMes = event.month;
    this.periodoAnio = event.year;
  }

  onsucursalesSeleccionadas(sucursal: any) {
    if (sucursal) {
      this.sucursalesSeleccionadas = sucursal;
    } else {
      this.sucursalesSeleccionadas = [];
    }
  }
  oncentrosSeleccionadas(centro: any) {
    if (centro) {
      this.centroSeleccionados = centro;
    }
  }

  onGridReadyDetalle(params: GridReadyEvent) {
    this.gridApiDetalle = params.api;
  }

  onCanalSeleccionado(canal: any) {
    this.canalSeleccionado = canal;
  }

  async modalverActualizaciones() {
    const colDefs = [
      {
        headerName: 'Fecha y hora',
        field: 'fechaHora',
        width: 150
      },
      {
        headerName: 'Usuario',
        field: 'usuario',
        width: 120
      },
      {
        headerName: 'Acción',
        field: 'accion',
        width: 150
      },
      {
        headerClass: 'centrarencabezado',
        headerName: 'Detalle del cambio',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        field: 'detalleCambio',
        flex: 1
      },
    ];

    const rowData = [
      {
        fechaHora: '10/01/2026 10:30',
        usuario: 'Diego Alarcón',
        accion: 'Creación',
        detalleCambio: 'Reporte inicial generado'
      },
      {
        fechaHora: '10/01/2026 14:15',
        usuario: 'María González',
        accion: 'Actualización',
        detalleCambio: 'Cambio de sucursales seleccionadas'
      }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones de Distribución de Costos',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      }
    });

    await modal.present();
  }

  generarReporte() {
    this.reporteGenerado = true;
    this.rrHhFacade.cargarDistribucionCostos();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowDataDetalle = this.rrHhFacade.distribucionCostos();
        this.toastService.success('¡Reporte generado exitosamente!');
        clearInterval(timer);
      }
    }, 100);
  }

  async abrirModalAutocomplete(tipo: string): Promise<void> {
    let titulo = '';
    let datos: any[] = [];
    let subtitulo = '';
    let colDefs: ColDef[] = [];


    // Determinar qué datos mostrar según el tipo
    if (tipo === 'sucursales') {
      titulo = 'Sucursales seleccionadas';
      // Obtener los datos de sucursales seleccionadas
      datos = this.sucursales.filter(s => this.sucursalesSeleccionadas.includes(s.id));
      subtitulo = `Total sucursales: ${String(datos.length).padStart(2, '0')}`;

      // Columnas específicas para sucursales
      colDefs = [
        { field: 'nombre', headerName: 'Nombre de Sucursal', width: 140 },
        { field: 'direccion', headerName: 'Dirección', flex:1 , minWidth: 180 },
        {
          field: 'estado', headerName: 'Estado', headerClass:'centrarencabezado', width: 70,
          cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
          cellRenderer: (params: any) => {
            if (params.value === 'Activa') {
              return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activa</span>'
            } else if (params.value === 'Inactiva') {
              return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactiva</span>'
            }
            return params.value;
          }
        }

      ];
    } else if (tipo === 'centros') {
      titulo = 'Centros de costo seleccionados';
      // Obtener los datos de centros seleccionados
      datos = this.centros.filter(c => this.centroSeleccionados.includes(c.id));
      subtitulo = `Total c. de costos: ${String(datos.length).padStart(2, '0')}`;

      // Columnas específicas para centros
      colDefs = [
        { field: 'nombre', headerName: 'Nombre de centro de costo', flex: 1, minWidth: 150 },
        { field: 'tipo', headerName: 'Tipo', minWidth: 100 },
        {
          field: 'estado', headerName: 'Estado', headerClass:'centrarencabezado', width: 70,
          cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
          cellRenderer: (params: any) => {
            if (params.value === 'Activa') {
              return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Activa</span>'
            } else if (params.value === 'Inactiva') {
              return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Inactiva</span>'
            }
            return params.value;
          }
        }

      ];
    }

    if (datos.length === 0) {
      this.toastService.danger('No hay selecciones para mostrar');
      return;
    }

    const modal = await this.modalController.create({
      component: ModalDetalleCalculoComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: titulo,
        tituloTabla1: subtitulo,
        colDefs1: colDefs,
        rowData1: datos,
        mostrarIcono: false,

      }
    });

    await modal.present();
  }

  verDetalle(event: Event) {
    event.stopPropagation();
    this.abrirModalAsignar();
  }

  async abrirModalAsignar(): Promise<void> {
    const modal = await this.modalController.create({
      component: ModalAsignacionDistribucionComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: 'Asignar Distribución',
        textoBotonCancelar: 'Cerrar',
        ocultarBotonConfirmar: false,
        tipo: this.tipoDistribucionSeleccionado,
      }
    });

    await modal.present();
  }

}
