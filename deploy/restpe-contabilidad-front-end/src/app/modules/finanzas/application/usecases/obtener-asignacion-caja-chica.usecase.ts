import { Injectable, inject } from '@angular/core';
import { IAsignacionCajaChicaRepository } from '../../domain/repositories/iasignacion-caja-chica.repository';
import { AsignacionCajaChicaStore } from '../../store/asignacion-caja-chica.store';

@Injectable()
export class ObtenerAsignacionCajaChicaUseCase {
  private readonly repo = inject(IAsignacionCajaChicaRepository);
  private readonly store = inject(AsignacionCajaChicaStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setAsignaciones(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las asignaciones de caja chica');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
