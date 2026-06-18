import { Injectable, computed, signal } from '@angular/core';
import {
  AjustesReclasificacionState,
  AJUSTES_RECLASIFICACION_INITIAL_STATE,
} from './ajustes-reclasificacion.state';
import { AjustesReclasificacionEntity } from '../domain/models/ajustes-reclasificacion.entity';
import { AjusteReclasificacionItem } from '../domain/models/ajustes-reclasificacion.entity';

/**
 * AjustesReclasificacionStore — Store reactivo basado en signals.
 * Almacena el estado del listado de ajustes y reclasificaciones contables.
 */
@Injectable()
export class AjustesReclasificacionStore {

  private readonly _state = signal<AjustesReclasificacionState>(
    AJUSTES_RECLASIFICACION_INITIAL_STATE
  );

  // Selectors
  readonly data       = computed(() => this._state().data);
  readonly items      = computed<AjusteReclasificacionItem[]>(() => this._state().data?.items ?? []);
  readonly isLoading  = computed(() => this._state().isLoading);
  readonly errorObtener = computed(() => this._state().errorObtener);

  // Mutators
  setLoading(isLoading: boolean): void {
    this._state.update(s => ({ ...s, isLoading }));
  }

  setData(data: AjustesReclasificacionEntity): void {
    this._state.update(s => ({ ...s, data, isLoading: false, errorObtener: null }));
  }

  setError(errorObtener: string): void {
    this._state.update(s => ({ ...s, errorObtener, isLoading: false }));
  }

  setErrorObtener(errorObtener: string | null): void {
    this._state.update(s => ({ ...s, errorObtener }));
  }

  reset(): void {
    this._state.set(AJUSTES_RECLASIFICACION_INITIAL_STATE);
  }
}
