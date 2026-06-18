import { inject, Injectable } from '@angular/core';
import { SunatTipoDocumentoStore } from '@modules/finanzas/store/sunat-tipo-documento.store';
import { ObtenerSunatTiposDocumentoUseCase } from '../usecases/obtener-sunat-tipo-documento.usecase';

@Injectable()
export class SunatTipoDocumentoFacade {
  private readonly store = inject(SunatTipoDocumentoStore);
  private readonly obtenerUC = inject(ObtenerSunatTiposDocumentoUseCase);

  readonly tiposDocumento = this.store.sunatDocumentos;
  readonly tiposDocumentoActivos = this.store.sunatDocumentosActivos;

  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;

  cargarTiposDocumento(): void {
    this.store.setLoadingObtener(true);
    this.obtenerUC.execute().subscribe({
      next: (tiposDocumento) => this.store.setTiposDocumento(tiposDocumento),
      error: (err) => this.store.setErrorObtener(err.message),
      complete: () => this.store.setLoadingObtener(false),
    });
  }

  cargarTiposDocumentoActivos(): void {
    this.store.setLoadingObtener(true);
    this.obtenerUC.executeActivos().subscribe({
      next: (tiposDocumento) =>
        this.store.setTiposDocumentoActivos(tiposDocumento),
      error: (err) => this.store.setErrorObtener(err.message),
      complete: () => this.store.setLoadingObtener(false),
    });
  }
}
