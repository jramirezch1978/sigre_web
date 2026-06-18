import { Injectable, signal, computed } from '@angular/core';
import { PagosMasivosEntity } from '../domain/models/pagos-masivos.entity';
import { PagosMasivosDocumentoEntity } from '../domain/models/pagos-masivos-documento.entity';
import { PagosMasivosState, initialPagosMasivosState } from './pagos-masivos.state';

@Injectable()
export class PagosMasivosStore {
  private readonly _state = signal<PagosMasivosState>(initialPagosMasivosState);

  // ── Selectores ────────────────────────────────────────────────────────────
  readonly registros = computed(() => this._state().registros);
  readonly documentos = computed(() => this._state().documentos);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly loadingGuardar = computed(() => this._state().loadingGuardar);
  readonly loadingDocumentos = computed(() => this._state().loadingDocumentos);
  readonly isLoading = computed(
    () => this._state().loadingObtener || this._state().loadingGuardar || this._state().loadingDocumentos
  );
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly errorGuardar = computed(() => this._state().errorGuardar);
  readonly errorDocumentos = computed(() => this._state().errorDocumentos);
  readonly guardadoOk = computed(() => this._state().guardadoOk);

  // ── Mutadores ─────────────────────────────────────────────────────────────
  setRegistros(data: PagosMasivosEntity[]) {
    this._state.update(s => ({ ...s, registros: data }));
  }

  addRegistro(entity: PagosMasivosEntity) {
    this._state.update(s => ({ ...s, registros: [entity, ...s.registros] }));
  }

  setDocumentos(data: PagosMasivosDocumentoEntity[]) {
    this._state.update(s => ({ ...s, documentos: data }));
  }

  setLoadingObtener(v: boolean) { this._state.update(s => ({ ...s, loadingObtener: v })); }
  setLoadingGuardar(v: boolean) { this._state.update(s => ({ ...s, loadingGuardar: v })); }
  setLoadingDocumentos(v: boolean) { this._state.update(s => ({ ...s, loadingDocumentos: v })); }
  setErrorObtener(e: string | null) { this._state.update(s => ({ ...s, errorObtener: e })); }
  setErrorGuardar(e: string | null) { this._state.update(s => ({ ...s, errorGuardar: e })); }
  setErrorDocumentos(e: string | null) { this._state.update(s => ({ ...s, errorDocumentos: e })); }
  setGuardadoOk(v: boolean) { this._state.update(s => ({ ...s, guardadoOk: v })); }

  reset() { this._state.set(initialPagosMasivosState); }
}
