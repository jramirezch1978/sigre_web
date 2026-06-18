import { Injectable, inject } from '@angular/core';
import { GeneracionAsientosSiniestroStore } from '../../store/generacion-asientos-siniestro.store';
import { ObtenerGeneracionAsientosSiniestroUseCase } from '../usecases/obtener-generacion-asientos-siniestro.usecase';
import { GuardarGeneracionAsientosSiniestroUseCase } from '../usecases/guardar-generacion-asientos-siniestro.usecase';
import { ActualizarGeneracionAsientosSiniestroUseCase } from '../usecases/actualizar-generacion-asientos-siniestro.usecase';
import { EliminarGeneracionAsientosSiniestroUseCase } from '../usecases/eliminar-generacion-asientos-siniestro.usecase';
import { GeneracionAsientosSiniestroEntity } from '../../domain/models/generacion-asientos-siniestro.entity';

@Injectable()
export class GeneracionAsientosSiniestroFacade {
  private readonly store        = inject(GeneracionAsientosSiniestroStore);
  private readonly obtenerUC    = inject(ObtenerGeneracionAsientosSiniestroUseCase);
  private readonly guardarUC    = inject(GuardarGeneracionAsientosSiniestroUseCase);
  private readonly actualizarUC = inject(ActualizarGeneracionAsientosSiniestroUseCase);
  private readonly eliminarUC   = inject(EliminarGeneracionAsientosSiniestroUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly siniestros        = this.store.siniestros;
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
  cargarSiniestros(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setSiniestros(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los siniestros');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarSiniestro(item: GeneracionAsientosSiniestroEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el siniestro');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarSiniestro(item: GeneracionAsientosSiniestroEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el siniestro');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarSiniestro(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el siniestro');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
