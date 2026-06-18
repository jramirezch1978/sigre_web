import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ToastService } from 'src/app/ui/services/toast.service';

// Font Awesome Icons
import { faCalendar } from '@fortawesome/pro-light-svg-icons';
import { faCircleXmark, faXmark } from '@fortawesome/pro-regular-svg-icons';




@Component({
  selector: 'app-modal-reprogramar',
  templateUrl: './modal-reprogramar.component.html',
  styleUrls: ['./modal-reprogramar.component.scss'],
  standalone: false,
})
export class ModalReprogramarComponent  implements OnInit {
  // Font Awesome Icons
  falCalendar = faCalendar;
  farCircleXmark = faCircleXmark;
  farXmark = faXmark;



  documentoSustento: string = '';
  @Input() fechaVencimientoActual: string = '';
  fechaVencimientoParseada: string = '';
  reprogramarForm!: FormGroup

  constructor(
    private modalCtrl: ModalController,
    private formBuilder: FormBuilder,
    private toastService: ToastService, 
  ) { }

  ngOnInit() {
    this.reprogramarForm = this.formBuilder.group({
      nuevaFechaVencimiento: [ '', Validators.required ],
      motivoReprogramacion: ['', Validators.required],
      documentoSustento: ['', Validators.required],
    });
    this.fechaVencimientoParseada = new Date(this.fechaVencimientoActual).toLocaleDateString();
  }

  onFileSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.documentoSustento = file.name;
      this.reprogramarForm.patchValue({
        documentoSustento: file
      })
    }
  }

  removeFile() {
    this.documentoSustento = '';
    this.reprogramarForm.reset({
        documentoSustento: ''
      })
  }

  formatearFecha(fecha: Date): string {
    const dia = fecha.getDate().toString().padStart(2, '0');
    const mes = (fecha.getMonth() + 1).toString().padStart(2, '0');
    const anio = fecha.getFullYear();
    return `${anio}-${mes}-${dia}`;
  }

  onFechaVenciemiento(date: Date) {
    console.log('Fecha Vencimiento:', date);
    this.reprogramarForm.patchValue({
      nuevaFechaVencimiento: this.formatearFecha(date)
    })
  }

  cerrarModal(tipo: boolean) {
    if(tipo === true){
      // Validar que el formulario sea válido
      if (!this.reprogramarForm.valid || !this.documentoSustento) {
        this.toastService.warning('Por favor, completa todos los campos obligatorios');
        // Marcar todos los controles como tocados para mostrar errores
        Object.keys(this.reprogramarForm.controls).forEach(key => {
          this.reprogramarForm.get(key)?.markAsTouched();
        });
        return;
      }
      
      // Validar que la nueva fecha sea mayor a la fecha actual
      const nuevaFecha = new Date(this.reprogramarForm.get('nuevaFechaVencimiento')?.value);
      if (nuevaFecha <= new Date(this.fechaVencimientoActual)) {
        this.toastService.warning('La nueva fecha debe ser mayor a la fecha de vencimiento actual');
        return;
      }
      
      // Devolver la nueva fecha al componente padre
      this.modalCtrl.dismiss({
        success: true,
        nuevaFechaVencimiento: this.reprogramarForm.get('nuevaFechaVencimiento')?.value
      });
    } else {
      this.modalCtrl.dismiss(false);
    }
  }

}
