import { Injectable, inject } from '@angular/core';
import { AprobarGiroStore } from '../../store/aprobar-giro.store';
import { ObtenerAprobarGiroUseCase } from '../usecases/obtener-aprobar-giro.usecase';
import { ActualizarAprobarGiroUseCase } from '../usecases/actualizar-aprobar-giro.usecase';
import { AprobarGiroEntity } from '../../domain/models/aprobar-giro.entity';

@Injectable()
export class AprobarGiroFacade {
  private readonly store = inject(AprobarGiroStore);
  private readonly obtenerUC = inject(ObtenerAprobarGiroUseCase);
  private readonly actualizarUC = inject(ActualizarAprobarGiroUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly ordenes = this.store.ordenes;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;
  readonly errorActualizar = this.store.errorActualizar;
  readonly actualizadoOk = this.store.actualizadoOk;
  readonly mensajeExito = this.store.mensajeExito;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDatos(): void {
    this.obtenerUC.execute();
  }

  actualizar(entity: AprobarGiroEntity, mensaje?: string): void {
    this.actualizarUC.execute(entity, mensaje);
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
