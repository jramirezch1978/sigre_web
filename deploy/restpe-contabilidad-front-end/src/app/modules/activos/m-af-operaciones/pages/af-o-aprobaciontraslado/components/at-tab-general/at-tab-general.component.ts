import { Component, EventEmitter, Input, OnInit, Output, SimpleChanges } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';

@Component({
  selector: 'app-at-tab-general',
  templateUrl: './at-tab-general.component.html',
  styleUrls: ['./at-tab-general.component.scss'],
  standalone: false,
})
export class AtTabGeneralComponent implements OnInit {

     //FECHAS ÚNICAS (SINGLE)
  fechaSolicitud: Date | undefined;  

  @Output() formValidChange = new EventEmitter<boolean>();
  @Input() datosTraslado: any;
  
  formulario!: FormGroup;

  constructor(private fb: FormBuilder) { }

  ngOnInit() {
    this.initForm();
    
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes['datosTraslado'] && changes['datosTraslado'].currentValue && this.formulario) {
      this.actualizarFormulario(changes['datosTraslado'].currentValue);
    }
  }

  actualizarFormulario(datos: any) {
    // Parsear la fecha de solicitud de DD/MM/YYYY a Date
    let fechaDate: Date | undefined;
    if (datos.atr_fecha_solicitud) {
      const partes = datos.atr_fecha_solicitud.split('/');
      if (partes.length === 3) {
        const dia = parseInt(partes[0], 10);
        const mes = parseInt(partes[1], 10) - 1; // Meses en JS van de 0-11
        const anio = parseInt(partes[2], 10);
        fechaDate = new Date(anio, mes, dia);
        this.fechaSolicitud = fechaDate;
      }
    }

    this.formulario.patchValue({
      activo:         datos.atr_activo || '',
      responsable:    datos.atr_responsable_activo || '',
      area:           datos.atr_area_responsable || '',
      centroCostos:   datos.atr_centro_costos || '',
      activoDos:      datos.atr_activo || '',
      numeroTraslado: datos.atr_numero_traslado || '',
      motivoTraslado: datos.atr_motivo_traslado || '',
      fechaSolicitud: fechaDate || '',
      estado:         datos.atr_estado || ''
    });
    
    // Deshabilitar TODOS los campos para modo solo lectura
    this.formulario.disable();
  }

  initForm() {
    this.formulario = this.fb.group({
      activo: ['', Validators.required],
      responsable: ['', Validators.required],
      area: ['', Validators.required],
      centroCostos: ['', Validators.required],
      activoDos: ['', Validators.required],
      numeroTraslado: ['', Validators.required],
      motivoTraslado: ['', Validators.required],
      fechaSolicitud: ['', Validators.required],
      estado: ['']
    });

    // Emitir el estado de validación cada vez que cambie el formulario
    this.formulario.statusChanges.subscribe(() => {
      this.formValidChange.emit(this.formulario.valid);
    });

    // Emitir el estado inicial
    this.formValidChange.emit(this.formulario.valid);
  }

  onFechaSolicitud(date: Date) {
    this.fechaSolicitud = date;
    this.formulario.patchValue({ fechaSolicitud: date });
  }
}
