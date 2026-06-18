import { Injectable, inject } from '@angular/core';
import { GeneracionDevengoAseguradoresStore } from '../../store/generacion-devengo-aseguradores.store';
import { ObtenerGeneracionDevengoAseguradoresUseCase } from '../usecases/obtener-generacion-devengo-aseguradores.usecase';
import { GuardarGeneracionDevengoAseguradoresUseCase } from '../usecases/guardar-generacion-devengo-aseguradores.usecase';
import { ActualizarGeneracionDevengoAseguradoresUseCase } from '../usecases/actualizar-generacion-devengo-aseguradores.usecase';
import { EliminarGeneracionDevengoAseguradoresUseCase } from '../usecases/eliminar-generacion-devengo-aseguradores.usecase';
import { GeneracionDevengoAseguradoresEntity } from '../../domain/models/generacion-devengo-aseguradores.entity';

@Injectable()
export class GeneracionDevengoAseguradoresFacade {
  private readonly store        = inject(GeneracionDevengoAseguradoresStore);
  private readonly obtenerUC    = inject(ObtenerGeneracionDevengoAseguradoresUseCase);
  private readonly guardarUC    = inject(GuardarGeneracionDevengoAseguradoresUseCase);
  private readonly actualizarUC = inject(ActualizarGeneracionDevengoAseguradoresUseCase);
  private readonly eliminarUC   = inject(EliminarGeneracionDevengoAseguradoresUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly devengoItems      = this.store.devengoItems;
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
  cargarDevengo(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setDevengoItems(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener el devengo de aseguradores');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarItem(item: GeneracionDevengoAseguradoresEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(item).subscribe({
      next: (res) => {
        // Agregar el nuevo ítem al final del store (el componente hace .reverse())
        const current = this.store.devengoItems();
        this.store.setDevengoItems([...current, item]);
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el devengo');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarItem(item: GeneracionDevengoAseguradoresEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(item).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el devengo');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarItem(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el devengo');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
