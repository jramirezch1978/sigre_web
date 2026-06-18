import { Injectable, inject } from '@angular/core';
import { ResumenRangosStore } from '../../store/resumen-rangos.store';
import { ObtenerResumenRangosUseCase } from '../usecases/obtener-resumen-rangos.usecase';
import { GuardarResumenRangosUseCase } from '../usecases/guardar-resumen-rangos.usecase';
import { ActualizarResumenRangosUseCase } from '../usecases/actualizar-resumen-rangos.usecase';
import { EliminarResumenRangosUseCase } from '../usecases/eliminar-resumen-rangos.usecase';
import { ResumenRangosEntity } from '../../domain/models/resumen-rangos.entity';

@Injectable()
export class ResumenRangosFacade {
  private readonly store        = inject(ResumenRangosStore);
  private readonly obtenerUC    = inject(ObtenerResumenRangosUseCase);
  private readonly guardarUC    = inject(GuardarResumenRangosUseCase);
  private readonly actualizarUC = inject(ActualizarResumenRangosUseCase);
  private readonly eliminarUC   = inject(EliminarResumenRangosUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly rangos            = this.store.rangos;
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
  cargarRangos(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setRangos(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener el resumen de rangos');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarRango(item: ResumenRangosEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el rango de activo');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarRango(item: ResumenRangosEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el rango de activo');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarRango(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el rango de activo');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
