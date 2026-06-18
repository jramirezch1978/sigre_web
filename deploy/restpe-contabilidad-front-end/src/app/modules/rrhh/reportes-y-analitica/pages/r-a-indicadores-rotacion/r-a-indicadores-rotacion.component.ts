import { Component, OnInit, inject } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalDetalleCalculoComponent } from '../../../procesos-de-nomina/modals/modal-detalle-calculo/modal-detalle-calculo.component';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { IndicadoresRotacionEntity } from 'src/app/modules/rrhh/domain/models/indicadores-rotacion.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faClock, faDownload, faTable, faUsers } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-r-a-indicadores-rotacion',
  templateUrl: './r-a-indicadores-rotacion.component.html',
  styleUrls: ['./r-a-indicadores-rotacion.component.scss'],
  standalone: false,
})
export class RAIndicadoresRotacionComponent implements OnInit {
  // Facade
  private readonly rrHhFacade = inject(RrHhFacade);

  // Selectores del store
  readonly isLoading = this.rrHhFacade.loadingIndicadoresRotacion;

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasClock = faClock;
  fasDownload = faDownload;
  fasTable = faTable;
  fasUsers = faUsers;


  private gridApi!: GridApi;

  // Datos del formulario
  indicadoresSeleccionados: any[] = [];
  tiposContratoSeleccionados: any[] = [];
  canalesSeleccionados: any[] = [];
  sucursalesSeleccionadas: any[] = [];
  areasProduccionSeleccionadas: any[] = [];
  umbralAusentismo: number | null = null;
  periodoSeleccionado: string = '';

  // Opciones de los dropdowns
  indicadores = [
    { label: 'Rotación', value: 'rotacion' },
    { label: 'Ausentismo', value: 'ausentismo' },
    { label: 'Dotación', value: 'dotacion' }
  ];

  tiposContrato = [
    { label: 'Indefinido', value: 'indefinido' },
    { label: 'Temporal', value: 'temporal' },
    { label: 'Rotación', value: 'rotacion' },
    { label: 'Ausentismo', value: 'ausentismo' },
    { label: 'Dotación', value: 'dotacion' }
  ];

  canales = [
    { id: 2, nombre: 'Delivery' },
    { id: 3, nombre: 'Salón' }
  ];

  sucursales = [
    { id: 2, nombre: 'La Molina, Lima' },
    { id: 3, nombre: 'San Isidro, Lima' },
    { id: 4, nombre: 'San Borja, Lima' },
    { id: 5, nombre: 'Santa Isabel, Piura' },
    { id: 6, nombre: 'CC. Real Plaza, Piura' }
  ];

  areasProduccion = [
    { id: 2, nombre: 'Cocina' },
    { id: 3, nombre: 'Terraza' },
    { id: 4, nombre: 'Administración' },
    { id: 5, nombre: 'Limpieza' }
  ];

  // Estado del reporte
  reporteGenerado: boolean = false;

  // Indicadores calculados
  rotacionPersonal = '12%';
  ingresos = 6;
  ceses = 8;
  ausentismoHoras = 83;
  ausentismoPorcentaje = '4.2%';
  dotacionActual = 82;
  dotacionIdeal = 90;
  dotacionBrecha = 8;
  dotacionBrechaPorcentaje = '-9%';

  // Grid configuration
  rowData: IndicadoresRotacionEntity[] = [];
  columnDefs: ColDef[] = [
    { field: 'indicador_rotacion_periodo', headerName: 'Periodo', flex: 0.8, minWidth: 100 },
    { field: 'indicador_rotacion_area', headerName: 'Area', flex: 1.5, minWidth: 180 },
    // { field: 'tipoContrato', headerName: 'Tipo contrato', flex: 0.9, minWidth: 100 },
    { field: 'indicador_rotacion_sucursal', headerName: 'Sucursal', flex: 1, minWidth: 140 },
    { field: 'indicador_rotacion_centro_costos', headerName: 'Centro de costos', flex: 1.2, minWidth: 140 },
    { field: 'indicador_rotacion_canal_operativo', headerName: 'Canal operativo', flex: 1, minWidth: 120 },
    {
      field: 'indicador_rotacion_ausentismo', headerName: 'Ausentismo', flex: 0.7, minWidth: 90,
      headerClass: 'centrarencabezado',
      cellRenderer: VistaCellRenderComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
    {
      field: 'indicador_rotacion_rotacion', headerName: 'Rotación', flex: 0.7, minWidth: 90,
      headerClass: 'centrarencabezado',
      cellRenderer: VistaCellRenderComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
    {
      field: 'indicador_rotacion_dotacion', headerName: 'Dotación', flex: 0.7, minWidth: 90,
      headerClass: 'centrarencabezado',
      cellRenderer: VistaCellRenderComponent,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    },
    {
      field: 'indicador_rotacion_estado',
      headerName: 'Estado',
      flex: 0.7,
      minWidth: 90,
      headerClass: 'centrarencabezado',
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
      cellRenderer: (params: any) => {
        let badgeClass = '';
        if (params.value === 'Normal') {
          badgeClass = 'bg-[#DCFDE7] text-[#16A34A]';
        } else if (params.value === 'Alto') {
          badgeClass = 'bg-[#FEE2E2] text-[#DC2626]';
        }
        return `<span class="badge-table ${badgeClass}">${params.value}</span>`;
      }
    }
  ];

  context = { componentParent: this };

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
    private toastService: ToastService,
    private modalController: ModalController,
  ) {}

  ngOnInit() { }

  get formularioValido(): boolean {
    const valido = Boolean(
      this.tiposContratoSeleccionados.length > 0 &&
      this.canalesSeleccionados.length > 0 &&
      this.sucursalesSeleccionadas.length > 0 &&
      this.areasProduccionSeleccionadas.length > 0 &&
      this.umbralAusentismo !== null &&
      this.umbralAusentismo !== undefined &&
      this.umbralAusentismo.toString() !== ''
    );

    console.log('=== Validación de formulario ===');
    console.log('Tipos contrato:', this.tiposContratoSeleccionados.length);
    console.log('Canales:', this.canalesSeleccionados.length);
    console.log('Sucursales:', this.sucursalesSeleccionadas.length);
    console.log('Áreas producción:', this.areasProduccionSeleccionadas.length);
    console.log('Umbral ausentismo:', this.umbralAusentismo);
    console.log('Formulario válido:', valido);

    return valido;
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onIndicadoresSeleccionados(indicadores: any[]) {
    this.indicadoresSeleccionados = indicadores;
    console.log('Indicadores seleccionados:', indicadores);
  }

  onTiposContratoSeleccionados(tipos: any[]) {
    this.tiposContratoSeleccionados = tipos;
    console.log('Tipos de contrato seleccionados:', tipos);
  }

  onCanalesSeleccionados(canales: any[]) {
    this.canalesSeleccionados = canales;
    console.log('Canales seleccionados:', canales);
  }

  onSucursalesSeleccionadas(sucursales: any[]) {
    this.sucursalesSeleccionadas = sucursales;
    console.log('Sucursales seleccionadas:', sucursales);
  }

  onAreasProduccionSeleccionadas(areas: any[]) {
    this.areasProduccionSeleccionadas = areas;
    console.log('Áreas de producción seleccionadas:', areas);
  }

  onPeriodoSeleccionado(periodo: any) {
    this.periodoSeleccionado = periodo;
    console.log('Periodo seleccionado:', periodo);
  }

  generarReporte() {
    this.reporteGenerado = true;
    this.rrHhFacade.cargarIndicadoresRotacion();
    const timer = setInterval(() => {
      if (!this.isLoading()) {
        this.rowData = this.rrHhFacade.indicadoresRotacion();
        if (this.gridApi) {
          this.gridApi.setGridOption('rowData', [...this.rowData]);
        }
        clearInterval(timer);
        this.toastService.success('¡Reporte generado exitosamente!');
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
        { field: 'nombre', headerName: 'Nombre de Sucursal', width: 160 },
        { field: 'direccion', headerName: 'Dirección', flex: 1, minWidth: 180 },
      ];
    } else if (tipo === 'areas' || tipo === 'areasProduccion') {
      titulo = 'Áreas seleccionadas';
      
      // Array estático de TODAS las sucursales disponibles
      const todasLasSucursales = [
        { nombre: 'La Molina, Lima' },
        { nombre: 'San Isidro, Lima' },
        { nombre: 'San Borja, Lima' },
        { nombre: 'Santa Isabel, Piura' },
        { nombre: 'CC. Real Plaza, Piura' }
      ];
      
      // Normalizar selección de áreas del autocomplete
      const seleccionNormalizada = (this.areasProduccionSeleccionadas || []).map((item: any) => {
        if (item && typeof item === 'object') {
          return item.id ?? item.value ?? item.nombre;
        }
        return item;
      });

      // Obtener áreas seleccionadas del autocomplete
      const areasSeleccionadas = this.areasProduccion.filter(a => {
        const idStr = String(a.id);
        return seleccionNormalizada.some((s: any) => String(s) === idStr || String(s) === a.nombre);
      });

      // Generar producto cartesiano: cada área seleccionada con TODAS las sucursales
      datos = [];
      areasSeleccionadas.forEach(area => {
        todasLasSucursales.forEach(sucursal => {
          datos.push({
            area: area.nombre,
            sucursal: sucursal.nombre
          });
        });
      });

      subtitulo = `Total áreas: ${String(datos.length).padStart(2, '0')}`;

      // Columnas específicas para mostrar áreas y sucursales
      colDefs = [
        { field: 'area', headerName: 'Áreas', flex: 1, minWidth: 140 },
        { field: 'sucursal', headerName: 'Sucursales', flex: 1, minWidth: 160 },
      ];
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
  async abrirModal(value: string, data: any) {
    await this.abrirdetalledetrabajadores();
  }

  async abrirdetalledetrabajadores(){
    const coldeftrabajador: ColDef[] = [
          { field: 'codtrabajador', headerName: 'Codigo', width: 70 },
          { field: 'nombre', headerName: 'Nombre del trabajador', flex:1, minWidth: 200 },
        ]
    const datatrabajador = [
      { codtrabajador: '0001', nombre: 'Juan Pérez López' },
      { codtrabajador: '0002', nombre: 'María González Torres' },
      { codtrabajador: '0003', nombre: 'Carlos Rodríguez Sánchez' },
      { codtrabajador: '0004', nombre: 'Ana Martínez Flores' },
      { codtrabajador: '0005', nombre: 'Luis Fernández Castro' },
    ];
    const modal= await this.modalController.create({
      component:ModalDetalleComponent,
      cssClass:'promo',
      componentProps:{
        tituloModal:'Detalle de trabajadores',
        mostrarTabla:true,
        mostrarTextarea:false,
        textoBotonCancelar:false,
        mostrarBotonEliminar:false,
        mostrarbuscador:true,
        colDefs:coldeftrabajador,
        rowData: datatrabajador,
      }
      });
    modal.present();
  }
}
