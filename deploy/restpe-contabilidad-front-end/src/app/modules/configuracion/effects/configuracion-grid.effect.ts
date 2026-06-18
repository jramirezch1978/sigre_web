import { Injectable, inject, effect } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { ConfiguracionStore } from '../store/configuracion.store';
import { PlantillaNotificacionEntity } from '../domain/models/plantilla-notificacion.entity';

/**
 * @summary Effects para sincronización de grilla de plantillas de notificación
 * @description
 * Maneja los efectos secundarios reactivos para la grilla AG-Grid:
 * - Actualiza rowData cuando cambian las plantillas en el store
 * - Muestra/oculta overlay de loading según el estado de carga
 * 
 * Usa Angular Signals con `effect` para reactividad sin suscripciones manuales.
 * 
 * @example
 * ```ts
 * // En el componente
 * private readonly gridEffects = inject(ConfiguracionGridEffects);
 * 
 * onGridReady(params: GridReadyEvent) {
 *   this.gridEffects.setGridApi(params.api);
 * }
 * ```
 */
@Injectable()
export class ConfiguracionGridEffects {

  /** @summary Store reactivo con el estado de configuración (plantillas + loading). */
  private readonly store = inject(ConfiguracionStore);

  /** @summary Referencia a la API de AG-Grid para manipulación reactiva. */
  private gridApi: GridApi | null = null;

  /** @summary Datos actuales de la grilla (rowData). */
  rowData: PlantillaNotificacionEntity[] = [];

  constructor() {
    this.actualizarRowDataEffect();
    this.manejarLoadingEffect();
  }

  /**
   * @summary Registra la API de AG-Grid para que los effects puedan manipularla.
   * @description Debe llamarse desde onGridReady del componente.
   */
  setGridApi(api: GridApi): void {
    this.gridApi = api;
  }

  /**
   * @summary Obtiene los datos actuales de la grilla.
   * @description Permite al componente acceder al rowData gestionado por el effect.
   */
  getRowData(): PlantillaNotificacionEntity[] {
    return this.rowData;
  }

  /**
   * @summary Effect: actualiza rowData cuando cambian las plantillas en el store.
   * @description
   * Observa el signal `plantillasNotificacion()` del store y actualiza automáticamente
   * la grilla cuando los datos cambian. No requiere suscripciones manuales.
   */
  private actualizarRowDataEffect(): void {
    effect(() => {
      const plantillas = this.store.plantillasNotificacion();
      this.rowData = plantillas;
      
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  /**
   * @summary Effect: maneja el overlay de loading de la grilla.
   * @description
   * Observa el signal `loadingPlantillasNotificacion()` y muestra/oculta
   * el overlay de loading de AG-Grid automáticamente.
   */
  private manejarLoadingEffect(): void {
    effect(() => {
      const loading = this.store.loadingPlantillasNotificacion();
      
      if (!this.gridApi) return;

      if (loading) {
        this.gridApi.showLoadingOverlay();
      } else {
        this.gridApi.hideOverlay();
      }
    });
  }
}
