import { Injectable, inject } from '@angular/core';
import { ICerrarLiqAdelantosRepository } from '../../domain/repositories/icerrar-liq-adelantos.repository';
import { CerrarLiqAdelantosStore } from '../../store/cerrar-liq-adelantos.store';
import { CerrarLiqAdelantosEntity } from '../../domain/models/cerrar-liq-adelantos.entity';

@Injectable()
export class ActualizarCerrarLiqAdelantosUseCase {
  private readonly repo = inject(ICerrarLiqAdelantosRepository);
  private readonly store = inject(CerrarLiqAdelantosStore);

  execute(entity: CerrarLiqAdelantosEntity, mensaje?: string): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);
    this.store.setActualizadoOk(false);
    this.repo.actualizar(entity).subscribe({
      next: updated => {
        this.store.updateLiquidacion(updated);
        this.store.setLoadingActualizar(false);
        this.store.setMensajeExito(mensaje ?? null);
        this.store.setActualizadoOk(true);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar liquidación');
        this.store.setLoadingActualizar(false);
      },
    });
  }
}
