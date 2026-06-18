import { Injectable, inject } from '@angular/core';
import {
  ObtenerCondicionesPagoUseCase,
  GuardarCondicionPagoUseCase,
  ActualizarCondicionPagoUseCase,
  EliminarCondicionPagoUseCase
} from '../usecases';
import { CondicionPagoEntity } from '../../domain/models/condicion-pago.entity';
import { CondicionPagoStore } from '../../store/condicion-pago.store';

@Injectable()
export class CondicionPagoFacade {

  private readonly store = inject(CondicionPagoStore);

  private readonly obtenerUC = inject(ObtenerCondicionesPagoUseCase);
  private readonly guardarUC = inject(GuardarCondicionPagoUseCase);
  private readonly actualizarUC = inject(ActualizarCondicionPagoUseCase);
  private readonly eliminarUC = inject(EliminarCondicionPagoUseCase);

  // Selectores de condiciones de pago
  readonly condicionesPago = this.store.condicionesPago;
  readonly condicionSeleccionada = this.store.condicionSeleccionada;

  // Selectores de loading
  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly loadingActualizar = this.store.loadingActualizar;

  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;

  // Selectores de errores
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorEliminar = this.store.errorEliminar;
  readonly errorActualizar = this.store.errorActualizar;

  // Selectores de resultados
  readonly resultGuardar = this.store.resultGuardar;
  readonly resultEliminar = this.store.resultEliminar;
  readonly resultActualizar = this.store.resultActualizar;

  cargarCondicionesPago(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: (condiciones) => {
        this.store.setCondicionesPago(condiciones);
      },
      error: (err) => {
        this.store.setErrorObtener(err.message || 'Error al cargar condiciones de pago');
      },
      complete: () => {
        this.store.setLoadingObtener(false);
      }
    });
  }

  guardarCondicionPago(condicion: CondicionPagoEntity): void {
    this.store.setLoadingGuardar(true);

    this.guardarUC.execute(condicion).subscribe({
      next: (result) => {
        this.store.setGuardarResultado(result);
      },
      error: (err) => {
        this.store.setErrorGuardar(err.message || 'Error al guardar condición de pago');
      },
      complete: () => {
        this.store.setLoadingGuardar(false);
      }
    });
  }

  actualizarCondicionPago(condicion: CondicionPagoEntity): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC.execute(condicion).subscribe({
      next: (result) => {
        this.store.setActualizarResultado(result);
      },
      error: (err) => {
        this.store.setErrorActualizar(err.message || 'Error al actualizar condición de pago');
      },
      complete: () => {
        this.store.setLoadingActualizar(false);
      }
    });
  }

  eliminarCondicionPago(codigo: string): void {
    this.store.setLoadingEliminar(true);

    this.eliminarUC.execute(codigo).subscribe({
      next: (result) => {
        this.store.setEliminarResultado(result);
      },
      error: (err) => {
        this.store.setErrorEliminar(err.message || 'Error al eliminar condición de pago');
      },
      complete: () => {
        this.store.setLoadingEliminar(false);
      }
    });
  }

  seleccionarCondicionPago(condicion: CondicionPagoEntity | null): void {
    this.store.setCondicionSeleccionada(condicion);
  }

  resetErrors(): void {
    this.store.resetErrors();
  }

  resetResults(): void {
    this.store.resetResults();
  }
}
