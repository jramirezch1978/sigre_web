import { Injectable, inject } from '@angular/core';
import { AsignacionRatiosStore } from '../../store/asignacion-ratios.store';
import { ObtenerAsignacionRatiosUseCase } from '../usecases/asignacion-ratios/obtener-asignacion-ratios.usecase';
import { GuardarAsignacionRatiosUseCase } from '../usecases/asignacion-ratios/guardar-asignacion-ratios.usecase';
import { ActualizarAsignacionRatiosUseCase } from '../usecases/asignacion-ratios/actualizar-asignacion-ratios.usecase';
import { EliminarAsignacionRatiosUseCase } from '../usecases/asignacion-ratios/eliminar-asignacion-ratios.usecase';
import { AsignacionRatiosEntity } from '../../domain/models/asignacion-ratios.entity';

@Injectable()
export class AsignacionRatiosFacade {
  private readonly store        = inject(AsignacionRatiosStore);
  private readonly obtenerUC    = inject(ObtenerAsignacionRatiosUseCase);
  private readonly guardarUC    = inject(GuardarAsignacionRatiosUseCase);
  private readonly actualizarUC = inject(ActualizarAsignacionRatiosUseCase);
  private readonly eliminarUC   = inject(EliminarAsignacionRatiosUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly asignaciones      = this.store.asignaciones;
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
  cargarAsignaciones(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setAsignaciones(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las asignaciones');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarAsignacion(item: AsignacionRatiosEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar la asignación');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarAsignacion(item: AsignacionRatiosEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar la asignación');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarAsignacion(id: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(id).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar la asignación');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
