import { Injectable, inject } from '@angular/core';
import { IRegistroFacturaRepository } from '../../domain/repositories/iregistro-factura.repository';
import { RegistroFacturaStore } from '../../store/registro-factura.store';
import { RegistroFacturaEntity } from '../../domain/models/registro-factura.entity';

@Injectable()
export class GuardarRegistroFacturaUseCase {
  private readonly repo = inject(IRegistroFacturaRepository);
  private readonly store = inject(RegistroFacturaStore);

  execute(factura: RegistroFacturaEntity): void {
    this.store.setLoadingGuardar(true);
    this.repo.guardar(factura).subscribe({
      next: saved => this.store.addFactura(saved),
      error: err => this.store.setErrorGuardar(err?.message ?? 'Error al guardar la factura'),
    });
  }
}
