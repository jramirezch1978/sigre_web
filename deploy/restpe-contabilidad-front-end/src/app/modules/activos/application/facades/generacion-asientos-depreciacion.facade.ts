import { Injectable, inject } from '@angular/core';
import { GeneracionAsientosDepreciacionStore } from '../../store/generacion-asientos-depreciacion.store';
import { ObtenerGeneracionAsientosDepreciacionUseCase } from '../usecases/obtener-generacion-asientos-depreciacion.usecase';
import { GuardarGeneracionAsientosDepreciacionUseCase } from '../usecases/guardar-generacion-asientos-depreciacion.usecase';
import { ActualizarGeneracionAsientosDepreciacionUseCase } from '../usecases/actualizar-generacion-asientos-depreciacion.usecase';
import { EliminarGeneracionAsientosDepreciacionUseCase } from '../usecases/eliminar-generacion-asientos-depreciacion.usecase';
import { GeneracionAsientosDepreciacionEntity } from '../../domain/models/generacion-asientos-depreciacion.entity';

@Injectable()
export class GeneracionAsientosDepreciacionFacade {
  private readonly store        = inject(GeneracionAsientosDepreciacionStore);
  private readonly obtenerUC    = inject(ObtenerGeneracionAsientosDepreciacionUseCase);
  private readonly guardarUC    = inject(GuardarGeneracionAsientosDepreciacionUseCase);
  private readonly actualizarUC = inject(ActualizarGeneracionAsientosDepreciacionUseCase);
  private readonly eliminarUC   = inject(EliminarGeneracionAsientosDepreciacionUseCase);

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
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los asientos de depreciación');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarAsiento(item: GeneracionAsientosDepreciacionEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el asiento de depreciación');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarAsiento(item: GeneracionAsientosDepreciacionEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el asiento de depreciación');
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
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el asiento de depreciación');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
