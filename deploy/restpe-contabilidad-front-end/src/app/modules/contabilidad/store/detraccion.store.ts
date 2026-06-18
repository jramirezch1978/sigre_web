import { Injectable, computed, signal } from '@angular/core';
import { DetraccionState, initialDetraccionState } from './detraccion.state';
import { DetraccionEntity } from '../domain/models/detraccion.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class DetraccionStore {

  private readonly state = signal<DetraccionState>(initialDetraccionState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly detracciones = computed(() => this.state().detracciones);
  readonly detraccionSeleccionada = computed(() => this.state().detraccionSeleccionada);

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

  setDetracciones(detracciones: DetraccionEntity[]): void {
    this.state.update(s => ({ ...s, detracciones, errorObtener: null }));
  }

  setDetraccionSeleccionada(detraccion: DetraccionEntity | null): void {
    this.state.update(s => ({ ...s, detraccionSeleccionada: detraccion }));
  }

  // ── Mutaciones de resultados ─────────────────────────────────────────────

  setGuardarResultado(result: ApiResponse<DetraccionEntity> | null): void {
    this.state.update(s => ({ ...s, resultGuardar: result, errorGuardar: null }));

    if (result?.success && result.data) {
      this.state.update(s => {
        const existe = s.detracciones.find(d => d.detraccion_codigo === result.data!.detraccion_codigo);
        return {
          ...s,
          detracciones: existe
            ? s.detracciones.map(d => d.detraccion_codigo === result.data!.detraccion_codigo ? result.data! : d)
            : [...s.detracciones, result.data!]
        };
      });
    }
  }

  setActualizarResultado(result: ApiResponse<DetraccionEntity> | null): void {
    this.state.update(s => ({ ...s, resultActualizar: result, errorActualizar: null }));

    if (result?.success && result.data) {
      this.state.update(s => ({
        ...s,
        detracciones: s.detracciones.map(d =>
          d.detraccion_codigo === result.data!.detraccion_codigo ? result.data! : d
        ),
        detraccionSeleccionada: s.detraccionSeleccionada?.detraccion_codigo === result.data!.detraccion_codigo
          ? result.data!
          : s.detraccionSeleccionada
      }));
    }
  }

  setEliminarResultado(result: ApiResponse<boolean> | null, codigo?: string): void {
    this.state.update(s => ({ ...s, resultEliminar: result, errorEliminar: null }));

    if (result?.success && codigo) {
      this.state.update(s => ({
        ...s,
        detracciones: s.detracciones.filter(d => d.detraccion_codigo !== codigo),
        detraccionSeleccionada: s.detraccionSeleccionada?.detraccion_codigo === codigo
          ? null
          : s.detraccionSeleccionada
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
    this.state.set(initialDetraccionState);
  }
}
