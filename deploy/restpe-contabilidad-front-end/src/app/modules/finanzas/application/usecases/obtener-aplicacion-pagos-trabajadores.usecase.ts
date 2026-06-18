import { Injectable, inject } from '@angular/core';
import { IAplicacionPagosRepository } from '../../domain/repositories/iaplicacion-pagos.repository';
import { AplicacionPagosStore } from '../../store/aplicacion-pagos.store';

@Injectable()
export class ObtenerAplicacionPagosTrabajadoresUseCase {
  private readonly repo = inject(IAplicacionPagosRepository);
  private readonly store = inject(AplicacionPagosStore);

  execute(): void {
    this.store.setLoadingTrabajadores(true);
    this.store.setErrorTrabajadores(null);
    this.repo.obtenerTrabajadores().subscribe({
      next: data => {
        this.store.setTrabajadores(data);
        this.store.setLoadingTrabajadores(false);
      },
      error: err => {
        this.store.setErrorTrabajadores(err?.message ?? 'Error al cargar trabajadores');
        this.store.setLoadingTrabajadores(false);
      },
    });
  }
}
