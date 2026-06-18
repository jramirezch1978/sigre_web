import { Injectable, inject } from '@angular/core';
import { CalculoDepreciacionStore } from '../../store/calculo-depreciacion.store';
import { ObtenerCalculoDepreciacionUseCase } from '../usecases/obtener-calculo-depreciacion.usecase';
import { GuardarCalculoDepreciacionUseCase } from '../usecases/guardar-calculo-depreciacion.usecase';
import { ActualizarCalculoDepreciacionUseCase } from '../usecases/actualizar-calculo-depreciacion.usecase';
import { EliminarCalculoDepreciacionUseCase } from '../usecases/eliminar-calculo-depreciacion.usecase';
import { CalculoDepreciacionEntity } from '../../domain/models/calculo-depreciacion.entity';

@Injectable()
export class CalculoDepreciacionFacade {
  private readonly store        = inject(CalculoDepreciacionStore);
  private readonly obtenerUC    = inject(ObtenerCalculoDepreciacionUseCase);
  private readonly guardarUC    = inject(GuardarCalculoDepreciacionUseCase);
  private readonly actualizarUC = inject(ActualizarCalculoDepreciacionUseCase);
  private readonly eliminarUC   = inject(EliminarCalculoDepreciacionUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly calculos          = this.store.calculos;
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
  cargarCalculos(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setCalculos(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los cálculos de depreciación');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarCalculo(item: CalculoDepreciacionEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el cálculo de depreciación');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarCalculo(item: CalculoDepreciacionEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el cálculo de depreciación');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarCalculo(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el cálculo de depreciación');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
