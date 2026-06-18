import { Injectable, inject } from '@angular/core';
import { OrdenCompraEntity } from '../../domain/models/orden-compra.entity';
import { OrdenCompraStore } from '../../stores/orden-compra.store';
import { ObtenerOrdenesCompraUseCase } from '../use-cases/orden-compra/obtener-ordenes-compra.usecase';
import { GuardarOrdenCompraUseCase } from '../use-cases/orden-compra/guardar-orden-compra.usecase';
import { ActualizarOrdenCompraUseCase } from '../use-cases/orden-compra/actualizar-orden-compra.usecase';
import { EliminarOrdenCompraUseCase } from '../use-cases/orden-compra/eliminar-orden-compra.usecase';

/**
 * Facade de Órdenes de Compra
 * Proporciona una interfaz simplificada para interactuar con el sistema de órdenes
 * Oculta la complejidad de los use cases y el store
 */
@Injectable()
export class OrdenCompraFacade {
  // Inyección de dependencias
  private readonly store = inject(OrdenCompraStore);
  private readonly obtenerOrdenesUseCase = inject(ObtenerOrdenesCompraUseCase);
  private readonly guardarOrdenUseCase = inject(GuardarOrdenCompraUseCase);
  private readonly actualizarOrdenUseCase = inject(ActualizarOrdenCompraUseCase);
  private readonly eliminarOrdenUseCase = inject(EliminarOrdenCompraUseCase);

  // ============ Selectores del Store (Reactivos) ============
  readonly ordenesCompra = this.store.ordenesCompra;
  readonly ordenCompraSeleccionada = this.store.ordenCompraSeleccionada;
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
   * Carga todas las órdenes de compra desde el repositorio
   */
  cargarOrdenesCompra(): void {
    this.obtenerOrdenesUseCase.execute().subscribe();
  }

  /**
   * Guarda una nueva orden de compra
   */
  guardarOrdenCompra(ordenCompra: OrdenCompraEntity): void {
    this.guardarOrdenUseCase.execute(ordenCompra).subscribe();
  }

  /**
   * Actualiza una orden de compra existente
   */
  actualizarOrdenCompra(ordenCompra: OrdenCompraEntity): void {
    this.actualizarOrdenUseCase.execute(ordenCompra).subscribe();
  }

  /**
   * Elimina una orden de compra por su número de orden
   */
  eliminarOrdenCompra(numeroOrden: string): void {
    this.eliminarOrdenUseCase.execute(numeroOrden).subscribe();
  }

  /**
   * Selecciona una orden de compra para trabajar con ella
   */
  seleccionarOrdenCompra(orden: OrdenCompraEntity | null): void {
    this.store.setOrdenCompraSeleccionada(orden);
  }

  /**
   * Resetea el estado del store
   */
  resetearEstado(): void {
    this.store.resetState();
  }
}
