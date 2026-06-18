import { Injectable, computed, signal } from '@angular/core';
import { TipoDeCambioState, initialTipoDeCambioState } from './tipo-de-cambio.state';
import { TipoDeCambioEntity } from '../domain/models/tipo-de-cambio.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class TipoDeCambioStore {

  private readonly state = signal<TipoDeCambioState>(initialTipoDeCambioState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly items = computed(() => this.state().items);

  // ── Selectores de loading ────────────────────────────────────────────────

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingGuardar  = computed(() => this.state().loadingGuardar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);
  readonly loadingEliminar = computed(() => this.state().loadingEliminar);

  readonly isLoading = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingGuardar ||
    this.state().loadingActualizar ||
    this.state().loadingEliminar
  );

  // ── Selectores de errores ────────────────────────────────────────────────

  readonly errorObtener    = computed(() => this.state().errorObtener);
  readonly errorGuardar    = computed(() => this.state().errorGuardar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);
  readonly errorEliminar   = computed(() => this.state().errorEliminar);

  readonly hasError = computed(() =>
    !!this.state().errorObtener ||
    !!this.state().errorGuardar ||
    !!this.state().errorActualizar ||
    !!this.state().errorEliminar
  );

  // ── Selectores de resultados ─────────────────────────────────────────────

  readonly resultGuardar    = computed(() => this.state().resultGuardar);
  readonly resultActualizar = computed(() => this.state().resultActualizar);
  readonly resultEliminar   = computed(() => this.state().resultEliminar);

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

  setItems(items: TipoDeCambioEntity[]): void {
    this.state.update(s => ({ ...s, items, errorObtener: null }));
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

  setErrorEliminar(error: string | null): void {
    this.state.update(s => ({ ...s, errorEliminar: error, loadingEliminar: false }));
  }

  // ── Mutaciones de resultados ─────────────────────────────────────────────

  setGuardarResultado(result: ApiResponse<TipoDeCambioEntity> | null): void {
    this.state.update(s => ({ ...s, resultGuardar: result, errorGuardar: null }));

    if (result?.success && result.data) {
      this.state.update(s => ({
        ...s,
        items: [...s.items, result.data!]
      }));
    }
  }

  setActualizarResultado(result: ApiResponse<TipoDeCambioEntity> | null): void {
    this.state.update(s => ({ ...s, resultActualizar: result, errorActualizar: null }));

    if (result?.success && result.data) {
      const updated = result.data;
      this.state.update(s => ({
        ...s,
        items: s.items.map(i => {
          // Preferir el id (estable); fallback a fecha+moneda si no hubiera id.
          const match = (updated.id != null && i.id != null)
            ? i.id === updated.id
            : (i.tipo_cambio_fecha_registro === updated.tipo_cambio_fecha_registro
               && i.tipo_cambio_moneda === updated.tipo_cambio_moneda);
          return match ? updated : i;
        })
      }));
    }
  }

  setEliminarResultado(result: ApiResponse<boolean> | null, id?: number): void {
    this.state.update(s => ({ ...s, resultEliminar: result, errorEliminar: null }));

    if (result?.success && id != null) {
      this.state.update(s => ({
        ...s,
        items: s.items.filter(i => i.id !== id)
      }));
    }
  }
}
