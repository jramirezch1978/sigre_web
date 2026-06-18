import { Injectable, computed, signal } from '@angular/core';
import { TablaImpuestoState, initialTablaImpuestoState } from './tabla-impuesto.state';
import { TablaImpuestoEntity } from '../domain/models/tabla-impuesto.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class TablaImpuestoStore {

  private readonly state = signal<TablaImpuestoState>(initialTablaImpuestoState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly items = computed(() => this.state().items);

  // ── Selectores de loading ────────────────────────────────────────────────

  readonly loadingObtener   = computed(() => this.state().loadingObtener);
  readonly loadingGuardar   = computed(() => this.state().loadingGuardar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);

  readonly isLoading = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingGuardar ||
    this.state().loadingActualizar
  );

  // ── Selectores de errores ────────────────────────────────────────────────

  readonly errorObtener    = computed(() => this.state().errorObtener);
  readonly errorGuardar    = computed(() => this.state().errorGuardar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);

  readonly hasError = computed(() =>
    !!this.state().errorObtener ||
    !!this.state().errorGuardar ||
    !!this.state().errorActualizar
  );

  // ── Selectores de resultados ─────────────────────────────────────────────

  readonly resultGuardar    = computed(() => this.state().resultGuardar);
  readonly resultActualizar = computed(() => this.state().resultActualizar);

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

  // ── Mutaciones de datos ──────────────────────────────────────────────────

  setItems(items: TablaImpuestoEntity[]): void {
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

  // ── Mutaciones de resultados ─────────────────────────────────────────────

  setGuardarResultado(result: ApiResponse<TablaImpuestoEntity> | null): void {
    this.state.update(s => ({ ...s, resultGuardar: result, errorGuardar: null }));

    if (result?.success && result.data) {
      this.state.update(s => ({
        ...s,
        items: [result.data!, ...s.items],
      }));
    }
  }

  setActualizarResultado(result: ApiResponse<TablaImpuestoEntity> | null): void {
    this.state.update(s => ({ ...s, resultActualizar: result, errorActualizar: null }));

    if (result?.success && result.data) {
      const updated = result.data;
      this.state.update(s => ({
        ...s,
        items: s.items.map(i => i.impuesto_codigo === updated.impuesto_codigo ? updated : i),
      }));
    }
  }
}
