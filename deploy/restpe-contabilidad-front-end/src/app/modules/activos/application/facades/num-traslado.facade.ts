import { Injectable, inject } from '@angular/core';
import { NumTrasladoStore } from '../../store/num-traslado.store';
import { ObtenerNumTrasladoUseCase } from '../usecases/obtener-num-traslado.usecase';
import { GuardarNumTrasladoUseCase } from '../usecases/guardar-num-traslado.usecase';
import { ActualizarNumTrasladoUseCase } from '../usecases/actualizar-num-traslado.usecase';
import { EliminarNumTrasladoUseCase } from '../usecases/eliminar-num-traslado.usecase';
import { NumTrasladoEntity } from '../../domain/models/num-traslado.entity';

@Injectable()
export class NumTrasladoFacade {
  private readonly store        = inject(NumTrasladoStore);
  private readonly obtenerUC    = inject(ObtenerNumTrasladoUseCase);
  private readonly guardarUC    = inject(GuardarNumTrasladoUseCase);
  private readonly actualizarUC = inject(ActualizarNumTrasladoUseCase);
  private readonly eliminarUC   = inject(EliminarNumTrasladoUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly numTraslados      = this.store.numTraslados;
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
  cargarNumTraslados(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setNumTraslados(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los numeradores de traslados');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarNumTraslado(numTraslado: NumTrasladoEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(numTraslado).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el numerador de traslado');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarNumTraslado(numTraslado: NumTrasladoEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(numTraslado).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el numerador de traslado');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarNumTraslado(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el numerador de traslado');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
