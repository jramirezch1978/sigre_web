import { Injectable, computed, signal } from '@angular/core';
import { IncidenciaState, initialIncidenciaState } from './incidencia.state';
import { IncidenciaEntity } from '../domain/models/incidencia.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

/**
 * Store reactivo para Incidencias usando Angular Signals.
 * Fuente única de verdad para el estado de incidencias.
 */
@Injectable()
export class IncidenciaStore {
  private readonly _state = signal<IncidenciaState>(initialIncidenciaState);

  // ── Selectores ──────────────────────────────────────────────────────────────
  readonly incidencias      = computed(() => this._state().incidencias);
  readonly incidenciaSeleccionada = computed(() => this._state().incidenciaSeleccionada);

  readonly loadingObtener   = computed(() => this._state().loadingObtener);
  readonly loadingGuardar   = computed(() => this._state().loadingGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly loadingEliminar  = computed(() => this._state().loadingEliminar);

  readonly errorObtener     = computed(() => this._state().errorObtener);
  readonly errorGuardar     = computed(() => this._state().errorGuardar);
  readonly errorActualizar  = computed(() => this._state().errorActualizar);
  readonly errorEliminar    = computed(() => this._state().errorEliminar);

  readonly resultGuardar    = computed(() => this._state().resultGuardar);
  readonly resultActualizar = computed(() => this._state().resultActualizar);
  readonly resultEliminar   = computed(() => this._state().resultEliminar);

  /** true si alguna operación está en vuelo */
  readonly isLoading = computed(
    () =>
      this._state().loadingObtener   ||
      this._state().loadingGuardar   ||
      this._state().loadingActualizar ||
      this._state().loadingEliminar
  );

  // ── Mutaciones ──────────────────────────────────────────────────────────────
  private patch(partial: Partial<IncidenciaState>): void {
    this._state.update(s => ({ ...s, ...partial }));
  }

  setIncidencias(incidencias: IncidenciaEntity[])       { this.patch({ incidencias }); }
  setIncidenciaSeleccionada(i: IncidenciaEntity | null) { this.patch({ incidenciaSeleccionada: i }); }

  setLoadingObtener(v: boolean)    { this.patch({ loadingObtener: v }); }
  setLoadingGuardar(v: boolean)    { this.patch({ loadingGuardar: v }); }
  setLoadingActualizar(v: boolean) { this.patch({ loadingActualizar: v }); }
  setLoadingEliminar(v: boolean)   { this.patch({ loadingEliminar: v }); }

  setErrorObtener(e: string | null)     { this.patch({ errorObtener: e }); }
  setErrorGuardar(e: string | null)     { this.patch({ errorGuardar: e }); }
  setErrorActualizar(e: string | null)  { this.patch({ errorActualizar: e }); }
  setErrorEliminar(e: string | null)    { this.patch({ errorEliminar: e }); }

  setResultGuardar(r: ApiResponse | null)    { this.patch({ resultGuardar: r }); }
  setResultActualizar(r: ApiResponse | null) { this.patch({ resultActualizar: r }); }
  setResultEliminar(r: ApiResponse | null)   { this.patch({ resultEliminar: r }); }

  reset(): void { this._state.set(initialIncidenciaState); }
}
