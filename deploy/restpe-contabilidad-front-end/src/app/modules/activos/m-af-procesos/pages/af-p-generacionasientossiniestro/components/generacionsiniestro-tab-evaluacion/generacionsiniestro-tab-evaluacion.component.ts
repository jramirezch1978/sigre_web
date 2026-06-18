import { Component, Input, OnInit } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { GeneracionAsientosSiniestroEntity } from '../../../../../domain/models/generacion-asientos-siniestro.entity';

@Component({
  selector: 'app-generacionsiniestro-tab-evaluacion',
  templateUrl: './generacionsiniestro-tab-evaluacion.component.html',
  styleUrls: ['./generacionsiniestro-tab-evaluacion.component.scss'],
  standalone: false,
})
export class GeneracionsiniestroTabEvaluacionComponent  implements OnInit {

  @Input() mostrartabla: boolean = false;
  @Input() soloVista: boolean = false;
  @Input() formGroup!: FormGroup;

  constructor() { }

  ngOnInit() {}

  onFechaEvaluacion(fecha: Date) {
    const dd = String(fecha.getDate()).padStart(2, '0');
    const mm = String(fecha.getMonth() + 1).padStart(2, '0');
    const yyyy = fecha.getFullYear();
    this.formGroup.get('fechaEvaluacion')?.setValue(`${yyyy}-${mm}-${dd}`);
  }

  cambioTipo(tipo: string) {
    this.formGroup.patchValue({
      tipoCosto: tipo,
    });
  }
}
