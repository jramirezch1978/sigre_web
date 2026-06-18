import { Injectable, computed, signal } from '@angular/core';
import { CuentaVsSubcategoriaState, initialCuentaVsSubcategoriaState } from './cuenta-vs-subcategoria.state';
import { CuentaVsSubcategoriaEntity } from '../domain/models/cuenta-vs-subcategoria.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class CuentaVsSubcategoriaStore {

  private readonly state = signal<CuentaVsSubcategoriaState>(initialCuentaVsSubcategoriaState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly items = computed(() => this.state().items);
  readonly itemSeleccionado = computed(() => this.state().itemSeleccionado);

  // ── Selectores de loading ────────────────────────────────────────────────

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);

  readonly isLoading = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingActualizar
  );

  // ── Selectores de errores ────────────────────────────────────────────────

  readonly errorObtener = computed(() => this.state().errorObtener);
  readonly errorActualizar = computed(() => this.state().errorActualizar);

  readonly hasError = computed(() =>
    !!this.state().errorObtener ||
    !!this.state().errorActualizar
  );

  // ── Selectores de resultados ─────────────────────────────────────────────

  readonly resultActualizar = computed(() => this.state().resultActualizar);

  // ── Mutaciones de loading ────────────────────────────────────────────────

  setLoadingObtener(value: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }

  setLoadingActualizar(value: boolean): void {
    this.state.update(s => ({ ...s, loadingActualizar: value }));
  }

  // ── Mutaciones de datos ──────────────────────────────────────────────────

  setItems(items: CuentaVsSubcategoriaEntity[]): void {
    this.state.update(s => ({ ...s, items, errorObtener: null }));
  }

  setItemSeleccionado(item: CuentaVsSubcategoriaEntity | null): void {
    this.state.update(s => ({ ...s, itemSeleccionado: item }));
  }

  // ── Mutaciones de errores ────────────────────────────────────────────────

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update(s => ({ ...s, errorActualizar: error, loadingActualizar: false }));
  }

  // ── Mutaciones de resultados ─────────────────────────────────────────────

  setActualizarResultado(result: ApiResponse<CuentaVsSubcategoriaEntity> | null): void {
    this.state.update(s => ({ ...s, resultActualizar: result, errorActualizar: null }));

    if (result?.success && result.data) {
      this.state.update(s => ({
        ...s,
        items: s.items.map(i => i.cuenta_sub_codigo === result.data!.cuenta_sub_codigo ? result.data! : i)
      }));
    }
  }
}
