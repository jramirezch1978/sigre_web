import { Injectable, computed, signal } from '@angular/core';
import { GestionCatalogoEntity } from '../domain/models/gestion-catalogo.entity';
import { GestionCatalogoState, GESTION_CATALOGO_INITIAL_STATE } from './gestion-catalogo.state';

@Injectable()
export class GestionCatalogoStore {
  private readonly _state = signal<GestionCatalogoState>(GESTION_CATALOGO_INITIAL_STATE);

  // Selectores
  readonly documentos = computed(() => this._state().documentos);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingGuardar = computed(() => this._state().loadingGuardar);
  readonly loadingActualizar = computed(() => this._state().loadingActualizar);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorGuardar = computed(() => this._state().errorGuardar);
  readonly errorActualizar = computed(() => this._state().errorActualizar);
  readonly resultGuardar = computed(() => this._state().resultGuardar);
  readonly resultActualizar = computed(() => this._state().resultActualizar);
  readonly loadingEliminar = computed(() => this._state().loadingEliminar);
  readonly errorEliminar = computed(() => this._state().errorEliminar);
  readonly resultEliminar = computed(() => this._state().resultEliminar);

  readonly isLoading = computed(() =>
    this._state().loadingObtener ||
    this._state().loadingGuardar ||
    this._state().loadingActualizar ||
    this._state().loadingEliminar
  );
  readonly hasError = computed(() =>
    !!this._state().errorObtener ||
    !!this._state().errorGuardar ||
    !!this._state().errorActualizar ||
    !!this._state().errorEliminar
  );

  // Mutadores — Obtener
  setLoadingObtener(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingObtener: loading }));
  }
  setDocumentos(documentos: GestionCatalogoEntity[]): void {
    this._state.update(s => ({ ...s, documentos, loadingObtener: false }));
  }
  setErrorObtener(error: string | null): void {
    this._state.update(s => ({ ...s, errorObtener: error, loadingObtener: false }));
  }

  // Mutadores — Guardar
  setLoadingGuardar(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingGuardar: loading }));
  }
  setResultGuardar(result: { success: boolean; data?: GestionCatalogoEntity } | null): void {
    this._state.update(s => ({ ...s, resultGuardar: result, loadingGuardar: false }));
  }
  setErrorGuardar(error: string | null): void {
    this._state.update(s => ({ ...s, errorGuardar: error, loadingGuardar: false }));
  }

  // Mutadores — Actualizar
  setLoadingActualizar(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingActualizar: loading }));
  }
  setResultActualizar(result: { success: boolean; data?: GestionCatalogoEntity } | null): void {
    this._state.update(s => ({ ...s, resultActualizar: result, loadingActualizar: false }));
  }
  setErrorActualizar(error: string | null): void {
    this._state.update(s => ({ ...s, errorActualizar: error, loadingActualizar: false }));
  }

  addDocumento(documento: GestionCatalogoEntity): void {
    this._state.update(s => ({ ...s, documentos: [...s.documentos, documento] }));
  }

  updateDocumento(documento: GestionCatalogoEntity): void {
    this._state.update(s => ({
      ...s,
      documentos: s.documentos.map(d =>
        d.catalogo_codigo === documento.catalogo_codigo ? { ...d, ...documento } : d
      ),
    }));
  }

  // Mutadores — Eliminar
  setLoadingEliminar(loading: boolean): void {
    this._state.update(s => ({ ...s, loadingEliminar: loading }));
  }
  setResultEliminar(result: { success: boolean } | null): void {
    this._state.update(s => ({ ...s, resultEliminar: result, loadingEliminar: false }));
  }
  setErrorEliminar(error: string | null): void {
    this._state.update(s => ({ ...s, errorEliminar: error, loadingEliminar: false }));
  }

  removeDocumento(codigo: string): void {
    this._state.update(s => ({
      ...s,
      documentos: s.documentos.filter(d => d.catalogo_codigo !== codigo),
    }));
  }

  resetState(): void {
    this._state.set(GESTION_CATALOGO_INITIAL_STATE);
  }
}
