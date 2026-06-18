import { Injectable, signal, computed } from '@angular/core';
import { OrdenServicioEntity } from '../domain/models/orden-servicio.entity';
import { AprobarServicioState, initialAprobarServicioState } from './aprobar-servicio.state';

/**
 * Store de Aprobación de Servicios usando Angular Signals
 * Gestiona el estado reactivo del flujo de aprobación de órdenes de servicio
 */
@Injectable()
export class AprobarServicioStore {
  private readonly state = signal<AprobarServicioState>(initialAprobarServicioState);

  // Selectores computados
  readonly ordenesPendientes   = computed(() => this.state().ordenesPendientes);
  readonly ordenSeleccionada   = computed(() => this.state().ordenSeleccionada);
  readonly filasSeleccionadas  = computed(() => this.state().filasSeleccionadas);

  readonly loading          = computed(() => this.state().loading);
  readonly loadingObtener   = computed(() => this.state().loadingObtener);
  readonly loadingAprobar   = computed(() => this.state().loadingAprobar);
  readonly loadingRechazar  = computed(() => this.state().loadingRechazar);
  readonly loadingRetornar  = computed(() => this.state().loadingRetornar);

  readonly error         = computed(() => this.state().error);
  readonly errorObtener  = computed(() => this.state().errorObtener);
  readonly errorAprobar  = computed(() => this.state().errorAprobar);
  readonly errorRechazar = computed(() => this.state().errorRechazar);
  readonly errorRetornar = computed(() => this.state().errorRetornar);

  // ============ Setters de datos ============

  setOrdenesPendientes(ordenes: OrdenServicioEntity[]): void {
    this.state.update(s => ({ ...s, ordenesPendientes: ordenes }));
  }

  setOrdenSeleccionada(orden: OrdenServicioEntity | null): void {
    this.state.update(s => ({ ...s, ordenSeleccionada: orden }));
  }

  setFilasSeleccionadas(filas: OrdenServicioEntity[]): void {
    this.state.update(s => ({ ...s, filasSeleccionadas: filas }));
  }

  /**
   * Elimina una orden de la lista de pendientes (tras aprobar/rechazar/retornar)
   */
  removerOrdenPendiente(numeroOrden: string): void {
    this.state.update(s => ({
      ...s,
      ordenesPendientes: s.ordenesPendientes.filter(o => o.orden_servicio_numero !== numeroOrden),
      filasSeleccionadas: s.filasSeleccionadas.filter(o => o.orden_servicio_numero !== numeroOrden),
      ordenSeleccionada: s.ordenSeleccionada?.orden_servicio_numero === numeroOrden ? null : s.ordenSeleccionada
    }));
  }

  // ============ Setters de Loading ============

  setLoading(loading: boolean): void {
    this.state.update(s => ({ ...s, loading }));
  }

  setLoadingObtener(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingObtener: loading }));
  }

  setLoadingAprobar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingAprobar: loading }));
  }

  setLoadingRechazar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingRechazar: loading }));
  }

  setLoadingRetornar(loading: boolean): void {
    this.state.update(s => ({ ...s, loadingRetornar: loading }));
  }

  // ============ Setters de Error ============

  setError(error: string | null): void {
    this.state.update(s => ({ ...s, error }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update(s => ({ ...s, errorObtener: error }));
  }

  setErrorAprobar(error: string | null): void {
    this.state.update(s => ({ ...s, errorAprobar: error }));
  }

  setErrorRechazar(error: string | null): void {
    this.state.update(s => ({ ...s, errorRechazar: error }));
  }

  setErrorRetornar(error: string | null): void {
    this.state.update(s => ({ ...s, errorRetornar: error }));
  }

  resetState(): void {
    this.state.set(initialAprobarServicioState);
  }
}
