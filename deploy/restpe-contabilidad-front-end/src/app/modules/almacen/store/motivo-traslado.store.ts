import { computed, Injectable, signal } from '@angular/core';
import {
  initialMotivoTrasladoState,
  MotivoTrasladoState,
} from './motivo-traslado.state';
import { MotivoTrasladoAlmacenEntity } from '../domain/models/motivo-traslado-almacen.entity';
import { BackendApiResponse } from '../application/dto/almacen-backend.types';

@Injectable()
export class MotivoTrasladoStore {
  private readonly state = signal<MotivoTrasladoState>(
    initialMotivoTrasladoState,
  );

  readonly motivos = computed(() => this.state().motivos);
  readonly motivoSeleccionado = computed(() => this.state().motivoSeleccionado);

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

  // ... el resto igual que ProveedorStore, cambiando el tipo
  setMotivos(motivos: MotivoTrasladoAlmacenEntity[]): void {
    this.state.update((s) => ({ ...s, motivos, errorObtener: null }));
  }

  setMotivoSeleccionado(motivo: MotivoTrasladoAlmacenEntity | null): void {
    this.state.update((s) => ({ ...s, motivoSeleccionado: motivo }));
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

  setResultGuardar(
    result: MotivoTrasladoAlmacenEntity | null,
  ): void {
    this.state.update((s) => ({
      ...s,
      resultGuardar: result,
      errorGuardar: null,
    }));

    if (result) {
      this.state.update((s) => ({
        ...s,
        motivos: [...s.motivos, result],
      }));
    }
  }

  setResultEliminar(result: BackendApiResponse<boolean> | null): void {
    this.state.update((s) => ({
      ...s,
      resultEliminar: result,
      errorEliminar: null,
    }));
  }

  setResultActualizar(
    result: BackendApiResponse<MotivoTrasladoAlmacenEntity> | null,
  ): void {
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
