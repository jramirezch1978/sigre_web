import { Component, Input, OnInit, OnChanges, SimpleChanges } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

interface IDestino {
  id: number;
  nombre: string;
}

interface ISolicitante {
  id: number;
  nombre: string;
}

@Component({
  selector: 'app-at-tab-ubicacion',
  templateUrl: './at-tab-ubicacion.component.html',
  styleUrls: ['./at-tab-ubicacion.component.scss'],
  standalone: false,
})
export class AtTabUbicacionComponent implements OnInit, OnChanges {
  @Input() mostrartabla: boolean = true;
  @Input() datosTraslado: any; // Recibe los datos del traslado desde el componente padre
  formulario!: FormGroup;
  fechaSolicitud: Date | undefined;  

  destinos: IDestino[] = [
    { id: 1, nombre: 'Almacén Central' },
    { id: 2, nombre: 'Sucursal Lima' },
    { id: 3, nombre: 'Sucursal Arequipa' },
    { id: 4, nombre: 'Sucursal Cusco' },
    { id: 5, nombre: 'Sucursal Trujillo' },
    { id: 6, nombre: 'Sucursal Piura' }
  ];

  solicitantes: ISolicitante[] = [
    { id: 1, nombre: 'Juan Pérez' },
    { id: 2, nombre: 'María González' },
    { id: 3, nombre: 'Carlos Rodríguez' },
    { id: 4, nombre: 'Ana Martínez' },
    { id: 5, nombre: 'Luis Fernández' },
    { id: 6, nombre: 'Carmen Torres' }
  ];

  constructor(private fb: FormBuilder) { }

  ngOnInit() {
    this.initForm();
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes['datosTraslado'] && this.datosTraslado && this.formulario) {
      console.log('Datos recibidos en AtTabUbicacion:', this.datosTraslado);
      this.formulario.patchValue({
        destino:         this.datosTraslado.atr_destino || '',
        solicitante:     this.datosTraslado.atr_solicitante || '',
        fechaProgramada: this.datosTraslado.atr_fecha_programada || '',
        observaciones:   this.datosTraslado.atr_observaciones || '',
        aprobacion:      this.datosTraslado.atr_aprobacion || '',
        fechaAprobacion: this.datosTraslado.atr_fecha_aprobacion || '',
        ejecucion:       this.datosTraslado.atr_ejecucion || '',
        fechaEjecucion:  this.datosTraslado.atr_fecha_ejecucion || ''
      });
    }
  }

  initForm() {
    this.formulario = this.fb.group({
      destino: [{ value: '', disabled: true }],
      solicitante: [{ value: '', disabled: true }],
      fechaProgramada: [{ value: '', disabled: true }],
      observaciones: [{ value: '', disabled: true }],
      aprobacion: [{ value: '', disabled: true }],
      fechaAprobacion: [{ value: '', disabled: true }],
      ejecucion: [{ value: '', disabled: true }],
      fechaEjecucion: [{ value: '', disabled: true }]
    });
  }

  onDestinoSeleccionado(destino: IDestino) {
    console.log('Destino seleccionado:', destino);
  }

  onSolicitanteSeleccionado(solicitante: ISolicitante) {
    console.log('Solicitante seleccionado:', solicitante);
  }

  onFechaSolicitud(date: Date) {
    console.log('Fecha Solicitud:', date);
    this.fechaSolicitud = date;  
  }

}
