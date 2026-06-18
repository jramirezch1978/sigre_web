import { Injectable, inject } from '@angular/core';
import { UbicacionActivoStore } from '../../store/ubicacion-activo.store';
import { ObtenerUbicacionActivoUseCase } from '../usecases/obtener-ubicacion-activo.usecase';
import { GuardarUbicacionActivoUseCase } from '../usecases/guardar-ubicacion-activo.usecase';
import { ActualizarUbicacionActivoUseCase } from '../usecases/actualizar-ubicacion-activo.usecase';
import { EliminarUbicacionActivoUseCase } from '../usecases/eliminar-ubicacion-activo.usecase';
import { UbicacionActivoEntity } from '../../domain/models/ubicacion-activo.entity';

@Injectable()
export class UbicacionActivoFacade {
  private readonly store        = inject(UbicacionActivoStore);
  private readonly obtenerUC    = inject(ObtenerUbicacionActivoUseCase);
  private readonly guardarUC    = inject(GuardarUbicacionActivoUseCase);
  private readonly actualizarUC = inject(ActualizarUbicacionActivoUseCase);
  private readonly eliminarUC   = inject(EliminarUbicacionActivoUseCase);

  // ── Selectores expuestos ────────────────────────────────────────────────────
  readonly ubicaciones       = this.store.ubicaciones;
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
  cargarUbicaciones(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUC.execute().subscribe({
      next: (items) => {
        this.store.setUbicaciones(items);
        this.store.setLoadingObtener(false);
      },
      error: (err) => {
        this.store.setErrorObtener(err?.message ?? 'Error al obtener las ubicaciones');
        this.store.setLoadingObtener(false);
      },
    });
  }

  guardarUbicacion(ubicacion: UbicacionActivoEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setResultGuardar(null);
    this.store.setErrorGuardar(null);

    this.guardarUC.execute(ubicacion).subscribe({
      next: (res) => {
        this.store.setResultGuardar(res);
        this.store.setLoadingGuardar(false);
      },
      error: (err) => {
        this.store.setErrorGuardar(err?.message ?? 'Error al guardar la ubicación');
        this.store.setLoadingGuardar(false);
      },
    });
  }

  actualizarUbicacion(ubicacion: UbicacionActivoEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setResultActualizar(null);
    this.store.setErrorActualizar(null);

    this.actualizarUC.execute(ubicacion).subscribe({
      next: (res) => {
        this.store.setResultActualizar(res);
        this.store.setLoadingActualizar(false);
      },
      error: (err) => {
        this.store.setErrorActualizar(err?.message ?? 'Error al actualizar la ubicación');
        this.store.setLoadingActualizar(false);
      },
    });
  }

  eliminarUbicacion(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setResultEliminar(null);
    this.store.setErrorEliminar(null);

    this.eliminarUC.execute(codigo).subscribe({
      next: (res) => {
        this.store.setResultEliminar(res);
        this.store.setLoadingEliminar(false);
      },
      error: (err) => {
        this.store.setErrorEliminar(err?.message ?? 'Error al eliminar la ubicación');
        this.store.setLoadingEliminar(false);
      },
    });
  }
}
