import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { LiqRendicionStore } from '../../store/liq-rendicion.store';
import { ObtenerLiqRendicionUseCase } from '../usecases/obtener-liq-rendicion.usecase';
import { GuardarLiqRendicionUseCase } from '../usecases/guardar-liq-rendicion.usecase';
import { ActualizarLiqRendicionUseCase } from '../usecases/actualizar-liq-rendicion.usecase';
import { LiqRendicionEntity } from '../../domain/models/liq-rendicion.entity';
import { ILiqRendicionRepository, OpcionCatalogo } from '../../domain/repositories/iliq-rendicion.repository';

@Injectable()
export class LiqRendicionFacade {
  private readonly store = inject(LiqRendicionStore);
  private readonly obtenerUC = inject(ObtenerLiqRendicionUseCase);
  private readonly guardarUC = inject(GuardarLiqRendicionUseCase);
  private readonly actualizarUC = inject(ActualizarLiqRendicionUseCase);
  private readonly repo = inject(ILiqRendicionRepository);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly liquidaciones = this.store.liquidaciones;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly guardadoOk = this.store.guardadoOk;
  readonly actualizadoOk = this.store.actualizadoOk;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDatos(): void {
    this.obtenerUC.execute();
  }

  guardar(entity: LiqRendicionEntity, esEdicion: boolean): void {
    this.guardarUC.execute(entity, esEdicion);
  }

  actualizar(entity: LiqRendicionEntity): void {
    this.actualizarUC.execute(entity);
  }

  obtenerPorId(id: number): Observable<LiqRendicionEntity> {
    return this.repo.obtenerPorId(id);
  }

  anular(id: number): Observable<boolean> {
    return this.repo.anular(id);
  }

  listarSolicitudesAprobadas(): Observable<OpcionCatalogo[]> {
    return this.repo.listarSolicitudesAprobadas();
  }

  listarConceptos(): Observable<OpcionCatalogo[]> {
    return this.repo.listarConceptos();
  }

  listarCuentasPagar(): Observable<OpcionCatalogo[]> {
    return this.repo.listarCuentasPagar();
  }

  listarMonedas(): Observable<OpcionCatalogo[]> {
    return this.repo.listarMonedas();
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorGuardar(null);
    this.store.setErrorActualizar(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
