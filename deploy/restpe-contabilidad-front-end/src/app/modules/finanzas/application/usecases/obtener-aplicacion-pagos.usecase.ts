import { Injectable, inject } from '@angular/core';
import { IAplicacionPagosRepository } from '../../domain/repositories/iaplicacion-pagos.repository';
import { AplicacionPagosStore } from '../../store/aplicacion-pagos.store';

@Injectable()
export class ObtenerAplicacionPagosUseCase {
  private readonly repo = inject(IAplicacionPagosRepository);
  private readonly store = inject(AplicacionPagosStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setRegistros(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al cargar aplicación de pagos');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
