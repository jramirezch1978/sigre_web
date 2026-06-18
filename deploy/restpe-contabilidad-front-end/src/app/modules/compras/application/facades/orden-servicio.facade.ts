import { Injectable, inject } from '@angular/core';
import { OrdenServicioEntity } from '../../domain/models/orden-servicio.entity';
import { OrdenServicioStore } from '../../stores/orden-servicio.store';
import { ObtenerOrdenesServicioUseCase } from '../use-cases/orden-servicio/obtener-ordenes-servicio.usecase';
import { GuardarOrdenServicioUseCase } from '../use-cases/orden-servicio/guardar-orden-servicio.usecase';
import { ActualizarOrdenServicioUseCase } from '../use-cases/orden-servicio/actualizar-orden-servicio.usecase';
import { EliminarOrdenServicioUseCase } from '../use-cases/orden-servicio/eliminar-orden-servicio.usecase';

/**
 * Facade de Órdenes de Servicio
 * Proporciona una interfaz simplificada para interactuar con el sistema de órdenes
 * Oculta la complejidad de los use cases y el store
 */
@Injectable()
export class OrdenServicioFacade {
  // Inyección de dependencias
  private readonly store = inject(OrdenServicioStore);
  private readonly obtenerOrdenesUseCase = inject(ObtenerOrdenesServicioUseCase);
  private readonly guardarOrdenUseCase = inject(GuardarOrdenServicioUseCase);
  private readonly actualizarOrdenUseCase = inject(ActualizarOrdenServicioUseCase);
  private readonly eliminarOrdenUseCase = inject(EliminarOrdenServicioUseCase);

  // ============ Selectores del Store (Reactivos) ============
  readonly ordenesServicio = this.store.ordenesServicio;
  readonly ordenServicioSeleccionada = this.store.ordenServicioSeleccionada;
  readonly loading = this.store.loading;
  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly error = this.store.error;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly errorEliminar = this.store.errorEliminar;

  // ============ Métodos Públicos ============

  /**
   * Carga todas las órdenes de servicio desde el repositorio
   */
  cargarOrdenesServicio(): void {
    this.obtenerOrdenesUseCase.execute().subscribe();
  }

  /**
   * Guarda una nueva orden de servicio
   */
  guardarOrdenServicio(ordenServicio: OrdenServicioEntity): void {
    this.guardarOrdenUseCase.execute(ordenServicio).subscribe();
  }

  /**
   * Actualiza una orden de servicio existente
   */
  actualizarOrdenServicio(ordenServicio: OrdenServicioEntity): void {
    this.actualizarOrdenUseCase.execute(ordenServicio).subscribe();
  }

  /**
   * Elimina una orden de servicio por su número de orden
   */
  eliminarOrdenServicio(numeroOrden: string): void {
    this.eliminarOrdenUseCase.execute(numeroOrden).subscribe();
  }

  /**
   * Selecciona una orden de servicio para trabajar con ella
   */
  seleccionarOrdenServicio(orden: OrdenServicioEntity | null): void {
    this.store.setOrdenServicioSeleccionada(orden);
  }

  /**
   * Resetea el estado del store
   */
  resetearEstado(): void {
    this.store.resetState();
  }
}
