import { Injectable, inject } from '@angular/core';
import { CentroCostoStore } from '../../store/centro-costo.store';
import { CentroCostoEntity } from '../../domain/models/centro-costo.entity';
import {
  ObtenerCentrosCostoUseCase,
  GuardarCentroCostoUseCase,
  ActualizarCentroCostoUseCase,
  EliminarCentroCostoUseCase
} from '../usecases';

@Injectable()
export class CentroCostoFacade {

  private readonly store = inject(CentroCostoStore);

  private readonly obtenerUC = inject(ObtenerCentrosCostoUseCase);
  private readonly guardarUC = inject(GuardarCentroCostoUseCase);
  private readonly actualizarUC = inject(ActualizarCentroCostoUseCase);
  private readonly eliminarUC = inject(EliminarCentroCostoUseCase);

  // ── Selectores expuestos al componente ───────────────────────────────────

  readonly centrosCosto = this.store.centrosCosto;
  readonly centroCostoSeleccionado = this.store.centroCostoSeleccionado;

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

  cargarCentrosCosto(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: (centros) => {
        this.store.setCentrosCosto(centros);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message || 'Error al cargar centros de costo');
      },
      complete: () => {
        this.store.setLoadingObtener(false);
      }
    });
  }

  guardarCentroCosto(centro: CentroCostoEntity): void {
    this.store.setLoadingGuardar(true);

    this.guardarUC.execute(centro).subscribe({
      next: (result) => {
        this.store.setGuardarResultado(result);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message || 'Error al guardar centro de costo');
      },
      complete: () => {
        this.store.setLoadingGuardar(false);
      }
    });
  }

  actualizarCentroCosto(centro: CentroCostoEntity): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC.execute(centro).subscribe({
      next: (result) => {
        this.store.setActualizarResultado(result);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message || 'Error al actualizar centro de costo');
      },
      complete: () => {
        this.store.setLoadingActualizar(false);
      }
    });
  }

  eliminarCentroCosto(codigo: string): void {
    this.store.setLoadingEliminar(true);

    this.eliminarUC.execute(codigo).subscribe({
      next: (result) => {
        this.store.setEliminarResultado(result, codigo);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message || 'Error al eliminar centro de costo');
      },
      complete: () => {
        this.store.setLoadingEliminar(false);
      }
    });
  }

  seleccionarCentroCosto(centro: CentroCostoEntity | null): void {
    this.store.setCentroCostoSeleccionado(centro);
  }

  limpiarErrores(): void {
    this.store.clearErrors();
  }
}
