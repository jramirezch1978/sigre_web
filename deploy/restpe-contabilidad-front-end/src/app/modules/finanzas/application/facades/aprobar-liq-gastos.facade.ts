import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { AprobarLiqGastosStore } from '../../store/aprobar-liq-gastos.store';
import { ObtenerAprobarLiqGastosUseCase } from '../usecases/obtener-aprobar-liq-gastos.usecase';
import { ActualizarAprobarLiqGastosUseCase } from '../usecases/actualizar-aprobar-liq-gastos.usecase';
import { LiqRendicionEntity } from '../../domain/models/liq-rendicion.entity';
import { IAprobarLiqGastosRepository, ValidacionCierre } from '../../domain/repositories/iaprobar-liq-gastos.repository';

@Injectable()
export class AprobarLiqGastosFacade {
  private readonly store = inject(AprobarLiqGastosStore);
  private readonly obtenerUC = inject(ObtenerAprobarLiqGastosUseCase);
  private readonly actualizarUC = inject(ActualizarAprobarLiqGastosUseCase);
  private readonly repo = inject(IAprobarLiqGastosRepository);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly liquidaciones = this.store.liquidaciones;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;
  readonly errorActualizar = this.store.errorActualizar;
  readonly actualizadoOk = this.store.actualizadoOk;
  readonly mensajeExito = this.store.mensajeExito;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDatos(): void {
    this.obtenerUC.execute();
  }

  actualizar(entity: LiqRendicionEntity, mensaje?: string): void {
    this.actualizarUC.execute(entity, mensaje);
  }

  /** Validación previa al cierre/aprobación (GET /{id}/validacion-cierre). */
  validarCierre(id: number): Observable<ValidacionCierre> {
    return this.repo.validarCierre(id);
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorActualizar(null);
  }

  limpiarExito(): void {
    this.store.setActualizadoOk(false);
    this.store.setMensajeExito(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
