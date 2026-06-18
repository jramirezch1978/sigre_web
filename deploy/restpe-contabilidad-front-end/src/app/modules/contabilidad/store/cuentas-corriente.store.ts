import { Injectable, computed, signal } from '@angular/core';
import { CuentasCorrienteState, initialCuentasCorrienteState } from './cuentas-corriente.state';
import { CuentasCorrienteEntity } from '../domain/models/cuentas-corriente.entity';

/**
 * CuentasCorrienteStore — Store reactivo de señales.
 * Gestiona el estado del análisis de cuentas corriente.
 */
@Injectable()
export class CuentasCorrienteStore {

  private readonly state = signal<CuentasCorrienteState>(initialCuentasCorrienteState);

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

  setData(data: CuentasCorrienteEntity): void {
    this.state.update(s => ({ ...s, data, errorObtener: null, loadingObtener: false }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  resetState(): void {
    this.state.set(initialCuentasCorrienteState);
  }
}
