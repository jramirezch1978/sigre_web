import { Injectable, inject } from '@angular/core';
import { CruceExtractoStore } from '../../store/cruce-extracto.store';
import { ObtenerCruceExtractoUseCase } from '../usecases/obtener-cruce-extracto.usecase';
import { ObtenerMovimientoCruceUseCase } from '../usecases/obtener-movimiento-cruce.usecase';

@Injectable()
export class CruceExtractoFacade {
  private readonly store = inject(CruceExtractoStore);
  private readonly obtenerUseCase = inject(ObtenerCruceExtractoUseCase);
  private readonly obtenerMovimientosUseCase = inject(ObtenerMovimientoCruceUseCase);

  readonly cruces = this.store.cruces;
  readonly movimientos = this.store.movimientos;
  readonly isLoading = this.store.isLoading;
  readonly error = this.store.error;

  cargarCruces(): void {
    this.store.setLoading(true);
    this.obtenerUseCase.execute().subscribe({
      next: (cruces) => this.store.setCruces(cruces),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar cruces de extracto'),
    });
  }

  cargarMovimientos(): void {
    this.store.setLoading(true);
    this.obtenerMovimientosUseCase.execute().subscribe({
      next: (movimientos) => this.store.setMovimientos(movimientos),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar movimientos del sistema'),
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
