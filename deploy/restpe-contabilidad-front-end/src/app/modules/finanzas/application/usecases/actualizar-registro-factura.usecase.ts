import { Injectable, inject } from '@angular/core';
import { IRegistroFacturaRepository } from '../../domain/repositories/iregistro-factura.repository';
import { RegistroFacturaStore } from '../../store/registro-factura.store';
import { RegistroFacturaEntity } from '../../domain/models/registro-factura.entity';

@Injectable()
export class ActualizarRegistroFacturaUseCase {
  private readonly repo = inject(IRegistroFacturaRepository);
  private readonly store = inject(RegistroFacturaStore);

  execute(factura: RegistroFacturaEntity): void {
    this.store.setLoadingActualizar(true);
    this.repo.actualizar(factura).subscribe({
      next: updated => this.store.updateFactura(updated),
      error: err => this.store.setErrorActualizar(err?.message ?? 'Error al actualizar la factura'),
    });
  }
}
