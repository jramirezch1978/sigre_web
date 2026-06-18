import { Injectable, inject } from '@angular/core';
import { CuentaPagarStore } from '../../store/cuenta-pagar.store';
import { ObtenerCuentaPagarUseCase } from '../usecases/obtener-cuenta-pagar.usecase';

@Injectable()
export class CuentaPagarFacade {
  private readonly store = inject(CuentaPagarStore);
  private readonly obtenerUseCase = inject(ObtenerCuentaPagarUseCase);

  readonly facturas = this.store.facturas;
  readonly isLoading = this.store.isLoading;
  readonly error = this.store.error;

  cargarFacturas(): void {
    this.store.setLoading(true);
    this.obtenerUseCase.execute().subscribe({
      next: (facturas) => this.store.setFacturas(facturas),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar cuentas por pagar'),
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
