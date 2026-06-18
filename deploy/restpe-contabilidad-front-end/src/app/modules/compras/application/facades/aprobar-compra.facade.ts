import { Injectable, inject } from '@angular/core';
import { OrdenCompraEntity } from '../../domain/models/orden-compra.entity';
import { AprobarCompraStore } from '../../stores/aprobar-compra.store';
import { ObtenerOrdenesPendientesUseCase } from '../use-cases/aprobar-compra/obtener-ordenes-pendientes.usecase';
import { AprobarOrdenUseCase } from '../use-cases/aprobar-compra/aprobar-orden.usecase';
import { RechazarOrdenUseCase } from '../use-cases/aprobar-compra/rechazar-orden.usecase';
import { RetornarOrdenUseCase } from '../use-cases/aprobar-compra/retornar-orden.usecase';
import { AprobarOrdenesMasivoUseCase } from '../use-cases/aprobar-compra/aprobar-ordenes-masivo.usecase';

/**
 * Facade de Aprobación de Compras
 * Proporciona una interfaz simplificada para el flujo de aprobación/rechazo/retorno
 * Oculta la complejidad de los use cases y el store
 */
@Injectable()
export class AprobarCompraFacade {
  private readonly store = inject(AprobarCompraStore);
  private readonly obtenerPendientesUseCase = inject(ObtenerOrdenesPendientesUseCase);
  private readonly aprobarOrdenUseCase = inject(AprobarOrdenUseCase);
  private readonly rechazarOrdenUseCase = inject(RechazarOrdenUseCase);
  private readonly retornarOrdenUseCase = inject(RetornarOrdenUseCase);
  private readonly aprobarMasivoUseCase = inject(AprobarOrdenesMasivoUseCase);

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
   * Carga las órdenes con estado "Pendiente" desde el repositorio
   */
  cargarOrdenesPendientes(): void {
    this.obtenerPendientesUseCase.execute().subscribe();
  }

  /**
   * Aprueba una orden de compra individual
   */
  aprobarOrden(numeroOrden: string, observacion?: string): void {
    this.aprobarOrdenUseCase.execute(numeroOrden, observacion).subscribe();
  }

  /**
   * Rechaza una orden de compra con motivo
   */
  rechazarOrden(numeroOrden: string, motivo: string): void {
    this.rechazarOrdenUseCase.execute(numeroOrden, motivo).subscribe();
  }

  /**
   * Retorna una orden de compra al emisor con motivo
   */
  retornarOrden(numeroOrden: string, motivo: string): void {
    this.retornarOrdenUseCase.execute(numeroOrden, motivo).subscribe();
  }

  /**
   * Aprueba múltiples órdenes en bloque
   */
  aprobarOrdenesMasivo(numerosOrden: string[]): void {
    this.aprobarMasivoUseCase.execute(numerosOrden).subscribe();
  }

  /**
   * Selecciona una orden para trabajar con ella en el formulario
   */
  seleccionarOrden(orden: OrdenCompraEntity | null): void {
    this.store.setOrdenSeleccionada(orden);
  }

  /**
   * Actualiza las filas seleccionadas en el grid
   */
  setFilasSeleccionadas(filas: OrdenCompraEntity[]): void {
    this.store.setFilasSeleccionadas(filas);
  }

  /**
   * Resetea el estado completo del store
   */
  resetearEstado(): void {
    this.store.resetState();
  }
}
