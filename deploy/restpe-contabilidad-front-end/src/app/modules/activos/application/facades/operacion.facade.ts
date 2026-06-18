import { Injectable, inject } from '@angular/core';
import { OperacionStore } from '../../store/operacion.store';
import { ObtenerOperacionUseCase } from '../usecases/obtener-operacion.usecase';
import { GuardarOperacionUseCase } from '../usecases/guardar-operacion.usecase';
import { ActualizarOperacionUseCase } from '../usecases/actualizar-operacion.usecase';
import { EliminarOperacionUseCase } from '../usecases/eliminar-operacion.usecase';
import { OperacionEntity } from '../../domain/models/operacion.entity';

@Injectable()
export class OperacionFacade {
  private readonly store        = inject(OperacionStore);
  private readonly obtenerUC    = inject(ObtenerOperacionUseCase);
  private readonly guardarUC    = inject(GuardarOperacionUseCase);
  private readonly actualizarUC = inject(ActualizarOperacionUseCase);
  private readonly eliminarUC   = inject(EliminarOperacionUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly operaciones      = this.store.operaciones;
  readonly isLoading        = this.store.isLoading;

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
  cargarOperaciones(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setOperaciones(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las operaciones');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarOperacion(operacion: OperacionEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(operacion).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar la operación');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarOperacion(operacion: OperacionEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(operacion).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar la operación');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarOperacion(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar la operación');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
