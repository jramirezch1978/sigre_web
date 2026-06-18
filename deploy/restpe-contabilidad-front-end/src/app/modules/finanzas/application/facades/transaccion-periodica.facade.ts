import { Injectable, inject } from '@angular/core';
import { TransaccionPeriodicaStore } from '../../store/transaccion-periodica.store';
import { ObtenerTransaccionPeriodicaUseCase } from '../usecases/obtener-transaccion-periodica.usecase';
import { GuardarTransaccionPeriodicaUseCase } from '../usecases/guardar-transaccion-periodica.usecase';
import { ActualizarTransaccionPeriodicaUseCase } from '../usecases/actualizar-transaccion-periodica.usecase';
import { TransaccionPeriodicaEntity } from '../../domain/models/transaccion-periodica.entity';

@Injectable()
export class TransaccionPeriodicaFacade {
  private readonly store = inject(TransaccionPeriodicaStore);
  private readonly obtenerUC = inject(ObtenerTransaccionPeriodicaUseCase);
  private readonly guardarUC = inject(GuardarTransaccionPeriodicaUseCase);
  private readonly actualizarUC = inject(ActualizarTransaccionPeriodicaUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly transacciones = this.store.transacciones;
  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly resultGuardar = this.store.resultGuardar;
  readonly resultActualizar = this.store.resultActualizar;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarTransacciones(): void {
    this.obtenerUC.execute();
  }

  guardarTransaccion(transaccion: Partial<TransaccionPeriodicaEntity>): void {
    this.guardarUC.execute(transaccion);
  }

  actualizarTransaccion(codigoProgramacion: string, cambios: Partial<TransaccionPeriodicaEntity>): void {
    this.actualizarUC.execute(codigoProgramacion, cambios);
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
