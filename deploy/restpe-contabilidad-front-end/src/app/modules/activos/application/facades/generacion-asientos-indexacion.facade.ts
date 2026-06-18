import { Injectable, inject } from '@angular/core';
import { GeneracionAsientosIndexacionStore } from '../../store/generacion-asientos-indexacion.store';
import { ObtenerGeneracionAsientosIndexacionUseCase } from '../usecases/obtener-generacion-asientos-indexacion.usecase';
import { GuardarGeneracionAsientosIndexacionUseCase } from '../usecases/guardar-generacion-asientos-indexacion.usecase';
import { ActualizarGeneracionAsientosIndexacionUseCase } from '../usecases/actualizar-generacion-asientos-indexacion.usecase';
import { EliminarGeneracionAsientosIndexacionUseCase } from '../usecases/eliminar-generacion-asientos-indexacion.usecase';
import { GeneracionAsientosIndexacionEntity } from '../../domain/models/generacion-asientos-indexacion.entity';

@Injectable()
export class GeneracionAsientosIndexacionFacade {
  private readonly store        = inject(GeneracionAsientosIndexacionStore);
  private readonly obtenerUC    = inject(ObtenerGeneracionAsientosIndexacionUseCase);
  private readonly guardarUC    = inject(GuardarGeneracionAsientosIndexacionUseCase);
  private readonly actualizarUC = inject(ActualizarGeneracionAsientosIndexacionUseCase);
  private readonly eliminarUC   = inject(EliminarGeneracionAsientosIndexacionUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly asientos          = this.store.asientos;
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
  cargarAsientos(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setAsientos(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los asientos de indexación');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarAsiento(item: GeneracionAsientosIndexacionEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el asiento de indexación');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarAsiento(item: GeneracionAsientosIndexacionEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el asiento de indexación');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarAsiento(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el asiento de indexación');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
