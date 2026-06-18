import { Injectable, inject } from '@angular/core';
import { IPagosMasivosRepository } from '../../domain/repositories/ipagos-masivos.repository';
import { PagosMasivosStore } from '../../store/pagos-masivos.store';
import { PagosMasivosEntity } from '../../domain/models/pagos-masivos.entity';

@Injectable()
export class GuardarPagosMasivosUseCase {
  private readonly repo = inject(IPagosMasivosRepository);
  private readonly store = inject(PagosMasivosStore);

  execute(entity: PagosMasivosEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);
    this.store.setGuardadoOk(false);
    this.repo.guardar(entity).subscribe({
      next: saved => {
        this.store.addRegistro(saved);
        this.store.setLoadingGuardar(false);
        this.store.setGuardadoOk(true);
      },
      error: err => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar pago masivo');
        this.store.setLoadingGuardar(false);
      },
    });
  }
}
