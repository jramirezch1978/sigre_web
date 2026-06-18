import { Injectable, inject } from '@angular/core';
import { ResumenActivoFijoStore } from '../../store/resumen-activo-fijo.store';
import { ObtenerResumenActivoFijoUseCase } from '../usecases/obtener-resumen-activo-fijo.usecase';
import { GuardarResumenActivoFijoUseCase } from '../usecases/guardar-resumen-activo-fijo.usecase';
import { ActualizarResumenActivoFijoUseCase } from '../usecases/actualizar-resumen-activo-fijo.usecase';
import { EliminarResumenActivoFijoUseCase } from '../usecases/eliminar-resumen-activo-fijo.usecase';
import { ResumenActivoFijoEntity } from '../../domain/models/resumen-activo-fijo.entity';

@Injectable()
export class ResumenActivoFijoFacade {
  private readonly store        = inject(ResumenActivoFijoStore);
  private readonly obtenerUC    = inject(ObtenerResumenActivoFijoUseCase);
  private readonly guardarUC    = inject(GuardarResumenActivoFijoUseCase);
  private readonly actualizarUC = inject(ActualizarResumenActivoFijoUseCase);
  private readonly eliminarUC   = inject(EliminarResumenActivoFijoUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly resumenes         = this.store.resumenes;
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
  cargarResumenes(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setResumenes(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener el resumen de activos fijos');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarResumen(item: ResumenActivoFijoEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el registro');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarResumen(item: ResumenActivoFijoEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el registro');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarResumen(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el registro');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
