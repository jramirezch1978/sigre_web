import { Injectable, inject } from '@angular/core';
import { NumActivoStore } from '../../store/num-activo.store';
import { ObtenerNumActivoUseCase } from '../usecases/obtener-num-activo.usecase';
import { GuardarNumActivoUseCase } from '../usecases/guardar-num-activo.usecase';
import { ActualizarNumActivoUseCase } from '../usecases/actualizar-num-activo.usecase';
import { EliminarNumActivoUseCase } from '../usecases/eliminar-num-activo.usecase';
import { NumActivoEntity } from '../../domain/models/num-activo.entity';

@Injectable()
export class NumActivoFacade {
  private readonly store        = inject(NumActivoStore);
  private readonly obtenerUC    = inject(ObtenerNumActivoUseCase);
  private readonly guardarUC    = inject(GuardarNumActivoUseCase);
  private readonly actualizarUC = inject(ActualizarNumActivoUseCase);
  private readonly eliminarUC   = inject(EliminarNumActivoUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly numActivos        = this.store.numActivos;
  readonly isLoading         = this.store.isLoading;

  readonly loadingObtener    = this.store.loadingObtener;
  readonly loadingGuardar    = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly loadingEliminar   = this.store.loadingEliminar;

  readonly errorGuardar      = this.store.errorGuardar;
  readonly errorActualizar   = this.store.errorActualizar;
  readonly errorEliminar     = this.store.errorEliminar;

  readonly resultGuardar     = this.store.resultGuardar;
  readonly resultActualizar  = this.store.resultActualizar;
  readonly resultEliminar    = this.store.resultEliminar;

  // ── Acciones ────────────────────────────────────────────────────────────────
  cargarNumActivos(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setNumActivos(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los numeradores de activos');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarNumActivo(numActivo: NumActivoEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(numActivo).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el numerador de activo');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarNumActivo(numActivo: NumActivoEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(numActivo).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el numerador de activo');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarNumActivo(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el numerador de activo');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
