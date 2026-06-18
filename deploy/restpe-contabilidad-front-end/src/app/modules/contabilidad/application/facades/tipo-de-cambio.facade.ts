import { Injectable, inject } from '@angular/core';
import { TipoDeCambioStore } from '../../store/tipo-de-cambio.store';
import { ObtenerTiposDeCambioUseCase } from '../usecases/obtener-tipos-de-cambio.usecase';
import { GuardarTipoDeCambioUseCase } from '../usecases/guardar-tipo-de-cambio.usecase';
import { ActualizarTipoDeCambioUseCase } from '../usecases/actualizar-tipo-de-cambio.usecase';
import { EliminarTipoDeCambioUseCase } from '../usecases/eliminar-tipo-de-cambio.usecase';
import { TipoDeCambioEntity } from '../../domain/models/tipo-de-cambio.entity';

@Injectable()
export class TipoDeCambioFacade {

  private readonly store = inject(TipoDeCambioStore);
  private readonly obtenerUC = inject(ObtenerTiposDeCambioUseCase);
  private readonly guardarUC = inject(GuardarTipoDeCambioUseCase);
  private readonly actualizarUC = inject(ActualizarTipoDeCambioUseCase);
  private readonly eliminarUC = inject(EliminarTipoDeCambioUseCase);

  // ── Selectores expuestos ─────────────────────────────────────────────────

  readonly items           = this.store.items;
  readonly loadingObtener  = this.store.loadingObtener;
  readonly loadingGuardar  = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly isLoading       = this.store.isLoading;
  readonly errorObtener    = this.store.errorObtener;
  readonly errorGuardar    = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly errorEliminar   = this.store.errorEliminar;
  readonly hasError        = this.store.hasError;
  readonly resultGuardar   = this.store.resultGuardar;
  readonly resultActualizar = this.store.resultActualizar;
  readonly resultEliminar  = this.store.resultEliminar;

  // ── Acciones ─────────────────────────────────────────────────────────────

  cargarItems(): void {
    this.store.setLoadingObtener(true);

    this.obtenerUC.execute().subscribe({
      next: items => {
        this.store.setItems(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener tipos de cambio');
      }
    });
  }

  guardarItem(item: TipoDeCambioEntity): void {
    this.store.setLoadingGuardar(true);

    this.guardarUC.execute(item).subscribe({
      next: result => {
        this.store.setGuardarResultado(result);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar tipo de cambio');
      }
    });
  }

  actualizarItem(item: TipoDeCambioEntity): void {
    this.store.setLoadingActualizar(true);

    this.actualizarUC.execute(item).subscribe({
      next: result => {
        this.store.setActualizarResultado(result);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar tipo de cambio');
      }
    });
  }

  eliminarItem(id: number): void {
    this.store.setLoadingEliminar(true);

    this.eliminarUC.execute(id).subscribe({
      next: result => {
        this.store.setEliminarResultado(result, id);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar tipo de cambio');
      }
    });
  }
}
