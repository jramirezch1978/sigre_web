import { Injectable, computed, signal } from '@angular/core';
import { RazonSocialEntity } from '../domain/models/razon-social.entity';

interface RazonSocialState {
  razones: RazonSocialEntity[];
  seleccionada: RazonSocialEntity | null;
  loading: boolean;
  error: string | null;
}

const initialState: RazonSocialState = {
  razones: [],
  seleccionada: null,
  loading: false,
  error: null,
};

@Injectable({ providedIn: 'root' })
export class RazonSocialStore {
  private readonly state = signal<RazonSocialState>(initialState);

  // Selectores
  readonly razones = computed(() => this.state().razones);
  readonly seleccionada = computed(() => this.state().seleccionada);
  readonly loading = computed(() => this.state().loading);
  readonly error = computed(() => this.state().error);

  // Mutadores
  setRazones(data: RazonSocialEntity[]): void {
    this.state.update(s => ({ ...s, razones: data }));
  }

  setSeleccionada(razon: RazonSocialEntity | null): void {
    this.state.update(s => ({ ...s, seleccionada: razon }));
  }

  setLoading(value: boolean): void {
    this.state.update(s => ({ ...s, loading: value }));
  }

  setError(error: string | null): void {
    this.state.update(s => ({ ...s, error }));
  }

  resetState(): void {
    this.state.set(initialState);
  }
}
