import { Injectable, inject } from '@angular/core';
import { DetraccionStore } from '../../store/detraccion.store';
import { DetraccionEntity } from '../../domain/models/detraccion.entity';
import { ObtenerDetraccionesUseCase } from '../usecases/obtener-detracciones.usecase';
import { GuardarDetraccionUseCase } from '../usecases/guardar-detraccion.usecase';
import { ActualizarDetraccionUseCase } from '../usecases/actualizar-detraccion.usecase';
import { EliminarDetraccionUseCase } from '../usecases/eliminar-detraccion.usecase';

@Injectable()
export class DetraccionFacade {

  private readonly store = inject(DetraccionStore);

  private readonly obtenerUC = inject(ObtenerDetraccionesUseCase);
  private readonly guardarUC = inject(GuardarDetraccionUseCase);
  private readonly actualizarUC = inject(ActualizarDetraccionUseCase);
  private readonly eliminarUC = inject(EliminarDetraccionUseCase);

  // ── Selectores expuestos al componente ───────────────────────────────────

  readonly detracciones = this.store.detracciones;
  readonly detraccionSeleccionada = this.store.detraccionSeleccionada;

  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;

  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly errorEliminar = this.store.errorEliminar;

  readonly resultGuardar = this.store.resultGuardar;
  readonly resultActualizar = this.store.resultActualizar;
  readonly resultEliminar = this.store.resultEliminar;

  // ── Métodos de orquestación ──────────────────────────────────────────────

  cargarDetracciones(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: (detracciones) => {
        this.store.setDetracciones(detracciones);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message || 'Error al cargar las detracciones');
      },
      complete: () => {
        this.store.setLoadingObtener(false);
      }
    });
  }

  guardarDetraccion(detraccion: DetraccionEntity): void {
    this.store.setLoadingGuardar(true);

    this.guardarUC.execute(detraccion).subscribe({
      next: (result) => {
        this.store.setGuardarResultado(result);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message || 'Error al guardar la detracción');
      },
      complete: () => {
        this.store.setLoadingGuardar(false);
      }
    });
  }

  actualizarDetraccion(detraccion: DetraccionEntity): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC.execute(detraccion).subscribe({
      next: (result) => {
        this.store.setActualizarResultado(result);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message || 'Error al actualizar la detracción');
      },
      complete: () => {
        this.store.setLoadingActualizar(false);
      }
    });
  }

  eliminarDetraccion(codigo: string): void {
    this.store.setLoadingEliminar(true);

    this.eliminarUC.execute(codigo).subscribe({
      next: (result) => {
        this.store.setEliminarResultado(result, codigo);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message || 'Error al eliminar la detracción');
      },
      complete: () => {
        this.store.setLoadingEliminar(false);
      }
    });
  }

  seleccionarDetraccion(detraccion: DetraccionEntity | null): void {
    this.store.setDetraccionSeleccionada(detraccion);
  }

  limpiarErrores(): void {
    this.store.clearErrors();
  }
}
