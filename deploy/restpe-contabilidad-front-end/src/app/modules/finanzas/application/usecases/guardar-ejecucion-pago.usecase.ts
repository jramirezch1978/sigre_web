import { Injectable, inject } from '@angular/core';
import { IEjecucionPagoRepository } from '../../domain/repositories/iejecucion-pago.repository';
import { EjecucionPagoStore } from '../../store/ejecucion-pago.store';
import { EjecucionPagoEntity } from '../../domain/models/ejecucion-pago.entity';

@Injectable()
export class GuardarEjecucionPagoUseCase {
  private readonly repo = inject(IEjecucionPagoRepository);
  private readonly store = inject(EjecucionPagoStore);

  execute(entity: EjecucionPagoEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);
    this.store.setGuardadoOk(false);
    this.repo.guardar(entity).subscribe({
      next: saved => {
        if (saved.ep_codigo && this.store.pagos().some(p => p.ep_codigo === saved.ep_codigo)) {
          this.store.updatePago(saved);
        } else {
          this.store.addPago(saved);
        }
        this.store.setLoadingGuardar(false);
        this.store.setGuardadoOk(true);
      },
      error: err => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el pago');
        this.store.setLoadingGuardar(false);
      },
    });
  }
}
