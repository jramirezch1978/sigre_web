import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { CerrarLiqAdelantosStore } from '../../store/cerrar-liq-adelantos.store';
import { ObtenerCerrarLiqAdelantosUseCase } from '../usecases/obtener-cerrar-liq-adelantos.usecase';
import { ActualizarCerrarLiqAdelantosUseCase } from '../usecases/actualizar-cerrar-liq-adelantos.usecase';
import { CerrarLiqAdelantosEntity } from '../../domain/models/cerrar-liq-adelantos.entity';
import { ICerrarLiqAdelantosRepository, ValidacionCierre, OpcionCatalogo } from '../../domain/repositories/icerrar-liq-adelantos.repository';

@Injectable()
export class CerrarLiqAdelantosFacade {
  private readonly store = inject(CerrarLiqAdelantosStore);
  private readonly obtenerUC = inject(ObtenerCerrarLiqAdelantosUseCase);
  private readonly actualizarUC = inject(ActualizarCerrarLiqAdelantosUseCase);
  private readonly repo = inject(ICerrarLiqAdelantosRepository);

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

  actualizar(entity: CerrarLiqAdelantosEntity, mensaje?: string): void {
    this.actualizarUC.execute(entity, mensaje);
  }

  /** Validación previa al cierre (GET /{id}/validacion-cierre). */
  validarCierre(id: number): Observable<ValidacionCierre> {
    return this.repo.validarCierre(id);
  }

  /** Catálogo de monedas para resolver el nombre por id en la tabla. */
  listarMonedas(): Observable<OpcionCatalogo[]> {
    return this.repo.listarMonedas();
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
