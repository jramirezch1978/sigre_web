import { Injectable, inject } from '@angular/core';
import { EjecucionPagoStore } from '../../store/ejecucion-pago.store';
import { ObtenerEjecucionPagoUseCase } from '../usecases/obtener-ejecucion-pago.usecase';
import { GuardarEjecucionPagoUseCase } from '../usecases/guardar-ejecucion-pago.usecase';
import { AnularEjecucionPagoUseCase } from '../usecases/anular-ejecucion-pago.usecase';
import { EjecucionPagoEntity } from '../../domain/models/ejecucion-pago.entity';

@Injectable()
export class EjecucionPagoFacade {
  private readonly store = inject(EjecucionPagoStore);
  private readonly obtenerUC = inject(ObtenerEjecucionPagoUseCase);
  private readonly guardarUC = inject(GuardarEjecucionPagoUseCase);
  private readonly anularUC = inject(AnularEjecucionPagoUseCase);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly pagos = this.store.pagos;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorAnular = this.store.errorAnular;
  readonly guardadoOk = this.store.guardadoOk;
  readonly anuladoOk = this.store.anuladoOk;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarPagos(): void {
    this.obtenerUC.execute();
  }

  guardar(entity: EjecucionPagoEntity): void {
    this.guardarUC.execute(entity);
  }

  anular(ep_codigo: string): void {
    this.anularUC.execute(ep_codigo);
  }

  limpiarExito(): void {
    this.store.setGuardadoOk(false);
    this.store.setAnuladoOk(false);
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorGuardar(null);
    this.store.setErrorAnular(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
