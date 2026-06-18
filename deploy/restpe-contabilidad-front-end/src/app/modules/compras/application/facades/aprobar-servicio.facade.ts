import { Injectable, inject } from '@angular/core';
import { OrdenServicioEntity } from '../../domain/models/orden-servicio.entity';
import { AprobarServicioStore } from '../../stores/aprobar-servicio.store';
import { ObtenerOrdenesServicioPendientesUseCase } from '../use-cases/aprobar-servicio/obtener-ordenes-servicio-pendientes.usecase';
import { AprobarOrdenServicioUseCase } from '../use-cases/aprobar-servicio/aprobar-orden-servicio.usecase';
import { RechazarOrdenServicioUseCase } from '../use-cases/aprobar-servicio/rechazar-orden-servicio.usecase';
import { RetornarOrdenServicioUseCase } from '../use-cases/aprobar-servicio/retornar-orden-servicio.usecase';
import { AprobarOrdenesServicioMasivoUseCase } from '../use-cases/aprobar-servicio/aprobar-ordenes-servicio-masivo.usecase';

/**
 * Facade de Aprobación de Servicios
 * Proporciona una interfaz simplificada para el flujo de aprobación/rechazo/retorno de órdenes de servicio
 * Oculta la complejidad de los use cases y el store
 */
@Injectable()
export class AprobarServicioFacade {
  private readonly store = inject(AprobarServicioStore);
  private readonly obtenerPendientesUseCase = inject(ObtenerOrdenesServicioPendientesUseCase);
  private readonly aprobarOrdenUseCase = inject(AprobarOrdenServicioUseCase);
  private readonly rechazarOrdenUseCase = inject(RechazarOrdenServicioUseCase);
  private readonly retornarOrdenUseCase = inject(RetornarOrdenServicioUseCase);
  private readonly aprobarMasivoUseCase = inject(AprobarOrdenesServicioMasivoUseCase);

  // ============ Selectores del Store (Reactivos) ============
  readonly ordenesPendientes  = this.store.ordenesPendientes;
  readonly ordenSeleccionada  = this.store.ordenSeleccionada;
  readonly filasSeleccionadas = this.store.filasSeleccionadas;
  readonly loading            = this.store.loading;
  readonly loadingObtener     = this.store.loadingObtener;
  readonly loadingAprobar     = this.store.loadingAprobar;
  readonly loadingRechazar    = this.store.loadingRechazar;
  readonly loadingRetornar    = this.store.loadingRetornar;
  readonly error              = this.store.error;
  readonly errorObtener       = this.store.errorObtener;
  readonly errorAprobar       = this.store.errorAprobar;
  readonly errorRechazar      = this.store.errorRechazar;
  readonly errorRetornar      = this.store.errorRetornar;

  // ============ Métodos Públicos ============

  /**
   * Carga las órdenes de servicio con estado "Pendiente" desde el repositorio
   */
  cargarOrdenesPendientes(): void {
    this.obtenerPendientesUseCase.execute().subscribe();
  }

  /**
   * Aprueba una orden de servicio individual
   */
  aprobarOrden(numeroOrden: string): void {
    this.aprobarOrdenUseCase.execute(numeroOrden).subscribe();
  }

  /**
   * Rechaza una orden de servicio con motivo
   */
  rechazarOrden(numeroOrden: string, motivo: string): void {
    this.rechazarOrdenUseCase.execute(numeroOrden, motivo).subscribe();
  }

  /**
   * Retorna una orden de servicio al emisor con motivo
   */
  retornarOrden(numeroOrden: string, motivo: string): void {
    this.retornarOrdenUseCase.execute(numeroOrden, motivo).subscribe();
  }

  /**
   * Aprueba múltiples órdenes de servicio en bloque
   */
  aprobarOrdenesMasivo(numerosOrden: string[]): void {
    this.aprobarMasivoUseCase.execute(numerosOrden).subscribe();
  }

  /**
   * Selecciona una orden para trabajar con ella en el formulario
   */
  seleccionarOrden(orden: OrdenServicioEntity | null): void {
    this.store.setOrdenSeleccionada(orden);
  }

  /**
   * Actualiza las filas seleccionadas en el grid
   */
  setFilasSeleccionadas(filas: OrdenServicioEntity[]): void {
    this.store.setFilasSeleccionadas(filas);
  }

  /**
   * Resetea el estado completo del store
   */
  resetearEstado(): void {
    this.store.resetState();
  }
}
