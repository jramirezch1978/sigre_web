import { Injectable, inject } from '@angular/core';
import { tap, catchError, finalize, of } from 'rxjs';
import { NotaCreditoStore } from '../../stores/nota-credito.store';
import { ObtenerNotasCreditoUseCase } from '../use-cases/nota-credito/obtener-notas-credito.usecase';
import { GuardarNotaCreditoUseCase } from '../use-cases/nota-credito/guardar-nota-credito.usecase';
import { ActualizarNotaCreditoUseCase } from '../use-cases/nota-credito/actualizar-nota-credito.usecase';
import { EliminarNotaCreditoUseCase } from '../use-cases/nota-credito/eliminar-nota-credito.usecase';
import { NotaCreditoEntity } from '../../domain/models/nota-credito.entity';

/**
 * Facade de Notas de Crédito/Débito - Application Layer
 * Simplifica el acceso del componente al store y los use cases
 */
@Injectable()
export class NotaCreditoFacade {
  private readonly store = inject(NotaCreditoStore);
  private readonly obtenerUseCase = inject(ObtenerNotasCreditoUseCase);
  private readonly guardarUseCase = inject(GuardarNotaCreditoUseCase);
  private readonly actualizarUseCase = inject(ActualizarNotaCreditoUseCase);
  private readonly eliminarUseCase = inject(EliminarNotaCreditoUseCase);

  // Señales del store expuestas al componente
  readonly notas = this.store.notas;
  readonly notaSeleccionada = this.store.notaSeleccionada;
  readonly isLoading = this.store.loading;
  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly errorEliminar = this.store.errorEliminar;

  cargarNotas(): void {
    this.store.setLoadingObtener(true);
    this.store.setErrorObtener(null);

    this.obtenerUseCase.execute().pipe(
      tap(notas => this.store.setNotas(notas)),
      catchError(err => {
        this.store.setErrorObtener(err.message || 'Error al cargar notas');
        return of([]);
      }),
      finalize(() => this.store.setLoadingObtener(false))
    ).subscribe();
  }

  guardarNota(nota: NotaCreditoEntity): void {
    this.store.setLoadingGuardar(true);
    this.store.setErrorGuardar(null);

    this.guardarUseCase.execute(nota).pipe(
      tap(response => {
        if (response.success && response.data) {
          this.store.agregarNota(response.data);
        }
      }),
      catchError(err => {
        this.store.setErrorGuardar(err.message || 'Error al guardar nota');
        return of(null);
      }),
      finalize(() => this.store.setLoadingGuardar(false))
    ).subscribe();
  }

  actualizarNota(nota: NotaCreditoEntity): void {
    this.store.setLoadingActualizar(true);
    this.store.setErrorActualizar(null);

    this.actualizarUseCase.execute(nota).pipe(
      tap(response => {
        if (response.success && response.data) {
          this.store.actualizarNotaEnStore(response.data);
        }
      }),
      catchError(err => {
        this.store.setErrorActualizar(err.message || 'Error al actualizar nota');
        return of(null);
      }),
      finalize(() => this.store.setLoadingActualizar(false))
    ).subscribe();
  }

  eliminarNota(codigo: string): void {
    this.store.setLoadingEliminar(true);
    this.store.setErrorEliminar(null);

    this.eliminarUseCase.execute(codigo).pipe(
      tap(response => {
        if (response.success) {
          this.store.eliminarNotaDelStore(codigo);
        }
      }),
      catchError(err => {
        this.store.setErrorEliminar(err.message || 'Error al eliminar nota');
        return of(null);
      }),
      finalize(() => this.store.setLoadingEliminar(false))
    ).subscribe();
  }

  seleccionarNota(nota: NotaCreditoEntity | null): void {
    this.store.setNotaSeleccionada(nota);
  }

  resetearEstado(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorGuardar(null);
    this.store.setErrorActualizar(null);
    this.store.setErrorEliminar(null);
  }
}
