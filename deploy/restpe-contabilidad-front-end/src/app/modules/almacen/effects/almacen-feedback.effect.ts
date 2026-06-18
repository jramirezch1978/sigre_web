import { Injectable, inject, effect, untracked } from '@angular/core';
import { AlmacenStore } from '../store/almacen.store';
import { ToastService } from '../../../ui/services/toast.service';
import { ALMACEN_MENSAJES_FALLBACK } from '../constants/almacen.constants';
import { obtenerMensajeConFallback } from '../../../core/utils/api-response.util';

/**
 * @summary Effects de feedback para operaciones de almacén
 * @description
 * Maneja los efectos secundarios de las operaciones CRUD de almacenes:
 * - Muestra toasts de éxito/error
 * - Ejecuta callbacks post-operación
 * - Limpia el estado del store para evitar loops
 * 
 * Usa Angular Signals con `effect` para reactividad sin suscripciones manuales.
 */
@Injectable()
export class AlmacenFeedbackEffects {

  /** @summary Store reactivo con el estado de almacenes (CRUD + errores + loading). */
  private readonly store = inject(AlmacenStore);

  /** @summary Servicio UI para notificaciones tipo toast (éxito/error). */
  private readonly toast = inject(ToastService);

  /** @summary Callbacks configurados por el componente para post-éxito. */
  private onGuardarExitoCallback?: () => void;
  private onEliminarExitoCallback?: () => void;
  private onActualizarExitoCallback?: () => void;

  constructor() {
    this.guardarEffect();
    this.eliminarEffect();
    this.actualizarEffect();
    this.obtenerEffect();
  }

  /**
   * @summary Registra callbacks desde el componente sin necesidad de suscripciones.
   * @description Estos callbacks se ejecutan solo en caso de éxito, permitiendo
   * que el componente reaccione sin mantener `subscribe()` ni fugas de memoria.
   */
  registrarCallbacks(callbacks: {
    onGuardarExito?: () => void;
    onEliminarExito?: () => void;
    onActualizarExito?: () => void;
  }): void {
    this.onGuardarExitoCallback = callbacks.onGuardarExito;
    this.onEliminarExitoCallback = callbacks.onEliminarExito;
    this.onActualizarExitoCallback = callbacks.onActualizarExito;
  }

  // ---------------------------------------------------------------------------
  // HELPERS PRIVADOS
  // ---------------------------------------------------------------------------

  /**
   * @summary Maneja un flujo de éxito (UI + callback + reset del store).
   * @description
   * 1. Muestra toast de éxito  
   * 2. Ejecuta callback del componente (si existe)  
   * 3. Limpia el estado para evitar 'loops' del effect  
   */
  private manejarExito(mensaje: string, callback?: () => void, resetFn?: () => void): void {
    this.toast.success(mensaje);
    callback?.();
    resetFn?.();
  }

  /**
   * @summary Maneja un flujo de error centralizado.
   * @description Muestra mensaje de error y resetea estado asociado.
   */
  private manejarError(mensaje: string, resetFn?: () => void): void {
    this.toast.danger(mensaje);
    resetFn?.();
  }

  // ---------------------------------------------------------------------------
  // EFFECT 1: GUARDAR ALMACÉN
  // ---------------------------------------------------------------------------

  /**
   * @summary Effect: reacción automática a cambios de signals (Angular Signals)
   * @description
   * Un `effect` en Angular Signals es una función reactiva que se ejecuta automáticamente
   * cada vez que cambian los signals que lee dentro de su cuerpo. Es ideal para efectos
   * secundarios como mostrar toasts, navegar, o resetear estado, sin necesidad de subscribirse manualmente.
   *
   * En este caso, el effect observa el resultado y error del guardado de almacén:
   * - Si `resultGuardar()` emite → muestra mensaje de éxito, ejecuta callback y limpia el estado.
   * - Si `errorGuardar()` emite → muestra mensaje de error y limpia el error.
   *
   * Uso de `untracked`:
   * - `untracked` ejecuta una función sin que sus lecturas de signals disparen re-ejecuciones del effect.
   * - Aquí se usa para evitar loops infinitos: al resetear el estado dentro del effect, no queremos que eso vuelva a disparar el mismo effect.
   */
  private guardarEffect(): void {
    effect(() => {
      const resultado = this.store.resultGuardar();
      const error = this.store.errorGuardar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(resultado, ALMACEN_MENSAJES_FALLBACK.GUARDADO_DESCRIPCION);
          this.manejarExito(mensaje, this.onGuardarExitoCallback, () => this.store.setGuardarResultado(null));
        });
      }

      if (error) {
        untracked(() => {
          this.manejarError(error, () => this.store.setErrorGuardar(null));
        });
      }
    });
  }

  // ---------------------------------------------------------------------------
  // EFFECT 2: ELIMINAR ALMACÉN
  // ---------------------------------------------------------------------------

  /**
   * @summary Effect: reacción automática a la eliminación de almacén
   * @description
   * Este effect sigue el mismo patrón que el de guardar:
   * - Observa el resultado y error de la eliminación.
   * - Si hay éxito, muestra mensaje (backend o fallback), ejecuta callback y limpia el estado.
   * - Si hay error, muestra mensaje y limpia el error.
   *
   * Uso de `untracked`:
   * - Permite resetear el resultado sin que eso vuelva a disparar el effect.
   * - Así se evita un ciclo infinito de reacciones.
   */
  private eliminarEffect(): void {
    effect(() => {
      const resultado = this.store.resultEliminar();
      const error = this.store.errorEliminar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(resultado, ALMACEN_MENSAJES_FALLBACK.ELIMINADO_DESCRIPCION);
          this.manejarExito(mensaje, this.onEliminarExitoCallback, () => this.store.setEliminarResultado(null));
        });
      }

      if (error) {
        untracked(() => {
          this.manejarError(error, () => this.store.setErrorEliminar(null));
        });
      }
    });
  }

  // ---------------------------------------------------------------------------
  // EFFECT 3: ACTUALIZAR ALMACÉN
  // ---------------------------------------------------------------------------

  /**
   * @summary Effect: reacción automática a la actualización de almacén
   * @description
   * Este effect maneja el feedback de actualización:
   * - Observa el resultado y error de la actualización.
   * - Si hay éxito, muestra mensaje (backend o fallback), ejecuta callback y limpia el estado.
   * - Si hay error, muestra mensaje y limpia el error.
   */
  private actualizarEffect(): void {
    effect(() => {
      const resultado = this.store.resultActualizar();
      const error = this.store.errorActualizar();

      if (resultado) {
        untracked(() => {
          const mensaje = obtenerMensajeConFallback(resultado, ALMACEN_MENSAJES_FALLBACK.ACTUALIZADO_DESCRIPCION);
          this.manejarExito(mensaje, this.onActualizarExitoCallback, () => this.store.setActualizarResultado(null));
        });
      }

      if (error) {
        untracked(() => {
          this.manejarError(error, () => this.store.setErrorActualizar(null));
        });
      }
    });
  }

  // ---------------------------------------------------------------------------
  // EFFECT 4: OBTENER ALMACENES
  // ---------------------------------------------------------------------------

  /**
   * @summary Effect: manejo de errores al cargar almacenes
   * @description
   * Este effect solo maneja errores al cargar almacenes.
   * No muestra mensaje de éxito al cargar (para evitar toasts innecesarios).
   */
  private obtenerEffect(): void {
    effect(() => {
      const error = this.store.errorObtener();

      if (error) {
        untracked(() => {
          this.manejarError(error, () => this.store.setErrorObtener(null));
        });
      }
    });
  }
}
