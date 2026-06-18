import { Component, Input, OnInit } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { GeneracionAsientosSiniestroEntity } from '../../../../../domain/models/generacion-asientos-siniestro.entity';

@Component({
  selector: 'app-generacionsiniestro-tab-reclamo',
  templateUrl: './generacionsiniestro-tab-reclamo.component.html',
  styleUrls: ['./generacionsiniestro-tab-reclamo.component.scss'],
  standalone: false,
})
export class GeneracionsiniestroTabReclamoComponent  implements OnInit {

  @Input() mostrartabla: boolean = false;
  @Input() soloVista: boolean = false;
  @Input() formGroup!: FormGroup;

  tabestadodereclamo=[
    {value: 'Reportado', nombre: 'Reportado'},
    {value: 'En evaluación', nombre: 'En evaluación'},
    {value: 'Aprobado', nombre: 'Aprobado'},
    {value: 'Rechazado', nombre: 'Rechazado'},
    {value: 'Indemnizado', nombre: 'Indemnizado'},
  ];

  constructor() { }

  ngOnInit() {}

  onFechaComunicacion(fecha: Date) {
    const dd = String(fecha.getDate()).padStart(2, '0');
    const mm = String(fecha.getMonth() + 1).padStart(2, '0');
    const yyyy = fecha.getFullYear();
    this.formGroup.get('fechaComunicacion')?.setValue(`${yyyy}-${mm}-${dd}`);
  }

  onFechaRespuesta(fecha: Date) {
    const dd = String(fecha.getDate()).padStart(2, '0');
    const mm = String(fecha.getMonth() + 1).padStart(2, '0');
    const yyyy = fecha.getFullYear();
    this.formGroup.get('fechaRespuesta')?.setValue(`${yyyy}-${mm}-${dd}`);
  }
}
