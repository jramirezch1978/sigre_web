import { Injectable, inject, signal } from '@angular/core';
import { catchError, finalize, of, tap } from 'rxjs';
import { IDocumentoDirectoRepository } from '../../domain/repositories/idocumento-directo.repository';
import { DocumentoDirectoEntity } from '../../domain/models/documento-directo.entity';

/**
 * Facade de Documentos por Pagar Directo (DPD).
 * Maneja estado con signals y delega la persistencia al repositorio real.
 */
@Injectable()
export class DocumentoDirectoFacade {
  private readonly repo = inject(IDocumentoDirectoRepository);

  readonly documentos = signal<DocumentoDirectoEntity[]>([]);
  readonly loadingObtener = signal<boolean>(false);
  readonly loadingGuardar = signal<boolean>(false);
  readonly loadingAnular = signal<boolean>(false);
  readonly error = signal<string | null>(null);
  readonly mensajeExito = signal<string | null>(null);

  cargarDocumentos(): void {
    this.loadingObtener.set(true);
    this.error.set(null);
    this.repo
      .obtenerDocumentos()
      .pipe(
        tap((docs) => this.documentos.set(docs)),
        catchError((err) => {
          this.error.set(err?.message || 'Error al cargar documentos directos');
          return of([] as DocumentoDirectoEntity[]);
        }),
        finalize(() => this.loadingObtener.set(false))
      )
      .subscribe();
  }

  guardarDocumento(documento: DocumentoDirectoEntity, onExito?: () => void): void {
    this.loadingGuardar.set(true);
    this.error.set(null);
    this.mensajeExito.set(null);

    const esEdicion = !!(documento['id'] ?? (documento.dpd_codigo && documento.dpd_codigo !== ''));
    const operacion$ = esEdicion ? this.repo.actualizar(documento) : this.repo.guardar(documento);

    operacion$
      .pipe(
        tap((response) => {
          if (response.success) {
            this.mensajeExito.set(response.message);
            this.cargarDocumentos();
            onExito?.();
          } else {
            this.error.set(response.message || 'No se pudo guardar el documento directo');
          }
        }),
        catchError((err) => {
          this.error.set(err?.message || 'Error al guardar el documento directo');
          return of(null);
        }),
        finalize(() => this.loadingGuardar.set(false))
      )
      .subscribe();
  }

  anularDocumento(codigo: string, onExito?: () => void): void {
    this.loadingAnular.set(true);
    this.error.set(null);
    this.repo
      .anular(codigo)
      .pipe(
        tap((response) => {
          if (response.success) {
            this.mensajeExito.set(response.message);
            this.cargarDocumentos();
            onExito?.();
          } else {
            this.error.set(response.message || 'No se pudo anular el documento directo');
          }
        }),
        catchError((err) => {
          this.error.set(err?.message || 'Error al anular el documento directo');
          return of(null);
        }),
        finalize(() => this.loadingAnular.set(false))
      )
      .subscribe();
  }
}
