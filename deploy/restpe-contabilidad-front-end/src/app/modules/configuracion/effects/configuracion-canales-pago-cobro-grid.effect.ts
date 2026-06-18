import { Injectable, inject, effect } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { ConfiguracionStore } from '../store/configuracion.store';
import { CanalPagoCobroEntity } from '../domain/models/canal-pago-cobro.entity';

/**
 * @summary Effects para sincronización de grilla de canales de pago/cobro
 * @description
 * Maneja los efectos secundarios reactivos para la grilla AG-Grid de canales:
 * - Actualiza rowData cuando cambian los canales en el store
 * - Muestra/oculta overlay de loading según el estado de carga
 * 
 * Usa Angular Signals con `effect` para reactividad sin suscripciones manuales.
 * 
 * @example
 * ```ts
 * // En el componente
 * private readonly canalesGridEffects = inject(ConfiguracionCanalesPagoCobroGridEffects);
 * 
 * onGridReady(params: GridReadyEvent) {
 *   this.canalesGridEffects.setGridApi(params.api);
 * }
 * ```
 */
@Injectable()
export class ConfiguracionCanalesPagoCobroGridEffects {

  /** @summary Store reactivo con el estado de configuración (canales + loading). */
  private readonly store = inject(ConfiguracionStore);

  /** @summary Referencia a la API de AG-Grid para manipulación reactiva. */
  private gridApi: GridApi | null = null;

  /** @summary Datos actuales de la grilla (rowData). */
  rowData: CanalPagoCobroEntity[] = [];

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
    const loading = this.store.loadingCanalesPagoCobro();
    if (loading) {
      this.gridApi.showLoadingOverlay();
    }
  }

  /**
   * @summary Obtiene los datos actuales de la grilla.
   * @description Permite al componente acceder al rowData gestionado por el effect.
   */
  getRowData(): CanalPagoCobroEntity[] {
    return this.rowData;
  }

  /**
   * @summary Actualiza manualmente los datos de la grilla.
   * @description Permite al componente realizar operaciones CRUD locales.
   */
  setRowData(data: CanalPagoCobroEntity[]): void {
    this.rowData = data;
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /**
   * @summary Effect: actualiza rowData cuando cambian los canales en el store.
   * @description
   * Observa el signal `canalesPagoCobro()` del store y actualiza automáticamente
   * la grilla cuando los datos cambian. No requiere suscripciones manuales.
   */
  private actualizarRowDataEffect(): void {
    effect(() => {
      const canales = this.store.canalesPagoCobro();
      this.rowData = canales;
      
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  /**
   * @summary Effect: maneja el overlay de loading de la grilla.
   * @description
   * Observa el signal `loadingCanalesPagoCobro()` y muestra/oculta
   * el overlay de loading de AG-Grid automáticamente.
   */
  private manejarLoadingEffect(): void {
    effect(() => {
      const loading = this.store.loadingCanalesPagoCobro();
      
      if (!this.gridApi) return;

      if (loading) {
        this.gridApi.showLoadingOverlay();
      } else {
        this.gridApi.hideOverlay();
      }
    });
  }
}
