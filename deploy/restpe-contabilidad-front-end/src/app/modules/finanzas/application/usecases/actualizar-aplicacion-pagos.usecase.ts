import { Injectable, inject } from '@angular/core';
import { IAplicacionPagosRepository } from '../../domain/repositories/iaplicacion-pagos.repository';
import { AplicacionPagosStore } from '../../store/aplicacion-pagos.store';
import { AplicacionPagosEntity } from '../../domain/models/aplicacion-pagos.entity';

@Injectable()
export class ActualizarAplicacionPagosUseCase {
  private readonly repo = inject(IAplicacionPagosRepository);
  private readonly store = inject(AplicacionPagosStore);

  execute(entity: AplicacionPagosEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);
    this.store.setActualizadoOk(false);
    this.repo.actualizar(entity).subscribe({
      next: updated => {
        this.store.updateRegistro(updated);
        this.store.setLoadingActualizar(false);
        this.store.setActualizadoOk(true);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar aplicación de pago');
        this.store.setLoadingActualizar(false);
      },
    });
  }
}
