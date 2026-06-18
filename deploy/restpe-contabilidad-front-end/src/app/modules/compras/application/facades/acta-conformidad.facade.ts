import { Injectable, inject, signal } from '@angular/core';
import { catchError, finalize, of, tap } from 'rxjs';
import { IActaConformidadRepository } from '../../domain/repositories/iacta-conformidad.repository';
import {
  ActaConformidadEntity,
  OrdenServicioPendienteConformidadEntity,
} from '../../domain/models/acta-conformidad.entity';

/**
 * Facade de Actas de Conformidad de OS. Estado con signals + repositorio real.
 */
@Injectable()
export class ActaConformidadFacade {
  private readonly repo = inject(IActaConformidadRepository);

  readonly pendientes = signal<OrdenServicioPendienteConformidadEntity[]>([]);
  readonly actas = signal<ActaConformidadEntity[]>([]);
  readonly loading = signal<boolean>(false);
  readonly procesando = signal<boolean>(false);
  readonly error = signal<string | null>(null);
  readonly mensajeExito = signal<string | null>(null);

  cargarPendientes(): void {
    this.loading.set(true);
    this.repo
      .obtenerPendientes()
      .pipe(
        tap((p) => this.pendientes.set(p)),
        catchError((err) => {
          this.error.set(err?.message || 'Error al cargar OS pendientes de conformidad');
          return of([] as OrdenServicioPendienteConformidadEntity[]);
        }),
        finalize(() => this.loading.set(false))
      )
      .subscribe();
  }

  cargarActas(): void {
    this.loading.set(true);
    this.repo
      .obtenerActas()
      .pipe(
        tap((a) => this.actas.set(a)),
        catchError((err) => {
          this.error.set(err?.message || 'Error al cargar actas');
          return of([] as ActaConformidadEntity[]);
        }),
        finalize(() => this.loading.set(false))
      )
      .subscribe();
  }

  crearActa(acta: ActaConformidadEntity, onExito?: () => void): void {
    this.procesando.set(true);
    this.error.set(null);
    this.mensajeExito.set(null);
    this.repo
      .crear(acta)
      .pipe(
        tap((response) => {
          if (response.success) {
            this.mensajeExito.set(response.message);
            this.cargarPendientes();
            this.cargarActas();
            onExito?.();
          } else {
            this.error.set(response.message || 'No se pudo registrar el acta');
          }
        }),
        catchError((err) => {
          this.error.set(err?.message || 'Error al registrar el acta');
          return of(null);
        }),
        finalize(() => this.procesando.set(false))
      )
      .subscribe();
  }

  aprobarActa(id: string, onExito?: () => void): void {
    this.procesando.set(true);
    this.repo
      .aprobar(id)
      .pipe(
        tap((response) => {
          if (response.success) {
            this.mensajeExito.set(response.message);
            this.cargarActas();
            onExito?.();
          }
        }),
        catchError((err) => {
          this.error.set(err?.message || 'Error al aprobar el acta');
          return of(null);
        }),
        finalize(() => this.procesando.set(false))
      )
      .subscribe();
  }

  anularActa(id: string, onExito?: () => void): void {
    this.procesando.set(true);
    this.repo
      .anular(id)
      .pipe(
        tap((response) => {
          if (response.success) {
            this.mensajeExito.set(response.message);
            this.cargarActas();
            onExito?.();
          }
        }),
        catchError((err) => {
          this.error.set(err?.message || 'Error al anular el acta');
          return of(null);
        }),
        finalize(() => this.procesando.set(false))
      )
      .subscribe();
  }

  descargarPdf(id: string): void {
    this.repo
      .descargarPdf(id)
      .pipe(
        tap((blob) => {
          const url = window.URL.createObjectURL(blob);
          const a = document.createElement('a');
          a.href = url;
          a.download = `ACTA-${id}.pdf`;
          a.click();
          window.URL.revokeObjectURL(url);
        }),
        catchError((err) => {
          this.error.set(err?.message || 'No se pudo descargar el PDF');
          return of(null);
        })
      )
      .subscribe();
  }
}
