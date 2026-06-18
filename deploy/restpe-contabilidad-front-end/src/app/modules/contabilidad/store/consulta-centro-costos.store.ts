import { Injectable, computed, signal } from '@angular/core';
import { ConsultaCentroCostosState, initialConsultaCentroCostosState } from './consulta-centro-costos.state';
import { ConsultaCentroCostosEntity } from '../domain/models/consulta-centro-costos.entity';

/**
 * ConsultaCentroCostosStore — Store reactivo de señales.
 * Gestiona el estado de la consulta de centros de costo por trabajador.
 */
@Injectable()
export class ConsultaCentroCostosStore {

  private readonly state = signal<ConsultaCentroCostosState>(initialConsultaCentroCostosState);

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

  setData(data: ConsultaCentroCostosEntity): void {
    this.state.update(s => ({ ...s, data, errorObtener: null, loadingObtener: false }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  resetState(): void {
    this.state.set(initialConsultaCentroCostosState);
  }
}
