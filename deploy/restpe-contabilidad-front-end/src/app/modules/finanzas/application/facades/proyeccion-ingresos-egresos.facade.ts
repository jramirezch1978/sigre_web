import { Injectable, inject } from '@angular/core';
import { ProyeccionIngresosEgresosStore } from '../../store/proyeccion-ingresos-egresos.store';
import { ObtenerProyeccionIngresosEgresosUseCase } from '../usecases/obtener-proyeccion-ingresos-egresos.usecase';

@Injectable()
export class ProyeccionIngresosEgresosFacade {
  private readonly store = inject(ProyeccionIngresosEgresosStore);
  private readonly obtenerUseCase = inject(ObtenerProyeccionIngresosEgresosUseCase);

  readonly proyecciones = this.store.proyecciones;
  readonly isLoading = this.store.isLoading;
  readonly error = this.store.error;

  cargarProyecciones(): void {
    this.store.setLoading(true);
    this.obtenerUseCase.execute().subscribe({
      next: (proyecciones) => this.store.setProyecciones(proyecciones),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar proyecciones'),
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
