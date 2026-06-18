import { Injectable, inject } from '@angular/core';
import { ConsultaDocumentosStore } from '../../store/consulta-documentos.store';
import { ObtenerConsultaDocumentosUseCase } from '../usecases/obtener-consulta-documentos.usecase';

@Injectable()
export class ConsultaDocumentosFacade {
  private readonly store = inject(ConsultaDocumentosStore);
  private readonly obtenerUC = inject(ObtenerConsultaDocumentosUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly registros = this.store.registros;
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
