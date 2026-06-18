import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { ToastService } from 'src/app/ui/services/toast.service';

// Font Awesome Icons
import { faCheckCircle } from '@fortawesome/pro-regular-svg-icons';

export interface registro{
  estado: string,
  nasientos:string,
  reportes:string[],
}

@Component({
  selector: 'app-cc-cierre-mensual',
  templateUrl: './cc-cierre-mensual.component.html',
  styleUrls: ['./cc-cierre-mensual.component.scss'],
  standalone: false,
})
export class CcCierreMensualComponent  implements OnInit {
  // Font Awesome Icons
  farCheckCircle = faCheckCircle;


  form!: FormGroup;
  fechaEjecucion: Date | undefined;  

  registro: registro | null = null;
  valido = true;
  
  dataReporte:registro ={ estado: 'Activo', nasientos: '145', reportes: ['Libro Diario - Noviembre 2025', 'Libro Mayor - Noviembre 2025', 'Balance de Comprobación - Noviembre 2025', 'Estado de Resultados - Noviembre 2025']}

    periodos=[
      { label: '202501', id: '1' },
      { label: '202502', id: '2' },
      { label: '202503', id: 's3' },
      { label: '202504', id: '4' },
      { label: '202505', id: '5' },
      { label: '202506', id: '6' },
      { label: '202507', id: '7' },
      { label: '202508', id: '8' },
      { label: '202509', id: '9' },
      { label: '2025010', id: '10' },
      { label: '2025011', id: '11' },
      { label: '2025012', id: '12' }
    ]


  constructor(
    private fb: FormBuilder,
    private toastService : ToastService,
    private modalController: ModalController,
  ) {
    
  }

  ngOnInit() {
    this.form = this.fb.group({
      periodoContable: [this.periodos.length ? this.periodos[0].id : '', Validators.required],
      fechaE: [{value: '', disabled: true}],
      usuario: [{value: 'Javier Correa', disabled: true}],
      generarReporte: [false],
      observaciones: [''],
      estado:[{value: 'Activo', disabled: true}],
      totalA:[{value: '145', disabled: true}],
      totalM:[{value: '890', disabled: true}]

    });
    
    // Inicializar la fecha de ejecución con la fecha de hoy
    this.fechaEjecucion = new Date();
  }


  onPeriodoSeleccionado(event: any) {
    console.log('Periodo seleccionado:', event);
    
    let periodoValue = '';
    
    // El evento viene como {month: number, year: number}
    if (event && typeof event === 'object' && event.month && event.year) {
      const year = event.year;
      const month = String(event.month).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (event instanceof Date) {
      const year = event.getFullYear();
      const month = String(event.getMonth() + 1).padStart(2, '0');
      periodoValue = `${year}${month}`;
    } else if (typeof event === 'string') {
      periodoValue = event;
    }
    
    if (periodoValue) {
      this.form.patchValue({ periodoContable: periodoValue });
      console.log('Periodo guardado en formulario:', periodoValue);
    } else {
      console.warn('No se pudo procesar el evento del período:', event);
    }
  }


  onFechaEjecucion(date: Date) {
    if (this.form && date) {
      const fechaCtrl = this.form.get('fechaE');
      if (fechaCtrl) {
        fechaCtrl.setValue(date);
      }
    }
  }

  async modalConfirmacion() {
    const periodoSeleccionado = this.form.get('periodoContable')?.value;
    
    // Verificar si el periodo ya fue cerrado
    const yaCerrado = this.registro !== null;
    
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Ejecutar cierre mensual',
        title: yaCerrado ? 'Cierre Existente' : 'Ejecutar cierre mensual',
        message: yaCerrado 
          ? `El periodo contable ${periodoSeleccionado} ya fue cerrado previamente. <br> ¿Seguro que desea ejecutarlo de nuevo?`
          : 'Este proceso bloqueará todas las operaciones del periodo seleccionado. <br> ¿Está seguro de que desea continuar?',
        btnOkTxt: 'Ejecutar cierre',
        btnCancelTxt: 'Cancelar',
      },
    });

    await modal.present();

    const { data } = await modal.onWillDismiss();

    if (data === true) {
      // ÉXITO: generar reporte
      const generarReporte = this.form.get('generarReporte')?.value;
      
      // Solo asignar los reportes si el checkbox está marcado
      if (generarReporte) {
        this.registro = this.dataReporte;
      } else {
        // Si no se marca generar reportes, solo mostrar el estado y asientos
        this.registro = {
          estado: this.dataReporte.estado,
          nasientos: this.dataReporte.nasientos,
          reportes: []
        };
      }
      
      this.toastService.success(`El cierre contable mensual del periodo ${periodoSeleccionado} se ejecutó correctamente.`);
    }
  }

  generarReporte() {
    // VALIDACIÓN 1 — Detectar campos faltantes
    const camposFaltantes: string[] = [];
    
    const periodoContable = this.form.get('periodoContable');

    if (!periodoContable || !periodoContable.value) { 
      camposFaltantes.push('Período contable'); 
    }

    if (camposFaltantes.length > 0) {
      const mensaje = `Campos requeridos faltantes: ${camposFaltantes.join(', ')}`;
      this.toastService.danger(mensaje,'',12000);
      return;
    }

    // VALIDACIÓN 2 — Validaciones del formulario
    if (this.form.invalid) {
      this.toastService.danger('Existen errores de validación.',' Corríjalos antes de generar el archivo', 12000);
      return;
    }

    // VALIDACIÓN 3 — Simulamos que hay registros
    const registrosEncontrados = true; // cambia a false para simular

    if (!registrosEncontrados) {
      this.toastService.danger('No existen registros contables en el período seleccionado');
      return;
    }

    // VALIDACIÓN 4 — error de sistema simulado
    const errorSistema = false; // cambia a true para probar

    if (errorSistema) {
      this.toastService.danger('Error al procesar un archivo.',' Contacte a un administrador del sistema', 12000);
      return;
    }

    this.modalConfirmacion();
  }

  validar() {
    if (this.valido) {
      // Habilitar momentáneamente para que setValue se refleje en ion-select deshabilitado
      const estadoCtrl = this.form.get('estado');
      estadoCtrl?.enable();
      estadoCtrl?.setValue('Cerrado');
      estadoCtrl?.disable();

      // Actualizar también en el registro si existe
      if (this.registro) {
        this.registro = { ...this.registro, estado: 'Cerrado' };
      }

      this.toastService.success('¡Validación exitosa! El periodo ha sido cerrado correctamente.');
    } else {
      this.toastService.danger('Existen asientos descuadrados o pendientes.', '', 12000);
    }
  }
}





