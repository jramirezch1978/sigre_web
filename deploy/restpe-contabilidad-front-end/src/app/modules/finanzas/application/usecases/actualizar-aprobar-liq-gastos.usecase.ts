import { Injectable, inject } from '@angular/core';
import { IAprobarLiqGastosRepository } from '../../domain/repositories/iaprobar-liq-gastos.repository';
import { AprobarLiqGastosStore } from '../../store/aprobar-liq-gastos.store';
import { LiqRendicionEntity } from '../../domain/models/liq-rendicion.entity';

@Injectable()
export class ActualizarAprobarLiqGastosUseCase {
  private readonly repo = inject(IAprobarLiqGastosRepository);
  private readonly store = inject(AprobarLiqGastosStore);

  execute(entity: LiqRendicionEntity, mensaje?: string): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);
    this.store.setActualizadoOk(false);
    this.store.setMensajeExito(null);
    this.repo.actualizar(entity).subscribe({
      next: updated => {
        this.store.updateLiquidacion(updated);
        this.store.setLoadingActualizar(false);
        this.store.setMensajeExito(mensaje ?? (updated as any)?.mensaje ?? null);
        this.store.setActualizadoOk(true);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar liquidación');
        this.store.setLoadingActualizar(false);
      },
    });
  }
}
