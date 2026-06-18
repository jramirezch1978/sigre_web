import { Injectable, inject } from '@angular/core';
import { IRegistroFacturaRepository } from '../../domain/repositories/iregistro-factura.repository';
import { RegistroFacturaStore } from '../../store/registro-factura.store';

@Injectable()
export class ObtenerRegistroFacturaUseCase {
  private readonly repo = inject(IRegistroFacturaRepository);
  private readonly store = inject(RegistroFacturaStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.repo.obtenerTodos().subscribe({
      next: facturas => this.store.setFacturas(facturas),
      error: err => this.store.setErrorObtener(err?.message ?? 'Error al obtener las facturas'),
    });
  }
}
