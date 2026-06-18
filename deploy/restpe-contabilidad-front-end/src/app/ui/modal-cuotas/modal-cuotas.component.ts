import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef } from 'ag-grid-enterprise';
import { AgGridAngular } from 'ag-grid-angular';
import { GridApi } from 'ag-grid-enterprise';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { ToastService } from '../services/toast.service';
import { CalendarCellEditorComponent } from '../calendar-cell-editor/calendar-cell-editor.component';
import { FechaEditCellRendererComponent } from '../fecha-edit-cell-renderer/fecha-edit-cell-renderer.component';

// Font Awesome Icons
import { faInfoCircle } from '@fortawesome/pro-regular-svg-icons';
import { faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-cuotas',
  templateUrl: './modal-cuotas.component.html',
  styleUrls: ['./modal-cuotas.component.scss'],
  standalone: false,
})
export class ModalCuotasComponent implements OnInit {
  // Font Awesome Icons
  farInfoCircle = faInfoCircle;
  fasXmark = faXmark;



  @Input() ordenCompraId: string = ''; // ID de la orden de compra asociada
  @Input() cuotasExistentes: any = null; // Cuotas existentes si se están editando
  @Input() condicionPago: string = ''; // Tipo de condición de pago (Mixta, Crédito, Al Contado)
  @Input() montoTotal: number = 0; // Monto total de la orden de compra

  @ViewChild('agGridCuotas') agGridCuotas!: AgGridAngular;
  gridApi!: GridApi;

  numerodecuotas: number = 0;
  montoIngresado: number = 0;
  porcentajeInteres: number = 0;

  gridOptions = {
    getRowId: (params: any) => params.data.id
  };

  colDefsCuotas: ColDef[] = [
    { field: 'cuota', headerName: 'Cuota', flex: 1, minWidth: 100 },
    { field: 'monto', headerName: 'Monto', flex: 1.5, minWidth: 120 },
    { field: 'fechaPago', headerName: 'Fecha programada de pago', flex: 1.5, minWidth: 130,
      cellStyle:{cursor: 'pointer'},
      editable: true,
      cellEditor: CalendarCellEditorComponent,
      cellRenderer: FechaEditCellRendererComponent,
      valueFormatter: (params: any) => {
        if (params.value) {
          if (typeof params.value === 'string') {
            return params.value;
          } else if (params.value instanceof Date) {
            const dia = params.value.getDate().toString().padStart(2, '0');
            const mes = (params.value.getMonth() + 1).toString().padStart(2, '0');
            const anio = params.value.getFullYear();
            return `${dia}/${mes}/${anio}`;
          }
        }
        return '';
      },
      valueGetter: (params: any) => {
        const fechaStr = params.data.fechaPago;
        if (fechaStr) {
          const partes = fechaStr.split('/');
          if (partes.length === 3) {
            return new Date(parseInt(partes[2]), parseInt(partes[1]) - 1, parseInt(partes[0]));
          }
        }
        return null;
      },
      valueSetter: (params: any) => {
        if (params.newValue) {
          const fecha = new Date(params.newValue);
          const dia = fecha.getDate().toString().padStart(2, '0');
          const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
          const anio = fecha.getFullYear();
          params.data.fechaPago = `${dia}/${mes}/${anio}`;
        }
        return true;
      }
    } as ColDef,
  ];

  rowDataCuotas: any[] = [];

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
    private modalController: ModalController,
    private simulation: SimulationService,
    private toastService: ToastService
  ) { }

  ngOnInit() {
    console.log('Modal cuotas inicializado con:', {
      ordenCompraId: this.ordenCompraId,
      cuotasExistentes: this.cuotasExistentes,
      condicionPago: this.condicionPago,
      montoTotal: this.montoTotal
    });

    // Si hay cuotas existentes, cargarlas
    if (this.cuotasExistentes) {
      this.numerodecuotas = this.cuotasExistentes.numeroCuotas;
      this.montoIngresado = this.cuotasExistentes.montoIngresado || 0;
      this.porcentajeInteres = this.cuotasExistentes.porcentajeInteres;
      // Asegurar que las cuotas existentes tienen IDs únicos
      this.rowDataCuotas = (this.cuotasExistentes.cuotas || []).map((cuota: any, index: number) => ({
        id: cuota.id || `${Date.now()}-${index}`,
        ...cuota
      }));
    } else {
      // Siempre cargar 2 cuotas por defecto automáticamente
      this.numerodecuotas = 2;
      this.montoIngresado = this.montoTotal || 20000;
      this.porcentajeInteres = 0;
      // Generar las cuotas automáticamente
      this.generarCuotas();
    }
  }

  /**
   * Valida si la condición de pago es Mixta o Mixto
   * El monto ingresado solo aparece para pagos Mixtos
   */
  isCondicionPagoMixta(): boolean {
    if (!this.condicionPago) return false;

    const condicionLower = this.condicionPago.toLowerCase().trim();
    return condicionLower === 'mixta' ||
      condicionLower === 'mixto' ||
      condicionLower.includes('mixta') ||
      condicionLower.includes('mixto');
  }

  onGridReady(event: any) {
    this.gridApi = event.api;
  }

  onNumeroCuotasChange() {
    if (this.numerodecuotas && this.numerodecuotas > 0) {
      this.rowDataCuotas = [];
      // Pequeño delay para permitir que ag-grid procese primero
      setTimeout(() => {
        this.generarCuotas();
      }, 50);
    } else {
      this.rowDataCuotas = [];
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', []);
      }
    }
  }

  onMontoIngresadoChange() {
    // Regenerar cuotas cuando cambia el monto ingresado
    if (this.numerodecuotas && this.numerodecuotas > 0) {
      this.rowDataCuotas = [];
      setTimeout(() => {
        this.generarCuotas();
      }, 50);
    }
  }

  generarCuotas() {
    this.rowDataCuotas = [];
    const fechaActual = new Date();

    // Calcular monto por cuota
    const montoBase = this.montoIngresado / this.numerodecuotas;

    // Calcular interés si aplica
    const montoConInteres = this.porcentajeInteres > 0
      ? montoBase * (1 + this.porcentajeInteres / 100)
      : montoBase;

    for (let i = 1; i <= this.numerodecuotas; i++) {
      const fechaPago = new Date(fechaActual);
      fechaPago.setMonth(fechaActual.getMonth() + i);

      const dia = fechaPago.getDate().toString().padStart(2, '0');
      const mes = (fechaPago.getMonth() + 1).toString().padStart(2, '0');
      const anio = fechaPago.getFullYear();

      // Formatar monto con decimales
      const montoFormateado = `S/ ${montoConInteres.toFixed(2)}`;

      this.rowDataCuotas.push({
        id: `${Date.now()}-${i}`, // ID único con timestamp
        cuota: `Cuota ${i}`,
        monto: montoFormateado,
        fechaPago: `${dia}/${mes}/${anio}`
      });
    }

    // Actualizar la tabla si gridApi está disponible
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', [...this.rowDataCuotas]);
    }

    console.log('Cuotas generadas:', {
      numeroCuotas: this.numerodecuotas,
      montoIngresado: this.montoIngresado,
      porcentajeInteres: this.porcentajeInteres,
      montoBase: montoBase,
      montoConInteres: montoConInteres,
      cuotas: this.rowDataCuotas
    });
  }

  guardarCuotas() {
    // Validar que hay cuotas configuradas
    if (this.numerodecuotas <= 0) {
      this.toastService.warning('¡Debe configurar al menos una cuota!');
      return;
    }

    if (this.montoIngresado <= 0) {
      this.toastService.warning('¡Debe ingresar un monto mayor a 0!');
      return;
    }

    // Crear objeto con la configuración de cuotas
    const configuracionCuotas = {
      ordenCompraId: this.ordenCompraId,
      numeroCuotas: this.numerodecuotas,
      montoIngresado: this.montoIngresado,
      porcentajeInteres: this.porcentajeInteres,
      cuotas: this.rowDataCuotas,
      fechaCreacion: new Date().toLocaleDateString('es-PE'),
      horaCreacion: new Date().toLocaleTimeString('es-PE')
    };

    console.log('Guardando configuración de cuotas:', configuracionCuotas);

    // Guardar en localStorage usando simulation
    try {
      // Obtener cuotas existentes
      const cuotasExistentes = this.simulation.list('cuotasOrdenCompra') || [];

      // Verificar si ya existe una configuración para esta orden
      const indiceExistente = cuotasExistentes.findIndex(
        (c: any) => c.ordenCompraId === this.ordenCompraId
      );

      if (indiceExistente !== -1) {
        // Actualizar configuración existente
        cuotasExistentes[indiceExistente] = configuracionCuotas;
        this.simulation.replace('cuotasOrdenCompra', cuotasExistentes);
        console.log('Cuotas actualizadas en localStorage');
        this.toastService.success('¡Configuración de cuotas actualizada!');
      } else {
        // Crear nueva configuración
        this.simulation.save('cuotasOrdenCompra', configuracionCuotas);
        console.log('Cuotas guardadas en localStorage');
        this.toastService.success('¡Configuración de cuotas guardada!');
      }

      // Cerrar modal y retornar datos
      this.modalController.dismiss({
        action: 'guardar',
        data: configuracionCuotas
      });

    } catch (error) {
      console.error('Error al guardar cuotas:', error);
      this.toastService.danger('¡Error al guardar configuración de cuotas!');
    }
  }

  cerrarmodal() {
    this.modalController.dismiss({
      action: 'cancelar'
    });
  }
}
