import { Component, Input, OnInit, inject, computed } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { PolizaSeguroFacade } from '../../../../../application/facades/poliza-seguro.facade';
import { AseguradoraFacade } from '../../../../../application/facades/aseguradora.facade';

@Component({
  selector: 'app-generacionsiniestro-tab-registro',
  templateUrl: './generacionsiniestro-tab-registro.component.html',
  styleUrls: ['./generacionsiniestro-tab-registro.component.scss'],
  standalone: false,
})
export class GeneracionsiniestroTabRegistroComponent  implements OnInit {

  @Input() mostrartabla: boolean = true;
  @Input() soloVista: boolean = false;
  @Input() formGroup!: FormGroup;

  tabfechaincidente=[
    {value: 'robo', nombre: 'Robo'},
    {value: 'incendio', nombre: 'Incendio'},
    {value: 'inundacion', nombre: 'Inundación'},
    {value: 'danomecanico', nombre: 'Daño mecanico'},
  ];

  private readonly polizaSeguroFacade = inject(PolizaSeguroFacade);
  private readonly aseguradoraFacade = inject(AseguradoraFacade);

  polizasAsociadas = computed(() =>
    this.polizaSeguroFacade.polizas().map(p => ({
      codigo: p.poliza_codigo,
      nombre: `${p.poliza_codigo} - ${p.poliza_aseguradora}`,
    }))
  );

  aseguradoras = computed(() =>
    this.aseguradoraFacade.aseguradoras().map(a => ({
      codigo: a.aseguradora_codigo,
      nombre: a.aseguradora_razon_social,
    }))
  );

  ngOnInit() {
    this.polizaSeguroFacade.cargarPolizas();
    this.aseguradoraFacade.cargarAseguradoras();
  }

  onPolizaSeleccionada(poliza: any) {
    this.formGroup.get('polizaAsociada')?.setValue(poliza.codigo);
  }
  onAseguradoraSeleccionada(aseguradora: any) {
    this.formGroup.get('aseguradora')?.setValue(aseguradora.nombre);
  }

  onFechaIncidente(fecha: Date) {
    const dd = String(fecha.getDate()).padStart(2, '0');
    const mm = String(fecha.getMonth() + 1).padStart(2, '0');
    const yyyy = fecha.getFullYear();
    this.formGroup.patchValue({ fechaIncidente: `${yyyy}-${mm}-${dd}` });
  }

}
