import { Injectable, computed, signal } from '@angular/core';
import {
  TablasContabilidadState,
  TABLAS_CONTABILIDAD_INITIAL_STATE,
} from './tablas-contabilidad.state';
import { TablasContabilidadEntity } from '../domain/models/tablas-contabilidad.entity';
import { TablaContabilidadItem } from '../domain/models/tablas-contabilidad.entity';

/**
 * TablasContabilidadStore — Store reactivo basado en signals.
 * Almacena el estado del catálogo de tipos de documento contable.
 */
@Injectable()
export class TablasContabilidadStore {

  private readonly _state = signal<TablasContabilidadState>(
    TABLAS_CONTABILIDAD_INITIAL_STATE
  );

  // Selectors
  readonly data         = computed(() => this._state().data);
  readonly items        = computed<TablaContabilidadItem[]>(() => this._state().data?.items ?? []);
  readonly isLoading    = computed(() => this._state().isLoading);
  readonly errorObtener = computed(() => this._state().errorObtener);

  // Mutators
  setLoading(isLoading: boolean): void {
    this._state.update(s => ({ ...s, isLoading }));
  }

  setData(data: TablasContabilidadEntity): void {
    this._state.update(s => ({ ...s, data, isLoading: false, errorObtener: null }));
  }

  setError(errorObtener: string): void {
    this._state.update(s => ({ ...s, errorObtener, isLoading: false }));
  }

  setErrorObtener(errorObtener: string | null): void {
    this._state.update(s => ({ ...s, errorObtener }));
  }

  reset(): void {
    this._state.set(TABLAS_CONTABILIDAD_INITIAL_STATE);
  }
}
