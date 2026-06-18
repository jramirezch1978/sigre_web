import { Injectable, inject } from '@angular/core';
import { IAplicacionPagosRepository } from '../../domain/repositories/iaplicacion-pagos.repository';
import { AplicacionPagosStore } from '../../store/aplicacion-pagos.store';

@Injectable()
export class ObtenerAplicacionPagosPlanillaUseCase {
  private readonly repo = inject(IAplicacionPagosRepository);
  private readonly store = inject(AplicacionPagosStore);

  execute(): void {
    this.store.setLoadingPlanillas(true);
    this.store.setErrorPlanillas(null);
    this.repo.obtenerPlanillas().subscribe({
      next: data => {
        this.store.setPlanillas(data);
        this.store.setLoadingPlanillas(false);
      },
      error: err => {
        this.store.setErrorPlanillas(err?.message ?? 'Error al cargar planillas');
        this.store.setLoadingPlanillas(false);
      },
    });
  }
}
