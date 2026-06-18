import { Injectable, inject } from '@angular/core';
import { ILiqRendicionRepository } from '../../domain/repositories/iliq-rendicion.repository';
import { LiqRendicionStore } from '../../store/liq-rendicion.store';
import { LiqRendicionEntity } from '../../domain/models/liq-rendicion.entity';

@Injectable()
export class GuardarLiqRendicionUseCase {
  private readonly repo = inject(ILiqRendicionRepository);
  private readonly store = inject(LiqRendicionStore);

  execute(entity: LiqRendicionEntity, esEdicion: boolean): void {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);
    this.store.setGuardadoOk(false);
    this.repo.guardar(entity).subscribe({
      next: saved => {
        if (esEdicion) {
          this.store.updateLiquidacion(saved);
        } else {
          this.store.addLiquidacion(saved);
        }
        this.store.setLoadingGuardar(false);
        this.store.setGuardadoOk(true);
      },
      error: err => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar liquidación');
        this.store.setLoadingGuardar(false);
      },
    });
  }
}
