import { Injectable } from '@angular/core';
import { CanjeReprogramacionStore } from '../../store/canje-reprogramacion.store';
import { ObtenerCanjeReprogramacionUseCase } from '../usecases/obtener-canje-reprogramacion.usecase';
import { AplicarCanjeUseCase } from '../usecases/aplicar-canje.usecase';
import { ReprogramarVencimientoUseCase } from '../usecases/reprogramar-vencimiento.usecase';

@Injectable()
export class CanjeReprogramacionFacade {
  // Selectores
  readonly registros = this.store.registros;
  readonly isLoading = this.store.isLoading;
  readonly hasError = this.store.hasError;
  readonly errorObtener = this.store.errorObtener;
  readonly errorCanje = this.store.errorCanje;
  readonly errorReprogramar = this.store.errorReprogramar;
  readonly resultCanje = this.store.resultCanje;
  readonly resultReprogramar = this.store.resultReprogramar;

  constructor(
    private store: CanjeReprogramacionStore,
    private obtenerUseCase: ObtenerCanjeReprogramacionUseCase,
    private aplicarCanjeUseCase: AplicarCanjeUseCase,
    private reprogramarUseCase: ReprogramarVencimientoUseCase,
  ) {}

  cargarRegistros(): void {
    this.obtenerUseCase.execute();
  }

  aplicarCanje(nroDocumento: string): void {
    this.aplicarCanjeUseCase.execute(nroDocumento);
  }

  reprogramarVencimiento(nroDocumento: string, nuevaFechaVencimiento: string): void {
    this.reprogramarUseCase.execute(nroDocumento, nuevaFechaVencimiento);
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorCanje(null);
    this.store.setErrorReprogramar(null);
  }

  resetState(): void {
    this.store.resetState();
  }
}
