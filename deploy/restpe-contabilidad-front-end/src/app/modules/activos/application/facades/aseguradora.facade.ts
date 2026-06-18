import { Injectable, inject } from '@angular/core';
import { AseguradoraEntity } from '../../domain/models/aseguradora.entity';
import { AseguradoraStore } from '../../store/aseguradora.store';
import { ObtenerAseguradoresUseCase } from '../usecases/obtener-aseguradores.usecase';
import { GuardarAseguradoraUseCase } from '../usecases/guardar-aseguradora.usecase';
import { ActualizarAseguradoraUseCase } from '../usecases/actualizar-aseguradora.usecase';
import { EliminarAseguradoraUseCase } from '../usecases/eliminar-aseguradora.usecase';

/**
 * Facade de Aseguradoras.
 * Punto de entrada único para el componente: orquesta use cases y actualiza el store.
 */
@Injectable()
export class AseguradoraFacade {

  private readonly store = inject(AseguradoraStore);

  private readonly obtenerUC    = inject(ObtenerAseguradoresUseCase);
  private readonly guardarUC    = inject(GuardarAseguradoraUseCase);
  private readonly actualizarUC = inject(ActualizarAseguradoraUseCase);
  private readonly eliminarUC   = inject(EliminarAseguradoraUseCase);

  // ─────────── Selectores expuestos al componente ───────────
  readonly aseguradoras            = this.store.aseguradoras;
  readonly aseguradoraSeleccionada = this.store.aseguradoraSeleccionada;
  readonly isLoading               = this.store.isLoading;
  readonly loadingObtener          = this.store.loadingObtener;
  readonly loadingGuardar          = this.store.loadingGuardar;
  readonly loadingEliminar         = this.store.loadingEliminar;
  readonly loadingActualizar       = this.store.loadingActualizar;
  readonly errorObtener            = this.store.errorObtener;
  readonly errorGuardar            = this.store.errorGuardar;
  readonly errorEliminar           = this.store.errorEliminar;
  readonly errorActualizar         = this.store.errorActualizar;
  readonly resultGuardar           = this.store.resultGuardar;
  readonly resultEliminar          = this.store.resultEliminar;
  readonly resultActualizar        = this.store.resultActualizar;

  // ─────────── Acciones ───────────

  cargarAseguradoras(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (aseguradoras: AseguradoraEntity[]) => {
        this.store.setAseguradoras(aseguradoras);
        this.store.setLoadingObtener(false);
      },
      error: (err: Error) => {
        this.store.setErrorObtener(err.message ?? 'Error al cargar aseguradoras');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarAseguradora(aseguradora: AseguradoraEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(aseguradora).subscribe({
      next: (result) => {
        this.store.setResultGuardar(result);
        this.store.setLoadingGuardar(false);
      },
      error: (err: Error) => {
        this.store.setErrorGuardar(err.message ?? 'Error al guardar aseguradora');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarAseguradora(aseguradora: AseguradoraEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(aseguradora).subscribe({
      next: (result) => {
        this.store.setResultActualizar(result);
        this.store.setLoadingActualizar(false);
      },
      error: (err: Error) => {
        this.store.setErrorActualizar(err.message ?? 'Error al actualizar aseguradora');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarAseguradora(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (result) => {
        this.store.setResultEliminar(result);
        this.store.setLoadingEliminar(false);
      },
      error: (err: Error) => {
        this.store.setErrorEliminar(err.message ?? 'Error al eliminar aseguradora');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
