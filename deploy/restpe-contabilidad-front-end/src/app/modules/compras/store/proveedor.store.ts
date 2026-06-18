import { Injectable, signal, computed } from '@angular/core';
import { ProveedorState, initialProveedorState } from './proveedor.state';
import { ProveedorEntity } from '../domain/models/proveedor.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class ProveedorStore {

  private readonly state = signal<ProveedorState>(initialProveedorState);

  readonly proveedores = computed(() => this.state().proveedores);
  readonly proveedorSeleccionado = computed(() => this.state().proveedorSeleccionado);

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

  readonly isLoading = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingGuardar ||
    this.state().loadingEliminar ||
    this.state().loadingActualizar
  );

  readonly hasError = computed(() =>
    !!this.state().errorObtener ||
    !!this.state().errorGuardar ||
    !!this.state().errorEliminar ||
    !!this.state().errorActualizar
  );

  setProveedores(proveedores: ProveedorEntity[]): void {
    this.state.update(s => ({ ...s, proveedores, errorObtener: null }));
  }

  setProveedorSeleccionado(proveedor: ProveedorEntity | null): void {
    this.state.update(s => ({ ...s, proveedorSeleccionado: proveedor }));
  }

  setLoadingObtener(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: loading }));
  }

  setLoadingGuardar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingGuardar: loading }));
  }

  setLoadingEliminar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingEliminar: loading }));
  }

  setLoadingActualizar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingActualizar: loading }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  setErrorGuardar(error: string | null): void {
    this.state.update(s => ({ ...s, errorGuardar: error, loadingGuardar: false }));
  }

  setErrorEliminar(error: string | null): void {
    this.state.update(s => ({ ...s, errorEliminar: error, loadingEliminar: false }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update(s => ({ ...s, errorActualizar: error, loadingActualizar: false }));
  }

  setGuardarResultado(result: ApiResponse<ProveedorEntity>): void {
    this.state.update(s => ({ ...s, resultGuardar: result, errorGuardar: null }));

    if (result?.success && result.data) {
      this.state.update(s => ({
        ...s,
        proveedores: [...s.proveedores, result.data!]
      }));
    }
  }

  setEliminarResultado(result: ApiResponse<boolean>): void {
    this.state.update(s => ({ ...s, resultEliminar: result, errorEliminar: null }));
  }

  setActualizarResultado(result: ApiResponse<ProveedorEntity>): void {
    this.state.update(s => ({ ...s, resultActualizar: result, errorActualizar: null }));

    if (result?.success && result.data) {
      this.state.update(s => ({
        ...s,
        proveedores: s.proveedores.map(p =>
          p.proveedor_codigo === result.data!.proveedor_codigo ? result.data! : p
        )
      }));
    }
  }

  resetErrors(): void {
    this.state.update(s => ({
      ...s,
      errorObtener: null,
      errorGuardar: null,
      errorEliminar: null,
      errorActualizar: null
    }));
  }

  resetResults(): void {
    this.state.update(s => ({
      ...s,
      resultGuardar: null,
      resultEliminar: null,
      resultActualizar: null
    }));
  }

  reset(): void {
    this.state.set(initialProveedorState);
  }
}
