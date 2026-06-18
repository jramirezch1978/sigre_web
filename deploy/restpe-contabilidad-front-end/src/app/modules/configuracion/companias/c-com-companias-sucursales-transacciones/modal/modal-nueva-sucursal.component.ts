import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faCirclePlus, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-nueva-sucursal',
  templateUrl: './modal-nueva-sucursal.component.html',
  styleUrls: ['./modal-nueva-sucursal.component.scss'],
  standalone: false
})
export class ModalNuevaSucursalComponent implements OnInit {
  // Font Awesome Icons
  farCirclePlus = faCirclePlus;
  farXmark = faXmark;



  sucursalForm!: FormGroup;

  zonasHorarias = [
    { value: 'UTC-5', label: 'Lima, Perú' },
    { value: 'UTC-4', label: 'Santiago, Chile' },
    { value: 'UTC-5', label: 'Bogotá, Colombia' },
    { value: 'UTC-5', label: 'Quito, Ecuador' },
    { value: 'UTC-6', label: 'San José, Costa Rica' },
  ];

  idiomas = [
    { value: 'es', label: 'Español' },
    { value: 'en', label: 'Inglés' },
    { value: 'pt', label: 'Portugués' }
  ];

  estados = [
    { value: 'activo', label: 'Activo' },
    { value: 'inactivo', label: 'Inactivo' }
  ];
  mesActual: string = '';
  anioActual: number = 0;

  constructor(
    private fb: FormBuilder,
    private modalController: ModalController
  ) {}

  ngOnInit() {
    
    // Establecer valores por defecto
    const currentDate = new Date();
    const monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
      const currentMonth = monthNames[currentDate.getMonth()];
      const currentYear = currentDate.getFullYear();
      this.mesActual = monthNames[currentDate.getMonth()];
      this.anioActual = currentDate.getFullYear();
      
    this.sucursalForm = this.fb.group({
      nombre: ['', Validators.required],
      correoElectronico: ['', [Validators.required, Validators.email]],
      direccionFiscal: ['', Validators.required],
      ruc: ['', [Validators.required, Validators.minLength(11), Validators.maxLength(11)]],
      zonaHoraria: ['', Validators.required],
      periodoContableInicial: [`${currentMonth}, ${currentYear}`, Validators.required],
      idioma: ['es', Validators.required],
      estado: ['activo', Validators.required]
    });
  }

  cerrarModal() {
    this.modalController.dismiss();
  }

  onPeriodoContableInicialChange(event: { month: string, year: number }) {
    // Formatear como "Enero, 2025"
    const periodoFormateado = `${event.month}, ${event.year}`;
    this.sucursalForm.patchValue({
      periodoContableInicial: periodoFormateado
    });
  }

  validarFormulario(): boolean {
    const form = this.sucursalForm;
    return !!(
      form.get('nombre')?.valid &&
      form.get('correoElectronico')?.valid && 
      form.get('direccionFiscal')?.valid && 
      form.get('ruc')?.valid && 
      form.get('zonaHoraria')?.valid && 
      form.get('periodoContableInicial')?.valid && 
      form.get('idioma')?.valid && 
      form.get('estado')?.valid
    );
  }

  agregarSucursal() {
    if (this.sucursalForm.valid) {
      const nuevaSucursal = {
        id: Date.now(),
        nombre: `Sucursal - ${this.sucursalForm.value.ruc}`,
        ...this.sucursalForm.value
      };
      this.modalController.dismiss({ action: 'agregar', sucursal: nuevaSucursal });
    }
  }
}
