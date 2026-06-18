import { Injectable, signal, computed } from '@angular/core';
import { ProduccionState, initialProduccionState } from './produccion.state';
import { ReglaAsignacionEntity } from '../domain/models/regla-asignacion.entity';

@Injectable()
export class ProduccionStore {

  private readonly state = signal<ProduccionState>(initialProduccionState);

  // Selectores
  readonly reglasAsignacion = computed(() => this.state().reglasAsignacion);
  readonly loadingReglasAsignacion = computed(() => this.state().loadingReglasAsignacion);
  readonly errorReglasAsignacion = computed(() => this.state().errorReglasAsignacion);

  readonly isLoading = computed(() => this.state().loadingReglasAsignacion);
  readonly hasError = computed(() => !!this.state().errorReglasAsignacion);

  // Setters para loading
  setLoadingReglasAsignacion(value: boolean): void {
    this.state.update((s) => ({ ...s, loadingReglasAsignacion: value }));
  }

  // Setters para datos
  setReglasAsignacion(reglas: ReglaAsignacionEntity[]): void {
    this.state.update((s) => ({
      ...s,
      reglasAsignacion: reglas,
      loadingReglasAsignacion: false,
      errorReglasAsignacion: null,
    }));
  }

  clearReglasAsignacion(): void {
    this.state.update((s) => ({
      ...s,
      reglasAsignacion: [],
      loadingReglasAsignacion: false,
      errorReglasAsignacion: null,
    }));
  }

  // Setters para errores
  setErrorReglasAsignacion(error: string): void {
    this.state.update((s) => ({
      ...s,
      errorReglasAsignacion: error,
      loadingReglasAsignacion: false,
    }));
  }

  // Reset state
  resetState(): void {
    this.state.set(initialProduccionState);
  }
}
