import { Injectable, signal, computed } from '@angular/core';
import { CotizacionEntity } from '../domain/models/cotizacion.entity';
import { CotizacionState, initialCotizacionState } from './cotizacion.state';

/**
 * Store de Cotizaciones usando Angular Signals
 * Gestiona el estado reactivo de las cotizaciones
 */
@Injectable()
export class CotizacionStore {
  // Signal privada con el estado completo
  private readonly state = signal<CotizacionState>(initialCotizacionState);

  // Selectores computados (solo lectura)
  readonly cotizaciones = computed(() => this.state().cotizaciones);
  readonly cotizacionSeleccionada = computed(() => this.state().cotizacionSeleccionada);
  readonly comparativo = computed(() => this.state().comparativo);
  readonly loading = computed(() => this.state().loading);
  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingGuardar = computed(() => this.state().loadingGuardar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);
  readonly loadingEliminar = computed(() => this.state().loadingEliminar);
  readonly loadingComparativo = computed(() => this.state().loadingComparativo);
  readonly error = computed(() => this.state().error);
  readonly errorObtener = computed(() => this.state().errorObtener);
  readonly errorGuardar = computed(() => this.state().errorGuardar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);
  readonly errorEliminar = computed(() => this.state().errorEliminar);
  readonly errorComparativo = computed(() => this.state().errorComparativo);

  // ============ Setters para Cotizaciones ============
  setCotizaciones(cotizaciones: CotizacionEntity[]): void {
    this.state.update((state) => ({ ...state, cotizaciones }));
  }

  setCotizacionSeleccionada(cotizacion: CotizacionEntity | null): void {
    this.state.update((state) => ({ ...state, cotizacionSeleccionada: cotizacion }));
  }

  agregarCotizacion(cotizacion: CotizacionEntity): void {
    this.state.update((state) => ({
      ...state,
      cotizaciones: [...state.cotizaciones, cotizacion],
    }));
  }

  actualizarCotizacionEnStore(cotizacionActualizada: CotizacionEntity): void {
    this.state.update((state) => ({
      ...state,
      cotizaciones: state.cotizaciones.map((cot) =>
        cot.id === cotizacionActualizada.id ? cotizacionActualizada : cot
      ),
    }));
  }

  eliminarCotizacionDelStore(cotizacionId: number): void {
    this.state.update((state) => ({
      ...state,
      cotizaciones: state.cotizaciones.filter((cot) => cot.id !== cotizacionId),
    }));
  }

  setComparativo(comparativo: any): void {
    this.state.update((state) => ({ ...state, comparativo }));
  }

  // ============ Setters para Loading ============
  setLoading(loading: boolean): void {
    this.state.update((state) => ({ ...state, loading }));
  }

  setLoadingObtener(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingObtener: loading }));
  }

  setLoadingGuardar(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingGuardar: loading }));
  }

  setLoadingActualizar(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingActualizar: loading }));
  }

  setLoadingEliminar(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingEliminar: loading }));
  }

  setLoadingComparativo(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingComparativo: loading }));
  }

  // ============ Setters para Errores ============
  setError(error: string | null): void {
    this.state.update((state) => ({ ...state, error }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update((state) => ({ ...state, errorObtener: error }));
  }

  setErrorGuardar(error: string | null): void {
    this.state.update((state) => ({ ...state, errorGuardar: error }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update((state) => ({ ...state, errorActualizar: error }));
  }

  setErrorEliminar(error: string | null): void {
    this.state.update((state) => ({ ...state, errorEliminar: error }));
  }

  setErrorComparativo(error: string | null): void {
    this.state.update((state) => ({ ...state, errorComparativo: error }));
  }
}
