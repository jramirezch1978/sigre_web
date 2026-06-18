import { Injectable, inject } from '@angular/core';
import { IRelacionDocClienteRepository } from '../../domain/repositories/irelaciondoc-cliente.repository';
import { RelacionDocClienteStore } from '../../store/relaciondoc-cliente.store';

@Injectable()
export class ObtenerRelacionDocClienteUseCase {
  private readonly repo = inject(IRelacionDocClienteRepository);
  private readonly store = inject(RelacionDocClienteStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setFacturasPorCliente(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener documentos por cliente');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
