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
  selector: 'app-cc-cierre-anual',
  templateUrl: './cc-cierre-anual.component.html',
  styleUrls: ['./cc-cierre-anual.component.scss'],
  standalone: false,
})
export class CcCierreAnualComponent  implements OnInit {
  // Font Awesome Icons
  farCheckCircle = faCheckCircle;



  form!: FormGroup;
  fechaEjecucion: Date | undefined;  

  registro: registro | null = null;
  valido = true;
  
  dataReporte:registro ={ estado: 'Activo', nasientos: '145', reportes: ['Estado de situación financiera', 'Estado de cambios en el patrimonio', 'Estado de Resultados - Cierre 2025', 'Estado de flujo de efectivo']};

  anios=['2025', '2024', '2023', '2022', '2021', '2020'];

  constructor(
    private fb: FormBuilder,
    private toastService : ToastService,
    private modalController: ModalController,
  ) {
    
  }

  ngOnInit() {
    this.form = this.fb.group({
      anioC: ['', Validators.required],
      fechaE: [{value: '', disabled: true}],
      usuario: [{value: 'Javier Correa', disabled: true}],
      generarReporte: [false],
      trasladar: [false],
      observaciones: [''],
      estado:[{value: 'Activo', disabled: true}],
      periodosC:[{value: '12 de 12', disabled: true}],

    });
    
    // Inicializar la fecha de ejecución con la fecha de hoy
    this.fechaEjecucion = new Date();
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
    const anioC = this.form.get('anioC')?.value;
    
    // Verificar si el ejercicio ya fue cerrado
    const yaCerrado = this.registro !== null;
    
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: yaCerrado ? 'Cierre Existente' : 'Ejecutar cierre anual',
        title: yaCerrado ? 'Cierre Existente' : 'Ejecutar cierre anual',
        message: yaCerrado
          ? `El ejercicio ${anioC} ya fue cerrado previamente. <br> ¿Seguro que desea ejecutarlo de nuevo?`
          : `¿Está seguro de que desea ejecutar el cierre contable anual del ejercicio ${anioC}? <br> Este proceso es irreversible`,
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
      
      this.toastService.success('¡Cierre ejecutado exitosamente!');
    }
  }

  generarReporte() {
    // VALIDACIÓN 1 — Detectar campos faltantes
    const camposFaltantes: string[] = [];
    
    const anioC = this.form.get('anioC');

    if (!anioC || !anioC.value) { 
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

      this.toastService.success('¡Validación exitosa! El ejercicio ha sido cerrado correctamente.');
    } else {
      this.toastService.danger('Existen asientos descuadrados o pendientes.', '', 12000);
    }
  }
}






