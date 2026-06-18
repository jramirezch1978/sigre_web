import { Injectable, inject } from '@angular/core';
import { ProveedorActivoEntity } from '../../domain/models/proveedor-activo.entity';
import { ProveedorActivoStore } from '../../store/proveedor-activo.store';
import { ObtenerProveedoresActivoUseCase } from '../usecases/obtener-proveedores-activo.usecase';

@Injectable()
export class ProveedorActivoFacade {

  private readonly store      = inject(ProveedorActivoStore);
  private readonly obtenerUC  = inject(ObtenerProveedoresActivoUseCase);

  // ─────────── Selectores expuestos al componente ───────────
  readonly proveedores     = this.store.proveedores;
  readonly isLoading       = this.store.isLoading;
  readonly loadingObtener  = this.store.loadingObtener;
  readonly errorObtener    = this.store.errorObtener;

  // ─────────── Acciones ───────────

  cargarProveedores(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (proveedores: ProveedorActivoEntity[]) => {
        this.store.setProveedores(proveedores);
        this.store.setLoadingObtener(false);
      },
      error: (err: Error) => {
        this.store.setErrorObtener(err.message ?? 'Error al cargar proveedores');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
