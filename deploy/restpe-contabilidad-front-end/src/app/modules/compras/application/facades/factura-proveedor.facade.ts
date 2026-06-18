import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize, of } from 'rxjs';
import { FacturaProveedorStore } from '../../stores/factura-proveedor.store';
import { ObtenerFacturasProveedorUseCase } from '../use-cases/factura-proveedor/obtener-facturas-proveedor.usecase';
import { GuardarFacturaProveedorUseCase } from '../use-cases/factura-proveedor/guardar-factura-proveedor.usecase';
import { ActualizarFacturaProveedorUseCase } from '../use-cases/factura-proveedor/actualizar-factura-proveedor.usecase';
import { EliminarFacturaProveedorUseCase } from '../use-cases/factura-proveedor/eliminar-factura-proveedor.usecase';
import { FacturaProveedorEntity } from '../../domain/models/factura-proveedor.entity';

/**
 * Facade de Facturas de Proveedor - Application Layer
 * Simplifica el acceso del componente al store y los use cases
 */
@Injectable()
export class FacturaProveedorFacade {
  private readonly store = inject(FacturaProveedorStore);
  private readonly obtenerUseCase = inject(ObtenerFacturasProveedorUseCase);
  private readonly guardarUseCase = inject(GuardarFacturaProveedorUseCase);
  private readonly actualizarUseCase = inject(ActualizarFacturaProveedorUseCase);
  private readonly eliminarUseCase = inject(EliminarFacturaProveedorUseCase);

  // Señales del store expuestas al componente
  readonly facturas = this.store.facturas;
  readonly facturaSeleccionada = this.store.facturaSeleccionada;
  readonly isLoading = this.store.loading;
  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly errorEliminar = this.store.errorEliminar;

  cargarFacturas(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUseCase.execute().pipe(
      tap(facturas => this.store.setFacturas(facturas)),
      catchError(err => {
        this.store.setErrorObtener(err.message || 'Error al cargar facturas');
        return of([]);
      }),
      finalize(() => this.store.setLoadingObtener(false))
    ).subscribe();
  }

  guardarFactura(factura: FacturaProveedorEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);

    this.guardarUseCase.execute(factura).pipe(
      tap(response => {
        if (response.success && response.data) {
          this.store.agregarFactura(response.data);
        }
      }),
      catchError(err => {
        this.store.setErrorGuardar(err.message || 'Error al guardar factura');
        return of(null);
      }),
      finalize(() => this.store.setLoadingGuardar(false))
    ).subscribe();
  }

  actualizarFactura(factura: FacturaProveedorEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);

    this.actualizarUseCase.execute(factura).pipe(
      tap(response => {
        if (response.success && response.data) {
          this.store.actualizarFacturaEnStore(response.data);
        }
      }),
      catchError(err => {
        this.store.setErrorActualizar(err.message || 'Error al actualizar factura');
        return of(null);
      }),
      finalize(() => this.store.setLoadingActualizar(false))
    ).subscribe();
  }

  eliminarFactura(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setErrorEliminar(null);

    this.eliminarUseCase.execute(codigo).pipe(
      tap(response => {
        if (response.success) {
          this.store.eliminarFacturaDelStore(codigo);
        }
      }),
      catchError(err => {
        this.store.setErrorEliminar(err.message || 'Error al eliminar factura');
        return of(null);
      }),
      finalize(() => this.store.setLoadingEliminar(false))
    ).subscribe();
  }

  seleccionarFactura(factura: FacturaProveedorEntity | null): void {
    this.store.setFacturaSeleccionada(factura);
  }

  resetearEstado(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorGuardar(null);
    this.store.setErrorActualizar(null);
    this.store.setErrorEliminar(null);
  }
}
