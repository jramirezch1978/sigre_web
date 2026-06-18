import { Injectable, inject } from '@angular/core';
import {
  ObtenerActivosFijosUseCase,
  GuardarActivoFijoUseCase,
  ActualizarActivoFijoUseCase,
  EliminarActivoFijoUseCase,
} from '../usecases';
import { ActivoFijoEntity } from '../../domain/models/activo-fijo.entity';
import { ActivoFijoStore } from '../../store/activo-fijo.store';

/**
 * Facade de Activos Fijos.
 * Punto de entrada único para el componente: orquesta use cases y actualiza el store.
 */
@Injectable()
export class ActivoFijoFacade {

  private readonly store = inject(ActivoFijoStore);

  private readonly obtenerUC    = inject(ObtenerActivosFijosUseCase);
  private readonly guardarUC    = inject(GuardarActivoFijoUseCase);
  private readonly actualizarUC = inject(ActualizarActivoFijoUseCase);
  private readonly eliminarUC   = inject(EliminarActivoFijoUseCase);

  // ────────── Selectores expuestos al componente ──────────
  readonly activosFijos       = this.store.activosFijos;
  readonly activoSeleccionado = this.store.activoSeleccionado;
  readonly isLoading          = this.store.isLoading;
  readonly loadingObtener     = this.store.loadingObtener;
  readonly loadingGuardar     = this.store.loadingGuardar;
  readonly loadingEliminar    = this.store.loadingEliminar;
  readonly loadingActualizar  = this.store.loadingActualizar;
  readonly errorObtener       = this.store.errorObtener;
  readonly errorGuardar       = this.store.errorGuardar;
  readonly errorEliminar      = this.store.errorEliminar;
  readonly errorActualizar    = this.store.errorActualizar;
  readonly resultGuardar      = this.store.resultGuardar;
  readonly resultEliminar     = this.store.resultEliminar;
  readonly resultActualizar   = this.store.resultActualizar;

  // ────────── Acciones ──────────

  cargarActivosFijos(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (activosFijos: ActivoFijoEntity[]) => {
        this.store.setActivosFijos(activosFijos);
        this.store.setLoadingObtener(false);
      },
      error: (err: Error) => {
        this.store.setErrorObtener(err.message ?? 'Error al cargar activos fijos');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarActivoFijo(activo: ActivoFijoEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(activo).subscribe({
      next: (result) => {
        this.store.setResultGuardar(result);
        this.store.setLoadingGuardar(false);
      },
      error: (err: Error) => {
        this.store.setErrorGuardar(err.message ?? 'Error al guardar activo fijo');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarActivoFijo(activo: ActivoFijoEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(activo).subscribe({
      next: (result) => {
        this.store.setResultActualizar(result);
        this.store.setLoadingActualizar(false);
      },
      error: (err: Error) => {
        this.store.setErrorActualizar(err.message ?? 'Error al actualizar activo fijo');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarActivoFijo(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (result) => {
        this.store.setResultEliminar(result);
        this.store.setLoadingEliminar(false);
      },
      error: (err: Error) => {
        this.store.setErrorEliminar(err.message ?? 'Error al eliminar activo fijo');
        this.store.setLoadingEliminar(false);
      },
    });
  }

  seleccionarActivo(activo: ActivoFijoEntity | null): void {
    this.store.setActivoSeleccionado(activo);
  }

  resetResultados(): void {
    this.store.resetResultados();
  }
}
