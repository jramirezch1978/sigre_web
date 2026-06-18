import { Injectable, inject, effect } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { ConfiguracionStore } from '../store/configuracion.store';
import { EjercicioFiscalEntity } from '../domain/models/ejercicio-fiscal.entity';

/**
 * @summary Effects para sincronización de grilla de ejercicios fiscales
 * @description
 * Maneja los efectos secundarios reactivos para la grilla AG-Grid de ejercicios fiscales:
 * - Actualiza rowData cuando cambian los ejercicios en el store
 * - Muestra/oculta overlay de loading según el estado de carga
 * 
 * Usa Angular Signals con `effect` para reactividad sin suscripciones manuales.
 * 
 * @example
 * ```ts
 * // En el componente
 * private readonly ejerciciosGridEffects = inject(ConfiguracionEjerciciosFiscalesGridEffects);
 * 
 * onGridReady(params: GridReadyEvent) {
 *   this.ejerciciosGridEffects.setGridApi(params.api);
 * }
 * ```
 */
@Injectable()
export class ConfiguracionEjerciciosFiscalesGridEffects {

  /** @summary Store reactivo con el estado de configuración (ejercicios fiscales + loading). */
  private readonly store = inject(ConfiguracionStore);

  /** @summary Referencia a la API de AG-Grid para manipulación reactiva. */
  private gridApi: GridApi | null = null;

  /** @summary Datos actuales de la grilla (rowData). */
  rowData: EjercicioFiscalEntity[] = [];

  constructor() {
    // Effect 1: Actualizar rowData cuando cambian los ejercicios en el store
    effect(() => {
      const ejercicios = this.store.ejerciciosFiscales();
      if (ejercicios.length > 0) {
        this.actualizarRowDataEffect(ejercicios);
      }
    });

    // Effect 2: Mostrar/ocultar overlay de loading
    effect(() => {
      const loading = this.store.loadingEjerciciosFiscales();
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
    const loading = this.store.loadingEjerciciosFiscales();
    if (loading) {
      this.gridApi.showLoadingOverlay();
    }
  }

  /**
   * @summary Obtiene los datos actuales de la grilla.
   * @description Permite al componente acceder al rowData gestionado por el effect.
   */
  getRowData(): EjercicioFiscalEntity[] {
    return this.rowData;
  }

  /**
   * @summary Actualiza los datos de la grilla localmente.
   * @description Permite al componente actualizar rowData después de operaciones CRUD.
   */
  setRowData(data: EjercicioFiscalEntity[]): void {
    this.rowData = data;
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /**
   * @summary Effect que actualiza rowData cuando cambian los ejercicios en el store.
   * @param ejercicios - Nuevos ejercicios fiscales del store
   */
  private actualizarRowDataEffect(ejercicios: EjercicioFiscalEntity[]): void {
    this.rowData = [...ejercicios];
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
