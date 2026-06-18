import { Injectable, inject } from '@angular/core';
import { RelacionDocProveedorStore } from '../../store/relaciondoc-proveedor.store';
import { ObtenerRelacionDocProveedorUseCase } from '../usecases/obtener-relaciondoc-proveedor.usecase';

@Injectable()
export class RelacionDocProveedorFacade {
  private readonly store = inject(RelacionDocProveedorStore);
  private readonly obtenerUC = inject(ObtenerRelacionDocProveedorUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly facturasPorProveedor = this.store.facturasPorProveedor;
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
