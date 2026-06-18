import { effect, inject, Injectable } from "@angular/core";
import { AlmacenStore } from "../store/almacen.store";
import { AlmacenFacade } from "../application/facades/almacen.facade";

/**
 * @summary Efectos de sincronización local para almacenes.
 * @description
 * Estos effects implementan el patrón feedback: reaccionan automáticamente a cambios
 * en el estado (signals) y disparan acciones secundarias (cargar datos) cuando detectan
 * que una operación relevante (guardar/eliminar/actualizar) fue exitosa.
 *
 * - `effect` de Angular Signals: ejecuta la función cada vez que cambian los signals leídos.
 * - Aquí, cuando resultGuardar/resultEliminar/resultActualizar cambian a un valor truthy, se recarga la lista.
 * - No se usan callbacks ni suscripciones manuales: todo es reactivo y declarativo.
 *
 * @example
 * ```ts
 * // En el módulo
 * providers: [AlmacenSyncEffects]
 * 
 * // El effect se ejecuta automáticamente al cambiar el estado
 * ```
 */

@Injectable()
export class AlmacenSyncEffects {
  private readonly store = inject(AlmacenStore);
  private readonly facade = inject(AlmacenFacade);

  constructor() {
    this.refrescarDespuesDeGuardar();
    this.refrescarDespuesDeEliminar();
    this.refrescarDespuesDeActualizar();
  }

  /**
   * @summary Recarga almacenes tras guardar exitosamente.
   * @description
   * Cuando el resultado de guardar cambia (feedback), se recarga la lista de almacenes
   * para reflejar el estado actualizado. No requiere suscripciones manuales.
   */
  private refrescarDespuesDeGuardar() {
    effect(() => {
      if (this.store.resultGuardar()) {
        this.facade.cargarAlmacenes();
      }
    });
  }

  /**
   * @summary Recarga almacenes tras eliminar exitosamente.
   * @description
   * Cuando el resultado de eliminar cambia (feedback), se recarga la lista de almacenes
   * para reflejar el estado actualizado. No requiere suscripciones manuales.
   */
  private refrescarDespuesDeEliminar() {
    effect(() => {
      if (this.store.resultEliminar()) {
        this.facade.cargarAlmacenes();
      }
    });
  }

  /**
   * @summary Recarga almacenes tras actualizar exitosamente.
   * @description
   * Cuando el resultado de actualizar cambia (feedback), se recarga la lista de almacenes
   * para reflejar el estado actualizado. No requiere suscripciones manuales.
   */
  private refrescarDespuesDeActualizar() {
    effect(() => {
      if (this.store.resultActualizar()) {
        this.facade.cargarAlmacenes();
      }
    });
  }
}
