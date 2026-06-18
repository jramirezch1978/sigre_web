import { Injectable, computed, signal } from '@angular/core';
import { SeleccionarCuentaContableState, initialSeleccionarCuentaContableState } from './seleccionar-cuenta-contable.state';
import { SeleccionarCuentaContableEntity } from '../domain/models/seleccionar-cuenta-contable.entity';

/**
 * SeleccionarCuentaContableStore — Store reactivo de señales.
 * Gestiona el catálogo de cuentas contables para el buscador de asientos manuales.
 */
@Injectable()
export class SeleccionarCuentaContableStore {

  private readonly state = signal<SeleccionarCuentaContableState>(initialSeleccionarCuentaContableState);

  // ── Selectores de datos ──────────────────────────────────────────────────

  readonly data  = computed(() => this.state().data);
  readonly items = computed(() => this.state().data.items);

  // ── Selectores de loading / error ────────────────────────────────────────

  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly isLoading      = computed(() => this.state().loadingObtener);
  readonly errorObtener   = computed(() => this.state().errorObtener);
  readonly hasError       = computed(() => !!this.state().errorObtener);

  // ── Mutaciones ───────────────────────────────────────────────────────────

  setLoadingObtener(value: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }

  setData(data: SeleccionarCuentaContableEntity): void {
    this.state.update(s => ({ ...s, data, errorObtener: null, loadingObtener: false }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  resetState(): void {
    this.state.set(initialSeleccionarCuentaContableState);
  }
}
