import { Injectable, inject, effect } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { ConfiguracionStore } from '../store/configuracion.store';
import { CuentaBancariaEntity } from '../domain/models/cuenta-bancaria.entity';

/**
 * @summary Effects para sincronización de grilla de cuentas bancarias
 * @description
 * Maneja los efectos secundarios reactivos para la grilla AG-Grid de cuentas bancarias:
 * - Actualiza rowData cuando cambian las cuentas en el store
 * - Muestra/oculta overlay de loading según el estado de carga
 * 
 * Usa Angular Signals con `effect` para reactividad sin suscripciones manuales.
 * 
 * @example
 * ```ts
 * // En el componente
 * private readonly cuentasGridEffects = inject(ConfiguracionCuentasBancariasGridEffects);
 * 
 * onGridReady(params: GridReadyEvent) {
 *   this.cuentasGridEffects.setGridApi(params.api);
 * }
 * ```
 */
@Injectable()
export class ConfiguracionCuentasBancariasGridEffects {

  /** @summary Store reactivo con el estado de configuración (cuentas bancarias + loading). */
  private readonly store = inject(ConfiguracionStore);

  /** @summary Referencia a la API de AG-Grid para manipulación reactiva. */
  private gridApi: GridApi | null = null;

  /** @summary Datos actuales de la grilla (rowData). */
  rowData: CuentaBancariaEntity[] = [];

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
    const loading = this.store.loadingCuentasBancarias();
    if (loading) {
      this.gridApi.showLoadingOverlay();
    }
  }

  /**
   * @summary Obtiene los datos actuales de la grilla.
   * @description Permite al componente acceder al rowData gestionado por el effect.
   */
  getRowData(): CuentaBancariaEntity[] {
    return this.rowData;
  }

  /**
   * @summary Actualiza manualmente los datos de la grilla.
   * @description Permite al componente realizar operaciones CRUD locales.
   */
  setRowData(data: CuentaBancariaEntity[]): void {
    this.rowData = data;
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /**
   * @summary Effect: actualiza rowData cuando cambian las cuentas en el store.
   * @description
   * Observa el signal `cuentasBancarias()` del store y actualiza automáticamente
   * la grilla cuando los datos cambian. No requiere suscripciones manuales.
   */
  private actualizarRowDataEffect(): void {
    effect(() => {
      const cuentas = this.store.cuentasBancarias();
      this.rowData = [...cuentas].reverse();
      
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  /**
   * @summary Effect: muestra/oculta loading overlay según estado de carga.
   * @description
   * Observa el signal `loadingCuentasBancarias()` del store y muestra automáticamente
   * el overlay de carga en la grilla. Sincroniza estado reactivo con UI.
   */
  private manejarLoadingEffect(): void {
    effect(() => {
      const loading = this.store.loadingCuentasBancarias();
      
      if (!this.gridApi) return;

      if (loading) {
        this.gridApi.showLoadingOverlay();
      } else {
        this.gridApi.hideOverlay();
      }
    });
  }
}
