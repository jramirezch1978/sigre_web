import { computed, Injectable, signal } from '@angular/core';
import {
  initialTipoDocumentoState,
  TipoDocumentoState,
} from './tipo-documento.state';
@Injectable()
export class TipoDocumentoStore {
  private readonly state = signal<TipoDocumentoState>(
    initialTipoDocumentoState,
  );

  readonly tiposDocumento = computed(() => this.state().tiposDocumento);
  readonly tipoDocumentoSeleccionado = computed(
    () => this.state().tipoDocumentoSeleccionado,
  );

  readonly isLoading = computed(
    () =>
      this.state().loadingObtener ||
      this.state().loadingGuardar ||
      this.state().loadingEliminar ||
      this.state().loadingActualizar,
  );

  readonly hasError = computed(
    () =>
      !!this.state().errorObtener ||
      !!this.state().errorGuardar ||
      !!this.state().errorEliminar ||
      !!this.state().errorActualizar,
  );

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingGuardar = computed(() => this.state().loadingGuardar);
  readonly loadingEliminar = computed(() => this.state().loadingEliminar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);

  readonly errorObtener = computed(() => this.state().errorObtener);
  readonly errorGuardar = computed(() => this.state().errorGuardar);
  readonly errorEliminar = computed(() => this.state().errorEliminar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);

  readonly resultGuardar = computed(() => this.state().resultGuardar);
  readonly resultEliminar = computed(() => this.state().resultEliminar);
  readonly resultActualizar = computed(() => this.state().resultActualizar);

  setTiposDocumento(tiposDocumento: any[]): void {
    this.state.update((state) => ({
      ...state,
      tiposDocumento,
      errorObtener: null,
    }));
  }

  setTipoDocumentoSeleccionado(tipoDocumento: any | null): void {
    this.state.update((s) => ({
      ...s,
      tipoDocumentoSeleccionado: tipoDocumento,
    }));
  }

  setLoadingObtener(loading: boolean): void {
    this.state.update((s) => ({ ...s, loadingObtener: loading }));
  }

  setLoadingGuardar(loading: boolean): void {
    this.state.update((s) => ({ ...s, loadingGuardar: loading }));
  }

  setLoadingEliminar(loading: boolean): void {
    this.state.update((s) => ({ ...s, loadingEliminar: loading }));
  }

  setLoadingActualizar(loading: boolean): void {
    this.state.update((s) => ({ ...s, loadingActualizar: loading }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update((s) => ({
      ...s,
      errorObtener: error,
      loadingObtener: false,
    }));
  }

  setErrorGuardar(error: string | null): void {
    this.state.update((s) => ({
      ...s,
      errorGuardar: error,
      loadingGuardar: false,
    }));
  }

  setErrorEliminar(error: string | null): void {
    this.state.update((s) => ({
      ...s,
      errorEliminar: error,
      loadingEliminar: false,
    }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update((s) => ({
      ...s,
      errorActualizar: error,
      loadingActualizar: false,
    }));
  }

  setResultGuardar(result: any | null): void {
    this.state.update((s) => ({
      ...s,
      resultGuardar: result,
      errorGuardar: null,
    }));

    if (result) {
      this.state.update((s) => ({
        ...s,
        tiposDocumento: [...s.tiposDocumento, result],
      }));
    }
  }

  setResultEliminar(result: any | null): void {
    this.state.update((s) => ({
      ...s,
      resultEliminar: result,
      errorEliminar: null,
    }));
  }

  setResultActualizar(result: any | null): void {
    this.state.update((s) => ({
      ...s,
      resultActualizar: result,
      errorActualizar: null,
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
