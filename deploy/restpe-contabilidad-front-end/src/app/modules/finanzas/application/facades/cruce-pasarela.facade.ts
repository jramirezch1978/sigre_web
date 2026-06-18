import { Injectable, inject } from '@angular/core';
import { CrucePasarelaStore } from '../../store/cruce-pasarela.store';
import { ObtenerCrucePasarelaUseCase } from '../usecases/obtener-cruce-pasarela.usecase';
import { ObtenerMovimientoPasarelaUseCase } from '../usecases/obtener-movimiento-pasarela.usecase';

@Injectable()
export class CrucePasarelaFacade {
  private readonly store = inject(CrucePasarelaStore);
  private readonly obtenerCrucesUseCase = inject(ObtenerCrucePasarelaUseCase);
  private readonly obtenerMovimientosUseCase = inject(ObtenerMovimientoPasarelaUseCase);

  readonly cruces = this.store.cruces;
  readonly movimientos = this.store.movimientos;
  readonly isLoading = this.store.isLoading;
  readonly error = this.store.error;

  cargarCruces(): void {
    this.store.setLoading(true);
    this.obtenerCrucesUseCase.execute().subscribe({
      next: (cruces) => this.store.setCruces(cruces),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar cruces de pasarela'),
    });
  }

  cargarMovimientos(): void {
    this.store.setLoading(true);
    this.obtenerMovimientosUseCase.execute().subscribe({
      next: (movimientos) => this.store.setMovimientos(movimientos),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar movimientos de pasarela'),
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
