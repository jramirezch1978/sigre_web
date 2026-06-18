import { Injectable, inject } from '@angular/core';
import { IRelacionDocProveedorRepository } from '../../domain/repositories/irelaciondoc-proveedor.repository';
import { RelacionDocProveedorStore } from '../../store/relaciondoc-proveedor.store';

@Injectable()
export class ObtenerRelacionDocProveedorUseCase {
  private readonly repo = inject(IRelacionDocProveedorRepository);
  private readonly store = inject(RelacionDocProveedorStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setFacturasPorProveedor(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener documentos por proveedor');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
