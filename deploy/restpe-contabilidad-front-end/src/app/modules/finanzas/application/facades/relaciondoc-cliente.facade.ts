import { Injectable, inject } from '@angular/core';
import { RelacionDocClienteStore } from '../../store/relaciondoc-cliente.store';
import { ObtenerRelacionDocClienteUseCase } from '../usecases/obtener-relaciondoc-cliente.usecase';

@Injectable()
export class RelacionDocClienteFacade {
  private readonly store = inject(RelacionDocClienteStore);
  private readonly obtenerUC = inject(ObtenerRelacionDocClienteUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly facturasPorCliente = this.store.facturasPorCliente;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDatos(): void {
    this.obtenerUC.execute();
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
