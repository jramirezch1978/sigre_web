import { Injectable, computed, signal } from '@angular/core';
import { RegistroUitState, initialRegistroUitState } from './registro-uit.state';
import { RegistroUitEntity } from '../domain/models/registro-uit.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

@Injectable()
export class RegistroUitStore {

  private readonly state = signal<RegistroUitState>(initialRegistroUitState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly items = computed(() => this.state().items);

  // ── Selectores de loading ────────────────────────────────────────────────

  readonly loadingObtener    = computed(() => this.state().loadingObtener);
  readonly loadingGuardar    = computed(() => this.state().loadingGuardar);
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

  setItems(items: RegistroUitEntity[]): void {
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

  setGuardarResultado(result: ApiResponse<RegistroUitEntity> | null): void {
    this.state.update(s => {
      const items = result?.data
        ? [result.data, ...s.items]
        : s.items;
      return { ...s, resultGuardar: result, items, loadingGuardar: false };
    });
  }

  setActualizarResultado(result: ApiResponse<RegistroUitEntity> | null): void {
    this.state.update(s => {
      const items = result?.data
        ? s.items.map(i => i.registro_uit_anio_fiscal === result.data!.registro_uit_anio_fiscal ? result.data! : i)
        : s.items;
      return { ...s, resultActualizar: result, items, loadingActualizar: false };
    });
  }

  // ── Reset ────────────────────────────────────────────────────────────────

  resetState(): void {
    this.state.set(initialRegistroUitState);
  }
}
