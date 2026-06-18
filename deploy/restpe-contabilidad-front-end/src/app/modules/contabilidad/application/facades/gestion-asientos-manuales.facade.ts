import { Injectable, inject } from '@angular/core';
import { GestionAsientosManualesStore } from '../../store/gestion-asientos-manuales.store';
import { AsientoManualItem } from '../../domain/models/gestion-asientos-manual.entity';
import { ObtenerGestionAsientosManualesUseCase } from '../usecases/obtener-gestion-asientos-manuales.usecase';
import { GuardarAsientoManualUseCase } from '../usecases/guardar-asiento-manual.usecase';
import { ActualizarAsientoManualUseCase } from '../usecases/actualizar-asiento-manual.usecase';
import { AnularAsientoManualUseCase } from '../usecases/anular-asiento-manual.usecase';

/**
 * GestionAsientosManualesFacade — Capa de Aplicación.
 * Punto de entrada único para los componentes de gestión de asientos manuales.
 * Orquesta los use cases y expone señales del store.
 */
@Injectable()
export class GestionAsientosManualesFacade {

  private readonly store = inject(GestionAsientosManualesStore);

  private readonly obtenerUC    = inject(ObtenerGestionAsientosManualesUseCase);
  private readonly guardarUC    = inject(GuardarAsientoManualUseCase);
  private readonly actualizarUC = inject(ActualizarAsientoManualUseCase);
  private readonly anularUC     = inject(AnularAsientoManualUseCase);

  // ── Selectores expuestos ─────────────────────────────────────────────────

  readonly asientos            = this.store.asientos;
  /** @deprecated Usar `asientos` */
  readonly items               = this.store.items;
  readonly asientoSeleccionado = this.store.asientoSeleccionado;

  readonly loadingObtener    = this.store.loadingObtener;
  readonly loadingGuardar    = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly loadingAnular     = this.store.loadingAnular;
  readonly isLoading         = this.store.isLoading;
  readonly hasError          = this.store.hasError;

  readonly errorObtener    = this.store.errorObtener;
  readonly errorGuardar    = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly errorAnular     = this.store.errorAnular;

  readonly resultGuardar    = this.store.resultGuardar;
  readonly resultActualizar = this.store.resultActualizar;
  readonly resultAnular     = this.store.resultAnular;

  // ── Métodos de orquestación ──────────────────────────────────────────────

  cargarDatos(): void {
    this.cargarItems();
  }

  cargarItems(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: asientos => {
        this.store.setAsientos(asientos);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los asientos manuales');
      }
    });
  }

  guardarAsiento(asiento: AsientoManualItem): void {
    this.store.setLoadingGuardar(true);

    this.guardarUC.execute(asiento).subscribe({
      next: result => {
        this.store.setGuardarResultado(result);
      },
      error: err => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el asiento manual');
      }
    });
  }

  actualizarAsiento(asiento: AsientoManualItem): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC.execute(asiento).subscribe({
      next: result => {
        this.store.setActualizarResultado(result);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el asiento manual');
      }
    });
  }

  anularAsiento(nroAsiento: string): void {
    this.store.setLoadingAnular(true);

    this.anularUC.execute(nroAsiento).subscribe({
      next: result => {
        this.store.setAnularResultado(result);
      },
      error: err => {
        this.store.setErrorAnular(err?.message ?? 'Error al inactivar el asiento manual');
      }
    });
  }

  seleccionarAsiento(asiento: AsientoManualItem | null): void {
    this.store.setAsientoSeleccionado(asiento);
  }

  limpiarErrores(): void {
    this.store.clearErrors();
  }
}

