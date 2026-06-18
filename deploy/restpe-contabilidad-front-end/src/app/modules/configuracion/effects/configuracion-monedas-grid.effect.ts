import { Injectable, inject, effect } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { ConfiguracionStore } from '../store/configuracion.store';
import { MonedaEntity } from '../domain/models/moneda.entity';

/**
 * @summary Effects para sincronización de grilla de monedas
 * @description
 * Maneja los efectos secundarios reactivos para la grilla AG-Grid de monedas:
 * - Actualiza rowData cuando cambian las monedas en el store
 * - Muestra/oculta overlay de loading según el estado de carga
 * 
 * Usa Angular Signals con `effect` para reactividad sin suscripciones manuales.
 * 
 * @example
 * ```ts
 * // En el componente
 * private readonly monedasGridEffects = inject(ConfiguracionMonedasGridEffects);
 * 
 * onGridReady(params: GridReadyEvent) {
 *   this.monedasGridEffects.setGridApi(params.api);
 * }
 * ```
 */
@Injectable()
export class ConfiguracionMonedasGridEffects {

  /** @summary Store reactivo con el estado de configuración (monedas + loading). */
  private readonly store = inject(ConfiguracionStore);

  /** @summary Referencia a la API de AG-Grid para manipulación reactiva. */
  private gridApi: GridApi | null = null;

  /** @summary Datos actuales de la grilla (rowData). */
  rowData: MonedaEntity[] = [];

  constructor() {
    // Effect 1: Actualizar rowData cuando cambian las monedas en el store
    effect(() => {
      const monedas = this.store.monedas();
      if (monedas.length > 0) {
        this.actualizarRowDataEffect(monedas);
      }
    });

    // Effect 2: Mostrar/ocultar overlay de loading
    effect(() => {
      const loading = this.store.loadingMonedas();
      this.manejarLoadingEffect(loading);
    });
  }

  /**
   * @summary Registra la API de AG-Grid para que los effects puedan manipularla.
   * @description Debe llamarse desde onGridReady del componente.
   */
  setGridApi(api: GridApi): void {
    this.gridApi = api;
    
    // Si ya está cargando cuando se registra la API, mostrar el overlay
    const loading = this.store.loadingMonedas();
    if (loading) {
      this.gridApi.showLoadingOverlay();
    }
  }

  /**
   * @summary Obtiene los datos actuales de la grilla.
   * @description Permite al componente acceder al rowData gestionado por el effect.
   */
  getRowData(): MonedaEntity[] {
    return this.rowData;
  }

  /**
   * @summary Actualiza los datos de la grilla localmente.
   * @description Permite al componente actualizar rowData después de operaciones CRUD.
   */
  setRowData(data: MonedaEntity[]): void {
    this.rowData = data;
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /**
   * @summary Effect que actualiza rowData cuando cambian las monedas en el store.
   * @param monedas - Nuevas monedas del store
   */
  private actualizarRowDataEffect(monedas: MonedaEntity[]): void {
    this.rowData = [...monedas];
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /**
   * @summary Effect que maneja el overlay de loading.
   * @param loading - Estado de carga actual
   */
  private manejarLoadingEffect(loading: boolean): void {
    if (!this.gridApi) return;

    if (loading) {
      this.gridApi.showLoadingOverlay();
    } else {
      this.gridApi.hideOverlay();
    }
  }
}
