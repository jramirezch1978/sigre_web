import { Injectable, inject } from '@angular/core';
import { RegistroUitStore } from '../../store/registro-uit.store';
import { ObtenerRegistrosUitUseCase } from '../usecases/obtener-registros-uit.usecase';
import { GuardarRegistroUitUseCase } from '../usecases/guardar-registro-uit.usecase';
import { ActualizarRegistroUitUseCase } from '../usecases/actualizar-registro-uit.usecase';
import { RegistroUitEntity } from '../../domain/models/registro-uit.entity';

/**
 * RegistroUitFacade — Capa de Aplicación.
 * Punto de entrada único para que los componentes interactúen con el feature.
 * Orquesta use cases y expone selectores del store como señales de solo lectura.
 */
@Injectable()
export class RegistroUitFacade {

  private readonly store      = inject(RegistroUitStore);
  private readonly obtenerUC  = inject(ObtenerRegistrosUitUseCase);
  private readonly guardarUC  = inject(GuardarRegistroUitUseCase);
  private readonly actualizarUC = inject(ActualizarRegistroUitUseCase);

  // ── Selectores expuestos ─────────────────────────────────────────────────

  readonly items             = this.store.items;
  readonly loadingObtener    = this.store.loadingObtener;
  readonly loadingGuardar    = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly isLoading         = this.store.isLoading;
  readonly errorObtener      = this.store.errorObtener;
  readonly errorGuardar      = this.store.errorGuardar;
  readonly errorActualizar   = this.store.errorActualizar;
  readonly hasError          = this.store.hasError;
  readonly resultGuardar     = this.store.resultGuardar;
  readonly resultActualizar  = this.store.resultActualizar;

  // ── Acciones ─────────────────────────────────────────────────────────────

  cargarItems(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: items => {
        this.store.setItems(items);
        this.store.setLoadingObtener(false);
      },
      error: err => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener registros UIT');
      }
    });
  }

  guardarItem(item: RegistroUitEntity): void {
    this.store.setLoadingGuardar(true);

    this.guardarUC.execute(item).subscribe({
      next: result => {
        this.store.setGuardarResultado(result);
      },
      error: err => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el registro UIT');
      }
    });
  }

  actualizarItem(item: RegistroUitEntity): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC.execute(item).subscribe({
      next: result => {
        this.store.setActualizarResultado(result);
      },
      error: err => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el registro UIT');
      }
    });
  }
}
