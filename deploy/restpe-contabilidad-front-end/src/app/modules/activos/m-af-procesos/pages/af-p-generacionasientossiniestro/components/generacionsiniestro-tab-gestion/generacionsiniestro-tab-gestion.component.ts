import { Component, Input, OnInit } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { GeneracionAsientosSiniestroEntity } from '../../../../../domain/models/generacion-asientos-siniestro.entity';
import { SimulationService } from 'src/app/simulation/simulation.service';

@Component({
  selector: 'app-generacionsiniestro-tab-gestion',
  templateUrl: './generacionsiniestro-tab-gestion.component.html',
  styleUrls: ['./generacionsiniestro-tab-gestion.component.scss'],
  standalone: false,
})
export class GeneracionsiniestroTabGestionComponent  implements OnInit {

  @Input() mostrartabla: boolean = false;
  @Input() soloVista: boolean = false;
  @Input() formGroup!: FormGroup;

  selectrecuper=[
    {value: 'si', nombre: 'Parcial'},
    {value: 'no', nombre: 'Total'},
  ]
  selectcausa=[
    {value: 'Pendiente', nombre: 'Pendiente'},
    {value: 'Reparado', nombre: 'Reparado'},
    {value: 'Rechazado', nombre: 'Rechazado'},
  ]

  todasLasCuentas: any[] = [];
  cuentasList: { id: string; nombre: string }[] = [];

  constructor(
    private simulation: SimulationService,
  ) { }

  ngOnInit() {
    this.todasLasCuentas = this.simulation.list('plancontable') || [];
      this.cuentasList = this.todasLasCuentas.map((item) => ({
        id: item.codigo,
        nombre: `${item.codigo} - ${item.descripcion}`,
      }));

  }

  onFechaRecupero(fecha: Date) {
    const dd = String(fecha.getDate()).padStart(2, '0');
    const mm = String(fecha.getMonth() + 1).padStart(2, '0');
    const yyyy = fecha.getFullYear();
    this.formGroup.get('fechaRecupero')?.setValue(`${yyyy}-${mm}-${dd}`);
  }

  onCuentaSelected(cuenta: any) {
    this.formGroup.get('cuentaContableIngreso')?.setValue(cuenta.codigo);
  }
}
