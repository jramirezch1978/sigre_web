import { Injectable, inject } from '@angular/core';
import { CotizacionEntity } from '../../domain/models/cotizacion.entity';
import { CotizacionStore } from '../../stores/cotizacion.store';
import { ObtenerCotizacionesUseCase } from '../use-cases/cotizacion/obtener-cotizaciones.usecase';
import { GuardarCotizacionUseCase } from '../use-cases/cotizacion/guardar-cotizacion.usecase';

/**
 * Facade de Cotizaciones
 * Proporciona una interfaz simplificada para interactuar con el sistema de cotizaciones
 * Oculta la complejidad de los use cases y el store
 */
@Injectable()
export class CotizacionFacade {
  // Inyección de dependencias
  private readonly store = inject(CotizacionStore);

  private readonly obtenerUC = inject(ObtenerCotizacionesUseCase);
  private readonly guardarUC = inject(GuardarCotizacionUseCase);
//   private readonly actualizarUC = inject(ActualizarCotizacionUseCase);
  // private readonly eliminarUC = inject(EliminarCotizacionUseCase);

  // ============ Selectores del Store (Reactivos) ============
  readonly cotizaciones = this.store.cotizaciones;
  readonly cotizacionSeleccionada = this.store.cotizacionSeleccionada;
  readonly comparativo = this.store.comparativo;
  readonly loading = this.store.loading;
  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly loadingComparativo = this.store.loadingComparativo;
  readonly error = this.store.error;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly errorEliminar = this.store.errorEliminar;
  readonly errorComparativo = this.store.errorComparativo;

  // ============ Métodos Públicos ============

  /**
   * Carga todas las cotizaciones
   */
  cargarCotizaciones(): void {
    this.obtenerUC.execute().subscribe();
  }

  /**
   * Guarda una nueva cotización
   */
  guardarCotizacion(
    cotizacion: Omit<
      CotizacionEntity,
      'proveedor_id' | 'proveedor_razon_social' | 'total' | 'flag_estado'
    >,
  ): void {
    this.store.setLoadingGuardar(true);
    try {
      this.guardarUC.execute(cotizacion).subscribe();
      this.store.setLoadingGuardar(false);
      this.store.setErrorGuardar(null);
    } catch (error) {
      this.store.setLoadingGuardar(false);
      this.store.setErrorGuardar('Error al guardar la cotización');
    }
  }

  /**
   * Actualiza una cotización existente
   */
  actualizarCotizacion(cotizacion: CotizacionEntity): void {
    this.store.setLoadingActualizar(true);
    try {
      this.store.actualizarCotizacionEnStore(cotizacion);
      this.store.setLoadingActualizar(false);
      this.store.setErrorActualizar(null);
    } catch (error) {
      this.store.setLoadingActualizar(false);
      this.store.setErrorActualizar('Error al actualizar la cotización');
    }
  }

  /**
   * Elimina una cotización por su ID
   */
  eliminarCotizacion(cotizacionId: number): void {
    this.store.setLoadingEliminar(true);
    try {
      this.store.eliminarCotizacionDelStore(cotizacionId);
      this.store.setLoadingEliminar(false);
      this.store.setErrorEliminar(null);
    } catch (error) {
      this.store.setLoadingEliminar(false);
      this.store.setErrorEliminar('Error al eliminar la cotización');
    }
  }

  /**
   * Selecciona una cotización para trabajar con ella
   */
  seleccionarCotizacion(cotizacion: CotizacionEntity | null): void {
    this.store.setCotizacionSeleccionada(cotizacion);
  }

  /**
   * Marca una cotización como seleccionada (ganadora)
   */
  seleccionarCotizacionGanadora(cotizacionId: number): void {
    const cot = this.store.cotizaciones().find((c) => c.id === cotizacionId);
    if (cot) {
      const cotActualizada: CotizacionEntity = {
        ...cot,
        flag_estado: 'SELECCIONADA',
      };
      this.actualizarCotizacion(cotActualizada);
    }
  }

  /**
   * Marca una cotización como descartada
   */
  descartarCotizacion(cotizacionId: number): void {
    const cot = this.store.cotizaciones().find((c) => c.id === cotizacionId);
    if (cot) {
      const cotActualizada: CotizacionEntity = {
        ...cot,
        flag_estado: 'DESCARTADA',
      };
      this.actualizarCotizacion(cotActualizada);
    }
  }

  /**
   * Anula una cotización
   */
  anularCotizacion(cotizacionId: number, motivo: string): void {
    const cot = this.store.cotizaciones().find((c) => c.id === cotizacionId);
    if (cot) {
      const cotActualizada: CotizacionEntity = {
        ...cot,
        flag_estado: '0',
      };
      this.actualizarCotizacion(cotActualizada);
    }
  }

  /**
   * Carga el comparativo de cotizaciones
   */
  cargarComparativo(comparativo: any): void {
    this.store.setComparativo(comparativo);
    this.store.setLoadingComparativo(false);
  }

  /**
   * Resetea el estado del store
   */
  resetearEstado(): void {
    this.store.setCotizaciones([]);
    this.store.setCotizacionSeleccionada(null);
    this.store.setComparativo(null);
    this.store.setError(null);
  }
}
