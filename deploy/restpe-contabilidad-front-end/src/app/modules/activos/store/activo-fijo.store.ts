import { Injectable, signal, computed } from '@angular/core';
import { ActivoFijoState, initialActivoFijoState } from './activo-fijo.state';
import { ActivoFijoEntity } from '../domain/models/activo-fijo.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

/**
 * Store reactivo de Activos Fijos usando Angular Signals.
 * Centraliza el estado de la lista y operaciones CRUD.
 */
@Injectable()
export class ActivoFijoStore {

  private readonly state = signal<ActivoFijoState>(initialActivoFijoState);

  // ────────── Selectores de datos ──────────
  readonly activosFijos        = computed(() => this.state().activosFijos);
  readonly activoSeleccionado  = computed(() => this.state().activoSeleccionado);

  // ────────── Selectores de loading ──────────
  readonly loadingObtener    = computed(() => this.state().loadingObtener);
  readonly loadingGuardar    = computed(() => this.state().loadingGuardar);
  readonly loadingEliminar   = computed(() => this.state().loadingEliminar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);
  readonly isLoading         = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingGuardar ||
    this.state().loadingEliminar ||
    this.state().loadingActualizar
  );

  // ────────── Selectores de errores ──────────
  readonly errorObtener    = computed(() => this.state().errorObtener);
  readonly errorGuardar    = computed(() => this.state().errorGuardar);
  readonly errorEliminar   = computed(() => this.state().errorEliminar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);

  // ────────── Selectores de resultados (para effects) ──────────
  readonly resultGuardar    = computed(() => this.state().resultGuardar);
  readonly resultEliminar   = computed(() => this.state().resultEliminar);
  readonly resultActualizar = computed(() => this.state().resultActualizar);

  // ────────── Mutaciones ──────────

  setActivosFijos(activosFijos: ActivoFijoEntity[]): void {
    this.state.update(s => ({ ...s, activosFijos }));
  }

  setActivoSeleccionado(activo: ActivoFijoEntity | null): void {
    this.state.update(s => ({ ...s, activoSeleccionado: activo }));
  }

  setLoadingObtener(value: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }

  setLoadingGuardar(value: boolean): void {
    this.state.update(s => ({ ...s, loadingGuardar: value }));
  }

  setLoadingEliminar(value: boolean): void {
    this.state.update(s => ({ ...s, loadingEliminar: value }));
  }

  setLoadingActualizar(value: boolean): void {
    this.state.update(s => ({ ...s, loadingActualizar: value }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error }));
  }

  setErrorGuardar(error: string | null): void {
    this.state.update(s => ({ ...s, errorGuardar: error }));
  }

  setErrorEliminar(error: string | null): void {
    this.state.update(s => ({ ...s, errorEliminar: error }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update(s => ({ ...s, errorActualizar: error }));
  }

  setResultGuardar(result: ApiResponse<ActivoFijoEntity> | null): void {
    this.state.update(s => ({ ...s, resultGuardar: result }));
  }

  setResultEliminar(result: ApiResponse<boolean> | null): void {
    this.state.update(s => ({ ...s, resultEliminar: result }));
  }

  setResultActualizar(result: ApiResponse<ActivoFijoEntity> | null): void {
    this.state.update(s => ({ ...s, resultActualizar: result }));
  }

  resetResultados(): void {
    this.state.update(s => ({
      ...s,
      resultGuardar: null,
      resultEliminar: null,
      resultActualizar: null,
    }));
  }
}
