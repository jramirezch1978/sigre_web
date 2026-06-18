import { computed, Injectable, signal } from '@angular/core';
import {
  initialSunatTipoDocumentoState,
  SunatTipoDocumentoState,
} from './sunat-tipo-documento.state';
import { SunatTipoDocumentoEntity } from '../domain/models/tipo-documento.entity';

@Injectable()
export class SunatTipoDocumentoStore {
  private readonly state = signal<SunatTipoDocumentoState>(
    initialSunatTipoDocumentoState,
  );

  readonly sunatDocumentos = computed(() => this.state().sunatDocumentos);
  readonly sunatDocumentosActivos = computed(
    () => this.state().sunatDocumentosActivos,
  );

  readonly isLoading = computed(() => this.state().loadingObtener);

  readonly hasError = computed(() => !!this.state().errorObtener);

  setTiposDocumento(sunatDocumentos: SunatTipoDocumentoEntity[]): void {
    this.state.update((state) => ({
      ...state,
      sunatDocumentos,
      errorObtener: null,
    }));
  }

  setTiposDocumentoActivos(sunatDocumentos: SunatTipoDocumentoEntity[]): void {
    this.state.update((state) => ({
      ...state,
      sunatDocumentosActivos: sunatDocumentos,
      errorObtener: null,
    }));
  }

  setLoadingObtener(loading: boolean): void {
    this.state.update((s) => ({ ...s, loadingObtener: loading }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update((s) => ({
      ...s,
      errorObtener: error,
      loadingObtener: false,
    }));
  }

  resetErrors(): void {
    this.state.update((s) => ({
      ...s,
      errorObtener: null,
      errorGuardar: null,
      errorEliminar: null,
      errorActualizar: null,
    }));
  }
}
