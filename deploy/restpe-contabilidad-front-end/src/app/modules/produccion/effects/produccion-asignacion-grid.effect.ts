import { Injectable, inject, effect } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { ProduccionStore } from '../store/produccion.store';
import { ReglaAsignacionEntity } from '../domain/models/regla-asignacion.entity';

/**
 * @summary Effects para sincronización de grilla de asignación de gastos indirectos
 * @description
 * Maneja los efectos secundarios reactivos para la grilla AG-Grid de reglas de asignación:
 * - Actualiza rowData cuando cambian las reglas en el store
 * - Muestra/oculta overlay de loading según el estado de carga
 *
 * Usa Angular Signals con `effect` para reactividad sin suscripciones manuales.
 *
 * @example
 * ```ts
 * // En el componente
 * private readonly asignacionGridEffects = inject(ProduccionAsignacionGridEffects);
 *
 * onGridReady(params: GridReadyEvent) {
 *   this.asignacionGridEffects.setGridApi(params.api);
 * }
 * ```
 */
@Injectable()
export class ProduccionAsignacionGridEffects {

  /** @summary Store reactivo con el estado de producción (reglas + loading). */
  private readonly store = inject(ProduccionStore);

  /** @summary Referencia a la API de AG-Grid para manipulación reactiva. */
  private gridApi: GridApi | null = null;

  /** @summary Datos actuales de la grilla (rowData). */
  rowData: ReglaAsignacionEntity[] = [];

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
    if (this.store.loadingReglasAsignacion()) {
      this.gridApi.showLoadingOverlay();
    }
  }

  /**
   * @summary Obtiene los datos actuales de la grilla.
   */
  getRowData(): ReglaAsignacionEntity[] {
    return this.rowData;
  }

  /**
   * @summary Actualiza los datos de la grilla localmente.
   * @description Permite al componente actualizar rowData después de operaciones CRUD.
   */
  setRowData(data: ReglaAsignacionEntity[]): void {
    this.rowData = data;
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /**
   * @summary Effect: actualiza rowData cuando cambian las reglas en el store.
   */
  private actualizarRowDataEffect(): void {
    effect(() => {
      const reglas = this.store.reglasAsignacion();
      this.rowData = reglas;

      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  /**
   * @summary Effect: maneja el overlay de loading de la grilla.
   */
  private manejarLoadingEffect(): void {
    effect(() => {
      const loading = this.store.loadingReglasAsignacion();

      if (!this.gridApi) return;

      if (loading) {
        this.gridApi.showLoadingOverlay();
      } else {
        this.gridApi.hideOverlay();
      }
    });
  }
}
