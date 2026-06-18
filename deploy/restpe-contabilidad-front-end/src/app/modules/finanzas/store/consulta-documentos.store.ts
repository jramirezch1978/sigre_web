import { Injectable, signal, computed } from '@angular/core';
import { ConsultaDocumentosEntity } from '../domain/models/consulta-documentos.entity';
import {
  ConsultaDocumentosState,
  initialConsultaDocumentosState,
} from './consulta-documentos.state';

@Injectable()
export class ConsultaDocumentosStore {
  private readonly _state = signal<ConsultaDocumentosState>(initialConsultaDocumentosState);

  // ── Selectores ───────────────────────────────────────────────────────────
  readonly registros = computed(() => this._state().registros);
  readonly loadingObtener = computed(() => this._state().loadingObtener);
  readonly errorObtener = computed(() => this._state().errorObtener);
  readonly isLoading = computed(() => this._state().loadingObtener);

  // ── Mutadores ────────────────────────────────────────────────────────────
  setRegistros(data: ConsultaDocumentosEntity[]) {
    this._state.update(s => ({ ...s, registros: data }));
  }
  setLoadingObtener(v: boolean) {
    this._state.update(s => ({ ...s, loadingObtener: v }));
  }
  setErrorObtener(e: string | null) {
    this._state.update(s => ({ ...s, errorObtener: e }));
  }
  reset() {
    this._state.set(initialConsultaDocumentosState);
  }
}
