import { Injectable, signal, computed } from '@angular/core';
import {
  AsignacionRatiosState,
  initialAsignacionRatiosState,
} from './asignacion-ratios.state';
import { AsignacionRatiosEntity } from '../domain/models/asignacion-ratios.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class AsignacionRatiosStore {

  private readonly _state = signal<AsignacionRatiosState>(
    initialAsignacionRatiosState
  );

  // ── Selectores ──────────────────────────────────────────────────────────────
  readonly asignaciones           = computed(() => this._state().asignaciones);
  readonly asignacionSeleccionada = computed(() => this._state().asignacionSeleccionada);
  readonly isLoading              = computed(() =>
    this._state().loadingObtener  ||
    this._state().loadingGuardar  ||
    this._state().loadingActualizar ||
    this._state().loadingEliminar
  );

  readonly loadingObtener    = computed(() => this._state().loadingObtener);
  readonly loadingGuardar    = computed(() => this._state().loadingGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly loadingEliminar   = computed(() => this._state().loadingEliminar);

  readonly errorObtener      = computed(() => this._state().errorObtener);
  readonly errorGuardar      = computed(() => this._state().errorGuardar);
  readonly errorActualizar   = computed(() => this._state().errorActualizar);
  readonly errorEliminar     = computed(() => this._state().errorEliminar);

  readonly resultGuardar     = computed(() => this._state().resultGuardar);
  readonly resultActualizar  = computed(() => this._state().resultActualizar);
  readonly resultEliminar    = computed(() => this._state().resultEliminar);

  // ── Mutaciones ──────────────────────────────────────────────────────────────
  setAsignaciones(asignaciones: AsignacionRatiosEntity[]): void {
    this._state.update(s => ({ ...s, asignaciones }));
  }

  setAsignacionSeleccionada(item: AsignacionRatiosEntity | null): void {
    this._state.update(s => ({ ...s, asignacionSeleccionada: item }));
  }

  setLoadingObtener(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingObtener: loading }));
  }
  setLoadingGuardar(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingGuardar: loading }));
  }
  setLoadingActualizar(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingActualizar: loading }));
  }
  setLoadingEliminar(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingEliminar: loading }));
  }

  setErrorObtener(error: string | null): void {
    this._state.update(s => ({ ...s, errorObtener: error }));
  }
  setErrorGuardar(error: string | null): void {
    this._state.update(s => ({ ...s, errorGuardar: error }));
  }
  setErrorActualizar(error: string | null): void {
    this._state.update(s => ({ ...s, errorActualizar: error }));
  }
  setErrorEliminar(error: string | null): void {
    this._state.update(s => ({ ...s, errorEliminar: error }));
  }

  setResultGuardar(result: ApiResponse | null): void {
    this._state.update(s => ({ ...s, resultGuardar: result }));
  }
  setResultActualizar(result: ApiResponse | null): void {
    this._state.update(s => ({ ...s, resultActualizar: result }));
  }
  setResultEliminar(result: ApiResponse | null): void {
    this._state.update(s => ({ ...s, resultEliminar: result }));
  }
}
