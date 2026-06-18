import { Injectable, signal, computed } from '@angular/core';
import { OrdenCompraEntity } from '../domain/models/orden-compra.entity';
import { OrdenCompraState, initialOrdenCompraState } from './orden-compra.state';

/**
 * Store de Órdenes de Compra usando Angular Signals
 * Gestiona el estado reactivo de las órdenes de compra
 */
@Injectable()
export class OrdenCompraStore {
  // Signal privada con el estado completo
  private readonly state = signal<OrdenCompraState>(initialOrdenCompraState);

  // Selectores computados (solo lectura)
  readonly ordenesCompra = computed(() => this.state().ordenesCompra);
  readonly ordenCompraSeleccionada = computed(() => this.state().ordenCompraSeleccionada);
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
  setOrdenesCompra(ordenes: OrdenCompraEntity[]): void {
    this.state.update((state) => ({ ...state, ordenesCompra: ordenes }));
  }

  setOrdenCompraSeleccionada(orden: OrdenCompraEntity | null): void {
    this.state.update((state) => ({ ...state, ordenCompraSeleccionada: orden }));
  }

  agregarOrdenCompra(orden: OrdenCompraEntity): void {
    this.state.update((state) => ({
      ...state,
      ordenesCompra: [...state.ordenesCompra, orden],
    }));
  }

  actualizarOrdenCompraEnStore(ordenActualizada: OrdenCompraEntity): void {
    this.state.update((state) => ({
      ...state,
      ordenesCompra: state.ordenesCompra.map((orden) =>
        orden.orden_compra_numero === ordenActualizada.orden_compra_numero ? ordenActualizada : orden
      ),
    }));
  }

  eliminarOrdenCompraDelStore(numeroOrden: string): void {
    this.state.update((state) => ({
      ...state,
      ordenesCompra: state.ordenesCompra.filter((orden) => orden.orden_compra_numero !== numeroOrden),
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
    this.state.set(initialOrdenCompraState);
  }
}
