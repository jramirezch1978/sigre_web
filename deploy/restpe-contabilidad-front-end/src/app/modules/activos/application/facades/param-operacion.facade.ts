import { Injectable, inject } from '@angular/core';
import { ParamOperacionStore } from '../../store/param-operacion.store';
import { ObtenerParamOperacionUseCase } from '../usecases/obtener-param-operacion.usecase';
import { GuardarParamOperacionUseCase } from '../usecases/guardar-param-operacion.usecase';
import { ActualizarParamOperacionUseCase } from '../usecases/actualizar-param-operacion.usecase';
import { EliminarParamOperacionUseCase } from '../usecases/eliminar-param-operacion.usecase';
import { ParamOperacionEntity } from '../../domain/models/param-operacion.entity';

@Injectable()
export class ParamOperacionFacade {
  private readonly store        = inject(ParamOperacionStore);
  private readonly obtenerUC    = inject(ObtenerParamOperacionUseCase);
  private readonly guardarUC    = inject(GuardarParamOperacionUseCase);
  private readonly actualizarUC = inject(ActualizarParamOperacionUseCase);
  private readonly eliminarUC   = inject(EliminarParamOperacionUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly paramOperaciones     = this.store.paramOperaciones;
  readonly paramOperacionActual = this.store.paramOperacionActual;
  readonly isLoading            = this.store.isLoading;

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
  cargarParamOperaciones(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setParamOperaciones(items);
        // Cargar el registro activo (primer elemento = configuración actual)
        if (items.length > 0) {
          this.store.setParamOperacionActual(items[0]);
        }
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los parámetros de operaciones');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarParamOperacion(paramOperacion: ParamOperacionEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(paramOperacion).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar los parámetros de operaciones');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarParamOperacion(paramOperacion: ParamOperacionEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(paramOperacion).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar los parámetros de operaciones');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarParamOperacion(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar los parámetros de operaciones');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
