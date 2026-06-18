import { Injectable, inject } from '@angular/core';
import { RegistroIngresoDeDiaStore } from '../../store/registro-ingreso-de-dia.store';
import { ObtenerRegistroIngresoDeDiaUseCase } from '../usecases/obtener-registro-ingreso-de-dia.usecase';

@Injectable()
export class RegistroIngresoDeDiaFacade {
  private readonly store = inject(RegistroIngresoDeDiaStore);
  private readonly obtenerUseCase = inject(ObtenerRegistroIngresoDeDiaUseCase);

  readonly ingresos = this.store.ingresos;
  readonly isLoading = this.store.isLoading;
  readonly error = this.store.error;

  cargarIngresos(): void {
    this.store.setLoading(true);
    this.obtenerUseCase.execute().subscribe({
      next: (ingresos) => this.store.setIngresos(ingresos),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar ingresos del día'),
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
