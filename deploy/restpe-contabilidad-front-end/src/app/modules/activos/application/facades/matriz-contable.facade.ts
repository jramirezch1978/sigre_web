import { Injectable, inject } from '@angular/core';
import { MatrizContableStore } from '../../store/matriz-contable.store';
import { ObtenerMatrizContableUseCase } from '../usecases/obtener-matriz-contable.usecase';
import { GuardarMatrizContableUseCase } from '../usecases/guardar-matriz-contable.usecase';
import { ActualizarMatrizContableUseCase } from '../usecases/actualizar-matriz-contable.usecase';
import { EliminarMatrizContableUseCase } from '../usecases/eliminar-matriz-contable.usecase';
import { MatrizContableEntity } from '../../domain/models/matriz-contable.entity';

@Injectable()
export class MatrizContableFacade {
  private readonly store        = inject(MatrizContableStore);
  private readonly obtenerUC    = inject(ObtenerMatrizContableUseCase);
  private readonly guardarUC    = inject(GuardarMatrizContableUseCase);
  private readonly actualizarUC = inject(ActualizarMatrizContableUseCase);
  private readonly eliminarUC   = inject(EliminarMatrizContableUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly matrizContable       = this.store.matrizContable;
  readonly isLoading            = this.store.isLoading;

  readonly loadingObtener       = this.store.loadingObtener;
  readonly loadingGuardar       = this.store.loadingGuardar;
  readonly loadingActualizar    = this.store.loadingActualizar;
  readonly loadingEliminar      = this.store.loadingEliminar;

  readonly errorGuardar         = this.store.errorGuardar;
  readonly errorActualizar      = this.store.errorActualizar;
  readonly errorEliminar        = this.store.errorEliminar;
  readonly errorObtener         = this.store.errorObtener;

  readonly resultGuardar        = this.store.resultGuardar;
  readonly resultActualizar     = this.store.resultActualizar;
  readonly resultEliminar       = this.store.resultEliminar;

  // ── Acciones ────────────────────────────────────────────────────────────────
  cargarMatrizContable(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setMatrizContable(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener la matriz contable');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarMatriz(matriz: MatrizContableEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(matriz).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar la matriz contable');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarMatriz(matriz: MatrizContableEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(matriz).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar la matriz contable');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarMatriz(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar la matriz contable');
        this.store.setLoadingEliminar(false);
      },
    });
  }

   limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorGuardar(null);
    this.store.setErrorActualizar(null);
    this.store.setErrorEliminar(null);
  }
}
