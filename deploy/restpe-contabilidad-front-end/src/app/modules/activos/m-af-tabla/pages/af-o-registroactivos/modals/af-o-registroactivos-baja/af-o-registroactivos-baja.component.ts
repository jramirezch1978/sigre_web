import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';
import { SimulationService } from 'src/app/simulation/simulation.service';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';
import { faArrowTrendDown, faSearch } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-af-o-registroactivos-baja',
  templateUrl: './af-o-registroactivos-baja.component.html',
  styleUrls: ['./af-o-registroactivos-baja.component.scss'],
  standalone: false,
})
export class AfORegistroactivosBajaComponent implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;
  fasArrowTrendDown = faArrowTrendDown;
  fasSearch = faSearch;


  
  bajaForm: FormGroup;
  fechaBaja: Date = new Date();
  tipoBajaSeleccionado: string = '';

  tiposBaja = [
    { id: 'Obsolescencia', nombre: 'Obsolescencia' },
    { id: 'Siniestro', nombre: 'Siniestro' },
    { id: 'Venta', nombre: 'Venta' },
  ];

  motivos = [
    { id: 1, nombre: 'Fin de vida útil' },
    { id: 2, nombre: 'Tecnología obsoleta' },
    { id: 3, nombre: 'Deterioro físico' },
  ];

  tiposSiniestro = [
    { id: 1, nombre: 'Incendio' },
    { id: 2, nombre: 'Inundación' },
    { id: 3, nombre: 'Terremoto' },
    { id: 4, nombre: 'Accidente' },
  ];

  tiposDocumento = [
    { id: 'Factura', nombre: 'Factura' },
    { id: 'Boleta', nombre: 'Boleta' },
    { id: 'Recibo', nombre: 'Recibo' },
  ];

  monedas = [
    { id: 'Soles', nombre: 'Soles' },
    { id: 'Dólares', nombre: 'Dólares' },
  ];

  estados = [
    { id: 'En proceso', nombre: 'En proceso' },
    { id: 'Completado', nombre: 'Completado' },
  ];

  cuentasContables: any[] = [];

  tiposCompradorRUC = [
    { id: 'RUC', nombre: 'RUC' },
    { id: 'DNI', nombre: 'DNI' },
    { id: 'CE', nombre: 'CE' },
  ];

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder,
    private toastService: ToastService,
    private simulation: SimulationService
  ) {
    this.bajaForm = this.formBuilder.group({
      tipoBaja: ['Obsolescencia', Validators.required],
      // Campos para Obsolescencia
      motivo: [null],
      descripcion: [''],
      // Campos para Siniestro
      tipoSiniestro: [null],
      partePolicialSeguro: [''],
      montoIndemnizacion: [''],
      descripcionSiniestro: [''],
      // Campos para Venta
      valorVenta: [''],
      tipoCompradorRUC: ['RUC'],
      numeroComprador: [''],
      nombreComprador: [''],
      tipoDocumento: [null],
      numeroDocumento: [''],
      // Campos comunes
      fechaBaja: [this.fechaBaja, Validators.required],
      moneda: [null, Validators.required],
      cuentaContable: [null, Validators.required],
      estado: ['En proceso', Validators.required],
    });
  }

  ngOnInit() {
    this.cargarCuentasContables();
  }

  /**
   * Cargar cuentas contables desde el SimulationService (plan contable)
   */
  cargarCuentasContables() {
    // Leer directamente desde localStorage para obtener los datos más recientes
    const datosGuardados = localStorage.getItem('plancontable');
    let cuentasLS: any[] = [];
    
    if (datosGuardados) {
      try {
        cuentasLS = JSON.parse(datosGuardados);
      } catch (e) {
        console.error('Error al parsear cuentas contables:', e);
        cuentasLS = [];
      }
    }
    
    console.log(' Cuentas contables cargadas:', cuentasLS.length);
    
    // Mapear cuentas con el formato necesario para el autocomplete
    this.cuentasContables = cuentasLS.map((item: any) => ({
      id: item.codigo,
      codigo: item.codigo,
      descripcion: item.descripcion,
      nombre: `${item.codigo} - ${item.descripcion}`,
      naturaleza: item.naturaleza,
      tipo: item.tipo,
      movimiento: item.movimiento,
      nivel: item.nivel
    }));
    
    console.log(' Cuentas mapeadas para autocomplete:', this.cuentasContables.length);
  }

  onTipoBajaSeleccionado(event: any) {
    this.tipoBajaSeleccionado = event.detail.value;
    this.actualizarValidaciones();
  }

  actualizarValidaciones() {
    // Limpiar todas las validaciones opcionales
    this.bajaForm.get('motivo')?.clearValidators();
    this.bajaForm.get('tipoSiniestro')?.clearValidators();
    this.bajaForm.get('partePolicialSeguro')?.clearValidators();
    this.bajaForm.get('montoIndemnizacion')?.clearValidators();
    this.bajaForm.get('valorVenta')?.clearValidators();
    this.bajaForm.get('numeroComprador')?.clearValidators();
    this.bajaForm.get('nombreComprador')?.clearValidators();
    this.bajaForm.get('tipoDocumento')?.clearValidators();
    this.bajaForm.get('numeroDocumento')?.clearValidators();

    // Aplicar validaciones según el tipo de baja
    if (this.tipoBajaSeleccionado === 'Obsolescencia') {
      this.bajaForm.get('motivo')?.setValidators([Validators.required]);
    } else if (this.tipoBajaSeleccionado === 'Siniestro') {
      this.bajaForm.get('tipoSiniestro')?.setValidators([Validators.required]);
      this.bajaForm.get('partePolicialSeguro')?.setValidators([Validators.required]);
      this.bajaForm.get('montoIndemnizacion')?.setValidators([Validators.required]);
    } else if (this.tipoBajaSeleccionado === 'Venta') {
      this.bajaForm.get('valorVenta')?.setValidators([Validators.required]);
      this.bajaForm.get('numeroComprador')?.setValidators([Validators.required]);
      this.bajaForm.get('nombreComprador')?.setValidators([Validators.required]);
      this.bajaForm.get('tipoDocumento')?.setValidators([Validators.required]);
      this.bajaForm.get('numeroDocumento')?.setValidators([Validators.required]);
    }

    // Actualizar el estado de validación de todos los campos
    Object.keys(this.bajaForm.controls).forEach(key => {
      this.bajaForm.get(key)?.updateValueAndValidity();
    });
  }

  onMotivoSeleccionado(event: any) {
    this.bajaForm.patchValue({ motivo: event.detail.value });
  }

  onTipoSiniestroSeleccionado(event: any) {
    this.bajaForm.patchValue({ tipoSiniestro: event.detail.value });
  }

  onFechaBaja(fecha: Date) {
    this.fechaBaja = fecha;
    this.bajaForm.patchValue({ fechaBaja: fecha });
  }

  onMonedaSeleccionada(event: any) {
    this.bajaForm.patchValue({ moneda: event.detail.value });
  }

  onCuentaContableSeleccionada(item: any) {
    console.log('Cuenta contable seleccionada:', item);
    this.bajaForm.patchValue({ 
      cuentaContable: item.codigo || item.id 
    });
  }

  onEstadoSeleccionado(event: any) {
    this.bajaForm.patchValue({ estado: event.detail.value });
  }

  onTipoDocumentoSeleccionado(event: any) {
    this.bajaForm.patchValue({ tipoDocumento: event.detail.value });
  }

  onTipoCompradorRUCSeleccionado(event: any) {
    this.bajaForm.patchValue({ tipoCompradorRUC: event.detail.value });
  }

  buscarComprador() {
    // Lógica para buscar comprador por RUC/DNI
    console.log('Buscar comprador:', this.bajaForm.get('numeroComprador')?.value);
  }

  confirmarBaja() {
    if (this.bajaForm.valid) {
      this.toastService.success('¡Baja de activo registrada exitosamente!');
      this.modalController.dismiss({
        baja: this.bajaForm.value
      });
    }
  }

  dismissModal() {
    this.modalController.dismiss();
  }
}
