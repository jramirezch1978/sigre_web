import { Injectable, signal, computed } from '@angular/core';
import { DocumentoClienteState, initialDocumentoClienteState } from './documento-cliente.state';
import { DocumentoClienteEntity } from '../domain/models/documento-cliente.entity';

@Injectable()
export class DocumentoClienteStore {
  private readonly _state = signal<DocumentoClienteState>(initialDocumentoClienteState);

  readonly documentos = computed(() => this._state().documentos);
  readonly isLoading = computed(() => this._state().isLoading);
  readonly error = computed(() => this._state().error);

  setLoading(isLoading: boolean): void {
    this._state.update(state => ({ ...state, isLoading }));
  }

  setDocumentos(documentos: DocumentoClienteEntity[]): void {
    this._state.update(state => ({ ...state, documentos, isLoading: false }));
  }

  setError(error: string): void {
    this._state.update(state => ({ ...state, error, isLoading: false }));
  }

  resetState(): void {
    this._state.set(initialDocumentoClienteState);
  }
}
