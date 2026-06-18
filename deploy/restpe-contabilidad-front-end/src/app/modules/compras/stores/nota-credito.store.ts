import { Injectable, signal, computed } from '@angular/core';
import { NotaCreditoEntity } from '../domain/models/nota-credito.entity';
import { NotaCreditoState, initialNotaCreditoState } from './nota-credito.state';

/**
 * Store de Notas de Crédito/Débito usando Angular Signals - Application Layer
 * Gestiona el estado reactivo de las notas de crédito y débito
 */
@Injectable()
export class NotaCreditoStore {
  private readonly state = signal<NotaCreditoState>(initialNotaCreditoState);

  // Selectores computados (solo lectura)
  readonly notas = computed(() => this.state().notas);
  readonly notaSeleccionada = computed(() => this.state().notaSeleccionada);
  readonly notaActual = computed(() => this.state().notaActual);
  readonly loading = computed(() => this.state().loading);
  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingGuardar = computed(() => this.state().loadingGuardar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);
  readonly loadingEliminar = computed(() => this.state().loadingEliminar);
  readonly error = computed(() => this.state().error);
  readonly errorObtener = computed(() => this.state().errorObtener);
  readonly errorGuardar = computed(() => this.state().errorGuardar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);
  readonly errorEliminar = computed(() => this.state().errorEliminar);

  // ============ Setters para Notas ============
  setNotas(notas: NotaCreditoEntity[]): void {
    this.state.update(state => ({ ...state, notas }));
  }

  setNotaSeleccionada(nota: NotaCreditoEntity | null): void {
    this.state.update(state => ({ ...state, notaSeleccionada: nota }));
  }

  agregarNota(nota: NotaCreditoEntity): void {
    this.state.update(state => ({
      ...state,
      notas: [nota, ...state.notas],
      notaActual: nota,
    }));
  }

  actualizarNotaEnStore(notaActualizada: NotaCreditoEntity): void {
    this.state.update(state => ({
      ...state,
      notas: state.notas.map(n =>
        n.nota_credito_codigo === notaActualizada.nota_credito_codigo ? notaActualizada : n
      ),
      notaActual: notaActualizada,
    }));
  }

  eliminarNotaDelStore(codigo: string): void {
    this.state.update(state => ({
      ...state,
      notas: state.notas.filter(n => n.nota_credito_codigo !== codigo),
    }));
  }

  // ============ Setters para Loading ============
  setLoading(loading: boolean): void {
    this.state.update(state => ({ ...state, loading }));
  }

  setLoadingObtener(loading: boolean): void {
    this.state.update(state => ({ ...state, loadingObtener: loading }));
  }

  setLoadingGuardar(loading: boolean): void {
    this.state.update(state => ({ ...state, loadingGuardar: loading }));
  }

  setLoadingActualizar(loading: boolean): void {
    this.state.update(state => ({ ...state, loadingActualizar: loading }));
  }

  setLoadingEliminar(loading: boolean): void {
    this.state.update(state => ({ ...state, loadingEliminar: loading }));
  }

  // ============ Setters para Errores ============
  setError(error: string | null): void {
    this.state.update(state => ({ ...state, error }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(state => ({ ...state, errorObtener: error }));
  }

  setErrorGuardar(error: string | null): void {
    this.state.update(state => ({ ...state, errorGuardar: error }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update(state => ({ ...state, errorActualizar: error }));
  }

  setErrorEliminar(error: string | null): void {
    this.state.update(state => ({ ...state, errorEliminar: error }));
  }
}
