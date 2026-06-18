import { Injectable, inject } from '@angular/core';
import { AprobacionTrasladoStore } from '../../store/aprobacion-traslado.store';
import { ObtenerAprobacionTrasladoUseCase } from '../usecases/aprobacion-traslado/obtener-aprobacion-traslado.usecase';
import { GuardarAprobacionTrasladoUseCase } from '../usecases/aprobacion-traslado/guardar-aprobacion-traslado.usecase';
import { ActualizarAprobacionTrasladoUseCase } from '../usecases/aprobacion-traslado/actualizar-aprobacion-traslado.usecase';
import { EliminarAprobacionTrasladoUseCase } from '../usecases/aprobacion-traslado/eliminar-aprobacion-traslado.usecase';
import { AprobacionTrasladoEntity } from '../../domain/models/aprobacion-traslado.entity';

@Injectable()
export class AprobacionTrasladoFacade {
  private readonly store        = inject(AprobacionTrasladoStore);
  private readonly obtenerUC    = inject(ObtenerAprobacionTrasladoUseCase);
  private readonly guardarUC    = inject(GuardarAprobacionTrasladoUseCase);
  private readonly actualizarUC = inject(ActualizarAprobacionTrasladoUseCase);
  private readonly eliminarUC   = inject(EliminarAprobacionTrasladoUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly traslados         = this.store.traslados;
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
  cargarTraslados(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setTraslados(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los traslados');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarTraslado(item: AprobacionTrasladoEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el traslado');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarTraslado(item: AprobacionTrasladoEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el traslado');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarTraslado(id: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(id).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el traslado');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
