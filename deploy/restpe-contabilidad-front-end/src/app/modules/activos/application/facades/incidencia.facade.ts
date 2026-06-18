import { Injectable, inject } from '@angular/core';
import { IncidenciaStore } from '../../store/incidencia.store';
import { ObtenerIncidenciasUseCase } from '../usecases/obtener-incidencias.usecase';
import { GuardarIncidenciaUseCase } from '../usecases/guardar-incidencia.usecase';
import { ActualizarIncidenciaUseCase } from '../usecases/actualizar-incidencia.usecase';
import { EliminarIncidenciaUseCase } from '../usecases/eliminar-incidencia.usecase';
import { IncidenciaEntity } from '../../domain/models/incidencia.entity';

/**
 * Facade de Incidencias.
 * Punto único de entrada para la UI; orquesta store + use cases.
 */
@Injectable()
export class IncidenciaFacade {
  private readonly store              = inject(IncidenciaStore);
  private readonly obtenerUC          = inject(ObtenerIncidenciasUseCase);
  private readonly guardarUC          = inject(GuardarIncidenciaUseCase);
  private readonly actualizarUC       = inject(ActualizarIncidenciaUseCase);
  private readonly eliminarUC         = inject(EliminarIncidenciaUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly incidencias          = this.store.incidencias;
  readonly isLoading            = this.store.isLoading;

  readonly loadingObtener       = this.store.loadingObtener;
  readonly loadingGuardar       = this.store.loadingGuardar;
  readonly loadingActualizar    = this.store.loadingActualizar;
  readonly loadingEliminar      = this.store.loadingEliminar;

  readonly errorGuardar         = this.store.errorGuardar;
  readonly errorActualizar      = this.store.errorActualizar;
  readonly errorEliminar        = this.store.errorEliminar;

  readonly resultGuardar        = this.store.resultGuardar;
  readonly resultActualizar     = this.store.resultActualizar;
  readonly resultEliminar       = this.store.resultEliminar;

  // ── Acciones ────────────────────────────────────────────────────────────────
  cargarIncidencias(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setIncidencias(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener incidencias');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarIncidencia(incidencia: IncidenciaEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(incidencia).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar incidencia');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarIncidencia(incidencia: IncidenciaEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(incidencia).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar incidencia');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarIncidencia(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar incidencia');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
