import { Injectable, computed, signal } from '@angular/core';
import { CentroCostoState, initialCentroCostoState } from './centro-costo.state';
import { CentroCostoEntity } from '../domain/models/centro-costo.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class CentroCostoStore {

  private readonly state = signal<CentroCostoState>(initialCentroCostoState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly centrosCosto = computed(() => this.state().centrosCosto);
  readonly centroCostoSeleccionado = computed(() => this.state().centroCostoSeleccionado);

  // ── Selectores de loading ────────────────────────────────────────────────

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingGuardar = computed(() => this.state().loadingGuardar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);
  readonly loadingEliminar = computed(() => this.state().loadingEliminar);

  readonly isLoading = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingGuardar ||
    this.state().loadingActualizar ||
    this.state().loadingEliminar
  );

  // ── Selectores de errores ────────────────────────────────────────────────

  readonly errorObtener = computed(() => this.state().errorObtener);
  readonly errorGuardar = computed(() => this.state().errorGuardar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);
  readonly errorEliminar = computed(() => this.state().errorEliminar);

  readonly hasError = computed(() =>
    !!this.state().errorObtener ||
    !!this.state().errorGuardar ||
    !!this.state().errorActualizar ||
    !!this.state().errorEliminar
  );

  // ── Selectores de resultados ─────────────────────────────────────────────

  readonly resultGuardar = computed(() => this.state().resultGuardar);
  readonly resultActualizar = computed(() => this.state().resultActualizar);
  readonly resultEliminar = computed(() => this.state().resultEliminar);

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

  setLoadingEliminar(value: boolean): void {
    this.state.update(s => ({ ...s, loadingEliminar: value }));
  }

  // ── Mutaciones de datos ──────────────────────────────────────────────────

  setCentrosCosto(centros: CentroCostoEntity[]): void {
    this.state.update(s => ({ ...s, centrosCosto: centros, errorObtener: null }));
  }

  setCentroCostoSeleccionado(centro: CentroCostoEntity | null): void {
    this.state.update(s => ({ ...s, centroCostoSeleccionado: centro }));
  }

  // ── Mutaciones de resultados ─────────────────────────────────────────────

  setGuardarResultado(result: ApiResponse<CentroCostoEntity> | null): void {
    this.state.update(s => ({ ...s, resultGuardar: result, errorGuardar: null }));

    if (result?.success && result.data) {
      this.state.update(s => {
        const existe = s.centrosCosto.find(c => c.centro_costo_codigo === result.data!.centro_costo_codigo);
        return {
          ...s,
          centrosCosto: existe
            ? s.centrosCosto.map(c => c.centro_costo_codigo === result.data!.centro_costo_codigo ? result.data! : c)
            : [...s.centrosCosto, result.data!]
        };
      });
    }
  }

  setActualizarResultado(result: ApiResponse<CentroCostoEntity> | null): void {
    this.state.update(s => ({ ...s, resultActualizar: result, errorActualizar: null }));

    if (result?.success && result.data) {
      this.state.update(s => ({
        ...s,
        centrosCosto: s.centrosCosto.map(c =>
          c.centro_costo_codigo === result.data!.centro_costo_codigo ? result.data! : c
        ),
        centroCostoSeleccionado: s.centroCostoSeleccionado?.centro_costo_codigo === result.data!.centro_costo_codigo
          ? result.data!
          : s.centroCostoSeleccionado
      }));
    }
  }

  setEliminarResultado(result: ApiResponse<boolean> | null, codigo?: string): void {
    this.state.update(s => ({ ...s, resultEliminar: result, errorEliminar: null }));

    if (result?.success && codigo) {
      this.state.update(s => ({
        ...s,
        centrosCosto: s.centrosCosto.filter(c => c.centro_costo_codigo !== codigo),
        centroCostoSeleccionado: s.centroCostoSeleccionado?.centro_costo_codigo === codigo
          ? null
          : s.centroCostoSeleccionado
      }));
    }
  }

  // ── Mutaciones de error ──────────────────────────────────────────────────

  setErrorObtener(message: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: message, loadingObtener: false }));
  }

  setErrorGuardar(message: string | null): void {
    this.state.update(s => ({ ...s, errorGuardar: message, loadingGuardar: false }));
  }

  setErrorActualizar(message: string | null): void {
    this.state.update(s => ({ ...s, errorActualizar: message, loadingActualizar: false }));
  }

  setErrorEliminar(message: string | null): void {
    this.state.update(s => ({ ...s, errorEliminar: message, loadingEliminar: false }));
  }

  clearErrors(): void {
    this.state.update(s => ({
      ...s,
      errorObtener: null,
      errorGuardar: null,
      errorActualizar: null,
      errorEliminar: null
    }));
  }

  reset(): void {
    this.state.set(initialCentroCostoState);
  }
}
