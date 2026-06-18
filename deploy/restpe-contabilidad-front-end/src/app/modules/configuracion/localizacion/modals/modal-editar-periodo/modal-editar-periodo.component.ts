import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

// Font Awesome Icons
import { faEdit } from '@fortawesome/pro-regular-svg-icons';
import { faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-editar-periodo',
  templateUrl: './modal-editar-periodo.component.html',
  styleUrls: ['./modal-editar-periodo.component.scss'],
  standalone: false,
})
export class ModalEditarPeriodoComponent implements OnInit {
  // Font Awesome Icons
  farEdit = faEdit;
  fasXmark = faXmark;



  @Input() data: any;


  cierreSeleccionado: string= 'todos';
  formulario!: FormGroup;
  fechaInicio: Date | undefined;
  fechaFin: Date | undefined;

  modulos = [
    { id: '1', nombre: 'Contabilidad' },
    { id: '2', nombre: 'Inventarios' },
    { id: '3', nombre: 'Ventas' },
    { id: '4', nombre: 'Bancos' },
    { id: '5', nombre: 'Activos' },
    { id: '6', nombre: 'Compras' },
  ];

    tipoCierre=[
    { label: 'Pre-cierre', value: 'precierre' },
    { label: 'Cierre definitivo', value: 'cierredefinitivo' },
  ]

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder
  ) { }

  ngOnInit() {
    this.inicializarFormulario();
    this.llenarFormulario(this.data);

  }

  inicializarFormulario() {
    this.formulario = this.formBuilder.group({
      modalNombre: ['', Validators.required],
      modalfechaInicioInput: [{ value: '', disabled: true }, Validators.required],
      modalfechaFinInput: [{ value: '', disabled: true }, Validators.required],
      recordatorioDias: ['', [Validators.required, Validators.min(0)]],
      cierresModulos: [[], Validators.required]
    });
  }

  llenarFormulario(datos: any) {
    this.formulario.patchValue({
      modalNombre: datos.nombre,  
      modalfechaInicioInput: datos.fechaInicioDetalle,
      modalfechaFinInput: datos.fechaFinDetalle,
      recordatorioDias: datos.recordatorioDias,
      cierresModulos: datos.cierre
    });
  }

  cerrarModal() {
    this.modalController.dismiss(null, 'cancel');
  }

  guardar() {
    // Validar que el formulario sea válido
    if (this.formulario.invalid) {
      console.error('Formulario inválido');
      return;
    }

    // Obtener los valores del formulario incluyendo los campos deshabilitados
    const datosActualizados = this.formulario.getRawValue();

    // Retornar los datos al modal que lo abrió
    this.modalController.dismiss(datosActualizados, 'guardar');
  }


  onModulosSeleccionadas(modulos: any[]) {
    console.log('Módulos seleccionados:', modulos);
    // Aquí puedes manejar los módulos seleccionados
  }

}
