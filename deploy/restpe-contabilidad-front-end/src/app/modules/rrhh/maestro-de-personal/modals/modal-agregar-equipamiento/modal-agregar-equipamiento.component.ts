import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faPlusCircle } from '@fortawesome/pro-regular-svg-icons';
import { faXmark } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-agregar-equipamiento',
  templateUrl: './modal-agregar-equipamiento.component.html',
  styleUrls: ['./modal-agregar-equipamiento.component.scss'],
  standalone:false, 
})
export class ModalAgregarEquipamientoComponent  implements OnInit {
  // Font Awesome Icons
  farPlusCircle = faPlusCircle;
  fasXmark = faXmark;



  @Input() esEdicion: boolean = false;
  @Input() data: any = null;

  archivo: any
  tipos= [
    'Uniforme',
    'Activo fijo'
  ];
  estados = [
    'Pendiente',
    'Asignado',
    'Devuelto'
  ];
  activosF = [
    'Laptop',
    'Teléfono',
    'Escritorio',
    'Silla',
    'Otros',
  ]
  responsables = [
    'Juan Pérez',
    'María López',
    'Carlos García',
    'Carlos Zapata',
  ]

  formulario!: FormGroup;


  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder
  ) {}

  ngOnInit() {
    console.log('Datos recibidos en el modal:', this.data);
    this.crearFormulario();
    if(this.data){
      this.llenarFormulario()
    }
  }

  crearFormulario() {
    this.formulario = this.formBuilder.group({
      tipo: ['Uniforme', [Validators.required]],
      descripcion: [''],
      activoF: [''],
      cantidad: ['', [Validators.required]],
      responsable: ['', Validators.required],
      documento: [null],
      estado: ['Pendiente', Validators.required,]
    });
  }

  habilitarBoton(): boolean {
    const tipo = this.formulario.get('tipo')?.value;
    const cantidad = this.formulario.get('cantidad')?.value;
    const responsable = this.formulario.get('responsable')?.value;
    const estado = this.formulario.get('estado')?.value;

    if (tipo === 'Activo fijo') {
      const activoF = this.formulario.get('activoF')?.value;
      return tipo && activoF && cantidad && responsable && estado;
    } else {
      const descripcion = this.formulario.get('descripcion')?.value;
      return tipo && descripcion && cantidad && responsable && estado;
    }
  }

  onFileSelected(file: File) {
    this.formulario.patchValue({ documento: file });
  }

  onFileRemoved() {
    this.formulario.patchValue({ documento: null });
  }

  showFileError(error: string) {
    console.error('Error al cargar archivo:', error);
  }

  registrarContrato() {
    if (this.formulario.valid) {
      const datosFormulario = this.formulario.value;
      
      // Transformar datos al formato esperado por el grid
      const nuevoRegistro = {
        fechaAsignacion: new Date().toISOString().split('T')[0],
        tipoElemento: datosFormulario.tipo,
        descripcion: datosFormulario.tipo === 'Uniforme' ? datosFormulario.descripcion : datosFormulario.activoF,
        cantidad: datosFormulario.cantidad,
        responsableEntrega: datosFormulario.responsable,
        estado: datosFormulario.estado,
      };
      
      console.log('Enviando datos del modal:', nuevoRegistro);
      this.modalController.dismiss(nuevoRegistro);
    }
  }

  closemodal() {
    this.modalController.dismiss();
  }

  llenarFormulario(){
    const datos = this.data;
    this.formulario.patchValue({
      tipo: datos.tipo || 'Uniforme',
      descripcion: datos.descripcion || '',
      activoF: datos.activoF || '',
      cantidad: datos.cantidad || '',
      responsable: datos.responsableEntrega || '',
      estado: datos.estado || 'Pendiente',
    });
  }

  onArchivoSelected(file: File) {
    this.archivo = file;
    console.log('Archivo seleccionado:', file.name);
  }

  onArchivoRemoved() {
    this.archivo = null;
    console.log('Archivo removido');
  }

}
