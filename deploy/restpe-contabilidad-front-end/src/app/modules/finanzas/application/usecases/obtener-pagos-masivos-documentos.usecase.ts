import { Injectable, inject } from '@angular/core';
import { IPagosMasivosRepository } from '../../domain/repositories/ipagos-masivos.repository';
import { PagosMasivosStore } from '../../store/pagos-masivos.store';

@Injectable()
export class ObtenerPagosMasivosDocumentosUseCase {
  private readonly repo = inject(IPagosMasivosRepository);
  private readonly store = inject(PagosMasivosStore);

  execute(): void {
    this.store.setLoadingDocumentos(true);
    this.store.setErrorDocumentos(null);
    this.repo.obtenerDocumentos().subscribe({
      next: data => {
        this.store.setDocumentos(data);
        this.store.setLoadingDocumentos(false);
      },
      error: err => {
        this.store.setErrorDocumentos(err?.message ?? 'Error al cargar documentos de pagos masivos');
        this.store.setLoadingDocumentos(false);
      },
    });
  }
}
