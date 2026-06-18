import { Injectable, signal, computed } from '@angular/core';
import { ClasifActivoState, initialClasifActivoState } from './clasif-activo.state';
import { ClasifActivoEntity } from '../domain/models/clasif-activo.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

/**
 * Store reactivo de Clasificación de Activos usando Angular Signals.
 * Centraliza el estado de la lista y operaciones CRUD.
 */
@Injectable()
export class ClasifActivoStore {

  private readonly state = signal<ClasifActivoState>(initialClasifActivoState);

  // ─────────── Selectores de datos ───────────
  readonly clasifsActivo      = computed(() => this.state().clasifsActivo);
  readonly clasifSeleccionada = computed(() => this.state().clasifSeleccionada);

  // ─────────── Selectores de loading ───────────
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

  // ─────────── Selectores de errores ───────────
  readonly errorObtener    = computed(() => this.state().errorObtener);
  readonly errorGuardar    = computed(() => this.state().errorGuardar);
  readonly errorEliminar   = computed(() => this.state().errorEliminar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);

  // ─────────── Selectores de resultados (para effects) ───────────
  readonly resultGuardar    = computed(() => this.state().resultGuardar);
  readonly resultEliminar   = computed(() => this.state().resultEliminar);
  readonly resultActualizar = computed(() => this.state().resultActualizar);

  // ─────────── Mutaciones — datos ───────────

  setClasifsActivo(clasifsActivo: ClasifActivoEntity[]): void {
    this.state.update(s => ({ ...s, clasifsActivo }));
  }

  setClasifSeleccionada(clasif: ClasifActivoEntity | null): void {
    this.state.update(s => ({ ...s, clasifSeleccionada: clasif }));
  }

  // ─────────── Mutaciones — loading ───────────

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

  // ─────────── Mutaciones — errores ───────────

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

  // ─────────── Mutaciones — resultados ───────────

  setResultGuardar(result: ApiResponse | null): void {
    this.state.update(s => ({ ...s, resultGuardar: result }));
  }

  setResultEliminar(result: ApiResponse | null): void {
    this.state.update(s => ({ ...s, resultEliminar: result }));
  }

  setResultActualizar(result: ApiResponse | null): void {
    this.state.update(s => ({ ...s, resultActualizar: result }));
  }
}
