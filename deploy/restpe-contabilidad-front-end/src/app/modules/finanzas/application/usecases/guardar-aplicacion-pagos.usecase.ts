import { Injectable, inject } from '@angular/core';
import { IAplicacionPagosRepository } from '../../domain/repositories/iaplicacion-pagos.repository';
import { AplicacionPagosStore } from '../../store/aplicacion-pagos.store';
import { AplicacionPagosEntity } from '../../domain/models/aplicacion-pagos.entity';

@Injectable()
export class GuardarAplicacionPagosUseCase {
  private readonly repo = inject(IAplicacionPagosRepository);
  private readonly store = inject(AplicacionPagosStore);

  execute(entity: AplicacionPagosEntity): void {
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
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar aplicación de pago');
        this.store.setLoadingGuardar(false);
      },
    });
  }
}
