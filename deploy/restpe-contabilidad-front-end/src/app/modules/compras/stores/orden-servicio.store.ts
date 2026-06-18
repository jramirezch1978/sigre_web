import { Injectable, signal, computed } from '@angular/core';
import { OrdenServicioEntity } from '../domain/models/orden-servicio.entity';
import { OrdenServicioState, initialOrdenServicioState } from './orden-servicio.state';

/**
 * Store de Órdenes de Servicio usando Angular Signals
 * Gestiona el estado reactivo de las órdenes de servicio
 */
@Injectable()
export class OrdenServicioStore {
  // Signal privada con el estado completo
  private readonly state = signal<OrdenServicioState>(initialOrdenServicioState);

  // Selectores computados (solo lectura)
  readonly ordenesServicio = computed(() => this.state().ordenesServicio);
  readonly ordenServicioSeleccionada = computed(() => this.state().ordenServicioSeleccionada);
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

  // ============ Setters para Órdenes ============
  setOrdenesServicio(ordenes: OrdenServicioEntity[]): void {
    this.state.update((state) => ({ ...state, ordenesServicio: ordenes }));
  }

  setOrdenServicioSeleccionada(orden: OrdenServicioEntity | null): void {
    this.state.update((state) => ({ ...state, ordenServicioSeleccionada: orden }));
  }

  agregarOrdenServicio(orden: OrdenServicioEntity): void {
    this.state.update((state) => ({
      ...state,
      ordenesServicio: [...state.ordenesServicio, orden],
    }));
  }

  actualizarOrdenServicioEnStore(ordenActualizada: OrdenServicioEntity): void {
    this.state.update((state) => ({
      ...state,
      ordenesServicio: state.ordenesServicio.map((orden) =>
        orden.orden_servicio_numero === ordenActualizada.orden_servicio_numero ? ordenActualizada : orden
      ),
    }));
  }

  eliminarOrdenServicioDelStore(numeroOrden: string): void {
    this.state.update((state) => ({
      ...state,
      ordenesServicio: state.ordenesServicio.filter((orden) => orden.orden_servicio_numero !== numeroOrden),
    }));
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

  // ============ Resetear Estado ============
  resetState(): void {
    this.state.set(initialOrdenServicioState);
  }
}
