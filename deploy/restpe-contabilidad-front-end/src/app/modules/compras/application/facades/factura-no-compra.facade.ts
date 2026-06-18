import { Injectable, inject } from '@angular/core';
import { FacturaNoCompraEntity } from '../../domain/models/factura-no-compra.entity';
import { FacturaNoCompraStore } from '../../stores/factura-no-compra.store';
import { ObtenerFacturasNoCompraUseCase } from '../use-cases/factura-no-compra/obtener-facturas-no-compra.usecase';
import { GuardarFacturaNoCompraUseCase } from '../use-cases/factura-no-compra/guardar-factura-no-compra.usecase';
import { ActualizarFacturaNoCompraUseCase } from '../use-cases/factura-no-compra/actualizar-factura-no-compra.usecase';
import { EliminarFacturaNoCompraUseCase } from '../use-cases/factura-no-compra/eliminar-factura-no-compra.usecase';

/**
 * Facade de Factura No Compra
 * Proporciona una interfaz simplificada para interactuar con el sistema de facturas no compras
 */
@Injectable()
export class FacturaNoCompraFacade {
  private readonly store = inject(FacturaNoCompraStore);
  private readonly obtenerFacturasUseCase = inject(ObtenerFacturasNoCompraUseCase);
  private readonly guardarFacturaUseCase = inject(GuardarFacturaNoCompraUseCase);
  private readonly actualizarFacturaUseCase = inject(ActualizarFacturaNoCompraUseCase);
  private readonly eliminarFacturaUseCase = inject(EliminarFacturaNoCompraUseCase);

  // ============ Selectores del Store (Reactivos) ============
  readonly facturas = this.store.facturas;
  readonly facturaSeleccionada = this.store.facturaSeleccionada;
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
   * Carga todas las facturas no compras desde el repositorio
   */
  cargarFacturas(): void {
    this.obtenerFacturasUseCase.execute().subscribe();
  }

  /**
   * Guarda una nueva factura no compra
   */
  guardarFactura(factura: FacturaNoCompraEntity): void {
    this.guardarFacturaUseCase.execute(factura).subscribe((response) => {
      if (response.success) {
        this.cargarFacturas();
      }
    });
  }

  /**
   * Actualiza una factura no compra existente
   */
  actualizarFactura(factura: FacturaNoCompraEntity): void {
    this.actualizarFacturaUseCase.execute(factura).subscribe((response) => {
      if (response.success) {
        this.cargarFacturas();
      }
    });
  }

  /**
   * Anula/elimina una factura no compra por su código
   */
  eliminarFactura(codigo: string): void {
    this.eliminarFacturaUseCase.execute(codigo).subscribe((response) => {
      if (response.success) {
        this.cargarFacturas();
      }
    });
  }

  /**
   * Selecciona una factura para trabajar con ella
   */
  seleccionarFactura(factura: FacturaNoCompraEntity | null): void {
    this.store.setFacturaSeleccionada(factura);
  }

  /**
   * Resetea el estado del store
   */
  resetearEstado(): void {
    this.store.resetState();
  }
}
