import { Injectable, signal, computed } from '@angular/core';
import { AseguradoraState, initialAseguradoraState } from './aseguradora.state';
import { AseguradoraEntity } from '../domain/models/aseguradora.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

/**
 * Store reactivo de Aseguradoras usando Angular Signals.
 * Centraliza el estado de la lista y operaciones CRUD.
 */
@Injectable()
export class AseguradoraStore {

  private readonly state = signal<AseguradoraState>(initialAseguradoraState);

  // ─────────── Selectores de datos ───────────
  readonly aseguradoras           = computed(() => this.state().aseguradoras);
  readonly aseguradoraSeleccionada = computed(() => this.state().aseguradoraSeleccionada);

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

  setAseguradoras(aseguradoras: AseguradoraEntity[]): void {
    this.state.update(s => ({ ...s, aseguradoras }));
  }

  setAseguradoraSeleccionada(aseguradora: AseguradoraEntity | null): void {
    this.state.update(s => ({ ...s, aseguradoraSeleccionada: aseguradora }));
  }

  // ─────────── Mutaciones — loading ───────────

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

  setResultGuardar(result: ApiResponse<AseguradoraEntity> | null): void {
    this.state.update(s => ({ ...s, resultGuardar: result }));
  }

  setResultEliminar(result: ApiResponse<boolean> | null): void {
    this.state.update(s => ({ ...s, resultEliminar: result }));
  }

  setResultActualizar(result: ApiResponse<AseguradoraEntity> | null): void {
    this.state.update(s => ({ ...s, resultActualizar: result }));
  }
}
