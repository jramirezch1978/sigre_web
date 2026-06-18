import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-community';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { ToastService } from 'src/app/ui/services/toast.service';

// Font Awesome Icons
import { faBook, faCircleInfo, faEye, faInfoCircle, faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faChevronsRight, faCirclePlus, faDownload, faRotateRight } from '@fortawesome/pro-solid-svg-icons';



interface IReglaDistribucion {
  codigo: string;
  vigencia: string;
  impuestoContribucion: string;
  fondoEn: string;
  baseCalculo: number;
  porcentaje: string;
  montoLimite: number;
  responsablePago: string;
  estado: string;
}

interface ITramo {
  tramo: number;
  unidad: string;
  desde: number;
  hasta: number;
  monto?: number;
  porcentaje: number;
}

@Component({
  selector: 'app-p-parametros-impuestos',
  templateUrl: './p-parametros-impuestos.component.html',
  styleUrls: ['./p-parametros-impuestos.component.scss'],
  standalone: false,
})
export class PParametrosImpuestosComponent implements OnInit {
  // Font Awesome Icons
  farBook = faBook;
  farCircleInfo = faCircleInfo;
  farEye = faEye;
  farInfoCircle = faInfoCircle;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasChevronsRight = faChevronsRight;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;


  @ViewChild('scrollBox', { read: ElementRef }) scrollBox!: ElementRef;
  pais= this.countryService.getCountryCode();
  countries=ALL_COUNTRIES;
  monedapais='';
  reglaForm: FormGroup;
  private gridApi!: GridApi;
  panelLateralVisible: boolean = true;
  filaSeleccionada: any = null;
  tituloPanelDerecho: string = 'Nueva regla de distribución';
  
  // Opciones para selectores
  impuestosContribuciones: any = [
    // { value: 'afp', label: 'Fondo de pensiones' },
    // { value: 'quintaCategoria', label: 'Impuesto a la Renta - Quinta Categoría' },
  ];
  fondosPensiones = ['AFP Integra', 'AFP Prima', 'AFP Profuturo', 'AFP Habitat', 'ONP'];
  tiposMonto = ['Mínimo', 'Máximo', 'Fijo'];
  responsablesPago = ['Trabajador', 'Empleador', 'Ambos'];
  estadosSelect = ['Activo', 'Inactivo'];

  // Getter para saber qué tipo de impuesto está seleccionado
  get tipoImpuestoSeleccionado(): string {
    return this.reglaForm.get('impuestoContribucion')?.value || '';
  }

  // Getter para saber si estamos editando
  get modoEdicion(): boolean {
    return this.filaSeleccionada !== null;
  }

  // Datos para tabla de tramos
  tramos: ITramo[] = [];
  valorUIT: number = 5500;

  // Configuración AG-Grid para tramos
  colDefsTramos: ColDef[] = [];

  // Configuración AG-Grid
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

  rowData: IReglaDistribucion[] = [
    { codigo: 'RD-0002', vigencia: '01/01/2025 - 31/12/2025', impuestoContribucion: 'Fondo de pensiones', fondoEn: 'AFP Habitat', baseCalculo: 2000, porcentaje: '10%', montoLimite: 0, responsablePago: 'Trabajador', estado: 'Activo'},
    { codigo: 'RD-0001', vigencia: '01/01/2025 - 31/12/2025', impuestoContribucion: 'Fondo de pensiones', fondoEn: 'AFP Prima', baseCalculo: 2000, porcentaje: '10%', montoLimite: 0, responsablePago: 'Trabajador', estado: 'Activo'},
  ];

  colDefs: ColDef<IReglaDistribucion>[] = [
    { field: 'codigo', headerName: 'Código', width: 90 },
    { field: 'vigencia', headerName: 'Vigencia', width: 160 },
    { field: 'impuestoContribucion', headerName: 'Impuesto/Contribución', flex: 1, minWidth: 200 },
    { field: 'fondoEn', headerName: 'Fondo/Entidad', width: 120 },
    { field: 'baseCalculo', headerName: 'Base de cálculo', width: 120, 
      headerClass: 'derechaencabezado',
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
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    { field: 'porcentaje', headerName: 'Porcentaje', headerClass:'derechaencabezado', width: 100,
       cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right'}
     },
    { field: 'montoLimite', headerName: 'Monto límite', width: 110,
      headerClass: 'derechaencabezado',
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
        return '';
      },
      cellStyle: (params) => {
        const style: any = { justifyContent: 'end', };
        if (params.value < 0) {
          style.color = '#EF4444'; // Rojo para negativos
        }
        return style;
      }
    },
    { field: 'responsablePago', headerName: 'Responsable de pago', width: 150 },
    {
      field: 'estado',
      headerName: 'Estado',
      headerClass: 'centrarencabezado',
      width: 90,
      cellRenderer: (params: any) => {
        const estado = params.value;
        const estadoClass = estado === 'Activo' ? 'text-green-600 bg-green-100' : 'text-red-600 bg-red-100';
        return `<span class="px-2 py-[1px] rounded-full text-xxss font-medium ${estadoClass}">${estado}</span>`;
      },
      cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' }
    }
  ];

  constructor(
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private modalController: ModalController,
    private countryService: CountryService,
  ) {
    this.reglaForm = this.formBuilder.group({
      // Campo principal
      impuestoContribucion: ['afp', Validators.required],
      
      // Campos comunes
      concepto: ['', Validators.required],
      baseCalculo: ['', Validators.required],
      vigenciaDesde: [null, Validators.required],
      vigenciaHasta: [null],
      responsablePago: ['', Validators.required],
      estado: ['Activo', Validators.required],
      observaciones: [''],
      valoruit: ['S/5,500.00', {disabled: true}],
      // Campos específicos para pensiones
      fondoPensiones: [''],
      porcentaje: [''],
      
      // Campos específicos para quinta categoría
      tipoMonto: [''],
      montoMinimo: ['']
    });

    // Escuchar cambios en el selector de impuesto
    this.reglaForm.get('impuestoContribucion')?.valueChanges.subscribe(() => {
      this.actualizarValidadores();
    });

    // Escuchar cambios en fondo de pensiones para ONP
    this.reglaForm.get('fondoPensiones')?.valueChanges.subscribe((valor) => {
      const porcentajeControl = this.reglaForm.get('porcentaje');
      
      if (valor === 'ONP') {
        // Si es ONP, autocompletar con 13 y deshabilitar
        porcentajeControl?.setValue(13);
        porcentajeControl?.disable();
      } else {
        // Si no es ONP, habilitar y limpiar valor
        porcentajeControl?.enable();
        if (porcentajeControl?.value === 13) {
          porcentajeControl?.setValue('');
        }
      }
    });
  }

  ngOnInit() {
    this.obtenerdaatosdepais();
    this.inicializarColumnasTramos();
    this.inicializarTramos();
    this.actualizarValidadores();
  }
  obtenerdaatosdepais(){
    this.countries.find(c => {
      if(c.codigo === this.pais){
        this.impuestosContribuciones= c.impuestosContribuciones;
        c.monedapais?.find(tip => {
          this.monedapais= tip.simbolo;
        })
      }
    })   
  }
  
  inicializarColumnasTramos() {
    const columnasBase: ColDef[] = [
      { headerName: 'Tramos', field: 'tramo', width: 60, headerClass: 'text-center' },
      { headerName: 'Unidad', field: 'unidad', width: 50, headerClass: 'text-center' },
      { 
        headerName: 'Desde', 
        field: 'desde', 
        width: 60, 
        headerClass: 'text-center',
        valueFormatter: (params: any) => `${this.monedapais} ${params.value}`
      },
      { 
        headerName: 'Hasta', 
        field: 'hasta', 
        width: 80, 
        headerClass: 'text-center', 
        valueFormatter: (params: any) => params.value === 0 ? 'A más' : `${this.monedapais} ${params.value}`
      }
    ];

    // Solo agregar columna Monto si NO es Guatemala
    if (this.pais !== 'GT') {
      columnasBase.push({
        headerName: 'Monto', 
        field: 'monto', 
        width: 100, 
        headerClass: 'derechaencabezado',
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
          return '';
        },
        cellStyle: (params) => {
          const style: any = { justifyContent: 'end' };
          if (params.value < 0) {
            style.color = '#EF4444'; // Rojo para negativos
          }
          return style;
        }
      });
    }

    // Agregar columna de porcentaje al final
    columnasBase.push({
      headerName: '%', 
      field: 'porcentaje', 
      width: 60, 
      headerClass: 'text-center', 
      valueFormatter: (params: any) => `${params.value}%`
    });

    this.colDefsTramos = columnasBase;
  }
  
  inicializarTramos() {
    if(this.pais != 'GT'){
    this.tramos = [
      { tramo: 1, unidad: 'UIT', desde: 0, hasta: 5, monto: 27500, porcentaje: 8 },
      { tramo: 2, unidad: 'UIT', desde: 5, hasta: 20, monto: 110000, porcentaje: 14 },
      { tramo: 3, unidad: 'UIT', desde: 20, hasta: 35, monto: 192500, porcentaje: 17 },
      { tramo: 4, unidad: 'UIT', desde: 35, hasta: 45, monto: 247500, porcentaje: 20 },
      { tramo: 5, unidad: 'UIT', desde: 45, hasta: 0, monto: 247500, porcentaje: 30 }
    ];
    }
    if(this.pais === 'GT'){
      this.tramos = [
      { tramo: 1, unidad: 'ISR', desde: 0, hasta: 30000000, porcentaje: 5 },
      { tramo: 2, unidad: 'ISR', desde: 30000000, hasta: 0, porcentaje: 7 },
    ];
    }
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.gridApi.setGridOption('rowData', this.rowData);
  }

  onCellClicked(event: any) {
    const data = event.data;
    this.filaSeleccionada = data;
    
    // Actualizar título del panel derecho
    this.tituloPanelDerecho = `Regla de distribución: ${data.codigo}`;
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
      event.node.setSelected(true);
    }

    // Llenar formulario con los datos
    this.reglaForm.patchValue({
      concepto: data.impuestoContribucion,
      baseCalculo: data.baseCalculo,
      responsablePago: data.responsablePago,
      estado: data.estado,
      porcentaje: data.porcentaje.replace('%', '')
    });
  }

  togglePanelLateral() {
    this.panelLateralVisible = !this.panelLateralVisible;
  }

  actualizarValidadores() {
    const tipoSeleccionado = this.reglaForm.get('impuestoContribucion')?.value;
    const fondoPensiones = this.reglaForm.get('fondoPensiones');
    const porcentaje = this.reglaForm.get('porcentaje');
    const tipoMonto = this.reglaForm.get('tipoMonto');
    const montoMinimo = this.reglaForm.get('montoMinimo');

    if (tipoSeleccionado === 'afp') {
      // Es fondo de pensiones
      fondoPensiones?.setValidators([Validators.required]);
      porcentaje?.setValidators([Validators.required]);
      tipoMonto?.clearValidators();
      montoMinimo?.clearValidators();
    } else if (tipoSeleccionado === 'quintaCategoria') {
      // Es quinta categoría
      fondoPensiones?.clearValidators();
      porcentaje?.clearValidators();
      tipoMonto?.setValidators([Validators.required]);
      montoMinimo?.setValidators([Validators.required]);
    } else {
      // No hay selección, limpiar todo
      fondoPensiones?.clearValidators();
      porcentaje?.clearValidators();
      tipoMonto?.clearValidators();
      montoMinimo?.clearValidators();
    }

    fondoPensiones?.updateValueAndValidity();
    porcentaje?.updateValueAndValidity();
    tipoMonto?.updateValueAndValidity();
    montoMinimo?.updateValueAndValidity();
  }

  botonNuevaRegla() {
    this.filaSeleccionada = null;
    this.tituloPanelDerecho = 'Nueva regla de distribución';
    this.reglaForm.reset({ estado: 'Activo' });
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  botonGuardar() {
    if (this.reglaForm.invalid) {
      this.toastService.warning('Por favor, completa todos los campos requeridos');
      return;
    }

    const formValue = this.reglaForm.value;
    
    // Formatear vigencia
    const vigenciaDesde = formValue.vigenciaDesde ? new Date(formValue.vigenciaDesde).toLocaleDateString('es-PE') : '';
    const vigenciaHasta = formValue.vigenciaHasta ? new Date(formValue.vigenciaHasta).toLocaleDateString('es-PE') : '';
    const vigencia = vigenciaHasta ? `${vigenciaDesde} - ${vigenciaHasta}` : vigenciaDesde;
    
    // Determinar impuesto/contribución y fondo/entidad
    let impuestoContribucion = '';
    let fondoEn = '';
    
    if (formValue.impuestoContribucion === 'afp') {
      impuestoContribucion = 'Fondo de pensiones';
      fondoEn = formValue.fondoPensiones || '';
    } else if (formValue.impuestoContribucion === 'quintaCategoria') {
      impuestoContribucion = 'Impuesto a la Renta - Quinta Categoría';
      fondoEn = '';
    }
    
    if (this.modoEdicion) {
      // MODO EDICIÓN: Actualizar registro existente
      const index = this.rowData.findIndex(r => r.codigo === this.filaSeleccionada.codigo);
      if (index !== -1) {
        const reglaActualizada: IReglaDistribucion = {
          codigo: this.filaSeleccionada.codigo, // Mantener el mismo código
          vigencia: vigencia,
          impuestoContribucion: impuestoContribucion,
          fondoEn: fondoEn,
          baseCalculo: parseFloat(formValue.baseCalculo) || 0,
          porcentaje: formValue.porcentaje ? `${formValue.porcentaje}%` : '',
          montoLimite: parseFloat(formValue.montoMinimo) || 0,
          responsablePago: formValue.responsablePago,
          estado: formValue.estado
        };
        
        this.rowData[index] = reglaActualizada;
        this.rowData = [...this.rowData]; // Trigger change detection
      }
      
      this.toastService.success('¡Regla actualizada con éxito!');
    } else {
      // MODO CREACIÓN: Crear nueva regla
      const nuevoCodigo = `RD-${String(this.rowData.length + 1).padStart(4, '0')}`;
      
      const nuevaRegla: IReglaDistribucion = {
        codigo: nuevoCodigo,
        vigencia: vigencia,
        impuestoContribucion: impuestoContribucion,
        fondoEn: fondoEn,
        baseCalculo: parseFloat(formValue.baseCalculo) || 0,
        porcentaje: formValue.porcentaje ? `${formValue.porcentaje}%` : '',
        montoLimite: parseFloat(formValue.montoMinimo) || 0,
        responsablePago: formValue.responsablePago,
        estado: formValue.estado
      };
      
      // Agregar al INICIO de la tabla
      this.rowData = [nuevaRegla, ...this.rowData];
      
      this.toastService.success('¡Regla registrada con éxito!');
    }
    
    // Actualizar grid
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
    
    // Limpiar formulario
    this.reglaForm.reset({ 
      estado: 'Activo',
      impuestoContribucion: 'afp'
    });
    this.filaSeleccionada = null;
    
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }
  }

  scrollLeft() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: -150, behavior: 'smooth' });
  }

  scrollRight() {
    const el = this.scrollBox.nativeElement;
    el.scrollBy({ left: 150, behavior: 'smooth' });
  }

  async modalverActualizaciones() {
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150 },
      { headerName: 'Usuario', field: 'usuario', width: 120 },
      { headerName: 'Acción', field: 'accion', width: 150 },
      {
        headerClass: 'centrarencabezado',
        headerName: 'Detalle del cambio',
        cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
        field: 'detalleCambio',
        flex: 1
      }
    ];

    const rowData = [
      { fechaHora: '12/11/2025 10:30', usuario: 'Juan Pérez', accion: 'Creación', detalleCambio: 'Se creó regla RD-0001' },
      { fechaHora: '12/11/2025 14:15', usuario: 'María González', accion: 'Actualización', detalleCambio: 'Se editó el porcentaje' },
      { fechaHora: '13/11/2025 09:00', usuario: 'Carlos Rodríguez', accion: 'Actualización', detalleCambio: 'Se cambió la vigencia' }
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: `Historial de Actualizaciones - ${this.filaSeleccionada?.codigo || 'Nueva Regla'}`,
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px'
      }
    });

    await modal.present();
  }

  async modalDetalleComisiones() {
    const colDefs: ColDef[] = [
      { headerName: 'AFP', field: 'afp', minWidth: 100, flex: 1 },
      { headerName: 'Comisión sobre flujo', field: 'comisionFlujo', width: 130 },
      { headerName: 'Comisión anual sobre saldo', field: 'comisionSaldo', width: 160 },
      { headerName: 'Prima de seguros (%)', field: 'primaSeguros', width: 130 },
      { headerName: 'Aporte obligatorio al fondo de pensiones', field: 'aporteObligatorio', width: 235 },
      { headerName: 'Remuneración máxima asegurada', field: 'remuneracionMaxima', width: 200 },
    ];

    const rowData = [
      { 
        afp: 'Habitat', 
        comisionFlujo: '1.47%', 
        comisionSaldo: '1.25%', 
        primaSeguros: '1.37%', 
        aporteObligatorio: '10%', 
        remuneracionMaxima: 'S/12,209.11' 
      },
      { 
        afp: 'Integra', 
        comisionFlujo: '1.55%', 
        comisionSaldo: '0.78%', 
        primaSeguros: '1.37%', 
        aporteObligatorio: '10%', 
        remuneracionMaxima: 'S/12,209.11' 
      },
      { 
        afp: 'Prima', 
        comisionFlujo: '1.60%', 
        comisionSaldo: '1.25%', 
        primaSeguros: '1.37%', 
        aporteObligatorio: '10%', 
        remuneracionMaxima: 'S/12,209.11' 
      },
      { 
        afp: 'Profuturo', 
        comisionFlujo: '1.69%', 
        comisionSaldo: '0.68%', 
        primaSeguros: '1.37%', 
        aporteObligatorio: '10%', 
        remuneracionMaxima: 'S/12,209.11' 
      },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Comisiones y primas de Seguro del SPP',
        subtitulo: 'Detalle de comisiones',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '1000px',
      }
    });
    await modal.present();
  }

  onBtReset() {
    if (this.gridApi) {
      this.gridApi.showLoadingOverlay();
      setTimeout(() => {
        this.gridApi.setGridOption('rowData', [...this.rowData]);
        this.gridApi.hideOverlay();
      }, 300);
    }
  }
}
