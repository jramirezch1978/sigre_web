import { Component, OnInit, ViewChild, inject, Signal, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { FormValidationService } from 'src/app/ui/services/form-validation.service';
import { VistaCellRenderComponent } from 'src/app/ui/vista-cell-render/vista-cell-render.component';
import { BotonAccionesComponent } from 'src/app/ui/boton-acciones/boton-acciones.component';
import { OnDestroy } from '@angular/core';
import { ModalDetalleComponent } from 'src/app/ui/modal-detalle/modal-detalle.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';

// Font Awesome Icons
import { LetraCambioFacade } from 'src/app/modules/finanzas/application/facades/letra-cambio.facade';
import { LetraCambioFeedbackEffects } from 'src/app/modules/finanzas/effects/letra-cambio-feedback.effect';
import { LetraCambioSyncEffects } from 'src/app/modules/finanzas/effects/letra-cambio-sync.effect';
import { LetraCambioEntity } from 'src/app/modules/finanzas/domain/models/letra-cambio.entity';

import { faBook, faSearch as faSearchRegular } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsLeft, faChevronsRight, faCirclePlus, faDownload, faRotateRight, faSearch as faSearchSolid } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-f-o-letras-cammbio',
  templateUrl: './f-o-letras-cammbio.component.html',
  styleUrls: ['./f-o-letras-cammbio.component.scss'],
  standalone: false,
})
export class FOLetrasCammbioComponent  implements OnInit {
  // ── Arquitectura limpia ───────────────────────────────────────────────────
  readonly letrasFacade = inject(LetraCambioFacade);
  private readonly _feedbackEffects = inject(LetraCambioFeedbackEffects);
  private readonly _syncEffects = inject(LetraCambioSyncEffects);
  readonly isLoading: Signal<boolean> = this.letrasFacade.isLoading;

  private _mensajeActualizacion = '¡Cambios guardados exitosamente!';
  private _prevLoadingActualizar = false;

  getRowId = (params: any) => params.data.letra_codigo;

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


  @ViewChild('autocompleteCuentas') autocompleteCuentas: any;

  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  fechaInicial: Date | undefined; 
  panelLateralVisible: boolean = true;

  letraForm!: FormGroup;
  private gridApi!: GridApi;
  private detalleGridApi!: GridApi;
  gridContext!: { componentParent: FOLetrasCammbioComponent};
  filaSeleccionada: any = null;
  cuentasPorCliente: any[] = []
  context: any;
  countries= ALL_COUNTRIES;
  tiposIdentificacion: any[] = [];
  estadoSelect = [
    'Emitida',
    'En gestión',
  ];
  monedas = [
    'Soles',
    'Dólares'
  ];
  bancos = [
    { id: 'banco1', nombre: 'Banco de Crédito del Perú' },
    { id: 'banco2', nombre: 'Banco Interbank' },
    { id: 'banco3', nombre: 'BBVA Perú' },
    { id: 'banco4', nombre: 'Scotiabank Perú' },
    { id: 'banco5', nombre: 'Banco Pichincha' },
    { id: 'banco6', nombre: 'Banco Falabella' },
  ];

  sucursales = [
    { id: '1', nombre: 'San Juan de lurigancho, Lima' },
    { id: '2', nombre: 'Santa Isabel, Piura' },
    { id: '3', nombre: 'Miraflores, Lima' },
    { id: '4', nombre: 'San Isidro, Lima' },
  ];

  sucursalSeleccionada: string = '';

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

  cuentas = [
  { tipoDocumento: 'Factura', nroDocumento: 'F001-00123', fechaEmision: '2025-11-10', fechaVencimiento: '2025-12-10', montoTotal: 5000,montoPendiente: 5000, moneda: 'Soles', tipoCambio: 3.75, numeroAsiento: 'MN-2025-11-01-002', estado: 'Pendiente' },
  { tipoDocumento: 'Letra', nroDocumento: 'L001-00123', fechaEmision: '2025-11-10', fechaVencimiento: '2025-12-10', montoTotal: 5000,montoPendiente: 5000, moneda: 'Soles', tipoCambio: 3.75, numeroAsiento: 'MN-2025-11-01-002', estado: 'Pendiente' },
  { tipoDocumento: 'Nota de débito', nroDocumento: 'ND-12345', fechaEmision: '2025-11-10', fechaVencimiento: '2025-12-10', montoTotal: 5000,montoPendiente: 5000, moneda: 'Soles', tipoCambio: 3.75, numeroAsiento: 'MN-2025-11-01-002', estado: 'Pendiente' }
];


  rowData: LetraCambioEntity[] = [];

  colDefs: ColDef[] = [
    { field: 'letra_codigo', headerName: 'N° de letra', width: 150 },
    { field: 'letra_cliente', headerName: 'Cliente', width: 180, filter: true },
    { field: 'letra_sucursal', headerName: 'Sucursal', width: 180, filter: true },
    { field: 'letra_fecha_emision', headerName: 'Fecha emisión', width: 120,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    { field: 'letra_fecha_vencimiento', headerName: 'Fecha vencimiento', width: 130,
      valueFormatter: (params: any) => {
        if (params.value) {
          const date = new Date(params.value);
          const day = String(date.getDate() + 1).padStart(2, '0');
          const month = String(date.getMonth() + 1).padStart(2, '0');
          const year = date.getFullYear();
          return `${day}/${month}/${year}`;
        }
        return '';
      }
    },
    { field: 'letra_monto_total', headerName: 'Monto total', headerClass:'derechaencabezado', width: 100,
      cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right'},

      valueFormatter: (params: any) => {
        if (params.data?.letra_moneda === 'Soles') {
          return `S/ ${params.value}`;
        } else if (params.data?.letra_moneda === 'Dólares') {
          return `$ ${params.value}`;
        }
        return params.value;
      }
    },
    { field: 'letra_cuotas', headerName: 'Cuotas', width: 100, filter: true },
    { field: 'letra_moneda', headerName: 'Moneda', width: 100, filter: true },
    { field: 'letra_tasa_interes', headerName: 'Tasa de interés', width: 100,
      valueFormatter: (params: any) => {
        return `${params.value} %`;
    },
    },
    { field: 'letra_asiento', headerName: 'Asiento', width: 140, cellRenderer: VistaCellRenderComponent,},
    { field: 'letra_estado', headerName: 'Estado', width: 80, headerClass: 'centrarencabezado', filter: true,
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
      cellRenderer: (params: any) => {
        if (params.value === 'En gestión') {
          return '<span class="badge-table bg-[#FFF0BF] text-[#F2A626]">En gestión</span>';
        } else if (params.value === 'Emitida') {
          return '<span class="badge-table bg-[#DCFDE7] text-[#16A34A]">Emitida</span>';
        } else if (params.value === 'Protestada') {
          return '<span class="badge-table bg-[#FFDECC] text-[#FF8947]">Protestada</span>';
        } else if (params.value === 'Anulada') {
          return '<span class="badge-table bg-[#FEE2E2] text-[#DC2626]">Anulada</span>';
        }
        return params.value;
      }
    }
  ];

  colDefsDetalle: ColDef[] = [
  { field: 'tipoDocumento', headerName: 'Tipo de documento', width: 160},
  { field: 'nroDocumento', headerName: 'N° de documento', width: 150 },
  { field: 'fechaEmision', headerName: 'Fecha de emisión', width: 150,
    valueFormatter: (params: any) => {
      if (params.value) {
        const date = new Date(params.value);
        const day = String(date.getDate() + 1).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${day}/${month}/${year}`;
      }
      return '';
    }
  },
  { field: 'fechaVencimiento', headerName: 'Fecha de vencimiento', width: 180, 
    valueFormatter: (params: any) => {
      if (params.value) {
        const date = new Date(params.value);
        const day = String(date.getDate() + 1).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${day}/${month}/${year}`;
      }
      return '';
    }
  },
  { field: 'montoTotal', headerName: 'Monto total', headerClass:'derechaencabezado', width: 130,
    cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right'},
    valueFormatter: (params: any) => {
      return `S/ ${params.value}`;
    }
  },
  { field: 'montoPendiente', headerName: 'Monto pendiente', headerClass:'derechaencabezado', width: 150,
    cellStyle: {textAlign: 'right',display: 'flex',justifyContent: 'right'},
    valueFormatter: (params: any) => {
      if (params.data?.moneda === 'Soles') {
        return `S/ ${params.value}`;
      }
      return params.value;
    }
  },
  { field: 'moneda', headerName: 'Moneda', width: 110 },
  { field: 'tipoCambio', headerName: 'Tipo de cambio', width: 130 },
  { field: 'numeroAsiento', headerName: 'N° asiento', width: 160,},
  { field: 'estado', headerName: 'Estado', width: 120, headerClass: 'centrarencabezado',
    cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
    cellRenderer: (params: any) => {
      if (params.value === 'Pendiente') {
        return '<span class="badge-table bg-[#F5F5F5] text-text-85">Pendiente</span>';
      }
      return params.value;
    }
  },
  { headerName: 'Acciones', width: 80, headerClass: 'centrarencabezado',
    cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center'},
    cellRenderer: BotonAccionesComponent,
  }
];


  constructor(
    private formBuilder: FormBuilder,
    private modalController: ModalController,
    private toastService: ToastService,
    private formValidationService: FormValidationService,
    private countryService: CountryService,
  ) {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

    // Sincronizar rowData y grid cuando cambie el store
    effect(() => {
      const letras = this.letrasFacade.letras();
      this.rowData = letras;
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', letras);
      }
    });

    // Toast específico al completar actualización
    effect(() => {
      const loading = this.letrasFacade.loadingActualizar();
      const error = this.letrasFacade.errorActualizar();
      if (this._prevLoadingActualizar && !loading && !error) {
        this.toastService.success(this._mensajeActualizacion);
        this._mensajeActualizacion = '¡Cambios guardados exitosamente!';
      }
      this._prevLoadingActualizar = loading;
    });
  }

  ngOnInit() {
    this.docpais();

    const hoy = new Date().toISOString().split('T')[0];
    this.letraForm = this.formBuilder.group({
      tipoDocumentoCliente: [this.tiposIdentificacion[0]?.value , Validators.required],
      numeroDocumentoCliente: ['', Validators.required],
      sucursal: [''],
      nombreCliente: ['', Validators.required],
      fechaE: [hoy, Validators.required],
      fechaV: [hoy, Validators.required],
      montoT: [''],
      moneda: ['Soles', Validators.required],
      tipoCambio: [{ vallue:'3.25', disabled: true }],
      tasaI: [''],
      bancoE: ['', Validators.required],
      cuentaB: ['', Validators.required],
      nroCuotas: ['', Validators.required],
      estado: ['Emitida'],
    });

    this.gridContext = { componentParent: this };
    this.formValidationService.inicializarFormulario(this.letraForm);
    this.context = { componentParent: this };
    this.letrasFacade.cargarLetras();
  }
  docpais(){
   const country = this.countries.find(
    c => c.codigo === this.countryService.getCountryCode()
    );
    this.countries.find(c => {
      if(c.codigo === country?.codigo){
        c.personalidadfiscal?.find(tip => {
          this.tiposIdentificacion.push({value: tip.value, label: tip.nombre , numero: tip.numero})
        })
      }
    })    
  }

  togglePanelLateral(){
    this.panelLateralVisible = !this.panelLateralVisible;
  }
  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Lógica para filtrar datos
  }
  formatearFecha(fecha: string): string {
    if (!fecha) return '-';
    
    const [año, mes, dia] = fecha.split('-');
    return `${dia}/${mes}/${año}`;
  }

  ngOnDestroy() {
    this.formValidationService.limpiarFormulario();
  }

  // Implementación del guard CanDeactivate usando el servicio
  async canDeactivate(): Promise<boolean> {
    return await this.formValidationService.canDeactivate();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;

    // Restaurar la selección visual cuando el grid se recrea (toggle del panel lateral)
    if (this.filaSeleccionada) {
      setTimeout(() => {
        if (this.gridApi) {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data && node.data.letra_codigo === this.filaSeleccionada?.letra_codigo) {
              node.setSelected(true);
              this.gridApi.ensureNodeVisible(node, 'middle');
            }
          });
        }
      }, 150);
    }
  }
  onDetalleGridReady(params: GridReadyEvent) {
    this.detalleGridApi = params.api;
    // Pasar el contexto del componente al grid para que los cellRenderers puedan acceder a los métodos
    this.detalleGridApi.setGridOption('context', { componentParent: this });
  }

  async onCellClicked(event: any) {
    const data = event?.data;
    if (!data) { return; }

    // Prevenir selección automática de AG-Grid
    event.node.setSelected(false);

    // Guardar referencia del elemento que tiene el foco
    const elementoConFoco = document.activeElement as HTMLElement;
    
    // Validar si hay cambios sin guardar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      // Mantener selección anterior
      if (this.filaSeleccionada) {
        setTimeout(() => {
          this.gridApi.deselectAll();
          this.gridApi.forEachNode((node) => {
            if (node.data.letra_codigo === this.filaSeleccionada.letra_codigo) {
              node.setSelected(true);
            }
          });
          
          // Restaurar el foco al campo que estaba activo
          if (elementoConFoco && elementoConFoco.tagName === 'INPUT') {
            setTimeout(() => {
              elementoConFoco.focus();
            }, 100);
          }
        }, 0);
      } else {
        this.gridApi.deselectAll();
      }
      return;
    }

    // Cargar datos del letra seleccionado
    this.cargarDatosletra(data, event.node);
  }

  // Método para cargar datos en el formulario
  private cargarDatosletra(data: any, node?: any): void {
    this.filaSeleccionada = data;
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
    if (node) {
      node.setSelected(true);
    }

    const sucursalObj = this.sucursales.find(s => s.nombre === data.letra_sucursal || s.id === data.letra_sucursal);

    this.letraForm.patchValue({
      tipoDocumentoCliente: data.letra_tipo_doc_cliente || '',
      nombreCliente: data.letra_cliente || '',
      numeroDocumentoCliente: data.letra_doc_cliente || '',
      sucursal: sucursalObj?.id || '',
      fechaE: data.letra_fecha_emision || '',
      fechaV: data.letra_fecha_vencimiento || '',
      montoT: data.letra_monto_total || '',
      nroCuotas: data.letra_cuotas || '',
      moneda: data.letra_moneda || '',
      tipoCambio: data.letra_tipo_cambio || '',
      tasaI: data.letra_tasa_interes || '',
      bancoE: data.letra_banco_emisor || '',
      cuentaB: data.letra_cuenta_banco || '',
      estado: data.letra_estado || '',
    });

    this.formValidationService.resetearEstado();
  }

  async botonRegistrarLetra() {
    // Validar cambios antes de limpiar usando el servicio
    const confirmar = await this.formValidationService.validarCambios();
    
    if (!confirmar) {
      return; // Cancelar acción
    }

    // Reiniciar el formulario a los valores por defecto
    if (this.letraForm) {
      // Obtener fecha de hoy en formato YYYY-MM-DD
      const hoy = new Date().toISOString().split('T')[0];

      this.letraForm.reset({
        tipoDocumentoCliente: this.tiposIdentificacion[0]?.value ,
        estado: 'Emitida',
        fechaE: hoy,
        fechaV: hoy,
        moneda: 'Soles',
        tipoCambio: '3.25',
      });
      
      this.filaSeleccionada = null;
      
      // Deseleccionar fila de la tabla
      if (this.gridApi) {
        this.gridApi.deselectAll();
      }

      // Resetear estado del servicio de validación
      this.formValidationService.resetearEstado();
    }
  }

  botonGuardar() {
    // Validar que el formulario sea válido
    if (this.letraForm.invalid) {
      // Mostrar cuáles campos tienen errores
      const camposConError: string[] = [];
      Object.keys(this.letraForm.controls).forEach(key => {
        const control = this.letraForm.get(key);
        if (control && control.invalid) {
          camposConError.push(key);
        }
      });
      console.log('Campos con error:', camposConError);
      this.toastService.warning(`Por favor, completa todos los campos requeridos: ${camposConError.join(', ')}`);
      return;
    }

    const formValue = this.letraForm.getRawValue();
    const codigo = this.filaSeleccionada ? this.filaSeleccionada.letra_codigo : `LC-2025-${String(this.rowData.length + 1).padStart(3, '0')}`;

    // Crear objeto completo con todos los campos del formulario
    const letraCompleta = {
      letra_codigo: codigo || '',
      letra_tipo_doc_cliente: formValue.tipoDocumentoCliente || 'RUC',
      letra_nro_doc_cliente: formValue.numeroDocumentoCliente || '',
      letra_doc_cliente: formValue.numeroDocumentoCliente || '',
      letra_cliente: formValue.nombreCliente || '',
      letra_sucursal: this.sucursales.find(s => s.id === formValue.sucursal)?.nombre || formValue.sucursal || '',
      letra_fecha_emision: formValue.fechaE || '',
      letra_fecha_vencimiento: formValue.fechaV || '',
      letra_monto_total: formValue.montoT || 0,
      letra_cuotas: formValue.nroCuotas || 0,
      letra_moneda: formValue.moneda || 'Soles',
      letra_tipo_cambio: formValue.tipoCambio || '3.25',
      letra_tasa_interes: formValue.tasaI || '0',
      letra_banco_emisor: formValue.bancoE || '',
      letra_cuenta_banco: formValue.cuentaB || '',
      letra_asiento: 'MN-' + new Date().getFullYear() + '-' + String(new Date().getMonth() + 1).padStart(2, '0') + '-01-001',
      letra_estado: this.filaSeleccionada ? this.filaSeleccionada.letra_estado : (formValue.estado || 'Emitida'),
    };

    if (this.filaSeleccionada) {
      this.letrasFacade.actualizarLetra(letraCompleta);
      this.formValidationService.resetearEstado();
    } else {
      this.letrasFacade.guardarLetra(letraCompleta);
      this.limpiarFormulario();
      this.formValidationService.resetearEstado();
    }
  }

  // Método para limpiar y resetear el formulario
  private limpiarFormulario(): void {
    const hoy = new Date().toISOString().split('T')[0];

    this.letraForm.reset({
      tipoDocumentoCliente: 'ruc',
      numeroDocumentoCliente: '',
      sucursal: '',
      nombreCliente: '',
      fechaE: hoy,
      fechaV: hoy,
      montoT: '',
      moneda: 'Soles',
      tipoCambio: '3.25',
      tasaI: '',
      bancoE: '',
      cuentaB: '',
      estado: 'Emitida',
    });
    
    this.sucursalSeleccionada = '';
    this.cuentasPorCliente = [];
    if (this.detalleGridApi) {
      this.detalleGridApi.setGridOption('rowData', []);
    }
    
    this.filaSeleccionada = null;
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }

    // Método para buscar Cliente por DNI/RUC
  buscarCliente() {
    const tipoDocumento = this.letraForm.get('tipoDocumentoCliente')?.value;
    const numeroDocumento = this.letraForm.get('numeroDocumentoCliente')?.value;
    
    console.log('Buscando Cliente:', { tipoDocumento, numeroDocumento });
    
    if (!numeroDocumento || numeroDocumento.toString().trim() === '') {
      return;
    }

    // Generar un nombre automáticamente basado en el número ingresado
    let nombreGenerado = '';
    
    if (tipoDocumento === 'dni') {
      // Para DNI generar nombre de persona
      const nombres = ['Juan Carlos', 'María Elena', 'Pedro Luis', 'Ana Sofia', 'Carlos Alberto', 'Rosa María'];
      const apellidos = ['García López', 'Rodríguez Pérez', 'Martinez Ruiz', 'Fernández Torres', 'González Vargas', 'Díaz Morales'];
      
      const indiceNombre = parseInt(numeroDocumento.toString().slice(-1)) % nombres.length;
      const indiceApellido = parseInt(numeroDocumento.toString().slice(-2, -1)) % apellidos.length;
      
      nombreGenerado = `${nombres[indiceNombre]} ${apellidos[indiceApellido]}`;
    } else if (tipoDocumento === 'ruc') {
      // Para RUC generar nombre de empresa
      const tiposEmpresa = ['EMPRESA', 'COMERCIAL', 'CORPORACIÓN', 'INDUSTRIAS', 'SERVICIOS', 'GRUPO'];
      const nombresEmpresa = ['DEMO', 'EJEMPLO', 'MODELO', 'PRUEBA', 'TEST', 'MUESTRA'];
      const sufijos = ['S.A.C.', 'S.R.L.', 'E.I.R.L.', 'S.A.', 'S.A.A.', 'LTDA.'];
      
      const indiceTipo = parseInt(numeroDocumento.toString().slice(-1)) % tiposEmpresa.length;
      const indiceNombre = parseInt(numeroDocumento.toString().slice(-2, -1)) % nombresEmpresa.length;
      const indiceSufijo = parseInt(numeroDocumento.toString().slice(-3, -2)) % sufijos.length;
      
      nombreGenerado = `${tiposEmpresa[indiceTipo]} ${nombresEmpresa[indiceNombre]} ${sufijos[indiceSufijo]}`;
    }
    
    // Establecer el nombre generado en el formulario
    this.letraForm.patchValue({ nombreCliente: nombreGenerado });
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
        { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: `Se ha creado la letra ${this.filaSeleccionada.letra_codigo}`},
        { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se modificó el número de cuotas'},
      ];
  
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: `Historial de Actualizaciones de la letra ${this.filaSeleccionada.letra_codigo}`,
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
          
        }
      });
      
      await modal.present();
      
      // Manejar la respuesta cuando se cierre el modal
      const { data } = await modal.onWillDismiss();
      if (data) {
        console.log('Modal cerrado con datos:', data);
      }
  }

  onFechaSeleccionadaE(date: Date) {
    console.log('Fecha seleccionada:', date);
    if (this.letraForm && date) {
      const fechaFormato = new Date(date).toISOString().split('T')[0];
      this.letraForm.get('fechaE')?.setValue(fechaFormato);
    }
  }

  onFechaSeleccionadaV(date: Date) {
    console.log('Fecha seleccionada:', date);
    if (this.letraForm && date) {
      const fechaFormato = new Date(date).toISOString().split('T')[0];
      this.letraForm.get('fechaV')?.setValue(fechaFormato);
    }
  }

  onSucursalSeleccionada(sucursal: any) {
    this.sucursalSeleccionada = sucursal?.id || '';
    this.letraForm.patchValue({
      sucursal: sucursal?.nombre || ''
    });
    console.log('Sucursal seleccionada:', sucursal);
  }

  onBtReset() {
    this.letrasFacade.cargarLetras();
  }

  onCuentaSeleccionada(cuenta: any) {
    console.log('Cuenta seleccionada:', cuenta);
    
    // Verificar si la cuenta ya existe en la tabla
    const cuentaExistente = this.cuentasPorCliente.find(item => item.nroDocumento === cuenta.nroDocumento);
    if (cuentaExistente) {
      this.toastService.warning('El documento ya está agregado a la tabla');
      // Limpiar el autocomplete incluso si la cuenta ya existe
      if (this.autocompleteCuentas) {
        this.autocompleteCuentas.clearSelection();
      }
      return;
    }
    
    // Crear nueva cuenta para la tabla con todos los datos
    const nuevaCuenta = {
      tipoDocumento: cuenta.tipoDocumento || '',
      nroDocumento: cuenta.nroDocumento || '',
      fechaEmision: cuenta.fechaEmision || '',
      fechaVencimiento: cuenta.fechaVencimiento || '',
      montoTotal: cuenta.montoTotal || 0,
      montoPendiente: cuenta.montoPendiente || 0,
      moneda: cuenta.moneda || 'Soles',
      tipoCambio: cuenta.tipoCambio || 0,
      numeroAsiento: cuenta.numeroAsiento || '',
      estado: cuenta.estado || 'Pendiente'
    };
    
    // Agregar la cuenta a la tabla
    this.cuentasPorCliente = [...this.cuentasPorCliente, nuevaCuenta];
    
    // Actualizar la tabla
    if (this.detalleGridApi) {
      this.detalleGridApi.setGridOption('rowData', this.cuentasPorCliente);
    }
    
    // Limpiar el autocomplete después de agregar la cuenta
    setTimeout(() => {
      if (this.autocompleteCuentas) {
        this.autocompleteCuentas.clearSelection();
        console.log('Autocomplete limpiado - listo para agregar otro documento');
      }
    }, 100);
    
  }

  eliminarArticulo(cuenta: any) {
    // Filtrar la cuenta a eliminar del array
    this.cuentasPorCliente = this.cuentasPorCliente.filter(item => item.nroDocumento !== cuenta.nroDocumento);
    
    // Actualizar la tabla
    if (this.detalleGridApi) {
      this.detalleGridApi.setGridOption('rowData', this.cuentasPorCliente);
    }
  }

  async botonProtestar(){
    const detallesEjemplo = [
      { label: 'Cliente', value:  this.filaSeleccionada.letra_cliente },
      { label: 'Fecha emisión', value: this.formatearFecha(this.filaSeleccionada.letra_fecha_emision) },
      { label: 'Fecha vencimiento', value: this.formatearFecha(this.filaSeleccionada.letra_fecha_vencimiento) },
    ];
    
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Protestar letra: ${this.filaSeleccionada.letra_codigo}`,
        subtituloModal: '',
        tituloTextarea: 'Motivo de protesto:',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Protestar',
        colorBotonConfirmar: 'primary',
        motivoObligatorio: true,
        widthModal: '492px',  
      }
    });

    await modal.present();
        
    const { data, role } = await modal.onWillDismiss();
    
    // Verificar si se confirmó la acción
    if (data && data.action === 'confirmar') {
      this._mensajeActualizacion = '¡Protesta realizada exitosamente!';
      this.letrasFacade.actualizarLetra({ ...this.filaSeleccionada, letra_estado: 'Protestada' });
    }
  }

  async botonAnular(){
    const detallesEjemplo = [
      { label: 'Cliente', value:  this.filaSeleccionada.letra_cliente },
      { label: 'Fecha emisión', value: this.formatearFecha(this.filaSeleccionada.letra_fecha_emision) },
      { label: 'Fecha vencimiento', value: this.formatearFecha(this.filaSeleccionada.letra_fecha_vencimiento) },
    ];
    
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Anular letra: ${this.filaSeleccionada.letra_codigo}`,
        subtituloModal: '',
        widthModal: '492px',
        tituloTextaera: 'Motivo de anulación',
        detalles: detallesEjemplo,
        mostrarTextarea: true,
        mostrarBotonEliminar: true,
        textoBotonConfirmar: 'Anular',
        colorBotonConfirmar: 'danger',
        motivoObligatorio: true,
      }
    });

    await modal.present();
        
    const { data, role } = await modal.onWillDismiss();
    
    // Verificar si se confirmó la acción
    if (data && data.action === 'confirmar') {
      this._mensajeActualizacion = '¡Letra anulada exitosamente!';
      this.letrasFacade.actualizarLetra({ ...this.filaSeleccionada, letra_estado: 'Anulada' });
    }
  }
  async abrirModal(value: any, rowData: any) {
      const detalleAsiento=[
      { label: 'Fecha de registro', value: '12/12/2025'},
      { label: 'Fecha contable', value: '12/12/2025'},
      { label: 'Glosa', value: 'Provisión de servicios de internet - Local San Isidro (Mes 11/2025)'},
      { label: 'Total', value: 'S/ 380.00'},
      { label: 'Duplicado', value: 'No'},
    ]

    const colDefs: ColDef[] = [
      {  field: 'cuentaContable',  headerName: 'Cuenta',  width: 70 },
      {  field: 'descripcion',  headerName: 'Descripción',  minWidth: 270, flex: 1 ,},
      { field: 'debe', headerName: 'Debe (S/)',  width: 80, headerClass: 'centrarencabezado',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            // Si es negativo, mostrar entre paréntesis
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      },
      { field: 'haber', headerName: 'Haber (S/)', width: 80,
        headerClass: 'centrarencabezado',cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        valueFormatter: (params) => {
          if (params.value !== null && params.value !== undefined) {
            const absValue = Math.abs(params.value);
            const formattedValue = new Intl.NumberFormat('es-PE', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2,
            }).format(absValue);
            
            // Si es negativo, mostrar entre paréntesis
            if (params.value < 0) {
              return `(${formattedValue})`;
            }
            return formattedValue;
          }
          return '-';
        },
      },
      {  field: 'centroC',  headerName: 'Centro de costo',  width: 100 },
      {  field: 'docRef',  headerName: 'Documento referencial',  width: 145 },
      {  field: 'tercero',  headerName: 'Tercero',  width: 100 },

    ];
  
    const modal = await this.modalController.create({
      component: ModalDetalleComponent,
      cssClass: 'promo',
      componentProps: {
        tituloModal: `Asiento ${value}`,
        detalles: detalleAsiento,
        mostrarTabla: true,
        subtitulomodal: '',
        widthModal: '740px',
        mostrarTextarea: false,
        mostrarBotonEliminar: false,
        mostrarTotal: true,
        itemstotal: [
          { label: 'Total debe (S/)', value: '380.00' },
          { label: 'Total haber (S/)', value: '380.00' },
        ],
        colDefs: colDefs,
        rowData: [
          {
            cuentaContable: '631109',
            descripcion: 'Servicios de internet',
            debe: 380.00,
            haber: null,
            centroC: 'CC-SI01',
            docRef: 'F001- 000123',
            tercero: 'Claro Perú',
          },
          {
            cuentaContable: '421101',
            descripcion: 'Proveedores Nacionales / Cuentas por Pagar Comerciales',
            debe: null,
            haber: 380.00,
            centroC: 'CC-SI01',
            docRef: 'F001- 000123',
            tercero: 'Claro Perú',
          }
        ]
      }
    });

    await modal.present();
  }
}