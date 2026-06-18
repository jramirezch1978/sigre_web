import { Injectable, computed, signal } from '@angular/core';
import { GestionGrupoEntity } from '../domain/models/gestion-grupo.entity';
import { GestionGrupoState, GESTION_GRUPO_INITIAL_STATE } from './gestion-grupo.state';

@Injectable()
export class GestionGrupoStore {
  private readonly _state = signal<GestionGrupoState>(GESTION_GRUPO_INITIAL_STATE);

  // Selectores
  readonly grupos = computed(() => this._state().grupos);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingGuardar = computed(() => this._state().loadingGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorGuardar = computed(() => this._state().errorGuardar);
  readonly errorActualizar = computed(() => this._state().errorActualizar);
  readonly resultGuardar = computed(() => this._state().resultGuardar);
  readonly resultActualizar = computed(() => this._state().resultActualizar);

  readonly isLoading = computed(() =>
    this._state().loadingObtener ||
    this._state().loadingGuardar ||
    this._state().loadingActualizar
  );
  readonly hasError = computed(() =>
    !!this._state().errorObtener ||
    !!this._state().errorGuardar ||
    !!this._state().errorActualizar
  );

  // Mutadores — Obtener
  setLoadingObtener(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingObtener: loading }));
  }
  setGrupos(grupos: GestionGrupoEntity[]): void {
    this._state.update(s => ({ ...s, grupos, loadingObtener: false }));
  }
  setErrorObtener(error: string | null): void {
    this._state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  // Mutadores — Guardar
  setLoadingGuardar(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingGuardar: loading }));
  }
  setResultGuardar(result: { success: boolean; data?: GestionGrupoEntity } | null): void {
    this._state.update(s => ({ ...s, resultGuardar: result, loadingGuardar: false }));
  }
  setErrorGuardar(error: string | null): void {
    this._state.update(s => ({ ...s, errorGuardar: error, loadingGuardar: false }));
  }

  // Mutadores — Actualizar
  setLoadingActualizar(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingActualizar: loading }));
  }
  setResultActualizar(result: { success: boolean; data?: GestionGrupoEntity } | null): void {
    this._state.update(s => ({ ...s, resultActualizar: result, loadingActualizar: false }));
  }
  setErrorActualizar(error: string | null): void {
    this._state.update(s => ({ ...s, errorActualizar: error, loadingActualizar: false }));
  }

  resetState(): void {
    this._state.set(GESTION_GRUPO_INITIAL_STATE);
  }
}
