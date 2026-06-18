import { Injectable, inject } from '@angular/core';
import { SeguroStore } from '../../store/seguro.store';
import { ObtenerSeguroUseCase } from '../usecases/obtener-seguro.usecase';
import { GuardarSeguroUseCase } from '../usecases/guardar-seguro.usecase';
import { ActualizarSeguroUseCase } from '../usecases/actualizar-seguro.usecase';
import { EliminarSeguroUseCase } from '../usecases/eliminar-seguro.usecase';
import { SeguroEntity } from '../../domain/models/seguro.entity';

@Injectable()
export class SeguroFacade {
  private readonly store        = inject(SeguroStore);
  private readonly obtenerUC    = inject(ObtenerSeguroUseCase);
  private readonly guardarUC    = inject(GuardarSeguroUseCase);
  private readonly actualizarUC = inject(ActualizarSeguroUseCase);
  private readonly eliminarUC   = inject(EliminarSeguroUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly seguros           = this.store.seguros;
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
  cargarSeguros(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setSeguros(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener los tipos de seguro');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarSeguro(seguro: SeguroEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(seguro).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar el tipo de seguro');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarSeguro(seguro: SeguroEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(seguro).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar el tipo de seguro');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarSeguro(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar el tipo de seguro');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
