import { Injectable, inject } from '@angular/core';
import { IConsultaDocumentosRepository } from '../../domain/repositories/iconsulta-documentos.repository';
import { ConsultaDocumentosStore } from '../../store/consulta-documentos.store';

@Injectable()
export class ObtenerConsultaDocumentosUseCase {
  private readonly repo = inject(IConsultaDocumentosRepository);
  private readonly store = inject(ConsultaDocumentosStore);

  execute(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);
    this.repo.obtenerTodos().subscribe({
      next: data => {
        this.store.setRegistros(data);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener documentos');
        this.store.setLoadingObtener(false);
      },
    });
  }
}
