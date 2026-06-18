import { Injectable, inject } from '@angular/core';
import { DepreciacionAnualStore } from '../../store/depreciacion-anual.store';
import { ObtenerDepreciacionAnualUseCase } from '../usecases/obtener-depreciacion-anual.usecase';
import { GuardarDepreciacionAnualUseCase } from '../usecases/guardar-depreciacion-anual.usecase';
import { ActualizarDepreciacionAnualUseCase } from '../usecases/actualizar-depreciacion-anual.usecase';
import { EliminarDepreciacionAnualUseCase } from '../usecases/eliminar-depreciacion-anual.usecase';
import { DepreciacionAnualEntity } from '../../domain/models/depreciacion-anual.entity';

@Injectable()
export class DepreciacionAnualFacade {
  private readonly store        = inject(DepreciacionAnualStore);
  private readonly obtenerUC    = inject(ObtenerDepreciacionAnualUseCase);
  private readonly guardarUC    = inject(GuardarDepreciacionAnualUseCase);
  private readonly actualizarUC = inject(ActualizarDepreciacionAnualUseCase);
  private readonly eliminarUC   = inject(EliminarDepreciacionAnualUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly depreciaciones    = this.store.depreciaciones;
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
  cargarDepreciaciones(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setDepreciaciones(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las depreciaciones anuales');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarDepreciacion(item: DepreciacionAnualEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar la depreciación');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarDepreciacion(item: DepreciacionAnualEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar la depreciación');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarDepreciacion(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar la depreciación');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
