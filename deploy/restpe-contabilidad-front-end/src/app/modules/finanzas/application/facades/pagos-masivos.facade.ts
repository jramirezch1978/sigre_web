import { Injectable, inject } from '@angular/core';
import { PagosMasivosStore } from '../../store/pagos-masivos.store';
import { ObtenerPagosMasivosUseCase } from '../usecases/obtener-pagos-masivos.usecase';
import { ObtenerPagosMasivosDocumentosUseCase } from '../usecases/obtener-pagos-masivos-documentos.usecase';
import { GuardarPagosMasivosUseCase } from '../usecases/guardar-pagos-masivos.usecase';
import { PagosMasivosEntity } from '../../domain/models/pagos-masivos.entity';

@Injectable()
export class PagosMasivosFacade {
  private readonly store = inject(PagosMasivosStore);
  private readonly obtenerUC = inject(ObtenerPagosMasivosUseCase);
  private readonly obtenerDocumentosUC = inject(ObtenerPagosMasivosDocumentosUseCase);
  private readonly guardarUC = inject(GuardarPagosMasivosUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly registros = this.store.registros;
  readonly documentos = this.store.documentos;
  readonly isLoading = this.store.isLoading;
  readonly loadingDocumentos = this.store.loadingDocumentos;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorDocumentos = this.store.errorDocumentos;
  readonly guardadoOk = this.store.guardadoOk;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDatos(): void {
    this.obtenerUC.execute();
  }

  cargarDocumentos(): void {
    this.obtenerDocumentosUC.execute();
  }

  guardar(entity: PagosMasivosEntity): void {
    this.guardarUC.execute(entity);
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorGuardar(null);
    this.store.setErrorDocumentos(null);
  }

  limpiarExito(): void {
    this.store.setGuardadoOk(false);
  }

  resetState(): void {
    this.store.reset();
  }
}
