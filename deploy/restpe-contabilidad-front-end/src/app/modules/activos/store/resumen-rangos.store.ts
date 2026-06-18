import { Injectable, computed, signal } from '@angular/core';
import { ResumenRangosState, initialResumenRangosState } from './resumen-rangos.state';
import { ResumenRangosEntity } from '../domain/models/resumen-rangos.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class ResumenRangosStore {
  private readonly _state = signal<ResumenRangosState>(initialResumenRangosState);

  // ── Selectores ──────────────────────────────────────────────────────────────
  readonly rangos             = computed(() => this._state().rangos);
  readonly rangoSeleccionado  = computed(() => this._state().rangoSeleccionado);

  readonly loadingObtener    = computed(() => this._state().loadingObtener);
  readonly loadingGuardar    = computed(() => this._state().loadingGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly loadingEliminar   = computed(() => this._state().loadingEliminar);

  readonly isLoading = computed(() =>
    this._state().loadingObtener    ||
    this._state().loadingGuardar    ||
    this._state().loadingActualizar ||
    this._state().loadingEliminar
  );

  readonly errorObtener    = computed(() => this._state().errorObtener);
  readonly errorGuardar    = computed(() => this._state().errorGuardar);
  readonly errorActualizar = computed(() => this._state().errorActualizar);
  readonly errorEliminar   = computed(() => this._state().errorEliminar);

  readonly resultGuardar    = computed(() => this._state().resultGuardar);
  readonly resultActualizar = computed(() => this._state().resultActualizar);
  readonly resultEliminar   = computed(() => this._state().resultEliminar);

  // ── Setters ─────────────────────────────────────────────────────────────────
  setRangos(items: ResumenRangosEntity[])                   { this._state.update(s => ({ ...s, rangos: items })); }
  setRangoSeleccionado(item: ResumenRangosEntity | null)    { this._state.update(s => ({ ...s, rangoSeleccionado: item })); }

  setLoadingObtener(v: boolean)    { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setLoadingGuardar(v: boolean)    { this._state.update(s => ({ ...s, loadingGuardar: v })); }
  setLoadingActualizar(v: boolean) { this._state.update(s => ({ ...s, loadingActualizar: v })); }
  setLoadingEliminar(v: boolean)   { this._state.update(s => ({ ...s, loadingEliminar: v })); }

  setErrorObtener(e: string | null)    { this._state.update(s => ({ ...s, errorObtener: e })); }
  setErrorGuardar(e: string | null)    { this._state.update(s => ({ ...s, errorGuardar: e })); }
  setErrorActualizar(e: string | null) { this._state.update(s => ({ ...s, errorActualizar: e })); }
  setErrorEliminar(e: string | null)   { this._state.update(s => ({ ...s, errorEliminar: e })); }

  setResultGuardar(r: ApiResponse | null)    { this._state.update(s => ({ ...s, resultGuardar: r })); }
  setResultActualizar(r: ApiResponse | null) { this._state.update(s => ({ ...s, resultActualizar: r })); }
  setResultEliminar(r: ApiResponse | null)   { this._state.update(s => ({ ...s, resultEliminar: r })); }

  reset() { this._state.set(initialResumenRangosState); }
}
