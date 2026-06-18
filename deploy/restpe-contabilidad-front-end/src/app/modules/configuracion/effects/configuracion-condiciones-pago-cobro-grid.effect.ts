import { Injectable, inject, effect } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { ConfiguracionStore } from '../store/configuracion.store';
import { CondicionPagoCobroEntity } from '../domain/models/condicion-pago-cobro.entity';

/**
 * @summary Effects para sincronización de grilla de condiciones de pago/cobro
 * @description
 * Maneja los efectos secundarios reactivos para la grilla AG-Grid de condiciones:
 * - Actualiza rowData cuando cambian las condiciones en el store
 * - Muestra/oculta overlay de loading según el estado de carga
 * 
 * Usa Angular Signals con `effect` para reactividad sin suscripciones manuales.
 * 
 * @example
 * ```ts
 * // En el componente
 * private readonly condicionesGridEffects = inject(ConfiguracionCondicionesPagoCobroGridEffects);
 * 
 * onGridReady(params: GridReadyEvent) {
 *   this.condicionesGridEffects.setGridApi(params.api);
 * }
 * ```
 */
@Injectable()
export class ConfiguracionCondicionesPagoCobroGridEffects {

  /** @summary Store reactivo con el estado de configuración (condiciones + loading). */
  private readonly store = inject(ConfiguracionStore);

  /** @summary Referencia a la API de AG-Grid para manipulación reactiva. */
  private gridApi: GridApi | null = null;

  /** @summary Datos actuales de la grilla (rowData). */
  rowData: CondicionPagoCobroEntity[] = [];

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
    
    // Si ya está cargando cuando se registra la API, mostrar el overlay
    const loading = this.store.loadingCondicionesPagoCobro();
    if (loading) {
      this.gridApi.showLoadingOverlay();
    }
  }

  /**
   * @summary Obtiene los datos actuales de la grilla.
   * @description Permite al componente acceder al rowData gestionado por el effect.
   */
  getRowData(): CondicionPagoCobroEntity[] {
    return this.rowData;
  }

  /**
   * @summary Actualiza manualmente los datos de la grilla.
   * @description Permite al componente realizar operaciones CRUD locales.
   */
  setRowData(data: CondicionPagoCobroEntity[]): void {
    this.rowData = data;
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /**
   * @summary Effect: actualiza rowData cuando cambian las condiciones en el store.
   * @description
   * Observa el signal `condicionesPagoCobro()` del store y actualiza automáticamente
   * la grilla cuando los datos cambian. No requiere suscripciones manuales.
   */
  private actualizarRowDataEffect(): void {
    effect(() => {
      const condiciones = this.store.condicionesPagoCobro();
      this.rowData = condiciones;
      
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  /**
   * @summary Effect: muestra/oculta loading overlay según estado de carga.
   * @description
   * Observa el signal `loadingCondicionesPagoCobro()` del store y muestra automáticamente
   * el overlay de carga en la grilla. Sincroniza estado reactivo con UI.
   */
  private manejarLoadingEffect(): void {
    effect(() => {
      const loading = this.store.loadingCondicionesPagoCobro();
      
      if (!this.gridApi) return;

      if (loading) {
        this.gridApi.showLoadingOverlay();
      } else {
        this.gridApi.hideOverlay();
      }
    });
  }
}
