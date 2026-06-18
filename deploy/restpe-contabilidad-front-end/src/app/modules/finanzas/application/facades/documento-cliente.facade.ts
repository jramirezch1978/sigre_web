import { Injectable, inject } from '@angular/core';
import { DocumentoClienteStore } from '../../store/documento-cliente.store';
import { ObtenerDocumentoClienteUseCase } from '../usecases/obtener-documento-cliente.usecase';

@Injectable()
export class DocumentoClienteFacade {
  private readonly store = inject(DocumentoClienteStore);
  private readonly obtenerUseCase = inject(ObtenerDocumentoClienteUseCase);

  readonly documentos = this.store.documentos;
  readonly isLoading = this.store.isLoading;
  readonly error = this.store.error;

  cargarDocumentos(): void {
    this.store.setLoading(true);
    this.obtenerUseCase.execute().subscribe({
      next: (documentos) => this.store.setDocumentos(documentos),
      error: (err) => this.store.setError(err?.message ?? 'Error al cargar documentos de clientes'),
    });
  }

  resetState(): void {
    this.store.resetState();
  }
}
