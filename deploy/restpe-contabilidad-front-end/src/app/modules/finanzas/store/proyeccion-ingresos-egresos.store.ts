import { Injectable, signal, computed } from '@angular/core';
import { ProyeccionIngresosEgresosState, initialProyeccionIngresosEgresosState } from './proyeccion-ingresos-egresos.state';
import { ProyeccionIngresosEgresosEntity } from '../domain/models/proyeccion-ingresos-egresos.entity';

@Injectable()
export class ProyeccionIngresosEgresosStore {
  private readonly _state = signal<ProyeccionIngresosEgresosState>(initialProyeccionIngresosEgresosState);

  readonly proyecciones = computed(() => this._state().proyecciones);
  readonly isLoading = computed(() => this._state().isLoading);
  readonly error = computed(() => this._state().error);

  setLoading(isLoading: boolean): void {
    this._state.update(state => ({ ...state, isLoading }));
  }

  setProyecciones(proyecciones: ProyeccionIngresosEgresosEntity[]): void {
    this._state.update(state => ({ ...state, proyecciones, isLoading: false }));
  }

  setError(error: string): void {
    this._state.update(state => ({ ...state, error, isLoading: false }));
  }

  resetState(): void {
    this._state.set(initialProyeccionIngresosEgresosState);
  }
}
