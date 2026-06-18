import { Injectable, inject, effect } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { ConfiguracionStore } from '../store/configuracion.store';
import { UsuarioEntity } from '../domain/models/usuario.entity';

/**
 * @summary Effects para sincronización de grilla de usuarios
 * @description
 * Maneja los efectos secundarios reactivos para la grilla AG-Grid de usuarios:
 * - Actualiza rowData cuando cambian los usuarios en el store
 * - Muestra/oculta overlay de loading según el estado de carga
 *
 * Usa Angular Signals con `effect` para reactividad sin suscripciones manuales.
 *
 * @example
 * ```ts
 * // En el componente
 * private readonly usuariosGridEffects = inject(ConfiguracionUsuariosGridEffects);
 *
 * onGridReady(params: GridReadyEvent) {
 *   this.usuariosGridEffects.setGridApi(params.api);
 * }
 * ```
 */
@Injectable()
export class ConfiguracionUsuariosGridEffects {

  /** @summary Store reactivo con el estado de configuración (usuarios + loading). */
  private readonly store = inject(ConfiguracionStore);

  /** @summary Referencia a la API de AG-Grid para manipulación reactiva. */
  private gridApi: GridApi | null = null;

  /** @summary Datos actuales de la grilla (rowData). */
  rowData: UsuarioEntity[] = [];

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
    const loading = this.store.loadingUsuarios();
    if (loading) {
      this.gridApi.showLoadingOverlay();
    }
  }

  /**
   * @summary Obtiene los datos actuales de la grilla.
   * @description Permite al componente acceder al rowData gestionado por el effect.
   */
  getRowData(): UsuarioEntity[] {
    return this.rowData;
  }

  /**
   * @summary Actualiza los datos de la grilla localmente.
   * @description Permite al componente actualizar rowData después de operaciones CRUD.
   */
  setRowData(data: UsuarioEntity[]): void {
    this.rowData = data;
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  /**
   * @summary Effect: actualiza rowData cuando cambian los usuarios en el store.
   * @description
   * Observa el signal `usuarios()` del store y actualiza automáticamente
   * la grilla cuando los datos cambian. No requiere suscripciones manuales.
   */
  private actualizarRowDataEffect(): void {
    effect(() => {
      const usuarios = this.store.usuarios();
      this.rowData = usuarios;

      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });
  }

  /**
   * @summary Effect: maneja el overlay de loading de la grilla.
   * @description
   * Observa el signal `loadingUsuarios()` y muestra/oculta
   * el overlay de carga de AG-Grid reactivamente.
   */
  private manejarLoadingEffect(): void {
    effect(() => {
      const loading = this.store.loadingUsuarios();

      if (!this.gridApi) return;

      if (loading) {
        this.gridApi.showLoadingOverlay();
      } else {
        this.gridApi.hideOverlay();
      }
    });
  }
}
