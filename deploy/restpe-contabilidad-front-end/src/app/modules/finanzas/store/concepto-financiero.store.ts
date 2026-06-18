import { Injectable, signal, computed } from '@angular/core';
import { ConceptoFinancieroState, initialConceptoFinancieroState } from './concepto-financiero.state';
import { ConceptoFinancieroEntity } from '../domain/models/concepto-financiero.entity';

@Injectable()
export class ConceptoFinancieroStore {

  private readonly state = signal<ConceptoFinancieroState>(initialConceptoFinancieroState);

  // Selectores
  readonly conceptos          = computed(() => this.state().conceptos);
  readonly loadingObtener     = computed(() => this.state().loadingObtener);
  readonly loadingGuardar     = computed(() => this.state().loadingGuardar);
  readonly loadingActualizar  = computed(() => this.state().loadingActualizar);
  readonly errorObtener       = computed(() => this.state().errorObtener);
  readonly errorGuardar       = computed(() => this.state().errorGuardar);
  readonly errorActualizar    = computed(() => this.state().errorActualizar);
  readonly resultGuardar      = computed(() => this.state().resultGuardar);
  readonly resultActualizar   = computed(() => this.state().resultActualizar);
  readonly loadingEliminar    = computed(() => this.state().loadingEliminar);
  readonly errorEliminar      = computed(() => this.state().errorEliminar);
  readonly resultEliminar     = computed(() => this.state().resultEliminar);

  readonly isLoading = computed(() =>
    this.state().loadingObtener ||
    this.state().loadingGuardar ||
    this.state().loadingActualizar ||
    this.state().loadingEliminar
  );

  readonly hasError = computed(() =>
    !!this.state().errorObtener ||
    !!this.state().errorGuardar ||
    !!this.state().errorActualizar ||
    !!this.state().errorEliminar
  );

  // ── Mutadores de loading ────────────────────────────────────────────────────
  setLoadingObtener(value: boolean)    { this.state.update(s => ({ ...s, loadingObtener: value })); }
  setLoadingGuardar(value: boolean)    { this.state.update(s => ({ ...s, loadingGuardar: value })); }
  setLoadingActualizar(value: boolean) { this.state.update(s => ({ ...s, loadingActualizar: value })); }
  setLoadingEliminar(value: boolean)   { this.state.update(s => ({ ...s, loadingEliminar: value })); }

  // ── Mutadores de datos ──────────────────────────────────────────────────────
  setConceptos(conceptos: ConceptoFinancieroEntity[]) {
    this.state.update(s => ({ ...s, conceptos, errorObtener: null }));
  }

  addConcepto(concepto: ConceptoFinancieroEntity) {
    this.state.update(s => ({ ...s, conceptos: [...s.conceptos, concepto] }));
  }

  /** Reemplaza un concepto existente (match por id real; fallback por código). */
  updateConcepto(concepto: ConceptoFinancieroEntity) {
    this.state.update(s => ({
      ...s,
      conceptos: s.conceptos.map(c =>
        (concepto.concepto_id != null && c.concepto_id === concepto.concepto_id) ||
        c.concepto_codigo === concepto.concepto_codigo
          ? { ...c, ...concepto }
          : c
      ),
    }));
  }

  setResultGuardar(result: ConceptoFinancieroEntity) {
    this.state.update((s) => ({ ...s, resultGuardar: result }));
  }

  setResultActualizar(result: ConceptoFinancieroEntity) {
    this.state.update((s) => ({ ...s, resultActualizar: result }));
  }

  setResultEliminar(result: { success: boolean } | null) {
    this.state.update(s => ({ ...s, resultEliminar: result }));
  }

  removeConcepto(codigo: string) {
    this.state.update(s => ({ ...s, conceptos: s.conceptos.filter(c => c.concepto_codigo !== codigo) }));
  }

  // ── Mutadores de error ──────────────────────────────────────────────────────
  setErrorObtener(message: string | null)    { this.state.update(s => ({ ...s, errorObtener: message,    loadingObtener: false })); }
  setErrorGuardar(message: string | null)    { this.state.update(s => ({ ...s, errorGuardar: message,    loadingGuardar: false })); }
  setErrorActualizar(message: string | null) { this.state.update(s => ({ ...s, errorActualizar: message, loadingActualizar: false })); }
  setErrorEliminar(message: string | null)   { this.state.update(s => ({ ...s, errorEliminar: message,   loadingEliminar: false })); }

  clearErrors() {
    this.state.update(s => ({ ...s, errorObtener: null, errorGuardar: null, errorActualizar: null, errorEliminar: null }));
  }

  clearStates() {
    //Limpia todos los estados excepto los datos (conceptos)
    this.state.update(s => ({
      ...s,
      loadingObtener: false,
      loadingGuardar: false,
      loadingActualizar: false,
      loadingEliminar: false,
      errorObtener: null,
      errorGuardar: null,
      errorActualizar: null,
      errorEliminar: null,
      resultGuardar: null,
      resultActualizar: null,
      resultEliminar: null,
    }));
  }
  

  resetState() {
    this.state.set(initialConceptoFinancieroState);
  }
}
