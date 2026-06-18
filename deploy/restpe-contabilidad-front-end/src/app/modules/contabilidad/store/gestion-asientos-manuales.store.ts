import { Injectable, computed, signal } from '@angular/core';
import { GestionAsientosManualesState, initialGestionAsientosManualesState } from './gestion-asientos-manuales.state';
import { AsientoManualItem } from '../domain/models/gestion-asientos-manual.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

/**
 * GestionAsientosManualesStore — Store reactivo de señales.
 * Gestiona el estado completo de asientos manuales (CRUD).
 */
@Injectable()
export class GestionAsientosManualesStore {

  private readonly state = signal<GestionAsientosManualesState>(initialGestionAsientosManualesState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly asientos            = computed(() => this.state().asientos);
  /** @deprecated Usar `asientos` — mantenido por retrocompatibilidad */
  readonly items               = computed(() => this.state().asientos);
  readonly asientoSeleccionado = computed(() => this.state().asientoSeleccionado);

  // ── Selectores de loading ────────────────────────────────────────────────

  readonly loadingObtener    = computed(() => this.state().loadingObtener);
  readonly loadingGuardar    = computed(() => this.state().loadingGuardar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);
  readonly loadingAnular     = computed(() => this.state().loadingAnular);

  readonly isLoading = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingGuardar ||
    this.state().loadingActualizar ||
    this.state().loadingAnular
  );

  // ── Selectores de errores ────────────────────────────────────────────────

  readonly errorObtener    = computed(() => this.state().errorObtener);
  readonly errorGuardar    = computed(() => this.state().errorGuardar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);
  readonly errorAnular     = computed(() => this.state().errorAnular);

  readonly hasError = computed(() =>
    !!this.state().errorObtener   ||
    !!this.state().errorGuardar   ||
    !!this.state().errorActualizar ||
    !!this.state().errorAnular
  );

  // ── Selectores de resultados ─────────────────────────────────────────────

  readonly resultGuardar    = computed(() => this.state().resultGuardar);
  readonly resultActualizar = computed(() => this.state().resultActualizar);
  readonly resultAnular     = computed(() => this.state().resultAnular);

  // ── Mutaciones de loading ────────────────────────────────────────────────

  setLoadingObtener(value: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }

  setLoadingGuardar(value: boolean): void {
    this.state.update(s => ({ ...s, loadingGuardar: value }));
  }

  setLoadingActualizar(value: boolean): void {
    this.state.update(s => ({ ...s, loadingActualizar: value }));
  }

  setLoadingAnular(value: boolean): void {
    this.state.update(s => ({ ...s, loadingAnular: value }));
  }

  // ── Mutaciones de datos ──────────────────────────────────────────────────

  setAsientos(asientos: AsientoManualItem[]): void {
    this.state.update(s => ({ ...s, asientos, errorObtener: null, loadingObtener: false }));
  }

  setAsientoSeleccionado(asiento: AsientoManualItem | null): void {
    this.state.update(s => ({ ...s, asientoSeleccionado: asiento }));
  }

  // ── Mutaciones de resultados ─────────────────────────────────────────────

  setGuardarResultado(result: ApiResponse<AsientoManualItem> | null): void {
    this.state.update(s => ({ ...s, resultGuardar: result, errorGuardar: null, loadingGuardar: false }));
  }

  setActualizarResultado(result: ApiResponse<AsientoManualItem> | null): void {
    this.state.update(s => ({ ...s, resultActualizar: result, errorActualizar: null, loadingActualizar: false }));
  }

  setAnularResultado(result: ApiResponse<boolean> | null): void {
    this.state.update(s => ({ ...s, resultAnular: result, errorAnular: null, loadingAnular: false }));
  }

  // ── Mutaciones de errores ────────────────────────────────────────────────

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  setErrorGuardar(error: string | null): void {
    this.state.update(s => ({ ...s, errorGuardar: error, loadingGuardar: false }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update(s => ({ ...s, errorActualizar: error, loadingActualizar: false }));
  }

  setErrorAnular(error: string | null): void {
    this.state.update(s => ({ ...s, errorAnular: error, loadingAnular: false }));
  }

  clearErrors(): void {
    this.state.update(s => ({
      ...s,
      errorObtener: null,
      errorGuardar: null,
      errorActualizar: null,
      errorAnular: null,
    }));
  }

  resetState(): void {
    this.state.set(initialGestionAsientosManualesState);
  }
}

