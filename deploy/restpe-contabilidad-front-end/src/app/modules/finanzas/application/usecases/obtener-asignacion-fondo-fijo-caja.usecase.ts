import { Injectable, inject } from '@angular/core';
import { IAsignacionFondoFijoCajaRepository } from '../../domain/repositories/iasignacion-fondo-fijo-caja.repository';
import { AsignacionFondoFijoCajaStore } from '../../store/asignacion-fondo-fijo-caja.store';

@Injectable()
export class ObtenerAsignacionFondoFijoCajaUseCase {
  private readonly repo = inject(IAsignacionFondoFijoCajaRepository);
  private readonly store = inject(AsignacionFondoFijoCajaStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setAsignaciones(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las asignaciones de fondo fijo');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
