import { Injectable, inject } from '@angular/core';
import { ClasifActivoEntity } from '../../domain/models/clasif-activo.entity';
import { ClasifActivoStore } from '../../store/clasif-activo.store';
import { ObtenerClasifActivosUseCase } from '../usecases/obtener-clasif-activos.usecase';
import { GuardarClasifActivoUseCase } from '../usecases/guardar-clasif-activo.usecase';
import { ActualizarClasifActivoUseCase } from '../usecases/actualizar-clasif-activo.usecase';
import { EliminarClasifActivoUseCase } from '../usecases/eliminar-clasif-activo.usecase';

/**
 * Facade de Clasificación de Activos.
 * Punto de entrada único para el componente: orquesta use cases y actualiza el store.
 */
@Injectable()
export class ClasifActivoFacade {

  private readonly store = inject(ClasifActivoStore);

  private readonly obtenerUC    = inject(ObtenerClasifActivosUseCase);
  private readonly guardarUC    = inject(GuardarClasifActivoUseCase);
  private readonly actualizarUC = inject(ActualizarClasifActivoUseCase);
  private readonly eliminarUC   = inject(EliminarClasifActivoUseCase);

  // ─────────── Selectores expuestos al componente ───────────
  readonly clasifsActivo       = this.store.clasifsActivo;
  readonly clasifSeleccionada  = this.store.clasifSeleccionada;
  readonly isLoading           = this.store.isLoading;
  readonly loadingObtener      = this.store.loadingObtener;
  readonly loadingGuardar      = this.store.loadingGuardar;
  readonly loadingEliminar     = this.store.loadingEliminar;
  readonly loadingActualizar   = this.store.loadingActualizar;
  readonly errorObtener        = this.store.errorObtener;
  readonly errorGuardar        = this.store.errorGuardar;
  readonly errorEliminar       = this.store.errorEliminar;
  readonly errorActualizar     = this.store.errorActualizar;
  readonly resultGuardar       = this.store.resultGuardar;
  readonly resultEliminar      = this.store.resultEliminar;
  readonly resultActualizar    = this.store.resultActualizar;

  // ─────────── Acciones ───────────

  cargarClasifActivos(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (clasifsActivo: ClasifActivoEntity[]) => {
        this.store.setClasifsActivo(clasifsActivo);
        this.store.setLoadingObtener(false);
      },
      error: (err: Error) => {
        this.store.setErrorObtener(err.message ?? 'Error al cargar clasificación de activos');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarClasifActivo(clasif: ClasifActivoEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(clasif).subscribe({
      next: (result) => {
        this.store.setResultGuardar(result);
        this.store.setLoadingGuardar(false);
      },
      error: (err: Error) => {
        this.store.setErrorGuardar(err.message ?? 'Error al guardar clasificación');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarClasifActivo(clasif: ClasifActivoEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(clasif).subscribe({
      next: (result) => {
        this.store.setResultActualizar(result);
        this.store.setLoadingActualizar(false);
      },
      error: (err: Error) => {
        this.store.setErrorActualizar(err.message ?? 'Error al actualizar clasificación');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarClasifActivo(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (result) => {
        this.store.setResultEliminar(result);
        this.store.setLoadingEliminar(false);
      },
      error: (err: Error) => {
        this.store.setErrorEliminar(err.message ?? 'Error al eliminar clasificación');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
